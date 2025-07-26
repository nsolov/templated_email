Class Demo.Setup Extends %RegisteredObject
{

ClassMethod Setup() As %Status
{
    set sc = ##class(Demo.Setup).createRESTApp($namespace)
    return:$$$ISERR(sc) sc
    set sc = ##class(Demo.Setup).createWebApp($namespace)
    return:$$$ISERR(sc) sc

    set ^github("clientid") = ""
    set ^github("secret") = ""

    if $SYSTEM.Util.GetEnviron("INSTANCE_DEST") = "LOCAL" {
        set sc = ##class(Demo.Setup).setDefaultPassword()
    }

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
  set webProperties("DispatchClass") = "Demo.REST"
  set webProperties("NameSpace") = namespace
  set webProperties("Enabled") = 1
  set webProperties("AutheEnabled") = 64
  set webProperties("MatchRoles") = ":%ALL"

  set sc = ##class(Security.Applications).Create(webName, .webProperties)
  write sc, !
  write "Web application "_ webName _" has been created!", !

  set sc1 = ##class(Security.Users).AddRoles("UnknownUser", ":%DB_" _ namespace)
  zn namespace
  return $$$ADDSC(sc, sc1)
}

ClassMethod setDefaultPassword() As %Status
{
  write "Set default password", !

  set sc = $$$OK

  set namespace = $namespace
  zn "%SYS"

  // It's better to fix it when have a time
  set password = "SYS"

  for user = "_SYSTEM", "Admin", "SuperUser" {
    if ##class(Security.Users).Exists(user) {
      do $system.Security.ChangePassword(user, password,,.sc)
      set prop("ChangePassword") = 0
      do ##class(Security.Users).Modify(user, .prop)
      return:$$$ISERR(sc) sc
    }
  }

  write "Password was changed", !

  zn namespace

  return sc
}

}
