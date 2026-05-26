//--------------------------------------------------------------
// Reset Synchronization with the test mode bypass 
//--------------------------------------------------------------
module vc_sync_rst (clk, test_mode, rst_in, rst_out);
input clk, test_mode, rst_in;
output rst_out;

  wire sync_in, sync_out;
  
  assign sync_in = (test_mode)? sync_out : rst_in;
  assign rst_out = (test_mode)? rst_in : (sync_out & rst_in);
  vc_sync rst_sync (clk, 1'b1, sync_in, sync_out);

endmodule
