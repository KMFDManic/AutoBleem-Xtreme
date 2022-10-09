#!/bin/sh
	
# compat_patch
# Script and config patcher

PATCHER_VERSION=1

patch_script()
{
	sed -i 's/\r//g' "${1}"
	sed -i '/\/data\/power\/disable/d' "${1}"
	sed -i '/\/tmp\/launchfilecommand/d' "${1}"
	sed -i 's|/var/volatile/project_eris.cfg|/media/retroarch/retroboot/compat/compat_environment.sh|g' "${1}"
	sed -i "s|/var/volatile/launchtmp|${2}|g" "${1}"
	sed -i 's|/project_eris/etc/project_eris/SUP/launchers/|/retroarch/apps/compat/|g' "${1}"
	sed -i 's|${PROJECT_ERIS_PATH}/bin/sdl_input_text_display|sh /media/retroarch/retroboot/compat/compat_select.sh|g' "${1}"
	sed -i 's|${PROJECT_ERIS_PATH}/bin/sdl_text_display|sh /media/retroarch/retroboot/compat/compat_display.sh|g' "${1}"
	sed -i 's|${PROJECT_ERIS_PATH}/etc/boot_menu/|/media/retroarch/retroboot/compat/|g' "${1}"
	sed -i 's|${PROJECT_ERIS_PATH}/lib|/tmp/rblib|g' "${1}"
	sed -i 's|/media/project_eris/lib|/tmp/rblib|g' "${1}"
}

patch_cfg()
{
	sed -i "s|/var/volatile/launchtmp|${2}|g" "${1}"
	sed -i 's|/project_eris/etc/project_eris/SUP/launchers/|/retroarch/apps/compat/|g' "${1}"
}

mark_dir()
{
	echo "#!/bin/sh" > "${1}/.compat_patch_version"
	echo "patch_version=${PATCHER_VERSION}" >> "${1}/.compat_patch_version" 
}

compat_original()
{
	COMPAT_FILE="${1}"
	if [ -f "${COMPAT_FILE}.compat_original" ]; then
		rm "${COMPAT_FILE}"
		cp "${COMPAT_FILE}.compat_original" "${COMPAT_FILE}"
	else
		cp "${COMPAT_FILE}" "${COMPAT_FILE}.compat_original"
	fi
}

ROOTDIR="${1}"

if [ ! -z "${2}" ]; then
	FIXDIR="${2}"
else
	FIXDIR="${1}"
fi

if [ -d "${FIXDIR}" ]; then

	DIR_PATCHED=0
	patch_version=0

	cd "${FIXDIR}"
	
	if [ -f "${FIXDIR}/.compat_patch_version" ]; then
		source "${FIXDIR}/.compat_patch_version"
	fi
	
	if [ ${PATCHER_VERSION} -gt ${patch_version} ] || [ ${RB_FORCE_COMPAT_PATCH} -gt 0 ]; then
		
		for FILE in *.sh; do
			if [ -f "${FILE}" ]; then
				compat_original "${FILE}"
				patch_script "${FILE}" "${ROOTDIR}"
				DIR_PATCHED=1
			fi
		done

		for FILE in *.cfg *.CFG *.ini *.INI *.txt *.TXT *.conf *.config *.xml .[^.]*; do
			if [ -f "${FILE}" ]; then
				compat_original "${FILE}"
				patch_cfg "${FILE}" "${ROOTDIR}"
				DIR_PATCHED=1
			fi
		done
		
		if [ ${DIR_PATCHED} -eq 1 ]; then
			mark_dir "${FIXDIR}"
		fi
		
		for SUBDIR in * .[^.]* ; do
			if [ -d "${SUBDIR}" ]; then
				sh /media/retroarch/retroboot/compat/compat_patch.sh "${ROOTDIR}" "${SUBDIR}"
			fi
		done
	fi
fi
