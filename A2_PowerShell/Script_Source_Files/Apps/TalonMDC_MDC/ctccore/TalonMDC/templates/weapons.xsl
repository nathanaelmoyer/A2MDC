<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   04/26/06 MAH - Created
  -->
  <!-- *************************** -->

<xsl:import href="message.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Weapons_Single" match="Weapons" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

    <xsl:apply-templates select="//Message" mode="single"/>
    <xsl:call-template name="fldr_footer"/>
  </xsl:template>
  
</xsl:stylesheet>
