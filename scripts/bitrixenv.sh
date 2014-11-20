#!/usr/bin/expect -f

set timeout 600

spawn /tmp/scripts/bitrix-env.sh

expect {
   "Which version you want to install? (4|5)" {send "$env(BITRIX_VERSION)\r";exp_continue }
   "root@*#" {send_user "Instalation Complete!!!"; exit 0}
   timeout {send_user "TIME TIME TIME\r"; exit 2}
}

exit 0
