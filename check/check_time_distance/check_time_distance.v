module check_time_distance(cond1, cond2);

parameter MIN_TIME = 0;
parameter MAX_TIME = 64'hFFFF_FFFF_FFFF_FFFF;

input cond1, cond2;
time start_time;
event err,ok;
reg sampling;
initial sampling = 0;

//-----------------------------------------
always @(posedge cond1) begin
  start_time = $time;
  sampling = 1;
end

//-----------------------------------------
always @(posedge cond2) begin
  if (sampling) begin
    sampling = 0;
    if ($time - start_time > MAX_TIME) begin
      $display("[%0t] <%m> ERROR: Time interval (%0t) more than defined maximum (%0t)",
         $time, $time - start_time, MAX_TIME);
      -> err;
    end
    else if ($time - start_time < MIN_TIME) begin
      $display("[%0t] <%m> ERROR: Time interval (%0t) less than defined minimum (%0t)",
        $time, $time - start_time, MIN_TIME);
      -> err;
    end
    else 
      -> ok;
  end
end

endmodule
