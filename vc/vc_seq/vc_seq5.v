module vc_seq5 (clk, rst_n, c1, c2, c3, c4, c5, match);

input clk, rst_n;
input c1, c2, c3, c4, c5;
output match;

parameter C1_MIN = 0;
parameter C1_MAX = 0;
parameter C2_MIN = 0;
parameter C2_MAX = 0;
parameter C3_MIN = 0;
parameter C3_MAX = 0;
parameter C4_MIN = 0;
parameter C4_MAX = 0;
parameter C5_MIN = 0;

parameter COUNT_WIDTH = 8;

parameter WAIT  = 0;
parameter S1    = 1;
parameter S2    = 2;
parameter S3    = 3;
parameter S4    = 4;
parameter S5    = 5;


reg error, match;
reg [2:0] state, next;
reg [COUNT_WIDTH-1:0] count1, count2, count3, count4, count5;

initial
  if (C1_MAX < C1_MIN | C2_MAX < C2_MIN | C3_MAX < C3_MIN | C4_MAX < C4_MIN | C5_MIN == 0) begin
    $display("<%m> CONFIGURATION ERROR: Please correct parameters");
    $finish;
  end

//---------------------------------------------
always @(state or c1 or c2 or c3 or c4 or c5 or count5) begin
  next = WAIT;
  match = 0;
  error = 0;

  case (state)

  WAIT: if (c1)                                    next = S1;
          else if (c2 & C1_MIN == 0)               next = S2;
          else if (c3 & C1_MIN == 0 & C2_MIN == 0) next = S3;
          else if (c4 & C1_MIN == 0 & C2_MIN == 0 & C3_MIN == 0 )
                                                   next = S4;
          else if (c5 & C1_MIN == 0 & C2_MIN == 0 & C3_MIN == 0 & C4_MIN == 0)
            if (C5_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S5;

  S1:   if (count1 < C1_MIN)
          if (c1)                                  next = S1;
          else               begin   error = 1;    next = WAIT; end        
        else if (count1 <= C1_MAX)
          if (c2)                                  next = S2;
          else if (c1)                             next = S1;
          else if (c3 & C2_MIN == 0)		   next = S3;
          else if (c4 & C2_MIN == 0 & C3_MIN == 0) next = S4;
          else if (c5 & C2_MIN == 0 & C3_MIN == 0 & C4_MIN == 0)
            if (C5_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S5;
          else               begin   error = 1;    next = WAIT; end   
        else                 begin   error = 1;    next = WAIT; end  

  S2:   if (count2 < C2_MIN)
          if (c2)                                  next = S2;
          else               begin   error = 1;    next = WAIT; end        
        else if (count2 <= C2_MAX)
          if (c3)                                  next = S3;
          else if (c2)                             next = S2;
          else if (c4 & C3_MIN == 0)               next = S4;
          else if (c5 & C3_MIN == 0 & C4_MIN == 0)
            if (C5_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S5;
          else               begin   error = 1;    next = WAIT; end   
        else                 begin   error = 1;    next = WAIT; end  

  S3:   if (count3 < C3_MIN)
          if (c3)                                  next = S3;
          else               begin   error = 1;    next = WAIT; end        
        else if (count3 <= C3_MAX)
          if (c4)                                  next = S4;
          else if (c3)                             next = S3;
          else if (c5 & C4_MIN == 0)
            if (C5_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S5;
          else               begin   error = 1;    next = WAIT; end 
        else                 begin   error = 1;    next = WAIT; end  

  S4:   if (count4 < C4_MIN)
          if (c4)                                  next = S4;
          else               begin   error = 1;    next = WAIT; end        
        else if (count4 <= C4_MAX)
          if (c5)
            if (C5_MIN == 1) begin   match = 1;    next = WAIT; end
            else                                   next = S5;
          else if (c4)                             next = S4;
          else               begin   error = 1;    next = WAIT; end 
        else                 begin   error = 1;    next = WAIT; end  

  S5:   if (count5 < C5_MIN-1)
          if (c5)                                  next = S5;
          else               begin   error = 1;    next = WAIT; end
        else if (count5 == C5_MIN-1)
          if (c5)            begin   match = 1;    next = WAIT; end
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
    if (next == S4) count4 <= count4 + 1;
    else            count4 <= 0;
    if (next == S5) count5 <= count5 + 1;
    else            count5 <= 0;
    state <= next;
    if (error) 
      $display("[%0t] <%m> ERROR: sequence mismatch!", $time);
  end

endmodule
