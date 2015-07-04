#!/bin/bash

# Wifi reboot script v1.0.0

# Customize
WIFIIP="192.168.1.XXX"

STATEFILE=/tmp/wifistate
WIFIREACHABLE=`ping -c 4 $WIFIIP | grep "packet loss" | sed "s/^.* \([0-9]\+\)% packet loss.*$/\1/"`

if [ -f $STATEFILE ]; then
        STATE=`cat $STATEFILE`
fi

if [ $WIFIREACHABLE == "100" ]; then
        # Wifi cannot be reach

        # directly after reboot? let us wait a few minutes to avoid cycling reboot
        if [ -z "$STATE" ]; then
                STATE="KO5"
        elif [ $STATE == "KO5" ]; then
                STATE="KO4"
        elif [ $STATE == "KO4" ]; then
                STATE="KO3"
        elif [ $STATE == "KO3" ]; then
                STATE="KO2"
        elif [ $STATE == "KO2" ]; then
                STATE="KO1"
        # unreachable after reboot and a few minutes wait OR unreachable but it was reachable just before
        elif [[ $STATE == "OK" ]] || [ $STATE == "KO1" ]; then
                STATE="KO"
                sudo reboot
        fi
else
        # Wifi is ok
        STATE="OK"
fi

echo $STATE > $STATEFILE
echo "STATE is "$STATE

