`include "gen_delay.v"

module test;

reg clk;

reg  [7:0] data_in;
wire [7:0] data_out;
integer i;

always #15 clk <= ~clk;

gen_delay #(3,6,8) delay (clk, 1'b1, data_in, data_out);

initial begin
  $dumpvars;
  clk = 1;
  data_in = 0;

  for (i=0; i<200; i=i+1) begin
    @(posedge clk);
    if (i%10 == 0) data_in = i;
    else data_in = 0;
  end
  #100 $finish;
end

endmodule

  