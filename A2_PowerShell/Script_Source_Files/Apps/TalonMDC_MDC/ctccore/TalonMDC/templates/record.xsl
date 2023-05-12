<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed vehicles.xsl import
					- Commented out vehicle test
					- Removed table and data template processing - only Single is called
					- Removed incident
	   06/20/05 MAH - Added linkinfo
	   04/26/06 MAH - Added query title
	   04/27/06 MAH - Added template for case view
	   05/18/06 MAH - Added check for InjectXML to handle image/pdf links in case folders
	   03/29/06 MAH - Changed Queried to use style
  !-->

  <!-- *************************** -->

	<xsl:import href="person.xsl"/>
	<xsl:import href="notification.xsl"/>
	<xsl:import href="vehicle.xsl"/>
	<xsl:import href="incident.xsl"/>
	<xsl:import href="document.xsl"/>
	<xsl:import href="labcase.xsl"/>

	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
 
  <!-- *************************** -->
	<xsl:template name="Record_Single" match="Record" mode="single">

		<table border="0" width="100%">
			<tr>
				<td class="ctc_msg_title">
					<xsl:value-of select="@DateCreated"/>&#160;|&#160;<xsl:value-of select="@TimeCreated"/>&#160;|&#160;<xsl:value-of select="@Source"/>&#160;|&#160;<xsl:apply-templates select="Description" mode="data"/>
				</td>
			</tr>
		</table>

		<!--Display query string, if available-->
		<xsl:variable name="queryTitle" select="../@Title"/>
		<xsl:if test="string-length($queryTitle) > 0">
			<p class="ctc_page_subtitle_1"><!--font color="black"-->Queried: <xsl:value-of select="$queryTitle"/><!--/font--></p>
		</xsl:if>
		
		<!--xsl:apply-templates select="Person" mode="single"/-->
		
		<xsl:for-each select="*">
			<xsl:variable name="curNode" select="name(current())"/>
			<xsl:if test="contains($curNode,'Person')">
				<xsl:call-template name="Person_Single"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'Vehicle')">
				<xsl:call-template name="Vehicle_Single"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'Incident')">
				<xsl:call-template name="Incident_Single"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'Document')">
				<xsl:call-template name="Document_Single"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'LabCase')">
				<xsl:call-template name="LabCase_Single"/>
			</xsl:if>
			<xsl:if test="contains($curNode,'FileList')">
				<xsl:call-template name="FileListCall" >
				  <xsl:with-param name="msgMode">record</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="contains($curNode,'LinkInfo')">
				<xsl:call-template name="LinkInfo" />
			</xsl:if>
			<xsl:if test="contains($curNode,'Notification')">
				<xsl:call-template name="Notification_Single" />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="Record_Case" match="Record" mode="case">

		<xsl:for-each select="*">
			<xsl:variable name="curNode" select="name(current())"/>
			<xsl:if test="contains($curNode,'Person')">
				<xsl:call-template name="Person_CaseSingle"/>
			</xsl:if>
			
			<xsl:if test="contains($curNode,'Document')">
				<xsl:call-template name="Document_Single"/>
			</xsl:if>

			<xsl:if test="contains($curNode,'InjectXML')">
				<xsl:call-template name="FileListCall" >
				<xsl:with-param name="msgMode">inline</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="contains($curNode,'FileList')">
				<xsl:call-template name="FileListCall" >
				  <xsl:with-param name="msgMode">record</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

		</xsl:for-each>

		<br/><hr/>

	</xsl:template>

</xsl:stylesheet>
