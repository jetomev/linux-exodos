# Linux - eXoDos · TODO

*Kept current as we go. Newest at the top of each list.*

## Next
- [ ] 4. Run `install_dependencies.command` and read what it wants to install on Arch (F-1: Flatpak vs nog's `dosbox-staging`)
- [ ] 3. Read `eXoDOS Linux ReadMe.txt` once the patch has landed; update the research note
- [ ] 1b. `dosbox-staging` through nog: blocked by a chaotic-aur 404 on two-day-old lists; nog's answer is a full `nog update` (Javier's call), or the patch's own installer may make it moot

## Then
- [ ] Run `Setup eXoDOS.command`, then `exogui.command`; first game: Secret of Monkey Island
- [ ] Check exogui (Electron) under Sway/Wayland
- [ ] Decide: official patch route vs Exodium (native launcher, 0.15.4 on 2026-10-15)
- [ ] Findings as GitHub issues (F-1 Flatpak, F-2 nothing on the AUR, F-3 `.command` scripts need a terminal on Sway)
- [ ] Full release later, on a healthier disk or after an 18-hour write/read test of this one

## Done
- [x] 2026-10-16 15:15 Lite + Linux patch torrents started (`scripts/torrent-start.sh`, 31 MB/s, the USB 2.0 ceiling); `scripts/torrent-status.sh` shows progress
- [x] 2026-10-16 `transmission-cli` installed through nog
- [x] 2026-10-16 GitHub `jetomev/linux-exodos`: README, About, 9 topics, issues #1 F-1, #2 F-2, #3 F-3, #4 first-game tracker
- [x] 2026-10-16 Vault folder `Linux - eXoDos` + hub; memory `project_linux_exodos`
- [x] 2026-10-16 Research written (`docs/research/2026-10-16-exodos-on-linux.md`)
- [x] 2026-10-16 Disk formatted ext4 `exodos` → `/mnt/exodos`, fstab updated (`scripts/format-exodos-disk.sh`, log in `logs/`)
- [x] 2026-10-16 Torrent files fetched and measured: full 697.6 GB / 14,011 files · Lite 6.6 GB · Linux patch 2.7 GB
- [x] 2026-10-16 SMART on the WD My Book: PASSED but 167 pending + 150 uncorrectable sectors, 129,825 h → Lite only (Javier's call)

## Decisions
- D-1 (2026-10-16, Javier) Lite on this disk; he downloads what he wants to play. Full stays off it.
- D-2 (2026-10-16) ext4, label `exodos`, `/mnt/exodos`. Repo and collection side by side, collection never in git.
