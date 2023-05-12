<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:s="http://niem.gov/niem/structures/2.0" xmlns:p1="http://ijis-fidex/1.0/doc/DispositionReporting" xmlns:p3="http://niem.gov/niem/niem-core/2.0" xmlns:p4="http://ijis-fidex/1.0" xmlns:p5="http://niem.gov/niem/domains/jxdm/4.0" xmlns:j="http://niem.gov/niem/domains/jxdm/4.1"  exclude-result-prefixes="NonHtml p1 p3 p4 p5 s" xmlns:NonHtml="http://www.progress.com/StylusStudio/NonHtml">
  <xsl:output method="html" />

  <xsl:template match="/">
    <html>
<style>
table, td, th{
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border: 1px solid black;
    border-collapse: collapse;
}
</style>

      <body>
        <p align="center">
          <strong>
            <font size="5">Disposition Report</font>
          </strong>
        </p>

    
          <table width="100%" >
            <tbody>
			<tr>
              <th></th>
              <th>
                <em>REPORTING AGENCY</em>
              </th>
			  </tr>
              <tr>
                <td width="30%">Agency Name</td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:Agency/p3:OrganizationName"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Agency ORI</td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:Agency/p3:OrganizationOtherIdentification/p3:IdentificationID"/>
                </td>
              </tr>
              <tr>
                
                <xsl:variable name="AGENCYID" select="p1:DispositionReporting/p4:Payload/p3:Agency/@s:id"/>
                <xsl:variable name="CONTACTREF" select="p1:DispositionReporting/p4:Payload/p3:OrganizationContactInformationAssociation/p3:OrganizationReference[@s:ref=$AGENCYID]/../p3:ContactInformationReference/@s:ref"/>
 
                <td width="30%">Phone Number</td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:ContactInformation[@s:id = $CONTACTREF]/p3:ContactTelephoneNumber/p3:FullTelephoneNumber/p3:TelephoneNumberFullID"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Address</td>
                <td width="70%">
                  <xsl:variable name="AGENCYID" select="p1:DispositionReporting/p4:Payload/p3:Agency/@s:id"/>
                  <xsl:variable name="ADDRESSREF" select="p1:DispositionReporting/p4:Payload/p3:LocationOrganizationAssociation/p3:OrganizationReference[@s:ref=$AGENCYID]/../p3:LocationReference/@s:ref"/>
 
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:Address[@s:id = $ADDRESSREF]/p3:StructuredAddress/p3:LocationStreet/p3:StreetFullText"/><![CDATA[, ]]>
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:Address[@s:id = $ADDRESSREF]/p3:StructuredAddress/p3:LocationCityName"/><![CDATA[, ]]>
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:Address[@s:id = $ADDRESSREF]/p3:StructuredAddress/p3:LocationStateUSPostalServiceCode"/><![CDATA[, ]]>
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p3:Address[@s:id = $ADDRESSREF]/p3:StructuredAddress/p3:LocationPostalCode"/>
                </td>
              </tr>
            </tbody>
          </table>
        

          <table width="100%" >
            <tbody>
			<tr>
              <th></th>
              <th>
                <em>CASE DISPOSITION</em>
              </th>
			  </tr>
              <tr>
                <td width="30%">Disposition Date</td>
                <td width="70%">
                  <xsl:call-template name="standard_date"><xsl:with-param name="date" select="p1:DispositionReporting/p4:Payload/p4:Case/p3:CaseDisposition/p3:DispositionDate/p3:Date"/></xsl:call-template>
                </td>
              </tr>
              <tr>
                <td width="30%">
                  Disposition Description
                </td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p4:Case/p3:CaseDisposition/p3:DispositionDescriptionText"/>
                </td>
              </tr>
            </tbody>
          </table>
          <table width="100%" >
            <tbody>
			<tr>
              <th></th>
              <th>
                <em>COURT CASE IDENTIFIERS</em>
              </th>
			  </tr>
              <tr>
                <td width="30%">Court Case Number</td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p4:Case/p3:CaseDocketID"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Court Case File Date</td>
                <td width="70%">
                  <xsl:call-template name="standard_date"><xsl:with-param name="date" select="p1:DispositionReporting/p4:Payload/p4:Case/p3:CaseFiling/p3:DocumentFiledDate/p3:Date"/></xsl:call-template>
                </td>
              </tr>
              <tr>
                <td width="30%">Court Name</td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p4:Case/p5:CaseAugmentation/p5:CaseCourt/p5:CourtName"/>
                </td>
              </tr>
              <tr>
                <td width="30%">
                  Court ORI
                </td>
                <td width="70%">
                  <xsl:value-of select="p1:DispositionReporting/p4:Payload/p4:Case/p5:CaseAugmentation/p5:CaseCourt/p3:OrganizationOtherIdentification/p3:IdentificationID"/>
                </td>
              </tr>

            </tbody>
          </table>
          <table  width="100%">
            <tbody>
			<tr>
              <th></th>
              <th>
                <em>ARRESTS</em>
              </th>
			  </tr>
            <xsl:for-each select="p1:DispositionReporting/p4:Payload/p5:Arrest">

              <tr>
                <td width="30%">Arrest Date</td>
                <td width="70%">
                  <xsl:call-template name="standard_date"><xsl:with-param name="date" select="./p3:ActivityDate/p3:Date"/></xsl:call-template>
                </td>
              </tr>
              <tr>
                <td width="30%">Booking ID</td>
                <td width="70%">
                  <xsl:value-of select="./p3:ActivityIdentification/p3:IdentificationID"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Agency Incident Number</td>
                <td width="70%">
                  <xsl:value-of select="./p5:ArrestAgencyRecordIdentification/p3:IdentificationID"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Agency Name</td>
                <td width="70%">
                  <xsl:value-of select="./p5:ArrestAgency/p3:OrganizationName"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Agency ORI</td>
                <td width="70%">
                  <xsl:value-of select="./p5:ArrestAgency/p3:OrganizationLocalIdentification/p3:IdentificationID"/>
                </td>
              </tr>
              <tr>
                <td width="30%">Agency Other ID</td>
                <td width="70%">
                  <xsl:value-of select="./p5:ArrestAgency/p3:OrganizationOtherIdentification/p3:IdentificationID"/>
                </td>
              </tr>              
              <xsl:variable  name="PERSONREF"  select="./p5:ArrestSubject/p3:RoleOfPersonReference/@s:ref"/>
              <tr><td></td>
				<td>
                  <table border="none">
                  <tbody>
                    <tr>
                      <td width="20%">Arestee</td>
                      <td width="80%">
                        <xsl:value-of select="//p1:DispositionReporting/p4:Payload/p4:Person[@s:id=$PERSONREF]/p3:PersonName/p3:PersonSurName"/><![CDATA[, ]]>
                        <xsl:value-of select="//p1:DispositionReporting/p4:Payload/p4:Person[@s:id=$PERSONREF]/p3:PersonName/p3:PersonGivenName"/>
                      </td>
                    </tr>
                    <tr>
                      <td width="20%">DOB</td>
                      <td width="80%">
                        <xsl:call-template name="standard_date"><xsl:with-param name="date" select="//p1:DispositionReporting/p4:Payload/p4:Person[@s:id=$PERSONREF]/p3:PersonBirthDate/p3:Date"/></xsl:call-template>

                      </td>
                    </tr>
                  </tbody>
                </table>
              </td></tr>
            </xsl:for-each>
            </tbody>
          </table>

         
          <!-- <xsl:variable name="CHARGE" select="@s:id"/>
          <xsl:value-of select="$CHARGE"/>
          -->
            <xsl:for-each select="p1:DispositionReporting/p4:Payload/j:ProsecutionCharge">
              <table width="100%" >
              <tbody>
			  <tr>
                <th></th>
                <th>
                  <em>CHARGES</em>
                </th>
				</tr>
                  <tr>
                  <td width="30%">Section and Code</td>
                  <td width="70%">
                    <xsl:value-of select="./j:ChargeStatute/j:StatuteCodeSectionIdentification/p3:IdentificationID"/><![CDATA[/]]>
                    <xsl:value-of select="./j:ChargeStatute/j:StatuteCodeIdentification/p3:IdentificationID"/>
                  </td>
                </tr>
                <tr>
                  <td width="30%">Description</td>
                  <td width="70%">
                    <xsl:value-of select="./j:ChargeDescriptionText"/>
                  </td>
                </tr>
                  <xsl:variable  name="PERSONREF"  select="./j:ChargeSubject/p3:RoleOfPersonReference/@s:ref"/>
				<tr>
				<td width="30%"></td>
				<td width="70%">
                  <table border="none">
                    <tbody>
                      <tr>
                        <td width="20%">Charged</td>
                        <td width="80%">
                          <xsl:value-of select="//p1:DispositionReporting/p4:Payload/p4:Person[@s:id=$PERSONREF]/p3:PersonName/p3:PersonSurName"/><![CDATA[, ]]>
                          <xsl:value-of select="//p1:DispositionReporting/p4:Payload/p4:Person[@s:id=$PERSONREF]/p3:PersonName/p3:PersonGivenName"/>
                        </td>
                      </tr>
                      <tr>
                        <td width="20%">DOB</td>
                        <td width="80%">
                          <xsl:call-template name="standard_date"><xsl:with-param name="date" select="//p1:DispositionReporting/p4:Payload/p4:Person[@s:id=$PERSONREF]/p3:PersonBirthDate/p3:Date"/></xsl:call-template>

                        </td>
                      </tr>
                      
                    </tbody>
                  </table>              
				</td>				  
				</tr>       
              </tbody>
            </table>
            </xsl:for-each>

      </body>
    </html>
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

</xsl:stylesheet>
