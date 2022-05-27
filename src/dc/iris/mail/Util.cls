Include Mail

Class dc.iris.mail.Util
{

ClassMethod DebugMM(strMessage As %String = "") As %Status
{
	//Set ^TESTmm($I(^TESTmm))=$ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	$$$TRACE(strMessage)
	Quit $$$OK
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	//Set ^TESTmail($I(^TESTmail))=$ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	$$$TRACE(strMessage)
	Quit $$$OK
}

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod DebugStatus(pStatus As %Status) As %Status
{
	Set tStatus = ..StatusToText(pStatus)
	Quit ..DebugTEST(tStatus)
}

ClassMethod InitMessageID(pMessageID As %String = "") As %Status
{
	If ($Get(^irisMessageID) '= "") Quit $$$ERROR($$$GeneralError,"MessageID already set.")
	Set ^irisMessageID = pMessageID  // Initial Value
	Quit $$$OK
}

ClassMethod GenerateMessageDate(pDomain As %String = "") As %String
{
	// Example: "Date: 31 Mar 2020 12:04:01 -0500 (CDT)"
	Set tDate = $ZDateTime($Horolog,2)
	Set tFormatted = "Date: " _ tDate _ " -0500 (CDT)"
	Quit tFormatted
}

ClassMethod GenerateMessageID(pDomain As %String = "") As %String
{
	If ($Get(^irisMessageID) = "") Set ^irisMessageID = 0  // Initial Value
	Set tID = $Increment(^irisMessageID)
	Quit tID
}

ClassMethod GenerateMessageIDFormatted(pDomain As %String = "") As %String
{
	Set tID = ..GenerateMessageID()
	Quit ..GetFormattedMessageID(tID,pDomain)
}

ClassMethod GetFormattedMessageID(
	pMessageID As %String = "",
	pDomain As %String = "") As %String
{
	// Example: "Message-ID: <1189.3200331@DMLSS.VA.GOV>"
	If ($Get(pMessageID) = "") Set pMessageID = 0  // Initial Value
	Set tID = pMessageID _ ".3" _ $Extract($ZDate($Horolog,8),3,8)
	Set tFormatted = "Message-ID: <" _ tID _ "@" _ pDomain _ ">"
	Quit tFormatted
}

}
