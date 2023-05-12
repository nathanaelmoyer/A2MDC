<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   exclude-result-prefixes="NonHtml" xmlns:NonHtml="http://www.progress.com/StylusStudio/NonHtml">
  <xsl:output method="html"/>

  <xsl:template match="/">
    <html xmlns:s="http://niem.gov/niem/structures/2.0">
      <body>
        <p align="center">
          <strong>
            <font size="5">Prosecutor Acknowledgement</font>
          </strong>
        </p>

    
          <table border="1px" width="100%">
            <tbody>
              <tr>
                <td width="20%">Agency ORI</td>
                <td width="80%">
                  <xsl:value-of select="//ori"/>
                </td>
              </tr>
              <tr>
                <td width="20%">Incident Number</td>
                <td width="80%">
                  <xsl:value-of select="//rmsId"/>
                </td>
              </tr>     
                      
              <tr>
                <td width="20%">Date Sent</td>
                <td width="80%">
                  <xsl:call-template name="standard_date"><xsl:with-param name="date" select="//dateSent"/></xsl:call-template>
                </td>
              </tr>
              <tr>
                <td width="20%">Success</td>
                <td width="80%">
                  <xsl:value-of select="//isAck"/>
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
