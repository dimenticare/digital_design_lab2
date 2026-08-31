`timescale 1ns / 1ps

module ControlUnit_tb;

    reg [31:0] Instr;
    reg [3:0] ALUFlags;
    reg CLK;

    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire [1:0] ImmSrc;
    wire RegWrite;
    wire [1:0] RegSrc;
    wire [1:0] ALUControl;	
    wire PCSrc;
ControlUnit ControlUnit1 (Instr,ALUFlags,CLK,
MemtoReg,MemWrite,ALUSrc,ImmSrc,RegWrite,RegSrc,ALUControl,PCSrc); 

reg PC;
initial begin
CLK=1;
ALUFlags=4'b0000;
Instr=32'he59f2204;
PC=1'b0;
#100
Instr=32'he59f31f0;
#100
Instr=32'he0815002;
#100
Instr=32'he5835004;
#100
Instr=32'he2833008;
#100
Instr=32'he5135004;
#100
Instr=32'he0416002;
end
always #5 CLK=~CLK;
endmodule
