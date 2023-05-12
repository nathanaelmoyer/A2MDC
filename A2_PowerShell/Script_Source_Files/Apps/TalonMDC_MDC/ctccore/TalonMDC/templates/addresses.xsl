<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed residence.xsl import
					- Removed call to LocationAddress_Table template - embedded it
					- Removed Addresses_Table template
	   04/26/06 MAH - Added query title
	   12/05/06 MAH - Added person information
  -->
  <!-- *************************** -->

  <!-- *************************** -->
  <xsl:template name="Addresses_Single" match="Addresses" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<p class="ctc_page_subtitle_1">Address Summary</p>
	<table  width="100%">
	  <tr class="ctc_tbl_headrow">
		<th class="ctc_tbl_center_hdr">Street</th>
		<th class="ctc_tbl_center_hdr">City</th>
		<th class="ctc_tbl_center_hdr">State</th>
		<th class="ctc_tbl_center_hdr">Zip</th>
		<th class="ctc_tbl_center_hdr">Source</th>
	  </tr>
	<xsl:choose>
		<xsl:when test="count(PersonName)>0">
		
			<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="PersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'LocationAddressGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'LocationAddress')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:call-template name="AddressList">
			  <xsl:with-param name="node" select="//LocationAddress"/>
		  </xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>

	</table>

    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="AddressGrp" match="LocationAddressGrp">
	  <xsl:call-template name="AddressList">
		  <xsl:with-param name="node" select="./LocationAddress"/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Address" match="LocationAddress">
	  <xsl:call-template name="AddressList">
		  <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="AddressList">
	<xsl:param name="node"/>
	
	<xsl:variable name="fullAddr" select="$node/AddressFullText"/>
	<xsl:choose>
		<xsl:when test="count($fullAddr) > 0"> 
		  <p class="ctc_page_subtitle_1">Address</p>
		  <table border="0" cellpadding="0" cellspacing="0"  width="100%">
			<xsl:for-each select="$fullAddr">
				 <tr>
				   <td class="ctc_tbl_data"><xsl:value-of select="."/></td>
				 </tr>
			</xsl:for-each>
		  </table>
		</xsl:when>
		<xsl:otherwise>
			  <xsl:for-each select="$node">
			   <xsl:if test="(count(AddressFullText) > 0) or (string-length(LocationStreet) > 0) or (string-length(LocationBuilding) > 0)
				   or (string-length(LocationCityName) > 0) or (string-length(LocationStateCode.fips5-2Alpha) > 0) 
				   or (string-length(LocationStateCode.USPostalService) > 0) or (string-length(LocationPostalCodeID) > 0)">
					<tr class="ctc_tbl_row">
					  <td class="ctc_tbl_data">
						<xsl:if test="count(AddressFullText) > 0"> 
						  <xsl:apply-templates select="AddressFullText" mode="data" /><br/>
						</xsl:if>
						<xsl:if test="string-length(LocationStreet) > 0" >
							<xsl:value-of select="LocationStreet" />&#160;
						</xsl:if>
						<xsl:if test="string-length(LocationBuilding) > 0" >
							<xsl:value-of select="LocationBuilding" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(LocationCityName) > 0" >
							<xsl:value-of select="LocationCityName" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(LocationStateCode.fips5-2Alpha) > 0" >
							<xsl:value-of select="LocationStateCode.fips5-2Alpha" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(LocationStateCode.USPostalService) > 0" >
							<xsl:value-of select="LocationStateCode.USPostalService" />
						</xsl:if>
						<xsl:if test="string-length(LocationPostalCodeID) > 0" >
							<xsl:value-of select="LocationPostalCodeID/ID" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(LocationCountyName) > 0" >
							<xsl:value-of select="LocationCountyName" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(LocationCountryName) > 0" >
							<xsl:value-of select="LocationCountryName" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(ResidenceStartDate) > 0" >
							<xsl:value-of select="ResidenceStartDate" />
						</xsl:if>
					  </td>
					  <td class="ctc_tbl_data">
						<xsl:if test="string-length(ResidenceEndDate) > 0" >
							<xsl:value-of select="ResidenceEndDate" />
						</xsl:if>
					  </td>
					  <xsl:variable name="sourceID" select="./InjectXML/@ID" />
					  <xsl:if test="string-length($sourceID) > 0">
					  	<xsl:variable name="linkHref" select="concat('link:display=window+id=', $sourceID)" />
					  	<td class="ctc_tbl_data"><a href="{$linkHref}">View Source</a></td>
					  </xsl:if>
					</tr>
				</xsl:if>
			  </xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
  
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
			<td class="ctc_tbl_data_em" colspan="4" align="center" >
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
</xsl:stylesheet>
