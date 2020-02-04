#!/bin/bash -e
dd=/home/pi/avnav/data
if [ ! -d $dd ] ; then
	mkdir -p $dd
fi
cp /usr/lib/avnav/raspberry/avnav_server.xml $dd
if [ -f /etc/systemd/system/signalk.service ] ; then
	sed -iorig '/##.*SIGNALK/d' $dd/avnav_server.xml
fi
if [ -f /etc/default/n2kd ] ; then
	sed -iorig 's/^ *# *CAN_INTERFACE *=.*/CAN_INTERFACE=can0/' /etc/default/n2kd
	sed -iorig '/##.*CANBOAT/d' $dd/avnav_server.xml
fi
chown -R pi:pi /home/pi/avnav

