//================================================================
// Function: returns random value between given limits
// Inputs : low_limit, high_limit 
//================================================================
function integer rn;
input d1, d2;
integer d1, d2;

begin
  rn = d1 + {$random(seed)} % (d2-d1+1);
end
endfunction

//================================================================
// Function: returns Low random value between given limits 
// Inputs : low_limit, high_limit 
//================================================================
function integer rl;
input d1, d2;
integer d1, d2;
integer diff;

begin
  diff = rn(d1,d2);
  rl = rn(d1, diff);
end
endfunction

//================================================================
// Function: returns High random value between given limits
// Inputs : low_limit, high_limit 
//================================================================
function integer rh;
input d1, d2;
integer d1, d2;
integer diff;

begin
  diff = rn(d1,d2);
  rh = rn(diff, d2);
end
endfunction


//====================================================================
// Function: weighted-random choise functions : 2, 3, 4, and 5, inputs
// Inputs: (input_value1, weight1, input_value2, weight2, ...)
// Usage example: uncompletely specified FSM models
//====================================================================

function integer rnc2;
input s1, p1, s2, p2;
integer s1, p1, s2, p2;

begin
  if ({$random}%(p1+p2) < p1)
    rnc2 = s1;
  else 
    rnc2 = s2;
end
endfunction

//------------------------------------
function integer rnc3;
input s1, p1, s2, p2, s3, p3;
integer s1, p1, s2, p2, s3, p3;
integer num;
begin
  num = {$random}%(p1+p2+p3);
  if      (num < p1) rnc3 = s1;
  else if (num < p2) rnc3 = s2;
  else               rnc3 = s3;
end
endfunction

//------------------------------------
function integer rnc4;
input s1, p1, s2, p2, s3, p3, s4, p4;
integer s1, p1, s2, p2, s3, p3, s4, p4;
integer num;
begin
  num = {$random}%(p1+p2+p3+p4);
  if      (num < p1) rnc4 = s1;
  else if (num < p2) rnc4 = s2;
  else if (num < p3) rnc4 = s3;
  else               rnc4 = s4;
end
endfunction

//------------------------------------
function integer rnc5;
input s1, p1, s2, p2, s3, p3, s4, p4, s5, p5;
integer s1, p1, s2, p2, s3, p3, s4, p4, s5, p5;
integer num;
begin
  num = {$random}%(p1+p2+p3+p4+p5);
  if      (num < p1) rnc5 = s1;
  else if (num < p2) rnc5 = s2;
  else if (num < p3) rnc5 = s3;
  else if (num < p4) rnc5 = s4;
  else               rnc5 = s5;
end
endfunction
