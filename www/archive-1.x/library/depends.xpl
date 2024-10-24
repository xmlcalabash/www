<p:library xmlns:p="http://www.w3.org/ns/xproc"
	   xmlns:c="http://www.w3.org/ns/xproc-step"
	   xmlns:cx="http://xmlcalabash.com/ns/extensions"
	   xmlns:xs="http://www.w3.org/2001/XMLSchema"
           version="1.0">

<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

<p:declare-step name="main" type="cx:out-of-date"
		exclude-inline-prefixes="cx xs">
  <p:input port="source"/>
  <p:output port="result"/>

  <p:documentation xmlns="http://docbook.org/ns/docbook">
    <para>The <tag>cx:out-of-date</tag> step takes a document of the form:</para>
    <programlisting>&lt;cx:depends xmlns:cx="http://xmlcalabash.com/ns/extensions">
  &lt;cx:target>langspec.html&lt;/cx:target>
  &lt;cx:source>langspec.xml&lt;/cx:source>
  &lt;cx:source>otherdoc.xml&lt;/cx:source>
&lt;/cx:depends></programlisting>
    <para>If the target document exists and is newer than all of the specified
    sources, then <tag>cx:out-of-date</tag> returns a <tag>c:result</tag>
    document containing the word “false”, otherwise it returns a 
    <tag>c:result</tag> document containing the word “true”. If the target
    is out of date, the <tag>c:result</tag> element will have an
    <tag class="attribute">href</tag> attribute that identifies
    <emphasis>one of</emphasis> the sources that is newer than the target.
    </para>
  </p:documentation>

  <p:choose>
    <p:when test="not(/cx:depends)">
      <p:error code="cx:wrong-input-type">
	<p:input port="source">
	  <p:inline>
	    <message>The cx:out-of-date step expects a cx:depends document.
	    </message>
	  </p:inline>
	</p:input>
      </p:error>
      <p:identity>
	<p:input port="source">
	  <p:inline><doc>This can't happen.</doc></p:inline>
	</p:input>
      </p:identity>
    </p:when>
    <p:otherwise>
      <cx:uri-info name="target-info">
	<p:with-option name="href"
		       select="resolve-uri(/cx:depends/cx:target,
			                   base-uri(/cx:depends/cx:target))"/>
      </cx:uri-info>

      <p:for-each>
	<p:iteration-source select="/cx:depends/cx:source">
	  <p:pipe step="main" port="source"/>
	</p:iteration-source>
	<p:output port="result" sequence="true"/>

	<cx:uri-info name="source-info">
	  <p:with-option name="href"
			 select="resolve-uri(/, base-uri(/*))"/>
	</cx:uri-info>

	<p:choose>
	  <p:variable name="target-exists" select="/c:uri-info/@exists">
	    <p:pipe step="target-info" port="result"/>
	  </p:variable>
	  <p:variable name="target-datetime" select="/c:uri-info/@last-modified">
	    <p:pipe step="target-info" port="result"/>
	  </p:variable>
	  <p:variable name="source-exists" select="/c:uri-info/@exists">
	    <p:pipe step="source-info" port="result"/>
	  </p:variable>
	  <p:variable name="source-datetime" select="/c:uri-info/@last-modified">
	    <p:pipe step="source-info" port="result"/>
	  </p:variable>
	  <p:when test="$source-exists != 'true'">
	    <p:string-replace match="cx:target">
	      <p:input port="source">
		<p:inline>
		  <message>The target (<cx:target/>) depends on a source file (<cx:source/>) that does not exist.</message>
		</p:inline>
	      </p:input>
	      <p:with-option name="replace"
			     select="concat('&quot;',/c:uri-info/@href,'&quot;')">
		<p:pipe step="target-info" port="result"/>
	      </p:with-option>
	    </p:string-replace>

	    <p:string-replace match="cx:source" name="srepl">
	      <p:with-option name="replace"
			     select="concat('&quot;',/c:uri-info/@href,'&quot;')">
		<p:pipe step="source-info" port="result"/>
	      </p:with-option>
	    </p:string-replace>

	    <p:error code="cx:no-source">
              <p:input port="source">
                <p:pipe step="srepl" port="result"/>
              </p:input>
            </p:error>
	  </p:when>
	  <p:when test="$target-exists = 'true'
			and xs:dateTime($target-datetime)
			    &gt; xs:dateTime($source-datetime)">
	    <p:identity>
	      <p:input port="source">
		<p:inline><c:result>false</c:result></p:inline>
	      </p:input>
	    </p:identity>
	  </p:when>
	  <p:otherwise>
	    <p:string-replace match="/c:result/@href">
	      <p:input port="source">
		<p:inline><c:result href="">true</c:result></p:inline>
	      </p:input>
	      <p:with-option name="replace"
			     select="concat('&quot;',/c:uri-info/@href,'&quot;')">
		<p:pipe step="source-info" port="result"/>
	      </p:with-option>
	    </p:string-replace>
	  </p:otherwise>
	</p:choose>
      </p:for-each>
    </p:otherwise>
  </p:choose>

  <p:wrap-sequence wrapper="cx:wrapper"/>

  <p:choose>
    <p:when test="/cx:wrapper[c:result = 'true']">
      <p:identity>
	<p:input port="source" select="/cx:wrapper/c:result[. = 'true'][1]"/>
      </p:identity>
    </p:when>
    <p:otherwise>
      <p:identity>
	<p:input port="source">
	  <p:inline><c:result>false</c:result></p:inline>
	</p:input>
      </p:identity>
    </p:otherwise>
  </p:choose>
</p:declare-step>

</p:library>
