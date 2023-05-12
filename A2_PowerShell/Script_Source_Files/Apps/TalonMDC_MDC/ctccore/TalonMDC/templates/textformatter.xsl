<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="txtperson.xsl"/>
	<xsl:import href="txtmessage.xsl"/>
	<xsl:output method="text"/>
	<xsl:strip-space elements="*"/>
	<!-- *************************** -->
	<xsl:template name="textformatter" match="/*">
		<xsl:apply-templates select="." mode="text"/>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="standard_date">
		<!-- Formats YYYY-MM-DD to MM/DD/YYYY.
	   Keeps any other date format in its original format
  -->
		<xsl:param name="date"/>
		<xsl:choose>
			<xsl:when test="substring($date,5,1)='-'">
				<xsl:variable name="day" select="substring($date, 9, 2)"/>
				<xsl:variable name="month" select="substring($date, 6, 2)"/>
				<xsl:variable name="year" select="substring($date, 1, 4)"/>
				<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="txtHeaderOld">
		<xsl:text>&#10;********************************&#10;</xsl:text>
		<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template name="txtHeader">
		<xsl:param name="showHeader"/>
		<xsl:param name="showSeparator"/>
		<!--xsl:param name="Separator"/-->
		
		<!--decide if should show header-->
		<xsl:choose>
			<xsl:when test="(substring($showSeparator,1,1)='T') or (substring($showSeparator,1,1)='t')">
				<xsl:text>&#10;********************************&#10;</xsl:text>
				<!--xsl:value-of select="$Separator"/-->
			</xsl:when>
			<xsl:when test="(substring($showSeparator,1,1)='F') or (substring($showSeparator,1,1)='f')">
				<!--don't show the separator-->
				<xsl:text>&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!--if old xml w/o this attribute, show separator-->
				<xsl:text>&#10;********************************&#10;</xsl:text>
				<!--xsl:value-of select="$Separator"/-->
			</xsl:otherwise>
		</xsl:choose>

		<!--decide if should show header-->
		<xsl:choose>
			<xsl:when test="(substring($showHeader,1,1)='T') or (substring($showHeader,1,1)='t')">
				<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="(substring($showHeader,1,1)='F') or (substring($showHeader,1,1)='f')">
				<!--don't show the header-->
			</xsl:when>
			<xsl:otherwise>
				<!--if old xml w/o this attribute, show header-->
				<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- *************************** -->
	<xsl:template name="Photo" match="Photo" mode="text"/>
	<!-- *************************** -->
	<xsl:template name="txtFileListCall" match="FileListCall" mode="textcall">
		<!-- Check if at least 1 Photo element exists in the FileList element -->
		<xsl:if test="count(FileList/Photo) > 0">
			<xsl:text>&#10;Image(s):&#10;An image is available for this message.  &#10;Please switch to a different view to see the image.  &#10;NOTE: Images will not be printed to dot matrix printers.&#10;</xsl:text>
		</xsl:if>
		<!-- Check if at least 1 PDF element exists in the FileList element -->
		<xsl:if test="count(FileList/PDF) > 0">
			<xsl:text>&#10;File(s):&#10;A file is available for this message.  &#10;Please switch to a different view to download the file.&#10;</xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="txtQuery" match="Query" mode="text">
		<!--xsl:text>&#10;********************************&#10;</xsl:text>
		<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="Title"/>
		<xsl:text>&#10;</xsl:text-->
		<xsl:value-of select="Title"/>		<xsl:text>&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="string-length(QueryXML)>0">
				<!--xsl:value-of select="QueryXML"/-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="QueryString"/>
		   </xsl:otherwise>	
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="txtRecord" match="Record" mode="text">
		<!--xsl:text>&#10;********************************&#10;</xsl:text>
		<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description"/>
		<xsl:text>&#10;</xsl:text-->
		<xsl:for-each select="*">
			<xsl:variable name="curNode" select="name(current())"/>
			<xsl:if test="contains($curNode,'Person')">
				<xsl:call-template name="txtPerson"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'Vehicle')">
				<xsl:call-template name="txtVehicle"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'FileList')">
				<xsl:if test="count(./Photo) > 0">
					<xsl:text>Image(s):&#10;An image is available for this message.  &#10;Please switch to a different view to see the image.  &#10;NOTE: Images will not be printed to dot matrix printers.&#10;</xsl:text>
				</xsl:if>
				<xsl:if test="count(./PDF) > 0">
					<xsl:text>File(s):&#10;A file is available for this message.  &#10;Please switch to a different view to download the file.&#10;</xsl:text>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="MiscInfo" match="MiscInfo" mode="text"/>
	<!-- *************************** -->
	<xsl:template name="txtMiscInfoDisplayable" match="MiscInfoDisplayable" mode="text">
		<!--xsl:text>&#10;********************************&#10;</xsl:text>
		<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description"/>
		<xsl:text>&#10;</xsl:text-->
		<xsl:if test="@ContentType='Text'">
			<xsl:value-of select="//Content"/>
		</xsl:if>
		<xsl:for-each select="*">
			<!--xsl:variable name="curNode" select="name(current())"/-->
			<!--xsl:if test="contains($curNode,'Content')"--> 
				<xsl:if test="count(Residence)>0">
					<xsl:call-template name="txtResidence">
						<xsl:with-param name="nodeMode" select="Residence"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="count(Location)>0">
					<xsl:call-template name="txtResidence">
						<xsl:with-param name="nodeMode" select="Location"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="count(Incident/Property)>0">
					<xsl:call-template name="txtProperty">
						<xsl:with-param name="nodeMode" select="Incident"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="count(CAFullReport/CAPReport)">
					<xsl:for-each select="CAFullReport/CAPReport">
						<xsl:value-of select="ResponseCount"/>
						<xsl:value-of select="ReportText"/>
					</xsl:for-each>
				</xsl:if>
			<!--/xsl:if-->
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="txtResidence" match="Residence" mode="text">
		<xsl:param name="nodeMode" />

		<!-- ADDRESSES - Display Address information -->
		<xsl:text>&#10;ADDRESS SUMMARY&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count($nodeMode/LocationAddress/AddressFullText) > 0">
				<!-- address is not parsed -->
				<xsl:for-each select="$nodeMode/LocationAddress">
					<xsl:value-of select="AddressFullText"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- parsed address(es) -->
				<xsl:for-each select="$nodeMode">
					<xsl:if test="count(./LocationAddress/LocationStreet/StreetNumberText)>0">
						<xsl:value-of select="./LocationAddress/LocationStreet/StreetNumberText"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="count(./LocationAddress/LocationStreet/StreetName)>0">
						<xsl:value-of select="./LocationAddress/LocationStreet/StreetName"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="count(./LocationAddress/LocationCityName)>0">
						<xsl:value-of select="./LocationAddress/LocationCityName"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="count(./LocationAddress/LocationStateCode.fips5-2Alpha)>0">
						<xsl:value-of select="./LocationAddress/LocationStateCode.fips5-2Alpha"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="count(./LocationAddress/LocationStateCode.USPostalService)>0">
						<xsl:value-of select="./LocationAddress/LocationStateCode.USPostalService"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="count(./LocationAddress/LocationPostalCodeID)>0">
						<xsl:value-of select="./LocationAddress/LocationPostalCodeID/ID"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="count(./PrimaryContactInformation/ContactTelephoneNumber) > 0">
						<xsl:variable name="tempPhone" select="./PrimaryContactInformation/ContactTelephoneNumber"/>
						<xsl:if test="(string-length($tempPhone/TelephoneNumberCommentText) > 0) or (string-length($tempPhone/TelephoneNumberFullID) > 0)">
							<xsl:if test="string-length($tempPhone/TelephoneNumberCommentText) > 0">
								<xsl:value-of select="$tempPhone/TelephoneNumberCommentText"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="string-length($tempPhone/TelephoneNumberFullID) > 0">
								<xsl:value-of select="$tempPhone/TelephoneNumberFullID"/>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				<xsl:text>&#10;</xsl:text>

				<xsl:if test="count(./Person) > 0">
					<xsl:text>&#10;PEOPLE AT THE ADDRESS</xsl:text>
					<xsl:for-each select="Person">
						<xsl:call-template name="printPersonSummary"/>
					</xsl:for-each>
					<xsl:text>&#10;</xsl:text>
				</xsl:if>

				<xsl:if test="count(./Incident) > 0">
					<xsl:text>&#10;INCIDENT SUMMARY&#10;</xsl:text>
					<xsl:call-template name="printIncidentList">
						<xsl:with-param name="node" select="./Incident"/>
					</xsl:call-template>
				</xsl:if>

				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		

	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="txtProperty" >
		<xsl:param name="nodeMode" />
 	
	<xsl:for-each select="$nodeMode" >
		<!--xsl:text>&#10;Property: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text>  </xsl:text><xsl:value-of select="ActivityTypeText"  /><xsl:text> </xsl:text><xsl:value-of select="ActivityID/ID" /-->
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Date: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template><xsl:text>  </xsl:text>
		<xsl:text>Activity Type: </xsl:text><xsl:value-of select="ActivityTypeText"/><xsl:text>  </xsl:text>
		<xsl:text>ID: </xsl:text><xsl:value-of select="ActivityID/ID"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Description: </xsl:text><xsl:value-of select="Property/PropertyDescriptionText"/><xsl:text>  </xsl:text>
		<xsl:text>Type: </xsl:text><xsl:value-of select="Property/PropertyTypeCode"/><xsl:text>  </xsl:text>
		<xsl:text>Disposition: </xsl:text><xsl:value-of select="Property/PropertyDisposition/PropertyDispostionCode"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Model: </xsl:text><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyModelName"/><xsl:text>  </xsl:text>
		<xsl:text>Brand: </xsl:text><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyBrandName"/><xsl:text>  </xsl:text>
		<xsl:text>Category: </xsl:text><xsl:value-of select="Property/PropertyPhysicalDetails/PropertyCategoryCode.nibrsPropertyCategory"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Serial #:: </xsl:text><xsl:value-of select="Property/PropertyAssignedIDDetails/PropertySerialID"/><xsl:text>  </xsl:text>
		<xsl:text>NCIC ID: </xsl:text><xsl:value-of select="Property/PropertyAssignedIDDetails/PropertyNCICID"/><xsl:text>  </xsl:text>
		<xsl:text>Owner ID: </xsl:text><xsl:value-of select="Property/PropertyAssignedIDDetails/PropertyOwnerAppliedID"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Value: </xsl:text><xsl:value-of select="Property/PropertyValueDetails/PropertyOtherValue/PropertyValueAmount"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:for-each>

	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="txtVehicle" match="Vehicle" mode="text">
		<xsl:text>&#10;Vehicle Information: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleModelYearDate"/></xsl:call-template><xsl:text>  </xsl:text><xsl:value-of select="VehicleMakeCode"  /><xsl:text> </xsl:text><xsl:value-of select="VehicleModelCode" /><xsl:text> </xsl:text><xsl:value-of select="VehicleID/ID" />
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Year: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleModelYearDate"/></xsl:call-template><xsl:text>  </xsl:text>
		<xsl:text>Make: </xsl:text><xsl:value-of select="VehicleMakeCode"/><xsl:text>  </xsl:text>
		<xsl:text>VIN: </xsl:text><xsl:value-of select="VehicleID/ID"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Style: </xsl:text><xsl:value-of select="VehicleStyleCode"/><xsl:text>  </xsl:text>
		<xsl:text>Model: </xsl:text><xsl:value-of select="VehicleModelCode"/><xsl:text>  </xsl:text><xsl:value-of select="VehicleModelCodeText"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Plate: </xsl:text><xsl:value-of select="VehicleLicensePlateID"/><xsl:text>  </xsl:text><xsl:value-of select="VehicleRegistration/RegistrationJurisdictionName"/><xsl:text>  </xsl:text>
		<xsl:text>Effective: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleRegistration/RegistrationEffectiveDate"/></xsl:call-template><xsl:text>  </xsl:text>
		<xsl:text>Expiration: </xsl:text><xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleRegistration/RegistrationExpirationDate"/></xsl:call-template>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>Description: </xsl:text><xsl:value-of select="PropertyDescriptionText"/>
		<xsl:text>&#10;</xsl:text>
		
		<xsl:if test="count(//Person) > 0">
			<xsl:for-each select="Person">
				<xsl:call-template name="printPersonSummary"/>
			</xsl:for-each>
		</xsl:if>
		
		<xsl:if test="count(//Incident) > 0">
			<xsl:text>&#10;INCIDENT SUMMARY&#10;</xsl:text>
			<xsl:call-template name="printIncidentList">
				<xsl:with-param name="node" select="./Incident"/>
			</xsl:call-template>
		</xsl:if>


	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printroot" match="root" mode="text">

		<xsl:variable name="showHeader" select="@ShowHeader"/>
		<xsl:variable name="showSeparator" select="@ShowSeparator"/>
		<!--xsl:variable name="Separator" select="@Separator"/-->

		<xsl:variable name="queryTitle" select="@Title"/>
		<xsl:if test="string-length($queryTitle) > 0">
			<xsl:text>Queried:</xsl:text>
			<xsl:value-of select="$queryTitle"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
		<!--MAH - changed to loop through each element because was getting out of order when using apply-templates-->
		<xsl:for-each select="*">
			<xsl:variable name="curNode" select="name(current())"/>
			<xsl:choose>
				<xsl:when test="contains($curNode,'Query')">
					<xsl:call-template name="txtHeader">
						<xsl:with-param name="showHeader" select="$showHeader"/>
						<xsl:with-param name="showSeparator" select="$showSeparator"/>
					</xsl:call-template>
					<xsl:call-template name="txtQuery"/>
				</xsl:when>
				<xsl:when test="contains($curNode,'Message')">
					<xsl:call-template name="txtHeader">
						<xsl:with-param name="showHeader" select="$showHeader"/>
						<xsl:with-param name="showSeparator" select="$showSeparator"/>
					</xsl:call-template>
					<xsl:call-template name="txtMessage"/>
				</xsl:when>
				<xsl:when test="contains($curNode,'Record')">
					<xsl:call-template name="txtHeader">
						<xsl:with-param name="showHeader" select="$showHeader"/>
						<xsl:with-param name="showSeparator" select="$showSeparator"/>
					</xsl:call-template>
					<xsl:call-template name="txtRecord"/>
				</xsl:when>
				<xsl:when test="contains($curNode,'Vehicle')">
					<xsl:call-template name="txtHeader">
						<xsl:with-param name="showHeader" select="$showHeader"/>
						<xsl:with-param name="showSeparator" select="$showSeparator"/>
					</xsl:call-template>
					<xsl:call-template name="txtVehicle"/>
				</xsl:when>
				<xsl:when test="contains($curNode,'MiscInfoDisplayable')">
					<xsl:call-template name="txtHeader">
						<xsl:with-param name="showHeader" select="$showHeader"/>
						<xsl:with-param name="showSeparator" select="$showSeparator"/>
					</xsl:call-template>
					<xsl:call-template name="txtMiscInfoDisplayable"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<!--Printing Case Subfolders-->
		<xsl:choose>
			<xsl:when test="count(./Accident)>0">
				<xsl:call-template name="printAccidents"/>
			</xsl:when>
			<xsl:when test="count(./LocationAddress)>0">
				<xsl:call-template name="printAddresses"/>
			</xsl:when>
			<xsl:when test="count(./Incident)>0">
				<xsl:call-template name="printIncidents"/>
			</xsl:when>
			<xsl:when test="count(./Activity)>0">
				<xsl:call-template name="printProperty"/>
			</xsl:when>
			<xsl:when test="count(./Corrections)>0">
				<xsl:call-template name="printCorrections"/>
			</xsl:when>
			<xsl:when test="count(./Arrest)>0">
				<xsl:call-template name="printArrests"/>
			</xsl:when>
			<xsl:when test="count(./Case)>0">
				<xsl:call-template name="printCourtCases"/>
			</xsl:when>
			<xsl:when test="count(./Photo)>0">
				<xsl:call-template name="printPhotos"/>
			</xsl:when>
			<xsl:when test="count(./Person)>0">
				<xsl:call-template name="printPeople"/>
			</xsl:when>
		<xsl:when test="count(./ProtectionOrder)>0">
			<xsl:call-template name="printPPO"/>
		</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAccidents" match="Accident" mode="text">
		<xsl:text>&#10;ACCIDENT SUMMARY&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="printPersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'AccidentGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Accident')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="Accident">
					<xsl:call-template name="standard_date">
						<xsl:with-param name="date" select="ActivityDate"/>
					</xsl:call-template>
					<xsl:text> | </xsl:text>
					<xsl:value-of select="ActivityTypeText"/>
					<xsl:text> | </xsl:text>
					<xsl:value-of select="ActivityDescriptionText"/>
					<xsl:text> | </xsl:text>
					<xsl:value-of select="ActivityID/ID"/>
					<xsl:text> | </xsl:text>
					<xsl:value-of select="ActivityID/IDSourceText"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAccidentGrp" match="AccidentGrp">
		<xsl:call-template name="printAccidentList">
			<xsl:with-param name="node" select="./Accident"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAccident" match="Accident">
		<xsl:call-template name="printAccidentList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAccidentList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:call-template name="standard_date">
				<xsl:with-param name="date" select="ActivityDate"/>
			</xsl:call-template>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityTypeText"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityDescriptionText"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityID/ID"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityID/IDSourceText"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAddresses" match="LocationAddress" mode="print">
		<xsl:text>&#10;ADDRESS SUMMARY&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="printPersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'LocationAddressGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'LocationAddress')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="printAddressList">
					<xsl:with-param name="node" select="//LocationAddress"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAddressGrp" match="LocationAddressGrp">
		<xsl:call-template name="printAddressList">
			<xsl:with-param name="node" select="./LocationAddress"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAddress" match="LocationAddress">
		<xsl:call-template name="printAddressList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printAddressList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:if test="(count(AddressFullText) > 0) or (string-length(LocationStreet) > 0) or (string-length(LocationBuilding) > 0)
		   or (string-length(LocationCityName) > 0) or (string-length(LocationStateCode.fips5-2Alpha) > 0) 
		   or (string-length(LocationStateCode.USPostalService) > 0) or (string-length(LocationPostalCodeID) > 0)">
				<xsl:if test="count(LocationBuilding)>0">
					<xsl:value-of select="LocationBuilding"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationStreet/StreetNumberText)>0">
					<xsl:value-of select="LocationStreet/StreetNumberText"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationStreet/StreetName)>0">
					<xsl:value-of select="LocationStreet/StreetName"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationCityName)>0">
					<xsl:value-of select="LocationCityName"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationStateCode.fips5-2Alpha)>0">
					<xsl:value-of select="LocationStateCode.fips5-2Alpha"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationStateCode.USPostalService)>0">
					<xsl:value-of select="LocationStateCode.USPostalService"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationPostalCodeID)>0">
					<xsl:value-of select="LocationPostalCodeID/ID"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="count(LocationCountyName)>0">
					<xsl:value-of select="LocationCountyName"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printArrests" match="Arrest" mode="text">
		<xsl:text>&#10;ARRESTS&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="printPersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'ArrestGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Arrest')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="printArrestList">
					<xsl:with-param name="node" select="Arrest"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printArrestGrp" match="ArrestGrp">
		<xsl:call-template name="printArrestList">
			<xsl:with-param name="node" select="./Arrest"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printArrest" match="Arrest">
		<xsl:call-template name="printArrestList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printArrestList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:if test="count(ActivityDate)>0">
				<xsl:call-template name="standard_date">
					<xsl:with-param name="date" select="ActivityDate"/>
				</xsl:call-template>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="count(ActivityTypeText)>0">
				<xsl:value-of select="ActivityTypeText"/>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="count(ActivityDescriptionText)>0">
				<xsl:value-of select="ActivityDescriptionText"/>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="count(ActivityID/ID)>0">
				<xsl:value-of select="ActivityID/ID"/>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="count(ActivityID/IDSourceText)>0">
				<xsl:value-of select="ActivityID/IDSourceText"/>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="count(ArrestLocation/LocationDescriptionText)>0">
				<xsl:value-of select="ArrestLocation/LocationDescriptionText"/>
				<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:if test="count(ArrestAgency/OrganizationName)>0">
				<xsl:value-of select="ArrestAgency/OrganizationName"/>
			</xsl:if>
			<xsl:if test="count(Charge/ChargeTrackingID/ID)>0">
				<xsl:text> | CTN: </xsl:text>
				<xsl:value-of select="Charge/ChargeTrackingID/ID"/>
			</xsl:if>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCorrections" match="Corrections" mode="text">
		<xsl:text>&#10;CORRECTIONS&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="printPersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'CorrectionsGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Corrections')">
							<xsl:apply-templates select="." mode="txtcase"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="Corrections" mode="txtcase"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCorrectionsGrp" match="CorrectionsGrp">
		<xsl:call-template name="printCorrectionsList">
			<xsl:with-param name="node" select="./Corrections"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCorrections2" match="Corrections" mode="txtcase">
		<xsl:call-template name="printCorrectionsList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCorrectionsList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:if test="count(SupervisionAgency/OrganizationName)>0">
				<xsl:text>Agency: </xsl:text>
				<xsl:value-of select="SupervisionAgency/OrganizationName"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="(count(ActivityID/ID)>0) or (count(SupervisionTCN/ID)>0) or (count(SupervisionRelease/ActivityDate)>0) or (count(SupervisionCustodyStatus/StatusText)>0) or (count(SupervisionFacility/OrganizationDescriptionText)>0)">
				<xsl:if test="count(ActivityID/ID)>0">
					<xsl:text>Booking ID: </xsl:text>
					<xsl:value-of select="ActivityID/ID"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(SupervisionTCN/ID)>0">
					<xsl:text>TCN: </xsl:text>
					<xsl:value-of select="SupervisionTCN/ID"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(SupervisionRelease/ActivityDate)>0">
					<xsl:text>Release: </xsl:text>
					<xsl:call-template name="standard_date">
						<xsl:with-param name="date" select="SupervisionRelease/ActivityDate"/>
					</xsl:call-template>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(SupervisionCustodyStatus/StatusText)>0">
					<xsl:text>Status: </xsl:text>
					<xsl:value-of select="SupervisionCustodyStatus/StatusText"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(SupervisionFacility/OrganizationDescriptionText)>0">
					<xsl:text>Facility: </xsl:text>
					<xsl:value-of select="SupervisionFacility/OrganizationDescriptionText"/>
				</xsl:if>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="count(Arrest)>0">
				<xsl:text>&#10;    ARRESTS</xsl:text>
				<xsl:for-each select="Arrest">
					<xsl:text>&#10;    </xsl:text>
					<xsl:if test="count(ActivityDate)>0">
						<xsl:call-template name="standard_date">
							<xsl:with-param name="date" select="ActivityDate"/>
						</xsl:call-template>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ActivityTypeText)>0">
						<xsl:value-of select="ActivityTypeText"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ActivityDescriptionText)>0">
						<xsl:value-of select="ActivityDescriptionText"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ActivityID/ID)>0">
						<xsl:value-of select="ActivityID/ID"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ActivityID/IDSourceText)>0">
						<xsl:value-of select="ActivityID/IDSourceText"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ArrestLocation/LocationDescriptionText)>0">
						<xsl:value-of select="ArrestLocation/LocationDescriptionText"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ArrestAgency/OrganizationName)>0">
						<xsl:value-of select="ArrestAgency/OrganizationName"/>
					</xsl:if>
					<xsl:if test="count(Charge/ChargeTrackingID/ID)>0">
						<xsl:text>&#10;    </xsl:text>
						<xsl:text>CTN: </xsl:text>
						<xsl:value-of select="Charge/ChargeTrackingID/ID"/>
					</xsl:if>
					<xsl:if test="count(Charge)>0">
						<xsl:text>&#10;&#10;        CHARGES&#10;</xsl:text>
						<xsl:for-each select="Charge">
							<xsl:if test="(count(ChargeID/ID)>0) or (count(ChargeFilingDate)>0) or (count(ChargeClassification)>0) or (count(CourtEvent/CourtEventCourt/CourtName)>0) or (count(CourtEvent/CaseDocketID/ID)>0)">
								<xsl:text>        </xsl:text>
								<xsl:if test="count(ChargeID/ID)>0">
									<xsl:value-of select="ChargeID/ID"/>
									<xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(ChargeFilingDate)>0">
									<xsl:call-template name="standard_date">
										<xsl:with-param name="date" select="ChargeFilingDate"/>
									</xsl:call-template>
									<xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(ChargeClassification)>0">
									<xsl:value-of select="ChargeClassification"/>
									<xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(ChargeDescriptionText)>0">
									<xsl:value-of select="ChargeDescriptionText"/>
									<xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(CourtEvent/CourtEventCourt/CourtName)>0">
									<xsl:value-of select="CourtEvent/CourtEventCourt/CourtName"/>
									<xsl:text> | </xsl:text>
								</xsl:if>
								<xsl:if test="count(CourtEvent/CaseDocketID/ID)>0">
									<xsl:value-of select="CourtEvent/CaseDocketID/ID"/>
								</xsl:if>
								<xsl:text>&#10;</xsl:text>
							</xsl:if>
							<xsl:if test="count(CourtEvent/CourtEventJudge/PersonName/PersonFullName)>0">
								<xsl:text>          </xsl:text>
								<xsl:value-of select="CourtEvent/CourtEventJudge/PersonName/PersonFullName"/>
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
	<xsl:template name="printCourtCases" match="Case" mode="text">
		<xsl:text>&#10;COURT CASES&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="printPersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'CaseGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Case')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="printCaseList">
					<xsl:with-param name="node" select="Case"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCaseGrp" match="CaseGrp">
		<xsl:call-template name="printCaseList">
			<xsl:with-param name="node" select="./Case"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCase" match="Case">
		<xsl:call-template name="printCaseList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printCaseList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:if test="(count(ActivityDate)>0) or (count(CaseTrackingID/ID)>0) or (count(ActivityTypeText)>0) or (count(ActivityDescriptionText)>0)">
				<xsl:text>&#10;</xsl:text>
				<xsl:text>Date: </xsl:text>
				<xsl:call-template name="standard_date">
					<xsl:with-param name="date" select="ActivityDate"/>
				</xsl:call-template>
				<xsl:text>  Case ID: </xsl:text>
				<xsl:value-of select="CaseTrackingID/ID"/>
				<xsl:text>  Type: </xsl:text>
				<xsl:value-of select="ActivityTypeText"/>
				<xsl:text>  Desc: </xsl:text>
				<xsl:value-of select="ActivityDescriptionText"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="(count(CaseTypeText)>0) or (count(CaseCourt/CourtName)>0) or (count(Court/CourtName)>0) or (count(CaseCourt/OrganizationLocation/LocationAddress/LocationCountyName)>0) or (count(Court/OrganizationLocation/LocationAddress/LocationCountyName)>0)">
				<xsl:text>Case Type: </xsl:text>
				<xsl:value-of select="CaseTypeText"/>
				<xsl:text>  Court: </xsl:text>
				<xsl:value-of select="CaseCourt/CourtName"/>
				<xsl:value-of select="Court/CourtName"/>
				<xsl:text>  County: </xsl:text>
				<xsl:value-of select="CaseCourt/OrganizationLocation/LocationAddress/LocationCountyName"/>
				<xsl:value-of select="Court/OrganizationLocation/LocationAddress/LocationCountyName"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="(count(CaseParticipants/CaseJudge/PersonName/PersonFullName)>0) or (count(CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText)>0) or (count(CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText)>0)">
				<xsl:value-of select="CaseParticipants/CaseJudge/JudicialOfficialTypeText"/>
				<xsl:text>:  </xsl:text>
				<xsl:value-of select="CaseParticipants/CaseJudge/PersonName/PersonFullName"/>
				<xsl:if test="count(CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText)>0">
					<xsl:text>  </xsl:text>
					<xsl:value-of select="CaseParticipants/CaseDefenseAttorney/JudicialOfficialTypeText"/>
					<xsl:text>:  </xsl:text>
					<xsl:value-of select="CaseParticipants/CaseDefenseAttorney/PersonName/PersonFullName"/>
				</xsl:if>
				<xsl:if test="count(CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText)>0">
					<xsl:text>  </xsl:text>
					<xsl:value-of select="CaseParticipants/CaseProsecutionAttorney/JudicialOfficialTypeText"/>
					<xsl:text>:  </xsl:text>
					<xsl:value-of select="CaseParticipants/CaseProsecutionAttorney/PersonName/PersonFullName"/>
				</xsl:if>
				<xsl:text>&#10;&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="count(Charge)>0">
				<xsl:text>    </xsl:text>
				<xsl:text>CHARGES&#10;</xsl:text>
				<xsl:for-each select="Charge">
					<xsl:text>    </xsl:text>
					<xsl:if test="count(ChargeID/ID)>0">
						<xsl:value-of select="ChargeID/ID"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ChargeID/IDSourceText)>0">
						<xsl:value-of select="ChargeID/IDSourceText"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(ChargeClassification)>0">
						<xsl:value-of select="ChargeClassification"/>
						<xsl:text> | </xsl:text>
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
						<xsl:call-template name="standard_date">
							<xsl:with-param name="date" select="CourtEventActivity/ActivityDate"/>
						</xsl:call-template>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(CourtEventActivity/ActivityTypeText)>0">
						<xsl:value-of select="CourtEventActivity/ActivityTypeText"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(CourtEventJudge/PersonName/PersonFullName)>0">
						<xsl:value-of select="CourtEventJudge/PersonName/PersonFullName"/>
						<xsl:text> | </xsl:text>
					</xsl:if>
					<xsl:if test="count(CourtEventActivity/ActivityDescriptionText)>0">
						<xsl:value-of select="CourtEventActivity/ActivityDescriptionText"/>
					</xsl:if>
					<xsl:text>&#10;</xsl:text>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printIncidents" match="Incident" mode="text">
		<xsl:text>&#10;INCIDENT AND ACTIVITY SUMMARY&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<br/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:call-template name="printPersonInfo"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'IncidentGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Incident')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'ActivityGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Activity')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#10;INCIDENT SUMMARY&#10;</xsl:text>
				<xsl:call-template name="printIncidentList">
					<xsl:with-param name="node" select="Incident"/>
				</xsl:call-template>
				<xsl:text>&#10;ACTIVITY SUMMARY&#10;</xsl:text>
				<xsl:call-template name="printActivityList">
					<xsl:with-param name="node" select="Activity"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printIncidentGrp" match="IncidentGrp">
		<xsl:call-template name="printIncidentList">
			<xsl:with-param name="node" select="./Incident"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printIncident" match="Incident">
		<xsl:call-template name="printIncidentList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printIncidentList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:call-template name="standard_date">
				<xsl:with-param name="date" select="ActivityDate"/>
			</xsl:call-template>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityTypeText"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityDescriptionText"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityID/ID"/>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityID/IDSourceText"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>

	<!-- *************************** -->
	<xsl:template name="printPersonSummary" match="Person">

			<xsl:text>&#10;Name: </xsl:text>
			<xsl:value-of select="PersonName/PersonSurName"/>, <xsl:value-of select="PersonName/PersonGivenName"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="PersonName/PersonMiddleName"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:if test="(count(PersonBirthDate)>0) or (count(PersonPhysicalDetails/PersonRaceText)>0) or (count(PersonPhysicalDetails/PersonSexText)>0) or (count(PersonPhysicalDetails/PersonSkinToneText)>0)">
				<xsl:if test="count(PersonBirthDate)>0">
					<xsl:text>DOB: </xsl:text>
					<xsl:call-template name="standard_date">
						<xsl:with-param name="date" select="PersonBirthDate"/>
					</xsl:call-template>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(PersonPhysicalDetails/PersonRaceText)>0">
					<xsl:text>Race: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonRaceText"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(PersonPhysicalDetails/PersonSexText)>0">
					<xsl:text>Sex: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonSexText"/>
				</xsl:if>
				<xsl:if test="count(PersonPhysicalDetails/PersonSkinToneText)>0">
					<xsl:text>Skin Tone: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonSkinToneText"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="(count(PersonPhysicalDetails/PersonHeightMeasure)>0) or (count(PersonPhysicalDetails/PersonWeightMeasure)>0) or (count(PersonPhysicalDetails/PersonEyeColorText)>0) or (count(PersonPhysicalDetails/PersonHairColorText)>0)">
				<xsl:if test="count(PersonPhysicalDetails/PersonHeightMeasure)>0">
					<xsl:text>Height: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonHeightMeasure"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(PersonPhysicalDetails/PersonWeightMeasure)>0">
					<xsl:text>Weight: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonWeightMeasure"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(PersonPhysicalDetails/PersonEyeColorText)>0">
					<xsl:text>Eyes: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonEyeColorText"/>
					<xsl:text>  </xsl:text>
				</xsl:if>
				<xsl:if test="count(PersonPhysicalDetails/PersonHairColorText)>0">
					<xsl:text>Hair: </xsl:text>
					<xsl:value-of select="PersonPhysicalDetails/PersonHairColorText"/>
					<xsl:text>  </xsl:text>
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
				<xsl:variable name="tagFBI" select="PersonAssignedIDDetails/PersonFBIID/ID"/>
				<xsl:if test="(count($tagOLN) > 0) or (count($tagOLNST) > 0) or (count($tagOLNDate) > 0) or (count($tagOLNExpire) > 0)">
					<xsl:if test="count($tagOLN)>0">
						<xsl:text>OLN: </xsl:text>
						<xsl:value-of select="$tagOLN"/>
						<xsl:if test="count($tagOLNST)>0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="$tagOLNST"/>
							<xsl:text>  </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="count($tagOLNDate)>0">
						<xsl:text>Effective: </xsl:text>
						<xsl:call-template name="standard_date">
							<xsl:with-param name="date" select="$tagOLNDate"/>
						</xsl:call-template>
						<xsl:text>  </xsl:text>
					</xsl:if>
					<xsl:if test="count($tagOLNExpire)>0">
						<xsl:text>Expires: </xsl:text>
						<xsl:call-template name="standard_date">
							<xsl:with-param name="date" select="$tagOLNExpire"/>
						</xsl:call-template>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="(count($tagSSN) > 0) or (count($tagCIN) > 0) or (count($tagSID) > 0) or (count($tagFBI) > 0)">
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
					<xsl:if test="count($tagFBI)>0">
						<xsl:text>FBI: </xsl:text><xsl:value-of select="$tagFBI"/>
					</xsl:if>
					<xsl:text>&#10;</xsl:text>
				</xsl:if>
				<xsl:if test="count($tagAFIS)>0">
					<xsl:text>AFIS: </xsl:text><xsl:value-of select="$tagAFIS"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:if>
			</xsl:if>
			<!-- Contact Info (e.g. phone) -->
			<xsl:if test="count(PrimaryContactInformation)>0">
				<xsl:for-each select="PrimaryContactInformation/ContactTelephoneNumber">
					<xsl:value-of select="TelephoneNumberCommentText"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="TelephoneNumberFullID"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:for-each>
			</xsl:if>
			<!-- Employment Info -->
			<xsl:if test="count(PersonEmployment)>0">
				<xsl:for-each select="PersonEmployment">
					<xsl:if test="string-length(EmployerName) > 0">
						<xsl:text>Employer: </xsl:text>
						<xsl:value-of select="EmployerName"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
					<xsl:if test="string-length(OccupationText) > 0">
						<xsl:text>Occupation: </xsl:text>
						<xsl:value-of select="OccupationText"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<!-- ALIASES - List any Aliases for the Person -->
			<xsl:if test="count(PersonAlias)>0">
				<xsl:text>&#10;ALIAS(ES):&#10;</xsl:text>
				<xsl:for-each select="PersonAlias">
					<xsl:value-of select="."/>
					<xsl:text>&#10;</xsl:text>
				</xsl:for-each>
			</xsl:if>

	</xsl:template>
	
	<!-- *************************** -->
	<xsl:template name="printPeople" match="Person" mode="text">
		<xsl:text>&#10;PEOPLE&#10;</xsl:text>
		<xsl:for-each select="Person">
		
			<xsl:call-template name="printPersonSummary"/>


			<xsl:if test="count(Residence)>0">
				<!-- ADDRESSES - Display Address information -->
				<xsl:text>&#10;ADDRESS SUMMARY&#10;</xsl:text>
				<xsl:choose>
					<xsl:when test="count(Residence/LocationAddress/AddressFullText) > 0">
						<!-- address is not parsed -->
						<xsl:for-each select="Residence/LocationAddress">
							<xsl:value-of select="AddressFullText"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- parsed address(es) -->
						<xsl:for-each select="Residence">
							<xsl:if test="count(./LocationAddress/LocationStreet/StreetNumberText)>0">
								<xsl:value-of select="./LocationAddress/LocationStreet/StreetNumberText"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="count(./LocationAddress/LocationStreet/StreetName)>0">
								<xsl:value-of select="./LocationAddress/LocationStreet/StreetName"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="count(./LocationAddress/LocationCityName)>0">
								<xsl:value-of select="./LocationAddress/LocationCityName"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="count(./LocationAddress/LocationStateCode.fips5-2Alpha)>0">
								<xsl:value-of select="./LocationAddress/LocationStateCode.fips5-2Alpha"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="count(./LocationAddress/LocationStateCode.USPostalService)>0">
								<xsl:value-of select="./LocationAddress/LocationStateCode.USPostalService"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="count(./LocationAddress/LocationPostalCodeID)>0">
								<xsl:value-of select="./LocationAddress/LocationPostalCodeID/ID"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="count(./PrimaryContactInformation/ContactTelephoneNumber) > 0">
								<xsl:variable name="tempPhone" select="./PrimaryContactInformation/ContactTelephoneNumber"/>
								<xsl:if test="(string-length($tempPhone/TelephoneNumberCommentText) > 0) or (string-length($tempPhone/TelephoneNumberFullID) > 0)">
									<xsl:if test="string-length($tempPhone/TelephoneNumberCommentText) > 0">
										<xsl:value-of select="$tempPhone/TelephoneNumberCommentText"/>
										<xsl:text> </xsl:text>
									</xsl:if>
									<xsl:if test="string-length($tempPhone/TelephoneNumberFullID) > 0">
										<xsl:value-of select="$tempPhone/TelephoneNumberFullID"/>
									</xsl:if>
								</xsl:if>
							</xsl:if>
							<xsl:text>&#10;</xsl:text>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printPhotos" match="Photo" mode="text">
		<xsl:text>ASSOCIATED IMAGE(S) &#10;</xsl:text>
		<xsl:for-each select="Photo">
			<xsl:text>Title: </xsl:text>
			<xsl:value-of select="TalonPointData/@FileTitle"/>
			<xsl:text>  </xsl:text>
			<xsl:text>Source: </xsl:text>
			<xsl:value-of select="TalonPointData/@SourceName"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printProperty" match="Activity" mode="text">
		<xsl:text>&#10;PROPERTY SUMMARY&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
				<xsl:for-each select="*">
					<xsl:variable name="curNode" select="name(current())"/>
					<xsl:if test="contains($curNode,'PersonName')">
						<xsl:if test="string-length(PersonSurName) > 0">
							<xsl:call-template name="printPersonInfo"/>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($curNode,'ActivityGrp')">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="contains($curNode,'Activity')">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="printActivityList">
					<xsl:with-param name="node" select="Activity"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printActivityGrp" match="ActivityGrp">
		<xsl:call-template name="printActivityList">
			<xsl:with-param name="node" select="./Activity"/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printActivity" match="Activity">
		<xsl:call-template name="printActivityList">
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printActivityList">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:value-of select="ActivityID/ID"/>
			<xsl:text> | </xsl:text>
			<xsl:call-template name="standard_date">
				<xsl:with-param name="date" select="ActivityDate"/>
			</xsl:call-template>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="ActivityTypeText"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:text>    </xsl:text>
			<xsl:value-of select="ActivityDescriptionText"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:text>    </xsl:text>
			<xsl:value-of select="ActivityReportingOrganization/OrganizationName"/>
			<xsl:text> in </xsl:text>
			<xsl:value-of select="ActivityReportingOrganization/LocationAddress/LocationCityName"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="ActivityReportingOrganization/LocationAddress/LocationStateCode.fips5-2Alpha"/>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	<!-- *************************** -->
	<xsl:template name="printPersonInfo">
		<xsl:text>--------------------&#10;</xsl:text>
		<xsl:text>Name: </xsl:text>
		<xsl:value-of select="PersonSurName"/>, <xsl:value-of select="PersonGivenName"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="PersonMiddleName"/>
		<xsl:text> </xsl:text>
		<xsl:if test="count(following-sibling::PersonBirthDate)>0">
			<xsl:text>DOB: </xsl:text>
			<xsl:call-template name="standard_date">
				<xsl:with-param name="date" select="following-sibling::PersonBirthDate"/>
			</xsl:call-template>
			<xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(following-sibling::PersonPhysicalDetails/PersonRaceText)>0">
			<xsl:text>Race: </xsl:text>
			<xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonRaceText"/>
			<xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:if test="count(following-sibling::PersonPhysicalDetails/PersonSexText)>0">
			<xsl:text>Sex: </xsl:text>
			<xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonSexText"/>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

<!-- *************************** -->
<xsl:template name="printPPO" match="ProtectionOrder" mode="text">
	<xsl:text>&#10;PROTECTION ORDERS&#10;</xsl:text>
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
    <xsl:text>*** END OF RECORDS *** &#10;</xsl:text>
</xsl:template>

	<!-- *************************** -->
</xsl:stylesheet>
