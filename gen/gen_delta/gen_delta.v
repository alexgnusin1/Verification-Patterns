module gen_delta (clk, rst_n, data_in, data_out);

parameter NEG_MIN = 0;
parameter NEG_MAX = 0;
parameter POS_MIN = 0;
parameter POS_MAX = 0;

parameter BWIDTH    = 0;

input  clk, rst_n;
input  [BWIDTH-1:0] data_in;
output [BWIDTH-1:0] data_out;

`ifdef CONTROL_MODE 
reg [BWIDTH-1:0] data_out;
reg [BWIDTH-1:0] data_reg;

//-----------------------------------------------------
function integer rn_delta;
input   data, neg_min, neg_max, pos_min, pos_max;
integer data, neg_min, neg_max, pos_min, pos_max;

integer range, border, rand_num;
begin
  border = neg_max-neg_min;
  range  = border + (pos_max-pos_min);
  rand_num = {$random} % (range+1);
  if (rand_num <= border)
    rn_delta = data - neg_min - rand_num;
  else 
    rn_delta = data + pos_min + rand_num - border;
end  
endfunction

//-----------------------------------------------------
always @(posedge clk) begin
  if (!rst_n) data_out <= 0;
  else begin
    data_reg <= data_in;
    if (data_in !== data_reg) begin
      data_out = rn_delta(data_in,NEG_MIN,NEG_MAX,POS_MIN,POS_MAX);
    end
  end
end
    
`else 
assign data_out = data_in;
`endif

endmodule