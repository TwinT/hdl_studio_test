module comparador_tb;

  // ── Clock & Reset ──────────────────────────────────────────────────────────
  logic clk = 0;
  always #5 clk = ~clk;  // periodo = 10 unidades de tiempo

  logic rst = 1;
  initial begin
    repeat (2) @(posedge clk);
    rst = 0;
  end

  // ── Señales ────────────────────────────────────────────────────────────────
  logic [7:0] value;
  logic [3:0] a, b;
  logic result, pass, done;

  assign {a, b} = value;

  // ── DUT ────────────────────────────────────────────────────────────────────
  comparador dut (
      .a,
      .b,
      .out(result)
  );

  assign pass = (result == (a == b));

  // ── Oracle (recorre todas las combinaciones de entradas) ───────────────────
  oracle_tb #(8) oracle (
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
    $dumpvars(0, comparador_tb);

    wait (done);

    #1;  // flush de la traza
    $finish;
  end

endmodule
