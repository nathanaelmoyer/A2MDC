<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <xsl:template name="testsort"  >
	
	<p class="ctc_page_subtitle_1">Incident Summary</p>
    <!--table border="1" width="100%"-->
	   <xsl:for-each select="//Incident" >

	   <!--xsl:sort data-type="number" select="number(concat(substring(ActivityDate,1,2),substring(ActivityDate,4,2),substring(ActivityDate,7,4)))" order="descending"/-->

	   <xsl:choose>
		<xsl:when test="substring(ActivityDate,5,1)='-'">
			<xsl:call-template name="testdateformat">
			   <xsl:with-param name="day" select="substring(ActivityDate, 9, 2)"/>
			   <xsl:with-param name="month" select="substring(ActivityDate, 6, 2)"/>
			   <xsl:with-param name="year" select="substring(ActivityDate, 1, 4)"/>
		   </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="testdateformat">
			   <xsl:with-param name="day" select="substring(ActivityDate, 4, 2)"/>
			   <xsl:with-param name="month" select="substring(ActivityDate, 1, 2)"/>
			   <xsl:with-param name="year" select="substring(ActivityDate, 7, 4)"/>
			</xsl:call-template>
		
		</xsl:otherwise>
		</xsl:choose>


		
		<!--tr>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDate" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityTypeText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityDescriptionText" /></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/ID"/></td>
		  <td class="ctc_tbl_data"><xsl:value-of select="ActivityID/IDSourceText" /></td>
		</tr-->
	  </xsl:for-each>
    <!--/table-->
  </xsl:template>
  
  <xsl:template name="testdateformat">
	  <xsl:param name="day"/>
	  <xsl:param name="month"/>
	  <xsl:param name="year"/>

	   <xsl:variable name="test" select="concat($month,$day,$year)"/>
	   DEBUG: test <xsl:value-of select="$test"/><br/>
  
  </xsl:template>




</xsl:stylesheet>
