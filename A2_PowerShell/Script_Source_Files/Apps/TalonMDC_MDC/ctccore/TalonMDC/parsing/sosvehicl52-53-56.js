/*
	Parse a SOS Vehicle Response.
*/

if (keepParsing) HandleVehicleResponse();


function HandleVehicleResponse()
{
	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;
	
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length <= 3 )
		return;

	//Find unique message type
	dataLineIndex = 5;
	if ( p1Lines[2].startsWith( "56;" ) || p1Lines[2].startsWith( "53;" ) || p1Lines[3].startsWith( "52;" )  )
		dataLineIndex = 6;
	else if ( p1Lines[3].startsWith( "56;" )|| p1Lines[3].startsWith( "53;" )  )
		dataLineIndex = 7;
	else if ( !  p1Lines[2].startsWith( "52;" ))
		return;


	var idx = ptools.AdvanceToLineAfter( content, "TITLE INFORMATION:", 0 );
	var curVehicle = jxtools.CreateVehicleInfo(MC);
	var person = jxtools.CreatePersonInfo(MC);

	if ( idx != -1 )
	{		
		var lines = STRUTIL.GetLines(content.substring(idx) );
		
		//sometimes there is a note line before the date line. We need to adjust for that.
		testdate = SplitIn2AndTrim( lines[1], " " );
		adjustlines = 0;
		if ( ! jxtools.IsDate( testdate[0] )  )
			adjustlines = 1;
	
		//this handles year-mk-vin-style line
		//lines[0] is like "1986 OLDSMOBILE   AAAAA11111SPC         12 FOUR DOOR    M CORR       "

		if (SetVehicleYrMkVinStyle(lines[0 + adjustlines], curVehicle) )
		{
			parsedItems.add(curVehicle);

			//lines[1] is like this:""    05/02/2006    123T4567890     VENTURE             12345 A""
			SetVehicleDATEMODEL( lines[1 + adjustlines], curVehicle ) 
			keepParsing = false;		
		}
		
		//lines[2] = person name
		if ( ExtractReadableName( lines[2 + adjustlines], person ) )
		{
		//lines[3] &  lines[4] = address
			var address = Extract2LineAddr( lines[3 + adjustlines], lines[4 + adjustlines], person );
			parsedItems.add(person);
			keepParsing = false;
		}
	}

	idx = ptools.AdvanceToLineAfter( content, "REGISTRATION INFORMATION:", 0 );
	if ( idx != -1 )
	{		
		registration = content.substring(idx);

		//Remove any Previous owner so we can parse the REGISTRATION INFORMATION.
		//Which is sometimes not given.
		idx = registration.indexOf( "PREVIOUS" );
		if ( idx != -1  )
		{
			registration = registration.substring( 0, idx )
		}

		var lines = STRUTIL.GetLines( registration );
		
		//MC.Trace( "lines[0]: " + lines[0] );
		var platestrs = SplitIn2AndTrim( lines[0], "  " );
		
		if ( platestrs[0] != null) 
			curVehicle.SetLicensePlateID( platestrs[0] ); 
		//if ( platestrs[1] != null) 
			//curVehicle.SetPlateType( platestrs[1] ); //should be plate type
			

		//MC.Trace( "lines[1]: " + lines[1] );
		var parts = STRUTIL.Split( lines[1], " " );
		
		if ( jxtools.IsDate( parts[0] )  )
		{	
			//MC.Trace( "Found Date: " + parts[0] );

			//get the vehicle type
			vehstrs = SplitIn2AndTrim( lines[1], "  " );
			
			curVehicle.SetRegistrationEffectiveDate( vehstrs[0]); //not sure if this is right
			
			if ( vehstrs[1] != null) //sometimes there is no OLN
				person.SetOLN( vehstrs[1], "MI", false );
				
			keepParsing = false;
		}
		
	}
}
