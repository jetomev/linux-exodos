#!/usr/bin/env python3
"""Drive an eXo shell script from any shell: answer each question by its wording, log everything.
Usage: exo-driver.py --mode setup|play <working dir> <script> <log file> [--fullscreen] [--hide-adult] [--size L|M|S]
An unknown question is never guessed: after 10 quiet minutes on something that looks like a prompt, the script is stopped."""
import os, pty, select, sys, time, re, signal

a = sys.argv[1:]
mode = a[a.index("--mode") + 1]; cwd, script, logpath = a[2], a[3], a[4]
fullscreen = "--fullscreen" in a; hide_adult = "--hide-adult" in a
size = a[a.index("--size") + 1] if "--size" in a else "M"
log = open(logpath, "ab", buffering=0)

SETUP = [  # (pattern on the recent output, answer); first match wins, specific before general
    (r"\[F\]ull Install or just the \[M\]edia", "F\n"),
    (r"\[C\]ontinue, \[E\]xit, or \[M\]erge", "C\n"),
    (r"\[C\]ontinue or \[E\]xit", "C\n"),
    (r"without support for LaunchBox.*\(Y\)es or \(N\)o", "N\n"),
    (r"continue installing LaunchBox.*\(Y\)es or \(N\)o", "Y\n"),
    (r"64 bit.*\(Y\)es or \(N\)o", "Y\n"),
    (r"aren't 100% sure.*\(Y\)es or \(N\)o", "N\n"),
    (r"Adult games.*\(Y\)es or \(N\)o", "Y\n" if hide_adult else "N\n"),
    (r"\[F\]ullscreen or \[W\]indowed.*Please choose \(F/W\)", "F\n" if fullscreen else "W\n"),
    (r"primary desktop resolution.*Please choose \(L/M/S\)", size + "\n"),
    (r"Aspect Correction.*\[Y\]es or \[N\]o", "Y\n"),
    (r"icon on your desktop.*\[Y\]es or \[N\]o", "N\n"),
    (r"Press any key", "x"),
]
PLAY = [
    (r"download it\?.*\[Y\]es or \[N\]o", "Y\n"),            # Lite: fetch the game from the torrent
    (r"\(y/n\)\?", "y\n"),                                   # launch.bsh: game not installed, install it?
    (r"Please Choose: \[C,U\]", "C\n"),                      # already installed: Continue, not Uninstall
    (r"backup your saves.*\[Y\]es or \[N\]o", "Y\n"),
    (r"change any of these\?.*\[Y\]es or \[N\]o, or \[\?\]", "N\n"),  # keep the global settings (window size, aspect)
    (r"scaler.*\[Y\]es or \[N\]o, or \[\?\]", "N\n"),        # keep the default scaler (normal2x)
    (r"\[F\]ullscreen or \[W\]indowed.*Please choose \(F/W\)", "F\n" if fullscreen else "W\n"),
    (r"desktop resolution.*Please choose \(L/M/S\)", size + "\n"),
    (r"Aspect Correction.*\[Y\]es or \[N\]o", "Y\n"),
    (r"\[Y\]es or \[N\]o, or \[D\]elete your Save", "Y\n"),  # restore saves
    (r"Press 1 to play.*Please Choose:", "VERSION"),         # several versions: pick the IBM/VGA/CD one, else 1
    (r"Press any key", "x"),
]
RULES = SETUP if mode == "setup" else PLAY

def pick_version(tail):
    opts = re.findall(r"Press (\d) to play ([^\n]*)", tail)
    for want in ("IBM", "VGA", "CD", "EGA"):
        for n, desc in opts:
            if want.lower() in desc.lower(): return n + "\n"
    return (opts[0][0] if opts else "1") + "\n"

pid, fd = pty.fork()
if pid == 0:
    os.chdir(cwd); os.environ.setdefault("TERM", "dumb")
    os.execvp("bash", ["bash", script])

buf = b""; last_out = time.time(); start = last_out; answered = []
def strip(b): return re.sub(rb"\x1b\[[0-9;?]*[A-Za-z]", b"", b).decode(errors="replace")
try:
    while True:
        r, _, _ = select.select([fd], [], [], 1.0)
        if r:
            try: data = os.read(fd, 65536)
            except OSError: break
            if not data: break
            log.write(data); buf = (buf + data)[-20000:]; last_out = time.time()
            continue
        tail = strip(buf[-1500:])
        for pat, ans in RULES:
            if re.search(pat, tail, re.S | re.I):
                if ans == "VERSION": ans = pick_version(tail)
                os.write(fd, ans.encode()); log.write(f"\n[driver] matched '{pat}' → {ans!r}\n".encode())
                answered.append((pat, ans.strip())); buf = b""; break
        else:
            if time.time() - last_out > 600 and re.search(r"\?\s*$|:\s*$", tail):
                log.write(b"\n[driver] UNKNOWN PROMPT after 10 quiet minutes, stopping:\n" + tail[-600:].encode() + b"\n")
                os.kill(pid, signal.SIGTERM); sys.exit(3)
        if time.time() - start > 6 * 3600:
            log.write(b"\n[driver] 6 h limit, stopping\n"); os.kill(pid, signal.SIGTERM); sys.exit(4)
finally:
    _, status = os.waitpid(pid, 0)
rc = os.waitstatus_to_exitcode(status)
log.write(f"\n[driver] script exit {rc}; answered {len(answered)} prompts\n".encode())
for p, ans in answered: print(f"  {ans:3} ← {p[:55]}")
sys.exit(rc)
