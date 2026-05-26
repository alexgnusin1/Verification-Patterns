`include "gen_pulse.v"

module test;

reg clk, start;
wire pulse;
integer i;

initial begin
  clk = 1;
  start = 0;
end

always #5 clk <= ~clk;

gen_pulse #(0,6) gen_pulse (clk, 1'b1, start, pulse);

initial begin
  $dumpvars;
  for (i=0; i<300; i=i+1) begin
    @(posedge clk);
    if (i%30 == 0) start = 1;
    else           start = 0;
  end
  #100 $finish;
end

endmodule

