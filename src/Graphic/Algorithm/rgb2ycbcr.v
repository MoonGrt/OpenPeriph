module rgb2ycbcr (
    //module clock
    input wire       clk,    // 模块驱动时钟
    input wire       rst_n,  // 复位信号
    input wire       EN,     // 使能信号
    input wire [1:0] mode,  // 

    //图像处理前的数据接口
    input wire        pre_vs,    // Prepared Image data vs valid signal
    input wire        pre_de,    // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data,  // Prepared Image data

    //图像处理后的数据接口
    output wire       post_vs,  // Processed Image data vs valid signal
    output wire       post_de,  // Processed Image data output/capture enable clock
    output wire [7:0] post_y,   // 输出图像Y数据
    output wire [7:0] post_cb,  // 输出图像Cb数据
    output wire [7:0] post_cr   // 输出图像Cr数据
);

    // reg define
    reg [15:0] rgb_r_m0, rgb_r_m1, rgb_r_m2;
    reg [15:0] rgb_g_m0, rgb_g_m1, rgb_g_m2;
    reg [15:0] rgb_b_m0, rgb_b_m1, rgb_b_m2;
    reg [15:0] img_y0;
    reg [15:0] img_cb0;
    reg [15:0] img_cr0;
    reg [ 7:0] img_y1;
    reg [ 7:0] img_cb1;
    reg [ 7:0] img_cr1;
    reg [ 2:0] pre_vs_d;
    reg [ 2:0] pre_de_d;

    // wire define
    wire [ 7:0] rgb888_r = pre_data[23:16];
    wire [ 7:0] rgb888_g = pre_data[15:8];
    wire [ 7:0] rgb888_b = pre_data[7:0];

    //*****************************************************
    //**                    main code
    //*****************************************************
    //--------------------------------------------
    // RGB 888 to YCbCr
    /********************************************************
        RGB888 to YCbCr Conversion
        Y  = 0.299R +0.587G + 0.114B
        Cb = 0.568(B-Y) + 128 = -0.172R-0.339G + 0.511B + 128
        CR = 0.713(R-Y) + 128 = 0.511R-0.428G -0.083B + 128

        Y  = (77 *R    +    150*G    +    29 *B) >> 8
        Cb = (-43*R    -    85 *G    +    128*B) >> 8 + 128
        Cr = (128*R    -    107*G    -    21 *B) >> 8 + 128

        Y  = (77 *R    +    150*G    +    29 *B        ) >> 8
        Cb = (-43*R    -    85 *G    +    128*B + 32768) >> 8
        Cr = (128*R    -    107*G    -    21 *B + 32768) >> 8
    *********************************************************/

    // step1 pipeline mult
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n | pre_vs) begin
            rgb_r_m0 <= 16'd0;
            rgb_r_m1 <= 16'd0;
            rgb_r_m2 <= 16'd0;
            rgb_g_m0 <= 16'd0;
            rgb_g_m1 <= 16'd0;
            rgb_g_m2 <= 16'd0;
            rgb_b_m0 <= 16'd0;
            rgb_b_m1 <= 16'd0;
            rgb_b_m2 <= 16'd0;
        end else begin
            rgb_r_m0 <= rgb888_r * 8'd77;
            rgb_r_m1 <= rgb888_r * 8'd43;
            rgb_r_m2 <= rgb888_r << 3'd7;
            rgb_g_m0 <= rgb888_g * 8'd150;
            rgb_g_m1 <= rgb888_g * 8'd85;
            rgb_g_m2 <= rgb888_g * 8'd107;
            rgb_b_m0 <= rgb888_b * 8'd29;
            rgb_b_m1 <= rgb888_b << 3'd7;
            rgb_b_m2 <= rgb888_b * 8'd21;
        end
    end

    // step2 pipeline add
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n | pre_vs) begin
            img_y0  <= 16'd0;
            img_cb0 <= 16'd0;
            img_cr0 <= 16'd0;
        end else begin
            img_y0  <= rgb_r_m0 + rgb_g_m0 + rgb_b_m0;
            img_cb0 <= rgb_b_m1 - rgb_r_m1 - rgb_g_m1 + 16'd32768;
            img_cr0 <= rgb_r_m2 - rgb_g_m2 - rgb_b_m2 + 16'd32768;
        end
    end

    // step3 pipeline div
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n | pre_vs) begin
            img_y1  <= 8'd0;
            img_cb1 <= 8'd0;
            img_cr1 <= 8'd0;
        end else begin
            img_y1  <= img_y0[15:8];
            img_cb1 <= img_cb0[15:8];
            img_cr1 <= img_cr0[15:8];
        end
    end

    // 延时3拍以同步数据信号
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pre_vs_d <= 2'd0;
            pre_de_d <= 2'd0;
        end else begin
            pre_vs_d <= {pre_vs_d[1:0], pre_vs};
            pre_de_d <= {pre_de_d[1:0], pre_de};
        end
    end

    // 同步输出数据接口信号
    assign post_vs = EN ? pre_vs_d[2] : pre_vs;
    assign post_de = EN ? pre_de_d[2] : pre_de;
    assign post_y  = EN ? img_y1 : pre_data[23:16];
    assign post_cb = EN ? img_cb1 : pre_data[15:8];
    assign post_cr = EN ? img_cr1 : pre_data[7:0];

endmodule
