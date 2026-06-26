module oracle_tb #(
    parameter integer N         = 4,
    parameter bit     FAST_FAIL = 0
) (
    input  logic         clk,
    input  logic         rst,
    input  logic         pass,
    output logic         done,
    output logic [N-1:0] value,
    output logic         dv
);

  logic tests_passing;
  logic first;

  always_ff @(posedge clk) begin
    if (rst) begin
      value         <= -1;
      done          <= 0;
      dv            <= 0;
      tests_passing <= 1;
      first         <= 1;
    end else if (!done) begin
      value <= value + 1;  // -1+1=0 en el primer ciclo activo
      dv    <= 1;
      first <= 0;
      if (!first) begin  // salteamos el chequeo cuando value es -1
        if (!pass) begin
          $display("\033[31mFAIL: value = %0d (%b)\033[0m", value, value);
          tests_passing <= 0;
          if (FAST_FAIL || &value) begin
            done <= 1;
            dv   <= 0;
          end
        end else if (&value) begin
          done <= 1;
          dv   <= 0;
        end
      end
    end
  end

  initial begin
    wait (done);
    if (tests_passing)
      $display("\033[32mPASS: todos los tests pasaron\033[0m");
    else
      $display("\033[31mFAIL: hubo combinaciones que fallaron\033[0m");
  end

endmodule
