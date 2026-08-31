`timescale 1ns / 1ps

module ProgramCounter_tb;
reg CLK,Reset;
reg PCSrc;
reg [31:0] Result;
wire [31:0] PC;
wire [31:0] PC_Plus_4;

ProgramCounter ProgramCounter (CLK,Reset,PCSrc,Result,PC,PC_Plus_4);
initial begin
    CLK = 1'b0;
    Result = 32'b0;
    Reset = 1'b1;
    PCSrc = 1'b0;
    #30
    Reset = 1'b0;
    #100
    PCSrc = 1'b1;
    #100
    $finish;
end
always #5 CLK = ~CLK;
endmodule
