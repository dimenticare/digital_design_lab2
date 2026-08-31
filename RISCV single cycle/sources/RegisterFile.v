`timescale 1ns / 1ps

module RegisterFile(
    input CLK,
    input WE3,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,

    output [31:0] RD1,
    output [31:0] RD2
    );
    
    reg [31:0] RegBank[0:31];
    
    assign RD1 = RegBank[A1];
    assign RD2 = RegBank[A2];
    
    always @(posedge CLK) begin
        if (WE3 & A3!= 5'b0) begin
            RegBank[A3] <= WD3;
        end
        else begin
            RegBank[0] <= 32'b0;//ÓÀÔ¶Îª0
        end
    end
    
endmodule