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

	var dataParagraph = ptools.ExtractParagraph( content, "RECORDS MAY NOT MATCH EXACTLY THE NAME", 0 );
	if ( STRUTIL.IsStringSet( dataParagraph ) )
	{
		This.DebugTrace( "Processing LEIN name list from:\n" + dataParagraph );

		if ( ! ExtractUsingColumnPosition( dataParagraph ) )
		{
			This.DebugTrace( "Not in column mode." );

			var lines = STRUTIL.GetLines( dataParagraph, false );
			
			for( var i=1; i < lines.length; i++ )
			{
				var line = lines[i];
				This.DebugTrace( "Processing line: " + line );
			
				if ( ! line.startsWith( "  " ) )
				{
					//var parts = STRUTIL.Split( line, " " );
					//I want the multiple spaces to be removed, not treated as a blank item.
					var parts = STRUTIL.ListToArray( line, " " );

					if ( parts[0] != null && parts[1] != null) 
					{				
						var len = parts[0].length() + parts[1].length() + 1;
	This.Trace( "Testing...  Len: (" + len + ")." );
						var max = 30;
						if ( len >= max )
						{
							This.Trace( "AMBCUR Name line only has run together parts.  Len: (" + len + ").  Will split first part: " + parts[1] );

							var part1Len = parts[1].length();
							var newLine = parts[0] + " " + parts[1].substring(0,part1Len - 1 );
							newLine += " " + parts[1].substring(part1Len-1);
						
							for( var j=2; j < parts.length; j++ )
							{
								newLine += " " + parts[j];
							}

							This.Trace( "Re-created line to create a space: " + newLine );

							parts = STRUTIL.ListToArray( newLine, " " );
						}
					}

					if ( parts.length > 7 )
					{				
						var person = jxtools.CreatePersonInfo(MC);
						
						var findName = true;
						var name = parts[0];
						var curIdx = 1;
						
						while( findName && curIdx < parts.length )
						{
						This.DebugTrace( "Testing part: " + parts[curIdx] );
							if ( jxtools.IsRace( parts[curIdx] ) && jxtools.IsSex( parts[curIdx+1] ) )
							{
								findName = false;
							}
							else
							{
								name = name + " " + parts[curIdx];
								curIdx++;
							}
						}

						if ( ProcessName( name, person ) )
						{					
							person.RaceText = parts[curIdx++];
							person.SexText = parts[curIdx++];
							person.SetBirthDate( parts[curIdx++] );
							person.SetHeight( parts[curIdx++] );
							//MC.Trace( "HairColorText: " + parts[curIdx] );  //LAW DBG
							person.HairColorText = parts[curIdx++];
							person.EyeColorText = parts[curIdx++];
							person.StateID = parts[curIdx++];

							parsedItems.add(person);

						}
					}
				}
			}
		}

		This.DebugTrace( "Name list 1: Setting keep parsing false" );
		keepParsing = false;		
	}
}
  
/*
	Check if the items are in the standard Column format.
	Some fields are optional.
	
                                                                     MATCHED ON
                                                                     |D|S|M|P|N|
                                                                     |L|O|N|R|A|
NAME ON FILE                 R/S DOB        HGT  HAI  EYE  SID       |N|C|U|N|M|
---------------              --- ---------- ---  ---  ---  ----      -----------
LAST,FIRST MIDDLE            W M 10/07/1972 602            2181197A           *
^                            ^ ^ ^          ^    ^    ^    ^         ^
|                            | | |          |    |    |    |         |
0                            | | 33         44   49   54   59        69
                             | 31
                             29                                 

*/
function ExtractUsingColumnPosition( content )
{
	//This.DebugTrace( "ExtractUsingColumnPosition()" );

	//var dataParagraph = ptools.ExtractRestOfParagraph( content, "NAME ON FILE                 R/S DOB        HGT  HAI  EYE  SID", 0 );
	var dataParagraph = ptools.ExtractRestOfParagraph( content, "NAME ON FILE", 0 );
	//MC.Trace( "dataParagraph is:", dataParagraph );
	if ( STRUTIL.IsStringSet( dataParagraph ) )
	{
		var lines = STRUTIL.GetLines( dataParagraph, false );
		//This.DebugTrace( "lines length is: " + lines.length + "  Line 1 is: " + lines[1] );
		if ( lines.length >= 2 && lines[1].startsWith( "---------------" ) )
		{
			This.DebugTrace( "Using Column Mode." );
		
			for( var i=2; i < lines.length; i++ )
			{
				if ( lines[i].length() >= 60 )
				{
					var person = jxtools.CreatePersonInfo(MC);

					name = GetSubString( lines[i], 0, 29 )
					if ( ProcessName( name, person ) )
					{
						This.DebugTrace( "Name is: " + name );
						person.RaceText = GetSubString( lines[i], 29, 30 );
						person.SexText = GetSubString( lines[i], 31, 32 );
						
						person.SetBirthDate( GetSubString( lines[i], 33, 43 ) );
						person.SetHeight( GetSubString( lines[i], 44, 48 ) );
						person.HairColorText = GetSubString( lines[i], 49, 53 );
						person.EyeColorText = GetSubString( lines[i], 54, 58 );
						person.StateID = GetSubString( lines[i], 59, 69 );

						parsedItems.add(person);
					}
					else
					{
						This.DebugTrace( "Not a valid name: " + name );
					}
				}
				else
				{
					This.DebugTrace( "Line too short. len= " + lines[i].length() + "  " + lines[i] );
				}
			}
		}

		return true;
	}

	return false;
}

/*
	String GetSubString( String str, int startIndex, int endIndex )
	
	Get the substring and trim it.
*/
function GetSubString( str, startIndex, endIndex )
{
	if ( endIndex > str.length )
		endIndex = str.length;

	sub = str.substring( startIndex, endIndex );
	return sub.trim();
}