`define EQ      4'b0000
`define NE      4'b0001
`define CS_HS   4'b0010
`define CC_LO   4'b0011
`define MI      4'b0100
`define PL      4'b0101
`define VS      4'b0110
`define VC      4'b0111
`define HI      4'b1000
`define LS      4'b1001
`define GE      4'b1010
`define LT      4'b1011
`define GT      4'b1100
`define LE      4'b1101
`define AL_NONE 4'b1110

module CondLogic(
    input CLK,
    input PCS,
    input RegW,
    input MemW,
    input [1:0] FlagW,
    input [3:0] Cond,
    input [3:0] ALUFlags,
    input NoWrite,
    
    output PCSrc,
    output RegWrite,
    output MemWrite
    ); 
    
    reg CondEx ;
    reg N = 0, Z = 0, C = 0, V = 0 ;
    //reg [3:0] Flags;
    wire [1:0] FlagWrite;
    
// 将N、Z、C、V对应Flags，为什么这么写不行？
//    always @(*) begin
//        Flags = {N, Z, C, V};  
//    end
    
    //output逻辑门按位与
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & (!NoWrite);
    assign MemWrite = MemW & CondEx;    
    assign FlagWrite[1] = FlagW[1] & CondEx;
    assign FlagWrite[0] = FlagW[0] & CondEx;
    
    //Flags随时钟条件更新
    always@(posedge CLK) begin
        if(FlagWrite[1] == 1) begin
            N <= ALUFlags[3]; 
            Z <= ALUFlags[2]; 
        end
        if(FlagWrite[0] == 1) begin
            C <= ALUFlags[1];
            V <= ALUFlags[0];
        end
    end
    
    //CondEx的构建 Condition Check
    always @(*) begin
        case(Cond)
            `EQ: CondEx = Z;
            `NE: CondEx = ~Z;
            `CS_HS: CondEx = C;
            `CC_LO: CondEx = ~C;
            `MI: CondEx = N;
            `PL: CondEx = ~N;
            `VS: CondEx = V;
            `VC: CondEx = ~V;
            `HI: CondEx = ~Z & C;
            `LS: CondEx = Z | ~C;
            `GE: CondEx = ~(N ^ V);
            `LT: CondEx = (N ^ V);
            `GT: CondEx = ~Z & ~(N ^ V);
            `LE: CondEx = Z | (N ^ V);
            `AL_NONE: CondEx = 1'b1;
            default: CondEx = 1'bX;
        endcase
    end
    
endmodule