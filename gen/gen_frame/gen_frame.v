module gen_frame (clk, rst_n, param1, param2, start, waiting, data_in, data_out);

parameter MIN_CLKS = 0;
parameter MAX_CLKS = 0;
parameter START_CHANGE = 0; 

input         clk, rst_n;
input  [31:0] param1, param2;
input         start;
input         waiting;
input         data_in;
output        data_out; 

/* ---------------------------------------------
CHANGE:   
0 - level
1 - rising edge
2 - falling edge
3 - change
-----------------------------------------------*/

`ifdef CONTROL_MODE 

reg data_change;
reg start_reg;

reg [31:0] clock_count;
reg [31:0] clock_limit;
reg        count_enable;

reg [31:0] frame_count;
reg [31:0] frame_limit;
reg        frame_enable;

wire start_rise, start_fall, start_change;
//---------------------------------------------------------
assign start_rise   = (start == 1 && start_reg == 0);
assign start_fall   = (start == 0 && start_reg == 1);
assign start_change = (start != start_reg);

assign start_w =  (START_CHANGE==0)? start : 
                 ((START_CHANGE==1)? start_rise :
                 ((START_CHANGE==2)? start_fall : start_change));

//-----------------------------------------------------
function integer rn;
input d1, d2;
integer d1, d2;

begin
  rn = d1 + {$random} % (d2-d1+1);
end

endfunction

//-----------------------------------------------------
initial begin
  clock_count  = 0;
  count_enable = 0;
  frame_count  = 0;
  frame_enable = 0;
  start_reg    = 0;
end

//-----------------------------------------------------
always @(posedge clk) begin
  if (!rst_n) clock_count <= 0;
  else begin
    start_reg <= start;
    if (start_w && count_enable == 0) begin
      clock_count  <= 0;
      count_enable <= 1;
      clock_limit  <= rn (MIN_CLKS,MAX_CLKS);
    end
    if (clock_count == clock_limit-1) begin
      frame_limit  <= rn (param1,param2);
      count_enable <= 0;
      frame_count  <= 0;
      frame_enable <= 1;
    end
    if (frame_count == frame_limit-1) begin
      frame_enable <= 0;
    end
    if (count_enable & !waiting)
      clock_count <= clock_count + 1;
    if (frame_enable)
      frame_count <= frame_count + 1;
  end
end

assign data_out = frame_enable | data_in; 

`else 
assign data_out = data_in;
`endif

endmodule