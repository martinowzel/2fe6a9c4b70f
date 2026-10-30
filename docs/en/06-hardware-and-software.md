# 06 — Required Hardware and Software

> This document lists everything needed for the disc-based BD-JB route (firmware 9.00–12.52), plus buying and configuration notes.

---

## 1. Quick shopping list

| Item | Required? | Notes |
|---|---|---|
| PS4 on firmware 9.00–12.52 | Yes | Verify the exact firmware first |
| Blu-ray writer (BD-RE/BD-R) | Yes | Internal SATA or external USB; must support recordable Blu-ray |
| BD-R or BD-RE disc | Yes | 25 or 50 GB; **BDXL is not supported**; BD-RE is better for testing/reuse |
| USB flash drive | Yes (first run) | FAT32 or exFAT; `payload.bin` at the root |
| PC with burning software | Yes | ImgBurn/PowerISO (Windows), K3b (Linux), BD-SimpleBurn (macOS) |
| GoldHEN or HEN payload | Yes | Firmware-compatible version from an official source |
| Network/Ethernet (optional) | No | For RemoteJarLoader/logging/payload sending from a PC |
| Pre-burned disc | Alternative to a writer | Only from a trusted seller; content/quality risk |

---

## 2. Blu-ray writer

### 2.1 What is required?

- A writer capable of **BD-R** and **BD-RE** (not just DVD/CD).
- Internal SATA or external USB 2.0/3.0.
- Support for low write speeds (2x/4x) for better stability.

### 2.2 Buying notes

- Cheap **read-only** drives (BD-ROM) are useless; make sure it is a **writer/burner**.
- For an external writer, confirm it is detected by your OS without special drivers.
- Older writers may not support high-capacity BD-RE; check the specifications.

### 2.3 Discs

| Type | Description | Recommendation |
|---|---|---|
| **BD-R** | Write once | Final/archival disc |
| **BD-RE** | Erasable and rewritable | Testing and ISO updates |
| **BDXL** | High capacity (100 GB+) | **Not supported** for PS4 BD-JB |
| **DVD/CD** | — | Does not work for BD-JB |

- Known brands (Verbatim, Sony, Panasonic, etc.) are generally more reliable.
- Cheap unbranded discs may not be readable by the PS4.
- For BD-RE, disable **permanent write / write once** in the burning software so the disc remains rewritable.

---

## 3. Burning software

| OS | Software | Note |
|---|---|---|
| Windows | **ImgBurn** | Simple and well known; use "Write image file to disc" |
| Windows | **PowerISO** | Alternative mentioned by ConsoleMods |
| Linux | **K3b** | Recommended in BD-JB READMEs |
| macOS | **BD-SimpleBurn** | macOS-specific; GitHub project |

### 3.1 Burning principles

1. Burn the ISO as an **image**, not as a data copy.
2. Use a low speed (2x/4x); enable "verify" if available.
3. For BD-RE, choose the correct erase/rewrite mode.
4. After burning, test the disc in a regular Blu-ray player or the PS4.

> BD-JB ISOs are usually small (around 16 MB); capacity is not the issue, but **disc type and BDMV structure** are.

---

## 4. USB flash drive and payload

- Format: **FAT32** or **exFAT** (both are supported in the READMEs).
- Put the payload at the **root** of the USB and name it exactly `payload.bin`.
- The payload must match your firmware (GoldHEN/HEN).
- Insert the USB **before** the disc.
- In many builds, after the first run the payload is copied to `/data/payload.bin` and the USB is no longer needed; behavior depends on the tool.

> Never run an unknown `payload.bin`. A malicious payload can damage the system/data.

---

## 5. PS4 settings

| Setting | Required value | Reason |
|---|---|---|
| **HDCP** | Enabled | Blu-ray playback/BD-J requires it |
| **Automatic updates** | Disabled | Prevent an unwanted firmware update |
| **System update** | Manual/disabled | Same reason |
| **BD-LIVE** | Answer YES when prompted | Some builds require this for execution |
| **Disable Pop-ups while playing video** | Off (pop-ups allowed) | To see notifications/the exploit menu |
| **Internet connection** | Only if initial activation is needed | If Blu-ray was never activated, go online once; then offline |
| **PSN connection** | Not required | BD-JB works offline |

### 5.1 Initial Blu-ray activation

If the console has never played a Blu-ray disc, the player may need activation/internet first. In that case:

1. Disable **automatic updates** first.
2. Connect to the internet once and activate Blu-ray playback.
3. Then go offline.

### 5.2 Error `NW-31201-7`

This error is usually related to HDCP/network/BD-LIVE. ConsoleMods recommends:

1. Open `Settings → System → Automatic Downloads` and uncheck "Allow Restart" and "System Software Update Files".
2. Reconfigure `Settings → Network → Set up Internet Connection` using Easy setup.
3. Enable `Settings → System → Enable HDCP`.

---

## 6. Network (optional)

For advanced use:

- **RemoteJarLoader:** send a custom JAR to port 9025.
- **BinLoader/console:** port 9020 (depending on the build).
- **RemoteLogger:** port 18194 for logs.
- Sending tools: `netcat`/`ncat` or the Python scripts included in the repositories (such as `log_client.py`).

Perform network setup only on a trusted local network; do not expose these ports to the internet.

---

## 7. Pre-flight checklist

- [ ] I have recorded the exact PS4 firmware.
- [ ] I checked firmware compatibility in the [compatibility table](05-firmware-compatibility.md).
- [ ] I have a working Blu-ray writer and a BD-R/BD-RE disc.
- [ ] I downloaded the correct ISO from an official/known source.
- [ ] I obtained a compatible payload (GoldHEN/HEN) from an official source.
- [ ] The USB is formatted FAT32/exFAT with `payload.bin` at the root.
- [ ] HDCP is enabled and automatic updates are disabled.
- [ ] Blu-ray playback is activated if needed.
- [ ] I understand I must not update firmware after jailbreaking.

---

## 8. Sources

- ConsoleMods — PS4:BD-JB (burning software, HDCP, BD-LIVE, errors): <https://consolemods.org/wiki/PS4:BD-JB>
- HENloader LP (requirements, USB, burning): <https://github.com/GoldHEN/henloader_lp>
- `DefKorns/BD-JB-1252` (HDCP/BD-LIVE/pop-up notes): <https://github.com/DefKorns/BD-JB-1252>
- `kimariin/BlueLoader` (disc types and network tools): <https://github.com/kimariin/BlueLoader>
- ImgBurn: <https://www.imgburn.com>
- K3b: <https://apps.kde.org/k3b>
- BD-SimpleBurn: <https://github.com/C4ndyF1sh/BD-SimpleBurn>
