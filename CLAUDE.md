# Canterbury Press — Project Instructions

## Overview
Canterbury Press is a parametric 3D printing project hub. Models are designed in OpenSCAD (code-first) and/or FreeCAD/Fusion 360 (visual-first), then sliced and printed on a Bambu Lab P1S.

## Printer
- **Bambu Lab P1S** — enclosed CoreXY, 256x256x256mm build volume
- **Nozzle:** 0.4mm
- **Bed:** Textured PEI
- **Primary material:** PLA
- **Slicer:** Bambu Studio / OrcaSlicer

## Project Layout
- `models/<name>/` — individual model projects (src, stl, docs)
- `lib/` — shared OpenSCAD modules (printer profile, enclosures, connectors, vents, fasteners)
- `templates/new-model/` — copy to start a new model project
- `docs/` — project-wide documentation
- `Makefile` — builds `.scad` → `.stl`

## Conventions

### Creating New Models
Always copy `templates/new-model/` into `models/<descriptive-name>/` as the starting point.

### OpenSCAD Files
- Use `include <../../lib/printer-profile.scad>` for printer constants and tolerances
- Use `use <../../lib/enclosure-utils.scad>` (etc.) for module libraries
- Separate measurements/dimensions into their own file (e.g., `measurements.scad`)
- All dimensions in millimeters

### Tolerances
- Always reference `lib/printer-profile.scad` for clearance values — never hardcode tolerances
- Tolerance values are starting points; update after calibration test prints

### STL Files
- Generated STLs go in `models/<name>/stl/`
- Run `make` to build from OpenSCAD sources
- STLs are tracked in git for easy sharing

### FDM Printability Rules
- Reference `docs/fdm-design-rules.md` for comprehensive FDM design guidelines
- No unsupported overhangs beyond 45° — redesign or add supports
- Bridges up to 20mm are reliable; beyond that, add support geometry
- Minimum horizontal hole diameter: 2mm; use teardrop shapes for horizontal holes
- Snap-fit arms: minimum 1.2mm thick, 8-12mm long, deflect along layer lines
- Use heat-set inserts over printed threads for M3+
- Chamfer bottom edges 0.4mm to hide elephant foot

### Design Principles
- Parametric first — dimensions are variables, not magic numbers
- Design for printability — minimize supports, use flat bottom faces
- Reuse shared libraries — add new common patterns to `lib/` when they'll be used across models

### CadQuery (Alternative to OpenSCAD)
- Use CadQuery (Python) when parts need fillets, chamfers, sweeps, or STEP export
- CadQuery source files go in `models/<name>/src/*.py`
- Install with `pip install cadquery`
