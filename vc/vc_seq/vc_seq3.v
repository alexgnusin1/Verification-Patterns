module vc_seq3 (clk, rst_n, c1, c2, c3, match);

input clk, rst_n;
input c1, c2, c3;
output match;

parameter C1_MIN = 0;
parameter C1_MAX = 0;
parameter C2_MIN = 0;
parameter C2_MAX = 0;
parameter C3_MIN = 0;

parameter REPORT_ERROR = 1;
parameter COUNT_WIDTH = 8;

parameter WAIT  = 0;
parameter S1    = 1;
parameter S2    = 2;
parameter S3    = 3;


reg error, match;
reg [2:0] state, next;
reg [COUNT_WIDTH-1:0] count1, count2, count3;

initial
  if (C1_MAX < C1_MIN | C2_MAX < C2_MIN | C3_MIN == 0) begin
    $display("<%m> CONFIGURATION ERROR: Please correct parameters");
    $finish;
  end

//---------------------------------------------
always @(state or c1 or c2 or c3 or count3) begin
  next = WAIT;
  match = 0;
  error = 0;

  case (state)

  WAIT: if (c1)                                    next = S1;
          else if (c2 & C1_MIN == 0)               next = S2;
          else if (c3 & C1_MIN == 0 & C2_MIN == 0)
            if (C3_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S3;

  S1:   if (count1 < C1_MIN)
          if (c1)                                  next = S1;
          else               begin   error = 1;    next = WAIT; end        
        else if (count1 <= C1_MAX)
          if (c2)                                  next = S2;
          else if (c1)                             next = S1;
          else if (c3 & C2_MIN == 0)
            if (C3_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S3;
          else               begin   error = 1;    next = WAIT; end   
        else                 begin   error = 1;    next = WAIT; end  

  S2:   if (count2 < C2_MIN)
          if (c2)                                  next = S2;
          else               begin   error = 1;    next = WAIT; end        
        else if (count2 <= C2_MAX)
          if (c3)
            if (C3_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S3;
          else if (c2)                             next = S2;
          else               begin   error = 1;    next = WAIT; end 
        else                 begin   error = 1;    next = WAIT; end  

  S3:   if (count3 < C3_MIN-1)
          if (c3)                                  next = S3;
          else               begin   error = 1;    next = WAIT; end
        else if (count3 == C3_MIN-1)
          if (c3)            begin   match = 1;    next = WAIT; end
          else               begin   error = 1;    next = WAIT; end

  endcase
end

//---------------------------------------------
always @(posedge clk)
  if (!rst_n) begin state <= WAIT; next <= WAIT; end
  else begin
    if (next == S1) count1 <= count1 + 1;
    else            count1 <= 0;
    if (next == S2) count2 <= count2 + 1;
    else            count2 <= 0;
    if (next == S3) count3 <= count3 + 1;
    else            count3 <= 0;
    state <= next;
    if (error) 
      if (REPORT_ERROR) $display("[%0t] <%m> ERROR: sequence mismatch!", $time);
  end

endmodule
