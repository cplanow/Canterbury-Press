# ESP32 WLED Enclosure

Two-piece snap-fit enclosure for an AITRIP ESP32-WROOM-32 DevKitC mounted on an AITRIP expansion board, running WLED firmware for WS2812B LED strip control.

## Purpose
Securely house the ESP32 + expansion board behind a TV, with:
- USB-C access for power (from TV USB port)
- Wire exit for D16 (data) and GND jumper wires to LED strip
- Ventilation for heat dissipation (ESP32 runs WiFi continuously)
- Snap-fit lid for tool-free access

## Hardware
| Component | Spec |
|-----------|------|
| ESP32 | AITRIP ESP32-WROOM-32 DevKitC (USB-C) |
| Expansion Board | AITRIP expansion board (socket headers) |
| Firmware | WLED (WiFi LED controller) |
| LED Strip | BTF-LIGHTING WS2812B ECO, 5m, 60 LED/m |
| Power | USB-C from TV (ESP32), ALITOVE 5V 5A (strip) |
| Wiring | 2x F/M jumper wires (D16 data, GND) |

## Status
- [ ] Measurements verified with calipers
- [ ] First test print (draft quality)
- [ ] Tolerances adjusted
- [ ] Final print

## Dimensions (Placeholder -- Verify!)
All measurements are datasheet estimates. See `src/measurements.scad`.

| Dimension | Value | Source |
|-----------|-------|--------|
| ESP32 DevKitC PCB | 51.5 x 28.0 mm | Datasheet |
| Expansion Board | ~75 x 55 mm | Estimate |
| Total stack height | ~28-30 mm | Calculated |

## Print Settings
| Setting | Value |
|---------|-------|
| Material | PLA |
| Layer Height | 0.20 mm |
| Infill | 20% |
| Supports | No |
| Wall Count | 3 (1.2mm) |

## Build
```bash
make models/esp32-wled-enclosure/stl/enclosure.stl
```

## Revision History
| Date | Change |
|------|--------|
| 2026-04-04 | Initial POC design with datasheet dimensions |
