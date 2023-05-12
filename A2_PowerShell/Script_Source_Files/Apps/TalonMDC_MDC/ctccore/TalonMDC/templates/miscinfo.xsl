<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	   06/20/05 MAH - Created
	   09/14/05 MAH - Added CAD
	   09/29/05 MAH - Updated CAD - reports and incidents
	   03/13/07 MAH - Updated CAD incidents for LPD
	   03/22/07 MAH - Changed LPD CAD Mod tag
	   03/28/07 MAH - Changed ctcCAD tags to just c
	   04/20/07 MAH - Modified cell spacing on CAD
			- Switched bold on CAD incident from prompt to data
			- Use cad style sheets for data
	   01/07/09 MAH - Added formatted CAD Incident Report
	   02/12/09 MAH - Added more Time fields to CAD Incident and Incident Recall Report
	   03/26/09 MAH - Added cUnitsAssigned to CAD Incident and Incident Recall Report
  -->
	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<!-- *************************** -->


	<xsl:template name="MiscInfo_Single" match="MiscInfo" mode="single">
		<xsl:variable name="tagMetadata" select="Content/DocumentDescriptiveMetadata"/>
		<xsl:variable name="tagOrg" select="$tagMetadata/DocumentContributor.Organization"/>
		<xsl:variable name="tagContact" select="$tagOrg/OrganizationPrimaryContact"/>
		<xsl:variable name="tagCADEvent" select="Content/cEvent"/>
		<xsl:variable name="tagCADFields" select="$tagCADEvent/cFields"/>

		<xsl:if test="count($tagMetadata/DocumentCommentText)>0">
			<p class="ctc_tbl_data">
				<xsl:value-of select="$tagMetadata/DocumentCommentText"/>
			</p>
		</xsl:if>

		<!-- TalonPoint Organization Info -->
		<xsl:if test="(count($tagOrg)>0) or (count($tagContact)>0)">
			<table border="0">
				<tr class="ctc_tbl_data">
					<td>Organization ID:</td>
					<td><strong><xsl:value-of select="$tagOrg/OrganizationID/ID"/></strong></td>
				</tr>
				<tr class="ctc_tbl_data">
					<td>Organization Name:</td>
					<td><strong><xsl:value-of select="$tagOrg/OrganizationName"/></strong></td>
				</tr>
				<tr class="ctc_tbl_data">
					<td>Contact:</td>
					<td><strong><xsl:value-of select="$tagContact/ContactPerson/PersonName/PersonFullName"/></strong></td>
				</tr>
				<tr class="ctc_tbl_data">
					<td>Phone:</td>
					<td><strong><xsl:value-of select="$tagContact/ContactTelephoneNumber/TelephoneNumberFullID"/></strong></td>
				</tr>
				<tr class="ctc_tbl_data">
					<td>Email:</td>
					<td><strong><xsl:value-of select="$tagContact/ContactEmailID/ID"/></strong></td>
				</tr>
			</table>
		</xsl:if>

		<!-- CAD -->
		<xsl:if test="count($tagCADEvent)>0">
			<!-- Check cEvent attribute ClassName for type of CAD event (com.ctccore.talon.cad.xxxxx) -->
			<xsl:variable name="cadClass" select="$tagCADEvent/@ClassName"/>
			<xsl:choose>
				<!-- EvtIncidentInfo -->
				<xsl:when test="contains($cadClass,'EvtIncidentInfo')">
					<!--cFields cErrorFlag="false" cSuccessFlag="false">
						<cAddress FieldType="class java.lang.String">123 Main St</cAddress>
						<cCADUserID FieldType="class java.lang.String">Andy</cCADUserID>
						<cIncidentNumber FieldType="class java.lang.String">000123</cIncidentNumber>
						<cIncidentType FieldType="class java.lang.String">FIGHT</cIncidentType>
						<cPriority FieldType="class java.lang.String">2</cPriority>
					  </cFields-->
					<xsl:variable name="incMsgText" select="$tagCADFields/cMessageText"/>
					<xsl:variable name="incNum" select="$tagCADFields/cIncidentNumber"/>
					<xsl:choose>
						<xsl:when test="count($incMsgText)>0">
							<table border="0" width="100%"  cellpadding="0" cellspacing="0">
								<tr>
									<td class="ctc_msg_title">
										<xsl:value-of select="@DateCreated"/>
										&#160;|&#160;<xsl:value-of select="@TimeCreated"/>
										&#160;|&#160;<xsl:value-of select="$incNum"/>
									</td>
								</tr>
								<tr>
									<td class="ctc_msg_data">
										<pre>
											<xsl:value-of select="$incMsgText"/>
										</pre>
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>

								<xsl:call-template name="CADIncidentDetails"	>
										<xsl:with-param name="tagCADFields" select="$tagCADFields"/>
										<xsl:with-param name="incNumber" select="$incNum"/>
										<xsl:with-param name="includeDispatchHeader">true</xsl:with-param>	
								</xsl:call-template>

							<!--table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="ctc_msg_title"  colspan="6">
										<xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;CAD Incident: <xsl:value-of select="$incNum"/>
									</td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Units Attached: </td>
									<td colspan="5"><strong>
								  		<xsl:if test="(count($tagCADFields/cPrimaryUnit)>0) or (count($tagCADFields/cUnit01)>0)">
											<xsl:if test="count($tagCADFields/cPrimaryUnit)>0"><xsl:value-of select="$tagCADFields/cPrimaryUnit"/></xsl:if>
											<xsl:if test="count($tagCADFields/cUnit01)>0"><xsl:value-of select="$tagCADFields/cUnit01"/></xsl:if>
										</xsl:if>	
										<xsl:if test="count($tagCADFields/cUnitsAssigned)>0">, <xsl:value-of select="$tagCADFields/cUnitsAssigned"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit02)>0">, <xsl:value-of select="$tagCADFields/cUnit02"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit03)>0">, <xsl:value-of select="$tagCADFields/cUnit03"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit04)>0">, <xsl:value-of select="$tagCADFields/cUnit04"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit05)>0">, <xsl:value-of select="$tagCADFields/cUnit05"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit06)>0">, <xsl:value-of select="$tagCADFields/cUnit06"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit07)>0">, <xsl:value-of select="$tagCADFields/cUnit07"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit08)>0">, <xsl:value-of select="$tagCADFields/cUnit08"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit09)>0">, <xsl:value-of select="$tagCADFields/cUnit09"/></xsl:if>
										<xsl:if test="count($tagCADFields/cUnit10)>0">, <xsl:value-of select="$tagCADFields/cUnit10"/></xsl:if>
									</strong>
									</td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Priority Comment: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cSpecialComment"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Business Name: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cBusinessName"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Apt: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cApartment"/></strong></td>
									<td>Bldg: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cBuilding"/></strong></td>
									<td>Addr: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cAddress"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Xst1: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cComplainantsAddressCrossStreets"/></strong></td>
									<td>Xst2: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cCrossStreet2"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Prem: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cPremiseFlags"/></strong></td>
									<td>Contact: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cSeeComplainant"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Cname: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cComplainantsName"/></strong></td>
									<td>Caddr: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cComplainantsAddress"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Cphon: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cComplainantsPhone"/></strong></td>
								</tr-->

								<!-- OLD
									tr class="ctc_tbl_data_cad">
									<td>Type: </td>
									<td>
										<table border="0">
											<tr>
												<td><strong><xsl:value-of select="$tagCADFields/cIncidentType"/></strong>&#160;&#160;</td>
												<td>Mod: </td>
												<td><strong><xsl:value-of select="$tagCADFields/cModifyingCircumstances"/></strong></td>
											</tr>
										</table>
									</td>
									<td>Call Recv: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cTimeCallReceived"/></strong></td>
									<td>Pri: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cPriority"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Loc: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cLocation"/></strong></td>
									<td>Dist: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cBeat"/></strong></td>
									<td>Map: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cMap"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Inc #: </td>
									<td><strong><xsl:value-of select="$tagCADFields/cIncidentNumber"/></strong></td>
								</tr>
								<xsl:if test="(count($tagCADFields/cTimeDispatched)>0) or (count($tagCADFields/cTimeEnroute)>0)">
									<tr class="ctc_tbl_data_cad">
										<td>Dispatched: </td>
										<td><strong><xsl:value-of select="$tagCADFields/cTimeDispatched"/></strong></td>
										<td>Enroute: </td>
										<td><strong><xsl:value-of select="$tagCADFields/cTimeEnroute"/></strong></td>
									</tr>
								</xsl:if>
								<xsl:if test="(count($tagCADFields/cTimeOnscene)>0) or (count($tagCADFields/cTimeComplete)>0)">
									<tr class="ctc_tbl_data_cad">
										<td>On Scene: </td>
										<td><strong><xsl:value-of select="$tagCADFields/cTimeOnscene"/></strong></td>
										<td>Complete: </td>
										<td><strong><xsl:value-of select="$tagCADFields/cTimeComplete"/></strong></td>
									</tr>
								</xsl:if-->
								<!--tr class="ctc_tbl_headrow_cad">
									<td colspan="6">Comments:</td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td colspan="6"><pre><strong><xsl:value-of select="$tagCADFields/cComments"/></strong></pre></td>
								</tr>
							</table-->
						</xsl:otherwise>
						<!--xsl:otherwise>
							<table border="0">
								<tr class="ctc_tbl_headrow">
									<td>Call Received</td>
									<td>Inc. #</td>
									<td>Type</td>
									<td>Priority</td>
									<td>Unit</td>
									<td>UnitsAssigned</td>
								</tr>
								<tr class="ctc_tbl_data">
									<td><xsl:value-of select="$tagCADFields/cTimeCallReceived"/></td>
									<td><xsl:value-of select="$tagCADFields/cIncidentNumber"/></td>
									<td><xsl:value-of select="$tagCADFields/cIncidentType"/></td>
									<td><xsl:value-of select="$tagCADFields/cPriority"/></td>
									<td><xsl:value-of select="$tagCADFields/cUnit"/></td>
									<td><xsl:value-of select="$tagCADFields/cUnitsAssigned"/></td>
								</tr>
								<tr class="ctc_tbl_headrow">
									<td>Location</td>
									<td>Address</td>
									<td colspan="3">Cross Streets</td>
								</tr>
								<tr class="ctc_tbl_data">
									<td><xsl:value-of select="$tagCADFields/cLocation"/></td>
									<td><xsl:value-of select="$tagCADFields/cAddress"/></td>
									<td colspan="3"><xsl:value-of select="$tagCADFields/cCrossStreets"/></td>
								</tr>
								<tr class="ctc_tbl_headrow">
									<td>Complainant</td>
									<td>Phone</td>
									<td colspan="3">Address</td>
								</tr>
								<tr class="ctc_tbl_data">
									<td><xsl:value-of select="$tagCADFields/cComplainantsName"/></td>
									<td><xsl:value-of select="$tagCADFields/cComplainantsPhone"/></td>
									<td colspan="3"><xsl:value-of select="$tagCADFields/cComplainantsAddress"/></td>
								</tr>
								<tr class="ctc_tbl_headrow">
									<td colspan="5">Additional Information</td>
								</tr>
								<tr class="ctc_tbl_data">
									<td colspan="5"><xsl:value-of select="$tagCADFields/cComments"/></td>
								</tr>
							</table>
						</xsl:otherwise-->
					</xsl:choose>
				</xsl:when>

				<!-- EvtReportResponse -->
				<xsl:when test="contains($cadClass,'EvtReportResponse')">
					<xsl:variable name="rptType" select="$tagCADFields/cReportType"/>
					<xsl:variable name="rptMsgText" select="$tagCADFields/cMessageText"/>
					<xsl:variable name="rptXML" select="$tagCADFields/cReportXML"/>
					<!--Option 1 - Text only-->
					<xsl:if test="count($rptMsgText)>0">
						<table border="0" width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td class="ctc_msg_title">
									<xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;<xsl:value-of select="$rptType"/>
								</td>
							</tr>
							<tr>
								<td>
									<pre class="ctc_msg_data">
										<xsl:value-of select="$rptMsgText"/>
									</pre>
								</td>
							</tr>
						</table>
					</xsl:if>
					<!-- Option 2 - Formatted
					  <cFields cErrorFlag="false" cSuccessFlag="false">
						<cMBUserID FieldType="class java.lang.String">A</cMBUserID>
						<cReportType>Query Incident</cReportType>
						<cReportXML>
						  <blahReportXML>
							<SomeReportTag/>
							<Someothertag>
							  Some embedded report text!
							</Someothertag>
						  </blahReportXML>
						</cReportXML>
					  </cFields>
					-->
					<xsl:if test="count($rptXML)>0">

						<!--xsl:variable name="rptFields" select="$rptXML/cEvent/cFields"/-->
						<xsl:variable name="rptFields" select="$rptXML"/>

						<table border="0" width="100%"  cellpadding="0" cellspacing="0">
							<tr>
								<td class="ctc_msg_title">
									<xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;<xsl:value-of select="$rptType"/>
								</td>
							</tr>
						</table>
						<xsl:choose>
						<!--
							<xsl:when test="contains($rptType,'Unit')">
								<table border="0" width="100%">
									<tr>
										<td>Formatted Report</td>
									</tr>
								</table>
							</xsl:when>
							<xsl:when test="contains($rptType,'Active')">
								<table border="0" width="100%">
									<tr>
										<td>Formatted Report</td>
									</tr>
								</table>
							</xsl:when>
							<xsl:when test="contains($rptType,'MDT')">
								<table border="0" width="100%">
									<tr>
										<td>Formatted Report</td>
									</tr>
								</table>
							</xsl:when>
					-->
							<xsl:when test="contains($rptType,'Incident')">
								
								<xsl:apply-templates select="$rptFields/ReportXML/Incident" mode="rpt"/>
							
								<!--xsl:call-template name="CADIncidentRecallDetails"	>
										<xsl:with-param name="tagCADFields" select="$rptFields/ReportXML/Incident"/>
										<xsl:with-param name="incNumber"> </xsl:with-param>	
										<xsl:with-param name="includeDispatchHeader">true</xsl:with-param>	
								</xsl:call-template-->
							
							<!--table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr class="ctc_tbl_data_cad">
									<td>Type: </td>
									<td>
										<table border="0">
											<tr>
												<td><strong><xsl:value-of select="$rptFields/cIncidentType"/></strong>&#160;&#160;</td>
												<td>Mod: </td>
												<td><strong><xsl:value-of select="$rptFields/cModifyingCircumstances"/></strong></td>
											</tr>
										</table>
									</td>
									<td>Call Recv: </td>
									<td><strong><xsl:value-of select="$rptFields/cTimeCallReceived"/></strong></td>
									<td>Pri: </td>
									<td><strong><xsl:value-of select="$rptFields/cPriority"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Addr: </td>
									<td><strong><xsl:value-of select="$rptFields/cAddress"/></strong></td>
									<td>Bldg: </td>
									<td><strong><xsl:value-of select="$rptFields/cBuilding"/></strong></td>
									<td>Apt: </td>
									<td><strong><xsl:value-of select="$rptFields/cApartment"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Loc: </td>
									<td><strong><xsl:value-of select="$rptFields/cLocation"/></strong></td>
									<td>Dist: </td>
									<td><strong><xsl:value-of select="$rptFields/cBeat"/></strong></td>
									<td>Map: </td>
									<td><strong><xsl:value-of select="$rptFields/cMap"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Xst1: </td>
									<td><strong><xsl:value-of select="$rptFields/cCrossStreet1"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Xst2: </td>
									<td><strong><xsl:value-of select="$rptFields/cCrossStreet2"/></strong></td>
									<td>Prem: </td>
									<td><strong><xsl:value-of select="$rptFields/cPremiseFlags"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Disp: </td>
									<td colspan="5"><strong>
								  		<xsl:if test="(count($rptFields/cPrimaryUnit)>0) or (count($rptFields/cUnit01)>0)">
											<xsl:if test="count($rptFields/cPrimaryUnit)>0"><xsl:value-of select="$rptFields/cPrimaryUnit"/></xsl:if>
											<xsl:if test="count($rptFields/cUnit01)>0"><xsl:value-of select="$rptFields/cUnit01"/></xsl:if>
										</xsl:if>	
										<xsl:if test="count($rptFields/cUnitsAssigned)>0">, <xsl:value-of select="$rptFields/cUnitsAssigned"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit02)>0">, <xsl:value-of select="$rptFields/cUnit02"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit03)>0">, <xsl:value-of select="$rptFields/cUnit03"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit04)>0">, <xsl:value-of select="$rptFields/cUnit04"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit05)>0">, <xsl:value-of select="$rptFields/cUnit05"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit06)>0">, <xsl:value-of select="$rptFields/cUnit06"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit07)>0">, <xsl:value-of select="$rptFields/cUnit07"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit08)>0">, <xsl:value-of select="$rptFields/cUnit08"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit09)>0">, <xsl:value-of select="$rptFields/cUnit09"/></xsl:if>
										<xsl:if test="count($rptFields/cUnit10)>0">, <xsl:value-of select="$rptFields/cUnit10"/></xsl:if>
									</strong>
									</td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Inc #: </td>
									<td><strong><xsl:value-of select="$rptFields/cIncidentNumber"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Cname: </td>
									<td><strong><xsl:value-of select="$rptFields/cComplainantsName"/></strong></td>
									<td>Caddr: </td>
									<td><strong><xsl:value-of select="$rptFields/cComplainantsAddress"/></strong></td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td>Cphon: </td>
									<td><strong><xsl:value-of select="$rptFields/cComplainantsPhone"/></strong></td>
									<td>Contact: </td>
									<td><strong><xsl:value-of select="$rptFields/cSeeComplainant"/></strong></td>
								</tr>
								<xsl:if test="(count($rptFields/cTimeDispatched)>0) or (count($rptFields/cTimeEnroute)>0)">
									<tr class="ctc_tbl_data_cad">
										<td>Dispatched: </td>
										<td><strong><xsl:value-of select="$rptFields/cTimeDispatched"/></strong></td>
										<td>Enroute: </td>
										<td><strong><xsl:value-of select="$rptFields/cTimeEnroute"/></strong></td>
									</tr>
								</xsl:if>
								<xsl:if test="(count($rptFields/cTimeOnscene)>0) or (count($rptFields/cTimeComplete)>0)">
									<tr class="ctc_tbl_data_cad">
										<td>On Scene: </td>
										<td><strong><xsl:value-of select="$rptFields/cTimeOnscene"/></strong></td>
										<td>Complete: </td>
										<td><strong><xsl:value-of select="$rptFields/cTimeComplete"/></strong></td>
									</tr>
								</xsl:if>

								<tr class="ctc_tbl_headrow_cad">
									<td colspan="6">Comments:</td>
								</tr>
								<tr class="ctc_tbl_data_cad">
									<td colspan="6"><pre><strong><xsl:value-of select="$rptFields/cComments"/></strong></pre></td>
								</tr>
								</table-->
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

  <!-- *************************** -->

    <xsl:template name="CADIncidentDetails">
		<xsl:param name="tagCADFields"/>
		<xsl:param name="includeDispatchHeader"/>
		<xsl:param name="incNumber"/>

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<xsl:if test="string-length($includeDispatchHeader) > 0">
				<tr>
					<td class="ctc_msg_title"  colspan="6">
						<xsl:value-of select="@DateCreated"/>
						&#160;|&#160;<xsl:value-of select="@TimeCreated"/>
						&#160;|&#160;CAD CFS#: <xsl:value-of select="$incNumber"/>
					</td>
				</tr>
			</xsl:if>
			<tr class="ctc_tbl_data_cad">
				<td>UNITS ATTACHED: </td>
<!-- 12/22/10 jtg TODO: Need handling for @isElementChangeDetected here too, if ANY of these fields change. -->
				<td colspan="3"><strong>
					<xsl:if test="(count($tagCADFields/cPrimaryUnit)>0) or (count($tagCADFields/cUnit01)>0)">
						<xsl:if test="count($tagCADFields/cPrimaryUnit)>0"><xsl:value-of select="$tagCADFields/cPrimaryUnit"/></xsl:if>
						<xsl:if test="count($tagCADFields/cUnit01)>0"><xsl:value-of select="$tagCADFields/cUnit01"/></xsl:if>
					</xsl:if>	
					<xsl:if test="string-length($tagCADFields/cUnitsAssigned)>0">
						<xsl:if test="(string-length($tagCADFields/cPrimaryUnit)>0) or (string-length($tagCADFields/cUnit01)>0)">, </xsl:if>
					    <xsl:value-of select="$tagCADFields/cUnitsAssigned"/>
					</xsl:if>
					<xsl:if test="count($tagCADFields/cUnit02)>0">, <xsl:value-of select="$tagCADFields/cUnit02"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit03)>0">, <xsl:value-of select="$tagCADFields/cUnit03"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit04)>0">, <xsl:value-of select="$tagCADFields/cUnit04"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit05)>0">, <xsl:value-of select="$tagCADFields/cUnit05"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit06)>0">, <xsl:value-of select="$tagCADFields/cUnit06"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit07)>0">, <xsl:value-of select="$tagCADFields/cUnit07"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit08)>0">, <xsl:value-of select="$tagCADFields/cUnit08"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit09)>0">, <xsl:value-of select="$tagCADFields/cUnit09"/></xsl:if>
					<xsl:if test="count($tagCADFields/cUnit10)>0">, <xsl:value-of select="$tagCADFields/cUnit10"/></xsl:if>
				</strong>
				</td>
				<!--td>Type: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cIncidentType"/></strong></td-->
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>CALL TYPE: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cIncidentType" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cIncidentType/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
				<td>IN PROGRESS: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cInProgress" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cInProgress/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
				<!--td>OFC CNTCT: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cSeeComplainant" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cSeeComplainant/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template-->
				<!--td>WEAPONS: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cWeapons" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cWeapons/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template-->
			</tr>
			<!--tr class="ctc_tbl_data_cad"-->
                <!--td>PRIORITY COMMENT: </td-->
                <!--xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cSpecialComment" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cSpecialComment/@isElementChangeDetected" /></xsl:with-param>
                    <xsl:with-param name="colSpan">3</xsl:with-param>
                </xsl:call-template-->
			<!--/tr-->
			<tr class="ctc_tbl_data_cad">
                <td>ADDRESS: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cAddress" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cAddress/@isElementChangeDetected" /></xsl:with-param>
                    <xsl:with-param name="colSpan">3</xsl:with-param>
                </xsl:call-template>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>COMMON NAME: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cBusinessName" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cBusinessName/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>APT: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cApartment" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cApartment/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
				<!--td>BLDG: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cBuilding" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cBuilding/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template-->
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>CROSS ST: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cCrossStreet1" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cCrossStreet1/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>CALL RECEIVED: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText">
                      <xsl:call-template name="standard_date_time">
                        <xsl:with-param name="date" select="$tagCADFields/cTimeReceived" />
					  </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cTimeReceived/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>COMPLAINANT: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cComplainantsName" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cComplainantsName/@isElementChangeDetected" /></xsl:with-param>
                    <xsl:with-param name="colSpan">3</xsl:with-param>
                </xsl:call-template>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>ADDRESS: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cComplainantsAddress" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cComplainantsAddress/@isElementChangeDetected" /></xsl:with-param>
                    <xsl:with-param name="colSpan">3</xsl:with-param>
                </xsl:call-template>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>PHONE: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cComplainantsPhone" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cComplainantsPhone/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
			</tr>
            <tr class="ctc_tbl_data_cad">
                <td>INC #: </td>
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cReportNumber" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cReportNumber/@isElementChangeDetected" /></xsl:with-param>
                </xsl:call-template>
                <!-- 2/6/11 jtg: Right now it's cFields/cEmbeddedXML/DispatchReferenceNumbers,
                 but '//' looks for matches anywhere under cFields, in case it's moved up or down. -->
                <!--xsl:for-each select="$tagCADFields//DispatchReferenceNumbers/DispatchReferenceNumber">
                    <xsl:sort select="Agency"/>
                    <xsl:sort select="Number"/-->
                    <!-- 
                    <td>
                        <xsl:value-of select="Agency" />/<xsl:value-of select="Number" />, 
                    </td>
                    -->
                    <!--xsl:call-template name="CADIncidentDataItem">
                        <xsl:with-param name="elementText"><xsl:value-of select="." /></xsl:with-param>
                        <xsl:with-param name="isChanged"><xsl:value-of select="./@isElementChangeDetected" /></xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each-->
            </tr>
			<!--tr class="ctc_tbl_data_cad">
				<td>Type: </td>
				<td>
					<table border="0">
						<tr>
							<td><strong><xsl:value-of select="$tagCADFields/cIncidentType"/></strong>&#160;&#160;</td>
							<td>Mod: </td>
							<td><strong><xsl:value-of select="$tagCADFields/cModifyingCircumstances"/></strong></td>
						</tr>
					</table>
				</td>
				<td>Call Recv: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cTimeCallReceived"/></strong></td>
				<td>Pri: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cPriority"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>Loc: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cLocation"/></strong></td>
				<td>Dist: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cBeat"/></strong></td>
				<td>Map: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cMap"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>Inc #: </td>
				<td><strong><xsl:value-of select="$tagCADFields/cIncidentNumber"/></strong></td>
			</tr>
			<xsl:if test="(count($tagCADFields/cTimeDispatched)>0) or (count($tagCADFields/cTimeEnroute)>0)">
				<tr class="ctc_tbl_data_cad">
					<td>Dispatched: </td>
					<td><strong><xsl:value-of select="$tagCADFields/cTimeDispatched"/></strong></td>
					<td>Enroute: </td>
					<td><strong><xsl:value-of select="$tagCADFields/cTimeEnroute"/></strong></td>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagCADFields/cTimeOnscene)>0) or (count($tagCADFields/cTimeComplete)>0)">
				<tr class="ctc_tbl_data_cad">
					<td>On Scene: </td>
					<td><strong><xsl:value-of select="$tagCADFields/cTimeOnscene"/></strong></td>
					<td>Complete: </td>
					<td><strong><xsl:value-of select="$tagCADFields/cTimeComplete"/></strong></td>
				</tr>
			</xsl:if-->
			<tr class="ctc_tbl_headrow_cad">
				<td colspan="6">DISPATCH NOTES:</td>
			</tr>
            <!-- 
			<tr class="ctc_tbl_data_cad">
                <xsl:call-template name="CADIncidentDataItem">
                    <xsl:with-param name="elementText"><xsl:value-of select="$tagCADFields/cComments" /></xsl:with-param>
                    <xsl:with-param name="isChanged"><xsl:value-of select="$tagCADFields/cComments/@isElementChangeDetected" /></xsl:with-param>
                    <xsl:with-param name="colSpan">6</xsl:with-param>
                    <xsl:with-param name="isPre">true</xsl:with-param>
                </xsl:call-template>
			</tr>
            -->
            <tr class="ctc_tbl_data_cad">
                <td colspan="6">
                <table border="0" width="100%" cellpadding="5" cellspacing="0">
                
                <!-- 7/27/11 jtg: Right now it's cFields/cCommentsXml/IncidentComments,
                 but '//' looks for matches anywhere under cFields, in case it's moved up or down. -->
                <xsl:for-each select="$tagCADFields//IncidentComments/Comment">
                    <xsl:sort select="@commentId" order="descending" data-type="number"/>
                    <xsl:sort select="TimeCreated" order="descending"/>
                    <tr>
                    <xsl:call-template name="CADIncidentDataItem">
                        <xsl:with-param name="elementText"><xsl:value-of select="TimeCreated" /></xsl:with-param>
                        <xsl:with-param name="isChanged"><xsl:value-of select="./@isElementChangeDetected" /></xsl:with-param>
                        <xsl:with-param name="width">1%</xsl:with-param>
                        <xsl:with-param name="isPre">true</xsl:with-param>
                        <xsl:with-param name="valign">top</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="CADIncidentDataItem">
                        <xsl:with-param name="elementText"><xsl:value-of select="Text" /></xsl:with-param>
                        <xsl:with-param name="isChanged"><xsl:value-of select="./@isElementChangeDetected" /></xsl:with-param>
                        <xsl:with-param name="isPre">false</xsl:with-param>
                        <xsl:with-param name="valign">top</xsl:with-param>
                    </xsl:call-template>
                    </tr>
                </xsl:for-each>
                </table>
                </td>
            </tr>
		</table>
    
    </xsl:template>	

  <!-- *************************** -->
  
  <xsl:template name="CADIncidentDataItem">
    <xsl:param name="elementText" />
    <xsl:param name="isChanged">false</xsl:param>
    <xsl:param name="colSpan">1</xsl:param>
    <xsl:param name="isPre">false</xsl:param>
    <xsl:param name="width">auto</xsl:param>
    <xsl:param name="valign">middle</xsl:param>
    
<!-- 12/22/10 jtg: Currently isPre is only set by cComments, and we honor it here, although when
the html is displayed in Talon, everything is fixed-width.  Somebody else must be doing that. -->

<!-- 12/22/10 jtg: I picked teal because it shows up well in both day & night modes; there isn't
currently a way for the stylesheet to know which mode is active so this covers either case. -->

<!-- 07/20/11 jtg: Changed color to orange (#FFA500) per customer request. -->

<!-- 02/01/12 jtg: Changed color to blue (#1E90FF) per customer request. -->

    <xsl:variable name="myStyle">
        <xsl:choose>
            <xsl:when test="$isChanged = 'true'">color:#1E90FF</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!--td colspan="{$colSpan}" style="{$myStyle}" width="{$width}" valign="{$valign}"-->
    <!-- 04/14/2017 dah: valign wasn't working.  Changed to vertical-align in the style -->
    <td colspan="{$colSpan}" style="{$myStyle} vertical-align:{$valign}" width="{$width}">
        <xsl:if test="$isPre = 'true'">&lt;pre&gt;</xsl:if>
        <strong>
            <xsl:value-of select="$elementText" />
        </strong>
        <xsl:if test="$isPre = 'true'">&lt;/pre&gt;</xsl:if>
    </td>
  </xsl:template>

	<!-- *************************** -->
	<xsl:template name="standard_date_time">
		<!-- Formats YYYY-MM-DDThh:mm:ss to MM/DD/YYYY hh:mm:ss
	    Keeps any other date format in its original format
        -->
		<xsl:param name="date"/>
		<xsl:choose>
			<xsl:when test="substring($date,5,1)='-'">
				<xsl:variable name="day" select="substring($date, 9, 2)"/>
				<xsl:variable name="month" select="substring($date, 6, 2)"/>
				<xsl:variable name="year" select="substring($date, 1, 4)"/>
				<xsl:variable name="time" select="substring($date, 12, 8)"/>
				
				<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"/>&#160;<xsl:value-of select="$time"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <!-- *************************** -->
  
    <xsl:template name="CADIncidentRecallDetails" match="Incident" mode="rpt">
		<!--xsl:param name="tagCADFields"/>
		<xsl:param name="includeDispatchHeader"/>
		<xsl:param name="incNumber"/-->

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!--xsl:if test="string-length($includeDispatchHeader) > 0">
				<tr>
					<td class="ctc_msg_title"  colspan="6">
						<xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;CAD Incident: <xsl:value-of select="$incNumber"/>
					</td>
				</tr>
			</xsl:if-->
			<tr class="ctc_tbl_data_cad">
				<td>CFS#: </td>
				<td colspan="4"><strong><xsl:value-of select="@incidentId"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>UNITS ATTACHED: </td>
				<td colspan="3"><strong>
					<xsl:if test="count(AssignedUnits/PrimaryUnit)>0">
						<xsl:if test="count(AssignedUnits/PrimaryUnit)>0"><xsl:value-of select="AssignedUnits"/></xsl:if>
					</xsl:if>	
					<xsl:if test="string-length(AssignedUnits/AssistingUnits) > 0">, <xsl:value-of select="AssignedUnits/AssistingUnits"/></xsl:if>
				</strong>
				</td>
				<!--td>Type: </td>
				<td><strong><xsl:value-of select="@incidentType"/></strong></td-->
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>PRIORITY COMMENT: </td>
				<td colspan="3"><strong><xsl:value-of select="SpecialComment"/></strong></td>
				<!-- 2/2/12 jtg: Removed per customer request.
				<td>Priority: </td>
				<td><strong><xsl:value-of select="IncidentPriority"/></strong></td>
				-->
				
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>BUSINESS NAME: </td>
				<td><strong><xsl:value-of select="BusinessName"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>APT: </td>
				<td><strong><xsl:value-of select="Address/ApartmentNumber"/></strong></td>
				<td>BLDG: </td>
				<td><strong><xsl:value-of select="Address/Building"/></strong></td>
				<!--td>Addr: </td>
				<td><strong><xsl:value-of select="Address/StreetAddress"/></strong></td-->
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>X-ST: </td>
				<td><strong><xsl:value-of select="Address/CrossStreets/CrossStreet1"/></strong></td>
				<td>X-ST: </td>
				<td><strong><xsl:value-of select="Address/CrossStreets/CrossStreet2"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>INPRGS: </td>
				<td><strong><xsl:value-of select="InProgress"/></strong></td>
				<td>OFC CNTCT: </td>
				<td><strong><xsl:value-of select="ComplainantInfo/ComplainantDesiresContact"/></strong></td>
				<td>WEAPONS: </td>
				<td><strong><xsl:value-of select="Weapons"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>CNAME: </td>
				<td><strong><xsl:value-of select="ComplainantInfo/PersonName"/></strong></td>
				<td>CADDX: </td>
				<td><strong><xsl:value-of select="ComplainantInfo/Address"/></strong></td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td>CPH: </td>
				<td><strong><xsl:value-of select="ComplainantInfo/Phone"/></strong></td>
			</tr>

			<tr class="ctc_tbl_headrow_cad">
				<td colspan="6">COMMENTS:</td>
			</tr>
			<tr class="ctc_tbl_data_cad">
				<td colspan="6"><pre><strong><xsl:value-of select="IncidentComments"/></strong></pre></td>
			</tr>
		</table>
    
    </xsl:template>	

</xsl:stylesheet>
