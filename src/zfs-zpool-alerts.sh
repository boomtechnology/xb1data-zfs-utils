#!/bin/sh

#set arguments

ALWAYS=false
OPTIND=1
ZSTATUS=$(zpool status)
ZHEALTHY=$(echo "$ZSTATUS" | grep "state: ONLINE" | wc -l)
ZSTATUSOFF="ALERT: The ZPOOL /data has entered an alarm state. !IMMEDIATE ACTION REQUIRED!"
ZSTATUSON="INFO: The ZPOOL /data is ONLINE and HEALTHY. NO ACTION REQUIRED" 

while getopts 'a' opt; do
    case $opt in
        a) ALWAYS=true ;;
       	*) echo	'Error in command line parsing' >&2
           exit 1
    esac
done

shift "$(( OPTIND - 1 ))"

if [ $ALWAYS == true ] || [ $ZHEALTHY == 0 ]
then
    echo "email sent"
    echo "$ZSTATUSOFF $ZSTATUS" | mailx -v -n -s "Neuromancer.boom.local ZPOOL /data UNHEALTHY - CRITICAL ALERT - !IMMEDIATE ACTION REQUIRED!" avionics.notifications@boom.aero
else
    echo "email NOT sent"
fi



