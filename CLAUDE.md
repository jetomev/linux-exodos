# Linux - eXoDos · how this project works

The umbrella rules are in `~/.claude/CLAUDE.md` (Javier & Claude). This file adds what is specific here.

- **Lives on the external disk:** repo `/mnt/exodos/linux-exodos`, collection `/mnt/exodos/eXoDOS`. If `/mnt/exodos` is not mounted, stop and say so; the disk is a 15-year-old WD My Book on USB 2.0 and may be unplugged.
- **The collection never enters git.** Only scripts, docs, findings and the small `.torrent` files.
- **Scripts go in `scripts/`, log to `logs/`** (ignored by git except `.gitkeep`). Root work runs through one script per job, started with plain `sudo -A -k` so the sudoForge box asks; never `SUDO_ASKPASS`.
- **Torrent client:** transmission-daemon run by hand with its state in `/mnt/exodos/.transmission`, PID file alongside; stop it by that PID, never by `pkill -f`.
- **Packages:** nog first (`dosbox-staging`, `transmission-cli` are in the repos). Flatpak or AppImage only when the eXo patch leaves no choice, and then it is a finding (F-n) in `docs/research/` and a GitHub issue.
- **The scripts, in order:** `exo-install-dependencies.sh` (once per machine) → `exo-setup.sh` (once per collection) → `exo-play.sh <folder>` (a game; folder = short name under `eXo/eXoDOS/!dos/`, e.g. `mi1`). All answer the eXo prompts through `exo-driver.py`; an unknown prompt stops the run after 10 quiet minutes, it never guesses. PID files: `/mnt/exodos/.transmission/daemon.pid`, `/mnt/exodos/.exogui.pid`, `/mnt/exodos/.exo-play-<g>.pid`.
- **Findings** are numbered F-1, F-2… in the research notes and become issues on `jetomev/linux-exodos`.
- **Plain words everywhere** (README, issues, notes): the reader is not an engineer.
