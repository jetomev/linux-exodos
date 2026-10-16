#!/usr/bin/env bash
# exo-play.sh <game folder> — install (download, on Lite) and launch one eXoDOS game from any shell, no root.
# The folder is the short name under eXo/eXoDOS/!dos/ (mi1 = The Secret of Monkey Island). Answers: download yes,
# aspect on, default scaler, keep saves. The game's own window opens; this script waits until it is closed.
set -uo pipefail
X=/mnt/exodos/eXoDOS; P=/mnt/exodos/linux-exodos
g=${1:?game folder under eXo/eXoDOS/!dos/, e.g. mi1}
D="$X/eXo/eXoDOS/!dos/$g"; [ -d "$D" ] || { echo "!! no such game folder: $D"; exit 1; }
S=$(ls "$D"/*\).bsh 2>/dev/null | head -1); [ -n "$S" ] || { echo "!! no launcher .bsh in $D"; exit 1; }
LOG=$P/logs/exo-play-$g-$(date +%Y%m%d-%H%M%S).log; ln -sfn "$LOG" "$P/logs/exo-play-$g-latest"
echo "== exo-play.sh $g $(date '+%F %T')  $(basename "$S")" | tee -a "$LOG"
mountpoint -q /mnt/exodos || { echo "!! /mnt/exodos not mounted" | tee -a "$LOG"; exit 1; }
python3 -I "$P/scripts/exo-driver.py" --mode play "$D" "$S" "$LOG" & echo $! > "/mnt/exodos/.exo-play-$g.pid"; wait $!; rc=$?; rm -f "/mnt/exodos/.exo-play-$g.pid"
echo "-- driver exit $rc $(date '+%F %T')" | tee -a "$LOG"
ls "$X/eXo/eXoDOS/$(basename "${S%.bsh}").zip" "$X/eXo/eXoDOS/$g" 2>&1 | head -3 | tee -a "$LOG"
exit $rc
