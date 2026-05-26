module vc_fifo;

parameter WLEN =  0;
parameter NUMW =  0;
parameter DEPTH = 0;

// Access registers
// --------------------------------
reg [WLEN-1:0] data_out [0:NUMW-1];
reg [31:0]     data_size;    
// --------------------------------

reg [WLEN-1:0] data_mem  [0:NUMW*DEPTH-1];
reg [31:0]     dsize_mem [0:DEPTH-1];

reg [WLEN-1:0] data_in  [0:NUMW-1];
reg [31:0]     din_size;    


integer wptr, rptr,dist_ptr, i;
initial begin
  wptr = 0; rptr = 0;
  dist_ptr = 0;
  din_size = 0;
  if (WLEN == 0 || NUMW == 0 || DEPTH == 0) begin
    $display("ERROR <%m> : parameters are not set!");
    $finish;
  end
end

//--------------------------------------
// Access task: set input data word
//--------------------------------------
task set_data;
input [31:0]     numw;
input [WLEN-1:0] data;
begin
  data_in[numw] = data;
  if (numw > din_size) din_size = numw;
end
endtask

//-------------------------------------------
// Access task: push input data words to FIFO
//-------------------------------------------
task push;
integer i;
begin 
  wait (dist_ptr < DEPTH);
  $display("-----------------------------------------");
  $display("PUSH: wptr = %0d, time = %0t", wptr, $time);
  dsize_mem[wptr] = din_size;
  for (i=0; i<= din_size; i=i+1) begin
    data_mem[wptr*NUMW+i] = data_in[i];
    $display("  data_mem[%0d] = %h", i, data_in[i]);
  end
  din_size = 0;
  dist_ptr = dist_ptr + 1;
  if (wptr == DEPTH-1) wptr = 0; 
  else wptr = wptr + 1;
end
endtask

//-------------------------------------------
// Access task: pull data words out from FIFO
//-------------------------------------------
task pull;
integer i;
begin
  wait (dist_ptr > 0);
  $display("-----------------------------------------");
  $display("PULL: rptr = %0d, time = %0t", rptr, $time);
  data_size = dsize_mem[rptr];
  for (i=0; i<= data_size; i=i+1) begin
    data_out[i] = data_mem[rptr*NUMW+i];
    $display("  data_mem[%0d] = %h", i, data_out[i]);
  end
  dist_ptr = dist_ptr - 1;
  if (rptr == DEPTH-1) rptr = 0;
  else rptr = rptr + 1;
end
endtask

//-------------------------------------------
// Access task: reset FIFO
//-------------------------------------------
task reset;
begin
  wptr = 0; rptr = 0;
  dist_ptr = 0;
  din_size = 0;
end
endtask

//---------------------------------------------------------
// Check remainders at the end of simulation
//---------------------------------------------------------
`ifdef TOP_FINISH
always @(top.finish) begin
  if (rptr != wptr || dist_ptr != 0) begin
    $display("[%0t:%0t] <%m> Error: data entries remain in FIFO",
       time_mem[rptr], $time);
  end
end
`endif


endmodule