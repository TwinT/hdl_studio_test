/*
Sugerencia: para que los tests se ejecuten más rápido, clickear en la entrada
"clk" y cambiar el valor de 100 a 10.
*/

module internal_vars_tb;

  // ── Clock & Reset ──────────────────────────────────────────────────────────
  logic clk = 0;
  always #5 clk = ~clk;  // periodo = 10 unidades de tiempo

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // ── Señales ────────────────────────────────────────────────────────────────
  logic done;
  logic a, b, c;
  logic pass, result, exp;
  logic [2:0] value;

  // Esto se llama "concatenación" y permite asignar varias señales a la vez. En este caso, se asigna el valor de la señal "value" a las tres entradas del módulo bajo prueba.
  assign {a, b, c} = value;

  // Como los puertos tienen el mismo nombre que las señales internas, se puede usar la sintaxis de
  // "named port connections" para conectarlos automáticamente. Las que difieren se conectan explicitamente. Existe incluso una manera más abreviada de hacer esto, la veremos en el próximo ejercicio.
  internal_vars dut (
      .a,
      .b,
      .c,
      .out(result)
  );

  always_comb begin
    case (value)
      3'b001:  exp = 1;
      3'b010:  exp = 1;
      3'b100:  exp = 1;
      default: exp = 0;
    endcase
  end

  assign pass = exp == result;

  oracle_tb #(3) oracle (
      .clk,
      .rst,
      .pass,
      .done,
      .value,
      .dv()
  );

    // ── Traza FST y terminación ────────────────────────────────────────────────
  initial begin
    $dumpfile("build/sim.fst");
    $dumpvars(0, internal_vars_tb);

    wait (done);

    #1;  // flush de la traza
    $finish;
  end

endmodule


