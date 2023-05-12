/*
Parse ccw responses
		

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


if (keepParsing) HandleCCW();




function HandleCCW()
{

	var dataIdx = ptools.AdvanceToParagraphAfter( content, "EXCEPT FOR PURPOSES OF ACT 381", 0, 3 );
	if ( dataIdx != -1 )
	{
		This.DebugTrace( "Processing CCW report." );
		
		var dataParagraph = ptools.ExtractParagraph( content, dataIdx );
		if ( STRUTIL.IsStringSet( dataParagraph ) )
		{
			var valueMap = ptools.DecodeToMap( dataParagraph, ":" );

			This.DebugTrace( "Map:\n" + UTIL12.GetMapContents( valueMap, "Map content", MC ) );

			var name = valueMap.get( "NAM" );
			if ( STRUTIL.IsStringSet(name) )
			{
				var person = jxtools.CreatePersonInfo(MC);

				var nameParts = ltools.ExtractNameParts( name );
				person.SurName = nameParts[0];
				person.GivenName = nameParts[1];
				person.MiddleName = nameParts[2];

				person.SetBirthDate( valueMap.get("DOB") );				

				person.RaceText = valueMap.get("RACE");
				person.SexText = valueMap.get("SEX");
				person.SetHeight( valueMap.get("HGT") );
				person.Weight = valueMap.get("WGT");
				person.HairColorText = valueMap.get("HAI");
				person.EyeColorText = valueMap.get("EYE");
				
				person.SetOLN( valueMap.get("OLN"), "MI", false );
				person.SSN = valueMap.get( "SOC" );

				var addr = valueMap.get( "ADD" );
				if ( addr != null )
				{
					var address = jxtools.CreateResidence(MC);
					
					ExtractFullAddress( addr, address );
					
					person.AddSubNode( address );
				}

				parsedItems.add(person);
			}
			else
			{
				This.TraceError( "Failed to get name from crim. hist report." );
			}
		}

		This.DebugTrace( "Crim hist: Setting keep parsing false" );
		keepParsing = false;
	}
}


function ProcessOLN( valueMap, person )
{
	var dln = valueMap.get("DLN");
	if ( STRUTIL.IsStringSet( dln ) )
	{
		var parts = STRUTIL.Split( dln, "/" );
		
		person.SetOLN( parts[1], parts[0], false );
	}
}










