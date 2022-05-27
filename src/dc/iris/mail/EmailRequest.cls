Class dc.iris.mail.EmailRequest Extends (Ens.StreamContainer, Ens.Request) [ StorageStrategy = "" ]
{

/// Message ID for Email message.
Property MessageID As %String;

/// Who the message is from 
Property MailFrom As %String(MAXLEN = 1000);

/// To for message, list of names to which message will be sent (SMTP) or was sent (POP3) 
Property RcptTo As %String(MAXLEN = 1000);

/// Who actually sent the message 
Property Sender As %String(MAXLEN = 1000);

/// Message ID for Email message.
Property SenderMessageID As %String;

/// Subject of message 
Property Subject As %String(MAXLEN = 1000);

Storage Default
{
<Data name="EmailRequestDefaultData">
<Subscript>"EmailRequest"</Subscript>
<Value name="1">
<Value>MessageID</Value>
</Value>
<Value name="2">
<Value>MailFrom</Value>
</Value>
<Value name="3">
<Value>RcptTo</Value>
</Value>
<Value name="4">
<Value>Sender</Value>
</Value>
<Value name="5">
<Value>SenderMessageID</Value>
</Value>
<Value name="6">
<Value>Subject</Value>
</Value>
</Data>
<DefaultData>EmailRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
