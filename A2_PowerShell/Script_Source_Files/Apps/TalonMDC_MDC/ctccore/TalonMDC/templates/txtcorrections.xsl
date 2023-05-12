<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:template name="txtCorrections" match="Corrections" mode="text" >
<xsl:text>Corrections</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:for-each select="Corrections" >
<xsl:value-of select="ActivityID/ID" /><xsl:text>  </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="SupervisionRelease/ActivityDate"/></xsl:call-template><xsl:text>  </xsl:text><xsl:value-of select="SupervisionCustodyStatus/StatusText" /><xsl:text>  </xsl:text><xsl:value-of select="SupervisionFacility/OrganizationDescriptionText" />
<xsl:text>&#10;</xsl:text>
<xsl:if test="count(Arrest)>0">
<xsl:text>    </xsl:text><xsl:text>Arrests</xsl:text>
<xsl:text>&#10;</xsl:text>
	<xsl:for-each select="Arrest" >
<xsl:text>    </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text>  </xsl:text><xsl:value-of select="ArrestLocation/LocationDescriptionText" /><xsl:text>  </xsl:text><xsl:value-of select="ArrestAgency/OrganizationName" /><xsl:text>  </xsl:text><xsl:value-of select="Charge/ChargeTrackingID/ID" />
<xsl:text>&#10;</xsl:text>
<xsl:text>    </xsl:text><xsl:if test="count(Charge/ChargeTrackingID/ID)>0"><xsl:text>CTN: </xsl:text><xsl:value-of select="Charge/ChargeTrackingID/ID" /><xsl:text>&#10;</xsl:text></xsl:if>
	<xsl:text>&#10;</xsl:text>
	<xsl:if test="count(Charge)>0">
<xsl:text>    </xsl:text><xsl:text>Charges&#10;</xsl:text>
	<xsl:for-each select="Charge">
<xsl:text>    </xsl:text><xsl:value-of select="ChargeID/ID"/><xsl:text>  </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ChargeFilingDate"/></xsl:call-template><xsl:text>  </xsl:text><xsl:value-of select="ChargeClassification"/><xsl:text>  </xsl:text><xsl:value-of select="CourtEvent/CourtEventCourt/CourtName"/><xsl:text>  </xsl:text><xsl:value-of select="CourtEvent/CaseDocketID/ID"/>
	<xsl:text>&#10;</xsl:text>
<xsl:if test="count(ChargeDescriptionText)>0">
<xsl:text>    </xsl:text><xsl:value-of select="ChargeDescriptionText"/>
	<xsl:text>&#10;</xsl:text>
</xsl:if>   
<xsl:if test="count(CourtEvent/CourtEventJudge/PersonName/PersonFullName)>0">
<xsl:text>    </xsl:text><xsl:value-of select="CourtEvent/CourtEventJudge/PersonName/PersonFullName"/>
<xsl:text>&#10;</xsl:text>
</xsl:if>
	</xsl:for-each>
	</xsl:if>
	<xsl:text>&#10;</xsl:text>
	</xsl:for-each>
</xsl:if>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
