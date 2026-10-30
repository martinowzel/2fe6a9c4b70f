# 10 — Troubleshooting

> This document collects common BD-JB issues. If your problem is not listed, check the tool logs (port 18194) and the README for your exact build.

---

## 1. Quick table

| Symptom | Likely cause | Fix |
|---|---|---|
| Exploit does not run | Transient failure/timing | Fully restart the console and retry |
| Reopening the BD-J app after a failure makes it worse | Unstable in-memory state | Restart; do not just reopen the app |
| `NW-31201-7` error | HDCP/network/BD-LIVE | Enable HDCP, disable Automatic Downloads, use Easy setup |
| Disc cannot be read | Bad burn/incompatible disc | Burn the ISO as an image at low speed; use valid BD-R/BD-RE, not BDXL |
| Black screen | Incompatible/old AIO fix | Use Lapse 1.2+ or HENloader; remove extra fixes |
| Corrupted saves | Incompatible AIO fix/plugin | Apply the AIO fix correctly; avoid multiple plugins |
| Payload does not load | USB/name/version | USB first, `payload.bin` at root, FAT32/exFAT, compatible payload |
| No notification | Pop-ups disabled | Turn off `Disable Pop-ups while playing video` |
| HENloader menu does not appear | BD-LIVE/disc/version | Accept BD-LIVE; rebuild the disc; verify the ISO |
| PSN/update issues after success | Auto-update/online | Block updates; stay offline |

---

## 2. Common issues in detail

### 2.1 The exploit fails

- Do a **full restart** (not just closing the app).
- Connect the USB before the disc.
- Reinsert the disc and open Blu-ray Player.
- If it fails repeatedly, re-burn the disc (especially BD-RE).
- Some builds are more stable on the first run after power-on.

### 2.2 `NW-31201-7`

Per ConsoleMods:

1. `Settings → System → Automatic Downloads`
   - Uncheck `Allow Restart`.
   - Uncheck `System Software Update Files`.
2. Reconfigure `Settings → Network → Set up Internet Connection` with Easy setup.
3. Enable `Settings → System → Enable HDCP`.

### 2.3 Disc cannot be read

- The ISO must be burned as an **image**, not as a data disc.
- The disc must be **BD-R or BD-RE**; DVD/CD/BDXL will not work.
- Lower the burn speed and enable `Verify`.
- For BD-RE, disable `permanent write`.
- The PS4 lens/drive may be dirty; test with a normal Blu-ray disc.
- Some cheap discs are not readable by the PS4.

### 2.4 Black screen or corrupted saves

- This is an **AIO fix** issue, not BD-JB itself.
- Use `Lapse.iso` 1.2+ or HENloader (the fix is inside the ISO).
- If using an older build, send `aiofix_network.elf` after HEN via BinLoader.
- **Do not install multiple fixes or plugins at the same time.**
- If conflicting fixes were installed, remove plugins and test before considering more drastic steps.

### 2.5 Payload does not load

- Connect the USB **before** the disc.
- The file must be exactly `payload.bin` at the root.
- Use FAT32 or exFAT.
- The payload must match the firmware (GoldHEN/HEN).
- If the ISO has a built-in payload, USB may not be needed; read the README.
- In some builds BinLoader is on 9020, not 9090.

### 2.6 No notification/menu

- Turn **off** `Settings → Notifications → Disable Pop-ups while playing video`.
- Some builds only send logs over the network: run `log_client.py` on port 18194.

### 2.7 The console is unstable after success

- Remove incompatible payloads/plugins.
- Use the AIO fix/payload bundled with the same tool.
- Power-cycle and re-run the exploit.
- If the issue persists, try another ISO/payload build.

### 2.8 Automatic firmware update

- Disable automatic updates.
- If possible, configure DNS/firewall rules to block update servers.
- If firmware is updated beyond the supported range, the previous exploit no longer works; there may be no immediate public solution.

---

## 3. Collecting logs

### 3.1 RemoteLogger (Gezine builds)

1. On a PC, run `log_client.py` from the repository:

```bash
python3 log_client.py
```

2. Launch the BD-J app on the PS4.
3. Logs are received on port 18194.

### 3.2 BinLoader console

- Connect to port 9020 with netcat and watch messages (in builds with an active console):

```bash
nc 192.168.1.50 9020
```

### 3.3 What to report

- PS4 model and exact firmware.
- Exact ISO/tool version.
- Disc type (BD-R/BD-RE) and burn speed.
- Full error/log text.
- Whether the USB was connected and the file name.

---

## 4. When to stop

If you see any of these, stop:

- The console does not boot or has a persistent black screen.
- Beep/error light (especially a flashing blue/white light).
- System/data corruption messages.
- A requirement to reinstall firmware.

In these cases:

1. Disconnect power and wait a few minutes.
2. Try Safe Mode boot if possible.
3. If you have important data, back it up first if possible.
4. Do not attempt further modifications without specific guidance.

---

## 5. Sources

- ConsoleMods — PS4:BD-JB (Troubleshooting: exploit failed, NW-31201-7, disc cannot be read): <https://consolemods.org/wiki/PS4:BD-JB>
- `DefKorns/BD-JB-1252` (HDCP/BD-LIVE/pop-ups/restart notes): <https://github.com/DefKorns/BD-JB-1252>
- `ps3120/BD-JB-1250` (AIO fix and logging): <https://github.com/ps3120/BD-JB-1250>
- `kimariin/BlueLoader` (ports and netcat): <https://github.com/kimariin/BlueLoader>
- HENloader LP: <https://github.com/GoldHEN/henloader_lp>
