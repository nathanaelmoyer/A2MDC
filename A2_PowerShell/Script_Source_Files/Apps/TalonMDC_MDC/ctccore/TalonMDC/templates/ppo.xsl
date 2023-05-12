<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/08 MAH - Combined data & table template by adding node & isCaseView params
	   06/20/08 MAH - Added support for both Court and CaseCourt tags
					- Fixed Judge type prompt not displaying
					- Added defense & prosecution attorneys
					- Added CourtEvent
	   12/30/08 MAH - Changed data to be bold instead of labels
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- **************************************************************************** -->
  <!-- called from person.xsl & courtcases.xsl -->

  <xsl:template name="PPO" match="ProtectionOrder" mode="data" >
	<xsl:param name="node" />
	<xsl:param name="isCaseView" />

	<xsl:choose>
		<xsl:when test="contains($isCaseView,'true')">
			<p class="ctc_page_subtitle_1">Protection Orders</p>
		</xsl:when>
		<xsl:otherwise>
			<p class="ctc_page_subtitle_1">Protection Orders</p>		
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:for-each select="$node">
		<xsl:variable name="tagCourtName" select="CourtOrderIssuingCourt/CourtName"/>
		<xsl:variable name="tagJudgeType" select="CourtOrderIssuingJudicialOfficial/JudicialOfficialTypeText"/>
		<xsl:variable name="tagJudgeName" select="CourtOrderIssuingJudicialOfficial/PersonName/PersonFullName"/>
		<xsl:variable name="tagActDate" select="CourtOrderIssuingDate"/>
		<xsl:variable name="tagStatus" select="CourtOrderStatus/StatusText"/>
		<xsl:variable name="tagConditions" select="ConditionDisciplinaryAction"/>
	      <xsl:variable name="personLast" select="ProtectionOrderRestrictedPerson/PersonName/PersonSurName" />
	      <xsl:variable name="personFirst" select="ProtectionOrderRestrictedPerson/PersonName/PersonGivenName" />
	      <xsl:variable name="personMid" select="ProtectionOrderRestrictedPerson/PersonName/PersonMiddleName" />
	      <xsl:variable name="tagProtectedPerson" select="concat($personLast,', ', $personFirst,' ',$personMid)" />

		<table width="100%">
			<tr class="ctc_tbl_row" valign="top" >
				<xsl:if test="count($personLast)>0">
					<td class="ctc_tbl_data">Protected: <strong><xsl:value-of select="$tagProtectedPerson"/></strong></td>
				</xsl:if>
			</tr>
			<tr class="ctc_tbl_row" valign="top">
				<xsl:if test="count($tagActDate)>0">
					<td class="ctc_tbl_data" nowrap="nowrap">Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagActDate"/></xsl:call-template></strong></td>
				</xsl:if>
				<xsl:if test="count($tagCourtName)>0">
					<td class="ctc_tbl_data">Court: <strong><xsl:value-of select="$tagCourtName"/></strong></td>
				</xsl:if>
				<td class="ctc_tbl_data" >
					<xsl:if test="count($tagJudgeType)>0"><xsl:value-of select="$tagJudgeType"/>: </xsl:if>
					<xsl:if test="count($tagJudgeName)>0"><strong><xsl:value-of select="$tagJudgeName"/></strong></xsl:if>
				</td>
			</tr>
			<tr class="ctc_tbl_row" valign="top" >
				<xsl:if test="count($tagStatus)>0">
					<td class="ctc_tbl_data" colspan="3">Status: <strong><xsl:value-of select="$tagStatus"/></strong></td>
				</xsl:if>
			</tr>
			<tr class="ctc_tbl_row" valign="top" >
				<xsl:if test="count($tagConditions)>0">
					<td class="ctc_tbl_data" colspan="3">Conditions: <strong><xsl:value-of select="$tagConditions"/></strong></td>
				</xsl:if>
			</tr>

		</table>


		<br/>
	</xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
