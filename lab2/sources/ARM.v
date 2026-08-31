module ARM(
    input CLK,
    input Reset,
    input [31:0] Instr,//输入Reg中的Instr到各部分
    input [31:0] ReadData,//输入Data中的Read结果，进行反馈

    output MemWrite,//输出作WE判定写入与否,L28
    output [31:0] PC,//输出ProgramCounter的PC，得到Reg中的Instr，L16
    output [31:0] ALUResult,//ALU输出进Data，L83
    output [31:0] WriteData//ALU输出进Data，assign WriteData = RD2;
); 

//CLK和Reset都是输入wire
wire PCSrc;//wire在ControlUnit,L19
wire [31:0] Result;//wire在模块之间，尾部输入,L20
//PC是wire（output）,无相关
wire [31:0] PC_Plus_4;//L21
ProgramCounter ProgramCounter(CLK, Reset, PCSrc, Result, PC, PC_Plus_4);
//assign PC_Plus_8 = PC_Plus_4 + 4;
//R15 <= PC_Plus_8;

//wire [31:0] Instr;//wire在input,L36
wire [3:0] ALUFlags;//返回到ControlUnit,L37
//输入CLK是wire（input）
wire MemtoReg;//末尾判断Result,L38
//MemWrite是wire（output），无相关
wire ALUSrc;//连接在模块之间，决定Src_B，L86-97
wire [1:0] ImmSrc;//连接到Extend,直接连，没改L99
wire RegWrite;//连接到Register，作为WE3,L39
wire [1:0] RegSrc;//连接在模块之间，决定A1，A2，L51-78
wire [1:0] ALUControl;//连接到ALU,L40
//wire PCSrc;//返回到PC作输入,L19
ControlUnit ControlUnit(Instr, ALUFlags, CLK, MemtoReg, MemWrite, ALUSrc, ImmSrc, RegWrite, RegSrc, ALUControl, PCSrc);
//assign Result = MemtoReg ? ReadData : ALUResult;
//WE3 <= RegWrite;
//ALUControl_r <= ALUControl;

wire WE3;//连接RegWrite,L39
wire [3:0] A1;
wire [3:0] A2;
wire [3:0] A3;//均来自Instr，组合逻辑,L51-78
wire [31:0] WD3;//连接Result,L51-78
wire [31:0] R15;//PC+8.L51-78
wire [31:0] RD1;//连接Src_A，L86-97
wire [31:0] RD2;//Src_B前置，L86-97
RegisterFile RegisterFile(CLK, WE3, A1, A2, A3, WD3, R15, RD1, RD2);

wire [31:0] Src_A;//Reg中RD1,L84-97
wire [31:0] Src_B;//RD2||ExtImm,L84-97
//wire [1:0] ALUControl;//wire在ControlUnit,L40
//ALUResult是wire(output),同时连接判断Result,无相关
//wire [3:0] ALUFlags;//返回到ControlUnit,L37
ALU ALU(Src_A, Src_B, ALUControl, ALUResult, ALUFlags);

//ImmSrc是wire（ControlUnit）,L30
wire [23:0] InstrImm;//来自Instr,L103-105
wire [31:0] ExtImm;//Src_B前置,L86-97
Extend Extend(ImmSrc, InstrImm, ExtImm);  
//    InstrImm <= Instr[23:0];

//新功能
wire [1:0] Sh;//Instr[6:5],L113
wire [4:0] Shamt5;//Instr[11:7],L114
wire [31:0] ShIn;//RD2输入，L115
wire [31:0] ShOut;//输出转向Src_B，替换原先RD2，L92
Shifter Shifter(Sh, Shamt5, ShIn, ShOut);
//Src_B <= ShOut;
assign Sh = Instr[6:5];//L113
assign Shamt5 = Instr[11:7];//L114
assign ShIn = RD2;//L115

//wire [31:0] Result; 
//reg [31:0] ALUResult_r;
//assign ALUResult = ALUResult_r;不知道这俩干嘛的
assign WE3 = RegWrite;//L39

//Instr与Register连接
wire [31:0] PC_Plus_8;
assign PC_Plus_8 = PC_Plus_4 + 4;//L21

//A1\A2的选择器
assign A1 = (RegSrc[0]) ? 4'b1111 : Instr[19:16];
assign A2 = (RegSrc[1]) ? Instr[15:12] : Instr[3:0];
assign A3 = Instr[15:12];
assign WD3 = Result;
assign R15 = PC_Plus_8;

//Register与ALU的连接
assign Src_A = RD1;
assign Src_B = (ALUSrc == 1) ? ExtImm : ShOut;

//Extend连接,赋值InstrImm（reg）
assign InstrImm = Instr[23:0];

//ALU与Data的连接
assign WriteData = RD2;//L10

//Data数值反馈回Program Counter，Result输入为reg
assign Result = (MemtoReg == 1) ? ReadData : ALUResult;

endmodule