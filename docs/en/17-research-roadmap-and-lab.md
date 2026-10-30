# 17 — PS4 14.00 Research Roadmap and Lab Setup

> Goal: build a reproducible research program toward a 14.00 kernel primitive, starting from the public userland work and a jailbroken 13.52 tooling console. This is a roadmap, not a promise of a jailbreak.

---

## 0. Constraints

- No public 14.00 kernel exploit or full jailbreak exists as of 2026-10-30.
- Public research indicates the browser userland is usable; the missing link is a kernel primitive.
- The safest way to analyze 14.00 is static firmware analysis using a **13.52 jailbroken console**, not a 14.00 exploit.
- Work only on hardware you own; isolate the lab; do not distribute decrypted firmware or weaponized exploits.

---

## 1. Lab topology

```text
Isolated LAN / hotspot (no internet)
  ├── 14.00 test console        (never update; offline; browser tests)
  ├── 13.52 tooling console     (GoldHEN; PUP decrypt; offset baseline)
  ├── Optional 9.00/12.02 console (stable baseline/WEBKIT/BD-J tests)
  ├── Linux analysis PC         (Ghidra, diffing, scripts, HTTP server)
  ├── Windows VM (optional)     (MSYS2 build for PupDecrypt-PS4)
  ├── USB drives                (exFAT/FAT32; payloads; PUP)
  └── Blu-ray writer + BD-RE    (optional BD-J baseline)
```

### 1.1 Console roles

| Console | Firmware | Role | Rules |
|---|---|---|---|
| **A** | 14.00 | Target: browser/userland tests, crash reproduction | Offline; no PSN; no updates; test only |
| **B** | 13.52 with GoldHEN | Tooling: PUP decrypt, klog, payload testing, offsets | Offline; trusted payloads only |
| **C** (optional) | 9.00/12.52 | Stable baseline, BD-J tests, GoldHEN regression | Offline |

**Do not** use your main/primary console for destructive kernel tests. Kernel bugs can panic or corrupt the system.

### 1.2 Network

- Use a dedicated router/hotspot with **no WAN uplink**.
- Local HTTP server on the analysis PC for browser harnesses.
- Disable automatic updates on both consoles; block PSN/update domains at the router if possible.
- Never expose payload/BinLoader ports to the internet.
- Record the MAC/IP of each console and keep a lab notebook.

### 1.3 Power and recovery

- Use a controllable power strip; know how to boot Safe Mode.
- Keep the official 14.00 PUP and a recovery USB ready.
- Do not test while an important data write/install is in progress.
- If a kernel panic occurs, power-cycle, wait, and record the symptom before retrying.

---

## 2. Phase 0 — Preserve and document (1–2 days)

**Deliverables**

- 14.00 console identified by model (CUH-xxxx), serial (optional), exact firmware, and module/hash baseline.
- Official 14.00 PUP downloaded, hashed (SHA-256), stored twice.
- 13.52 tooling console confirmed with GoldHEN and BinLoader.
- Lab network diagram, console IP/MAC table, recovery checklist.
- Decision log: what is in scope (browser userland, kernel, BD-J, media) and what is out of scope (piracy, online cheating).

**Do not update the 14.00 console.** Every future firmware reduces the chance of a public/private exploit match.

---

## 3. Phase 1 — Static firmware analysis (1–2 weeks)

### 3.1 Decrypt the 14.00 PUP

1. Download the official PUP from Sony (S49).
2. On the 13.52 GoldHEN console, prepare a USB with enough free space (about twice the PUP size).
3. Copy the PUP to the USB root as `safe.PS4UPDATE.PUP`.
4. Send the `ps4-pup-decrypt.bin` payload to GoldHEN's BinLoader (port 9090).
5. Wait for `PS4UPDATE1.PUP.dec` … `PS4UPDATE4.PUP.dec` (recovery update: four parts; normal update: two).
6. Unpack with `pup_unpack` on the PC.
7. Hash every output; store the manifest in the lab notebook.

**Reference result:** a 14.00 recovery PUP (1.08 GB, 4 parts) decrypted on a 13.52 console with GoldHEN in about 17.5 minutes (S52).

**Troubleshooting**

- `Failed to open /dev/pup_update0`: load GoldHEN first; verify the SDK has offsets for your console firmware.
- Payload starts then stops: check GoldHEN Klog (TCP 3232); a fatal signal means the payload crashed. GoldHEN loads BIN payloads at `0x40000`; subtract that from the reported `rip` to find the offset in the bin (S52 FAQ).
- The console refuses updates older than the installed firmware or for another product code. Use a retail console and the retail PUP.

### 3.2 Extract and inventory

Target files:

| Component | Why |
|---|---|
| Kernel image | Compare 13.52 vs 14.00; identify patched functions; derive symbols/offsets |
| `libSceNKWebKit.sprx` and browser modules | Verify the frozen-engine claim; extract gadgets; map base leaks |
| BD-J / `bdjstack.jar` | Check BD-JB-13.04 patches and new paths |
| Media/audio/network daemons | Candidate attack surface |
| System libraries (`libkernel`, `libc`, `pup`, `aio`, `netcontrol`) | Syscall/gate/ABI verification |

### 3.3 Compare 13.52 vs 14.00

- **Binary diff:** BinDiff/Diaphora/Ghidra Version Tracking.
- **Function triage:** patched branches, removed checks, new checks, new code.
- **String/import diff:** new device nodes, new syscalls, new error paths.
- **Symbol recovery:** use public offsets only as hypotheses; verify against your dump.
- **Patch map:** list every changed function and classify it as (a) security fix, (b) feature, (c) refactor, (d) unknown.

**Deliverable:** a 14.00 change dossier with function-level evidence. This is the raw material for kernel hypotheses.

---

## 4. Phase 2 — Reproduce the userland primitive (1–3 weeks)

### 4.1 Choose a research base

| Base | What it gives you | Caveats |
|---|---|---|
| **Mikadolebg `ps4-1400-research`** | SSV entry, R/W, base leak, ROP, syscalls, measured gates, open leads | Community research; verify each claim; read `STATUS.md` and `REPRODUCE.md` first |
| **siongadev `PS4-14.00-Jailbreak-Research`** | Browser R/W, native execution, module/syscall maps, evidence discipline | Explicitly no sandbox/kernel; large evidence archive |
| **adri `ps4-14-00-security-notes`** | WebKit ROP/gadget dossier, kernel offsets, CVE catalogue | Some claims conflict (e.g., CVE-2026-7270/14.10); cross-check |
| **OptiTron `1350-webkit-test`** | 13.50/13.52 WebKit harness with a stopping R/W primitive | Reference for porting, not a 14.00 chain |
| **ntfargo `CSSFontFace-Exploit`** | Classic WebKit UAF; writeup and chain architecture | Only PS4 6.00–11.02; not 14.00 |

### 4.2 Evidence gates

Do not promote a claim until it passes all gates:

1. **Control:** the operation works/does not work as predicted on an ordinary page.
2. **Repeat:** at least two fresh pages/sessions.
3. **Independent oracle:** a read/write effect that normal JavaScript cannot explain.
4. **Restoration:** modified pointers/flags are restored; the page survives.
5. **Cleanup:** no leaked handles, no wedged sockets, no endless reload loop.
6. **Attribution:** the firmware/module/hash is recorded.

### 4.3 What to measure

- WebKit module inventory and hashes (all 26 loaded modules, if you follow the public mapping method).
- ROP gadgets at 14.00 RVAs; verify byte-exact on your dump.
- Base-leak pair/delta; repeat across boots.
- libkernel syscall stubs and gate status (302 stubs in the public 14.00 table).
- Browser sandbox: visible paths, devices, sockets, credential class, memory/CPU limits.
- Crash signatures: what causes a page refresh vs a process crash vs a console reboot.

### 4.4 What not to do

- Do not use CSSFontFace on 14.00; it is not the right primitive.
- Do not trust a "14.00 jailbreak" page that only shows a menu/notification.
- Do not run unknown private/paid payloads.
- Do not blind-fuzz syscalls from the browser; one probe per session with a health check.

---

## 5. Phase 3 — Kernel primitive hunt (open-ended; weeks–months)

### 5.1 Strategy

1. **Diff-driven:** every security-relevant patch in 14.00 is a clue to a vulnerability that existed in 13.52; conversely, code that Sony did **not** patch is a candidate.
2. **Reachability-first:** a kernel bug is only useful if reachable from the browser (or another sandbox) with the required privileges.
3. **Primitive-first:** prefer a bug that yields a stable read/write or a controlled free over a one-shot panic.
4. **KASLR plan:** assume KASLR; design a leak or a KASLR-independent primitive.
5. **Stability plan:** every attempt must be repeatable and recoverable; avoid blind loops.

### 5.2 Candidate triage

For each candidate, answer:

- Is the vulnerable code present in the 14.00 kernel? (binary diff)
- Is the relevant syscall/device/IPC reachable from the browser?
- What gate exists at syscall entry/credential class?
- What is the race window or heap shape?
- Can you observe success without crashing?
- What is the rollback/recovery plan?

Use the candidate table in [the attack-surface document](16-ps4-1400-attack-surface.md) and the public lead ranking in `sources/repos/Mikadolebg-ps4-1400-research/docs/07-next-leads.md`.

### 5.3 Suggested order

1. **AIO `multi_delete` TOCTOU** — delete 662 alive; public Lapse recipe; worker threads available; wait 663 gate must be bypassed or avoided.
2. **`/dev/dipsw` ioctl** — measured-open device; one command per session; unknown protocol; highest unknown-value.
3. **Named IPC / confused deputy** — kernel registry unauthenticated; find a non-gated process.
4. **`/system_tmp` sockets** — graphics/decoder protocols; measure connect/stat first.
5. **bnet `raise` UAF** — entry chain proven; low probability; panic risk.
6. **Remote Play parsers** — separate process, LAN surface; PIN mode for ctrl.
7. **Untested syscall families** — cheap, bounded probes.

### 5.4 Negative results

Keep a negative-results log. A closed lead is valuable: it prevents the team from repeating dead ends. Public research repositories explicitly document closed leads; mirror that discipline.

---

## 6. Phase 4 — Sandbox escape and post-exploitation (after a kernel primitive)

### 6.1 Sandbox escape

A kernel bug reachable only from a non-browser process still requires a sandbox escape/confused-deputy step. Plan for:

- browser → a system service (IPC, socket, file/service request),
- browser → kernel directly (the preferred path),
- browser → GPU/media/compositor service.

### 6.2 Post-exploitation

Public 14.00 offsets/kpatches exist:

- `Scene-Collective/ps4-hen` includes `kpayload/include/offsets/1400.h` and patch logic for firmware 14.00;
- `ps3120/ps4-exploit-kpatches/1400.c` contains 14.00 kernel patch shellcode (AIO patch, `xfast_syscall`, etc.).

Use these as **post-exploitation references**, not as a KEX. Verify every offset against your own kernel dump. The typical post-exploitation steps are:

1. obtain kernel read/write,
2. defeat KASLR (leak base),
3. patch `ucred`/`prison0`/`rootvnode`/`dynlib` ranges,
4. disable/relax sandbox gates,
5. load GoldHEN/HEN,
6. verify homebrew/PKG/FTP.

### 6.3 Payload loading

- Use a local BinLoader/ELF loader compatible with your chain.
- Keep the payload minimal until the chain is stable.
- Test with a harmless payload first; only then GoldHEN/HEN.
- Record every payload hash and version.

---

## 7. Phase 5 — Validation and disclosure (1–2 weeks)

### 7.1 Validation matrix

| Dimension | Minimum |
|---|---|
| Boots | 10+ cold boots |
| Sessions | 10+ fresh browser sessions |
| Models | At least one base/slim; Pro if available |
| Stability | No unintended panics; recoverable failures |
| Cleanup | No wedged sockets/devices; console remains usable |
| Reproducibility | Written steps + hashes + logs from a second person |

### 7.2 Disclosure

- Consider Sony's HackerOne program for sandbox/kernel vulnerabilities.
- Coordinate timing; do not release weaponized code before a fix or an agreed disclosure date.
- Publish defensive value: firmware diff notes, root-cause, mitigations, detection.
- Do not sell or privately gate a kernel exploit while claiming "public research".

### 7.3 Release package

- High-level write-up, affected firmware, root cause, fix status.
- Reproducibility notes that do not weaponize piracy.
- Credits and license.
- No decrypted firmware, no copyrighted keys, no game content.

---

## 8. Suggested schedule (part-time researcher)

| Phase | Estimate | Exit criterion |
|---|---|---|
| 0. Preserve/lab | 1–2 days | 14.00 console offline; PUP hash; 13.52 tooling ready |
| 1. Static analysis | 1–2 weeks | 14.00 PUP unpacked; kernel/WebKit inventory; change dossier |
| 2. Userland repro | 1–3 weeks | R/W/ROP/syscalls reproduced with evidence gates |
| 3. Kernel hunt | open-ended | Candidate reachability + trigger + primitive |
| 4. Sandbox/post-exploit | 1–4 weeks after KEX | Stable payload load |
| 5. Validation/disclosure | 1–2 weeks | Reproducible report; disclosure decision |

These are planning estimates, not guarantees. Kernel research is non-linear.

---

## 9. Practical lab notes

- Keep a single **lab notebook** (Markdown) with date, firmware, module hashes, probe, control, result, and cleanup.
- Use **one variable per experiment**; do not change the harness and the payload in the same run.
- Save **raw logs** before summarizing; include timestamps and console errors.
- Prefer **read-only** probes first; state-changing probes last.
- **Health-check** after every risky probe: browser alive? page responsive? devices still open? reboot if wedge.
- Do not reuse a wedged session; reopen the browser or reboot.
- Keep a **known-good** 14.00 browser page and a 13.52 GoldHEN baseline for regression.
- Treat public repos as **hypotheses**, not truth. Verify offsets, gates, and CVE applicability on your own dump.
- Do not confuse **PS4 14.00** with **PS5 14.10**; their exploit state and firmware numbering are different.

---

## 10. Sources and further reading

- Sony PS4 system software: <https://www.playstation.com/en-us/support/hardware/ps4/system-software/>
- Sony PS4 WebKit OSS: <https://www.playstation.com/en-us/oss/ps4/webkit/>
- `PupDecrypt-PS4` (14.00 offsets; 13.52 decrypt workflow): <https://github.com/iHaiDeeZ/PupDecrypt-PS4>
- `Scene-Collective/ps4-pup-decrypt`: <https://github.com/Scene-Collective/ps4-pup-decrypt>
- `idc/ps4-pup_unpack`: <https://github.com/idc/ps4-pup_unpack>
- `ps3120/ps4-exploit-kpatches`: <https://github.com/ps3120/ps4-exploit-kpatches>
- `Scene-Collective/ps4-hen`: <https://github.com/Scene-Collective/ps4-hen>
- `Mikadolebg/ps4-1400-research`: <https://github.com/Mikadolebg/ps4-1400-research>
- `siongadev/PS4-14.00-Jailbreak-Research`: <https://github.com/siongadev/PS4-14.00-Jailbreak-Research>
- `adri22235/ps4-14-00-security-notes`: <https://github.com/adri22235/ps4-14-00-security-notes>
- `ntfargo/CSSFontFace-Exploit` (legacy WebKit reference): <https://github.com/ntfargo/CSSFontFace-Exploit>
- NVD CVE records: see [sources](12-sources.md)
