`include "vc_array.v"

module vc_randc;
parameter MIN = 0;
parameter MAX = 10;

reg [7:0] result;
integer i;

vc_array #(8,MAX-MIN+1) my_array();

//----------------------------------------
initial begin
  #0
  for (i=0; i<=MAX-MIN; i=i+1)
    my_array.set(i,MIN+i);
  my_array.shuffle;
  i = 0;
end  

//-----------------------------------------
always @(posedge (i==0)) my_array.shuffle;

//-----------------------------------------
function [7:0] get;
input dummy;
begin
  get = my_array.get(i);
  if (i==(MAX-MIN)) i = 0;
  else              i = i+1;
end
endfunction

endmodule
