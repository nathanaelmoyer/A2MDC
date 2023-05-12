<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml">
	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	05/08/09 MAH - Created
	05/11/09 MAH - More sections added
	05/19/09 MAH - Add, Edit, Delete links
	05/21/09 MAH - Renamed "Incident Overview" to "Incident Header"
		     - Added Narratives
	05/27/09 MAH - Some of the header fields were not bold
		     - Only display ContactMethod if the value element has a value
	05/30/09 MAH - Pictures
	06/01/09 MAH - Fixed right justification of Edit/Delete links
						  - Spelling error
						  - Change MICR Status to green if the text is "READY"
    07/08/09 MAH - Person Involvement/RoleCode
    07/17/09 MAH - Property
    08/03/09 MAH - Documents
						  - Changed "Picture" to "Pictures"
    08/04/09 MAH - Support for View links
						  - Right justified links for Pictures & Documents
    08/04/09 MAH - Added MO to Offense
						  - Move Property before Documents
    08/12/09 MAH - InvolvementRoles
						  - Hide "occurred between" if no dates are entered
    08/14/09 MAH - Changed title People Involved->Involvements
    08/16/09 MAH - Changed various tags to new transformed code->description tags
						  - Hid Arrests/Charges columns for now
    10/05/09 MAH - Added ReportTime
    10/06/09 MAH - Additional Incident header fields
    11/18/09 MAH - Changed "MICR Code" to "File Class"
		 - Added user defined fields to incident header
    12/02/09 MAH - Removed changing MICR status to green if the text contains "ready"
    12/29/09 MAH - Use translated version of Involvement (RoleCodeDesc) instead of RoleCode.
    01/11/09 MAH - Added MO section.
		 - Removed MO from Offense section.
    02/24/10 MAH - Added evidence flag if Category is not blank.
    04/15/10 MAH - Added ticket section.
		 - Added fields to MO section.

  -->
	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" />
	<!-- *************************** -->

	<xsl:template name="IncidentReport_Single" match="IncidentReport" mode="single">
	<!--xsl:template name="IncidentReport_Single" match="IncidentReport"-->

		<!-- Incident Header -->
		<xsl:if test="count(Incident)>0">
			<xsl:call-template name="secIncident"/>
		</xsl:if>
		
		<!-- Sections -->
		<xsl:if test="count(Section)>0">
			<xsl:apply-templates select="Section"/>
		</xsl:if>
		
	</xsl:template>

  <!-- *************************** -->
  	<xsl:template name="Section" match="Section">

			<!-- retrieve the ID value, ex: <Section ID="Person">  -->
			<xsl:variable name="secID" select="@ID"/>
			<!--p>DEBUG: <xsl:value-of select="$secID"/></p-->
			<xsl:choose>
				<xsl:when test="contains($secID, 'IncidentSituation')">
					<xsl:call-template name="secIncidentSituation"/>
				</xsl:when>			
				<xsl:when test="contains($secID,'IncidentSupplement')">
					<xsl:call-template name="secSupplement"/>
				</xsl:when>

				<xsl:when test="contains($secID,'MO')">
					<xsl:call-template name="secMO"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Offense')">
					<xsl:call-template name="secOffense"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Location')">
					<xsl:call-template name="secLocation"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Person')">
					<xsl:call-template name="secPerson"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Vehicle')">
					<xsl:call-template name="secVehicle"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Ticket')">
					<xsl:call-template name="secTicket"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Property')">
					<xsl:call-template name="secProperty"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Documents')">
					<xsl:call-template name="secDocuments"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Pictures')">
					<xsl:call-template name="secPictures"/>
				</xsl:when>
				<xsl:when test="contains($secID,'IncidentNarrative')">
					<xsl:call-template name="secIncidentNarrative"/>
				</xsl:when>

			</xsl:choose>

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secIncident" match="Incident">
			<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/><xsl:with-param name="AgencyCode" select="@AgencyCode"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/><xsl:with-param name="AgencyCode" select="@AgencyCode"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/><xsl:with-param name="AgencyCode" select="@AgencyCode"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="InvestigativeTime"><xsl:value-of select="InvestigativeTime"/></xsl:variable> 

			<!--<p class="ctc_page_subtitle_1">Incident Header</p>-->
			<xsl:choose>
				<xsl:when test="(string-length(@AgencyCode)>0)">
					<p class="ctc_page_subtitle_1">
					Incident Header (Agency: 
					<xsl:value-of select="@AgencyCode"/>&#160;
					<xsl:value-of select="@AgencyORI"/>)
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="ctc_page_subtitle_1">Incident Header</p>
				</xsl:otherwise>
			</xsl:choose>
				
			    <!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
			    <table width="100%" border="0" cellpadding="1" cellspacing="0">
				  <tr class="{$RowClass}">
					<td class="{$DataClass}" width="7%">Report #:</td>
					<td class="{$DataClass}" width="26%"><strong><xsl:value-of select="IncidentNumber"/></strong></td>
					<td class="{$DataClass}" width="13%">Reporting Officer: </td>
					<td class="{$DataClass}" width="19%"><strong><xsl:value-of select="ReportingOfficer"/></strong></td>
					<td class="{$DataClass}" width="17%">Status:</td>
					<td class="{$DataClass}" width="18%"><strong><xsl:value-of select="StatusDescription"/></strong></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Date/Time:</td>
					<td class="{$DataClass}"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ReportDate"/></xsl:call-template>&#160;&#160;<xsl:value-of select="ReportTime"/></strong></td>
					<td class="{$DataClass}">Officer2: </td>
					<td class="{$DataClass}"><strong><xsl:value-of select="Officer2"/></strong></td>
					<td class="{$DataClass}">For State:</td>
						<!--xsl:choose>
							<xsl:when test="(contains(NIBRStatusDescription,'READY') or contains(NIBRStatusDescription,'ready') or contains(NIBRStatusDescription,'Ready'))">
								<td class="{$DataClass}" style="color: #00C040"><strong><xsl:value-of select="NIBRStatusDescription"/></strong></td>
							</xsl:when>
							<xsl:otherwise>
								<td class="{$DataClass}"><strong><xsl:value-of select="NIBRStatusDescription"/></strong></td>
							</xsl:otherwise>	
						</xsl:choose-->	
					<td class="{$DataClass}"><strong><xsl:value-of select="NIBRStatusDescription"/></strong></td>
					
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Entered:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="EnteredBy"/></strong></td>
					<td class="{$DataClass}">Detective:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="Detective"/></strong></td>
					<td class="{$DataClass}">Edit Status:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="NIBREditDescription"/></strong></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}">Assigned Bureau:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="AssignedDepartment"/></strong></td>
					<xsl:choose>
					  <xsl:when test="(string-length($InvestigativeTime)>0) and starts-with($InvestigativeTime, '00:00')">
					    <td class="{$DataClass}"></td>
					    <td class="{$DataClass}"></td>
					  </xsl:when>
					  <xsl:otherwise>
				        <td class="{$DataClass}">Total Investigative Time:</td>
				        <td class="{$DataClass}"><strong><xsl:value-of select="InvestigativeTime"/></strong></td>
				      </xsl:otherwise>
				    </xsl:choose>
				  </tr>
				  <tr class="{$RowClass}">
				  <xsl:choose>
					<xsl:when test="(string-length(IncidentCategoryDesc)>0)">
						<td class="{$DataClass}">Category:</td>
						<td class="{$DataClass}"><strong><xsl:value-of select="IncidentCategoryDesc"/></strong></td>
						<td class="{$DataClass}">Description:</td>
						<td class="{$DataClass}" colspan="3"><strong><xsl:value-of select="Description"/></strong></td>
					</xsl:when>
					<xsl:otherwise>
						<td class="{$DataClass}">Description:</td>
						<td class="{$DataClass}" colspan="5"><strong><xsl:value-of select="Description"/></strong></td>
					</xsl:otherwise>
				  </xsl:choose>
				  </tr>
				  <xsl:if test="(string-length(FromDate)>0) or (string-length(ToDate)>0)">
					  <tr class="{$RowClass}">
						<td class="{$DataClass}" colspan="6"><strong>Occurred between: <xsl:call-template name="standard_date"><xsl:with-param name="date" select="FromDate"/></xsl:call-template>&#160;<xsl:value-of select="FromTime"/> and <xsl:call-template name="standard_date"><xsl:with-param name="date" select="ToDate"/></xsl:call-template>&#160;<xsl:value-of select="ToTime"/></strong></td>
					  </tr>
				  </xsl:if>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Dispatched:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="DispatchTime"/></strong></td>
					<td class="{$DataClass}">Person Injury?</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="PersonInjuryFlag"/></strong></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Arrival Time:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="ArrivalTime"/></strong></td>
					<td class="{$DataClass}">Prop Damage?</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="PropertyDamageFlag"/></strong></td>
					<td class="{$DataClass}">Status Date:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="StatusDate"/></strong></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Clear Time:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="ClearTime"/></strong></td>
					<td class="{$DataClass}">Fatality?</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="FatalityFlag"/></strong></td>
					<td class="{$DataClass}">Mod Date:</td>
					<td class="{$DataClass}"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="IncidentModifiedDate"/></xsl:call-template></strong></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">City/Twp:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="City"/></strong></td>
					<td class="{$DataClass}">Area:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="AreaDesc"/></strong></td>
					<td class="{$DataClass}">County:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="CountyDesc"/></strong></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Assist ORI:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="AssistForORI"/></strong></td>
					<td class="{$DataClass}">Exceptional Clearance:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="ExceptionalClearanceDesc"/></strong></td>
					<td class="{$DataClass}">Exceptional Clearance Date:</td>
					<td class="{$DataClass}"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ExceptionalClearanceDate"/></xsl:call-template></strong></td>
				  </tr>
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Local Use:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="UserDefined1Desc"/></strong></td>
					<td class="{$DataClass}">Local Use:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="UserDefined2Desc"/></strong></td>
					<td class="{$DataClass}">Local Use:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="UserDefined3Desc"/></strong></td>
				  </tr>
				<xsl:if test="(string-length(CFSNumber)>0)">
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">CFS #:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="CFSNumber"/></strong></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
				  </tr>
				</xsl:if>
				
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Review Status:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="ReviewStatus"/></strong></td>
					<td class="{$DataClass}">Reviewed By:</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="ReviewedBy"/></strong></td>
					<td class="{$DataClass}">Reviewed Date:</td>
					<td class="{$DataClass}"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ReviewedDate"/></xsl:call-template></strong></td>
				  </tr>
				
				  <tr class="{$RowClass}">
					<td class="{$DataClass}">Confidential Incident?</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="LockedFlag"/></strong></td>
					<td class="{$DataClass}">Sealed Incident?</td>
					<td class="{$DataClass}"><strong><xsl:value-of select="SealedFlag"/></strong></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
				  </tr>
				  <tr  class="{$RowClass}">
					<td class="{$DataClass}">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
								<xsl:with-param name="linkclass" select="$LinkClass"/>
							</xsl:call-template>
					</td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
				  </tr>
				</table>
				
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secMO" match="MO">
			
			<p class="ctc_page_subtitle_1">Method of Operation</p>
			
  			<xsl:for-each select="MO">
				<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			    <table width="100%" border="0" cellpadding="1" cellspacing="0">
				<xsl:if test="(string-length(PropertyTakenDesc)>0) or (string-length(PropertyServiceObtainedDesc)>0)">
					<tr class="{$RowClass}">
						<xsl:if test="(string-length(PropertyTakenDesc)>0)">
							<td class="{$DataClass}">Taken:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="PropertyTakenDesc"/></strong></td>
						</xsl:if>
						<xsl:if test="(string-length(PropertyTakenDesc)>0)">
							<td class="{$DataClass}">Obtained: </td>
							<td class="{$DataClass}"><strong><xsl:value-of select="PropertyServiceObtainedDesc"/></strong></td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="(string-length(StructuresAttackedDesc)>0) or (string-length(TargetsDesc)>0)">
					<tr class="{$RowClass}">
						<xsl:if test="(string-length(StructuresAttackedDesc)>0)">
							<td class="{$DataClass}">Struct Attacked:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="StructuresAttackedDesc"/></strong></td>
						</xsl:if>
						<xsl:if test="(string-length(TargetsDesc)>0)">
							<td class="{$DataClass}">Targets:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="TargetsDesc"/></strong></td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="(string-length(PointOfEntry1Desc)>0) or (string-length(PointOfEntry2Desc)>0) or (string-length(PointOfEntry3Desc)>0) or (string-length(PointOfExit1Desc)>0) or (string-length(PointOfExit2Desc)>0) or (string-length(PointOfExit3Desc)>0)">
					  <tr class="{$RowClass}">
						<xsl:if test="(string-length(PointOfEntry1Desc)>0) or (string-length(PointOfEntry2Desc)>0) or (string-length(PointOfEntry3Desc)>0)">
							<td class="{$DataClass}">Point of Entry: </td>
							<td class="{$DataClass}"><strong><xsl:value-of select="PointOfEntry1Desc"/>&#160;<xsl:value-of select="PointOfEntry2Desc"/>&#160;<xsl:value-of select="PointOfEntry3Desc"/></strong></td>
						</xsl:if>
						<xsl:if test="(string-length(PointOfExit1Desc)>0) or (string-length(PointOfExit2Desc)>0) or (string-length(PointOfExit3Desc)>0)">
							<td class="{$DataClass}">Point of Exit:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="PointOfExit1Desc"/>&#160;<xsl:value-of select="PointOfExit2Desc"/>&#160;<xsl:value-of select="PointOfExit3Desc"/></strong></td>
						</xsl:if>
						
					  </tr>
				</xsl:if>
				<xsl:if test="(string-length(DocumentUsedDesc)>0) or (string-length(ForceUsedDesc)>0)">
					  <tr class="{$RowClass}">
						<xsl:if test="(string-length(DocumentUsedDesc)>0)">
							<td class="{$DataClass}">Document:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="DocumentUsedDesc"/></strong></td>
						</xsl:if>
						<xsl:if test="(string-length(ForceUsedDesc)>0)">
							<td class="{$DataClass}">Force:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="ForceUsedDesc"/></strong></td>
						</xsl:if>
					  </tr>
				</xsl:if>
				<xsl:if test="(string-length(WeaponUsedDesc)>0) or (string-length(WeaponUsageDesc)>0) or (string-length(WeaponFeaturesDesc)>0)">
					  <tr class="{$RowClass}">
						<td class="{$DataClass}">Weapon:</td>
						<td class="{$DataClass}" colspan="3"><strong><xsl:value-of select="WeaponUsedDesc"/>&#160;<xsl:value-of select="WeaponUsageDesc"/>&#160;<xsl:value-of select="WeaponFeaturesDesc"/></strong></td>
					  </tr>
				</xsl:if>
				<xsl:if test="(string-length(SuspectActionsDesc)>0) or (string-length(SuspectPretendedDesc)>0)">
					  <tr class="{$RowClass}">
						<xsl:if test="(string-length(SuspectActionsDesc)>0)">
							<td class="{$DataClass}">Suspect Actions:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="SuspectActionsDesc"/></strong></td>
						</xsl:if>
						<xsl:if test="(string-length(SuspectPretendedDesc)>0)">
							<td class="{$DataClass}">Suspect Pretended:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="SuspectPretendedDesc"/></strong></td>
						</xsl:if>
					  </tr>
				</xsl:if>
				<xsl:if test="(string-length(DrugCategoryCode)>0) or (string-length(DrugName)>0)">
					  <tr class="{$RowClass}">
						<xsl:if test="(string-length(DrugCategoryCode)>0)">
							<td class="{$DataClass}">Drug Category:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="DrugCategoryCode"/></strong></td>
						</xsl:if>
						<xsl:if test="(string-length(DrugName)>0)">
							<td class="{$DataClass}">Drug Name:</td>
							<td class="{$DataClass}"><strong><xsl:value-of select="DrugName"/></strong></td>
						</xsl:if>
					  </tr>
				  </xsl:if>
				  <tr  class="{$RowClass}">
					<td class="{$DataClass}">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
								<xsl:with-param name="linkclass" select="$LinkClass"/>
							</xsl:call-template>
					</td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
					<td class="{$DataClass}"></td>
				  </tr>	
				</table>
			</xsl:for-each>
				
			<!--xsl:if test="count(LinkInfo[@Display='Edit'])>0">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr  class="ctc_tbl_row">
				<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="LinkInfo[@Display='Edit']"/>
							<xsl:with-param name="desc">Edit</xsl:with-param>
						</xsl:call-template>
				</td>
			  </tr>
			</table>	
		</xsl:if-->

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secIncidentSituation" match="IncidentSituation">
			<p class="ctc_page_subtitle_1">Additional Situations (NOTE: The main incident is situation 0.)</p>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
				  <tr class="ctc_tbl_headrow">
					<td class="ctc_tbl_center_hdr">#</td>
					<td class="ctc_tbl_center_hdr">Title</td>
					<td class="ctc_tbl_center_hdr">Except. Clear Code</td>
					<td class="ctc_tbl_center_hdr">Except. Clear Date</td>
					<td class="ctc_tbl_center_hdr">Unfounded</td>
					<td class="ctc_tbl_center_hdr">For State</td>
					<td class="ctc_tbl_center_hdr">Edit Status</td>
				  </tr>
				  <xsl:for-each select="IncidentSituation">
					<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
					<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				  
					<tr class="{$RowClass}">
						<td class="{$DataClass}"><xsl:value-of select="SituationNumber"/></td>
						<td class="{$DataClass}"><xsl:value-of select="Description"/></td>
						<td class="{$DataClass}"><xsl:value-of select="ExceptionalClearanceDesc"/></td>
						<td class="{$DataClass}"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ExceptionalClearanceDate"/></xsl:call-template></td>
						<td class="{$DataClass}"><xsl:value-of select="Unfounded"/></td>
						<td class="{$DataClass}"><xsl:value-of select="NIBRStatusDescription"/></td>
						<td class="{$DataClass}"><xsl:value-of select="NIBREditDescription"/></td>
					</tr>
				  </xsl:for-each>
			</table>
		
	</xsl:template>
	
  <!-- *************************** -->
	<xsl:template name="secOffense" match="Offense">
			<p class="ctc_page_subtitle_1">Offenses</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
			  <tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">File Class</td>
				<td class="ctc_tbl_center_hdr">Description</td>
				<!--td class="ctc_tbl_center_hdr">MO</td-->
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			  </tr>
			  
  			<xsl:for-each select="Offense"	>
				<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			    <xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="SituationTitle"><xsl:value-of select="SituationTitle"/></xsl:variable>

			  <tr  class="{$RowClass}">
				<td class="{$DataClass}"><xsl:value-of select="Statute"/></td>
				
				<xsl:if test="(string-length($SituationTitle)=0)">
					<td class="{$DataClass}"><xsl:value-of select="MICRDescription"/></td>
				</xsl:if>
				<xsl:if test="(string-length($SituationTitle)>0)">
					<td class="{$DataClass}">
						<xsl:value-of select="MICRDescription"/>
						&#160;(<xsl:value-of select="$SituationTitle"/>)
					</td>
				</xsl:if>
				
				<!--td class="{$DataClass}"><xsl:value-of select="MO"/></td-->
				<td align="right" class="{$DataClass}">
					<div align="right">
						<xsl:call-template name="maintLinks">
							<xsl:with-param name="elementPath" select="name(current())"/>
							<xsl:with-param name="linkclass" select="$LinkClass"/>
						</xsl:call-template>
					</div>
				</td>
				<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
			  </tr>
			  
			</xsl:for-each>
			
			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			</xsl:if>	
			</table>	
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secLocation" match="Location">
			<p class="ctc_page_subtitle_1">Locations</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
			  <tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Location</td>
				<td class="ctc_tbl_center_hdr">Cross Street</td>
				<td class="ctc_tbl_center_hdr">City</td>
				<td class="ctc_tbl_center_hdr">Common Name</td>
				<!--td class="ctc_tbl_center_hdr">Owner</td-->
				<td class="ctc_tbl_center_hdr" align="right"><div align="right"></div></td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			  </tr>
			  
			<xsl:for-each select="Location"	>
					<xsl:variable name="street" select="StreetName" />
					<xsl:variable name="number" select="StreetNumber" />
					<xsl:variable name="addrFull" select="concat($number,' ', $street)" />
					<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
					<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
					<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 

				  <tr  class="{$RowClass}">
					<td class="{$DataClass}"><xsl:value-of select="$addrFull"/>&#160;<xsl:value-of select="Apartment"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="CrossStreetName"/></td>
					<td class="{$DataClass}"><xsl:value-of select="City"/></td>
					<td class="{$DataClass}"><xsl:value-of select="CommonName"/></td>

					<!--xsl:choose>
						<xsl:when test="count(Person)>0">
							<xsl:variable name="personLast" select="Person/LastName" />
							<xsl:variable name="personFirst" select="Person/FirstName" />
							<xsl:variable name="personMid" select="Person/MiddleName" />
							<xsl:variable name="personFull" select="concat($personLast,', ', $personFirst,' ',$personMid)" />
							<td class="{$DataClass}"><xsl:value-of select="$personFull"/></td>
						</xsl:when>
						<xsl:otherwise><td class="{$DataClass}"></td></xsl:otherwise>
					  </xsl:choose-->
					<td align="right" class="{$DataClass}">
						<div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
								<xsl:with-param name="linkclass" select="$LinkClass"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
				  </tr>
			</xsl:for-each>
			
			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
			</table>
	
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secPerson" match="Person">
			<p class="ctc_page_subtitle_1">Involvement</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
				  <tr class="ctc_tbl_headrow">
					<td class="ctc_tbl_center_hdr">Name</td>
					<td class="ctc_tbl_center_hdr">Sex</td>
					<td class="ctc_tbl_center_hdr">Race</td>
					<td class="ctc_tbl_center_hdr">DOB</td>
					<td class="ctc_tbl_center_hdr">Involvement</td>
					<td class="ctc_tbl_center_hdr">Address</td>
					<td class="ctc_tbl_center_hdr">Phone</td>
					<!--td class="ctc_tbl_center_hdr">Arrests</td>
					<td class="ctc_tbl_center_hdr">Charge</td-->
					<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
					<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
				  </tr>
			
			<xsl:for-each select="Person"	>
			
					<xsl:variable name="personLast" select="LastName" />
					<xsl:variable name="personFirst" select="FirstName" />
					<xsl:variable name="personMid" select="MiddleName" />
					<xsl:variable name="personFull" select="concat($personLast,', ', $personFirst,' ',$personMid)" />
					<xsl:variable name="roleDesc" select="RoleDesc" />
					<xsl:variable name="nameType" select="NameType" />
				    <xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				    <xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
					<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 

				      <tr  class="{$RowClass}">
					    <td class="{$DataClass}"><xsl:value-of select="$personFull"/></td>
					    <td class="{$DataClass}"><xsl:value-of select="Sex"/></td>
					    <td class="{$DataClass}"><xsl:value-of select="Race"/></td>
					  <xsl:choose>
						<xsl:when test="not(contains($roleDesc, 'Officer')) and not($nameType='L')">
							<td class="{$DataClass}"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="DOB"/></xsl:call-template></td>
						</xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>

					    <td class="{$DataClass}"><xsl:value-of select="$roleDesc"/></td>
					
					  <xsl:choose>
						<xsl:when test="count(Location)>0 and count(Location/IsPrimary) > 0 and not(contains($roleDesc, 'Officer')) and not($nameType='L')">
							<xsl:variable name="primaryAddress" select="Location[IsPrimary='Y']" />
							<td><xsl:value-of select="$primaryAddress/StreetNumber"/>&#160;<xsl:value-of select="$primaryAddress/StreetName"/>&#160;<xsl:value-of select="$primaryAddress/Apartment"/></td>
						</xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>
							
					  <xsl:choose>
						<xsl:when test="(count(ContactMethod)>0) and count(ContactMethod/IsPrimary) > 0 and (string-length(ContactMethod/MethodValue) > 0) and not(contains($roleDesc, 'Officer')) and not($nameType='L')">
							<xsl:variable name="primaryContact" select="ContactMethod[IsPrimary='Y']" />
							<td><xsl:value-of select="$primaryContact/MethodType"/>: <xsl:value-of select="$primaryContact/MethodValue"/></td>
						</xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>
	
	<!--
					  <xsl:choose>
						<xsl:when test="count(Arrest)>0"><td></td></xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>
	
					  <xsl:choose>
						<xsl:when test="count(Charge)>0"><td></td></xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>
						
    -->
						<td align="right" class="{$DataClass}">
							<div align="right">
								<xsl:call-template name="maintLinks">
									<xsl:with-param name="elementPath" select="name(current())"/>
									<xsl:with-param name="linkclass" select="$LinkClass"/>
								</xsl:call-template>
							</div>
						</td>
					    <td class="{$RowClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
					  </tr>
				  </xsl:for-each>

			<xsl:if test="$makeAddLink">
			  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
			</table>

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secVehicle" match="Vehicle">
		<p class="ctc_page_subtitle_1">Vehicles</p>
		
		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
		  <tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr">License Plate</td>
			<td class="ctc_tbl_center_hdr">State</td>
			<td class="ctc_tbl_center_hdr">VIN</td>
			<td class="ctc_tbl_center_hdr">Year</td>
			<td class="ctc_tbl_center_hdr">Make</td>
			<td class="ctc_tbl_center_hdr">Model</td>
			<td class="ctc_tbl_center_hdr">Style</td>
			<td class="ctc_tbl_center_hdr">Color</td>
			<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
		  </tr>
		  
		  <xsl:for-each select="Vehicle">
				<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
		  
				  <tr  class="{$RowClass}">
					<td class="{$DataClass}"><xsl:value-of select="PlateTag"/></td>
					<td class="{$DataClass}"><xsl:value-of select="StateCode"/></td>
					<td class="{$DataClass}"><xsl:value-of select="VIN"/></td>
					<td class="{$DataClass}"><xsl:value-of select="VehicleYear"/></td>
					<td class="{$DataClass}"><xsl:value-of select="Make"/></td>
					<td class="{$DataClass}"><xsl:value-of select="Model"/></td>
					<td class="{$DataClass}"><xsl:value-of select="BodyStyle"/></td>
					<td class="{$DataClass}"><xsl:value-of select="Color1"/></td>
					<td align="right" class="{$DataClass}">
						<div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
								<xsl:with-param name="linkclass" select="$LinkClass"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
				  </tr>
		  
		  </xsl:for-each>

			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				  </tr>
			</xsl:if>
		</table>
		
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secDocuments" match="Documents">
		<p class="ctc_page_subtitle_1">Documents</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
			<tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Title</td>
				<!--td class="ctc_tbl_center_hdr">Link</td-->
				<td class="ctc_tbl_center_hdr">Filename</td>
				<td></td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			</tr>
		
		<xsl:for-each select="Documents">
			<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
		
			  <tr class="{$RowClass}">
				<td class="{$DataClass}"><xsl:value-of select="Title"/></td>
				<!--td class="{$DataClass}">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="concat('file:///', FilePath)"/>
							<xsl:with-param name="desc">Download/View</xsl:with-param>	
						</xsl:call-template>
				</td-->
				<td class="{$DataClass}">
					<xsl:if test="AccessAllowed='true'"><xsl:value-of select="Filename"/></xsl:if>
					<xsl:if test="AccessAllowed='false'">DOCUMENT IS CONFIDENTIAL</xsl:if>
				</td>
				<td align="right" class="{$DataClass}">
					<div align="right">
						<xsl:call-template name="maintLinks">
							<xsl:with-param name="elementPath" select="name(current())"/>
							<xsl:with-param name="linkclass" select="$LinkClass"/>
						</xsl:call-template>
					</div>
				</td>
				<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
			  </tr>
   		      <tr class="{$RowClass}">
				<td class="ctc_tbl_data"></td>
		      </tr>

		</xsl:for-each>
			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
		</table>	

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secProperty" match="Property">
		<p class="ctc_page_subtitle_1">Property/Evidence</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
		  <tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr"># </td>
			<td class="ctc_tbl_center_hdr">Storage</td>
			<td class="ctc_tbl_center_hdr">Desc</td>
			<td class="ctc_tbl_center_hdr">Serial #</td>
			<td class="ctc_tbl_center_hdr">Class</td>
			<td class="ctc_tbl_center_hdr">Loss Type</td>
			<td class="ctc_tbl_center_hdr">Value</td>
			<td class="ctc_tbl_center_hdr">Send to State?</td>
			<td class="ctc_tbl_center_hdr"></td>
			<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
		  </tr>

		<xsl:for-each select="Property"	>
			<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 

			<tr class="{$RowClass}">
				<td class="{$DataClass}"><xsl:value-of select="ItemNumber"/></td>
				<td class="{$DataClass}">
					<xsl:if test="string-length(Category) > 0">Y</xsl:if>
				</td>
				<td class="{$DataClass}"><xsl:value-of select="Description"/></td>
				<td class="{$DataClass}"><xsl:value-of select="SerialNumber"/></td>
				<td class="{$DataClass}"><xsl:value-of select="PropertyClassDescription"/></td>
				<td class="{$DataClass}"><xsl:value-of select="PropertyLossDescription"/></td>
				<td class="{$DataClass}"><xsl:value-of select="PropertyValue"/></td>
				<td class="{$DataClass}"><xsl:value-of select="ToNIBRSFlag"/></td>
				<td align="right" class="{$DataClass}">
					<div align="right">
						<xsl:call-template name="maintLinks">
							<xsl:with-param name="elementPath" select="name(current())"/>
							<xsl:with-param name="linkclass" select="$LinkClass"/>
						</xsl:call-template>
					</div>
				</td>
				<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
			</tr>
		
		</xsl:for-each>

			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
		</table>		
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secPictures" match="Pictures">
		<p class="ctc_page_subtitle_1">Pictures</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
			<tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Title</td>
				<td class="ctc_tbl_center_hdr">Preview</td>
				<td class="ctc_tbl_center_hdr">Filename</td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
				<td class="ctc_tbl_center_hdr"></td>
			</tr>
		
		<xsl:for-each select="Pictures">
			<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
		
			<xsl:if test="AccessAllowed='true'">
			  <tr class="{$RowClass}">
				<td class="{$DataClass}"><xsl:value-of select="Title"/></td>
				<td class="{$DataClass}">
				   <xsl:call-template name="incImage" >
					 <xsl:with-param name="source" select="FilePathThumb" />
				   </xsl:call-template>
				</td>
				<td class="{$DataClass}"><xsl:value-of select="Filename"/></td>
				<td align="right" class="{$DataClass}">
					<div align="right">
						<xsl:call-template name="maintLinks">
							<xsl:with-param name="elementPath" select="name(current())"/>
							<xsl:with-param name="linkclass" select="$LinkClass"/>
						</xsl:call-template>
					</div>
				</td>
				<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
			  </tr>
   		      <!--tr class="{$RowClass}">
				<td class="{$DataClass}"></td>
		      </tr-->
		    </xsl:if>

		</xsl:for-each>
			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
		</table>	
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secIncidentNarrative" match="IncidentNarrative">
		<p class="ctc_page_subtitle_1">Narratives</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		
		  <xsl:for-each select="IncidentNarrative">
			<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 

			  <tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr"><xsl:value-of select="Title"/></td>
				<td class="ctc_tbl_center_hdr">Supplement #: <xsl:value-of select="SupplementNumber"/></td>
				<td class="ctc_tbl_center_hdr"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="DateWritten"/></xsl:call-template></td>
				<td class="ctc_tbl_center_hdr"><xsl:value-of select="Officer"/></td>
				<!--td class="ctc_tbl_center_hdr"><xsl:if test="SupplementNumber!='0'">Review Status: <xsl:value-of select="ReviewStatus"/></xsl:if></td-->
			  </tr>
			  <tr class="{$RowClass}">
				<td class="{$DataClass}" colspan="4">
				  <xsl:if test="AccessAllowed='true'"><xsl:value-of select="Narrative" disable-output-escaping="yes"/></xsl:if>
				  <xsl:if test="AccessAllowed='false'">NARRATIVE IS CONFIDENTIAL</xsl:if>
				</td>
			  </tr>
			  <tr class="{$RowClass}">
				<td class="{$DataClass}">
					<xsl:call-template name="maintLinks">
						<xsl:with-param name="elementPath" select="name(current())"/>
						<xsl:with-param name="linkclass" select="$LinkClass"/>
					</xsl:call-template>
				</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
   		      <tr class="{$RowClass}">
				<td class="{$DataClass}"></td>
		      </tr>
		  </xsl:for-each>
		
		  <xsl:if test="$makeAddLink">
			  <tr  class="ctc_tbl_row">
				<td class="ctc_tbl_data">
					<xsl:call-template name="TIMSLink">
						<xsl:with-param name="dest" select="$lnkAdd"/>
						<xsl:with-param name="desc" select="$dispAdd"/>
					</xsl:call-template>
				</td>
			 </tr>
		  </xsl:if>	
		</table>
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secSupplement" match="IncidentSupplement">
			<p class="ctc_page_subtitle_1">Supplement Summary</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
			  <tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Title</td>
				<td class="ctc_tbl_center_hdr">Supplement</td>
				<td class="ctc_tbl_center_hdr">Date</td>
				<td class="ctc_tbl_center_hdr">Officer</td>
				<td class="ctc_tbl_center_hdr">Entered By</td>
				<td class="ctc_tbl_center_hdr">Review Status</td>
				<td class="ctc_tbl_center_hdr">Reviewed By</td>
				<td class="ctc_tbl_center_hdr">Reviewed Date</td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			  </tr>
			  
  			<xsl:for-each select="IncidentSupplement">
  			  <xsl:if test="SupplementNumber!='-1'">
				<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
			    <xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 

			    <tr  class="{$RowClass}">
				  <td class="{$DataClass}"><xsl:value-of select="Description"/></td>
			  	  <td class="{$DataClass}">Supplement #:<xsl:value-of select="SupplementNumber"/></td>
				  <td class="{$DataClass}"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="SupplementDate"/></xsl:call-template></td>
				  <td class="{$DataClass}"><xsl:value-of select="ReportingOfficer"/></td>
				  <td class="{$DataClass}"><xsl:value-of select="EnteredBy"/></td>
				  <td class="{$DataClass}"><xsl:value-of select="ReviewStatus"/></td>
				  <td class="{$DataClass}"><xsl:value-of select="ReviewedBy"/></td>
				  <td class="{$DataClass}"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ReviewedDate"/></xsl:call-template></td>
				  <td class="{$DataClass}"></td>
				  <td class="{$DataClass}"></td>
			    </tr>
			  </xsl:if>	
 			</xsl:for-each>
		  </table>	
	</xsl:template>
	
  <!-- *************************** -->
	<xsl:template name="secTicket" match="Ticket">
		<p class="ctc_page_subtitle_1">Tickets</p>
		
		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<!--table width="100%" border="0" cellpadding="0" cellspacing="0"-->
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
		  <tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr">Ticket</td>
			<td class="ctc_tbl_center_hdr">Type</td>
			<td class="ctc_tbl_center_hdr">Date</td>
			<td class="ctc_tbl_center_hdr">Officer</td>
			<td class="ctc_tbl_center_hdr">Entered</td>
			<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
		  </tr>
		  
		  <xsl:for-each select="Ticket">
				<xsl:variable name="RowClass"><xsl:call-template name="row_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="DataClass"><xsl:call-template name="data_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
				<xsl:variable name="LinkClass"><xsl:call-template name="link_class"><xsl:with-param name="SupplementNumber" select="@SupplementNumber"/><xsl:with-param name="ActiveSupplementNumber" select="@ActiveSupplementNumber"/></xsl:call-template></xsl:variable> 
		  
				  <tr  class="{$RowClass}">
					<td class="{$DataClass}"><xsl:value-of select="TicketNumber"/></td>
					<td class="{$DataClass}"><xsl:value-of select="TicketTypeDesc"/></td>
					<td class="{$DataClass}"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="IssuedDate"/></xsl:call-template>&#160;&#160;<xsl:value-of select="IssuedTime"/></td>
					<td class="{$DataClass}"><xsl:value-of select="ReportingOfficer"/></td>
					<td class="{$DataClass}"><xsl:value-of select="EnteredBy"/></td>
					<td align="right" class="{$DataClass}">
						<div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
								<xsl:with-param name="linkclass" select="$LinkClass"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="{$DataClass}"><div align="right"><xsl:value-of select="@SupplementNumber"/></div></td>
				  </tr>
		  
		  </xsl:for-each>

			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
				    <td class="ctc_tbl_data"></td>
				  </tr>
			</xsl:if>
		</table>
		
	</xsl:template>

  <!-- *************************** -->
  <xsl:template name="TIMSLink">
    <xsl:param name="dest" />
    <xsl:param name="desc" />
	<xsl:param name="linkclass"/>	
      <xsl:if test="string-length($dest) > 0">
        <xsl:if test="string-length($desc) > 0">
          <!--span><a  class="ctc_link" href="{$dest}"><xsl:value-of select="$desc" /></a></span-->
          <span><a  class="{$linkclass}" href="{$dest}"><xsl:value-of select="$desc" /></a></span>
        </xsl:if>
      </xsl:if>
  </xsl:template>

 <!-- *************************** -->  
  <xsl:template name="maintLinks">
	<xsl:param name="elementPath"/>	
	<xsl:param name="linkclass"/>	
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='View'])>0">
			<xsl:call-template name="TIMSLink">
				<xsl:with-param name="dest" select="LinkInfo[@Display='View']"/>
				<xsl:with-param name="desc">View</xsl:with-param>
				<xsl:with-param name="linkclass"><xsl:value-of select="$linkclass" /></xsl:with-param>
			</xsl:call-template>
			&#160;&#160;&#160;&#160;
		</xsl:when>
	</xsl:choose>	
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='Edit'])>0">
			<xsl:call-template name="TIMSLink">
				<xsl:with-param name="dest" select="LinkInfo[@Display='Edit']"/>
				<xsl:with-param name="desc">Edit</xsl:with-param>
				<xsl:with-param name="linkclass"><xsl:value-of select="$linkclass" /></xsl:with-param>
			</xsl:call-template>
			&#160;&#160;&#160;&#160;
		</xsl:when>
	</xsl:choose>	
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='Downloading'])>0">
			<span>Downloading...</span>
			&#160;&#160;&#160;&#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='Error'])>0">
		          <span>Error</span>
			&#160;&#160;&#160;&#160;
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='Delete'])>0">
			<xsl:call-template name="TIMSLink">
				<xsl:with-param name="dest" select="LinkInfo[@Display='Delete']"/>
				<xsl:with-param name="desc">Delete</xsl:with-param>
				<xsl:with-param name="linkclass"><xsl:value-of select="$linkclass" /></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>	
  
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="incImage">
    <xsl:param name="source" />
    <xsl:variable name="imagePath" select="concat('file:///', $source)"/>
    <xsl:if test="string-length($source) > 0">
      <span class="ctc_img"><img src="{$imagePath}" /></span>
    </xsl:if>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="standard_date">
  <!-- Formats YYYY-MM-DD to MM/DD/YYYY.
	   Keeps any other date format in its original format
  -->
		<xsl:param name="date"/>

		<xsl:choose>
			<xsl:when test="substring($date,5,1)='-'">
				<xsl:variable name="day" select="substring($date, 9, 2)"/>
				<xsl:variable name="month" select="substring($date, 6, 2)"/>
				<xsl:variable name="year" select="substring($date, 1, 4)"/>
				<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
		
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="row_class">
		<xsl:param name="SupplementNumber"/>
		<xsl:param name="ActiveSupplementNumber"/>
		<xsl:param name="AgencyCode"/>
		
		<xsl:variable name="Active" select="$SupplementNumber = $ActiveSupplementNumber"/>
		<xsl:variable name="Local"  select="(string-length(@AgencyCode) = 0)"/>
		<xsl:choose>
			<xsl:when test="$Active and $Local">ctc_tbl_row_supp</xsl:when>
			<xsl:otherwise>ctc_tbl_row</xsl:otherwise>
		</xsl:choose>
		
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="data_class">
		<xsl:param name="SupplementNumber"/>
		<xsl:param name="ActiveSupplementNumber"/>
		<xsl:param name="AgencyCode"/>
		
		<xsl:variable name="Active" select="$SupplementNumber = $ActiveSupplementNumber"/>
		<xsl:variable name="Local"  select="(string-length(@AgencyCode) = 0)"/>
		<xsl:choose>
			<xsl:when test="$Active and $Local">ctc_tbl_data_supp</xsl:when>
			<xsl:otherwise>ctc_tbl_data</xsl:otherwise>
		</xsl:choose>
		
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="link_class">
		<xsl:param name="SupplementNumber"/>
		<xsl:param name="ActiveSupplementNumber"/>
		<xsl:param name="AgencyCode"/>
		
		<xsl:variable name="Active" select="$SupplementNumber = $ActiveSupplementNumber"/>
		<xsl:variable name="Local"  select="(string-length(@AgencyCode) = 0)"/>
		<xsl:choose>
			<xsl:when test="$Active and $Local">ctc_link_supp</xsl:when>
			<xsl:otherwise>ctc_link</xsl:otherwise>
		</xsl:choose>
		
  </xsl:template>

  <!-- *************************** -->
</xsl:stylesheet>
