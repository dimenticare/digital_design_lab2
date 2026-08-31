`define LSL 2'b00//左移
`define LSR 2'b01//右移
`define ASR 2'b10//保位右移
`define ROR 2'b11//首尾右移循环

module Shifter(
    input [1:0] Sh,
    input [4:0] Shamt5,
    input [31:0] ShIn,
    
    output [31:0] ShOut
    );

wire [31:0] ShOut_LSL;
wire [31:0] ShOut_LSR;
wire [31:0] ShOut_ASR;
wire [31:0] ShOut_ROR;
reg [31:0] ShOut_LSL_r;
reg [31:0] ShOut_LSR_r;
reg [31:0] ShOut_ASR_r;
reg [31:0] ShOut_ROR_r;
reg [31:0] ShOut_r;
//always & assign见后

//LSL左移
wire [31:0] ShOut_LSL_A;
wire [31:0] ShOut_LSL_B;
wire [31:0] ShOut_LSL_C;
wire [31:0] ShOut_LSL_D;
assign ShOut_LSL_A = Shamt5[4] ? {ShIn[15:0],16'b0} : ShIn;
assign ShOut_LSL_B = Shamt5[3] ? {ShOut_LSL_A[23:0],8'b0} : ShOut_LSL_A;
assign ShOut_LSL_C = Shamt5[2] ? {ShOut_LSL_B[27:0],4'b0} : ShOut_LSL_B;
assign ShOut_LSL_D = Shamt5[1] ? {ShOut_LSL_C[29:0],2'b0} : ShOut_LSL_C;
assign ShOut_LSL   = Shamt5[0] ? {ShOut_LSL_D[30:0],1'b0} : ShOut_LSL_D;

//LSR右移
wire [31:0] ShOut_LSR_A;
wire [31:0] ShOut_LSR_B;
wire [31:0] ShOut_LSR_C;
wire [31:0] ShOut_LSR_D;
assign ShOut_LSR_A = Shamt5[4] ? {16'b0,ShIn[31:16]} : ShIn;
assign ShOut_LSR_B = Shamt5[3] ? {8'b0,ShOut_LSR_A[31:8]} : ShOut_LSR_A;
assign ShOut_LSR_C = Shamt5[2] ? {4'b0,ShOut_LSR_B[31:4]} : ShOut_LSR_B;
assign ShOut_LSR_D = Shamt5[1] ? {2'b0,ShOut_LSR_C[31:2]} : ShOut_LSR_C;
assign ShOut_LSR   = Shamt5[0] ? {1'b0,ShOut_LSR_D[31:1]} : ShOut_LSR_D;

//ASR保位右移
wire [31:0] ShOut_ASR_A;
wire [31:0] ShOut_ASR_B;
wire [31:0] ShOut_ASR_C;
wire [31:0] ShOut_ASR_D;
assign ShOut_ASR_A = Shamt5[4] ? {{17{ShIn[31]}},ShIn[30:16]} : ShIn;
assign ShOut_ASR_B = Shamt5[3] ? {{9{ShIn[31]}},ShOut_ASR_A[30:8]} : ShOut_ASR_A;
assign ShOut_ASR_C = Shamt5[2] ? {{5{ShIn[31]}},ShOut_ASR_B[30:4]} : ShOut_ASR_B;
assign ShOut_ASR_D = Shamt5[1] ? {{3{ShIn[31]}},ShOut_ASR_C[30:2]} : ShOut_ASR_C;
assign ShOut_ASR   = Shamt5[0] ? {{2{ShIn[31]}},ShOut_ASR_D[30:1]} : ShOut_ASR_D;

//ROR首尾循环右移
wire [31:0] ShOut_ROR_A;
wire [31:0] ShOut_ROR_B;
wire [31:0] ShOut_ROR_C;
wire [31:0] ShOut_ROR_D;
assign ShOut_ROR_A = Shamt5[4] ? {ShIn[15:0],ShIn[31:16]} : ShIn;
assign ShOut_ROR_B = Shamt5[3] ? {ShOut_ROR_A[7:0],ShOut_ROR_A[31:8]} : ShOut_ROR_A;
assign ShOut_ROR_C = Shamt5[2] ? {ShOut_ROR_A[3:0],ShOut_ROR_B[31:4]} : ShOut_ROR_B;
assign ShOut_ROR_D = Shamt5[1] ? {ShOut_ROR_A[1:0],ShOut_ROR_C[31:2]} : ShOut_ROR_C;
assign ShOut_ROR   = Shamt5[0] ? {ShOut_ROR_A[0],ShOut_ROR_D[31:1]} : ShOut_ROR_D;

always @(*) begin
    ShOut_LSL_r <= ShOut_LSL;
    ShOut_LSR_r <= ShOut_LSR;
    ShOut_ASR_r <= ShOut_ASR;
    ShOut_ROR_r <= ShOut_ROR;//加载
    case(Sh)
        `LSL:begin
        ShOut_r <= ShOut_LSL;
        end
        `LSR:begin
        ShOut_r <= ShOut_LSR;
        end
        `ASR:begin
        ShOut_r <= ShOut_ASR;
        end
        `ROR:begin
        ShOut_r <= ShOut_ROR;
        end
        default:begin
        ShOut_r <= 32'bX;//不存在，报错
        end
    endcase
end

assign ShOut = ShOut_r;

endmodule 
