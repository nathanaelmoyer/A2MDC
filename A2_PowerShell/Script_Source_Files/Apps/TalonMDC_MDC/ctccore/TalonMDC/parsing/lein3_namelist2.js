/*
Parse LEIN name list responses
		

Registered Beans:
ptools - ParsingTools
ltools - LEINParsingTools
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


if (keepParsing) HandleNameList();




function HandleNameList()
{

	var line = ptools.ExtractWholeLine( content, "TYPE   CHRG", false );
	if ( STRUTIL.IsStringSet( line ) && line.indexOf( "SYSIDNO" ) != -1 ) 
	{
		var restOfMessage = content.substring( content.indexOf( "TYPE   CHRG" ) );
		var lines = STRUTIL.GetLines( restOfMessage );
		
		var curPerson;
		var firstLine = true;
		
		for( var i=1; i < lines.length; i++ )
		{
			var line = lines[i];
			//LAW var parts = STRUTIL.Split( line, " " );
			//This will also remove extra spaces.
			var parts = STRUTIL.ListToArray( line, ' ' );

			if ( firstLine )
			{
				var nameParts = ltools.ExtractNameParts( parts[0] );

				if ( nameParts != null )
				{
					firstLine = false;
					curPerson = jxtools.CreatePersonInfo(MC);
					
					curPerson.SurName = nameParts[0];
					curPerson.GivenName = nameParts[1];
					curPerson.MiddleName = nameParts[2];
					
					
					curPerson.SexText = parts[1];
					
					curPerson.SetBirthDate( parts[2] );
				}
			}
			else
			{				
				var address = jxtools.CreateResidence(MC);

/*LAW replaced with below
				address.StreetNumberText = parts[0];
				
				for( var j=parts.length-1; j >= 1; j-- )
				{
					var part = parts[j];					
					
					if ( ltools.IsORI( part ) )
					{
						address.City = parts[j-1];
						
						var street = parts[1];
						for( var k=2; k < j-1; k++ )
						{
							street = street + " " + parts[k];
						}
						
						address.StreetName = street;
						
						break;
					}
				}
*/

				for( var j=parts.length-1; j >= 1; j-- )
				{
					var part = parts[j];					
					
					if ( ltools.IsORI( part ) )
					{
						//Every thing before the ORI is the Address.
						index = line.indexOf ( part );
						if ( index >= 0 )
						{
							ExtractFullAddress( line.substring( 0, index ), address );
						}
						break;
					}
				}

				curPerson.AddSubNode( address );
				
				firstLine = true;
				
				parsedItems.add(curPerson);
			}
			
		}
		
		This.DebugTrace( "Name List 2: Setting keep parsing false" );
		keepParsing = false;	
		
	}
}
