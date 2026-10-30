# 00 — Executive Summary

> One page for readers who need to know quickly: what the PS4 Blu-ray jailbreak is, where it stands now, and where to start.

---

## 1. In 30 seconds

- **BD-JB** is an exploit against **Blu-ray Disc Java**, triggered by a burned BD-R/BD-RE disc, that escapes the Java sandbox in the PS4 Blu-ray player.
- BD-JB **is not a full jailbreak by itself**; it must be combined with a **kernel exploit** (Lapse or Poopsploit).
- **Best practical range: 9.00–12.52.** All-in-one tools such as **HENloader LP** cover this range.
- **12.50–12.52:** Lapse is patched; use **Poopsploit**.
- **13.00–13.04:** research builds exist (BD-JB-13.00 / BD-JB-13.04), but this is not the standard path.
- **13.50–13.52:** disc-based BD-JB is blocked; the public route is WebKit plus GoldHEN 2.4b18.12.
- **14.00:** no public jailbreak; community browser userland research exists, but sandbox escape and kernel primitive are not public. A private/teaser full jailbreak is reported but not available. **14.10 is PS5, not PS4.**

---

## 2. Decision matrix

| If your firmware is… | Best option | Risk | Recommendation |
|---|---|---|---|
| 9.00–12.02 | HENloader / Lapse.iso | Low | Usable now; do not update |
| 12.50–12.52 | HENloader / Poops.iso | Low | Do not try Lapse (patched) |
| 13.00 | Research ISO for 13.00/13.02 + Poops | Medium/high | Advanced users only |
| 13.02–13.04 | BD-JB-13.00/13.04 + reported kernel | High | Read the exact-version sources |
| 13.50–13.52 | WebKit + GoldHEN 2.4b18.12 | Medium | Not disc-based BD-JB |
| 14.00 | Research only: browser userland reported; no public KEX | High | Preserve the console; use a 13.52 tooling console for PUP analysis |
| 14.10 | Not a PS4 firmware | — | PS5-only; do not confuse |

---

## 3. Why BD-JB?

**Advantages:** offline, reliable, no browser, larger kernel attack surface (`libkernel_sys`), and ROP-less code execution (JIT is enabled on PS4).

**Disadvantages:** requires a Blu-ray burner/disc, limited process memory, dependency on a separate kernel exploit, and Sony patches.

---

## 4. Key people

| Name | Contribution |
|---|---|
| **TheFloW (Andy Nguyen)** | Discovered BD-JB1 and BD-JB2; implemented Poopsploit |
| **sleirsgoevy** | First public PS4 implementation |
| **Gezine** | BD-JB-1250, BD-JB-13.00/CVE-2025-64390, BD-JB5 |
| **ps3120** | Implemented BD-JB3.2/13.04 and published ISOs |
| **abc** | Lapse kernel exploit |
| **slidybat** | Discovered the `sys_netcontrol` bug |
| **John Törnblom** | BDJ-SDK and ps4-payload-sdk |
| **SiSTRo / GoldHEN** | GoldHEN payload |
| **15432 / CelesteBlue** | BD-JB-EX |
| **kimariin** | BlueLoader (developer tool) |

---

## 5. Recommended path for a typical user

1. Verify the exact firmware.
2. If it is 9.00–12.52, obtain **HENloader LP 1.0** from the official GitHub release.
3. Prepare a USB drive with `payload.bin` (GoldHEN).
4. Burn the ISO to BD-R/BD-RE at a low speed.
5. Enable HDCP, disable auto-updates, and accept BD-LIVE.
6. Insert the USB first, then the disc, and open the Blu-ray Player.
7. Choose Lapse (Cross) or Poops (Circle), depending on firmware.
8. After success, block firmware updates.

Full route: [step-by-step guide](07-step-by-step-guide.md).

---

## 6. Three common mistakes

1. **Thinking the disc alone is enough.** Without a kernel exploit, GoldHEN will not load.
2. **Using Lapse on 12.50/12.52.** Lapse was patched at 12.50; Poops is required.
3. **Updating firmware "for security".** This usually destroys the exploit.

---

## 7. Continue reading

- [Fundamentals](01-fundamentals.md)
- [History](02-history-and-timeline.md)
- [Technical deep dive](03-technical-deep-dive.md)
- [Kernel exploits](04-kernel-exploits.md)
- [Firmware compatibility](05-firmware-compatibility.md)
- [Hardware and software](06-hardware-and-software.md)
- [Step-by-step guide](07-step-by-step-guide.md)
- [Tools and repositories](08-tools-and-repositories.md)
- [Payloads and GoldHEN](09-payloads-and-goldhen.md)
- [Troubleshooting](10-troubleshooting.md)
- [Risks and legal notes](11-risks-and-legal.md)
- [Sources](12-sources.md)
- [Glossary](13-glossary.md)
- [FAQ](14-faq.md)
- [PS4 14.00 status](15-ps4-1400-status.md)
- [PS4 14.00 attack surface](16-ps4-1400-attack-surface.md)
- [PS4 14.00 roadmap and lab](17-research-roadmap-and-lab.md)
- [Skills and experience](18-skills-and-experience.md)
