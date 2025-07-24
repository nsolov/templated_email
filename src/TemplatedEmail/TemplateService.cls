Class TemplatedEmail.TemplateService Extends %RegisteredObject
{

/// basicTemplateFile - full filename of the basic template, that must have {{content}} block - 
///    {{content}} is replaced by HTML, generated from Markdown
/// bodyMD - Markdown string
/// newTemplateFile - full Filename where new template saved
ClassMethod buildTemplateFromMarkdown(
	basicTemplateFile As %String,
	bodyMD As %String,
	newTemplateFile As %String) As %Status
{
    try {
        // open existing basic template
        if '##class(%File).Exists(basicTemplateFile) {
            $$$ThrowStatus($$$ERROR(1101, basicTemplateFile))
        }
        set basicTemplate = ""
        set stream=##class(%Stream.FileCharacter).%New()
        set sc=stream.LinkToFile(basicTemplateFile)
        while 'stream.AtEnd {
            set basicTemplate = basicTemplate _ stream.Read()
        }
        
        // process Markdown
        set data = {"content": (..pyMarkdown(bodyMD))}
        
        set newTemplate = ..pyRenderJinjaTemplate(basicTemplate, data)
        set stream=##class(%Stream.FileCharacter).%New()
        set sc=stream.LinkToFile(newTemplateFile)
        do stream.Write(newTemplate)
        $$$ThrowOnError(stream.%Save())
        return $$$OK
    } catch ex {
        return ex.AsStatus()
    }
}

ClassMethod pyMarkdown(md As %String) As %String [ Language = python ]
{
	import re
	import html
	import pycmarkgfm as gfm

	def replace_escaped_link(match) -> str:
		content = html.unescape(match.group(1))
		return f'{{{{{content}}}}}'


	gfm_t = gfm.gfm_to_html(md, options=gfm.options.unsafe | gfm.options.hardbreaks | gfm.options.smart)

	result = re.sub(r'%7B%7B(.*?)%7D%7D',
                    replace_escaped_link,
                    gfm_t, flags=re.S)

	return result
}

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
