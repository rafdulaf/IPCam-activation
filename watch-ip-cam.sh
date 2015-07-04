#!/bin/bash

# IPCamera activate script v1.2.0

# CUSTOMIZE THIS PART

# The smartphones IPs (has to be fixed ips)
IPS=( "192.168.1.X" "192.168.1.Y" )
# The IPCamera IP (has to be fixed)
CAMIP="192.168.1.Z"
# The IPCamera username
CAMUSR="USERNAME"
# The IPCamera password
CAMPWD="PASSWORD"

# END OF CUSTOMIZABLE PART

URL_END="\" -O /dev/null"

URL="wget --user=$CAMUSR --password=$CAMPWD \"http://$CAMIP"

URL_SETMOTION="$URL/setSystemMotion?ConfigSystemMotion=Save&ReplyErrorPage=motion.htm&ReplySuccessPage=motion.htm&MotionDetectionScheduleDay=0"
URL_SETMOTION_OFF="$URL_SETMOTION&MotionDetectionEnable=0$URL_END"
URL_SETMOTION_ON="$URL_SETMOTION&MotionDetectionEnable=1&MotionDetectionScheduleMode=0&MotionDetectionSensivity=70$URL_END"

URL_SETSOUND="$URL/setSystemSoundDB?ConfigSystemSoundDB=Save&SoundDetectionDB=70&SoundDetectionScheduleDay=0&ReplyErrorPage=sounddb.htm&ReplySuccessPage=sounddb.htm"
URL_SETSOUND_OFF="$URL_SETSOUND&SoundDetectionEnable=0$URL_END"
URL_SETSOUND_ON="$URL_SETSOUND&SoundDetectionEnable=1$URL_END"

URL_MOVETO="$URL/pantiltcontrol.cgi"
URL_MOVETO_OFF="$URL_MOVETO?PanTiltPresetPositionMove=2$URL_END"
URL_MOVETO_ON="$URL_MOVETO?PanTiltPresetPositionMove=0$URL_END"

URL_SETIR="$URL/setDayNightMode?ReplySuccessPage=night.htm&ReplyErrorPage=errrnght.htm&ConfigDayNightMode=Save"
URL_SETIR_OFF="$URL_SETIR&DayNightMode=2$URL_END"
URL_SETIR_AUTO="$URL_SETIR&DayNightMode=0$URL_END"

STATEFILE=/tmp/state
CAMREACHABLE=`ping -c 4 $CAMIP | grep "packet loss" | sed "s/^.* \([0-9]\+\)% packet loss.*$/\1/"`

if [ $CAMREACHABLE != "100" ]; then

        if [ -f $STATEFILE ]; then
                STATE=`cat $STATEFILE`
        fi

        FOUND=false
        for i in ${IPS[@]}; do
                REACH=`ping -c 4 $i | grep "packet loss" | sed "s/^.* \([0-9]\+\)% packet loss.*$/\1/"`
                if [ $REACH != "100" ]; then
                        echo "FOUND "$i
                        if [[ -z "$STATE" ]] || [ $STATE == "ON" ]; then
                                echo "State changed to off"
                                eval "$URL_SETMOTION_OFF"
                                eval "$URL_SETSOUND_OFF"
                                eval "$URL_MOVETO_OFF"
                                eval "$URL_SETIR_OFF"
                        fi
                        STATE="OFF"
                        FOUND=true
                        break
                fi
        done

        if [ $FOUND == false ]; then
                echo "NOT FOUND ANY"

                if [ $STATE == "OFF" ]; then
                        STATE="ON5"
                elif [ $STATE == "ON5" ]; then
                        STATE="ON4"
                elif [ $STATE == "ON4" ]; then
                        STATE="ON3"
                elif [ $STATE == "ON3" ]; then
                        STATE="ON2"
                elif [ $STATE == "ON2" ]; then
                        STATE="ON1"
                elif [[ -z "$STATE" ]] || [ $STATE == "ON1"  ]; then
                        echo "State changed to on"
                        STATE="ON"
                        eval "$URL_MOVETO_ON"
                        eval "$URL_SETMOTION_ON"
                        eval "$URL_SETSOUND_ON"
                        eval "$URL_SETIR_AUTO"
                fi
        fi

        echo $STATE > $STATEFILE

else

        rm $STATEFILE

fi

echo "STATE is "$STATE
        
