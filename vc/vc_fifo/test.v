`include "vc_fifo.v"

module test;

reg clk;
initial clk = 0;
always #5 clk <= ~clk;

integer i;

//------- WLEN NUMW DEPTH ----------------
vc_fifo #(8,   4,   4)  fifo ();

initial begin
  $dumpvars;
//  $monitor("wptr = %0d, rptr = %0d, dist = %0d, time = %0t",
//    fifo.wptr, fifo.rptr, fifo.dist_ptr, $time);
  #1000 $finish;
end

initial begin
for (i=0; i<3; i=i+1) fifo.set_data(i,1);
#10  fifo.push;
for (i=0; i<2; i=i+1) fifo.set_data(i,2);
#10  fifo.push;
for (i=0; i<4; i=i+1) fifo.set_data(i,3);
#10  fifo.push;
for (i=0; i<1; i=i+1) fifo.set_data(i,4);
#10  fifo.push;
for (i=0; i<2; i=i+1) fifo.set_data(i,5);
#10  fifo.push;
for (i=0; i<3; i=i+1) fifo.set_data(i,6);
#10  fifo.push;
for (i=0; i<3; i=i+1) fifo.set_data(i,7);
#10  fifo.push;
for (i=0; i<3; i=i+1) fifo.set_data(i,8);
#10  fifo.push;
end

initial begin
#100 fifo.pull;
#10 fifo.pull;
#10 fifo.pull;
#10 fifo.pull;
#10 fifo.pull;

#100 $finish;
end

endmodule
