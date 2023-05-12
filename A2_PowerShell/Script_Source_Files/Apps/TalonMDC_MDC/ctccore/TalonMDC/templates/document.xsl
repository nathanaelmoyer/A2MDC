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
  <xsl:template name="Document_Single" match="Document" mode="single" >

	<xsl:call-template name="Document_Info"/>
	<xsl:call-template name="FileListCall"/>

  </xsl:template>
  
  <!-- *************************** -->
  <xsl:template name="Document_Info" match="Document" mode="info" >
	<p class="ctc_page_subtitle_1">Document Summary</p>
    <table width="100%">
      <tr class="ctc_tbl_headrow">
        <th class="ctc_tbl_center_hdr">FileName</th>
       <th class="ctc_tbl_center_hdr">Title</th>
       <th class="ctc_tbl_center_hdr">Created Date</th>
        <th class="ctc_tbl_center_hdr">Created By</th>
        <th class="ctc_tbl_center_hdr">Requested By</th>
        <th class="ctc_tbl_center_hdr">DocID #</th>
        <th class="ctc_tbl_center_hdr">Incident #</th>
        <th class="ctc_tbl_center_hdr">Agency</th>
        <th class="ctc_tbl_center_hdr">Source</th>
      </tr>

	   <!--xsl:for-each select="$node" -->
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentFileName"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentTitleText" /></td>
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="DocumentCreationDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentCreator/EntityOrganizationReference" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentRequester" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentFileControlID" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentIncidentNumberText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentGroupID" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="DocumentSourceText" /></td>
		</tr>
	  <!--/xsl:for-each-->
    </table>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Document" match="Document" mode="data" >

  </xsl:template>
  <!-- *************************** -->

</xsl:stylesheet>
