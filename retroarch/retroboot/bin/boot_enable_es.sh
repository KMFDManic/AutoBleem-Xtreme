#!/bin/sh

# RetroBoot 1.1.0 - boot_enable_es.sh
# Enables EmulationStation

sed -i 's/use_emulationstation=0/use_emulationstation=1/g' /media/retroarch/retroboot/retroboot.cfg
if [ ! -d /tmp/retroboot ]; then
	mkdir /tmp/retroboot
fi

if [ -f /media/Apps/retroboot/Retroboot-ES.png ] && [ -f /media/Apps/retroboot/Retroboot.png ]; then
	mv /media/Apps/retroboot/Retroboot.png /media/Apps/retroboot/Retroboot-RA.png
	mv /media/Apps/retroboot/Retroboot-ES.png /media/Apps/retroboot/Retroboot.png
fi

if [ -f /media/Apps/retroboot/app.ini ]; then
	sed -i 's/Retroboot (RetroArch)/Retroboot (EmulationStation)/g' /media/Apps/retroboot/app.ini
fi

rm /tmp/es-restart
rm /tmp/es-shutdown 
rm /tmp/es-sysrestart
touch /tmp/retroboot/.ra_killed
touch /tmp/retroboot/.reload_rb_config
killall -s KILL retroarch
killall -s KILL emulationstation
