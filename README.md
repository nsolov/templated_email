# templated_email
InterSystems IRIS module for sending Jinja2-based emails

## Overview
This module provides an Interoperability Business Operation and utility classes to render email templates using Jinja2 + Markdown, and send them via email.

It is designed to work both within InterSystems Interoperability productions and from standalone ObjectScript code, making it suitable for a wide range of use cases.

## Installation

```bash
npm install templated-email
```

## Quick Start

### Using the package within Interoperability productions
1. Install the package
2. Create credentials `http://{hostname}:{port}/csp/user/EnsPortal.Credentials.zen` to access SMTP server
3. Add Business Operation [TemplatedEmail.BusinessOperation](src/TemplatedEmail/BusinessOperation.cls) to your production.
4. On the Production configuration page, configure the Business Operation as you would for any operation using the EnsLib.EMail.OutboundAdapter:
- Set the SMTP server, port, credentials, etc.
- Additionally, you may specify the TemplateFolder setting to define the directory where your templates are stored (optional)
5. Use [TemplatedEmail.EmailRequest](src/TemplatedEmail/EmailRequest.cls) to trigger the operation

### Using from ObjectScript

Anywhere in your ObjectScript code where you use %Net.MailMessage, you can replace it with [TemplatedEmail.MailMessage](src/TemplatedEmail/MailMessage.cls).

This extended class provides two additional methods:
 - applyBodyTemplate() — renders and sets the email body using a Jinja2 + Markdown template
 - applySubjectTemplate() — renders and sets the email subject using a Jinja2 template

This allows you to easily integrate dynamic templated content into your emails.

### Components Description
1. **TemplatedEmail.TemplateService** - utility class that contents methods for templates processing
2. **TemplatedEmail.EmailRequest** - Interoperbility Message for Business Operation
   - *Data:%DynamicObject* - data that will be used while rendering Templates
   - *BodyTemplateFilename:%String* - path to the mail template
   - *BodyTemplate:%String* - mail template text. One of BodyTemplateFilename or BodyTemplate must be specified
   - *SubjectTemplateFilename:%String* - path to the mail template
   - *SubjectTemplate:%String* - mail template text. One of SubjectTemplateFilename or SubjectTemplate must be specified
   - *Recipients:%String* - Comma and/or semicolon separated list of recipients
   - *FromAddress:%String* - From address to put in sent mail messages
3. **TemplatedEmail.BusinessOperation** - Business Operation for processing and sending template emails
4. **TemplatedEmail.MailMessage** - inheritant of the %Net.MailMessage for use in Business Operation

## Demo
### Local
1. Clone the repository
```bash
git clone https://github.com/nsolov/templated_email.git
```
2. Build the container
```bash
docker compose up -d
```
3. Create credentials (http://localhost:52796/csp/user/EnsPortal.Credentials.zen) to access SMTP server
![set_creds](https://github.com/nsolov/templated_email/blob/master/imgs/set_creds.png)
4. On Production configuration page for "emails" Business Operation specify your smtp server, port and credentials
(http://localhost:52796/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=Demo.TemplatedEmail.Production)
![setup_bo](https://github.com/nsolov/templated_email/blob/master/imgs/setup_bo.png)
6. Run production
7. Run Test for TestProcess
   - specify your for credentials in **From** field
   - specify your recipient in **To** field
   - select "file" or "string" option
     
   ![test_bo](https://github.com/nsolov/templated_email/blob/master/imgs/test_bo.png)


### Online Demo
Look for the link in the OEX Package
![online_demo](https://github.com/nsolov/templated_email/blob/master/imgs/online_demo.gif)

## Requirements
- InterSystems IRIS 2023.1+

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

-   [IRIS Documentation](https://docs.intersystems.com/)
-   [GitHub Issues](https://github.com/nsolov/templated_email/issues)
