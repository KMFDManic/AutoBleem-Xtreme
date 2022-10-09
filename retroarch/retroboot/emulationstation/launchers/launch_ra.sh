#!/bin/sh
corename="${1}"
rompath="${2}"
shift
shift
export LD_LIBRARY_PATH="/media/retroarch/retroboot/lib:${LD_LIBRARY_PATH}"
/media/retroarch/retroarch --config /media/retroarch/retroarch.cfg -L "/media/retroarch/cores/${corename}" -v "${@}" "${rompath}"
 &> /media/retroarch/logs/retroarch.log
