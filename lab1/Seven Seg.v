`define anode_NULL     8'b0000_0000
`define anode_0        8'b1111_1110
`define anode_1        8'b1111_1101
`define anode_2        8'b1111_1011
`define anode_3        8'b1111_0111
`define anode_4        8'b1110_1111
`define anode_5        8'b1101_1111
`define anode_6        8'b1011_1111
`define anode_7        8'b0111_1111

`timescale 1ns / 1ps

module Seven_Seg#(
   parameter CLK_FREQ = 50_000_000
)(
    input clk,              // fundamental frequency 100MHz (in Xilinx Board) 50MHZ (in Pango board)
    input [31:0] data,      // 32-bit MEM contents willing to display on 7-segments
    output reg [7:0] anode,     // anodes for 7-segments
    output          dp,     // dot point for 7-segments
    output reg [6:0] cathode    // cathodes for 7-segments
);

// TODO
//…®√Ë ±÷”º∆ ˝
parameter SCAN_FREQ = 200;
parameter SCAN_CLK_CNT = CLK_FREQ /(SCAN_FREQ * 4) - 1;
reg [31:0] clk_cnt = 32'b0;
assign scan_next = (clk_cnt == SCAN_CLK_CNT);

always @(posedge clk) begin
        if (clk_cnt == SCAN_CLK_CNT) begin
            clk_cnt <= 32'b0;
        end 
        else begin
            clk_cnt <= clk_cnt + 32'b1;
        end 
end

//anode
//◊¥Ã¨◊™“∆
reg [7:0] next_seg_sel = `anode_0;
//???????????????????reg???assign
//???????????reg
// reg [7:0] anode = 8'b0000_0000;
always @(posedge clk ) begin
        anode <= next_seg_sel;
end 

//◊¥Ã¨«–ªª
always @(*) begin
    if (scan_next) begin
        case(anode)
            `anode_0: next_seg_sel <= `anode_1;
            `anode_1: next_seg_sel <= `anode_2;
            `anode_2: next_seg_sel <= `anode_3;
            `anode_3: next_seg_sel <= `anode_4;
            `anode_4: next_seg_sel <= `anode_5;
            `anode_5: next_seg_sel <= `anode_6;
            `anode_6: next_seg_sel <= `anode_7;
            `anode_7: next_seg_sel <= `anode_0;
            default:  next_seg_sel <= `anode_0;
        endcase
    end 
    else begin
        next_seg_sel <= anode;
    end 
end

//◊¥Ã¨ ‰≥ˆnum∫Õdata???
reg [3:0] sel_num = 4'b0;
//???????????????????reg???assign
//???????????reg
//reg [6:0] cathode = 7'b000_0000;
always @(posedge clk)
begin
        case(anode)
            `anode_0: sel_num = data[3:0];
            `anode_1: sel_num = data[7:4];
            `anode_2: sel_num = data[11:8];
            `anode_3: sel_num = data[15:12];
            `anode_4: sel_num = data[19:16];
            `anode_5: sel_num = data[23:20];
            `anode_6: sel_num = data[27:24];
            `anode_7: sel_num = data[31:28];
            default:  sel_num = 8'b0;
        endcase 
end
always @(*)
begin
	case(sel_num)
		4'd0: cathode = 7'b1000000;
		4'd1: cathode = 7'b1111001;
		4'd2: cathode = 7'b0100100;
		4'd3: cathode = 7'b0110000;
		4'd4: cathode = 7'b0011001;
		4'd5: cathode = 7'b0010010;
		4'd6: cathode = 7'b0000010;
		4'd7: cathode = 7'b1111000;
		4'd8: cathode = 7'b0000000;
		4'd9: cathode = 7'b0010000;
		4'ha: cathode = 7'b0001000;
		4'hb: cathode = 7'b0000011;
		4'hc: cathode = 7'b1000110;
		4'hd: cathode = 7'b0100001;
		4'he: cathode = 7'b0000110;
		4'hf: cathode = 7'b0001110;
		default:cathode = 7'b1000000;
	endcase
end 

endmodule