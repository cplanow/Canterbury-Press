# FDM Design Rules — Bambu Lab P1S

Printability rules and design guidelines for FDM (Fused Deposition Modeling) on the P1S with a 0.4mm nozzle. Reference these when designing parts in OpenSCAD, FreeCAD, or when prompting an LLM to generate CAD code.

These rules complement the dimensional constants in `lib/printer-profile.scad`.

---

## Dimensional Rules

| Rule | Value | Notes |
|------|-------|-------|
| Minimum wall thickness | 0.8mm | 2 perimeters x 0.4mm nozzle |
| Standard wall thickness | 1.2mm | 3 perimeters — good default for most parts |
| Structural / screw boss walls | 2.0mm minimum | Load-bearing features |
| XY clearance (loose fit) | 0.2mm per side | Lid on box, sliding parts |
| Press-fit interference | 0.1mm per side | Snug inserts, friction-held parts |
| Hole clearance for screws/pins | +0.3mm over nominal diameter | e.g., M3 screw = 3.3mm hole |
| Maximum build volume | 256 x 256 x 256mm | P1S limit |

---

## Overhang and Bridging Rules

| Rule | Value | Notes |
|------|-------|-------|
| Maximum unsupported overhang | 45° from vertical | Beyond this, add supports or redesign |
| Reliable bridge span | Up to 20mm | Beyond 20mm, add support geometry or redesign |
| Bridge speed | Slower than normal | Bambu Studio handles this automatically |

**Design strategies to avoid supports:**
- Orient flat faces downward (print on the bed)
- Use chamfers (45°) instead of fillets on bottom edges
- Split parts and print flat, then assemble
- Use teardrop or keyhole shapes for horizontal holes

---

## Hole Design Rules

| Rule | Value | Notes |
|------|-------|-------|
| Minimum horizontal hole diameter | 2mm | Smaller holes tend to close up |
| Vertical holes | Print well at most sizes | No special treatment needed |
| Horizontal holes | Use teardrop/keyhole shapes | The top of a horizontal circle sags without support |
| Hole tolerance | +0.3mm over nominal | Compensates for shrinkage and first-layer expansion |

### Teardrop Hole Profile

For horizontal holes, replace circles with teardrops to avoid the unsupported overhang at the top:

```
    /\         ← pointed top (45° sides, self-supporting)
   /  \
  |    |       ← circular body
  |    |
   \  /
    \/
```

---

## First Layer Effects

| Rule | Value | Notes |
|------|-------|-------|
| Elephant foot expansion | ~0.1-0.2mm | First layer squishes wider than designed |
| Chamfer bottom edges | 0.4mm at 45° | Hides elephant foot visually |
| First layer height | Usually 0.2mm regardless of layer height | Bambu auto-calibrates |

---

## Snap-Fit Design Rules

| Rule | Value | Notes |
|------|-------|-------|
| Minimum arm thickness | 1.2mm | Thinner arms crack during deflection |
| Recommended arm thickness | 1.5-2.0mm | Balance between flex and strength |
| Arm length | 8-12mm | Longer = more flex = easier assembly |
| Hook overhang | 0.8-1.5mm | Enough to catch but not block assembly |
| Draft angle on hooks | 15-30° | Eases insertion |
| Deflection direction | Along layer lines | Across layer lines = weak, prone to delamination |

**Critical:** Print orientation matters for snap-fits. The flexure arm should bend *along* the layer lines, not across them. Across-layer bending causes layer separation under stress.

---

## Thread and Fastener Rules

| Rule | Value | Notes |
|------|-------|-------|
| Printed threads | Avoid for M3+ | Use heat-set inserts instead |
| Heat-set insert holes | Sized per manufacturer spec | Typically insert OD - 0.1mm for PLA |
| Self-tapping screw pilots | 2.0-2.2mm for M3 | In a 6mm OD boss |
| Screw boss height | 6-8mm minimum | Enough thread engagement |
| Press-fit pin holes | Pin diameter - 0.1mm | Interference fit |

**Heat-set inserts are strongly preferred** over printed threads for M3 and larger. They provide metal-to-metal thread engagement, consistent clamping force, and can be installed in seconds with a soldering iron.

---

## Material-Specific Notes

### PLA (Primary Material)

- Glass transition: ~60°C — parts soften in hot environments (car dashboard, near electronics under load)
- Easy to print, minimal warping
- Good for prototypes and low-stress functional parts
- Brittle under sharp impact

### PETG

- Better layer adhesion than PLA
- Slight stringing — tune retraction
- Good for functional parts that need flexibility
- Chemical resistant

### ABS / ASA (Requires P1S Enclosed Chamber)

- ABS glass transition: ~105°C — heat resistant
- ASA: UV resistant — good for outdoor use
- Warp-prone — use enclosed chamber, brim, and 100-110°C bed
- Better for high-stress functional parts

### TPU (Flexible)

- Print at 30-40mm/s (slow)
- Direct drive compatible (P1S is direct drive)
- Good for gaskets, bumpers, flexible hinges
- Cannot bridge — design accordingly

---

## Multi-Material / AMS Design Rules

| Rule | Value | Notes |
|------|-------|-------|
| Available slots | 4 filament types/colors | Via AMS |
| Color change time | ~30 seconds per swap | Adds print time |
| Purge tower waste | ~3-5g per change | Unavoidable with AMS |
| Design strategy | Minimize color transitions | Fewer changes = less waste and faster prints |
| Soluble supports | PVA in AMS slot | Dissolves in water — complex support geometry possible |

---

## LLM Prompt Context Block

Include this block in system prompts or `CLAUDE.md` when using an LLM to generate CAD code for the P1S:

```
## 3D Printing Design Constraints (Bambu Lab P1S, 0.4mm nozzle, PLA)

### Dimensional Rules (MUST follow)
- Minimum wall thickness: 0.8mm (2 perimeters x 0.4mm nozzle)
- Standard wall thickness: 1.2mm (3 perimeters — use as default)
- Structural/screw boss walls: 2.0mm minimum
- XY clearance for loose fit (lid on box): 0.2mm per side
- Press-fit interference: 0.1mm per side
- Hole clearance for screws/pins: +0.3mm over nominal diameter
- Maximum build volume: 256 x 256 x 256mm

### Layer Height Options
- Fine detail: 0.08mm
- Standard: 0.20mm (default)
- Draft: 0.28mm
- Standard floor/ceiling: 1.2mm (6 layers at 0.20mm)

### FDM Design Rules (MUST follow)
- No unsupported overhangs beyond 45° without support or bridging
- Bridges up to 20mm are reliable; beyond that, add support geometry
- Minimum horizontal hole diameter: 2mm (smaller holes close up)
- Vertical holes print well; horizontal holes need teardrop/keyhole shapes
- Elephant foot compensation: first layer expands ~0.1-0.2mm
- Snap fits: flexure arms minimum 1.2mm thick, 8-12mm long
- Thread features: use heat-set inserts over printed threads for M3+
- Chamfer bottom edges 0.4mm to avoid elephant foot visibility
```
