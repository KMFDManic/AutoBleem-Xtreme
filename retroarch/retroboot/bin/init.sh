#!/bin/sh

# RetroBoot 1.1.0 - init.sh
# Initializes environment

# Define memory card import function
importmc()
{
	FN="$1"
	GID="$2"
	if [ ! -f "/media/retroarch/saves/$GID.srm" ]; then
		cp "/data/AppData/sony/pcsx/$FN/.pcsx/memcards/card1.mcd" "/media/retroarch/saves/$GID.srm"
	fi	
}

# Define symlink preparation function for multi-disc games
linkdisk()
{
	FN="$1"
	GID="$2"
	ln -s "/gaadata/$FN/$GID.cue" "/tmp/retroboot/$GID.cue"
	ln -s "/gaadata/$FN/$GID.bin" "/tmp/retroboot/$GID.bin"
}

closeui()
{
	# Wait for system to finish initializing
	while [ -z "$(ps | grep -E 'ui_menu' | grep -v grep)" ]; do
		usleep 250000
	done
	sleep 1
	
	# Exit Sony software gracefully
	touch "/data/power/prepare_suspend"
	while [ ! -z "$(ps | grep -E 'sonyapp|ui_menu|auto_dimmer|pcsx' | grep -v grep)" ]; do
		usleep 100000
	done
	rm "/data/power/prepare_suspend"
	rm "/data/power/apps_okay"
	
	# Disable power button.
	echo 2 > /data/power/disable
}

parselaunchers()
{
	sh /media/retroarch/retroboot/bin/parselaunchers.sh
}

inittmp()
{

	# M3Us only support relative paths, so set up a temp folder for MGS and FF7
	mkdir -p "/tmp/retroboot"
		
	# Copy M3Us to temp folder
	cp /media/retroarch/retroboot/assets/rb_ff7.m3u /tmp/retroboot/FinalFantasyVII.m3u
	cp /media/retroarch/retroboot/assets/rb_mgs.m3u /tmp/retroboot/MetalGearSolid.m3u
	
	# Create symlinks for FF7
	linkdisk 4 "SCUS-94163"
	linkdisk 4 "SCUS-94164"
	linkdisk 4 "SCUS-94165"

	# Create symlinks for MGS
	linkdisk 8 "SLUS-00594"
	linkdisk 8 "SLUS-00776"

	# Set up libs
	sh /media/retroarch/retroboot/bin/init_libs.sh

	# Set up RetroArch cache directory
	mkdir -p "/tmp/ra_cache"

}

initusb()
{

	# Check if PSX BIOS is in /media/RetroArch, and copy from internal memory if not.
	[ ! -f /media/retroarch/system/scph5500.bin ] && cp /gaadata/system/bios/romJP.bin /media/retroarch/system/scph5500.bin
	[ ! -f /media/retroarch/system/scph5501.bin ] && cp /gaadata/system/bios/romw.bin /media/retroarch/system/scph5501.bin
	[ ! -f /media/retroarch/system/scph5502.bin ] && cp /gaadata/system/bios/romw.bin /media/retroarch/system/scph5502.bin

	# Import Memory Cards
	if [ $RB_IMPORTCARDS -eq 1 ]; then
		importmc 1 "SCES-00002"
		importmc 2 "SCES-00992"
		importmc 3 "SCES-00008"
		importmc 4 "FinalFantasyVII"
		importmc 5 "SLES-00032"
		importmc 6 "SCUS-94181"
		importmc 7 "SCES-00003"
		importmc 8 "MetalGearSolid"
		importmc 9 "SLUS-01111"
		importmc 10 "SLES-00664"
		importmc 11 "SLUS-00005"
		importmc 12 "SLES-00969"
		importmc 13 "SLUS-00339"
		importmc 14 "SLUS-00797"
		importmc 15 "SLUS-00418"
		importmc 16 "SCUS-94240"
		importmc 17 "SCES-01237"
		importmc 18 "SLES-01136"
		importmc 19 "SCUS-94304"
		importmc 20 "SCUS-94608"
	fi
	
	# Restore default playlist if missing or empty
	if [ $RB_IMPORTGAMES -eq 1 ]; then
		[ ! -s "/media/retroarch/playlists/Sony - PlayStation.lpl" ] && cp "/media/retroarch/retroboot/assets/default.lpl" "/media/retroarch/playlists/Sony - PlayStation.lpl"
	fi
	
	# Restore default configs if missing or empty
	[ ! -s "/media/retroarch/retroarch.cfg" ] && cp "/media/retroarch/retroboot/assets/retroarch.cfg" "/media/retroarch/retroarch.cfg"

	[ ! -s "/media/retroarch/config/retroarch-core-options.cfg" ] && cp "/media/retroarch/retroboot/assets/retroarch-core-options.cfg" "/media/retroarch/config/retroarch-core-options.cfg"
	
	# Delete old RetroArch crash log
	rm /media/retroarch/logs/retroarch_crash.log
	
	# Mark RetroArch binary as executable
	chmod +x /media/retroarch/retroarch
	
	# Mark xz binary as executable
	chmod +x /media/retroarch/retroboot/bin/xz

	# Force DS4 Mappings
	if [ $RB_DS4MODE -eq 4 ]; then
		[ ! -s "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg" ] && cp "/media/retroarch/retroboot/assets/Sony-PlayStation4-DualShock4-Controller.cfg" "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg"
		[ ! -s "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg" ] && cp "/media/retroarch/retroboot/assets/Sony-PlayStation4-DualShock4v2-Controller.cfg" "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg"
		[ ! -s "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg" ] && cp "/media/retroarch/retroboot/assets/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg" "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg"
	fi
	
	if [ $RB_DS4MODE -eq 1 ]; then
		[ ! -s "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg" ] && cp "/media/retroarch/retroboot/assets/Sony-PlayStation4-DualShock4-Controller.cfg" "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg"
		[ -f "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg" ] && rm "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg"
		[ -f "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg" ] && rm "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg"
	fi
	
	if [ $RB_DS4MODE -eq 2 ]; then
		[ -f "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg" ] && rm "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg"
		[ ! -s "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg" ] && cp "/media/retroarch/retroboot/assets/Sony-PlayStation4-DualShock4v2-Controller.cfg" "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg"
		[ -f "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg" ] && rm "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg"
	fi
	
	if [ $RB_DS4MODE -eq 3 ]; then
		[ -f "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg" ] && rm "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4-Controller.cfg"
		[ -f "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg" ] && rm "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Controller.cfg"
		[ ! -s "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg" ] && cp "/media/retroarch/retroboot/assets/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg" "/media/retroarch/autoconfig/Sony-PlayStation4-DualShock4v2-Wired-Crystal-Controller.cfg"
	fi
	
	if [ $RB_ENABLEAPPS -eq 1 ]; then
		if [ $RB_PARSELAUNCHERS -eq 3 ]; then
			parselaunchers
		elif [ $RB_PARSELAUNCHERS -eq 2 ]; then
			sed -i "s/refresh_applications=2/refresh_applications=1/g" /media/retroarch/retroboot/retroboot.cfg
			parselaunchers
		elif [ $RB_PARSELAUNCHERS -eq 1 ] && [ -f /media/retroarch/retroboot/applaunchers/.updatelaunchers ]; then
			parselaunchers				
		fi
	elif [ $RB_ENABLEAPPS -eq 0 ] && [ -f /media/retroarch/playlists/Applications.lpl ]; then
		rm /media/retroarch/playlists/Applications.lpl
		touch /media/retroarch/retroboot/apps/launchers/.updatelaunchers
	fi
	
}

# Initialize items on /media/ in subshell
initusb &
IUPID=$!

# Initialize items on /tmp/ in subshell
inittmp &
ITPID=$!

# Close Sony UI
if [ $RB_MODE -eq 0 ]; then
	closeui
fi

# Wait for /media/ and /tmp/ to finish initializing
while [ -f /proc/$IUPID/exe ] || [ -f /proc/$ITPID/exe ] ; do
	usleep 100000
done

# Load kernel modules
if [ $RB_LOADMODULES -eq 1 ]; then

	for kmod in /media/retroarch/retroboot/modules/*.ko; do 
		insmod "$kmod";
	done
fi

if [ $RB_MODE -eq 0 ]; then
	# Remount data and gaadata as read-only.
	mount -o "remount,ro" "/data"
	mount -o "remount,ro" "/gaadata"

	# Overmount udev rules for better support of joypads in USB hubs.
	mount -o bind /media/retroarch/retroboot/assets/20-joystick.rules /etc/udev/rules.d/20-joystick.rules

	# Load new udev rules
	udevadm control --reload-rules
	udevadm trigger
fi
