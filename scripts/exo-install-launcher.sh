#!/usr/bin/env bash
# exo-install-launcher.sh — put eXoDOS in the desktop's application launcher (hypeForge: Win+Space → Games). No root.
# The real file is the repo's exodos.desktop; this links it into ~/.local/share/applications. Run again = no change.
set -euo pipefail
P=/mnt/exodos/linux-exodos; A=~/.local/share/applications; mkdir -p "$A"
[ -x /mnt/exodos/eXoDOS/exogui.command ] || chmod +x /mnt/exodos/eXoDOS/exogui.command
ln -sfn "$P/exodos.desktop" "$A/exodos.desktop"
command -v desktop-file-validate >/dev/null && desktop-file-validate "$P/exodos.desktop" && echo "entry valid"
command -v update-desktop-database >/dev/null && update-desktop-database "$A" 2>/dev/null || true
echo "linked: $A/exodos.desktop → $(readlink "$A/exodos.desktop")"
