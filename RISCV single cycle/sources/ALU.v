`timescale 1ns / 1ps

module ALU(
    input [2:0] ALUControl,
    input [31:0] Src1,
    input [31:0] Src2,
    
    output zero,
    output reg [31:0] ALUResult
    );
    
    always@(*) begin
        case(ALUControl)
            3'b000: ALUResult = Src1 + Src2;
            3'b001: ALUResult = Src1 - Src2;
            3'b010: ALUResult = Src1 & Src2;
            3'b011: ALUResult = Src1 | Src2;
            3'b100: ALUResult = Src1 ^ Src2;
            //3'b101: ALUResult = (Src1 != Src2) ? 1 : 0;
            //default: ALUResult = 32'bX;
        endcase
    end
    
    assign zero = (ALUResult==32'b0) ? 1'b1: 1'b0;
    
endmodule
