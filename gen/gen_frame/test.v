`define CONTROL_MODE  

`include "gen_frame.v"

module test;

reg clk, start, data_in, waiting;
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

always @(posedge clk) 
  if ({$random}%100 < 10) waiting <= 1;
  else                    waiting <= 0;

gen_frame #(8,8) frame (clk, 1'b1, 3, 3, start, waiting, data_in, data_out);

initial begin
  $monitor ("start     = %b, time = %0t", start, $time); 
  $monitor ("data_out = %b, time = %0t", data_out, $time); 
  $dumpvars;

  for (i=0; i<300; i=i+1) begin
    @(posedge clk);
    if (i%30 == 0) start = 1;
    else           start = 0;
  end
  #100 $finish;
end

endmodule

