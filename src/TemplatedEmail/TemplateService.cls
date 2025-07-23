Class TemplatedEmail.TemplateService Extends %RegisteredObject
{

ClassMethod pyRenderJinjaTemplate(
	htmlTemplate As %String,
	data As %DynamicObject) As %String [ Language = python ]
{
    from jinja2 import Template
    import json

    tData = json.loads(data._ToJSON())
    template = Template(htmlTemplate) 

    return template.render(**tData)
}

ClassMethod renderTemplates(
	subjectTemplate As %String,
	bodyTemplate As %String,
	data As %DynamicObject,
	Output subject As %String,
	Output body As %String) As %Status
{
    set sc = $$$OK
    set (subject,body) = ""

    try {
        set body = ..pyRenderJinjaTemplate(bodyTemplate, data)
        set subject = ..pyRenderJinjaTemplate(subjectTemplate, data)
    } catch ex {
        return ex.AsStatus()
    }

    return sc
}

}
