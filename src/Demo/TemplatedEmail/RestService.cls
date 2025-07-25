Class Demo.TemplatedEmail.RestService Extends Ens.BusinessService
{

Method OnProcessInput(
	pInput As TemplatedEmail.EmailRequest,
	Output pOutput As %RegisteredObject) As %Status
{
    return ..SendRequestAsync("emails", pInput)
}

}
