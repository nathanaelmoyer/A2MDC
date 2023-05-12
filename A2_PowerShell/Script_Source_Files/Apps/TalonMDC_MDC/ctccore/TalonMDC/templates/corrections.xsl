<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Moved correction details into sub template
					- Added embedded arrests into this template, removed arrest.xsl import
					- Renamed Corrections_Test to Corrections_Multiple
	   09/28/05 MAH - Removed <br/> in Corrections_Multiple
	   11/08/05 MAH - Added TCN element
	   02/16/06 MAH - Added message element
	   04/26/06 MAH - Added query title
	   12/11/06 MAH - Added person info
	   12/30/08 MAH - Changed data to be bold instead of labels
  -->
  <!-- *************************** -->

  <xsl:import href="message.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>


  <!-- *************************** -->
  <!-- called from main template processing -->
  
  <xsl:template name="Corrections_Single" match="Corrections" mode="single" >
	<xsl:if test="(count(Corrections)>0) or (count(Message)>0)">
		<!-- we're in the Corrections folder of the Case View -->
	<xsl:call-template name="fldr_querytitle"/>

		<xsl:if test="count(//Message)>0">
			<p class="ctc_page_subtitle_1">CMIS</p>
			<xsl:apply-templates select="Message" mode="single"/>
		</xsl:if>
		<xsl:if test="count(./Corrections)>0">
			<hr/>
			<p class="ctc_page_subtitle_1">Corrections</p>
			<xsl:choose>
				<xsl:when test="count(PersonName)>0">
						<xsl:for-each select="*">
								<xsl:variable name="curNode" select="name(current())"/>
								<xsl:if test="contains($curNode,'PersonName')">
									<xsl:if test="string-length(PersonSurName) > 0">
										<hr/>
										<xsl:call-template name="PersonInfo"/>
									</xsl:if>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="contains($curNode,'CorrectionsGrp')">
										<xsl:apply-templates select="./Corrections" mode="case"/>
									</xsl:when>
									<xsl:when test="contains($curNode,'Corrections')">
										<xsl:apply-templates select="." mode="case"/>
									</xsl:when>
								</xsl:choose>
						</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="Corrections" mode="case"/>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
    <xsl:call-template name="fldr_footer"/>
    </xsl:if>
    
  </xsl:template>


  <!-- **************************************************************************** -->
  <!-- called from Corrections_Single 
	   Displays correction records for case view folder
  -->
  <xsl:template name="Corrections_Case" match="Corrections" mode="case" >

	<xsl:call-template name="Corrections_Details"/>

	<xsl:if test="count(Arrest)>0">
		<blockquote>
			<table width="100%">
				<tr >
					<td>
						<xsl:call-template name="Corrections_Arrest"/>
					</td>
				</tr>
			</table>
		</blockquote>
	</xsl:if>

	<br/><!--hr/-->

  </xsl:template>


  <!-- **************************************************************************** -->
  <!-- called from person.xsl -->
  
  <xsl:template name="Corrections_Multiple" match="Corrections" mode="multiple" >

	<p class="ctc_page_subtitle_1">Corrections</p>
	
	<xsl:for-each select="Corrections">
	
		<xsl:call-template name="Corrections_Details"/>
	
		<xsl:if test="count(Arrest)>0">
			<blockquote>
				<table width="100%">
					<tr >
						<td>
							<xsl:call-template name="Corrections_Arrest"/>
						</td>
					</tr>
				</table>
			</blockquote>
		</xsl:if>
		<!--br/-->
	</xsl:for-each>

  </xsl:template>


  <!-- *************************** -->
  <xsl:template name="Corrections_Details" match="Corrections" mode="details">

		<xsl:variable name="tagAgency" select="SupervisionAgency/OrganizationName"/>
		<xsl:variable name="tagBookingID" select="ActivityID/ID"/>
		<xsl:variable name="tagRelease" select="SupervisionRelease/ActivityDate"/>
		<xsl:variable name="tagStatus" select="SupervisionCustodyStatus/StatusText"/>
		<xsl:variable name="tagFacility" select="SupervisionFacility/OrganizationDescriptionText"/>
		<xsl:variable name="tagTCN" select="SupervisionTCN/ID"/>

		<xsl:if test="count($tagAgency)>0">
			<table  width="100%">
				<tr class="ctc_tbl_row" >
					<td class="ctc_tbl_data">Agency: <strong><xsl:value-of select="$tagAgency"/></strong></td>
				</tr>
			</table>
		</xsl:if>

		<xsl:if test="(count($tagBookingID)>0) or (count($tagTCN)>0) or (count($tagRelease)>0) or (count($tagStatus)>0) or (count($tagFacility)>0)">
			<table width="100%">
				<xsl:if test="(count($tagBookingID)>0) or (count($tagTCN)>0)">
					<tr class="ctc_tbl_row" valign="top">
						<xsl:if test="count($tagBookingID)>0">
							<td class="ctc_tbl_data">Booking ID: <strong><xsl:value-of select="$tagBookingID"/></strong></td>
						</xsl:if>
						<xsl:if test="count($tagTCN)>0">
							<td class="ctc_tbl_data">TCN: <strong><xsl:value-of select="$tagTCN"/></strong></td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="(count($tagRelease)>0) or (count($tagStatus)>0) or (count($tagFacility)>0)">
					<tr class="ctc_tbl_row" valign="top">
						<xsl:if test="count($tagRelease)>0">
							<td class="ctc_tbl_data" nowrap="nowrap">Release: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagRelease"/></xsl:call-template></strong></td>
						</xsl:if>
						<xsl:if test="count($tagStatus)>0">
							<td class="ctc_tbl_data">Status: <strong><xsl:value-of select="$tagStatus"/></strong></td>
						</xsl:if>
						<xsl:if test="count($tagFacility)>0">
							<td class="ctc_tbl_data">Facility: <strong><xsl:value-of select="$tagFacility"/></strong></td>
						</xsl:if>
					</tr>
				</xsl:if>
			</table>
		</xsl:if>
  
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Corrections_Arrest" match="Corrections" mode="arrest">

	<!-- Loop through each Arrest tag -->
	<xsl:for-each select="Arrest">
		<xsl:variable name="countAgency" select="count(ArrestAgency/OrganizationName)" />
		<xsl:variable name="countLocation" select="count(ArrestLocation/LocationDescriptionText)" />
		<xsl:variable name="countCTN" select="count(Charge/ChargeTrackingID/ID)" />
		<p class="ctc_page_subtitle_1">Arrest</p>
		<table width="100%">
			<tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Date</td>
				<td class="ctc_tbl_center_hdr">Type</td>
				<td class="ctc_tbl_center_hdr">Description</td>
				<td class="ctc_tbl_center_hdr">ID</td>
				<td class="ctc_tbl_center_hdr">Source</td>
				<xsl:if test="$countLocation > 0"><td class="ctc_tbl_center_hdr">Location</td></xsl:if>
				<xsl:if test="$countAgency > 0"><td class="ctc_tbl_center_hdr">Arrest Agency</td></xsl:if>
				<xsl:if test="$countCTN > 0"><td class="ctc_tbl_center_hdr">CTN</td></xsl:if>
			</tr>
			<tr class="ctc_tbl_row" valign="top">
				<!-- display ActivityDate in MM/DD/YYYY format -->
				<td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID" /></td>
				<td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
				<xsl:if test="$countLocation > 0">
					<td class="ctc_tbl_data"><xsl:value-of select="ArrestLocation/LocationDescriptionText"/></td>
				</xsl:if>
				<xsl:if test="$countAgency > 0">
					<td class="ctc_tbl_data"><xsl:value-of select="ArrestAgency/OrganizationName"/></td>
				</xsl:if>
				<xsl:if test="$countCTN > 0">
					<td  class="ctc_tbl_data"><xsl:value-of select="Charge/ChargeTrackingID/ID"/></td>
				</xsl:if>
			</tr>
		</table>
			
		<xsl:if test="count(Charge)>0">
			<blockquote>
				<xsl:variable name="tagChargeID" select="Charge/ChargeID/ID"/>
				<xsl:variable name="tagFilingDate" select="Charge/ChargeFilingDate"/>
				<xsl:variable name="tagDesc" select="Charge/ChargeDescriptionText"/>
				<xsl:variable name="tagClass" select="Charge/ChargeClassification"/>
				<xsl:variable name="tagCourtName" select="Charge/CourtEvent/CourtEventCourt/CourtName"/>
				<xsl:variable name="tagDocket" select="Charge/CourtEvent/CaseDocketID/ID"/>

				<p class="ctc_page_subtitle_2">Charges</p>
				
				<table width="100%">
					<tr class="ctc_tbl_headrow">
						<xsl:if test="count($tagChargeID)>0"><td class="ctc_tbl_center_hdr">#</td></xsl:if>
						<xsl:if test="count($tagFilingDate)>0"><td class="ctc_tbl_center_hdr">Date</td></xsl:if>
						<xsl:if test="count($tagDesc)>0"><td class="ctc_tbl_center_hdr">Charge</td></xsl:if>
						<xsl:if test="count($tagClass)>0"><td class="ctc_tbl_center_hdr">CD/PACC</td></xsl:if>
						<xsl:if test="count($tagCourtName)>0"><td class="ctc_tbl_center_hdr">Court</td></xsl:if>
						<xsl:if test="count($tagDocket)>0"><td class="ctc_tbl_center_hdr">Docket ID</td></xsl:if>
					</tr>
					
					<!-- Loop through each Charge tag under Arrest -->
					<xsl:for-each select="Charge">
						<xsl:variable name="tagChargeID" select="ChargeID/ID"/>
						<xsl:variable name="tagFilingDate" select="ChargeFilingDate"/>
						<xsl:variable name="tagDesc" select="ChargeDescriptionText"/>
						<xsl:variable name="tagClass" select="ChargeClassification"/>
						<xsl:variable name="tagCourtName" select="CourtEvent/CourtEventCourt/CourtName"/>
						<xsl:variable name="tagDocket" select="CourtEvent/CaseDocketID/ID"/>
						<tr class="ctc_tbl_row" valign="top">
							<xsl:if test="count($tagChargeID)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagChargeID"/></td>
							</xsl:if>
							<!-- display ActivityDate in MM/DD/YYYY format -->
							<xsl:if test="count($tagFilingDate)>0">
								<td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagFilingDate"/></xsl:call-template></td>
							</xsl:if>
							<xsl:if test="count($tagDesc)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagDesc"/></td>
							</xsl:if>
							<xsl:if test="count($tagClass)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagClass"/></td>
							</xsl:if>
							<xsl:if test="count($tagCourtName)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagCourtName"/></td>
							</xsl:if>
							<xsl:if test="count($tagDocket)>0">
								<td class="ctc_tbl_data"><xsl:value-of select="$tagDocket"/></td>
							</xsl:if>
						</tr>
						<xsl:if test="count(CourtEventJudge)>0">
							 <tr class="ctc_tbl_row">
								<td class="ctc_tbl_data" colspan="5">
									<table border="0" width="100%">
										<tr>
											<td>Judge: <xsl:value-of select="CourtEvent/CourtEventJudge/PersonName/PersonFullName"/></td>
										</tr>
									</table>
								</td>
							</tr> 
						</xsl:if>
					</xsl:for-each>
				</table>
			</blockquote>
		</xsl:if>
	</xsl:for-each>


  </xsl:template>


  <!-- *************************** -->
  <!-- ISN'T CALLED, BUT IF REMOVE IT, CORRECTIONS FOLDER DOESN'T WORK -->
  <xsl:template name="Corrections" match="Corrections" mode="data" >
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="PersonInfo">
	
	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(following-sibling::PersonBirthDate)" />
	<xsl:variable name="countPhysicalRace" select="count(following-sibling::PersonPhysicalDetails/PersonRaceText)" />
	<xsl:variable name="countPhysicalSex" select="count(following-sibling::PersonPhysicalDetails/PersonSexText)" />

	<table width="100%">
		<tr>
			<td class="ctc_tbl_data_em" align="center">
				(<xsl:value-of select="PersonSurName"/>, <xsl:value-of select="PersonGivenName"/>, <xsl:value-of select="PersonMiddleName"/>&#160;
				DOB: 
			<xsl:choose>
				<xsl:when test="$countDOB > 0"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="following-sibling::PersonBirthDate"/></xsl:call-template></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
				Race: 
			<xsl:choose>
				<xsl:when test="$countPhysicalRace > 0"><xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonRaceText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			Sex: 
			<xsl:choose>
				<xsl:when test="$countPhysicalSex > 0"><xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonSexText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			)
			</td>
		</tr>
	</table>
  </xsl:template>

  <!-- *************************** -->

</xsl:stylesheet>
