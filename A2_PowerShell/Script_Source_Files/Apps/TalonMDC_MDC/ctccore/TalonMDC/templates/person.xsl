<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   05/31/05 MAH - Removed checking for unknown tags
					- Moved personname, alias, incident & accident into person template
					- Only display certain data when called from People folder
	   06/01/05 MAH - Moved addresses into person template
					- Removed filelistcall.xsl import - template is now in ctc_templates.xsl
					- Removed grouped parameter for call to arrest template
					- Changed call to activity template - now has param
					- Changed call to case template - now has 2 params
	   07/21/05		- Added Driver's License issued and expired dates
	   07/25/05	    - Added check for person tags under each address - for LocatePLUS
	   09/28/05 MAH - Commented out FileList - this is done at the Record level
	   10/14/05 MAH - Change Person's name to link if LinkInfo element exists - for LocatePLUS
	   10/31/05 MAH - In address, check for string-length of street # & street name
	   11/01/05 MAH - Moved address processing to separate residence template
	   12/22/05 MAH - Added check for PersonDescriptionText
	   04/26/06 MAH - Added "Response:" in front of person's name. Differentiate between queried name.
	   12/30/08 MAH - Changed data to be bold instead of labels
	   01/22/09 MAH - Added variable to Person_Info for calling it from within Vehicle & Address records
  -->
  <!-- *************************** -->

  <!-- *************************** -->
  <xsl:import href="corrections.xsl" />
  <xsl:import href="arrest.xsl" />
  <xsl:import href="activity.xsl" />
  <xsl:import href="case.xsl" />
  <xsl:import href="residence.xsl" />
  <xsl:import href="ppo.xsl" />
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- Person record for People folder -->
  <xsl:template name="Person_Case" match="Person" mode="case" >

	<xsl:call-template name="Person_Info"/>
	<xsl:call-template name="Person_Address"><xsl:with-param name="isCaseView">true</xsl:with-param></xsl:call-template>

	<br/><hr/>
  
  </xsl:template>

  <!-- *************************** -->
  <!-- Person record for other folders -->
  <xsl:template name="Person_CaseSingle" match="Person" mode="casesingle" >
	
	<xsl:call-template name="Person_Info"/>
	<xsl:call-template name="Person_Address"><xsl:with-param name="isCaseView">true</xsl:with-param></xsl:call-template>
	<xsl:call-template name="Person_Details"/>
	
  </xsl:template>

  <!-- *************************** -->
  <!-- Person record for single record -->
  <xsl:template name="Person_Single" match="Person" mode="single" >
	<xsl:param name="isCaseView" />
	
	<xsl:call-template name="Person_Info"/>
	<xsl:call-template name="Person_Address"/>
	<xsl:call-template name="Person_Details"/>
	
  </xsl:template>

  <!-- *************************** -->
  <!-- Person details -->
  <xsl:template name="Person_Details" match="Person" mode="details">
	
	<!-- Person Description Text -->
	<xsl:if test="count(//PersonDescriptionText) > 0">
		<xsl:for-each select="//PersonDescriptionText" >
			<xsl:value-of select="."/>
		</xsl:for-each>
	</xsl:if>

	<!-- Incident -->
	<xsl:if test="count(//Incident) > 0">
		<p class="ctc_page_subtitle_1">Incident Summary</p>
		<table width="100%">
		  <tr class="ctc_tbl_headrow">
			<th class="ctc_tbl_center_hdr">Date</th>
			<th class="ctc_tbl_center_hdr">Type</th>
			<th class="ctc_tbl_center_hdr">Description</th>
			<th class="ctc_tbl_center_hdr">ID</th>
			<th class="ctc_tbl_center_hdr">Source</th>
		  </tr>
		   <xsl:for-each select="//Incident" >
			<tr class="ctc_tbl_row" valign="top"> 
			  <!-- display ActivityDate in MM/DD/YYYY format -->
			  <td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
			</tr>
		  </xsl:for-each>
		</table>
	</xsl:if>

	<!-- Corrections info -->
	<xsl:if test="count(//Corrections) > 0">
	  <xsl:call-template name="Corrections_Multiple"/>
	</xsl:if>

	<!-- Arrest info -->
	<xsl:if test="count(Arrest) > 0">
	  <xsl:call-template name="Arrest"/> 
	</xsl:if>

	<!-- Court Case info -->
	<xsl:if test="count(//Case) > 0">
		<xsl:call-template name="Case">
			<xsl:with-param name="node" select="Case"/>
			<xsl:with-param name="isCaseView">false</xsl:with-param>
		</xsl:call-template>
	</xsl:if>

	<!-- PPO info -->
	<xsl:if test="count(//ProtectionOrder) > 0">
		<xsl:call-template name="PPO">
			<xsl:with-param name="node" select="ProtectionOrder"/>
			<xsl:with-param name="isCaseView">false</xsl:with-param>
		</xsl:call-template>
	</xsl:if>

	<!-- Activity info -->
	<xsl:if test="count(//Activity) > 0">
	  <xsl:call-template name="Activity">
		<xsl:with-param name="node" select="Activity"/>
	  </xsl:call-template>
	</xsl:if>

	<!-- Accident -->
	<xsl:if test="count(//Accident) > 0">
		<p class="ctc_page_subtitle_1">Accident Summary</p>
		<table width="100%">
		  <tr class="ctc_tbl_headrow">
			<th class="ctc_tbl_center_hdr">Date</th>
			<th class="ctc_tbl_center_hdr">Type</th>
			<th class="ctc_tbl_center_hdr">Description</th>
			<th class="ctc_tbl_center_hdr">ID</th>
			<th class="ctc_tbl_center_hdr">Source</th>
		  </tr>
		   <xsl:for-each select="//Accident" >
			<tr class="ctc_tbl_row" valign="top"> 
			  <!-- display ActivityDate in MM/DD/YYYY format -->
			  <td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
			</tr>
		  </xsl:for-each>
		</table>
	</xsl:if>
	
		<!-- Crash -->
	<xsl:if test="count(//Crash) > 0">
		<p class="ctc_page_subtitle_1">Crash Summary</p>
		<table width="100%">
		  <tr class="ctc_tbl_headrow">
			<th class="ctc_tbl_center_hdr">Date</th>
			<th class="ctc_tbl_center_hdr">Severity</th>
			<th class="ctc_tbl_center_hdr">Description</th>
			<th class="ctc_tbl_center_hdr">ID</th>
			<th class="ctc_tbl_center_hdr">CMV</th>			
			<th class="ctc_tbl_center_hdr">HazMat</th>
			<th class="ctc_tbl_center_hdr">Jurisdiction</th>			
		  </tr>
		   <xsl:for-each select="//Crash" >
			<tr class="ctc_tbl_row" valign="top"> 
			  <!-- display ActivityDate in MM/DD/YYYY format -->
			  <td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingAccidentSeverityText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="IdentificationID" />-<xsl:value-of select="IdentificationJurisdictionText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingIncidentCMVText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingIncidentHazMatText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingIncidentJurisdiction" /></td>
			</tr>
		  </xsl:for-each>
		</table>
	</xsl:if>

		<!-- Driver Conviction -->
	<xsl:if test="count(//DriverConviction) > 0">
		<xsl:for-each select="//DriverConviction" >
		<p class="ctc_page_subtitle_1">Driver Conviction</p>
		<table width="100%">
		  <tr class="ctc_tbl_row" valign="top"> 
			  <!-- display ActivityDate in MM/DD/YYYY format -->
			  <td class="ctc_tbl_data">Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="DriverConvictionActivityDate"/></xsl:call-template></strong></td>
			  <td class="ctc_tbl_data">Description: <strong><xsl:value-of select="DriverConvictionActivityDescriptionText" /></strong></td>
			  <td class="ctc_tbl_data">Charge ID: <strong><xsl:value-of select="DriverConvictionActivityIdentificationID" /></strong></td>
			  <td class="ctc_tbl_data">Charge Jurisdiction: <strong><xsl:value-of select="DriverConvictionActivityIdentificationJurisdictionText" /></strong></td>
		</tr>
		<tr class="ctc_tbl_row" valign="top"> 
			  <xsl:if test="count(//ChargeStatuteIdentificationID) > 0">
				<td class="ctc_tbl_data">Charge Statute ID: <strong><xsl:value-of select="ChargeStatuteIdentificationID" /></strong></td>
				<td class="ctc_tbl_data">Jurisdiction: <strong><xsl:value-of select="ChargeStatuteIdentificationJurisdictionText" /></strong></td>
			  </xsl:if>
		</tr>
		<tr class="ctc_tbl_row" valign="top"> 
			<td><strong>- Conviction Court Details -</strong></td>
		  </tr>
		<tr class="ctc_tbl_row" valign="top"> 
			  <td class="ctc_tbl_data">Street: <strong><xsl:value-of select="ConvictionCourtOrganizationLocationStreet" /></strong></td>
			  <td class="ctc_tbl_data">City: <strong><xsl:value-of select="ConvictionCourtOrganizationLocationCityName" /></strong></td>
			  <xsl:if test="count(//ConvictionCourtOrganizationLocationStateName) > 0">
				<td class="ctc_tbl_data">State: <strong><xsl:value-of select="ConvictionCourtOrganizationLocationStateName" /></strong></td>
			  </xsl:if>
			  <td class="ctc_tbl_data">Zip Code: <strong><xsl:value-of select="ConvictionCourtOrganizationLocationPostalCode" /></strong></td>
		</tr>
		<tr class="ctc_tbl_row" valign="top">
			  <td class="ctc_tbl_data">Category: <strong><xsl:value-of select="ConvictionCourtOrganizationCategoryText" /></strong></td>
			  <td class="ctc_tbl_data">County: <strong><xsl:value-of select="ConvictionCourtOrganizationLocationCountyName" /></strong></td>
			  <td class="ctc_tbl_data">Country: <strong><xsl:value-of select="ConvictionCourtOrganizationLocationCountryName" /></strong></td>
		</tr>
		<tr class="ctc_tbl_row" valign="top"> 
			<td><strong>- Citation Details -</strong></td>
		  </tr>
		<tr class="ctc_tbl_row" valign="top"> 
			  <td class="ctc_tbl_data">ID: <strong><xsl:value-of select="DriverConvictionCitationActivityIdentificationID" /></strong></td>
			  <td class="ctc_tbl_data">Jurisdiction: <strong><xsl:value-of select="DriverConvictionCitationActivityIdentificationJurisdictionText" /></strong></td>
			  <td class="ctc_tbl_data">Date:<strong> <xsl:call-template name="standard_date"><xsl:with-param name="date" select="DriverConvictionCitationActivityDate"/></xsl:call-template></strong></td>
			  <td class="ctc_tbl_data">Citation Description: <strong><xsl:value-of select="DriverConvictionCitationActivityDescriptionText" /></strong></td>
		</tr>
		<tr class="ctc_tbl_row" valign="top"> 
			  <td class="ctc_tbl_data">CMV: <strong><xsl:value-of select="DriverConvictionCMVText" /></strong></td>
			  <td class="ctc_tbl_data">HazMat: <strong><xsl:value-of select="DriverConvictionHazMatText" /></strong></td>
			  <td class="ctc_tbl_data">Offense: <strong><xsl:value-of select="DriverConvictionOffenseText" /></strong></td>
			  <td class="ctc_tbl_data">Offense Description: <strong><xsl:value-of select="DriverConvictionOffenseDescriptionText" /></strong></td>
		</tr>
		</table>
		  </xsl:for-each>
	</xsl:if>
	
			<!-- Driver License Withdrawal -->
	<xsl:if test="count(//DriverLicenseWithdrawal) > 0">
		<xsl:for-each select="//DriverLicenseWithdrawal" >
		<p class="ctc_page_subtitle_1">Driver License Withdrawal</p>
		<table width="100%">
		  <tr class="ctc_tbl_row" valign="top"> 
			  <!-- display ActivityDate in MM/DD/YYYY format -->
			  <td class="ctc_tbl_data">Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></strong></td>
			  <td class="ctc_tbl_data">Description: <strong><xsl:value-of select="ActivityDescriptionText" /></strong></td>
			  <td class="ctc_tbl_data">ID: <strong><xsl:value-of select="ActivityIdentificationID" /></strong></td>
			  <td class="ctc_tbl_data">Jurisdiction: <strong><xsl:value-of select="ActivityIdentificationJurisdictionText" /></strong></td>
		</tr>
		<tr class="ctc_tbl_row" valign="top"> 
			<xsl:if test="count(//DriverLicenseWithdrawalActionCode) > 0">
				<td class="ctc_tbl_data">Action Code: <strong><xsl:value-of select="DriverLicenseWithdrawalActionCode" /></strong></td>
			  </xsl:if>
			<xsl:if test="count(//DriverLicenseWithdrawalBasisCode) > 0">
				<td class="ctc_tbl_data">Basis Code: <strong><xsl:value-of select="DriverLicenseWithdrawalBasisCode" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalCode) > 0">
				<td class="ctc_tbl_data">Code: <strong><xsl:value-of select="DriverLicenseWithdrawalCode" /></strong></td>
			</xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalDueProcessStatusCode) > 0">
				<td class="ctc_tbl_data">Due Process Status Code: <strong><xsl:value-of select="DriverLicenseWithdrawalDueProcessStatusCode" /></strong></td>
			  </xsl:if>
		  </tr>
		<tr class="ctc_tbl_row" valign="top"> 
			  <xsl:if test="count(//DriverLicenseWithdrawalEffectiveDate) > 0">
				<td class="ctc_tbl_data">Effective Date:<strong> <xsl:call-template name="standard_date"><xsl:with-param name="date" select="DriverLicenseWithdrawalEffectiveDate"/></xsl:call-template></strong></td>
			</xsl:if>
			<xsl:if test="count(//DriverLicenseWithdrawalEligibilityCode) > 0">
				<td class="ctc_tbl_data">EligibilityCode: <strong><xsl:value-of select="DriverLicenseWithdrawalEligibilityCode" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalEligibilityDate) > 0">
				<td class="ctc_tbl_data">Eligibility Date:<strong> <xsl:call-template name="standard_date"><xsl:with-param name="date" select="DriverLicenseWithdrawalEligibilityDate"/></xsl:call-template></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalExtentText) > 0">
				<td class="ctc_tbl_data">Extent Text: <strong><xsl:value-of select="DriverLicenseWithdrawalExtentText" /></strong></td>
			  </xsl:if>
		  </tr>
		<tr class="ctc_tbl_row" valign="top"> 
			<xsl:if test="count(//DriverLicenseWithdrawalIssuingAuthorityText) > 0">
				<td class="ctc_tbl_data">Issuing Authority: <strong><xsl:value-of select="DriverLicenseWithdrawalIssuingAuthorityText" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalLocatorReferenceIdentificationID) > 0">
				<td class="ctc_tbl_data">Locator Reference ID: <strong><xsl:value-of select="DriverLicenseWithdrawalLocatorReferenceIdentificationID" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalLocatorReferenceIdentificationJurisdictionText) > 0">
				<td class="ctc_tbl_data">Locator Reference Jurisdiction: <strong><xsl:value-of select="DriverLicenseWithdrawalLocatorReferenceIdentificationJurisdictionText" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverLicenseWithdrawalReasonReferenceCode) > 0">
				<td class="ctc_tbl_data">Reason Reference Code: <strong><xsl:value-of select="DriverLicenseWithdrawalReasonReferenceCode" /></strong></td>
			  </xsl:if>
		</tr>
		<tr class="ctc_tbl_row" valign="top"> 
			  <xsl:if test="count(//DriverLicenseWithdrawalReinstatementDate) > 0">
				<td class="ctc_tbl_data">Reinstatement Date: <strong><xsl:value-of select="DriverLicenseWithdrawalReinstatementDate" /></strong></td>
			 </xsl:if>
		</tr>
		</table>
		  </xsl:for-each>
	</xsl:if>
				<!-- Driver History Summary -->
	<xsl:if test="count(//DriverHistorySummary) > 0">
		<xsl:for-each select="//DriverHistorySummary" >
		<p class="ctc_page_subtitle_1">Driver History Summary</p>
		<table width="100%">
		<tr class="ctc_tbl_row" valign="top"> 
			<xsl:if test="count(//DriverHistoryAccidentQuantity) > 0">
				<td class="ctc_tbl_data">Accident Quantity: <strong><xsl:value-of select="DriverHistoryAccidentQuantity" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverHistoryConvictionQuantity) > 0">
				<td class="ctc_tbl_data">Conviction Quantity: <strong><xsl:value-of select="DriverHistoryConvictionQuantity" /></strong></td>
			  </xsl:if>
			  <xsl:if test="count(//DriverHistoryWithdrawalQuantity) > 0">
				<td class="ctc_tbl_data">Withdrawal Quantity: <strong><xsl:value-of select="DriverHistoryWithdrawalQuantity" /></strong></td>
			  </xsl:if>
		</tr>
		</table>
		  </xsl:for-each>
	</xsl:if>
	
	<!-- ctcDistributionText -->
	<xsl:if test="count(ctcDistributionText)>0">
		<table border="0" width="100%"  >
			<tr><td class="ctc_tbl_data" ><xsl:value-of select="ctcDistributionText"/></td></tr>
		</table>
	</xsl:if>

  </xsl:template>

  <!-- *************************** -->
  <!-- Person stats -->
  <xsl:template name="Person_Info" match="Person" mode="info">
	<xsl:param name="isEmbedded" />

  	<xsl:variable name="txtNA">N/A</xsl:variable>
    <xsl:variable name="countDOB" select="count(PersonBirthDate)" />
    <xsl:variable name="countPhysical" select="count(PersonPhysicalDetails/*)" />
    <xsl:variable name="countEmployment" select="count(PersonEmployment/*)" />
    <xsl:variable name="makeLink" select="count(PersonName/LinkInfo)" />
    <xsl:variable name="personLast" select="PersonName/PersonSurName" />
    <xsl:variable name="personFirst" select="PersonName/PersonGivenName" />
    <xsl:variable name="personMid" select="PersonName/PersonMiddleName" />
    <xsl:variable name="personSuffix" select="PersonName/PersonSuffixName" />
    
    <xsl:variable name="personFull" select="concat($personLast,', ', $personFirst,' ',$personMid,' ',$personSuffix)" />
    <xsl:variable name="personFullText" select="PersonName/PersonFullName" />

    <xsl:variable name="MessageKeyCodeText" select="NLETSMessageHeader/MessageKeyCodeText" />
    <xsl:variable name="OriginatingORIID" select="NLETSMessageHeader/OriginatingORIID" />
    <xsl:variable name="DestinationORIID" select="NLETSMessageHeader/DestinationORIID" />
    <xsl:variable name="DocumentControlFieldText" select="NLETSMessageHeader/DocumentControlFieldText" />
    <xsl:variable name="MessageReceiveDate" select="NLETSMessageHeader/MessageReceiveDate" />
    <xsl:variable name="MessageReceiveTime" select="NLETSMessageHeader/MessageReceiveTime" />
    <xsl:variable name="MessageSendDate" select="NLETSMessageHeader/MessageSendDate" />
    <xsl:variable name="MessageSendTime" select="NLETSMessageHeader/MessageSendTime" />
    <xsl:variable name="ReceiveMessageNumeric" select="NLETSMessageHeader/ReceiveMessageNumeric" />
    <xsl:variable name="SendMessageNumeric" select="NLETSMessageHeader/SendMessageNumeric" />
    
    <xsl:choose>
		<xsl:when test="$makeLink">
			<xsl:call-template name="Link">
				<xsl:with-param name="dest" select="PersonName/LinkInfo"/>
				<xsl:with-param name="desc" select="$personFull"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="contains($isEmbedded,'true')">
				<p class="ctc_page_subtitle_1">Person: <xsl:value-of select="$personFull" /></p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="(string-length($personFull) &gt; '5')">
				    <p class="ctc_page_subtitle_1">Response: <xsl:value-of select="$personFull" /></p>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>


	<xsl:if test="(count($MessageKeyCodeText)>0) or (count($OriginatingORIID)>0) or (count($DestinationORIID)>0) or (count($DocumentControlFieldText)>0)">
	<p class="ctc_tbl_row">
     	    MKE: <xsl:value-of select="$MessageKeyCodeText"/>, 
	    From: <xsl:value-of select="$OriginatingORIID"/> To: <xsl:value-of select="$DestinationORIID"/>, 
	    <xsl:value-of select="$DocumentControlFieldText"/>, 
	    Rcv: <xsl:value-of select="$MessageReceiveDate"/>,  
	    <xsl:value-of select="$MessageReceiveTime"/>, 
	    <xsl:value-of select="$ReceiveMessageNumeric"/>, 
	    Snd: <xsl:value-of select="$MessageSendDate"/>,  
	    <xsl:value-of select="$MessageSendTime"/>, 
	    <xsl:value-of select="$SendMessageNumeric"/> 
	</p>
	</xsl:if>
    
    <xsl:if test="($countDOB > 0) or ($countPhysical > 0) or (count(PersonAssignedIDDetails)>0)">
		<p class="ctc_page_subtitle_1">Statistics Summary
		<xsl:if test="count($personFullText)>0">
			 For: <xsl:value-of select="$personFullText"/>
		</xsl:if>
		</p>
		<table width="100%" class="ctc_tbl_row">
		<xsl:if test="(count(PersonBirthDate)>0) or (count(PersonPhysicalDetails/PersonRaceText)>0) or (count(PersonPhysicalDetails/PersonSexText)>0) or (count(PersonPhysicalDetails/PersonSkinToneText)>0)">
			<tr class="ctc_tbl_row" >
				  <td class="ctc_tbl_data">DOB: 
				  <xsl:choose>
					<!-- display DOB, convert to MM/DD/YYYY format -->				
					<xsl:when test="$countDOB > 0"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="PersonBirthDate"/></xsl:call-template></strong></xsl:when>					
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Race: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonRaceText)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonRaceText" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Sex: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonSexText)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonSexText" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Skin Tone: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonSkinToneText)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonSkinToneText" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
			</tr>
		</xsl:if>
		<xsl:if test="(count(PersonPhysicalDetails/PersonHeightMeasure)>0) or (count(PersonPhysicalDetails/PersonWeightMeasure)>0) or (count(PersonPhysicalDetails/PersonEyeColorText)>0) or (count(PersonPhysicalDetails/PersonHairColorText)>0)">
			<tr class="ctc_tbl_row">
				  <td class="ctc_tbl_data">Height: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonHeightMeasure)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonHeightMeasure" /> &#160; <xsl:value-of select="PersonPhysicalDetails/PersonHeightMeasure/@personHeightUnitCode" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Weight: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonWeightMeasure)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonWeightMeasure" />&#160; <xsl:value-of select="PersonPhysicalDetails/PersonWeightMeasure/@personWeightUnitCode" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Eyes: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonEyeColorText)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonEyeColorText" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Hair: 
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonHairColorText)>0"><strong><xsl:value-of select="PersonPhysicalDetails/PersonHairColorText" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
			</tr>
		</xsl:if>
		<xsl:if test="(count(PersonMedicalFileIndicator)>0 or count(PersonOrganDonator)>0 ) ">
			<tr class="ctc_tbl_row">
				  <td class="ctc_tbl_data">Medical File: 
				  <xsl:choose>
					<xsl:when test="count(PersonMedicalFileIndicator)>0"><strong><xsl:value-of select="PersonMedicalFileIndicator" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data">Organ Donator: 
				  <xsl:choose>
					<xsl:when test="count(PersonOrganDonatorIndicator)>0"><strong><xsl:value-of select="PersonOrganDonatorIndicator" /></strong></xsl:when>
					<xsl:otherwise><strong><xsl:value-of select="$txtNA"/></strong></xsl:otherwise>
				  </xsl:choose>
				  </td>
			</tr>
		</xsl:if>

		<!-- IDs associated with the Person (e.g. SSN, CIN, etc.) -->
		<xsl:if test="count(PersonAssignedIDDetails)>0">

			<xsl:variable name="tagSSN" select="PersonAssignedIDDetails/PersonSSNID/ID"/>
			<xsl:variable name="tagSSNJuris" select="PersonAssignedIDDetails/PersonSSNID/IDJurisdictionText"/>
			<xsl:variable name="tagCIN" select="PersonAssignedIDDetails/PersonOtherID[IDTypeText='CIN']/ID"/>
			<xsl:variable name="tagSID" select="PersonAssignedIDDetails/PersonStateID/ID"/>
			<xsl:variable name="tagSIDST" select="PersonAssignedIDDetails/PersonStateID/IDJurisdictionText"/>
			<xsl:variable name="tagAFIS" select="PersonAssignedIDDetails/PersonAFISID/ID"/>
			<xsl:variable name="tagFBIID" select="PersonAssignedIDDetails/PersonFBIID/ID"/>
			<xsl:variable name="tagCorrectionsID" select="PersonAssignedIDDetails/PersonOtherID[IDTypeText='Corrections']/ID"/>
			<xsl:variable name="tagOtherID" select="PersonAssignedIDDetails/PersonOtherID[IDTypeText='Other']/ID"/>
			<xsl:variable name="tagOtherIDJuris" select="PersonAssignedIDDetails/PersonOtherID[IDTypeText='Other']/PersonOtherIDJuris"/>


			<xsl:if test="(count($tagSSN) > 0) or (count($tagCIN) > 0) or (count($tagSID) > 0) or (count($tagAFIS) > 0)">
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagSSN)>0">
						<td class="ctc_tbl_data">SSN: <strong><xsl:value-of select="$tagSSN"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagSSNJuris)>0">
						<td class="ctc_tbl_data">SSN Juris: <strong><xsl:value-of select="$tagSSNJuris"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagCIN)>0">
						<td class="ctc_tbl_data">CIN: <strong><xsl:value-of select="$tagCIN"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagSID)>0">
						<td class="ctc_tbl_data">SID: <strong><xsl:value-of select="$tagSID"/>
						<xsl:if test="count($tagSIDST)>0">
							, <xsl:value-of select="$tagSIDST"/>
						</xsl:if>
						</strong>
						</td>
					</xsl:if>
					<xsl:if test="count($tagAFIS)>0">
						<td class="ctc_tbl_data">AFIS: <strong><xsl:value-of select="$tagAFIS"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagFBIID)>0">
						<td class="ctc_tbl_data">FBI: <strong><xsl:value-of select="$tagFBIID"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagCorrectionsID)>0">
						<td class="ctc_tbl_data">Prison ID: <strong><xsl:value-of select="$tagCorrectionsID"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOtherID)>0">
						<td class="ctc_tbl_data">Other ID: <strong><xsl:value-of select="$tagOtherID"/></strong></td>
						<xsl:if test="count($tagOtherIDJuris)>0">
							<td class="ctc_tbl_data">Jurisdiction: <strong><xsl:value-of select="$tagOtherIDJuris"/></strong></td>
						</xsl:if>
					</xsl:if>
				</tr>
			</xsl:if>
		</xsl:if>

		<!-- Contact Info (e.g. phone) -->
		<xsl:if test="count(PrimaryContactInformation)>0">
			<xsl:for-each select="PrimaryContactInformation/ContactTelephoneNumber">
				<tr class="ctc_tbl_row">
					<td class="ctc_tbl_data"><xsl:value-of select="TelephoneNumberCommentText"/>: <strong><xsl:value-of select="TelephoneNumberFullID"/></strong></td>
				</tr>
			</xsl:for-each>
		</xsl:if>

		<!-- Employment -->
		<xsl:if test="$countEmployment>0">
			<xsl:for-each select="PersonEmployment">
				<tr class="ctc_tbl_row">
					<xsl:if test="string-length(EmployerName) > 0">
						<td class="ctc_tbl_data">Employer: <strong><xsl:value-of select="EmployerName"/></strong></td>
					</xsl:if>
					<xsl:if test="string-length(OccupationText) > 0">
						<td class="ctc_tbl_data">Occupation: <strong><xsl:value-of select="OccupationText"/></strong></td>
					</xsl:if>
				</tr>
			</xsl:for-each>
		</xsl:if>
		
		</table>
	</xsl:if>    

	<!-- List any OLN Details for the Person -->
	<xsl:if test="count(//PersonAssignedIDDetails)>0">
			<xsl:variable name="tagOLNFieldName" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDFieldName"/>
			<xsl:variable name="tagOLNFieldValue" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDFieldValue"/>
			<xsl:variable name="tagOLN" select="PersonAssignedIDDetails/PersonDriverLicenseID/ID"/>
			<xsl:variable name="tagOLNST" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDJurisdictionCode"/>
			<xsl:variable name="tagOLNDate" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDEffectiveDate"/>
			<xsl:variable name="tagOLNExpire" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDExpirationDate"/>

			<xsl:variable name="tagOLNStatus" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseNonCommercialStatusText"/>
			<xsl:variable name="tagOLNncClass" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseNonCommercialClassText"/>
			<xsl:variable name="tagOLNcClass" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseCommercialClassText"/>
			<xsl:variable name="tagOLNncLocalClass" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseNonCommercialLocalClassText"/>
			<xsl:variable name="tagOLNcStatus" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseCommercialStatusText"/>
			<xsl:variable name="tagOLNPermitQuantity" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermitQuantity"/>

			<xsl:variable name="tagDriverLicenseEndorsementCode" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseEndorsement/DriverLicenseEndorsementCode"/>
			<xsl:variable name="tagDriverLicenseEndorsementText" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseEndorsement/DriverLicenseEndorsementText"/>
			<xsl:variable name="tagDriverLicenseEndorsementEndDate" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseEndorsement/DriverLicenseEndorsementEndDate/Date"/>

			<xsl:variable name="tagDriverLicenseHMEThreatCode" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseEndorsement/DriverLicenseHMEThreatCode"/>
			<xsl:variable name="tagDriverLicenseHMEThreatText" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseEndorsement/DriverLicenseHMEThreatText"/>
			<xsl:variable name="tagDriverLicenseHMEThreatDate" select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicenseEndorsement/DriverLicenseHMEThreatDate/Date"/>

			<xsl:variable name="tagPermitClassificationText" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitClassificationText"/>
			<xsl:variable name="tagPermitStatusText" 		select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitStatusText"/>
			<xsl:variable name="tagPermitIssueDate" 		select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitIssueDate/Date"/>

			<xsl:variable name="tagPermitEndorsementCode" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitEndorsementCode"/>
			<xsl:variable name="tagPermitEndorsementText" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitEndorsementText"/>
			<xsl:variable name="tagPermitExpirationDate" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitExpirationDate/Date"/>

			<xsl:variable name="tagPermitRestrictionText" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitRestrictionText"/>
			<xsl:variable name="tagPermitRestrictionDesc" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitRestrictionDesc"/>
			<xsl:variable name="tagPermitRestrictionEndDate" 	select="PersonAssignedIDDetails/PersonDriverLicenseID/DriverLicensePermit/PermitRestrictionEndDate/Date"/>

		<p class="ctc_page_subtitle_1">OLN Details:</p>
		<xsl:if test="(count($tagOLNFieldName) > 0) or (count($tagOLNFieldValue) > 0) ">
			<strong><xsl:value-of select="$tagOLNFieldName"/> : <xsl:value-of select="$tagOLNFieldValue"/></strong>
		</xsl:if>
		<table width="100%" class="ctc_tbl_row">
			<xsl:if test="(count($tagOLN) > 0) or (count($tagOLNST) > 0) or (count($tagOLNDate) > 0) or (count($tagOLNExpire) > 0)">
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagOLN)>0">
						<td class="ctc_tbl_data">OLN: <strong><xsl:value-of select="$tagOLN"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNST)>0">
						<td class="ctc_tbl_data">State: <strong><xsl:value-of select="$tagOLNST"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNDate)>0">
						<td class="ctc_tbl_data">Effective: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagOLNDate"/></xsl:call-template></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNExpire)>0">
						<td class="ctc_tbl_data">Expires: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagOLNExpire"/></xsl:call-template></strong></td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagOLNStatus) > 0) or (count($tagOLNncClass) > 0) or (count(//DriverLicenseNonCommercialLicensedIndicator) > 0)">
				<tr class="ctc_tbl_row">
					<xsl:if test="count(//DriverLicenseNonCommercialLicensedIndicator)>0">
						<td class="ctc_tbl_data">NC OLN Ind: <strong><xsl:value-of select="//DriverLicenseNonCommercialLicensedIndicator"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNStatus)>0">
						<td class="ctc_tbl_data">NC OLN Status: <strong><xsl:value-of select="$tagOLNStatus"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNncClass)>0">
						<td class="ctc_tbl_data">NC Class: <strong><xsl:value-of select="$tagOLNncClass"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNncLocalClass)>0">
						<td class="ctc_tbl_data">NC Local Class: <strong><xsl:value-of select="$tagOLNncLocalClass"/></strong></td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagOLNcClass) > 0) or (count($tagOLNcStatus) > 0)or (count($tagOLNPermitQuantity) > 0) or (count(//DriverLicenseCommercialLicensedIndicator) > 0)">
				<tr class="ctc_tbl_row">
					<xsl:if test="count(//DriverLicenseCommercialLicensedIndicator)>0">
						<td class="ctc_tbl_data">Commercial OLN Ind: <strong><xsl:value-of select="//DriverLicenseCommercialLicensedIndicator"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNcClass)>0">
						<td class="ctc_tbl_data">Commercial Class: <strong><xsl:value-of select="$tagOLNcClass"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNcStatus)>0">
						<td class="ctc_tbl_data">Commercial Status: <strong><xsl:value-of select="$tagOLNcStatus"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagOLNPermitQuantity)>0">
						<td class="ctc_tbl_data">Permit Quantity: <strong><xsl:value-of select="$tagOLNPermitQuantity"/></strong></td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagDriverLicenseEndorsementCode) > 0) or (count($tagDriverLicenseEndorsementText) > 0) or (count($tagDriverLicenseEndorsementEndDate) > 0)">
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagDriverLicenseEndorsementCode)>0">
						<td class="ctc_tbl_data">Endorsement: <strong><xsl:value-of select="$tagDriverLicenseEndorsementCode"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagDriverLicenseEndorsementText)>0">
						<td class="ctc_tbl_data">Endorsement Details: <strong><xsl:value-of select="$tagDriverLicenseEndorsementText"/></strong></td>
					</xsl:if>

					<xsl:if test="count($tagDriverLicenseEndorsementEndDate)>0">
						<td class="ctc_tbl_data">Endorsement End Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagDriverLicenseEndorsementEndDate"/></xsl:call-template></strong></td>

					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagDriverLicenseHMEThreatCode) > 0) or (count($tagDriverLicenseHMEThreatText) > 0) or (count($tagDriverLicenseHMEThreatDate) > 0)">
				<tr><td></td></tr>
				<tr><td><strong>- HAZMAT Endorsement -</strong></td></tr>
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagDriverLicenseHMEThreatCode)>0">
						<td class="ctc_tbl_data">Code: <strong><xsl:value-of select="$tagDriverLicenseHMEThreatCode"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagDriverLicenseHMEThreatText)>0">
						<td class="ctc_tbl_data">Details: <strong><xsl:value-of select="$tagDriverLicenseHMEThreatText"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagDriverLicenseHMEThreatDate)>0">
						<td class="ctc_tbl_data">Adjudication Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagDriverLicenseHMEThreatDate"/></xsl:call-template></strong></td>

					</xsl:if>
				</tr>
			</xsl:if>
			
		<!-- Restriction -->
		<xsl:if test="count(//DrivingRestriction) > 0">
		<p class="ctc_page_subtitle_1"><strong>- Driver License Restrictions -</strong></p>
		  <tr class="ctc_tbl_headrow">
			<th class="ctc_tbl_center_hdr">Restriction</th>
			<th class="ctc_tbl_center_hdr">Code</th>
			<th class="ctc_tbl_center_hdr">Description</th>
			<th class="ctc_tbl_center_hdr">End Date</th>
		  </tr>
		   <xsl:for-each select="//DrivingRestriction" >
			<tr class="ctc_tbl_row" valign="top"> 
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingRestrictionText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingRestrictionCode" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="DrivingRestrictionDescriptionText" /></td>
			  <!-- display EndDate in MM/DD/YYYY format -->
			<td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="DrivingRestrictionEndDate"/></xsl:call-template></td>
			</tr>
		  </xsl:for-each>
		</xsl:if>	
					
			<xsl:if test="(count(//PermitID) > 0) or (count(//PermitJurisdiction) > 0)">
				<tr><td></td></tr>
				<tr><td><strong>- Driver Permit -</strong></td></tr>
				<tr class="ctc_tbl_row">
					<xsl:if test="count(//PermitID)>0">
						<td class="ctc_tbl_data">Permit ID: <strong><xsl:value-of select="//PermitID"/></strong></td>
					</xsl:if>
					<xsl:if test="count(//PermitJurisdiction)>0">
						<td class="ctc_tbl_data">Permit Jurisdiction: <strong><xsl:value-of select="//PermitJurisdiction"/></strong></td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagPermitStatusText) > 0) or (count($tagPermitClassificationText) > 0) or (count($tagPermitIssueDate) > 0)">
				<xsl:if test="(count(//PermitID) = 0) and (count(//PermitJurisdiction) = 0)">
					<tr><td></td></tr>
				</xsl:if>
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagPermitStatusText)>0">
						<td class="ctc_tbl_data">Permit Status: <strong><xsl:value-of select="$tagPermitStatusText"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagPermitClassificationText)>0">
						<td class="ctc_tbl_data">Permit Class: <strong><xsl:value-of select="$tagPermitClassificationText"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagPermitIssueDate)>0">
						<td class="ctc_tbl_data">Effective: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagPermitIssueDate"/></xsl:call-template></strong></td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagPermitEndorsementCode) > 0) or (count($tagPermitEndorsementText) > 0) or (count($tagPermitExpirationDate) > 0)">
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagPermitEndorsementCode)>0">
						<td class="ctc_tbl_data">Endorsement: <strong><xsl:value-of select="$tagPermitEndorsementCode"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagPermitEndorsementText)>0">
						<td class="ctc_tbl_data">Endorsement Details: <strong><xsl:value-of select="$tagPermitEndorsementText"/></strong></td>
					</xsl:if>

					<xsl:if test="count($tagPermitExpirationDate)>0">
						<td class="ctc_tbl_data">Endorsement End Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagPermitExpirationDate"/></xsl:call-template></strong></td>

					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="(count($tagPermitRestrictionText) > 0) or (count($tagPermitRestrictionDesc) > 0) or (count($tagPermitRestrictionEndDate) > 0)">
				<tr><td></td></tr>
				<tr><td><strong>- Permit Restrictions -</strong></td></tr>
				<tr class="ctc_tbl_row">
					<xsl:if test="count($tagPermitRestrictionText)>0">
						<td class="ctc_tbl_data">Restriction: <strong><xsl:value-of select="$tagPermitRestrictionText"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagPermitRestrictionDesc)>0">
						<td class="ctc_tbl_data">Description: <strong><xsl:value-of select="$tagPermitRestrictionDesc"/></strong></td>
					</xsl:if>
					<xsl:if test="count($tagPermitRestrictionEndDate)>0">
						<td class="ctc_tbl_data">End Date: <strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagPermitRestrictionEndDate"/></xsl:call-template></strong></td>

					</xsl:if>
				</tr>
			</xsl:if>
					<!-- Permit Restriction -->
			<xsl:if test="count(//PermitRestriction) > 0">
			<p class="ctc_page_subtitle_1"><strong>- Permit Restrictions -</strong></p>
			  <tr class="ctc_tbl_headrow">
				<th class="ctc_tbl_center_hdr">Restriction</th>
				<th class="ctc_tbl_center_hdr">Code</th>
				<th class="ctc_tbl_center_hdr">Description</th>
				<th class="ctc_tbl_center_hdr">End Date</th>
			  </tr>
			   <xsl:for-each select="//PermitRestriction" >
				<tr class="ctc_tbl_row" valign="top"> 
				  <td class="ctc_tbl_data"><xsl:value-of select="PermitRestrictionText" /></td>
				  <td class="ctc_tbl_data"><xsl:value-of select="PermitRestrictionCode" /></td>
				  <td class="ctc_tbl_data"><xsl:value-of select="PermitRestrictionDesc" /></td>
				  <!-- display EndDate in MM/DD/YYYY format -->
				<td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="PermitRestrictionEndDate"/></xsl:call-template></td>
				</tr>
			  </xsl:for-each>
			</xsl:if>
		</table>
	</xsl:if> 

	<!-- List any Aliases for the Person -->
	<xsl:if test="count(//PersonAlias)>0">
		<p class="ctc_page_subtitle_1">Aliases</p>
		<table width="100%">
		  <xsl:for-each select="//PersonAlias" >
			<tr><td class="ctc_tbl_data"><xsl:value-of select="." /></td></tr>
		  </xsl:for-each>
		</table>
	</xsl:if>    


  </xsl:template>

  <!-- *************************** -->
  <!-- Addresses for a person -->
  <xsl:template name="Person_Address" match="Person" mode="address" >
	<xsl:param name="isCaseView" />

	<!-- Display Address information -->
	<xsl:choose>
		<xsl:when test="contains($isCaseView,'true')">
			<xsl:if test="count(Residence) > 0">
		<p class="ctc_page_subtitle_1">Residence</p>
					<xsl:call-template name="Residence_Single">
						<xsl:with-param name="nodeMode" select="Residence"/>
					</xsl:call-template>
			</xsl:if>
			<xsl:if test="count(Mailing) > 0">
		<p class="ctc_page_subtitle_1">Mailing</p>
					<xsl:call-template name="Residence_Single">
						<xsl:with-param name="nodeMode" select="Mailing"/>
					</xsl:call-template>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="count(//Residence) > 0">
		<p class="ctc_page_subtitle_1">Residence</p>
					<xsl:call-template name="Residence_Single">
						<xsl:with-param name="nodeMode" select="//Residence"/>
					</xsl:call-template>
			</xsl:if>
			<xsl:if test="count(//Mailing) > 0">
		<p class="ctc_page_subtitle_1">Mailing</p>
					<xsl:call-template name="Residence_Single">
						<xsl:with-param name="nodeMode" select="//Mailing"/>
					</xsl:call-template>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

  </xsl:template>

  <!-- *************************** -->
  <!-- THIS TEMPLATE IS NEVER CALLED, BUT IF YOU REMOVE TABLE OR DATA TEMPLATES, PUKES -->
  <xsl:template name="Person_Table" match="Person" mode="table" >
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Person" match="Person" mode="data" >
    no Person data element available
  </xsl:template>

</xsl:stylesheet>
