# 01 — Fundamentals: BD-J, Blu-ray, and the PS4 Sandbox

> Goal: explain exactly what the "Blu-ray jailbreak" is, why it works, and why it still needs a separate kernel exploit.

---

## 1. The exploit chain at a glance

Every modern PS4 jailbreak usually consists of two or three stages:

```text
Userland Entry
        │
        ├── Web browser (WebKit)
        ├── Game-save exploit (Savedata)
        ├── Network service (PPPwn)
        ├── PS2 emulator (mast1c0re)
        └── Blu-ray player (BD-JB)      ← subject of this project
        │
        ▼
Sandbox escape / native code execution in userland
        │
        ▼
Kernel exploit (Lapse, Poopsploit, Relapse/Celsius)
        │
        ▼
Kernel read/write and privilege patches
        │
        ▼
Payload (GoldHEN / HEN) and homebrew enabled
```

**Key point:** a Blu-ray disc is not a complete jailbreak. BD-JB only escapes the Java sandbox and allows native code to run inside the Blu-ray player process. A kernel exploit is required for PKG installation, debug settings, FTP, plugins, and full homebrew support.

---

## 2. The PS4 and its Blu-ray player

- The PS4 operating system is based on FreeBSD and is distributed as firmware (PUP).
- The Blu-ray player application is known by the ID **NPXS20113** and lives on the protected `system_ex` partition.
- Important Java-related files include:
  - `bdjstack.jar` — Sony's BD-J implementation (`com.sony.bdjstack...`)
  - `rt.jar` — the Java runtime library
  - `lib/ext/sunjce_provider.jar` — a crypto provider that has a privileged path on some firmware versions
  - `lib/security/java.security` — Java's security policy; on some versions it is plaintext and unsigned
- PlayStation uses **Java ME / GEM / BD-J** for Blu-ray playback. A disc contains `BDMV`, a `BDJO` descriptor, and Xlet JAR files.

---

## 3. What exactly is BD-J?

**BD-J (Blu-ray Disc Java)** is the part of the Blu-ray standard that lets games, menus, and interactive applications run on a player.

Key components:

| Component | Description |
|---|---|
| **Xlet** | A Java application on a Blu-ray disc (similar to an Applet) with the lifecycle `initXlet` / `startXlet` / `pauseXlet` / `destroyXlet` |
| **BDMV** | Blu-ray disc file structure (video playback, JARs, metadata) |
| **BDJO** | BD-J application descriptor; contains `baseDirectory`, `applicationId`, and the startup class |
| **M2TS** | Video/audio transport stream |
| **BD-LIVE** | Blu-ray network feature; the player may ask the user for network permission |

The PS4 player has a Java **SecurityManager** that restricts what the disc application can do (for example, reading or writing system paths). BD-JB abuses weaknesses in the BD-J implementation and its security policies to bypass these restrictions.

---

## 4. Why the Blu-ray player is an attractive target

According to PSDevWiki, BD-J has significant advantages over WebKit as an exploit entry:

1. **Larger kernel attack surface:** the BD-J process uses `libkernel_sys`, which exposes capabilities such as `nmount` (mounting system partitions). Browsers use the much more restricted `libkernel_web`.
2. **High stability:** BD-J exploits are often described as "100% reliable" and are less sensitive to exact firmware revisions than WebKit.
3. **ROP-less code execution:** on PS4 the Java VM has JIT enabled, so kernel exploits can be written in C/Java instead of ROP and assembly.
4. **Offline:** after the disc is burned, no internet connection or external server is required (unlike some WebKit routes).
5. **Patch resilience:** several BD-J vulnerabilities survived for years, and a new bug could re-expand the supported firmware range.

Limitations:

- Requires a **Blu-ray writer** and BD-R/BD-RE media (or a pre-burned disc).
- The BD-J process has less memory; it is not enough by itself to run copied games.
- Sony has patched JAR loading paths and security policies on newer firmware.

---

## 5. The Java sandbox and "sandbox escape"

In Java, the `SecurityManager` decides what a class may do. A BD-J application on a disc normally has only limited permissions. To run native code and access memory, one of the following must happen:

- **Remove the SecurityManager:** call `System.setSecurityManager(null)` from a privileged context.
- **Load a class with AllPermission:** trick the BD-J engine into treating the attacker's JAR as a file under the privileged `lib/ext` path.
- **Invoke a privileged method through Ixc:** abuse the Inter-Xlet Communication mechanism, which invokes methods inside `AccessController.doPrivileged`.

After the sandbox is broken, the attacker can:

- use `sun.misc.Unsafe` or internal Unsafe classes for raw memory access;
- resolve native symbols with `NativeLibrary.findEntry`;
- call native functions using `setcontext` / `multi_allocate` structures;
- on PS4, send requests to the compiler process to execute arbitrary JIT code.

The exact evolution of these techniques is covered in the [technical deep dive](03-technical-deep-dive.md).

---

## 6. The role of the kernel exploit

After the sandbox escape, attacker code runs in userland with more privileges, but it still cannot:

- read or write kernel memory;
- change its process credentials to root;
- fully load the GoldHEN payload.

A kernel exploit triggers a vulnerability in Sony's FreeBSD-based kernel (for example, a double free in AIO or a UAF in `sys_netcontrol`) and patches structures such as `ucred`, `prison0`, `rootvnode`, and the `dynlib` range to gain the necessary control. The payload is then loaded over the network or from USB.

---

## 7. Key terms

| Term | Meaning |
|---|---|
| **BD-JB** | Blu-ray Disc Java Sandbox Escape; the Blu-ray sandbox-escape exploit family |
| **Userland Entry** | The initial point that gives code execution in userland |
| **Kernel Exploit / KEX** | A kernel vulnerability used to gain kernel-level access |
| **Payload** | A binary/program executed after the kernel exploit (GoldHEN, HEN) |
| **HEN** | Homebrew Enabler |
| **GoldHEN** | The most popular PS4 HEN with extra features (FTP, BinLoader, plugins) |
| **BD-R / BD-RE** | Recordable once / rewritable Blu-ray media |
| **BDXL** | High-capacity Blu-ray; not supported for PS4 BD-JB |
| **PRISON0** | A Sony kernel security structure used to confine processes |
| **Ucred** | Kernel credential structure (UID/GID/caps) |
| **AIO** | Asynchronous I/O; the subsystem containing Lapse's vulnerability |
| **Ixc** | Inter-Xlet Communication |
| **AllPermission** | Complete permission in the Java security model |
| **Xlet** | A Java application on a Blu-ray disc |

---

## 8. What this project does not cover

- WebKit/PPPwn/VueAfterFree methods are mentioned only for comparison and compatibility context.
- PS5 exploit details (BD-JB5, Y2JB, etc.) are included only to distinguish them from PS4.
- No binaries, firmware, keys, or copyrighted content are distributed.

---

## Sources for this document

- PSDevWiki — Vulnerabilities, "Usermode Exploits (BD-J)": <https://www.psdevwiki.com/ps4/Vulnerabilities>
- TheOfficialFloW/bd-jb source (`Exploit.java`, `Payload.java`, `Loader.java`): <https://github.com/TheOfficialFloW/bd-jb>
- ConsoleMods — PS4:BD-JB: <https://consolemods.org/wiki/PS4:BD-JB>
- HackerOne reports 1379975 (initial BD-JB) and 3104356 (Ixc): see [sources](12-sources.md)
