<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Changed call to activity template - was calling table template
	   04/26/05 MAH - Added heading param
	   04/26/06 MAH - Added query title
  -->
  <!-- *************************** -->

<xsl:import href="activity.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Activities_Single" match="Activities" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

    <xsl:call-template name="Activity">
		<xsl:with-param name="node" select="//Activity"/>
		<xsl:with-param name="heading">Activity Summary</xsl:with-param>
	</xsl:call-template>
    <xsl:call-template name="fldr_footer"/>
  </xsl:template>


</xsl:stylesheet>
