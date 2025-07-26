# templated_email
InterSystems Interoperability Business Operation module for sending templated Jinja2 emails

## Overview
This package provides Business Operation and utils to process Jinja2+Markdown Templates and send them via emails.

## Installation

```bash
npm install templated-email
```

## Quick Start

### Using the package
1. Install the package
2. Create credentials `http://{hostname}:{port}/csp/user/EnsPortal.Credentials.zen` to access SMTP server
3. Add Business Operation [TemplatedEmail.BusinessOperation](src/TemplatedEmail/BusinessOperation.cls) to your production
4. Use [TemplatedEmail.MailMessage](src/TemplatedEmail/EmailRequest.cls) to start the operation
5. On Production configuration page for "emails" business operation specify your smtp server, port and credentials

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
4. On Production configuration page for "emails" Business Operation specify your smtp server, port and credentials
(http://localhost:52796/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=Demo.TemplatedEmail.Production)
5. Run production
6. Run Test for TestProcess
   - specify your for credentials in **From** field
   - specify your recipient in **To** field
   - select "file" or "string" option


### Online

## Requirements
-   InterSystems IRIS 2023.1+

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