module gen_pulse (clk, rst_n, start, pulse);

parameter MIN_CLOCKS   = 0;
parameter MAX_CLOCKS   = 0;
parameter START_CHANGE = 0; 

input clk, rst_n, start;
output pulse;

/* ---------------------------------------------
CHANGE:   
0 - level
1 - rising edge
2 - falling edge
3 - change
-----------------------------------------------*/

reg    start_reg;
reg    pulse_reg;

reg [31:0] limit, count;
reg count_enable;
wire start_rise, start_fall, start_change, start_w;
//-----------------------------------------------------
function integer rn;
input d1, d2;
integer d1, d2;

begin
  rn = d1 + {$random} % (d2-d1+1);
end

endfunction

//-----------------------------------------------------
assign start_rise   = (start == 1 && start_reg == 0);
assign start_fall   = (start == 0 && start_reg == 1);
assign start_change = (start != start_reg);

assign start_w =  (START_CHANGE==0)? start : 
                 ((START_CHANGE==1)? start_rise :
                 ((START_CHANGE==2)? start_fall : start_change));

//-----------------------------------------------------
initial begin
  count = 0;
  limit = 0;
  count_enable = 0;
  pulse_reg = 0;
end

//-----------------------------------------------------
always @(posedge clk) begin
  if (!rst_n) pulse_reg <= 0;
  else begin
    start_reg <= start;
    if (start & !count_enable) begin
      limit = rn(MIN_CLOCKS,MAX_CLOCKS);
      count_enable <= 1;
      count <= 0;
    end
    else if (count == limit)
      count_enable <= 0;

    if (count == limit-1 && count_enable) pulse_reg <= 1;
    else pulse_reg <= 0;

    if (count_enable) 
      count <= count + 1;
  end
end

assign pulse = (limit == 0)? count_enable : pulse_reg;

endmodule  