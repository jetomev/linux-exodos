#!/usr/bin/env python3
"""Drive the eXo setup script (eXo/util/Setup eXoDOS.bsh) from any shell: answer each question by its wording.
Usage: exo-setup-driver.py <collection root> <log file> [--fullscreen] [--hide-adult] [--size L|M|S]
Unknown prompt: the driver stops the script and says so (never guesses). Everything the script prints goes to the log."""
import os, pty, select, sys, time, re, signal

root = sys.argv[1]; log = open(sys.argv[2], "ab", buffering=0)
fullscreen = "--fullscreen" in sys.argv; hide_adult = "--hide-adult" in sys.argv
size = sys.argv[sys.argv.index("--size") + 1] if "--size" in sys.argv else "M"

# (pattern on the recent output, answer). First match wins; ordered specific → general.
RULES = [
    (r"\[F\]ull Install or just the \[M\]edia", "F\n"),
    (r"\[C\]ontinue, \[E\]xit, or \[M\]erge", "C\n"),
    (r"\[C\]ontinue or \[E\]xit", "C\n"),
    (r"without support for LaunchBox.*\(Y\)es or \(N\)o", "N\n"),
    (r"continue installing LaunchBox.*\(Y\)es or \(N\)o", "Y\n"),
    (r"64 bit.*\(Y\)es or \(N\)o", "Y\n"),
    (r"aren't 100% sure.*\(Y\)es or \(N\)o", "N\n"),
    (r"Adult games.*\(Y\)es or \(N\)o", ("Y\n" if hide_adult else "N\n")),
    (r"\[F\]ullscreen or \[W\]indowed.*Please choose \(F/W\)", ("F\n" if fullscreen else "W\n")),
    (r"primary desktop resolution.*Please choose \(L/M/S\)", size + "\n"),
    (r"Aspect Correction.*\[Y\]es or \[N\]o", "Y\n"),
    (r"icon on your desktop.*\[Y\]es or \[N\]o", "N\n"),
    (r"Press any key", "x"),
]
pid, fd = pty.fork()
if pid == 0:
    os.chdir(os.path.join(root, "eXo", "util"))
    os.environ.setdefault("TERM", "dumb")
    os.execvp("bash", ["bash", "./Setup eXoDOS.bsh"])

buf = b""; last_out = time.time(); start = last_out; answered = []
def strip(b): return re.sub(rb"\x1b\[[0-9;?]*[A-Za-z]", b"", b).decode(errors="replace")
try:
    while True:
        r, _, _ = select.select([fd], [], [], 1.0)
        if r:
            try: data = os.read(fd, 65536)
            except OSError: break
            if not data: break
            log.write(data); buf += data[-20000:]; buf = buf[-20000:]; last_out = time.time()
            continue
        # quiet for a second: is the script waiting on a question?
        tail = strip(buf[-1500:])
        for pat, ans in RULES:
            if re.search(pat, tail, re.S):
                os.write(fd, ans.encode()); log.write(f"\n[driver] matched '{pat}' → {ans!r}\n".encode())
                answered.append((pat, ans.strip())); buf = b""; break
        else:
            if time.time() - last_out > 600 and re.search(r"\?\s*$|:\s*$", tail):
                log.write(b"\n[driver] UNKNOWN PROMPT after 10 min of silence, stopping:\n" + tail[-600:].encode() + b"\n")
                os.kill(pid, signal.SIGTERM); sys.exit(3)
        if time.time() - start > 3 * 3600:
            log.write(b"\n[driver] 3 h limit, stopping\n"); os.kill(pid, signal.SIGTERM); sys.exit(4)
finally:
    _, status = os.waitpid(pid, 0)
rc = os.waitstatus_to_exitcode(status)
log.write(f"\n[driver] script exit {rc}; answered {len(answered)} prompts\n".encode())
for p, a in answered: print(f"  {a:3} ← {p[:50]}")
sys.exit(rc)
