//-----------------------------------------------------
module vc_rose (clk, rst_n, din, rose);
input  clk, rst_n;
input  din;
output rose;
reg    dreg;

always @(posedge clk)
  if (!rst_n) dreg <= 0;
  else        dreg <= din; 

assign rose = (din == 1 && dreg == 0);

endmodule
