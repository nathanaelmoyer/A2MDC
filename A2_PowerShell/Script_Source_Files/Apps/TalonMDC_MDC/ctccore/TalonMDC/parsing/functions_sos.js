/*
Helper functions to be included with other SOS scripts.
		

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



/*SOS Helper functions*/

function SubStringAndTrim( str, startIndex, endIndex )
{
	sub = str.substring( startIndex, endIndex );
	return sub.trim();
}


/*
	Format is Name, DOB, Sex, Height, Weight, Eye, IMAGE
	Should be passed lineParts as: var line2 = stools.TokenizeLine( lines[2], 1 );
	
	Parameters: String [] lineParts, JXMLPersonInfo person
	returns boolean
*/
function SetNameLine( lineParts, person )
{
	var parsed = false;
	
	This.DebugCall( "SetNameLine: (" + lineParts.length + ") parts" );
	
	var nameSearch = true;
	var sexSearch = true;
	var heightSearch = true;
	var weightSearch = true;
	var eyeColorSearch = true;
	
	var name = lineParts[0];					
	var part = name;
	
	for ( var i=1; i < lineParts.length; i++ )
	{
		part = lineParts[i];
		
		This.DebugTrace( "Handling part: " + part );
		
		if ( nameSearch )
		{
			if ( jxtools.IsDate( part ) )
			{
				parsed = true;
				nameSearch = false;
				person.SetBirthDate(part);
				
				ExtractReadableName( name, person );
			}
			else
			{
				name = name + " " + part;
			}
		}
		else if ( sexSearch )
		{
			sexSearch = false;
			person.SexText = part;
		}
		else if ( heightSearch )
		{
			heightSearch = false;
			person.SetHeight( part );
		}
		else if ( weightSearch )
		{
			weightSearch = false;
			person.Weight = part;
		}
		else if ( eyeColorSearch )
		{
			eyeColorSearch = false;
			person.EyeColorText = part;
		}
	}

	return parsed;
}

function SetVehicleInfo( vehiclelines, curVehicle )
{
/*
VYR: 2015 VMA: JEEP VMO: WRANGER VIN: 11111111111111111 
VST: FOUR DOOR MILES: 60,000 MILEAGE CODE: A PRIMARY COLOR: RED SECONDARY COLOR: BLK
FUEL: ELECTRIC MPT CODE: POLICE
TITLE DATE: 09/19/2018 TITLE #: MI1195420000 TYPE: TRANSFER
*VEHICLE BRAND SPECIAL NOTATION*
*TITLE FLASH*
WEIGHT INFORMATION: (WILL ONLY APPEAR FOR CERTAIN VEHICLES)
CURRENT WEIGHT: 100,000
GROSS LADEN WEIGHT: 100,000
MAX LOAD WEIGHT: 100,000
UNLADEN WEIGHT: 100,000
 */
	if ( vehiclelines.indexOf("VYR") == -1 && vehiclelines.indexOf("VMA") == -1 && vehiclelines.indexOf("VMO") == -1 && vehiclelines.indexOf("VIN") == -1 )
		return false;
	
	var map = ptools.DecodeToMap( vehiclelines, ":" );
	
	curVehicle.SetModelYearDate( map.get("VYR") );
	curVehicle.SetMakeCode( map.get("VMA") );
	curVehicle.SetModelCodeText( map.get("VMO") );
	curVehicle.SetVIN( map.get("VIN") );
	curVehicle.SetStyleCode( map.get("VST") );
	curVehicle.SetPrimaryColor( map.get("PRIMARY COLOR") );
	curVehicle.SetSecondaryColor( map.get("SECONDARY COLOR") );
	curVehicle.SetMileage( map.get("MILES") );
	curVehicle.SetMileageCode( map.get("MILEAGE CODE") );
	curVehicle.SetCurrentWeight( map.get("CURRENT WEIGHT") );
	curVehicle.SetGrossLadenWeight( map.get("GROSS LADEN WEIGHT") );
	curVehicle.SetMaxLoadWeight( map.get("MAX LOAD WEIGHT") );
	curVehicle.SetUnLadenWeight( map.get("UNLADEN WEIGHT") );
	
	var licParsed = false;
	
	var licLines = ptools.ExtractParagraph( vehiclelines, "LIC:", 0);
	if ( licLines != null )
	{
		var map3 = ptools.DecodeToMap( licLines, ":" );
		var licPlateTag = map3.get("LIC");
		var idxSpace = licPlateTag.indexOf(" ");
		if (idxSpace != -1)
		{
			curVehicle.SetLicensePlateID( SubStringAndTrim( licPlateTag,  0, idxSpace) );
		}else{
			curVehicle.SetLicensePlateID( licPlateTag );
		}
		curVehicle.SetPlateType( map3.get("LIT") );
		if ( jxtools.IsDate( map3.get("ORIG ISSUE DATE") ) )
		{
			curVehicle.SetRegistrationEffectiveDate( map3.get("ORIG ISSUE DATE") );
		}
		if ( jxtools.IsDate( map3.get("EXP DATE") ) )
		{
			curVehicle.SetRegistrationExpirationDate( map3.get("EXP DATE") );
		}	
		licParsed = true;
	}
	
	if (!licParsed)
	{
		var idxreg = ptools.AdvanceToLineAfter( vehiclelines, "REGISTRATION INFORMATION:", 0 );
		
		if ( idxreg != -1 )
		{		
			var linesreg = STRUTIL.GetLines(vehiclelines.substring(idxreg) );
			var map2 = ptools.DecodeToMap( linesreg, ":" );
			
			curVehicle.SetLicensePlateID( map2.get("LIC") );
			curVehicle.SetPlateType( map2.get("LIT") );
			if ( jxtools.IsDate( map2.get("ORIG ISSUE DATE") ) )
			{
				curVehicle.SetRegistrationEffectiveDate( map2.get("ORIG ISSUE DATE") );
			}
			if ( jxtools.IsDate( map2.get("EXP DATE") ) )
			{
				curVehicle.SetRegistrationExpirationDate( map2.get("EXP DATE") );
			}
			
		}
	}
	
	return true;
	
}

function SetVehicleYrMkVinStyle( vehicleline, curVehicle )
{
/*  Examples:  It seems to be positional
          1         2         3         4         5         6         7
01234567890123456789012345678901234567890123456789012345678901234567890
Year MakeCode---- VIN--------------        Style-------
1994 FREIGHTLINER 1FV6HLAAXRL771173        TRACTOR        TRANSFER           
2001 AMERICAN STA 1N8RK272910036876   8560 TRLR COACH     TRANSFER   
1970 FRUEHAUF     WEM166202          13200 TRAILER        FOREIGN    
2003 BUICK        1G4HP52K93U228257     25 FOUR DOOR      ORIGINAL   
2006 LINCOLN      5LTPW18536FJ23474     42 PICKUP       S ORIGINAL   
1996 CHRYSLER     4C3AU42Y6TE373248     16 TWO DOOR       TRANSFER   
*/

	//MC.Trace( "SetVehicleYrMkVinStyle(" + vehicleline + ")" );

	if ( vehicleline.length() < 55 )
		return false;

	//NOTE: character at end index is not included.  use last character index +1.
	curVehicle.SetModelYearDate( 	SubStringAndTrim( vehicleline,  0,  4 ) );
	curVehicle.SetMakeCode( 	SubStringAndTrim( vehicleline,  5, 17 ) );
	curVehicle.SetVIN(  		SubStringAndTrim( vehicleline, 18, 35 ) );
	curVehicle.SetStyleCode(	SubStringAndTrim( vehicleline, 43, 55 ) );
	
	return true;
}

/*old try - Not always multiple space sepatated.
function SetVehicleYRMKVINSTYLE( vehicleline, curVehicle )
{
	parsed = false;

	strs = SplitIn2AndTrim( vehicleline, "  " );
	yearMake = strs[0];
	vin = null;
	style = null;  //Init to null.  If it gets set we found all the items.
	
	if ( strs[1] != null )
	{
	//strs[1] is like "AAAAA11111SPC         12 FOUR DOOR    M CORR       "
	//Splitting here           -----^^
		strs = SplitIn2AndTrim( strs[1], "  " );
		vin = strs[0];
		if ( strs[1] != null )
		{
		//strs[1] is like "12 FOUR DOOR    M CORR       "
		//Splitting here          -----^^
			strs = SplitIn2AndTrim( strs[1], "  " );
			style = strs[0];
		}
		
	}

	//If this last item found then the line fit the pattern.
	if ( style != null )
	{
		//curVehicle = jxtools.CreateVehicleInfo(MC);
		//yearMake is like "1986 OLDSMOBILE"
		yrmk = STRUTIL.SplitIn2( yearMake, " " );
		curVehicle.SetModelYearDate( yrmk[0] );
		curVehicle.SetMakeCode( yrmk[1] );
		
		curVehicle.SetVIN( vin );
		
		//style is like "12 FOUR DOOR"
		//Drop the first word.  TODO - What is the 12 and is it always there and one word?
		strs = STRUTIL.SplitIn2( style, " " );
		if ( strs[1] != null )
			curVehicle.SetStyleCode( strs[1] );
		else
		{
			This.DebugTrace( "Style not formatted as expected: " + style );
			//What to do?
			//Using the whole thing (which is only one word).
			curVehicle.SetStyleCode( style );
		}
		
		parsed = true;
	}
		
		return parsed;
}
*/

//next line is like this:""    05/02/2006    123T4567890     VENTURE             12345 A""
function SetVehicleDATEMODEL( vehicleline, curVehicle )
{
	parsed = false;
	
	strs = SplitIn2AndTrim( vehicleline, " " );
	effdate = strs[0];
	model = null;  //Init to null.  If it gets set we found all the items.
	
	if ( strs[1] != null )
	{
	//strs[1] is like " 123T4567890     VENTURE             12345 A""
		strs = SplitIn2AndTrim( strs[1], "  " );
		//somenumber = strs[0];
		if ( strs[1] != null )
		{
		//strs[1] is like "  VENTURE             12345 A "
			strs = SplitIn2AndTrim( strs[1], "  " );
			model = strs[0];
		}
		
	}

	//add the items if we found at least a  date
	if ( effdate != null )
	{
		//if (jxtools.IsDate( effdate) )
		//	curVehicle.SetRegistrationEffectiveDate( effdate );  this is the title date

		//curVehicle.SetVIN( somenumber );  note this is not the vin but I don' t know what it is.
		
		if (model != null)
			curVehicle.SetModelCode( model );

		parsed = true;
	}
		
		return parsed;
}


/*
Pass in a nameLine which contains a name to be parsed.
The parsed fields will be set in jxPerson

'Reverse' - Format is  Last  First  Middle
	
@return
	True if a name was extracted, and set into the jxPerson.
*/
function ExtractReverseName( nameLine, jxPerson )
{
	var nameSet = false;
	
	This.DebugTrace( "Name line: " + nameLine );
	
	nameLine = jxtools.RemoveConjunctions( nameLine );
	
	This.DebugTrace( "Name line after: " + nameLine );
	
	var parts = stools.TokenizeLine( nameLine, 1 );
	var num = parts.length;
	
	if ( num == 2 )
	{
		jxPerson.SurName = parts[0]; //last
		jxPerson.GivenName = parts[1]; //first

		
		nameSet = true;
	}
	else if ( num == 3 )
	{
		jxPerson.SurName = parts[0]; //last
		jxPerson.GivenName = parts[1]; //first
		
		if ( jxtools.IsSuffix( parts[2] ) )
		{

			jxPerson.Suffix = parts[2];
		}
		else
		{
			jxPerson.MiddleName = parts[2];
		}
		
		nameSet = true;
	}
	else if ( num == 4 )
	{
		jxPerson.SurName = parts[0]; //last
		jxPerson.GivenName = parts[1]; //first
		
		if ( jxtools.IsSuffix( parts[3] ) )
		{
			jxPerson.MiddleName = parts[2];
			jxPerson.Suffix = parts[3];
		}
		else
		{
			jxPerson.MiddleName = parts[2] + " " + parts[3];
		}
		
		nameSet = true;
	}
	
	return nameSet;
}


