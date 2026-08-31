`timescale 1ns / 1ps

module Adder4(
    input [3:0] a,
    input [3:0] b,
    input ci,
    
    output [3:0] sum,
    output cout
    );
    
    wire [3:0] c;
    
    Adder1 u0(.a(a[0]), .b(b[0]), .ci(ci), .sum(sum[0]), .cout(c[0]));
    Adder1 u1(.a(a[1]), .b(b[1]), .ci(c[0]), .sum(sum[1]), .cout(c[1]));
    Adder1 u2(.a(a[2]), .b(b[2]), .ci(c[1]), .sum(sum[2]), .cout(c[2]));
    Adder1 u3(.a(a[3]), .b(b[3]), .ci(c[2]), .sum(sum[3]), .cout(c[3]));
    
    assign cout = c[3];
    
endmodule
