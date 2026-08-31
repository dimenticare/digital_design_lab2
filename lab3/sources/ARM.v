module ARM(
    input CLK,
    input Reset,
    input [31:0] Instr,
    input [31:0] ReadData,

    output MemWrite,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData
); 


wire PCSrc;
wire [31:0] Result;
wire [31:0] PC_Plus_4;
wire Busy;
ProgramCounter ProgramCounter(
    .CLK(CLK), 
    .Reset(Reset), 
    .PCSrc(PCSrc), 
    .Result(Result), 
    .Busy(Busy), 
    
    .PC(PC), 
    .PC_Plus_4(PC_Plus_4));

wire [3:0] ALUFlags;
wire MemtoReg;
wire ALUSrc;
wire [1:0] ImmSrc;
wire RegWrite;
wire [1:0] RegSrc;
wire [1:0] ALUControl;
wire Start;
wire MCycleOp;
wire M_Write;
ControlUnit ControlUnit(Instr, ALUFlags, CLK, MemtoReg, MemWrite, ALUSrc, ImmSrc, RegWrite, 
RegSrc, ALUControl, PCSrc, Start, MCycleOp, M_Write);

wire WE3;
wire [3:0] A1;
wire [3:0] A2;
wire [3:0] A3;
wire [31:0] WD3;
wire [31:0] R15;
wire [31:0] RD1;
wire [31:0] RD2;
RegisterFile RegisterFile(CLK, WE3, A1, A2, A3, WD3, R15, RD1, RD2);

wire [31:0] Src_A;
wire [31:0] Src_B;
ALU ALU(Src_A, Src_B, ALUControl, ALUResult, ALUFlags);

wire [23:0] InstrImm;
wire [31:0] ExtImm;
Extend Extend(ImmSrc, InstrImm, ExtImm);  

wire [1:0] Sh;
wire [4:0] Shamt5;
wire [31:0] ShIn;
wire [31:0] ShOut;
Shifter Shifter(Sh, Shamt5, ShIn, ShOut);
assign Sh = Instr[6:5];
assign Shamt5 = Instr[11:7];
assign ShIn = RD2;

assign WE3 = RegWrite;

wire [31:0] PC_Plus_8;
assign PC_Plus_8 = PC_Plus_4 + 4;

assign A1 = (Start == 1) ? Instr[11:8]: (RegSrc[0] ? 4'b1111: Instr[19:16]);//MCycle
assign A2 = (RegSrc[1] == 1) ? Instr[15:12] : Instr[3:0];
assign A3 = (Start == 1) ? Instr[19:16] : Instr[15:12];//MCycle
assign WD3 = Result;
assign R15 = PC_Plus_8;

assign Src_A = RD1;
assign Src_B = ALUSrc ? ExtImm : ShOut;

assign InstrImm = Instr[23:0];

assign WriteData = RD2;

wire [31:0] Operand1;
wire [31:0] Operand2;
assign Operand1 = RD1;
assign Operand2 = RD2;
wire [31:0] MCycleResult;
MCycle MCycle(CLK, Reset, Start, MCycleOp, Operand1, Operand2, MCycleResult, Busy);

assign Result = (MemtoReg == 1) ? ReadData : 
    ((M_Write == 1) ? MCycleResult : ALUResult);

endmodule