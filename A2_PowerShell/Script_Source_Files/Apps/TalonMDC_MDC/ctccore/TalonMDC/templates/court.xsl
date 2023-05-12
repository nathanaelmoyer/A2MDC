<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="case.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Court_Single" match="Court" mode="single" >
	<xsl:if test="count(Case)>0">
		<p class="ctc_page_subtitle_1">Court Cases</p>
		<xsl:apply-templates select="Case" mode="caseview"/>
		<p class="ctc_page_subtitle_1">*** END OF RECORDS ***</p>
	</xsl:if>
  </xsl:template>

</xsl:stylesheet>
