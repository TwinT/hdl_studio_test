// Introducción a System Verilog para Sistemas Digitales
// Obs: Esto es un comentario de única línea

// Definamos nuestro primer módulo, con dos entradas (a y b) y una salida (c):
module helloworld (
    input  logic a,
    input  logic b,
    output logic c
);

  /* Vamos a usar assign para asignarle un valor a una señal.
  Podemos usar las siguientes operaciones de la lógica relacional:
  - ~a (NOT a)
  - a & b (AND)
  - a | b (OR)
  - a ^ b (XOR)
  Obs: esto es un comentario multilínea */

  assign c = (~a | ~b);

endmodule

/* Prueben sintetizar el circuito. Para eso hay que seleccionar la opción
"Create circuit in HDL studio" en el explorer, y después clickear en botón
"Syntethize".

Ejercicio: usen la ley de DeMorgan para reesecribir la expresión de c usando
solamente NOTs y ANDs. Vean el circuito sintetizado. ¿Cambió la cantidad de
compuertas lógicas?

Para probar que el cambio que hicieron en el ejercicio es equivalente a la
expresión original, corran la simulación por línea de comandos del circuito,
que hace una prueba exhaustiva de todas las entradas posibles del circuito (a
esta simulación se la llama "testbench"). Para eso, abran una terminal
seleccionando la opción "Open in Integrated Terminal" del explorer, y dentro
de la terminal ejecuten el comando "make sim". Si el circuito cumple lo pedido,
deberían ver un mensaje indicando que los tests pasaron.

*/
