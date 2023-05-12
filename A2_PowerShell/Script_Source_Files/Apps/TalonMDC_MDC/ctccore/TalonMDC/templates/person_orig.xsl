<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="personname.xsl" />
  <xsl:import href="filelistcall.xsl" />
  <xsl:import href="personalias.xsl" />
  <xsl:import href="incident.xsl" />
  <xsl:import href="residence.xsl" />
  <xsl:import href="corrections.xsl" />
  <xsl:import href="arrests.xsl" />
  <!--xsl:import href="testsort.xsl" /-->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <xsl:template name="Person_Single" match="Person" mode="single" >
	<xsl:param name="isCaseView" />
	
	<xsl:variable name="txtNA">N/A</xsl:variable>
    <xsl:variable name="countDOB" select="count(PersonBirthDate)" />
    <xsl:variable name="countPhysical" select="count(PersonPhysicalDetails/*)" />
    
    <p class="ctc_page_title">Person Summary - <xsl:apply-templates select="PersonName" mode="data" /></p>
    
    <xsl:if test="($countDOB > 0) or ($countPhysical > 0)">
		<p class="ctc_page_subtitle_1">Statistics Summary</p>
		<table border="1" width="100%">
		<tr >
		  <td class="ctc_tbl_left_hdr" colspan="4" > </td>
		</tr>
		<xsl:if test="(count(PersonBirthDate)>0) or (count(PersonPhysicalDetails/PersonRaceText)>0) or (count(PersonPhysicalDetails/PersonSexText)>0) or (count(PersonPhysicalDetails/PersonSkinToneText)>0)">
			<tr>
				  <td class="ctc_tbl_data"><strong>DOB: </strong>
				  <xsl:choose>
					<!--xsl:when test="$countDOB > 0"><xsl:value-of select="PersonBirthDate" /></xsl:when-->	
					<!-- display DOB, convert to MM/DD/YYYY format -->				
					<xsl:when test="$countDOB > 0"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="PersonBirthDate"/></xsl:call-template></xsl:when>					
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"><strong>Race: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonRaceText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonRaceText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"><strong>Sex: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonSexText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonSexText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"><strong>Skin Tone: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonSkinToneText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonSkinToneText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
			</tr>
		</xsl:if>
		<xsl:if test="(count(PersonPhysicalDetails/PersonHeightMeasure)>0) or (count(PersonPhysicalDetails/PersonWeightMeasure)>0) or (count(PersonPhysicalDetails/PersonEyeColorText)>0) or (count(PersonPhysicalDetails/PersonHairColorText)>0)">
			<tr>
				  <td class="ctc_tbl_data"><strong>Height: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonHeightMeasure)>0"><xsl:value-of select="PersonPhysicalDetails/PersonHeightMeasure" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"><strong>Weight: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonWeightMeasure)>0"><xsl:value-of select="PersonPhysicalDetails/PersonWeightMeasure" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"><strong>Eyes: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonEyeColorText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonEyeColorText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
				  <td class="ctc_tbl_data"><strong>Hair: </strong>
				  <xsl:choose>
					<xsl:when test="count(PersonPhysicalDetails/PersonHairColorText)>0"><xsl:value-of select="PersonPhysicalDetails/PersonHairColorText" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
				  </xsl:choose>
				  </td>
			</tr>
		</xsl:if>
		</table>
	</xsl:if>    
	
	<!-- IDs associated with the Person (e.g. SSN, CIN, etc.) -->
	<xsl:if test="count(PersonAssignedIDDetails)>0">
		<p class="ctc_page_subtitle_1">Identification Numbers</p>
		<table border="1" width="100%">
			<tr >
			  <td class="ctc_tbl_left_hdr" colspan="5" > </td>
			</tr>
			<tr>
				<td class="ctc_tbl_data"><strong>OLN: </strong><xsl:value-of select="PersonAssignedIDDetails/PersonDriverLicenseID/ID"/>, <xsl:value-of select="PersonAssignedIDDetails/PersonDriverLicenseID/IDJurisdictionCode"/></td>
				<td class="ctc_tbl_data"><strong>SSN: </strong><xsl:value-of select="PersonAssignedIDDetails/PersonSSNID/ID"/></td>
				<td class="ctc_tbl_data"><strong>CIN: </strong><xsl:value-of select="PersonAssignedIDDetails/PersonOtherID/ID"/></td>
				<td class="ctc_tbl_data"><strong>SID: </strong><xsl:value-of select="PersonAssignedIDDetails/PersonStateID/ID"/>, <xsl:value-of select="PersonAssignedIDDetails/PersonStateID/IDJurisdictionText"/></td>
				<td class="ctc_tbl_data"><strong>AFIS: </strong><xsl:value-of select="PersonAssignedIDDetails/PersonAFISID/ID"/></td>
			</tr>
		</table>
	</xsl:if>
	
	<!-- List any Aliases for the Person -->
	<xsl:call-template name="PersonAlias_Table"/>

	<!-- Contact Info (e.g. phone) -->
	<xsl:if test="count(PrimaryContactInformation)>0">
		<p class="ctc_page_subtitle_1">Contact Information</p>
		<table border="1" width="100%">
			<tr >
			  <td class="ctc_tbl_left_hdr" colspan="1" > </td>
			</tr>
			<xsl:for-each select="PrimaryContactInformation/ContactTelephoneNumber">
				<tr>
					<td class="ctc_tbl_data"><strong><xsl:value-of select="TelephoneNumberCommentText"/>: </strong><xsl:value-of select="TelephoneNumberFullID"/></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:if>

	<!-- Display Address information -->
	<xsl:choose>
		<xsl:when test="contains($isCaseView,'true')">
			<xsl:if test="count(Residence) > 0">
				<xsl:call-template name="Residence_Single" >
					<xsl:with-param name="nodeMode" select="Residence"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="count(//Residence) > 0">
				<xsl:call-template name="Residence_Single">
					<xsl:with-param name="nodeMode" select="//Residence"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

	<!-- FileList template checks if FileList/Photo and/or FileList/PDF elements are available and displays -->
    <xsl:call-template name="FileListCall"/>
    
    <!-- If there are any incident elements, call Incident template in table format -->
	<xsl:choose>
		<xsl:when test="contains($isCaseView,'true')">
			<xsl:if test="count(Incident) > 0">
			  <xsl:call-template name="Incident_Table"> 
				  <xsl:with-param name="caseview">true</xsl:with-param>
			  </xsl:call-template>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="count(//Incident) > 0">
			  <xsl:call-template name="Incident_Table"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

	<!-- Corrections info -->
	<xsl:if test="count(//Corrections) > 0">
		<xsl:call-template name="Corrections"/>
	</xsl:if>

	<!-- Arrest info -->
	<xsl:if test="count(//Arrests) > 0">
		<xsl:call-template name="Arrests"/>
	</xsl:if>

    <!-- PROCESS EVERYTHING ELSE -->
	<p class="ctc_page_subtitle_1">Miscellaneous Details</p>
	<!--table border="1" width="100%"-->
	<table width="100%">

	<!-- Loop through each child tags.  Unknown tags will use default processing-->
	<xsl:for-each select="*[position() >= 1 and position() &lt;= last()]">

		<!-- Set the current node name so we can check if we have already processed this node -->
		<xsl:variable name="curNodeName" select="name(.)"/>
				
		<xsl:choose>
			<!-- PERSON NAME -->
			<xsl:when test="contains($curNodeName,'PersonName')">
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- DOB -->
			<xsl:when test="contains($curNodeName,'PersonBirthDate')">			
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- PHYSICAL DETAILS -->
			<xsl:when test="contains($curNodeName,'PersonPhysicalDetails')">			
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- IDS -->
			<xsl:when test="contains($curNodeName,'PersonAssignedIDDetails')">			
				<!-- Ignore, already processed it -->
			</xsl:when>
			
			<!-- PERSON ALIAS -->
			<xsl:when test="contains($curNodeName,'PersonAlias')">
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- CONTACT INFO -->
			<xsl:when test="contains($curNodeName,'PrimaryContactInformation')">
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- RESIDENCE -->
			<xsl:when test="contains($curNodeName,'Residence')">
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- INCIDENTS -->
			<xsl:when test="contains($curNodeName,'Incident')">
				<!-- Ignore, already processed it -->
			</xsl:when>

			<!-- CORRECTIONS -->
			<!--xsl:when test="contains($curNodeName,'Corrections')"-->
				<!-- Ignore, already processed it -->
			<!--/xsl:when-->

			<!-- ARRESTS -->
			<!--xsl:when test="contains($curNodeName,'Arrests')"-->
				<!-- Ignore, already processed it -->
			<!--/xsl:when-->
			
			<!-- EVERYTHING ELSE -->
			<xsl:otherwise>
				<tr>
					<td class="ctc_tbl_data"><strong><xsl:value-of select="$curNodeName"/>:</strong> <xsl:apply-templates select="." /></td>
				</tr>
			</xsl:otherwise>
		
		</xsl:choose>
		
	</xsl:for-each>

	</table>

	<xsl:if test="contains($isCaseView,'true')">
		<br/><hr/>
	</xsl:if>
  </xsl:template>

  <!-- *************************** -->
  <!-- THIS TEMPLATE IS NEVER CALLED -->
  <xsl:template name="Person_Table" match="Person" mode="table" >
    <p class="ctc_page_subtitle_1">Person Summary</p>
    <table border="1" width="100%">
      <tr>
        <th class="ctc_tbl_center_hdr">Name</th>
        <th class="ctc_tbl_center_hdr">DOB</th>
        <th class="ctc_tbl_center_hdr">Race</th>
        <th class="ctc_tbl_center_hdr">Sex</th>
        <th class="ctc_tbl_center_hdr">Weight</th>
        <th class="ctc_tbl_center_hdr">Images<br/>Available</th>
      </tr>
      <xsl:for-each select="//Person">
        <tr>
          <td class="ctc_tbl_data"><xsl:apply-templates select="PersonName" mode="data" /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="PersonBirthDate" /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="PersonPhysicalDetails/PersonRaceText" /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="PersonPhysicalDetails/PersonSexText" /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="PersonPhysicalDetails/PersonWeightMeasure" /></td>
          <td class="ctc_tbl_data" align="center" >
			<!-- FileList template checks if FileList/Photo and/or FileList/PDF elements are available and displays -->
			<xsl:call-template name="FileListCall"/>
          </td>
        </tr>
	  <tr>
	    <td>
    		<xsl:if test="count(//Incident) > 0">
			  <xsl:call-template name="Incident_Table"/>
    		</xsl:if>
	    </td>
	  </tr>
      </xsl:for-each>
    </table>
   </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Person" match="Person" mode="data" >
    no Person data element available
  </xsl:template>

</xsl:stylesheet>
