<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!--
	Calls FileList template located in ctc_templates.xsl which handles
	displaying remote files such as images and PDF files.
  -->

  <xsl:template name="FileListCall" match="FileListCall" mode="call" >
	<xsl:param name="msgMode"/>
	
	<!-- IMAGES -->
	<!-- Check if at least 1 Photo element exists in the FileList element -->
	<xsl:choose>
		<xsl:when test="(contains($msgMode,'summary')) or (contains($msgMode,'record'))">
			<!-- If msgMode is record or summary, than we're already in the FileList element.
				 So we need to check for the child Photo instead of FileList/Photo.
			-->
<!--		
In filelistcall.xsl msgMode:<xsl:value-of select="$msgMode"/>
-->
			<xsl:if test="count(//Photo) > 0">
			 <p class="ctc_page_subtitle_1">Associated Images(s)</p>
			 <!-- 
				Call the template that will handle displaying the image(s). 
				Use apply-templates to handle all the instances of the FileList element.
				Using call-template because apply-templates will try to match on "FileList"
				and we're not on that element anymore.
			 -->
			 <xsl:call-template name="FileList_Table">
				  <xsl:with-param name="elementPath" select="Photo" />
				  <xsl:with-param name="totalElements" select="count(Photo)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">Photo</xsl:with-param>
				  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
			  </xsl:call-template>
			</xsl:if>
			<!-- PDF -->
			<!-- Check if at least 1 PDF element exists in the FileList element -->
			<xsl:if test="count(//PDF) > 0" >
			 <p class="ctc_page_subtitle_1">Associated PDF File(s)</p>
			 <!-- 
				Call the template that will handle displaying the PDF file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				Using call-template because apply-templates will try to match on "FileList"
				and we're not on that element anymore.
			 -->
			 <xsl:call-template name="FileList_Table">
				  <xsl:with-param name="elementPath" select="PDF"/>
				  <xsl:with-param name="totalElements" select="count(PDF)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">PDF</xsl:with-param>
				  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
			  </xsl:call-template>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="count(FileList/Photo) > 0">
			 <p class="ctc_page_subtitle_1">Associated Images(s)</p>
			 <!-- 
				Call the template that will handle displaying the image(s). 
				Use apply-templates to handle all the instances of the FileList element.
				If getting multiple copies of the same data, switch to call-template.
			 -->
			 <xsl:apply-templates select="FileList" mode="table">
				  <xsl:with-param name="elementPath" select="//FileList/Photo" />
				  <xsl:with-param name="totalElements" select="count(//FileList/Photo)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">Photo</xsl:with-param>
			  </xsl:apply-templates>
			</xsl:if>
		
			<!-- PDF -->
			<!-- Check if at least 1 PDF element exists in the FileList element -->
			<xsl:if test="count(FileList/PDF) > 0" >
			 <p class="ctc_page_subtitle_1">Associated PDF File(s)</p>
			 <!-- 
				Call the template that will handle displaying the PDF file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				If getting multiple copies of the same data, switch to call-template.
			 -->
			 <xsl:apply-templates select="FileList" mode="table">
				  <xsl:with-param name="elementPath" select="//FileList/PDF"/>
				  <xsl:with-param name="totalElements" select="count(//FileList/PDF)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">PDF</xsl:with-param>
			  </xsl:apply-templates>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

  </xsl:template>

</xsl:stylesheet>
