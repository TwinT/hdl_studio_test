module mux_tb;

  // ── Clock & Reset ──────────────────────────────────────────────────────────
  logic clk = 0;
  always #5 clk = ~clk;  // periodo = 10 unidades de tiempo

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // ── Señales ────────────────────────────────────────────────────────────────

  logic result, exp, pass, done;
  logic a, b;
  logic [1:0] value;

  assign {a, b} = value;

  negador_condicional dut (
      .bit_a_negar(a),
      .negar(b),
      .out(result)
  );

  always_comb begin
    if (b) exp = ~a;
    else exp = a;
  end

  assign pass = result == exp;

  oracle_tb #(2) oracle (
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
    $dumpvars(0, mux_tb);

    wait (done);

    #1;  // flush de la traza
    $finish;
  end

endmodule



