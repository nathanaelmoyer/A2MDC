<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed single arrest processing - moved to Corrections template
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- called from Person and Arrests -->
  <xsl:template name="Arrest" match="Arrest" mode="data" >
	
	<p class="ctc_page_subtitle_1">Arrests</p>
	<table width="100%">
		<xsl:variable name="countAgency" select="count(ArrestAgency/OrganizationName)" />
		<xsl:variable name="countLocation" select="count(ArrestLocation/LocationDescriptionText)" />
		<xsl:variable name="countCTN" select="count(Charge/ChargeTrackingID/ID)" />
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

		<xsl:for-each select="Arrest">
			<xsl:variable name="countAgency" select="count(ArrestAgency/OrganizationName)" />
			<xsl:variable name="countLocation" select="count(ArrestLocation/LocationDescriptionText)" />
			<xsl:variable name="countCTN" select="count(Charge/ChargeTrackingID/ID)" />
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
	</table>

  </xsl:template>

  <!-- *************************** -->

</xsl:stylesheet>
