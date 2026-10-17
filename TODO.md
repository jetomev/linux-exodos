# Linux - eXoDos · TODO

*Kept current as we go. Newest at the top of each list.*

## Next
- [x] 6. A game started from exogui's Play button (#7) — 2026-10-17, Javier: "installing and running games perfectly": Double Dragon I/II/III and Dune installed and played from exogui. Works because Konsole is installed (on the wrappers' 18-terminal list); #6 stays open for Alacritty alone
- [ ] 1b. `dosbox-staging` through nog: blocked by a chaotic-aur 404 on two-day-old lists; nog's answer is a full `nog update` (Javier's call), or the patch's own installer may make it moot

## Then
- [ ] `scripts/exo-check.sh`: compare the NVIDIA driver version with the Flatpak GL extension (`org.freedesktop.Platform.GL.nvidia-*`); mismatch after a `nog update` = games won't start until `flatpak update --user -y` (eXo ReadMe, Troubleshooting). Today both are 615.71.09.
- [x] Check exogui (Electron) under Sway/Wayland — runs through XWayland, Install and Play both work (2026-10-17)
- [ ] Decide: official patch route vs Exodium (native launcher, 0.15.4 on 2026-10-15)
- [ ] exogui 1.1.11 (bundled) vs 1.2.58 (GitHub): try the newer AppImage in `exogui/`
- [ ] Stop/clean: `scripts/exo-stop.sh` (transmission by PID file, exogui by PID file, a running game by `/mnt/exodos/.exo-play-<g>.pid`)
- [ ] Full release later, on a healthier disk or after an 18-hour write/read test of this one

## Done
- [x] 2026-10-16 17:00 eXoDOS in the application launcher (Javier asked): `exodos.desktop` in the repo (Categories=Game, eXo's icon), linked by `scripts/exo-install-launcher.sh` into `~/.local/share/applications` → hypeForge's Games group
- [x] 2026-10-16 16:50 Javier: "window may be too small" → `scripts/exo-display.sh fullscreen` (eXo's own FULL.SEL marker + options_linux.conf); `windowed [small|medium|large]` flips it back; Alt+Enter in a game toggles
- [x] 2026-10-16 16:45 **Javier: "game ran perfectly"** (Monkey Island CD, 34 min, MT-32 music). #4 closed, #7 opened for the exogui Play button
- [x] 2026-10-16 16:43 Monkey Island session ended cleanly after 34 min (exit 0; DOSBox used the MT-32 ROMs for music: "MT32: LCD-Message: Lucasfilm Games")
- [x] 2026-10-16 16:09 **First game.** `scripts/exo-play.sh mi1`: downloaded 1.65 GB from the torrent in <3 min, unpacked, DOSBox ECE r4482 (eXo Flatpak) opened Monkey Island's version menu. Two driver fixes on the way (`change any of these?` → No; the version menu → IBM/VGA)
- [x] 2026-10-16 15:46 exogui runs on Sway (XWayland): 7,667 games listed; `docs/images/2026-10-16-exogui-first-launch.png`
- [x] 2026-10-16 15:44 `scripts/exo-setup.sh`: "Your eXoPacks are now setup" (windowed 1280x960, aspect on, no icon)
- [x] 2026-10-16 15:35 `scripts/exo-install-dependencies.sh`: 7 runtimes + 21 eXo Flatpaks on `/mnt/exodos/flatpak`, 8.9 GB, NVIDIA GL pulled automatically
- [x] 2026-10-16 15:23 Lite + Linux patch fully downloaded (9.3 GB); ReadMe read; F-4 #5, F-5 #6 opened; `zip` installed through nog so F-4 can't bite
- [x] 2026-10-16 15:15 Lite + Linux patch torrents started (`scripts/torrent-start.sh`, 31 MB/s, the USB 2.0 ceiling); `scripts/torrent-status.sh` shows progress
- [x] 2026-10-16 `transmission-cli` installed through nog
- [x] 2026-10-16 GitHub `jetomev/linux-exodos`: README, About, 9 topics, issues #1 F-1, #2 F-2, #3 F-3, #4 first-game tracker
- [x] 2026-10-16 Vault folder `Linux - eXoDos` + hub; memory `project_linux_exodos`
- [x] 2026-10-16 Research written (`docs/research/2026-10-16-exodos-on-linux.md`)
- [x] 2026-10-16 Disk formatted ext4 `exodos` → `/mnt/exodos`, fstab updated (`scripts/format-exodos-disk.sh`, log in `logs/`)
- [x] 2026-10-16 Torrent files fetched and measured: full 697.6 GB / 14,011 files · Lite 6.6 GB · Linux patch 2.7 GB
- [x] 2026-10-16 SMART on the WD My Book: PASSED but 167 pending + 150 uncorrectable sectors, 129,825 h → Lite only (Javier's call)

## Decisions
- D-5 (2026-10-16, Javier) Fullscreen by default: eXo's window sizes top out at 1280x960 below the 2560x1920 that is taller than his 1440 screens.
- D-3 (2026-10-16) Setup answers, in `scripts/exo-setup.sh`: adult games stay listed (filter in exogui, nothing is deleted either way) · windowed first (the Updater can flip it) · aspect correction on · no desktop icon · window size from Sway's screen height. Flags `--fullscreen`, `--hide-adult`, `--size` change them.
- D-4 (2026-10-16) The patch's Flatpaks are strictly needed (21 eXo builds hard-wired per game, F-1); they live on the project disk via `~/.local/share/flatpak → /mnt/exodos/flatpak`.
- D-1 (2026-10-16, Javier) Lite on this disk; he downloads what he wants to play. Full stays off it.
- D-2 (2026-10-16) ext4, label `exodos`, `/mnt/exodos`. Repo and collection side by side, collection never in git.
