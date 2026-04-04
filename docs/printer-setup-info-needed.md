# Printer Info Needed — Bambu Lab P1S

Hey! I'm setting up AI-assisted tools to design and control 3D prints on the P1S remotely from my dev machine. I need a few pieces of info from the printer to get everything connected. Here's what I need and where to find it.

---

## What I Need

### 1. Printer IP Address
- **Where to find it:** On the printer's touchscreen, go to **WLAN** (WiFi icon) — the IP address is displayed there
- **Looks like:** `192.168.x.x` or similar
- **Example:** `192.168.1.105`

### 2. LAN Access Code
- **Where to find it:** On the printer's touchscreen, go to **WLAN** — look for **Access Code**
- **Looks like:** An 8-digit alphanumeric code
- **Example:** `12345678`

### 3. Printer Serial Number
- **Where to find it:** On the printer's touchscreen, go to **Settings** > **Device** > **Serial Number**
- **Looks like:** A long alphanumeric string
- **Example:** `01P00A000000000`

### 4. Developer Mode Status
- **Where to check:** On the printer's touchscreen, go to **Settings** > **LAN Only**
- **What I need:** Is Developer Mode currently **enabled** or **disabled**?
- **If it's not on:** Could you enable it? It's under the LAN Only settings. This lets me send print files directly from my computer over the local network.
- **Note:** Enabling Developer Mode may disable some Bambu Handy (phone app) cloud features. If you use Bambu Handy regularly, let me know and I can work around it.

### 5. Firmware Version
- **Where to find it:** On the printer's touchscreen, go to **Settings** > **Device** > **Firmware Version**
- **Looks like:** Something like `01.08.00.00`

### 6. Network Info
- **What network is the printer on?** (WiFi name / SSID)
- **Is it on the same network as my computer?** (If you're not sure, just tell me the WiFi name and I'll check)

---

## Optional but Helpful

### 7. AMS Status
- **Is the AMS (Automatic Material System) connected?**
- **If yes:** What filament is loaded in each slot? (color/material)

### 8. Current Nozzle Size
- **Should be 0.4mm** (stock), but confirm if it's been swapped

### 9. Bed Plate Type
- **Textured PEI** (stock), **Smooth PEI**, or **Engineering plate**?

---

## How to Send This Back

Just text me the info — doesn't need to be fancy:

```
IP: 192.168.x.x
Access Code: xxxxxxxx
Serial: xxxxxxxxxxxxx
Dev Mode: on/off
Firmware: xx.xx.xx.xx
WiFi: [network name]
AMS: yes/no, [filament info]
Nozzle: 0.4mm
Bed: textured PEI
```

Thanks!
