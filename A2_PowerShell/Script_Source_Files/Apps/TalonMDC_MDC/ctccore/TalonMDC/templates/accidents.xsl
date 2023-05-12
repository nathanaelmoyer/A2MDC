<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data templates
	   04/26/06 MAH - Added query title
	   12/07/06 MAH - Added check for Person info
  -->
  <!-- *************************** -->

<xsl:import href="accident.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Accidents_Single" match="Accidents" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:choose>
		<xsl:when test="count(PersonName)>0">
				<p class="ctc_page_subtitle_1">Accident Summary</p>
				<table width="100%">
				  <tr class="ctc_tbl_headrow">
					<th class="ctc_tbl_center_hdr">Date</th>
					<th class="ctc_tbl_center_hdr">Type</th>
					<th class="ctc_tbl_center_hdr">Description</th>
					<th class="ctc_tbl_center_hdr">ID</th>
					<th class="ctc_tbl_center_hdr">Source</th>
					<th class="ctc_tbl_center_hdr"></th>
				  </tr>
				<xsl:for-each select="*">
						<xsl:variable name="curNode" select="name(current())"/>
						<xsl:if test="contains($curNode,'PersonName')">
							<xsl:if test="string-length(PersonSurName) > 0">
								<xsl:call-template name="PersonInfo"/>
							</xsl:if>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="contains($curNode,'AccidentGrp')">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="contains($curNode,'Accident')">
								<xsl:apply-templates select="."/>
							</xsl:when>
						</xsl:choose>
				</xsl:for-each>
			</table>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="Accident_Table">
				<xsl:with-param name="node" select="//Accident"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	
    <xsl:call-template name="fldr_footer"/>

  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="AccidentGrp" match="AccidentGrp">
	  <xsl:call-template name="AccidentList">
		  <xsl:with-param name="node" select="./Accident"/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Accident" match="Accident">
	  <xsl:call-template name="AccidentList">
		  <xsl:with-param name="node" select="."/>
	  </xsl:call-template>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="AccidentList">
	<xsl:param name="node" />

	   <xsl:for-each select="$node" >
		<tr class="ctc_tbl_row" valign="top">
		  <!-- display ActivityDate in MM/DD/YYYY format -->
		  <td class="ctc_tbl_data" nowrap="nowrap"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		  <xsl:if test="count(InjectXML/FileList)>0">
			<td>
			<xsl:call-template name="FileListCall" >
			  <xsl:with-param name="msgMode">inline</xsl:with-param>
			</xsl:call-template>
			</td>
		  </xsl:if>
		</tr>
	  </xsl:for-each>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="PersonInfo">
	
	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(following-sibling::PersonBirthDate)" />
	<xsl:variable name="countPhysicalRace" select="count(following-sibling::PersonPhysicalDetails/PersonRaceText)" />
	<xsl:variable name="countPhysicalSex" select="count(following-sibling::PersonPhysicalDetails/PersonSexText)" />

		<tr class="ctc_tbl_row">
			<td colspan="6"><hr/></td>
		</tr>
		<tr class="ctc_tbl_row">
			<td class="ctc_tbl_data_em" colspan="6" align="center">
				( <xsl:value-of select="PersonSurName"/>, <xsl:value-of select="PersonGivenName"/>, <xsl:value-of select="PersonMiddleName"/>&#160;
				DOB: 
			<xsl:choose>
				<xsl:when test="$countDOB > 0"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="following-sibling::PersonBirthDate"/></xsl:call-template></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
				Race: 
			<xsl:choose>
				<xsl:when test="$countPhysicalRace > 0"><xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonRaceText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			Sex: 
			<xsl:choose>
				<xsl:when test="$countPhysicalSex > 0"><xsl:value-of select="following-sibling::PersonPhysicalDetails/PersonSexText"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
			</xsl:choose>
			)
			</td>
		</tr>
  </xsl:template>

  <!-- *************************** -->
  
</xsl:stylesheet>
