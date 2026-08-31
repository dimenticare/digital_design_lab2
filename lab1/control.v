`timescale 1ns / 1ps

module control(
    input clk,
    input pause,        // high when pressed down
    input speedup,      // high when pressed down
    input speeddown,    // high when pressed down
    output reg [7:0] addr
);

parameter CLK_FREQ = 100_000_000;    
// 按钮状态缓存    
reg pause_r;
reg speedup_r;
reg speeddown_r;

//记录延迟时刻的状态
always @(posedge clk ) begin
   pause_r <= pause;
   speeddown_r <= speeddown;
   speedup_r <= speedup;
end

//上升沿的检测判定//这是下降沿TT
/*assign _pause = pause_r & ~pause;
assign _speeddown = speeddown_r & ~speeddown;
assign _speedup = speedup_r & ~speedup; */
assign _pause = !pause_r & pause;
assign _speeddown = !speeddown_r & speeddown;
assign _speedup = !speedup_r & speedup;

//时钟与速度初始化及工作状态判定
reg state = 1'b1;
reg [40:0] clk_cnt = 32'b0;
reg [4:0] speed = 5'd4;
wire CLK_MAX;
assign CLK_MAX = (clk_cnt >= 4*CLK_FREQ - 1) ? 1 :0;

//时钟计数
always @(posedge clk ) begin
    if (clk_cnt >= 4*CLK_FREQ - 1) begin
        clk_cnt <= 32'b0;
    end
    else begin
        clk_cnt <= clk_cnt + speed;
    end
end

always @ (posedge clk) begin
    if(_pause) begin
        //反转状态
        state <= ~state;
    end
    else begin
        state <= state;
    end
end

//速度模块调控
always @(posedge clk ) begin
    //最高不超过4words读数
    if((_speedup) && (speed < 16)) begin
        speed <= speed << 2;
    end
    //最低不低于0.25words读数
    else if((_speeddown) && (speed > 1)) begin
        speed <= speed >> 2;
    end
    else begin
        speed <= speed;
    end
end

//遍历address
always @ (posedge clk) begin
    if(~state) begin
        addr <= addr;
    end
    else begin
        if(addr[6:0] == 128) begin
            addr[6:0] <= 0;
        end
        else if (CLK_MAX) begin 
            addr <= addr + 1;
        end
        else begin
            addr <= addr;
        end
    end
end

endmodule
