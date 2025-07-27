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
    <Route Url="/templates/:name" Method="GET" Call="getTemplate" />
    <Route Url="/templates" Method="POST" Call="saveTemplate" />
    <Route Url="/send" Method="POST" Call="sendEmail"/>

    <Route Url="/github-auth" Method="GET" Call="auth"/>

</Routes>
}

ClassMethod getTemplate(name As %String) As %Status
{
    set fullname = ..#HOMEDIR_name
    if '##class(%File).Exists(fullname) {
        $$$ThrowStatus($$$ERROR(1101, name))
    }
    set %response.ContentType = "text/plain"
    set stream=##class(%Stream.FileCharacter).%New()
    set sc=stream.LinkToFile(fullname)
    while 'stream.AtEnd {
        write stream.Read()
    }
    return $$$OK
}

ClassMethod getTemplates() As %Status
{
    set stmt = ##class(%SQL.Statement).%New()
    set sc = stmt.%PrepareClassQuery("%File", "FileSet")
    return:$$$ISERR(sc) sc
    set rset = stmt.%Execute(..#HOMEDIR, "*.tpl", "Name")

    set res = []
    while rset.%Next() {
        set item = {
            "name":($p(rset.%Get("Name"), "/", *)),
            "data": "{}"
        }
        if (item.name = "reminder_body.tpl") {
            set data = {
                "name": "John Doe",
                "session": {
                    "date": "2025-08-05",
                    "time": "10:00 AM",
                    "link": "https://wellivia.com/session/12345"
                },
                "service": {
                    "name": "Mindful Yoga Session"
                },
                "coach": {
                    "name": "Sophie Green"
                },
                "year": "2025"
            }
            set item.data = data.%ToJSON()
            set item.subject = "Reminder: {{service.name}} with {{coach.name}} on {{session.date}}"
        } else {
            /// read template and generate data 
            set template = ""
            set stream=##class(%Stream.FileCharacter).%New()
            set sc=stream.LinkToFile(..#HOMEDIR_item.name)
            while 'stream.AtEnd {
                set template = template _ stream.Read()
            }
            set item.data = ##class(TemplatedEmail.TemplateService).getJinjaSchema(template)
        }
        
        do res.%Push(item)
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
    set session = ""
    set tKey = ""
    for {
        set tKey = $ORDER(%request.CgiEnvs(tKey))
        quit:tKey=""
        if (tKey = "HTTP_AUTHORIZATION") {
            set session = $piece(%request.CgiEnvs(tKey)," ",2)
        }
    }

    set user = ##class(Demo.Auth.User).SessionIndexOpen(session)
    if ('$isobject(user) ) {
        return $$$ERROR(5001,"User Not Found")
    }

    set content = ##class(%Library.DynamicObject).%FromJSON(%request.Content)

    set msg = ##class(TemplatedEmail.EmailRequest).%New()
    set msg.Recipients = user.Email
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
