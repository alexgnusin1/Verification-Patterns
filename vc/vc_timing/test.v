`include "vc_timing.v"

//---------------------------------------------------
module test;
reg a, b, clk;

initial begin
  $dumpvars;
  clk = 0;
  a = 0; b=0;
  #20 a = 1;
  #20 b = 1;
  #20 a = 0;
  #20 b = 0;
  #20 a = 1;
   b = 1;
  #40 $finish;
end

always #10 clk = ~clk;
vc_timing a_b (clk, 1'b1, a, b);
always @(a_b.rose)
  $display("[%0t]: b rose, r2r = %0d, f2r = %0d", $time, a_b.r2r, a_b.f2r);
always @(a_b.fell) begin
  $display("[%0t]: b fell, r2f = %0d, f2f = %0d", $time, a_b.r2f, a_b.f2f);
  if (a_b.r2f < 20)
    $display("[%0t] <%m> Error: a_b rise-to-fall time (%0d) less than 20!", 
      $time, a_b.r2f);
end

endmodule