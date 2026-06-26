module vectores_tb;

  // ── Clock & Reset ──────────────────────────────────────────────────────────
  logic clk = 0;
  always #5 clk = ~clk;  // periodo = 10 unidades de tiempo

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // ── Señales ────────────────────────────────────────────────────────────────
  logic [5:0] value;
  logic [5:0] result;
  logic pass, done;

  // ── DUT ────────────────────────────────────────────────────────────────────
  vectores dut (
      .in (value),
      .out(result)
  );

  assign pass = (result == value << 1);

  // ── Oracle (recorre todas las combinaciones de entradas) ───────────────────
  oracle_tb #(6) oracle (
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
    $dumpvars(0, vectores_tb);

    wait (done);

    #1;  // flush de la traza
    $finish;
  end

endmodule
