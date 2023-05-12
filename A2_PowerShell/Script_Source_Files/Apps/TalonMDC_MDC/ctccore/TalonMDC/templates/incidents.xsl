<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data templates
	   04/26/06 MAH - Added Activity
	   04/26/06 MAH - Added query title
	   12/07/06 MAH - Added check for Person info
	   01/20/09 MAH - Added Property
	   01/22/09 MAH - Added property description
  -->
  <!-- *************************** -->

<xsl:import href="incident.xsl" />
<xsl:import href="activity.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Incidents_Single" match="Incidents" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:choose>
		<xsl:when test="count(PersonName)>0">
				<p class="ctc_page_subtitle_1">Incident and Activity Summary</p>
				<table width="100%">
					  <tr class="ctc_tbl_headrow">
						<th class="ctc_tbl_center_hdr">Date</th>
						<th class="ctc_tbl_center_hdr">Type</th>
						<th class="ctc_tbl_center_hdr">Description</th>
						<th class="ctc_tbl_center_hdr">ID</th>
						<th class="ctc_tbl_center_hdr">Source</th>
					  </tr>
			
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:call-template name="PersonInfo"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'IncidentGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Incident')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'ActivityGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Activity')">
							<xsl:apply-templates select="." mode="case"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				
				</table>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="Incident_Table">
				<xsl:with-param name="node" select="//Incident"/>
			</xsl:call-template>
			<xsl:if test="count(//Activity)>0">
				<xsl:call-template name="ActivityTbl">
					<xsl:with-param name="node" select="//Activity"/>
					<xsl:with-param name="heading">Activity Summary</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

    <xsl:call-template name="fldr_footer"/>


  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="IncidentGrp" match="IncidentGrp">
	  <xsl:call-template name="IncidentList">
		  <xsl:with-param name="node" select="./Incident"/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Incident" match="Incident">
	  <xsl:call-template name="IncidentList">
		  <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="IncidentList">
	<xsl:param name="node" />
	
	   <xsl:for-each select="$node" >
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		</tr>
	  </xsl:for-each>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="ActivityGrp" match="ActivityGrp">
	  <xsl:call-template name="ActivityList">
		  <xsl:with-param name="node" select="./Activity"/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Activity" match="Activity" mode="case">
	  <xsl:call-template name="ActivityList">
		  <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="ActivityList" >
	<xsl:param name="node" />

		<xsl:for-each select="$node">
			<xsl:variable name="tagID" select="ActivityID/ID"/>
			<xsl:variable name="tagDate" select="ActivityDate"/>
			<xsl:variable name="tagType" select="ActivityTypeText"/>
			<xsl:variable name="tagDesc" select="ActivityDescriptionText"/>
			<xsl:variable name="tagOrgName" select="ActivityReportingOrganization/OrganizationName"/>
			<xsl:variable name="tagOrgCity" select="ActivityReportingOrganization/LocationAddress/LocationCityName"/>
			<xsl:variable name="tagOrgSt" select="ActivityReportingOrganization/LocationAddress/LocationStateCode.fips5-2Alpha"/>

			<tr class="ctc_tbl_row" valign="top">
				<td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagDate"/></xsl:call-template></td>
				<td class="ctc_tbl_data"><xsl:value-of select="$tagType"/></td>
				<td class="ctc_tbl_data">
					<xsl:if test="count($tagDesc)>0"><xsl:value-of select="$tagDesc"/></xsl:if>
				</td>
				<td class="ctc_tbl_data"><xsl:value-of select="$tagID"/></td>
			</tr>
			<xsl:if test="count(ActivityReportingOrganization)>0">
				<tr class="ctc_tbl_row">
					<td></td>
					<td></td>
					<td class="ctc_tbl_data">
						<xsl:value-of select="$tagOrgName"/>&#160;in&#160;
						<xsl:value-of select="$tagOrgCity"/>,&#160;
						<xsl:value-of select="$tagOrgSt"/>
					</td>
				</tr>
			</xsl:if>
		</xsl:for-each>

  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="PersonInfo">
	
	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(following-sibling::PersonBirthDate)" />
	<xsl:variable name="countPhysicalRace" select="count(following-sibling::PersonPhysicalDetails/PersonRaceText)" />
	<xsl:variable name="countPhysicalSex" select="count(following-sibling::PersonPhysicalDetails/PersonSexText)" />

		<tr class="ctc_tbl_row">
			<td colspan="5"><hr/></td>
		</tr>
		<tr class="ctc_tbl_row">
			<td class="ctc_tbl_data_em" colspan="5" align="center">
				( <xsl:value-of select="PersonSurName"/>, <xsl:value-of select="PersonGivenName"/>, <xsl:value-of select="PersonMiddleName"/>&#160;
				DOB: 
			<xsl:choose>
				<xsl:when test="$countDOB > 0"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="following-sibling::PersonBirthDate"/></xsl:call-template></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
				Race: 
			<xsl:choose>
				<xsl:when test="$countPhysicalRace > 0"><xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonRaceText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			Sex: 
			<xsl:choose>
				<xsl:when test="$countPhysicalSex > 0"><xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonSexText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			)
			</td>
		</tr>
  </xsl:template>

<!-- *************************** -->
  <xsl:template name="Property_Single">
	<xsl:param name="nodeMode" />
 
	<xsl:variable name="txtNA">N/A</xsl:variable>
	
	   <xsl:for-each select="$nodeMode" >
		
	    <p class="ctc_page_subtitle_1">Property: <xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template>&#160;<xsl:value-of select="ActivityTypeText"  />&#160;<xsl:value-of select="ActivityID/ID"  /></p>
	    <table width="100%" class="ctc_tbl_row">
		      <tr class="ctc_tbl_row">
			<td class="ctc_tbl_data">Date:
			<xsl:choose>
			<xsl:when test="count(ActivityDate)>0"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			<td class="ctc_tbl_data">Activity Type: 
			<xsl:choose>
			<xsl:when test="count(ActivityTypeText)>0"><strong><xsl:value-of select="ActivityTypeText" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			<td class="ctc_tbl_data">ID: 
			<xsl:choose>
			<xsl:when test="count(ActivityID/ID)>0"><strong><xsl:value-of select="ActivityID/ID" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
		      </tr>
		      <tr class="ctc_tbl_row">
			<td class="ctc_tbl_data">Description:
			<xsl:choose>
			<xsl:when test="count(Property/PropertyDescriptionText)>0"><strong><xsl:value-of select="Property/PropertyDescriptionText" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			<td class="ctc_tbl_data">Type:
			<xsl:choose>
			<xsl:when test="count(Property/PropertyTypeCode)>0"><strong><xsl:value-of select="Property/PropertyTypeCode" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			<td class="ctc_tbl_data">Disposition: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyDisposition/PropertyDispostionCode)>0"><strong><xsl:value-of select="Property/PropertyDisposition/PropertyDispostionCode" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
		      </tr>
		      <tr class="ctc_tbl_row">
			 <td class="ctc_tbl_data">Model: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyPhysicalDetails/PropertyModelName)>0"><strong><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyModelName" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			 <td class="ctc_tbl_data">Brand: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyPhysicalDetails/PropertyBrandName)>0"><strong><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyBrandName" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			 <td class="ctc_tbl_data">Category: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyPhysicalDetails/PropertyCategoryCode.nibrsPropertyCategory)>0"><strong><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyCategoryCode.nibrsPropertyCategory" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
		     </tr>
		      <tr class="ctc_tbl_row">
			 <td class="ctc_tbl_data">Serial #: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyAssignedIDDetails/PropertySerialID)>0"><strong><xsl:value-of select="Property/PropertyAssignedIDDetails/PropertySerialID" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
		       <td class="ctc_tbl_data">NCIC ID: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyAssignedIDDetails/PropertyNCICID)>0"><strong><xsl:value-of select="Property/PropertyAssignedIDDetails/PropertyNCICID" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
			<td class="ctc_tbl_data">Owner ID:
			<xsl:choose>
			<xsl:when test="count(Property/PropertyAssignedIDDetails/PropertyOwnerAppliedID)>0"><strong><xsl:value-of select="Property/PropertyAssignedIDDetails/PropertyOwnerAppliedID" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
		    </tr>
		    <tr>
			<td class="ctc_tbl_data">Value: 
			<xsl:choose>
			<xsl:when test="count(Property/PropertyValueDetails/PropertyOtherValue/PropertyValueAmount)>0"><strong><xsl:value-of select="Property/PropertyValueDetails/PropertyOtherValue/PropertyValueAmount" /></strong></xsl:when>
			<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			</td>
		    </tr>
	    </table>
		
	  </xsl:for-each>
  </xsl:template>

<!-- *************************** -->
  <xsl:template name="PropertyList">
	<xsl:param name="nodeMode" />
	
	   <xsl:for-each select="$nodeMode" >
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/><xsl:value-of select="ActivityID/IDSourceText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyTypeCode" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyDisposition/PropertyDispostionCode" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyModelName" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyBrandName" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyCategoryCode.nibrsPropertyCategory" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="Property/PropertyValueDetails/PropertyOtherValue/PropertyValueAmount" /></td>
		</tr>
	  </xsl:for-each>
  </xsl:template>

  <!-- *************************** -->
  
</xsl:stylesheet>
