<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed filelistcall import
					- Removed table & data templates - only Single is called
	   06/20/05 MAH - Added call to LinkInfo
	   05/18/06 MAH - Moved LinkInfo to FileListCall
  -->
  <!-- *************************** -->

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Message_Single" match="Message" mode="single" >
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr><td class="ctc_msg_title"><xsl:value-of select="@DateCreated" />&#160;|&#160;<xsl:value-of select="@TimeCreated" />&#160;|&#160;<xsl:value-of select="@Source" />&#160;|&#160;<xsl:apply-templates select="Description" mode="data" /></td></tr>
	<tr><td class="ctc_msg_data"><pre><xsl:value-of select="MessageText"/></pre></td></tr>
    </table>
    <xsl:call-template name="FileListCall"/>
  </xsl:template>

</xsl:stylesheet>