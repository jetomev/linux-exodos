# eXoDOS on Linux — what we know (2026-10-16)

*Research for the Linux - eXoDos project, written by Claude for Javier. Plain words; a term gets explained the first time it shows up.*

## What eXoDOS is

eXoDOS is a curated collection of DOS games (the games people played on PCs in the 1980s and 1990s), already set up to run inside DOSBox (a program that pretends to be an old PC so those games work on a modern one). Every game comes with its settings, manuals, box art and a catalog. It is made by "eXo" and a team of volunteers, and lives at https://www.retro-exo.com. The current version is **6.04**.

The collection is built for Windows: its front end (the program you browse the games in) is LaunchBox, a Windows program. Linux support comes from a **community patch** maintained by volunteers (parricc, jelcynek, Colin), with its own front end called **exogui**.

## The downloads (measured from the torrent files, 2026-10-16)

| What | Size | Files | Notes |
|---|---|---|---|
| eXoDOS full (`eXoDOS.torrent`) | **697.6 GB** | 14,011 | The site says 638 GB; the torrent file says 697.6 GB. Everything, offline forever. Biggest single games are 4 to 6.5 GB each (Gabriel Knight 2, Phantasmagoria, Links LS). |
| eXoDOS Lite (`eXoDOS_Lite.torrent`) | **6.6 GB** | 11 | The front end, the catalog and the art for every game. Each game is fetched the first time you play it: **not from a server, but as one file out of the full torrent** (`eXo/util/install.bsh` runs eXo's aria2c Flatpak with `--select-file=<index>` against `eXo/util/aria/eXoDOS.torrent`, index in `index.txt`). Needs internet and torrent peers. |
| Linux patch (`LinuxPatcheXoDOS.torrent`) | **2.7 GB** | 10 | Goes on top of either of the above. Contains `eXoDOS Linux ReadMe.txt`, `Setup eXoDOS.command`, Linux versions of the metadata and the utilities. |
| Media Add-On Pack | 220 GB (site) | | Magazines, books, catalogs, soundtracks, TV shows. Optional. Has its own Linux bits inside. |
| Manual | 10 MB PDF | | `eXoDOS Manual.pdf`, also inside the Lite torrent. |

All of it is distributed by **torrent only**, one tracker, no web seeds, no direct mirrors on the official site. The Internet Archive has some older pieces (the 6.02 update, a Lite listing) but not the full v6 release.

## The official Linux route (the eXo wiki's Linux Patch page)

1. Download eXoDOS (full or Lite) with a torrent client.
2. Download the Linux patch torrent **into the same folder**, so its files land in the collection's root (next to `eXoDOS Catalog.pdf` and `Setup.bat`), not in a subfolder.
3. Run `install_dependencies.command` and pick "[P]roceed". This installs what the games need. The eXo site says the patch supports "nearly any x86_64 distribution with flatpak support", so this step installs **Flatpaks** (self-contained app bundles that sit outside the distro's package manager). Exactly which ones is **unverified** until we have the patch's ReadMe (2.7 GB download). Arch, Manjaro and SteamOS are listed as supported.
4. Run `Setup eXoDOS.command`. It unpacks and rewires the collection for Linux and asks three things: remove adult games or not, fullscreen or windowed, aspect ratio on or off. Do not unpack anything by hand; the setup edits files as it goes.
5. Run `exogui.command`. First time you pick a game it "installs" (unzips) it, then plays. exogui is an Electron app (a web page wrapped as a desktop program), forked from the Flashpoint launcher; latest release **1.2.58 (2026-08-12)**, MIT, AppImage or tar.gz, self-updating.
6. Each game also gets a `<game>.command` and `<game>.bsh` script in its folder, so a game can be launched from a desktop shortcut without exogui.

Works from a portable drive: the wiki says to re-run the dependency installer on each new machine (Flatpaks install per user), and the eXoDOS Updater re-points shortcuts if the folder moves.

Not supported: ARM, Raspberry Pi, macOS, BSD. The German language pack is not converted.

## Three other ways to run it on Linux

| Launcher | What it is | Latest | Needs the official patch? | Notes |
|---|---|---|---|---|
| **Exodium** (tvollstaedt/exodium) | Native desktop app; browse, download and play. Covers eXoDOS, eXoWin3x, eXoWin9x, eXoScummVM, plus the German/Spanish/Polish packs. | **0.15.4, 2026-10-15**, 330 stars, very active | No. Downloads games itself into a folder you pick. | AppImage, .deb, .rpm. Bundles DOSBox Staging. Some games tuned for DOSBox-ECE (3dfx, light gun) may differ. Not on the AUR. |
| **eisoDOS** (cosmix/eisoDOS) | Terminal launcher in Rust: fuzzy search, launches through DOSBox or 86Box. | 0.3.2, 2026-07-21, 1 star | No. Reads the collection's zips as-is. | Unzips a game into a cache on first launch. Win9x games want a copy-on-write filesystem (btrfs) or each launch copies ~400 MB. |
| **exogui standalone** | The same front end the patch uses. | 1.2.58 | It is the patch's front end. | Must sit in an `exogui/` folder inside the collection, or `exodosPath` in `exogui/config.json`. |

Also seen: ExoDOSConverter (turns the collection into an EmulationStation/RetroPie layout) and bradgy/exodos-launcher (older Flashpoint fork). Not pursued.

## What Arch (and nog) already offers

| Package | Repo | Version |
|---|---|---|
| dosbox-staging | chaotic-aur | 0.83.0 |
| dosbox-x | chaotic-aur | 2026.10.01 |
| dosbox (classic 0.74) | extra | 0.74.3 |
| transmission-cli (torrent, headless) | extra | 4.1.3 |
| qbittorrent (torrent, GUI) | extra | 5.2.4 |
| 7zip, unrar, aria2 | extra | yes |
| exodium / exogui / eisodos | AUR | **nothing** |

Already on this machine: git, 7z, unzip, wine. Not installed: any DOSBox, any torrent client.

## KognogOS findings (the rules say: Forge first, nog first, Flatpak only when strictly needed)

- **F-1** (confirmed from the ReadMe and `install_dependencies.bsh`, 15:30) The patch installs **21 Flatpaks built by eXo** (`com.retro_exo.*`: DOSBox 0.74-3, three DOSBox-ECE builds, DOSBox GridC, DOSBox Staging 0.81.2 and 0.82.0, two DOSBox-X builds, GZDoom, two ScummVM builds, Wine, VLC, mpv, Okular, Falkon, mcomix, AbiWord, Gnumeric, aria2c) on **7 Flathub runtimes** (freedesktop 23.08 + 24.08 with their 32-bit halves, GNOME 46, KDE 6.7, KDE 5.15-23.08), all user-level, no root; 86Box comes as an AppImage. Each game's `.bsh` names which build to run (`eXo/util/dosbox_linux.txt`), so a system `dosbox-staging` from nog is not a drop-in: it would mean rewriting that table and accepting conf differences. Verdict: Flatpak is strictly needed for the official route; we keep them on the project disk (`~/.local/share/flatpak` → `/mnt/exodos/flatpak`). Swapping one build for nog's is a later experiment, issue #1 stays open.
- **F-4** (15:30) `install_dependencies.bsh` on Arch runs `sudo pacman --noconfirm -Syu` the moment **any** of its 12 tools is missing (`curl ffmpeg flatpak fold perl python3 sed sha256sum tput unzip wget zip`). On a tier-held KognogOS that is a silent full upgrade. `zip` was the one missing here. Our `scripts/exo-install-dependencies.sh` refuses to start unless all 12 are present, so the branch can never fire.
- **F-5** (15:30) The `.command` wrappers only run from 18 known terminals (konsole, gnome-terminal, xterm…) by looking at the parent process name; otherwise "Weird system achievement unlocked". Alacritty is not on the list. The `.bsh` scripts under `eXo/util/` work from any shell, so we call those.
- **F-2** No launcher (exogui, Exodium, eisoDOS) is packaged for Arch. Exodium and exogui ship as AppImages. A packaging gap, and a candidate for an AUR recipe of ours.
- **F-3** The patch's launch scripts are `.command` / `.bsh` files meant to be double-clicked in a file manager; on Sway with no file manager that is a terminal job. Fine for us.

## The disk (WD My Book 1110, 1 TB, USB 2.0)

SMART on 2026-10-16: overall PASSED, but 129,825 hours on (14.8 years), **167 pending sectors** and **150 offline-uncorrectable sectors**: spots the drive could not read and has not yet been able to swap for spares. 0 reallocated so far. Link is USB 2.0 (480 Mbit, about 30 MB/s): the full collection would need a day or more just to be written. See the project's TODO for the decision.

## Filesystem notes

- Game names contain spaces, commas, apostrophes, `!` and `$` (`$100,000 Pyramid (1988).zip`, `!dos`, `!DOSmetadata.zip`). Any filesystem that handles those; NTFS is fine for the data but bad for git (no permissions, no symlinks) and the `.command` scripts need the executable bit.
- ext4 is the boring reliable choice for a torrent landing zone. btrfs only buys something if we go the eisoDOS Win9x route (reflinks).
- The collection must not live inside the git repo; the repo holds our scripts, docs and findings, `.gitignore` keeps the collection out.

## Installed and running (2026-10-16 15:45)

`scripts/exo-install-dependencies.sh` (10 min: 7 runtimes + 21 eXo Flatpaks, 8.9 GB on the disk, NVIDIA GL extension pulled automatically) → `scripts/exo-setup.sh` (9 min, "Your eXoPacks are now setup. Enjoy!", windowed 1280x960, aspect on) → `exogui.command` opens through XWayland on Sway: 7,667 games listed, search, filters, playlists. Screenshot: `docs/images/2026-10-16-exogui-first-launch.png`. The collection is 29 GB on the disk after setup. exogui bundled with the patch is 1.1.11 (the GitHub release is 1.2.58).

## Open questions

1. Which disk (see SMART above) and full or Lite first.
2. ~~What `install_dependencies.command` installs on Arch~~ answered: F-1, F-4.
3. Whether exogui runs well under Sway/Wayland (Electron; may need `--ozone-platform=wayland`).
4. Whether our DOSBox Staging from chaotic-aur satisfies the patch's game `.conf` files (the wiki says the alternate launcher must be DOSBox Staging "to not break conf files").

## Sources

- eXoDOS site: https://www.retro-exo.com/exodos.html · Linux patches: https://www.retro-exo.com/linux.html
- eXo wiki, Linux Patch: https://wiki.retro-exo.com/index.php/Linux_Patch
- exogui: https://github.com/exogui/exogui · Exodium: https://github.com/tvollstaedt/exodium · eisoDOS: https://github.com/cosmix/eisoDOS
- ExoDOSConverter: https://github.com/Voljega/ExoDOSConverter · exodos-launcher: https://github.com/bradgy/exodos-launcher
- Exodium write-up: https://korben.info/en/exodium-exo-dos-games-playable-mac.html
- Sizes: eXoDOS v6 thread https://tinkerdifferent.com/threads/exodos-v6-is-coming-and-its-incredible.2983/ · Windows 11 guide https://gamespheremagazine.wordpress.com/2026/09/11/how-to-install-and-use-exodos-v6-04-on-windows-11/ · Internet Archive 6.02 update https://archive.org/details/update_202401 · Lite listing https://archive.org/download/exodos_lite_202511
- DOSBox Staging Linux releases: https://www.dosbox-staging.org/releases/linux/
