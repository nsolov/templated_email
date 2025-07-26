Class Demo.Auth.Session Extends %Persistent
{

Property Session As %String [ Required ];

Property User As Demo.Auth.User [ Required ];

Storage Default
{
<Data name="SessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Session</Value>
</Value>
<Value name="3">
<Value>User</Value>
</Value>
</Data>
<DataLocation>^Demo.Auth.SessionD</DataLocation>
<DefaultData>SessionDefaultData</DefaultData>
<IdLocation>^Demo.Auth.SessionD</IdLocation>
<IndexLocation>^Demo.Auth.SessionI</IndexLocation>
<StreamLocation>^Demo.Auth.SessionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
