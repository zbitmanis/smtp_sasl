#!/usr/bin/expect
set mailserver [lrange $argv 0 0]
set from [lrange $argv 1 1]
set to [lrange $argv 2 2]
set auth [lrange $argv 3 3]
set host [lrange $argv 4 4]

spawn telnet $mailserver 25
expect "failed" {
                send_user "$mailserver: connect failed\n"
                exit    
        } "2?? *" {
        } "4?? *"   {
                exit
        } "refused" {
                send_user "$mailserver: connect refused\n"
                exit
        } "closed" {
                send_user "$mailserver: connect closed\n"
                exit
        } timeout {
                send_user "$mailserver: connect to port 25 timeout\n"
                exit
        }

send "EHLO $host\r"
expect "2?? *" {
} "5?? *" {
        exit
} "4?? *" {
        exit
}

send "AUTH LOGIN\r"
expect "334 *"  {
} "5?? *" {
 exit
} "4?? *" {
exit
}   

send "$auth\r"
expect "334 *"  {
} "5?? *" {
 exit
} "4?? *" {
exit
}   

send "$auth\r"
expect "334 *"  {
} "5?? *" {
 exit
} "4?? *" {
exit
}   

send "MAIL FROM: <$from>\r"
expect "2?? *"  {
} "5?? *" {
        exit
} "4?? *" {
        exit
}
send "RCPT TO: <$to>\r"
expect "2?? *" {
} "5?? *" {
        exit
} "4?? *" {
        exit
}
#send "RCPT TO: <$to1>\r"
#expect "2?? *" {
#} "5?? *" {
#        exit
#} "4?? *" {
#        exit
#}
send "DATA\r"
expect "3?? *" {
} "5?? *" {
        exit
} "4?? *" {
        exit
}
send "From: $from\r"
send "To: $to\r"
#send "CC: $to1\r"
send "Subject: test\r"
send "This is a test message\r"
send ".\r"
expect "2?? *" {
} "5?? *" {
        exit
} "4?? *" {
        exit
}
send "QUIT\r"
exit

