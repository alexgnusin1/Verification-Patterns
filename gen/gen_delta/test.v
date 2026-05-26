`define CONTROL_MODE  

`include "gen_delta.v"

module test;

reg clk;

reg  [7:0] data_in;
wire [7:0] data_out;
integer i;

initial begin
  clk = 0;
  data_in = 0;
end

always #10 clk <= ~clk;

gen_delta #(0,6,0,6,8) delta (clk, 1'b1, data_in, data_out);


initial begin
  $monitor ("data_in = %0d, data_out = %0d, time = %0t", data_in, data_out, $time); 
  $dumpvars;

  for (i=0; i<400; i=i+1) begin
    @(posedge clk);
    if (i%10 == 0) data_in = i;
  end
  #100 $finish;
end

endmodule

