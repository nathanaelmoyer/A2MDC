<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
		06/04/05 MAH	- Removed choose statement
						- Commented out single
  -->
  <!-- *************************** -->
  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>
  <!-- *************************** -->
  
  <xsl:template name="Incident_Table" match="Incident" mode="table" >
	<xsl:param name="caseview" />
	<xsl:param name="node" />
	
	<p class="ctc_page_subtitle_1">Incident Summary</p>
    <table width="100%">
      <tr class="ctc_tbl_headrow">
        <th class="ctc_tbl_center_hdr">Date</th>
        <th class="ctc_tbl_center_hdr">Type</th>
        <th class="ctc_tbl_center_hdr">Description</th>
        <th class="ctc_tbl_center_hdr">ID</th>
        <th class="ctc_tbl_center_hdr">Source</th>
      </tr>

	   <xsl:for-each select="$node" >
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		</tr>
	  </xsl:for-each>
    </table>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Incident_Single" match="Incident" mode="single" >

	<xsl:call-template name="Incident_Info"/>
	<!--xsl:call-template name="Incident_Details"/-->

  </xsl:template>
  
  <!-- *************************** -->
  <xsl:template name="Incident_Info" match="Incident" mode="info" >
	<p class="ctc_page_subtitle_1">Incident Summary</p>
    <table width="100%">
      <tr class="ctc_tbl_headrow">
        <th class="ctc_tbl_center_hdr">Date</th>
        <!--th class="ctc_tbl_center_hdr">Type</th-->
        <th class="ctc_tbl_center_hdr">Description</th>
        <th class="ctc_tbl_center_hdr">ID</th>
        <th class="ctc_tbl_center_hdr">Source</th>
      </tr>

	   <!--xsl:for-each select="$node" -->
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <!--td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td-->
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		</tr>

		<!-- Embedded location record -->
		<xsl:if test="count(./Location) > 0">
			<tr>
				<td colspan="4">
					<blockquote>
					  <xsl:if test="(string-length(Location/LocationAddress/LocationStreet/StreetNumberText) > 0) 
					     or (string-length(Location/LocationAddress/LocationStreet/StreetName) > 0) 
					     or (string-length(Location/LocationAddress/LocationBuilding) > 0)
					     or (string-length(Location/LocationAddress/LocationCityName) > 0) 
					     or (string-length(Location/LocationAddress/LocationStateCode.fips5-2Alpha) > 0) 
					     or (string-length(Location/LocationAddress/LocationStateCode.USPostalService) > 0) 
					     or (string-length(Location/LocationAddress/LocationPostalCodeID) > 0)">
	
						<xsl:variable name="streetNum" select="Location/LocationAddress/LocationStreet/StreetNumberText" />
						<xsl:variable name="streetName" select="Location/LocationAddress/LocationStreet/StreetName" />
						<xsl:variable name="building" select="Location/LocationAddress/LocationBuilding" />
						<xsl:variable name="city" select="Location/LocationAddress/LocationCityName" />
						<xsl:variable name="state" select="Location/LocationAddress/LocationStateCode.fips5-2Alpha" />
						<!--xsl:variable name="zip" select="Location/LocationAddress/LocationStateCode.USPostalService" /-->
						<xsl:variable name="zipOldTag" select="Location/LocationAddress/LocationStateCode.USPostalService" />
						<xsl:variable name="zipNewTag" select="Location/LocationAddress/LocationPostalCodeID/ID" />
						<xsl:variable name="zip" select="concat($zipOldTag,$zipNewTag)" />
						
						<xsl:variable name="addrFull" select="concat($streetNum,' ',$streetName,' ',$building,' ',$city,', ',$state,' ',$zip)" />
	
						<p class="ctc_page_subtitle_1">Address Summary</p>
						<table  width="100%">
						  <tr class="ctc_tbl_row">
							<td class="ctc_tbl_data"><xsl:value-of select="$addrFull" /></td>
						  </tr>
						</table>
					  </xsl:if>
					</blockquote>
				</td>
			</tr>
		</xsl:if>

		<!-- Embedded person record -->
		<xsl:if test="count(./Person) > 0">
			<tr>
				<td colspan="4">
					<blockquote>
						<xsl:call-template name="Person_Info_Table" />
					</blockquote>
				</td>
			</tr>
		</xsl:if>

	  <!--/xsl:for-each-->
    </table>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Incident" match="Incident" mode="data" >
	  <!--xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template>
	  <xsl:value-of select="ActivityTypeText" />
	  <xsl:value-of select="ActivityDescriptionText" />
	  <xsl:value-of select="ActivityID/ID"/>
	  <xsl:value-of select="ActivityID/IDSourceText" /-->
  </xsl:template>
 
  <!-- *************************** -->
  <!-- Person stats table format -->
  <xsl:template name="Person_Info_Table">

	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(./Person/PersonBirthDate)" />
	<xsl:variable name="countPhysical" select="count(./Person/PersonPhysicalDetails/*)" />

		<p class="ctc_page_subtitle_1">People Involved</p>
		<table width="100%" class="ctc_tbl_row">
		  <tr>
			<td class="ctc_tbl_headrow"><strong>Name</strong></td>
			<td class="ctc_tbl_headrow"><strong>DOB</strong></td>
			<td class="ctc_tbl_headrow"><strong>Race</strong></td>
			<td class="ctc_tbl_headrow"><strong>Sex</strong></td>
			<td class="ctc_tbl_headrow"><strong>OLN</strong></td>
			<td class="ctc_tbl_headrow"><strong>SSN</strong></td>
			<td class="ctc_tbl_headrow"><strong>Phone</strong></td>
			<td class="ctc_tbl_headrow"><strong>Role</strong></td>
		  </tr>
		  <xsl:for-each select="./Person">
		  <!--xsl:for-each select="//Person"-->
			<xsl:variable name="personLast" select="PersonName/PersonSurName" />
			<xsl:variable name="personFirst" select="PersonName/PersonGivenName" />
			<xsl:variable name="personMid" select="PersonName/PersonMiddleName" />
			<xsl:variable name="tagOLN" select="PersonAssignedIDDetails/PersonDriverLicenseID/ID"/>
			<xsl:variable name="tagSSN" select="PersonAssignedIDDetails/PersonSSNID/ID"/>
			<xsl:variable name="tagRole" select="Role"/>
			
			<xsl:variable name="personFull" select="concat($personLast,', ', $personFirst,' ',$personMid)" />
			<tr class="ctc_tbl_row">
				<td class="ctc_tbl_data"><xsl:value-of select="$personFull" /></td>
				<td>
				  <xsl:choose>
					<!-- display DOB, convert to MM/DD/YYYY format -->				
					<xsl:when test="$countDOB > 0"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="PersonBirthDate"/></xsl:call-template></xsl:when>					
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"> 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonRaceText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonRaceText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonSexText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonSexText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">
				  <xsl:choose>
					<xsl:when test="count($tagOLN)>0"><xsl:value-of select="$tagOLN" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">
				  <xsl:choose>
					<xsl:when test="count($tagSSN)>0"><xsl:value-of select="$tagSSN" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">
				  <xsl:choose>
					<xsl:when test="count(PrimaryContactInformation/ContactTelephoneNumber)>0"><xsl:value-of select="PrimaryContactInformation/ContactTelephoneNumber/TelephoneNumberFullID" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">
				  <xsl:choose>
					<xsl:when test="count($tagRole)>0"><xsl:value-of select="$tagRole" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
			</tr>
		</xsl:for-each>
	</table>

  </xsl:template>
  <!-- *************************** -->

</xsl:stylesheet>
