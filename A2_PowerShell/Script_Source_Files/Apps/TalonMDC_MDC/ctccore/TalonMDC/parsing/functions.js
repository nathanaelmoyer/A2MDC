/*
Helper functions to be included with other scripts.
		

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

/*
Extract a standard, 2 line mailing style address
(currently does not support Apt numbers)

5020 W Michigan Ave
Lansing MI 48917
*/
function Extract2LineAddr( line1, line2, jxPerson )
{
	This.DebugCall( "Extract2LineAddr:\n" + line1 + "\n" + line2 );
	
	var address;
	
	if (jxPerson != null)
		address = jxtools.CreateResidence(MC);
	else
		address = jxtools.CreateLocation(MC);
	
	ExtractStreetAddress( line1, address );
		
	
	var line2parts = stools.TokenizeLineToStringCollection( line2, 2 );
	var itemCount = line2parts.GetSize();
	
	if ( itemCount >= 2 )
	{
		address.City = line2parts.GetListing(0, itemCount-1, " ", false );
		if (jxtools.IsZip(line2parts.ElementAt(itemCount-1)))
			address.PostalCode = line2parts.ElementAt(itemCount-1);
		address.State = "MI";
	}
	else
	{
		This.Trace( "Unhandled Address line2: " + line2 );
	}
		
	
	This.DebugTrace( "Address: " + address );
	
	if ( jxPerson != null )
		jxPerson.AddSubNode(address);
	
	return address;
}
/*
Extract a standard, 1 line mailing style address with multiple spaces separating the street from the city
(currently does not support Apt numbers)

LAW NOTE:  In functions_lein.js there is a method ExtractFullAddress() that does almost the same as this.
		It does try to handle Apt numbers.

5020 W Michigan Ave             Lansing MI 48917
*/
function Extract1LineAddr( line1, jxPerson )
{
	//This.DebugCall( "Extract1LineAddr:\n" + line1  );
	MC.Trace( "Extract1LineAddr(" + line1 + ")" );  
	
	var address;
	strs = SplitIn2AndTrim( line1, "  " );
	
	if (jxPerson != null)
		address = jxtools.CreateResidence(MC);
	else
		address = jxtools.CreateLocation(MC);

	ExtractStreetAddress( strs[0], address );

	var line2parts = stools.TokenizeLineToStringCollection( strs[1], 2 );
	var itemCount = line2parts.GetSize();
	
	if ( itemCount >= 2 )
	{
		address.City = line2parts.GetListing(0, itemCount-1, " ", false );
		
		if (jxtools.IsZip(line2parts.ElementAt(itemCount-1)))
			address.PostalCode = line2parts.ElementAt(itemCount-1);
		address.State = "MI";
	}
	else
	{
		This.Trace( "Unhandled Address line2: " + strs[1] );
	}


	This.DebugTrace( "Address: " + address );

	if ( jxPerson != null )
		jxPerson.AddSubNode(address);
	
	return address;
}


/*
Extract a street address and number from a single line.
*/
function ExtractStreetAddress( line, address )
{
    var line1parts = stools.TokenizeLineToStringCollection( line, 1 );
    
	if ( line1parts.GetSize() == 1 )
	{
		address.StreetName = line;
	}
	else
	{

		address.StreetNumberText = line1parts.ElementAt(0);
		
		line1parts.Remove(0);
		address.StreetName = line1parts.GetListing( " ", false );		
	}
}


/*
Pass in a nameLine which contains a name to be parsed.
The parsed fields will be set in jxPerson

'Readable' - Format is First Middle Last ie 
	not Last, First, Middle
	
@return
	True if a name was extracted, and set into the jxPerson.
*/
function ExtractReadableName( nameLine, jxPerson )
{

	var nameSet = false;
	
	This.DebugTrace( "Name line: " + nameLine );
	
	//nameLine = STRUTIL.Split( nameLine, " AND " )[0]; //Bug: I doubt there will be a trailing space when AND is used at the end of the line, but we don't want to split Andersons.
	//nameLine = STRUTIL.Split( nameLine, "&" )[0]; 
	nameLine = jxtools.RemoveConjunctions( nameLine );
	
	This.DebugTrace( "Name line after: " + nameLine );
	
	var parts = stools.TokenizeLine( nameLine, 1 );
	var num = parts.length;

	if ( num == 2 )
	{
		jxPerson.GivenName = parts[0];
		jxPerson.SurName = parts[1];
		
		nameSet = true;
	}
	else if ( num == 3 )
	{
		jxPerson.GivenName = parts[0];
		
		if ( jxtools.IsSuffix( parts[2] ) )
		{
			jxPerson.SurName = parts[1];
			jxPerson.Suffix = parts[2];
		}
		else
		{
			jxPerson.MiddleName = parts[1];
			jxPerson.SurName = parts[2];			
		}
		
		nameSet = true;
	}
	else if ( num == 4 )
	{
		jxPerson.GivenName = parts[0];
		
		if ( jxtools.IsSuffix( parts[3] ) )
		{
			jxPerson.MiddleName = parts[1];
			jxPerson.SurName = parts[2];
			jxPerson.Suffix = parts[3];
		}
		else
		{
			jxPerson.MiddleName = parts[1] + " " + parts[2];
			jxPerson.SurName = parts[3];
		}
		
		nameSet = true;
	}

	This.DebugTrace( "Person: " + jxPerson );

	return nameSet;
}

function GetDefaultStateAbbr()
{
	return "MI";
}

/*
Break a string into 2 parts and remove all extra spaces.
returns an array of two Strings.  The second may be null.
*/
function SplitIn2AndTrim( str, sep )
{
	//MC.Trace( "SplitIn2AndTrim(" + str + ") sep: " + sep );  //LAW DBG
	strs = STRUTIL.SplitIn2( str, sep );
	strs[0] = strs[0].trim();
	if ( strs[1] != null )
		strs[1] = strs[1].trim();
	
	//MC.Trace( "  Item 0: " + strs[0] );
	//MC.Trace( "  Item 1: " + strs[1] );

	return strs;
}
