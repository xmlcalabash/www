<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:cx="http://xmlcalabash.com/ns/extensions"
           xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
           xmlns:xsd="http://www.w3.org/2001/XMLSchema"
           version="1.0">

<p:declare-step type="cxf:copy">
   <p:output port="result" primary="false"/>
   <p:option name="href" required="true"/>
   <p:option name="target" required="true"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:delete">
   <p:output port="result" primary="false"/>
   <p:option name="href" required="true"/>
   <p:option name="recursive" select="'false'"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:head">
   <p:output port="result"/>
   <p:option name="href" required="true"/>
   <p:option name="count" required="true"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:info">
   <p:output port="result" sequence="true"/>
   <p:option name="href" required="true"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:mkdir">
   <p:output port="result" primary="false"/>
   <p:option name="href" required="true"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:move">
   <p:output port="result" primary="false"/>
   <p:option name="href" required="true"/>
   <p:option name="target" required="true"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:tail">
   <p:output port="result"/>
   <p:option name="href" required="true"/>
   <p:option name="count" required="true"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:tempfile">
   <p:output port="result" primary="false"/>
   <p:option name="href" required="true"/>
   <p:option name="prefix"/>
   <p:option name="suffix"/>
   <p:option name="delete-on-exit"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

<p:declare-step type="cxf:touch">
   <p:output port="result" primary="false"/>
   <p:option name="href" required="true"/>
   <p:option name="timestamp"/>
   <p:option name="fail-on-error" select="'true'"/>
</p:declare-step>

</p:library>
