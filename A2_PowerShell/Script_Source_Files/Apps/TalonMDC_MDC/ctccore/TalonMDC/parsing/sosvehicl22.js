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
	
	if ( p1Lines[3].startsWith( "22;" )  )
		platestrs = SplitIn2AndTrim( p1Lines[3], ";" );
	else if (  p1Lines[2].startsWith( "22;" ) )
		platestrs = SplitIn2AndTrim( p1Lines[2], ";" );
	else 
		return;
		
	//need to remove any periods from the plate string
	platestrs[1] = STRUTIL.ReplaceAll( platestrs[1], ".", "" );
	//sometimes the vin line has extra codes and a second semicolon. need to remove all that to get the VIN at the end
	breakloc = platestrs[1].indexOf( ";" );
	if ( breakloc != -1 )
		platestrs[1] = ( platestrs[1].substring( breakloc + 1 ));
	

	var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
	if ( idx != -1 )
	{		
		var lines = STRUTIL.GetLines(content.substring(idx) );
		var parts = STRUTIL.Split( lines[0], "  " );
		
		var curVehicle = jxtools.CreateVehicleInfo(MC);
		curVehicle.SetVIN( platestrs[1] );  
		parsedItems.add(curVehicle);
		
		curVehicle.SetStyleCode( "WC" );	//22 is always a watercraft
		curVehicle.SetMakeCode( "WC" );	//22 is always a watercraft

		//get the vehicle info from line 0
		vehicleinfo = SplitIn2AndTrim( lines[0], " " );
			curVehicle.SetModelYearDate( vehicleinfo[0] );
			modelinfo = SplitIn2AndTrim( vehicleinfo[1], "  " );
				curVehicle.SetModelCode( modelinfo[0] );
				curVehicle.SetModelCodeText( modelinfo[1] );  //not sure what to do with this.
		//line 1 contains the date of entry
			var parts = stools.TokenizeLine( lines[1], 1 );
			var num = parts.length;
			if ( num == 4 )
			{
				if ( jxtools.IsDate( parts[2] )  )
					curVehicle.SetRegistrationEffectiveDate( parts[2] );
			}


		
		//get the person info from second paragraph
		var person = jxtools.CreatePersonInfo(MC);
		if ( ExtractReadableName( lines[2], person ) )
		{
			//person.SetOLN( personstrs[1], "MI", false );
			parsedItems.add(person);					
		//get the address from line 2
		var address = Extract1LineAddr( lines[3] + "  " + lines[4], person );
		}
		keepParsing = false;
	}

}

