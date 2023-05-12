<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   12/16/08 MAH - Fixed to transform actual Vehicle XML
	   02/05/09 MAH - Added case template
	   03/31/10 MAH - Added description for vehicle
  -->
  <!-- *************************** -->
   <xsl:import href="person.xsl" />

  <!-- *************************** -->
  <xsl:template name="Vehicle_Table" match="Vehicle" mode="table">
    <p class="ctc_page_subtitle_1">Vehicle Summary</p>
    <table width="100%" class="ctc_tbl_row">
      <tr class="ctc_tbl_row">
        <th class="ctc_tbl_center_hdr">VIN</th>
        <th class="ctc_tbl_center_hdr">Make</th>
        <th class="ctc_tbl_center_hdr">Model</th>
        <th class="ctc_tbl_center_hdr">Year</th>
        <!--th class="ctc_tbl_center_hdr">Detail</th-->
      </tr>
      <xsl:for-each select="//Vehicle">
        <tr class="ctc_tbl_row">
          <td class="ctc_tbl_data"><xsl:value-of select="VehicleID"  /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="VehicleMakeCode"  /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="VehicleModelCode"  /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="VehicleModelYearDate"  /></td>
          <!--td class="ctc_tbl_data">
            <xsl:call-template name="Link" >
              <xsl:with-param name="desc" select="string('View')" />
              <xsl:with-param name="dest" select="string(@CTC_OwnerID)" />
              <xsl:with-param name="type" select="string('view')" />
            </xsl:call-template>
          </td-->
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Vehicle_Case" match="Vehicle" mode="case" >
	<xsl:param name="nodeMode" />

	<xsl:call-template name="Vehicle_Info"/>

	<xsl:variable name="sourceID" select="./InjectXML/@ID" />
	<xsl:if test="string-length($sourceID) > 0">
		<xsl:variable name="linkHref" select="concat('link:display=window+id=', $sourceID)" />
		<a href="{$linkHref}">View Source</a>
	</xsl:if>
			
	<br/><hr/>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Vehicle_Single" match="Vehicle" mode="single" >

	<xsl:call-template name="Vehicle_Info"/>
	<xsl:call-template name="Vehicle_Details"/>

  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Vehicle_Info" match="Vehicle" mode="info" >
  
    <xsl:variable name="txtNA">N/A</xsl:variable>
 
    <p class="ctc_page_subtitle_1">Vehicle Information: <xsl:value-of select="VehicleModelYearDate"  />&#160;<xsl:value-of select="VehicleMakeCode"  />&#160;<xsl:value-of select="VehicleModelCode"  />&#160;<xsl:value-of select="VehicleID"  /></p>
    <table width="100%" class="ctc_tbl_row">
      <tr class="ctc_tbl_row">
        <td class="ctc_tbl_data">Year:
        <xsl:choose>
	<xsl:when test="count(VehicleModelYearDate)>0"><strong><xsl:value-of select="VehicleModelYearDate" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
        <td class="ctc_tbl_data">Make: 
        <xsl:choose>
	<xsl:when test="count(VehicleMakeCode)>0"><strong><xsl:value-of select="VehicleMakeCode" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
        <td class="ctc_tbl_data">VIN: 
        <xsl:choose>
	<xsl:when test="count(VehicleID)>0"><strong><xsl:value-of select="VehicleID" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
      </tr>
      <tr class="ctc_tbl_row">
         <td class="ctc_tbl_data">Style: 
        <xsl:choose>
	<xsl:when test="count(VehicleStyleCode)>0"><strong><xsl:value-of select="VehicleStyleCode" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
       <td class="ctc_tbl_data">Model: 
        <xsl:choose>
	<xsl:when test="count(VehicleModelCode)>0"><strong><xsl:value-of select="VehicleModelCode" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
        <td class="ctc_tbl_data">
        <xsl:choose>
	<xsl:when test="count(VehicleModelCodeText)>0"><strong><xsl:value-of select="VehicleModelCodeText" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
    </tr>
      <tr class="ctc_tbl_row">
         <td class="ctc_tbl_data">Plate: 
        <xsl:choose>
	<xsl:when test="count(VehicleLicensePlateID)>0"><strong><xsl:value-of select="VehicleLicensePlateID" /></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
	<xsl:if test="count(VehicleRegistration/RegistrationJurisdictionName)>0">&#160;&#160;<strong><xsl:value-of select="VehicleRegistration/RegistrationJurisdictionName" /></strong></xsl:if>
        </td>
         <td class="ctc_tbl_data">Effective: 
        <xsl:choose>
	<xsl:when test="count(VehicleRegistration/RegistrationEffectiveDate)>0"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleRegistration/RegistrationEffectiveDate"/></xsl:call-template></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
         <td class="ctc_tbl_data">Expiration: 
        <xsl:choose>
	<xsl:when test="count(VehicleRegistration/RegistrationExpirationDate)>0"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="VehicleRegistration/RegistrationExpirationDate"/></xsl:call-template></strong></xsl:when>
	<xsl:otherwise><xsl:value-of select="$txtNA"/></xsl:otherwise>
	</xsl:choose>
        </td>
     </tr>
     <xsl:if test="count(PropertyDescriptionText)>0">
      <tr class="ctc_tbl_row">
         <td class="ctc_tbl_data" colspan="3"	>Description: <strong><xsl:value-of select="PropertyDescriptionText" /></strong></td>	
      </tr>
      </xsl:if>
    </table>
    <!--p class="ctc_page_subtitle_1">Property Location information:</p>
      <xsl:value-of select="PropertyLocation" />
    <p class="ctc_page_subtitle_1">Property Owner Information:</p>
      <xsl:value-of select="PropertyOwner.Person" />
    <br/-->
    
    


  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Vehicle_Details" match="Vehicle" mode="details" >

	<!--xsl:variable name="curNode" select="name(current())"/-->

	<xsl:if test="count(//Person) > 0">
		<xsl:for-each select="./Person" >
			<xsl:call-template name="Person_Info">
				<xsl:with-param name="isEmbedded">true</xsl:with-param>
			</xsl:call-template>
			
		</xsl:for-each>
	   </xsl:if>

	<xsl:if test="count(//Incident) > 0">
		<p class="ctc_page_subtitle_1">Incident Summary</p>
		<table width="100%">
		  <tr class="ctc_tbl_headrow">
			<th class="ctc_tbl_center_hdr">Date</th>
			<th class="ctc_tbl_center_hdr">Type</th>
			<th class="ctc_tbl_center_hdr">Description</th>
			<th class="ctc_tbl_center_hdr">ID</th>
			<th class="ctc_tbl_center_hdr">Source</th>
		  </tr>
		   <xsl:for-each select="./Incident" >
			<tr class="ctc_tbl_row" valign="top"> 
			  <!-- display ActivityDate in MM/DD/YYYY format -->
			  <td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="ActivityDate"/></xsl:call-template></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID" /></td>
			  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
			</tr>
		  </xsl:for-each>
		</table>
	</xsl:if>

  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Vehicle" match="Vehicle" mode="data" >
      <xsl:value-of select="VehicleID" />&#160;
      <xsl:value-of select="VehicleMakeCode" />&#160;
      <xsl:value-of select="VehicleModelCode" />&#160;
      <xsl:value-of select="VehicleModelYearDate" />&#160;
      <xsl:value-of select="VehicleColorPrimaryCode" />
  </xsl:template>

<!-- *************************** -->
</xsl:stylesheet>