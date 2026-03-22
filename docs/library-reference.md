# Library Reference

API documentation for the shared OpenSCAD modules in `lib/`.

Include modules in your model files with:
```scad
use <../../lib/printer-profile.scad>
use <../../lib/enclosure-utils.scad>
```

> **`use`** imports modules without executing top-level code.
> **`include`** runs everything inline — use it for `printer-profile.scad` when you need its variables directly.

---

## printer-profile.scad

Constants for the Bambu Lab P1S. Include this in any model to reference printer-specific values.

### Build Volume
| Variable | Default | Description |
|----------|---------|-------------|
| `max_build_x` | 256 | Max X dimension (mm) |
| `max_build_y` | 256 | Max Y dimension (mm) |
| `max_build_z` | 256 | Max Z dimension (mm) |

### Tolerances
| Variable | Default | Description |
|----------|---------|-------------|
| `xy_clearance` | 0.2 | Loose-fit gap (lid on box) |
| `press_fit` | 0.1 | Interference fit (snug inserts) |
| `hole_clearance` | 0.3 | Screw/pin hole oversize |
| `snap_fit_clearance` | 0.25 | Snap-fit hook gap |

### Wall Thickness
| Variable | Default | Description |
|----------|---------|-------------|
| `min_wall` | 0.8 | 2 perimeters — absolute minimum |
| `standard_wall` | 1.2 | 3 perimeters — good default |
| `strong_wall` | 2.0 | Structural / screw boss walls |

### Layer Heights
| Variable | Default | Description |
|----------|---------|-------------|
| `draft_layer` | 0.28 | Fast prototyping |
| `standard_layer` | 0.20 | General purpose |
| `detail_layer` | 0.12 | Cosmetic parts |
| `fine_layer` | 0.08 | Maximum detail |

### Floor/Top Thickness
| Variable | Default | Description |
|----------|---------|-------------|
| `min_floor` | 0.8 | 4 layers at 0.2mm |
| `standard_floor` | 1.2 | 6 layers at 0.2mm |

---

## enclosure-utils.scad

Parametric box and lid generators for electronics enclosures.

### `rounded_box(size, wall, radius, floor_h)`

Hollow box with rounded vertical corners, open top.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `size` | — | `[x, y, z]` outer dimensions |
| `wall` | 1.2 | Wall thickness |
| `radius` | 2 | Corner radius |
| `floor_h` | 1.2 | Bottom thickness |

### `rounded_cube(size, radius)`

Solid cube with rounded vertical edges. Used as a building block.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `size` | — | `[x, y, z]` dimensions |
| `radius` | 2 | Corner radius |

### `simple_lid(size, wall, lid_h, lip_h, clearance, radius)`

Flat lid with inner lip that sits inside the box walls.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `size` | — | `[x, y]` matching box outer dimensions |
| `wall` | 1.2 | Box wall thickness |
| `lid_h` | 3 | Total lid height |
| `lip_h` | 2 | Inner lip depth |
| `clearance` | 0.2 | Fit gap (use `xy_clearance`) |
| `radius` | 2 | Corner radius matching box |

### `board_ledge(length, depth, height)`

Internal shelf to rest a PCB on.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `length` | — | Ledge length |
| `depth` | 1.5 | How far it protrudes from wall |
| `height` | 1.0 | Ledge thickness |

### `screw_boss(outer_d, inner_d, height)`

Cylindrical post for self-tapping screws.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `outer_d` | 6 | Boss outer diameter |
| `inner_d` | 2.2 | Pilot hole diameter |
| `height` | 8 | Boss height |

---

## connectors.scad

Cutout shapes for common connectors. Use with `difference()` to subtract from walls.

### `usb_c_cutout(clearance, depth)`

USB-C port (8.94 x 3.26mm with rounded ends).

| Parameter | Default | Description |
|-----------|---------|-------------|
| `clearance` | 0.3 | Extra space around port |
| `depth` | 5 | Wall thickness to cut through |

### `micro_usb_cutout(clearance, depth)`

Micro-USB port (7.5 x 2.5mm rectangular).

| Parameter | Default | Description |
|-----------|---------|-------------|
| `clearance` | 0.3 | Extra space |
| `depth` | 5 | Wall thickness |

### `barrel_jack_cutout(clearance, depth)`

DC barrel jack (5.5mm diameter circular).

| Parameter | Default | Description |
|-----------|---------|-------------|
| `clearance` | 0.3 | Extra space |
| `depth` | 5 | Wall thickness |

### `jst_sm_3pin_cutout(clearance, depth)`

JST-SM 3-pin connector (8.0 x 4.5mm rectangular).

| Parameter | Default | Description |
|-----------|---------|-------------|
| `clearance` | 0.3 | Extra space |
| `depth` | 5 | Wall thickness |

### `wire_channel(diameter, depth)`

Rounded slot for wire bundles.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `diameter` | 4 | Channel diameter |
| `depth` | 5 | Wall thickness |

### `rect_slot(w, h, depth)`

Generic rectangular cutout.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `w` | — | Width |
| `h` | — | Height |
| `depth` | 5 | Wall thickness |

---

## ventilation.scad

Vent patterns for airflow. Subtract from walls or lids.

### `slot_vent(width, height, slots, slot_width, depth)`

Parallel rectangular slot grid.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `width` | — | Total pattern width |
| `height` | — | Total pattern height |
| `slots` | 5 | Number of slots |
| `slot_width` | 1.5 | Width of each slot |
| `depth` | 5 | Wall thickness |

### `honeycomb_vent(width, height, hex_size, wall, depth)`

Hexagonal honeycomb pattern — high airflow with structural strength.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `width` | — | Total pattern width |
| `height` | — | Total pattern height |
| `hex_size` | 5 | Flat-to-flat hex diameter |
| `wall` | 1.2 | Thickness between hexagons |
| `depth` | 5 | Wall thickness |

### `circle_vent(width, height, hole_d, spacing, depth)`

Grid of circular holes.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `width` | — | Total pattern width |
| `height` | — | Total pattern height |
| `hole_d` | 3 | Hole diameter |
| `spacing` | 5 | Center-to-center distance |
| `depth` | 5 | Wall thickness |

---

## fasteners.scad

Mechanical fastening modules for assembly.

### `snap_hook(length, width, thickness, hook_h, clearance)`

Cantilever snap-fit hook for tool-free assembly.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `length` | 8 | Beam length (longer = more flex) |
| `width` | 3 | Beam width |
| `thickness` | 1.0 | Beam thickness |
| `hook_h` | 0.8 | Hook overhang |
| `clearance` | 0.2 | Gap for mating part |

### `snap_catch(width, depth, hook_h, clearance)`

Matching recess for a snap-fit hook.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `width` | 3.4 | Must match hook width + clearance |
| `depth` | 2 | Wall depth |
| `hook_h` | 1.2 | Must match hook overhang + clearance |
| `clearance` | 0.2 | Fit gap |

### `screw_hole(diameter, depth, countersink, cs_diameter)`

Through-hole for screws, with optional countersink.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `diameter` | 3.2 | Shaft clearance diameter |
| `depth` | 5 | Material thickness |
| `countersink` | false | Add countersink cone |
| `cs_diameter` | 6 | Countersink outer diameter |

### `insert_boss(insert_d, insert_h, boss_d, boss_h)`

Hole sized for brass heat-set threaded inserts.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `insert_d` | 4.0 | Insert outer diameter |
| `insert_h` | 5.0 | Insert length |
| `boss_d` | 7.0 | Surrounding boss diameter |
| `boss_h` | 6.0 | Total boss height |

### `press_pin(diameter, height)`

Solid alignment pin for mating parts.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `diameter` | 3 | Pin diameter |
| `height` | 4 | Pin height |

### `press_hole(diameter, depth, clearance)`

Matching hole for a press-fit pin.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `diameter` | 3 | Pin diameter |
| `depth` | 4 | Hole depth |
| `clearance` | 0.1 | Interference fit value |
