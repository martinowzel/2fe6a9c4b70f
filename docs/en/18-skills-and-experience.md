# 18 — Skills, Experience, and Working Notes for PS4 14.00 Research

> This chapter collects the practical experience needed to work on the 14.00 research track: skills, learning order, lab habits, common failure modes, and collaboration rules.

---

## 1. Skills matrix

| Track | Must-have | Nice-to-have |
|---|---|---|
| **Programming** | C, JavaScript, Python; x86-64 assembly reading | Java (BD-J), C++, TypeScript/Node |
| **Userland exploitation** | Memory corruption, UAF, type confusion, heap grooming, ROP, JIT/typed arrays | Browser/WebKit internals, DOM, BigInt/serialization |
| **Kernel** | FreeBSD 9 kernel structure, syscalls, UAF/race/double-free, KASLR | SMEP/SMAP, kernel heap internals, IPC |
| **Reverse engineering** | Ghidra or IDA, function diffing (BinDiff/Diaphora), ROP gadget search | Binary Ninja, radare2/rizin, custom scripts |
| **Fuzzing** | AFL++, libFuzzer, ASAN/UBSAN, corpus management | Network protocol fuzzing, media parsers |
| **PS4-specific** | PUP/SPRX/ELF formats, GoldHEN, BinLoader, offsets, syscall tables | BD-J, PFS, SceAIO, SceNet |
| **Hardware/lab** | USB imaging, console recovery, offline network, power control | UART/serial, soldering/ESD, Blu-ray writer |
| **Research process** | Hypothesis testing, controls, evidence logs, reproducibility | Coordinated disclosure, technical writing |

If you are missing one track, team up. A 14.00 kernel exploit is a multi-disciplinary project, not a single-language task.

---

## 2. Learning path

### Stage 1 — Foundations (4–8 weeks)

- C memory model, pointers, integer bugs, heap/stack.
- x86-64 calling conventions, registers, stack alignment, ROP.
- JavaScript engine basics: objects, arrays, typed arrays, JIT, GC.
- Linux/FreeBSD command line, Git, Python scripting.
- Read: CTurt's "Hacking the PS4" series; Saelo's "Attacking JavaScript Engines"; basic ROP/CTF pwn writeups.

**Exercise:** build a small userland UAF/type-confusion lab on your PC; write a ROP chain; document it.

### Stage 2 — Browser/WebKit (4–8 weeks)

- WebKit architecture: JSC, DOM, bindings, serialization, JIT.
- Structured clone / SerializedScriptValue; BigInts; typed arrays; mark stack.
- Build and fuzz a desktop JSC/WebKit; use ASAN.
- Read public browser exploitation writeups (not just PS4-specific).
- Study the public PS4 SSV research at a high level; verify mechanics on desktop where possible.

**Exercise:** reproduce a known WebKit CVE on a desktop build; write a root-cause note; do not publish weaponized code.

### Stage 3 — FreeBSD kernel (6–12 weeks)

- FreeBSD 9 source: `kern_exec.c`, `sys_aio.c`, `sysv_sem.c`, `sysv_msg.c`, `sysv_shm.c`, `ufs/ffs`, `dev/sound`, networking.
- UAF/double-free/race patterns; KASLR; kernel heap grooming.
- Kernel debugging in a VM; crash triage; symbol recovery.
- Diff two kernel builds; read security advisories.

**Exercise:** analyze a public FreeBSD CVE, write a reachability/exploitability note, and test it in a VM.

### Stage 4 — PS4-specific (4–8 weeks)

- PUP decrypt/unpack; SPRX/ELF formats; `libkernel`/`libkernel_sys`; syscall tables.
- GoldHEN/BinLoader; klog; payload SDK; offsets.
- Browser harness on 14.00; sandbox boundary mapping; device/IPC probes.
- Read the 14.00 research repositories and reproduce their evidence gates.

**Exercise:** dump the 14.00 browser module inventory; verify 5 public offsets; produce a negative-results page.

### Stage 5 — Research project (ongoing)

- Choose one kernel lead; write a one-page hypothesis with predicted observations.
- Build the smallest trigger; measure reachability; record every crash.
- Iterate; close leads; publish defensive notes.

---

## 3. Experience notes (what actually matters)

### 3.1 Evidence discipline

- **One variable per run.** Change the harness or the target, not both.
- **Control first.** A wrong result is often a harness bug, not a kernel bug.
- **Repeat on a fresh page/session.** A single success can be stale state.
- **Raw logs before summaries.** Keep timestamps, console errors, module hashes.
- **Negative results are results.** Write down what did not work and why.
- **Do not promote a symptom to a primitive.** A memory warning, a page refresh, or a successful syscall return is not a kernel R/W.

### 3.2 Offsets and versions

- Never trust published offsets blindly; verify against your own dump.
- Record the exact firmware, module hash, and browser user agent.
- Expect offset drift between 13.52 and 14.00; use diffing, not copy-paste.
- KASLR means a static address is not enough; design a leak.
- Public 14.00 kpatches are post-exploitation references, not KASLR bypasses.

### 3.3 Crashes and stability

- Kernel bugs often panic the console; a test console is mandatory.
- Use health checks after every risky probe: browser alive, page responsive, devices not wedged.
- Reboot to clear wedged sockets/devices; do not stack failures.
- Keep a recovery USB/PUP; know Safe Mode.
- If a probe causes an unexpected reboot, stop and write the crash signature before retrying.

### 3.4 Sandbox reality

- A browser R/W primitive does not mean you can open `/dev/mem` or call arbitrary kernel syscalls.
- The browser is in a prison with a limited mount table, credential class, and syscall gates.
- A kernel bug reachable only from a non-browser service still needs a sandbox escape/confused deputy.
- Measure what is allowed; do not assume from older firmware.

### 3.5 Media and IPC

- Media parsers and IPC daemons are real surfaces, but they may run in different processes/sandboxes.
- A parser crash is not a kernel primitive; determine the process, registers, and heap control.
- Network fuzzing should be rate-limited; do not DoS shared services or other users.

### 3.6 Community claims

- "Private jailbreak" teasers are not reproducible evidence.
- Paid exploits may be fake, stolen, or non-transferable; do not build a project on them.
- Low-star research repos can still contain useful evidence; read their methodology, not just their claims.
- Conflicting claims are a signal to verify, not to pick the convenient one.
- **14.10 is PS5**, not PS4; firmware-number confusion is common.

---

## 4. Common pitfalls (14.00 track)

| Pitfall | What happens | Better approach |
|---|---|---|
| Using CSSFontFace on 14.00 | Primitive was redesigned after 11.02; chain fails | Use the newer SSV/WebKit research |
| Treating a browser R/W as a jailbreak | Sandbox/kernel still closed | Map the boundary; test a protected resource |
| Trusting a teaser/private jailbreak | No reproducible result; possible scam | Build from public evidence and your own dumps |
| Assuming CVE applicability from FreeBSD version | PS4 is FreeBSD 9-derived with Sony patches | Verify code presence and reachability |
| Blind syscall fuzzing from browser | Panics/wedged devices; no useful data | One bounded probe per session; health check |
| Hardcoding community offsets | Wrong addresses; crashes | Derive from your dumped kernel/WebKit |
| Confusing 14.00/14.10 | Wrong target; wasted effort | 14.10 is PS5; verify Settings |
| Not restoring modified state | Unstable sessions; false positives | Restore pointers/flags; reopen/reboot |
| Reusing a wedged session | Results not reproducible | Reboot/reopen; fresh page |
| Ignoring cleanup | Leaked fds/sockets; later probes fail | Close handles; verify baseline |

---

## 5. Collaboration and disclosure

- Share **methodology, negative results, and defensive fixes**, not weaponized exploits.
- Credit prior work (TheFloW, Gezine, ps3120, abc, slidybat, Al-Azif, ntfargo, and the 14.00 research teams).
- Consider coordinated disclosure to Sony's HackerOne program for sandbox/kernel bugs.
- Do not sell access to a private exploit while presenting yourself as a public researcher.
- Do not use research for piracy, online cheating, or DRM circumvention for sale.
- Respect local laws and Sony's ToS; this project is not legal advice.

---

## 6. Recommended resources

| Topic | Resource |
|---|---|
| PS4 architecture | CTurt, "Hacking the PS4" series |
| Browser exploitation | Saelo, "Attacking JavaScript Engines"; modern WebKit/JSC writeups |
| FreeBSD kernel | FreeBSD 9 source; FreeBSD security advisories; kernel debugging guides |
| WebKit source | Sony PS4 OSS WebKit 13.00 archive |
| PS4 firmware | PSDevWiki, ConsoleMods, PUP decrypt/unpack tools |
| 14.00 research | S58, S59, S60 repositories and their evidence logs |
| WebKit legacy | ntfargo CSSFontFace writeup (for architecture lessons, not 14.00) |
| Tooling | Ghidra, IDA, BinDiff, Diaphora, ROPgadget, ropper, AFL++, libFuzzer |
| Community | r/ps4homebrew, PSX-Place, HackerOne PlayStation program |

---

## 7. A final reality check

A 14.00 jailbreak is not blocked by a lack of userland entry in the public research; it is blocked by **one missing kernel primitive** and the engineering needed to make it stable. The work is valuable even if it does not produce a public jailbreak: firmware diffs, sandbox maps, negative results, and CVE analyses improve the whole scene's understanding and help defenders.

---

## 8. Sources

See [sources](12-sources.md) for S49–S70 and the full list. Key 14.00 research repositories:

- `Mikadolebg/ps4-1400-research`: <https://github.com/Mikadolebg/ps4-1400-research>
- `siongadev/PS4-14.00-Jailbreak-Research`: <https://github.com/siongadev/PS4-14.00-Jailbreak-Research>
- `adri22235/ps4-14-00-security-notes`: <https://github.com/adri22235/ps4-14-00-security-notes>
- `ntfargo/CSSFontFace-Exploit`: <https://github.com/ntfargo/CSSFontFace-Exploit>
