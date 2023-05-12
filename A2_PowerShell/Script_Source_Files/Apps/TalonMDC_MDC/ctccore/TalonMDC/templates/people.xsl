<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Changed person template call - calls case mode instead of single
       07/22/05 MAH - Changed call to person template to make more efficient
	   04/26/06 MAH - Added query title, if available
  -->
  <!-- *************************** -->

<xsl:import href="person.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="People_Single" match="People" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:for-each select="./Person">
		<xsl:call-template name="Person_Case"/>
	</xsl:for-each>
    <!--xsl:apply-templates select="//Person" mode="case"/-->
    <!--xsl:apply-templates select="//Person" mode="single">
		<xsl:with-param name="isCaseView">true</xsl:with-param>
    </xsl:apply-templates-->
    <xsl:call-template name="fldr_footer"/>
  </xsl:template>

</xsl:stylesheet>
