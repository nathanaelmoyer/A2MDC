<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed "Court Cases" title - displayed in case template
					- Changed call to case template - now has 2 params
	   04/26/06 MAH - Added query title
	   12/11/06 MAH - Added person info
  -->
  <!-- *************************** -->

<xsl:import href="case.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="CourtCases_Single" match="CourtCases" mode="single" >
	<xsl:if test="count(Case)>0">
		<xsl:call-template name="fldr_querytitle"/>
	
		<xsl:choose>
			<xsl:when test="count(PersonName)>0">
					<xsl:for-each select="*">
							<xsl:variable name="curNode" select="name(current())"/>
							<xsl:if test="contains($curNode,'PersonName')">
								<xsl:if test="string-length(PersonSurName) > 0">
									<br/><hr/>
									<xsl:call-template name="PersonInfo"/>
								</xsl:if>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="contains($curNode,'CaseGrp')">
									<xsl:call-template name="Case">
										<xsl:with-param name="node" select="./Case"/>
										<xsl:with-param name="isCaseView">true</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="contains($curNode,'Case')">
										<xsl:call-template name="Case">
											<xsl:with-param name="node" select="."/>
											<xsl:with-param name="isCaseView">true</xsl:with-param>
										</xsl:call-template>
								</xsl:when>
							</xsl:choose>
					</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Case">
					<xsl:with-param name="node" select="//Case"/>
					<xsl:with-param name="isCaseView">true</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:call-template name="fldr_footer"/>
	</xsl:if>
  </xsl:template>

   <!-- *************************** -->
  <xsl:template name="PersonInfo">
	
	<xsl:variable name="txtNA">N/A</xsl:variable>
	<xsl:variable name="countDOB" select="count(following-sibling::PersonBirthDate)" />
	<xsl:variable name="countPhysicalRace" select="count(following-sibling::PersonPhysicalDetails/PersonRaceText)" />
	<xsl:variable name="countPhysicalSex" select="count(following-sibling::PersonPhysicalDetails/PersonSexText)" />

	<table width="100%">
		<tr>
			<td class="ctc_tbl_data_em" align="center">
				(<xsl:value-of select="PersonSurName"/>, <xsl:value-of select="PersonGivenName"/>, <xsl:value-of select="PersonMiddleName"/>&#160;
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
	</table>
  </xsl:template>

  <!-- *************************** -->

</xsl:stylesheet>
