/*
 	Parse a SOS vehicle Response with new CARS format
 */

if (keepParsing) HandleVehicleResponse();

function HandleVehicleResponse()
{

	var idx = ptools.AdvanceToLineAfter( content, "TITLE INFORMATION:", 0 );
	var curVehicle = jxtools.CreateVehicleInfo(MC);
	var person = jxtools.CreatePersonInfo(MC);
	
	if ( idx != -1 )
	{
		var lines = content.substring(idx);
		
		if (SetVehicleInfo(lines, curVehicle))
		{
			parsedItems.add(curVehicle);
			keepParsing = false;
		}
	}
	
	idx = ptools.AdvanceToLineAfter( content, "TITLE HOLDER INFORMATION:", 0 );
	
	if ( idx != -1 )
	{
		var lines = STRUTIL.GetLines( content.substring(idx) );
		if ( ExtractReadableName( lines[0], person ) )
		{
			if (lines.length > 2)
			{
				var address = Extract2LineAddr( lines[1], lines[2], person);
				
			}
			
			if (lines.length > 3)
			{
				var olnparts = STRUTIL.Split( lines[3], " ");
				var oln = "";
				var olnstate = "";
				if (olnparts.length > 0)
				{
					oln = olnparts[0];
				}
				if (olnparts.length > 1)
				{
					olnstate = olnparts[1];
				}
				person.SetOLN( oln, olnstate, false );
			}
			parsedItems.add(person);
			keepParsing = false;
		}
	}
}