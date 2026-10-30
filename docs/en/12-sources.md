# 12 — Sources

> Access date for all sources: **30 October 2026 (2026-10-30)**. Archived links are provided for pages that may be unavailable directly. Treat "community" sources with caution.

---

## Local archive

All public GitHub repositories referenced below are cloned under `sources/repos/` (**41 repositories**); the Poopsploit gist is cloned under `sources/gists/poopsploit/`. Web/PDF snapshots are under `sources/web/` (the hardwear.io PDF, full PSDevWiki HTML plus a readable Markdown snapshot, ConsoleMods pages, the HENloader guide, and Sony's PS4 WebKit/system-software pages). Structured CVE records are in `data/cves-ps4-1400.json`. The clone inventory, commit hashes, and failures are recorded in `sources/README.md` and `sources/clones.log`. HackerOne, Reddit, X, and YouTube pages require JavaScript/auth or block automated access, so they are preserved as links only.

Cloned repositories remain under their upstream licenses; they are reference copies only.

---

## 1. Primary and official sources

| ID | Source | Type | Local copy | Notes | Link |
|---|---|---|---|---|---|
| **S01** | TheOfficialFloW/bd-jb | Official source | `repos/TheOfficialFloW-bd-jb` | Reference BD-JB source: `Exploit.java`, `Payload.java`, `Loader.java`, sandbox | <https://github.com/TheOfficialFloW/bd-jb> |
| **S02** | TheFloW — hardwear.io 2022 slides | Presentation/PDF | `repos/TheOfficialFloW-Presentations` | BD-JB1/BD-JB2 details; pages 27–28 cover path traversal | <https://github.com/TheOfficialFloW/Presentations/blob/master/2022-hardwear-io-bd-jb.pdf> |
| **S03** | HackerOne #1379975 | Disclosure | link only | Initial BD-JB report (TheFloW), June 2022 | <https://hackerone.com/reports/1379975> |
| **S04** | HackerOne #3104356 | Disclosure | link only | Two Ixc vulnerabilities (BD-JB3), April 2025 | <https://hackerone.com/reports/3104356> |
| **S05** | HackerOne #3320669 | Disclosure | link only | `sys_netcontrol` double fdrop (slidybat), August 2025 | <https://hackerone.com/reports/3320669> |
| **S06** | HackerOne #3452696 | Disclosure | link only | `CVE-2025-64390` / BD-JB-13.00 (Gezine) | <https://hackerone.com/reports/3452696> |
| **S07** | NVD — CVE-2025-64390 | CVE reference | link only | Official CVE record | <https://nvd.nist.gov/vuln/detail/CVE-2025-64390> |
| **S08** | TheFloW — Poopsploit gist | Source | `gists/poopsploit` | `ExploitNetControlImpl.java`, November 2025 | <https://gist.github.com/TheOfficialFloW/7174351201b5260d7780780f4059bebf> |
| **S09** | CTurt/FreeDVDBoot | Historical context | `repos/CTurt-FreeDVDBoot` | Early BD-J hacking idea for PS2/PS3/PS4 | <https://github.com/CTurt/FreeDVDBoot> |

---

## 2. Wikis and technical references

| ID | Source | Type | Local copy | Notes | Link |
|---|---|---|---|---|---|
| **S10** | PSDevWiki — Vulnerabilities | Wiki | `web/psdevwiki-vulnerabilities.html` + `web/psdevwiki-vulnerabilities.md` | Most detailed reference: BD-JB1 through BD-JB-EX, Lapse, Poopsploit, Celsius | <https://www.psdevwiki.com/ps4/Vulnerabilities> |
| **S11** | ConsoleMods — PS4:Exploit_Chart | Wiki | `web/consolemods-exploit-chart.html` | Compatibility matrix (last edited 2026-10-17) | <https://consolemods.org/wiki/PS4:Exploit_Chart> · [archive](https://web.archive.org/web/20261020125155/https://consolemods.org/wiki/PS4:Exploit_Chart) |
| **S12** | ConsoleMods — PS4:BD-JB | Wiki | `web/consolemods-bd-jb.html` | Henloader/Lapse guide, HDCP/BD-LIVE, errors | <https://consolemods.org/wiki/PS4:BD-JB> · [archive](https://web.archive.org/web/20260724075552/https://consolemods.org/wiki/PS4:BD-JB) |
| **S13** | HENloader Guide | Release/guide | `web/henloader-guide.html` | Simplified HENloader guide | <https://iaceene.github.io/HENloader/> |

---

## 3. BD-JB releases and tools

| ID | Source | Type | Local copy | Notes | Link |
|---|---|---|---|---|---|
| **S14** | GoldHEN/henloader_lp | Release | `repos/GoldHEN-henloader_lp` | AIO: Lapse + Poops + GoldHEN 2.4b18.7; 9.00–12.52 | <https://github.com/GoldHEN/henloader_lp> |
| **S15** | HENloader LP 1.0 | Release | `repos/GoldHEN-henloader_lp` | Release page/tag | <https://github.com/GoldHEN/henloader_lp/releases/tag/1.0> |
| **S16** | iaceene/HENloader_Source | Source | `repos/iaceene-HENloader_Source` | `Lapse.java`, `Poops.java`, `KernelOffset.java` | <https://github.com/iaceene/HENloader_Source> |
| **S17** | ps3120/BD-JB-1250 | Release | `repos/ps3120-BD-JB-1250` | Active fork of `Gezine/BD-JB-1250`; BD-JB3.2, AIO | <https://github.com/ps3120/BD-JB-1250> |
| **S18** | ps3120 — `Lapse_1.2_Mod` | Release tag | `repos/ps3120-BD-JB-1250` | ISO for 13.00/13.02 (research) | <https://github.com/ps3120/BD-JB-1250/releases/tag/Lapse_1.2_Mod> |
| **S19** | DefKorns/BD-JB-1252 | Release | `repos/DefKorns-BD-JB-1252` | `Poops.iso` for 12.50–12.52 | <https://github.com/DefKorns/BD-JB-1252> |
| **S20** | ayasns/BD-JB-1250 | Mirror/fork | `repos/ayasns-BD-JB-1250` | Another BD-JB-1250 mirror | <https://github.com/ayasns/BD-JB-1250> |
| **S21** | ps3120/ps3120.github.io | Release | `repos/ps3120-ps3120.github.io` | Contains `bdj1304.iso` (BD-JB-13.04) | <https://github.com/ps3120/ps3120.github.io> |
| **S22** | `bdj1304.iso` | Release file | `repos/ps3120-ps3120.github.io/bdj1304.iso` | BD-JB-13.04 ISO (16 MB) | <https://github.com/ps3120/ps3120.github.io/blob/main/bdj1304.iso> |
| **S23** | kimariin/BlueLoader | Release | `repos/kimariin-BlueLoader` | Alternative JAR loader (obsolete); ports/fsdump | <https://github.com/kimariin/BlueLoader> |
| **S24** | john-tornblom/bdj-sdk | Tool | `repos/john-tornblom-bdj-sdk` | Build BD-J ISOs on Linux | <https://github.com/john-tornblom/bdj-sdk> |
| **S25** | ps4-payload-dev/sdk | Tool | `repos/ps4-payload-dev-sdk` | PS4 payload SDK | <https://github.com/ps4-payload-dev/sdk> |
| **S26** | ps3120/henloader_lp | Release | `repos/ps3120-henloader_lp` | HENloader fork/update | <https://github.com/ps3120/henloader_lp> |

---

## 4. Payloads

| ID | Source | Type | Local copy | Notes | Link |
|---|---|---|---|---|---|
| **S27** | GoldHEN/GoldHEN | Payload source | `repos/GoldHEN-GoldHEN` | Official GoldHEN; features/ports | <https://github.com/GoldHEN/GoldHEN> |
| **S28** | GoldHEN 2.4b18 | Release | `repos/GoldHEN-GoldHEN` | Official GitHub release (October 2024) | <https://github.com/GoldHEN/GoldHEN/releases/tag/2.4b18> |
| **S29** | Scene-Collective/ps4-hen | Payload source | `repos/Scene-Collective-ps4-hen` | Alternative HEN; README says 5.05–12.02 | <https://github.com/Scene-Collective/ps4-hen> |
| **S30** | Reddit — GoldHEN 2.4b18.12 | Community | link only | Reports 13.02/13.04/13.50 support; secondary | <https://www.reddit.com/r/ps4homebrew/comments/1wmhxjd/goldhen_v24b1812_13xx_support/> |
| **S31** | YouTube — GoldHEN 2.4b18.12 | Community video | link only | Secondary report of 13.02–13.52 support | <https://www.youtube.com/watch?v=8f6_EV8y0ak> |

---

## 5. Kernel exploits and alternative chains

| ID | Source | Type | Local copy | Notes | Link |
|---|---|---|---|---|---|
| **S32** | iMrDJAi/laps3c0re | Release | `repos/iMrDJAi-laps3c0re` | Lapse + mast1c0re (PS4 5.00–12.02) | <https://github.com/iMrDJAi/laps3c0re> |
| **S33** | Al-Azif/psfree-lapse | Release | `repos/Al-Azif-psfree-lapse` | PSFree + Lapse (PS4 7.00–9.60) | <https://github.com/Al-Azif/psfree-lapse> |
| **S34** | kmeps4/PSFree | Release | `repos/kmeps4-PSFree` | PSFree + Lapse for 9.00 | <https://github.com/kmeps4/PSFree> |
| **S35** | shahrilnet/remote_lua_loader | Release | `repos/shahrilnet-remote_lua_loader` | Lua Loader + Lapse | <https://github.com/shahrilnet/remote_lua_loader> |
| **S36** | adri22235/ps4-suid-scanner | Research | `repos/adri22235-ps4-suid-scanner` | 13.04 research; Celsius/offset claims (unverified) | <https://github.com/adri22235/ps4-suid-scanner> |

---

## 6. Community, news, and discussions (secondary)

| ID | Source | Type | Notes | Link |
|---|---|---|---|---|
| **S37** | Reddit — BD-J+Lapse 9.00–12.02 | Community | Gezine release discussion (August 2025) | <https://www.reddit.com/r/ps4homebrew/comments/1mox09r/bdjlapse_jailbreak_release_9001202/> |
| **S38** | Reddit — BD-JB up to 13.02 | Community | 13.02 userland release discussion (December 2025) | <https://www.reddit.com/r/ps4homebrew/comments/1pepyqj/a_new_ps4_bdjb_that_works_up_to_1302_by_gezine/> |
| **S39** | Reddit — 13.50 warning | Community | 13.50 security update warning (2026) | <https://www.reddit.com/r/ps4homebrew/comments/1rwjnxw/warning_do_not_update_to_1350_userland_exploit/> |
| **S40** | PSX-Place — BD-JB-1250 | Community | Release news (August 2025) | <https://www.psx-place.com/threads/bd-jb-1250-new-exploit-bluray-for-playstation-4-supporting-upto-12-50-firmware-from-gezine.48161/> |
| **S41** | YouTube — BD-JB talk | Community video | TheFloW at hardwear.io 2022 | <https://www.youtube.com/watch?v=jyyCOoWksbg> |
| **S42** | X — TheFloW | Community | BD-JB affects PS3/PS4/PS5 (2022) | <https://x.com/theflow0/status/1535361317535506432> |
| **S43** | X — Gezine | Community | `CVE-2025-64390` report (2025) | <https://x.com/gezine_dev/status/1996799464552755543> |
| **S44** | X — zecoxao | Community | 13.04/13.02 firmware diff (2026) | <https://x.com/notnotzecoxao/status/2016436488800448685> |
| **S45** | Gezine/BD-JB5 | PS5-only | BD-JB for PS5; `bdj_unpatch` (13.60+) | <https://github.com/Gezine/BD-JB5> |

---

## 7. Burning software

| ID | Source | Type | Notes | Link |
|---|---|---|---|---|
| **S46** | ImgBurn | Software | Windows Blu-ray burning | <https://www.imgburn.com> |
| **S47** | K3b | Software | Linux Blu-ray burning | <https://apps.kde.org/k3b> |
| **S48** | BD-SimpleBurn | Software | macOS Blu-ray burning | <https://github.com/C4ndyF1sh/BD-SimpleBurn> |

---

## 8. PS4 14.00 research sources

| ID | Source | Type | Local copy | Notes | Link |
|---|---|---|---|---|---|
| **S49** | Sony — PS4 system software support | Official | `web/sony-ps4-system-software.html` | Official PUP/update page; 14.00 PUP path dated 2026_0831 | <https://www.playstation.com/en-us/support/hardware/ps4/system-software/> |
| **S50** | Sony — PS4 WebKit OSS source page | Official | `web/sony-ps4-webkit-oss.html` | Last PS4 WebKit drop is **13.00-**; no 13.50/13.52/14.00 archive | <https://www.playstation.com/en-us/oss/ps4/webkit/> |
| **S51** | MP1ST — PS4 Update 14.00 released | Community | link only (snapshot blocked by Cloudflare) | Release date 2026-09-16; secondary | <https://mp1st.com/news/ps4-update-14-00-released-on-september-16-brings-what-you-expect> |
| **S52** | iHaiDeeZ/PupDecrypt-PS4 | Release | `repos/iHaiDeeZ-PupDecrypt-PS4` | 14.00 PUP decrypt on 13.52 GoldHEN; ~17.5 min test | <https://github.com/iHaiDeeZ/PupDecrypt-PS4> |
| **S53** | Scene-Collective/ps4-pup-decrypt | Release | `repos/Scene-Collective-ps4-pup-decrypt` | Upstream PUP decrypt payload | <https://github.com/Scene-Collective/ps4-pup-decrypt> |
| **S54** | idc/ps4-pup_decrypt | Release | `repos/idc-ps4-pup_decrypt` | Original PUP decrypt utility | <https://github.com/idc/ps4-pup_decrypt> |
| **S55** | idc/ps4-pup_unpack | Release | `repos/idc-ps4-pup_unpack` | Unpack decrypted PUP parts | <https://github.com/idc/ps4-pup_unpack> |
| **S56** | andy-man/ps4-pup-decrypt | Release | `repos/andy-man-ps4-pup-decrypt` | Fork used by PupDecrypt-PS4 | <https://github.com/andy-man/ps4-pup-decrypt> |
| **S57** | ps3120/ps4-exploit-kpatches | Release | `repos/ps3120-ps4-exploit-kpatches` | Kernel patch shellcode including 14.00; post-exploitation, not a KEX | <https://github.com/ps3120/ps4-exploit-kpatches> |
| **S58** | Mikadolebg/ps4-1400-research | Research | `repos/Mikadolebg-ps4-1400-research` | 14.00 SSV userland, R/W/ROP/syscalls, measured gates, open leads | <https://github.com/Mikadolebg/ps4-1400-research> |
| **S59** | siongadev/PS4-14.00-Jailbreak-Research | Research | `repos/siongadev-PS4-14.00-Jailbreak-Research` | 14.00 browser R/W/native execution; no sandbox/kernel; evidence archive | <https://github.com/siongadev/PS4-14.00-Jailbreak-Research> |
| **S60** | adri22235/ps4-14-00-security-notes | Research | `repos/adri22235-ps4-14-00-security-notes` | WebKit gadget/offset dossier, kernel offsets, CVE catalogue; verify claims | <https://github.com/adri22235/ps4-14-00-security-notes> |
| **S61** | ntfargo/CSSFontFace-Exploit | Release/reference | `repos/ntfargo-CSSFontFace-Exploit` | CSSFontFace UAF; PS4 6.00-11.02 exploitable; **not** 14.00 | <https://github.com/ntfargo/CSSFontFace-Exploit> |
| **S62** | OptiTronOffical/1350-webkit-test | Community/reference | `repos/OptiTronOffical-1350-webkit-test` | 13.50/13.52 WebKit R/W harness; kernel stage disabled | <https://github.com/OptiTronOffical/1350-webkit-test> |
| **S63** | NVD — CVE-2026-49415 | Primary | `data/cves-ps4-1400.json` | FreeBSD execve SUID TOCTOU; CVSS 8.8; PS4 applicability unproven | <https://nvd.nist.gov/vuln/detail/CVE-2026-49415> |
| **S64** | NVD — CVE-2026-101308 | Primary | `data/cves-ps4-1400.json` | FreeBSD sound(4) UAF; CVSS 5.5; PS4 applicability unproven | <https://nvd.nist.gov/vuln/detail/CVE-2026-101308> |
| **S65** | NVD — CVE-2026-58087 | Primary | `data/cves-ps4-1400.json` | FreeBSD semctl OOB; CVSS 7.8; PS4 applicability unproven | <https://nvd.nist.gov/vuln/detail/CVE-2026-58087> |
| **S66** | NVD — CVE-2026-7270 | Primary | `data/cves-ps4-1400.json` | FreeBSD execve slab overflow; disputed/discarded for PS4 | <https://nvd.nist.gov/vuln/detail/CVE-2026-7270> |
| **S67** | TechPowerUp — PS5 14.10 private jailbreak | Community | link only | Clarifies that 14.10 (26.06-14.10.00) is PS5, not PS4 | <https://www.techpowerup.com/353929/ps5-firmware-14-10-reportedly-jailbroken-in-private-hypervisor-still-holding-up> |
| **S68** | PSDevWiki — WebKit Bugs | Wiki | link only | WebKit bug ranges/context; community-maintained | <https://www.psdevwiki.com/ps4/WebKit_Bugs> |
| **S69** | Scene-Collective/ps4-payload-sdk | Release | `repos/Scene-Collective-ps4-payload-sdk` | Payload SDK used by the PUP decrypt workflow | <https://github.com/Scene-Collective/ps4-payload-sdk> |
| **S70** | ps3120/FontFace-Lapse | Release/reference | `repos/ps3120-FontFace-Lapse` | Legacy WebKit + Lapse chain reference; not a 14.00 entry | <https://github.com/ps3120/FontFace-Lapse> |
| **S71** | YouTube — PS4/PS5 Jailbreak News: 14.00 JB teaser | Community | link only | Community teaser report; not reproducible | <https://www.youtube.com/watch?v=i0O2o2ZhnTg> |
| **S72** | Reddit — PS4 14.00 private jailbreak discussion | Community | link only | Community claim of a private 14.00 jailbreak; no public release | <https://www.reddit.com/r/PS4Mods/comments/1wyehee/ps4_1400/> |
| **S73** | FreeBSD Security Advisory SA-26:71.sound | Primary | link only | sound(4) `sndbuf_resize`/mmap UAF advisory; context for CVE-2026-101308 | <https://www.freebsd.org/security/advisories/FreeBSD-SA-26:71.sound.asc> |

> The 14.00 research repositories (S58–S60) are community work, not audited by this project. They are valuable because they publish methodology, evidence, and negative results. Cross-check every offset, gate, and CVE claim against your own firmware dump.

---

## 9. Trust notes

- **Primary/official (S01–S09, S27–S29):** source code, disclosures, CVEs. Highest confidence.
- **Wikis (S10–S12):** detailed and technical, but community-maintained; may lag by days/weeks.
- **Releases (S14–S26):** for downloads/use; always read release notes and verify hashes.
- **Community/secondary (S30–S31, S36–S45, S51, S67, S71–S72):** useful for leads/dates, but can be incomplete or wrong; teaser/private claims are not reproducible evidence.
- **Research (S36, S58–S60):** independently verify the claims and reproduce the evidence; low-star repositories can still contain useful methodology, but they are not audited here.
- **14.00 candidate CVEs (S63–S66):** NVD records describe FreeBSD issues; PS4 applicability requires source/binary verification.

---

## 10. Keeping sources up to date

- Follow PSDevWiki for technical details.
- Check the ConsoleMods Exploit Chart for compatibility.
- Watch the releases pages of HENloader/BD-JB repositories.
- Follow community channels (r/ps4homebrew, PSX-Place) for 13.x changes.
- **Never** rely on a single YouTube video or Telegram post for downloads.

---

## 11. Structured data

- Machine-readable source metadata: [`data/sources.json`](../../data/sources.json)
- 14.00 research status/leads: [`data/ps4-1400-research.json`](../../data/ps4-1400-research.json)
- Candidate CVE records: [`data/cves-ps4-1400.json`](../../data/cves-ps4-1400.json)
- Source archive inventory: [`sources/README.md`](../../sources/README.md)
