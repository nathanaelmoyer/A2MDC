<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   05/25/06 MAH - Created
  -->
  <!-- *************************** -->

<xsl:import href="message.xsl" />
<xsl:import href="record.xsl" />
<xsl:import href="miscinfodisplayable.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Canada_Single" match="Canada" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:if test="count(//Message)>0">
		<!--p class="ctc_page_subtitle_1">NLETS</p-->
		<xsl:apply-templates select="Message" mode="single"/>
	</xsl:if>
	<xsl:if test="count(//Record)>0">
		<hr/>
		<p class="ctc_page_subtitle_1">Data Sharing</p>
		<xsl:apply-templates select="Record" mode="case"/>
	</xsl:if>
	<xsl:if test="count(//MiscInfoDisplayable)>0">
		<xsl:apply-templates select="MiscInfoDisplayable" mode="single"/>
	</xsl:if>
    <xsl:call-template name="fldr_footer"/>
  </xsl:template>
  
</xsl:stylesheet>
