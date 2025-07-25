Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="Namespace" Value="IRISAPP"/>
  <Default Name="app" Value="irisapp" />

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="1">

    <Configuration>
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32" />
  </Namespace>

  <Invoke Class="App.Installer" Method="createRESTApp" CheckStatus="1">
    <Arg Value="${Namespace}"/>
  </Invoke>
  
  

</Manifest>
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

  return $$$ADDSC(sc, sc1)
}

ClassMethod setup(
	ByRef pVars,
	pLogLevel As %Integer = 3,
	pInstaller As %Installer.Installer,
	pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
