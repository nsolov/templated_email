Class Demo.Auth.User Extends %Persistent
{

/// Description
Property Email As %String;

Property Name As %String;

Index EmailIndex On Email [ Unique ];

Storage Default
{
<Data name="UserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Email</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^Demo.Auth.UserD</DataLocation>
<DefaultData>UserDefaultData</DefaultData>
<IdLocation>^Demo.Auth.UserD</IdLocation>
<IndexLocation>^Demo.Auth.UserI</IndexLocation>
<StreamLocation>^Demo.Auth.UserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
