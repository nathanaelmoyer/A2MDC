/*
	Parse a SOS Vehicle Response.
*/

if (keepParsing) HandleResponse();


function HandleResponse()
{

	lines = STRUTIL.GetLines( content );
	if ( lines.length <= 3 )
		return;
	
	//Find Unique SOS code
	if (! lines[3].startsWith( "78;" )  && ! lines[2].startsWith( "78;" ) )
		return;


	//var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );

	//Find the name and DOB Line.
	var nameIndex = -1;
	for ( var i = 3; i < lines.length; i++ )
	{
		if ( lines[i].indexOf( "DOB:" ) >= 0 )
		{
			nameIndex = i;
			break;
		}
	}

	if ( nameIndex >= 0 )
	{		
		//get the person info
		var person = jxtools.CreatePersonInfo(MC);

		var nameLine = SplitIn2AndTrim( lines[nameIndex], "DOB:" );

		if ( nameLine[1] != null )
		{
			person.SetBirthDate( nameLine[1] );
		}

		if ( ExtractReadableName( nameLine[0], person )  )
		{
			//Extract Address Line.
			Extract1LineAddr( lines[nameIndex+1], person );

			//Add this person to our list of parsed items
			parsedItems.add(person);
			keepParsing = false;
		}
	}
}


