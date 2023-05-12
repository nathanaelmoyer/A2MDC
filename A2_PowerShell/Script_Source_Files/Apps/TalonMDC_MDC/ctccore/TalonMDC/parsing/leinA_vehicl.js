/*
	Parse a LEIN Vehicle Response.
	Plate Infomation.
*/

if (keepParsing) HandlePlateResponse();


function HandlePlateResponse()
{
	//Is "STOLEN PLATE" The unique Tag?
	//var licLines = ptools.ExtractParagraph( content, "STOLEN PLATE", 0 );

	//Find the LIC: section if it exists.
	var licLines = ptools.ExtractParagraph( content, "LIC:", 0 );
	if ( licLines != null )
	{
		//MC.Trace( "licLines: " + licLines );
		curVehicle = jxtools.CreateVehicleInfo(MC);
		map = ptools.DecodeToMap( licLines, ":" );
		lic = map.get( "LIC" ) ;
		//MC.Trace( "LIC: " + lic );
		curVehicle.SetLicensePlateID( lic );  //20
		curVehicle.SetRegistrationJurisdictionName( map.get( "LIS" ) );  //22
		curVehicle.SetRegistrationExpirationDate( map.get( "LIY" ) );	//24
		curVehicle.SetPlateType( map.get( "LIT" ) );			//27  Plate Type
		//curVehicle.Set?( map.get( "DOT" ) );	//28
		//curVehicle.Set??( map.get( "OCA" ) );			//29

		//These may be missing.
		curVehicle.SetModelYearDate( map.get( "VYR" ) ); 
		curVehicle.SetMakeCode( map.get( "VMA" ) ); 
		curVehicle.SetModelCode( map.get( "VMO" ) ); 
		curVehicle.SetStyleCode( map.get( "VST" ) ); 

		//Check if this also has a STOLEN VEHICLE Section.
		index = content.indexOf( "STOLEN VEHICLE" );
		if ( index >= 0 )
		{
			//Find the following License info section.
			licLines = ptools.ExtractParagraph( content, "LIC:", index );
			if ( licLines != null )
			{
				map = ptools.DecodeToMap( licLines, ":" );
				//CHECK - This overwrites the value from the first section.
				//curVehicle.Set?( map.get( "LIC" ) );   //24
				//curVehicle.Set?( map.get( "LIS" ) ); 
				//curVehicle.Set?( map.get( "LIY" ) ); 
				//curVehicle.Set?( map.get( "LIT" ) ); 
				vin = map.get( "VIN" )
				//Sometimes the VIN is put into the OAN field.
				if ( vin == null )
					vin = map.get( "OAN" )
				curVehicle.SetVIN( vin );   //23

				curVehicle.SetModelYearDate( map.get( "VYR" ) ); 
				curVehicle.SetMakeCode( map.get( "VMA" ) ); 
				curVehicle.SetModelCode( map.get( "VMO" ) ); 
				curVehicle.SetStyleCode( map.get( "VST" ) ); 
				//curVehicle.Set?( map.get( "VCO" ) ); 
				//curVehicle.Set?( map.get( "DOT" ) ); 
				//curVehicle.Set?( map.get( "OCA" ) ); 
			}
		}

		parsedItems.add(curVehicle);
		keepParsing = false;		
	}
}
