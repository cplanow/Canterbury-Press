// ============================================
// Fastener Library
// ============================================
// Parametric modules for mechanical fastening:
// snap-fits, screw holes, press-fit pins, etc.
// ============================================

// --- Snap-Fit Hook ---
// Cantilever snap-fit hook for tool-free assembly.
//   length    = beam length (longer = more flex)
//   width     = beam width
//   thickness = beam thickness
//   hook_h    = hook overhang height
//   clearance = gap for mating part
module snap_hook(length = 8, width = 3, thickness = 1.0, hook_h = 0.8, clearance = 0.2) {
    // Cantilever beam
    cube([width, thickness, length]);

    // Hook tip
    translate([0, 0, length])
        cube([width, thickness + hook_h, thickness]);
}

// --- Snap-Fit Catch ---
// Matching recess for a snap-fit hook.
//   width     = must match hook width + clearance
//   depth     = wall depth for the catch slot
//   hook_h    = must match hook overhang height + clearance
//   clearance = fit gap
module snap_catch(width = 3.4, depth = 2, hook_h = 1.2, clearance = 0.2) {
    w = width + clearance;
    cube([w, depth, hook_h + clearance]);
}

// --- Screw Hole (through-hole) ---
//   diameter  = screw shaft clearance diameter
//   depth     = material thickness
//   countersink = if true, adds a countersink cone
//   cs_diameter = countersink outer diameter
module screw_hole(diameter = 3.2, depth = 5, countersink = false, cs_diameter = 6) {
    cylinder(d = diameter, h = depth, $fn = 24);
    if (countersink) {
        translate([0, 0, depth - (cs_diameter - diameter) / 2])
            cylinder(d1 = diameter, d2 = cs_diameter,
                     h = (cs_diameter - diameter) / 2, $fn = 24);
    }
}

// --- Heat-Set Insert Boss ---
// Hole sized for a brass heat-set insert.
//   insert_d = insert outer diameter
//   insert_h = insert length
//   boss_d   = surrounding boss diameter
//   boss_h   = total boss height
module insert_boss(insert_d = 4.0, insert_h = 5.0, boss_d = 7.0, boss_h = 6.0) {
    difference() {
        cylinder(d = boss_d, h = boss_h, $fn = 32);
        translate([0, 0, boss_h - insert_h])
            cylinder(d = insert_d, h = insert_h + 0.1, $fn = 32);
    }
}

// --- Press-Fit Pin ---
// Solid pin for alignment between mating parts.
//   diameter = pin diameter
//   height   = pin height
module press_pin(diameter = 3, height = 4) {
    cylinder(d = diameter, h = height, $fn = 24);
}

// --- Press-Fit Hole ---
// Matching hole for a press-fit pin.
//   diameter  = pin diameter + press_fit tolerance
//   depth     = hole depth
//   clearance = interference fit value
module press_hole(diameter = 3, depth = 4, clearance = 0.1) {
    cylinder(d = diameter - clearance, h = depth, $fn = 24);
}
