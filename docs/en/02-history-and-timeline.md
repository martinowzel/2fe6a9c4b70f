# 02 — History and Timeline of BD-JB

> This document traces the evolution of the PS4 Blu-ray jailbreak from the initial idea to the state of October 2026. Dates are based on public sources (PSDevWiki, HackerOne, GitHub, Reddit, ConsoleMods) and may differ slightly between discovery, disclosure, and public release.

---

## Compact timeline

| Date | Event | Significance |
|---|---|---|
| 2020-06-27 | CTurt proposes the idea of hacking BD-J on PS3/PS4 | Initial spark for the Blu-ray route |
| 2021-10 | Andy Nguyen (TheFloW) finds five BD-J vulnerabilities | Foundation of BD-JB1 |
| 2021-10-22 | `TheOfficialFloW/bd-jb` repository is created | First public BD-J code |
| 2022-06-10 | "bd-jb: Blu-ray Disc Java Sandbox Escape" at hardwear.io; HackerOne report | Public disclosure of the BD-JB1 chain for PS3/PS4/PS5 |
| 2022-06-16 | sleirsgoevy publishes the first public PS4 implementation | Research becomes a tool |
| 2022-07-12 | A PS5 sandbox escape is discovered | BD-JB expands to PS5 |
| 2023-09 to 10 | TheFloW reports/discloses a path-traversal bug (BD-JB2) | Support for newer firmware |
| 2024-11-28 | Path-traversal implementation lands in the BD-JB repository | Replaces the old `UserPreferenceManagerImpl` method |
| 2025-04-22 | TheFloW reports two Ixc vulnerabilities to HackerOne | Basis for BD-JB3 |
| 2025-04 to 05 | abc (anonymous) publishes the Lapse PoC and then a full exploit (AIO double free) | Stable kernel exploit for 5.00–12.02 |
| 2025-06 | Lapse is chained with PSFree, Lua Loader, and mast1c0re | Lapse becomes a standard |
| 2025-08-02 | Gezine publishes `BD-JB-1250` and the `com.sun.xlet.ixc.XletManager` exploit | Complete BD-JB for 9.00–12.02 plus Lapse |
| 2025-08-25 | Lapse/AIO is chained with BD-JB3 for PS4 5.00–12.02 | Full Blu-ray-disc jailbreak |
| 2025-08-30 | slidybat reports the `sys_netcontrol` double-fdrop bug | Poopsploit foundation |
| 2025-11-02 | TheFloW publishes Poopsploit, chained with BD-JB3 (PS4) and BD-JB2 (PS5) | PS4 support up to 13.00 |
| 2025-11-24 | HENloader LP 1.0 is released (Lapse 9.00–12.02 + Poops 9.00–12.52) | All-in-one user solution |
| 2025-12-05 | Gezine reports BD-JB-13.00 (`CVE-2025-64390`) to HackerOne | New route for 13.00/13.02 |
| 2026-02-20 | 15432 implements BD-JB-EX (JAR injection into `system_ex`) | BD-JB on higher firmware with a prior kernel exploit |
| 2026-03-17 | ps3120 implements BD-JB-13.04 | Disc-based route returns on 13.04 |
| 2026-03-21 | Gezine publishes `bdj_unpatch` for PS5 | BD-JB5 for PS5 13.60+; not PS4 |
| 2026-04-29 | HackerOne report for `CVE-2025-64390` is disclosed | Technical transparency |
| 2026-05-30 | ps3120 publishes an ISO for 13.00/13.02 and implements BD-JB3.2 | Research disc builds |
| 2026-06-02 | NVD publishes `CVE-2025-64390` details | Official CVE record |
| 2026-09 | GoldHEN 2.4b18.11/2.4b18.12 is reported for 13.02–13.52 (WebKit route) | 13.x jailbreak without disc BD-JB |
| 2026-09-16 | PS4 firmware **14.00** is released | New target; public research begins |
| 2026-09–10 | Community researchers report a browser **userland** chain on 14.00; no public sandbox escape or kernel primitive | The missing link is a KEX |
| 2026-09–10 | 14.00 PUP is decrypted on a 13.52 GoldHEN console with 14.00 offsets | Static analysis becomes possible without a 14.00 exploit |
| 2026-10-01 | PS5 firmware 26.06-14.10.00 is released | **14.10 is PS5, not PS4** |
| 2026-10 | Private/teaser full 14.00 jailbreak reports appear | Not public; not reproducible |
| 2026-10-30 | Current status: disc BD-JB stable through 12.52; 13.00–13.04 research; 13.50+ disc BD-JB blocked; 14.00 no public chain; 14.10 is PS5 | This project |

---

## 1. Early era: discovery and disclosure (2020–2022)

### 1.1 The BD-J idea

CTurt — known for `FreeDVDBoot` on PS2 — proposed using BD-J vulnerabilities on PS3/PS4. The idea was later turned into a full chain by TheFloW.

### 1.2 The five TheFloW vulnerabilities

Around October 2021, TheFloW found five vulnerabilities in Sony's BD-J implementation and disclosed them in June 2022 at hardwear.io and HackerOne. The chain affected **PS3, PS4, and PS5** and is known as BD-JB1.

Chain stages (per PSDevWiki):

1. Escape the sandbox by abusing `UserPreferenceManagerImpl` and deserializing the `userprefs` file in a privileged context.
2. Disable the SecurityManager with `System.setSecurityManager(null)`.
3. Install a native API using `sun.misc.Unsafe` and reflection.
4. Resolve native functions with `NativeLibrary.findEntry` and call them via `setcontext` / `multi_allocate`.
5. Execute arbitrary code on PS4 by sending requests to the compiler process.

> This chain alone is not enough to run copied games; the BD-J process has limited memory and other constraints.

### 1.3 First implementations

In June 2022, sleirsgoevy wrote the first public PS4 implementation. Afterwards, psxdev, sleirsgoevy, and John Törnblom developed public implementations and disc-building tools (BDJ-SDK).

---

## 2. The BD-JB2 and path-traversal era (2023–2024)

In September 2023, TheFloW reported a new vulnerability to Sony and disclosed it in October 2023: **path traversal in `BdjPolicyImpl`**.

Core idea:

```text
file:///app0/cdc/lib/../../../disc/BDMV/JAR/00000.jar
```

The `BDJO` file sets `baseDirectory` so the BD-J engine treats the JAR on the disc as a file under `$JAVA_HOME/lib` and grants it **AllPermission**. The attacker's JAR can then disable the SecurityManager.

This method was implemented in the `TheOfficialFloW/bd-jb` repository in November 2024, replacing the older `UserPreferenceManagerImpl` approach. BD-JB2 worked up to PS4 12.52 and PS5 8.00.

---

## 3. The BD-JB3 and Ixc era (2025)

### 3.1 TheFloW's reports

In April 2025, TheFloW reported two vulnerabilities in the Ixc implementations to HackerOne:

- `org.dvb.io.ixc` (the "reborn" variant)
- `com.sun.xlet.ixc.WrappedRemote`

### 3.2 Gezine's exploit

Gezine noticed that firmware 12.52 blacklisted the `com.sun.xlet` package — the only security-relevant change in that update. He found a vulnerability in `com.sun.xlet.ixc.XletManager`: `createXlet` allowed creating an Xlet with an attacker-controlled classloader and permissions. Combined with `WrappedRemote` (which invokes a method inside `doPrivileged`), this made it possible to call `System.setSecurityManager(null)`.

The exploit was published in August 2025 in `Gezine/BD-JB-1250` and worked on PS4 (not PS5, because `com.sun.xlet` is not exported on PS5).

> TheFloW later confirmed that the `com.sun.xlet` vulnerability found by Gezine was not the one he had reported to HackerOne.

### 3.3 Full chain with Lapse

Gezine combined BD-JB3 with the **Lapse** kernel exploit published by abc. The result was a complete Blu-ray-disc jailbreak for PS4 firmware **9.00–12.02**. Version 1.2 included AIO fixes for black screens and save-data corruption.

---

## 4. The Poopsploit and firmware 13.x era (2025–2026)

### 4.1 Poopsploit

In August 2025, slidybat reported a double-fdrop bug in `sys_netcontrol`. In November 2025, TheFloW published a full exploit and chained it with BD-JB3 (PS4) and BD-JB2 (PS5). The exploit, known in the community as **Poopsploit**, worked on PS4 up to firmware **13.00** and on PS5 up to **12.00**, and was patched in 13.02 (PS4) / 12.02 (PS5).

### 4.2 HENloader LP

In November 2025, an all-in-one package called **HENloader LP** was released with both kernel exploits on one disc:

- **Lapse:** firmware 9.00–12.02
- **Poopsploit:** firmware 9.00–12.52
- GoldHEN 2.4b18.7 was included.
- In the menu, Cross selected Lapse and Circle selected Poops.

This became the practical, low-friction route for most users on 9.00–12.52.

### 4.3 BD-JB-13.00 and CVE-2025-64390

In December 2025, Gezine found a new bug in the loading of nested JARs and reported it to HackerOne. It became **BD-JB-13.00** and **CVE-2025-64390**.

Summary:

- The `baseDirectory` value in the BDJO is set to a path such as `file:/dsm/00000.jar/../../app0/bdjstack/lib/ext/00000.jar`.
- A JAR is nested inside itself so the BD-J engine treats it as a file under `lib/ext` and grants AllPermission.
- To bypass signature verification, the `applicationId` is chosen outside the `0x4000–0x7FFFF` range.

The bug was patched in 13.04 by truncating the path at the first `.jar`. ps3120 later published ISOs for 13.00/13.02.

### 4.4 BD-JB-13.04 and BD-JB-EX

- **BD-JB-13.04:** in 13.04, a Sony patch accidentally re-opened the old path traversal. ps3120 implemented it in March 2026 and published `bdj1304.iso`. It was patched in 13.50.
- **BD-JB-EX:** with a prior kernel exploit, a malicious `00000.jar` is injected into `system_ex/app/NPXS20113/bdjstack/lib/ext/`. Any JAR in that path receives full permissions. The vector was proposed by CelesteBlue and implemented by 15432 in February 2026. Limitation: the console must already have been jailbroken on a firmware with a kernel exploit, and the injection is lost if firmware is reinstalled.

---

## 5. The 2026 state and historical lessons

1. **Patch/reintroduction pattern:** Sony patched BD-J routes several times, but a side effect reintroduced a vulnerability in 13.04. BD-JB is not a "finished" route.
2. **The kernel exploit is the bottleneck:** even when BD-JB works on 13.02/13.04, the lack of a stable public kernel exploit limits a full jailbreak.
3. **WebKit became the alternative:** for 13.50/13.52, the community moved to WebKit (Slopkit/Relapse/Celsius) and GoldHEN 2.4b18.12; disc BD-JB is no longer the primary route.
4. **12.52 is the last standard disc-BD-JB firmware.** 9.00 and 12.02 remain popular because of Lapse's stability.
5. **Scene information expires quickly:** check source dates before buying hardware or updating.

---

## 6. Beyond BD-JB: the 14.00 research era (September–October 2026)

PS4 14.00 changed the research focus from Blu-ray to the browser:

- Sony's last PS4 WebKit source drop is **13.00-**; no 13.50/13.52/14.00 source archive is listed. Community research treats the engine as frozen and ports the 13.04/13.52 **SSV/WebKit** userland work to 14.00.
- Community repositories report browser read/write, native execution/ROP, and syscalls on 14.00, but explicitly **no public sandbox escape or kernel primitive**.
- The public Lapse/AIO wait path is gated on 14.00; Celsius `ffs_mount` was patched at 13.50.
- A **13.52 jailbroken console** can decrypt the official 14.00 PUP, enabling static kernel/WebKit analysis without a 14.00 exploit.
- A private/teaser full jailbreak is discussed, but it is not publicly available or reproducible.
- **14.10 is a PS5 firmware**, not PS4.

See [15 — PS4 14.00 status](15-ps4-1400-status.md) for the evidence table.

---

## Sources for this document

- PSDevWiki — Vulnerabilities: <https://www.psdevwiki.com/ps4/Vulnerabilities>
- TheOfficialFloW/bd-jb: <https://github.com/TheOfficialFloW/bd-jb>
- hardwear.io 2022 slides: <https://github.com/TheOfficialFloW/Presentations/blob/master/2022-hardwear-io-bd-jb.pdf>
- HackerOne reports 1379975, 3104356, 3320669, 3452696
- Gezine/BD-JB-1250 and ps3120/BD-JB-1250: <https://github.com/ps3120/BD-JB-1250>
- DefKorns/BD-JB-1252: <https://github.com/DefKorns/BD-JB-1252>
- GoldHEN/henloader_lp: <https://github.com/GoldHEN/henloader_lp>
- ConsoleMods — PS4 Exploit Chart (archived 2026-10-20)
- Reddit r/ps4homebrew — "BD-J+Lapse jailbreak release 9.00-12.02" and "A new PS4 BD-JB that works up to 13.02 by Gezine"
