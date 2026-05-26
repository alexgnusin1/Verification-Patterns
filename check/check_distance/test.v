`define TOP_FINISH 1
`include "check_distance.v"

module top;

event finish;
reg clk, rst_n;
initial begin
  clk = 1;
  rst_n = 1;
end
always #5 clk <= ~clk;

task finish_err;
begin
end
endtask

reg req, ack;

check_distance #(3,6,0,0) d1 (clk, rst_n, req, ack);

initial begin
  $dumpvars;
  req = 0; ack = 0;
  #10; #10; 
  rst_n = 0;
  #10 req = 1;   #10 req = 0;
  #10 req = 1;   #10 req = 0;
  #10 ack = 1; #10 ack = 0;
  #10 ack = 1; #10 ack = 0;
  #100 -> finish;
  #1 $finish;
end

endmodule
