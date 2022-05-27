Include Mail

Class dc.iris.mail.Service Extends Ens.BusinessService [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "dc.iris.mail.TCPTextLineInboundAdapter";

/// Configuration item(s) to which to send file stream messages
Property TargetConfigNames As %String(MAXLEN = 1000);

/// Should we let the client know that we got the message?
Property SendAcknowledgement As %Boolean [ InitialExpression = 1 ];

/// Host domain to use for SMTP communication
Property MailDomain As %String;

Parameter SETTINGS = "MailDomain,TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Parameter CONTAINERCLASS = "Ens.StreamContainer";

/// pInput contains the incoming line of text
/// pOutput contains the outgoing response (if any)
Method OnProcessInput(
	pInput As Ens.StringContainer,
	pOutput As Ens.StringContainer) As %Status
{
	#Dim %EmailRequest As dc.iris.mail.EmailRequest
	$$$sysTRACE("dc.iris.mail.TCPMailmanService OnProcessInput")
	//$$$sysTRACE("pInput received "_pInput)
	//$$$sysTRACE("%EmailRequest is "_$Get(%EmailRequest,"UNDEFINED"))
	If '$Data(%EmailRequest) Set %EmailRequest = ##class(dc.iris.mail.EmailRequest).%New() //$$$sysTRACE("$Data - %EmailRequest is "_$Get(%EmailRequest,"UNDEFINED"))
	If '$IsObject(%EmailRequest) Set %EmailRequest = ##class(dc.iris.mail.EmailRequest).%New() //$$$sysTRACE("$IsObject - %EmailRequest is "_$Get(%EmailRequest,"UNDEFINED"))
	Set $ZT = "EXCEPTION"
	Set pResponse = ""
	Set tDataDone = 0
	Set tLine = ""
	Set tSC=$$$OK
	Do {
		Set tLine = pInput.StringValue
		Do {
			//$$$sysTRACE("INNER DO - dc.iris.mail.Util MailManResponse")
			$$$sysTRACE("<< "_$Get(tLine))
			Set uLine = $ZCONVERT($Get(tLine),"U")
			$$$sysTRACE("uLine "_uLine)
			Set tMailDomain = ..MailDomain
			Set pResponse = $$$MailDomain($$$MMResponseDefault,tMailDomain)
			$$$sysTRACE("%DataStarted "_%DataStarted)

			If (%DataStarted > 0) {
				If (uLine = ".") {
					Set tDataDone = 1
					Set %DataStarted = 0
					$$$sysTRACE("Setting %DataStarted to 0")
					Set pResponse = $$$MailDomain($$$MMResponseDataAcpt,tMailDomain)
				} Else {
					Set pResponse = ""
					If (%DataStarted > 1) {
						Set tStream = %EmailRequest.StreamGet()
						If '$IsObject(tStream) Set tStream = ##class(%GlobalCharacterStream).%New()
						Set tSC = tStream.Write(tLine_$$$terminator)
						$$$sysTRACE("Status:"_tSC)
						Set tSC = %EmailRequest.StreamSet(tStream)
						$$$sysTRACE("Status:"_tSC)
					}
					Else {
						If (uLine = "") {
							Set %DataStarted = 2  // Ready to Write to Stream
							$$$sysTRACE("Setting %DataStarted to 2 - Write to Stream")
						} Else {
							// Message-ID: <1187.3200331@DMLSS.VA.GOV>
							If ($Extract(uLine,1,11) = "MESSAGE-ID:") {
								Set %EmailRequest.SenderMessageID = $Extract(tLine,12,*)
							}
							If ($Extract(uLine,1,8) = "SUBJECT:") {
								Set %EmailRequest.Subject = $Extract(tLine,9,*)
							}
						}
					}
					Set pResponse = ""
					//$$$sysTRACE("No response because %DataStarted is 1 --> QUIT")
					Quit
				}
				//$$$sysTRACE("Break out of INNER Do --> QUIT")
				Quit
			}

			If ($Piece(uLine,$$$Space,1) = "DATA") {
				$$$sysTRACE("DATA")
				Set %DataStarted=1
				$$$sysTRACE("Setting %DataStarted to 1")
				Set pResponse = $$$MailDomain($$$MMResponseData,tMailDomain)
			}

			If $Piece(uLine,$$$Space,1) = "HELO" {
				Set pResponse = $$$MailDomain($$$MMResponseHELO,tMailDomain)
			}
			If $Piece(uLine,$$$Space,1) = "NOOP" {
				Set pResponse = $$$MailDomain($$$MMResponseDefault,tMailDomain)
			}
			If $Piece(uLine,$$$Space,1) = "MAIL" {
				Set %EmailRequest.MessageID = ##class(dc.iris.mail.Util).GenerateMessageID(tMailDomain)
				Set pResponse = "250 OK "_##class(dc.iris.mail.Util).GetFormattedMessageID(%EmailRequest.MessageID,tMailDomain)
			}
			If $Piece(uLine,$$$Space,1) = "RCPT" {
				// There may not be a space after TO:
				If $Extract(uLine,6,8) = "TO:" {
					Set tTo = $Extract(uLine,9,*)
					$$$sysTRACE("RCPT TO: "_tTo)
					//If tTo = "<POSTMASTER@DMLSSSQA1.VA.GOV>" {
					Set pResponse = "250 'RCPT' accepted"
					//}
					//Else {
					//	Set pResponse = "550 Addressee not found."
					//}
				}
			}
			If $Piece(uLine,$$$Space,1) = "RSET" {
				Set pResponse = "250"
			}
			If $Piece(uLine,$$$Space,1) = "SUBJECT:" {
				$$$sysTRACE("SUBJECT:")
				Set %EmailRequest.Subject = $Extract(tLine,9,*)
				Set pResponse = $$$MailDomain($$$MMResponseDefault,tMailDomain)
			}
			If $Piece(uLine,$$$Space,1) = "TURN" {
				Set pResponse = $$$MailDomain($$$MMResponseTURN,tMailDomain)
			}
			If $Piece(uLine,$$$Space,1) = "QUIT" {
				Set pResponse = $$$MailDomain($$$MMResponseQUIT,tMailDomain)
			}

			
			$$$sysTRACE(">> "_$Get(pResponse))

		} While (0)
		$$$sysTRACE("pResponse "_pResponse)
		Set pOutput = ##class(Ens.StringContainer).%New(pResponse)
		
	} While (0)
EXIT
	$$$sysTRACE("dc.iris.mail.TCPMailmanService OnProcessInput EXIT")
	$$$sysTRACE("tDataDone "_tDataDone)
	If (tDataDone = 0) {
		$$$sysTRACE("Status:"_tSC)
		Quit tSC
	}
	// check stream size ?
	Set tMessageID = %EmailRequest.MessageID
	$$$SyncCommitSet(tSyncCommit)
	For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		$$$sysTRACE("Sending MessageID "_tMessageID_" async to "_tOneTarget)
		$$$sysTRACE("Sending MessageID "_tMessageID_" async to "_tOneTarget)
		Set tSC1=..SendRequestAsync(tOneTarget,%EmailRequest)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
		$$$sysTRACE("Status:"_tSC1)
	}
	$$$SyncCommitClear(tSyncCommit)
	KILL %EmailRequest
	$$$sysTRACE("%EmailRequest is "_$Get(%EmailRequest,"UNDEFINED"))
	$$$sysTRACE("Status:"_tSC)
	Quit tSC
EXCEPTION
	$$$sysTRACE("dc.iris.mail.TCPMailmanService OnProcessInput EXCEPTION")
	Set $ZT = ""
	Set tSC = $$$EnsSystemError
	Goto EXIT
}

Method OnConnect(pTimeout As %Numeric) As %Status
{
	$$$sysTRACE("dc.iris.mail.TCPMailmanService OnConnect pTimeout = "_$Get(pTimeout))
	Quit 1
}

/// Override this method to provide custom error handling. Return 0 means skip standard AlertOnError behavior.
Method OnError(pStatus As %Status) As %Boolean
{
	$$$sysTRACE("dc.iris.mail.TCPMailmanService OnError")
	$$$sysTRACE("Status:"_pStatus)
	Quit 1
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(
	Output pArray As %String,
	pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
