// ============================================
// ESP32-WROOM-32 DevKitC + AITRIP Expansion Board
// Measurements — Datasheet-derived placeholders
// ============================================
// UPDATE these values with caliper measurements
// of your actual boards for a precise fit.
// ============================================

// --- ESP32-WROOM-32 DevKitC V4 ---
esp32_pcb_length = 51.5;   // mm (long edge)
esp32_pcb_width  = 28.0;   // mm (short edge)
esp32_pcb_thick  = 1.6;    // mm (FR4 board thickness)
esp32_total_height = 12.0; // mm (tallest component: WROOM RF shield)

// USB-C port on ESP32
usb_c_width  = 8.94;       // mm
usb_c_height = 3.26;       // mm
usb_c_offset_from_edge = 1.0; // mm above PCB surface
usb_c_center_x = esp32_pcb_width / 2; // centered on short edge

// Pin headers (2 rows of 19 pins, 2.54mm pitch)
pin_header_pitch = 2.54;   // mm
pin_header_rows  = 2;
pin_header_pins  = 19;     // per row
pin_header_height = 8.5;   // mm (male pin length below PCB)

// --- AITRIP Expansion Board ---
// These are ESTIMATES — measure your actual board!
exp_board_length = 75.0;   // mm (long edge)
exp_board_width  = 55.0;   // mm (short edge)
exp_board_thick  = 1.6;    // mm (FR4)
exp_board_height = 5.0;    // mm (components below socket headers)

// Socket headers on expansion board
socket_header_height = 8.5; // mm (receives ESP32 pin headers)

// --- Combined Stack ---
// Expansion board sits flat, ESP32 plugs in on top
total_stack_height = exp_board_height + exp_board_thick
                   + socket_header_height + esp32_pcb_thick
                   + esp32_total_height;
// Estimated: ~28-30mm total

// --- Wire Exits ---
// D16 (data) and GND jumper wires exit from expansion board
wire_bundle_diameter = 4.0; // mm (2x F/M jumper wires)

// --- Enclosure Padding ---
// Extra internal space beyond the board dimensions
internal_padding = 1.0;    // mm per side (for wire routing, airflow)
