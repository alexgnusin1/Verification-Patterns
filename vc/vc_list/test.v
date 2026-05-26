`include "vc_list.v"

module test;

integer i;
vc_list #(8,4) list ();

initial  begin
  #0;

// Checking all entries (datapath check)
// ------------------------------------
  $display("\nTC info: check_all demonstration");
  for (i=0; i<4; i=i+1)
    #10 list.add(i);

  for (i=0; i<4; i=i+1)
    #10 list.check_all(i);

// Checking first entry only (FIFO -like operation)
// ---------------------------------------------
  $display("\nTC info: check_first demonstration");
  for (i=0; i<4; i=i+1)
    #10 list.add(i);

  for (i=0; i<4; i=i+1)
    #10 list.check_first(i);

// Checking last entry only (FILO -like operation)
// ---------------------------------------------
  $display("\nTC info: check_last demonstration");
  for (i=0; i<4; i=i+1)
    #10 list.add(i);

  for (i=3; i>=0; i=i-1)
    #10 list.check_last(i);

// Checking last entry with reordering
// ------------------------------------
  $display("\nTC info: check_last demonstration with reordering");
  for (i=0; i<4; i=i+1)
    #10 list.add(i);
  
  list.reorder(1,2);

  #10 list.check_last(3);
  #10 list.check_last(1);
  #10 list.check_last(2);
  #10 list.check_last(0);

  #10 $finish;
end

always @(list.err) 
  $display("[%0t] <%m> Error: %0d does not match", $time, list.data_reg);

always @(list.ok) 
  $display("[%0t] <%m> Info: Match found for %0d",  $time, list.data_reg);

endmodule