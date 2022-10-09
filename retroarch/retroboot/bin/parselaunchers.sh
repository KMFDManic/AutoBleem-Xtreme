#!/bin/sh

# RetroBoot 1.1.0 - parselaunchers.sh
# Parses .rblaunchers and builds Applications playlist

writelpl()
{
	echo "$1" >> /media/retroarch/playlists/Applications.lpl
}

writegamelist()
{
	echo "$1" >> /media/retroarch/retroboot/emulationstation/.emulationstation/gamelists/ports/gamelist.xml
}

# Start a new log when launchers refresh
echo "Parsing Launchers" > /media/retroarch/logs/apps.log

if [ ! -d /media/retroarch/retroboot/applaunchers/ ]; then
	echo "Launcher directory not found!" >> /media/retroarch/logs/apps.log
	exit 0
fi

LAUNCHERCOUNT=0

if ls /media/retroarch/retroboot/applaunchers/*.rblauncher 1> /dev/null 2>&1 || ls /media/retroarch/retroboot/applaunchers/*.rbolauncher 1> /dev/null 2>&1; then
 	
	echo "Found launchers." >> /media/retroarch/logs/apps.log
	rm  /media/retroarch/playlists/Applications.lpl
	
	writelpl "{"
	writelpl "  \"version\": \"1.2\","
	writelpl "  \"default_core_path\": \"/media/retroarch/cores/app_launcher_rb_libretro.so\","
	writelpl "  \"default_core_name\": \"App Launcher RB\","

	writelpl "  \"items\": ["
	
	echo "Wrote playlist header." >> /media/retroarch/logs/apps.log
	
	for LAUNCHER in /media/retroarch/retroboot/applaunchers/*.rblauncher /media/retroarch/retroboot/applaunchers/*.rbolauncher; do 
		if [ ! -f "$LAUNCHER" ]; then
			continue
		fi

		if [ "$LAUNCHERCOUNT" -gt 0 ]; then
			writelpl ","
		else
			LAUNCHERCOUNT=1
		fi
		
		sed -i 's/\r//g' "$LAUNCHER"
		source "$LAUNCHER"
		
		writelpl "    {" 
		writelpl "    \"path\": \"$LAUNCHER\","
		writelpl "    \"label\": \"$LAUNCHER_LABEL\","
		writelpl "    \"core_path\": \"/media/retroarch/cores/app_launcher_rb_libretro.so\","
		writelpl "    \"core_name\": \"$LAUNCHER_DESCRIPTION\","
		writelpl "    \"crc32\": \"00000000|crc\","
		writelpl "    \"db_name\": \"Applications.lpl\""
		writelpl "    }" 
		
		echo "Added $LAUNCHER_LABEL to playlist." >> /media/retroarch/logs/apps.log
	
	done

	writelpl "  ]"
	writelpl "}"
else
	echo "No launchers found!" >> /media/retroarch/logs/apps.log
fi

if [ $LAUNCHERCOUNT -eq 0 ]; then
	echo "Deleting launcher playlist." >> /media/retroarch/logs/apps.log
	rm /media/retroarch/playlists/Applications.lpl
fi

LAUNCHERCOUNT=0
if ls /media/retroarch/retroboot/applaunchers/*.rblauncher 1> /dev/null 2>&1 || ls /media/retroarch/retroboot/applaunchers/*.eslauncher 1> /dev/null 2>&1; then
 	
	echo "Found ES launchers." >> /media/retroarch/logs/apps.log
	rm  /media/retroarch/retroboot/emulationstation/.emulationstation/gamelists/ports/gamelist.xml
	
	writegamelist "<?xml version=\"1.0\"?>"
	writegamelist "<gameList>"
	
	echo "Wrote ES game list header." >> /media/retroarch/logs/apps.log
	
	for LAUNCHER in /media/retroarch/retroboot/applaunchers/*.rblauncher /media/retroarch/retroboot/applaunchers/*.eslauncher; do 
		if [ ! -f "$LAUNCHER" ]; then
			continue
		fi

		LAUNCHERCOUNT=1
		
		sed -i 's/\r//g' "$LAUNCHER"
		source "$LAUNCHER"
		
		RA_ICON_FILENAME="${LAUNCHER_LABEL}.png"
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
		
		writegamelist "<game>"
		writegamelist "<path>$LAUNCHER</path>"
		writegamelist "<name>$LAUNCHER_LABEL</name>"
		writegamelist "<desc>$LAUNCHER_DESCRIPTION</desc>"
		writegamelist "<image>/media/retroarch/thumbnails/Applications/Named_Boxarts/$RA_ICON_FILENAME</image>"
		writegamelist "</game>"
		
		echo "Added $LAUNCHER_LABEL to ES game list." >> /media/retroarch/logs/apps.log
	
	done

	writegamelist "</gameList>"
	
else
	echo "No ES launchers found!" >> /media/retroarch/logs/apps.log
fi

if [ $LAUNCHERCOUNT -eq 0 ]; then
	echo "Deleting ES game list." >> /media/retroarch/logs/apps.log
	rm /media/retroarch/retroboot/emulationstation/.emulationstation/gamelists/ports/gamelist.xml
fi

rm /media/retroarch/retroboot/applaunchers/.updatelaunchers
