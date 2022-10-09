#!/bin/sh

# RetroBoot 1.1.0 - launch_psc.sh
# Standalone boot sequence

echo 0 > /sys/class/leds/red/brightness
echo 1 > /sys/class/leds/green/brightness

# Standalone mode
export RB_MODE=0
RB_PATCHED=0

# Load configuration
source /media/retroarch/retroboot/bin/loadconfig.sh

# Run updates

$RB_PATCHED=0
if [ $RB_PATCH -eq 1 ] && [ -d /media/RB_PATCH ]; then
	source /media/retroarch/retroboot/bin/update.sh
	$RB_PATCHED=$?
fi

if [ $RB_PATCHED -eq 0 ]; then
	if [ $RB_FASTBOOT -eq 1 ]; then
		sh /media/retroarch/retroboot/bin/initfast.sh &
		PID=$!
	else
		sh /media/retroarch/retroboot/bin/init.sh &
		PID=$!
	fi

	# Flash green LED while initializing
	while [ -f /proc/$PID/exe ]; do
		echo 0 > /sys/class/leds/green/brightness
		usleep 250000
		echo 1 > /sys/class/leds/green/brightness
		usleep 250000
	done

	if [ $RB_USEMONITOR -eq 1 ]; then
		# Start RA log monitor 
		sh /media/retroarch/retroboot/monitor.sh &
		MONPID=$!
	fi

	# Set Paths
	export XDG_CONFIG_HOME=/media
	export PATH=/media/retroarch/retroboot/bin:$PATH
	export LD_LIBRARY_PATH=/media/retroarch/retroboot/lib:$LD_LIBRARY_PATH

	# Start RetroArch.  Restart it if it crashes.  Launch exclusive mode apps.
	while : ; do
		
		rm /tmp/retroboot/.ra_killed
		rm /tmp/retroboot/.reload_rb_config
		rm /tmp/es-restart
		rm /tmp/es-shutdown 
		rm /tmp/es-sysrestart
		
		if [ $RB_ENABLE_ES -eq 1 ]; then
			sh /media/retroarch/retroboot/bin/launch_es.sh
			LVL=$?
		else
			/media/retroarch/retroarch --menu &> /media/retroarch/logs/retroarch.log
			LVL=$?
		fi
		
		if [ $LVL -eq 0 ] && [ ! -f /tmp/retroboot/.ra_killed ] && [ ! $RB_ENABLE_ES -eq 1 ]; then
			break
		fi
			
		if [ -f /tmp/es-shutdown ]; then
			break
		fi
		
		if [ -f /tmp/es-restart ]; then
			rm /tmp/es-restart
		elif [ -f /tmp/retroboot/launch_exclusive.sh ]; then
			sh /tmp/retroboot/launch_exclusive.sh
			rm /tmp/retroboot/launch_exclusive.sh
		elif [ -f /tmp/retroboot/.reload_rb_config ]; then
			rm /tmp/retroboot/.reload_rb_config
			source /media/retroarch/retroboot/bin/loadconfig.sh
		elif [ $RB_ENABLE_ES -eq 1 ]; then
			sh /media/retroarch/retroboot/bin/boot_disable_es.sh
			rm /tmp/.reload_rb_config
			source /media/retroarch/retroboot/bin/loadconfig.sh
		else	
			echo 0 > /sys/class/leds/green/brightness
			echo 1 > /sys/class/leds/red/brightness
			
			if [ $RB_ENABLE_ES -eq 1 ]; then
				rm /media/retroarch/logs/emulationstation_crash.log
				mv /media/retroarch/logs/emulationstation.log /media/retroarch/logs/emulationstation_crash.log
				printf "\n--End of emulationstation.log--\n\nOutput from dmesg:\n\n" >> /media/retroarch/logs/emulationstation_crash.log
				dmesg >> /media/retroarch/logs/emulationstation_crash.log		
				printf "\n--End of Log--\n" >> /media/retroarch/logs/emulationstation_crash.log
			else
				rm /media/retroarch/logs/retroarch_crash.log
				mv /media/retroarch/logs/retroarch.log /media/retroarch/logs/retroarch_crash.log
				printf "\n--End of retroarch.log--\n\nOutput from dmesg:\n\n" >> /media/retroarch/logs/retroarch_crash.log
				dmesg >> /media/retroarch/logs/retroarch_crash.log		
				printf "\n--End of Log--\n" >> /media/retroarch/logs/retroarch_crash.log
			fi
			
			
			# Flash leds to indicate restart
			for i in 1 2 3 4 5 6 7 8 9 10 11 12
			do
				echo 1 > /sys/class/leds/red/brightness
				usleep 125000
				echo 0 > /sys/class/leds/red/brightness
				usleep 125000
			done
						
			echo 1 > /sys/class/leds/green/brightness
		fi
	done


	# Show the shut down image
	if [ $RB_SHOWSPLASH -eq 1 ]; then
		chmod +x /media/retroarch/retroboot/bin/sdimage
		sdimage &
		SDPID=$!
	fi

	# Kill the monitor
	if [ $RB_USEMONITOR -eq 1 ]; then
		kill $MONPID 
	fi

	# Flash red LED while cleaning up
	echo 1 > /sys/class/leds/red/brightness
	echo 0 > /sys/class/leds/green/brightness
	sh /media/retroarch/retroboot/bin/cleanup.sh &
	PID=$!
	while [ -f /proc/$PID/exe ]; do
		echo 0 > /sys/class/leds/red/brightness
		usleep 250000
		echo 1 > /sys/class/leds/red/brightness
		usleep 250000
	done
	
	sleep 1
	
	# Kill the shut down image
	if [ $RB_SHOWSPLASH -eq 1 ]; then
		kill -9 $SDPID
	fi
fi

sleep 1
reboot
