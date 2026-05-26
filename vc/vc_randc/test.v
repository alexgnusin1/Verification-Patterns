`include "vc_randc.v"

module test;
integer i;
vc_randc #(3,8) randc();

initial begin
  for (i=0; i< 20; i=i+1)
    #10 $display("i = %0d; randc = %0d", i, randc.get(0));
  #10 $finish;
end

endmodule