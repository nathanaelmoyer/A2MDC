<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed filelistcall import
	   04/26/06 MAH - Added query title
  -->
  <!-- *************************** -->

	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>

	<xsl:template name="Photos_Single" match="Photos" mode="single">
		<xsl:call-template name="fldr_querytitle"/>
	
		<xsl:call-template name="FileListCall">
			<xsl:with-param name="msgMode">summary</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="fldr_footer"/>
	</xsl:template>

</xsl:stylesheet>
