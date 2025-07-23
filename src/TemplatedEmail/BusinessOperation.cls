Class TemplatedEmail.BusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Property TemplateFolder As %String;

Parameter SETTINGS As %String = "TemplateFolder:Templates:directorySelector";

Parameter INVOCATION = "Queue";

Method SendEmail(
	pRequest As TemplatedEmail.EmailRequest,
	Output pResponse As Ens.Response) As %Status
{
    try {
        set mailMessage = ##class(TemplatedEmail.MailMessage).%New()
        set dir = ##class(%File).NormalizeDirectory(..TemplateFolder)
        $$$ThrowOnError(mailMessage.applySubjectTemplate(pRequest.Data, pRequest.SubjectTemplate, dir_pRequest.SubjectTemplateFilename))
        $$$ThrowOnError(mailMessage.applyBodyTemplate(pRequest.Data, pRequest.BodyTemplate, dir_pRequest.BodyTemplateFilename))

        do mailMessage.setRecipients(pRequest.Recipients)
        set mailMessage.From = pRequest.FromAddress
        
        return ..Adapter.SendMail(mailMessage)
    } catch ex {
        return ex.AsStatus()
    }
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="TemplatedEmail.EmailRequest">
    <Method>SendEmail</Method>
  </MapItem>
</MapItems>
}

}
