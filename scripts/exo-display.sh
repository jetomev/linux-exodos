#!/usr/bin/env bash
# exo-display.sh fullscreen|windowed [small|medium|large] — the global screen setting for every DOSBox game, no root.
# Uses eXo's own switches: the .SEL marker files in eXo/util that launch.bsh applies to options_linux.conf at every launch.
# Window sizes are eXo's three: small 640x480, medium 1280x960, large 2560x1920. Alt+Enter in a game toggles either way.
set -euo pipefail
X=/mnt/exodos/eXoDOS; U=$X/eXo/util; C=$X/eXo/emulators/dosbox/options_linux.conf
mode=${1:?fullscreen or windowed}; size=${2:-}
case $mode in
  fullscreen) rm -f $U/WIN.SEL; : > $U/FULL.SEL; sed -i 's|^fullscreen=false|fullscreen=true|' "$C";;
  windowed)   rm -f $U/FULL.SEL; : > $U/WIN.SEL; sed -i 's|^fullscreen=true|fullscreen=false|' "$C";;
  *) echo "!! fullscreen or windowed"; exit 1;;
esac
if [ -n "$size" ]; then
  rm -f $U/SML.SEL $U/MED.SEL $U/LRG.SEL
  case $size in
    small)  : > $U/SML.SEL; r=640x480;;
    medium) : > $U/MED.SEL; r=1280x960;;
    large)  : > $U/LRG.SEL; r=2560x1920;;
    *) echo "!! small, medium or large"; exit 1;;
  esac
  sed -i "s|^windowresolution=.*|windowresolution=$r|" "$C"
fi
echo "DOSBox default now: $(grep -E '^fullscreen=' "$C"), window $(grep -E '^windowresolution=' "$C" | cut -d= -f2), markers: $(cd $U && ls *.SEL | tr '\n' ' ')"
