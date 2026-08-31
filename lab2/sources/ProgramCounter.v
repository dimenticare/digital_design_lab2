module ProgramCounter(
    input CLK,
    input Reset,
    input PCSrc,
    input [31:0] Result,
    
    output reg [31:0] PC, //current_PC
    output [31:0] PC_Plus_4
); 

//fill your Verilog code here
wire [31:0] next_PC;

// 选择器：根据PCSrc选择Result或PC_Plus_4
assign next_PC = (PCSrc == 1) ? Result : PC_Plus_4;

// D触发器：D为next_PC，Q为当前PC，具有异步复位功能
always @(posedge CLK or posedge Reset) begin
    if (Reset) begin
        // 如果Reset为高电平，则将PC异步重置为0
        PC <= 32'b0;
    end else begin
        // 否则，将PC更新为选择器的输出
        PC <= next_PC;
    end
end

// 计算PC_Plus_4的值
assign PC_Plus_4 = PC + 4;

endmodule
