/*
	Parse a NCIC Stolen item Response.
*/

if (keepParsing) HandleNCICResponse();


function HandleNCICResponse()
{
	//MC.Trace( "Run NCICI Stolen"  ); 
	offset = 0;
	
	pgraphs = ptools.SplitIntoParagraphs( content, "MKE/STOLEN" );

	num = pgraphs.size();
	for ( i = 0; i < num; i++ )
	{
		pLines = pgraphs.get( i );

		map = ptools.DecodeToMap( pLines, "/" );

		//Is "MKE/STOLEN VEHICLE" The unique Tag?
		//Find the section if it exists.
		if ( pLines.indexOf( "MKE/STOLEN VEHICLE" ) >= 0 ||
		     pLines.indexOf( "MKE/STOLEN LICENSE PLATE" ) >= 0 )
		{
			//MC.Trace( "Found NCIC 53 STOLEN VEHICLE\n" + pLines ); 
			ExtractVehicle( map );
		}
		else if ( pLines.indexOf( "MKE/STOLEN ARTICLE" ) >= 0 )
			ExtractArticle( map );
	}
}

function ExtractArticle( map )
{
	//Is "MKE/STOLEN ARTICLE" The unique Tag?
	//MC.Trace( "Found NCIC STOLEN ARTICLE\n" + pLines ); 

	prop = jxtools.CreateProperty(MC);

	//?.Set?( map.get( "ORI" ) );  //? Entering ORI?

	prop.SetArticleType( map.get( "TYP" ) );
	prop.SetSerialNumber( map.get( "SER" ) );
	prop.SetBrandName( map.get( "BRA" ) );

	prop.SetModelName( map.get( "MOD" ) );
	prop.SetOAN( map.get( "OAN" ) );
	prop.SetDateStolen( map.get( "DOT" ) );  //Date of Theft

	prop.SetOCA( map.get( "OCA" ) );

	prop.SetNCICNumber( map.get( "NIC" ) );
	//prop.Set?( map.get( "DTE" ) );  //Date and Time of Entry?

	parsedItems.add(prop);
	keepParsing = false;		
}

function ExtractVehicle( map )
{
	curVehicle = jxtools.CreateVehicleInfo(MC);
	
	//?.Set?( map.get( "ORI" ) );  //? Entering ORI?

	curVehicle.SetLicensePlateID( map.get( "LIC" ) );
	curVehicle.SetRegistrationJurisdictionName( map.get( "LIS" ) );
	curVehicle.SetRegistrationExpirationDate( map.get( "LIY" ) );
	curVehicle.SetStyleCode( map.get( "LIT" ) );

	curVehicle.SetVIN( map.get( "VIN" ) );
	curVehicle.SetModelYearDate( map.get( "VYR" ) );

	curVehicle.SetMakeCode( map.get( "VMA" ) );
	curVehicle.SetModelCode( map.get( "VMO" ) );
	curVehicle.SetStyleCode( map.get( "VST" ) );
	//curVehicle.Set?( map.get( "VCO" ) );  //Color
	//curVehicle.Set?( map.get( "DOT" ) );  //Date of Theft?

	//curVehicle.Set?( map.get( "OCA" ) ); 

	//curVehicle.Set?( map.get( "MIS" ) ); 
	//curVehicle.Set?( map.get( "NIC" ) ); 
	//curVehicle.Set?( map.get( "DTE" ) ); 

	//curVehicle.Set?( map.get( "VLD" ) );  //Date

	parsedItems.add(curVehicle);
	keepParsing = false;		
}
