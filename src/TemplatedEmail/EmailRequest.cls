Class TemplatedEmail.EmailRequest Extends Ens.Request
{

/// data that will be used while rendering Templates
/// 
/// BodyTemplate:
///     <h2>Hi {{user.name}}!</h2><p>You won {{amount}} coins!</p>
/// 
/// SubjectTemplate:
///     Find out how much you won in the contest {{contest.name}}
/// 
/// Data:
/// {   
///     "contest": {
///         "name": "Contest Name"
///     },
///     "user": {
///         "name": "Real UserName"
///     },
///     "amount": 1000000
/// } 
Property Data As %DynamicObject [ Required ];

/// On of BodyTemplateFilename or BodyTemplate must be specified
/// file name (directory should be defined in BusinessOperation Settings)
Property BodyTemplateFilename As %String;

Property BodyTemplate As %String(MAXLEN = "");

/// file name (directory should be defined in BusinessOperation Settings)
Property SubjectTemplateFilename As %String;

Property SubjectTemplate As %String(MAXLEN = "");

/// Comma and/or semicolon separated list of recipients
Property Recipients As %String(MAXLEN = "");

/// From address to put in sent mail messages
Property FromAddress As %String(MAXLEN = 200);

Storage Default
{
<Data name="Data">
<Attribute>Data</Attribute>
<Structure>node</Structure>
<Subscript>"TemplatedEmail.EmailRequest.Data"</Subscript>
</Data>
<Data name="EmailRequestDefaultData">
<Subscript>"EmailRequest"</Subscript>
<Value name="1">
<Value>BodyTemplateFilename</Value>
</Value>
<Value name="2">
<Value>BodyTemplate</Value>
</Value>
<Value name="3">
<Value>SubjectTemplateFilename</Value>
</Value>
<Value name="4">
<Value>SubjectTemplate</Value>
</Value>
<Value name="5">
<Value>Recipients</Value>
</Value>
<Value name="6">
<Value>FromAddress</Value>
</Value>
</Data>
<DefaultData>EmailRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
