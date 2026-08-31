`timescale 1ns / 1ps

module Result_MUX(
    input MemtoReg,
    input PC4,
    input PCimm,
    input [31:0] ReadData,
    input [31:0] ALUResult,
    input [31:0] PC_plus_4,
    input [31:0] PC_imm,
    
    output reg [31:0] Result
    );
    
    always @(*) begin
        if (MemtoReg) begin
            Result = ReadData;
        end
        else if (PC4) begin
            Result = PC_plus_4;
        end
        else if (PCimm) begin
            Result = PC_imm;
        end
        else begin
            Result = ALUResult;
        end
    end
    
endmodule
