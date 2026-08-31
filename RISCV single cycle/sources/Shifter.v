`timescale 1ns / 1ps

module Shifter(
    input [31:0] ShIn,
    input [31:0] instr,
    
    output reg [31:0] ShOut
    );
    
    wire [6:0] op;
    wire [2:0] funct3;
    wire [5:0] funct6;
    wire [5:0] Shamt;
    
    assign op = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct6 = instr[31:26];
    assign Shamt =instr[25:20];
    
    //LL◊Û“∆
    wire [31:0] ShOut_LL_A;
    wire [31:0] ShOut_LL_B;
    wire [31:0] ShOut_LL_C;
    wire [31:0] ShOut_LL_D;
    wire [31:0] ShOut_LL_E;
    wire [31:0] ShOut_LL;
    assign ShOut_LL_A = Shamt[5] ? {32'b0} : ShIn;
    assign ShOut_LL_B = Shamt[4] ? {ShOut_LL_A[15:0],16'b0} : ShOut_LL_A;
    assign ShOut_LL_C = Shamt[3] ? {ShOut_LL_B[23:0],8'b0} : ShOut_LL_B;
    assign ShOut_LL_D = Shamt[2] ? {ShOut_LL_C[27:0],4'b0} : ShOut_LL_C;
    assign ShOut_LL_E = Shamt[1] ? {ShOut_LL_D[29:0],2'b0} : ShOut_LL_D;
    assign ShOut_LL   = Shamt[0] ? {ShOut_LL_E[30:0],1'b0} : ShOut_LL_E;

    //RL”““∆
    wire [31:0] ShOut_RL_A;
    wire [31:0] ShOut_RL_B;
    wire [31:0] ShOut_RL_C;
    wire [31:0] ShOut_RL_D;
    wire [31:0] ShOut_RL_E;
    wire [31:0] ShOut_RL;
    assign ShOut_RL_A = Shamt[5] ? {32'b0} : ShIn;
    assign ShOut_RL_B = Shamt[4] ? {16'b0,ShOut_RL_A[31:16]} : ShOut_RL_A;
    assign ShOut_RL_C = Shamt[3] ? {8'b0,ShOut_RL_B[31:8]} : ShOut_RL_B;
    assign ShOut_RL_D = Shamt[2] ? {4'b0,ShOut_RL_C[31:4]} : ShOut_RL_C;
    assign ShOut_RL_E = Shamt[1] ? {2'b0,ShOut_RL_D[31:2]} : ShOut_RL_D;
    assign ShOut_RL   = Shamt[0] ? {1'b0,ShOut_RL_E[31:1]} : ShOut_RL_E;

    //RA”““∆
    wire [31:0] ShOut_RA_A;
    wire [31:0] ShOut_RA_B;
    wire [31:0] ShOut_RA_C;
    wire [31:0] ShOut_RA_D;
    wire [31:0] ShOut_RA_E;
    wire [31:0] ShOut_RA;
    assign ShOut_RA_A = Shamt[5] ? {{32{ShIn[31]}}} : ShIn;
    assign ShOut_RA_B = Shamt[4] ? {{17{ShIn[31]}},ShOut_RA_A[30:16]} : ShOut_RA_A;
    assign ShOut_RA_C = Shamt[3] ? {{9{ShIn[31]}},ShOut_RA_B[30:8]} : ShOut_RA_B;
    assign ShOut_RA_D = Shamt[2] ? {{5{ShIn[31]}},ShOut_RA_C[30:4]} : ShOut_RA_C;
    assign ShOut_RA_E = Shamt[1] ? {{3{ShIn[31]}},ShOut_RA_D[30:2]} : ShOut_RA_D;
    assign ShOut_RA   = Shamt[0] ? {{2{ShIn[31]}},ShOut_RA_E[30:1]} : ShOut_RA_E;
    
    always @(*) begin
        if(op == 7'b0010011 & funct3 == 3'b001 & funct6 == 6'b000000) begin
            ShOut = ShOut_LL;//slli
        end
        else if(op == 7'b0010011 & funct3 == 3'b101 & funct6 == 6'b000000) begin
            ShOut = ShOut_RL;//srli
        end
        else if(op == 7'b0010011 & funct3 == 3'b101 & funct6 == 6'b010000) begin
            ShOut = ShOut_RA;//srai
        end
        else begin
            ShOut = ShIn;
        end
    end
        
endmodule
