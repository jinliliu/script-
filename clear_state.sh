#!/bin/bash

function check_ping()
{
    ping -c 1 -W 2 $1 >/dev/null 2>&1 && return 0 || return 1
}

function clear_state()
{
     ip=$1
        password=c4proto!

    /usr/bin/expect <<EOF
            set timeout -1
            spawn ssh root@$ip
                    expect {
                            "(yes/no" {
                                    send "yes\r";exp_continue
                                    expect "Password:"
                                    send "$password\r"
                    expect "~>"
                            send "svc_rescue_state -c\r"
                    expect "~>"
                    send "exit\r"
                             }
                            "Password:" { send "$password\r"
                    expect "~>"
                            send "svc_rescue_state -c\r"
                    expect "~>"
                    send "exit\r"
                }
                            "~>" {
                            send "svc_rescue_state -c\r"
                    expect "~>"
                    send "exit\r"
                }
                    }
        expect eof
EOF
}
{
ip_spa=$1
ip_spb=$2

{ 
check_ping $ip_spa
if [ $? -eq 0 ];then
clear_state $ip_spa
#else 
#echo "ping fail"
fi
}&

{
check_ping $ip_spb
if [ $? -eq 0 ];then
clear_state $ip_spa
#else
#echo "ping fail"
fi
}&
wait; } > /dev/null &
echo 11
echo 22

echo jj
exit 0





