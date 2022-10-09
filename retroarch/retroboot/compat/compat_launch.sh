#!/bin/sh

# compat_launch
# Launches apps

LAUNCHDIR=$1
LAUNCH_EXCLUSIVE=0

printf "\nLaunching $1" > /media/retroarch/logs/compat.log

launcher_title="Compat Application"

if [ -f "${LAUNCHDIR}/launcher.cfg" ]; then

	sed -i 's/\r//g' "${LAUNCHDIR}/launcher.cfg"
	source "${LAUNCHDIR}/launcher.cfg"
	
	if grep "${launcher_filename}" /media/retroarch/retroboot/compat/blacklist; then
		printf "\n${launcher_filename} is blacklisted.  Aborting launch." > /media/retroarch/logs/compat.log
		exit 1
	fi
	
	if grep "$launcher_filename" /media/retroarch/retroboot/compat/exclusive; then

		printf "\nPatching ${launcher_title}" >> /media/retroarch/logs/compat.log
		sh /media/retroarch/retroboot/compat/compat_patch.sh "${LAUNCHDIR}"

		if [ ! -d /tmp/retroboot ]; then
			mkdir /tmp/retroboot
		fi
		
		echo "#!/bin/sh" > "/tmp/retroboot/launch_exclusive.sh"
		echo "cd \"${LAUNCHDIR}\"" >> "/tmp/retroboot/launch_exclusive.sh"
		echo "ln -s \"${LAUNCHDIR}\" /var/volatile/launchtmp" >> "/tmp/retroboot/launch_exclusive.sh"
		echo "sh \"${LAUNCHDIR}/launch.sh\"" >> "/tmp/retroboot/launch_exclusive.sh"
		echo "rm /var/volatile/launchtmp" >> "/tmp/retroboot/launch_exclusive.sh"
		
		touch /tmp/retroboot/.ra_killed

		printf "\nStarting ${launcher_title} in exclusive mode" >> /media/retroarch/logs/compat.log
		killall -s KILL retroarch
		killall -s KILL emulationstation
		
		exit 0
	fi
fi

printf "\nPatching ${launcher_title}" >> /media/retroarch/logs/compat.log
sh /media/retroarch/retroboot/compat/compat_patch.sh "${LAUNCHDIR}"

printf "\nStarting ${launcher_title} (${LAUNCHDIR}/launch.sh)\n" >> /media/retroarch/logs/compat.log

cd "${LAUNCHDIR}"
ln -s "${LAUNCHDIR}" /var/volatile/launchtmp
sh "${LAUNCHDIR}/launch.sh"
rm /var/volatile/launchtmp

exit 0
