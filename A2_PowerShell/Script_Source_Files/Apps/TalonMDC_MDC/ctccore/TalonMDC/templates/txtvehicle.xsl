<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:template name="txtVehicle" match="Vehicle" mode="text" >
ID: <xsl:value-of select="VehicleID" />
Make: <xsl:value-of select="VehicleMakeCode"  />
Model: <xsl:value-of select="VehicleModelCode"  />
<!--Year: <xsl:value-of select="VehicleModelYearDate" /-->
Year: <xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleModelYearDate"/></xsl:call-template>
Color: <xsl:value-of select="VehicleColorPrimaryCode"  />
</xsl:template>
</xsl:stylesheet>