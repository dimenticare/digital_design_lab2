`define ADD 2'b00;
`define SUB 2'b01;
`define AND 2'b10;
`define ORR 2'b11;

module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [1:0] ALUControl,

    output [31:0] ALUResult,
    output [3:0] ALUFlags
    );
    
    wire [31:0] Src_C;
    wire [31:0] result_0X;
    wire [31:0] result_10;
    wire [31:0] result_11;
    wire Cout;
    reg [31:0] ALUResult_r;
    
    assign Src_C = (ALUControl[0] == 1) ? ~Src_B : Src_B;
    assign result_10 = Src_A & Src_B;
    assign result_11 = Src_A | Src_B;    
    assign ALUResult = ALUResult_r;
    
    //assign result_0X = Src_A + Src_C + ALUControl[0];//这里得到的结果都是原码嘛？
    wire [1:0] c;
    Adder16 u0(.a(Src_A[15:0]), .b(Src_C[15:0]), .ci(ALUControl[0]), .sum(result_0X[15:0]), .cout(c[0]));
    Adder16 u1(.a(Src_A[31:16]), .b(Src_C[31:16]), .ci(c[0]), .sum(result_0X[31:16]), .cout(c[1]));
    //assign Cout = (((Src_A ^ Src_C) & ALUControl[0]) | (Src_A & Src_C));
    assign Cout = c[1];
    
    //各种功能实现，第一部分
    always @(*) begin
        case(ALUControl)
            2'b00:begin
                ALUResult_r = result_0X;
                //Cout = (!(Src_A[31] ^ Src_C[31]) ^ result_0X);//看溢出，但减法不看借位了嘛？
            end
            2'b01:begin
                ALUResult_r = result_0X;
                //Cout = 0;//减法设置为0正确吗？如果不正确而是看借位如何取反？
            end
            2'b10:begin
                ALUResult_r = result_10;
            end
            2'b11:begin
                ALUResult_r = result_11;
            end
            default:begin
                ALUResult_r = 32'b0;//出错了都置0
            end
        endcase
    end
    
    //第二部分
    //Flags定义
    //reg N = 0, Z = 0, C = 0, V = 0 ;
    //reg ALUFlags_r;
    //wire zero;
    //assign ALUFlags = ALUFlags_r;
    //assign zero = !(|ALUResult);//若全为0则zero为1
        
    //最后输出的ALUFlags
    //always @(*) begin
    //    ALUFlags_r = {N, Z, C, V};  
    //end
    
    //NZ更新
    assign ALUFlags[3] = ALUResult[31];
    assign ALUFlags[2] = !(|ALUResult);
    
    //CV更新
//    reg A_B;
//    reg A_Result;
    assign ALUFlags[1] = Cout & !ALUControl[1];
    assign ALUFlags[0] = ~(ALUControl[0] ^ Src_A[31] ^ Src_B[31]) & (Src_A[31] ^ result_0X[31]) & (!ALUControl[1]);

//    always @(*) begin
//        //对应情况下的溢出判断
//        C = Cout & (!ALUControl[1]);
//        //按照图片上写法的V更新
//        A_B = !(Src_A[31] ^ Src_B[31] ^ ALUControl[0]);
//        A_Result = Src_A[31] ^ ALUControl[0];
//        V = A_B & A_Result & (!ALUControl[1]);
//按照文字逻辑思路的V更新
        //判定A与Result异号
//                A_Result = Src_A[31] ^ result_0X[31];
//                if (ALUControl[0]) begin
//                    //SUB下判定AB异号
//                    A_B = Src_A[31] ^ Src_B[31];
//                end
//                else if (!ALUControl[0]) begin
//                    //ADD下判定AB同号
//                    A_B = !(Src_A[31] ^ Src_B[31]);
//                end
//                //若A与Result异号且满足ADD或SUB下AB的对应要求，则V=1
//                if (A_B && A_Result && (!ALUControl[1])) begin
//                    V = 1'b1;
//                end 
//                else begin
//                    V = 1'b0;
//                end
//    end
        
endmodule