// Testbench auto-contenido para helloworld.sv
// Compatible con Verilator (--timing, --trace-fst).
// Sin puertos: genera su propio clk/rst y termina con $finish.
module helloworld_tb;

  // ── Clock & Reset ──────────────────────────────────────────────────────────
  logic clk = 0;
  always #5 clk = ~clk;  // periodo = 10 unidades de tiempo

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // ── Señales ────────────────────────────────────────────────────────────────
  logic [1:0] value;
  logic       a, b, result;
  logic       pass;
  logic       done, dv, all_tests_passed;

  assign a = value[0];
  assign b = value[1];

  // ── DUT ────────────────────────────────────────────────────────────────────
  helloworld dut (
      .a(a),
      .b(b),
      .c(result)
  );

  assign pass = (result == (~a | ~b));

  // ── Oracle (recorre todas las combinaciones de entradas) ───────────────────
  oracle_tb #(.N(2)) oracle (
      .clk             (clk),
      .rst             (rst),
      .pass            (pass),
      .done            (done),
      .all_tests_passed(all_tests_passed),
      .value           (value),
      .dv              (dv)
  );

  // ── Traza FST y terminación ────────────────────────────────────────────────
  initial begin
    $dumpfile("build/sim.fst");
    $dumpvars(0, helloworld_tb);

    wait (done);

    if (all_tests_passed)
      $display("PASS: todos los tests pasaron");
    else
      $display("FAIL: hubo combinaciones que fallaron (ver detalle arriba)");

    #1;  // flush de la traza
    $finish;
  end

endmodule
