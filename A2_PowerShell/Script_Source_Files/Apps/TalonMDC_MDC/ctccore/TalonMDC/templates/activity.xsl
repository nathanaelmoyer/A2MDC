<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Combined data & table template by adding node param
	   04/26/06 MAH - Added heading param to show appropriate heading for subfolder
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- **************************************************************************** -->
  <!-- called from person.xsl & activities -->

  <xsl:template name="ActivityTbl" match="Activity" mode="tbl">
	<xsl:param name="node" />
	<xsl:param name="heading" />

		<xsl:call-template name="Activity">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="heading" select="$heading"/>
		</xsl:call-template>

  
  </xsl:template>

  <xsl:template name="Activity" match="Activity" mode="data" >
	<xsl:param name="node" />
	<xsl:param name="heading" />

	<xsl:choose>
		<xsl:when test="string-length($heading) > 0">
			<p class="ctc_page_subtitle_1"><xsl:value-of select="$heading"/></p>
		</xsl:when>
		<xsl:otherwise><p class="ctc_page_subtitle_1">Activity</p></xsl:otherwise>
	</xsl:choose>
	
	<table width="100%" bgcolor="#DFDFDF" class="ctc_tbl_row">
		<tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr">Trans#</td>
			<td class="ctc_tbl_center_hdr">Date</td>
			<td class="ctc_tbl_center_hdr">Type</td>
		</tr>
			
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
	</table>

	
  </xsl:template>

</xsl:stylesheet>
