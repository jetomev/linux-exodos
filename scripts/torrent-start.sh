#!/usr/bin/env bash
# torrent-start.sh — start transmission for the eXoDOS downloads and add the torrents.
# Runs as Javier (no root). State in /mnt/exodos/.transmission, PID file there (never pkill -f).
set -euo pipefail
ROOT=/mnt/exodos; P=$ROOT/linux-exodos; ST=$ROOT/.transmission
LOG=$P/logs/torrent-start-$(date +%Y%m%d-%H%M%S).log; ln -sfn "$LOG" $P/logs/torrent-start-latest
exec > >(tee -a "$LOG") 2>&1
echo "== torrent-start.sh $(date '+%F %T')"
mountpoint -q $ROOT || { echo "!! $ROOT not mounted — stopping"; exit 1; }
mkdir -p $ST
if [ -f $ST/daemon.pid ] && kill -0 "$(cat $ST/daemon.pid)" 2>/dev/null; then
  echo "-- daemon already running, pid $(cat $ST/daemon.pid)"
else
  echo "-- starting transmission-daemon (downloads → $ROOT, seed ratio 2, then stop)"
  transmission-daemon -g $ST -w $ROOT -x $ST/daemon.pid --global-seedratio 2 \
    --logfile $ST/daemon.log --log-level=info
  sleep 3; echo "   pid $(cat $ST/daemon.pid)"
fi
for t in "$@"; do echo "-- adding $t"; transmission-remote -a "$t"; done
sleep 2; transmission-remote -l
echo "OK $(date '+%F %T')"
