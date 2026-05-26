`include "cover_value.v"

module test;

reg clk; initial clk = 0;
reg [6:0] data;

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
  data <= ($random)%20;

//--------------------------------------
cover_value #(7,5) cov (clk, 1'b1, data);

initial begin
  cov.display_status = 0;
//         name       from  to  min max
//         ----------------------------
  cov.add("VAL 1",  1, 5,  100);
  cov.add("VAL 2",  2, 5,  100);
  cov.add("VAL 3",  3, 5,  100);
  cov.add("VAL 4",  4, 5,  100);
  cov.add("VAL 5",  5, 5,  100);
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
  $dumpvars;
  #10000 $finish;  
end

endmodule

