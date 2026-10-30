# 09 — Payloads and GoldHEN

> After the kernel exploit, the next stage is the **payload**: the program that enables homebrew, FTP, PKG installation, debugging, and plugins. This document covers GoldHEN, HEN, and selection/usage notes.

---

## 1. What is HEN?

**HEN (Homebrew Enabler)** is a payload executed after the kernel exploit that:

- removes restrictions on running homebrew;
- enables PKG installation;
- adds FTP/BinLoader/Debug Settings in some versions.

HEN is not a kernel exploit by itself; it must be loaded after Lapse/Poopsploit.

---

## 2. GoldHEN

### 2.1 Facts

| Attribute | Value |
|---|---|
| Author | SiSTRo and the GoldHEN team |
| Type | HEN + companion tools |
| Latest official GitHub release | `2.4b18` (October 2024) |
| Versions shipped with BD-JB bundles | `2.4b18.7` (HENloader), `2.4b18.12` (reported for 13.x) |
| Official link | <https://github.com/GoldHEN/GoldHEN> |

### 2.2 Features (from the official README)

- Homebrew Enabler
- Debug Settings
- VR support
- Remote Package Install
- Rest Mode support
- External HDD support and official external HDD format
- Debug trophies
- `sys_dynlib_dlsym` patch
- UART Enabler
- Never Disable Screenshot
- Remote Play Enabler
- **FW Update Block**
- FTP Server on port **2121**
- BinLoader Server on port **9090**
- Klog Server on port **3232**
- `CE-30391-6` error (CMOS) fix
- Cheat Menu and FPS Counter
- Plugin support

> Ports 9020/9021/9025 belong to BD-JB/loaders, not to GoldHEN's BinLoader. Do not confuse them.

### 2.3 Choosing a version

- Firmware 9.00–12.52: use the version shipped with HENloader (`2.4b18.7`) or a compatible official build.
- Firmware 13.02–13.52 (WebKit route): reports mention `2.4b18.12`.
- Always use the version recommended by the tool author; a mismatch can crash the console.

> GoldHEN 2.4b18.12 is not on the official GitHub release page and is distributed through community/supporter channels. Verify the source carefully.

---

## 3. PS4 HEN (alternative)

| Attribute | Value |
|---|---|
| Author | Scene-Collective |
| Firmware support (README) | **5.05 – 12.02** |
| Link | <https://github.com/Scene-Collective/ps4-hen> |
| Latest pre-release | `pre-release-main-182` (September 2026) |

PS4 HEN is lighter than GoldHEN and suits users who only need a basic HEN. For 12.50/12.52, check compatibility in the release notes.

---

## 4. How to load a payload

### 4.1 From USB (common)

1. Rename the payload to `payload.bin` and place it at the USB root.
2. Connect the USB before the disc.
3. The ISO/loader reads and executes the payload.
4. In some builds, the payload is copied to `/data/payload.bin` and the USB is not needed next time.

### 4.2 From the network (advanced)

- **BinLoader (Lapse/Poops):** port 9020.
- **RemoteJarLoader:** port 9025; send a custom JAR with netcat or a script.
- **GoldHEN BinLoader:** port 9090 (after GoldHEN starts).
- **Klog:** port 3232.
- **FTP:** port 2121.

Example of sending a JAR with netcat:

```bash
cat payload.jar | nc 192.168.1.50 9025
```

> Only on a trusted local network. Do not expose these ports to the internet.

---

## 5. What can I do after loading GoldHEN?

### 5.1 Normal/legal uses

- Run legal homebrew (emulators, media players, backup tools).
- Install PKG files you legally own (personal backups).
- Back up/restore saves.
- Use FTP for file transfer.
- Debug trophies/screenshots.

### 5.2 Out of scope

- Installing/distributing pirated games.
- DRM circumvention for sale or sharing.
- Online cheating or modifying online games.
- Selling a jailbroken console with illegal content.

---

## 6. Stability notes

1. **Do not install all plugins at once.** An incompatible plugin can cause crashes/black screens.
2. **Do not repeatedly apply the AIO fix.** It is included in HENloader/Lapse 1.2.
3. **Re-run the exploit after every restart.** The jailbreak is not persistent (it lives in memory).
4. **Do not power off while something is installing/writing.** Rest Mode is supported by some builds, but a full shutdown is safer.
5. **Block firmware updates.** GoldHEN has an FW Update Block; also consider DNS/firewall rules.

---

## 7. Payload FAQ

**The payload loaded but it is not GoldHEN.**
It may be a simple HEN or an incompatible build. Obtain the correct payload from the official release.

**The console crashes after loading.**
The payload does not match the firmware/tool, or an incompatible plugin/AIO fix is installed. Try the version bundled with HENloader.

**Do I need the USB every time?**
Not necessarily; many builds cache the payload in `/data/payload.bin`. Read the tool README to be sure.

**Can I go online on PSN?**
Technically possible, but there is a ban risk. Online use with your main account is not recommended on a jailbroken console.

---

## 8. Sources

- GoldHEN (README, features, ports): <https://github.com/GoldHEN/GoldHEN>
- GoldHEN 2.4b18 release: <https://github.com/GoldHEN/GoldHEN/releases/tag/2.4b18>
- PS4 HEN: <https://github.com/Scene-Collective/ps4-hen>
- HENloader LP: <https://github.com/GoldHEN/henloader_lp>
- GoldHEN 2.4b18.12 report for 13.x: <https://www.reddit.com/r/ps4homebrew/comments/1wmhxjd/goldhen_v24b1812_13xx_support/>
