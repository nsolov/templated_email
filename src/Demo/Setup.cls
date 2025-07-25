Class Demo.Setup Extends %RegisteredObject
{

ClassMethod Setup() As %Status
{
    set sc = ##class(Demo.Setup).createRESTApp($namespace)
    set sc = ##class(Demo.Setup).createWebApp($namespace)
    return:$$$ISERR(sc) sc

    return sc
}

ClassMethod createWebApp(namespace) As %Status
{
  zn "%SYS"
  write "Create web application / ...", !
  set webName = "/"
  set webProperties("NameSpace") = namespace
  set webProperties("Enabled") = 1
  set webProperties("AutheEnabled") = 64
  set webProperties("Path") = "/home/irisowner/dev/web"
  set sc = ##class(Security.Applications).Create(webName, .webProperties)
  
  write sc, !
  write "Web application "_ webName _" has been created!", !
  zn namespace
  return sc
}

ClassMethod createRESTApp(namespace) As %Status
{
  zn "%SYS"
  write "Create web application /api ...", !

  set webName = "/api"
  set webProperties("DispatchClass") = "Demo.TemplatedEmail.REST"
  set webProperties("NameSpace") = namespace
  set webProperties("Enabled") = 1
  set webProperties("AutheEnabled") = 64
  set webProperties("MatchRoles") = ":%DB_" _ namespace

  set sc = ##class(Security.Applications).Create(webName, .webProperties)
  write sc, !
  write "Web application "_ webName _" has been created!", !

  set sc1 = ##class(Security.Users).AddRoles("UnknownUser", ":%DB_" _ namespace)
  zn namespace
  return $$$ADDSC(sc, sc1)
}

}
