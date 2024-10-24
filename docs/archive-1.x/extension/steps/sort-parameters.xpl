<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                type="cx:sort-parameters"
                exclude-inline-prefixes="cx"
                name="main" version="1.0">
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>

<p:parameters name="params">
  <p:input port="parameters">
    <p:pipe step="main" port="parameters"/>
  </p:input>
</p:parameters>

<p:xslt>
  <p:input port="source">
    <p:pipe step="params" port="result"/>
  </p:input>
  <p:input port="stylesheet">
    <p:inline>
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                      xmlns:c="http://www.w3.org/ns/xproc-step"
                      version="2.0">

        <xsl:template match="c:param-set">
          <c:param-set>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="c:param">
              <xsl:sort select="concat(@namespace,'|',@name)"/>
              <xsl:sequence select="."/>
            </xsl:for-each>
          </c:param-set>
        </xsl:template>

      </xsl:stylesheet>
    </p:inline>
  </p:input>
</p:xslt>

</p:declare-step>
