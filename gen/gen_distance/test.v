`include "gen_distance.v"

module test;

reg clk;
wire data_out;
integer i;

initial begin
  clk = 1;
end

always #5 clk <= ~clk;

gen_distance #(12, 15) dist (clk, 1'b1, data_out);

initial begin
  $monitor ("data_out = %b, time = %0t", data_out, $time); 
  $dumpvars;

  #1000 $finish;
end

endmodule

