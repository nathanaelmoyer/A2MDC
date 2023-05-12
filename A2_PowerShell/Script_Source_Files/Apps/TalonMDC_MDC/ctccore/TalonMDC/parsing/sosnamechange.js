/*
Parse SOS name change record
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


if (keepParsing) HandleNameChange();



/*
A SOS 3274 90 07/06/06 0032 CORESERV.
MI1215700
35;1;T111165564364.
FOR:R/A
OPR:O

PREV NAME: CHORON LADDE HEOBATH   DOB: 01/11/1951
CURRENT RECORD: CHORON LADDE ISHERTH   DOB: 01/11/1951  H-210-165-514-364

MI SOS

*/
function HandleNameChange()
{
	var paragraph = ptools.ExtractRestOfParagraph(content, "PREV NAME:", 0 );
	if ( paragraph != null )
	{
		var valueMap = ptools.DecodeMultiWordKeyToMap( paragraph, ":" );
		
		var name = valueMap.get( "CURRENT RECORD" );
		var dobAndOLN = valueMap.get( "DOB" );
		
		//This.DebugTrace( "\nName: " + name + "\nDOB/OLN: " + dobAndOLN + "\n" + UTIL12.GetMapContents( valueMap, "Map", MC ) );
		
		if ( name != null && dobAndOLN != null )
		{
			var person = jxtools.CreatePersonInfo(MC);
			if ( ExtractReadableName( name, person ) )
			{
				var splitdobOLN = STRUTIL.Split( dobAndOLN, " " );
				person.SetBirthDate( splitdobOLN[0] );
				person.SetOLN( splitdobOLN[1], "MI", false );
				
				
				parsedItems.add(person);					
				keepParsing = false;
			}
		}
	}
}










