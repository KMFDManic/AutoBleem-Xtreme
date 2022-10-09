#!/bin/sh

# RetroBoot 1.0.1 - launch_app_exclusive.sh
# Starts Launchers

echo "Launching $1 in exclusive mode" >> /media/retroarch/logs/apps.log

if [ ! -d /tmp/retroboot ]; then
	mkdir /tmp/retroboot
fi

sed -i 's/\r//g' "$1"
cp "$1" "/tmp/retroboot/launch_exclusive.sh"

touch /tmp/retroboot/.ra_killed

echo "Killing RetroArch" >> /media/retroarch/logs/apps.log
killall -s KILL retroarch
killall -s KILL emulationstation
