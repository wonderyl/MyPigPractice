#!/usr/bin/expect -f

#wonderyao 2011.05.15

set timeout -1

set destiny [lindex $argv 0]
set password [lindex $argv 1]
set command [lindex $argv 2]

spawn /usr/local/bin/ssh2 -p36000 $destiny $command
expect {
        "*(yes/no)*" { 
                send "yes\r" 
                expect "*assword*" 
                sleep 1
                send "$password\r"
        }

        "*assword*" {
                sleep 1
                send "$password\r"
        }
}
expect eof

exit 0
