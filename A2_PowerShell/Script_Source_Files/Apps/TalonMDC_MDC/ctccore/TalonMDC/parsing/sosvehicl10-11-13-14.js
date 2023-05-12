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
	}
	else if (  p1Lines[2].startsWith( "14;" ) ||  p1Lines[2].startsWith( "13;" )||  p1Lines[2].startsWith( "11;" ) ||  p1Lines[2].startsWith( "10;" ) )
	{
		platestrs = SplitIn2AndTrim( p1Lines[2], ";" );
	}
	else
		return;

	//Remove the trainling period character.
	platestrs[1] = STRUTIL.ReplaceAll( platestrs[1], ".", "" );

	var idx = ptools.AdvanceToLineAfter( content, "TITLE INFORMATION:", 0 );
	var person = jxtools.CreatePersonInfo(MC);
	var curVehicle = jxtools.CreateVehicleInfo(MC);
	curVehicle.SetLicensePlateID( platestrs[1] );  

	if ( idx != -1 )
	{
		//This will remove any blank lines.
		var lines = STRUTIL.GetLines(content.substring(idx) );
		
		//sometimes there is a note line before the date line. We need to adjust for that.
		testdate = SplitIn2AndTrim( lines[1], " " );
		adjustlines = 0;
		if ( ! jxtools.IsDate( testdate[0] )  )
			adjustlines = 1;

		
		//0 = YEAR, MAKE, VIN, STYLE
		//lines[0] is like "1986 OLDSMOBILE   AAAAA11111SPC         12 FOUR DOOR    M CORR       "
		if (SetVehicleYrMkVinStyle(lines[0 + adjustlines], curVehicle) )
		{
			parsedItems.add(curVehicle);
			
			//lines[1] is like this:""    05/02/2006    123T4567890     VENTURE             12345 A""
			SetVehicleDATEMODEL( lines[1+ adjustlines], curVehicle )
			keepParsing = false;
		}
		
		//sometimes we get a 4 line address with a two line (company) name.  Skip those.
		addParaIndex = ptools.AdvanceToParagraph( content, idx, 3 );
		if ( addParaIndex > 0 )
		{
			addParagraph = ptools.ExtractParagraph( content, addParaIndex );
			addPLines = STRUTIL.GetLines( addParagraph );
			
			//sometimes we get a 4 line address with a two line (company) name.  Skip those.
			//If this is really two people then we may want to add two person subnodes.
			if ( addPLines.length == 3 )
			{
				if ( ExtractReadableName( addPLines[0], person ) )
				{
					//The address is the last two lines.
					var address = Extract2LineAddr( addPLines[1], addPLines[2], person );
					parsedItems.add(person);
					keepParsing = false;
				}
			}
		}

		/*Does not work with the 4 line addresses. - 8/8/07 Replaced with above
		//lines[2] = person name
		if ( ExtractReadableName( lines[2 + adjustlines], person ) )
		{
		//lines[3] &  lines[4] = address
			var address = Extract2LineAddr( lines[3 + adjustlines], lines[4 + adjustlines], person );
			parsedItems.add(person);
			keepParsing = false;
		}
		*/
	}

	idx = ptools.AdvanceToLineAfter( content, "REGISTRATION INFORMATION:", 0 );
	if ( idx != -1 )
	{		
		// if we are in a 10 or 11 response, we need to get to the next section after the plate
		//Look for the plate code after the REGISTRATION INFORMATION header.
		if ( platestrs[0].startsWith( "10" ) || platestrs[0].startsWith( "11" ) )
			idx = ptools.AdvanceToLineAfter( content, platestrs[1], idx );
		
		var lines = STRUTIL.GetLines( content.substring(idx) );
		var parts = STRUTIL.Split( lines[0], " " );
		
		if ( jxtools.IsDate( parts[0] ) || parts[0].equals( "*NON-EXPIRING*" ) )
		{	
			//get the vehicle type
			vehstrs = SplitIn2AndTrim( lines[0], "  " );

			//Should we put *NON-EXPIRING* in here?
			curVehicle.SetRegistrationExpirationDate( vehstrs[0]); //LAW 8/9/07 Was calling SetRegistrationEffectiveDate()
			if ( vehstrs[1] != null ) //sometimes there is no OLN
				person.SetOLN( vehstrs[1], "MI", false );

			keepParsing = false;	
		}
	}
	else
	{
	/*  Something like this.
	OPR:BAKER
	11/26/2009                           DX-RENEWAL  *HCPLT**PENINSULA*
	ALAN DALE STREIT                     S-363-040-135-903
	500 PINEVIEW CT                      HILLMAN 49746-8975
	1993 LINCOLN 4D 33                   1LNLM9741PY703595
	*/
		//This.Trace( "SOS 1x without Title Info" );
		var idx = ptools.AdvanceToLineAfter( content, "OPR:", 0 );
		if ( idx != -1 )
		{
			var lines = STRUTIL.GetLines( content.substring(idx) );
			var parts = STRUTIL.Split( lines[0], " " );
			if ( lines.length >= 3 && jxtools.IsDate( parts[0] ) )
			{
				nameLine = lines[1];
				columnOffset = 37;
				//Check if last item is the OLN.
				if ( nameLine.length() > columnOffset )
				{
					oln = nameLine.substring(columnOffset);
					//This.Trace( "oln code [" + oln + "]" );
					if ( jxtools.IsOLN( oln ) )
					{
						person.SetOLN( oln, "MI", false );
						nameLine = nameLine.substring( 0, columnOffset );
					}
				}
				
				ExtractReadableName( nameLine, person );

				//get the address
				addressLine = lines[2];
				vehLine = lines[3];

				var parts = STRUTIL.Split( addressLine, " " );
				if ( parts.length <= 1 || ! STRUTIL.IsStrNumeric( parts[0] ) || ! jxtools.IsZip( parts[parts.length - 1] ) )
				{
					//Usually a second name line.
					//Since we don't have a way to store a second name in person I am skipping it.
					addressLine = lines[3];
					vehLine = lines[4];
				}

				var address = Extract1LineAddr( addressLine, person );

				This.Trace( "LAWDBG Found name and Address. \n" + person.toJXML().ShowTree() );

				parsedItems.add(person);
				keepParsing = false;
				
				//Check if there is a vehicle info line.
				//like:  2002 GMC SW 31                       1GKDT13S322504582 ENVOY
				if ( vehLine.length() > columnOffset )
				{
					vin = vehLine.substring(columnOffset);
					var parts = STRUTIL.Split( vin, " " );
					if ( STRUTIL.IsStrPartNumeric( parts[0] ) )
						curVehicle.SetVIN( parts[0] );
					vehInfo = vehLine.substring( 0, columnOffset );
					var parts = STRUTIL.Split( vehInfo, " " );
					if ( parts.length >= 2 )
					{
						if ( STRUTIL.IsStrNumeric( parts[0] ) )
						{
							curVehicle.SetModelYearDate( parts[0] );
							curVehicle.SetMakeCode( parts[1] )

							parsedItems.add(curVehicle);
							keepParsing = false;  //Alrady done but being safe.
						}
					}
				}
			}
		}
	}
}
