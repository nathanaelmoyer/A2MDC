/*
	Parse a NCIC Vehicle Response.
*/

if (keepParsing) HandleNCICResponse();


function HandleNCICResponse()
{
	//Have seen
	//MKE/STOLEN GUN
	//MKE/RECOVERED GUN
	//MKE/LOCATED STOLEN GUN
	
	mkeIndex = content.indexOf( "MKE/" );
	while ( mkeIndex >= 0 )
	{
		//Find the section if it exists.
		var pLines = ptools.ExtractParagraph( content, mkeIndex );
		if ( pLines != null )
		{
			if ( pLines.indexOf( "GUN" ) >= 0 )
				ExtractGun( pLines );
		}

		//Look for another section.
		mkeIndex = content.indexOf( "MKE/", mkeIndex + 3 );
	}
}
	
function ExtractGun( pLines )
{
	gun = jxtools.CreateGun(MC);
	map = ptools.DecodeToMap( pLines, "/" );

	//TODO - None of these fields are in the XML.

	//?.Set?( map.get( "ORI" ) );  //? Entering ORI?
	gun.SetSerialNumber( map.get( "SER" ) ); 
	gun.SetMakeName( map.get( "MAK" ) ); 
	gun.SetCaliber( map.get( "CAL" ) );  //Calibur
	gun.SetModelName( map.get( "MOD" ) ); 
	

	gun.SetType( map.get( "TYP" ) );
	//gun.Set?( map.get( "DOT" ) );  //Date of Theft
	//gun.Set?( map.get( "DOR" ) );  //Date of Recovery?

	gun.SetOCA( map.get( "OCA" ) );

	gun.SetMisc( map.get( "MIS" ) );

	gun.SetNCICNumber( map.get( "NIC" ) );
	//gun.Set?( map.get( "DTE" ) );  //Date and Time of Entry?

	parsedItems.add(gun);
	keepParsing = false;		
}
