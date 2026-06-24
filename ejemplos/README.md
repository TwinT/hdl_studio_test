# Tutorial de system verilog para Sistemas Digitales

La idea es presentar el lenguaje de System Verilog a través de ejercicios
básicos de lógica combinatoria.

Se asume que los estudiantes cuentan conocimiento de álgebra booleana y
compuertas lógicas, pero no necesariamente de representación de números
enteros.

Cada ejercicio muestra un nuevo feature de System Verilog. Para ponerlo en
práctica, se pide que implementen algo y lo testeen usado un testbench ya
provisto.

Forma de uso:

* Cargar el fichero del ejercicio (`ejXX_nombre.sv`) en [DigitalJS
  Online](https://digitaljs.tilk.eu/) donde dice `Drop your files here or click
  for a file dialog`
* Una vez implementado lo que se pide, cargar el testbench `ejXX_tb.sv` y el
  fichero `oracle_tb.sv` que es necesario para todos los testbenches. Esto va a
  hacer que se sintetice el testbench en vez de solamente el circuito que
  implementamos, y permitirá verificar la correctitud de la implementación.
* Recordar que el testbench sintetizado va a tener una instancia del circuito que
  se implementó. El estado de este último se puede ver seleccionando el componente
  (por convención se lo suele nombrar `dut` por Device Under Test) y clickeando en
  la lupa.
* Para pasar al siguiente ejercicio, cerrar y volver a abrir DigitalJS y
  repetir los pasos anteriores

### Nota sobre limitaciones de DigitalJS Online

Por el momento, digitaljs no permite seleccionar el circuito top-level a
sintetizar. Por eso es necesario cargar el testbench recién a la hora de
testear, y reiniciar el programa para pasar al siguiente ejercicio. Está
pendiente encontrar una mejor forma de que se carguen los ficheros y de que se
pueda elegir más fácilmente el circuito top-level.
