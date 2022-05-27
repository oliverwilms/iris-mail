Class dc.iris.mail.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.iris.mail.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Mail Service" Category="" ClassName="dc.iris.mail.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="Port">30025</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Mail Operation</Setting>
  </Item>
  <Item Name="Mail Operation" Category="" ClassName="dc.iris.mail.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="From">iris@mail.dc.gov</Setting>
    <Setting Target="Adapter" Name="Recipient">Oliver.Wilms@dc.gov</Setting>
    <Setting Target="Adapter" Name="SMTPPort">25</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.dc.gov</Setting>
  </Item>
</Production>
}

}
