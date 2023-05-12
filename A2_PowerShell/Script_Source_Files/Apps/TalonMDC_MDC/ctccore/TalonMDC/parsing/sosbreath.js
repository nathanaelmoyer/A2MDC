/*
Parse SOS breath related messages
		

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


if (keepParsing) HandleBreathPosted();



/*
A SOS 3018 130 07/05/06 0026 CORESERV.
MI2624200
MI2624200
RE: MI/M650758866401             MOAN SAMEL WAE                    05/18/1963SEQ NO: 001414278  OCA: B-216-06   INST NO: 930120    

(BREATH) PERMIT POSTED

MICHIGAN RECORD FOUND

OLN:    M651758866401               
NAME:   SAMEL WAE MOAN                        DOB: 05/18/1963
STREET: 1017 LEELY RD                         SEX: 1
CITY:   BEAERTON           STATE: MI  ZIP: 48412    
MI SOS
*/
function HandleBreathPosted()
{
  
   var idx = content.indexOf( "(BREATH) PERMIT POSTED" );
   if ( idx != -1 )
   {		
	idx = ptools.AdvanceToParagraphAfter( content, "RECORD FOUND", idx, 2 );
	if ( idx != -1 )
	{
		var paragraph = content.substring(idx);
					
		var valueMap = ptools.DecodeToMap( paragraph, ":" );
					
		var person = jxtools.CreatePersonInfo(MC);
		if ( ExtractReadableName( valueMap.get("NAME"), person ) )
		{
			var state = valueMap.get( "STATE" );
			
			person.SetBirthDate( valueMap.get("DOB") );
			person.SetOLN( valueMap.get( "OLN" ), state, false );
			
			var address = jxtools.CreateResidence(MC);
			
			ExtractStreetAddress( valueMap.get( "STREET" ), address );
			
			address.City = valueMap.get("CITY");
			address.State = state;
			address.PostalCode = valueMap.get("ZIP");
			
			person.AddSubNode(address);

			parsedItems.add(person);					
			keepParsing = false;
		}
	}
	else
		This.DebugTrace( "Could not find paragraph after record found." );
   }
}










