<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:template name="txtActivity" match="Activity" mode="text" >
<xsl:text>Activity Summary</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:for-each select="Activity" >
<xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text><xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityDescriptionText" />
<xsl:text>&#10;</xsl:text>
<xsl:text>    </xsl:text><xsl:value-of select="ActivityDescriptionText"/>
<xsl:text>&#10;</xsl:text>
<xsl:text>    </xsl:text><xsl:value-of select="ActivityReportingOrganization/OrganizationName"/><xsl:text> in </xsl:text><xsl:value-of select="ActivityReportingOrganization/LocationAddress/LocationCityName"/><xsl:text>, </xsl:text><xsl:value-of select="ActivityReportingOrganization/LocationAddress/LocationStateCode.fips5-2Alpha"/>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>

