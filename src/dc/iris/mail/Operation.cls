Class dc.iris.mail.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Parameter INVOCATION = "Queue";

/// To be used in place of localhost when using Mailman server.
Property MailDomain As %String;

Parameter SETTINGS = "MailDomain";

Method SendMessage(
	pRequest As dc.iris.mail.EmailRequest,
	Output pResponse As Ens.Response) As %Status
{
	Set pResponse = $$$NULLOREF
	$$$sysTRACE("dc.iris.mail.Operation SendMessage")
	If '$IsObject(pRequest.Stream) {
		$$$LOGWARNING("No Stream contained in StreamContainer Request") 
		Quit $$$OK
	}
	$$$sysTRACE("pRequest received "_pRequest)
	$$$sysTRACE("pRequest.OriginalFilename "_pRequest.OriginalFilename)
	$$$sysTRACE("pRequest.Stream "_pRequest.Stream)
	$$$sysTRACE("pRequest.Stream.Size "_pRequest.Stream.Size)
	$$$sysTRACE("Adapter.SMTPServer "_..Adapter.SMTPServer)
	$$$sysTRACE("Adapter.Recipient "_..Adapter.Recipient)
	Set email=##class(%Net.MailMessage).%New()
	Set tSC = email.ContentTransferEncodingSet("7bit")
	$$$sysTRACE("Status:"_tSC)
	Set tSC = email.TextData.CopyFrom(pRequest.Stream)
	$$$sysTRACE("Status:"_tSC)
	
	
	///Use Email subject from request if available
	Try {
		If (pRequest.Subject '= "") {
			Set email.Subject = pRequest.Subject
		} 
	}
	
	Catch {
		$$$sysTRACE("CATCH SendMessage")
	}
	/// If no subject in request then use the original filename
	Set:email.Subject="" email.Subject = $P($$$UPPER(##class(%File).GetFilename(pRequest.OriginalFilename)),".TXT",1)
	
	$$$sysTRACE("Adapter.SMTP.localhost "_..Adapter.SMTP.localhost)
	If (..MailDomain '= "") {
		Set ..Adapter.SMTP.localhost = ..MailDomain
		$$$sysTRACE("Adapter.SMTP.localhost "_..Adapter.SMTP.localhost)
	}
	$$$sysTRACE("before ..Adapter.SendMail")
	Set tSC=..Adapter.SendMail(email,.pFailedRecipients)
	$$$sysTRACE("after ..Adapter.SendMail")
	$$$sysTRACE("Status:"_tSC)
	Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StreamContainer"> 
		<Method>SendMessage</Method>
	</MapItem>
</MapItems>
}

}
