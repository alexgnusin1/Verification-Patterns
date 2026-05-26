module vc_switch (clk, rst_n, start_in, end_in, switch_out);
parameter START_EVENT = 0;
parameter END_EVENT = 0;

input  clk, rst_n;
input  start_in, end_in;
output switch_out;
reg    switch_reg;
reg  start_reg, end_reg;
wire start_w,   end_w;

/* ---------------------------------------------
CHANGE:   
0 - rising edge
1 - falling edge
2 - change
3 - level
-----------------------------------------------*/

assign start_rise   = (start_in == 1 && start_reg == 0);
assign start_fall   = (start_in == 0 && start_reg == 1);
assign start_change = (start_in != start_reg);

assign start_w =  (START_EVENT==0)? start_in : 
                 ((START_EVENT==1)? start_rise :
                 ((START_EVENT==2)? start_fall : start_change));

assign end_rise   = (end_in == 1 && end_reg == 0);
assign end_fall   = (end_in == 0 && end_reg == 1);
assign end_change = (end_in != end_reg);

assign end_w =    (END_EVENT==0)? end_in : 
                 ((END_EVENT==1)? end_rise :
                 ((END_EVENT==2)? end_fall : end_change));

always @(posedge clk) begin
  if (!rst_n) begin
    switch_reg <= 0;
    start_reg <= 0;
    end_reg   <= 0;
  end 
  else begin
    start_reg <= start_in;
    end_reg   <= end_in;
    if (start_w && !switch_reg)     switch_reg <= 1;
    else if (end_w && switch_reg)   switch_reg <= 0;
  end
end

assign switch_out = switch_reg;

endmodule