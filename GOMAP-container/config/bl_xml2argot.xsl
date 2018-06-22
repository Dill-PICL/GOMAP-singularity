<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://exslt.org/math">
  <xsl:output method="text" />
     <xsl:template match="/BlastOutput/*" />
     <xsl:template match="/BlastOutput/BlastOutput_iterations">
        <xsl:variable name="currNode" select="Iteration" />    
    <!-- output the data row -->
    <!-- loop over the field names and find the value of each one in the xml -->
    <!-- <xsl:for-each select="$fields"> -->
      <xsl:for-each select="$currNode/Iteration_hits/Hit">
        <xsl:variable name="evalue" select="math:min(Hit_hsps/Hsp/Hsp_evalue)"/>
        <xsl:value-of select="$currNode/Iteration_query-def" />
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="Hit_accession"/>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="$evalue"/>
        <xsl:text>&#xa;</xsl:text>
      </xsl:for-each>
    <!-- </xsl:for-each> -->
  </xsl:template>
  <xsl:template match="text()[not(string-length(normalize-space()))]"/>
</xsl:stylesheet>