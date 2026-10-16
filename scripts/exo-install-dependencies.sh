#!/usr/bin/env bash
# exo-install-dependencies.sh — run the eXo patch's dependency installer safely, from any shell, no root.
# Why a wrapper: the eXo script runs `sudo pacman --noconfirm -Syu` if ANY tool it wants is missing.
# On KognogOS that must never happen (nog holds packages by tier), so this refuses to start unless
# every tool is present. Then it answers the prompts (P, any key, any key) and logs everything.
set -uo pipefail
X=/mnt/exodos/eXoDOS; P=/mnt/exodos/linux-exodos
LOG=$P/logs/exo-install-dependencies-$(date +%Y%m%d-%H%M%S).log; ln -sfn "$LOG" $P/logs/exo-install-dependencies-latest
exec > >(tee -a "$LOG") 2>&1
echo "== exo-install-dependencies.sh $(date '+%F %T')"
mountpoint -q /mnt/exodos || { echo "!! /mnt/exodos not mounted"; exit 1; }
missing=0
for c in curl ffmpeg flatpak fold perl python3 sed sha256sum tput unzip wget zip; do
  command -v "$c" >/dev/null || { echo "!! missing: $c (install it with nog first; the eXo script would run pacman -Syu)"; missing=1; }
done
[ $missing = 0 ] || exit 1
ls "$X"/eXo/util/util*_linux*.zip.part 2>/dev/null && { echo "!! the Linux util zip is still downloading"; exit 1; }
[ -L ~/.local/share/flatpak ] && echo "-- user flatpaks go to $(readlink ~/.local/share/flatpak)"
echo "-- running eXo/util/install_dependencies.bsh (answers: P, then any key twice)"
export TERM=${TERM:-dumb}
cd "$X/eXo/util" && printf 'P\nxx' | bash ./install_dependencies.bsh; rc=$?
echo "-- installer exit $rc"
echo "-- eXo flatpaks now installed:"; flatpak list --user --app --columns=application | grep -c retro_exo || true
echo "-- runtimes:"; flatpak list --user --runtime --columns=application,branch
du -sh /mnt/exodos/flatpak
[ $rc = 0 ] && echo "OK $(date '+%F %T')" || echo "FAILED $(date '+%F %T')"
exit $rc
