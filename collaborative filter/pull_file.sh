#!/usr/bin/expect -f

#wonderyao 2010.12.22

set timeout -1

set source [lindex $argv 0]
set destiny [lindex $argv 1]
set password [lindex $argv 2]

spawn /usr/local/bin/scp2 -P 36000 -q $source $destiny
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
