<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data template processing - only Single is called
					- Removed grouped param
	   04/26/06 MAH - Added query title
	   12/07/06 MAH - Added check for Person info
  -->
  <!-- *************************** -->

<!--xsl:import href="arrest.xsl" /-->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- for Arrests folder in case view -->
  <xsl:template name="Arrests_Single" match="Arrests" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<p class="ctc_page_subtitle_1">Arrests</p>
	<table width="100%">
		<tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr">Date</td>
			<td class="ctc_tbl_center_hdr">Type</td>
			<td class="ctc_tbl_center_hdr">Description</td>
			<td class="ctc_tbl_center_hdr">ID</td>
			<td class="ctc_tbl_center_hdr">Source</td>
			<td class="ctc_tbl_center_hdr">Location</td>
			<td class="ctc_tbl_center_hdr">Arrest Agency</td>
			<td class="ctc_tbl_center_hdr">CTN</td>
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
							<xsl:when test="contains($curNode,'ArrestGrp')">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="contains($curNode,'Arrest')">
								<xsl:apply-templates select="."/>
							</xsl:when>
						</xsl:choose>
				</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			  <xsl:call-template name="ArrestList">
				  <xsl:with-param name="node" select="//Arrest"/>
			  </xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>

	</table>

    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="ArrestGrp" match="ArrestGrp">
	  <xsl:call-template name="ArrestList">
		  <xsl:with-param name="node" select="./Arrest"/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Arrest" match="Arrest">
	  <xsl:call-template name="ArrestList">
		  <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="ArrestList" >
	<xsl:param name="node" />
	
		<xsl:for-each select="$node">
			<tr class="ctc_tbl_row" valign="top">
				<!-- display ActivityDate in MM/DD/YYYY format -->
				<td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ArrestLocation/LocationDescriptionText"/></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ArrestAgency/OrganizationName"/></td>
				<td class="ctc_tbl_data"><xsl:value-of select="Charge/ChargeTrackingID/ID"/></td>
			</tr>
		</xsl:for-each>

  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="PersonInfo">
	
	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(following-sibling::PersonBirthDate)" />
	<xsl:variable name="countPhysicalRace" select="count(following-sibling::PersonPhysicalDetails/PersonRaceText)" />
	<xsl:variable name="countPhysicalSex" select="count(following-sibling::PersonPhysicalDetails/PersonSexText)" />

		<tr class="ctc_tbl_row">
			<td colspan="8"><hr/></td>
		</tr>
		<tr class="ctc_tbl_row">
			<td class="ctc_tbl_data_em" colspan="8" align="center">
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
