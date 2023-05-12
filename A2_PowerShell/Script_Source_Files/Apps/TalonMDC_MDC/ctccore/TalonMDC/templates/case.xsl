<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Combined data & table template by adding node & isCaseView params
	   06/20/05 MAH - Added support for both Court and CaseCourt tags
					- Fixed Judge type prompt not displaying
					- Added defense & prosecution attorneys
					- Added CourtEvent
	   12/08/06 MAH - Added CaseStatus
	   12/30/08 MAH - Changed data to be bold instead of labels
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- **************************************************************************** -->
  <!-- called from person.xsl & courtcases.xsl -->

  <xsl:template name="Case" match="Case" mode="data" >
	<xsl:param name="node" />
	<xsl:param name="isCaseView" />

	<xsl:choose>
		<xsl:when test="contains($isCaseView,'true')">
			<p class="ctc_page_subtitle_1">Court Cases</p>
		</xsl:when>
		<xsl:otherwise>
			<p class="ctc_page_subtitle_1">Cases</p>		
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:for-each select="$node">
		<xsl:variable name="tagCaseID" select="CaseTrackingID/ID"/>
		<xsl:variable name="tagActType" select="ActivityTypeText"/>
		<xsl:variable name="tagActDesc" select="ActivityDescriptionText"/>
		<xsl:variable name="tagActDate" select="ActivityDate"/>
		<xsl:variable name="tagCaseType" select="CaseTypeText"/>

		<xsl:variable name="tagCourtName" select="CaseCourt/CourtName"/>
		<xsl:variable name="tagCounty" select="CaseCourt/OrganizationLocation/LocationAddress/LocationCountyName"/>
		<!-- remove at later point when all TP's have been updated to use CaseCourt -->
		<xsl:variable name="tagCourtName2" select="Court/CourtName"/>
		<xsl:variable name="tagCounty2" select="Court/OrganizationLocation/LocationAddress/LocationCountyName"/>

		<xsl:variable name="numStatus" select="count(CaseStatus)"/>
		<xsl:variable name="tagStatusType" select="CaseStatus/StatusText"/>
		<xsl:variable name="tagStatusDate" select="CaseStatus/StatusDate"/>
		
		<xsl:variable name="numParticipants" select="count(CaseParticipants)"/>
		<xsl:variable name="tagJudgeType" select="CaseParticipants/CaseJudge/JudicialOfficialTypeText"/>
		<xsl:variable name="tagJudgeName" select="CaseParticipants/CaseJudge/PersonName/PersonFullName"/>
		<xsl:variable name="tagDefType" select="CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText"/>
		<xsl:variable name="tagDefName" select="CaseParticipants/CaseDefenseAttorney/PersonName/PersonFullName"/>
		<xsl:variable name="tagProsType" select="CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText"/>
		<xsl:variable name="tagProsName" select="CaseParticipants/CaseProsecutionAttorney/PersonName/PersonFullName"/>

		<table width="100%">
			<tr class="ctc_tbl_row" valign="top">
				<xsl:if test="count($tagActDate)>0">
					<td class="ctc_tbl_data" nowrap="nowrap">Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagActDate"/></xsl:call-template></strong></td>
				</xsl:if>
				<xsl:if test="count($tagCaseID)>0">
					<td class="ctc_tbl_data">Case ID: <strong><xsl:value-of select="$tagCaseID"/></strong></td>
				</xsl:if>
				<xsl:if test="count($tagActType)>0">
					<td class="ctc_tbl_data">Type: <strong><xsl:value-of select="$tagActType"/></strong></td>
				</xsl:if>
				<xsl:if test="count($tagActDesc)>0">
					<td class="ctc_tbl_data">Desc: <strong><xsl:value-of select="$tagActDesc"/></strong></td>
				</xsl:if>
			</tr>
			<tr class="ctc_tbl_row" valign="top">
				<xsl:if test="count($tagCaseType)>0">
					<td class="ctc_tbl_data">Case Type: <strong><xsl:value-of select="$tagCaseType"/></strong></td>
				</xsl:if>
				<xsl:if test="count($tagCourtName)>0">
					<td class="ctc_tbl_data" >Court: <strong><xsl:value-of select="$tagCourtName"/></strong></td>
				</xsl:if>
				<xsl:if test="count($tagCounty)>0">
					<td class="ctc_tbl_data">County: <strong><xsl:value-of select="$tagCounty"/></strong></td>
				</xsl:if>
				<xsl:if test="count($tagCourtName2)>0">
					<td class="ctc_tbl_data" >Court: <strong><xsl:value-of select="$tagCourtName2"/></strong></td>
				</xsl:if>
				<xsl:if test="count($tagCounty2)>0">
					<td class="ctc_tbl_data">County: <strong><xsl:value-of select="$tagCounty2"/></strong></td>
				</xsl:if>
				<xsl:if test="$numStatus > 0">
					<td class="ctc_tbl_data" nowrap="nowrap">
						Status: 
						<xsl:if test="count($tagStatusType)>0"><strong><xsl:value-of select="$tagStatusType"/></strong></xsl:if>&#160;
						<xsl:if test="count($tagStatusDate)>0"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagStatusDate"/></xsl:call-template></strong></xsl:if>
					</td>
				</xsl:if>
			</tr>
			<xsl:if test="$numParticipants > 0">
			<tr class="ctc_tbl_row" valign="top">
				<td class="ctc_tbl_data" >
					<xsl:if test="count($tagJudgeType)>0"><xsl:value-of select="$tagJudgeType"/>: </xsl:if>
					<xsl:if test="count($tagJudgeName)>0"><strong><xsl:value-of select="$tagJudgeName"/></strong></xsl:if>
				</td>
				<td class="ctc_tbl_data" >
					<xsl:if test="count($tagDefType)>0"><xsl:value-of select="$tagDefType"/>: </xsl:if>
					<xsl:if test="count($tagDefName)>0"><strong><xsl:value-of select="$tagDefName"/></strong></xsl:if>
				</td>
				<td class="ctc_tbl_data" >
					<xsl:if test="count($tagProsType)>0"><xsl:value-of select="$tagProsType"/>: </xsl:if>
					<xsl:if test="count($tagProsName)>0"><strong><xsl:value-of select="$tagProsName"/></strong></xsl:if>
				</td>
			</tr>
			</xsl:if>
		</table>

		<xsl:if test="count(Charge)>0">
			<blockquote>
				<xsl:variable name="tagChargeID" select="Charge/ChargeID/ID"/>
				<xsl:variable name="tagChargeIDText" select="Charge/ChargeID/IDSourceText"/>
				<xsl:variable name="tagClass" select="Charge/ChargeClassification"/>
				<xsl:variable name="tagDesc" select="Charge/ChargeDescriptionText"/>
	
				<p class="ctc_page_subtitle_1">Charges</p>
				
				<table width="100%">
					<tr class="ctc_tbl_headrow">
						<xsl:if test="count($tagChargeID)>0"><td class="ctc_tbl_center_hdr">ID</td></xsl:if>
						<xsl:if test="count($tagChargeIDText)>0"><td class="ctc_tbl_center_hdr">Agency</td></xsl:if>
						<xsl:if test="count($tagClass)>0"><td class="ctc_tbl_center_hdr">CD/PACC</td></xsl:if>
						<xsl:if test="count($tagDesc)>0"><td class="ctc_tbl_center_hdr">Charge</td></xsl:if>
					</tr>
					
					<!-- Loop through each Charge tag under Case -->
					<xsl:for-each select="Charge">
						<xsl:variable name="tagChargeID" select="ChargeID/ID"/>
						<xsl:variable name="tagChargeIDText" select="ChargeID/IDSourceText"/>
						<xsl:variable name="tagClass" select="ChargeClassification"/>
						<xsl:variable name="tagDesc" select="ChargeDescriptionText"/>
						<tr class="ctc_tbl_row" valign="top">
							<xsl:if test="count($tagChargeID)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagChargeID"/></td>
							</xsl:if>
							<xsl:if test="count($tagChargeIDText)>0">
								<td class="ctc_tbl_data" ><xsl:value-of select="$tagChargeIDText"/></td>
							</xsl:if>
							<xsl:if test="count($tagClass)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagClass"/></td>
							</xsl:if>
							<xsl:if test="count($tagDesc)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagDesc"/></td>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</table>
			</blockquote>
		</xsl:if>

		<xsl:if test="count(CourtEvent)>0">
			<blockquote>
				<xsl:variable name="tagEventActType" select="CourtEvent/CourtEventActivity/ActivityTypeText"/>
				<xsl:variable name="tagEventActDesc" select="CourtEvent/CourtEventActivity/ActivityDescriptionText"/>
				<xsl:variable name="tagEventActDate" select="CourtEvent/CourtEventActivity/ActivityDate"/>
				<xsl:variable name="tagEventJudgeName" select="CourtEvent/CourtEventJudge/PersonName/PersonFullName"/>
	
				<p class="ctc_page_subtitle_1">Events</p>
				
				<table width="100%">
					<tr class="ctc_tbl_headrow">
						<xsl:if test="count($tagEventActDate)>0"><td class="ctc_tbl_center_hdr">Date</td></xsl:if>
						<xsl:if test="count($tagEventActType)>0"><td class="ctc_tbl_center_hdr">Proceeding</td></xsl:if>
						<xsl:if test="count($tagEventJudgeName)>0"><td class="ctc_tbl_center_hdr">Judge</td></xsl:if>
						<xsl:if test="count($tagEventActDesc)>0"><td class="ctc_tbl_center_hdr">Result</td></xsl:if>
					</tr>
					
					<!-- Loop through each CourtEvent tag under Case -->
					<xsl:for-each select="CourtEvent">
						<xsl:variable name="tagEventActType" select="CourtEventActivity/ActivityTypeText"/>
						<xsl:variable name="tagEventActDesc" select="CourtEventActivity/ActivityDescriptionText"/>
						<xsl:variable name="tagEventActDate" select="CourtEventActivity/ActivityDate"/>
						<xsl:variable name="tagEventJudgeName" select="CourtEventJudge/PersonName/PersonFullName"/>
						<tr class="ctc_tbl_row" valign="top">
							<xsl:if test="count($tagEventActDate)>0">
								<td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagEventActDate"/></xsl:call-template></td>
							</xsl:if>
							<xsl:if test="count($tagEventActType)>0">
								<td class="ctc_tbl_data" ><xsl:value-of select="$tagEventActType"/></td>
							</xsl:if>
							<xsl:if test="count($tagEventJudgeName)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagEventJudgeName"/></td>
							</xsl:if>
							<xsl:if test="count($tagEventActDesc)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagEventActDesc"/></td>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</table>
			</blockquote>
		</xsl:if>

		<br/>
	</xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
