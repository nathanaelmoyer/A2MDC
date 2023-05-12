<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	   10/28/05 MAH - Created
	   10/31/05 MAH - Added header, check for link and added string-length test for address street # & name
	   11/01/05 MAH - Added phone under Residence.  Moved Residence to separate template.
	   09/25/06 MAH - Added check for file to download.
	   10/25/06 MAH - Added Crime Analysis.
	   10/27/06 MAH - Added check for text in Content to handle error responses.
	   01/19/09 MAH - Added check for Location for Address TPs.
			- Added Property (part of incidents.xsl).
  -->
 
	<!-- *************************** -->
   <xsl:import href="residence.xsl" />
   <xsl:import href="incidents.xsl" />
	<!-- *************************** -->

	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<!-- *************************** -->

	<xsl:template name="MiscInfoDisplayable_Single" match="MiscInfoDisplayable" mode="single">

		<table border="0" width="100%">
			<tr>
				<td class="ctc_msg_title">
					<!--xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;<xsl:value-of select="@Source"/>&#160;|&#160;<xsl:apply-templates select="Description" mode="data"/-->
					<xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;<xsl:value-of select="@Source"/>&#160;|&#160;<xsl:apply-templates select="//Content/Description" mode="data"/>
				</td>
			</tr>
		</table>

		<xsl:if test="@ContentType='Text'">
			<!--displays text that's within the Content tag, but not in a subelement.  E.g. error responses-->
			<table cellspacing="0" cellpadding="0">
				<tr><td class="ctc_msg_data"><pre><xsl:value-of select="//Content"/></pre></td></tr>
			</table>
		</xsl:if>

		<xsl:for-each select="*">
			<xsl:variable name="curNode" select="name(current())"/>
			<xsl:if test="contains($curNode,'Content')">
			
				<!-- Check Address - LocatePLUS -->
				<xsl:if test="count(//Residence) > 0">
					<xsl:call-template name="Residence_Single">
						<xsl:with-param name="nodeMode" select="//Residence"/>
					</xsl:call-template>
				</xsl:if>

				<!-- Check Address - Other TPs -->
				<xsl:if test="count(//Location) > 0">
					<xsl:call-template name="Residence_Single">
						<xsl:with-param name="nodeMode" select="//Location"/>
					</xsl:call-template>
				</xsl:if>

				<!-- Check Property -->
				<xsl:if test="count(//Incident/Property) > 0">
					<xsl:call-template name="Property_Single">
						<xsl:with-param name="nodeMode" select="//Incident"/>
					</xsl:call-template>
				</xsl:if>

				<!--Crime Analysis-->
				<xsl:if test="count(//CAFullReport/CAPReport)">
					<xsl:for-each select="//CAFullReport/CAPReport">
							<xsl:value-of select="ResponseCount"/>
							<xsl:value-of select="ReportText"/>
					</xsl:for-each>
				</xsl:if>

			</xsl:if>
			<xsl:if test="contains($curNode,'LinkInfo')">
				<xsl:call-template name="LinkInfo"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'FileList')">
				<xsl:call-template name="FileListCall" >
				  <xsl:with-param name="msgMode">record</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

  <!-- *************************** -->
  <!-- THIS TEMPLATE IS NEVER CALLED, BUT IF YOU REMOVE TABLE OR DATA TEMPLATES, PUKES -->
  <xsl:template name="MiscInfoDisplayable_Table" match="MiscInfoDisplayable" mode="table" >
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="MiscInfoDisplayable" match="MiscInfoDisplayable" mode="data" >
  </xsl:template>
	
</xsl:stylesheet>
