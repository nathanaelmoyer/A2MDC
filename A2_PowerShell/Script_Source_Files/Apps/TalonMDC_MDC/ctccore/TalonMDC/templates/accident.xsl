<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed single and data template processing - only Table is called
	   06/04/05 MAH - Removed choose statement
	   04/03/06 MAH - Added link to PDF
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <xsl:template name="Accident_Table" match="Accident" mode="table" >
	<xsl:param name="caseview" />
	
	<p class="ctc_page_subtitle_1">Accident Summary</p>
    <table width="100%">
      <tr class="ctc_tbl_headrow">
        <th class="ctc_tbl_center_hdr">Date</th>
        <th class="ctc_tbl_center_hdr">Type</th>
        <th class="ctc_tbl_center_hdr">Description</th>
        <th class="ctc_tbl_center_hdr">ID</th>
        <th class="ctc_tbl_center_hdr">Source</th>
        <th class="ctc_tbl_center_hdr"></th>
      </tr>

	   <xsl:for-each select="//Accident" >
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		  <xsl:if test="count(InjectXML/FileList)>0">
			<xsl:call-template name="FileListCall" >
			  <xsl:with-param name="msgMode">inline</xsl:with-param>
			</xsl:call-template>
		  </xsl:if>
		</tr>
	  </xsl:for-each>
    </table>
  </xsl:template>


</xsl:stylesheet>
