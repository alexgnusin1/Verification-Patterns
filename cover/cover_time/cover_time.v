module cover_time (clk, rst_n, start_event, end_event);

parameter COVER_NUM = 0;
parameter SSIZE = 20;

input clk, rst_n;
input start_event, end_event;

// Control variables
//------------------------------------
integer   display_status;

// Access variables
//------------------------------------
integer total_cov;
event covered;

reg [8*SSIZE-1:0] cover_name_mem  [0:COVER_NUM-1];
reg [31:0]        count_mem       [0:COVER_NUM-1];
reg [31:0]        min_range_mem   [0:COVER_NUM-1];
reg [31:0]        max_range_mem   [0:COVER_NUM-1];
reg [31:0]        cover_goal_mem   [0:COVER_NUM-1];

integer i, cover_id;
reg [15:0]        clock_count;
reg               count_flag;

// ------ACCESS TASK-------------------
task reset;
integer i;
begin
  display_status  = 0;
  cover_id        = 0;
  count_flag      = 0;
  clock_count     = 0;
  for (i=0; i<COVER_NUM; i=i+1) begin
    cover_name_mem[i]  = "";
    count_mem[i]       = 0;
    max_range_mem[i]   = 32'hFFFFFFFF;
    min_range_mem[i]   = 0;
    cover_goal_mem[i]   = 0;
  end
end
endtask

//-------------------------------------
function integer get_cover_id;
input [8*SSIZE-1:0] cover_name;
integer i;
begin
  for (i=0; i<cover_id;i=i+1)
    if (cover_name_mem[i] == cover_name)
      get_cover_id = i;
end
endfunction


//-------------------------------------
function integer get_total_cov;
input dummy;
integer i;
begin
  get_total_cov = 0;
  for (i=0; i<cover_id; i=i+1)
    get_total_cov = get_total_cov + get_cov(i);
  get_total_cov = get_total_cov / cover_id;
end
endfunction

//-------------------------------------
function integer get_cov;
input [8*SSIZE-1:0] cover_name;
integer id;
begin
  id = get_cover_id(cover_name);
  if (count_mem[id] >= cover_goal_mem[id])    get_cov = 100;
  else if (cover_goal_mem[id] == 0) get_cov = 100;
  else    get_cov = 100 * count_mem[id] / cover_goal_mem[id];
end
endfunction

//----------ACCESS TASK-----------------
task add;
input [8*SSIZE-1:0] cover_name;
input [31:0]        min_range;
input [31:0]        max_range;
input [31:0]        cover_goal;

begin
  if (max_range < min_range) begin
    $display("<%m> Interface Error: Max range must be greater than Min Range!");
    $finish;
  end
  #0
  cover_name_mem[cover_id] = cover_name;
  cover_goal_mem[cover_id] = cover_goal;
  min_range_mem[cover_id]  = min_range;
  max_range_mem[cover_id]  = max_range;
  count_mem[cover_id] = 0;
  cover_id = cover_id + 1;
end
endtask

//----------ACCESS TASK-------------------
task change;
input [8*SSIZE-1:0] cover_name;
input [31:0]        min_range;
input [31:0]        max_range;
input [31:0]        cover_goal;
integer id;
begin
  if (max_range < min_range) begin
    $display("[%0t] <%m> Interface Error: Max range less than Min Range!", $time);
    $finish;
  end
  id = get_cover_id(cover_name);
  cover_goal_mem[id] = cover_goal;
  min_range_mem[id]  = min_range;
  max_range_mem[id]  = max_range;
end
endtask

//-------------------------------------
task cover_goal_reached;
reg below_range;
integer i;
begin
  below_range = 0;
  for (i=0; i<cover_id; i=i+1)
    if (count_mem[i] < min_range_mem[i])
      below_range = 1;
  if (below_range == 0) begin
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
  $display("		Time Coverage Report <%m>");
  $display("------------------------------------------------------------------------------------");
  $display("           Cover name    Min_range   Max_range     Hits       Goal       Coverage  ");
  $display("------------------------------------------------------------------------------------");
  for (i=0; i<cover_id; i=i+1) begin
    if (count_mem[i] >= cover_goal_mem[i])    cov = 100;
    else if (cover_goal_mem[i] == 0)          cov = 100;
    else    cov = 100 * count_mem[i] / cover_goal_mem[i];

    $write("%s ",cover_name_mem[i]);
    if (min_range_mem[i] == 0)     $write("          ");
    else 			   $write("%d ", min_range_mem[i]);
    if (max_range_mem[i] == 32'hFFFF_FFFF)  $write("          ");
    else 			   $write("%d ", max_range_mem[i]);
    $write("%d %d", count_mem[i], cover_goal_mem[i]);
    if (min_range_mem[i] != 0)     $display(" %d percent", cov);
    else                           $display("");
    total_cov = total_cov + cov;
  end
  total_cov = total_cov/cover_id;
  $display("\nTotal Coverage: %d percent", total_cov);
  $display("");
end
endtask

//-------------------------------------------
task check_timing;
input clock_num;
integer clock_num;
begin
  for (i=0; i<cover_id;i=i+1) begin
    if (min_range_mem[i] <= clock_num && max_range_mem[i] >= clock_num) begin
      count_mem[i] = count_mem[i] + 1;
      if (count_mem[i] >= cover_goal_mem[i])
        cover_goal_reached;
    end
  end
end
endtask

//-------------------------------------------
initial reset;

always @(posedge clk) begin
  if (!rst_n) reset;
  else begin
    if (start_event) begin
      clock_count <= 0;
      count_flag  <= 1;
    end
    if (end_event) begin
      if (count_flag)
        check_timing(clock_count);
      count_flag <= 0;
    end
    if (count_flag) 
      clock_count <= clock_count + 1;
  end
end

endmodule
