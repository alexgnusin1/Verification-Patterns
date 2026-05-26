
module test ();

reg [0:31] seed;
integer i;

`include "vc_random.v"

initial begin
  for (i=0; i<40; i=i+1)
    $display("rl = %0d	rn = %0d	rh = %0d",
      rl(0,20), rn(0,20), rh(0,20));
  $finish;
end

endmodule
