/*
Parse LEIN criminal history responses
		

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


if (keepParsing) HandleCriminalHistory();




function HandleCriminalHistory()
{

	var dataIdx = ptools.AdvanceToParagraphAfter( content, "CRIMINAL HISTORY RECORD RESPONSES ARE DEPENDENT", 0, 3 );
	if ( dataIdx != -1 )
	{
		//This.DebugTrace( "Processing LEIN crim history report." );
		
		var dataParagraph = ptools.ExtractParagraph( content, dataIdx );
		if ( STRUTIL.IsStringSet( dataParagraph ) )
		{
			var valueMap = ptools.DecodeToMap( dataParagraph, ":" );
			
			//This.DebugTrace( "Map:\n" + UTIL12.GetMapContents( valueMap, "Map content", MC ) );
			
			var name = valueMap.get( "NAM" );
			
			if ( STRUTIL.IsStringSet(name) )
			{
				var person = jxtools.CreatePersonInfo(MC);

				ProcessName( name, person );
				ProcessOLN( valueMap, person );
				person.StateID = valueMap.get( "SID" );

				person.RaceText = valueMap.get("RAC");
				person.SexText = valueMap.get("SEX");				
				person.SetBirthDate( valueMap.get("DOB") );
				person.FBIID = valueMap.get( "FBI" );

				person.SetHeight( valueMap.get("HGT") );
				person.Weight = valueMap.get("WGT");
				person.HairColorText = valueMap.get("HAI");

				person.EyeColorText = valueMap.get("EYE");

				person.SSN = valueMap.get( "SOC" );
				
				parsedItems.add(person);
				
			}
			else
			{
				This.Trace( "(" + scriptFileName + "): Failed to get name from crim. hist report." );
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










