# Canterbury Press

A parametric 3D printing project hub — designing and building printable models with AI-assisted CAD using OpenSCAD and visual tools.

## Printer

**Bambu Lab P1S** — enclosed CoreXY with 256x256x256mm build volume, textured PEI bed, 0.4mm nozzle. Primary material: PLA.

## Project Structure

```
Canterbury-Press/
├── models/              # Each subdirectory is a separate model project
│   └── <model-name>/
│       ├── src/         # Source files (.scad, .FCStd, .f3d)
│       ├── stl/         # Print-ready STL exports
│       ├── docs/        # Measurements, photos, references
│       └── README.md    # BOM, print settings, assembly notes
├── lib/                 # Shared OpenSCAD parametric modules
│   ├── printer-profile.scad   # P1S specs & calibrated tolerances
│   ├── enclosure-utils.scad   # Box/lid generators, board ledges
│   ├── connectors.scad        # USB-C, barrel jack, JST cutouts
│   ├── ventilation.scad       # Slot, honeycomb, circle vent patterns
│   └── fasteners.scad         # Snap-fits, screw holes, heat-set inserts
├── templates/           # Starter template for new models
│   └── new-model/
├── docs/                # Project-wide documentation
│   ├── getting-started.md     # Tooling setup & workflow guide
│   ├── print-settings.md      # PLA/ASA profiles for the P1S
│   └── library-reference.md   # Shared module API reference
└── Makefile             # Build automation (scad → stl)
```

## Quick Start

### 1. Install Tools

```bash
# Parametric code-based CAD
brew install --cask openscad

# Visual parametric CAD
brew install --cask freecad

# Slicer (download from bambulab.com)
# Bambu Studio or OrcaSlicer
```

### 2. Create a New Model

```bash
cp -r templates/new-model models/my-new-part
```

### 3. Design

**Code-first (OpenSCAD):**
```scad
// models/my-new-part/src/my-part.scad
use <../../lib/printer-profile.scad>
use <../../lib/enclosure-utils.scad>

rounded_box([60, 40, 25], wall = standard_wall, radius = 3);
```

**Visual-first (FreeCAD / Fusion 360):**
- Design in the visual tool
- Save source to `models/<name>/src/`
- Export STL to `models/<name>/stl/`

### 4. Build STL from OpenSCAD

```bash
# Build all models
make

# Build a specific model
make models/my-new-part/stl/my-part.stl

# List available models
make list
```

### 5. Slice and Print

Open the STL in Bambu Studio, apply settings from [docs/print-settings.md](docs/print-settings.md), slice, and send to the P1S.

## Shared Libraries

The `lib/` directory contains reusable OpenSCAD modules shared across all models. See [docs/library-reference.md](docs/library-reference.md) for full API documentation.

| Module | Purpose |
|--------|---------|
| `printer-profile.scad` | P1S build volume, tolerances, wall/layer presets |
| `enclosure-utils.scad` | Rounded boxes, lids, board ledges, screw bosses |
| `connectors.scad` | USB-C, Micro-USB, barrel jack, JST, wire channel cutouts |
| `ventilation.scad` | Slot grids, honeycomb, circular hole vent patterns |
| `fasteners.scad` | Snap-fit hooks/catches, screw holes, heat-set inserts, press-fits |

## Workflow

```
 Measure       Design        Build STL      Slice         Print
 hardware  →  .scad/.FCStd  →  make  →  Bambu Studio  →  P1S
     ↑                                                      │
     └──── calibrate tolerances with test prints ───────────┘
```

## Documentation

- [Getting Started](docs/getting-started.md) — tool installation, project workflow, calibration
- [Print Settings](docs/print-settings.md) — PLA and ASA profiles tuned for the P1S
- [FDM Design Rules](docs/fdm-design-rules.md) — printability rules, overhangs, snap-fits, hole design, material notes
- [Library Reference](docs/library-reference.md) — all shared OpenSCAD modules and their parameters

## AI-Assisted 3D Printing Research

Research into AI tools for 3D model generation, print monitoring, and slicer optimization. See [docs/research/](docs/research/) for the full collection.

| Report | Summary |
|--------|---------|
| [AI Design Guide](docs/research/ai-3d-printing-design-guide.md) | Workflow guide: code-gen pipelines, text-to-CAD platforms, agentic workflows, prompt engineering |
| [DesignBench.ai](docs/research/designbench-ai.md) | LLM-to-OpenSCAD code generation (dormant project, but technique widely adopted) |
| [Hitem3D](docs/research/hitem3d.md) | AI image/text-to-3D mesh generator for organic models |
| [LLM-3D Print (CMU)](docs/research/llm-3d-print.md) | Multi-agent LLM for autonomous real-time print error correction |
| [AI Landscape](docs/research/ai-3d-printing-landscape.md) | Comprehensive survey of text-to-3D, text-to-CAD, print monitoring, and slicer optimization tools |
| [Recommended Tools](docs/research/recommended-tools.md) | Prioritized tool stack for Canterbury Press, organized by implementation tier |

## License

[GNU General Public License v3.0](LICENSE)
