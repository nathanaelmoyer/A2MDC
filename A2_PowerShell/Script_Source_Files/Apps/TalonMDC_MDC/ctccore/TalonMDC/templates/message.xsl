<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed filelistcall import
					- Removed table & data templates - only Single is called
	   06/20/05 MAH - Added call to LinkInfo
	   05/18/06 MAH - Moved LinkInfo to FileListCall
	   05/02/18 TFB - Added to get a new date for file deployment
  -->
  <!-- *************************** -->

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Message_Single" match="Message" mode="single" >
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr><td class="ctc_msg_title"><xsl:value-of select="@DateCreated" />&#160;|&#160;<xsl:value-of select="@TimeCreated" />&#160;|&#160;<xsl:value-of select="@Source" />&#160;|&#160;<xsl:apply-templates select="Description" mode="data" /></td></tr>
    </table>
	<xsl:variable name="tagPerson" select="ParsedInfo/BasicBinder/RecordSet/Record/Person"/>
	<xsl:variable name="tagPhoto" select="ParsedInfo/BasicBinder/RecordSet/Photo"/>
	<xsl:choose>
		<xsl:when test="count($tagPerson)>0">
			<xsl:call-template name="Message_Info">
				<xsl:with-param name="tagPerson" select="$tagPerson"/>
			</xsl:call-template>

			<xsl:if test="count($tagPhoto)>0">
				<xsl:call-template name="Photo_Single">
					<xsl:with-param name="tagPhoto" select="$tagPhoto"/>
				</xsl:call-template>
			</xsl:if>

		</xsl:when>
		<xsl:otherwise>
			<pre class="ctc_msg_data"><xsl:value-of select="MessageText"/></pre>
			<xsl:call-template name="FileListCall"/>
		</xsl:otherwise>
	</xsl:choose>
	
	<!--
	<xsl:call-template name="FileListCall" >
		<xsl:with-param name="msgMode">record</xsl:with-param>
	</xsl:call-template>	
	-->
	
	<!--<xsl:call-template name="FileListCall"/>-->
	
  </xsl:template>
  
  <xsl:template name="Message_Info" >
		<!-- ctcDistributionText -->
	<xsl:param name="tagPerson"/>
	<!--<pre><xsl:value-of select="$tagPerson/ctcDistributionText"/></pre>-->
	<xsl:variable name="newText">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="$tagPerson/ctcDistributionText" />
			<xsl:with-param name="replace" select="'&lt;br/&amp;gt'" />
			<xsl:with-param name="by" select="'&lt;br/&gt;'" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="newText2" select="translate($newText,';','')"/>
	
	<p class="ctc_msg_data"><xsl:value-of select="$newText2"/></p>
	
	<!--
    <xsl:call-template name="ReplaceBreakTags">
		<xsl:with-param name="InputString"><xsl:value-of select="$tagPerson/ctcDistributionText"/></xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#10;</xsl:text>
	-->

</xsl:template>
	
<xsl:template name="Photo_Single" mode="single">
	<xsl:param name="tagPhoto"/>
	<p class="ctc_page_subtitle_1">Associated Images(s)</p>
	 <xsl:call-template name="FileList_Table">
		  <xsl:with-param name="elementPath" select="$tagPhoto" />
		  <xsl:with-param name="totalElements" select="count($tagPhoto)"/>
		  <!-- WARNING! fileType parameter will break if use select statement in param def -->
		  <xsl:with-param name="fileType">Photo</xsl:with-param>
		  <xsl:with-param name="msgMode"><xsl:value-of select="''"/></xsl:with-param>
	  </xsl:call-template>
	<xsl:if test="count($tagPhoto/LinkInfo)>0">
		<xsl:for-each select="$tagPhoto/LinkInfo">
			<xsl:call-template name="LinkInfo" />
		</xsl:for-each>
	</xsl:if>

</xsl:template>
  
<!-- *************************** -->
<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
        <xsl:when test="$text = '' or $replace = ''or not($replace)" >
            <!-- Prevent this routine from hanging -->
            <xsl:value-of select="$text" />
        </xsl:when>
        <xsl:when test="contains($text, $replace)">
            <xsl:value-of select="substring-before($text,$replace)" />
            <xsl:value-of select="$by" />
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="substring-after($text,$replace)" />
                <xsl:with-param name="replace" select="$replace" />
                <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="ReplaceBreakTags">
  <xsl:param name="InputString"/>
  <xsl:variable name="RemainingString" select="substring-after($InputString,'&lt;br/&amp;gt')"/>
  <xsl:choose>
    <xsl:when test="contains($RemainingString,'&lt;br/&amp;gt')">
      <xsl:value-of select="substring-before($RemainingString,'&lt;br/&amp;gt')"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="ReplaceBreakTags">
        <xsl:with-param name="InputString" select="substring-after($RemainingString,'&lt;br/&amp;gt')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$RemainingString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>  
  
</xsl:stylesheet>