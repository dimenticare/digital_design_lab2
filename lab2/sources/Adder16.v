`timescale 1ns / 1ps

module Adder16(
    input [15:0] a,
    input [15:0] b,
    input ci,
    
    output [15:0] sum,
    output cout
    );
    
    wire [3:0] c;
    
    Adder4 u0(.a(a[3:0]), .b(b[3:0]), .ci(ci), .sum(sum[3:0]), .cout(c[0]));
    Adder4 u1(.a(a[7:4]), .b(b[7:4]), .ci(c[0]), .sum(sum[7:4]), .cout(c[1]));
    Adder4 u2(.a(a[11:8]), .b(b[11:8]), .ci(c[1]), .sum(sum[11:8]), .cout(c[2]));
    Adder4 u3(.a(a[15:12]), .b(b[15:12]), .ci(c[2]), .sum(sum[15:12]), .cout(c[3]));
    
    assign cout = c[3];
    
endmodule
