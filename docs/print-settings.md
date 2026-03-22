# Print Settings — Bambu Lab P1S

## PLA Profiles

### PLA — Draft (fast prototyping)
| Setting | Value |
|---------|-------|
| Layer Height | 0.28 mm |
| Wall Count | 2 |
| Infill | 15% grid |
| Speed | Default (fast) |
| Supports | As needed |
| Bed Temp | 55-60°C |
| Nozzle Temp | 210-220°C |

### PLA — Standard (general purpose)
| Setting | Value |
|---------|-------|
| Layer Height | 0.20 mm |
| Wall Count | 3 |
| Infill | 20% grid |
| Speed | Default |
| Supports | As needed |
| Bed Temp | 55-60°C |
| Nozzle Temp | 210-220°C |

### PLA — Detail (cosmetic parts)
| Setting | Value |
|---------|-------|
| Layer Height | 0.12 mm |
| Wall Count | 4 |
| Infill | 20% grid |
| Speed | Reduced for quality |
| Supports | As needed |
| Bed Temp | 55-60°C |
| Nozzle Temp | 205-215°C |

## ASA Profiles (for heat-resistant parts)

### ASA — Standard
| Setting | Value |
|---------|-------|
| Layer Height | 0.20 mm |
| Wall Count | 3 |
| Infill | 20% grid |
| Speed | Default |
| Supports | As needed |
| Bed Temp | 100-110°C |
| Nozzle Temp | 240-260°C |
| Enclosure | Required (P1S has this) |
| Fan | Reduced (30-50%) |

## Tips for the P1S

- **Textured PEI plate**: Great first-layer adhesion for PLA. Clean with IPA periodically.
- **Smooth PEI plate**: Better for PETG and TPU. PLA may stick too well.
- **Enclosed chamber**: Use it for ASA/ABS. Crack the door for PLA if you notice heat creep.
- **AMS**: If using AMS, ensure filament is dry — PLA is hygroscopic.
- **First layer**: Bambu Studio auto-calibrates, but manual Z-offset tweaks of +/-0.02mm can help.
