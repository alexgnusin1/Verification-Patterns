`define VPL_VERIFICATION 1

`include "vc_sync.v"
`include "vc_sync_rst.v"
module test;

reg clk1, clk2;

initial begin
  clk1 = 0;
  clk2 = 0;
end

always #10 clk1 <= ~clk1;
always #12 clk2 <= ~clk2;

reg  [3:0]  reg1, reg2;
wire [3:0] reg1_w;

reg  raw_rst_n;
wire rst_n;

always @(posedge clk1)
  if      ({$random}%100 < 10)  reg1 <= 1;
  else if ({$random}%100 > 90)  reg1 <= 4;
  else                     reg1 <= 0;

always @(posedge clk2)
  reg2 <= reg1_w;

vc_sync_rst sync_rst (clk2, 1'b0, raw_rst_n, rst_n);
vc_sync  #4  sync     (clk2, rst_n, reg1, reg1_w); 


initial begin
  $dumpvars;
  raw_rst_n = 0;
  #52 raw_rst_n = 1;
  #10000 $finish;
end

endmodule