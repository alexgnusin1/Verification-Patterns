`include "vc_count.v"

module test;

reg clk, rst_n;
initial begin
  clk = 1;
  rst_n = 0;
end

always #5 clk <= ~clk;

vc_count count (clk, rst_n);

initial begin
  $dumpvars;
  #20 rst_n = 1;
  #30 count.on;
  #40 $display("[%0t] count = %0d", $time, count.val);
  #30 count.off;
  #50 count.on;
  #20 $display("[%0t] count = %0d", $time, count.val);
  #50 count.reset;
  $display("[%0t] count = %0d", $time, count.val);
  #50 $finish;
end

endmodule
