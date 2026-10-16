#!/usr/bin/env bash
# format-exodos-disk.sh — turn the old WD My Book "Backup" disk into the eXoDOS project disk.
# One ext4 partition, label "exodos", mounted at /mnt/exodos, in fstab. Runs as root (sudo -A -k).
set -euo pipefail
LOG=${1:?log path}
exec > >(tee -a "$LOG") 2>&1
echo "== format-exodos-disk.sh  $(date '+%F %T')  user=$(id -un)"
DEV=/dev/sdc
WANT_SERIAL=WD-WMAVU2854761
OLD_MNT=/mnt/backup
NEW_MNT=/mnt/exodos
OWNER=1000

echo "-- 1. identity check"
serial=$(udevadm info -q property -n "$DEV" | sed -n 's/^ID_SERIAL_SHORT=//p')
model=$(udevadm info -q property -n "$DEV" | sed -n 's/^ID_MODEL=//p')
echo "   $DEV = $model serial=$serial"
[ "$serial" = "$WANT_SERIAL" ] || { echo "!! serial mismatch (wanted $WANT_SERIAL) — stopping, nothing touched"; exit 1; }
lsblk -no NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT "$DEV"

echo "-- 2. unmount"
for m in $(lsblk -no MOUNTPOINT "$DEV" | grep -v '^$'); do echo "   umount $m"; umount "$m"; done
lsblk -no MOUNTPOINT "$DEV" | grep -q . && { echo "!! still mounted — stopping"; exit 1; }

echo "-- 3. wipe old layout + new GPT with one partition"
wipefs -a "${DEV}1" 2>/dev/null || true
wipefs -a "$DEV"
parted -s "$DEV" mklabel gpt mkpart exodos ext4 1MiB 100%
udevadm settle; sleep 2
PART=${DEV}1
[ -b "$PART" ] || { echo "!! $PART missing"; exit 1; }

echo "-- 4. mkfs.ext4 (label exodos, no reserved root space: data disk)"
mkfs.ext4 -q -L exodos -m 0 "$PART"
UUID=$(blkid -s UUID -o value "$PART")
echo "   UUID=$UUID"

echo "-- 5. fstab: drop the old $OLD_MNT line, add $NEW_MNT"
cp -a /etc/fstab "/etc/fstab.bak-exodos-$(date +%Y%m%d-%H%M%S)"
sed -i "\|[[:space:]]$OLD_MNT[[:space:]]|d" /etc/fstab
grep -q "[[:space:]]$NEW_MNT[[:space:]]" /etc/fstab && sed -i "\|[[:space:]]$NEW_MNT[[:space:]]|d" /etc/fstab
printf 'UUID=%s  %s  ext4  defaults,noatime,nofail,x-systemd.device-timeout=10s  0 2\n' "$UUID" "$NEW_MNT" >> /etc/fstab
grep -n "$NEW_MNT" /etc/fstab

echo "-- 6. mount + ownership"
mkdir -p "$NEW_MNT"
systemctl daemon-reload
mount "$NEW_MNT"
chown $OWNER:$OWNER "$NEW_MNT"
chmod 755 "$NEW_MNT"
[ -d "$OLD_MNT" ] && rmdir "$OLD_MNT" 2>/dev/null && echo "   removed empty $OLD_MNT"

echo "-- 7. result"
findmnt -no SOURCE,FSTYPE,SIZE,AVAIL,OPTIONS "$NEW_MNT"
lsblk -no NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT "$DEV"
echo "OK  $(date '+%F %T')"
