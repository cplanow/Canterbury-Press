// ============================================
// Enclosure Utilities
// ============================================
// Generic parametric box and lid generators.
// Use these as building blocks for any enclosure.
// ============================================

use <printer-profile.scad>

// --- Rounded Box (hollow) ---
// Creates a hollow box with rounded corners.
//   size     = [x, y, z] outer dimensions
//   wall     = wall thickness
//   radius   = corner radius
//   floor_h  = bottom thickness
module rounded_box(size, wall = 1.2, radius = 2, floor_h = 1.2) {
    difference() {
        // Outer shell
        rounded_cube(size, radius);
        // Inner cavity
        translate([wall, wall, floor_h])
            rounded_cube([
                size[0] - 2 * wall,
                size[1] - 2 * wall,
                size[2]  // open top
            ], max(radius - wall, 0.1));
    }
}

// --- Rounded Cube (solid) ---
// A cube with rounded vertical edges.
//   size   = [x, y, z]
//   radius = corner radius
module rounded_cube(size, radius = 2) {
    r = min(radius, min(size[0], size[1]) / 2 - 0.01);
    hull() {
        for (x = [r, size[0] - r])
            for (y = [r, size[1] - r])
                translate([x, y, 0])
                    cylinder(h = size[2], r = r, $fn = 32);
    }
}

// --- Simple Lid ---
// A flat lid that sits on top of a box.
//   size       = [x, y] matching box outer dimensions
//   wall       = wall thickness of the box it fits
//   lid_h      = total lid height
//   lip_h      = inner lip depth (fits inside box)
//   clearance  = gap for fit (use xy_clearance from printer-profile)
//   radius     = corner radius matching the box
module simple_lid(size, wall = 1.2, lid_h = 3, lip_h = 2, clearance = 0.2, radius = 2) {
    top_thickness = lid_h - lip_h;

    // Outer cap
    rounded_cube([size[0], size[1], top_thickness], radius);

    // Inner lip
    translate([wall + clearance, wall + clearance, -lip_h])
        rounded_cube([
            size[0] - 2 * (wall + clearance),
            size[1] - 2 * (wall + clearance),
            lip_h + 0.01  // slight overlap to merge with cap
        ], max(radius - wall, 0.1));
}

// --- Board Ledge ---
// Internal ledge/shelf to rest a PCB on.
//   length   = ledge length along the wall
//   depth    = how far the ledge sticks out from the wall
//   height   = ledge thickness
module board_ledge(length, depth = 1.5, height = 1.0) {
    cube([length, depth, height]);
}

// --- Screw Boss ---
// Cylindrical post for self-tapping screws.
//   outer_d = outer diameter of the boss
//   inner_d = pilot hole diameter
//   height  = boss height
module screw_boss(outer_d = 6, inner_d = 2.2, height = 8) {
    difference() {
        cylinder(d = outer_d, h = height, $fn = 32);
        translate([0, 0, -0.1])
            cylinder(d = inner_d, h = height + 0.2, $fn = 24);
    }
}
