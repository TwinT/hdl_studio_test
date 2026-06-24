# common.mk — Reglas compartidas de simulación con Verilator
# ─────────────────────────────────────────────────────────────
# Incluir desde el Makefile de cada ejercicio DESPUÉS de definir:
#
#   TOP  : módulo top-level (ej: helloworld_tb)
#   SRCS : archivos .sv locales al ejercicio (rutas relativas)
#
# Targets:
#   make sim   → compila y ejecuta la simulación → build/sim.fst
#   make wave  → abre build/sim.fst en surfer
#   make clean → elimina build/
#
# Requiere: Verilator ≥ 5.0 (para --timing) y surfer en el PATH.

# Directorio de este archivo (siempre ejemplos/) — funciona aunque
# sea incluido desde subdirectorios.
_COMMON_MK_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
LIB_DIR        := $(_COMMON_MK_DIR)lib

BUILD_DIR := build
SIM_BIN   := $(BUILD_DIR)/obj_dir/V$(TOP)
FST_FILE  := $(BUILD_DIR)/sim.fst

# Todos los .sv de lib/ se incluyen automáticamente.
# Para agregar una nueva dependencia compartida basta con
# colocar el archivo en ejemplos/lib/.
LIB_SRCS := $(wildcard $(LIB_DIR)/*.sv)
ALL_SRCS  := $(LIB_SRCS) $(SRCS)

VERILATOR_FLAGS := \
  --binary    \
  --trace-fst \
  --timing    \
  -sv         \
  --top-module $(TOP) \
  -Mdir $(BUILD_DIR)/obj_dir

.PHONY: sim wave clean

sim: $(FST_FILE)

# Compilación: regenerar el binario si cambia alguna fuente
$(SIM_BIN): $(ALL_SRCS)
	@mkdir -p $(BUILD_DIR)
	verilator $(VERILATOR_FLAGS) $(ALL_SRCS)

# Simulación: regenerar el FST si el binario cambió
$(FST_FILE): $(SIM_BIN)
	./$(SIM_BIN)

wave: $(FST_FILE)
	WAYLAND_DISPLAY= WINIT_UNIX_BACKEND=x11 surfer $(FST_FILE); \

wave2: $(FST_FILE)
	code $(FST_FILE)

clean:
	rm -rf $(BUILD_DIR)
