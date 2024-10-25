<p:library xmlns:p="http://www.w3.org/ns/xproc"
           xmlns:c="http://www.w3.org/ns/xproc-step"
           xmlns:flickr="http://xmlcalabash.com/ns/extensions/flickr"
           xmlns:cx="http://xmlcalabash.com/ns/extensions"
           version="1.0">

<p:import href="sort-parameters.xpl"/>
<p:import href="load-config.xpl"/>

<p:declare-step type="flickr:sign-api" name="main">
  <p:input port="parameters" kind="parameter"/>
  <p:output port="result"/>
  <p:option name="secret"/>

  <p:parameters name="params">
    <p:input port="parameters">
      <p:pipe step="main" port="parameters"/>
    </p:input>
  </p:parameters>

  <p:choose name="secret">
    <p:when test="p:value-available('secret')">
      <p:output port="result"/>

      <p:string-replace match="/secret/text()">
        <p:input port="source">
          <p:inline><secret>@@</secret></p:inline>
        </p:input>
        <p:with-option name="replace" select="concat('&quot;',$secret,'&quot;')"/>
      </p:string-replace>
    </p:when>

    <p:when test="/c:param-set/c:param[@name='secret']">
      <p:xpath-context>
        <p:pipe step="params" port="result"/>
      </p:xpath-context>
      <p:output port="result"/>

      <p:variable name="value"
                  select="string(/c:param-set/c:param[@name='secret']/@value)">
        <p:pipe step="params" port="result"/>
      </p:variable>

      <p:string-replace match="/secret/text()">
        <p:input port="source">
          <p:inline><secret>@@</secret></p:inline>
        </p:input>
        <p:with-option name="replace" select="concat('&quot;',$value,'&quot;')"/>
      </p:string-replace>
    </p:when>

    <p:otherwise>
      <p:output port="result"/>

      <p:error code="err:XX01" xmlns:err="http://www.w3.org/ns/xproc-error">
        <p:input port="source">
          <p:inline>
            <message>flickr:sign-api called without secret</message>
          </p:inline>
        </p:input>
      </p:error>
    </p:otherwise>
  </p:choose>

  <cx:sort-parameters name="sorted">
    <p:input port="parameters">
      <p:pipe step="main" port="parameters"/>
    </p:input>
  </cx:sort-parameters>

  <p:for-each name="loop">
    <p:iteration-source select="//c:param[@name != 'secret']"/>

    <p:variable name="name"
                select="if (contains(/*/@name, ':'))
                        then substring-after(/*/@name, ':')
                        else string(/*/@name)"/>

    <p:variable name="value" select="string(/*/@value)"/>

    <p:string-replace match="/doc/text()">
      <p:input port="source"><p:inline><doc>@@</doc></p:inline></p:input>
      <p:with-option name="replace"
                     select="'concat(&quot;',$name,'&quot;,&quot;',$value,'&quot;)'">
        <p:pipe step="loop" port="current"/>
      </p:with-option>
    </p:string-replace>
  </p:for-each>

  <p:wrap-sequence wrapper="inner-wrapper"/>

  <p:insert match="/inner-wrapper" position="first-child">
    <p:input port="insertion">
      <p:pipe step="secret" port="result"/>
    </p:input>
  </p:insert>

  <p:wrap-sequence wrapper="wrapper"/>

  <p:hash match="/wrapper/inner-wrapper" algorithm="md" version="5" name="hash">
    <p:with-option name="value" select="string(.)"/>
  </p:hash>

  <p:group>
    <p:variable name="hash" select="string(/)">
      <p:pipe step="hash" port="result"/>
    </p:variable>

    <p:string-replace match="/c:param/@value" name="api_sig">
      <p:input port="source">
        <p:inline><c:param name="api_sig" value="@@"/></p:inline>
      </p:input>
      <p:with-option name="replace" select="concat('&quot;',$hash,'&quot;')"/>
    </p:string-replace>

    <p:delete match="c:param[@name='secret']">
      <p:input port="source">
        <p:pipe step="params" port="result"/>
      </p:input>
    </p:delete>

    <p:insert match="/c:param-set" position="last-child">
      <p:input port="insertion">
        <p:pipe step="api_sig" port="result"/>
      </p:input>
    </p:insert>
  </p:group>
</p:declare-step>

<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf flickr"
                type="flickr:upload" name="main">
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>

<p:option name="href" required="true"/>
<p:option name="title"/>
<p:option name="description" select="''"/>
<p:option name="tags" select="''"/>
<p:option name="is_public" select="1"/>
<p:option name="is_friend" select="1"/>
<p:option name="is_family" select="1"/>
<p:option name="safety_level" select="1"/>
<p:option name="content_type" select="1"/>
<p:option name="hidden" select="1"/>

<p:declare-step type="cx:make-param">
  <p:output port="result"/>
  <p:option name="pname" required="true"/>
  <p:option name="pvalue" required="true"/>

  <p:string-replace match="/c:param/@name">
    <p:input port="source">
      <p:inline><c:param name="@@" value="@@"/></p:inline>
    </p:input>
    <p:with-option name="replace"
                   select="concat('&quot;', $pname, '&quot;')"/>
  </p:string-replace>

  <p:string-replace match="/c:param/@value">
    <p:with-option name="replace"
                   select="concat('&quot;', $pvalue, '&quot;')"/>
  </p:string-replace>
</p:declare-step>

<cx:make-param name="arg-description" pname="description">
  <p:with-option name="pvalue" select="$description"/>
</cx:make-param>

<cx:make-param name="arg-tags" pname="tags">
  <p:with-option name="pvalue" select="$tags"/>
</cx:make-param>

<cx:make-param name="arg-is_public" pname="is_public">
  <p:with-option name="pvalue" select="$is_public"/>
</cx:make-param>

<cx:make-param name="arg-is_friend" pname="is_friend">
  <p:with-option name="pvalue" select="$is_friend"/>
</cx:make-param>

<cx:make-param name="arg-is_family" pname="is_family">
  <p:with-option name="pvalue" select="$is_family"/>
</cx:make-param>

<cx:make-param name="arg-safety_leavel" pname="safety_level">
  <p:with-option name="pvalue" select="$safety_level"/>
</cx:make-param>

<cx:make-param name="arg-content_type" pname="content_type">
  <p:with-option name="pvalue" select="$content_type"/>
</cx:make-param>

<cx:make-param name="arg-hidden" pname="hidden">
  <p:with-option name="pvalue" select="$hidden"/>
</cx:make-param>

<cx:load-config name="config" filename=".flickr.xml"/>

<!-- Handle optional title -->
<p:choose>
  <p:when test="p:value-available('title')">
    <p:string-replace match="/c:param/@value">
      <p:input port="source">
        <p:inline><c:param name="title" value="@@"/></p:inline>
      </p:input>
      <p:with-option name="replace"
                     select="concat('&quot;', $title, '&quot;')"/>
    </p:string-replace>
  </p:when>
  <p:otherwise>
    <p:identity>
      <p:input port="source">
        <p:empty/>
      </p:input>
    </p:identity>
  </p:otherwise>
</p:choose>

<p:insert match="/c:param-set" position="last-child">
  <p:input port="source">
    <p:pipe step="config" port="result"/>
  </p:input>
</p:insert>

<p:insert match="/c:param-set" position="last-child" name="param-set">
  <p:input port="insertion">
    <p:pipe step="arg-description" port="result"/>
    <p:pipe step="arg-tags" port="result"/>
    <p:pipe step="arg-is_public" port="result"/>
    <p:pipe step="arg-is_friend" port="result"/>
    <p:pipe step="arg-is_family" port="result"/>
    <p:pipe step="arg-safety_leavel" port="result"/>
    <p:pipe step="arg-content_type" port="result"/>
    <p:pipe step="arg-hidden" port="result"/>
  </p:input>
</p:insert>

<flickr:sign-api>
  <p:input port="parameters">
    <p:pipe step="param-set" port="result"/>
    <p:pipe step="main" port="parameters"/>
  </p:input>
</flickr:sign-api>

<!-- Turn each parameter into a form body part -->
<p:for-each name="loop">
  <p:iteration-source select="/c:param-set/c:param"/>
  <p:string-replace match="/c:body/@disposition">
    <p:input port="source">
      <p:inline><c:body disposition="@@" content-type="text/plain">@@</c:body></p:inline>
    </p:input>
    <p:with-option name="replace"
                   select="concat('&quot;form-data; name=''',
                                  /c:param/@name,
                                  '''&quot;')"/>
  </p:string-replace>
  <p:string-replace match="/c:body/text()">
    <p:with-option name="replace"
                   select="concat('&quot;', /c:param/@value, '&quot;')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:string-replace>
</p:for-each>

<p:wrap-sequence wrapper="c:multipart"/>

<p:add-attribute match="/c:multipart"
                 attribute-name="content-type"
                 attribute-value="multipart/form-data"/>

<p:add-attribute match="/c:multipart"
                 attribute-name="boundary"
                 attribute-value="abcdeffgalskdjflsjflksjfdsljfsldjfsdlkfjds"/>

<p:wrap-sequence wrapper="c:request"/>

<p:add-attribute match="/c:request"
                 attribute-name="method"
                 attribute-value="post"/>

<p:add-attribute match="/c:request" name="post-request"
                 attribute-name="href"
                 attribute-value="http://api.flickr.com/services/upload/"/>

<!--
<p:add-attribute match="/c:request" name="post-request"
                 attribute-name="href"
                 attribute-value="http://localhost:8133/service/check-multipart"/>
-->

<p:string-replace match="/c:request/@href">
  <p:input port="source">
    <p:inline>
      <c:request method="get" href="@@"/>
    </p:inline>
  </p:input>
  <p:with-option name="replace" select="concat('&quot;',
                                        resolve-uri($href, exf:cwd()),
                                        '&quot;')"/>
</p:string-replace>

<p:http-request name="get-image"/>

<p:add-attribute match="/c:body"
                 attribute-name="content-type" attribute-value="image/jpeg">
  <p:input port="source">
    <p:pipe step="get-image" port="result"/>
  </p:input>
</p:add-attribute>

<p:add-attribute match="/c:body"
                 attribute-name="disposition">
  <p:with-option name="attribute-value"
                 select="concat('form-data; name=&quot;photo&quot;; filename=&quot;', substring-after(resolve-uri($href, exf:cwd()), 'file:'), '&quot;')"/>
</p:add-attribute>

<p:insert match="/c:request/c:multipart" position="last-child">
  <p:input port="source">
    <p:pipe step="post-request" port="result"/>
  </p:input>
</p:insert>

<p:http-request cx:send-binary="true"/>
</p:declare-step>

<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                exclude-inline-prefixes="cx flickr"
                type="flickr:service" name="main">
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>

<cx:load-config name="config" filename=".flickr.xml"/>

<flickr:sign-api name="param-set">
  <p:input port="parameters">
    <p:pipe step="config" port="result"/>
    <p:pipe step="main" port="parameters"/>
  </p:input>
</flickr:sign-api>

<p:www-form-urlencode match="/c:request/@href">
  <p:input port="source">
    <p:inline><c:request method="get" href="@@"/></p:inline>
  </p:input>
  <p:input port="parameters">
    <p:pipe step="param-set" port="result"/>
  </p:input>
</p:www-form-urlencode>

<p:string-replace match="/c:request/@href"
                  replace="concat('http://api.flickr.com/services/rest/?',.)"/>

<p:http-request/>

</p:declare-step>

</p:library>
