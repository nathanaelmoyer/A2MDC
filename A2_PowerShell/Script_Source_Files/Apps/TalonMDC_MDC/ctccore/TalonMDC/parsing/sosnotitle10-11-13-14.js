/*
	Parse a SOS Vehicle Response.
*/

if (keepParsing) HandleVehicleResponse();


function HandleVehicleResponse()
{
/*
	A SOS 74193 14325 04/30/07 1005 CLEMISCOMP3.
	MI630043N
	14;999YZZ.
	FOR:TEST/CLEMIS
	OPR:TEST
	03/06/2007                                 PC-CORRECTION
	ANNE CARR DRIVER                     D-616-067-108-888
	7064 CROWNER DR                      LANSING 48918-0001
	
	Sometimes there are comments between the date line and the name.  Such as:
	       **NOT A VALID PLATE**
	       *REPORTED AS REPLACED*
*/

	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;
	
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length <= 3 )
		return;

	//Find Unique SOS code
	if ( p1Lines[3].startsWith( "14;" )  ||  p1Lines[3].startsWith( "13;" )  ||  p1Lines[3].startsWith( "11;" ) ||  p1Lines[3].startsWith( "10;" ) )
	{
		platestrs = SplitIn2AndTrim( p1Lines[3], ";" );
		platestrs[1] = STRUTIL.ReplaceAll( platestrs[1], ".", "" );
	}
	else if (  p1Lines[2].startsWith( "14;" ) ||  p1Lines[2].startsWith( "13;" )||  p1Lines[2].startsWith( "11;" ) ||  p1Lines[2].startsWith( "10;" ) )
	{
		platestrs = SplitIn2AndTrim( p1Lines[2], ";" );
		platestrs[1] = STRUTIL.ReplaceAll( platestrs[1], ".", "" );
	}
	else //if ( !  p1Lines[2].startsWith( "14;" ))
		return;

	//this version only parses the NO TITLE VERSION OF THE MESSAGE
	if (content.indexOf ( "** NO TITLE INFORMATION ON COMPUTER **") == -1)
		return;
		
	   var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
	   if ( idx != -1 )
	   {		
		// if we are in a 10 or 11 response, we need to get to the next section after the plate
		if ( platestrs[0].startsWith( "10" ) || platestrs[0].startsWith( "11" ) )
			idx = ptools.AdvanceToLineAfter( content, platestrs[1], idx );
			//ptools.ExtractParagraph( content, platestrs[1], idx );
		
		var lines = STRUTIL.GetLines(content.substring(idx) );
		var parts = STRUTIL.Split( lines[0], " " );
		
		if ( jxtools.IsDate( parts[0] )  )
		{	
			
			//get the vehicle type
			vehstrs = SplitIn2AndTrim( lines[0], "  " );
			var curVehicle = jxtools.CreateVehicleInfo(MC);
			curVehicle.SetRegistrationEffectiveDate( vehstrs[0]); //not sure if this is right date
			//curVehicle.SetStyleCode( vehstrs[1] );
			curVehicle.SetPlateType( vehstrs[1] );
			curVehicle.SetLicensePlateID( platestrs[1] );  
			parsedItems.add(curVehicle);

			//Skip any comment lines that start with spaces or *
			lineNum = 1;
			while ( lineNum < lines.length && ( lines[lineNum].startsWith( " " ) || lines[lineNum].startsWith( "*" ) ) )
				lineNum++;

			//Make sure that there are the two lines
			if ( lineNum < lines.length - 2 )
			{
				//get the person info
				var person = jxtools.CreatePersonInfo(MC);
				personstrs = SplitIn2AndTrim( lines[lineNum], "  " );
				if ( ExtractReadableName( personstrs[0], person ) )
				{
					person.SetOLN( personstrs[1], "MI", false );
					parsedItems.add(person);	

					//get the address
					var address = Extract1LineAddr( lines[lineNum+1], person );
					//person.AddSubNode( address );
					//parsedItems.add(address);
				}
			}

			keepParsing = false;	
		}
	   }
}
