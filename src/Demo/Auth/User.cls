Class Demo.Auth.User Extends %Persistent
{

/// Description
Property Email As %String(MAXLEN = 1000);

Property Name As %String(MAXLEN = 1000);

Property Session As %String(MAXLEN = 1000);

Index SessionIndex On Session [ Unique ];

Index EmailIndex On Email [ Unique ];

ClassMethod getUser(userjo As %DynamicObject) As Demo.Auth.User
{
    set user = ..EmailIndexOpen(userjo."email")
    if ('$isobject(user)) {
        set user = ..%New()
        set user.Email = userjo."email"
        set user.Name = userjo."name"
        set user.Session = $system.Util.CreateGUID()
        do user.%Save()
    }
    return user
}

Method getJson()
{
    return {
        "name":(..Name),
        "email":(..Email),
        "session":(..Session)
    }
}

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
<Value name="4">
<Value>Session</Value>
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
