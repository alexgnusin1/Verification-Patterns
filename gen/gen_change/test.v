`define CONTROL_MODE  

`include "gen_pulse.v"

module test;

reg clk, start, data_in;
wire data_out;
integer i;

initial begin
  clk = 0;
  start = 0;
  data_in = 0;
end

always #10 clk <= ~clk;

always @(posedge clk) 
  if ({$random}%100 < 4) data_in <= 1;
  else                   data_in <= 0;

gen_pulse #(2,20) pulse (clk, 1'b1, start, data_in, data_out);

initial begin
  $monitor ("start     = %b, time = %0t", start, $time); 
  $monitor ("data_out = %b, time = %0t", data_out, $time); 
//  $recordsetup("version=1");
//  $recordfile("top");
  $recordvars;

  for (i=0; i<300; i=i+1) begin
    @(posedge clk);
    if (i%30 == 0) start = 1;
    else           start = 0;
  end
  #100 $finish;
end

endmodule

