`timescale 1ns / 1ps

module top(
    input btn_p,                // pause button
    input btn_spdup,            // speed-up button
    input btn_spddn,            // speed-down button
    input clk,                  // input clk, fundamental frequency 100MHz (in Xilinx Board) 50MHZ (in Pango board)
    output [7:0] anode,         // anodes for 7-segment
    output [6:0] cathode,       // cathodes for 7-segment
    output dp,                  // dot point for 7-segment
    output [7:0] led            // output current addr by led 
);

wire [7:0] addr;
wire [31:0] data;
wire btn_p_stable;
wire btn_spdup_stable;
wire btn_spddn_stable;

control ctrl(clk, btn_p_stable, btn_spdup_stable, btn_spddn_stable, addr);
Seven_Seg ss(clk, data, anode, dp, cathode);

// TODO - add others missing codes
memory mem(clk, addr, data);
KeyDebounce key(clk,btn_p,btn_spdup,btn_spddn,btn_p_stable,btn_spdup_stable,btn_spddn_stable);

assign led = addr;

endmodule