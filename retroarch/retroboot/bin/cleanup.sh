#!/bin/sh

# Retroboot 1.1.0 - cleanup.sh
# Cleans up temporary files before shutdown

# Clean up RetroBoot temp folder.
rm -rf "/tmp/retroboot"

# Clean up RetroArch cache folder
rm -rf "/tmp/ra_cache"

# Clean up RetroArch cache folder
rm -rf "/tmp/rblib"

# Flush disk cache
if [ $RB_MODE -eq 0 -o $RB_SYNCFSAB -ne 0 ]; then
	sync
fi
