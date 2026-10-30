# 13 — Glossary

> Technical terms used in this project, sorted alphabetically.

| Term | Meaning |
|---|---|
| **AIO** | All-In-One; a combined bundle (for example, HENloader includes Lapse and Poops) |
| **AIO Fix** | Extra fixes for black-screen/save-corruption issues in Lapse |
| **AIO (Kernel)** | Asynchronous I/O; the I/O subsystem containing Lapse's vulnerability |
| **AllPermission** | Complete permission in the Java security model |
| **BD-J** | Blu-ray Disc Java; the Java application environment on Blu-ray discs |
| **BD-JB** | Blu-ray Disc Java Sandbox Escape; the Blu-ray Java sandbox-escape exploit family |
| **BD-LIVE** | Blu-ray network feature; the player may request network permission |
| **BD-R** | Write-once Blu-ray disc |
| **BD-RE** | Rewritable Blu-ray disc |
| **BDXL** | High-capacity Blu-ray standard; not supported for PS4 BD-JB |
| **BDMV** | Blu-ray disc file structure |
| **BDJO** | BD-J application descriptor (includes `baseDirectory` and `applicationId`) |
| **BinLoader** | Network payload receiver (port 9020 in BD-JB loaders; 9090 in GoldHEN) |
| **Celsius** | A kernel exploit/bug name (community report for 13.04; `ffs_mount`) |
| **CVE** | Common Vulnerabilities and Exposures; official vulnerability identifier |
| **Double Free** | Freeing the same memory twice; leads to UAF/exploitation |
| **fdrop / fhold** | Decrement/increment a file reference count in the FreeBSD kernel |
| **FTP** | File Transfer Protocol; GoldHEN uses port 2121 |
| **GoldHEN** | Popular PS4 HEN with extra features |
| **HEN** | Homebrew Enabler |
| **HENloader LP** | All-in-one package containing Lapse + Poops + GoldHEN |
| **Ixc** | Inter-Xlet Communication |
| **JIT** | Just-In-Time compilation; enabled in the PS4 JVM |
| **KASLR** | Kernel Address Space Layout Randomization |
| **KEX** | Kernel Exploit |
| **Klog** | Kernel Log; GoldHEN uses port 3232 |
| **Lapse** | AIO double-free kernel exploit; firmware 5.00–12.02 |
| **libkernel_sys** | Privileged system library; used by the BD-J process |
| **libkernel_web** | Restricted library used by the browser |
| **NPXS20113** | The PS4 Blu-ray player application ID |
| **Payload** | A binary/program executed after the kernel exploit (GoldHEN/HEN) |
| **PKG** | PS4 installation package |
| **Poopsploit** | `sys_netcontrol` double-fdrop kernel exploit; PS4 ≤13.00 |
| **PRISON0** | A Sony kernel security structure used to confine processes |
| **PUP** | Official PS4 firmware update package |
| **Relapse** | A kernel exploit/jailbreak name (PS4 13.02–13.04 and PS5); community report |
| **RTHDR** | IPv6 Routing Header; used for spraying in Poopsploit |
| **RWX** | Memory that is readable, writable, and executable |
| **SecurityManager** | Java class that enforces security policies |
| **system_ex** | Protected PS4 system partition containing the Blu-ray player |
| **UAF** | Use-After-Free |
| **Ucred** | Kernel credential structure (UID/GID/caps) |
| **Unsafe** | Java class for raw memory access |
| **Xlet** | A Java application on a Blu-ray disc |
| **XOM** | Execute-Only Memory; a PS5 memory restriction |

---

## Common abbreviations

| Abbreviation | Meaning |
|---|---|
| **AIO** | All-In-One (complete bundle) |
| **BD-JB** | Blu-ray Disc Java Sandbox Escape |
| **HEN** | Homebrew Enabler |
| **KEX** | Kernel Exploit |
| **PoC** | Proof of Concept |
| **UAF** | Use-After-Free |
| **FW** | Firmware |
| **PSN** | PlayStation Network |
| **USB** | Universal Serial Bus |
