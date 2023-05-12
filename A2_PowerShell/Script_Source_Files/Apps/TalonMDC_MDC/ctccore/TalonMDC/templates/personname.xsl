<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="PersonName_Table" match="PersonName" mode="table">
    <p class="ctc_page_subtitle_1">Person Name Summary</p>
    <table cellpadding="3" border="1" width="100%">
      <xsl:for-each select="//PersonName">
        <tr>
          <td class="ctc_tbl_data">
              <xsl:value-of select="PersonSurName" />, <xsl:value-of select="PersonGivenName" />&#160;<xsl:value-of select="PersonMiddleName" />
          </td>
        </tr>
      </xsl:for-each>
    </table><br/>
  </xsl:template>

  <xsl:template name="PersonName_Single" match="PersonName" mode="single">
    <font class="ctc_single_title">Person Name: </font><xsl:value-of select="PersonSurName" />, <xsl:value-of select="PersonGivenName" />&#160;<xsl:value-of select="PersonMiddleName" /><br/>
  </xsl:template>

  <xsl:template name="PersonName" match="PersonName" mode="data">
    <xsl:value-of select="PersonSurName" />, <xsl:value-of select="PersonGivenName"  />&#160;<xsl:value-of select="PersonMiddleName"/>
  </xsl:template>

</xsl:stylesheet>
