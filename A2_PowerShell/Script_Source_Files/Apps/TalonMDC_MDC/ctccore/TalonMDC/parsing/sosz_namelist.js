/*
	Parse a SOS Person List
*/

if (keepParsing) HandleResponse();


function HandleResponse()
{
	//The only thing in all of these messages is the TOTAL line at the bottom.
	if ( content.indexOf( "TOTAL:" ) == -1 )
		return;

	firstParagraph = ptools.ExtractParagraph( content, 0 );
	if ( firstParagraph == null )
		return;

	//This response does not have the normal SOS code line in the header.
	//It only has two lines.
	p1Lines = STRUTIL.GetLines( firstParagraph );
	if ( p1Lines.length != 2 )
		return;

	pIndex = 0
	while ( pIndex >= 0 )
	{
		pIndex = ptools.AdvanceToParagraph( content, pIndex, 4 );
		if ( pIndex >= 0 )
		{
			paragraph = ptools.ExtractParagraph( content, pIndex );
			pLines = STRUTIL.GetLines( paragraph );
			
			//We get a 4 line block that has the following format.
				//OLN
				//Name (Last First Middle
				//Address
				//City Zip
			if ( pLines.length == 4 )
			{
				if ( jxtools.IsOLN( pLines[0] ) )
				{
					var person = jxtools.CreatePersonInfo(MC);
					person.SetOLN( pLines[0], GetDefaultStateAbbr(), false );
					if ( ExtractReverseName( pLines[1], person ) )
					{
						//The address is the last two lines.
						var address = Extract2LineAddr( pLines[2], pLines[3], person );
						parsedItems.add(person);
						keepParsing = false;
					}
				}
			}
		}
	}
}
