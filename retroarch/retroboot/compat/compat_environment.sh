# compat_environment
# Sets up environment for apps

export LD_LIBRARY_PATH="${RB_LIBRARY_PATH}"
export PROJECT_ERIS_PATH="/media/retroarch/retroboot/compat"
export RUNTIME_LOG_PATH="/media/retroarch/logs/compat"
if [ ! -d $RUNTIME_LOG_PATH ]; then
	mkdir $RUNTIME_LOG_PATH
fi
