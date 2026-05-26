`include "vc_bit.v"

module test;

reg a;
reg clk, rst_n;
initial begin
  clk = 1;
  rst_n = 0;
  a = 0;
end

always #5 clk <= ~clk;

always @(posedge clk)
  if ({$random}%10 < 2) a <= 1;
  else a <= 0;

vc_rose     rose_a    (clk, rst_n, a, a_rose);
vc_fell     fell_a    (clk, rst_n, a, a_fell);
vc_changed  changed_a (clk, rst_n, a, a_changed);
vc_delay #3 delay_a   (clk, rst_n, a, a_delay);   

initial begin
  $dumpvars;
  @(posedge clk);@(posedge clk);
  rst_n = 1;

  #500 $finish;
end

endmodule
