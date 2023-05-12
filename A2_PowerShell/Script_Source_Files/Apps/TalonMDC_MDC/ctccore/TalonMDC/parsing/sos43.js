/*
	Parse a SOS Vehicle Response.
*/

if (keepParsing) HandleVehicleResponse();


function HandleVehicleResponse()
{
/*
	/AXROKA2T63222
	A SOS 63222 11764 04/30/07 0927 CLEMISCOMP3.
	MI630043N
	43;2;ANNE CARR DRIVER;112062.
	FOR:BUTLERG/CLEMIS
	OPR:BUTLERG
	D-616-067-108-888
	ANNE CARR DRIVER             11/20/1962  F  5-03  130  BRO  IMAGE
	
	10/11/2005  DETROIT          09/16/2005 SPEED  70/55 -LATE RECD ABST    
					-AA                               3 T0202  
	01/20/2006  ANN ARBOR 14A    01/01/2006 CMV FAILED TO STOP AT    
					RAILROAD CROSSING -CV             2 T0945  


	MI SOS
*/

	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;
	
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length <= 3 )
		return;
	
	//Find Unique SOS code
	
	if (! p1Lines[3].startsWith( "43;" )  && ! p1Lines[2].startsWith( "43;" ) )
		return;


	var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
	if ( idx != -1 )
	{		
		var lines = STRUTIL.GetLines(content.substring(idx) );
		
		//get the person info
		var person = jxtools.CreatePersonInfo(MC);
		
		person.SetOLN( lines[0], "MI", false );

		var nameline = stools.TokenizeLine( lines[1], 1 );
		if (SetNameLine( nameline, person ) )
		{
			//Add this person to our list of parsed items
			parsedItems.add(person);
			keepParsing = false;
		}
	}
}


