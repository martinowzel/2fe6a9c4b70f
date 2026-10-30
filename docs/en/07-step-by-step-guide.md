# 07 — Step-by-Step Guide (Firmware 9.00–12.52)

> This guide is for **personally owned consoles** and **legal homebrew**. Before starting, confirm that your firmware is in the supported range. If you are unsure, go back to the [firmware compatibility table](05-firmware-compatibility.md).

---

## 0. Route summary

```text
1) Check the firmware
2) Download the correct ISO
3) Prepare the USB drive (payload.bin)
4) Burn the ISO to BD-R/BD-RE
5) Configure the PS4 (HDCP, auto-update, BD-LIVE)
6) Insert USB, insert disc, open Blu-ray Player
7) Select Lapse or Poops (in HENloader)
8) Wait for GoldHEN/HEN to load
9) After success: block updates and use a trusted payload
```

---

## 1. Check the firmware

1. Open `Settings`.
2. Go to `System → System Information`.
3. Record the exact `System Software` number (for example `12.02`, not just "12").
4. Find the corresponding row in the [compatibility table](05-firmware-compatibility.md).

**Quick rules:**

- `9.00 – 12.02`: Lapse (HENloader or Lapse.iso).
- `12.50 – 12.52`: Poopsploit (HENloader or Poops.iso).
- `13.00 – 13.04`: research; read the exact-version sources before proceeding.
- `13.50+`: disc BD-JB is not recommended.
- `14.00+`: no public method.

---

## 2. Choose the ISO

### Option A — HENloader LP (recommended, 9.00–12.52)

- Repository: <https://github.com/GoldHEN/henloader_lp>
- Stable release: `1.0` (November 2025)
- Includes: Lapse (9.00–12.02) + Poopsploit (9.00–12.52) + GoldHEN 2.4b18.7
- AIO fixes (black screen/save corruption) are inside the ISO.
- Menu: **Cross = Lapse**, **Circle = Poops**.

> HENloader is a community all-in-one package, not an official GoldHEN release. Read its README and release notes before use.

### Option B — Lapse.iso (9.00–12.02)

- Original repository: `Gezine/BD-JB-1250` (direct access is currently restricted; active fork: <https://github.com/ps3120/BD-JB-1250>)
- Version 1.2+ includes AIO fixes inside the ISO.
- The payload is loaded automatically from USB (`payload.bin`).
- BinLoader port: 9020.

### Option C — Poops.iso (12.50–12.52)

- Repository: <https://github.com/DefKorns/BD-JB-1252>
- The ISO contains the Poops JAR payload.
- `payload.bin` is loaded from USB and copied to `/data/payload.bin`.
- BinLoader listens on 9020 even if `payload.bin` is not found.

> Use only official releases from the same repository. Do not run files uploaded to unknown channels.

---

## 3. Prepare the USB drive

1. Format the USB as **FAT32** or **exFAT**.
2. Obtain a firmware-compatible payload from an official source:
   - GoldHEN: <https://github.com/GoldHEN/GoldHEN/releases>
   - PS4 HEN (alternative): <https://github.com/Scene-Collective/ps4-hen/releases>
3. Rename the file to `payload.bin` (exactly).
4. Place it at the **root** of the USB, not inside a folder.
5. Eject the USB safely.

**Note:** if the ISO has a built-in payload and you do not want a custom one, you can use the ISO alone; a custom GoldHEN build requires the USB.

---

## 4. Burn the ISO to a Blu-ray disc

### Windows — ImgBurn

1. Open ImgBurn.
2. Choose `Write image file to disc`.
3. Select the ISO file.
4. Insert the BD-R or BD-RE disc into the writer.
5. Set a low speed (2x/4x).
6. Enable `Verify`.
7. Click `Write` and wait for completion.

### Linux — K3b

1. Open K3b.
2. Choose `Burn Image` and select the ISO.
3. Insert the BD-RE/BD-R disc.
4. Select a low speed and enable `Verify`.
5. Start burning.

### macOS — BD-SimpleBurn

- Use <https://github.com/C4ndyF1sh/BD-SimpleBurn> and burn the ISO with the default settings/low speed.

**Important:**

- For BD-RE, disable **permanent write**.
- Do not burn the ISO as a "data disc"; it must be an image.
- If burning fails, do not throw the disc away; BD-RE can be erased and rewritten.

---

## 5. Configure the PS4 before running

1. **Enable HDCP:** `Settings → System → Enable HDCP`.
2. **Disable automatic updates:**
   - `Settings → System → Automatic Downloads`
   - Uncheck `System Software Update Files` and `Allow Restart`.
3. **If Blu-ray was never activated:** go online once (with automatic updates disabled) and activate Blu-ray playback; then go offline.
4. **Pop-ups:** `Settings → Notifications` → turn **off** `Disable Pop-ups while playing video` so notifications/menus are visible.
5. **BD-LIVE:** when prompted, choose `Yes`.

---

## 6. Run the exploit

### 6.1 With HENloader

1. Connect the prepared USB to the PS4 **first**.
2. Insert the disc.
3. From the home screen, open **Blu-ray Player**.
4. If the BD-LIVE prompt appears, choose `Yes`.
5. The HENloader menu appears.
6. Depending on firmware:
   - **9.00–12.02:** press **Cross** (Lapse).
   - **12.50–12.52:** Lapse is disabled; press **Circle** (Poops).
7. Wait for the success message/GoldHEN load.
8. The disc may eject automatically; this is normal.
9. Once loaded, you can close the Blu-ray Player.

### 6.2 With Lapse.iso

1. Connect the USB.
2. Insert the disc and open Blu-ray Player.
3. The exploit runs automatically.
4. `payload.bin` is loaded from USB.
5. Wait for the success message/notification.
6. Close the Blu-ray Player.

### 6.3 With Poops.iso (12.50–12.52)

1. Connect the USB.
2. Insert the disc and open Blu-ray Player.
3. The Poops payload JAR runs.
4. `payload.bin` is loaded from USB and copied to `/data/payload.bin`.
5. After success, close the Blu-ray Player.

**If it fails:** **restart** the console and try again. Official guidance: do not simply reopen the BD-J app after a failure; stability degrades.

---

## 7. Verify success

Success indicators:

- GoldHEN/HEN notification.
- New items in Settings (depending on the payload).
- Working FTP/BinLoader/Homebrew Launcher.
- GoldHEN settings/plugins menu.

If the payload does not load:

- The USB is in the correct port and was inserted before the disc.
- The file is named `payload.bin` and is at the root.
- The payload matches the firmware.
- The USB is FAT32/exFAT.

---

## 8. After jailbreaking: recommended setup

1. **Block firmware updates:**
   - Keep automatic updates disabled.
   - If possible, configure DNS/firewall rules to block update servers.
2. **Avoid PSN** if you want to reduce ban risk (especially with your main account).
3. **Keep payloads/ISOs from official sources** and record their hashes.
4. **Back up saves** (GoldHEN/Save Manager).
5. **Do not install many incompatible plugins**, especially together with AIO fixes.
6. **Do not update** until the BD-JB/kernel status for the new firmware is clear.

---

## 9. 13.x notes (advanced users only)

- **13.00/13.02:** ps3120 published the research ISO `Lapse_1.2_Mod` under `ps3120/BD-JB-1250` tags. The 13.00 kernel can be Poopsploit; 13.02 needs a different kernel.
- **13.04:** `bdj1304.iso` is in `ps3120/ps3120.github.io`; the 13.04 kernel is Relapse/Celsius in community reports.
- **13.50/13.52:** disc BD-JB is blocked; the public route is WebKit + GoldHEN 2.4b18.12. BD-JB-EX is only possible with a previously injected JAR in `system_ex`.
- **14.00+:** no public chain.

> These versions do not have a complete "cookbook" here because official/reproducible public detail is limited and the brick/data-loss risk is higher. Start from the exact-version pages on PSDevWiki and ConsoleMods.

---

## 10. Quick troubleshooting

| Issue | Action |
|---|---|
| Exploit does not run | Restart the console; retry from the beginning |
| `NW-31201-7` | HDCP, Automatic Downloads, Easy network setup |
| Disc cannot be read | Correct burn, BD-R/BD-RE, low speed, no BDXL |
| Black screen/corrupted saves | AIO fix (Lapse 1.2/HENloader); do not stack plugins |
| Payload does not load | USB first, `payload.bin` at root, correct format/version |
| No notification | Turn off `Disable Pop-ups while playing video` |

More: [troubleshooting](10-troubleshooting.md).

---

## 11. Sources

- ConsoleMods — PS4:BD-JB (Henloader/Lapse steps, errors): <https://consolemods.org/wiki/PS4:BD-JB>
- HENloader LP: <https://github.com/GoldHEN/henloader_lp>
- `DefKorns/BD-JB-1252`: <https://github.com/DefKorns/BD-JB-1252>
- `ps3120/BD-JB-1250` (Gezine fork): <https://github.com/ps3120/BD-JB-1250>
- `bdj1304.iso`: <https://github.com/ps3120/ps3120.github.io/blob/main/bdj1304.iso>
- GoldHEN: <https://github.com/GoldHEN/GoldHEN>
- PS4 HEN: <https://github.com/Scene-Collective/ps4-hen>
