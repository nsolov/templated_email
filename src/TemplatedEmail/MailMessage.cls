Class TemplatedEmail.MailMessage Extends %Net.MailMessage
{

/// one of the subjectTemplate or subjectTemplateFile must be specified:
/// - subjectTemplate - a string containing the inline template
/// - subjectTemplateFile - full path to the template file
Method applySubjectTemplate(
	data As %Library.DynamicObject,
	subjectTemplate As %String,
	subjectTemplateFile As %String) As %Status
{
    try {
        if (subjectTemplate = "") {
            if (subjectTemplateFile'="") {
                if ##class(%File).Exists(subjectTemplateFile) {
                    set stream=##class(%Stream.FileCharacter).%New()
                    set sc=stream.LinkToFile(subjectTemplateFile)
                    while 'stream.AtEnd {
                        set subjectTemplate = subjectTemplate _ stream.Read()
                    }
                } else {
                    $$$ThrowStatus($$$ERROR(5001, "File subjectTemplateFile(" _ subjectTemplateFile _ ") doesn't exist"))

                }
            } else {
                $$$ThrowStatus($$$ERROR(5001, "On of subjectTemplate or subjectTemplateFile must not be empty "))
            }
        }

        set ..Subject = ##class(TemplatedEmail.TemplateService).pyRenderJinjaTemplate(subjectTemplate, data)

        set ..IsHTML = 1

        return $$$OK
    } catch ex {
        return ex.AsStatus()
    }
}


/// one of the bodyTemplate or bodyTemplateFile must be specified:
/// - bodyTemplate - a string containing the inline template
/// - bodyTemplateFile - full path to the template file
Method applyBodyTemplate(
	data As %Library.DynamicObject,
	bodyTemplate As %String,
	bodyTemplateFile As %String) As %Status
{
    try {
        if (bodyTemplate = "") {
            if (bodyTemplateFile'="") {
                if ##class(%File).Exists(bodyTemplateFile) {
                    set stream=##class(%Stream.FileCharacter).%New()
                    set sc=stream.LinkToFile(bodyTemplateFile)
                    while 'stream.AtEnd {
                        set bodyTemplate = bodyTemplate _ stream.Read()
                    }
                } else {
                    $$$ThrowStatus($$$ERROR(5001, "File subjectTemplateFile(" _ bodyTemplateFile _ ") doesn't exist"))

                }
            } else {
                $$$ThrowStatus($$$ERROR(5001, "On of bodyTemplate or bodyTemplateFile must not be empty "))
            }
        }

        set body = ##class(TemplatedEmail.TemplateService).pyRenderJinjaTemplate(bodyTemplate, data)
        set inlinedBody = ##class(TemplatedEmail.TemplateService).pyCssInliner(body)

        do ..TextData.Rewind()
        do ..TextData.Write(inlinedBody)

        set ..IsHTML = 1

        return $$$OK
    } catch ex {
        return ex.AsStatus()
    }
}


Method setRecipients(recipients As %String) As %Status
{
    set recipients = $translate(recipients,";",",")
    set rlist = $listfromstring(recipients, ",")
    for i=1:1:$listlength(rlist) {
        do ..To.Insert($list(rlist, i))
    }
    return $$$OK
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
