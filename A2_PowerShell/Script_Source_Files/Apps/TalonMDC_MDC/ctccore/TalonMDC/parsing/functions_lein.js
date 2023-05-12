/*
LEIN Helper functions to be included with other scripts.
		

Registered Beans:
ptools - ParsingTools
xtools - XMLTOOLS
jxtools - JXMLTools
stools - SCRIPTTOOLS
message - TDMessage
query - TDQuery
content - String
STRUTIL - STRUTIL
Engine - TalonEngine
This - LEINMessageParser
*/



/*Helper functions*/


//			   ( String line, JXMLAddressInfo address )
function ExtractFullAddress( line, address )
{
	MC.TraceCall( "functions_lein.ExtractFullAddress(" + line + ")" );

	//46238 BEN FRANKLIN SHELBY MI 48315
	//123 ELM ST  104  LANSING  MI
	//MICHIGAN DEPT OF CORR, LANSING, MI 48910
	// 23821 FULLERTON ST A       DETROIT          
	//795 HESS PO BOX 267  ST HELEN  48656
	
	//Had one that was just the state code.
	//MI

	//Double spaces become an blank item.
	var parts = STRUTIL.Split( line, " " );
	var len = parts.length;

	var startIndex = 1;
	//Look for a street number
	if ( STRUTIL.StrToInt( parts[0], -1 ) != -1 )
	{
		address.StreetNumberText = parts[0];
		startIndex = 2;
	}

	//Remove the Zip if found from the end.
	end = len-1;
	if ( jxtools.IsZip(parts[end]) )
	{
		address.PostalCode = parts[end];
		end--;
	}

	//The next item may be "" if there was a double space.
	//Remove all extra spaces.
	while ( end > 0 && parts[end].length() == 0 )
		end--;

	//Remove the State if found from the end.
	if ( jxtools.IsState(parts[end]) )
	{
		//MC.Trace( "Found state: " + parts[end] + " at index: " + end );
		address.State = parts[end];
		end--;
	}
	else
		address.State = "MI";

	//The next item may be "" if there was a double space.
	while ( end > 0 && parts[end].length() == 0 )
	{
		end--;
	}

	//Sometimes we don't have a full address.  Don't crash.
	if ( end < 0 )
		return;

	var streetName = parts[startIndex-1];	
	var streetSearch = true;
	var lastStreetIdx = 2;

	for ( var i=startIndex; i < end; i++ ) //Start after street number, and end with city remaining
	{
		if ( streetSearch )
		{
			if ( jxtools.IsRoadOrStreet(parts[i] ) )
			{
				streetSearch = false;
			}

			if ( parts[i].endsWith( "," ) )
			{
				//Use the comma as a sepatator between street and city.
				streetSearch = false;
				//remove the comma from the street name.
				parts[i] = RemoveTrailingComma( parts[i] );
			}

			//Append this unless it is a blank.  Treat that as a separator before the City.
			if ( parts[i].length() == 0 )
				streetSearch = false;
			else
				streetName = streetName + " " + parts[i];

			lastStreetIdx = i;

			/*  Handled with the extra space code in City below.
			if ( streetSearch == false )
			{
				//The next item may be "" since there was a double space.
				if ( parts[lastStreetIdx+1].length() == 0 )
					lastStreetIdx++;

				//Check for an Appartment number and include that as well.
				if ( STRUTIL.StrToInt( parts[lastStreetIdx+1], -1 ) != -1 )
				{
					streetName = streetName + " " + parts[lastStreetIdx+1];
					lastStreetIdx = lastStreetIdx+1;
				}
			}
			*/
		}
	}

	cityStart = lastStreetIdx+1;
	//Skip any blanks.
	while ( parts[cityStart] != null && parts[cityStart].length() == 0 )
		cityStart++;

	if (parts[cityStart] != null)
	{
		var city = RemoveTrailingComma( parts[cityStart] );

		for ( var i=cityStart + 1; i <= end; i++ )
		{
			var part = parts[i];

			if ( part.length() == 0 )
			{
				//It there was a double space assume that this was really the separator between the
				//Street and City.  Items before this were Appartment numbers or something.
				streetName = streetName + " " + city;

				//Skip all the spaces.
				while ( parts[i].length() == 0 && i < end )
					i++;

				//restart the city with this item.
				city = RemoveTrailingComma( parts[i] );
			}
			else
				city = city + " " + RemoveTrailingComma(part);
		}
	}

	//MC.Trace( "  StreetName: " + streetName );  //LAW DBG
	address.StreetName = streetName;

	//MC.Trace( "  City: " + city );  //LAW DBG
	address.City = city;
	
	//MC.Trace( "  State: " + address.State );  //LAW DBG
	//MC.Trace( "  Zip: " + address.PostalCode );  //LAW DBG
}


function ProcessName( name, person )
{
	//ITT,RON ANTONY  - Will the , always be there?
	
	var nameSet = false;
	
	var parts = STRUTIL.Split( name, "," );
	
	if ( parts.length == 2 )
	{
		person.SurName = parts[0];
		
		parts = STRUTIL.Split( parts[1], " " );
				
		person.GivenName = parts[0];
		
		if ( parts.length > 1 )
		{
			person.MiddleName = parts[1];  //TODO: handle longer names
		}
		
		nameSet = true;
	}
	
	return nameSet;
}

function RemoveTrailingComma( str )
{
	if ( str.endsWith( "," ) )
	{
		//remove the comma from the city name.
		//MC.Trace( "Remove comma from: " + str );
		str = str.substring( 0, str.length()-1 );
		//MC.Trace( "Removed comma    : " + str );
	}

	return str;
}

