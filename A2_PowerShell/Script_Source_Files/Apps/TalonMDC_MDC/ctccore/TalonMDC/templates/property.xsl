<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Changed call to activity template - was calling table template
	   04/26/05 MAH - Added heading param
	   04/26/06 MAH - Renamed to Property from Activities
	   12/07/06 MAH - Added check for Person info
  -->
  <!-- *************************** -->

<!--xsl:import href="activity.xsl" /-->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Property_Single" match="Property" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>
 
	<p class="ctc_page_subtitle_1">Property Summary</p>
	
	<table width="100%" bgcolor="#DFDFDF" class="ctc_tbl_row">
		<tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr">Trans#</td>
			<td class="ctc_tbl_center_hdr">Date</td>
			<td class="ctc_tbl_center_hdr">Type</td>
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
							<xsl:when test="contains($curNode,'ActivityGrp')">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="contains($curNode,'Activity')">
								<xsl:apply-templates select="."/>
							</xsl:when>
						</xsl:choose>
				</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			  <xsl:call-template name="ActivityList">
				  <xsl:with-param name="node" select="//Activity"/>
			  </xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>

	</table>

    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="ActivityGrp" match="ActivityGrp">
	  <xsl:call-template name="ActivityList">
		  <xsl:with-param name="node" select="./Activity"/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Activity" match="Activity">
	  <xsl:call-template name="ActivityList">
		  <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
  </xsl:template>

  <!-- **************************************************************************** -->
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
				<td class="ctc_tbl_data"><xsl:value-of select="$tagID"/></td>
				<td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagDate"/></xsl:call-template></td>
				<td class="ctc_tbl_data"><xsl:value-of select="$tagType"/></td>
			</tr>
			<xsl:if test="count($tagDesc)>0">
				<tr class="ctc_tbl_row" >
					<td colspan="3">
						<table>
							<tr class="ctc_tbl_row">
								<td class="ctc_tbl_data">&#160;&#160;<xsl:value-of select="$tagDesc"/></td>						
							</tr>
						</table>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="count(ActivityReportingOrganization)>0">
				<tr class="ctc_tbl_row">
					<td colspan="3">
						<table>
							<tr>
								<td class="ctc_tbl_data">
									&#160;&#160;
									<xsl:value-of select="$tagOrgName"/>&#160;in&#160;
									<xsl:value-of select="$tagOrgCity"/>,&#160;
									<xsl:value-of select="$tagOrgSt"/>
								</td>
							</tr>
						</table>
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
			<td colspan="3"><hr/></td>
		</tr>
		<tr class="ctc_tbl_row">
			<td class="ctc_tbl_data_em" colspan="3" align="center" nowrap="nowrap">
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
