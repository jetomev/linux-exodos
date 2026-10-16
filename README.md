# Linux - eXoDos

> **Running the eXoDOS collection on Linux, on KognogOS, from an external disk.** eXoDOS is a curated set of 7,600+ DOS games (the PC games of the 1980s and 1990s), each already set up to run inside DOSBox, a program that pretends to be an old PC. It is made for Windows; this project is our record of getting it to run on Linux: what we tried, what worked, the scripts, and the findings.

> 🖥 **Where it runs:** **Arch / KognogOS** (tested here, on the Sway desktop) · any desktop should do, the games open their own window · the launcher scripts work from a terminal.

## What this is

- **Not the games.** eXoDOS itself is downloaded from [retro-exo.com](https://www.retro-exo.com/exodos.html) by torrent. This repo holds only our scripts, notes and the small `.torrent` files, never the collection.
- **One disk for everything.** A 1 TB USB disk (WD My Book) formatted ext4, mounted at `/mnt/exodos`. On it: this repo (`/mnt/exodos/linux-exodos`) and the collection (`/mnt/exodos/eXoDOS`), side by side.
- **Lite first.** The Lite release (6.6 GB) brings the front end, the catalog and the art; each game downloads the first time it is played. The full 698 GB release stays off this disk (its health report has 167 unreadable spots; see the research note).

## Where things are

| Path | What |
|---|---|
| `docs/research/` | What we learned, newest first. Start with [2026-10-16-exodos-on-linux.md](docs/research/2026-10-16-exodos-on-linux.md). |
| `scripts/` | Everything we ran. Each one logs to `logs/`. `format-exodos-disk.sh` made the disk · `torrent-start.sh` / `torrent-status.sh` the downloads · `exo-install-dependencies.sh` → `exo-setup.sh` → `exo-play.sh <game>` the eXo steps, with `exo-driver.py` answering eXo's questions · `exo-display.sh fullscreen|windowed` the screen default · `exo-install-launcher.sh` puts eXoDOS in the desktop's app launcher (Games) · `torrent-info.py` reads a `.torrent`. |
| `torrents/` | The exact `.torrent` files we used (Lite, full, Linux patch), from retro-exo.com on 2026-10-16. |
| `TODO.md` | The live list. |

## Status

**16 October 2026: it plays.** Research, disk, Lite + Linux patch, the eXo dependencies (21 Flatpaks on the disk), setup, exogui on Sway, and The Secret of Monkey Island in DOSBox ECE, all the same afternoon. Javier: "game ran perfectly". Next: a game from exogui's own Play button ([#7](https://github.com/jetomev/linux-exodos/issues/7)).

## Credits

eXoDOS is the work of eXo and the eXo team, and the Linux patch of parricc, jelcynek and Colin. Thank you. Built by Javier and Claude, together. License: GPLv3 for what is ours here.
