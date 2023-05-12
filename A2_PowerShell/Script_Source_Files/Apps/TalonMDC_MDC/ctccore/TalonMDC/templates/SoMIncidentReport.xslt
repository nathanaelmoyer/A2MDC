<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ir="http://ojbc.org/IEPD/Exchange/IncidentReport/1.0" 
                xmlns:lexspd="http://usdoj.gov/leisp/lexs/publishdiscover/3.1" 
                xmlns:lexs="http://usdoj.gov/leisp/lexs/3.1" 
                xmlns:nc="http://niem.gov/niem/niem-core/2.0" 
                xmlns:lexsdigest="http://usdoj.gov/leisp/lexs/digest/3.1" 
                xmlns:ns="http://niem.gov/niem/structures/2.0" 
                xmlns:j="http://niem.gov/niem/domains/jxdm/4.0" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xmlns:ndexia="http://fbi.gov/cjis/N-DEx/IncidentArrest/2.1" 
                xmlns:inc-ext="http://ojbc.org/IEPD/Extensions/IncidentReportStructuredPayload/1.0" 
                xmlns:lexslib="http://usdoj.gov/leisp/lexs/library/3.1"
                xmlns:NonHtml="http://www.progress.com/StylusStudio/NonHtml">
  <xsl:output method="html"/>

  <xsl:template match="/">
    <html >
      <body>
        <p align="center">
          <strong>
            <font size="5">Incident Submission Summary</font>
          </strong>
        </p>

    
          <table border="1px" width="100%">
            <tbody>

              <tr>
                <td width="20%">Agency Name</td>
                <td width="80%">
                  <xsl:value-of select="/ir:IncidentReport/lexspd:doPublish/lexs:PublishMessageContainer/lexs:PublishMessage/lexs:DataSubmitterMetadata/lexs:SystemIdentifier/nc:OrganizationName"/>
                </td>
              </tr>
              <tr>
                <td width="20%">Agency ORI</td>
                <td width="80%">
                  <xsl:value-of select="/ir:IncidentReport/lexspd:doPublish/lexs:PublishMessageContainer/lexs:PublishMessage/lexs:DataSubmitterMetadata/lexs:SystemIdentifier/lexs:ORI"/>
                </td>
              </tr>
              <tr>
                <td width="20%">Incident Number</td>
                <td width="80%">
                  <xsl:value-of select="/ir:IncidentReport/lexspd:doPublish/lexs:PublishMessageContainer/lexs:PublishMessage/lexs:DataItemPackage/lexs:PackageMetadata/lexs:DataItemID"/>
                </td>
              </tr>              
              <tr>
                <td width="20%">Incident From Date</td>
                <td width="80%">
                  <xsl:call-template name="standard_date"><xsl:with-param name="date" select="//nc:Activity[@ns:id='Incident_1']/nc:ActivityDate/nc:Date"/></xsl:call-template>
                </td>
              </tr>  
              <tr>
                <td width="20%">Incident Summary</td>
                <td width="80%">
                  <xsl:value-of select="//nc:Activity[@ns:id='Incident_1']/nc:ActivityDescriptionText"/>
                </td>
              </tr>  
            </tbody>
          </table>
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