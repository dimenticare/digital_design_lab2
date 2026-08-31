`timescale 1ns / 1ps
//>>>>>>>>>>>> ******* FOR SIMULATION. DO NOT SYNTHESIZE THIS DIRECTLY (This is used as a component in TOP.v for Synthesis) ******* <<<<<<<<<<<<

module Wrapper
#(
	parameter N_LEDs = 16,       // Number of LEDs displaying Result. LED(15 downto 15-N_LEDs+1). 16 by default
	parameter N_DIPs = 7         // Number of DIPs. 16 by default	                             
)
(
	input  [N_DIPs-1:0] DIP, 		 		// DIP switch inputs, used as a user definied memory address for checking memory content.
	output reg [N_LEDs-1:0] LED, 	// LED light display. Display the value of program counter.
	output reg [31:0] SEVENSEGHEX, 			// 7 Seg LED Display. The 32-bit value will appear as 8 Hex digits on the display. Used to display memory content.
	input  RESET,							// Active high.
	input  CLK								// Divided Clock from TOP.
);                                             

//----------------------------------------------------------------
// ARM signals
//----------------------------------------------------------------
wire[31:0] PC ;
wire[31:0] Instr ;
reg[31:0] ReadData ;
wire MemWrite ;
wire[31:0] ALUResult ;
wire[31:0] WriteData ;

//----------------------------------------------------------------
// Address Decode signals
//---------------------------------------------------------------
wire dec_DATA_CONST, dec_DATA_VAR;  // 'enable' signals from data memory address decoding

//----------------------------------------------------------------
// Memory read for IO signals
//----------------------------------------------------------------
wire [31:0] ReadData_IO;

//----------------------------------------------------------------
// Memory declaration
//-----------------------------------------------------------------
reg [31:0] INSTR_MEM		[0:127]; // instruction memory
reg [31:0] DATA_CONST_MEM	[0:127]; // data (constant) memory
reg [31:0] DATA_VAR_MEM     [0:127]; // data (variable) memory
integer i;

//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
initial begin
INSTR_MEM[0] = 32'h0010_0093;	//addi x1=x0+1=0+1=1                
INSTR_MEM[1] = 32'h0020_0113;	//addi x2=x0+2=0+2=2                
INSTR_MEM[2] = 32'h0011_01B3;	//add x3=x2+x1=2+1=3                
INSTR_MEM[3] = 32'h4011_01B3;	//sub x3=x2-x1=2-1=1                
INSTR_MEM[4] = 32'h4020_8233;	//sub x4=x1-x2=1-2=-1=²¹Âëffff_ffff
INSTR_MEM[5] = 32'h0011_61B3;	//OR x3=x2||x1=2||1=3               
INSTR_MEM[6] = 32'h0011_71B3;	//AND x3=x2&x1=0                    
INSTR_MEM[7] = 32'h0011_41B3;	//XOR x3=x2^x1=3
INSTR_MEM[8] = 32'h0010_9193;	//SLLI x3=x1<1=2
INSTR_MEM[9] = 32'h0010_D193;	//SRLI x3=x1>1=0
INSTR_MEM[10] = 32'h4010_D193;	//SRAI x3=x1>1=0
INSTR_MEM[11] = 32'h4012_5193;	//SRAI x3=x4>1=ffff_ffff>1=ffff_ffff
INSTR_MEM[12] = 32'h4040_2283;	//lw x5=mem[0+1]=mem[1]=820
INSTR_MEM[13] = 32'h0020_A323;	//sw mem[x1+6]=mem[7]=x2=2
INSTR_MEM[14] = 32'h0070_2303;	//lw x6=mem[x0+7]=mem[7]=2
INSTR_MEM[15] = 32'h0020_8463;	//beq x1!=x2
INSTR_MEM[16] = 32'h0032_0463;	//beq x3=x4,pc+=8(1000)
INSTR_MEM[17] = 32'h0020_8463;	//beq x1!=x2
INSTR_MEM[18] = 32'h0032_0463;	//beq x3=x4,pc+=8(1000)
INSTR_MEM[19] = 32'h0080_036F;	//jal x[6]=pc+4,pc+=8(1000) NOP
INSTR_MEM[20] = 32'h0080_036F;	//jal x[6]=pc+4,pc+=8(1000)
INSTR_MEM[19] = 32'h0080_036F;	//jal x[6]=pc+4,pc+=8(1000) NOP
INSTR_MEM[20] = 32'h0080_036F;	//jal x[6]=pc+4,pc+=8(1000)
INSTR_MEM[21] = 32'h0083_23E7;	//jalr pc=x[6]+8,x[7]=pc+4 NOP
INSTR_MEM[22] = 32'h0083_23E7;	//jalr pc=x[6]+8,x[7]=pc+4
INSTR_MEM[23] = 32'h0000_1417;	//auipc x[8]=pc+1_0000_0000_0000(1)
for(i = 24; i < 128; i = i+1) begin 
				INSTR_MEM[i] = 32'h0; 
			end
end

//----------------------------------------------------------------
// Data (Constant) Memory
//----------------------------------------------------------------
initial begin
			DATA_CONST_MEM[0] = 32'h00000810; 
			DATA_CONST_MEM[1] = 32'h00000820; 
			DATA_CONST_MEM[2] = 32'h00000830; 
			DATA_CONST_MEM[3] = 32'h00000002; 
			DATA_CONST_MEM[4] = 32'h00000001; 
			DATA_CONST_MEM[5] = 32'hFFFFFFFF; 
			DATA_CONST_MEM[6] = 32'hFFFFFEFA; 
			for(i = 7; i < 128; i = i+1) begin 
				DATA_CONST_MEM[i] = 32'h0; 
			end
end

//----------------------------------------------------------------
// Data (Variable) Memory
//----------------------------------------------------------------
initial begin
            for(i = 0; i < 128; i = i+1) begin 
				DATA_VAR_MEM[i] = 32'h0; 
			end
end


//----------------------------------------------------------------
// ARM port map
//----------------------------------------------------------------
RISCV RISCV1(
	CLK,
	RESET,
	Instr,
	ReadData,
	MemWrite,
	PC,
	ALUResult,
	WriteData
);

//----------------------------------------------------------------
// Data memory address decoding
//----------------------------------------------------------------
assign dec_DATA_CONST		= (ALUResult >= 32'h00000100 && ALUResult <= 32'h000007FC) ? 1'b1 : 1'b0;
assign dec_DATA_VAR			= (ALUResult >= 32'h00000000 && ALUResult <= 32'h000000FC) ? 1'b1 : 1'b0;

//----------------------------------------------------------------
// Data memory read 1
//----------------------------------------------------------------
always@( * ) begin
if (dec_DATA_VAR)
	ReadData <= DATA_VAR_MEM[ALUResult[6:0]] ;
else if (dec_DATA_CONST)
	ReadData <= DATA_CONST_MEM[ALUResult[8:2]] ;
else
	ReadData <= 32'h0 ; 
end

//----------------------------------------------------------------
// Data memory read 2
//----------------------------------------------------------------
assign ReadData_IO = DATA_VAR_MEM[DIP[6:0]];

//----------------------------------------------------------------
// Data Memory write
//----------------------------------------------------------------
always@(posedge CLK) begin
    if( MemWrite && dec_DATA_VAR ) 
        DATA_VAR_MEM[ALUResult[6:0]] <= WriteData ;
end

//----------------------------------------------------------------
// Instruction memory read
//----------------------------------------------------------------
assign Instr = ( (PC >= 32'h00000000) && (PC <= 32'h000001FC) ) ? // To check if address is in the valid range, assuming 128 word memory. Also helps minimize warnings
                 INSTR_MEM[PC[8:2]] : 32'h00000000 ; 

//----------------------------------------------------------------
// LED light - display PC value
//----------------------------------------------------------------
always@(posedge CLK or posedge RESET) begin
    if(RESET)
        LED <= 32'b0 ;
    else 
        LED <= PC ;
end

//----------------------------------------------------------------
// SevenSeg LED - display memory content
//----------------------------------------------------------------
always @(posedge CLK or posedge RESET) begin
	if (RESET)
		SEVENSEGHEX <= 32'b0;
	else
		SEVENSEGHEX <= ReadData_IO;
end

endmodule
