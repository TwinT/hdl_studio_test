module extensor_tb;

  // ── Clock & Reset ──────────────────────────────────────────────────────────
  logic clk = 0;
  always #5 clk = ~clk;  // periodo = 10 unidades de tiempo

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // ── Señales ────────────────────────────────────────────────────────────────
  logic [3:0] value;
  logic [7:0] result;
  logic pass, done;

  // ── DUT ────────────────────────────────────────────────────────────────────
  extensor dut (
      .in (value),
      .out(result)
  );

  assign pass = (signed'(result) == 8'(signed'(value)));

  // ── Oracle (recorre todas las combinaciones de entradas) ───────────────────
  oracle_tb #(4) oracle (
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
    $dumpvars(0, extensor_tb);

    wait (done);

    #1;  // flush de la traza
    $finish;
  end

endmodule
