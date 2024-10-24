<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:exf="http://exproc.org/standard/functions"
                type="cx:tee" name="main" version="1.0">
  <p:input port="source" sequence="true" primary="true"/>
  <p:output port="result" sequence="true" primary="true"/>
  <p:option name="href" required="true"/>
  <p:option name="debug" select="0"/>

  <p:choose>
    <p:when test="$debug != 0">
      <p:store name="saving-debugging-output" method="xml" indent="true">
        <p:with-option name="href" select="resolve-uri($href, exf:cwd())"/>
      </p:store>
    </p:when>
    <p:otherwise>
      <p:sink name="discarding-debugging-output"/>
    </p:otherwise>
  </p:choose>

  <p:identity name="identity">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
  </p:identity>
</p:declare-step>
