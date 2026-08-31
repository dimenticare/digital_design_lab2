module ControlUnit(
    input [31:0] Instr,
    input [3:0] ALUFlags,
    input CLK,

    output MemtoReg,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [1:0] RegSrc,
    output [1:0] ALUControl,	
    output PCSrc,
    output Start,
    output MCycleOp,
    output M_Write
    ); 
    
    wire [3:0] Cond;
    wire PSC, RegW, MemW;
    wire [1:0] FlagW;
    wire NoWrite;

    assign Cond=Instr[31:28];


    CondLogic CondLogic(
     CLK,
     PCS,
     RegW,
     MemW,
     FlagW,
     Cond,
     ALUFlags,
     NoWrite,
     MCycleWrite,

     PCSrc,
     RegWrite,
     MemWrite,
     M_Write
    );

    Decoder Decoder(
     Instr,
     
     PCS,
     RegW,
     MemW,
     MemtoReg,
     ALUSrc,
     ImmSrc,
     RegSrc,
     ALUControl,
     FlagW,
     NoWrite,
     Start,
     MCycleOp,
     MCycleWrite
    );
endmodule