> **GitHub publication copy.** This repository contains the documentation, data, and metadata. The 41 local source clones (~835 MB), the Poopsploit gist clone, and the web/PDF snapshots are **not** included here because of size, nested-Git, and copyright/licensing constraints. Use `sources/clone-repos.sh` and `sources/clone-1400-research.sh` plus the links in `docs/en/12-sources.md` to recreate them locally. See `PUBLISHING.md` for details.

# PS4 Blu-ray Jailbreak — A Complete BD-JB Documentation Project

> Last updated: **30 October 2026** (2026-10-30)
>
> Scope: the PS4 jailbreak entry point based on **Blu-ray Disc Java (BD-J)**, its kernel-exploit chain, tools, firmware compatibility, and sources.
>
> Project type: **security research and educational documentation** for personally owned consoles. This project does not distribute exploit binaries or copyrighted firmware, and it does not endorse game piracy.

---

## What this project is

The "PS4 Blu-ray jailbreak" commonly refers to **BD-JB**: a chain of vulnerabilities in the Java runtime and sandbox of the PS4 Blu-ray player, triggered by a **burned Blu-ray disc** (BD-R/BD-RE). BD-JB is only a **userland entry point**. A full jailbreak also requires a **kernel exploit** (Lapse or Poopsploit) to load GoldHEN or HEN and enable homebrew.

This project consolidates information scattered across the web, GitHub, HackerOne, wikis, and community forums into a single structure: history, technical analysis, firmware compatibility, hardware, a step-by-step guide, tools, payloads, troubleshooting, risks, and sources.

**Persian documentation is preserved in [`docs/`](docs/00-خلاصه.md) and [`resources/quick-links-fa.md`](resources/quick-links-fa.md). English documentation lives in [`docs/en/`](docs/en/00-summary.md).**

---

## Quick status summary (October 2026)

| PS4 firmware | Disc-based BD-JB? | Kernel exploit | Practical status |
|---|---|---|---|
| **9.00 – 12.02** | Yes (Lapse ISO / HENloader) | Lapse | Stable and well documented; 9.00 and 12.02 are the best targets |
| **12.50 – 12.52** | Yes (Poops ISO / HENloader) | Poopsploit | Stable, but Lapse is patched at 12.50 |
| **13.00 – 13.04** | Yes, but research/special builds only | Poops (13.00 only); Relapse/Celsius (community-reported for 13.02–13.04) | Advanced; verify the sources for your exact firmware |
| **13.50 – 13.52** | Blocked from disc; BD-JB-EX only with a previously injected JAR | Public route is mainly WebKit (GoldHEN 2.4b18.12) | Not recommended for average users; do not update |
| **14.00** | No public full chain; browser userland-only research | No public KEX; browser userland research only | No public jailbreak; private/teaser reports only; do not update |
| **14.10** | Not a PS4 firmware | — | 14.10 is PS5 (26.06-14.10.00); do not confuse with PS4 |

> Important: Sony patched Lapse at 12.50, parts of BD-JB at 13.00/13.02, re-introduced a BD-JB path at 13.04, and patched the 13.04 path at 13.50. The scene changes quickly; always check the dates of the sources before updating or buying hardware.

---

## Where to start

1. **If your firmware is 9.00–12.52:** read the [step-by-step guide](docs/en/07-step-by-step-guide.md). The fastest route is **HENloader LP** (Lapse for 9.00–12.02, Poops for 12.50–12.52) or the Gezine/DefKorns ISOs.
2. **If you want to understand how it works:** read [fundamentals](docs/en/01-fundamentals.md) and the [technical deep dive](docs/en/03-technical-deep-dive.md).
3. **If your firmware is 13.00 or newer:** read [firmware compatibility](docs/en/05-firmware-compatibility.md). Most routes are research-grade and version-specific.
4. **If you need a specific tool or repository:** see [tools and repositories](docs/en/08-tools-and-repositories.md).
5. **If something fails:** see [troubleshooting](docs/en/10-troubleshooting.md).
6. **If you plan to research PS4 14.00:** start with the [14.00 status](docs/en/15-ps4-1400-status.md), [attack surface](docs/en/16-ps4-1400-attack-surface.md), [roadmap and lab](docs/en/17-research-roadmap-and-lab.md), and [skills/experience](docs/en/18-skills-and-experience.md).

---

## Project structure

```text
ps4-bd-jb/
├── README.md                        ← this file (English)
├── docs/
│   ├── en/                          ← complete English documentation
│   │   ├── 00-summary.md
│   │   ├── 01-fundamentals.md
│   │   ├── 02-history-and-timeline.md
│   │   ├── 03-technical-deep-dive.md
│   │   ├── 04-kernel-exploits.md
│   │   ├── 05-firmware-compatibility.md
│   │   ├── 06-hardware-and-software.md
│   │   ├── 07-step-by-step-guide.md
│   │   ├── 08-tools-and-repositories.md
│   │   ├── 09-payloads-and-goldhen.md
│   │   ├── 10-troubleshooting.md
│   │   ├── 11-risks-and-legal.md
│   │   ├── 12-sources.md
│   │   ├── 13-glossary.md
│   │   ├── 14-faq.md
│   │   ├── 15-ps4-1400-status.md
│   │   ├── 16-ps4-1400-attack-surface.md
│   │   ├── 17-research-roadmap-and-lab.md
│   │   └── 18-skills-and-experience.md
│   └── *.md                         ← Persian documentation mirror
├── data/
│   ├── firmware-compatibility.csv   ← machine-readable compatibility table
│   ├── sources.json                 ← structured source metadata
│   ├── cloned-sources.json          ← local clone inventory (generated)
│   ├── cves-ps4-1400.json           ← NVD records for candidate CVEs
│   └── ps4-1400-research.json       ← 14.00 status, candidates, open leads
├── resources/
│   ├── quick-links.md               ← English quick links
│   └── quick-links-fa.md            ← Persian quick links
└── sources/
    ├── README.md                    ← clone inventory and provenance
    ├── clone-repos.sh               ← core clone script
    ├── clone-1400-research.sh       ← 14.00 research/tooling clone script
    ├── clones.log                   ← clone log
    ├── repos/                       ← 41 shallow repository clones
    ├── gists/                       ← Poopsploit gist clone
    └── web/                         ← saved PDF/HTML snapshots of non-git sources
```

---

## Three key facts

1. **BD-JB alone is not a full jailbreak.** The disc escapes the Java sandbox; a kernel exploit is required to load GoldHEN/HEN and install homebrew/PKG files.
2. **The practical ceiling for disc-based BD-JB is 12.52.** Research builds exist for 13.00/13.02/13.04, but they are not the standard low-risk path. From 13.50 onward, disc-based BD-JB is blocked.
3. **Firmware updates kill exploits.** If your console is on a jailbreakable firmware, disable auto-updates and verify the current status before every update.

---

## PS4 14.00 research track

If the goal is to work on **PS4 14.00**, the research foundation is deliberately separated from the BD-JB guide:

- [15 — 14.00 status and evidence](docs/en/15-ps4-1400-status.md): what is public, what is private/teaser-only, and what is missing.
- [16 — 14.00 attack surface](docs/en/16-ps4-1400-attack-surface.md): WebKit, sandbox, kernel, media/IPC surfaces, and candidate CVEs.
- [17 — research roadmap and lab](docs/en/17-research-roadmap-and-lab.md): PUP decryption/static analysis, userland reproduction, kernel hunt, post-exploitation, and validation.
- [18 — skills and experience](docs/en/18-skills-and-experience.md): skills matrix, learning path, lab discipline, pitfalls, and collaboration.

Key facts:

- The **browser userland** on 14.00 is reported working by multiple community research repositories, but the **sandbox escape and kernel primitive are not public**.
- A 14.00 PUP can be **decrypted on a 13.52 jailbroken console** and unpacked for static analysis; no 14.00 exploit is needed for that step.
- Public 14.00 **kernel offsets/kpatches** exist as post-exploitation references, but they are not a kernel exploit.
- **14.10 is a PS5 firmware**, not a PS4 firmware. Do not confuse the two.
- Data: [`data/ps4-1400-research.json`](data/ps4-1400-research.json) and [`data/cves-ps4-1400.json`](data/cves-ps4-1400.json).

---

## Important warnings

- Jailbreaking may **void the warranty**, lead to a **PSN ban**, or damage the system/data if an unknown payload is used.
- Use only **official/known sources** for payloads and ISOs. Cheap pre-burned discs and "cracked" payloads can be malicious.
- Use this information for **personal ownership, security research, and homebrew**. Distributing pirated games, DRM circumvention for sale, and online cheating are outside the scope of this project.
- Laws vary by jurisdiction. This project is not legal advice. See [risks and legal notes](docs/en/11-risks-and-legal.md).

---

## Source repository clones

All public GitHub repositories referenced in this project are cloned under [`sources/repos/`](sources/repos) — **41 repositories plus the Poopsploit gist**, approximately 836 MB on disk. This includes the **PS4 14.00 research track**: PUP decrypt/unpack tools, WebKit research harnesses, 14.00 kernel patch/offset sources, and the public 14.00 research workspaces. The original `Gezine/BD-JB-1250` repository is currently unavailable/private; its active forks (`ps3120/BD-JB-1250` and `ayasns/BD-JB-1250`) are cloned. The clone inventory, commit hashes, and failures are recorded in [`sources/README.md`](sources/README.md) and [`sources/clones.log`](sources/clones.log). Non-Git sources are archived in [`sources/web/`](sources/web): the hardwear.io 2022 PDF, full PSDevWiki HTML plus a readable Markdown snapshot, ConsoleMods pages, the HENloader guide, and Sony's PS4 WebKit/system-software pages. HackerOne, Reddit, X, and YouTube pages require JavaScript/auth or block automated access; their links are preserved but they are not archived locally.

> Cloned repositories remain under their upstream licenses. They are read-only reference copies; this project does not claim ownership of them. Some upstream repositories contain release binaries, ISOs, or firmware-derived artifacts; those remain upstream artifacts and are not authored or endorsed for redistribution by this project.

---

## Key sources

- Official BD-JB source: <https://github.com/TheOfficialFloW/bd-jb>
- PSDevWiki vulnerabilities (most technical reference): <https://www.psdevwiki.com/ps4/Vulnerabilities>
- ConsoleMods exploit chart (October 2026 archive): <https://web.archive.org/web/20261020125155/https://consolemods.org/wiki/PS4:Exploit_Chart>
- HENloader LP: <https://github.com/GoldHEN/henloader_lp>
- Full dated source list: [docs/en/12-sources.md](docs/en/12-sources.md)

---

## Documentation status

This project was compiled on 30 October 2026 from public sources. The PS4 scene changes quickly, and some 13.x information comes from community reports rather than official Sony documentation. Claims with lower confidence are explicitly marked in the relevant documents and in the CSV/JSON data files.
