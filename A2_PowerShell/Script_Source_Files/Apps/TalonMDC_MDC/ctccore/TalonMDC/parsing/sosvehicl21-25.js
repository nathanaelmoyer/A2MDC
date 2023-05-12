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
	
	if ( p1Lines[3].startsWith( "21;" )  ||  p1Lines[3].startsWith( "25;" ) )
		platestrs = SplitIn2AndTrim( p1Lines[3], ";" );
	else if (  p1Lines[2].startsWith( "21;" ) ||  p1Lines[2].startsWith( "25;" ) )
		platestrs = SplitIn2AndTrim( p1Lines[2], ";" );
	else 
		return;
		
	//need to remove any periods from the plate string
	platestrs[1] = STRUTIL.ReplaceAll( platestrs[1], ".", "" );
	//sometimes the plate line has extra codes after a second semicolon. need to remove all that.
	breakloc = platestrs[1].indexOf( ";" );
	if ( breakloc != -1 )
		platestrs[1] = ( platestrs[1].substring(0, breakloc));
	

	var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
	if ( idx != -1 )
	{		
		var lines = STRUTIL.GetLines(content.substring(idx) );
		var parts = STRUTIL.Split( lines[0], "  " );
		
		if ( jxtools.IsDate( parts[0] )  )
		{	
			
			//get the vehicle type and DOE from line 0
			var curVehicle = jxtools.CreateVehicleInfo(MC);
			vehstrs = SplitIn2AndTrim( lines[0], "  " );
				curVehicle.SetRegistrationExpirationDate( vehstrs[0]); //not sure if this is right or if it is effective date
				//LAWCUR - This is not the style.  What is?
				//curVehicle.SetStyleCode( vehstrs[1] );

				makeinfo = SplitIn2AndTrim( vehstrs[1], "-" );
				curVehicle.SetMakeCode(makeinfo[0]);
				
				
			curVehicle.SetLicensePlateID( platestrs[1] );  
			
			parsedItems.add(curVehicle);
			
			//get the person info from line 1
			var person = jxtools.CreatePersonInfo(MC);
			personstrs = SplitIn2AndTrim( lines[1], "  " );
			if ( ExtractReadableName( personstrs[0], person ) )
			{
				//person.SetOLN( personstrs[1], "MI", false );
				parsedItems.add(person);					
			}
			
			//get the address from line 2
			var address = Extract1LineAddr( lines[2], person );
			keepParsing = false;
			
			//get the vehicle info from line 3
			vehicleinfo = SplitIn2AndTrim( lines[3], " " );
				curVehicle.SetModelYearDate( vehicleinfo[0] );
				modelinfo = SplitIn2AndTrim( vehicleinfo[1], "  " );
					curVehicle.SetModelCode( modelinfo[0] );
					
					breakloc = modelinfo[1].indexOf( " IN " );
					if ( breakloc != -1 )// looking for a boat lenght which will have " IN " in it
					{
						vininfo = SplitIn2AndTrim( modelinfo[1], " IN " );
						if ( vininfo[0] != null)
							curVehicle.SetModelCodeText( vininfo[0] );  //not sure what to do with this.
						if ( vininfo[1] != null)
							curVehicle.SetVIN(vininfo[1]);
					}
					else
						curVehicle.SetVIN(modelinfo[1]);
					
		}
		
	}
}

