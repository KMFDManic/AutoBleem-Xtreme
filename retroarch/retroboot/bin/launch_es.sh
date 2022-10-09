#!/bin/sh

# RetroBoot 1.1.0 - launch_es.sh
# Launches EmulationStation

export HOME="/media/retroarch/retroboot/emulationstation"
export PATH="${PATH}:/media/retroarch/retroboot/emulationstation/launchers"
SYSCFG="/media/retroarch/retroboot/emulationstation/.emulationstation/es_systems.cfg"

if [ ${RB_MODE} -eq 1 ]; then
	if [ ${RB_ES_AB_PATH} -eq 0 ]; then
		sed -i "s|<path>/media/roms/psx</path>|<path>/media/Games</path>|g" "${SYSCFG}"
	elif [ ${RB_ES_AB_PATH} -eq 1 ]; then
		sed -i "s|<path>/media/Games</path>|<path>/media/roms/psx</path>|g" "${SYSCFG}"
	fi
fi

export LD_LIBRARY_PATH="${RB_LIBRARY_PATH}"
chmod +x "${HOME}/emulationstation"
chmod +x "${HOME}/launchers/"*
SDL_VIDEODRIVER=wayland "${HOME}/emulationstation" &> "/media/retroarch/logs/emulationstation.log"
