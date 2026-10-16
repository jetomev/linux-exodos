#!/usr/bin/env bash
# exo-setup.sh — run the eXo "Setup eXoDOS" step from any shell, no root, answers chosen by us.
# Flags pass through: --fullscreen (default windowed), --hide-adult (default listed), --size L|M|S (default from Sway).
set -uo pipefail
X=/mnt/exodos/eXoDOS; P=/mnt/exodos/linux-exodos
LOG=$P/logs/exo-setup-$(date +%Y%m%d-%H%M%S).log; ln -sfn "$LOG" $P/logs/exo-setup-latest
echo "== exo-setup.sh $(date '+%F %T') $*" | tee -a "$LOG"
mountpoint -q /mnt/exodos || { echo "!! /mnt/exodos not mounted" | tee -a "$LOG"; exit 1; }
n=$(flatpak list --user --app --columns=application 2>/dev/null | grep -c retro_exo)
[ "$n" -ge 15 ] || { echo "!! only $n eXo flatpaks installed; run scripts/exo-install-dependencies.sh first" | tee -a "$LOG"; exit 1; }
args=("$@")
if [[ ! " $* " =~ " --size " ]]; then
  h=$(swaymsg -t get_outputs 2>/dev/null | python3 -I -c 'import sys,json; o=[o for o in json.load(sys.stdin) if o.get("active")]; print(max(x["current_mode"]["height"] for x in o) if o else 1080)' 2>/dev/null || echo 1080)
  if [ "$h" -ge 2000 ]; then s=L; elif [ "$h" -ge 1080 ]; then s=M; else s=S; fi
  args+=(--size "$s"); echo "-- screen height $h → size $s" | tee -a "$LOG"
fi
python3 -I "$P/scripts/exo-setup-driver.py" "$X" "$LOG" "${args[@]}"; rc=$?
echo "-- driver exit $rc" | tee -a "$LOG"
ls "$X"/exogui.command "$X"/eXo/util/*.SEL 2>&1 | tee -a "$LOG"
[ $rc = 0 ] && echo "OK $(date '+%F %T')" | tee -a "$LOG" || echo "FAILED $(date '+%F %T')" | tee -a "$LOG"
exit $rc
