`timescale 1ns / 1ps

module dvi_decoder (
    input wire clk_200m,
    input wire tmdsclk_p,  // tmds clock
    input wire tmdsclk_n,  // tmds clock
    input wire blue_p,     // Blue data in
    input wire green_p,    // Green data in
    input wire red_p,      // Red data in
    input wire blue_n,     // Blue data in
    input wire green_n,    // Green data in
    input wire red_n,      // Red data in
    input wire exrst_n,    // external reset input, e.g. reset button

    output reg        reset,   // rx reset
    output wire       pclk,    // regenerated pixel clock
    output wire       pclkx5,  // 5x pixel as IOCLK
    output wire       hsync,   // hsync data
    output wire       vsync,   // vsync data
    output wire       de,      // data enable
    output wire [7:0] red,     // pixel data out
    output wire [7:0] green,   // pixel data out
    output wire [7:0] blue     // pixel data out

);

    // parameter define
    parameter kCtlTknCount = 128;  // 检测到控制字符的最低持续个数
    parameter kTimeoutMs = 50;  // 未检测到控制字符的最大时间间隔

    // wire define
    wire de_b, de_g, de_r;
    wire blue_rdy, green_rdy, red_rdy;  // 数据准备好信号
    wire blue_vld, green_vld, red_vld;  // 数据有效信号

    //*****************************************************
    //**                    main code
    //*****************************************************

    assign de = de_b;

    // RX端的复位信号
    always @(posedge pclk) begin
        if (!exrst_n) reset <= 1'b1;
        else reset <= ~pll_lckd;
    end

    // HDMI时钟模块
    tmds_clock u_tmds_clock (

        .tmds_clk_p(tmdsclk_p),
        .tmds_clk_n(tmdsclk_n),

        .pixelclk (pclk),
        .serialclk(pclkx5),
        .alocked  (pll_lckd)
    );

    // HDMI红色数据解码模块
    tmds_decoder #(
        .kCtlTknCount (kCtlTknCount),  // 检测到控制字符的最低持续个数
        .kTimeoutMs   (kTimeoutMs),    // 未检测到控制字符的最大时间间隔
        .kRefClkFrqMHz(200)            // 参考时钟频率
    ) u_tmds_decoder_0 (

        .arst       (reset),
        .pixelclk   (pclk),
        .serialclk  (pclkx5),
        .refclk     (clk_200m),
        .prst       (~exrst_n),
        .sdatain_p  (red_p),
        .sdatain_n  (red_n),
        .potherchrdy({blue_rdy, green_rdy}),
        .potherchvld({blue_vld, green_vld}),
        .palignerr  (),
        .pc0        (),
        .pc1        (),
        .pmerdy     (red_rdy),
        .pmevld     (red_vld),
        .pvde       (de_r),
        .pdatain    (red),
        .peyesize   ()
    );

    // HDMI蓝色数据解码模块
    tmds_decoder #(
        .kCtlTknCount (kCtlTknCount),  // 检测到控制字符的最低持续个数
        .kTimeoutMs   (kTimeoutMs),    // 未检测到控制字符的最大时间间隔
        .kRefClkFrqMHz(200)            // 参考时钟频率
    ) u_tmds_decoder_1 (

        .arst       (reset),
        .pixelclk   (pclk),
        .serialclk  (pclkx5),
        .refclk     (clk_200m),
        .prst       (~exrst_n),
        .sdatain_p  (blue_p),
        .sdatain_n  (blue_n),
        .potherchrdy({red_rdy, green_rdy}),
        .potherchvld({red_vld, green_vld}),
        .palignerr  (),
        .pc0        (hsync),
        .pc1        (vsync),
        .pmerdy     (blue_rdy),
        .pmevld     (blue_vld),
        .pvde       (de_b),
        .pdatain    (blue),
        .peyesize   ()
    );

    // HDMI绿色数据解码模块
    tmds_decoder #(
        .kCtlTknCount (kCtlTknCount),  // 检测到控制字符的最低持续个数
        .kTimeoutMs   (kTimeoutMs),    // 未检测到控制字符的最大时间间隔
        .kRefClkFrqMHz(200)            // 参考时钟频率
    ) u_tmds_decoder_2 (

        .arst       (reset),
        .pixelclk   (pclk),
        .serialclk  (pclkx5),
        .refclk     (clk_200m),
        .prst       (~exrst_n),
        .sdatain_p  (green_p),
        .sdatain_n  (green_n),
        .potherchrdy({red_rdy, blue_rdy}),
        .potherchvld({red_vld, blue_vld}),
        .palignerr  (),
        .pc0        (),
        .pc1        (),
        .pmerdy     (green_rdy),
        .pmevld     (green_vld),
        .pvde       (de_g),
        .pdatain    (green),
        .peyesize   ()
    );

endmodule
