#!/bin/sh

#set arguments

ALWAYS=false
OPTIND=1
ZSTATUS=$(zpool status)
ZHEALTHY=$(echo "$ZSTATUS" | grep "state: ONLINE" | wc -l)
ALERT_EMAIL="rob@boom.aero"
#ALERT_EMAIL="avionics.notifications@boom.aero"
NL="%0D%0A"

# Check for the -a option, if present set ALWAYS to true
while getopts 'a' opt; do
    case $opt in
        a) ALWAYS=true ;;
       	*) echo	'Error in command line parsing' >&2
           exit 1
    esac
done

shift "$(( OPTIND - 1 ))"

# Check what kind of email we should send 
if [ $ALWAYS == true ] || [ $ZHEALTHY == 0 ]
then

    # Build the subject and status string based on the ZFS status
    if [ $ZHEALTHY == 0 ]
    then
        ZSUBJECT="Neuromancer zpool **UNHEALTHY** !IMMEDIATE ACTION REQUIRED!"
        ZALERT="WARNING: The ZPOOL /data has entered an alarm state. !IMMEDIATE ACTION REQUIRED!"
    else
        ZSUBJECT="Neruomacner zpool STATUS GOOD "
        ZALERT="INFO: The ZPOOL /data is ONLINE and HEALTHY."
    fi

    # Send the email to the avionics notifications channel
    echo -e "$ZSTATUS \n\n $ZALERT" | mailx -v -n -s "${ZSUBJECT}" $ALERT_EMAIL
    # echo a status message
    echo "email sent"
else
    echo "email NOT sent"
fi



