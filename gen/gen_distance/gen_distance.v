module gen_distance (clk, rst_n, data_out);

parameter MIN_CLKS = 0;
parameter MAX_CLKS = 0;

input clk, rst_n;
output data_out; 
reg data_out;

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
  data_out     = 0;
  clock_limit  = rn(MIN_CLKS, MAX_CLKS);
end

//-----------------------------------------------------
always @(posedge clk) begin
  if (!rst_n) data_out <= 0;
  else begin
    if (clock_count == clock_limit) begin
      clock_count  <= 0;
      data_out <= 1;
      clock_limit <= rn(MIN_CLKS,MAX_CLKS);
    end
    else begin
      clock_count <= clock_count + 1;
      data_out <= 0;
    end
  end
end

endmodule