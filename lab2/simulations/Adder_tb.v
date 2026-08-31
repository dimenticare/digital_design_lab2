`timescale 1ns / 1ps

module Adder_tb;
reg a;
reg b;
reg ci;
wire sum;
wire cout;

Adder1 u1(a,b,ci,sum,cout);

initial begin
a=0;
b=1;
ci=0;
#100
a=1;
#100
ci=1;
#100
$finish;
end

endmodule
