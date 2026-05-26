module vc_list;

parameter BITW = 0;
parameter DEPTH = 0;

reg [BITW-1:0] data_mem [0:DEPTH];
reg [BITW-1:0] data_reg;

integer ptr, i; 
event ok, err;

initial begin
  ptr = 0;
  if (BITW == 0 || DEPTH == 0) 
    $display("<%m> Error: vc_list parameters not defined properly!");
end


//------------------------------
// Access task: add data to list
//------------------------------
task add;
input [BITW-1:0] data;
begin
  data_mem[ptr] = data;
  ptr = ptr+1;
end
endtask

//----------------------------
task rm;
input [0:31] in_ptr;
begin
  for (i=in_ptr; i<ptr; i=i+1)
    data_mem[i] = data_mem[i+1];
  ptr = ptr-1;
end
endtask

//---------------------------------------------------------
// Access task: check all stored data against the given one
// In a case of match, remove matching data and assert "ok"
// If match in not found, flag error with "err" event
//---------------------------------------------------------
task check_all;
input [BITW-1:0] curr_data;
reg match_reg;

begin
  data_reg = curr_data;
  match_reg = 0;
  for (i=0; i<=ptr; i=i+1) begin
    if (match_reg == 0) begin
      if (curr_data == data_mem[i]) begin
        rm(i);
        match_reg = 1;
      end
    end
  end
  if (match_reg == 0) -> err;
  else                -> ok;
end
endtask

//---------------------------------------------------------
// Access task: check the oldest stored data against the given one
// In a case of match, remove matching data and assert "ok"
// If match in not found, flag error with "err" event
//---------------------------------------------------------
task check_first;
input [BITW-1:0] curr_data;

begin
  data_reg = curr_data;
  if (curr_data == data_mem[0]) begin
    -> ok;
    rm(0);
  end
  else 
    -> err;
end
endtask

//---------------------------------------------------------
// Access task: check the newest stored data against the given one
// In a case of match, remove matching data and assert "ok"
// If match in not found, flag error with "err" event
//---------------------------------------------------------
task check_last;
input [BITW-1:0] curr_data;

begin
  data_reg = curr_data;
  if (curr_data == data_mem[ptr-1]) begin
    -> ok;
    rm(ptr-1);
  end
  else 
    -> err;
end
endtask

//---------------------------------------------------------
// Access task: reorder two stored words in list.
// Use it along with check_last to match reordered transactions
//---------------------------------------------------------
task reorder;
input ptr1, ptr2;
integer ptr1, ptr2;
reg [BITW-1:0] tmp_reg;

begin
  if (ptr1 > ptr || ptr2 > ptr) 
    -> err;
  else begin 
    tmp_reg        = data_mem[ptr1];
    data_mem[ptr1] = data_mem[ptr2];
    data_mem[ptr2] = tmp_reg;
  end
end
endtask


//---------------------------------------------------------
// Access task: reset list: remove all list entries
//---------------------------------------------------------
task reset;
begin
  for (i=ptr; i>= 0; i=i-1)
    rm(i);
end
endtask


//---------------------------------------------------------
// Check remainders at the end of simulation
//---------------------------------------------------------
`ifdef TOP_FINISH
always @(top.finish) begin
  if (ptr != 0) begin
    $display("<%m> Error: List is not empty!",);
    -> err;
  end
end
`endif



endmodule



    

