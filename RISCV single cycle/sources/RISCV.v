`timescale 1ns / 1ps

module RISCV(
    input CLK,
    input Reset,
    input [31:0] Instr,
    input [31:0] ReadData,
    
    output MemWrite,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData
    );
    
    wire [31:0] Result;
    
    wire [31:0] next_PC;
    wire [31:0] current_PC;
    ProgramCounter PC1(
        .CLK(CLK),
        .Reset(Reset),
        .next_PC(next_PC),
        
        .current_PC(current_PC)
    ); 
    assign PC = current_PC;
    
    wire MemtoReg;
    //wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire set;
    wire xset;
    wire PC4;
    wire PCimm;
    wire [2:0] ALUControl;
    wire beq;
    wire bne;
    ControlUnit ControlUnit1(
        .instr(Instr),
        
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .PC4(PC4),//引出这条去往最后判定result的MUX部分x=PC+4
        .set(set),//PC+=offset
        .xset(xset),//PC=x+offset
        .PCimm(PCimm),//引出这条去往最后判定result的MUX部分x=PC+imm
        .ALUControl(ALUControl),
        .beq(beq),//PC+=offset
        .bne(bne) //PC+=offset
    );
    
    wire [31:0] RD1;
    wire [31:0] RD2;
    RegisterFile RegisterFile1(
    .CLK(CLK),
    .WE3(RegWrite),
    .A1(Instr[19:15]),
    .A2(Instr[24:20]),
    .A3(Instr[11:7]),
    .WD3(Result),

    .RD1(RD1),
    .RD2(RD2)
    );
    
    wire [31:0] imm;
    ImmGen ImmGen1(
    .instr(Instr),
    
    .imm(imm)
    );
    
    wire [31:0] ShOut;
    Shifter Shifter1(
    .ShIn(RD1),
    .instr(Instr),
    
    .ShOut(ShOut)
    );
    
    wire [31:0] Src2;
    wire zero;
    assign Src2 = ALUSrc ? imm : RD2 ;
    ALU ALU1(
    .ALUControl(ALUControl),
    .Src1(ShOut),
    .Src2(Src2),
    
    .zero(zero),
    .ALUResult(ALUResult)
    );
    
    wire [31:0] PC_plus_4;
    wire [31:0] PC_imm;
    PC_MUX PC_MUX1(
        .current_PC(current_PC),
        .beq(beq),
        .bne(bne),
        .zero(zero),
        .set(set),
        .imm(imm),
        .xset(xset),
        .ALUResult(ALUResult),
        
        .next_PC(next_PC),
        .PC_plus_4(PC_plus_4),
        .PC_imm(PC_imm)
    );
    
    Result_MUX Result_MUX1(
    .MemtoReg(MemtoReg),
    .PC4(PC4),
    .PCimm(PCimm),
    .ReadData(ReadData),
    .ALUResult(ALUResult),
    .PC_plus_4(PC_plus_4),
    .PC_imm(PC_imm),
    
    .Result(Result)
    );
    
    assign WriteData = RD2;
    
endmodule
