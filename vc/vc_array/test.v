`include "vc_array.v"

module test ();

integer number, i;

vc_array #(4,10) my_array ();

initial begin
  #10
  for (i=0; i<10; i=i+1)
    my_array.set(i,i);    
   
  for (i=0; i<10; i=i+1)
    $display("Array data[%0d] = %0d", i, my_array.get(i));
  
  // Shuffling array
  // ------------------------------
  $display("\nShuffling an array...");
  my_array.shuffle;
  my_array.dumpd;


  // Minimum & Maximum data indexes
  // ------------------------------
  $display("\nMinimum & Maximum values...");
  $display("Min data index: %0d", my_array.min_index(0));
  $display("Min data value: %0d\n", my_array.min_data(0));
  $display("Max data index: %0d", my_array.max_index(0));
  $display("Max data value: %0d", my_array.max_data(0));
  my_array.dumpd;

  // Matching array values
  // ------------------------------
  $display("\nMatching an array...");
  if (my_array.match(6)) 
    $display("\nMatched index is %0d", my_array.match_index(6));

  // Sorting array values
  // ------------------------------
  $display("\nSorting an array...");
  my_array.sort;
  my_array.dumpd;


  #10 $finish;
end

endmodule  
