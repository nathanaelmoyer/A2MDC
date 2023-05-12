<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	11/01/05 MAH - Created
	10/13/06 MAH - Added links to if LinkInfo element present - for LocatePLUS
	01/30/09 MAH - Additional table columns for related Person and Incident records
	02/05/09 MAH - Fixed problem where incidents in person records were being displayed via this template in addition to the person template.
    03/31/10 MAH - Fixed problem where the same person name was being displayed for each person record.
	*************************** -->

	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<!-- *************************** -->

	<xsl:template name="Residence_Single" match="Residence" mode="single">
		<xsl:param name="nodeMode" />
		<xsl:param name="isLP" />

		<xsl:choose>
		<xsl:when test="count(//LocationAddress/AddressFullText) > 0"> 
		  <p class="ctc_page_subtitle_1">Address</p>
		  <table border="0" cellpadding="0" cellspacing="0"  width="100%">
			<xsl:for-each select="//LocationAddress/AddressFullText">
				 <tr>
				   <td class="ctc_tbl_data"><xsl:value-of select="."/></td>
				 </tr>
			</xsl:for-each>
		  </table>
		</xsl:when>
		<xsl:otherwise>
		  <p class="ctc_page_subtitle_1">Address Summary</p>
			<table  width="100%">
			  <!-- For each Residence, get the LocationAddress and Contact Info -->
			  <xsl:for-each select="$nodeMode" >
				  <xsl:if test="(string-length(LocationAddress/LocationStreet/StreetNumberText) > 0) or (string-length(LocationAddress/LocationStreet/StreetName) > 0) or (string-length(LocationAddress/LocationBuilding) > 0)
				   or (string-length(LocationAddress/LocationCityName) > 0) or (string-length(LocationAddress/LocationStateCode.fips5-2Alpha) > 0) 
				   or (string-length(LocationAddress/LocationStateCode.USPostalService) > 0) or (string-length(LocationAddress/LocationPostalCodeID) > 0)">

					<xsl:variable name="makeLink" select="count(LinkInfo)" />
					
					<xsl:variable name="streetNum" select="LocationAddress/LocationStreet/StreetNumberText" />
					<xsl:variable name="streetName" select="LocationAddress/LocationStreet/StreetName" />
					<xsl:variable name="building" select="LocationAddress/LocationBuilding" />
					<xsl:variable name="city" select="LocationAddress/LocationCityName" />
					<xsl:variable name="state" select="LocationAddress/LocationStateCode.fips5-2Alpha" />
					<!--xsl:variable name="zip" select="LocationAddress/LocationStateCode.USPostalService" /-->
					<xsl:variable name="zipOldTag" select="LocationAddress/LocationStateCode.USPostalService" />
					<xsl:variable name="zipNewTag" select="LocationAddress/LocationPostalCodeID/ID" />
					<xsl:variable name="zip" select="concat($zipOldTag,$zipNewTag)" />
					<xsl:variable name="county" select="LocationAddress/LocationCountyName" />
					<xsl:variable name="country" select="LocationAddress/LocationCountryName" />
					<xsl:variable name="startDate" select="ResidenceStartDate" />
					<xsl:variable name="endDate" select="ResidenceEndDate" />

					<xsl:variable name="tempPhone" select="PrimaryContactInformation/ContactTelephoneNumber"/>
					<xsl:variable name="phoneText" select="$tempPhone/TelephoneNumberCommentText" />
					<xsl:variable name="phoneNum" select="$tempPhone/TelephoneNumberFullID" />
					
					<xsl:variable name="addrFull" select="concat($streetNum,' ',$streetName,' ',$building,' ',$city,', ',$state,' ',$zip)" />

					<tr class="ctc_tbl_row">
						<xsl:choose>
							<xsl:when test="$makeLink">
							  <td class="ctc_tbl_data">
								<xsl:call-template name="Link">
									<xsl:with-param name="dest" select="LinkInfo"/>
									<xsl:with-param name="desc" select="$addrFull"/>
								</xsl:call-template>
							  </td>
							<xsl:if test="(string-length($county) > 0)">
								<td> County:
									<xsl:value-of select="$county"/>
								</td>
							</xsl:if>
							<xsl:if test="(string-length($country) > 0)">
								<td> Country:
									<xsl:value-of select="$country"/>
								</td>
							</xsl:if>
							<xsl:if test="(string-length($startDate) > 0)">
								<td> Start Date:
									<xsl:value-of select="$startDate"/>
								</td>
							</xsl:if>
							<xsl:if test="(string-length($endDate) > 0)">
								<td> End Date:
									<xsl:value-of select="$endDate"/>
								</td>
							</xsl:if>
								  <xsl:if test="count($tempPhone) > 0">
									<xsl:if test="(string-length($phoneText) > 0) or (string-length($phoneNum) > 0)">
										<td>
											<xsl:if test="string-length($phoneText) > 0">
												<xsl:value-of select="$phoneText"/>&#160;
											</xsl:if>
											<xsl:if test="string-length($phoneNum) > 0">
												<xsl:value-of select="$phoneNum"/>
											</xsl:if>
										</td>
									</xsl:if>
								  </xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<td class="ctc_tbl_data"><xsl:value-of select="$addrFull" /></td>
								<xsl:if test="(string-length($county) > 0)">
									<td> County:
										<xsl:value-of select="$county"/>
									</td>
								</xsl:if>
								<xsl:if test="(string-length($country) > 0)">
									<td> Country:
										<xsl:value-of select="$country"/>
									</td>
								</xsl:if>
								<xsl:if test="(string-length($startDate) > 0)">
									<td> Start Date:
										<xsl:value-of select="$startDate"/>
									</td>
								</xsl:if>
								<xsl:if test="(string-length($endDate) > 0)">
									<td> End Date:
										<xsl:value-of select="$endDate"/>
									</td>
								</xsl:if>
								  <xsl:if test="count($tempPhone) > 0">
									<xsl:if test="(string-length($phoneText) > 0) or (string-length($phoneNum) > 0)">
										<td>
											<xsl:if test="string-length($phoneText) > 0">
												<xsl:value-of select="$phoneText"/>&#160;
											</xsl:if>
											<xsl:if test="string-length($phoneNum) > 0">
												<xsl:value-of select="$phoneNum"/>
											</xsl:if>
										</td>
									</xsl:if>
								  </xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					  </tr>
				  </xsl:if>

	
				<!-- Embedded person record -->
				<xsl:if test="count(./Person) > 0">
					<tr>
						<td>
							<blockquote>
								<xsl:call-template name="Person_Info_Table" />
							</blockquote>
						</td>
					</tr>
				</xsl:if>

				<!-- Embedded incident record -->
				<xsl:if test="count(./Incident) > 0">
					<tr>
						<td>
							<blockquote>
								<xsl:call-template name="IncidentList_Table" />
							</blockquote>
						</td>
					</tr>
				</xsl:if>
				
			  </xsl:for-each>
			</table>
		</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

  <!-- *************************** -->
  <!-- THESE 2 TEMPLATES ARE NEVER CALLED, BUT IF YOU REMOVE TABLE OR DATA TEMPLATES, GETS TEMPLATE ERRORS -->
  <xsl:template name="Residence_Table" match="Residence" mode="table" >
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Residence" match="Residence" mode="data" >
  </xsl:template>

  <!-- *************************** -->
  <!-- Person stats table format -->
  <xsl:template name="Person_Info_Table">

	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(./Person/PersonBirthDate)" />
	<xsl:variable name="countPhysical" select="count(./Person/PersonPhysicalDetails/*)" />

		<p class="ctc_page_subtitle_1">People at the Address</p>
		<table width="100%" class="ctc_tbl_row">
		  <tr>
			<td class="ctc_tbl_headrow"><strong>Name</strong></td>
			<td class="ctc_tbl_headrow"><strong>DOB</strong></td>
			<td class="ctc_tbl_headrow"><strong>Race</strong></td>
			<td class="ctc_tbl_headrow"><strong>Sex</strong></td>
			<td class="ctc_tbl_headrow"><strong>OLN</strong></td>
			<td class="ctc_tbl_headrow"><strong>SSN</strong></td>
			<td class="ctc_tbl_headrow"><strong>Phone</strong></td>
		  </tr>
		  <xsl:for-each select="./Person">
		  <!--xsl:for-each select="//Person"-->
			<xsl:variable name="personLast" select="PersonName/PersonSurName" />
			<xsl:variable name="personFirst" select="PersonName/PersonGivenName" />
			<xsl:variable name="personMid" select="PersonName/PersonMiddleName" />
			<xsl:variable name="tagOLN" select="PersonAssignedIDDetails/PersonDriverLicenseID/ID"/>
			<xsl:variable name="tagSSN" select="PersonAssignedIDDetails/PersonSSNID/ID"/>
			
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
			</tr>
		</xsl:for-each>
	</table>

  </xsl:template>

  <!-- *************************** -->
  <!-- Incidents -->
  <xsl:template name="IncidentList_Table">

	<p class="ctc_page_subtitle_1">Incident Summary</p>
	<table width="100%">
	  <tr class="ctc_tbl_headrow">
		<th class="ctc_tbl_center_hdr">Date</th>
		<th class="ctc_tbl_center_hdr">Type</th>
		<th class="ctc_tbl_center_hdr">Description</th>
		<th class="ctc_tbl_center_hdr">ID</th>
		<th class="ctc_tbl_center_hdr">Source</th>
	  </tr>
	   <xsl:for-each select="//Incident" >
		<tr class="ctc_tbl_row" valign="top"> 
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		</tr>
	  </xsl:for-each>
	</table>

  </xsl:template>
  <!-- *************************** -->

</xsl:stylesheet>
