#!/bin/sh

# RetroBoot 1.0.1 - launch_app.sh
# Starts Launchers

echo "Launching $1" >> /media/retroarch/logs/apps.log
sed -i 's/\r//g' "$1"
source "$1"
echo "Path is $LAUNCHER_SCRIPT_PATH" >> /media/retroarch/logs/apps.log
sh "$LAUNCHER_SCRIPT_PATH"
