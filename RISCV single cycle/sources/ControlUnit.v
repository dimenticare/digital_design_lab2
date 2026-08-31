`timescale 1ns / 1ps

module ControlUnit(
    input [31:0] instr,
    
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg PC4,//引出这条去往最后判定result的MUX部分x=PC+4
    output reg set,//PC+=offset
    output reg xset,//PC=x+offset
    output reg PCimm,//引出这条去往最后判定result的MUX部分x=PC+imm
    output reg [2:0] ALUControl,
    output beq,//PC+=offset
    output bne //PC+=offset
    );
    
    wire [6:0] op;
    wire [2:0] funct3;
    wire [6:0] funct7;
    assign op = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    
    assign beq = ((op == 7'b1100011) & (funct3==3'b000));
    assign bne = ((op == 7'b1100011) & (funct3==3'b001));
    
    always @(*) begin
        case(op)
            7'b0010011:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_1_1_0_0_0_0;//addi & 位移
            7'b0110011:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_0_1_0_0_0_0;//R-type
            7'b0000011:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b1_0_1_1_0_0_0_0;//lw
            7'b0100011:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'bX_1_1_0_0_0_0_0;//sw
            7'b1100011:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_0_0_0_0_0_0;//beq/bne
            7'b1101111:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_0_1_1_1_0_0;//jal
            7'b1100111:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_1_1_1_0_1_0;//jalr
            7'b0010111:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_0_1_0_0_0_1;//auipc
            default:{MemtoReg,MemWrite,ALUSrc,RegWrite,PC4,set,xset,PCimm}=8'b0_0_0_0_0_0_0_0;
        endcase
    end
    
    always @(*) begin
        if(op == 7'b0110011) begin
            case(funct3)
                3'b000:
                    if(funct7 == 7'b0000000)
                        ALUControl = 3'b000;//add
                    else if(funct7 == 7'b0100000)
                        ALUControl = 3'b001;//sub
                    else
                        ALUControl = 3'b111;
                3'b111:ALUControl = 3'b010;//and
                3'b110:ALUControl = 3'b011;//or
                3'b100:ALUControl = 3'b100;//xor
                default:ALUControl = 3'b000;//全都变加法（补码运算）
            endcase
        end
        else if(op == 7'b0010011 & funct3 == 3'b000)begin//addi
            ALUControl = 3'b000;
        end
        else if(op == 7'b1100011)begin//beq、bne
            ALUControl = 3'b001;
        end
        else if(op == 7'b1100111 & funct3 == 3'b001)begin//auipc
            ALUControl = 3'b000;//x=PC+imm<<12
        end
        else ALUControl = 3'b000;//非特例全变加法
    end
    
endmodule
