<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data - just calls single
	   04/26/06 MAH - Added query title
  -->
  <!-- *************************** -->

<xsl:import href="message.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="SOS_Single" match="SOS" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

    <xsl:apply-templates select="//Message" mode="single"/>
    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

</xsl:stylesheet>
