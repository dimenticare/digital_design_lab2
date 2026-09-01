module KeyDebounce #(
    parameter CLK_FREQ = 100_000_000,  // 板子是100M的
    parameter DEBOUNCE_TIME = 20_000_000 // 消抖时间（20ms）
)(
    input  clk,               // clock input
    input  btn_p, 
    input  btn_spdup,
    input  btn_spddn,
    output reg btn_p_stable,
    output reg btn_spdup_stable,
    output reg btn_spddn_stable
);

    reg [26:0] counter_p;       // 计数器用于消抖，27位足够计数到20ms
    reg [26:0] counter_spdup;
    reg [26:0] counter_spddn;

    reg btn_p_prev;             // 上一个状态
    reg btn_spdup_prev;
    reg btn_spddn_prev;

    always @(posedge clk) begin
        // 按钮 p 的消抖逻辑
        if (btn_p != btn_p_prev) begin
            counter_p <= 0; // 状态变化，重置计数器
        end else if (counter_p < DEBOUNCE_TIME) begin
            counter_p <= counter_p + 1; // 计数器加一
        end

        // 如果计数器达到消抖时间，更新稳定信号
        if (counter_p == DEBOUNCE_TIME) begin
            btn_p_stable <= btn_p;
        end

        // 按钮 spdup 的消抖逻辑
        if (btn_spdup != btn_spdup_prev) begin
            counter_spdup <= 0;
        end else if (counter_spdup < DEBOUNCE_TIME) begin
            counter_spdup <= counter_spdup + 1;
        end

        if (counter_spdup == DEBOUNCE_TIME) begin
            btn_spdup_stable <= btn_spdup;
        end

        // 按钮 spddn 的消抖逻辑
        if (btn_spddn != btn_spddn_prev) begin
            counter_spddn <= 0;
        end else if (counter_spddn < DEBOUNCE_TIME) begin
            counter_spddn <= counter_spddn + 1;
        end

        if (counter_spddn == DEBOUNCE_TIME) begin
            btn_spddn_stable <= btn_spddn;
        end

        // 更新前一个按钮状态
        btn_p_prev <= btn_p;
        btn_spdup_prev <= btn_spdup;
        btn_spddn_prev <= btn_spddn;
    end

endmodule
