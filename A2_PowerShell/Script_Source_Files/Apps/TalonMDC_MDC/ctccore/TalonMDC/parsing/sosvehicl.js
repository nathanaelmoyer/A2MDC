/*
	Parse a SOS Vehicle Response.
*/

if (keepParsing) HandleVehicleResponse();


function HandleVehicleResponse()
{
	//TODO - What is the unique Tag?


	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;
	
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length <= 6 )
		return;
	
	//Are these unique enough?
	dataLineIndex = 5;
	if ( p1Lines[2].startsWith( "56;" ) )
		dataLineIndex = 6;
	else if ( ! p1Lines[2].startsWith( "52;" ) )
		return;

	//if ( ! p1Lines[3].startsWith( "FOR:" ) )
	//	return;
	
	//if ( ! p1Lines[4].startsWith( "OPR:" ) )
	//	return;
	
	//p1Lines[5] is like "1986 OLDSMOBILE   AAAAA11111SPC         12 FOUR DOOR    M CORR       "
	//TODO - Is this fixed positional?
	
	//Split it at multiple spaces.
	//p1Lines[5] is like "1986 OLDSMOBILE   AAAAA11111SPC         12 FOUR DOOR    M CORR       "
	//                                   ^^
	strs = SplitIn2AndTrim( p1Lines[dataLineIndex], "  " );
	yearMake = strs[0];
	vin = null;
	style = null;  //Init to null.  If it gets set we found all the items.
	if ( strs[1] != null )
	{
	//strs[1] is like "AAAAA11111SPC         12 FOUR DOOR    M CORR       "
	//Splitting here           -----^^
		strs = SplitIn2AndTrim( strs[1], "  " );
		vin = strs[0];
		if ( strs[1] != null )
		{
		//strs[1] is like "12 FOUR DOOR    M CORR       "
		//Splitting here          -----^^
			strs = SplitIn2AndTrim( strs[1], "  " );
			style = strs[0];
		}
	}

	//If this last item found then the line fit the pattern.
	if ( style != null )
	{
		curVehicle = jxtools.CreateVehicleInfo(MC);
		//yearMake is like "1986 OLDSMOBILE"
		strs = STRUTIL.SplitIn2( yearMake, " " );
		curVehicle.SetModelYearDate( strs[0] );
		curVehicle.SetMakeCode( strs[1] );
		
		curVehicle.SetVIN( vin );
		
		//style is like "12 FOUR DOOR"
		//Drop the first word.  TODO - What is the 12 and is it always there and one word?
		strs = STRUTIL.SplitIn2( style, " " );
		if ( strs[1] != null )
			curVehicle.SetStyleCode( strs[1] );
		else
		{
			This.DebugTrace( "Style not formatted as expected: " + style );
			//What to do?
			//Using the whole thing (which is only one word).
			curVehicle.SetStyleCode( style );
		}

		parsedItems.add(curVehicle);
		keepParsing = false;		
	}
}
