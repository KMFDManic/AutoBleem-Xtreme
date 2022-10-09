#!/bin/sh

# RetroBoot 1.1.0 - update.sh
# Runs updates

closeui()
{
	# Wait for system to finish initializing
	while [ -z "$(ps | grep -E 'ui_menu' | grep -v grep)" ]; do
		usleep 250000
	done
	sleep 1
	
	touch "/data/power/prepare_suspend"
	while [ ! -z "$(ps | grep -E 'sonyapp|ui_menu|auto_dimmer|pcsx' | grep -v grep)" ]; do
		usleep 100000
	done
	rm "/data/power/prepare_suspend"
	rm "/data/power/apps_okay"
	
	# Disable power button.
	echo 2 > /data/power/disable
	
}


flashleds()
{
	while : ; do
		echo 1 > /sys/class/leds/green/brightness
		echo 1 > /sys/class/leds/red/brightness
		usleep 250000
		echo 1 > /sys/class/leds/green/brightness
		echo 0 > /sys/class/leds/red/brightness
		usleep 250000
	done
}

flashledsfinal()
{
	while : ; do
		echo 1 > /sys/class/leds/green/brightness
		echo 1 > /sys/class/leds/red/brightness
		usleep 200000
		echo 0 > /sys/class/leds/green/brightness
		echo 0 > /sys/class/leds/red/brightness
		usleep 100000
		echo 1 > /sys/class/leds/green/brightness
		echo 0 > /sys/class/leds/red/brightness
		usleep 200000
		echo 0 > /sys/class/leds/green/brightness
		echo 0 > /sys/class/leds/red/brightness
		usleep 100000
	done
}

export RB_PATCHLOG=/media/retroarch/logs/update.log
rm $RB_PATCHLOG

UPDATEERROR=0
PATCHESFOUND=0
PATCHESINSTALLED=0

printf "\nLooking for patches..." >> $RB_PATCHLOG
if [ ! -d /media/RB_PATCH ]; then
	printf "\nNo patches found." >> $RB_PATCHLOG
	printf "\nUpdate script completed successfully." >> $RB_PATCHLOG
	export RB_PATCHED=0
	exit 0
fi

printf "\nFound patch directory, killing Sony UI." >> $RB_PATCHLOG


if [ $RB_MODE -eq 0 ]; then
	closeui
fi

printf "\nStarting splash screen and LED flash." >> $RB_PATCHLOG

chmod +x /media/retroarch/retroboot/bin/udimage

/media/retroarch/retroboot/bin/udimage &
IMGPID=$!

flashleds &
LEDPID=$!

printf "\nSearching for patch scripts..." >> $RB_PATCHLOG

for PATCHFILE in /media/RB_PATCH/PATCH_*.sh
do 

	if [ ! -f $PATCHFILE ]; then
		continue
	fi
	
	printf "\nINSTALL: Starting patch script: $PATCHFILE" >> $RB_PATCHLOG
	PATCHESFOUND=1

	sed -i 's/\r//g' "$PATCHFILE"
	sh "$PATCHFILE"
	PATCHERROR=$?
	
	if [ $PATCHERROR -ne 0 ]; then
		UPDATEERROR=1
		mv "$PATCHFILE" "$PATCHFILE.FAILED"
		printf "\nFAILURE: Patch failed with error $PATCHERROR.\n" >> $RB_PATCHLOG
	else
		PATCHESINSTALLED=1
		if [ $RB_PATCHCLEANUP -eq 1 ]; then
			rm "$PATCHFILE"
		fi
		printf "\nSUCCESS: Patch was installed successfully.\n" >> $RB_PATCHLOG
	fi
done

printf "\nSearching for .mod files..." >> $RB_PATCHLOG

for MODFILE in /media/RB_PATCH/*.mod
do

	printf "\nFound $MODFILE." >> $RB_PATCHLOG

	if [ ! -f "$MODFILE" ]; then
		printf "\n$MODFILE is not a valid file" >> $RB_PATCHLOG
		continue
	fi
	
	base_filename=$(basename "$MODFILE")
	printf "\nINSTALL: Starting .mod install for $base_filename" >> $RB_PATCHLOG
	PATCHESFOUND=1

	sh /media/retroarch/retroboot/compat/compat_install.sh "$MODFILE"
	PATCHERROR=$?

	if [ $PATCHERROR -ne 0 ]; then
		UPDATEERROR=1
		
		if [ $PATCHERROR -eq 1 ]; then
			printf "\nFAILURE: Error unpacking $base_filename" >> $RB_PATCHLOG
		elif [ $PATCHERROR -eq 2 ]; then
			printf "\nFAILURE: No installable components found in $base_filename" >> $RB_PATCHLOG
		else
			printf "\nFAILURE: Error $PATCHERROR installing $base_filename" >> $RB_PATCHLOG
		fi
	else
		PATCHESINSTALLED=1
		if [ $RB_PATCHCLEANUP -eq 1 ]; then
			rm "$PATCHFILE"
		fi
		printf "\nSUCCESS: Patch was installed successfully.\n" >> $RB_PATCHLOG
	fi
	if [ -f "$MODFILE" ]; then
		rm "$MODFILE"
	fi
	
done



kill $LEDPID

if [ $PATCHESFOUND -eq 0 ]; then
	printf "\nNo patches found." >> $RB_PATCHLOG
	export RB_PATCHED=0
	echo 0 > /sys/class/leds/red/brightness
	echo 1 > /sys/class/leds/green/brightness
	kill -9 $IMGPID
fi	

if [ $RB_PATCHCLEANUP -eq 1 ]; then
	printf "\nDeleting patch folder." >> $RB_PATCHLOG
	rm -rf /media/RB_PATCH
fi

if [ $UPDATEERROR -eq 0 ]; then
	printf "\nUpdate script completed successfully." >> $RB_PATCHLOG
	echo 0 > /sys/class/leds/red/brightness
	
	for i in 1 2 3 4 5 6 7 8 9
	do
		echo 1 > /sys/class/leds/green/brightness
		usleep 250000
		echo 0 > /sys/class/leds/green/brightness
		usleep 125000
	done
else
	printf "\nUpdate script completed with errors." >> $RB_PATCHLOG
	rm /media/update_errors.txt
	cp $RB_PATCHLOG /media/update_errors.txt
	
	echo 0 > /sys/class/leds/green/brightness

	for i in 1 2 3 4 5 6 7 8 9
	do
		echo 1 > /sys/class/leds/red/brightness
		usleep 250000
		echo 0 > /sys/class/leds/red/brightness
		usleep 125000
	done
fi
		


if [ $PATCHESINSTALLED -gt 0 ]; then
	
	flashledsfinal &
	LEDPID=$!
	
	printf "\nFinalizing update." >> $RB_PATCHLOG

	sync
	sleep 1
	kill -9 $IMGPID
	sleep 1
	
	kill $LEDPID
	
	if [ $RB_MODE -eq 0 ]; then	
		echo 1 > /sys/class/leds/red/brightness
		echo 0 > /sys/class/leds/green/brightness
		reboot
	fi
	
	echo 0 > /sys/class/leds/red/brightness
	echo 1 > /sys/class/leds/green/brightness

	exit 1

fi

echo 0 > /sys/class/leds/red/brightness
echo 1 > /sys/class/leds/green/brightness

kill -9 $IMGPID

sleep 1
exit 0
