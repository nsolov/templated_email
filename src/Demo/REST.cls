/// Only for demo
Class Demo.REST Extends %CSP.REST
{

Parameter HOMEDIR = "/home/irisowner/dev/templates/";

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "UTF-8";

Parameter HandleCorsRequest = 1;

XData UrlMap
{
<Routes>
    <Route Url="/templates" Method="GET" Call="getTemplates" />
    <Route Url="/templates" Method="POST" Call="saveTemplate" />
    <Route Url="/send" Method="POST" Call="sendEmail"/>
    
    <Route Url="/github-auth" Method="GET" Call="auth"/>
    
</Routes>
}

/// Description
ClassMethod getTemplates() As %Status
{
    set stmt = ##class(%SQL.Statement).%New()
    set sc = stmt.%PrepareClassQuery("%File", "FileSet")
    return:$$$ISERR(sc) sc
    set rset = stmt.%Execute(..#HOMEDIR, "*.tpl", "Name")
    
    set res = []
    while rset.%Next() {
        do res.%Push({"name":($p(rset.%Get("Name"), "/", *))})
    }
    write res.%ToJSON()
    return $$$OK
}

ClassMethod saveTemplate() As %Status
{
    set content = ##class(%Library.DynamicObject).%FromJSON(%request.Content)
    set sc = ##class(TemplatedEmail.TemplateService).buildTemplateFromMarkdown(..#HOMEDIR_"main.tpl", content.body, ..#HOMEDIR_content.name)
    return sc
}

ClassMethod sendEmail() As %Status
{
    set content = ##class(%Library.DynamicObject).%FromJSON(%request.Content)
    
    set msg = ##class(TemplatedEmail.EmailRequest).%New()
    set msg.Recipients = content.to
    set msg.FromAddress = $get(^fromAddress) 
    set msg.BodyTemplateFilename = content.template
    set msg.SubjectTemplate = content.subject
    set msg.Data = {}.%FromJSON(content.data)
    
    set tSC = ##class(Ens.Director).CreateBusinessService("RestService",.tService)
    if ($IsObject(tService)) {
        set tSC = tService.ProcessInput(msg,.output)
    }
    return tSC
}

ClassMethod GetSSLConfiguration(host) As %String
{
  NEW $NAMESPACE
  SET $NAMESPACE = "%SYS"
  
  IF '##class(Security.SSLConfigs).Exists(host) {
    DO ##class(Security.SSLConfigs).Create(host)
  }
  QUIT host
}

ClassMethod getRequest(host As %String) As %Net.HttpRequest
{
    set req = ##class(%Net.HttpRequest).%New()
    set req.Server = host
    set req.Https = 1
    set req.SSLConfiguration = ..GetSSLConfiguration(req.Server)
    return req
}

ClassMethod auth()
{
    set code = %request.Data("code",1)

    /// get access_token
    set req = ..getRequest("github.com")
    set req.ContentType = "application/json"
    do req.SetHeader("Accept","application/json")
    
    
    set data = { 
        "client_id": ($get(^github("clientid"))),
        "client_secret": ($get(^github("secret"))),
        "code": (code)
    }

    
    do req.EntityBody.Write(data.%ToJSON())
    set sc = req.Post("login/oauth/access_token")
    

    set accessjo = {}.%FromJSON(req.HttpResponse.Data)
    

    set req = ..getRequest("api.github.com")
    do req.SetHeader("Authorization","Bearer " _ accessjo."access_token")
    set sc = req.Get("user")
    
    set userjo = {}.%FromJSON(req.HttpResponse.Data)
    set res = ##class(Demo.Auth.User).getUser(userjo).getJson()
    write res.%ToJSON()
    

    
    return $$$OK
}

}
