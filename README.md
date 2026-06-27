# hdl_studio_test

Este repositorio contiene los ejercicios de SystemVerilog de la materia **Sistemas Digitales (FCEN, UBA)**. Es el proyecto **completo** (con soluciones y testbenches listos); a partir de él se _tendría_ que generar la versión para alumnos con los módulos a completar.

---

## Prerrequisitos

La única dependencia local es **Docker** con soporte para **Dev Containers**.

1. Instalar [Docker Desktop](https://www.docker.com/products/docker-desktop/) (o Docker Engine en Linux).
2. Instalar VS Code con la extensión **Dev Containers** (`ms-vscode-remote.remote-containers`).
3. Abrir la carpeta del repo en VS Code → aparece el prompt *"Reopen in Container"* → aceptar.

El contenedor descarga la imagen `twint/sd:latest`, que ya incluye Verilator ≥ 5.0, slang y Surfer. No hace falta instalar nada más en la máquina host.

> **Linux con Wayland:** el devcontainer usa X11 para Surfer. Si el host corre Wayland puro, verificar que `DISPLAY` esté seteado y que `xhost +local:root` funcione (el `initializeCommand` del devcontainer lo hace automáticamente).

---

## Extensiones VS Code instaladas en el contenedor

| Extensión | ID | Rol |
|---|---|---|
| HDL Studio | `twint.hdl-studio` | Integración principal del curso (síntesis visual, etc.) |
| Surfer | `surfer-project.surfer` | Visor de trazas FST integrado en VS Code |
| slang-server | `Hudson-River-Trading.vscode-slang` | LSP de SystemVerilog (linting, navegación, autocompletado) |
| VaporView | `lramseyer.vaporview` | Visor alternativo de waveforms |

La configuración del linter slang-server está en `.slang/server.json`: indexa todo `ejercicios/` e ignora los directorios `build/` generados por Verilator.

---

## Estructura del repositorio

```
ejercicios/
  common.mk          # Reglas make compartidas por todos los ejercicios
  lib/               # Módulos SV reutilizables (disponibles en todos los ejercicios)
    oracle_tb.sv
  ej01/              # Cada ejercicio en su propio directorio
    helloworld.sv    # Módulo bajo prueba (diseño del alumno)
    helloworld_tb.sv # Testbench listo
    Makefile         # Define TOP y SRCS, incluye common.mk
    signals.sucl     # Configuración de señales para Surfer
    build/           # Generado por Verilator — no versionar (en .gitignore)
  ej02/ ...
.devcontainer/
  devcontainer.json  # Config del contenedor y extensiones
.slang/
  server.json        # Config del LSP slang-server
```

---

## Cómo funciona un ejercicio

Cada ejercicio tiene:

- **Un archivo de diseño** (ej. `helloworld.sv`) con el módulo de ejemplo y el stub que el alumno debe completar.
- **Un testbench** (`helloworld_tb.sv`) que verifica el diseño exhaustivamente usando `oracle_tb` u otras herramientas de verificación.
- **Un Makefile mínimo** que declara el top-level y las fuentes, y delega el resto a `common.mk`.

### El Makefile de cada ejercicio

```makefile
TOP      := helloworld_tb       # nombre del módulo top-level (el testbench)
SRCS     := helloworld.sv helloworld_tb.sv   # fuentes locales del ejercicio
CMD_FILE := $(wildcard *.sucl)  # archivo de señales para Surfer (opcional)

include ../common.mk
```

`common.mk` agrega automáticamente todos los `.sv` de `ejercicios/lib/`, así que **no hay que declararlos en `SRCS`**.

### Targets disponibles

Ejecutar desde el directorio del ejercicio:

| Comando | Qué hace |
|---|---|
| `make sim` | Compila con Verilator y ejecuta la simulación → genera `build/sim.fst` |
| `make wave` | Abre `build/sim.fst` en Surfer (con las señales del `.sucl` si existe) |
| `make wave_code` | Abre el `.fst` en el visor de VS Code |
| `make clean` | Elimina el directorio `build/` |

`make sim` es incremental: recompila solo si cambia alguna fuente.

---

## El módulo `oracle_tb` (lib/)

`oracle_tb` es el testbench genérico que recorre exhaustivamente las 2ⁿ combinaciones de entradas. Se parametriza con `N` (número de bits de entrada) y expone una señal `pass` que el testbench específico debe conectar con la condición de corrección del DUT.

```systemverilog
oracle_tb #(.N(2)) oracle (
    .clk,
    .rst,
    .pass,   // 1 cuando la salida del DUT es correcta para el valor actual
    .done,   // 1 cuando terminó de probar todas las combinaciones
    .value,  // vector de N bits que representa la combinación actual
    .dv()    // data valid, para módulos que necesitan un pulso de validación (opcional) 
);
```

El oracle imprime en consola cada combinación que falla y al final muestra PASS o FAIL con color.

---

## Patrón de testbench

Todos los testbenches siguen esta estructura (ver `ej01/helloworld_tb.sv` como referencia):

```systemverilog
module mi_modulo_tb;

  // Clock & Reset
  logic clk = 0;
  always #5 clk = ~clk;

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // Señales
  logic [N-1:0] value;
  logic result, pass, done;

  // Desempaquetar value en entradas individuales del DUT (si aplica)
  // assign {a, b, c} = value;

  // DUT
  mi_modulo dut (.in(value), .out(result));

  // Condición de corrección
  assign pass = (result == <expresión esperada>);

  // Oracle
  oracle_tb #(N) oracle (.clk, .rst, .pass, .done, .value, .dv());

  // Traza FST y terminación
  initial begin
    $dumpfile("build/sim.fst");
    $dumpvars(0, mi_modulo_tb);
    wait (done);
    #1;
    $finish;
  end

endmodule
```

---

## Cómo agregar un ejercicio nuevo

1. **Crear el directorio** `ejercicios/ejNN/`.

2. **Crear el archivo de diseño** con el módulo de ejemplo (si aplica) y el stub a completar:
   ```systemverilog
   module mi_modulo(input logic a, output logic b);
     // COMPLETAR
   endmodule
   ```

3. **Crear el testbench** siguiendo el patrón anterior. Elegir `N` según la cantidad de bits de entrada total (suma de todos los puertos de entrada del DUT).

4. **Crear el Makefile**:
   ```makefile
   TOP      := mi_modulo_tb
   SRCS     := mi_modulo.sv mi_modulo_tb.sv
   CMD_FILE := $(wildcard *.sucl)
   include ../common.mk
   ```

5. **Crear `signals.sucl`** para que Surfer abra el waveform con las señales del oracle y el DUT ya organizadas:
   ```
   scope_add_as_group mi_modulo_tb.oracle
   item_focus a
   item_set_color Pink
   # ... (un item_focus + item_set_color por señal del oracle)
   item_unfocus

   scope_add_as_group mi_modulo_tb.dut
   ```

6. **Verificar** corriendo `make sim` desde el directorio del ejercicio. Si el módulo stub no hace nada, deben verse FAILs — eso es correcto.

### Módulos compartidos

Si un módulo va a usarse en varios ejercicios, agregarlo a `ejercicios/lib/`. `common.mk` lo incluye automáticamente en todas las compilaciones.

---

## Convenciones

- El stub del módulo a implementar siempre es un módulo SV real (no comentado), con `// COMPLETAR` en el cuerpo.
- Los comentarios pedagógicos y la descripción del ejercicio van en bloques `/* ... */` antes del stub.
- El directorio `build/` está en `.gitignore` — no commitearlo.
- Los archivos `.sucl` sí se versiona: definen la vista de Surfer que los alumnos ven al abrir el waveform.
