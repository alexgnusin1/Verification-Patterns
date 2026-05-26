module vc_array ();

parameter NUMB = 8;
parameter NUMW = 10;

reg [NUMB-1:0] mem [0:NUMW-1];
reg [NUMB-1:0] result;
integer ptr, i;

initial begin
  for (i=0; i<= NUMW-1; i=i+1)
    mem[i] = 0;
end


//===========================================
function integer rn;
input d1, d2;
integer d1, d2;

begin
  rn = d1 + {$random} % (d2-d1+1);
end
endfunction

//============================================
task set;
input index;
input [NUMB-1:0] data;
integer index;

mem[index] = data;
endtask

//============================================
function [NUMB-1:0] get;
input index;
integer index;

get = mem[index];
endfunction

//============================================
task swap;
input n1, n2;
integer n1, n2;
reg [NUMB-1:0] tmp_reg;
begin
  tmp_reg = mem[n1];
  mem[n1] = mem[n2];
  mem[n2] = tmp_reg;
end
endtask  

//============================================
task shuffle;
  for (i=0; i<=NUMW-1; i=i+1) swap(i,rn(i,NUMW-1));
endtask


//============================================
function integer min_index;
input dummy;
reg [NUMB-1:0] tmp_reg;
integer tmp_id;
begin
  tmp_reg = mem[0];
  for (i=0; i<= NUMW-1; i=i+1)
    if (tmp_reg >= mem[i]) begin
      tmp_reg = mem[i];
      tmp_id = i;
    end
  min_index = tmp_id;
end
endfunction

//============================================
function[NUMB-1:0]  min_data;
input dummy;
reg [NUMB-1:0] tmp_reg;
integer tmp_id;
begin
  tmp_reg = mem[0];
  for (i=0; i<= NUMW-1; i=i+1)
    if (tmp_reg >= mem[i]) begin
      tmp_reg = mem[i];
      tmp_id = i;
    end
  min_data = tmp_reg;
end
endfunction


//============================================
function integer max_index;
input dummy;
reg [NUMB-1:0] tmp_reg;
integer tmp_id;
begin
  tmp_reg = mem[0];
  for (i=0; i<= NUMW-1; i=i+1)
    if (tmp_reg <= mem[i]) begin
      tmp_reg = mem[i];
      tmp_id = i;
    end
  max_index = tmp_id;
end
endfunction

//============================================
function[NUMB-1:0]  max_data;
input dummy;
reg [NUMB-1:0] tmp_reg;
integer tmp_id;
begin
  tmp_reg = mem[0];
  for (i=0; i<= NUMW-1; i=i+1)
    if (tmp_reg <= mem[i]) begin
      tmp_reg = mem[i];
      tmp_id = i;
    end
  max_data = tmp_reg;
end
endfunction

//============================================
task sort;
reg [NUMB-1:0] tmp_reg;
integer i,j;

begin
  for (i = NUMW-2; i>=0; i=i-1) 
    for (j = 0; j<=i; j=j+1) 
      if (mem[j] > mem[j+1]) swap(j,j+1);
end
endtask

//============================================
function match;
input [NUMB-1:0] data;

begin
  match = 0;
  for (i=0; i<= NUMW-1; i=i+1)
    if (mem[i] == data)
      match = 1;
end
endfunction

//============================================
function integer match_index;
input [NUMB-1:0] data;

begin
  match_index = 0;
  for (i=0; i<= NUMW-1; i=i+1)
    if (mem[i] == data)
      match_index = i;
end
endfunction


//============================================
task dumpd;
begin
  $display("\n<%m> report");
  for (i=0; i<=NUMW-1; i=i+1) 
    $display("  data[%0d] = %d", i, mem[i]);
end
endtask


//============================================
task dumph;
begin
  $display("\n<%m> report");
  for (i=0; i<=NUMW-1; i=i+1) 
    $display("  data[%0d] = %h", i, mem[i]);
end
endtask


endmodule



