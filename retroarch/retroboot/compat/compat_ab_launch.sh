#!/bin/sh

# compat_ab_launch
# Launches apps from AutoBleem

LAUNCHDIR=$1
LAUNCH_EXCLUSIVE=0

# Load RB Config
sed -i 's/\r//g' "/media/retroarch/retroboot/bin/loadconfig.sh"
source "/media/retroarch/retroboot/bin/loadconfig.sh"

# Init libraries
sed -i 's/\r//g' "/media/retroarch/retroboot/bin/init_libs.sh"
source "/media/retroarch/retroboot/bin/init_libs.sh"

printf "\nLaunching $1" > /media/retroarch/logs/compat.log

launcher_title="Compat Application"

if [ -f "${LAUNCHDIR}/launcher.cfg" ]; then

	sed -i 's/\r//g' "${LAUNCHDIR}/launcher.cfg"
	source "${LAUNCHDIR}/launcher.cfg"
	
	if grep "${launcher_filename}" /media/retroarch/retroboot/compat/blacklist; then
		printf "\n${launcher_filename} is blacklisted.  Aborting launch." > /media/retroarch/logs/compat.log
		exit 1
	fi
fi

printf "\nPatching ${launcher_title}" >> /media/retroarch/logs/compat.log
sh /media/retroarch/retroboot/compat/compat_patch.sh "${LAUNCHDIR}"


printf "\nStarting ${launcher_title} (${LAUNCHDIR}/launch.sh)\n" >> /media/retroarch/logs/compat.log
ln -s "${LAUNCHDIR}" /var/volatile/launchtmp
sh "${LAUNCHDIR}/launch.sh"
rm /var/volatile/launchtmp

exit 0

