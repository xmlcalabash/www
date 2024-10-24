<p:library xmlns:p="http://www.w3.org/ns/xproc"
	   xmlns:c="http://www.w3.org/ns/xproc-step"
	   xmlns:cx="http://xmlcalabash.com/ns/extensions"
	   xmlns:xs="http://www.w3.org/2001/XMLSchema"
           version="1.0">

<p:declare-step type="cx:eval">
  <p:input port="source" sequence="true" primary="true"/>
  <p:input port="pipeline"/>
  <p:input port="parameters" kind="parameter"/>
  <p:input port="options" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="detailed" select="'false'"/>
  <p:option name="step" cx:type="xs:QName"/>
</p:declare-step>

</p:library>
