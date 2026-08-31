`timescale 1ns / 1ps

module Adder1(
    input a,
    input b,
    input ci,
    
    output sum,
    output cout
    );
    
    assign sum = a ^ b ^ ci;
    assign cout = ((a ^ b) & ci) | (a & b);
    
endmodule
