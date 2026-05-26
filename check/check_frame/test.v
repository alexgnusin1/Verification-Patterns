`define TOP_FINISH 1
`include "check_frame.v"

module top;

reg clk, rst_n;
reg req, ack;

//------------------------------------------------
initial begin
  clk = 1;
  rst_n = 1;
end
always #5 clk <= ~clk;

//------------------------------------------------
event finish;
task finish_err;
begin
end
endtask

//------------------------------------------------
check_frame #(3,6,0,0) frame (clk, rst_n, req, ack);

//------------------------------------------------
always @(frame.err) 
  $display("[%0t] ERROR: vc_frame timing violation", $time);

always @(frame.ok) 
  $display("[%0t] INFO: vc_frame success", $time);

//------------------------------------------------
initial begin
  $dumpvars;
  req = 0; ack = 0;
  #10; #10; 
  rst_n = 0;
  #10 req = 1;   #10 req = 0;
  #10 req = 1;   #10 req = 0;
  #10 ack = 1;   #10 ack = 0;
  #40 ack = 1;   #10 ack = 0;
  #100 -> finish;
  #1 $finish;
end

endmodule
