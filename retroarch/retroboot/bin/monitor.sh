#!/bin/sh

# RetroBoot 1.1.0 - monitor.sh 
# Monitor RetroArch logs for Wayland errors

sleep 20

while : ; do
	sleep 5
	
	tail -n 5 /media/retroarch/retroarch.log | grep -q "wl_display@1: error"
	RETVAL=$?
  
	if [ $RETVAL -eq 0 ]; then
		touch /tmp/retroboot/.ra_killed
		killall retroarch
		sleep 20
	fi
done