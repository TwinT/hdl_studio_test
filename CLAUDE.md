# CLAUDE.md — Contexto del proyecto para Claude Code

Repositorio de referencia para la cátedra **Sistemas Digitales (FCEN, UBA)**, mantenido por ayudantes y JTP.

**No es lo que los alumnos clonan.** Es el proyecto completo (con soluciones) a partir del cual se genera una versión para alumnos con partes de los ejercicios a completar. El dev-container y la estructura de carpetas definen el entorno de trabajo que eventualmente usarán los alumnos.

## Stack

| Herramienta | Rol |
|---|---|
| `twint/sd:latest` | Imagen Docker del dev-container (Verilator, slang, surfer preinstalados) |
| Verilator ≥ 5.0 | Simulación (`--timing`, `--trace-fst`) |
| slang | Linter de SystemVerilog (via extensión `mshr-h.veriloghdl`) |
| Surfer | Visor de trazas FST |
| `twint.hdl-studio` | Extensión VS Code principal del curso |

## Estructura

```
ejemplos/
  common.mk          # Reglas make compartidas (sim, wave, clean)
  lib/               # Módulos SV reutilizables (oracle_tb.sv, etc.)
  ej01/              # Ejercicio 1: helloworld (NAND con assign)
    helloworld.sv
    helloworld_tb.sv
    Makefile         # TOP := helloworld_tb; include ../common.mk
  ej02_*/            # Ejercicios 2–6 (sin subdirectorio propio aún)
  ...
.devcontainer/
  devcontainer.json  # Configuración del contenedor y extensiones VS Code
.vscode/
  settings.json      # Configura slang con -y ejemplos/lib
```

## Flujo de trabajo de un ejercicio

Cada ejercicio tiene un `Makefile` mínimo que define `TOP` y `SRCS`, luego incluye `common.mk`.

```makefile
TOP  := helloworld_tb
SRCS := helloworld.sv helloworld_tb.sv
include ../common.mk
```

Targets disponibles desde el directorio del ejercicio:
- `make sim` — compila con Verilator y ejecuta la simulación → genera `build/sim.fst`
- `make wave` — abre `build/sim.fst` en Surfer
- `make clean` — elimina `build/`

`common.mk` incluye automáticamente todos los `.sv` de `ejemplos/lib/` — no hace falta declararlos en `SRCS`.

## Módulos compartidos (`ejemplos/lib/`)

- **`oracle_tb.sv`** — testbench genérico que recorre exhaustivamente las 2ⁿ combinaciones de entradas. Se instancia con `oracle_tb #(.n(2)) oracle (...)`.

## Configuración del linter

`.vscode/settings.json` configura slang para que encuentre módulos en `ejemplos/lib/`:

```json
{
  "verilog.linting.linter": "slang",
  "verilog.linting.slang.args": "-y ${workspaceFolder}/ejemplos/lib --ignore-unknown-modules"
}
```

Si se agregan más carpetas de módulos compartidos, agregar más flags `-y <path>` en ese archivo.
