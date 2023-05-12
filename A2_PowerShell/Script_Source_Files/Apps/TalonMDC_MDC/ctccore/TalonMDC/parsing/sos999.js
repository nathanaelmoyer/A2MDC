/*
Parse SOS messages
		

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



if (keepParsing) HandleTitleInfo();
if (keepParsing) LookForViolationsReport();




function HandleTitleInfo()
{
	if ( content.indexOf( "** NO TITLE INFORMATION ON COMPUTER **" != -1 ) )
		return;


	var idx = ptools.AdvanceToParagraphAfter( content, "TITLE INFORMATION:", 0, 3 );
	
	if ( idx != -1 )
	{		
		var paragraph = ptools.ExtractParagraph( content, idx );
		This.DebugTrace( "Found paragraph after TITLE INFORMATION (" + idx + ")\n" + paragraph );
		
		
		
		var lines = STRUTIL.GetLines(paragraph);	
		var lineCount = lines.length;
			
		if ( lineCount >= 3 )
		{	
			var primaryPerson;
			
			var personLines = lineCount - 2;			
			for ( var i=0; i < personLines; i++ )
			{
				var person = jxtools.CreatePersonInfo(MC);
							
				if ( ExtractReadableName( lines[i], person ) )
				{
					This.DebugTrace( "After name:\n" + person);					
					
					if ( primaryPerson == null )
						primaryPerson = person;
				
					parsedItems.add(person);
					
					keepParsing = false;
				}
			}
			
			if ( primaryPerson != null )
				Extract2LineAddr( lines[lineCount-2], lines[lineCount-1], primaryPerson );
			else
				This.Trace( "Primary person not set.  Cannot place address." );
			
		}
		
	}
	else
	{
		This.DebugTrace( "Did not find TITLE INFORMATION:" );
	}
	
}





function LookForViolationsReport()
{
	var paragraph = ptools.ExtractRestOfParagraph( content, "OPR:", 0 );
	if ( STRUTIL.IsStringSet( paragraph ) )
	{
		//MC.Trace( ">>> paragraph:\n" + paragraph + "\n<<< End paragraph" );
		var lines = STRUTIL.GetLines(paragraph);
		var lineCount = lines.length;
		
		if ( lineCount == 1 )
		{
			var idx = ptools.AdvanceToParagraphAfter( content, "OPR:", 0, 3 );
			if ( idx != -1 )			
			{
				var oprLine = paragraph;
				
				paragraph = ptools.ExtractParagraph( content, idx );
				if ( STRUTIL.IsStringSet( paragraph ) )
				{
					paragraph = oprLine + "\n" + paragraph; //Make it look like expected
					lines = STRUTIL.GetLines(paragraph);
					lineCount = lines.length;
				}
			}
		}

		This.DebugTrace( "Found OPR: paragraph:\n" + paragraph );

		if ( lineCount > 4 )
		{
			//First part of line[1] is OLN
			var oln = STRUTIL.Split( lines[1], " " )[0]; 
			
			if ( jxtools.IsOLN( oln ) )
			{
				//Line[2] is Name, DOB, Sex, Height, Weight, Eye, IMAGE
				var line2 = stools.TokenizeLine( lines[2], 1 );
				
				if ( line2.length > 0 )
				{
					var person = jxtools.CreatePersonInfo(MC);
				
					//Set the OLN now that we have a person object
					person.SetOLN( oln , "MI", false ); //Hack my examples never give a state?
					
					//If we can  extract a name info, we will count this as a 'hit'
					if ( ViolationsReport_SetNameLine( line2, person ) )
					{
						/*
						To extract the address from
						623 S EVIEW DR               C-OPER-CYCLE  03/02/2005  2010
						split on double space "  " to find the big break in the row,
						assume the first item in that array is the address
						*/
						var line3 = STRUTIL.Split( lines[3], "  " );
						var address = ViolationsReport_SetAddressLine( line3, person );
						var addressLine2Index = 4;
						if ( address == null )
						{
							MC.Trace( "line 3 address is null." );
							//Sometimes line 2 was longer the 80 characters and was wrapped.  Making line3 a non-valid address.
							//Check if line4 is a calid the address.
							if ( lineCount > 5 )
							{
								var line3 = STRUTIL.Split( lines[4], "  " );
								address = ViolationsReport_SetAddressLine( line3, person );
								MC.Trace( "line 4 address=" + address );
								addressLine2Index = 5;
							}
						}

						MC.Trace( "address=" + address );
						//Check if we could not parse the address at all.
						if ( address != null )
						{
							var line4 = STRUTIL.Split( lines[addressLine2Index], " " ); //One space this time
							ViolationsReport_SetAddressLine2( line4, address );
						    
							//Add this person to our list of parsed items
							parsedItems.add(person);
							
							keepParsing = false;
						}
					}
				}
			}
		}
	}
}

/*
Tries to get the address from a line like this:
604 N RIDVIEW DR             C-OPER-CYCLE  05/09/2006  2010

where the line has been split on a "  " sep (big space)
*/
function ViolationsReport_SetAddressLine( lineParts, person )
{
	if ( lineParts.length > 1 ) 
	{
		var address = jxtools.CreateResidence(MC);
	
		ExtractStreetAddress( lineParts[0], address );
		
		person.AddSubNode( address );
		return address;
	}
	else
	{
		MC.Trace( "ViolationsReport_SetAddressLine() Invalid format.  num parts=" + lineParts.length + " lineParts[0]=" + lineParts[0]  );
	}
}

/*
Tries to get the city, state & zip from a line like this:
FENTON MI  48430-1404   CORRECTIVE LENS
*/
function ViolationsReport_SetAddressLine2( lineParts, address )
{
	if ( lineParts.length > 2 )
	{
		var citySearch = true;
		var zipSearch = true;
		
		var city = lineParts[0];
		var part;

		for ( var i=1; i < lineParts.length; i++ )
		{		
			part = lineParts[i].trim();
			
			MC.Trace( "  part: " + part );
			if ( part.length() > 0 )
			{
				if ( citySearch )
				{
					if ( jxtools.IsState( part ) )
					{					
						address.City = city;
						address.State = part;
						citySearch = false;
						MC.Trace( "  found State: " + part );
					}
					else
					{
						city = city + " " + part;
						MC.Trace( "  city=: " + city );
					}
				}
				else if ( zipSearch )
				{
					if ( jxtools.IsZip( part ) )
					{
						address.PostalCode = part;
						zipSearch = false;
						MC.Trace( "  found Zip: " + part );
					}
				}
			}//end if part is long enough
		}//end for
	} //end if more than 2 parts
}



/*
*/
function ViolationsReport_SetNameLine( lineParts, person )
{
	var parsed = false;
	
	This.DebugCall( "SetNameLine: (" + lineParts.length + ") parts" );
	
	var nameSearch = true;
	var sexSearch = true;
	var heightSearch = true;
	var weightSearch = true;
	var eyeColorSearch = true;
	
	var name = lineParts[0];					
	var part = name;
	
	for ( var i=1; i < lineParts.length; i++ )
	{
		part = lineParts[i];
		
		This.DebugTrace( "Handling part: " + part );
		
		if ( nameSearch )
		{
			if ( jxtools.IsDate( part ) )
			{
				parsed = true;
				nameSearch = false;
				person.SetBirthDate(part);
				
				ExtractReadableName( name, person );
			}
			else
			{
				name = name + " " + part;
			}
		}
		else if ( sexSearch )
		{
			sexSearch = false;
			person.SexText = part;
		}
		else if ( heightSearch )
		{
			heightSearch = false;
			person.SetHeight( part );
		}
		else if ( weightSearch )
		{
			weightSearch = false;
			person.Weight = part;
		}
		else if ( eyeColorSearch )
		{
			eyeColorSearch = false;
			person.EyeColorText = part;
		}
		
	}
	
	return parsed;
}
















