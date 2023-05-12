<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- <xsl:import href="txtfilelistcall.xsl"/> -->
<xsl:output method="text"/>
<xsl:strip-space elements="*" />
<xsl:template name="txtMessage" match="Message" mode="text">
<!--xsl:value-of select="normalize-space(comment)"/-->
<!--<xsl:value-of select="@DateCreated"/> | <xsl:value-of select="@TimeCreated"/> | <xsl:value-of select="@Source"/> | <xsl:value-of select="Description" />-->
<xsl:text>&#10;</xsl:text>
<!-- display message contents -->
<xsl:variable name="tagPerson" select="ParsedInfo/BasicBinder/RecordSet/Record/Person"/>
<xsl:variable name="tagPhoto" select="ParsedInfo/BasicBinder/RecordSet/Photo"/>
<xsl:value-of select="Description" />
<xsl:text>&#10;</xsl:text>
<xsl:choose>
	<xsl:when test="count($tagPerson)>0">
		<xsl:call-template name="Message_Info">
			<xsl:with-param name="tagPerson" select="$tagPerson"/>
		</xsl:call-template>
		<xsl:if test="count($tagPhoto)>0">
		&#10;Image(s):&#10;An image is available for this message.  &#10;Please switch to a different view to see the image.
		</xsl:if>		
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="MessageText"/>
		<!-- check for associated file(s) - e.g. images or PDFs -->
		<xsl:call-template name="txtFileListCall"/>
	</xsl:otherwise>
</xsl:choose>
<!--xsl:text>&#10;********************************&#10;</xsl:text-->
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
	
	<xsl:variable name="newText3">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text" select="$newText" />
			<xsl:with-param name="replace" select="'&lt;br/&gt;'" />
			<xsl:with-param name="by" select="'&#10;'" />
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="newText2" select="translate($newText3,';','')"/>
	
	<p class="ctc_msg_data"><xsl:value-of select="$newText2"/></p>
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


</xsl:stylesheet>
