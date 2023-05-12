<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   04/27/06 MAH - Created based on arrests
				    - Modified to handle records
  -->
  <!-- *************************** -->

<xsl:import href="record.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- for PACCPAAM folder in case view -->
  <xsl:template name="PACCPAAM_Single" match="PACCPAAM" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:for-each select="Record">
		<xsl:apply-templates select="." mode="case"/>
	</xsl:for-each>
    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

</xsl:stylesheet>
