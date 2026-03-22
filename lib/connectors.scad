// ============================================
// Connector Cutout Library
// ============================================
// Parametric cutout shapes for common connectors.
// Use difference() to subtract these from enclosure walls.
//
// All modules create a solid shape meant to be subtracted.
// Position with translate() before subtracting.
// ============================================

// --- USB-C Port Cutout ---
//   clearance = extra space around the port
//   depth     = wall thickness to cut through
module usb_c_cutout(clearance = 0.3, depth = 5) {
    w = 8.94 + clearance;   // USB-C width
    h = 3.26 + clearance;   // USB-C height
    r = h / 2;              // USB-C has fully rounded ends
    hull() {
        translate([r, 0, r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = depth, $fn = 24);
        translate([w - r, 0, r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = depth, $fn = 24);
    }
}

// --- Micro-USB Port Cutout ---
//   clearance = extra space around the port
//   depth     = wall thickness to cut through
module micro_usb_cutout(clearance = 0.3, depth = 5) {
    w = 7.5 + clearance;
    h = 2.5 + clearance;
    translate([0, 0, 0])
        cube([w, depth, h]);
}

// --- DC Barrel Jack Cutout (5.5x2.1mm) ---
//   clearance = extra space
//   depth     = wall thickness
module barrel_jack_cutout(clearance = 0.3, depth = 5) {
    d = 5.5 + clearance;
    translate([d / 2, 0, d / 2])
        rotate([-90, 0, 0])
            cylinder(d = d, h = depth, $fn = 32);
}

// --- JST-SM 3-Pin Connector Cutout ---
//   clearance = extra space
//   depth     = wall thickness
module jst_sm_3pin_cutout(clearance = 0.3, depth = 5) {
    w = 8.0 + clearance;
    h = 4.5 + clearance;
    cube([w, depth, h]);
}

// --- Generic Wire Channel ---
// Rounded slot for wires to pass through a wall.
//   diameter = channel diameter (size for your wire bundle)
//   depth    = wall thickness to cut through
module wire_channel(diameter = 4, depth = 5) {
    translate([diameter / 2, 0, diameter / 2])
        rotate([-90, 0, 0])
            cylinder(d = diameter, h = depth, $fn = 24);
}

// --- Rectangular Slot ---
// Simple rectangular cutout for generic openings.
//   w     = width
//   h     = height
//   depth = wall thickness
module rect_slot(w, h, depth = 5) {
    cube([w, depth, h]);
}
