# Linux - eXoDos · TODO

*Kept current as we go. Newest at the top of each list.*

## Next
- [ ] 4. Run `install_dependencies.command` and read what it wants to install on Arch (F-1: Flatpak vs nog's `dosbox-staging`)
- [ ] 3. Read `eXoDOS Linux ReadMe.txt` once the patch has landed; update the research note
- [ ] 2. Download eXoDOS Lite (6.6 GB) + the Linux patch (2.7 GB) into `/mnt/exodos/eXoDOS` with transmission
- [ ] 1. Install `transmission-cli` + `dosbox-staging` through nog

## Then
- [ ] Run `Setup eXoDOS.command`, then `exogui.command`; first game: Secret of Monkey Island
- [ ] Check exogui (Electron) under Sway/Wayland
- [ ] Decide: official patch route vs Exodium (native launcher, 0.15.4 on 2026-10-15)
- [ ] Findings as GitHub issues (F-1 Flatpak, F-2 nothing on the AUR, F-3 `.command` scripts need a terminal on Sway)
- [ ] Full release later, on a healthier disk or after an 18-hour write/read test of this one

## Done
- [x] 2026-10-16 Research written (`docs/research/2026-10-16-exodos-on-linux.md`)
- [x] 2026-10-16 Disk formatted ext4 `exodos` → `/mnt/exodos`, fstab updated (`scripts/format-exodos-disk.sh`, log in `logs/`)
- [x] 2026-10-16 Torrent files fetched and measured: full 697.6 GB / 14,011 files · Lite 6.6 GB · Linux patch 2.7 GB
- [x] 2026-10-16 SMART on the WD My Book: PASSED but 167 pending + 150 uncorrectable sectors, 129,825 h → Lite only (Javier's call)

## Decisions
- D-1 (2026-10-16, Javier) Lite on this disk; he downloads what he wants to play. Full stays off it.
- D-2 (2026-10-16) ext4, label `exodos`, `/mnt/exodos`. Repo and collection side by side, collection never in git.
