`include "cover_bins.v"

module test;

reg clk; initial clk = 0;
reg [3:0] a_reg, b_reg, c_reg, d_reg;

always #10 clk <= ~clk;

always @(posedge clk) begin
  a_reg <= ($random)%4;
  b_reg <= ($random)%4;
  c_reg <= ($random)%4;
  d_reg <= ($random)%4;
end

//--------------------------------------

cover_bins #4 cov ();
initial begin
  cov.display_status = 0;
  cov.add("a_reg = 0", 10, 40);
  cov.add("b_reg = 1", 10, 40);
  cov.add("c_reg = 2", 10, 40);
  cov.add("d_reg = 3", 10, 40);
end
//--------------------------------------

always @(posedge clk) begin
 if (a_reg == 0) cov.sample("a_reg = 0");
 if (b_reg == 1) cov.sample("b_reg = 1");
 if (c_reg == 2) cov.sample("c_reg = 2");
 if (d_reg == 3) cov.sample("d_reg = 3");
end

initial forever begin
  #1000 cov.report;
end

// Exit on first maximum violation
always @(cov.exceeded) begin
  $display ("MAXIMUM reached for '%s'", cov.exceeded_name);
  $finish;
end

// Run till all functional coverage is collected; then exit
always @(cov.covered) begin
  $display("[%0t] Info: Stimulus coverage reached, test may exit", $time);
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

