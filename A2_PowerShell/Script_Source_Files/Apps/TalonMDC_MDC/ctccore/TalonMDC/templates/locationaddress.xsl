<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="addressfulltext.xsl" />

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="LocationAddress_Table" match="LocationAddress" mode="table" >
    <!--
        Define the number of columns to use for the residence.
          1 - default if none given or selected number layout doesn't exist.
          3 - Address, Links
          5 - Street/Bldg, City, State, Zip, Links
    -->
    <xsl:variable name="numCols" select="5" />

    <xsl:choose>
	<xsl:when test="count(//LocationAddress/AddressFullText) > 0"> 
        <xsl:for-each select="//LocationAddress">
          <xsl:apply-templates select="." mode="singlenoparse" />
        </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
    	  <p class="ctc_page_subtitle_1">Address Summary</p>
	    <table  width="100%">
	      <tr class="ctc_tbl_headrow">
	        <th class="ctc_tbl_center_hdr">Street</th>
	        <th class="ctc_tbl_center_hdr">City</th>
	        <th class="ctc_tbl_center_hdr">State</th>
	        <th class="ctc_tbl_center_hdr">Zip</th>
      	</tr>
	      <xsl:for-each select="//LocationAddress">
	        <xsl:apply-templates select="." mode="singlemaprow" >
	          <xsl:with-param name="cols" select="$numCols" />
	        </xsl:apply-templates>
	      </xsl:for-each>
	    </table>
	</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="LocationAddress_SingleNoParse" match="LocationAddress" mode="singlenoparse" >
    	<p class="ctc_page_subtitle_1">Address</p>
      <xsl:apply-templates select="AddressFullText" mode="single" />
	<br/>
  </xsl:template>

  <xsl:template name="LocationAddress_Single" match="LocationAddress" mode="single" >
    <font class="ctc_single_title">Address: </font>
    <xsl:choose>
		<xsl:when test="count(AddressFullText) > 0">
			<xsl:apply-templates select="AddressFullText" mode="data" />
			</xsl:when>
		<xsl:otherwise>
		  <xsl:if test="string-length(LocationStreet) > 0" >
			  <xsl:value-of select="LocationStreet" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationBuilding) > 0" >
			  <xsl:value-of select="LocationBuilding" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationCityName) > 0" >
			  <xsl:value-of select="LocationCityName" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationStateCode.fips5-2Alpha) > 0" >
			  <xsl:value-of select="LocationStateCode.fips5-2Alpha" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationStateCode.USPostalService) > 0" >
			  <xsl:value-of select="LocationStateCode.USPostalService" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationPostalCodeID) > 0" >
			  <xsl:value-of select="LocationPostalCodeID/ID" />&#160;
		  </xsl:if>
		  <!--xsl:if test="LocationStreet and LocationCityName and LocationStateCode.fips5-2Alpha and LocationStateCode.USPostalService">
			<td class="ctc_tbl_data">
			  <xsl:call-template name="Link" >
				<xsl:with-param name="dest" select="string(@id)" />
				<xsl:with-param name="desc" select="string('Map')" />
				<xsl:with-param name="type" select="string('map')" />
			  </xsl:call-template>
			  &#160;&#160;
			  <xsl:call-template name="Link" >
				<xsl:with-param name="dest" select="string(concat('r',@id))" />
				<xsl:with-param name="desc" select="string('Directions')" />
				<xsl:with-param name="type" select="string('map')" />
			  </xsl:call-template>
			</td>
		  </xsl:if-->
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template name="LocationAddress_DataMap" match="LocationAddress" mode="datamap" >
      <xsl:if test="count(AddressFullText) > 0"> 
        <xsl:apply-templates select="AddressFullText" mode="data" />
	  </xsl:if>
      <xsl:value-of select="LocationStreet" />&#160;
      <xsl:value-of select="LocationBuilding" />&#160;
      <xsl:value-of select="LocationCityName" />&#160;
      <xsl:value-of select="LocationStateCode.fips5-2Alpha" />&#160;
      <xsl:value-of select="LocationStateCode.USPostalService" />&#160;&#160;
      <!--xsl:if test="LocationStreet and LocationCityName and LocationStateCode.fips5-2Alpha and LocationStateCode.USPostalService">
		  <xsl:call-template name="Link" >
			<xsl:with-param name="dest" select="string(@id)" />
			<xsl:with-param name="desc" select="string('Map')" />
			<xsl:with-param name="type" select="string('map')" />
		  </xsl:call-template>
		  &#160;&#160;
		  <xsl:call-template name="Link" >
			<xsl:with-param name="dest" select="string(concat('r',@id))" />
			<xsl:with-param name="desc" select="string('Directions')" />
			<xsl:with-param name="type" select="string('map')" />
		  </xsl:call-template>
      </xsl:if-->
  </xsl:template>

  <xsl:template name="LocationAddress" match="LocationAddress" mode="data" >
    <xsl:if test="count(AddressFullText) > 0"> 
      <xsl:apply-templates select="AddressFullText" mode="data" />
    </xsl:if>
    <xsl:value-of select="LocationStreet" />&#160;
    <xsl:value-of select="LocationBuilding" />&#160;
    <xsl:value-of select="LocationCityName" />&#160;
    <xsl:value-of select="LocationStateCode.fips5-2Alpha" />&#160;
    <xsl:value-of select="LocationStateCode.USPostalService" />
  </xsl:template>

  <xsl:template name="LocationAddress_SingleMapRow" match="LocationAddress" mode="singlemaprow" >
    <xsl:param name="cols" />
    <!--tr bgcolor="DFDFDF"-->
    <tr class="ctc_tbl_row">
      <xsl:choose>
        <xsl:when test="$cols = 2">
          <td class="ctc_tbl_data">
    		<xsl:if test="count(AddressFullText) > 0"> 
              <xsl:apply-templates select="AddressFullText" mode="data" /><br/>
			</xsl:if>
		  <xsl:if test="string-length(LocationStreet) > 0" >
			  <xsl:value-of select="LocationStreet" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationBuilding) > 0" >
			  <xsl:value-of select="LocationBuilding" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationCityName) > 0" >
			  <xsl:value-of select="LocationCityName" />&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationStateCode.fips5-2Alpha) > 0" >
			  <xsl:value-of select="LocationStateCode.fips5-2Alpha" />&#160;&#160;
		  </xsl:if>
		  <xsl:if test="string-length(LocationStateCode.USPostalService) > 0" >
			  <xsl:value-of select="LocationStateCode.USPostalService" />&#160;
		  </xsl:if>
          </td>
          <!--td class="ctc_tbl_data">
            <xsl:call-template name="Link" >
              <xsl:with-param name="dest" select="string(@id)" />
              <xsl:with-param name="desc" select="string('Map')" />
              <xsl:with-param name="type" select="string('map')" />
            </xsl:call-template>
            &#160;&#160;
            <xsl:call-template name="Link" >
              <xsl:with-param name="dest" select="string(concat('r',@id))" />
              <xsl:with-param name="desc" select="string('Directions')" />
              <xsl:with-param name="type" select="string('map')" />
            </xsl:call-template>
          </td-->
        </xsl:when>
        <xsl:when test="$cols = 5">
          <td class="ctc_tbl_data">
    		<xsl:if test="count(AddressFullText) > 0"> 
              <xsl:apply-templates select="AddressFullText" mode="data" /><br/>
		</xsl:if>
            <xsl:value-of select="LocationStreet" />&#160;
            <xsl:value-of select="LocationBuilding" />
          </td>
          <td class="ctc_tbl_data"><xsl:value-of select="LocationCityName" /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="LocationStateCode.fips5-2Alpha" /></td>
          <td class="ctc_tbl_data"><xsl:value-of select="LocationStateCode.USPostalService" /></td>
          <!--td class="ctc_tbl_data">
            <xsl:call-template name="Link" >
              <xsl:with-param name="dest" select="string(@id)" />
              <xsl:with-param name="desc" select="string('Map')" />
              <xsl:with-param name="type" select="string('map')" />
            </xsl:call-template>
            &#160;&#160;
            <xsl:call-template name="Link" >
              <xsl:with-param name="dest" select="string(concat('r',@id))" />
              <xsl:with-param name="desc" select="string('Directions')" />
              <xsl:with-param name="type" select="string('map')" />
            </xsl:call-template>
          </td-->
        </xsl:when>
        <xsl:otherwise>
          <td class="ctc_tbl_data">
    		<xsl:if test="count(AddressFullText) > 0"> 
              <xsl:apply-templates select="AddressFullText" mode="data" /><br/>
			</xsl:if>
            <xsl:value-of select="LocationStreet" />&#160;
            <xsl:value-of select="LocationBuilding" />&#160;
            <xsl:value-of select="LocationCityName" />,&#160;
            <xsl:value-of select="LocationStateCode.fips5-2Alpha" />&#160;&#160;
            <xsl:value-of select="LocationStateCode.USPostalService" />&#160;&#160;
            <!--xsl:call-template name="Link" >
              <xsl:with-param name="dest" select="string(@id)" />
              <xsl:with-param name="desc" select="string('Map')" />
              <xsl:with-param name="type" select="string('map')" />
            </xsl:call-template>
            &#160;&#160;
            <xsl:call-template name="Link" >
              <xsl:with-param name="dest" select="string(concat('r',@id))" />
              <xsl:with-param name="desc" select="string('Directions')" />
              <xsl:with-param name="type" select="string('map')" />
            </xsl:call-template-->
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>

</xsl:stylesheet>
