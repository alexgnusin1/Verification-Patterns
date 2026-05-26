//-----------------------------------------------------
module vc_fell (clk, rst_n, din, fell);
input  clk, rst_n;
input  din;
output fell;
reg    dreg;

always @(posedge clk)
  if (!rst_n) dreg <= 0;
  else        dreg <= din; 

assign fell = (din == 0 && dreg == 1);

endmodule
