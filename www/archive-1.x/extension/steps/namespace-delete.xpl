<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                type="cx:namespace-delete"
                version="1.0">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:option name="prefixes" required="true"/>
</p:declare-step>
