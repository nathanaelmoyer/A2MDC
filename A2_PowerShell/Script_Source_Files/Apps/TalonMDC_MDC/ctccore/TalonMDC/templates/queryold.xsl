<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data template
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Query_Single" match="Query" mode="single" >
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr><td class="ctc_q_title" ><xsl:value-of select="@DateCreated" />&#160;|&#160;<xsl:value-of select="@TimeCreated" />&#160;|&#160;<xsl:value-of select="Title" /></td></tr>
	<tr><td class="ctc_msg_data"><pre><xsl:value-of select="QueryString" /></pre></td></tr>
    </table>     
    <!--xsl:apply-templates select="QueryMap" mode="table"/-->
  </xsl:template>


</xsl:stylesheet>
