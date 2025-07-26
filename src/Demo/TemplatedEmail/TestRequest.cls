Class Demo.TemplatedEmail.TestRequest Extends Ens.Request
{

Property TemplateType As %String(VALUELIST = ",string,file");

Property To As %String(MAXLEN = "");

Property From As %String(MAXLEN = "");

Storage Default
{
<Data name="TestRequestDefaultData">
<Subscript>"TestRequest"</Subscript>
<Value name="1">
<Value>TemplateType</Value>
</Value>
<Value name="2">
<Value>To</Value>
</Value>
<Value name="3">
<Value>From</Value>
</Value>
</Data>
<DefaultData>TestRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
