/*
Parse LEIN person responses
		

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


if (keepParsing) HandleNameResponse();




function HandleNameResponse()
{
  
	var reLine = ptools.ExtractLineAfter( content, "RE:", false, true );
	if ( reLine != null )
	{
		var nameQuery = ltools.ExtractName( reLine );
		if ( nameQuery != null && content.indexOf( "NAM:") != -1 )
		{			
			var curIdx = content.indexOf( "OPR:" );			
						
			while( curIdx > 0 )
			{
				curIdx = content.indexOf( "NAM:", curIdx+1 );
				
				if ( curIdx != -1 )
				{
					ExtractPersonInfo( curIdx );
				}
			}

			This.DebugTrace( "Name query: Setting keep parsing false" );
			keepParsing = false;
		}
	}
}




function ExtractPersonInfo( curIdx )
{
	var paragraph = ptools.ExtractParagraph( content, curIdx );

	if ( paragraph != null )
	{		
		This.DebugTrace( "Extracting person info from:\n" + paragraph + "\n" );

		var map = ptools.DecodeToMap( paragraph, ":" );

		This.DebugTrace( "Map:\n" + UTIL12.GetMapContents( map, "Map content", MC ) );

		var namValue = map.get( "NAM" );

		var nameParts = ltools.ExtractNameParts( namValue );
		if ( nameParts != null )
		{
			var person = jxtools.CreatePersonInfo(MC);

			person.SurName = nameParts[0];
			person.GivenName = nameParts[1];
			person.MiddleName = nameParts[2];			
			
			person.SetBirthDate( map.get( "DOB" ) );
			
			person.SetHeight( map.get( "HGT" ) );
			person.Weight = map.get( "WGT" );
			
			person.EyeColorText = map.get( "EYE" );
			person.HairColorText = map.get( "HAI" );
			
			SetSexAndRace( map, person );

			//Get OLN Info
			oln = map.get( "OLN" );
			ols = map.get( "OLS" );
			if ( oln != null )
			{
				if ( ols == null )
					ols = GetDefaultStateAbbr();
				person.SetOLN( oln, ols, jxtools.IsStateAbbreviated( ols ) );
			}
			
			person.FBIID = map.get( "FBI" );
			person.StateID = map.get( "SID" );

			var addr = map.get( "ADD" );
			if ( addr != null )
			{
				var address = jxtools.CreateResidence(MC);

				//Saw this once:
				//ADD:508 FROST STREET  CTY:FLINT  STA:MI  ZIP:48504  
				city = map.get( "CTY" );
				if ( city == null )
					ExtractFullAddress( addr, address );
				else
				{
					ExtractStreetAddress( addr, address );
					address.City = city;
					address.State = map.get( "STA" );
					address.PostalCode = map.get( "ZIP" );
				}
				//MC.Trace( "Adding Address:\n" + address.toJXML().ShowTree() );  //LAW DBG

				person.AddSubNode( address );
			}
			
			var map2 = ptools.DecodeToMap( content, ":" );
			This.DebugTrace( "Map2:\n" + UTIL12.GetMapContents( map2, "Map content", MC ) );

			var SYSIDValue = map2.get( "SYSIDNO" );

			if ( SYSIDValue != null )
			{
			person.SYSID = SYSIDValue;
			}
			
			
			//Check for ENTERED LEIN:
			//May not be in the NAM: paragraph
			index = ptools.AdvancePast( content, "ENTERED LEIN:", curIdx );
			if ( index > 0 )
			{
				person.SetRecordEntryDate( ptools.ExtractToChar( content, ' ', index ) );
			}

			parsedItems.add(person);			
		}
		else
		{
			This.DebugTrace( "No name extracted." );
		}
		
	}
	
}
	
	
function SetSexAndRace( map, person )
{
	var race = map.get( "RAC" );
	var sex = map.get( "SEX" );

	//The sex may come back like this:   WHITE SEX: MALE
	//The DecodeToMap() method will store the "WHITE" under the key "BEFORE-SEX"
	
	if ( race == null )
	{
		race = map.get( "BEFORE-SEX" );

		if ( race == null && sex != null )
		{
			var parts = STRUTIL.Split( sex, " " );
			
			if ( parts.length == 2 )
			{
				race = parts[0];
				sex = parts[1];			
			}
		}
	}
	
	person.RaceText = race;		
	person.SexText = sex;
}	
