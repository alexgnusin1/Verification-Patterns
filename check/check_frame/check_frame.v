module check_frame (clk, reset_n, start, test);

parameter MIN_CLKS = 0;
parameter MAX_CLKS = 0;
parameter START_CHANGE = 0; 
parameter TEST_CHANGE = 0;
parameter DEPTH = MAX_CLKS-MIN_CLKS;

/* ---------------------------------------------
CHANGE:   
0 - level
1 - rising edge
2 - falling edge
3 - change
-----------------------------------------------*/

input clk, reset_n, start, test;

reg [31:0] distance;
integer wptr, rptr, clk_count; 
reg  start_reg, test_reg, fifo_dist;
wire start_w, test_w;
wire start_rise, start_fall, start_change;
wire test_rise,   test_fall,   test_change;
event err, ok;

reg [31:0] count_mem [0:DEPTH];
time       time_mem  [0:DEPTH];

//---------------------------------------------------------
assign start_rise   = (start == 1 && start_reg == 0);
assign start_fall   = (start == 0 && start_reg == 1);
assign start_change = (start != start_reg);

assign start_w =  (START_CHANGE==0)? start : 
                 ((START_CHANGE==1)? start_rise :
                 ((START_CHANGE==2)? start_fall : start_change));

assign test_rise   = (test == 1 && test_reg == 0);
assign test_fall   = (test == 0 && test_reg == 1);
assign test_change = (test != test_reg);

assign test_w =   (TEST_CHANGE==0)? test : 
                 ((TEST_CHANGE==1)? test_rise :
                 ((TEST_CHANGE==2)? test_fall : test_change));

//---------------------------------------------------------
task reset;
begin
  wptr = 0;
  rptr = 0;
  fifo_dist = 0;
  clk_count = 0;
  distance  = 0;
  start_reg = 0;
  test_reg  = 0;
end
endtask

//---------------------------------------------------------
task push;
begin
  count_mem[wptr] = clk_count;
  time_mem[wptr]  = $time;
  if (wptr == DEPTH) begin 
    wptr = 0;
    fifo_dist = 1;
  end 
  else wptr = wptr + 1;
end
endtask

//---------------------------------------------------------
task pull;
begin
  if (rptr == wptr && fifo_dist == 0) begin
    $display("[%0t] <%m> Error: Unexpected End signal", $time);
    -> err;
  end
  else begin
    distance = clk_count - count_mem[rptr];
    if (distance < MIN_CLKS || distance > MAX_CLKS) begin
      $display("[%0t:%0t] <%m> Error: distance (%0d) out of limits (%0d:%0d)",
         time_mem[rptr], $time, distance, MIN_CLKS,MAX_CLKS);
     -> err;
    end
    else begin
      $display("[%0t:%0t] <%m> Info: distance (%0d) within limits (%0d:%0d)",
         time_mem[rptr], $time, distance, MIN_CLKS,MAX_CLKS);
      -> ok;
    end
    if (rptr == DEPTH) begin 
      rptr = 0;
      fifo_dist = 0;
    end 
    else rptr = rptr + 1;
  end
end
endtask

//---------------------------------------------------------
always @(posedge clk) begin
  if (reset_n) reset;
  else begin
    if (start_w) push;
    if (test_w)  pull;
    clk_count = clk_count+1;
  end
end

//---------------------------------------------------------
always @(negedge clk) begin
    start_reg <= start;
    test_reg   <= test;
    distance <= 0;
end

//---------------------------------------------------------
// Check remainders at the end of simulation
//---------------------------------------------------------
`ifdef TOP_FINISH
always @(top.finish) begin
  if (rptr != wptr || fifo_dist != 0) begin
    $display("[%0t:%0t] <%m> Error: Open sequences remains in queue",
       time_mem[rptr], $time);
    -> err;
  end
end
`endif
//---------------------------------------------------------

endmodule