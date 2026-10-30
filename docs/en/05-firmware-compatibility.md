# 05 — Firmware Compatibility (October 2026)

> This document summarizes the PS4 Blu-ray/kernel jailbreak status across firmware versions. "Practical route" means what a typical user can do with public tools; "Research" means it requires technical knowledge, a special build, or higher risk.

---

## 1. Decision summary

| Firmware | Disc BD-JB? | Kernel | Practical route | Recommendation |
|---|---|---|---|---|
| **9.00** | Yes | Lapse | HENloader / Lapse.iso | Keep; very stable |
| **9.03 / 9.04** | Yes | Lapse | HENloader | Keep |
| **9.50 / 9.51 / 9.60** | Yes | Lapse | HENloader | Keep |
| **10.00 / 10.01** | Yes | Lapse | HENloader | Keep |
| **10.50 / 10.70 / 10.71** | Yes | Lapse | HENloader | Keep |
| **11.00** | Yes | Lapse | HENloader | Keep |
| **11.02** | Yes (HENloader) | Lapse | HENloader | Keep |
| **11.50 / 11.52** | Yes | Lapse | HENloader | Keep |
| **12.00 / 12.02** | Yes | Lapse | HENloader / Lapse.iso | Keep; 12.02 is the most stable |
| **12.50 / 12.52** | Yes | Poopsploit | HENloader / Poops.iso | Keep; Lapse patched |
| **13.00** | Yes (research) | Poopsploit | ISO 13.00/13.02 + Poops | Advanced users only |
| **13.02** | Yes (research) | Poops patched; Relapse (community) | Research / exact-version sources | Do not update |
| **13.04** | Yes (`bdj1304.iso`) | Relapse/Celsius (community) | Research | Last disc-BD-JB firmware |
| **13.50 / 13.52** | No (from disc) | WebKit + GoldHEN 2.4b18.12 | WebKit route; BD-JB-EX with prior injection | Do not update |
| **14.00** | No public full chain (browser userland-only research) | No public KEX | Research: 13.52 PUP decrypt + WebKit work | No public jailbreak; do not update |
| **14.10** | Not a PS4 firmware | — | — | 14.10 is PS5 (26.06-14.10.00) |

> "Yes (research)" means an ISO/tool exists but the route is not standard or low-risk. Always read the README for that exact build.

---

## 2. Detailed tables

### 2.1 Firmware 9.00–12.52 (standard disc route)

| Firmware | BD-JB variant | Kernel exploit | Tool/ISO | Status |
|---|---|---|---|---|
| 9.00 | BD-JB1/BD-JB3 | Lapse | HENloader LP / Lapse.iso | Stable |
| 9.03 | BD-JB1/BD-JB3 | Lapse | HENloader LP | Stable |
| 9.04 | BD-JB1/BD-JB3 | Lapse | HENloader LP | Stable |
| 9.50 | BD-JB1/BD-JB3 | Lapse | HENloader LP | Stable |
| 9.51 | BD-JB1/BD-JB3 | Lapse | HENloader LP | Stable |
| 9.60 | BD-JB1/BD-JB3 | Lapse | HENloader LP | Stable |
| 10.00 | BD-JB2/BD-JB3 | Lapse | HENloader LP | Stable |
| 10.01 | BD-JB2/BD-JB3 | Lapse | HENloader LP | Stable |
| 10.50 | BD-JB3 | Lapse | HENloader LP | Stable |
| 10.70 | BD-JB3 | Lapse | HENloader LP | Stable |
| 10.71 | BD-JB3 | Lapse | HENloader LP | Stable |
| 11.00 | BD-JB3 | Lapse | HENloader LP | Stable |
| 11.02 | BD-JB3 | Lapse | HENloader LP | Stable (community source) |
| 11.50 | BD-JB3.2 | Lapse | HENloader LP | Stable |
| 11.52 | BD-JB3.2 | Lapse | HENloader LP | Stable |
| 12.00 | BD-JB3.2 | Lapse | HENloader LP | Stable |
| 12.02 | BD-JB3.2 | Lapse | HENloader LP / Lapse.iso 1.2 | Most stable |
| 12.50 | BD-JB3.2 | Poopsploit | HENloader / DefKorns Poops.iso | Stable |
| 12.52 | BD-JB3.2 | Poopsploit | HENloader / DefKorns Poops.iso | Stable |

**Notes:**

- HENloader LP 1.0 (November 2025) contains both Lapse and Poops in one ISO. In the menu, **Cross = Lapse** and **Circle = Poops**. On 12.50/12.52 the Lapse option is disabled because it is patched.
- `Lapse.iso` 1.2 and later include AIO fixes (black screen/save corruption) inside the ISO. Older 1.0/1.1/1.1b builds require sending `aiofix_network.elf` separately.
- `DefKorns/BD-JB-1252` targets 12.50–12.52 and provides `Poops.iso` with a built-in payload.
- If your firmware is not listed (for example, 10.02 or 11.01), that does not prove incompatibility, but public tools have been tested mainly on the listed versions. Check the tool's source before proceeding.

### 2.2 Firmware 13.00–13.52 (research/special builds)

| Firmware | BD-JB | Kernel | Tool/note | Status |
|---|---|---|---|---|
| 13.00 | BD-JB-13.00 (`CVE-2025-64390`) | Poopsploit (≤13.00) | ISO `Lapse_1.2_Mod` by ps3120 (13.00/13.02) | Research |
| 13.02 | BD-JB-13.00 (ISO) | Poops patched; Relapse (community) | Same ISO + a 13.02-compatible kernel | Research; higher risk |
| 13.04 | BD-JB-13.04 | Relapse/Celsius (community) | `bdj1304.iso` by ps3120 | Research; last disc BD-JB |
| 13.50 | BD-JB-13.04 patched; BD-JB-EX with prior injection | WebKit route; GoldHEN 2.4b18.12 | Not from disc | Advanced |
| 13.52 | BD-JB-13.04 patched; BD-JB-EX | WebKit route; GoldHEN 2.4b18.11/12 | Not from disc | Advanced |
| 14.00+ | — | — | — | No public chain |

**Important caveats:**

1. **13.00/13.02:** ps3120's ISOs are based on BD-JB-13.00. See the `Lapse_1.2_Mod` tag in `ps3120/BD-JB-1250`. This route differs from the 9.00–12.52 tools and may require a separate kernel exploit.
2. **13.04:** `bdj1304.iso` is available in `ps3120/ps3120.github.io`. PSDevWiki states that the route returned in 13.04 and was patched in 13.50. The 13.04 kernel exploit is called Relapse/Celsius in community reports.
3. **13.50/13.52:** disc BD-JB is blocked. The main public route is WebKit (Slopkit) plus GoldHEN 2.4b18.12. BD-JB-EX only makes sense if you previously jailbroke a lower firmware and injected the JAR into `system_ex`.
4. **14.00:** no public cold-start userland/kernel chain. Community research reports a browser userland chain but no sandbox escape/KEX; a private/teaser full jailbreak exists but is not public. A 13.52 jailbroken console can decrypt the 14.00 PUP for static analysis. See [15 — 14.00 status](15-ps4-1400-status.md).
5. **14.10 is PS5**, not PS4. Do not apply PS5 firmware guidance to a PS4.

### 2.3 PS4 14.00 — research-only status

| Layer | Status |
|---|---|
| Release | 2026-09-16 |
| Public full jailbreak | None |
| Private/teaser full jailbreak | Reported only; not reproducible |
| Browser userland | Community-reported R/W/ROP/syscalls on 14.00 |
| Browser sandbox escape | Not publicly demonstrated |
| Kernel primitive | No public KEX; AIO wait gated; Celsius patched |
| PUP decrypt/static analysis | Possible on a 13.52 GoldHEN console with 14.00 offsets |
| 14.00 kernel offsets/kpatches | Public post-exploitation references; not a KEX |
| BD-JB cold start | No public route; BD-JB-13.04 patched at 13.50 |

**Key links:** [15 — status](15-ps4-1400-status.md), [16 — attack surface](16-ps4-1400-attack-surface.md), [17 — roadmap/lab](17-research-roadmap-and-lab.md), [18 — skills](18-skills-and-experience.md).

---

## 3. Why is 12.52 the "practical ceiling"?

Three reasons:

1. **Disc BD-JB is standard through 12.52.** The 13.x routes require research ISOs, less-documented kernels, or prior injection.
2. **Lapse was patched at 12.50, but Poopsploit worked up to 13.00.** This covers 12.50/12.52; after 13.00 the options fragment.
3. **All-in-one tools (HENloader) target exactly 9.00–12.52.** They are better tested and better documented than the 13.x routes.

---

## 4. "Is my firmware jailbreakable?" checklist

1. Read the exact firmware from `Settings → System → System Information`.
2. Find the row in the table above.
3. If it is 9.00–12.52: see the HENloader/Lapse/Poops route.
4. If it is 13.00–13.04: read the exact-version research sources (PSDevWiki, ps3120, ConsoleMods) and accept the risk.
5. If it is 13.50+: forget disc BD-JB; check the current WebKit/Relapse status from up-to-date sources.
6. If it is 14.00+: no public method; do not update and wait.

---

## 5. Sources for this document

- ConsoleMods — PS4 Exploit Chart (archived 2026-10-20): <https://web.archive.org/web/20261020125155/https://consolemods.org/wiki/PS4:Exploit_Chart>
- ConsoleMods — PS4:BD-JB (archived 2026-07-24): <https://web.archive.org/web/20260724075552/https://consolemods.org/wiki/PS4:BD-JB>
- PSDevWiki — Vulnerabilities (BD-JB and kernel versions): <https://www.psdevwiki.com/ps4/Vulnerabilities>
- HENloader LP: <https://github.com/GoldHEN/henloader_lp>
- `DefKorns/BD-JB-1252`: <https://github.com/DefKorns/BD-JB-1252>
- `ps3120/BD-JB-1250` (`Lapse_1.2_Mod` tag): <https://github.com/ps3120/BD-JB-1250/releases>
- `bdj1304.iso`: <https://github.com/ps3120/ps3120.github.io/blob/main/bdj1304.iso>
- Reddit — GoldHEN 2.4b18.12 and 13.xx support: <https://www.reddit.com/r/ps4homebrew/comments/1wmhxjd/goldhen_v24b1812_13xx_support/>
- Machine-readable table: [`data/firmware-compatibility.csv`](../../data/firmware-compatibility.csv)
