Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="/opt/irisbuild/src"/>
  <Default Name="Namespace" Value="MAIL"/>
  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="${Namespace}" Dir="/opt/irisbuild" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
  </Namespace>
  <Namespace Name="%SYS" Create="no">
    <If Condition='(##class(%File).Exists("/opt/irisbuild/%ZSTART.mac")=1)'>
      <Import File="/opt/irisbuild/%ZSTART.mac" Flags="ck" Recurse="1"/>
    </If>
  </Namespace>
  <RunInstall Class="App.Installer" Method="SetAutoStart"/>
</Manifest>
}

ClassMethod SetAutoStart(
	ByRef pVars,
	pLogLevel,
	tInstaller) As %Status
{
  Set Namespace = tInstaller.Evaluate("${Namespace}")
  Do tInstaller.PushNS(Namespace)
  Set tSC = $$$OK
  Try {
    Set ^Ens.AutoStart = "dc.iris.mail.Production"
    Set ^Ens.AutoStart("StartupPriority") = 0
  } Catch { }
  Do tInstaller.PopNS()
  If $$$ISERR(tSC) Throw ##class(%Installer.Exception).CreateFromStatus(tSC)
  Quit $$$OK
}

ClassMethod setup(
	ByRef pVars,
	pLogLevel As %Integer = 3,
	pInstaller As %Installer.Installer,
	pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
