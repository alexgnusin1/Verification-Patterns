module gen_pulse (clk, rst_n, start_event, data_in, data_out);

parameter MIN_CLKS = 0;
parameter MAX_CLKS = 0;

input  clk, rst_n;
input  start_event;
input  data_in;
output data_out; 

`ifdef CONTROL_MODE 

reg data_change;

reg [31:0] clock_count;
reg [31:0] clock_limit;
reg        count_enable;

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
  data_change  = 0;
end

//-----------------------------------------------------
always @(posedge clk) begin
  if (!rst_n) clock_count <= 0;
  else begin
    data_change <= 0;
    if (start_event && count_enable == 0) begin
      clock_count  <= 0;
      count_enable <= 1;
      clock_limit  <= rn(MIN_CLKS,MAX_CLKS);
    end
    if (clock_count == clock_limit-1) begin
      data_change <= 1;
      count_enable <= 0;
    end
    if (count_enable)
      clock_count <= clock_count + 1;
  end
end

assign data_out = data_change | data_in; 

`else 
assign data_out = data_in;
`endif

endmodule