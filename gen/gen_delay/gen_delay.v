module gen_delay (clk, reset_n, data_in, data_out);
  parameter MIN_CLKS = 1;
  parameter MAX_CLKS = 1;
  parameter BWIDTH = 1;

  input clk, reset_n;
  input [BWIDTH-1:0] data_in;
  output [BWIDTH-1:0] data_out;

  //----ACCESS REG------------------------------  
  reg   [BWIDTH-1:0] data_out;
  //--------------------------------------------  

  reg [BWIDTH-1:0] delay_reg[0:MAX_CLKS-1];
  reg [31:0] random_delay;
  integer i;

  //-----------------------------------------------------
  function integer rn;
  input d1, d2;
  integer d1, d2;
 
  begin
    rn = d1 + {$random} % (d2-d1+1);
  end

  endfunction
  //--------------------------------------------  
  task reset;
  begin
    random_delay = rn(MIN_CLKS,MAX_CLKS);
    for (i=0; i<MAX_CLKS; i=i+1)
      delay_reg[i] = 0;
    data_out = 0;
  end
  endtask

  //--------------------------------------------
  initial reset;
  //--------------------------------------------
  always @(posedge clk) begin
    if (!reset_n) reset;
    else begin
      delay_reg[0] <= data_in;
      if (data_in != delay_reg[0]) 
        random_delay <= rn(MIN_CLKS,MAX_CLKS);
      for (i = 1; i < random_delay; i=i+1) 
        delay_reg[i] <= delay_reg[i-1];
      data_out <= delay_reg[random_delay-1];
    end
  end
 
endmodule
