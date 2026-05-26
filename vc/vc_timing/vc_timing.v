module vc_timing (clk, reset_n, start, test);
parameter CWIDTH = 8;
input clk, reset_n, start, test;

event rose, fell;
reg start_reg, test_reg;
reg [CWIDTH-1:0] r2r, r2f, f2r, f2f;
reg start_rise, start_fall;

//------------------------------------------------
task reset;
begin
  r2r = 0;  r2f = 0;
  f2r = 0;  f2f = 0;
  start_rise = 0;
  start_fall = 0;
  start_reg  = 0;
  test_reg   = 0;
end
endtask

//------------------------------------------------
initial reset;

//------------------------------------------------
always @(posedge clk) begin
  if (!reset_n) reset;
  else begin
    start_reg <= start;
    test_reg  <= test;
  end
  if (start_reg == 0 && start == 1) begin       // start rise
    r2r <=1; r2f <=1;
    if (start_fall) begin
      f2r <= f2r + 1; 
      f2f <= f2f + 1;
    end
    start_rise <= 1; 
  end
  else if (start_reg == 1 && start == 0) begin  // start fall
    f2r <= 1; f2f <=1;
    if (start_rise) begin
      r2r <= r2r + 1; 
      r2f <= r2f + 1;
    end
    start_fall <= 1; 
  end
  else begin
    if (start_rise) begin
      r2r <= r2r + 1;    r2f <= r2f + 1;
    end
    if (start_fall) begin
      f2r <= f2r + 1;    f2f <= f2f + 1;
    end
   end
  if (test_reg == 0 && test == 1) begin        // test rise
    -> rose;
    f2r <= 0;
    r2r <= 0;
    if (~(start_reg == 0 && start == 1))       // no start rise
      start_rise <= 0;
  end
  if (test_reg == 1 && test == 0) begin        // test fall
    -> fell;
    r2f <= 0;
    f2f <= 0;
    if (~(start_reg == 1 && start == 0))       // no start fall
      start_fall <= 0;
  end
end

endmodule

