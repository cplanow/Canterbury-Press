# ============================================
# 3D Printer Project — Build Automation
# ============================================
# Converts OpenSCAD source files to STL.
#
# Usage:
#   make all                          — build all models
#   make models/<name>/stl/<file>.stl — build one specific STL
#   make clean                        — remove all generated STLs
#   make list                         — show all available models
# ============================================

OPENSCAD := openscad
LIB_DIR  := lib

# Find all .scad source files in models/*/src/
SCAD_SOURCES := $(wildcard models/*/src/*.scad)

# Map source files to STL outputs: models/<name>/src/foo.scad → models/<name>/stl/foo.stl
STL_OUTPUTS := $(patsubst models/%/src/%.scad,models/%/stl/%.stl,$(SCAD_SOURCES))

# Default: build everything
.PHONY: all clean list

all: $(STL_OUTPUTS)

# Pattern rule: compile .scad → .stl
models/%/stl/%.stl: models/%/src/%.scad $(wildcard $(LIB_DIR)/*.scad)
	@mkdir -p $(dir $@)
	$(OPENSCAD) -o $@ $<

# Clean all generated STLs
clean:
	find models -name "*.stl" -path "*/stl/*" -delete

# List all model projects
list:
	@echo "Available models:"
	@ls -d models/*/ 2>/dev/null | sed 's|models/||;s|/||' || echo "  (none yet)"
