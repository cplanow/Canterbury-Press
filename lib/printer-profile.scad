// ============================================
// Printer Profile: Bambu Lab P1S
// ============================================
// Central source of truth for printer-specific
// constraints and tolerances. Include this in
// any model that needs to respect hardware limits.
//
// IMPORTANT: Tune tolerance values after running
// a calibration/tolerance test print on YOUR machine.
// ============================================

// --- Build Volume (mm) ---
max_build_x = 256;
max_build_y = 256;
max_build_z = 256;

// --- Nozzle ---
nozzle_diameter = 0.4;

// --- Tolerances (mm) ---
// Start conservative, tighten after test prints
xy_clearance      = 0.2;   // gap for loose-fit parts (lid on box)
press_fit         = 0.1;   // interference fit (snug inserts)
hole_clearance    = 0.3;   // oversized holes for screws/pins
snap_fit_clearance = 0.25; // snap-fit hooks and catches

// --- Wall Thickness (mm) ---
min_wall        = 0.8;   // 2 perimeters — absolute minimum
standard_wall   = 1.2;   // 3 perimeters — good default
strong_wall     = 2.0;   // structural / screw boss walls

// --- Layer Height Presets (mm) ---
draft_layer    = 0.28;
standard_layer = 0.20;
detail_layer   = 0.12;
fine_layer     = 0.08;

// --- Bottom/Top Thickness (mm) ---
// Should be a multiple of layer height
min_floor    = 0.8;   // 4 layers at 0.2mm
standard_floor = 1.2; // 6 layers at 0.2mm

// --- Bed ---
bed_type = "textured_pei";

// --- Material Defaults ---
// Override per-project as needed
default_material = "PLA";
