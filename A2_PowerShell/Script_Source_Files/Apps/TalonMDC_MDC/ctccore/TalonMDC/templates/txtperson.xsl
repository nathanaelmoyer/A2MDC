<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- display person record in text -->
<xsl:output method="text"/>
<xsl:strip-space elements="*" />
<xsl:template name="txtPerson" match="Person" mode="text" >
	<xsl:if test="(string-length(PersonName/PersonSurName) > 0) ">
		<xsl:text>&#10;Name: </xsl:text><xsl:value-of select="PersonName/PersonSurName" />, <xsl:value-of select="PersonName/PersonGivenName"  /><xsl:text> </xsl:text><xsl:value-of select="PersonName/PersonMiddleName" />
		<xsl:text>&#10;</xsl:text>
	</xsl:if>	
	<xsl:if test="(count(PersonBirthDate)>0) or (count(PersonPhysicalDetails/PersonRaceText)>0) or (count(PersonPhysicalDetails/PersonSexText)>0) or (count(PersonPhysicalDetails/PersonSkinToneText)>0)">
		<xsl:if test="count(PersonBirthDate)>0">
			<xsl:text>DOB: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="PersonBirthDate"/></xsl:call-template><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(PersonPhysicalDetails/PersonRaceText)>0">
			<xsl:text>Race: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonRaceText"  /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(PersonPhysicalDetails/PersonSexText)>0">
			<xsl:text>Sex: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonSexText" />
		</xsl:if>
		<xsl:if test="count(PersonPhysicalDetails/PersonSkinToneText)>0">
			<xsl:text>Skin Tone: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonSkinToneText" /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="(count(PersonPhysicalDetails/PersonHeightMeasure)>0) or (count(PersonPhysicalDetails/PersonWeightMeasure)>0) or (count(PersonPhysicalDetails/PersonEyeColorText)>0) or (count(PersonPhysicalDetails/PersonHairColorText)>0)">
		<xsl:if test="count(PersonPhysicalDetails/PersonHeightMeasure)>0">
			<xsl:text>Height: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonHeightMeasure" /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(PersonPhysicalDetails/PersonWeightMeasure)>0">
			<xsl:text>Weight: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonWeightMeasure"  /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(PersonPhysicalDetails/PersonEyeColorText)>0">
			<xsl:text>Eyes: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonEyeColorText" /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(PersonPhysicalDetails/PersonHairColorText)>0">
			<xsl:text>Hair: </xsl:text><xsl:value-of select="PersonPhysicalDetails/PersonHairColorText"  /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<!-- IDs associated with the Person (e.g. SSN, CIN, etc.) -->
	<xsl:if test="count(PersonAssignedIDDetails)>0">
		<xsl:variable name="tagOLN" select="PersonAssignedIDDetails/PersonDriverLicenseID/ID"/>
		<xsl:variable name="tagOLNST" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDJurisdictionCode"/>
		<xsl:variable name="tagOLNDate" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDEffectiveDate"/>
		<xsl:variable name="tagOLNExpire" select="PersonAssignedIDDetails/PersonDriverLicenseID/IDExpirationDate"/>
		<xsl:variable name="tagSSN" select="PersonAssignedIDDetails/PersonSSNID/ID"/>
		<xsl:variable name="tagCIN" select="PersonAssignedIDDetails/PersonOtherID/ID"/>
		<xsl:variable name="tagSID" select="PersonAssignedIDDetails/PersonStateID/ID"/>
		<xsl:variable name="tagSIDST" select="PersonAssignedIDDetails/PersonStateID/IDJurisdictionText"/>
		<xsl:variable name="tagAFIS" select="PersonAssignedIDDetails/PersonAFISID/ID"/>
		<xsl:if test="(count($tagOLN) > 0) or (count($tagOLNST) > 0) or (count($tagOLNDate) > 0) or (count($tagOLNExpire) > 0)">
			<xsl:if test="count($tagOLN)>0">
				<xsl:text>OLN: </xsl:text><xsl:value-of select="$tagOLN"/>
				<xsl:if test="count($tagOLNST)>0">
					<xsl:text>, </xsl:text><xsl:value-of select="$tagOLNST"/><xsl:text>  </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="count($tagOLNDate)>0">
				<xsl:text>Effective: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagOLNDate"/></xsl:call-template><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count($tagOLNExpire)>0">
				<xsl:text>Expires: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="$tagOLNExpire"/></xsl:call-template>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="(count($tagSSN) > 0) or (count($tagCIN) > 0) or (count($tagSID) > 0) or (count($tagAFIS) > 0)">
			<xsl:if test="count($tagSSN)>0">
				<xsl:text>SSN: </xsl:text><xsl:value-of select="$tagSSN"/><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count($tagCIN)>0">
				<xsl:text>CIN: </xsl:text><xsl:value-of select="$tagCIN"/><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count($tagSID)>0">
				<xsl:text>SID: </xsl:text><xsl:value-of select="$tagSID"/>
				<xsl:if test="count($tagSIDST)>0">
					<xsl:text>, </xsl:text><xsl:value-of select="$tagSIDST"/><xsl:text>  </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="count($tagAFIS)>0">
				<xsl:text>AFIS: </xsl:text><xsl:value-of select="$tagAFIS"/>
			</xsl:if>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
	</xsl:if>
	<!-- Contact Info (e.g. phone) -->
	<xsl:if test="count(PrimaryContactInformation)>0">
		<xsl:for-each select="PrimaryContactInformation/ContactTelephoneNumber">
			<xsl:value-of select="TelephoneNumberCommentText"/><xsl:text>: </xsl:text><xsl:value-of select="TelephoneNumberFullID"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:if>
	<!-- Employment Info -->
	<xsl:if test="count(PersonEmployment)>0">
		<xsl:for-each select="PersonEmployment">
			<xsl:if test="string-length(EmployerName) > 0">
				<xsl:text>Employer: </xsl:text><xsl:value-of select="EmployerName"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="string-length(OccupationText) > 0">
				<xsl:text>Occupation: </xsl:text><xsl:value-of select="OccupationText"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
	<!-- ALIASES - List any Aliases for the Person -->
	<xsl:if test="count(PersonAlias)>0">
		<xsl:text>&#10;ALIAS(ES):&#10;</xsl:text>
		<xsl:for-each select="PersonAlias">
			<xsl:value-of select="." /><xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="count(Residence)>0">
		<!-- ADDRESSES - Display Address information -->
		<xsl:text>&#10;ADDRESS SUMMARY&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(Residence/LocationAddress/AddressFullText) > 0"> 
				<!-- address is not parsed -->
				<xsl:for-each select="Residence/LocationAddress">
					<xsl:value-of select="AddressFullText" />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- parsed address(es) -->
				<xsl:for-each select="Residence" >
					<!--xsl:for-each select="./LocationAddress"-->
						<xsl:if test="count(./LocationAddress/LocationStreet/StreetNumberText)>0">
							<xsl:value-of select="./LocationAddress/LocationStreet/StreetNumberText" /><xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="count(./LocationAddress/LocationStreet/StreetName)>0">
							<xsl:value-of select="./LocationAddress/LocationStreet/StreetName" /><xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="count(./LocationAddress/LocationCityName)>0">
							<xsl:value-of select="./LocationAddress/LocationCityName" /><xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="count(./LocationAddress/LocationStateCode.fips5-2Alpha)>0">
							<xsl:value-of select="./LocationAddress/LocationStateCode.fips5-2Alpha" /><xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="count(./LocationAddress/LocationStateCode.USPostalService)>0">
							<xsl:value-of select="./LocationAddress/LocationStateCode.USPostalService" /><xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="count(./LocationAddress/LocationPostalCodeID)>0">
							<xsl:value-of select="./LocationAddress/LocationPostalCodeID/ID" /><xsl:text> </xsl:text>
						</xsl:if>
						  <xsl:if test="count(./PrimaryContactInformation/ContactTelephoneNumber) > 0">
							<xsl:variable name="tempPhone" select="./PrimaryContactInformation/ContactTelephoneNumber"/>
							<xsl:if test="(string-length($tempPhone/TelephoneNumberCommentText) > 0) or (string-length($tempPhone/TelephoneNumberFullID) > 0)">
								<xsl:if test="string-length($tempPhone/TelephoneNumberCommentText) > 0">
									<xsl:value-of select="$tempPhone/TelephoneNumberCommentText"/><xsl:text> </xsl:text>
								</xsl:if>
								<xsl:if test="string-length($tempPhone/TelephoneNumberFullID) > 0">
									<xsl:value-of select="$tempPhone/TelephoneNumberFullID"/>
								</xsl:if>
							</xsl:if>
						  </xsl:if>
						<xsl:text>&#10;</xsl:text>
					<!--/xsl:for-each-->
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<!--xsl:text>&#10;</xsl:text-->
	</xsl:if>
	<!-- FILES - Checks if FileList/Photo and/or FileList/PDF elements are available and displays -->
	<!--xsl:call-template name="txtFileListCall"/-->
	<!-- INCIDENTS - If there are any incident elements, call Incident template in table format -->
	<xsl:if test="count(Incident) > 0">
		<xsl:text>&#10;INCIDENT SUMMARY&#10;</xsl:text>
		<xsl:for-each select="Incident" >
			<xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text><xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityDescriptionText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/IDSourceText" />
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="count(Corrections)>0">
		<xsl:call-template name="txtCorrections"/>
		<!--xsl:text>&#10;</xsl:text-->
	</xsl:if>
	<xsl:if test="count(Arrest)>0">
		<xsl:call-template name="txtArrest"/>
		<!--xsl:text>&#10;</xsl:text-->
	</xsl:if>
	<xsl:if test="count(Case)>0">
		<xsl:call-template name="txtCase"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="count(ProtectionOrder)>0">
		<xsl:call-template name="txtPPO"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="count(Activity)>0">
		<xsl:text>&#10;ACTIVITY SUMMARY&#10;</xsl:text>
		<xsl:for-each select="Activity" >
			<xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text><xsl:value-of select="ActivityTypeText" />
			<xsl:text>&#10;</xsl:text>
			<xsl:text>    </xsl:text><xsl:value-of select="ActivityDescriptionText"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:text>    </xsl:text><xsl:value-of select="ActivityReportingOrganization/OrganizationName"/><xsl:text> in </xsl:text><xsl:value-of select="ActivityReportingOrganization/LocationAddress/LocationCityName"/><xsl:text>, </xsl:text><xsl:value-of select="ActivityReportingOrganization/LocationAddress/LocationStateCode.fips5-2Alpha"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
		<!--xsl:text>&#10;</xsl:text-->
	</xsl:if>
	<!-- ACCIDENTS - If there are any accident elements, call Accident template in table format -->
	<xsl:if test="count(Accident) > 0">
		<xsl:text>&#10;ACCIDENT SUMMARY&#10;</xsl:text>
		<xsl:for-each select="Accident" >
			<xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text><xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityDescriptionText" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text><xsl:value-of select="ActivityID/IDSourceText" />
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:if>
	<!-- ctcDistributionText -->
	<xsl:if test="count(ctcDistributionText)>0">
		<!--xsl:value-of select="ctcDistributionText"/ -->
		  <xsl:call-template name="ReplaceBreakTags">
			<xsl:with-param name="InputString"><xsl:value-of select="ctcDistributionText"/></xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
</xsl:template>
<!-- *************************** -->
<xsl:template name="ReplaceBreakTags">
  <xsl:param name="InputString"/>
  <xsl:variable name="RemainingString" select="substring-after($InputString,'&lt;br/&gt;')"/>
  <xsl:choose>
    <xsl:when test="contains($RemainingString,'&lt;br/&gt;')">
      <xsl:value-of select="substring-before($RemainingString,'&lt;br/&gt;')"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="ReplaceBreakTags">
        <xsl:with-param name="InputString" select="substring-after($RemainingString,'&lt;br/&gt;')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$RemainingString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- *************************** -->
<xsl:template name="txtArrest" match="Arrest" mode="text" >
	<xsl:text>&#10;ARRESTS&#10;</xsl:text>
	<xsl:for-each select="Arrest" >
		<xsl:if test="count(ActivityDate)>0">
			<xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:if test="count(ActivityTypeText)>0">
			<xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:if test="count(ActivityDescriptionText)>0">
			<xsl:value-of select="ActivityDescriptionText" /><xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:if test="count(ActivityID/ID)>0">
			<xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:if test="count(ActivityID/IDSourceText)>0">
			<xsl:value-of select="ActivityID/IDSourceText" /><xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:if test="count(ArrestLocation/LocationDescriptionText)>0">
			<xsl:value-of select="ArrestLocation/LocationDescriptionText" /><xsl:text> | </xsl:text>
		</xsl:if>
		<xsl:if test="count(ArrestAgency/OrganizationName)>0">
			<xsl:value-of select="ArrestAgency/OrganizationName" />
		</xsl:if>
		<!--xsl:text>&#10;</xsl:text-->
		<xsl:if test="count(Charge/ChargeTrackingID/ID)>0">
			<xsl:text> | CTN: </xsl:text><xsl:value-of select="Charge/ChargeTrackingID/ID" />
		</xsl:if>
		<xsl:if test="count(Charge/ChargeID/ID)>0">
			<xsl:text>&#10;CHARGES&#10;</xsl:text>
			<xsl:for-each select="Charge">
				<xsl:value-of select="ChargeID/ID"/><xsl:text>  </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ChargeFilingDate"/></xsl:call-template><xsl:text>  </xsl:text><xsl:value-of select="ChargeClassification"/><xsl:text>  </xsl:text><xsl:value-of select="CourtEvent/CourtEventCourt/CourtName"/><xsl:text>  </xsl:text><xsl:value-of select="CourtEvent/CaseDocketID/ID"/>
				<xsl:text>&#10;</xsl:text>
				<xsl:if test="count(ChargeDescriptionText)>0">
					<xsl:value-of select="ChargeDescriptionText"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:if>
				<xsl:if test="count(CourtEvent/CourtEventJudge/PersonName/PersonFullName)>0">
					<xsl:value-of select="CourtEvent/CourtEventJudge/PersonName/PersonFullName"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:for-each>
</xsl:template>

<!-- *************************** -->
<xsl:template name="txtCase" match="Case" mode="text" >
	<xsl:text>&#10;COURT CASES</xsl:text>
	<xsl:for-each select="Case" >
		<xsl:if test="(count(ActivityDate)>0) or (count(CaseTrackingID/ID)>0) or (count(ActivityTypeText)>0) or (count(ActivityDescriptionText)>0)">
			<xsl:text>&#10;</xsl:text>
			<xsl:text>Date: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template>
			<xsl:text>  Case ID: </xsl:text><xsl:value-of select="CaseTrackingID/ID" />
			<xsl:text>  Type: </xsl:text><xsl:value-of select="ActivityTypeText" />
			<xsl:text>  Desc: </xsl:text><xsl:value-of select="ActivityDescriptionText" />
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="(count(CaseTypeText)>0) or (count(CaseCourt/CourtName)>0) or (count(Court/CourtName)>0) or (count(CaseCourt/OrganizationLocation/LocationAddress/LocationCountyName)>0) or (count(Court/OrganizationLocation/LocationAddress/LocationCountyName)>0) or (count(CaseStatus)>0)">
			<xsl:text>Case Type: </xsl:text><xsl:value-of select="CaseTypeText"/>
			<xsl:text>  Court: </xsl:text><xsl:value-of select="CaseCourt/CourtName"/><xsl:value-of select="Court/CourtName"/>
			<xsl:text>  County: </xsl:text><xsl:value-of select="CaseCourt/OrganizationLocation/LocationAddress/LocationCountyName"/><xsl:value-of select="Court/OrganizationLocation/LocationAddress/LocationCountyName"/>
			<xsl:if test="count(CaseStatus)>0"><xsl:text>  Status: </xsl:text><xsl:value-of select="CaseStatus/StatusText"/><xsl:text> </xsl:text><xsl:value-of select="CaseStatus/StatusDate"/></xsl:if>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="(count(CaseParticipants/CaseJudge/PersonName/PersonFullName)>0) or (count(CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText)>0) or (count(CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText)>0)">
			<xsl:value-of select="CaseParticipants/CaseJudge/JudicialOfficialTypeText"/><xsl:text>:  </xsl:text><xsl:value-of select="CaseParticipants/CaseJudge/PersonName/PersonFullName"/>
			<xsl:if test="count(CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText)>0">
				<xsl:text>  </xsl:text><xsl:value-of select="CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText"/><xsl:text>:  </xsl:text>
				<xsl:value-of select="CaseParticipants/CaseDefenseAttorney/PersonName/PersonFullName"/>
			</xsl:if>
			<xsl:if test="count(CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText)>0">
				<xsl:text>  </xsl:text><xsl:value-of select="CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText"/><xsl:text>:  </xsl:text>
				<xsl:value-of select="CaseParticipants/CaseProsecutionAttorney/PersonName/PersonFullName"/>
			</xsl:if>
			<xsl:text>&#10;&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="count(Charge)>0">
			<xsl:text>    </xsl:text><xsl:text>CHARGES&#10;</xsl:text>
			<xsl:for-each select="Charge">
				<xsl:text>    </xsl:text>
				<xsl:if test="count(ChargeID/ID)>0">
					<xsl:value-of select="ChargeID/ID"/><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ChargeID/IDSourceText)>0">
					<xsl:value-of select="ChargeID/IDSourceText"/><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ChargeClassification)>0">
					<xsl:value-of select="ChargeClassification"/><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ChargeDescriptionText)>0">
					<xsl:value-of select="ChargeDescriptionText"/>
				</xsl:if>
				<xsl:text>&#10;</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="count(CourtEvent)>0">
			<xsl:text>&#10;    EVENTS&#10;</xsl:text>
			<xsl:for-each select="CourtEvent">
				<xsl:text>    </xsl:text>
				<xsl:if test="count(CourtEventActivity/ActivityDate)>0">
					<xsl:call-template name="standard_date"><xsl:with-param name="date" select="CourtEventActivity/ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(CourtEventActivity/ActivityTypeText)>0">
					<xsl:value-of select="CourtEventActivity/ActivityTypeText"/><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(CourtEventJudge/PersonName/PersonFullName)>0">
					<xsl:value-of select="CourtEventJudge/PersonName/PersonFullName"/><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(CourtEventActivity/ActivityDescriptionText)>0">
					<xsl:value-of select="CourtEventActivity/ActivityDescriptionText"/>
				</xsl:if>
				<xsl:text>&#10;</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<!--xsl:text>&#10;</xsl:text-->
	</xsl:for-each>
</xsl:template>

<!-- *************************** -->
<xsl:template name="txtCorrections" match="Corrections" mode="text" >
	<xsl:text>&#10;CORRECTIONS&#10;</xsl:text>
	<xsl:for-each select="Corrections" >
		<xsl:if test="count(SupervisionAgency/OrganizationName)>0">
			<xsl:text>Agency: </xsl:text><xsl:value-of select="SupervisionAgency/OrganizationName" /><xsl:text>&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="(count(ActivityID/ID)>0) or (count(SupervisionTCN/ID)>0) or (count(SupervisionRelease/ActivityDate)>0) or (count(SupervisionCustodyStatus/StatusText)>0) or (count(SupervisionFacility/OrganizationDescriptionText)>0)">
			<xsl:if test="count(ActivityID/ID)>0">
				<xsl:text>Booking ID: </xsl:text><xsl:value-of select="ActivityID/ID" /><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count(SupervisionTCN/ID)>0">
				<xsl:text>TCN: </xsl:text><xsl:value-of select="SupervisionTCN/ID" /><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count(SupervisionRelease/ActivityDate)>0">
				<xsl:text>Release: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="SupervisionRelease/ActivityDate"/></xsl:call-template><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count(SupervisionCustodyStatus/StatusText)>0">
				<xsl:text>Status: </xsl:text><xsl:value-of select="SupervisionCustodyStatus/StatusText" /><xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:if test="count(SupervisionFacility/OrganizationDescriptionText)>0">
				<xsl:text>Facility: </xsl:text><xsl:value-of select="SupervisionFacility/OrganizationDescriptionText" />
			</xsl:if>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
		<xsl:if test="count(Arrest)>0">
			<xsl:text>&#10;    ARRESTS</xsl:text>
			<xsl:for-each select="Arrest" >
				<xsl:text>&#10;    </xsl:text>
				<xsl:if test="count(ActivityDate)>0">
					<xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ActivityTypeText)>0">
					<xsl:value-of select="ActivityTypeText" /><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ActivityDescriptionText)>0">
					<xsl:value-of select="ActivityDescriptionText" /><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ActivityID/ID)>0">
					<xsl:value-of select="ActivityID/ID" /><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ActivityID/IDSourceText)>0">
					<xsl:value-of select="ActivityID/IDSourceText" /><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ArrestLocation/LocationDescriptionText)>0">
					<xsl:value-of select="ArrestLocation/LocationDescriptionText" /><xsl:text> | </xsl:text>
				</xsl:if>
				<xsl:if test="count(ArrestAgency/OrganizationName)>0">
					<xsl:value-of select="ArrestAgency/OrganizationName" />
				</xsl:if>
				<xsl:if test="count(Charge/ChargeTrackingID/ID)>0">
					<xsl:text>&#10;    </xsl:text><xsl:text>CTN: </xsl:text><xsl:value-of select="Charge/ChargeTrackingID/ID" />
				</xsl:if>
				<xsl:if test="count(Charge)>0">
					<xsl:text>&#10;&#10;        CHARGES&#10;</xsl:text>
					<xsl:for-each select="Charge">
						<xsl:if test="(count(ChargeID/ID)>0) or (count(ChargeFilingDate)>0) or (count(ChargeClassification)>0) or (count(CourtEvent/CourtEventCourt/CourtName)>0) or (count(CourtEvent/CaseDocketID/ID)>0)">
							<xsl:text>        </xsl:text>
								<xsl:if test="count(ChargeID/ID)>0">
									<xsl:value-of select="ChargeID/ID"/><xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(ChargeFilingDate)>0">
									<xsl:call-template name="standard_date"><xsl:with-param name="date" select="ChargeFilingDate"/></xsl:call-template><xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(ChargeClassification)>0">
									<xsl:value-of select="ChargeClassification"/><xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(ChargeDescriptionText)>0">
									<xsl:value-of select="ChargeDescriptionText"/><xsl:text> | </xsl:text>
								</xsl:if>   
								<xsl:if test="count(CourtEvent/CourtEventCourt/CourtName)>0">
									<xsl:value-of select="CourtEvent/CourtEventCourt/CourtName"/><xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(CourtEvent/CaseDocketID/ID)>0">
									<xsl:value-of select="CourtEvent/CaseDocketID/ID"/>
								</xsl:if>
							<xsl:text>&#10;</xsl:text>
						</xsl:if>
						<xsl:if test="count(CourtEvent/CourtEventJudge/PersonName/PersonFullName)>0">
							<xsl:text>          </xsl:text><xsl:value-of select="CourtEvent/CourtEventJudge/PersonName/PersonFullName"/>
							<xsl:text>&#10;</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:for-each>
</xsl:template>
<!-- *************************** -->
<xsl:template name="txtPPO" match="ProtectionOrder" mode="text" >
	<xsl:text>&#10;PROTECTION ORDERS</xsl:text>
	<xsl:for-each select="ProtectionOrder" >
		<xsl:if test="count(ProtectionOrderRestrictedPerson/PersonName/PersonSurName)>0">
			<xsl:text>&#10;</xsl:text>
			<xsl:text>Protected: </xsl:text><xsl:value-of select="ProtectionOrderRestrictedPerson/PersonName/PersonSurName" />, <xsl:value-of select="ProtectionOrderRestrictedPerson/PersonName/PersonGivenName"  /><xsl:text> </xsl:text><xsl:value-of select="ProtectionOrderRestrictedPerson/PersonName/PersonMiddleName" />
		</xsl:if>
		<xsl:if test="count(CourtOrderIssuingDate)>0">
			<xsl:text>&#10;</xsl:text>
			<xsl:text>Date: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="CourtOrderIssuingDate"/></xsl:call-template>
			<xsl:text>  Court: </xsl:text><xsl:value-of select="CourtOrderIssuingCourt/CourtName"/>
			<xsl:text>  </xsl:text><xsl:value-of select="CourtOrderIssuingJudicialOfficial/JudicialOfficialTypeText"/><xsl:text>:  </xsl:text><xsl:value-of select="CourtOrderIssuingJudicialOfficial/PersonName/PersonFullName"/>
		</xsl:if>
		<xsl:if test="count(CourtOrderStatus/StatusText)>0">
			<xsl:text>&#10;</xsl:text>
			<xsl:text>Status: </xsl:text><xsl:value-of select="CourtOrderStatus/StatusText"/>
		</xsl:if>
		<xsl:if test="count(ConditionDisciplinaryAction)>0">
			<xsl:text>&#10;</xsl:text>
			<xsl:text>Conditions: </xsl:text><xsl:value-of select="ConditionDisciplinaryAction"/>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:for-each>
</xsl:template>


<!-- *************************** -->
</xsl:stylesheet>