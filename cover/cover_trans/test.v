`include "cover_trans.v"

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
cover_trans #(3,8) cov (clk, rst_n, data);

initial begin
  cov.display_status = 0;
//         name       from  to  min max
//         ----------------------------
  cov.add("INIT->S1", INIT, S1,  5,  8);
  cov.add("S1->S2",     S1, S2,  5,  8);
  cov.add("S1->S5",     S1, S5,  5,  8);
  cov.add("S5->S3",     S5, S3,  6,  8);
  cov.add("S6->S3",     S6, S3,  5,  8);   // exit on coverage collection
//cov.add("S6->S3",     S6, S3,  3,  6);   // exit on reaching max limit
end
//--------------------------------------

initial forever begin
  #1000 cov.report;
end

// Exit on first maximum violation
always @(cov.exceeded) begin
  $display ("[%0t] TC INFO: MAXIMUM reached for '%s'",
      $time, cov.exceeded_name);
  $finish;
end

// Run till all functional coverage is collected; then exit
always @(cov.covered) begin
  $display("[%0t] TC INFO: Stimulus coverage reached, test may exit", $time);
  cov.report;
  $finish;
end

//If functional coverage is not collected , use timebomb
initial begin
  $recordsetup("version=1");
  $recordfile("top");
  $recordvars;
  #10000 $finish;  
end

endmodule

