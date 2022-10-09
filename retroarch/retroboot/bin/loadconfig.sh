#!/bin/sh

# RetroBoot 1.1.0 - loadconfig.sh 
# Loads retroboot.cfg

force_ds4=0
show_splash=1
use_monitor=0
load_modules=1
enable_fastboot=1
import_internal_games=1
import_internal_memcards=1
sync_fs_ab=1
enable_updates=1 
updater_cleanup=1 
refresh_applications=1
enable_applications=1
enable_mod_install=1
cache_libraries=1
mod_button_select=100
mod_always_patch=0
use_emulationstation=0
es_ab_psx_folder=0
if [ ! -f /media/retroarch/retroboot/retroboot.cfg ]; then
	cp "/media/retroarch/retroboot/assets/retroboot.cfg" "/media/retroarch/retroboot/retroboot.cfg"
fi

sed -i 's/\r//g' /media/retroarch/retroboot/retroboot.cfg
source /media/retroarch/retroboot/retroboot.cfg

source /media/retroarch/retroboot/bin/version.sh

export RB_LIBRARY_PATH=/tmp/rblib

export RB_DS4MODE=$force_ds4
export RB_SHOWSPLASH=$show_splash
export RB_USEMONITOR=$use_monitor
export RB_LOADMODULES=$load_modules
export RB_FASTBOOT=$enable_fastboot
export RB_IMPORTGAMES=$import_internal_games
export RB_IMPORTCARDS=$import_internal_memcards
export RB_SYNCFSAB=$sync_fs_ab
export RB_PATCH=$enable_updates 
export RB_PATCHCLEANUP=$updater_cleanup
export RB_PARSELAUNCHERS=$refresh_applications
export RB_ENABLEAPPS=$enable_applications
export RB_COMPAT=$enable_mod_install
export RB_LIBCACHE=$cache_libraries
export RB_COMPAT_SELECT=$mod_button_select
export RB_FORCE_COMPAT_PATCH=$mod_always_patch
export RB_ENABLE_ES=$use_emulationstation
export RB_ES_AB_PATH=$es_ab_psx_folder
