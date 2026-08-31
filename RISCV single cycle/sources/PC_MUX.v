`timescale 1ns / 1ps

module PC_MUX(
    input [31:0] current_PC,
    input beq,
    input bne,
    input zero,
    input set,
    input [31:0] imm,
    input xset,
    input [31:0] ALUResult,//x+offset
    
    output reg [31:0] next_PC,
    output [31:0] PC_plus_4,
    output [31:0] PC_imm
    );
    
    wire Branch;
    assign PC_plus_4 = current_PC + 4;
    assign PC_imm = current_PC + imm;//有必要左移一位吗？
    assign Branch = ((beq & zero) | (bne & ~zero) | set); 
    
    always @(*) begin
        if (Branch) begin
            next_PC = PC_imm;
        end
        else if (xset) begin
            next_PC = ALUResult;
        end
        else begin
            next_PC = PC_plus_4;
        end
    end
    
endmodule
