`include "check_time_distance.v"

module test;

reg clk;
reg a, b;

//-----------------------------------------------------
function integer rn;
input d1, d2;
integer d1, d2;

begin
  rn = d1 + {$random} % (d2-d1+1);
end

endfunction

//-----------------------------------------------------
check_time_distance #(80,140) distance (a,b);
//-----------------------------------------------------

initial begin
  clk = 0;
  a   = 0;
  b   = 0;
end

always #5 clk <= ~clk;

//-----------------------------------------------------
always @(posedge clk) begin
  if (rn(0,100) < 4) a <= 1;
  else               a <= 0;
  if (rn(0,100) < 4) b <= 1;
  else               b <= 0;
end


always @(distance.err) $display ("Test: wrong distance");
always @(distance.ok)  $display ("Test: right distance");

initial begin
  $monitor ("a = %b, b = %b, time = %0t", a, b, $time); 
  #3000 $finish;
end

endmodule
