<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml">
	<!-- *************************** -->
	<!-- CHANGE HISTORY:
	12/07/09 MAH - Created
    12/14/09 MAH - Renamed header from "Locations" to "Location"
						  - Changed IDs to descriptions in header
						  - Changed "Involvement" to "Names"
						  - Removed owner from Location

  -->
	<!-- *************************** -->
	<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" />
	<!-- *************************** -->

	<xsl:template name="TicketReport_Single" match="TicketReport" mode="single">
	<!--xsl:template name="TicketReport_Single" match="TicketReport"-->

		<!-- Ticket Header -->
		<xsl:if test="count(Ticket)>0">
			<xsl:call-template name="secTicket"/>
		</xsl:if>
		
		<!-- Sections -->
		<xsl:if test="count(Section)>0">
			<xsl:apply-templates select="Section"/>
		</xsl:if>
		
	</xsl:template>

  <!-- *************************** -->
  	<xsl:template name="Section" match="Section">

			<!-- retrieve the ID value, ex: <Section ID="Person">  -->
			<xsl:variable name="secID" select="@ID"/>
			<xsl:choose>
				<xsl:when test="contains($secID,'TicketOffense')">
					<xsl:call-template name="secTicketOffense"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Location')">
					<xsl:call-template name="secLocation"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Person')">
					<xsl:call-template name="secPerson"/>
				</xsl:when>
				<xsl:when test="contains($secID,'Vehicle')">
					<xsl:call-template name="secVehicle"/>
				</xsl:when>
			</xsl:choose>

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secTicket" match="Ticket">
			<!--<p class="ctc_page_subtitle_1">Ticket Header</p>-->
			<xsl:choose>
				<xsl:when test="(string-length(@AgencyCode)>0)">
					<p class="ctc_page_subtitle_1">
					Ticket Header (Agency: 
					<xsl:value-of select="@AgencyCode"/>&#160;
					<xsl:value-of select="@AgencyORI"/>)
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="ctc_page_subtitle_1">Ticket Header</p>
				</xsl:otherwise>
			</xsl:choose>
				
			    <table width="100%" border="0" cellpadding="1" cellspacing="0">
				  <tr class="ctc_tbl_row">
					<td class="ctc_tbl_data" >Ticket #:</td>
					<td class="ctc_tbl_data" ><strong><xsl:value-of select="TicketNumber"/></strong></td>
					<td class="ctc_tbl_data" >Reporting Officer: </td>
					<td class="ctc_tbl_data" ><strong><!--xsl:value-of select="ReportingOfficerID"/--><xsl:value-of select="ReportingOfficer"/></strong></td>
					<td class="ctc_tbl_data" >Type:</td>
					<td class="ctc_tbl_data"><strong><!--xsl:value-of select="Type"/--><xsl:value-of select="TicketTypeDesc"/></strong></td>
				  </tr>
				  <tr class="ctc_tbl_row">
					<td class="ctc_tbl_data">Date/Time:</td>
					<td class="ctc_tbl_data"><strong><xsl:call-template name="standard_date"><xsl:with-param name="date" select="IssuedDate"/></xsl:call-template>&#160;&#160;<xsl:value-of select="IssuedTime"/></strong></td>
					<td class="ctc_tbl_data">Entered:</td>
					<td class="ctc_tbl_data"><strong><!--xsl:value-of select="EnteredByID"/--><xsl:value-of select="EnteredBy"/></strong></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
				  </tr>
				  <xsl:if test="(string-length(Comments)>0)">
				    <tr class="ctc_tbl_row">
					  <td class="ctc_tbl_data" valign="top">Comments:</td>
					  <td class="ctc_tbl_data" colspan="5"><strong><xsl:value-of select="Comments"/></strong></td>
				    </tr>
				  </xsl:if>
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
							</xsl:call-template>
					</td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
				  </tr>
				</table>

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secTicketOffense" match="TicketOffense">
			<p class="ctc_page_subtitle_1">Ticket Offenses</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
			  <tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Charge</td>
				<td class="ctc_tbl_center_hdr">Class</td>
				<td class="ctc_tbl_center_hdr">Description</td>
				<td class="ctc_tbl_center_hdr">Disposition</td>
				<td class="ctc_tbl_center_hdr">Fine</td>
				<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
			  </tr>
			  
  			<xsl:for-each select="TicketOffense"	>

			  <tr  class="ctc_tbl_row">
				<td class="ctc_tbl_data"><!--xsl:value-of select="ChargeType"/--><xsl:value-of select="TicketChargeTypeDesc"/></td>
				<td class="ctc_tbl_data"><xsl:value-of select="Class"/><!--xsl:value-of select="TicketClassDesc"/--></td>
				<td class="ctc_tbl_data"><xsl:value-of select="Description"/></td>
				<td class="ctc_tbl_data"><xsl:value-of select="Disposition"/></td>
				<td class="ctc_tbl_data"><xsl:value-of select="FineAmt"/></td>
				<td align="right" class="ctc_tbl_data"><div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
							</xsl:call-template>
				</div></td>
			  </tr>
			  
			</xsl:for-each>
			
			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			</xsl:if>	
			</table>	
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secLocation" match="Location">
			<p class="ctc_page_subtitle_1">Location</p>

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
			  <tr class="ctc_tbl_headrow">
				<td class="ctc_tbl_center_hdr">Location</td>
				<td class="ctc_tbl_center_hdr">Common Name</td>
				<!--td class="ctc_tbl_center_hdr">Owner</td-->
				<td class="ctc_tbl_center_hdr" align="right"><div align="right"></div></td>
			  </tr>
			  
			<xsl:for-each select="Location"	>
					<xsl:variable name="street" select="StreetName" />
					<xsl:variable name="number" select="StreetNumber" />
					
					<xsl:variable name="addrFull" select="concat($number,' ', $street)" />

				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data"><xsl:value-of select="$addrFull"/>&#160;<xsl:value-of select="Apartment"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="CommonName"/></td>

					<!--xsl:choose>
						<xsl:when test="count(Person)>0">
							<xsl:variable name="personLast" select="Person/LastName" />
							<xsl:variable name="personFirst" select="Person/FirstName" />
							<xsl:variable name="personMid" select="Person/MiddleName" />
							<xsl:variable name="personFull" select="concat($personLast,', ', $personFirst,' ',$personMid)" />
							<td class="ctc_tbl_data"><xsl:value-of select="$personFull"/></td>
						</xsl:when>
						<xsl:otherwise><td class="ctc_tbl_data"></td></xsl:otherwise>
					  </xsl:choose-->
					<td align="right" class="ctc_tbl_data"><div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
							</xsl:call-template>
					</div></td>
				  </tr>
			</xsl:for-each>
			
			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
				<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
			</table>
	
	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secPerson" match="Person">
			<p class="ctc_page_subtitle_1">Involvement</p>
			<!--p class="ctc_page_subtitle_1">Names</p-->

		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
				  <tr class="ctc_tbl_headrow">
					<td class="ctc_tbl_center_hdr">Name</td>
					<td class="ctc_tbl_center_hdr">Sex</td>
					<td class="ctc_tbl_center_hdr">Race</td>
					<td class="ctc_tbl_center_hdr">DOB</td>
					<td class="ctc_tbl_center_hdr">Address</td>
					<td class="ctc_tbl_center_hdr">Phone</td>
					<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
				  </tr>
			
			<xsl:for-each select="Person"	>
			
					<xsl:variable name="personLast" select="LastName" />
					<xsl:variable name="personFirst" select="FirstName" />
					<xsl:variable name="personMid" select="MiddleName" />
					
					<xsl:variable name="personFull" select="concat($personLast,', ', $personFirst,' ',$personMid)" />
			
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data"><xsl:value-of select="$personFull"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="Sex"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="Race"/></td>
					<td class="ctc_tbl_data"><xsl:call-template name="standard_date"><xsl:with-param name="date" select="DOB"/></xsl:call-template></td>
					
				
					  <xsl:choose>
						<xsl:when test="count(Location)>0 and count(Location/IsPrimary) > 0">
							<xsl:variable name="primaryAddress" select="Location[IsPrimary='Y']" />
							<td><xsl:value-of select="$primaryAddress/StreetNumber"/>&#160;<xsl:value-of select="$primaryAddress/StreetName"/>&#160;<xsl:value-of select="$primaryAddress/Apartment"/></td>
						</xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>
							
					  <xsl:choose>
						<xsl:when test="(count(ContactMethod)>0) and count(ContactMethod/IsPrimary) > 0 and (string-length(ContactMethod/MethodValue) > 0)">
							<xsl:variable name="primaryContact" select="ContactMethod[IsPrimary='Y']" />
							<td><xsl:value-of select="$primaryContact/MethodType"/>: <xsl:value-of select="$primaryContact/MethodValue"/></td>
						</xsl:when>
						<xsl:otherwise><td></td></xsl:otherwise>
					  </xsl:choose>
	
						<td align="right" class="ctc_tbl_data"><div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
							</xsl:call-template>
						</div></td>
					  </tr>
				  </xsl:for-each>

			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
			  </tr>
			 </xsl:if>	
			</table>

	</xsl:template>

  <!-- *************************** -->
	<xsl:template name="secVehicle" match="Vehicle">
		<p class="ctc_page_subtitle_1">Vehicles</p>
		
		<xsl:variable name="makeAddLink" select="count(LinkInfo)" />
		<xsl:variable name="dispAdd" select="LinkInfo/@Display"	/>
		<xsl:variable name="lnkAdd" select="LinkInfo"	/>

		<table width="100%" border="0" cellpadding="0" cellspacing="1">
		  <tr class="ctc_tbl_headrow">
			<td class="ctc_tbl_center_hdr">License Plate</td>
			<td class="ctc_tbl_center_hdr">State</td>
			<td class="ctc_tbl_center_hdr">VIN</td>
			<td class="ctc_tbl_center_hdr">Year</td>
			<td class="ctc_tbl_center_hdr">Make</td>
			<td class="ctc_tbl_center_hdr">Model</td>
			<td class="ctc_tbl_center_hdr">Style</td>
			<td class="ctc_tbl_center_hdr">Color</td>
			<td align="right" class="ctc_tbl_center_hdr"><div align="right"></div></td>
		  </tr>
		  
		  <xsl:for-each select="Vehicle">
		  
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data"><xsl:value-of select="PlateTag"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="StateCode"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="VIN"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="VehicleYear"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="Make"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="Model"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="BodyStyle"/></td>
					<td class="ctc_tbl_data"><xsl:value-of select="Color1"/></td>
					<td align="right" class="ctc_tbl_data"><div align="right">
							<xsl:call-template name="maintLinks">
								<xsl:with-param name="elementPath" select="name(current())"/>
							</xsl:call-template>
					</div></td>
				  </tr>
		  
		  </xsl:for-each>

			<xsl:if test="$makeAddLink">
				  <tr  class="ctc_tbl_row">
					<td class="ctc_tbl_data">
						<xsl:call-template name="TIMSLink">
							<xsl:with-param name="dest" select="$lnkAdd"/>
							<xsl:with-param name="desc" select="$dispAdd"/>
						</xsl:call-template>
					</td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
					<td class="ctc_tbl_data"></td>
				  </tr>
			</xsl:if>
		</table>
		
	</xsl:template>

  <!-- *************************** -->
  <xsl:template name="TIMSLink">
    <xsl:param name="dest" />
    <xsl:param name="desc" />
      <xsl:if test="string-length($dest) > 0">
        <xsl:if test="string-length($desc) > 0">
          <span><a  class="ctc_link" href="{$dest}"><xsl:value-of select="$desc" /></a></span>
        </xsl:if>
      </xsl:if>
  </xsl:template>

 <!-- *************************** -->  
  <xsl:template name="maintLinks">
	<xsl:param name="elementPath"/>	
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='View'])>0">
			<xsl:call-template name="TIMSLink">
				<xsl:with-param name="dest" select="LinkInfo[@Display='View']"/>
				<xsl:with-param name="desc">View</xsl:with-param>
			</xsl:call-template>
			&#160;&#160;&#160;&#160;
		</xsl:when>
	</xsl:choose>	
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='Edit'])>0">
			<xsl:call-template name="TIMSLink">
				<xsl:with-param name="dest" select="LinkInfo[@Display='Edit']"/>
				<xsl:with-param name="desc">Edit</xsl:with-param>
			</xsl:call-template>
			&#160;&#160;&#160;&#160;
		</xsl:when>
	</xsl:choose>	
	<xsl:choose>
		<xsl:when test="count(LinkInfo[@Display='Delete'])>0">
			<xsl:call-template name="TIMSLink">
				<xsl:with-param name="dest" select="LinkInfo[@Display='Delete']"/>
				<xsl:with-param name="desc">Delete</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
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
