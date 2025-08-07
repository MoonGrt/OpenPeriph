module binarizer (
    // module clock
    input wire       clk,    // 时钟信号
    input wire       rst_n,  // 复位信号（低有效）
    input wire       EN,     // 使能信号
    input wire [1:0] mode,   // 模式选择（00=正常模式，01=反相模式，10=镜像模式，11=反镜像模式）

    input wire [7:0] threshold,  // 阈值
 
    // 图像处理前的数据接口
    input wire       pre_vs,  // vs信号
    input wire       pre_de,  // data enable信号
    input wire [7:0] pre_data,

    // 图像处理后的数据接口
    output wire post_vs,  // vs信号
    output wire post_de,  // data enable信号
    output wire post_bit  // bit（1=白，0=黑）
);

    // reg define
    reg bit_d0;
    reg pre_vs_d;
    reg pre_de_d;

    //*****************************************************
    //**                    main code
    //*****************************************************
    // assign bit_fall = (!post_bit_r) & bit_d0;
    // // 寄存以找下降沿
    // always @(posedge clk) begin
    //     bit_d0 <= post_bit_r;
    // end

    // 二值化
    reg post_bit_r;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) post_bit_r <= 1'b0;
        else if (pre_data > threshold) post_bit_r <= 1'b1; // 阈值
        else post_bit_r <= 1'b0;
    end

    // 延时2拍以同步时钟信号
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pre_vs_d <= 1'd0;
            pre_de_d <= 1'd0;
        end else begin
            pre_vs_d <= pre_vs;
            pre_de_d <= pre_de;
        end
    end

    assign post_vs = EN ? pre_vs_d : pre_vs;
    assign post_de = EN ? pre_de_d : pre_de;
    assign post_bit = EN ? post_bit_r : 1'b0;

endmodule
