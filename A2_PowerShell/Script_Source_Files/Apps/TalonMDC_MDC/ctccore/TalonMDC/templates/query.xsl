<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Removed table and data template
	   03/31/10 MAH - Added support for queries in XML format
	   08/19/16 CLV - Added Secure Document Query parsing
	   06/01/18 CLV - TIPS Admin Message parsing
	   
  -->
  <!-- *************************** -->

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="Query_Single" match="Query" mode="single" >
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr><td class="ctc_q_title" ><xsl:value-of select="@DateCreated" />&#160;|&#160;<xsl:value-of select="@TimeCreated" />&#160;|&#160;<xsl:value-of select="Title" /></td></tr>
    </table>  
    <xsl:choose>
		<!-- ******** Test for SecureDocument Entry *********** -->
    		<xsl:when test="string-length(QueryXML/EmbeddedQuery/Document)>0">
			<pre class="ctc_tbl_data">FileName:<xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentFileName"/></pre>
			<pre class="ctc_tbl_data">Title:<xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentTitleText" /></pre>
			<pre class="ctc_tbl_data">Created By:<xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentCreator" /></pre>
			<pre class="ctc_tbl_data">Requested By:<xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentRequestor" /></pre>
			<pre class="ctc_tbl_data">Incident Number:<xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentIncidentYear" /><xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentIncidentNumber" /></pre>
			<pre class="ctc_tbl_data">Agency:<xsl:value-of select="QueryXML/EmbeddedQuery/Document/DocumentGroupID" /></pre>
		</xsl:when>
		<!-- ******** Test for SecureDocument Query *********** -->
		<xsl:when test="string(QueryXML/EmbeddedQuery/@Type)='SecureDocuments'">
			<pre class="ctc_tbl_data">ORI: <xsl:value-of select="QueryXML/EmbeddedQuery/@ORI"/></pre>
			<pre class="ctc_tbl_data">Operator: <xsl:value-of select="QueryXML/EmbeddedQuery/@OPERATOR"/></pre>
			<pre class="ctc_tbl_data">Date Range: <xsl:value-of select="QueryXML/EmbeddedQuery/@FromDate"/> - <xsl:value-of select="QueryXML/EmbeddedQuery/@ToDate"/></pre>
			<pre class="ctc_tbl_data">FileName: <xsl:value-of select="QueryXML/EmbeddedQuery/@FileName"/></pre>
			<pre class="ctc_tbl_data">Title: <xsl:value-of select="QueryXML/EmbeddedQuery/@Title"/></pre>
			<pre class="ctc_tbl_data">Created By: <xsl:value-of select="QueryXML/EmbeddedQuery/@CreatedBy"/></pre>
			<pre class="ctc_tbl_data">Requested By: <xsl:value-of select="QueryXML/EmbeddedQuery/@RequestedBy"/></pre>
			<pre class="ctc_tbl_data">Incident Number: <xsl:value-of select="QueryXML/EmbeddedQuery/@IncidentNumber"/></pre>
			<pre class="ctc_tbl_data">Document ID Number: <xsl:value-of select="QueryXML/EmbeddedQuery/@DocumentIDNumber"/></pre>
		</xsl:when>
		<!-- ******** Test for Investigative Query *********** -->
		<xsl:when test="string(QueryXML/EmbeddedQuery/@Type)='Investigation'">
			<pre class="ctc_tbl_data"><xsl:value-of select="Title" /></pre>
			<pre class="ctc_tbl_data">ORI: <xsl:value-of select="QueryXML/EmbeddedQuery/@ORI"/></pre>
			<pre class="ctc_tbl_data">Operator: <xsl:value-of select="QueryXML/EmbeddedQuery/@Operator"/></pre>
			<pre class="ctc_tbl_data">Date Range: <xsl:value-of select="QueryXML/EmbeddedQuery/@FromDate"/> - <xsl:value-of select="QueryXML/EmbeddedQuery/@ToDate"/></pre>
			<pre class="ctc_tbl_data">Times: <xsl:value-of select="QueryXML/EmbeddedQuery/@FromHour"/> - <xsl:value-of select="QueryXML/EmbeddedQuery/@ToHour"/></pre>
			<pre class="ctc_tbl_data">Crime Codes: <xsl:value-of select="QueryXML/EmbeddedQuery/@CrimeCodes"/></pre>
			<pre class="ctc_tbl_data">Incident Status: <xsl:value-of select="QueryXML/EmbeddedQuery/@IncidentStatus"/></pre>
			<pre class="ctc_tbl_data">Location Type: <xsl:value-of select="QueryXML/EmbeddedQuery/@LocationType"/></pre>
			<pre class="ctc_tbl_data">Requested By: <xsl:value-of select="QueryXML/EmbeddedQuery/@Requester"/> / <xsl:value-of select="QueryXML/EmbeddedQuery/@Agency"/></pre>
			<pre class="ctc_tbl_data">Proximity: <xsl:value-of select="QueryXML/EmbeddedQuery/@Proximity"/></pre>
			<pre class="ctc_tbl_data">Days Of Week: <xsl:value-of select="QueryXML/EmbeddedQuery/@DaysOfWeek"/></pre>
			<pre class="ctc_tbl_data">Suspects Only: <xsl:value-of select="QueryXML/EmbeddedQuery/@SuspectsOnly"/></pre>
			<!--pre class="ctc_tbl_data">Incident Number<xsl:value-of select="QueryXML/EmbeddedQuery/ActivityID/ID"/></pre-->
			<xsl:if test="string-length(QueryXML/EmbeddedQuery/LocationAddress/LocationStreet/StreetName)>0 or string-length(QueryXML/EmbeddedQuery/LocationAddress/LocationStreet/StreetName)>0">
				<pre class="ctc_tbl_data">Location: 
				Number: <xsl:value-of select="QueryXML/EmbeddedQuery/LocationAddress/LocationStreet/StreetNumberText"/>
				Street: <xsl:value-of select="QueryXML/EmbeddedQuery/LocationAddress/LocationStreet/StreetName" />
				City: <xsl:value-of select="QueryXML/EmbeddedQuery/LocationAddress/LocationCityName"/>
				State: <xsl:value-of select="QueryXML/EmbeddedQuery/LocationAddress/LocationStateCode.fips5-2Alpha" /> 
				Zip Code: <xsl:value-of select="QueryXML/EmbeddedQuery/LocationAddress/LocationPostalCodeID/ID" />
				</pre>
			</xsl:if>
		</xsl:when>
		<!-- ******** Test for TIPS Style Admin Message *********** -->
		<xsl:when test="string-length(QueryXML/CJISMessage)>0">
			<pre class="ctc_tbl_data"><xsl:value-of select="Title" /></pre>
			<pre class="ctc_tbl_data">ORI:<xsl:value-of select="QueryXML/CJISMessage/OFML/HDR/ORI"/></pre>
			<pre class="ctc_tbl_data">OPERATOR:<xsl:value-of select="QueryXML/CJISMessage/UserID"/></pre>
			<xsl:for-each select="QueryXML/CJISMessage/OFML/HDR/DST">
				<pre class="ctc_tbl_data">Destination:<xsl:value-of select="." /></pre>
			</xsl:for-each>	
			<xsl:if test="string-length(QueryXML/CJISMessage/OFML/HDR/CTL)>0">
				<pre class="ctc_tbl_data">Control #:<xsl:value-of select="QueryXML/CJISMessage/OFML/HDR/CTL" /></pre>
			</xsl:if>
			<xsl:variable name="Text1" select="substring-before(QueryXML/CJISMessage/OFML/TRN/TXT, 'TXT:')"/>
			<xsl:variable name="Text2" select="substring-after(QueryXML/CJISMessage/OFML/TRN/TXT, 'TXT:')"/>
			
			<pre class="ctc_tbl_data"><xsl:value-of select="$Text1"/></pre>
			TXT:
			<!--
			<xsl:variable name="trimText">
				<xsl:call-template name="trim">
					<xsl:with-param name="input"><xsl:value-of select="$Text2"/></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="splitText">
				<xsl:call-template name="TextSplit">
					<xsl:with-param name="InputString"><xsl:value-of select="$trimText"/></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			-->
			<pre class="ctc_tbl_data_fixedfont"><xsl:value-of select="$Text2"/></pre> 
			
			<xsl:if test="string-length(QueryXML/CJISMessage/OFML/TRN/IMG)>0">
				<!--Images dont currently seem to work in the JEDITORPANE but do in other browsers-->
				<!--img src="data:image/jpg;base64,{QueryXML/CJISMessage/OFML/TRN/IMG}" alt=""/-->
			IMAGE SENT
			</xsl:if>
		</xsl:when>
		<xsl:when test="string-length(QueryXML)>0">
			<pre class="ctc_tbl_data"><xsl:value-of select="Title" /></pre>
			<p class="ctc_msg_data"><xsl:value-of select="QueryXML"/></p>
		</xsl:when>
		<xsl:otherwise>
			<pre class="ctc_msg_data"><xsl:value-of select="QueryString" /></pre>
			<!--pre class="ctc_tbl_data"><xsl:value-of select="Title" /></pre-->
	                 </xsl:otherwise>	
	</xsl:choose>	

    <!--xsl:apply-templates select="QueryMap" mode="table"/-->
  </xsl:template>



</xsl:stylesheet>
