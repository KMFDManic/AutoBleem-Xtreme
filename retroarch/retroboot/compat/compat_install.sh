#!/bin/sh

# compat_install
# Installs .mod packages


modinstall()
{

	if [ ! -f "${1}/launcher.cfg" ]; then
		printf "\nWARNING: Could not find ${1}/launcher.cfg, skipping install." >> $RB_PATCHLOG
		return 1
	fi
	
	if [ ! -f "${1}/launch.sh" ]; then
		printf "\nWARNING: Could not find ${1}/launch.sh, skipping install." >> $RB_PATCHLOG
		return 1
	fi
	
	NEW_MOD_PATH="/media/retroarch/apps/compat/$(basename ${1})"
	
	sed -i 's/\r//g' "${1}/launcher.cfg"
	
	source "${1}/launcher.cfg"
	
	printf "\n Found ${launcher_filename} (${launcher_title})" >> $RB_PATCHLOG
	
	if grep -q "${launcher_filename}" /media/retroarch/retroboot/compat/blacklist; then
		printf "\nWARNING: Found ${launcher_title} on compat blacklist, skipping install." >> $RB_PATCHLOG
		return 2
	fi
	
	if [ ! -d /media/retroarch/apps ]; then
		mkdir /media/retroarch/apps
	fi
	if [ ! -d /media/retroarch/apps/compat ]; then
		mkdir /media/retroarch/apps/compat
	fi
	
	if [ -d "${NEW_MOD_PATH}" ]; then
		printf "\nWARNING: Removing existing directory at ${NEW_MOD_PATH}" >> $RB_PATCHLOG
		rm -rf "${NEW_MOD_PATH}"
	fi
	
	mv "${1}" "/media/retroarch/apps/compat/"
	
	printf "\n Creating compatibility launcher script." >> $RB_PATCHLOG
		
	# Create launcher script
	CLFILENAME="/media/retroarch/retroboot/compat/launchers/launch_${launcher_filename}.sh"
	echo "#! /bin/sh" > $CLFILENAME
	echo "# Retroboot Compat Launcher" >> $CLFILENAME
	echo "" >> $CLFILENAME
	echo "sh \"/media/retroarch/retroboot/compat/compat_launch.sh\" \"${NEW_MOD_PATH}\"" >> $CLFILENAME
	# Create rblauncher
	printf "\nCreating application launcher." >> $RB_PATCHLOG

	APPLAUNCHER_FILENAME="/media/retroarch/retroboot/applaunchers/compat-${launcher_filename}.rblauncher"

	if [ ! -d /media/retroarch/retroboot/applaunchers ]; then
		mkdir /media/retroarch/retroboot/applaunchers
	fi

	if [ -f "${APPLAUNCHER_FILENAME}" ]; then
		rm "${APPLAUNCHER_FILENAME}"
	fi

	echo "# Retroboot Compat Launcher" >> ${APPLAUNCHER_FILENAME}
	echo "" >> ${APPLAUNCHER_FILENAME}
	echo "LAUNCHER_LABEL=\"${launcher_title}\"" >> ${APPLAUNCHER_FILENAME}
	echo "LAUNCHER_DESCRIPTION=\"Compatibility Mode Application\"" >> ${APPLAUNCHER_FILENAME}
	echo "LAUNCHER_SCRIPT_PATH=\"/media/retroarch/retroboot/compat/launchers/launch_${launcher_filename}.sh\"" >> ${APPLAUNCHER_FILENAME}
	touch /media/retroarch/retroboot/applaunchers/.updatelaunchers
	
	# Create icons
	
	printf "\n Preparing icons for RetroArch." >> $RB_PATCHLOG
		
	# Replace &*/:`<>?\| in icon filename for RA

	RA_ICON_FILENAME="${launcher_title}.png"
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/&/_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/\*/_/g') 
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/\//_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/:/_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/`/_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/</_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/>/_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/?/_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/\\/_/g')
	RA_ICON_FILENAME=$(echo "${RA_ICON_FILENAME}" | sed 's/|/_/g')
	
	ORIGINAL_ICON_PATH="${NEW_MOD_PATH}/${launcher_filename}.png"
		
	if [ -f $ORIGINAL_ICON_PATH ]; then

		# Delete old icons

		if [ -f "/media/retroarch/thumbnails/Applications/Named_Boxarts/${RA_ICON_FILENAME}" ]; then
			rm "/media/retroarch/thumbnails/Applications/Named_Boxarts/${RA_ICON_FILENAME}"
		fi	
		if [ -f "/media/retroarch/thumbnails/Applications/Named_Snaps/${RA_ICON_FILENAME}" ]; then
			rm "/media/retroarch/thumbnails/Applications/Named_Snaps/${RA_ICON_FILENAME}"
		fi	
		if [ -f "/media/retroarch/thumbnails/Applications/Named_Titles/${RA_ICON_FILENAME}" ]; then
			rm "/media/retroarch/thumbnails/Applications/Named_Titles/${RA_ICON_FILENAME}"
		fi	

		# Copy new icons
		cp "${ORIGINAL_ICON_PATH}" "/media/retroarch/thumbnails/Applications/Named_Boxarts/${RA_ICON_FILENAME}"
		cp "${ORIGINAL_ICON_PATH}" "/media/retroarch/thumbnails/Applications/Named_Snaps/${RA_ICON_FILENAME}"
		cp "${ORIGINAL_ICON_PATH}" "/media/retroarch/thumbnails/Applications/Named_Titles/${RA_ICON_FILENAME}"
	fi
	
	# Patch scripts and configs
	printf "\n Patching scripts and configs." >> $RB_PATCHLOG

	sh /media/retroarch/retroboot/compat/compat_patch.sh "${NEW_MOD_PATH}"

	if [ $RB_MODE -eq 1 ]; then
		# Create AB launcher
		printf "\n Creating launcher for Autobleem." >> $RB_PATCHLOG

		AB_LAUNCHER_FOLDER="/media/Apps/compat-${launcher_filename}"
		AB_LAUNCHER_INI="${AB_LAUNCHER_FOLDER}/app.ini"
		AB_LAUNCHER_SCRIPT="${AB_LAUNCHER_FOLDER}/run.sh"
		
		if [ ! -d /media/Apps ]; then
			mkdir /media/Apps
		fi
		
		if [ ! -d "${AB_LAUNCHER_FOLDER}" ]; then
			mkdir "${AB_LAUNCHER_FOLDER}"
		fi
		
		if [ -f "${AB_LAUNCHER_FOLDER}/app.ini" ]; then
			rm "${AB_LAUNCHER_FOLDER}/app.ini"
		fi

		echo "Title=${launcher_title}" >> ${AB_LAUNCHER_INI}
		echo "Author=${launcher_publisher}" >> ${AB_LAUNCHER_INI}
		echo "Startup=run.sh" >> ${AB_LAUNCHER_INI}
		echo "Kernel=false" >> ${AB_LAUNCHER_INI}
		echo "Readme=readme.txt" >> ${AB_LAUNCHER_INI}
		echo "Image=icon.png" >> ${AB_LAUNCHER_INI}
			
		if [ -f "${AB_LAUNCHER_FOLDER}/run.sh" ]; then
			rm "${AB_LAUNCHER_FOLDER}/run.sh"
		fi
		echo "#! /bin/sh" >> ${AB_LAUNCHER_SCRIPT}
		echo "# Retroboot Compat Launcher" >> ${AB_LAUNCHER_SCRIPT}
		echo "" >> ${AB_LAUNCHER_SCRIPT}
		echo "sh \"/media/retroarch/retroboot/compat/compat_ab_launch.sh\" \"${NEW_MOD_PATH}\"" >> ${AB_LAUNCHER_SCRIPT}

		printf "\n Searching for a readme file for Autobleem." >> $RB_PATCHLOG

		if [ -f "${NEW_MOD_PATH}/readme.txt" ]; then
			cp "${NEW_MOD_PATH}/readme.txt" "${AB_LAUNCHER_FOLDER}/readme.txt"
		elif [ -f "${NEW_MOD_PATH}/ReadMe.txt" ]; then
			cp "${NEW_MOD_PATH}/ReadMe.txt" "${AB_LAUNCHER_FOLDER}/readme.txt"
		elif [ -f "${NEW_MOD_PATH}/license.txt" ]; then
			cp "${NEW_MOD_PATH}/license.txt" "${AB_LAUNCHER_FOLDER}/readme.txt"
		elif [ -f "/media/RB_PATCH/${app_folder}/License.txt" ]; then
			cp "${NEW_MOD_PATH}/License.txt" "${AB_LAUNCHER_FOLDER}/readme.txt"
		else
			printf "\n No readme found, installing compat default." >> $RB_PATCHLOG
			cp /media/retroarch/retroboot/compat/compat_ab_default_readme.txt "${AB_LAUNCHER_FOLDER}/readme.txt" 
		fi
				
		if [ -f $ORIGINAL_ICON_PATH ]; then

			if [ -f "${AB_LAUNCHER_FOLDER}/icon.png" ]; then
				rm "${AB_LAUNCHER_FOLDER}/icon.png"
			fi		
			cp "${ORIGINAL_ICON_PATH}" "${AB_LAUNCHER_FOLDER}/icon.png"
		fi
	fi
	
	return 0
}

export RB_PATCHLOG="/media/retroarch/logs/update.log"

MODFILE="${1}"

MODROOT="/media/RB_PATCH/media/project_eris/etc/project_eris/SUP/launchers"

chmod +x /media/retroarch/retroboot/compat/busybox
cd /media/RB_PATCH

/media/retroarch/retroboot/compat/busybox ar -x "${MODFILE}"
rm "${MODFILE}"
rm ./control.tar.gz
rm ./debian-binary

if [ ! -f ./data.tar.xz ]; then
	printf "\nERROR: Could not extract data.tar.xz." >> $RB_PATCHLOG
	exit 1;
fi

/media/retroarch/retroboot/compat/busybox tar -xf ./data.tar.xz
rm ./data.tar.xz

if [ ! -d "${MODROOT}" ]; then
	printf "\nERROR: Could not extract launcher directory." >> $RB_PATCHLOG
	rm -rf "/media/RB_PATCH/media/"
	exit 1;
fi

MOD_INSTALLED=0

for MODDIR in "${MODROOT}/"*"/"
do

	MODTRIMMED=$(echo "${MODDIR}" | sed 's:/*$::')
	modinstall "${MODTRIMMED}"
	MOD_RESULT=$?
	
	if [ $MOD_RESULT -eq 0 ]; then
		MOD_INSTALLED=1
	fi	
done

	rm -rf "/media/RB_PATCH/media/"

if [ $MOD_INSTALLED -eq 0 ]; then
	exit 2
fi

exit 0
