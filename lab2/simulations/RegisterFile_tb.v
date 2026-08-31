`timescale 1ns / 1ps

module RegisterFile_tb;
reg CLK;
reg WE3;//连接RegWrite,L39
reg [3:0] A1;
reg [3:0] A2;
reg [3:0] A3;//均来自Instr，组合逻辑,L51-78
reg [31:0] WD3;//连接Result,L51-78
reg [31:0] R15;//PC+8.L51-78
wire [31:0] RD1;//连接Src_A，L86-97
wire [31:0] RD2;//Src_B前置，L86-97
RegisterFile RegisterFile1 (CLK, WE3, A1, A2, A3, WD3, R15, RD1, RD2);

initial begin
    CLK = 0;
    WE3 = 0;
    WD3 = 32'b1;
    A1 = 4'b0000;
    A2 = 4'b0001;
    A3 = 4'b0000;
    R15 = 32'b1;
    #100
    WE3 = 1;
    #100
    #100
    A3 = 4'b0001;
    #100
    A3 = 4'b0010;
    #100
    
    $finish;
end
always  #5 CLK = ~CLK;

endmodule
