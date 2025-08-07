module AHBVP #(
    parameter H_DISP = 12'd1280,
    parameter V_DISP = 12'd720,
    parameter INPUT_X_RES_WIDTH = 11,
    parameter INPUT_Y_RES_WIDTH = 11,
    parameter OUTPUT_X_RES_WIDTH = 11,
    parameter OUTPUT_Y_RES_WIDTH = 11
) (
    input clk_vp,
    input rst_n,

    // VP parameters
    input [31:0] VP_CR,
    input [31:0] VP_SR,
    input [31:0] VP_START,
    input [31:0] VP_END,
    input [31:0] VP_SCALER,
    input [31:0] VP_THRESHOLD,

    // video input
    input        vi_clk,
    input        vi_vs,
    input        vi_de,
    input [15:0] vi_data,

    // video process
    output        vp_clk,
    output        vp_vs,
    output        vp_de,
    output [15:0] vp_data
);

    // Constants
    localparam BLACK = 24'h000000;
    localparam WHITE = 24'hffffff;

    // VP funtions
    // VP 模式 (2位模式: 01: scale, 10: edge, 11: binarize)
    wire [1:0] vp_mode = VP_CR[2:1];
    // Cutter 模式 (2位模式: | 1位使能: 0: 禁用, 1: 使能)
    wire       cutter_en = VP_CR[3];
    wire [1:0] cutter_mode = VP_CR[5:4];
    // Filter 模式 (2位模式: 01: gaussian, 10: mean, 11: median | 1位使能: 0: 禁用, 1: 使能)
    wire       filter_en = VP_CR[6];
    wire [1:0] filter_mode = VP_CR[8:7];
    // Scaler 模式 (2位模式: 01: neighbor, 10: bilinear, 11: | 1位使能: 0: 禁用, 1: 使能)
    wire       scaler_en = VP_CR[9];
    wire [1:0] scaler_mode = VP_CR[11:10];
    // Color 模式 (2位模式: | 1位使能: 0: 禁用, 1: 使能)
    wire       color_en = VP_CR[12];
    wire [1:0] color_mode = VP_CR[14:13];
    // Edger 模式 (2位模式: 01: sobel, 10: prewitt, 11: | 1位使能: 0: 禁用, 1: 使能)
    wire       edger_en = VP_CR[15];
    wire [1:0] edger_mode = VP_CR[17:16];
    // Binarizer 模式 (2位模式: 01: 正向模式, 10: 反相模式 | 1位使能: 0: 禁用, 1: 使能)
    wire       binarizer_en = VP_CR[18];
    wire [1:0] binarizer_mode = VP_CR[20:19];
    // Fill 模式 (2位模式: 01: 黑色, 10: 白色, 11: 自定义 | 1位使能: 0: 禁用, 1: 使能)
    wire       fill_en = VP_CR[21];
    wire [1:0] fill_mode = VP_CR[23:22];

    wire [ INPUT_X_RES_WIDTH-1:0] START_X = VP_START[INPUT_X_RES_WIDTH-1:0];
    wire [ INPUT_Y_RES_WIDTH-1:0] START_Y = VP_START[INPUT_X_RES_WIDTH-1+16:0+16];
    wire [OUTPUT_X_RES_WIDTH-1:0] END_X = VP_END[OUTPUT_X_RES_WIDTH-1:0];
    wire [OUTPUT_Y_RES_WIDTH-1:0] END_Y = VP_END[OUTPUT_X_RES_WIDTH-1+16:0+16];
    wire [OUTPUT_X_RES_WIDTH-1:0] OUTPUT_X_RES = VP_SCALER[INPUT_X_RES_WIDTH-1:0];
    wire [OUTPUT_Y_RES_WIDTH-1:0] OUTPUT_Y_RES = VP_SCALER[INPUT_X_RES_WIDTH-1+16:0+16];
    wire [7:0] edger_th = VP_THRESHOLD[7:0];
    wire [7:0] binarizer_th = VP_THRESHOLD[15:8];

    wire [ INPUT_X_RES_WIDTH-1:0] inputXRes = END_X - START_X - 1;  // Resolution of input data minus 1
    wire [ INPUT_Y_RES_WIDTH-1:0] inputYRes = END_Y - START_Y - 1;
    wire [OUTPUT_X_RES_WIDTH-1:0] outputXRes = OUTPUT_X_RES - 1;  // Resolution of input data minus 1
    wire [OUTPUT_Y_RES_WIDTH-1:0] outputYRes = OUTPUT_Y_RES - 1;

    //--------------------------------------------------------------------------
    // Scaler
    //--------------------------------------------------------------------------
    wire vs_i = vi_vs;
    wire de_i = vi_de;
    wire [23:0] rgb_i = {vi_data[15:11], 3'b0, vi_data[10:5], 2'b0, vi_data[4:0], 3'b0};
    wire cutter_post_de, cutter_post_vs;
    wire [23:0] cutter_post_data;
    cutter #(
        .H_DISP            (H_DISP),
        .V_DISP            (V_DISP),
        .INPUT_X_RES_WIDTH (INPUT_X_RES_WIDTH),
        .INPUT_Y_RES_WIDTH (INPUT_Y_RES_WIDTH),
        .OUTPUT_X_RES_WIDTH(OUTPUT_X_RES_WIDTH),
        .OUTPUT_Y_RES_WIDTH(OUTPUT_Y_RES_WIDTH)
    ) cutter (
        .clk  (vi_clk),
        .rst_n(rst_n),
        .EN   (cutter_en),

        .START_X(START_X),
        .START_Y(START_Y),
        .END_X  (END_X),
        .END_Y  (END_Y),

        .pre_vs   (vs_i),
        .pre_de   (de_i),
        .pre_data (rgb_i),
        .post_vs  (cutter_post_vs),
        .post_de  (cutter_post_de),
        .post_data(cutter_post_data)
    );

    //--------------------------------------------------------------------------
    // Filter
    //--------------------------------------------------------------------------
    wire        filter_post_vs;  // Processed Image data vs valid signal
    wire        filter_post_de;  // Processed Image data output/capture enable clock
    wire [23:0] filter_post_data;  // Processed Image output
    filter filter (
        .clk      (vi_clk),
        .rst_n    (rst_n),
        .mode     (filter_mode),  // 00: bypass, 01: gaussian, 10: median, 11: mean

        .IMG_HDISP(inputXRes),
        .IMG_VDISP(inputYRes),

        .pre_vs   (cutter_post_vs),
        .pre_de   (cutter_post_de),
        .pre_data (cutter_post_data),
        .post_vs  (filter_post_vs),
        .post_de  (filter_post_de),
        .post_data(filter_post_data)
    );

    //--------------------------------------------------------------------------
    // Scaler
    //--------------------------------------------------------------------------
    wire        scaler_post_vs;  // Processed Image data vs valid signal
    wire        scaler_post_de;  // Processed Image data output/capture enable clock
    wire [23:0] scaler_post_data;  // Processed Image output
    scaler #(
        .INPUT_X_RES_WIDTH (INPUT_X_RES_WIDTH),
        .INPUT_Y_RES_WIDTH (INPUT_Y_RES_WIDTH),
        .OUTPUT_X_RES_WIDTH(OUTPUT_X_RES_WIDTH),
        .OUTPUT_Y_RES_WIDTH(OUTPUT_Y_RES_WIDTH)
    ) scaler (
        .EN  (scaler_en),
        .mode(scaler_mode),

        .inputXRes (inputXRes),
        .inputYRes (inputYRes),
        .outputXRes(outputXRes),
        .outputYRes(outputYRes),

        .pre_clk  (vi_clk),
        .pre_vs   (filter_post_vs),
        .pre_de   (filter_post_de),
        .pre_data (filter_post_data),
        .post_clk (clk_vp),
        .post_vs  (scaler_post_vs),
        .post_de  (scaler_post_de),
        .post_data(scaler_post_data)
    );

    //--------------------------------------------------------------------------
    // Color space convert
    //--------------------------------------------------------------------------
    wire       color_post_vs;  // Processed Image data vs valid signal
    wire       color_post_de;  // Processed Image data output/capture enable clock
    wire [7:0] color_post_y;  // Processed Image output
    rgb2ycbcr rgb2ycbcr (
        .clk     (vi_clk),
        .rst_n   (rst_n),
        .EN      (color_en),
        .mode    (color_mode),

        .pre_vs  (filter_post_vs),
        .pre_de  (filter_post_de),
        .pre_data(filter_post_data),
        .post_vs (color_post_vs),
        .post_de (color_post_de),
        .post_y  (color_post_y),
        .post_cb (),
        .post_cr ()
    );

    //--------------------------------------------------------------------------
    // Edge Detector
    //--------------------------------------------------------------------------
    wire edger_post_vs;  // Processed Image data vs valid signal
    wire edger_post_de;  // Processed Image data output/capture enable clock
    wire edger_post_bit;  // Processed Image output
    edger edger (
        .clk      (vi_clk),
        .rst_n    (rst_n),
        .EN       (edger_en),
        .mode     (edger_mode),

        .IMG_HDISP(inputXRes),
        .IMG_VDISP(inputYRes),
        .threshold(edger_th),

        .pre_vs  (color_post_vs),
        .pre_de  (color_post_de),
        .pre_data(color_post_y),
        .post_vs (edger_post_vs),
        .post_de (edger_post_de),
        .post_bit(edger_post_bit)
    );

    //--------------------------------------------------------------------------
    // Binarization
    //--------------------------------------------------------------------------
    wire binarizer_post_vs;  // Processed Image data vs valid signal
    wire binarizer_post_de;  // Processed Image data output/capture enable clock
    wire binarizer_post_bit;  // Processed Image output
    binarizer binarizer (
        .clk      (vi_clk),
        .rst_n    (rst_n),
        .EN       (binarizer_en),
        .mode     (binarizer_mode),
        .threshold(binarizer_th),

        .pre_vs  (color_post_vs),
        .pre_de  (color_post_de),
        .pre_data(color_post_y),
        .post_vs (binarizer_post_vs),
        .post_de (binarizer_post_de),
        .post_bit(binarizer_post_bit)
    );

    //--------------------------------------------------------------------------
    // Fill Brank
    //--------------------------------------------------------------------------
    reg         filler_pre_clk;  // Prepared Image data clock
    reg         filler_pre_vs;  // Prepared Image data vs valid signal
    reg         filler_pre_de;  // Prepared Image data output/capture enable clock
    reg  [23:0] filler_pre_data;  // Prepared Image output
    wire        filler_post_clk;  // Prepared Image data clock
    wire        filler_post_vs;  // Processed Image data vs valid signal
    wire        filler_post_de;  // Processed Image data output/capture enable clock
    wire [23:0] filler_post_data;  // Processed Image output
    wire        filler_en = (vp_mode == 2'b01) & (OUTPUT_X_RES < H_DISP);
    // wire        filler_en = (OUTPUT_X_RES < H_DISP);
    always @ (*) begin
        if (~rst_n) begin
            filler_pre_clk  = 1'b0;
            filler_pre_vs   = 1'b0;
            filler_pre_de   = 1'b0;
            filler_pre_data = 24'd0;
        end else begin
            case (vp_mode)
                2'b01: begin
                    filler_pre_clk  = clk_vp;
                    filler_pre_vs   = scaler_post_vs;
                    filler_pre_de   = scaler_post_de;
                    filler_pre_data = scaler_post_data;
                end
                2'b10: begin
                    filler_pre_clk  = vi_clk;
                    filler_pre_vs   = edger_post_vs;
                    filler_pre_de   = edger_post_de;
                    filler_pre_data = edger_post_bit ? WHITE : BLACK;
                end
                2'b11: begin
                    filler_pre_clk  = vi_clk;
                    filler_pre_vs   = binarizer_post_vs;
                    filler_pre_de   = binarizer_post_de;
                    filler_pre_data = binarizer_post_bit ? WHITE : BLACK;
                end
                default: begin
                    filler_pre_clk  = 1'b0;
                    filler_pre_vs   = 1'b0;
                    filler_pre_de   = 1'b0;
                    filler_pre_data = 24'd0;
                end
            endcase
        end
    end
    filler #(
        .H_DISP(H_DISP)
    ) filler (
        .rst_n    (rst_n),
        .EN       (filler_en),
        .mode     (fill_mode),

        .pre_clk  (filler_pre_clk),
        .pre_vs   (filler_pre_vs),
        .pre_de   (filler_pre_de),
        .pre_data (filler_pre_data),
        .post_clk (filler_post_clk),
        .post_vs  (filler_post_vs),
        .post_de  (filler_post_de),
        .post_data(filler_post_data)
    );

    //--------------------------------------------------------------------------
    // Output
    //--------------------------------------------------------------------------
    assign vp_clk  = filler_post_clk;
    assign vp_vs   = filler_post_vs;
    assign vp_de   = filler_post_de;
    assign vp_data = {filler_post_data[23:19], filler_post_data[15:10], filler_post_data[7:3]};

endmodule
