Include Mail

Class dc.iris.mail.TCPTextLineInboundAdapter Extends (dc.iris.mail.TCPInboundAdapter, dc.iris.mail.TCPTextLineCommon) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter SERVICEINPUTCLASS = "Ens.StringContainer";

Parameter SERVICEOUTPUTCLASS = "Ens.StringContainer";

/* override (empty) superclass initial Terminators value */
Property Terminators As %String [ InitialExpression = {$C(10)} ];

Method OnConnected() As %Status
{
	$$$sysTRACE("dc.iris.mail.TCPTextLineInboundAdapter OnConnected")

	Set tQuitErr=1  Do {
		Set tSC=..ReadLine(.tInStr,..CallInterval,1)
		$$$sysTRACE("Status:"_tSC)
		If $$$ISERR(tSC) {
			If ..IsReadError(tSC) {
				Set tSC=$$$ERROR($$$EnsErrInConnectionLost,"TCP Read Line",..IOAddr,$$$StatusDisplayString(tSC))
				Set tQuitErr=0  Do ..Disconnect()
				If ""=tInStr Set tTxt=$$$StatusText(tSC), tSC=$$$OK  If ..StayConnected<0 { $$$LOGWARNING(tTxt) } ElseIf ..%logConnections { $$$LOGINFO(tTxt) } Else { $$$sysTRACE(tTxt) } ; change error to info if lost connection with no data and trying to stay connected
			} ElseIf $$$StatusEquals(tSC,$$$EnsErrTCPTerminatedReadTimeoutExpired) {
				If ""=tInStr { Set tSC=$$$OK } ; no error if timed out with no data
				Else { Set tQuitErr=0 }
			}
			Quit
		}
		$$$ANEWINIOLOGENTRY($$$OK,"TCP ReadLine on :"_..IOAddr,tInStr)
		Set tSC=..BusinessHost.ProcessInput(##class(Ens.StringContainer).%New(tInStr), .tStringOut)  Quit:$$$ISERR(tSC)
		$$$sysTRACE("tStringOut "_tStringOut)
		If $D(tStringOut) {
			If $IsObject(tStringOut) {
				$$$ASSERT(tStringOut.%Extends("Ens.StringContainer"))
				Set tStringOut=tStringOut.StringValue
			}
		} Else { Set tStringOut="" }
		If $$$ISERR(tSC) {
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP TextLine ProcessInput error on :"_..IOAddr,tStringOut)
			Quit
		}
		If ""'=tStringOut {
			#;$$$sysTRACE("Returning Output String '"_tStringOut_"'")
			Set tSC=..WriteLine(tStringOut,1)
			$$$sysTRACE("Status:"_tSC)
			Set tDisconnect = $Extract($$$MMResponseQUIT,1,3)
			If (tDisconnect	= $Extract(tStringOut,1,3)) {
				$$$sysTRACE("We are going to Disconnect.")
				Do ..Disconnect()
			}
			If $$$ISERR(tSC) {
				If ..IsWriteError(tSC) {
					Set tSC=$$$ERROR($$$EnsErrInConnectionLost,"TCP Write Line",..IOAddr,$$$StatusDisplayString(tSC))
					Set tQuitErr=0  Do ..Disconnect()
				}
				$$$ACLOSEIOLOGENTRY(tSC,"after TCP WriteLine error on :"_..IOAddr,tStringOut)
				Quit
			}
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP WriteLine on :"_..IOAddr,tStringOut)
		} Else {
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP ProcessInput on :"_..IOAddr,"")
		}
	} While 0
	$$$sysTRACE("Status at end of OnConnected is "_##class(dc.iris.mail.Util).StatusToText(tSC))
	$$$sysTRACE("Status:"_tSC)
	#; Returning error status would cause this listener job to terminate
	If $$$ISERR(tSC) {
		#; Never quit the listener, but drop the connection on unrecognized error
		If tQuitErr&&..Connected&&..StayConnected { $$$LOGERROR("Disconnecting due to "_$$$StatusDisplayString(tSC)) Set tSC=$$$OK  Do ..Disconnect() }
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
		If $$$ISERR(tSC) $$$sysTRACE(tSC)
	}
	Quit $$$OK
}

}
