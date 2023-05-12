<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   04/26/06 MAH - Created
	   04/27/06 MAH - Modified to handle both messages and record responses
	   02/05/09 MAH - Fixed duplicate records from appearing when vehicle records containing person records are present.
  -->
  <!-- *************************** -->

<xsl:import href="message.xsl" />
<xsl:import href="record.xsl" />

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <xsl:template name="DriverVehicle_Single" match="DriverVehicle" mode="single" >
	<xsl:call-template name="fldr_querytitle"/>

	<xsl:if test="count(//Message)>0">
		<p class="ctc_page_subtitle_1">SOS</p>
		<xsl:apply-templates select="Message" mode="single"/>
	</xsl:if>
	<xsl:if test="count(//Record/Person)>0">
		<hr/>
		<p class="ctc_page_subtitle_1">MIDRS</p>
		<!--xsl:apply-templates select="Record" mode="case"/-->
		<xsl:for-each select="./Record/Person">
			<xsl:call-template name="Person_Case"/>
		</xsl:for-each>

	</xsl:if>
 	<xsl:if test="count(//Vehicle)>0">
		<hr/>
		<p class="ctc_page_subtitle_1">VEHICLES</p>
		<!--xsl:apply-templates select="Vehicle" mode="single"/-->
		<xsl:for-each select="./Vehicle">
			<xsl:call-template name="Vehicle_Case"/>
		</xsl:for-each>
	</xsl:if>
   <xsl:call-template name="fldr_footer"/>
  </xsl:template>
  
</xsl:stylesheet>
