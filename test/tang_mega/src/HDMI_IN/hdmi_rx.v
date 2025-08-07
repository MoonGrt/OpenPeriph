`timescale 1ns / 1ps

module hdmi_rx (
    input wire clk_10m,    // 10M时钟
    input wire clk_200m,   // 200M参考时钟
    input wire tmdsclk_p,  // HDMI输入差分时钟
    input wire tmdsclk_n,  // HDMI输入差分时钟
    input wire blue_p,     // HDMI输入蓝色差分数据
    input wire green_p,    // HDMI输入绿色差分数据
    input wire red_p,      // HDMI输入红色差分数据
    input wire blue_n,     // HDMI输入蓝色差分数据
    input wire green_n,    // HDMI输入绿色差分数据
    input wire red_n,      // HDMI输入红色差分数据
    input wire rst_n,      // 复位信号，低有效

    output wire        reset,       // RX端复位信号
    output wire        pclk,        // 像素点采样时钟
    output wire        pclkx5,      // 像素点5倍采样时钟
    output wire        hsync,       // 行信号
    output wire        vsync,       // 场信号
    output wire        de,          // 数据使能
    output wire [23:0] rgb_data,    // 像素数据
    output wire        hdmi_in_en,  // 输入输出使能信号，0代表输入，1代表输出
    output reg         hdmi_in_hpd  // 热插拔信号
);


    // wire define
    wire [7:0] red;  // 红色像素数据
    wire [7:0] green;  // 绿色像素数据
    wire [7:0] blue;  // 蓝色像素数据

    //*****************************************************
    //**                    main code
    //*****************************************************

    assign rgb_data   = {red, green, blue};
    assign hdmi_in_en = 1'b0;

    // 热插拔信号
    always @(posedge clk_10m or negedge rst_n) begin
        if (rst_n == 1'b0) hdmi_in_hpd <= 1'b0;
        else hdmi_in_hpd <= 1'b1;
    end

    // hdmi解码模块
    dvi_decoder u_dvi_decoder (
        // input
        .clk_200m (clk_200m),
        .tmdsclk_p(tmdsclk_p),  // tmds clock
        .tmdsclk_n(tmdsclk_n),  // tmds clock
        .blue_p   (blue_p),     // Blue data in
        .green_p  (green_p),    // Green data in
        .red_p    (red_p),      // Red data in
        .blue_n   (blue_n),     // Blue data in
        .green_n  (green_n),    // Green data in
        .red_n    (red_n),      // Red data in
        .exrst_n  (rst_n),      // external reset input, e.g. reset button
        // output
        .reset    (reset),      // rx reset
        .pclk     (pclk),       // double rate pixel clock
        .pclkx5   (pclkx5),     // 10x pixel as IOCLK
        .hsync    (hsync),      // hsync data
        .vsync    (vsync),      // vsync data
        .de       (de),         // data enable
        .red      (red),        // pixel data out
        .green    (green),      // pixel data out
        .blue     (blue)        // pixel data out

    );  // pixel data out

endmodule
