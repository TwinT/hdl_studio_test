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
  logic       ok;
  logic       ready, all_tests_passed;

  assign a = value[0];
  assign b = value[1];

  // ── DUT ────────────────────────────────────────────────────────────────────
  helloworld dut (
      .a(a),
      .b(b),
      .c(result)
  );

  assign ok = (result == (~a | ~b));

  // ── Oracle (recorre todas las combinaciones de entradas) ───────────────────
  oracle_tb #(.n(2)) oracle (
      .clk             (clk),
      .rst             (rst),
      .result_ok       (ok),
      .ready           (ready),
      .all_tests_passed(all_tests_passed),
      .value           (value)
  );

  // ── Traza FST y terminación ────────────────────────────────────────────────
  initial begin
    $dumpfile("build/sim.fst");
    $dumpvars(0, helloworld_tb);

    wait (ready);

    if (all_tests_passed)
      $display("PASS: todos los tests pasaron");
    else
      $display("FAIL: falla con a=%b b=%b result=%b (esperado=%b)",
               a, b, result, (~a | ~b));

    #1;  // flush de la traza
    $finish;
  end

endmodule
