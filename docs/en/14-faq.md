# 14 — Frequently Asked Questions

> Short answers based on the sources in this project. See the linked document for details.

---

## 1. What is BD-JB, and how is it different from a "full jailbreak"?

BD-JB is an exploit against **Blu-ray Disc Java** that escapes the Java sandbox in the PS4 Blu-ray player and enables native userland code execution. A full jailbreak also requires a **kernel exploit** (Lapse/Poopsploit) and a payload (GoldHEN/HEN).

---

## 2. Which firmware is suitable for BD-JB?

- **Standard/practical:** 9.00–12.52
- **Most stable:** 9.00 and 12.02 (Lapse)
- **12.50–12.52:** Lapse is patched; use Poopsploit.
- **13.00–13.04:** research builds; not the standard route.
- **13.50+:** disc BD-JB is blocked; WebKit route.
- **14.00+:** no public chain.

Full table: [firmware compatibility](05-firmware-compatibility.md).

---

## 3. Can I do this without a Blu-ray writer?

For disc-based BD-JB, no. Options:

- use/buy a Blu-ray writer (BD-R/BD-RE);
- buy a pre-burned disc from a trusted seller (content risk);
- use another entry point (WebKit/PPPwn/Lua), which is outside this project.

There is no public "BD-JB without a disc" method for PS4 (except research-grade BD-JB-EX, which requires a previously injected JAR).

---

## 4. Do I need an internet connection?

- For BD-JB execution, usually no.
- If Blu-ray playback has never been activated, you may need the internet once (with auto-updates disabled).
- After activation, you can stay offline.
- BD-LIVE may prompt for a connection; follow the guide and answer `Yes`.

---

## 5. Does BD-RE work?

Yes. BD-RE is suitable for testing/reuse. Disable **permanent write** in the burning software. BD-R also works.

---

## 6. Does BDXL work?

No. PS4 BD-JB does not support BDXL. Use regular BD-R/BD-RE.

---

## 7. GoldHEN or HEN?

- **GoldHEN:** more features (FTP, BinLoader, Debug, plugins, FW Update Block).
- **HEN:** lighter and simpler.
- More important than the choice is **firmware compatibility**. Use the version recommended by the tool author.

---

## 8. Can I install copied games?

This project covers only **homebrew and legal personal backups**. Installing/distributing pirated games is illegal in many jurisdictions and is outside this project.

---

## 9. Will I get banned from PSN?

There is a risk. Online use with your main account is not recommended on a jailbroken console. Sony may restrict the console/account.

---

## 10. Can I downgrade the firmware?

There is no public/simple general PS4 firmware downgrade. The best approach is **not to update**. If your firmware is too new, wait or follow the WebKit/kernel status.

---

## 11. Does this work on PS5?

No. PS5 BD-JB5 has a separate route (`Gezine/BD-JB5`, `bdj_unpatch`). This project is PS4-specific. Do not use PS5 files on PS4 or vice versa.

---

## 12. Why is the ISO only about 16 MB?

Because it contains the Java/BD-J application and BDMV files, not game data. That is enough for the exploit. Disc capacity is not the issue; disc type is.

---

## 13. Why do I have to re-run the exploit after every restart?

The PS4 jailbreak is not a permanent custom firmware; the exploit lives in memory and is lost on shutdown/restart. Re-run the disc/method each time.

---

## 14. Is HENloader safe?

HENloader is a **community all-in-one package**, not an official GoldHEN release. Using the official GitHub release and verifying the hash reduces risk. Do not use unknown Telegram/Discord files.

---

## 15. I am on 13.50/13.52. What should I do?

Disc BD-JB is blocked on these versions. Community reports describe a WebKit route plus GoldHEN 2.4b18.12. BD-JB-EX only makes sense if you previously injected the JAR into `system_ex`. Check up-to-date sources and do not update.

---

## 16. I am on 14.00. What should I do?

As of October 2026 there is **no public full 14.00 jailbreak**. Community researchers report a working browser userland chain, but no public sandbox escape or kernel primitive. A private/teaser full jailbreak is discussed but not available or reproducible.

Practical steps:

1. Do not update; keep the console offline.
2. Do not buy private/teaser exploits.
3. If you want to research, use a **13.52 GoldHEN console** to decrypt the official 14.00 PUP for static analysis.
4. Read [15 — 14.00 status](15-ps4-1400-status.md), [16 — attack surface](16-ps4-1400-attack-surface.md), and [17 — roadmap/lab](17-research-roadmap-and-lab.md).

> **14.10 is a PS5 firmware**, not a PS4 firmware. Do not confuse it with PS4 14.00.

---

## 17. What is the difference between Lapse and Poopsploit?

| Attribute | Lapse | Poopsploit |
|---|---|---|
| Bug type | AIO double free | `sys_netcontrol` double fdrop |
| PS4 firmware | 5.00–12.02 | Up to 13.00 |
| Patch | 12.50 | 13.02 |
| Main use | 9.00–12.02 | 12.50–12.52 |

---

## 18. What is the AIO fix, and why is it needed?

The AIO fix addresses **black-screen** and **save-corruption** issues in Lapse. It is included in `Lapse.iso` 1.2+ and HENloader. Older builds require sending `aiofix_network.elf` separately. Do not apply multiple fixes at once.

---

## 19. Can one disc work on multiple consoles?

The disc runs the BD-J exploit; each console needs a compatible firmware and kernel. Multi-console use is usually possible, but it depends on each console's firmware and kernel status.

---

## 20. Is jailbreaking legal?

It depends on the country/region and circumstances. Even where legal, it may violate **Sony's ToS** and **void the warranty**. This project is not legal advice; read [risks and legal notes](11-risks-and-legal.md).

---

## 21. What should I buy?

- A PS4 on compatible firmware (check this first);
- a Blu-ray writer supporting BD-R/BD-RE (not BDXL);
- a BD-RE for testing and a BD-R for archiving;
- a USB flash drive for `payload.bin`;
- burning software (ImgBurn/PowerISO/K3b/BD-SimpleBurn).

Details: [hardware and software](06-hardware-and-software.md).

---

## 22. Does this project contain exploit files?

No. This project is **documentation** and links to official/public sources. It does not distribute ISO, payload, or copyrighted firmware files. Public source repositories are cloned under `sources/repos/` for reference.

---

## 23. Is there a private 14.00 jailbreak, and should I buy it?

The community has discussed a private/teaser full 14.00 jailbreak, but there is **no public, reproducible release**. Do not buy or trust "private jailbreak" offers: they may be fake, stolen, non-transferable, or unsafe. Build from public evidence and your own dumps instead.

---

## 24. How can I start 14.00 research without a 14.00 exploit?

Use a **13.52 jailbroken console** to decrypt/unpack the official 14.00 PUP, analyze the kernel and WebKit statically, and use a separate 14.00 console for browser userland research. The missing link is a public kernel primitive. See [17 — roadmap/lab](17-research-roadmap-and-lab.md).
