`include "vc_switch.v"

module test;

reg a_reg;
reg clk, rst_n;
wire switch_out;

initial begin
  clk = 1;
  rst_n = 0;
  a_reg = 0;
end

always #5 clk <= ~clk;

vc_switch #(0,0) a_switch (clk, rst_n, a_reg, a_reg, switch_out);

initial begin
  $monitor ("[%0t]: a_switch = %b", $time, switch_out);
  #25 rst_n = 1;
  #40 a_reg = 1;
  #10 a_reg = 0;
  #40 a_reg = 1;
  #10 a_reg = 0;

  #40 $finish;
end

endmodule