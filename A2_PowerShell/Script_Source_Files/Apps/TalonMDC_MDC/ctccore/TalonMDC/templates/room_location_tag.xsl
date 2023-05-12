<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml">
	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	04/11/10 DAH - Created
	-->
	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" />
	<!-- *************************** -->

	<xsl:template name="RoomAndLocation" match="RoomAndLocation">
				
	<table>
		  <tr>
			<td class="ctc_tag_data">
			<xsl:call-template name="incImage" >
			     <xsl:with-param name="source" select="concat('file:///', FilePathBarcodeJPG)" />
			</xsl:call-template>
			</td>
		  </tr>
		  <tr>
			<td class="ctc_tag_data">Room:<strong>&#160;<xsl:value-of select="RoomDesc"/></strong></td>
		  </tr>
		  <tr>
			<td class="ctc_tag_data">Location:<strong>&#160;<xsl:value-of select="LocationDesc"/></strong></td>
		</tr>	
		<xsl:if test="count(SiteLabel)>0">
			  <tr align="center">
				<td class="ctc_tag_data" colspan="2" ><xsl:value-of select="SiteLabel"/></td>
			  </tr>
		</xsl:if>

	</table>

	</xsl:template>

<xsl:template name="incImage">
    <xsl:param name="source" />
    <xsl:if test="string-length($source) > 0">
      <span class="ctc_img"><img src="{$source}" /></span>
    </xsl:if>
</xsl:template>

  <!-- *************************** -->
</xsl:stylesheet>
