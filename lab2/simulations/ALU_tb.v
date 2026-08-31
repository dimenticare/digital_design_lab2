`timescale 1ns / 1ps

module ALU_tb;

reg [31:0] Src_A;
reg [31:0] Src_B;
reg [1:0] ALUControl;
wire [31:0] ALUResult;
wire [3:0] ALUFlags;
ALU ALU1 (Src_A,Src_B,ALUControl,ALUResult,ALUFlags);

initial begin
Src_A=32'b1;
Src_B=32'b11;
ALUControl=2'b0;
#50;
ALUControl=2'b1;
#50
ALUControl=2'b10;
#50
ALUControl=2'b11;
#50
$finish;
end
endmodule
