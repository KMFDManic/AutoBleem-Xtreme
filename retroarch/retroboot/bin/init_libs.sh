#!/bin/sh

# RetroBoot 1.1.0 - init_libs.sh
# Sets up application libraries

libdestpath="${RB_LIBRARY_PATH}"
libsourcepath=/media/retroarch/retroboot/assets/lib

# Link or copy library
mkdir "${libdestpath}"
cd "${libdestpath}"

for sourcelib in "${libsourcepath}/"*.so.*
do
	
	baselib="${libdestpath}/$(basename $sourcelib)"
	if [ $RB_LIBCACHE -eq 1 ]; then
		cp "${sourcelib}" "${baselib}"
	else
		ln -s "${sourcelib}" "${baselib}"
	fi
	
	shortlib="${baselib}"
	
	while extn=$(echo $shortlib | sed -n '/\.[0-9][0-9]*$/s/.*\(\.[0-9][0-9]*\)$/\1/p')
          [ -n "$extn" ]
    do
        shortlib=$(basename "${shortlib}" "${extn}")
		if [ $RB_LIBCACHE -eq 1 ]; then
			ln -s "${baselib}" "${shortlib}"
		else
			ln -s "${sourcelib}" "${shortlib}"
		fi
    done
	
done
