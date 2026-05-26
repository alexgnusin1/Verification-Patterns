module vc_count (clk, rst_n);

input clk, rst_n;
reg valid;
reg [31:0] val;

initial begin
  valid = 0;
  val = 0;
end

// --- Access Task ----------------------------
task reset;
  val = 0;
endtask

// --- Access Task ----------------------------
task on;
  valid = 1;
endtask

// --- Access Task ----------------------------
task off;
  valid = 0;
endtask

always @(posedge clk) begin
  if (!rst_n) begin
    valid <= 0;
    val <= 0;
  end 
  else
    if (valid) val <= val+1;
end

endmodule