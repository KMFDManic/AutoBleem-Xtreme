#!/bin/sh

# RetroBoot 1.1.0 - initfast.sh
# Fast boot mode

importmc()
{
	FN="$1"
	GID="$2"
	if [ ! -f "/media/retroarch/saves/$GID.srm" ]; then
		cp "/data/AppData/sony/pcsx/$FN/.pcsx/memcards/card1.mcd" "/media/retroarch/saves/$GID.srm"
	fi	
}

linkdisk()
{
	FN="$1"
	GID="$2"
	ln -s "/gaadata/$FN/$GID.cue" "/tmp/retroboot/$GID.cue"
	ln -s "/gaadata/$FN/$GID.bin" "/tmp/retroboot/$GID.bin"
}

closeui()
{
	sleep 5
	killall -s KILL showLogo sonyapp ui_menu auto_dimmer pcsx dimmer
	echo 2 > /data/power/disable
}

inittmp()
{
	mkdir -p "/tmp/retroboot"
		
	cp /media/retroarch/retroboot/assets/rb_ff7.m3u /tmp/retroboot/FinalFantasyVII.m3u
	cp /media/retroarch/retroboot/assets/rb_mgs.m3u /tmp/retroboot/MetalGearSolid.m3u
	
	linkdisk 4 "SCUS-94163"
	linkdisk 4 "SCUS-94164"
	linkdisk 4 "SCUS-94165"

	linkdisk 8 "SLUS-00594"
	linkdisk 8 "SLUS-00776"

	mkdir -p "/tmp/ra_cache"
}


parselaunchers()
{
	sh /media/retroarch/retroboot/bin/parselaunchers.sh
}

initblocking()
{
	
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
	
	if [ $RB_IMPORTGAMES -eq 1 ] && [ ! -s "/media/retroarch/playlists/Sony - PlayStation.lpl" ]; then
		cp "/media/retroarch/retroboot/assets/default.lpl" "/media/retroarch/playlists/Sony - PlayStation.lpl"
	fi
	
	[ ! -s "/media/retroarch/retroarch.cfg" ] && cp "/media/retroarch/retroboot/assets/retroarch.cfg" "/media/retroarch/retroarch.cfg"

	[ ! -s "/media/retroarch/config/retroarch-core-options.cfg" ] && cp "/media/retroarch/retroboot/assets/retroarch-core-options.cfg" "/media/retroarch/config/retroarch-core-options.cfg"

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
	
	if [ $RB_ENABLE_ES -eq 1 ]; then
		sh /media/retroarch/retroboot/bin/init_libs.sh
	fi

	chmod +x /media/retroarch/retroarch
}

initusb()
{
	
	chmod +x /media/retroarch/retroboot/bin/xz
		
	[ ! -f /media/retroarch/system/scph5500.bin ] && cp /gaadata/system/bios/romJP.bin /media/retroarch/system/scph5500.bin
	[ ! -f /media/retroarch/system/scph5501.bin ] && cp /gaadata/system/bios/romw.bin /media/retroarch/system/scph5501.bin
	[ ! -f /media/retroarch/system/scph5502.bin ] && cp /gaadata/system/bios/romw.bin /media/retroarch/system/scph5502.bin

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
	
	rm /media/retroarch/logs/retroarch_crash.log

}

initmisc() 
{
	if [ $RB_LOADMODULES -eq 1 ]; then
		for kmod in /media/retroarch/retroboot/modules/*.ko; do 
			insmod "$kmod";
		done
	fi

	mount -o bind /media/retroarch/retroboot/assets/20-joystick.rules /etc/udev/rules.d/20-joystick.rules

	udevadm control --reload-rules
	udevadm trigger
	
	mount -o "remount,ro" "/data"
	mount -o "remount,ro" "/gaadata"
}

initblocking &
BLOCKPID=$!

closeui &

inittmp &

initmisc &

initusb &

if [ ! $RB_ENABLE_ES -eq 1 ]; then
	sh /media/retroarch/retroboot/bin/init_libs.sh &
fi

# Wait for /media/ to finish initializing
while [ -f /proc/$BLOCKPID/exe ]; do
	usleep 50000
done
