<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:cxo="http://xmlcalabash.com/ns/extensions/osutils"
                type="cx:load-config"
                exclude-inline-prefixes="cx"
                name="main" version="1.0">
<p:output port="result"/>
<p:option name="filename" required="true"/>

<p:import href="osutils.xpl"/>

<cxo:env/>

<p:group>
  <p:variable name="HOME"
              select="concat('file://', /c:result/c:env[@name='HOME']/@value, '/')"/>

  <p:variable name="fn"
              select="resolve-uri($filename, $HOME)"/>

  <p:string-replace match="/doc/text()">
    <p:input port="source"><p:inline><doc>@@</doc></p:inline></p:input>
    <p:with-option name="replace" select="concat('&quot;',$fn,'&quot;')"/>
  </p:string-replace>

  <p:load>
    <p:with-option name="href" select="string(/)"/>
  </p:load>

</p:group>

</p:declare-step>
