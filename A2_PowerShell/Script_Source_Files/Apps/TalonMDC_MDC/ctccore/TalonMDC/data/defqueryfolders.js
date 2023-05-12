/*
This file defines which folders are created when a new query is sent.
Its location is <Talon>/data/defqueryfolders.js

05/06/09	
Changed LEIN folder to include new CCW messages

12/21/07	
Changed LEIN folder to include SOR messages

9/20/07
Changed the 'LEIN' folder's test for NLETS messages to a 'contains' test.  This
will make the LEIN folder include messages from Canadia.

12/11	
Court Cases folder should not ignore the word 'Case' when looking for NAM/DOB etc.
Fix: Corrections folder was ignoring CMIS messages
Fix: Property folder was looking for BWI Pawn - now space is removed.

12/8	
+ Added the method SetReGroupPeers(boolean) to folders.  Use when you don't want the Grp
	logic to be used.  This setting is true by default.
+ Property folder stopped including redundant IDs
	Requires Talon version 1.29.15 and later.
		
12/7	Added 'Case' to the list of things to ignore when finding a person's addresses.
		Added minimum number of sub properties to Address query to filter out 'blank' addresses.
		Requires Talon versions 1.29.13 and later.

11/29	Include NAM/RSX/DOB in the following folders:
		Accidents,Addresses,Arrests,Corrections,Court Cases,Incidents,Property
		Requires Talon versions 1.29.11 and later

8/25	Changed the Canadian folder to also include items with a Source of Canada

6/6		Changed one of the Canadian matches from ...C to ...CN
		Added a match for FROM CANADA -

5/24	Added Canada folder to catch LEIN and NLETS messages.
		No TP examples were available.

5/18	The Driver/Vehicle folder now includes associated files.

5/17/06 Added "Weapons" and "Criminal History" folder.
		Added SOS messages to LEIN folder
		Added PPO messages to LEIN folder

4/25/06 Original Version copied from TalonEngine.  Minor additions and changes made
		per MSP's request.
		

		
*/

//Enable/Disable the NAM/RSX/DOB inclusions
var EnableAddPostProcessExtractions=true;



var childLevel="Child";
var thisLevel="This";
var typeLocalName="LocalName";
var typeProperty="Property";
var typeDeepProperty="DeepProperty";
var typeAttr="Attr";
var searchMatch="Match";
var searchContains="Contains";

var query;



AddAccidents();
AddAddresses();
AddArrests();
AddCanadia();
AddCourtCases();
AddCorrections();
AddCriminalHistory();
AddDriverVehicle();
AddIncidents();
AddLEIN();
AddOutOfStateHACK();
AddPACCPAAM();
AddPeople();
AddPhotos();
AddProperty();
AddResponses();
AddWeapons();



function AddPostProcessExtractions( query, ignoreList )
{
	if ( EnableAddPostProcessExtractions )
	{
		query.AddPostProcessInstruction( "InjectXML", "Type,Path,Ignore,RequireSearchHit","Search,Person/PersonName," + ignoreList + ",True" );
		query.AddPostProcessInstruction( "InjectXML", "Type,Path,Ignore,RequireSearchHit","Search,Person/PersonBirthDate," + ignoreList + ",True" );
		query.AddPostProcessInstruction( "InjectXML", "Type,Path,Ignore,RequireSearchHit","Search,Person/PersonPhysicalDetails," + ignoreList + ",True" );	
	}
}


function AddPostProcessExtractionsIncident( query )
{
	AddPostProcessExtractions( query, "Record" );
}


function AddPostProcessExtractionsPerson( query )
{
	AddPostProcessExtractionsPerson( query, true );
}

function AddPostProcessExtractionsPerson( query, ignoreCase)
{
	var ignoreList = "Activity;Incident";
	
	if (ignoreCase)
		ignoreList = ignoreList + ";Case";

	AddPostProcessExtractions( query, ignoreList );
}

function AddAccidents()
{
	/*Accidents*/
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Accident",null,null, MC );
	
	AddPostProcessExtractionsIncident(query);
	
	
	/*
	Mar 30, 2006 ambrandt:
	Currently this is passed from the XQUERY class to the XQueryOwner in TSConditional folder, where it is added to the "hit" XML.
	Later it will be converted into proper, displayable XML
	
	11/29/06: Added the 'Parent' attribute so that we don't inject file lists into the elements
			  we inject using the call above.
	*/
	var instruction = query.AddPostProcessInstruction( "InjectXML", "Type,Key,Parent","Relation,FileList,Accident" );
	instruction.AddComment( "Items in this folder, will include the file list from their parent records.\nNote that this happens in 2 places - the TSConditionalFolder keeps a copy of each instruction, but does NOT affect the original record.\nThe TUIDisplay processor looks for these tags and injects the relevent XML.");
	
	parent.AddFolder( This.CreateConditionalFolder( "Accidents", false, query, true, true ) );
}


function AddAddresses()
{
	/*Address*/
	query = XQUERY.CreateQueryBranch( childLevel, typeLocalName, "LocationAddress", null, null, MC );
	query.SetAttrInt( query.X_ATTR_MinimumSubPropsWithValue, 3 );
	
	AddPostProcessExtractionsPerson(query);
	
	//The mere presence of the InjectXML element is enough to get TSConditionalFolder to set the InjectXML/@ID attribute.
	query.AddPostProcessInstruction( "InjectXML", "", "" );
	
	parent.AddFolder( This.CreateConditionalFolder( "Addresses", false, query, true, true ) );
}


function AddArrests()
{
	/*Arrests*/
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Arrest",null,null, MC );
	
	AddPostProcessExtractionsIncident(query);
	
	parent.AddFolder( This.CreateConditionalFolder( "Arrests", false, query, true, true ) );
}


function AddCanadia()
{
	//The main query looks for messages
	var messageQuery = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Message",null,null, MC );
	messageQuery.GetElement().SetMaxDepth(1);
	
	//Create sub queries for the content	
	//12/24/07 var nletsCanada = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"RESPONSE FROM CANADIAN SYSTEM",MC );
	var leinForwarded = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"FORWARDED TO CN",MC );
	//12/24/07 var nlets2 = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"FROM CANADA -",MC );
	
	//Create a query that will hold the content queries.  It will OR the querries under it.
	var contentQuery = This.CreateXQUERY();
	contentQuery.AddComment( "Collect any items that match some specified content." );
	contentQuery.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
				
	//Add the content queries - they will be OR'd together.
	//12/24/07 contentQuery.AddSubElement(nletsCanada);
	contentQuery.AddSubElement(leinForwarded);
	//12/24/07 contentQuery.AddSubElement(nlets2);
	
	//Add the content query to the main query			
	messageQuery.AddSubElement( contentQuery );
	
	
	//8/25/06: Also include items with a source of Canada
	
	var canadaSrcQuery = XQUERY.CreateQueryBranch(childLevel,typeAttr,"Source",searchMatch,"Canada",MC );
	var canadaSrcQuery2 = XQUERY.CreateQueryBranch(childLevel,typeAttr,"Source",searchMatch,"NLETS - Canada",MC );
	
	query = This.CreateXQUERY();
	query.AddComment( "Canadia folder holds both messages with specific content or items with a source of Canada." );
	query.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
		
	//Add them to the top query
	query.AddSubElement( messageQuery );
	query.AddSubElement( canadaSrcQuery );
	query.AddSubElement( canadaSrcQuery2 );

	var folder = This.CreateConditionalFolder( "Canada", false, query, true, true );
	folder.SetReGroupPeers(false);
	
	parent.AddFolder( folder );
}


function AddCorrections()
{
	/*Corrections*/            
	var correctionsQuery = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Corrections",null,null, MC );
	var cmisQuery = XQUERY.CreateQueryBranch(childLevel,typeAttr,"Source",searchMatch,"CMIS",MC );
				
	query = This.CreateXQUERY();
	query.AddComment( "Corrections folder holds both Corrections tags from records and CMIS responses from LEIN messages." );
	query.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
							
	query.AddSubElement(correctionsQuery);
	query.AddSubElement(cmisQuery);
	
	AddPostProcessExtractionsIncident(query);
	query.AddPostProcessInstruction( "InjectXML", "Type,Path,Ignore,RequireSearchHit","Search,Message/Description,Record,True" ); //AMBCUR
				
	parent.AddFolder( This.CreateConditionalFolder( "Corrections", false, query, true, true ) );
}

function AddCourtCases()
{
	//Court Cases
	
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Case",null,null, MC );
	AddPostProcessExtractionsPerson(query, false);
	parent.AddFolder( This.CreateConditionalFolder( "Court Cases", false, query, true, true ) );
}


function AddCriminalHistory()
{
	
	//The main query looks for messages
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Message",null,null, MC );
	query.GetElement().SetMaxDepth(1);
	
	//Create sub queries for the content	
	var leinCHRMessage = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"CRIMINAL HISTORY RECORD RESPONSES",MC );
	var ncicCHRMessage = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"NUMBER OF RECORDS FOR PERSONS BORN PRIOR TO 1956 ARE",MC );
	var ncicIIIMessage = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"THIS NCIC INTERSTATE IDENTIFICATION INDEX ",MC );
	
	//Create a query that will hold the content queries.  It will OR the querries under it.
	var contentQuery = This.CreateXQUERY();
	contentQuery.AddComment( "Collect any items that match some specified content." );
	contentQuery.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
				
	//Add the content queries - they will be OR'd together.
	contentQuery.AddSubElement(leinCHRMessage);
	contentQuery.AddSubElement(ncicCHRMessage);
	contentQuery.AddSubElement(ncicIIIMessage);
	
	//Add the content query to the main query			
	query.AddSubElement( contentQuery );
	
	parent.AddFolder( This.CreateConditionalFolder( "Criminal History", false, query, true, true ) );
}


function AddDriverVehicle()
{
	/*Vehicles and SOS*/
	var vehicleQuery = XQUERY.CreateQueryBranch(childLevel, typeLocalName, "Vehicle", null, null, MC );
	var sosQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"SOS",MC );
	var nletsQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"NLETS",MC );
	
	/*MIDRS Person records*/
	var midrsQuery = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Record",null,null, MC );
	var midrsSource = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"MIDRS",MC );
	midrsQuery.AddSubElement(midrsSource);
	
	
	
	query = This.CreateXQUERY();
	query.AddComment( "Driver/Vehicle folder holds both SOS Messages, MIDRS responses and Vehicle tags from TalonPoints." );
	query.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
	
	query.AddSubElement(vehicleQuery);
	query.AddSubElement(sosQuery);
	query.AddSubElement(nletsQuery);
	query.AddSubElement(midrsQuery);
	
	var instruction = query.AddPostProcessInstruction( "InjectXML", "Type,Key","Relation,FileList" );            
	instruction.AddComment( "Items in this folder, will include the file list from their parent records.\nNote that this happens in 2 places - the TSConditionalFolder keeps a copy of each instruction, but does NOT affect the original record.\nThe TUIDisplay processor looks for these tags and injects the relevent XML.");	
	var vehFolder = This.CreateConditionalFolder( "Driver/Vehicle", false, query, true, false );
	vehFolder.SetGroupingTag("DriverVehicle");
	vehFolder.SetReGroupPeers(false);
	
	parent.AddFolder( vehFolder );
}


function AddIncidents()
{
	/*Incidents*/
	var activityQuery = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Activity",null,null, MC );
	var	incidentQuery = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Incident",null,null, MC );
	
	var query = This.CreateXQUERY();
	query.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
	
	query.AddSubElement(activityQuery);
	query.AddSubElement(incidentQuery);
	
	AddPostProcessExtractionsIncident(query);
	
	parent.AddFolder( This.CreateConditionalFolder( "Incidents", false, query, true, true ) );
}


function AddLEIN()
{
	/*LEIN*/
	//The main query looks for messages
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Message",null,null, MC );
	query.GetElement().SetMaxDepth(1);
	
	
	var sourceQuery = This.CreateXQUERY();
	sourceQuery.AddComment( "Collect any items that are from the LEIN host computer.  Includes NCIC etc." );
	sourceQuery.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
	
				
	//Create sub queries for the sources
	var leinSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"LEIN",MC );
	var cmisSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"CMIS",MC );
	var ncicSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"NCIC",MC );
	var nletsSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchContains,"NLETS",MC );	
	var sosSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"SOS",MC );		
	var sorSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"SOR",MC );	
	var ccwSourceQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"LGWCCW",MC );	

	//Add the sources to the sub query
	sourceQuery.AddSubElement(leinSourceQuery);
	sourceQuery.AddSubElement(cmisSourceQuery);
	sourceQuery.AddSubElement(ncicSourceQuery);
	sourceQuery.AddSubElement(nletsSourceQuery);
	sourceQuery.AddSubElement(sosSourceQuery);
	sourceQuery.AddSubElement(sorSourceQuery);
	sourceQuery.AddSubElement(ccwSourceQuery);
	

	//PPO messages go in the LEIN folder also Added:5-17-06
	var ppoMessage = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"LEIN PPO DATABASE RESPONSE",MC );
	
	
	var sourceOrContentQuery = This.CreateXQUERY();
	sourceOrContentQuery.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );			
	sourceOrContentQuery.AddSubElement( sourceQuery );
	sourceOrContentQuery.AddSubElement( ppoMessage );	
				
				
	query.AddSubElement( sourceOrContentQuery );
	
	parent.AddFolder( This.CreateConditionalFolder( "LEIN", false, query, true, true ) );
}


function AddOutOfStateHACK()
{	
	/*
	Hack:
	Currently (4/27/06) TPs do not tell (nor know) their location, so we cannot implement this as we would like.
	Ideally, we would set a state flag on the message and do a NOT this state comparison.
	
	Instead, we will have to look for all known (currently 2) out of state TPs.
	*/
	var srcNORIS = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"OH NORIS", MC );
	var srcNORISMug = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"OH NORIS Mugshots", MC );
	
	query = This.CreateXQUERY();
	query.AddComment( "Currently, the only out of state TPs are from NORIS.  This hack catches NORIS replies." );
	query.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
	

	query.AddSubElement( srcNORIS );
	query.AddSubElement( srcNORISMug );
	
	var folder = This.CreateConditionalFolder( "Out of State", false, query, true, true );
	folder.SetReGroupPeers(false);
	parent.AddFolder( folder );
}

function AddPACCPAAM()
{
	var queryRecord = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Record",null,null, MC );            
	queryRecord.GetElement().SetMaxDepth(1);
	
	var subQuery = XQUERY.CreateQueryBranch(thisLevel,typeAttr,"Source",searchMatch,"PACCPAAM",MC );
	queryRecord.AddSubElement( subQuery );
	
	var folder = This.CreateConditionalFolder( "PACCPAAM", false, queryRecord, true, true );
	folder.SetReGroupPeers(false);
	parent.AddFolder( folder );
}

function AddPeople()
{
/*Person Folder*/
	query = XQUERY.CreateQueryBranch( childLevel, typeLocalName, "Person", null, null, MC );
	query.GetElement().SetMaxDepth(2);
	var folder = This.CreateConditionalFolder( "People", false, query, true, true );
	folder.SetReGroupPeers(false);
	parent.AddFolder( folder );
}


function AddPhotos()
{
	/*Photos*/
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Photo",null,null, MC );
	var folder = This.CreateConditionalFolder( "Photos", false, query, true, true );
				
	//Since we're collecting 'real' items, let them do their display thing.
	folder.SetUseCollectedViewItems( false );
	folder.SetAllowCaching(false);
	folder.SetReGroupPeers(false);
	parent.AddFolder( folder );
}


function AddProperty()
{
	query = XQUERY.CreateQueryBranch( childLevel, typeLocalName, "Activity", null, null, MC );

	var pawnQuery = XQUERY.CreateQueryBranch( childLevel, typeDeepProperty, "IDSourceText", searchMatch, "BWIPawn", MC );
	pawnQuery.GetElement().SetTestOnly(true); //Don't add IDSourceText tags to the results
	query.AddSubElement(pawnQuery);	
	
	
	AddPostProcessExtractionsIncident(query);
	
	var folder = This.CreateConditionalFolder( "Property", false, query, true, true );	
	parent.AddFolder( folder );
}


function AddResponses()
{
	/*Responses*/
	var queryMessage = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Message",null,null, MC );
				 
	var queryMiscInfo = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"MiscInfoDisplayable",null,null, MC );
	queryMiscInfo.GetElement().SetMaxDepth(1);
	
	var queryMiscFile = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"MiscFileDisplayable",null,null, MC );
	queryMiscFile.GetElement().SetMaxDepth(1);
				
	var queryRecord = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Record",null,null, MC );            
	queryRecord.GetElement().SetMaxDepth(1);
				
	var notTalonOrigin = XQUERY.CreateQueryBranch( thisLevel, typeAttr, "Origin", searchMatch, "Talon", MC );
	notTalonOrigin.GetElement().GetTest(0).SetAttrBool( "NegativeTest", true );
				
	var recordNotTalon = This.CreateXQUERY();
	recordNotTalon.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_AND );
	recordNotTalon.AddSubElement( queryRecord );
	recordNotTalon.AddSubElement( notTalonOrigin );
				
	query = This.CreateXQUERY();
	query.AddComment( "Responses collect Messages, Records or MiscInfos that are not generated locally (Origin=Talon)" );
	query.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
				
	query.AddSubElement( queryMessage );
	query.AddSubElement( queryMiscInfo );
	query.AddSubElement( queryMiscFile );
	query.AddSubElement( recordNotTalon );
	
	var responsesFolder = This.CreateConditionalFolder( "Responses", true, query, true, false );
	responsesFolder.SetUseCollectedViewItems( false );
	parent.AddFolder( responsesFolder );
}


function AddWeapons()
{
	
	//The main query looks for messages
	query = XQUERY.CreateQueryBranch(childLevel,typeLocalName,"Message",null,null, MC );
	query.GetElement().SetMaxDepth(1);
	
	//Create sub queries for the content
	
	var aprsMessage = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"MSP Firearms Records",MC );
	var ccwMessage = XQUERY.CreateQueryBranch(childLevel,typeProperty,"MessageText",searchContains,"LICENSE TO CARRY A CONCEALED PISTOL (CCW)",MC );
	
	var contentQuery = This.CreateXQUERY();
	contentQuery.AddComment( "Collect any items that match some specified content." );
	contentQuery.SetAttrStr( XQUERY.X_ATTR_Operator, XQUERY.OPERATOR_OR );
				
	contentQuery.AddSubElement(aprsMessage);
	contentQuery.AddSubElement(ccwMessage);
	
				
	query.AddSubElement( contentQuery );
	
	parent.AddFolder( This.CreateConditionalFolder( "Weapons", false, query, true, true ) );
}













