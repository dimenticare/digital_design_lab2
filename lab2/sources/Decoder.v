module Decoder(
    input [31:0] Instr,
	
    output PCS,
    output RegW, 
    output MemW, 
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW,
    output NoWrite//Extended Function
    ); 
wire [1:0] ALUOp;
    wire Branch;
    
    // 拆解Instr字段，这里不规范，如果规范分开写不需要写额外外部变量
    //wire [3:0] cond = Instr[31:28];
    wire [1:0] op = Instr[27:26];
    wire funct_I = Instr[25];
    wire [3:0] funct_cmd = Instr[24:21];
    wire funct_S = Instr[20];
    //wire [3:0] Rn = Instr[19:16];
    wire [3:0] Rd = Instr[15:12];
    //wire [15:0] Src2 = Instr[11:0];
    
    reg [9:0] result;
    reg ALUOp0;
    assign Branch = result[9];
    assign MemtoReg = result[8];
    assign MemW = result[7];
    assign ALUSrc = result[6];
    assign ImmSrc[1:0] =result[5:4];
    assign RegW = result[3];
    assign RegSrc[1:0] = result[2:1];
    assign ALUOp[1] = result[0];
    assign ALUOp[0] = (op==2'b01 && !Instr[23]) ? 1'b0 : 1'b1;//如果是Mem且减法（U=0）则为0，其他为1
    
    //全写always是因为没有变化量出现吗？是的，这里没引入CLK就没有其他变化量了
    always @(*) begin
        case(op)
            2'b00:
                case(funct_I)
                    1'b0:result = 10'b0000XX1001;
                    1'b1:result = 10'b0001001X01;
                    //dafualt:result = 10'bX;
                endcase
            2'b01:
                case(funct_S)
                    1'b0:result = 10'b0X11010100;
                    1'b1:result = 10'b0101011X00;
                    //dafualt:result = 10'bX;
                endcase
            2'b10:result = 10'b1001100X10;
            //dafualt:result = 10'bX;
        endcase
        //ALUOp[0]看Mem加减Imm，funct_U（23）
        //if (op==2'b01 && !Instr[23]) begin
        //    ALUOp0 = 1'b1;
        //end
        //else begin
        //    ALUOp0 = 1'b0;
        //end
    end
    
    //第二部分
    //判定ALUControl
    always @(*) begin
        if (ALUOp == 2'b00) begin//Mem减法
            ALUControl = 2'b01;
        end
        else if (ALUOp == 2'b01) begin//Mem加法
            ALUControl = 2'b00;
        end
        else if (ALUOp == 2'b11) begin//DP
            case(funct_cmd)
                        4'b0100,4'b1011:
                                ALUControl = 2'b00;
                        4'b0010,4'b1010:
                                ALUControl = 2'b01;
                        4'b0000:
                                ALUControl = 2'b10;
                        4'b1100:
                                ALUControl = 2'b11;
                        default:
                               ALUControl = 2'b00;
            endcase
        end
    end
    
    //判定FlagW
    always @(*) begin
        if (ALUOp[1] && funct_S) begin
            case(funct_cmd)
                4'b0100,4'b0010,4'b1010,4'b1011:
                    FlagW = 2'b11;
                4'b0000,4'b1100:
                    FlagW = 2'b10;
                default:
                    FlagW = 2'b00;
            endcase
        end
        else begin
            FlagW = 2'b00;
        end
    end
    
    //新功能CMP&CMN，判定为00的情况下：S=1且为CMP&CMN
    assign NoWrite = (ALUOp ==2'b10 && (funct_cmd==4'b1011 || funct_cmd==4'b1010) && Instr[20]);// ? 1'b1 : 1'b0;
    
    //PC Logic,若PCS=0是否意味着未执行且PCSrc=0,是的
    assign PCS = ((Rd == 15) && RegW) || Branch;
    
endmodule

//    always@(*) begin
//        if(Instr[27]==1) begin
//            Branch = 1'b1;
//        end
//        else begin
//            Branch = 1'b0;
//        end
//    end
//    always@(*) begin
//        if(op == 2'b00) begin
//            ALUOp[1] = 1'b1;
//        end
//        else begin 
//            ALUOp[1] = 1'b0;
//        end
//        if(op == 2'b01 && !Instr[23]) begin
//            ALUOp[0] = 1'b1;
//        end
//        else begin 
//            ALUOp[0] = 1'b0;
//        end
//    end