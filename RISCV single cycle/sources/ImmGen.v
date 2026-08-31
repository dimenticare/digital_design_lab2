`timescale 1ns / 1ps

module ImmGen(
    input [31:0] instr,
    
    output reg [31:0] imm
    );
    
    always@(*) begin
        case(instr[6:0])
            7'b0010011: begin
                if(instr[14:12] == 3'b000)begin//addi
                    if(instr[31] == 1) imm = {20'hfffff,instr[31:20]};
                    else imm = {20'h0,instr[31:20]};
                end
                else imm = 32'b0;//Î»ÒÆÖ¸Áî
            end
            7'b0000011: begin//LW
                if(instr[31] == 1) imm = {20'hfffff,instr[31:20]};
                else imm = {20'h0,instr[31:20]};
            end
            7'b0100011: begin//SW
                if(instr[31] == 1) imm = {20'hfffff,instr[31:25],instr[11:7]};
                else imm = {20'h0,instr[31:25],instr[11:7]};
            end
            7'b1100011: begin//BEQ,BNE
                if(instr[31] == 1) begin
                imm[31:13] = 19'h7ffff;
                imm[12:0] = {instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                end
                else begin
                imm[31:13] = 19'h0;
                imm[12:0] = {instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
                end
            end
            7'b1101111: begin//JAL
                if(instr[31] == 1) begin
                imm[31:21] = 11'h7ff;
                imm[20:0] = {instr[31],instr[19:12],instr[20],instr[30:21],1'h0};
                end
                else begin
                imm[31:21] = 11'h0;
                imm[20:0] = {instr[31],instr[19:12],instr[20],instr[30:21],1'h0};
                end
            end
            7'b1100111: begin//JALR
                if(instr[31] == 1) imm = {20'hfffff,instr[31:20]};
                else imm = {20'h0,instr[31:20]};
            end
            7'b0010111: begin//AUIPC
                if(instr[31] == 1) imm = {instr[31:12],12'b1};
                else imm = {instr[31:12],12'b0};
            end
        endcase
    end      
    
endmodule
