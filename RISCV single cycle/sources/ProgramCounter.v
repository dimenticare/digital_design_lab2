`timescale 1ns / 1ps

module ProgramCounter(
    input CLK,
    input Reset,
    input [31:0] next_PC,
    
    output reg [31:0] current_PC
); 

    always @(posedge CLK or posedge Reset) begin
        if (Reset) begin
            current_PC <= 32'b0;//32'h3000
        end else begin
            current_PC <= next_PC;
        end
    end

endmodule
