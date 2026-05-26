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

//-----------------------------------------------------
module vc_changed (clk, rst_n, din, changed);
input  clk, rst_n;
input  din;
output changed;
reg    dreg;

always @(posedge clk)
  if (!rst_n) dreg <= 0;
  else        dreg <= din; 

assign changed   = (din != dreg);

endmodule

//-----------------------------------------------------
module vc_delay (clk, rst_n, din, delay);
parameter CLK_DELAY = 1;
input  clk, rst_n;
input  din;
output delay;

reg [CLK_DELAY-1:0] delay_reg;

always @(posedge clk)
  if (!rst_n) delay_reg <= 0;
  else delay_reg <= {delay_reg,din};
  
assign delay = delay_reg[CLK_DELAY-1];

endmodule

//-----------------------------------------------------

