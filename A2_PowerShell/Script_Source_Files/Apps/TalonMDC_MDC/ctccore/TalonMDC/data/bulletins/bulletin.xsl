<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- *************************** -->
  <!-- CHANGE HISTORY:
	   12/22/06 MAH - Created.
	   12/26/06 MAH - Added check for presence of images.
	   12/28/06 MAH - Removed centering.
					  Added Body2 and PublishedBy.
					  Added check for PreferredLayout 3 & 4.
	   01/08/07 MAH - Changed body to use <pre> to preserve spaces.
  -->
  <!-- *************************** -->

<xsl:output method="html" doctype-public ="-//W3C//DTD HTML 4.0 Transitional//EN"/>

  <!-- *************************** -->
  <xsl:template name="Bulletin" match="Bulletin">
	
		<table>
			<tr>
				<td class="ctc_page_subtitle_1"><xsl:value-of select="Content/Header"/></td>
			</tr>
			<tr>
				<!--td><xsl:value-of select="Content/Body"/></td-->
				<!--td><pre style="font-family: Times New Roman;"><xsl:value-of select="Content/Body"/></pre></td-->
				<td><pre class="ctc_msg_data"><xsl:value-of select="Content/Body"/></pre></td>
			</tr>
			<xsl:if test="count(Image)>0">
				<tr>
					<xsl:choose>
						<xsl:when test="(contains(@PreferredLayout,'1')) or (contains(@PreferredLayout,'3'))">
							<xsl:variable name="LocalPath" select="Image"/>
							<xsl:variable name="source" select="concat('file://', $LocalPath)"/>
							<td>
								<img src="{$source}" />
							</td>
							
						</xsl:when>
						<xsl:when test="(contains(@PreferredLayout,'2')) or (contains(@PreferredLayout,'4'))">
							<td>
								<table border="0" cellspacing="0">
									<tr valign="top">
										<xsl:for-each select="Image">
											<xsl:variable name="LocalPath" select="."/>
											<xsl:variable name="source" select="concat('file://', $LocalPath)"/>
											<td>
												<img src="{$source}" />
											</td>
										</xsl:for-each>
									</tr>
								</table>
							</td>
						</xsl:when>
					</xsl:choose>
				</tr>
			</xsl:if>
			<xsl:if test="count(Content/Body2)>0">
				<tr>
					<td><pre class="ctc_msg_data"><xsl:value-of select="Content/Body2"/></pre></td>
				</tr>
			</xsl:if>
			<xsl:if test="count(Content/PublishedBy)>0">
				<tr>
					<td class="ctc_msg_data"><xsl:value-of select="Content/PublishedBy"/></td>
				</tr>
			</xsl:if>
		</table>

		<xsl:if test="count(Comments)>0">
			<p class="ctc_page_subtitle_1">Comments</p>
			<xsl:for-each select="Comments/Comment">
				<xsl:value-of select="."/><br/>
				<hr/>
			</xsl:for-each>
		</xsl:if>
	
	</xsl:template>

  <!-- *************************** -->

</xsl:stylesheet>
