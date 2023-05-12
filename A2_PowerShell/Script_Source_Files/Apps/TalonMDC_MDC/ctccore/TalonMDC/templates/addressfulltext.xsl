<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="AddressFullText_Table" match="AddressFullText" mode="table" >
    <p class="ctc_page_subtitle_1">Address Summary</p>
    <table cellpadding="3" border="1" cellspacing="3"  width="100%">
      <xsl:for-each select="//AddressFullText">
        <tr>
          <td class="ctc_tbl_data"><xsl:value-of select="."/></td>
        </tr>
      </xsl:for-each>
    </table><br/>
  </xsl:template>

  <xsl:template name="AddressFullText_Single" match="AddressFullText" mode="single" >
        <table border="0" cellpadding="0" cellspacing="0"  width="100%">
         <tr>
           <td class="ctc_tbl_data">
             <xsl:value-of select="."/>
           </td>
         </tr>
       </table>
  </xsl:template>

  <xsl:template name="AddressFullText_SingleSAV" match="AddressFullText" mode="singlesav" >
      <font class="ctc_single_title">Address Full Text: </font>
        <table border="0"  width="100%">
         <tr>
           <td rowspan="2">
             <!-- Indent the address below the title -->
             &#160;&#160;
           </td>
           <td>
             <xsl:value-of select="."/>
           </td>
         </tr>
         <tr height="1">
           <td><hr/></td>
         </tr>
       </table>
  </xsl:template>

  <xsl:template name="AddressFullText" match="AddressFullText" mode="data" >
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>