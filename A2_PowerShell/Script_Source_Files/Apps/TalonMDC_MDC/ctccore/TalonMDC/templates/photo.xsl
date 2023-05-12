<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>
 
  <xsl:template name="Photo_Single" match="Photo" mode="single">
	 <p class="ctc_page_subtitle_1">Associated Images(s)</p>
	 <!-- 
		Call the template that will handle displaying the image(s). 
		Use apply-templates to handle all the instances of the FileList element.
		Using call-template because apply-templates will try to match on "FileList"
		and we're not on that element anymore.
	 -->
	 <xsl:call-template name="FileList_Table">
		  <xsl:with-param name="elementPath" select="." />
		  <xsl:with-param name="totalElements" select="count(.)"/>
		  <!-- WARNING! fileType parameter will break if use select statement in param def -->
		  <xsl:with-param name="fileType">Photo</xsl:with-param>
		  <xsl:with-param name="msgMode">record</xsl:with-param>
	  </xsl:call-template>
		<xsl:if test="count(LinkInfo)>0">
			<xsl:for-each select="LinkInfo">
				<xsl:call-template name="LinkInfo" />
			</xsl:for-each>
		</xsl:if>
  
  </xsl:template>
  
  <xsl:template name="Photo_Table" match="Photo" mode="table">
  </xsl:template>

  <xsl:template name="Photo_Data" match="Photo" mode="data">
  </xsl:template>

</xsl:stylesheet>
