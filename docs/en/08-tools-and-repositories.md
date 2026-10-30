# 08 — Tools and Repositories

> This list is based on public sources up to October 2026. Check the status before use; some repositories are private/removed or are PS5-only.

---

## 1. Core BD-JB sources and documentation

| Repository | Author | Purpose | Firmware | Status | Link |
|---|---|---|---|---|---|
| `TheOfficialFloW/bd-jb` | TheFloW | Reference BD-JB source; `Exploit.java`, `Payload.java`, JAR loader | PS3/PS4/PS5 | Active, MIT | <https://github.com/TheOfficialFloW/bd-jb> |
| `TheOfficialFloW/Presentations` | TheFloW | hardwear.io 2022 slides (PDF) | — | Archived | <https://github.com/TheOfficialFloW/Presentations/blob/master/2022-hardwear-io-bd-jb.pdf> |
| HackerOne 1379975 | TheFloW | BD-JB1 report | PS3/PS4/PS5 | Disclosed | <https://hackerone.com/reports/1379975> |
| HackerOne 3104356 | TheFloW | Ixc report (BD-JB3) | PS4 | Disclosed | <https://hackerone.com/reports/3104356> |
| HackerOne 3320669 | slidybat | `sys_netcontrol` double-fdrop report | PS4/PS5 | Disclosed | <https://hackerone.com/reports/3320669> |
| HackerOne 3452696 | Gezine | `CVE-2025-64390` (BD-JB-13.00) | PS4 | Disclosed | <https://hackerone.com/reports/3452696> |

---

## 2. Practical/release BD-JB builds

| Repository/file | Purpose | Firmware | Status | Link |
|---|---|---|---|---|
| `Gezine/BD-JB-1250` | Original BD-JB + Lapse; `Lapse.iso`, `RemoteJarLoader.iso` | 9.00–12.02 | Original repository not directly available; use forks | (`Gezine/BD-JB-1250`) |
| `ps3120/BD-JB-1250` | Active fork; `Lapse_1.2_Mod` tag for 13.00/13.02; BD-JB3.2 | 9.00–13.02 | Active; 13.x research | <https://github.com/ps3120/BD-JB-1250> |
| `ayasns/BD-JB-1250` | Another fork/mirror | 9.00–12.50 | Active | <https://github.com/ayasns/BD-JB-1250> |
| `DefKorns/BD-JB-1252` | `Poops.iso` for 12.50–12.52 | 12.50–12.52 | Active; MIT | <https://github.com/DefKorns/BD-JB-1252> |
| `GoldHEN/henloader_lp` | AIO: Lapse + Poops + GoldHEN 2.4b18.7 | 9.00–12.52 | Release 1.0 | <https://github.com/GoldHEN/henloader_lp> |
| `ps3120/henloader_lp` | Fork/update of HENloader | 9.00–12.52 | Active | <https://github.com/ps3120/henloader_lp> |
| `iaceene/HENloader_Source` | HENloader source; `Lapse.java`, `Poops.java`, `KernelOffset.java` | 9.00–12.52 | Active; educational source | <https://github.com/iaceene/HENloader_Source> |
| `ps3120/ps3120.github.io` | `bdj1304.iso` (BD-JB-13.04) | 13.04 | Active; research | <https://github.com/ps3120/ps3120.github.io> |
| `kimariin/BlueLoader` | Alternative JAR loader; ports 9020/9025/9030 | 9.00–12.02 | **Obsolete**; developer-oriented | <https://github.com/kimariin/BlueLoader> |

### ISO notes

- BD-JB ISOs are usually small (around 16 MB) and must be burned to **BD-R/BD-RE**.
- Some builds include a payload; others read `payload.bin` from USB.
- Read the release README first: some builds target a specific firmware.

---

## 3. BD-J build/development tools

| Tool | Purpose | Link |
|---|---|---|
| `john-tornblom/bdj-sdk` | Build BD-J ISOs on Linux; `makefs`, JDK 8/11, HelloWorld sample | <https://github.com/john-tornblom/bdj-sdk> |
| `ps4-payload-dev/sdk` | PS4 payload SDK | <https://github.com/ps4-payload-dev/sdk> |
| `ps5-payload-dev/sdk` | PS5 payload SDK (for PS5/comparison) | <https://github.com/ps5-payload-dev/sdk> |
| `hammer-83/ps5-jar-loader` | PS5 JAR loader reference | <https://github.com/hammer-83/ps5-jar-loader> |
| `sleirsgoevy/bdj-doom` | Java/console sample | <https://github.com/sleirsgoevy/bdj-doom> |
| `log_client.py` (in BD-JB repos) | Receive logs on port 18194 | In BD-JB-1250/BD-JB5 repos |

### Building an ISO with `bdj-sdk` (summary)

```bash
sudo apt-get install build-essential libbsd-dev git pkg-config \
    openjdk-8-jdk-headless openjdk-11-jdk-headless
git clone --recurse-submodules https://github.com/john-tornblom/bdj-sdk
ln -s /usr/lib/jvm/java-8-openjdk-amd64 bdj-sdk/host/jdk8
ln -s /usr/lib/jvm/java-11-openjdk-amd64 bdj-sdk/host/jdk11
make -C bdj-sdk/host/src/makefs_termux
make -C bdj-sdk/host/src/makefs_termux install DESTDIR=$PWD/bdj-sdk/host
make -C bdj-sdk/target
make -C bdj-sdk/samples/helloworld
```

Sample output: `bdj-sdk/samples/helloworld/helloworld.iso`.

---

## 4. Payloads (Homebrew Enablers)

| Name | Purpose | Version | Link |
|---|---|---|---|
| **GoldHEN** | Popular HEN; FTP, BinLoader, plugins | Official 2.4b18 (October 2024); 2.4b18.7/2.4b18.12 in community bundles | <https://github.com/GoldHEN/GoldHEN> |
| **PS4 HEN** | Alternative/lightweight HEN | pre-release-main-182 (September 2026) | <https://github.com/Scene-Collective/ps4-hen> |
| **HENloader LP** | AIO Lapse+Poops+GoldHEN | 9.00–12.52 | <https://github.com/GoldHEN/henloader_lp> |

> GoldHEN 2.4b18.12 (13.02–13.52 support) is not published on the official GitHub releases and is distributed through community/supporter channels. Verify the source and file hash before use.

---

## 5. Kernel exploits (other chains)

These repositories are not required for BD-JB but are useful for understanding the chain/alternatives:

| Repository | Purpose | Link |
|---|---|---|
| TheFloW's `ExploitNetControlImpl.java` gist | Poopsploit (PS4/PS5) | <https://gist.github.com/TheOfficialFloW/7174351201b5260d7780780f4059bebf> |
| `iMrDJAi/laps3c0re` | Lapse + mast1c0re (PS4 5.00–12.02) | <https://github.com/iMrDJAi/laps3c0re> |
| `Al-Azif/psfree-lapse` | PSFree + Lapse (PS4 7.00–9.60) | <https://github.com/Al-Azif/psfree-lapse> |
| `kmeps4/PSFree` | PSFree + Lapse for 9.00 | <https://github.com/kmeps4/PSFree> |
| `shahrilnet/remote_lua_loader` | Lua Loader + Lapse | <https://github.com/shahrilnet/remote_lua_loader> |
| `adri22235/ps4-suid-scanner` | 13.04 research tool (Celsius claim) | <https://github.com/adri22235/ps4-suid-scanner> |

---

## 6. PS5-only (for separation)

| Repository | Purpose | Note |
|---|---|---|
| `Gezine/BD-JB5` | BD-JB for PS5 up to 13.42; `bdj_unpatch.elf` for 13.60+ | Do not use on PS4 |
| `Gezine/Y2JB` | Code execution via the PS5 YouTube app | PS5-only |
| `hammer-83/ps5-jar-loader` | PS5 JAR loader | PS5 reference |

---

## 7. Burning and network tools

| Tool | OS | Link |
|---|---|---|
| ImgBurn | Windows | <https://www.imgburn.com> |
| PowerISO | Windows | <https://www.poweriso.com> |
| K3b | Linux | <https://apps.kde.org/k3b> |
| BD-SimpleBurn | macOS | <https://github.com/C4ndyF1sh/BD-SimpleBurn> |
| netcat / ncat | Cross-platform | For sending JARs/payloads to 9020/9025 |

---

## 8. Wikis and reference documentation

| Source | Purpose | Link |
|---|---|---|
| PSDevWiki — Vulnerabilities | Most technical PS4/PS5 vulnerability reference | <https://www.psdevwiki.com/ps4/Vulnerabilities> |
| ConsoleMods — PS4:Exploit_Chart | Up-to-date compatibility chart | <https://consolemods.org/wiki/PS4:Exploit_Chart> |
| ConsoleMods — PS4:BD-JB | Step-by-step guide | <https://consolemods.org/wiki/PS4:BD-JB> |
| HENloader Guide | AIO guide | <https://iaceene.github.io/HENloader/> |
| BD-JB-1250 README (fork) | Lapse/Poops/AIO notes | <https://github.com/ps3120/BD-JB-1250> |

---

## 9. PS4 14.00 research tools

The 14.00 track uses the same lab but a different toolchain:

| Tool/repository | Purpose | Link |
|---|---|---|
| `PupDecrypt-PS4` | Decrypt official 14.00 PUP on a 13.52 GoldHEN console | <https://github.com/iHaiDeeZ/PupDecrypt-PS4> |
| `ps4-pup-decrypt` | Upstream PUP decrypt payload | <https://github.com/Scene-Collective/ps4-pup-decrypt> |
| `ps4-pup_unpack` | Unpack decrypted PUP parts | <https://github.com/idc/ps4-pup_unpack> |
| `ps3120/ps4-exploit-kpatches` | Kernel patch shellcode including 14.00 (post-exploitation) | <https://github.com/ps3120/ps4-exploit-kpatches> |
| `Mikadolebg/ps4-1400-research` | SSV userland, R/W/ROP/syscalls, gates, open leads | <https://github.com/Mikadolebg/ps4-1400-research> |
| `siongadev/PS4-14.00-Jailbreak-Research` | Browser R/W/native execution evidence workspace | <https://github.com/siongadev/PS4-14.00-Jailbreak-Research> |
| `adri22235/ps4-14-00-security-notes` | WebKit gadget/offset dossier and CVE catalogue | <https://github.com/adri22235/ps4-14-00-security-notes> |
| `ntfargo/CSSFontFace-Exploit` | Legacy WebKit UAF reference (not 14.00) | <https://github.com/ntfargo/CSSFontFace-Exploit> |
| `OptiTronOffical/1350-webkit-test` | 13.50/13.52 WebKit R/W harness reference | <https://github.com/OptiTronOffical/1350-webkit-test> |

> These are **research tools**, not a public 14.00 jailbreak. Verify offsets, gates, and evidence on your own firmware dump. See [15 — status](15-ps4-1400-status.md) and [17 — roadmap/lab](17-research-roadmap-and-lab.md).

---

## 10. Warning about unknown sources

- Duplicate/forked repositories can contain malicious payloads. Prefer the original/author repository.
- Check `payload.bin`, ISO, and JAR files with hashes/antivirus before running.
- Ignore shortened links, free file hosts, and "one-click jailbreak" offers.
- No legitimate project needs your PSN password or personal information.
