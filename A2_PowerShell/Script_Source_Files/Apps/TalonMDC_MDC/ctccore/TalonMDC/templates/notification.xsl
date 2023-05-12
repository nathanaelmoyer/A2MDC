<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   04/21/06 MAH - Created
	   12/30/08 MAH - Bold data instead of labels
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

<!-- *************************** -->
  <xsl:template name="Notification_Single" match="Notification" mode="single" >
	<table>
		<tr>
			<td class="ctc_tbl_data">ORI:</td>
			<td class="ctc_tbl_data"><strong><xsl:value-of select="Requester/ORI"/></strong></td>
		</tr>
		<tr>
			<td class="ctc_tbl_data">Requester:</td>
			<td class="ctc_tbl_data"><strong><xsl:value-of select="Requester/RequesterName"/></strong></td>
		</tr>
		<tr>
			<td class="ctc_tbl_data">Agency:</td>
			<td class="ctc_tbl_data"><strong><xsl:value-of select="Requester/AgencyName"/></strong></td>
		</tr>
		<tr valign="top">
			<td class="ctc_tbl_data"><xsl:value-of select="NotificationTypeText"/>:</td>
			<td class="ctc_tbl_data"><strong><xsl:value-of select="NotificationDescriptionText"/></strong></td>
		</tr>
		<tr valign="top">
			<td class="ctc_tbl_data"><xsl:value-of select="NoteTypeText"/>:</td>
			<td class="ctc_tbl_data"><strong><xsl:value-of select="NoteDescriptionText"/></strong></td>
		</tr>
	</table>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Notification_Table" match="Notification" mode="table" >

	<!--p class="ctc_page_subtitle_1">Accident Summary</p>
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
    </table-->
  </xsl:template>


  <!-- *************************** -->
  <xsl:template name="Notification" match="Notification" mode="data" >
  </xsl:template>
</xsl:stylesheet>
