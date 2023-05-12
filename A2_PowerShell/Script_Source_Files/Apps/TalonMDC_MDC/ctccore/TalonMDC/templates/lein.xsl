<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data - just calls single
	   04/26/06 MAH - Added query title
	   05/02/06 MAH - Sort messages - newest at bottom
	   01/09/07 MAH - Warning text if there is a folder limit
  -->
  <!-- *************************** -->

<xsl:import href="message.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="LEIN_Single" match="LEIN"  mode="single">

	<xsl:call-template name="fldr_querytitle"/>

    <xsl:apply-templates select="//Message" mode="single"/>
		<!--xsl:sort select="@DateCreated" order="ascending" />
		<xsl:sort select="@TimeCreated" order="ascending" /-->
    <!--/xsl:apply-templates-->
    
    <xsl:call-template name="fldr_footer"/>

  </xsl:template>

</xsl:stylesheet>
