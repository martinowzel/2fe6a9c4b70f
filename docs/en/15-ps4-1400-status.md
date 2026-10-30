# 15 — PS4 14.00: Status, Evidence, and What Is Missing

> Snapshot date: **30 October 2026**. This document separates public evidence from community claims. It is a research foundation, not a working 14.00 jailbreak.

---

## 1. Bottom line

- PS4 firmware **14.00** was released on **16 September 2026**.
- As of **30 October 2026**, there is **no public, reproducible 14.00 jailbreak**.
- Multiple community research repositories report a working **browser userland** chain on 14.00 (WebKit R/W, native execution/ROP, syscalls), but **no public sandbox escape and no public kernel primitive**.
- A private/teaser 14.00 jailbreak has been discussed in the community; it is **not publicly available** and must not be treated as a usable route.
- The practical research path is: use a **13.52 jailbroken console** to decrypt and unpack the official 14.00 PUP, reproduce the **WebKit userland** research on a 14.00 console, then find the missing **kernel primitive**.
- **14.10 is a PS5 firmware** (26.06-14.10.00, 1 October 2026), not a PS4 firmware. Do not confuse the two.

---

## 2. Firmware facts

| Item | Value |
|---|---|
| Firmware | PS4 14.00 |
| Release date | 2026-09-16 |
| Official update file | `PS4UPDATE.PUP` from Sony's PS4 system-software page (path dated `2026_0831`) |
| Official notes | Minimal; Sony does not publish a vulnerability-by-vulnerability changelog |
| Latest PS4 firmware in this snapshot | 14.00 (14.10 is PS5-only) |
| Public full jailbreak | None |
| Community userland-only research | Reported by multiple repositories (see below) |
| Private/teaser full jailbreak | Reported, not public |

**Sources:** Sony PS4 system software page (S49), Sony PS4 WebKit OSS page (S50), release article (S51), 14.10 PS5 context (S67).

---

## 3. Public status matrix

| Layer | Public status | Evidence | Confidence |
|---|---|---|---|
| **WebKit userland R/W** | Reported working on 14.00 (browser process) | Mikadolebg SSV chain (S58), siongadev browser R/W native calls (S59), adri WebKit/gadget dossier (S60) | Medium: independent community reports, not audited by this project |
| **Native execution / ROP / syscalls** | Reported working on 14.00 | Mikadolebg: 15 gadgets, 302 libkernel stubs, arbitrary syscalls; siongadev: native code-reuse call on fresh pages; adri: 29 gadgets from `libSceNKWebKit.sprx` | Medium |
| **Browser sandbox escape** | Not publicly demonstrated | siongadev explicitly says not demonstrated; Mikadolebg maps sandbox gates; adri says sandbox confinement active | High for "not demonstrated" |
| **Kernel primitive (KEX)** | Not publicly released | Mikadolebg: AIO wait 663 gated; siongadev: kernel R/W not demonstrated; adri: Celsius patched, candidates only | High for "no public KEX"; candidates unproven |
| **Full jailbreak** | Not public | ConsoleMods chart: no public exploits for 14.00+; private teaser only | High |
| **PUP decryption / static analysis** | Possible using a 13.52 jailbroken console | iHaiDeeZ/PupDecrypt-PS4: decrypted 14.00 recovery PUP on 13.52 with GoldHEN in ~17.5 min | Medium-high: tool report, reproducible workflow |
| **14.00 kernel offsets/kpatches** | Public sources exist | Scene-Collective `ps4-hen` 14.00 offsets; ps3120 `kpatches/1400.c` | High for existence; offsets must be verified on your dump |
| **BD-JB entry on 14.00** | No public cold-start route | BD-JB-13.04 patched at 13.50; BD-JB-EX requires prior injection; no public 14.00 BD-J escape | High |

---

## 4. What is proven vs what is claimed

### 4.1 Proven / measured by public researchers

- **WebKit engine is effectively frozen after 13.00.** Sony's OSS page lists the last PS4 WebKit source drop for **13.00-**; there is no 13.50/13.52/14.00 archive. The standard LGPL reading is that the shipped binary did not change (S50).
- **The 14.00 browser still exposes a userland primitive.** Independent research workspaces report read/write and native execution on 14.00. This does **not** imply a sandbox escape or kernel access.
- **The public AIO/Lapse wait path is gated on 14.00.** Mikadolebg measured syscall 663 (`aio_multi_wait`) returning immediately/error and never creating the waiter; the public Lapse chain therefore fails at that stage (S58).
- **Other browser kernel gates were tightened.** Named event-flag/semaphore creation, several device opens, and non-AF_UNIX socket behavior are restricted for the browser class (S58, S59, S60).
- **The official 14.00 PUP can be decrypted without a 14.00 exploit** using a jailbroken 13.52 console and a payload with 14.00 offsets (S52). This enables static analysis of the kernel and WebKit.

### 4.2 Claimed but not independently verified

- Exact WebKit module/gadget offsets for 14.00 (community reports; verify against your dumped `libSceNKWebKit.sprx`).
- Kernel symbol offsets such as `PRISON0`, `ROOTVNODE`, `ALLPROC`, `SYSENT` (community dossiers; verify against your decrypted kernel).
- The existence and stability of a private full 14.00 jailbreak (teaser/community reports only).
- Exploitability of candidate FreeBSD CVEs on PS4 14.00 (see §7).

### 4.3 What is missing

**A public kernel primitive reachable from the browser sandbox.** Everything above it (entry, R/W, leak, ROP, syscalls, payload patches) is reported as solved or partially prepared; the kernel link is the bottleneck.

---

## 5. The WebKit foundation: what entry actually works

### 5.1 The frozen-engine argument

Sony's PS4 OSS WebKit page lists sources only up to **13.00 -**. The 13.00 archive (`WebKit-616-1300.zip`, ~1.62 GB) is the last public drop; community analysis reports no 2026 changes. The 14.00 engine is therefore widely believed to be the same 13.00-era engine, which is why a 13.04/13.52 userland entry can be ported to 14.00 (S58, S59, S60).

This is an inference, not a Sony statement. Verify it by dumping and hashing the 14.00 WebKit module.

### 5.2 The SSV / BigInt bug

The public 13.04/13.52 browser entry is attributed to a **SerializedScriptValue (SSV)** bug in WebKit's serializer/deserializer:

- the serializer does not pool BigInts;
- the deserializer does;
- a duplicated reference causes a 2-byte write / 4-byte read mismatch;
- a controlled signed index in `MarkedVector::at()` produces a fake `Uint8Array` cell;
- the fake typed array provides arbitrary userland read/write.

This description is from community research (S58); it is high-level and intentionally not a step-by-step exploit guide. The same research reports that `history.replaceState` / structured serialization is the reachable path on 14.00.

### 5.3 CSSFontFace is not the 14.00 entry

The public `CSSFontFace-Exploit` repository states:

- vulnerability scope: PS4 **6.00–13.52**;
- exploitable range: PS4 **6.00–11.02**;
- newer WebKit versions redesigned CSSFontFace property handling, so the primitive is **not usable above 11.02** (S61).

Do not try to reuse the CSSFontFace chain on 14.00. The relevant 14.00 userland family is the newer WebKit string/serialization work (SSV), as reported by the research repositories.

---

## 6. What Sony hardened in 14.00 (observed)

Sony's public notes are minimal. Community measurements show the **kernel frontier of the browser** was hardened:

| Area | Observation | Source |
|---|---|---|
| AIO wait (663) | Returns immediately/error; no waiter created; public Lapse chain cannot land | S58 |
| Named IPC (`evf_*`, `osem_*`) | Creation/operations denied for the browser class | S58 |
| Non-AF_UNIX sockets | Restricted in 14.00 (browser sandbox) | S60 |
| Devices | `dmem0`, `dce`, `aout` opens denied; `dipsw` open succeeds but ioctl untested | S58 |
| AIO delete (662) | Alive; a TOCTOU in the delete/lock-upgrade path is an open lead | S58 |
| Kernel | Celsius `ffs_mount` patched at 13.50; no public replacement KEX | S58, S60 |

These are **observations**, not an official changelog. They can change with a future firmware.

---

## 7. Kernel candidates (as of 2026-10-30)

No candidate below has a public, reproducible PS4 14.00 exploit. Treat them as hypotheses requiring reachability analysis, a trigger, a KASLR strategy, and stability testing.

| Candidate | Subsystem | NVD/CVSS | Why it might matter | Main challenge |
|---|---|---|---|---|
| **CVE-2026-49415** | `execve(2)` SUID TOCTOU | 8.8 High (AV:N/AC:L/PR:L) | Code path may exist in FreeBSD 9-derived kernels; race modifies SUID process memory | Needs a SUID binary and procfs access; browser sandbox may block both |
| **CVE-2026-101308** | `sound(4)` `sndbuf_resize` / `mmap` UAF | 5.5 Medium (AV:L/AC:L/PR:L) | UAF in kernel; FreeBSD advisory SA-26:71.sound; audio device reachable in principle | Needs sound device access; browser device gates and heap control |
| **CVE-2026-58087** | `semctl(2)` GETALL/SETALL sequence wrap | 7.8 High (AV:L/AC:L/PR:N/UI:R) | OOB read/write on kernel heap after 0x8000 create/destroy cycles | Needs SysV semaphore access from a useful process; browser reachability unknown |
| **CVE-2026-7270** | `execve` argument slab overflow | — | Sometimes listed as a candidate | **Disputed/discarded** in a public PS4 analysis: function introduced in FreeBSD 13, not in the FreeBSD 9 baseline; do not rely on it |
| **AIO delete TOCTOU (Lapse family)** | `sys_aio_multi_delete` | — | Delete 662 alive; lock-upgrade window may be exploitable even though wait 663 is gated | Microsecond race; kernel panic on a lost attempt; needs worker-thread timing |
| **bnet `raise` UAF** | IPv6 netevent queue | — | Entry chain proven on 14.00 | Per-event probability very low; panic risk |
| **`/dev/dipsw` ioctl** | Sony device ioctl | — | Open fd from browser; command window known; untested | Unknown protocol; must avoid blind command sweeps |
| **Named IPC registry / confused deputy** | evf/osem registry | — | Kernel registry has no authentication; browser is gated at syscall entry | Need a non-gated system process that acts on browser influence |
| **`/system_tmp` sockets** | GnmCompositor, gpvdec/gpvenc | — | Live UNIX sockets visible from the prison | Protocol unknown; connect behavior unmeasured |
| **Remote Play parsers** | NPXS21006 UDP 987 / TCP 9295 | — | Non-browser process with its own parser surface | 576-case fuzz run found no crash; ctrl channel needs PIN mode |

**Key point:** the browser sandbox is the first wall; a kernel bug reachable only from a non-browser process still needs a sandbox-escape/confused-deputy step.

---

## 8. PUP decryption and static analysis: the practical foundation

Because there is no public 14.00 exploit, static analysis is the safest way to start.

### 8.1 What is possible

A **13.52 jailbroken console** running GoldHEN can decrypt the official **14.00** PUP using `PupDecrypt-PS4` / `ps4-pup-decrypt` with offsets up to 14.00:

- tested: 14.00 recovery update, 1.08 GB, 4 decrypted parts, ~17.5 minutes on a 13.52 console (S52);
- output: `PS4UPDATE1.PUP.dec` … `PS4UPDATE4.PUP.dec`;
- unpack with `pup_unpack` to obtain firmware filesystem images;
- no 14.00 exploit is required for this step; the 13.52 kernel does the decryption.

### 8.2 Why it matters

- You can compare **13.52 vs 14.00** kernel and WebKit binaries without a 14.00 kernel exploit.
- You can verify community offsets/gadgets against your own dump instead of trusting them.
- You can identify which functions Sony patched and generate new hypotheses.

### 8.3 Limits

- The console refuses updates older than installed firmware or for a different product code; use a retail console and a retail PUP.
- PUP decryption requires a jailbroken console and a payload loader (GoldHEN BinLoader).
- Do not distribute decrypted firmware; keep it local and respect copyright.
- The PUP is large; use a USB stick with enough free space (about twice the update size).

---

## 9. What a 14.00 project actually needs

1. **A 13.52 tooling console** (GoldHEN) for PUP decryption, offsets, and baseline tests.
2. **A 14.00 test console**, offline and preserved, for userland and crash testing.
3. **A reproducible WebKit userland primitive** on 14.00 (SSV research), with evidence gates.
4. **A kernel primitive** reachable from the browser sandbox — the missing link.
5. **Post-exploitation**: 14.00 offsets/kpatches, payload loader, GoldHEN compatibility.
6. **Discipline**: one hypothesis per experiment, controls, cleanup, hashes, negative results, and a reboot plan.

The detailed plan is in [the roadmap](17-research-roadmap-and-lab.md); the attack-surface map is in [the attack-surface document](16-ps4-1400-attack-surface.md).

---

## 10. Ethics and legal notes

- Work only on consoles you own, in an isolated lab.
- Do not buy, sell, or redistribute private exploits; do not release weaponized code irresponsibly.
- Consider coordinated disclosure to Sony's HackerOne program for kernel/sandbox bugs.
- Do not use this research for piracy, online cheating, or DRM circumvention for sale.
- Local laws and Sony's ToS apply; this project is not legal advice.

---

## 11. Sources

- S49 — Sony PS4 system software support: <https://www.playstation.com/en-us/support/hardware/ps4/system-software/>
- S50 — Sony PS4 WebKit OSS source page (last drop 13.00-): <https://www.playstation.com/en-us/oss/ps4/webkit/>
- S51 — PS4 14.00 release article (2026-09-16): <https://mp1st.com/news/ps4-update-14-00-released-on-september-16-brings-what-you-expect>
- S52 — `iHaiDeeZ/PupDecrypt-PS4`: <https://github.com/iHaiDeeZ/PupDecrypt-PS4>
- S53 — `Scene-Collective/ps4-pup-decrypt`: <https://github.com/Scene-Collective/ps4-pup-decrypt>
- S54 — `idc/ps4-pup_decrypt`: <https://github.com/idc/ps4-pup_decrypt>
- S57 — `ps3120/ps4-exploit-kpatches` (14.00 patch sources): <https://github.com/ps3120/ps4-exploit-kpatches>
- S58 — `Mikadolebg/ps4-1400-research`: <https://github.com/Mikadolebg/ps4-1400-research>
- S59 — `siongadev/PS4-14.00-Jailbreak-Research`: <https://github.com/siongadev/PS4-14.00-Jailbreak-Research>
- S60 — `adri22235/ps4-14-00-security-notes`: <https://github.com/adri22235/ps4-14-00-security-notes>
- S61 — `ntfargo/CSSFontFace-Exploit`: <https://github.com/ntfargo/CSSFontFace-Exploit>
- S63–S66 — NVD records for CVE-2026-49415, CVE-2026-101308, CVE-2026-58087, CVE-2026-7270
- S73 — FreeBSD SA-26:71.sound advisory: <https://www.freebsd.org/security/advisories/FreeBSD-SA-26:71.sound.asc>
- S67 — PS5 14.10 context (to avoid confusing it with PS4): <https://www.techpowerup.com/353929/ps5-firmware-14-10-reportedly-jailbroken-in-private-hypervisor-still-holding-up>
- S71 — Community 14.00 teaser report (secondary): <https://www.youtube.com/watch?v=i0O2o2ZhnTg>
- S72 — Community private 14.00 discussion (secondary): <https://www.reddit.com/r/PS4Mods/comments/1wyehee/ps4_1400/>
- Full list: [sources](12-sources.md)
