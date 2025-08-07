module filler #(
    parameter H_DISP = 12'd1280,
    parameter V_DISP = 12'd720
) (
    input wire        rst_n,
    input wire        EN,
    input wire [ 1:0] mode,  // 01: 黑色, 10: 白色, 11: 自定义
    input wire [23:0] color,

    input  wire        pre_clk,
    input  wire        pre_vs,
    input  wire        pre_de,
    input  wire [23:0] pre_data,
    output wire        post_clk,
    output wire        post_vs,
    output reg         post_de,
    output reg  [23:0] post_data
);

    // mode 01: 黑色, 10: 白色, 11: 自定义
    localparam BLACK = 24'h000000;
    localparam WHITE = 24'hffffff;
    reg [23:0] fill_color = BLACK;
    always @(*) begin
        case (mode)
            2'b01: fill_color = BLACK;
            2'b10: fill_color = WHITE;
            2'b11: fill_color = color;
            default: fill_color = BLACK;
        endcase
    end

    reg EN_d1, EN_d2, pre_vs_d1, pre_vs_d2, pre_de_d1, pre_de_d2;
    reg [3:0] BLANK_CNT;
    wire EN_pedge = EN & (EN_d1 ^ EN_d2);  // 正沿触发
    wire EN_nedge = ~EN & (EN_d1 ^ EN_d2);  // 负沿触发
    wire pre_vs_pedge = pre_vs & (pre_vs_d1 ^ pre_vs_d2);  // 正沿触发
    wire pre_vs_nedge = ~pre_vs & (pre_vs_d1 ^ pre_vs_d2);  // 负沿触发
    wire pre_de_pedge = pre_de & (pre_de_d1 ^ pre_de_d2);  // 正沿触发
    wire pre_de_nedge = ~pre_de & (pre_de_d1 ^ pre_de_d2);  // 负沿触发
    always @(posedge pre_clk or negedge rst_n) begin
        if (~rst_n) begin
            EN_d1 <= 1'b0;
            EN_d2 <= 1'b0;
            pre_vs_d1 <= 1'b0;
            pre_vs_d2 <= 1'b0;
            pre_de_d1 <= 1'b0;
            pre_de_d2 <= 1'b0;
        end else begin
            EN_d1 <= EN;
            EN_d2 <= EN_d1;
            pre_vs_d1 <= pre_vs;
            pre_vs_d2 <= pre_vs_d1;
            pre_de_d1 <= pre_de;
            pre_de_d2 <= pre_de_d1;
        end
    end


    // 定义状态
    localparam IDLE  = 2'b00;  // 空闲状态
    localparam BLANK = 2'b01;  // 进入空白帧状态
    localparam RECV  = 2'b10;  // 接收像素数据状态
    localparam FILL  = 2'b11;  // 填充黑色像素状态
    reg [ 1:0] state;  // 当前状态

    // 状态机与输出逻辑
    reg [11:0] h_cnt;  // 行内像素计数器
    reg recv_start = 1'b0;  // 接收开始标志
    assign post_clk = pre_clk;
    assign post_vs = pre_vs;
    always @(posedge pre_clk or negedge rst_n) begin
        if (~rst_n) begin
            // 复位所有信号
            state <= IDLE;
            h_cnt <= 12'd0;
            post_de <= 1'b0;
            post_data <= 24'h000000;
            BLANK_CNT <= 4'b0;
            recv_start <= 1'b0;
        end else begin
            post_de <= pre_de;
            post_data <= pre_data;
            case (state)
                IDLE: if (EN_pedge) state <= BLANK;  // 边沿触发，进入空白帧状态
                BLANK: begin
                    post_de <= 1'b1;
                    post_data <= fill_color;
                    if (pre_vs_pedge) BLANK_CNT <= BLANK_CNT + 1;
                    if (BLANK_CNT == 4'b0100) begin
                        state <= RECV;
                        BLANK_CNT <= 4'b0;
                    end
                end
                RECV: begin
                    post_de <= recv_start;
                    if (recv_start) h_cnt <= h_cnt + 1'b1;
                    if (pre_de_pedge) begin
                        recv_start <= 1'b1;
                        h_cnt <= 12'd0;
                    end
                    if (pre_de_nedge && (h_cnt < H_DISP)) state <= FILL;
                    if (~EN) state <= IDLE;  // 负沿触发，进入空闲状态
                end
                FILL: begin
                    post_de <= recv_start;
                    post_data <= fill_color;
                    h_cnt <= h_cnt + 1'b1;
                    if (h_cnt == H_DISP - 1) begin
                        state <= RECV;  // 达到H_DISP后回到RECV状态
                        recv_start <= 1'b0;
                    end
                    if (~EN) state <= IDLE;  // 负沿触发，进入空闲状态
                end
            endcase
        end
    end

    // // pixel 计数器
    // reg [25:0] pixel_cnt = 0;
    // always @(posedge pre_clk or negedge rst_n) begin
    //     if (~rst_n | pre_vs) pixel_cnt <= 0;
    //     else if (post_de) pixel_cnt <= pixel_cnt + 1;
    //     else pixel_cnt <= pixel_cnt;
    // end

endmodule
