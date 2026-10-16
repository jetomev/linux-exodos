#!/usr/bin/env bash
# torrent-status.sh — one screen: what transmission is doing. No root.
transmission-remote -l 2>/dev/null || { echo "transmission is not running (scripts/torrent-start.sh starts it)"; exit 1; }
echo; df -h /mnt/exodos | tail -1
