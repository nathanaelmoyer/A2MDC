<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:template name="txtCase" match="Case" mode="text" >
<xsl:text>Corrections</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:for-each select="Case" >
<xsl:text>Date: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text>  Case ID: </xsl:text><xsl:value-of select="CaseTrackingID/ID" /><xsl:text>  Type: </xsl:text><xsl:value-of select="ActivityTypeText" /><xsl:text>  Desc: </xsl:text><xsl:value-of select="ActivityDescriptionText" />
<xsl:text>&#10;</xsl:text>
<xsl:text>Case Type: </xsl:text><xsl:value-of select="CaseTypeText"/><xsl:text>  Court: </xsl:text><xsl:value-of select="Court/CourtName"/><xsl:text>  County: </xsl:text><xsl:value-of select="Court/OrganizationLocation/LocationAddress/LocationCountyName"/><xsl:text>  </xsl:text><xsl:value-of select="CaseParticipants/CaseJudge/JudicialOfficialTypeText"/><xsl:text>:  </xsl:text><xsl:value-of select="CaseParticipants/CaseJudge/PersonName/PersonFullName"/>
<xsl:text>&#10;</xsl:text>
	<xsl:if test="count(Charge)>0">
<xsl:text>    </xsl:text><xsl:text>Charges&#10;</xsl:text>
	<xsl:for-each select="Charge">
<xsl:text>    </xsl:text><xsl:value-of select="ChargeID/ID"/><xsl:text>  </xsl:text><xsl:value-of select="ChargeID/IDSourceText"/><xsl:text>  </xsl:text><xsl:value-of select="ChargeClassification"/><xsl:text>  </xsl:text><xsl:value-of select="ChargeDescriptionText"/>
	<xsl:text>&#10;</xsl:text>
	</xsl:for-each>
	</xsl:if>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
