`include "cover_time.v"

module test;

reg clk; initial clk = 0;
reg [2:0] data;

parameter INIT = 0;
parameter S1   = 1;
parameter S2   = 2;
parameter S3   = 3;
parameter S4   = 4;
parameter S5   = 5;
parameter S6   = 6;
parameter S7   = 7;

always #10 clk <= ~clk;

always @(posedge clk)
  data <= ($random)%7;

//--------------------------------------
cover_time #(3) cov (clk, rst_n, (data == S2), (data == S5));

initial begin
  cov.display_status = 0;
//         name         min  max goal
//         ----------------------------
  cov.add("Low Bound",  1,    4,   10);
  cov.add("Middle",     5,    9,   10);
  cov.add("High Bound", 10,   20,  10);
end
//--------------------------------------

initial forever begin
  #1000 cov.report;
end


// Run till all functional coverage is collected; then exit
always @(cov.covered) begin
  $display("[%0t] TC INFO: Stimulus coverage reached, test may exit", $time);
  cov.report;
  $finish;
end

//If functional coverage is not collected , wait for timeout
initial begin
  #40000 $finish;  
end

endmodule

