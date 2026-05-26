//--------------------------------------------------------------
// CDC syncronization register
//--------------------------------------------------------------
module vc_sync (clk, rst_n, din, dout);
parameter BWIDTH=1;
parameter INVERT=0;
input clk, rst_n;
input  [BWIDTH-1:0] din;
output [BWIDTH-1:0] dout;
reg    [BWIDTH-1:0] sync1, sync2;

`ifdef VPL_VERIFICATION

reg    [BWIDTH-1:0] change;
integer i;

//-----------------------------------------------------
task check_single_change;
integer i, sum;
begin
  sum = 0;
  for (i=0; i<BWIDTH; i=i+1)
    if (din[i] != sync1[i])
      sum = sum + 1;
  if (sum > 1)
    $display("Error %m: multibit change, @%0t", $time);
end
endtask

//-----------------------------------------------------
always @(negedge clk or negedge rst_n) begin
  if (~rst_n) change <= 0;
  else begin
    if (din != sync1) check_single_change;
    for (i=0; i<BWIDTH; i=i+1) begin
      if (din[i] != sync1[i]) begin
        if (change[i])
          $display("[%0t] <%m> Error: too narrow pulse for bit %0d", $time, i);
        change[i] <= 1;
      end
      else change[i] <= 0;
    end
  end
end

`endif

//-----------------------------------------------------
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    sync1 <= 0;
    sync2 <= 0;
  end
  else begin
    sync1 <= din;

`ifdef VPL_VERIFICATION

    for (i=0; i<BWIDTH; i=i+1) begin
      if ((^din[i]) === 1'hx )
        $display("[%0t] <%m> Error: X value found for bit %0d", $time, i);
      else if (change[i])
        if (INVERT) sync2[i] <= ~sync1[i];
        else        sync2[i] <= $random;    // May use top-level seed value here
      else
        sync2[i] <= sync1[i];
    end

`else
        
    sync2 <= sync1;

`endif

  end
end

assign dout = sync2;

endmodule




