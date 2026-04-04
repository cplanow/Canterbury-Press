// ============================================
// ESP32 + WLED Enclosure — Proof of Concept
// ============================================
// Two-piece snap-fit enclosure for AITRIP
// ESP32-WROOM-32 DevKitC on expansion board.
//
// Designed for Bambu Lab P1S, PLA, 0.4mm nozzle.
// ============================================

include <../../../lib/printer-profile.scad>
include <measurements.scad>
use <../../../lib/enclosure-utils.scad>
use <../../../lib/connectors.scad>
use <../../../lib/ventilation.scad>

// --- Enclosure Dimensions ---
wall = standard_wall;       // 1.2mm (3 perimeters)
floor_h = standard_floor;   // 1.2mm

// Internal cavity sized to expansion board + padding
inner_x = exp_board_length + 2 * internal_padding;
inner_y = exp_board_width  + 2 * internal_padding;
inner_z = total_stack_height + 3; // +3mm headroom above ESP32

// Outer dimensions
outer_x = inner_x + 2 * wall;
outer_y = inner_y + 2 * wall;
outer_z = inner_z + floor_h;

corner_r = 3; // corner radius

// --- Bottom Shell ---
module bottom_shell() {
    difference() {
        // Main box
        rounded_box([outer_x, outer_y, outer_z],
                    wall = wall, radius = corner_r, floor_h = floor_h);

        // USB-C cutout (centered on short edge, at ESP32 height)
        usb_z = floor_h + exp_board_height + exp_board_thick
              + socket_header_height + usb_c_offset_from_edge;
        translate([outer_x / 2 - usb_c_width / 2 - xy_clearance,
                   -0.1,
                   usb_z])
            usb_c_cutout(clearance = xy_clearance, depth = wall + 0.2);

        // Wire channel (opposite end for D16 + GND jumpers)
        wire_z = floor_h + exp_board_height + 2;
        translate([outer_x / 2 - wire_bundle_diameter / 2,
                   outer_y - wall - 0.1,
                   wire_z])
            wire_channel(diameter = wire_bundle_diameter, depth = wall + 0.2);

        // Ventilation slots on left side
        vent_z = floor_h + 5;
        translate([-0.1, outer_y * 0.2, vent_z])
            rotate([0, 0, 0])
                slot_vent(width = outer_y * 0.6, height = inner_z * 0.5,
                         slots = 4, slot_width = 1.5, depth = wall + 0.2);

        // Ventilation slots on right side
        translate([outer_x - wall, outer_y * 0.2, vent_z])
            slot_vent(width = outer_y * 0.6, height = inner_z * 0.5,
                     slots = 4, slot_width = 1.5, depth = wall + 0.2);
    }

    // Board ledges (support the expansion board)
    ledge_z = floor_h;
    ledge_len = 15;

    // Left side ledges (front and back)
    translate([wall, wall, ledge_z])
        board_ledge(ledge_len, depth = 1.5, height = exp_board_height);
    translate([wall, outer_y - wall - ledge_len, ledge_z])
        board_ledge(ledge_len, depth = 1.5, height = exp_board_height);

    // Right side ledges (front and back)
    translate([outer_x - wall - 1.5, wall, ledge_z])
        board_ledge(ledge_len, depth = 1.5, height = exp_board_height);
    translate([outer_x - wall - 1.5, outer_y - wall - ledge_len, ledge_z])
        board_ledge(ledge_len, depth = 1.5, height = exp_board_height);
}

// --- Lid ---
module lid() {
    lid_h = 3;
    lip_h = 2;

    difference() {
        simple_lid([outer_x, outer_y],
                   wall = wall, lid_h = lid_h, lip_h = lip_h,
                   clearance = xy_clearance, radius = corner_r);

        // Top ventilation (honeycomb)
        translate([outer_x * 0.15, -0.1, 0.8])
            rotate([90, 0, 0])
                rotate([0, 0, 90])
                    honeycomb_vent(width = outer_x * 0.7,
                                  height = outer_y * 0.7,
                                  hex_size = 5, wall = 1.2,
                                  depth = lid_h + 0.2);
    }
}

// --- Render ---
// Show bottom shell
bottom_shell();

// Show lid offset to the side for printing
translate([outer_x + 10, 0, 0])
    lid();
