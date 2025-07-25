/// Only for demo
Class Demo.TemplatedEmail.REST Extends %CSP.REST
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
        do res.%Push($p(rset.%Get("Name"), "/", *))
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

}
