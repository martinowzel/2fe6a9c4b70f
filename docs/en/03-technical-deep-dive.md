# 03 — Technical Deep Dive: How BD-JB Works

> This document is for technical readers. Its purpose is to explain mechanisms, not to provide ready-to-run exploit code. Claims are referenced to primary sources (PSDevWiki, public source code, HackerOne) wherever possible.

---

## 1. Chain overview

```text
Blu-ray disc (BDMV + BDJO + JAR)
        │  executed by the PS4 Blu-ray player (NPXS20113)
        ▼
Xlet application inside the Java sandbox
        │  BD-JB vulnerability (version-dependent)
        ▼
SecurityManager disabled / class loaded with AllPermission
        │
        ▼
Native memory access (Unsafe / JNI / JIT)
        │
        ▼
Native code execution inside the BD-J process (libkernel_sys)
        │
        ▼
Kernel exploit (Lapse / Poopsploit / ...)
        │
        ▼
GoldHEN/HEN payload from USB or network
```

---

## 2. BD-JB1: TheFloW's five vulnerabilities (PS4 ≤ 9.00)

The first BD-JB used a five-stage chain:

### Stage 1 — Sandbox escape via `UserPreferenceManagerImpl`

`com.sony.gemstack.org.dvb.user.UserPreferenceManagerImpl` deserializes the `userprefs` file inside an `AccessController.doPrivileged` block:

```java
UserPreferenceManagerImpl.preferences =
    AccessController.doPrivileged(
        (PrivilegedExceptionAction<String[][]>) new ReadPreferenceAction());
```

If an attacker controls the `userprefs` file, they can inject a custom `ClassLoader` and call `defineClass` with full permissions. This stage worked fully on PS4 firmware 5.07 and lower; it became harder on later versions.

### Stage 2 — Remove the SecurityManager

Once privileged context is reached, `System.setSecurityManager(null)` is called. From that point, Java's security checks are disabled.

### Stage 3 — Install a native API

Using `sun.misc.Unsafe` (or an internal Unsafe class plus reflection), raw memory becomes accessible. TheFloW's source contains two implementations:

- `UnsafeSunImpl` — uses `sun.misc.Unsafe`
- `UnsafeJdkImpl` — uses an internal JDK class and reflection

### Stage 4 — Call native functions

Native functions are resolved with `java.lang.ClassLoader$NativeLibrary.findEntry` and invoked using `setjmp` / `__Ux86_64_setcontext` and `multi_allocate`. This lets Java code call `libkernel` functions.

### Stage 5 — Execute arbitrary code (PS4 only)

On PS4, malicious requests sent to the compiler process write the payload into executable memory and run it. On PS5 this stage is different because of XOM (execute-only memory) and other restrictions.

> BD-JB1 alone is not a full jailbreak; it is not enough to install PKGs and run copied games.

---

## 3. BD-JB2: Path traversal in `BdjPolicyImpl` (up to PS4 12.52 / PS5 8.00)

### Idea

The BD-J engine uses the `baseDirectory` field in the `BDJO` file to load JARs. If this path is not validated correctly, `../` can escape the disc directory and place the attacker's JAR under the privileged `$JAVA_HOME/lib/` path:

```text
file:///app0/cdc/lib/../../../disc/BDMV/JAR/00000.jar
```

`com.sony.bdjstack.security.BdjPolicyImpl` then treats the JAR as a file in `lib` and grants **AllPermission**. The attacker's JAR disables the SecurityManager.

### Implementation

TheFloW implemented this method in the `bd-jb` repository in November 2024. The attacker only needs to place the `BDJO` and JAR on the disc; the rest of the chain (Unsafe, native calls, payload) is shared.

### Patch

- PS4: firmware 13.00
- PS5: firmware 8.00

---

## 4. BD-JB3: Abusing Ixc (up to PS4 12.50/12.52)

### 4.1 What is Ixc?

**Inter-Xlet Communication (Ixc)** is the mechanism Xlets use to communicate. BD-J has two independent implementations:

- `org.dvb.io.ixc`
- `com.sun.xlet.ixc`

Both allow methods of one Xlet to be called from another. If an attacker controls one of them, privileged methods can be invoked.

### 4.2 The `com.sun.xlet.ixc.XletManager` vulnerability

Gezine found that `createXlet` in `XletManager` allows a new Xlet to be created with an attacker-controlled `URLClassLoader` and JAR path. Because this call happens in a privileged context, the loaded class can disable the SecurityManager.

Simplified idea:

```java
XletLifecycleHandler handler = XletManager.createXlet(
    "org.bdj.sandbox.Dummy",
    new String[]{ "file:///app0/bdjstack/lib/ext/../../../../disc/BDMV/JAR/00000.jar" },
    new String[0]
);

XletManager manager = (XletManager) handler;
URLClassLoader loader = (URLClassLoader) manager.getClassLoader();
Class payload = loader.loadClass("org.bdj.sandbox.Payload");
payload.newInstance();
```

### 4.3 The `com.sun.xlet.ixc.WrappedRemote` vulnerability

`WrappedRemote` invokes `remoteMethod.invoke(target, args)` inside `AccessController.doPrivileged`:

```java
AccessController.doPrivileged(
    new PrivilegedExceptionAction() {
        public Object run() throws RemoteException {
            result[0] = remoteMethod.invoke(targetNow, args);
            return null;
        }
    }, context);
```

An attacker can create a fake Stub class and change `com_sun_xlet_method0` to the real `System.setSecurityManager`. Calling `setSecurityManager(null)` on a fake object then removes the real SecurityManager, effectively destroying the sandbox.

### 4.4 Why it does not work on PS5

The `com.sun.xlet` package is not exported from the PS5 `java.p` module. This route is therefore PS4-specific. BD-JB5 later found other routes for PS5.

### 4.5 Patch status

- `com.sun.xlet.ixc` worked on PS4 up to 12.50/12.52 and was patched in 12.52 (blacklisting `com.sun.xlet` in `java.security`).
- `org.dvb.io.ixc` was also reported in the same period and later patched.
- `BD-JB3.2` is a path-traversal variant using `$JAVA_HOME/lib/ext`; it worked up to 12.52 and was patched in 13.00.

---

## 5. BD-JB-13.00 and CVE-2025-64390

### 5.1 Nested JAR idea

In December 2025, Gezine found that JAR path validation in `BdjPolicyImpl` could still be bypassed. His method:

1. In the `BDJO`, set `baseDirectory` to:

```text
file:/dsm/00000.jar/../../app0/bdjstack/lib/ext/00000.jar
```

2. Build a JAR and then **nest the same JAR inside itself** at `../../app0/bdjstack/lib/ext/00000.jar`.
3. Set `applicationId` outside `0x4000–0x7FFFF` (for example `0x3FFF`) so `CoreAppId.isSigned()` returns `false` and signature verification is skipped.

As a result, the BD-J engine sees the nested file under the privileged `lib/ext` path and grants AllPermission. This vulnerability is **BD-JB-13.00** and **CVE-2025-64390**.

### 5.2 Patch

- In 13.04, Sony truncates the path at the first `.jar` from the left and then canonicalizes; for example, `...extWHAT/myjar.jarHELLO.jar` becomes `...extWHAT/myjar.jar`.
- This effectively disables nested JARs.
- In 13.04, another path-traversal route (`BD-JB-13.04`) was accidentally re-opened.

---

## 6. BD-JB-13.04

In firmware 13.04, while patching BD-JB-13.00, Sony accidentally re-enabled an older path:

```text
file:///app0/bdjstack/lib/ext/sunjce_provider.jar/../../../../../disc/BDMV/JAR/00000.jar
```

Key point: the attacker's JAR is loaded relative to `$JAVA_HOME/lib/ext/sunjce_provider.jar`; on 13.50 and lower, any JAR in that path received **AllPermission**. ps3120 implemented this vulnerability and published `bdj1304.iso`.

- **Patch:** 13.50
- **Affected versions:** up to 12.52 and 13.04 (per PSDevWiki)
- **Note:** on 13.00/13.02 this path was already patched.

---

## 7. BD-JB-EX: Injection into `system_ex`

### Idea

Instead of bypassing path validation, place the file under a privileged system path:

```text
/system_ex/app/NPXS20113/bdjstack/lib/ext/00000.jar
```

Any JAR in this path receives full permissions. Proposed vectors:

1. Inject a malicious `00000.jar` into `lib/ext` (implemented by 15432, February 2026).
2. Inject a vulnerable class into `bdjstack.jar` (proposed by Gezine).
3. Replace `lib/security/java.security` (proposed by CelesteBlue).

### Important limitation

Writing to `system_ex` requires a **prior kernel exploit**. BD-JB-EX is therefore not a cold-start method; it is for a console that was previously jailbroken and wants to preserve BD-JB on a higher firmware. Reinstalling firmware erases the injection. PSDevWiki warns that modifying the system partition can lead to a brick or a required firmware reinstall.

---

## 8. From sandbox escape to payload execution

### 8.1 Memory access and JIT

After the SecurityManager is disabled, Java code can:

- read/write native memory with `Unsafe`;
- resolve `libkernel` symbols with `dlsym`;
- create RWX memory with `sceKernelJitCreateSharedMemory` and `mmap`.

Simplified logic from TheFloW's `Payload.java`:

```java
sceKernelJitCreateSharedMemory(name, len, PROT_READ|PROT_WRITE|PROT_EXEC, handle);
long rwx = mmap(0, len, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, handle, 0);
api.memcpy(rwx, payload, payload.length);
// prepare arguments and execute the payload
int ret = (int) api.call(rwx, args);
```

This allows a small ELF/binary (such as `payload.bin`) to run inside the BD-J process.

### 8.2 Ports and loaders

Depending on the build, the following ports are used:

| Port | Purpose | Source |
|---|---|---|
| **9020** | BinLoader / Lapse console log | Gezine BD-JB-1250, HENloader |
| **9021** | Payload receiver in the original TheFloW BD-JB | `Exploit.java` |
| **9025** | RemoteJarLoader (send a custom JAR) | BD-JB-1250, BD-JB5, BlueLoader |
| **9030** | fsdump output (developer tool) | BlueLoader |
| **18194** | RemoteLogger (network logging) | BD-JB-1250/BD-JB5 |

> Exact ports depend on the tool build; always read the README of that repository.

### 8.3 RemoteLogger

In Gezine's builds, the BD-J application sends logs over the network. The server listens on port **18194**, and `log_client.py` displays the logs. Recommended order: start the client first, then launch the BD-J app.

---

## 9. BD-JB variant comparison

| Variant | Core mechanism | Max PS4 firmware | Status |
|---|---|---|---|
| **BD-JB1** | Five vulnerabilities; `UserPreferenceManagerImpl` + SecurityManager + Unsafe | ≤ 9.00 | Historical; initial foundation |
| **BD-JB2** | Path traversal in `BdjPolicyImpl` (`/app0/cdc/lib/...`) | ≤ 12.52 | Patched in 13.00 (PS5: 8.00) |
| **BD-JB3** | Ixc: `org.dvb.io.ixc` and `com.sun.xlet.ixc` | ≤ 12.50 / 12.52 | Patched in 12.52 |
| **BD-JB3.2** | Path traversal via `$JAVA_HOME/lib/ext` | ≤ 12.52 | Patched in 13.00 |
| **BD-JB-13.00** | Nested JAR + `baseDirectory` (`CVE-2025-64390`) | 13.00–13.02 | Patched in 13.04 |
| **BD-JB-13.04** | Path traversal via `sunjce_provider.jar` | 13.04 | Patched in 13.50 |
| **BD-JB-EX** | JAR injection into `system_ex/lib/ext` | Requires a prior kernel exploit | Preserves BD-JB on higher firmware |

---

## 10. Why these routes get patched

Three main patch patterns appear:

1. **Hardening JAR paths:** canonicalization, removing `..`, restricting `baseDirectory` to the disc directory.
2. **Blacklisting dangerous packages:** for example, `com.sun.xlet` in the 12.52 `java.security`.
3. **Changing permission policy:** removing AllPermission for `lib/ext` paths or `sunjce_provider.jar`.

Each time Sony closes a route, researchers find another. This is why BD-JB has had a long patch/exploit cycle.

---

## 11. Technical sources

- PSDevWiki — Vulnerabilities (BD-JB1 through BD-JB-EX and kernel sections): <https://www.psdevwiki.com/ps4/Vulnerabilities>
- `TheOfficialFloW/bd-jb` source: `src/com/bdjb/Exploit.java`, `Payload.java`, `Loader.java`, `exploit/sandbox/*` — <https://github.com/TheOfficialFloW/bd-jb>
- `Gezine/BD-JB-1250` source (ps3120 fork): `src/org/bdj/sandbox/XletManagerExploit.java` — <https://github.com/ps3120/BD-JB-1250>
- HackerOne 1379975 (BD-JB1): <https://hackerone.com/reports/1379975>
- HackerOne 3104356 (Ixc): <https://hackerone.com/reports/3104356>
- HackerOne 3320669 (sys_netcontrol): <https://hackerone.com/reports/3320669>
- HackerOne 3452696 (CVE-2025-64390): <https://hackerone.com/reports/3452696>
- NVD CVE-2025-64390: <https://nvd.nist.gov/vuln/detail/CVE-2025-64390>
- hardwear.io 2022 slides: <https://github.com/TheOfficialFloW/Presentations/blob/master/2022-hardwear-io-bd-jb.pdf>
