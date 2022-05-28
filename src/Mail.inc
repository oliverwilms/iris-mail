#include Ensemble

#; Mail
#Define smtpOnAfterGR(%l)	Do ..OnAfterGetResponse(%l)
#Define Space				$Char(32)
#Define MMfindDOMAIN		"MAILDOMAIN"
#Define MailDomain(%t,%md)	$REPLACE(%t,$$$MMfindDOMAIN,%md)
#Define MMReady				"220 MAILDOMAIN iris-mail 8.0 ready"
#Define MMResponseData		"354 Enter data"
#Define MMResponseDefault	"250 OK"
#Define MMResponseHELO		"250 OK MAILDOMAIN [8.0,DUP,SER,FTP]"
#Define MMResponseDataAcpt  "250 'data' accepted"
#Define MMResponseQUIT		"221 MAILDOMAIN Service closing transmission channel"
#Define MMResponseTURN		"502 MAILDOMAIN has no messages to export"
#Define terminator			$Char(10)
#Define timeout				1
