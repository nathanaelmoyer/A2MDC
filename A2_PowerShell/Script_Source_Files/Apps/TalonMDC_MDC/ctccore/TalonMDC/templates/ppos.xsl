<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed "Court Cases" title - displayed in case template
					- Changed call to case template - now has 2 params
	   04/26/06 MAH - Added query title
  -->
  <!-- *************************** -->

<xsl:import href="ppo.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="PPOs_Single" match="PPOs" mode="single" >
	<xsl:if test="count(Case)>0">
		<!--Display query string, if available-->
		<xsl:variable name="queryTitle" select="../@Title"/>
		<xsl:if test="string-length($queryTitle) > 0">
			<p class="ctc_page_subtitle_1"><font color="black">Queried: <xsl:value-of select="$queryTitle"/></font></p>
		</xsl:if>
	
		<xsl:call-template name="PPO">
			<xsl:with-param name="node" select="//ProtectionOrder"/>
			<xsl:with-param name="isCaseView">true</xsl:with-param>
		</xsl:call-template>
		<p class="ctc_page_subtitle_1">*** END OF RECORDS ***</p>
	</xsl:if>
  </xsl:template>

</xsl:stylesheet>
