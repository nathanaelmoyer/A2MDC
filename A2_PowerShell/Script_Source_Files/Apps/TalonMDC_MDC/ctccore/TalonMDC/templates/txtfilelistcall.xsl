<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:strip-space elements="*" />
  <!--
	Checks if a remote file (e.g. image or PDF) is available
  -->
<xsl:template name="txtFileListCall" match="FileListCall" mode="textcall"  >
<xsl:value-of select="normalize-space(comment)"/>
<!-- Check if at least 1 Photo element exists in the FileList element -->
<xsl:if test="count(FileList/Photo) > 0" >
Image(s):
An image is a available for this message.  Please switch to a different view to download the image.
</xsl:if>
<!-- Check if at least 1 PDF element exists in the FileList element -->
<xsl:if test="count(FileList/PDF) > 0" >
PDF File(s):
A PDF file is a available for this message.  Please switch to a different view to download the file.
</xsl:if>
</xsl:template>
</xsl:stylesheet>
