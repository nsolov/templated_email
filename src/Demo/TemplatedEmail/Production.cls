Class Demo.TemplatedEmail.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.TemplatedEmail.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="TestProcess" Category="" ClassName="Demo.TemplatedEmail.TestProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="emails" Category="" ClassName="TemplatedEmail.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TemplateFolder">/home/irisowner/dev/templates/</Setting>
    <Setting Target="Adapter" Name="Credentials">nsolov</Setting>
    <Setting Target="Adapter" Name="SMTPPort">465</Setting>
    <Setting Target="Adapter" Name="SMTPServer">mail.nsolov.com</Setting>
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">1</Setting>
    <Setting Target="Adapter" Name="SSLConfig">pm.community.intersystems.com</Setting>
  </Item>
</Production>
}

}
