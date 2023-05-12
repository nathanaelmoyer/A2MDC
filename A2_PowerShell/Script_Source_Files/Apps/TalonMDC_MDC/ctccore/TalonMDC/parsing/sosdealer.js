/*
Parse SOS dealer lookup messages
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


if (keepParsing) HandleDealerLookup();



/*
A SOS 2569 82 07/06/06 0026 CORESERV.
MI1234200
13;61D114.
FOR:r/a
OPR:o
02/28/2007  DEALER

Clemont Chevy Inc
1148 W 18th St
Sometown 41412
MI SOS
*/
function HandleDealerLookup()
{
	if ( content.indexOf( "DEALER" ) != -1 )
	{
		var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
		if ( idx != -1 )
		{		
			var lines = STRUTIL.GetLines(content.substring(idx) );
			var parts = STRUTIL.Split( lines[0], " " );
			
			if ( jxtools.IsDate( parts[0] ) && lines[0].indexOf("DEALER") != -1 )
			{				
				//TODO: How to mark up a dealer?
				
				var address = Extract2LineAddr( lines[2], lines[3], null );				
				
				parsedItems.add(address);
				keepParsing = false;
			}
		}
	}
}










