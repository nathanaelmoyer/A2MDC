/*
	Parse a SOS Vehicle Response.
*/

if (keepParsing) HandleVehicleResponse();


function HandleVehicleResponse()
{
/*
	example
*/

	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;
	
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length <= 3 )
		return;
	
	//Find Unique SOS code
	
	if (! p1Lines[3].startsWith( "66;" )  && ! p1Lines[2].startsWith( "66;" ) )
		return;


	var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
	if ( idx != -1 )
	{
		var paragraph = content.substring(idx);
		var lines = STRUTIL.GetLines( paragraph );

		//get the person info
		var person = jxtools.CreatePersonInfo(MC);
		//line 0  OLN, ID type, expires, birthday, sex
		//D-123-456-789-0      R-PERSONAL ID  2010  07/03/1927   F
		//M-123-456-789-0    *PID EXPIRED*   O-PERSONAL ID  2004  02/09/1983   F


		OLNstrs = SplitIn2AndTrim( lines[0], "   " );
		if ( OLNstrs[1] != null )
		{
			person.SetOLN( OLNstrs[0], "MI", false );
			var nameline = stools.TokenizeLine( OLNstrs[1], 1 );
			if ( nameline.length > 4 )
			{
				//The optional "*PID EXPIRED*" changes the indexes.  Get from the end.
				last = nameline.length - 1;
				//person.SetOLNExpirationYear(nameline[last-2]);  -no such parameter yet
				person.SetBirthDate(nameline[last-1]);
				person.SexText = nameline[last];
			}

			//Line 1  Name, streetnumber, street
			streetstrs = SplitIn2AndTrim( lines[1], "   " );
			
			if ( ExtractReadableName( streetstrs[0], person ) )
			{
				//Add this person to our list of parsed items
				parsedItems.add(person);
				
				//line 2
				adrstrs = SplitIn2AndTrim( lines[2], "  " );
				//need to break this up better with the jtxtools.IsZip
				var line2 = stools.TokenizeLine( adrstrs[0], 1 );
				
				if ( line2.length > 0 )
				{
					statepos=0;
					//need to find out which section is the state. Only checking first 4 sections for now
					if ( jxtools.IsState(line2[3]) ) //check 3rd item first
						statepos = 2;
					else if ( jxtools.IsState(line2[2]) )
						statepos = 1;
				}

				var address = Extract1LineAddr( streetstrs[1] , person );
				citytext = line2[0] ;

				//MC.Trace( "statepos=" + statepos );  
				if ( statepos > 0)
					citytext = citytext + " " + line2[1] ;
				if ( statepos > 1)
					citytext = citytext + " " + line2[2] ;

				address.City = citytext;
				if (jxtools.IsZip(line2[2+ statepos]) )
					address.PostalCode = line2[2+ statepos];
				if (jxtools.IsState(line2[1+ statepos]))
					address.State = line2[1+ statepos];

				//line 3 height, weight, eyecolor, image
				//HGT: 5 FT  7 IN    WGT: 190    EYE COLOR: BRO         IMAGE

				//May not always be line 3.  Sometimes there is a MAIL: line or two.

				var map = ptools.DecodeToMap( paragraph, ":" );
				
				person.SetHeight( map.get( "HGT" ) );
				
				var weight = map.get( "WGT" );
				//weight will be "190    EYE ".  Remove any extra stuff after the weight.
				split = SplitIn2AndTrim( weight, " " )
				person.Weight = split[0];

				var color = map.get( "COLOR" );
				//color will be "BRO         IMAGE".  Remove any extra stuff after the color code.
				split = SplitIn2AndTrim( color, " " )
				person.EyeColorText = split[0];

				keepParsing = false;
			}
		}
	}
}


