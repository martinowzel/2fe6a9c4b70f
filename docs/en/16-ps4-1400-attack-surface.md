# 16 — PS4 14.00 Attack Surface and Technical Map

> This document maps the public attack surface and the measured boundaries reported by community researchers. It is a research map, not an exploit guide. All PS4-specific claims must be verified on your own console/firmware dump.

---

## 1. Architecture in one picture

```text
Userland entry
  ├── WebKit browser (main public 14.00 research surface)
  ├── BD-J / Blu-ray Java (no public 14.00 cold-start route)
  ├── Media parsers (MP4/M4A, audio/video)
  ├── Remote Play daemon (NPXS21006)
  └── Savedata / PS2 emu / other apps (lower priority)

        │ browser sandbox boundary
        ▼
Browser sandbox
  credential class → prison → mount table → syscall gates → device permissions

        │ kernel boundary
        ▼
Orbis OS kernel (FreeBSD 9-derived + Sony subsystems)
  AIO, netcontrol, execve, ffs/UDF, sound, semaphores, IPC, devices, ...

        │ kernel R/W
        ▼
Post-exploitation
  creds / prison0 / rootvnode / dynlib patches → GoldHEN/HEN
```

The userland chain is reported as solved/partially solved on 14.00; the sandbox and kernel are the hard boundaries.

---

## 2. Userland entry surfaces

### 2.1 WebKit browser (primary)

**Why it is the leading surface on 14.00**

- Sony's last PS4 WebKit source drop is **13.00-**; there is no public 13.50/13.52/14.00 source drop (S50). Community evidence indicates the engine is effectively frozen.
- Public 13.04/13.52 research hosts exist; the **SSV / SerializedScriptValue** bug family has been ported/tested on 14.00 by multiple researchers (S58, S59, S60).
- It requires no disc, no network service, and no special app beyond the browser.

**Reported capabilities on 14.00**

| Capability | Status | Source |
|---|---|---|
| Browser-process read/write | Reported demonstrated with fresh-page repeats | S58, S59 |
| addrof / fakeobj / base leak | Reported working | S58, S59 |
| Native execution / ROP / syscalls | Reported demonstrated | S58, S59, S60 |
| Browser sandbox escape | Not demonstrated | S58, S59 |
| Kernel R/W | Not demonstrated | S58, S59, S60 |

**Important distinctions**

- The old `CSSFontFace` UAF is exploitable only up to PS4 **11.02**; it is not the 14.00 entry (S61).
- A working R/W primitive is not a sandbox escape. The browser is still in a prison with syscall/device gates.
- Do not trust "14.00 jailbreak" pages that only show a browser alert or a payload menu; verify the boundary crossed.

### 2.2 BD-J / Blu-ray

- BD-JB variants up to 13.04 are documented; BD-JB-13.04 was patched at 13.50.
- BD-JB-EX can preserve BD-JB on higher firmware only if a JAR was previously injected into `system_ex` using a kernel exploit.
- No public cold-start BD-J escape for 14.00 is documented. A burned disc is not a 14.00 entry today.
- BD-J remains interesting for its privileged process (`libkernel_sys`, `nmount`) if a new bug is found.

### 2.3 Media parsers

- A community report describes an **MP4/M4A atom parser heap overflow** in the media stack (Media Player / SHAREfactory), confirmed on 11.00 and likely present on later firmware; details are not independently verified (S60).
- Parser bugs are attractive because they can be triggered by a file, but the app's sandbox and code path must be measured.
- Candidate work: fuzz the parser on PC with ASAN, then reproduce on a test console; compare crash signatures across 13.52/14.00.

### 2.4 Remote Play daemon (NPXS21006)

- The console-side daemon exposes **UDP 987** (discovery) and **TCP 9295** (registration/control) on the LAN.
- Community testing found discovery/registration without pairing; 576 fuzz cases produced no crashes. The control/takion channels need PIN mode to open (S58).
- This is a non-browser process with its own parser surface — a second front, but not a browser sandbox escape.

### 2.5 Other userland surfaces

| Surface | 14.00 status | Notes |
|---|---|---|
| Savedata / Lua Loader | Not a public 14.00 route | Historical chains; firmware-specific |
| PS2 emulator (`mast1c0re`) | Publicly reported unpatched in an OSS/chart snapshot; not a full 14.00 chain | Requires a compatible PS2-on-PS4 game |
| PlayStation Vue | Blocked since 13.50 | Not available |
| Netflix / YouTube apps | Not a public 14.00 route | App versions and sandbox vary |
| BD-JB-EX | Persistence only | Requires a prior kernel exploit/injection |

---

## 3. Browser sandbox map (14.00)

Community research maps the browser process sandbox in five layers (S58):

1. **Sony credential class** — system vs non-system process gates.
2. **Prison** — a restricted root with a limited mount table.
3. **Mounts** — visible files/directories.
4. **Per-syscall gates** — checks at syscall entry (not only in the kernel object).
5. **Per-device permissions** — device nodes visible but often denied.

### 3.1 Filesystem prison

Visible paths reported from the browser (S58):

```text
/              prison root
/dev           partially populated devfs
/system_tmp    live UNIX sockets
/user          user data
/av_contents   AV content mount
/<random>      one random-named directory
```

About 31 standard system paths are **invisible** (not in the mount table). The wall is the mount set, not the file syscall implementation.

### 3.2 Visible devices

| Node | Browser access | Notes |
|---|---|---|
| `dipsw` | `open()` succeeds; read fails (ioctl-only) | Ioctl window reported `0x80028800..0x80108804`; untested |
| `random` / `urandom` | Readable and writable | Available from the prison |
| `dmem0`, `dce`, `aout` | Opens denied for browser class | Tightened in 14.00 |
| `rng`, `bt` | Visible | Semantics/perms need measurement |

### 3.3 Live UNIX sockets in `/system_tmp`

Reported: `mdbg0_dbgp`, `GnmCompositor`, `GnmCompositorRestricted`, `gpvdec_arbitrator`, `gpvdec_proxy`, `gpvenc_proxy`.
The protocols are unknown; `connect()` behavior from the browser has not been measured publicly (S58).

### 3.4 Measured syscall/IPC gates (browser class)

| Area | 14.00 observation | Implication |
|---|---|---|
| `aio_multi_wait` (663) | Immediate error; no waiter created | Public Lapse chain blocked at the wait stage |
| `aio_multi_delete` (662) | Alive/gated? Returns success for ordinary deletes; TOCTOU lead open | Potential race path; panic risk |
| `evf_*` / `osem_*` | Creation/ops denied for browser class | Named IPC not directly usable |
| `dmem0`/`dce`/`aout` opens | Denied | Device paths tightened |
| Non-AF_UNIX sockets | Restricted | Browser network options narrowed |
| `sys_dynlib_*`/syscall gates | 302 libkernel stubs mapped | Use measured tables, not old firmware assumptions |

**Lesson:** a syscall returning an error is not proof that the underlying kernel object is safe; the gate may be at entry.

---

## 4. Kernel attack surface

### 4.1 Baseline

Orbis OS is a Sony-modified **FreeBSD 9-derived** kernel. Public analyses use FreeBSD 9 source as a reference, but Sony patches and new subsystems mean every candidate needs source/binary verification on the PS4 kernel.

Relevant subsystems:

- `sys/kern/kern_exec.c` — execve, SUID credential transition
- `sys/dev/sound/pcm/buffer.c` — sound buffer resize/mmap
- `sys/kern/sysv_sem.c` — SysV semaphores (`semctl`)
- `sys/kern/sys_aio.c` / `SceAIO` — asynchronous I/O
- `sys/net*` / `__sys_netcontrol` — IPv6 netevent, routing headers
- `sys/ufs/ffs` / UDF / `pfs` — filesystems and mounts
- `sys/kern/sysv_msg.c`, `sysv_shm.c` — SysV IPC
- device ioctls (`dipsw`, graphics/audio)
- Sony subsystems exposed through `libkernel_sys`

### 4.2 Candidate CVEs

| CVE | Subsystem / class | NVD CVSS | PS4 applicability | Main obstacle |
|---|---|---|---|---|
| **CVE-2026-49415** | `execve(2)` SUID TOCTOU; modifies SUID process memory during credential transition | 8.8 High | Code path may exist in FreeBSD 9; candidate | Needs SUID binary + procfs access; browser jail likely blocks |
| **CVE-2026-101308** | `sound(4)` `sndbuf_resize` drops lock, mmap completes, freed buffer remains mapped → UAF | 5.5 Medium | Candidate if sound device is reachable | Browser device gates; heap grooming; audio path |
| **CVE-2026-58087** | `semctl GETALL/SETALL` sequence wrap after 0x8000 cycles → OOB kernel heap read/write | 7.8 High | Candidate if SysV semaphores reachable | Browser syscall gate? 0x8000-cycle race/setup |
| **CVE-2026-7270** | `execve` argument slab overflow (operator precedence) | — | **Disputed/discarded** for FreeBSD 9: function introduced in FreeBSD 13; do not rely | Not present in baseline |
| **AIO delete TOCTOU** | `sys_aio_multi_delete` lock-upgrade window | — | Open lead; delete 662 alive; wait 663 gated | Microsecond race; kernel panic on loss |
| **bnet `raise` UAF** | IPv6 netevent queue / socket close | — | Entry chain proven; exploitation open | ~1e-8 per attempt; panic risk |
| **`/dev/dipsw` ioctl** | Sony device ioctl | — | Open fd from browser; untested | Unknown protocol; blind sweeps dangerous |
| **Named IPC registry** | evf/osem kernel registry | — | Kernel registry unauthenticated; browser gated at entry | Needs a confused deputy |
| **`/system_tmp` sockets** | Graphics/decoder arbiters | — | Browser-visible UNIX sockets | Protocol unknown |
| **Remote Play parsers** | NPXS21006 network daemon | — | Separate process class | No crash found in 576 cases; ctrl needs PIN |

### 4.3 KASLR and mitigations

- PS4 kernel uses KASLR. A kernel exploit needs a base leak or a KASLR-independent primitive.
- The browser process can leak WebKit base; leaking **kernel** base is a separate problem.
- SMEP/SMAP and other mitigations depend on model/firmware; verify experimentally rather than assuming.
- Public 14.00 kpatches use `rdmsr(0xc0000082) - xfast_syscall_off` to find the kernel base **after** kernel R/W/execution; that is post-exploitation, not a KASLR bypass.
- A kernel crash usually means a reboot; plan for it and isolate the test console.

---

## 5. High-value open leads (ranked)

This ranking is from the public research repository S58; it is a hypothesis list, not a guarantee.

| Rank | Lead | Why it is interesting | Next evidence needed | Risk |
|---|---|---|---|---|
| 1 | **AIO `multi_delete` TOCTOU** | Delete path alive; lock-upgrade window; public Lapse recipe available; two worker threads possible via Web Workers | Reproduce delete race with health checks; confirm no wait gate | Kernel panic |
| 2 | **`/dev/dipsw` ioctl** | Only measured-open device door for browser; command window known; never tested | One ioctl per session with errno readout; no blind loops | Unknown, potentially panic |
| 3 | **Named IPC registry / confused deputy** | Kernel registry has no auth; browser sees namespaces | Find a non-gated system daemon that acts on browser-controlled names | Low direct risk; complex |
| 4 | **`/system_tmp` sockets** | Live graphics/decoder endpoints reachable by name | Measure `connect()`/`stat()`; protocol discovery | Unknown |
| 5 | **bnet `raise` UAF** | Netevent chain proven; socket close/raise race | Improve race reliability; avoid wedged slots | Panic, low probability |
| 6 | **Remote Play parsers** | Non-browser process, LAN reachable | PIN-mode ctrl/takion fuzzing | Network service; crash risk |
| 7 | **Untested stub families** | `virtual_query` 572, `shm_open` 482, `blockpool_batch` 657, `jitshm` 533/534 | One syscall per session, errno readout | Low if bounded |

Closed leads (do not reopen without new evidence): public Lapse wait chain, Celsius `ffs_mount`, CSSFontFace above 11.02, `evf/osem` creation from browser, `dmem/aout` opens, fake 14.00 offset files.

---

## 6. Static analysis workflow (no 14.00 exploit needed)

1. Obtain the official 14.00 PUP (S49).
2. On a **13.52 jailbroken console**, run `ps4-pup-decrypt` with 14.00 offsets (S52/S53) to produce `.dec` parts.
3. Unpack with `pup_unpack` (S55).
4. Extract:
   - kernel image / `kernel.elf`-equivalent,
   - `libSceNKWebKit.sprx` and browser modules,
   - `bdjstack.jar` / BD-J classes,
   - system libraries and daemons.
5. Hash and version every file.
6. Compare 13.52 vs 14.00:
   - function-level diff (BinDiff/Diaphora/Ghidra),
   - string/symbol changes,
   - patched branches (candidate vulnerabilities),
   - new code (new attack surface).
7. Reproduce community offsets/gadgets against your dump; do not trust published numbers blindly.
8. Feed hypotheses into the browser userland harness and then the kernel reachability tests.

### 6.1 Toolchain

| Purpose | Tools |
|---|---|
| PUP decrypt | `PupDecrypt-PS4`, `ps4-pup-decrypt`, GoldHEN BinLoader |
| Unpack | `pup_unpack` |
| Disassembly/decompile | Ghidra, IDA Pro, Binary Ninja, radare2/rizin |
| Binary diff | BinDiff, Diaphora, Ghidra Version Tracking |
| ROP/gadgets | ROPgadget, ropper |
| WebKit source | Sony PS4 OSS WebKit 13.00 archive (S50) |
| Kernel source reference | FreeBSD 9 source tree (verify Sony patches) |
| Payload build | `ps4-payload-sdk`, `ps4-payload-dev/sdk` |
| Debug/log | GoldHEN Klog 3232, UART (advanced), crash dumps |

---

## 7. Boundaries that are easy to misread

- **A successful syscall return is not a boundary crossing.** It may be an allowed stub or a gate returning a misleading success.
- **A browser R/W primitive is not a sandbox escape.** The browser still runs with a restricted credential class and prison.
- **A private/teaser jailbreak is not a reproducible result.** Do not base a roadmap on it.
- **A CVE affects FreeBSD, not necessarily PS4.** Verify the vulnerable code is present and reachable.
- **A kernel patch source existing for 14.00 does not mean a kernel exploit exists.** It means post-exploitation code knows where to patch once R/W is obtained.

---

## 8. Sources

- S49 — Sony PS4 system software: <https://www.playstation.com/en-us/support/hardware/ps4/system-software/>
- S50 — Sony PS4 WebKit OSS: <https://www.playstation.com/en-us/oss/ps4/webkit/>
- S52 — `PupDecrypt-PS4`: <https://github.com/iHaiDeeZ/PupDecrypt-PS4>
- S53 — `ps4-pup-decrypt`: <https://github.com/Scene-Collective/ps4-pup-decrypt>
- S55 — `ps4-pup_unpack`: <https://github.com/idc/ps4-pup_unpack>
- S57 — `ps4-exploit-kpatches`: <https://github.com/ps3120/ps4-exploit-kpatches>
- S58 — `ps4-1400-research`: <https://github.com/Mikadolebg/ps4-1400-research>
- S59 — `PS4-14.00-Jailbreak-Research`: <https://github.com/siongadev/PS4-14.00-Jailbreak-Research>
- S60 — `ps4-14-00-security-notes`: <https://github.com/adri22235/ps4-14-00-security-notes>
- S61 — `CSSFontFace-Exploit`: <https://github.com/ntfargo/CSSFontFace-Exploit>
- S63–S66 — NVD CVE records (see [sources](12-sources.md))
- S73 — FreeBSD SA-26:71.sound: <https://www.freebsd.org/security/advisories/FreeBSD-SA-26:71.sound.asc>
- Full list: [sources](12-sources.md)
