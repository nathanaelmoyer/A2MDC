<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:template name="CTC_Activity" >
    Activity View:<br/>
    <xsl:for-each select="/*" >
      <xsl:apply-templates select="." mode="single" />
	<!-- line feed -->
	<xsl:text>&#10;&#10;</xsl:text>
    </xsl:for-each>    
  </xsl:template>

</xsl:stylesheet>
