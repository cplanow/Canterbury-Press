# Getting Started

## Required Software

### OpenSCAD (Code-based parametric CAD)
```bash
brew install --cask openscad
```
- Open `.scad` files directly
- Preview with F5, render with F6
- Export STL with F7

### FreeCAD (Visual parametric CAD)
```bash
brew install --cask freecad
```
- Use the **Part Design** workbench for solid modeling
- Export as STL from File > Export

### Bambu Studio (Slicer)
Download from [bambulab.com](https://bambulab.com/en/download/studio)
- Import STL files
- Slice and send directly to your P1S

## Project Structure

```
3dPrinter/
├── models/          # Each subdirectory is a separate model project
├── lib/             # Shared OpenSCAD modules (include in your models)
├── templates/       # Copy new-model/ to start a new project
├── docs/            # Project-wide documentation
└── Makefile         # Build automation
```

## Starting a New Model

1. Copy the template:
   ```bash
   cp -r templates/new-model models/my-new-part
   ```

2. Add your design files to `models/my-new-part/src/`

3. For OpenSCAD models, include shared libraries:
   ```scad
   use <../../lib/printer-profile.scad>
   use <../../lib/enclosure-utils.scad>
   use <../../lib/connectors.scad>
   ```

4. Build STL from OpenSCAD source:
   ```bash
   make models/my-new-part/stl/my-new-part.stl
   ```

5. Open the STL in Bambu Studio, slice, and print.

## Workflow

### Visual-first (FreeCAD / Fusion 360)
1. Design in the visual tool
2. Export STL to `models/<name>/stl/`
3. Save source file (`.FCStd` / `.f3d`) to `models/<name>/src/`

### Code-first (OpenSCAD)
1. Write `.scad` in `models/<name>/src/`
2. Use shared libs from `lib/`
3. Run `make` to generate STL

### Hybrid
1. Prototype visually to nail the shape
2. Recreate parametrically in OpenSCAD for reusability
3. Use OpenSCAD as the source of truth going forward

## Calibration

Before your first functional print, run a tolerance test:
1. Print a tolerance test model (many free ones on Printables/Thingiverse)
2. Update `lib/printer-profile.scad` with your actual clearance values
3. All future models inherit the corrected values
