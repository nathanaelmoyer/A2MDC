<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   04/27/06 MAH - Created based on paccpaam
	   04/28/06 MAH - Added support for message tag
  -->
  <!-- *************************** -->

<xsl:import href="record.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- for Out of State folder in case view -->
  <xsl:template name="OutofState_Single" match="OutofState" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:if test="count(//Message)>0">
		<xsl:apply-templates select="Message" mode="single"/>
	</xsl:if>
	<xsl:if test="count(//Record)>0">
		<hr/>
		<xsl:apply-templates select="Record" mode="case"/>
	</xsl:if>

    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

 
</xsl:stylesheet>
