module cover_bins ();

parameter COVER_NUM = 0;
parameter SSIZE = 20;

// Control variables
//------------------------------------
integer   display_status;

// Access variables
//------------------------------------
integer total_cov;
event exceeded, covered;
reg [8*SSIZE-1:0] exceeded_name;


reg [8*SSIZE-1:0] cover_name_mem  [0:COVER_NUM-1];
reg [0:31]        count_mem       [0:COVER_NUM-1];
reg [0:31]        max_limit_mem   [0:COVER_NUM-1];
reg [0:31]        min_limit_mem   [0:COVER_NUM-1];

integer i, cover_id;


// ------ACCESS TASK-------------------
task reset;
integer i;
begin
  display_status  = 0;
  cover_id        = 0;
  for (i=0; i<COVER_NUM; i=i+1) begin
    cover_name_mem[i]  = "";
    count_mem[i]       = 0;
    max_limit_mem[i]   = 32'hFFFFFFFF;
    min_limit_mem[i]   = 0;
    exceeded_name   = "";
  end
end
endtask

//-------------------------------------
function integer get_cover_id;
input [8*SSIZE-1:0] cover_expr;
integer i;
begin
  for (i=0; i<cover_id;i=i+1)
    if (cover_name_mem[i] == cover_expr)
      get_cover_id = i;
end
endfunction


//-------------------------------------
function integer get_total_cov;
input dummy;
integer i;
begin
  get_total_cov = 0;
  for (i=0; i<COVER_NUM; i=i+1)
    get_total_cov = get_total_cov + get_cov(i);
  get_total_cov = get_total_cov / COVER_NUM;
end
endfunction

//-------------------------------------
function integer get_cov;
input [8*SSIZE-1:0] cover_expr;
integer id;
begin
  id = get_cover_id(cover_expr);
  if (count_mem[id] >= min_limit_mem[id])    get_cov = 100;
  else if (min_limit_mem[id] == 0) get_cov = 100;
  else    get_cov = 100 * count_mem[id] / min_limit_mem[id];
end
endfunction

//----------ACCESS TASK-----------------
task add;
input [8*SSIZE-1:0]   cover_name;
input [0:31]        min_limit;
input [0:31]        max_limit;

begin
  if (max_limit < min_limit) begin
    $display("Interface Error: Max limit must be greater than Min Limit!");
    $finish;
  end
  #0
  cover_name_mem[cover_id] = cover_name;
  min_limit_mem[cover_id]  = min_limit;
  max_limit_mem[cover_id]  = max_limit;
  count_mem[cover_id] = 0;
  cover_id = cover_id + 1;
end
endtask

//----------ACCESS TASK-------------------
task change;
input [8*SSIZE-1:0] cover_name;
input [0:31]        count;
input [0:31]        min_limit;
input [0:31]        max_limit;
integer id;
begin
  if (max_limit < min_limit) begin
    $display("[%0t] <%m> Interface Error: Max limit less than Min Limit!", $time);
    $finish;
  end
  id = get_cover_id(cover_name);
  count_mem[id]      = count;
  min_limit_mem[id]  = min_limit;
  max_limit_mem[id]  = max_limit;
end
endtask

//----------ACCESS TASK----------------------
task sample;
input [8*SSIZE-1:0] cover_name;
integer id;
begin
  id = get_cover_id(cover_name);
  count_mem[id] = count_mem[id] + 1;
  if (count_mem[id] >= max_limit_mem[id])
    max_limit_reached(id);
  if (count_mem[id] >= min_limit_mem[id])
    min_limit_reached;
end
endtask

//-------------------------------------
task max_limit_reached;
input id;
integer id;
begin
  exceeded_name = cover_name_mem[id];
  -> exceeded;
  if (display_status >= 1)
    $display("[%0t] <%m> Error: Max limit reached for %s!", $time, exceeded_name);
end
endtask

//-------------------------------------
task min_limit_reached;
reg below_limit;
integer i;
begin
  below_limit = 0;
  for (i=0; i<COVER_NUM; i=i+1)
    if (count_mem[i] < min_limit_mem[i])
      below_limit = 1;
  if (below_limit == 0) begin
    -> covered;
    if (display_status >= 1)
      $display("[%0t] <%m> Info: Reaching 100 percent Coverage", $time);
  end
end
endtask

//---------ACCESS TASK--------------------
task report;
integer cov;
begin
  total_cov = 0;
  $display("");
  $display("		Coverage Report <%m>");
  $display("--------------------------------------------------------------------------");
  $display("           Cover name       Count      Min_limit  Max_limit     Coverage  ");
  $display("--------------------------------------------------------------------------");
  for (i=0; i<cover_id; i=i+1) begin
    if (count_mem[i] >= min_limit_mem[i])    cov = 100;
    else if (min_limit_mem[i] == 0)          cov = 100;
    else    cov = 100 * count_mem[i] / min_limit_mem[i];

    $write("%s %d ",cover_name_mem[i],count_mem[i]);
    if (min_limit_mem[i] == 0)     $write("          ");
    else 			   $write("%d ", min_limit_mem[i]);
    if (max_limit_mem[i] == 32'hFFFF_FFFF)  $write("          ");
    else 			   $write("%d ", max_limit_mem[i]);
    if (min_limit_mem[i] != 0)     $display(" %d percent", cov);
    else                           $display("");
    total_cov = total_cov + cov;
  end
  total_cov = total_cov/COVER_NUM;
  $display("\nTotal Coverage: %d percent", total_cov);
  $display("");
end
endtask
//-------------------------------------------
initial reset;

endmodule
