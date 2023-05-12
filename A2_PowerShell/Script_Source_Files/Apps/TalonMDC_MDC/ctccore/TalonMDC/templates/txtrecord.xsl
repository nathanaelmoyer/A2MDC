<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="txtperson.xsl"/>
<xsl:import href="txtincident.xsl"/>
<xsl:import href="txtvehicle.xsl"/>
<!-- text only output for records -->
<xsl:output method="text"/>
<xsl:template name="Record" match="Record" mode="text">
<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description"/>
<xsl:text>&#10;</xsl:text>
<xsl:for-each select="*">
<xsl:variable name="curNode" select="name(current())"/>
<xsl:if test="contains($curNode,'Person')">
<xsl:call-template name="txtPerson"/>
</xsl:if>
<xsl:if test="contains($curNode,'Vehicle')">
<xsl:call-template name="txtVehicle"/>
</xsl:if>
<xsl:if test="contains($curNode,'Incident')">
<xsl:call-template name="txtIncident"/>
</xsl:if>
</xsl:for-each>
<xsl:text>&#10;********************************&#10;</xsl:text>
</xsl:template>
</xsl:stylesheet>
