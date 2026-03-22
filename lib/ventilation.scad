// ============================================
// Ventilation Pattern Library
// ============================================
// Parametric vent patterns for enclosures.
// Subtract these from walls/lids for airflow.
// ============================================

// --- Slot Vent Grid ---
// Parallel rectangular slots.
//   width       = total pattern width
//   height      = total pattern height
//   slots       = number of slots
//   slot_width  = width of each slot opening
//   depth       = wall thickness to cut through
module slot_vent(width, height, slots = 5, slot_width = 1.5, depth = 5) {
    slot_spacing = width / slots;
    for (i = [0 : slots - 1]) {
        translate([i * slot_spacing + (slot_spacing - slot_width) / 2, 0, 0])
            cube([slot_width, depth, height]);
    }
}

// --- Honeycomb Vent ---
// Hexagonal pattern for high airflow with strength.
//   width      = total pattern width
//   height     = total pattern height
//   hex_size   = flat-to-flat diameter of each hexagon
//   wall       = thickness between hexagons
//   depth      = wall thickness to cut through
module honeycomb_vent(width, height, hex_size = 5, wall = 1.2, depth = 5) {
    spacing_x = hex_size + wall;
    spacing_y = (hex_size + wall) * sin(60);
    cols = floor(width / spacing_x);
    rows = floor(height / spacing_y);

    intersection() {
        // Clip to bounding box
        cube([width, depth, height]);

        // Hexagon array
        for (row = [0 : rows]) {
            offset_x = (row % 2 == 0) ? 0 : spacing_x / 2;
            for (col = [0 : cols]) {
                x = col * spacing_x + offset_x + hex_size / 2;
                z = row * spacing_y + hex_size / 2;
                if (x > 0 && x < width && z > 0 && z < height)
                    translate([x, 0, z])
                        rotate([-90, 0, 0])
                            cylinder(d = hex_size, h = depth, $fn = 6);
            }
        }
    }
}

// --- Circular Vent Array ---
// Grid of circular holes.
//   width    = total pattern width
//   height   = total pattern height
//   hole_d   = hole diameter
//   spacing  = center-to-center distance
//   depth    = wall thickness
module circle_vent(width, height, hole_d = 3, spacing = 5, depth = 5) {
    cols = floor(width / spacing);
    rows = floor(height / spacing);

    intersection() {
        cube([width, depth, height]);
        for (col = [0 : cols]) {
            for (row = [0 : rows]) {
                x = col * spacing + spacing / 2;
                z = row * spacing + spacing / 2;
                if (x < width && z < height)
                    translate([x, 0, z])
                        rotate([-90, 0, 0])
                            cylinder(d = hole_d, h = depth, $fn = 20);
            }
        }
    }
}
