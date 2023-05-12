<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:template name="txtAccident" match="Accident" mode="text" >
<xsl:for-each select="//Accident" >
<!--xsl:value-of select="ActivityDate"/><xsl:text> | </xsl:text><xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityDescriptionText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/IDSourceText" /-->
<xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text><xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityDescriptionText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/IDSourceText" />
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
