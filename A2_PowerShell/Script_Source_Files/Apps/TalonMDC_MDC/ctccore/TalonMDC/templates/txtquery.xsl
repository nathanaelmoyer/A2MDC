<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- text only output for queries -->
<xsl:output method="text" />
<xsl:template name="txtQuery" match="Query" mode="text">
<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="Title"/>
<xsl:text>&#10;&#10;</xsl:text>
<xsl:value-of select="QueryString"/>
<xsl:text>&#10;&#10;********************************&#10;</xsl:text>
</xsl:template>
</xsl:stylesheet>
