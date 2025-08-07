`timescale 1ns / 1ps

module tmds_decoder #(
    parameter kCtlTknCount  = 128,  // 检测到控制字符的最低持续个数
    parameter kTimeoutMs    = 50,   // 未检测到控制字符的最大时间间隔
    parameter kRefClkFrqMHz = 200   // 参考时钟频率
) (
    input        arst,
    input        pixelclk,     // TMDS clock x1 (CLKDIV)
    input        serialclk,    // TMDS clock x5 (CLK)
    input        refclk,       // 200 MHz reference clock
    input        prst,         // Synchronous reset to restart lock procedure
    input        sdatain_p,    // TMDS data channel positive
    input        sdatain_n,    // TMDS data channel negative
    input  [1:0] potherchrdy,  // 另外2组数据同步完成信号
    input  [1:0] potherchvld,  // 另外2组数据校准完成信号
    output       palignerr,    // 校准错误信号
    output       pc0,          // 控制信号
    output       pc1,          // 控制信号
    output       pmerdy,       // 数据同步完成信号
    output       pmevld,       // 数据校准完成信号
    output       pvde,         // 数据有效使能
    output [7:0] pdatain,      // 解码后8bit颜色数据
    output [4:0] peyesize      // 连续监测到控制字符的延迟值的次数

);

    // wire define
    wire       pc0;  // 控制信号
    wire       pc1;  // 控制信号
    wire       pvde;  // 数据有效使能
    wire [7:0] pdatain;  // 解码后的8bit颜色数据
    wire [4:0] peyesize;  // 连续监测到控制字符的延迟值的次数
    wire [9:0] pdatainbnd;  // 同步后的10bit并行数据
    wire [9:0] pdatainraw;  // 转化后的10bit并行数据
    wire       pmerdy_int;  // 数据同步完成信号
    wire       paligned;  // 数据校准完成信号
    wire       palignerr_int;  // 校准错误信号
    wire       pidly_ld;  // IDELAYE控制信号
    wire       pidly_ce;  // IDELAYE控制信号
    wire       pidly_inc;  // IDELAYE控制信号
    wire [4:0] pidly_cnt;  // IDELAYE延迟值
    wire       pbitslip;  // 字对齐移动信号

    //*****************************************************
    //**                    main code
    //*****************************************************

    assign palignerr = palignerr_int;  // 校准错误信号
    assign pmevld    = paligned;  // 数据校准完成信号
    assign pmerdy    = pmerdy_int;  // 数据同步完成信号

    // 8b/10b解码模块
    decoder u_decoder (
        .pixelclk   (pixelclk),
        .pdatainbnd (pdatainbnd),
        .potherchrdy(potherchrdy),
        .pmerdy_int (pmerdy_int),

        .pc0    (pc0),
        .pc1    (pc1),
        .pvde   (pvde),
        .pdatain(pdatain)
    );

    // 串并转化模块模块
    selectio_1_10 #(
        .SYS_W(1),
        .DEV_W(10)
    ) u_selectio_1_10 (
        .clk_div_in         (pixelclk),
        .clk_in             (serialclk),
        .data_in_from_pins_p(sdatain_p),
        .data_in_from_pins_n(sdatain_n),
        .ref_clock          (refclk),
        // Encoded parallel data (raw)
        .data_in_to_device  (pdatainraw),
        // Control for phase alignment
        .bitslip            (pbitslip),
        .in_delay_ld        (pidly_ld),
        .in_delay_data_ce   (pidly_ce),
        .in_delay_data_inc  (pidly_inc),
        .in_delay_data_cnt  (pidly_cnt),
        .io_reset           (arst)

    );

    // 字对齐校准模块
    phasealign #(
        .kTimeoutMs(kTimeoutMs),
        .kRefClkFrqMHz(kRefClkFrqMHz),
        .kCtlTknCount(kCtlTknCount)
    ) u_phasealign (
        .prst     (prst),
        .arst     (arst),
        .pixelclk (pixelclk),
        .refclk   (refclk),
        .pdata    (pdatainraw),
        .pidly_ld (pidly_ld),
        .pidly_ce (pidly_ce),
        .pidly_inc(pidly_inc),
        .pidly_cnt(pidly_cnt),
        .pbitslip (pbitslip),
        .paligned (paligned),
        .perror   (palignerr_int),
        .peyesize (peyesize)
    );

    // 数据同步模块
    channelbond u_channelbond (
        .clk          (pixelclk),
        .rawdata      (pdatainraw),
        .iamvld       (paligned),
        .other_ch0_vld(potherchvld[0]),
        .other_ch1_vld(potherchvld[1]),
        .other_ch0_rdy(potherchrdy[0]),
        .other_ch1_rdy(potherchrdy[1]),
        .iamrdy       (pmerdy_int),
        .sdata        (pdatainbnd)
    );

endmodule
