module internal_vars (
    input  logic a,
    input  logic b,
    input  logic c,
    output logic out
);

  assign out = (a & ~b & ~c) | (~a & b & ~c) | (~a & ~b & c);
endmodule

/*
Ejercicio: cambiar el comportamiento del módulo para que devuelva 1 sí y solo sí
exactamente una entrada es 1. Ejemplos:
internal_vars(0,0,0) = 0
internal_vars(0,1,0) = 1
internal_vars(0,1,1) = 0
sugerencia: utilizar suma de productos y señales internas.

Comprobar el resultado corriendo internal_vars_tb.sv
*/

