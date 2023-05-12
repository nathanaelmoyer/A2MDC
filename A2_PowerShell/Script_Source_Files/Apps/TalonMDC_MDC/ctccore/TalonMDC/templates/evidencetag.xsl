<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml">
	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	02/22/10 MAH - Created

  -->
	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" />
	<!-- *************************** -->

	<xsl:template name="Property" match="Property">
				
				<table>
				  <tr>
					<!--td class="ctc_tag_data" colspan="2"-->
					<td class="ctc_tag_data">
					<xsl:call-template name="incImage" >
					     <xsl:with-param name="source" select="concat('file:///', FilePathBarcodeJPG)" />
					</xsl:call-template>
					</td>
					<!--td class="ctc_tag_data" ><strong><xsl:value-of select="IncidentNumber"/> - <xsl:value-of select="ItemNumber"/></strong></td-->
					<td>
					  <table>
						<tr>
					      <td class="ctc_tag_data" ><strong><xsl:call-template name="format_incidentnumber"><xsl:with-param name="incnum" select="IncidentNumber"/></xsl:call-template> - <xsl:value-of select="ItemNumber"/></strong></td>
						</tr>
						<xsl:if test="count(TrackingNumber)>0">
							  <tr >
								<td class="ctc_tag_data">Tracking No:<strong>&#160;<xsl:value-of select="TrackingNumber"/></strong></td>
							  </tr>
						</xsl:if>
					  </table>
					</td>
				  </tr>
				<!--xsl:if test="count(TrackingNumber)>0">
					  <tr >
						<td class="ctc_tag_data">Tracking No: <strong><xsl:value-of select="TrackingNumber"/></strong></td>
					  </tr>
				</xsl:if-->
				<xsl:if test="(count(EvidenceDate)>0) or (count(Officer)>0)">
					  <tr>
						<xsl:if test="count(EvidenceDate)>0">
							<td class="ctc_tag_data" >Submitted:<strong>&#160;&#160;<xsl:call-template name="standard_date"><xsl:with-param name="date" select="EvidenceDate"/></xsl:call-template></strong></td>
						</xsl:if>
						<xsl:if test="count(Officer)>0">
							<td class="ctc_tag_data">Officer:<strong>&#160;<xsl:value-of select="Officer"/></strong></td>
						</xsl:if>
					  </tr>
				</xsl:if>
				<xsl:if test="(count(Offense)>0) or (count(PropertyCategoryDesc)>0)">
					  <tr>
						<xsl:if test="count(PropertyCategoryDesc)>0">
							<td class="ctc_tag_data">Category:<strong>&#160;<xsl:value-of select="PropertyCategoryDesc"/></strong></td>
						</xsl:if>
						<xsl:if test="count(Offense)>0">
							<td class="ctc_tag_data">Offense:<strong>&#160;&#160;<xsl:value-of select="Offense"/></strong></td>
						</xsl:if>
					</tr>	
				</xsl:if>
				<xsl:if test="(count(Description)>0) or (count(PropertyExtra)>0)">
					  <tr>
						<td class="ctc_tag_data" colspan="2">Description:<strong>&#160;<xsl:value-of select="Description"/></strong></td>
					  </tr>				
				</xsl:if>
				<xsl:if test="count(PropertyExtra)>0">
					<tr>
						<td class="ctc_tag_data" colspan="2"><strong><xsl:value-of select="PropertyExtra"/></strong></td>
					</tr>
				</xsl:if>
				<xsl:if test="(count(Make)>0) or (count(Model)>0)">
					  <tr>
						<xsl:if test="count(Make)>0">
							<td class="ctc_tag_data">Make:<strong>&#160;<xsl:value-of select="Make"/></strong></td>
						</xsl:if>
						<xsl:if test="count(Model)>0">
							<td class="ctc_tag_data">Model:<strong>&#160;<xsl:value-of select="Model"/></strong></td>
						</xsl:if>
					</tr>	
				</xsl:if>
				<xsl:if test="(count(SerialNumber)>0) or (count(VehicleCount)>0)">
					  <tr>
						<xsl:if test="count(SerialNumber)>0">
							<td class="ctc_tag_data">Serial No:<strong>&#160;<xsl:value-of select="SerialNumber"/></strong></td>
						</xsl:if>
						<xsl:if test="count(VehicleCount)>0">
							<td class="ctc_tag_data">Vehicle Cnt:<strong>&#160;<xsl:value-of select="VehicleCount"/></strong></td>
						</xsl:if>
					</tr>	
				</xsl:if>
				<xsl:if test="count(PropertyNotes)>0">
					<tr>
						<td class="ctc_tag_data" colspan="2">Notes:<strong>&#160;<xsl:value-of select="PropertyNotes"/></strong></td>
					</tr>
				</xsl:if>				
				<xsl:if test="count(PropertyOwner)>0">
					<tr>
						<td class="ctc_tag_data">Owner:<strong>&#160;<xsl:value-of select="PropertyOwner"/></strong></td>
					</tr>
				</xsl:if>	
				<xsl:if test="count(PropertyObtainedFrom)>0">
					<tr>
						<td class="ctc_tag_data">Obtained from:<strong>&#160;&#160;<xsl:value-of select="PropertyObtainedFrom"/></strong></td>
					</tr>
				</xsl:if>		
				<xsl:if test="count(Suspect)>0">
					<tr>
						<td class="ctc_tag_data">Offender(s):<strong>&#160;&#160;<xsl:value-of select="Suspect"/></strong></td>
					</tr>
				</xsl:if>					

				<xsl:if test="(count(EvidenceRoomDesc)>0) or (count(EvidenceLocationDesc)>0)">
					  <tr>
						<xsl:if test="count(EvidenceRoomDesc)>0">
							<td class="ctc_tag_data">Room:<strong>&#160;<xsl:value-of select="EvidenceRoomDesc"/></strong></td>
						</xsl:if>
						<xsl:if test="count(EvidenceLocationDesc)>0">
							<td class="ctc_tag_data">Location:<strong>&#160;<xsl:value-of select="EvidenceLocationDesc"/></strong></td>
						</xsl:if>
					</tr>	
				</xsl:if>
				<xsl:if test="count(SiteLabel)>0">
					  <!--tr>
						<td class="ctc_tag_data">&#160;</td>
					  </tr-->
					  <tr align="center">
						<td class="ctc_tag_data" colspan="2" ><xsl:value-of select="SiteLabel"/></td>
					  </tr>
				</xsl:if>

				</table>

	</xsl:template>

<xsl:template name="incImage">
    <xsl:param name="source" />
    <xsl:if test="string-length($source) > 0">
      <span class="ctc_img"><img src="{$source}" /></span>
    </xsl:if>
  </xsl:template>
  
  <!-- *************************** -->
  <xsl:template name="format_incidentnumber">
  <!-- Formats yynnnnnn as yy-nnnnnn
	   
  -->
		<xsl:param name="incnum"/>

		<xsl:choose>
			<xsl:when test="string-length($incnum) = 8">
				<xsl:variable name="year" select="substring($incnum, 1, 2)"/>
				<xsl:variable name="num" select="substring($incnum, 3,6)"/>
				<xsl:value-of select="$year"/>-<xsl:value-of select="$num"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$incnum"/>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>  
  <!-- *************************** -->
  <xsl:template name="standard_date">
  <!-- Formats YYYY-MM-DD to MM/DD/YYYY.
	   Keeps any other date format in its original format
  -->
		<xsl:param name="date"/>

		<xsl:choose>
			<xsl:when test="substring($date,5,1)='-'">
				<xsl:variable name="day" select="substring($date, 9, 2)"/>
				<xsl:variable name="month" select="substring($date, 6, 2)"/>
				<xsl:variable name="year" select="substring($date, 1, 4)"/>
				<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
		
  </xsl:template>

  <!-- *************************** -->
</xsl:stylesheet>
