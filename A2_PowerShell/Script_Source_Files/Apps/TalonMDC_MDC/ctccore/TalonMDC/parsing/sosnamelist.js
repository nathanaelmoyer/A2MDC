/*
Parse SOS name listing
7/6/6

Registered Beans:
ptools - ParsingTools
xtools - XMLTOOLS
jxtools - JXMLTools
stools - SCRIPTTOOLS
message - TDMessage
results - ParseResults
query - TDQuery
content - String
STRUTIL - STRUTIL
Engine - TalonEngine
This - LEINMessageParser
*/


if (keepParsing) HandleNameList(); // from a 49 query or 69 query
if (keepParsing) HandleInqComplete(); //from a 15 query



/*
A SOS 10088 246 07/06/06 0126 CORESERV.
MI2612600
49;NAM:A DRIVER;SEX:F;S:P;YOB:1978-1988.
D-111-222-333-444 DRIVER ANNE CARR 05071983 HARRISON
TOTAL: 1 HIT
MI SOS

*/
function HandleNameList()
{
	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;
	
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length <= 3 )
		return;

	if ( p1Lines[3].startsWith( "69;" )  ||  p1Lines[3].startsWith( "49;" ) )
		startidx = 4;
	else if (  p1Lines[2].startsWith( "69;" ) ||  p1Lines[2].startsWith( "49;" ) )
		startidx = 3;
	else
		return;

	var paragraph = ptools.ExtractRestOfParagraph(content, ";", 0 );
	if ( paragraph != null )
	{
		var lines = STRUTIL.GetLines( paragraph );
		for( var i=0; i < lines.length; i++ )
		{
			var parts = STRUTIL.Split( lines[i], " " );

			if ( jxtools.IsOLN( parts[0] ) )
			{
				var person = jxtools.CreatePersonInfo(MC);
				
				person.SetOLN( parts[0], "MI", false );
				
				//if the last item in the row isn't the date, it should be the city
				/* 
				sometimes the last item isn't the city, it's "PREV NAME"
				skipping this for now
				if ( ! jxtools.IsDate(parts[parts.length-1]) )
				{
					var address = jxtools.CreateResidence(MC);
					address.City =parts[parts.length-1];
					person.AddSubNode(address)
				}*/
				
				var nameSearch = true;
				var name = parts[1];
				for( var j=2; j < parts.length; j++ )
				{
					if ( nameSearch )
					{
						var part = parts[j];
						if ( jxtools.IsDate( part ) )
						{
							// the format of this name is  LAST FIRST MIDDLE
							ExtractReverseName( name, person );
							person.SetBirthDate( part );
							
							nameSearch = false;
							parsedItems.add(person);
							
						}
						else
						{
							name = name + " " + part;
						}
						
					}
					
				}
				
			}
			
		}
		
		keepParsing = false;
	}
		
}

/*
A SOS 58435 13253 04/30/07 1510 CLEMISCOMP3.
MI630043N
INQ COMPLETE    
DRIVER ANNE CARR            114 HICKORY LN     *SN*  HE7001
DRIVER ANNE CARR            114 HICKORY LN     *SN*  HE7058
DRIVER ANNE CARR            114 HICKORY LN      *PC*  KRE812
DRIVER ANNE CARR            114 HICKORY LN     *WC*  0875KZ
DRIVER ANNE CARR            114 HICKORY LN     *VIN  JS1SF44A4R2101037
DRIVER ANNE CARR            114 HICKORY LN     *MC*  VY105  
*/

function HandleInqComplete() //SOS 15
{

	if ( content.indexOf( "INQ COMPLETE") != -1 )
	{
		var paragraph = ptools.ExtractRestOfParagraph(content, "INQ COMPLETE", 0 );
		
		if ( paragraph != null )
		{
			keepParsing = false;
			
			var lines = STRUTIL.GetLines( paragraph );
			//start at line 1 because line 0 includes the "INQ COMPLETE"
			for( var i=1; i < lines.length; i++ )
			{
			
				var parts = SplitIn2AndTrim( lines[i], "  " );
				var person = jxtools.CreatePersonInfo(MC);
				var address = jxtools.CreateResidence(MC);
		
					// the format of this name is  LAST FIRST MIDDLE
					ExtractReverseName( parts[0], person );
					parsedItems.add(person);
					
					if ( parts[1] != null )
						var adrstr = SplitIn2AndTrim( parts[1], "  " );
					if (adrstr[0] != null)
					{
						person.AddSubNode(address);
						Extract2LineAddr( adrstr[0]," ", person );
					}
					
					//followed by 4 char field starting with "*" - seen *SN*, *WC*,  *PC*,  *MC*,  *CO*,  *VIN
					//Then the corresponding number
					//This is not being parsed anwhere yet.
					
			}
			
		}
		
	}

}










