<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
		09/15/15 DAH	- Initial Version
  -->
  <!-- *************************** -->
  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>
  <!-- *************************** -->
  
  <!-- *************************** -->
  <xsl:template name="LabCase_Single" match="LabCase" mode="single" >

	<xsl:call-template name="LabCase_Info"/>

  </xsl:template>
  
  <!-- *************************** -->
  <xsl:template name="LabCase_Info" match="LabCase" mode="info" >
	<p class="ctc_page_subtitle_1">Case Summary</p>
	<table width="100%" class="ctc_tbl_row">
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Lab #:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:value-of select="LabCaseNumber" /></strong>
			</td>
			<td class="ctc_tbl_data"># of Cases:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:value-of select="CaseCount" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">First Submitted:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:value-of select="SubmittedDateFirst" /></strong>
			</td>
			<td class="ctc_tbl_data">Last Submitted:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:value-of select="SubmittedDateLast" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Status:</td>
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="LabCaseStatus" /></strong>
			</td>
		</tr>
		<!--
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Agency Case #:</td> 
			<td class="ctc_tbl_data"> 
				<strong><xsl:value-of select="SubmittingAgencyCases" /></strong>
			</td>
			<td class="ctc_tbl_data">Submitting Agency:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:value-of select="SubmittingAgency" /></strong>
			</td>
		</tr>
		-->
		<!--
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Offense Date:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="OffenseDate"/></xsl:call-template></strong>
			</td>
			<td class="ctc_tbl_data">First Published Date:</td>
			<td class="ctc_tbl_data"> 
				<strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="PublishDate"/></xsl:call-template></strong>
			</td>
		</tr>
		-->
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Agencies:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="SubmittingAgencies" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Investigating Officers:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="InvestigatingOfficers" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Submitting Officers:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="SubmittingOfficers" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Jurisdictions:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="Jurisdictions" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Offenses:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="Offenses" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Disciplines:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="Disciplines" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Exams:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="Exams" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Suspects:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="Suspects" /></strong>
			</td>
		</tr>
		<tr class="ctc_tbl_row" >
			<td class="ctc_tbl_data">Victims:</td> 
			<td class="ctc_tbl_data" colspan="3"> 
				<strong><xsl:value-of select="Victims" /></strong>
			</td>
		</tr>
	</table>
  </xsl:template>

</xsl:stylesheet>
