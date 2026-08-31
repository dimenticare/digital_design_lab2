`define R0 4'b0000
`define R1 4'b0001
`define R2 4'b0010
`define R3 4'b0011
`define R4 4'b0100
`define R5 4'b0101
`define R6 4'b0110
`define R7 4'b0111
`define R8 4'b1000
`define R9 4'b1001
`define R10 4'b1010
`define R11 4'b1011
`define R12 4'b1100
`define R13 4'b1101
`define R14 4'b1110
`define R15 4'b1111

module RegisterFile(
    input CLK,
    input WE3,
    input [3:0] A1,
    input [3:0] A2,
    input [3:0] A3,
    input [31:0] WD3,
    input [31:0] R15,

    output [31:0] RD1,
    output [31:0] RD2
    );
    
    // declare RegBank
    reg [31:0] RegBank[0:14];
    reg [31:0] WD3_r;
    reg [31:0] RD1_r;
    reg [31:0] RD2_r;
    assign RD1 = RD1_r;
    assign RD2 = RD2_r;
    
    always @(posedge CLK) begin
        //写入操作
        if (WE3) begin
            case (A3)
                `R0:RegBank[0] <= WD3;
                `R1:RegBank[1] <= WD3;
                `R2:RegBank[2] <= WD3;
                `R3:RegBank[3] <= WD3;
                `R4:RegBank[4] <= WD3;
                `R5:RegBank[5] <= WD3;
                `R6:RegBank[6] <= WD3;
                `R7:RegBank[7] <= WD3;
                `R8:RegBank[8] <= WD3;
                `R9:RegBank[9] <= WD3;
                `R10:RegBank[10] <= WD3;
                `R11:RegBank[11] <= WD3;
                `R12:RegBank[12] <= WD3;
                `R13:RegBank[13] <= WD3;
                `R14:RegBank[14] <= WD3;
                default: ;//怎么改？
            endcase
        end
    end
    always@(*)begin
            //读取操作
            case (A1)
                `R0:RD1_r = RegBank[0];
                `R1:RD1_r = RegBank[1];
                `R2:RD1_r = RegBank[2];
                `R3:RD1_r = RegBank[3];
                `R4:RD1_r = RegBank[4];
                `R5:RD1_r = RegBank[5];
                `R6:RD1_r = RegBank[6];
                `R7:RD1_r = RegBank[7];
                `R8:RD1_r = RegBank[8];
                `R9:RD1_r = RegBank[9];
                `R10:RD1_r = RegBank[10];
                `R11:RD1_r = RegBank[11];
                `R12:RD1_r = RegBank[12];
                `R13:RD1_r = RegBank[13];
                `R14:RD1_r = RegBank[14];
                `R15:RD1_r = R15;                
                default:RD1_r = 32'b0;
            endcase
            case (A2)
                `R0:RD2_r = RegBank[0];
                `R1:RD2_r = RegBank[1];
                `R2:RD2_r = RegBank[2];
                `R3:RD2_r = RegBank[3];
                `R4:RD2_r = RegBank[4];
                `R5:RD2_r = RegBank[5];
                `R6:RD2_r = RegBank[6];
                `R7:RD2_r = RegBank[7];
                `R8:RD2_r = RegBank[8];
                `R9:RD2_r = RegBank[9];
                `R10:RD2_r = RegBank[10];
                `R11:RD2_r = RegBank[11];
                `R12:RD2_r = RegBank[12];
                `R13:RD2_r = RegBank[13];
                `R14:RD2_r = RegBank[14];
                `R15:RD2_r = R15;                
                default:RD2_r = 32'b0;
            endcase    
    end
    
endmodule