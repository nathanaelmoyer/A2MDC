<?xml version="1.0"?>
<!-- THIS TEMPLATE IS INCLUDED IN ALL XSL DOCUMENTS VIA THE PROGRAM CODE -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>
 
  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   06/01/05 MAH - Moved FileListCall into ctc_templates
	   06/20/05 MAH - Added LinkInfo
	   07/22/05 MAH - Added space after link
	   04/03/06 MAH - Added inline links to FileListCall
	   05/18/06 MAH - Added linkinfo check to FileListCall
	   09/25/06 MAH - Added check for MiscFile to FileListCall & FileList_Table
       09/27/06 MAH - Fixed inline photos being displayed multiple times
	   10/20/06 MAH - Added check for DefaultDownloadBehavior attribute for links
	   12/30/08 MAH - Changed image title/source table to bold data instead of labels
  -->
  <!-- *************************** -->
	 
  <!-- *************************** -->
  <xsl:template name="SmartTemplate" match="/*" mode="smart" >
     <xsl:choose>
      <xsl:when test="count(.) > 1" >
        <xsl:apply-templates select="." mode="table" />
      </xsl:when>
      <xsl:when test="count(.) = 1" >
        <xsl:apply-templates select="." mode="single" />
      </xsl:when>
      <xsl:otherwise >
        <xsl:apply-templates select="." mode="data" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- *************************** -->
  <xsl:template name="ftr_template" >
    <!-- Put footer information here -->
  </xsl:template>


  <!-- *************************** -->
  <xsl:template name="hdr_template" >
    <!-- Put header information here --> 
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="version">
	Vendor: <xsl:value-of select="system-property('xsl:vendor')"/><br/>
	Vendor URL: <xsl:value-of select="system-property('xsl:vendor-url')"/><br/>
	XSLT Version: <xsl:value-of select="system-property('xsl:version')"/><br/>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="blankCell" >
    <xsl:param name="count" />
    <xsl:if test="$count != 0" >
      <td class="ctc_tbl_data"><xsl:text> </xsl:text></td>
      <xsl:call-template name="blankCell" >
        <xsl:with-param name="count" select="$count -1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- *************************** -->
  <xsl:template name="Image">
    <xsl:param name="source" />
    <xsl:if test="string-length($source) > 0">
      <span class="ctc_img"><img src="{$source}" /></span>
    </xsl:if>
  </xsl:template>


  <!-- *************************** -->
  <xsl:template name="Link">
    <xsl:param name="dest" />
    <xsl:param name="desc" />
    <xsl:param name="type" />
    <xsl:if test="$type != 'map'" >
      <xsl:if test="string-length($dest) > 0">
        <xsl:if test="string-length($desc) > 0">
          <span><a  class="ctc_link" href="{$dest}"><xsl:value-of select="$desc" /></a></span>&#160;
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <!-- *************************** -->
	<xsl:template name="LinkInfo" match="LinkInfo">
		<xsl:variable name="vLink" select="."/>
		<!--xsl:choose>
			<xsl:when test="contains(@Display,'Save Image')"></xsl:when>
			<xsl:otherwise-->
				<xsl:call-template name="Link" >
					<xsl:with-param name="desc" select="@Display" />
					<xsl:with-param name="dest" select="$vLink" />
					<xsl:with-param name="type" select="string('display')" />
			   </xsl:call-template>
			<!--/xsl:otherwise>
		</xsl:choose-->
	</xsl:template>


  <!-- *************************** -->
    <xsl:template name="FileListCall" match="FileListCall" mode="call" >
	<xsl:param name="msgMode"/>
	
	<!-- IMAGES -->
	<!-- Check if at least 1 Photo element exists in the FileList element -->
<!--	
In ctc_templates.xsl msgMode:<xsl:value-of select="$msgMode"/>			
-->
	<xsl:choose>
		<xsl:when test="contains($msgMode,'inline')">
			<!--Displays links w/in table data-->
			<xsl:if test="count(//Photo) > 0">
			 <!-- 
				Call the template that will handle displaying the image(s). 
				Use apply-templates to handle all the instances of the FileList element.
				If getting multiple copies of the same data, switch to call-template.
			 -->
			 <xsl:call-template name="FileList_Table">
				 <!--removed //FileList/Photo - was displaying all images for each record-->
				  <!--xsl:with-param name="elementPath" select="//FileList/Photo"/>
				  <xsl:with-param name="totalElements" select="count(//FileList/Photo)"/-->
				  <xsl:with-param name="elementPath" select="FileList/Photo"/>
				  <xsl:with-param name="totalElements" select="count(FileList/Photo)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">Photo</xsl:with-param>
				  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
			  </xsl:call-template>
				<xsl:if test="count(FileList/Photo/LinkInfo)>0">
					<xsl:for-each select="FileList/Photo/LinkInfo">
						<xsl:call-template name="LinkInfo" />
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
			<xsl:if test="count(InjectXML/FileList/PDF) > 0" >
			 <!-- 052306 MAH Changed to InjectXML - was displaying all instances instead of one for each record -->
			 <!-- 
				Call the template that will handle displaying the PDF file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				Using call-template because apply-templates will try to match on "FileList"
				and we're not on that element anymore.
			 -->
			 <xsl:call-template name="FileList_Table">
				  <xsl:with-param name="elementPath" select="InjectXML/FileList/PDF"/>
				  <xsl:with-param name="totalElements" select="count(InjectXML/FileList/PDF)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">PDF</xsl:with-param>
				  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
			  </xsl:call-template>
			</xsl:if>
		</xsl:when>
		<xsl:when test="(contains($msgMode,'summary')) or (contains($msgMode,'record'))">
			<!-- If msgMode is record or summary, than we're already in the FileList element.
				 So we need to check for the child Photo instead of FileList/Photo.
			-->
			<xsl:if test="count(//Photo) > 0">
			 <p class="ctc_page_subtitle_1">Associated Image(s)</p>
			 <!-- 
				Call the template that will handle displaying the image(s). 
				Use apply-templates to handle all the instances of the FileList element.
				Using call-template because apply-templates will try to match on "FileList"
				and we're not on that element anymore.
			 -->
			 <!--xsl:choose>
					<xsl:when test="count(//PhotoGrp) > 0">
						 <xsl:call-template name="FileList_Table">
							  <xsl:with-param name="elementPath" select="PhotoGrp/Photo" />
							  <xsl:with-param name="totalElements" select="count(//Photo)"/>
							  <xsl:with-param name="fileType">Photo</xsl:with-param>
							  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
						  </xsl:call-template>
					</xsl:when>
					<xsl:otherwise-->
						 <xsl:call-template name="FileList_Table">
							  <xsl:with-param name="elementPath" select="Photo" />
							  <xsl:with-param name="totalElements" select="count(Photo)"/>
							  <!-- WARNING! fileType parameter will break if use select statement in param def -->
							  <xsl:with-param name="fileType">Photo</xsl:with-param>
							  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
						  </xsl:call-template>
					<!--/xsl:otherwise>
				</xsl:choose-->
			  <xsl:if test="contains($msgMode,'record')">
				<xsl:if test="count(//Photo/LinkInfo)>0">
					<xsl:for-each select="//Photo/LinkInfo">
						<xsl:call-template name="LinkInfo" />
					</xsl:for-each>
				</xsl:if>
			  </xsl:if>
			</xsl:if>
			<!-- PDF -->
			<!-- Check if at least 1 PDF element exists in the FileList element -->
<!--		
In ctc_templates.xsl count pdf:<xsl:value-of select="count(//PDF)"/>
-->
			<xsl:if test="count(//PDF) > 0" >
			 <p class="ctc_page_subtitle_1">Associated File(s)</p>
			 <!-- 
				Call the template that will handle displaying the PDF file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				Using call-template because apply-templates will try to match on "FileList"
				and we're not on that element anymore.
			 -->
			 <xsl:call-template name="FileList_Table">
				  <xsl:with-param name="elementPath" select="PDF"/>
				  <xsl:with-param name="totalElements" select="count(PDF)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">PDF</xsl:with-param>
				  <!--xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param-->
				  <xsl:with-param name="msgMode">summary</xsl:with-param>
			  </xsl:call-template>
			</xsl:if>
			<!-- Misc File -->
			<!-- Check if at least 1 MiscFile element exists in the FileList element -->
			<xsl:if test="count(//MiscFile) > 0" >
			 <p class="ctc_page_subtitle_1">Associated File(s)</p>
			 <!-- 
				Call the template that will handle displaying the file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				Using call-template because apply-templates will try to match on "FileList"
				and we're not on that element anymore.
			 -->
			 <xsl:call-template name="FileList_Table">
				  <xsl:with-param name="elementPath" select="MiscFile"/>
				  <xsl:with-param name="totalElements" select="count(MiscFile)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">MiscFile</xsl:with-param>
				  <xsl:with-param name="msgMode"><xsl:value-of select="$msgMode"/></xsl:with-param>
			  </xsl:call-template>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="count(FileList/Photo) > 0">
			 <p class="ctc_page_subtitle_1">Associated Image(s)</p>
			 <!-- 
				Call the template that will handle displaying the image(s). 
				Use apply-templates to handle all the instances of the FileList element.
				If getting multiple copies of the same data, switch to call-template.
			 -->
			 <xsl:apply-templates select="FileList" mode="table">
				  <xsl:with-param name="elementPath" select="//FileList/Photo" />
				  <xsl:with-param name="totalElements" select="count(//FileList/Photo)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">Photo</xsl:with-param>
			  </xsl:apply-templates>
				<xsl:if test="count(//FileList/Photo/LinkInfo)>0">
					<xsl:for-each select="//FileList/Photo/LinkInfo">
						<xsl:call-template name="LinkInfo" />
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
		
			<!-- PDF -->
			<!-- Check if at least 1 PDF element exists in the FileList element -->
			<xsl:if test="count(FileList/PDF) > 0" >
			 <p class="ctc_page_subtitle_1">Associated File(s)</p>
			 <!-- 
				Call the template that will handle displaying the PDF file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				If getting multiple copies of the same data, switch to call-template.
			 -->
			 <xsl:apply-templates select="FileList" mode="table">
				  <xsl:with-param name="elementPath" select="//FileList/PDF"/>
				  <xsl:with-param name="totalElements" select="count(//FileList/PDF)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">PDF</xsl:with-param>
			  </xsl:apply-templates>
			</xsl:if>

			<!-- Misc File -->
			<!-- Check if at least 1 MiscFile element exists in the FileList element -->
			<xsl:if test="count(FileList/MiscFile) > 0" >
			 <p class="ctc_page_subtitle_1">Associated File(s)</p>
			 <!-- 
				Call the template that will handle displaying the PDF file(s). 
				Use apply-templates to handle all the instances of the FileList element.
				If getting multiple copies of the same data, switch to call-template.
			 -->
			 <xsl:apply-templates select="FileList" mode="table">
				  <xsl:with-param name="elementPath" select="//FileList/MiscFile"/>
				  <xsl:with-param name="totalElements" select="count(//FileList/MiscFile)"/>
				  <!-- WARNING! fileType parameter will break if use select statement in param def -->
				  <xsl:with-param name="fileType">MiscFile</xsl:with-param>
			  </xsl:apply-templates>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>


  </xsl:template>
  
  
  <!-- *************************** -->
  <xsl:template name="FileList_Table" match="FileList" mode="table">
  <!--
	Displays remote files (e.g. images and PDF files)
	Called from FileListCall.xsl    
	Parameters:
		elementPath - //FileList/<Photo/PDF>
		totalElements - count($elementPath)
		fileType - the type of FileList element (e.g. Photo, PDF)
		msgMode - what type of message (summary, record, message)
  -->

  	<xsl:param name="elementPath"/>
	<xsl:param name="totalElements"/>
	<xsl:param name="fileType"/>
	<xsl:param name="msgMode"/>
	
 <!--		
In ctc_templates.xsl FileList_Table msgMode:<xsl:value-of select="$msgMode"/>
-->
<!--check if element exists-->
   <xsl:if test="$totalElements > 0" >
     <xsl:variable name="cols" select="5" />
     <xsl:variable name="dataObjs" select="$totalElements" />
     <xsl:variable name="blankCells" select=" $cols - ($dataObjs mod $cols) " />
     <table border="1">
          <xsl:for-each select="$elementPath">
          <tr>
				<xsl:if test="contains($msgMode,'summary')">
		                                <!--xsl:if test="(contains($msgMode,'summary')) or (contains($msgMode,'record'))"-->
				   <td class="ctc_tbl_data" align="left" valign="top" >
					<table border="0">
						<tr>
							<td>Title</td>
							<td><strong><xsl:value-of select="./TalonPointData/@FileTitle"/></strong></td>
						</tr>
						<tr>
							<td>Source</td>
							<td><strong><xsl:value-of select="./TalonPointData/@SourceName"/></strong></td>
						</tr>
						<tr>
							<td>
								<xsl:if test="count(LinkInfo)>0">
									<xsl:for-each select="LinkInfo">
										<xsl:call-template name="LinkInfo" />
									</xsl:for-each>
								</xsl:if>
							</td>
						</tr>
					</table>
				   </td>
				</xsl:if>
		<td class="ctc_tbl_data" align="center" valign="middle" >
<!--		
In ctc_templates.xsl FileList_Table DefaultDownloadBehavior:<xsl:value-of select="@DefaultDownloadBehavior"/><br/>		
In ctc_templates.xsl FileList_Table Location:<xsl:value-of select="@Location"/><br/>
In ctc_templates.xsl FileList_Table LinkInfo:<xsl:value-of select="count(LinkInfo)"/><br/>
In ctc_templates.xsl FileList_Table desc:<xsl:value-of select="concat(@Status, @APImageTitle)"/><br/>
In ctc_templates.xsl FileList_Table dest:<xsl:value-of select="@ID"/><br/>
In ctc_templates.xsl FileList_Table type:<xsl:value-of select="string('image')"/><br/>
-->
				 <xsl:choose>
					<xsl:when test="@DefaultDownloadBehavior='false'">
						<!--Only display link if this attribute is set to false -->
						<xsl:if test="count(LinkInfo)>0">
							<xsl:for-each select="LinkInfo">
								<xsl:call-template name="LinkInfo" />
							</xsl:for-each>
						</xsl:if>
					 </xsl:when>
					 <xsl:otherwise>
						 <xsl:if test="@Location='Server'" >
						   <xsl:call-template name="Link" >
							 <xsl:with-param name="desc" select="concat(@Status, @APImageTitle)" />
							 <xsl:with-param name="dest" select="@ID" />
							 <xsl:with-param name="type" select="string('image')" />
						   </xsl:call-template>
						 </xsl:if>
						 <xsl:if test="@Location='Local'">
							<xsl:if test="(contains($fileType,'PDF')) or (contains($fileType,'MiscFile'))">
							   <xsl:call-template name="Link" >
								 <xsl:with-param name="desc" select="concat(@Status, @APImageTitle)" />
								 <xsl:with-param name="dest" select="@ID" />
								 <xsl:with-param name="type" select="string('image')" />
							   </xsl:call-template>
							</xsl:if>
							<xsl:if test="contains($fileType,'Photo')">
							   <xsl:call-template name="Image" >
								 <xsl:with-param name="source" select="concat('file://', LocalFullPath)" />
							   </xsl:call-template>
						   </xsl:if>
						 </xsl:if>
					 </xsl:otherwise>
				 </xsl:choose>
		</td>
           </tr>
           </xsl:for-each>
     </table>
   </xsl:if>
	
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
  <xsl:template name="fldr_querytitle">

	<!--Display query string, if available-->
	<xsl:variable name="queryTitle" select="../@Title"/>
	<xsl:if test="string-length($queryTitle) > 0">
		<p class="ctc_page_subtitle_1"><font color="black">Queried: <xsl:value-of select="$queryTitle"/></font></p>
	</xsl:if>

  </xsl:template>
  
  <!-- *************************** -->
  <xsl:template name="fldr_footer">
	<xsl:choose>
		<xsl:when test="count(//CTCNote)>0">
			<hr/>
			<p><pre class="ctc_warning_text"><xsl:value-of select="CTCNote"/></pre></p>
		</xsl:when>
		<xsl:otherwise>
			<p class="ctc_page_subtitle_1">*** END OF RECORDS ***</p>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
    <!-- *************************** -->
<xsl:template name="TextSplit">
    <xsl:param name="InputString"/>
    <xsl:param name="line-length" select="80"/>
    <xsl:variable name="line" select="substring($InputString,1,$line-length)"/>
    <xsl:variable name="rest" select="substring($InputString, $line-length+1)"/>
    <xsl:if test="$line">
        <MYTEXT> 
            <xsl:value-of select="$line"/>  
             <xsl:text>&#10;</xsl:text>
        </MYTEXT> 
    </xsl:if>
    <xsl:if test="$rest">
        <xsl:call-template name="TextSplit">
            <xsl:with-param name="InputString" select="$rest"/>
            <xsl:with-param name="line-length" select="$line-length"/>
        </xsl:call-template>
    </xsl:if>   
</xsl:template>
  <!-- *************************** -->
<xsl:template name="trim">
        <xsl:param name="input"/>
        <xsl:choose>
                <xsl:when test="starts-with($input,' ')">
                        <xsl:call-template name="trim">
                                <xsl:with-param name="input" select="substring-after($input,' ')"/>
                        </xsl:call-template>
                </xsl:when>
                <xsl:when test="substring($input, string-length($input) ) = ' ' ">
                        <xsl:call-template name="trim">
                                <xsl:with-param name="input" select="substring($input, 1, string-length($input)-1)"/>
                        </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with($input,'&#10;')">
                        <xsl:call-template name="trim">
                                <xsl:with-param name="input" select="substring-after($input,'&#10;')"/>
                        </xsl:call-template>
                </xsl:when>
	      <xsl:when test="starts-with($input,'&#13;')">
                        <xsl:call-template name="trim">
                                <xsl:with-param name="input" select="substring-after($input,'&#13;')"/>
                        </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="$input"/>
                </xsl:otherwise>
        </xsl:choose>
</xsl:template>
  <!-- *************************** -->
</xsl:stylesheet>
