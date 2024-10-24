<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:r="http://nwalsh.com/ns/git-repo-info"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="atom h db dc f m r t xlink xs"
		version="2.0">

<xsl:import href="https://cdn.docbook.org/release/xsl20/current/xslt/base/html/final-pass.xsl"/>

<xsl:output name="final"
	    method="xhtml"
	    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:param name="autolabel.elements">
  <db:appendix format="A"/>
  <db:chapter/>
</xsl:param>

<xsl:param name="linenumbering" as="element()*">
<ln path="literallayout" everyNth="0"/>
<ln path="programlisting" everyNth="0"/>
<ln path="programlistingco" everyNth="0"/>
<ln path="screen" everyNth="0"/>
<ln path="synopsis" everyNth="0"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

<xsl:variable name="cwd" select="system-property('user.dir')"/>
<xsl:variable name="page" select="substring-after(base-uri(/), $cwd)"/>
<xsl:variable name="article" select="/*"/>

<!-- ============================================================ -->

<xsl:variable name="sitenav" select="document('../etc/nav.xml')/*"
	      as="element()"/>

<xsl:variable name="gitlog" select="document('../etc/git-log-summary.xml')/*"
	      as="element()"/>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:javascript-head">
  <xsl:param name="node" select="."/>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script src="/archive-1.x/js/bulma.js"></script>
</xsl:template>

<xsl:template match="*" mode="m:css">
  <xsl:param name="node" select="."/>

  <link rel="stylesheet"
        href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css" />
  <link href="https://fonts.googleapis.com/css?family=Odibee+Sans&amp;display=swap" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="/archive-1.x/css/bulma.css"/>
  <link rel="stylesheet" type="text/css" href="/archive-1.x/css/bulma-mods.css"/>
  <link rel="stylesheet" type="text/css" href="/archive-1.x/css/style.css"/>

  <link rel="icon" href="/archive-1.x/img/icon.png" type="image/png"/>
  <xsl:if test="/db:article/@xml:id='home'">
    <link rel="me" href="https://botsin.space/@xmlcalabash"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:article[@xml:id]">
  <xsl:apply-templates select="$sitenav" mode="to-xhtml"/>

  <article class="section">
    <div class="container is-fluid">
      <img class="homelogo" src="/archive-1.x/img/homelogo.jpg"/>
      <h1>
	<xsl:apply-templates select="db:info/db:title" mode="titlepage"/>
      </h1>

      <xsl:apply-templates/>
      <xsl:call-template name="t:process-footnotes"/>
    </div>
  </article>

  <footer class="footer">
    <xsl:variable name="gitfn" select="substring-after(base-uri(/), $gitlog/@root)"/>
    <xsl:variable name="commit" select="($gitlog/r:commit[r:file = $gitfn])[1]"/>
    <xsl:variable name="cdate" select="($commit/r:date, '1970-01-01T00:00:00Z')[1]"/>
    <xsl:variable name="committer" select="substring-before($commit/r:committer, ' &lt;')"/>
    <xsl:if test="exists($cdate)">
      <xsl:variable name="date" select="$cdate cast as xs:dateTime"/>
      <xsl:text>Last updated on </xsl:text>
      <xsl:value-of select="format-dateTime($date, '[D01] [MNn,*-3] [Y0001]')"/>
      <xsl:text> at </xsl:text>
      <xsl:value-of select="format-dateTime($date, '[h01]:[m01][P] [z]')"/>
      <xsl:text> by </xsl:text>
      <xsl:value-of select="$committer"/>
    </xsl:if>
  </footer>
</xsl:template>

<xsl:template match="element()" mode="to-xhtml">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*,node()" mode="to-xhtml"/>
  </xsl:element>
</xsl:template>

<xsl:template match="a[@id = $article/@xml:id]/@class" mode="to-xhtml">
  <xsl:attribute name="class" select="concat(., ' is-active')"/>
</xsl:template>

<xsl:template match="a/@id" mode="to-xhtml">
  <!-- remove it -->
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()" mode="to-xhtml">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
