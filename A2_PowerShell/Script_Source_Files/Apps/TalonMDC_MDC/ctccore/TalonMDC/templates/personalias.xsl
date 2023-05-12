<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="PersonAlias_Table" match="PersonAlias" mode="table" >
	<xsl:if test="count(//PersonAlias)>0">
		<p class="ctc_page_subtitle_1">Aliases</p>
		<table width="100%">
		  <xsl:for-each select="//PersonAlias" >
			<!--tr bgcolor="#DFDFDF"><td class="ctc_tbl_data"><xsl:value-of select="." /></td></tr-->
			<tr><td class="ctc_tbl_data"><xsl:value-of select="." /></td></tr>
		  </xsl:for-each>
		</table>
	</xsl:if>    
  </xsl:template>

  <xsl:template name="PersonAlias_Single" match="PersonAlias" mode="single" >
    <font class="ctc_single_title">Sur Name: </font><xsl:value-of select="." /><br/>
  </xsl:template>

  <xsl:template name="PersonAlias" match="PersonAlias" mode="data" >
    <xsl:value-of select="." />
  </xsl:template>

</xsl:stylesheet>