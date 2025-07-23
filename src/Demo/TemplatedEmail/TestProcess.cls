Class Demo.TemplatedEmail.TestProcess Extends Ens.BusinessProcess
{

Method OnRequest(
	pRequest As Demo.TemplatedEmail.TestRequest,
	Output response As %Library.Persistent) As %Status
{
    set tRequest = ##class(TemplatedEmail.EmailRequest).%New()
    set tRequest.Recipients = pRequest.To
    
    set tRequest.FromAddress = "nsolov@nsolov.com"
    
    if (pRequest.TemplateType = "string") {
        set tRequest.Data = { 
            "contest": {
                "name": "Contest Name"
            },
            "user": {
                "name": "Real UserName"
            },
            "amount": 1000000
        }
        set tRequest.BodyTemplate = "<!DOCTYPE html><html><body><h2>Hi {{user.name}}!</h2><p>You won {{amount}} coins!</p></body></html>"
        set tRequest.SubjectTemplate = "Find out how much you won in the contest {{contest.name}}"
    } elseif (pRequest.TemplateType = "file") {
        set tRequest.Data = {
            "name": "John Doe",
            "appointment_date": "2025-08-05",
            "appointment_time": "14:30",
            "doctor_name": "Emily Carter",
            "appointment_link": "https://wellivia.com/appointments/view/12345",
            "year": "2025"
        }
        set tRequest.BodyTemplateFilename = "reminder_body.tpl"
        set tRequest.SubjectTemplateFilename = "reminder_subject.tpl"
    }
    
    Set tSC = ..SendRequestSync("emails", tRequest, .tResponseFromBO)
    
    return tSC
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
