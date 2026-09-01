`timescale 1ns / 1ps

module memory(
    input clk,
    input [7:0] addr,
    output reg [31:0] data
);
//同学在这里没有定义参数i，所以会报错QAQ
integer i;
// TODO  
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
reg [31:0] INSTR_MEM        [127:0];
initial begin
			INSTR_MEM[0] = 32'hE3A00000; 
			INSTR_MEM[1] = 32'hE1A0100F; 
			INSTR_MEM[2] = 32'hE0800001; 
			INSTR_MEM[3] = 32'hE2511001; 
			INSTR_MEM[4] = 32'h1AFFFFFC; 
			INSTR_MEM[5] = 32'hE59F01E8; 
			INSTR_MEM[6] = 32'hE58F57E0; 
			INSTR_MEM[7] = 32'hE59F57DC; 
			INSTR_MEM[8] = 32'hE59F21D8; 
			INSTR_MEM[9] = 32'hE5820000; 
			INSTR_MEM[10] = 32'hE5820004; 
			INSTR_MEM[11] = 32'hEAFFFFFE; 
			for(i = 12; i < 128; i = i+1) begin 
				INSTR_MEM[i] = 32'h0; 
			end
end

//----------------------------------------------------------------
// Data (Constant) Memory
//----------------------------------------------------------------
reg [31:0] DATA_CONST_MEM   [127:0];
//integer i;由于前面也要用到，所以要定义在前面
initial begin
			DATA_CONST_MEM[0] = 32'h00000800; 
			DATA_CONST_MEM[1] = 32'hABCD1234; 
			for(i = 2; i < 128; i = i+1) begin 
				DATA_CONST_MEM[i] = 32'h0; 
			end
end

//----------------------------------------------------------------
// Choices between 0 and 1
//---------------------------------------------------------------- 
always @ (posedge clk) begin
    case(addr[7]) 
        0: begin
            data <= INSTR_MEM[addr[6:0]];
        end
        1: begin
            data <= DATA_CONST_MEM[addr[6:0]];
        end
        default: data <= 0;
    endcase
end   

    
endmodule
