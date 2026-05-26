`include "vc_seq2.v"
`include "vc_seq3.v"
`include "vc_seq4.v"
`include "vc_seq5.v"

module test;

reg a, b, c, d, e, f;

reg clk, rst_n;
always #5 clk <= ~clk;

vc_seq3 #(1,1, 1,1, 1) seq1 (clk, rst_n, a_rose, b, c, match1);
vc_seq3 #(1,2, 1,2, 2) seq2 (clk, rst_n, a|b, c|d, e|f, match2);
vc_seq3 #(1,1, 1,3, 1, 1) seq3 (clk, rst_n, match1, d, e, match3); 
vc_seq5 #(1,1, 2,5, 1,1, 1,1, 3, 1) seq4 (clk, rst_n,a,b,c,d,e|f|a|b, match4);

vc_seq2 #(1,1, 3) seq5 (clk, rst_n, a, b|c|d, match5);
vc_seq3 #(1,1, 1,1, 3) seq6 (clk, rst_n, a, b, c|d|e, match6);
vc_seq4 #(1,1, 1,1, 1,1, 4) seq7 (clk, rst_n, a, b, c, d|e|f, match7);
vc_seq5 #(1,1, 1,1, 1,1, 1,1, 2) seq8 (clk, rst_n, a, b, c, d, e|f, match8);

always @(posedge clk)
  if (!rst_n) begin
    a <= 1;
    b <= 0;
    c <= 0;
    d <= 0;
    e <= 0;
    f <= 0;
  end
  else begin
    f <= e;
    e <= d;
    d <= c;
    c <= b;
    b <= a;
    a <= f;
  end


initial begin
  $dumpvars;
  clk = 1;
  rst_n = 0;
  #40 rst_n = 1;
  #500 $finish;
end

endmodule