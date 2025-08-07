module filter (
    // global clock
    input wire       clk,   // cmos video pixel clock
    input wire       rst_n, // global reset
    input wire [1:0] mode,  // enable

    // Image data parameters
    input [10:0] IMG_HDISP,
    input [10:0] IMG_VDISP,

    // Image data prepred to be processed
    input wire        pre_vs,   // Prepared Image data vs valid signal
    input wire        pre_de,   // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data, // Prepared Image data

    // Image data has been processed
    output reg        post_vs,   // Processed Image data vs valid signal
    output reg        post_de,   // Processed Image data output/capture enable clock
    output reg [23:0] post_data  // Processed Image data
);

    wire gaussian_en = (mode == 2'b01);  // enable gaussian filter
    wire mean_en = (mode == 2'b10);  // enable mean filter
    wire median_en = (mode == 2'b11);  // enable median filter

    wire        gaussian_post_vs;  // Processed Image data vs valid signal
    wire        gaussian_post_de;  // Processed Image data output/capture enable clock
    wire [23:0] gaussian_post_data;  // Processed Image output
    gaussian gaussian (
        // global clock
        .clk  (clk),  // cmos video pixel clock
        .rst_n(rst_n),  // global reset
        .EN   (gaussian_en),  // enable

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_data),

        // Image data has been processd
        .post_vs  (gaussian_post_vs),  // Processed Image data vs valid signal
        .post_de  (gaussian_post_de),  // Processed Image data output/capture enable clock
        .post_data(gaussian_post_data)
    );

    wire        mean_post_vs;  // Processed Image data vs valid signal
    wire        mean_post_de;  // Processed Image data output/capture enable clock
    wire [23:0] mean_post_data;  // Processed Image output
    mean mean (
        // global clock
        .clk  (clk),  // cmos video pixel clock
        .rst_n(rst_n),  // global reset
        .EN   (mean_en),  // enable


        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_data),

        // Image data has been processd
        .post_vs  (mean_post_vs),  // Processed Image data vs valid signal
        .post_de  (mean_post_de),  // Processed Image data output/capture enable clock
        .post_data(mean_post_data)
    );

    wire        median_post_vs;  // Processed Image data vs valid signal
    wire        median_post_de;  // Processed Image data output/capture enable clock
    wire [23:0] median_post_data;  // Processed Image output
    median median (
        // global clock
        .clk  (clk),  // cmos video pixel clock
        .rst_n(rst_n),  // global reset
        .EN   (median_en),  // enable

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_data),

        // Image data has been processd
        .post_vs  (median_post_vs),  // Processed Image data vs valid signal
        .post_de  (median_post_de),  // Processed Image data output/capture enable clock
        .post_data(median_post_data)
    );

    always @(*) begin
        if(~rst_n) begin
            post_vs   = 1'b0;
            post_de   = 1'b0;
            post_data = 24'b0;
        end else begin
            case(mode)
                2'b01: begin
                    post_vs   = gaussian_post_vs;
                    post_de   = gaussian_post_de;
                    post_data = gaussian_post_data;
                end
                2'b10: begin
                    post_vs   = mean_post_vs;
                    post_de   = mean_post_de;
                    post_data = mean_post_data;
                end
                2'b11: begin
                    post_vs   = median_post_vs;
                    post_de   = median_post_de;
                    post_data = median_post_data;
                end
                default: begin
                    post_vs   = pre_vs;
                    post_de   = pre_de;
                    post_data = pre_data;
                end
            endcase
        end
    end

endmodule


module gaussian (
    // global clock
    input wire clk,   // cmos video pixel clock
    input wire rst_n, // global reset
    input wire EN,    // enable

    // Image data parameters
    input [10:0] IMG_HDISP,
    input [10:0] IMG_VDISP,

    // Image data prepred to be processed
    input wire        pre_vs,   // Prepared Image data vs valid signal
    input wire        pre_de,   // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data, // Prepared Image data

    // Image data has been processed
    output wire        post_vs,   // Processed Image data vs valid signal
    output wire        post_de,   // Processed Image data output/capture enable clock
    output wire [23:0] post_data  // Processed Image data
);

    wire [7:0] pre_r = pre_data[23:16];  // Red channel
    wire [7:0] pre_g = pre_data[15:8];  // Green channel
    wire [7:0] pre_b = pre_data[7:0];  // Blue channel
    reg  [7:0] post_r;  // Processed Red channel
    reg  [7:0] post_g;  // Processed Green channel
    reg  [7:0] post_b;  // Processed Blue channel

    //----------------------------------------------------
    // Generate 8Bit 3X3 Matrix for Video Image Processor.
    // Image data has been processed
    wire matrix_vs;  // Prepared Image data vs valid signal
    wire matrix_href;  // Prepared Image data href valid signal
    wire matrix_de;  // Prepared Image data output/capture enable clock

    // Define the 3x3 matrix for R, G, B channels
    wire [7:0] matrix_p11_r, matrix_p12_r, matrix_p13_r;
    wire [7:0] matrix_p21_r, matrix_p22_r, matrix_p23_r;
    wire [7:0] matrix_p31_r, matrix_p32_r, matrix_p33_r;

    wire [7:0] matrix_p11_g, matrix_p12_g, matrix_p13_g;
    wire [7:0] matrix_p21_g, matrix_p22_g, matrix_p23_g;
    wire [7:0] matrix_p31_g, matrix_p32_g, matrix_p33_g;

    wire [7:0] matrix_p11_b, matrix_p12_b, matrix_p13_b;
    wire [7:0] matrix_p21_b, matrix_p22_b, matrix_p23_b;
    wire [7:0] matrix_p31_b, matrix_p32_b, matrix_p33_b;

    // Instantiate 3x3 matrix generator for each channel
    matrix3x3 matrix3x3_r (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_r),  // Prepared Image input

        // Image data has been processd
        .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_r), .matrix_p12(matrix_p12_r), .matrix_p13(matrix_p13_r),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_r), .matrix_p22(matrix_p22_r), .matrix_p23(matrix_p23_r),
        .matrix_p31(matrix_p31_r), .matrix_p32(matrix_p32_r), .matrix_p33(matrix_p33_r)
    );

    matrix3x3 matrix3x3_g (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_g),  // Prepared Image input

        // Image data has been processd
        // .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        // .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_g), .matrix_p12(matrix_p12_g), .matrix_p13(matrix_p13_g),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_g), .matrix_p22(matrix_p22_g), .matrix_p23(matrix_p23_g),
        .matrix_p31(matrix_p31_g), .matrix_p32(matrix_p32_g), .matrix_p33(matrix_p33_g)
    );

    matrix3x3 matrix3x3_b (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_b),  // Prepared Image input

        // Image data has been processd
        // .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        // .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_b), .matrix_p12(matrix_p12_b), .matrix_p13(matrix_p13_b),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_b), .matrix_p22(matrix_p22_b), .matrix_p23(matrix_p23_b),
        .matrix_p31(matrix_p31_b), .matrix_p32(matrix_p32_b), .matrix_p33(matrix_p33_b)
    );

    //--------------------------------------------------------------------------
    // 计算最终结果
    //  {1, 2, 1}
    //  {2, 4, 2}
    //  {1, 2, 1}
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            post_r <= 8'b0;
            post_g <= 8'b0;
            post_b <= 8'b0;
        end else if (pre_de) begin
            post_r <= (matrix_p11_r + matrix_p12_r*2 + matrix_p13_r + matrix_p21_r*2 + matrix_p22_r*4 +
                       matrix_p23_r*2 + matrix_p31_r + matrix_p32_r*2 + matrix_p33_r) >> 4;
            post_g <= (matrix_p11_g + matrix_p12_g*2 + matrix_p13_g + matrix_p21_g*2 + matrix_p22_g*4 +
                       matrix_p23_g*2 + matrix_p31_g + matrix_p32_g*2 + matrix_p33_g) >> 4;
            post_b <= (matrix_p11_b + matrix_p12_b*2 + matrix_p13_b + matrix_p21_b*2 + matrix_p22_b*4 +
                       matrix_p23_b*2 + matrix_p31_b + matrix_p32_b*2 + matrix_p33_b) >> 4;
        end
    end

    //---------------------------------------
    // lag 1 clocks signal sync
    reg pre_vs_r;
    reg pre_de_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pre_vs_r <= 0;
            pre_de_r <= 0;
        end else begin
            pre_vs_r <= matrix_vs;
            pre_de_r <= matrix_de;
        end
    end

    assign post_vs   = EN ? pre_vs_r : pre_vs;
    assign post_de   = EN ? pre_de_r : pre_de;
    assign post_data = EN ? {post_r, post_g, post_b} : pre_data;

endmodule


module mean (
    // global clock
    input wire clk,   // cmos video pixel clock
    input wire rst_n, // global reset
    input wire EN,    // enable

    // Image data parameters
    input [10:0] IMG_HDISP,
    input [10:0] IMG_VDISP,

    // Image data prepred to be processed
    input wire        pre_vs,   // Prepared Image data vs valid signal
    input wire        pre_de,   // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data, // Prepared Image data

    // Image data has been processed
    output wire        post_vs,   // Processed Image data vs valid signal
    output wire        post_de,   // Processed Image data output/capture enable clock
    output wire [23:0] post_data  // Processed Image data
);

    wire [7:0] pre_r = pre_data[23:16];  // Red channel
    wire [7:0] pre_g = pre_data[15:8];  // Green channel
    wire [7:0] pre_b = pre_data[7:0];  // Blue channel
    reg  [7:0] post_r;  // Processed Red channel
    reg  [7:0] post_g;  // Processed Green channel
    reg  [7:0] post_b;  // Processed Blue channel

    //----------------------------------------------------
    // Generate 8Bit 3X3 Matrix for Video Image Processor.
    // Image data has been processed
    wire matrix_vs;  // Prepared Image data vs valid signal
    wire matrix_href;  // Prepared Image data href valid signal
    wire matrix_de;  // Prepared Image data output/capture enable clock

    // Define the 3x3 matrix for R, G, B channels
    wire [7:0] matrix_p11_r, matrix_p12_r, matrix_p13_r;
    wire [7:0] matrix_p21_r, matrix_p22_r, matrix_p23_r;
    wire [7:0] matrix_p31_r, matrix_p32_r, matrix_p33_r;

    wire [7:0] matrix_p11_g, matrix_p12_g, matrix_p13_g;
    wire [7:0] matrix_p21_g, matrix_p22_g, matrix_p23_g;
    wire [7:0] matrix_p31_g, matrix_p32_g, matrix_p33_g;

    wire [7:0] matrix_p11_b, matrix_p12_b, matrix_p13_b;
    wire [7:0] matrix_p21_b, matrix_p22_b, matrix_p23_b;
    wire [7:0] matrix_p31_b, matrix_p32_b, matrix_p33_b;

    // Instantiate 3x3 matrix generator for each channel
    matrix3x3 matrix3x3_r (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_r),  // Prepared Image input

        // Image data has been processd
        .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_r), .matrix_p12(matrix_p12_r), .matrix_p13(matrix_p13_r),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_r), .matrix_p22(matrix_p22_r), .matrix_p23(matrix_p23_r),
        .matrix_p31(matrix_p31_r), .matrix_p32(matrix_p32_r), .matrix_p33(matrix_p33_r)
    );

    matrix3x3 matrix3x3_g (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_g),  // Prepared Image input

        // Image data has been processd
        // .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        // .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_g), .matrix_p12(matrix_p12_g), .matrix_p13(matrix_p13_g),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_g), .matrix_p22(matrix_p22_g), .matrix_p23(matrix_p23_g),
        .matrix_p31(matrix_p31_g), .matrix_p32(matrix_p32_g), .matrix_p33(matrix_p33_g)
    );

    matrix3x3 matrix3x3_b (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_b),  // Prepared Image input

        // Image data has been processd
        // .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        // .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_b), .matrix_p12(matrix_p12_b), .matrix_p13(matrix_p13_b),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_b), .matrix_p22(matrix_p22_b), .matrix_p23(matrix_p23_b),
        .matrix_p31(matrix_p31_b), .matrix_p32(matrix_p32_b), .matrix_p33(matrix_p33_b)
    );

    //--------------------------------------------------------------------------
    // 计算最终结果
    //  {1, 2, 1}
    //  {2, 4, 2}
    //  {1, 2, 1}
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            post_r <= 8'b0;
            post_g <= 8'b0;
            post_b <= 8'b0;
        end else if (pre_de) begin
            post_r <= (matrix_p11_r + matrix_p12_r + matrix_p13_r + matrix_p21_r + matrix_p22_r +
                       matrix_p23_r + matrix_p31_r + matrix_p32_r + matrix_p33_r) / 9;
            post_g <= (matrix_p11_g + matrix_p12_g + matrix_p13_g + matrix_p21_g + matrix_p22_g +
                       matrix_p23_g + matrix_p31_g + matrix_p32_g + matrix_p33_g) / 9;
            post_b <= (matrix_p11_b + matrix_p12_b + matrix_p13_b + matrix_p21_b + matrix_p22_b +
                       matrix_p23_b + matrix_p31_b + matrix_p32_b + matrix_p33_b) / 9;
        end
    end

    //---------------------------------------
    // lag 1 clocks signal sync
    reg pre_vs_r;
    reg pre_de_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pre_vs_r <= 0;
            pre_de_r <= 0;
        end else begin
            pre_vs_r <= matrix_vs;
            pre_de_r <= matrix_de;
        end
    end

    assign post_vs   = EN ? pre_vs_r : pre_vs;
    assign post_de   = EN ? pre_de_r : pre_de;
    assign post_data = EN ? {post_r, post_g, post_b} : pre_data;

endmodule


module median (
    // global clock
    input wire clk,   // cmos video pixel clock
    input wire rst_n, // global reset
    input wire EN,    // enable signal for image processing

    // Image data parameters
    input [10:0] IMG_HDISP,
    input [10:0] IMG_VDISP,

    // Image data prepred to be processd
    input wire        pre_vs,    // Prepared Image data vs valid signal
    input wire        pre_de,    // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data,  // Prepared Image input

    // Image data has been processd
    output wire        post_vs,  // Processed Image data vs valid signal
    output wire        post_de,  // Processed Image data output/capture enable clock
    output wire [23:0] post_data
);

    wire [7:0] pre_r = pre_data[23:16];  // Red channel
    wire [7:0] pre_g = pre_data[15:8];  // Green channel
    wire [7:0] pre_b = pre_data[7:0];  // Blue channel
    wire [7:0] post_r;  // Processed Red channel
    wire [7:0] post_g;  // Processed Green channel
    wire [7:0] post_b;  // Processed Blue channel

    //----------------------------------------------------
    // Generate 8Bit 3X3 Matrix for Video Image Processor.
    // Image data has been processed
    wire matrix_vs;  // Prepared Image data vs valid signal
    wire matrix_href;  // Prepared Image data href valid signal
    wire matrix_de;  // Prepared Image data output/capture enable clock

    // Define the 3x3 matrix for R, G, B channels
    wire [7:0] matrix_p11_r, matrix_p12_r, matrix_p13_r;
    wire [7:0] matrix_p21_r, matrix_p22_r, matrix_p23_r;
    wire [7:0] matrix_p31_r, matrix_p32_r, matrix_p33_r;

    wire [7:0] matrix_p11_g, matrix_p12_g, matrix_p13_g;
    wire [7:0] matrix_p21_g, matrix_p22_g, matrix_p23_g;
    wire [7:0] matrix_p31_g, matrix_p32_g, matrix_p33_g;

    wire [7:0] matrix_p11_b, matrix_p12_b, matrix_p13_b;
    wire [7:0] matrix_p21_b, matrix_p22_b, matrix_p23_b;
    wire [7:0] matrix_p31_b, matrix_p32_b, matrix_p33_b;

    // Instantiate 3x3 matrix generator for each channel
    matrix3x3 matrix3x3_r (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_r),  // Prepared Image input

        // Image data has been processd
        .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_r), .matrix_p12(matrix_p12_r), .matrix_p13(matrix_p13_r),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_r), .matrix_p22(matrix_p22_r), .matrix_p23(matrix_p23_r),
        .matrix_p31(matrix_p31_r), .matrix_p32(matrix_p32_r), .matrix_p33(matrix_p33_r)
    );
    // Median filter for each channel
    Matrix3x3Median Matrix3x3Median_r (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data prepred to be processd
        .pre_de (matrix_de),  // Prepared Image data output/capture enable clock

        // Image data has been processd
        .matrix_p11(matrix_p11_r), .matrix_p12(matrix_p12_r), .matrix_p13(matrix_p13_r),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_r), .matrix_p22(matrix_p22_r), .matrix_p23(matrix_p23_r),
        .matrix_p31(matrix_p31_r), .matrix_p32(matrix_p32_r), .matrix_p33(matrix_p33_r),

        // Median filter output
        .post_data(post_r)  // Processed Image output
    );

    matrix3x3 matrix3x3_g (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_g),  // Prepared Image input

        // Image data has been processd
        // .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        // .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_g), .matrix_p12(matrix_p12_g), .matrix_p13(matrix_p13_g),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_g), .matrix_p22(matrix_p22_g), .matrix_p23(matrix_p23_g),
        .matrix_p31(matrix_p31_g), .matrix_p32(matrix_p32_g), .matrix_p33(matrix_p33_g)
    );
    Matrix3x3Median Matrix3x3Median_g (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data prepred to be processd
        .pre_de (matrix_de),  // Prepared Image data output/capture enable clock

        // Image data has been processd
        .matrix_p11(matrix_p11_g), .matrix_p12(matrix_p12_g), .matrix_p13(matrix_p13_g),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_g), .matrix_p22(matrix_p22_g), .matrix_p23(matrix_p23_g),
        .matrix_p31(matrix_p31_g), .matrix_p32(matrix_p32_g), .matrix_p33(matrix_p33_g),

        // Median filter output
        .post_data(post_g)  // Processed Image output
    );

    matrix3x3 matrix3x3_b (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data parameters
        .IMG_HDISP(IMG_HDISP),
        .IMG_VDISP(IMG_VDISP),

        // Image data prepred to be processd
        .pre_vs  (pre_vs),  // Prepared Image data vs valid signal
        .pre_de  (pre_de),  // Prepared Image data output/capture enable clock
        .pre_data(pre_b),  // Prepared Image input

        // Image data has been processd
        // .matrix_vs(matrix_vs),  // Processed Image data vs valid signal
        // .matrix_de(matrix_de),  // Processed Image data output/capture enable clock
        .matrix_p11(matrix_p11_b), .matrix_p12(matrix_p12_b), .matrix_p13(matrix_p13_b),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_b), .matrix_p22(matrix_p22_b), .matrix_p23(matrix_p23_b),
        .matrix_p31(matrix_p31_b), .matrix_p32(matrix_p32_b), .matrix_p33(matrix_p33_b)
    );
    Matrix3x3Median Matrix3x3Median_b (
        // global clock
        .clk  (clk),    // cmos video pixel clock
        .rst_n(rst_n),  // global reset

        // Image data prepred to be processd
        .pre_de (matrix_de),  // Prepared Image data output/capture enable clock

        // Image data has been processd
        .matrix_p11(matrix_p11_b), .matrix_p12(matrix_p12_b), .matrix_p13(matrix_p13_b),  // 3X3 Matrix output
        .matrix_p21(matrix_p21_b), .matrix_p22(matrix_p22_b), .matrix_p23(matrix_p23_b),
        .matrix_p31(matrix_p31_b), .matrix_p32(matrix_p32_b), .matrix_p33(matrix_p33_b),

        // Median filter output
        .post_data(post_b)  // Processed Image output
    );

    //---------------------------------------
    // lag 4 clocks signal sync  
    reg [3:0] pre_vs_r;
    reg [3:0] pre_de_r;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pre_vs_r <= 0;
            pre_de_r <= 0;
        end else begin
            pre_vs_r <= {pre_vs_r[2:0], matrix_vs};
            pre_de_r <= {pre_de_r[2:0], matrix_de};
        end
    end

    assign post_vs   = EN ? pre_vs_r : pre_vs;
    assign post_de   = EN ? pre_de_r : pre_de;
    assign post_data = EN ? {post_r, post_g, post_b} : pre_data;

endmodule


module Matrix3x3Median(
    input       clk,
    input       rst_n,
    input       pre_de,
    input [7:0] matrix_p11, matrix_p12, matrix_p13,
    input [7:0] matrix_p21, matrix_p22, matrix_p23,
    input [7:0] matrix_p31, matrix_p32, matrix_p33,
    output reg [7:0] post_data
);

	reg	[7:0] matrix_p1_max, matrix_p1_mid, matrix_p1_min;
    reg	[7:0] matrix_p2_max, matrix_p2_mid, matrix_p2_min;
    reg	[7:0] matrix_p3_max, matrix_p3_mid, matrix_p3_min;	
	reg	[7:0] max_min, mid_mid, min_max;	

    // step1  分别求出 3 行中同一行的最大值、 最小值、 中间值
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            matrix_p1_max <= 8'b0;
            matrix_p1_mid <= 8'b0;
            matrix_p1_min <= 8'b0;
        end else if (pre_de) begin
            if(matrix_p11 >= matrix_p12 && matrix_p11 >= matrix_p13 && matrix_p12 >= matrix_p13) begin  // 1>=2>=3
                matrix_p1_max <= matrix_p11;
                matrix_p1_mid <= matrix_p12;
                matrix_p1_min <= matrix_p13;
            end
            else if(matrix_p11 >= matrix_p12 && matrix_p11 >= matrix_p13 && matrix_p12 <= matrix_p13) begin  // 1>3>2
                matrix_p1_max <= matrix_p11;
                matrix_p1_mid <= matrix_p13;
                matrix_p1_min <= matrix_p12;
            end
            else if(matrix_p11 <= matrix_p12 && matrix_p11 >= matrix_p13 && matrix_p12 >= matrix_p13) begin  // 2>1>3
                matrix_p1_max <= matrix_p12;
                matrix_p1_mid <= matrix_p11;
                matrix_p1_min <= matrix_p13;
            end
            else if(matrix_p11 <= matrix_p12 && matrix_p11 <= matrix_p13 && matrix_p12 >= matrix_p13) begin  // 2>3>1
                matrix_p1_max <= matrix_p12;
                matrix_p1_mid <= matrix_p13;
                matrix_p1_min <= matrix_p11;
            end
            else if(matrix_p11 >= matrix_p12 && matrix_p11 <= matrix_p13 && matrix_p12 <= matrix_p13) begin  // 3>1>2
                matrix_p1_max <= matrix_p13;
                matrix_p1_mid <= matrix_p11;
                matrix_p1_min <= matrix_p12;
            end
            else if(matrix_p11 <= matrix_p12 && matrix_p11 <= matrix_p13 && matrix_p12 <= matrix_p13) begin  // 3>2>1
                matrix_p1_max <= matrix_p13;
                matrix_p1_mid <= matrix_p12;
                matrix_p1_min <= matrix_p11;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            matrix_p2_max <= 8'b0;
            matrix_p2_mid <= 8'b0;
            matrix_p2_min <= 8'b0;
        end else if (pre_de) begin
            if(matrix_p21 >= matrix_p22 && matrix_p21 >= matrix_p23 && matrix_p22 >= matrix_p23) begin  // 1>=2>=3
                matrix_p2_max <= matrix_p21;
                matrix_p2_mid <= matrix_p22;
                matrix_p2_min <= matrix_p23;
            end
            else if(matrix_p21 >= matrix_p22 && matrix_p21 >= matrix_p23 && matrix_p22 <= matrix_p23) begin  // 1>3>2
                matrix_p2_max <= matrix_p21;
                matrix_p2_mid <= matrix_p23;
                matrix_p2_min <= matrix_p22;
            end
            else if(matrix_p21 <= matrix_p22 && matrix_p21 >= matrix_p23 && matrix_p22 >= matrix_p23) begin  // 2>1>3
                matrix_p2_max <= matrix_p22;
                matrix_p2_mid <= matrix_p21;
                matrix_p2_min <= matrix_p23;
            end
            else if(matrix_p21 <= matrix_p22 && matrix_p21 <= matrix_p23 && matrix_p22 >= matrix_p23) begin  // 2>3>1
                matrix_p2_max <= matrix_p22;
                matrix_p2_mid <= matrix_p23;
                matrix_p2_min <= matrix_p21;
            end
            else if(matrix_p21 >= matrix_p22 && matrix_p21 <= matrix_p23 && matrix_p22 <= matrix_p23) begin  // 3>1>2
                matrix_p2_max <= matrix_p23;
                matrix_p2_mid <= matrix_p21;
                matrix_p2_min <= matrix_p22;
            end
            else if(matrix_p21 <= matrix_p22 && matrix_p21 <= matrix_p23 && matrix_p22 <= matrix_p23) begin  // 3>2>1
                matrix_p2_max <= matrix_p23;
                matrix_p2_mid <= matrix_p22;
                matrix_p2_min <= matrix_p21;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            matrix_p3_max <= 8'b0;
            matrix_p3_mid <= 8'b0;
            matrix_p3_min <= 8'b0;
        end else if (pre_de) begin
            if(matrix_p31 >= matrix_p32 && matrix_p31 >= matrix_p33 && matrix_p32 >= matrix_p33) begin  // 1>=2>=3
                matrix_p3_max <= matrix_p31;
                matrix_p3_mid <= matrix_p32;
                matrix_p3_min <= matrix_p33;
            end
            else if(matrix_p31 >= matrix_p32 && matrix_p31 >= matrix_p33 && matrix_p32 <= matrix_p33) begin  // 1>3>2
                matrix_p3_max <= matrix_p31;
                matrix_p3_mid <= matrix_p33;
                matrix_p3_min <= matrix_p32;
            end
            else if(matrix_p31 <= matrix_p32 && matrix_p31 >= matrix_p33 && matrix_p32 >= matrix_p33) begin  // 2>1>3
                matrix_p3_max <= matrix_p32;
                matrix_p3_mid <= matrix_p31;
                matrix_p3_min <= matrix_p33;
            end
            else if(matrix_p31 <= matrix_p32 && matrix_p31 <= matrix_p33 && matrix_p32 >= matrix_p33) begin  // 2>3>1
                matrix_p3_max <= matrix_p32;
                matrix_p3_mid <= matrix_p33;
                matrix_p3_min <= matrix_p31;
            end
            else if(matrix_p31 >= matrix_p32 && matrix_p31 <= matrix_p33 && matrix_p32 <= matrix_p33) begin  // 3>1>2
                matrix_p3_max <= matrix_p33;
                matrix_p3_mid <= matrix_p31;
                matrix_p3_min <= matrix_p32;
            end
            else if(matrix_p31 <= matrix_p32 && matrix_p31 <= matrix_p33 && matrix_p32 <= matrix_p33) begin  // 3>2>1
                matrix_p3_max <= matrix_p33;
                matrix_p3_mid <= matrix_p32;
                matrix_p3_min <= matrix_p31;
            end
        end
    end

    // step2  3 行的最大值、 最小值、 中间值进行比较
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) max_min <= 8'b0;
        else if (pre_de) begin
            if(matrix_p1_max >= matrix_p2_max && matrix_p1_max >= matrix_p3_max && matrix_p2_max >= matrix_p3_max)  // 1>=2>=3
                max_min <= matrix_p3_max;
            else if(matrix_p1_max >= matrix_p2_max && matrix_p1_max >= matrix_p3_max && matrix_p2_max <= matrix_p3_max)  // 1>3>2
                max_min <= matrix_p2_max;
            else if(matrix_p1_max <= matrix_p2_max && matrix_p1_max >= matrix_p3_max && matrix_p2_max >= matrix_p3_max)  // 2>1>3
                max_min <= matrix_p3_max;
            else if(matrix_p1_max <= matrix_p2_max && matrix_p1_max <= matrix_p3_max && matrix_p2_max >= matrix_p3_max)  // 2>3>1
                max_min <= matrix_p1_max;
            else if(matrix_p1_max >= matrix_p2_max && matrix_p1_max <= matrix_p3_max && matrix_p2_max <= matrix_p3_max)  // 3>1>2
                max_min <= matrix_p2_max;
            else if(matrix_p1_max <= matrix_p2_max && matrix_p1_max <= matrix_p3_max && matrix_p2_max <= matrix_p3_max)  // 3>2>1
                max_min <= matrix_p1_max;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) mid_mid <= 8'b0;
        else if (pre_de) begin
            if(matrix_p1_mid >= matrix_p2_mid && matrix_p1_mid >= matrix_p3_mid && matrix_p2_mid >= matrix_p3_mid)  // 1>=2>=3
                mid_mid <= matrix_p2_mid;
            else if(matrix_p1_mid >= matrix_p2_mid && matrix_p1_mid >= matrix_p3_mid && matrix_p2_mid <= matrix_p3_mid)  // 1>3>2
                mid_mid <= matrix_p3_mid;
            else if(matrix_p1_mid <= matrix_p2_mid && matrix_p1_mid >= matrix_p3_mid && matrix_p2_mid >= matrix_p3_mid)  // 2>1>3
                mid_mid <= matrix_p1_mid;
            else if(matrix_p1_mid <= matrix_p2_mid && matrix_p1_mid <= matrix_p3_mid && matrix_p2_mid >= matrix_p3_mid)  // 2>3>1
                mid_mid <= matrix_p3_mid;
            else if(matrix_p1_mid >= matrix_p2_mid && matrix_p1_mid <= matrix_p3_mid && matrix_p2_mid <= matrix_p3_mid)  // 3>1>2
                mid_mid <= matrix_p1_mid;
            else if(matrix_p1_mid <= matrix_p2_mid && matrix_p1_mid <= matrix_p3_mid && matrix_p2_mid <= matrix_p3_mid)  // 3>2>1
                mid_mid <= matrix_p2_mid;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) min_max <= 8'b0;
        else if (pre_de) begin
            if(matrix_p1_min >= matrix_p2_min && matrix_p1_min >= matrix_p3_min && matrix_p2_min >= matrix_p3_min)  // 1>=2>=3
                min_max <= matrix_p1_min;
            else if(matrix_p1_min >= matrix_p2_min && matrix_p1_min >= matrix_p3_min && matrix_p2_min <= matrix_p3_min)  // 1>3>2
                min_max <= matrix_p1_min;
            else if(matrix_p1_min <= matrix_p2_min && matrix_p1_min >= matrix_p3_min && matrix_p2_min >= matrix_p3_min)  // 2>1>3
                min_max <= matrix_p2_min;
            else if(matrix_p1_min <= matrix_p2_min && matrix_p1_min <= matrix_p3_min && matrix_p2_min >= matrix_p3_min)  // 2>3>1
                min_max <= matrix_p2_min;
            else if(matrix_p1_min >= matrix_p2_min && matrix_p1_min <= matrix_p3_min && matrix_p2_min <= matrix_p3_min)  // 3>1>2
                min_max <= matrix_p3_min;
            else if(matrix_p1_min <= matrix_p2_min && matrix_p1_min <= matrix_p3_min && matrix_p2_min <= matrix_p3_min)  // 3>2>1
                min_max <= matrix_p3_min;
        end
    end

    // step3 得到 3x3 矩阵的中间值
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) post_data <= 8'b0;
        else if (pre_de) begin
            if (max_min >= mid_mid && max_min >= min_max && mid_mid >= min_max)  // 1>=2>=3
                post_data <= mid_mid;
            else if(max_min >= mid_mid && max_min >= min_max && mid_mid <= min_max)  // 1>3>2
                post_data <= min_max;
            else if(max_min <= mid_mid && max_min >= min_max && mid_mid >= min_max)  // 2>1>3
                post_data <= max_min;
            else if(max_min <= mid_mid && max_min <= min_max && mid_mid >= min_max)  // 2>3>1
                post_data <= min_max;
            else if(max_min >= mid_mid && max_min <= min_max && mid_mid <= min_max)  // 3>1>2
                post_data <= max_min;
            else if(max_min <= mid_mid && max_min <= min_max && mid_mid <= min_max)  // 3>2>1
                post_data <= mid_mid;
        end
    end

endmodule


module matrix3x3 (
    // global clock
    input wire clk,   // cmos video pixel clock
    input wire rst_n, // global reset

    // Image data parameters
    input [10:0] IMG_HDISP,
    input [10:0] IMG_VDISP,

    // Image data prepred to be processd
    input wire       pre_vs,   // Prepared Image data vs valid signal
    input wire       pre_de,   // Prepared Image data output/capture enable clock
    input wire [7:0] pre_data, // Prepared Image input

    // Image data has been processd
    output wire       matrix_vs,  // Prepared Image data vs valid signal
    output wire       matrix_de,  // Prepared Image data output/capture enable clock
    output  reg [7:0] matrix_p11, matrix_p12, matrix_p13,  // 3X3 Matrix output
    output  reg [7:0] matrix_p21, matrix_p22, matrix_p23,
    output  reg [7:0] matrix_p31, matrix_p32, matrix_p33
);

    // Generate 3*3 matrix
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // sync row3_data with pre_de & row1_data & raw2_data
    wire [7:0] row1_data;  // frame data of the 1th row
    wire [7:0] row2_data;  // frame data of the 2th row
    reg  [7:0] row3_data;  // frame data of the 3th row
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) row3_data <= 0;
        else begin
            if (pre_de) row3_data <= pre_data;
            else row3_data <= row3_data;
        end
    end

    //---------------------------------------
    // module of shift ram for raw data
    wire shift_en = pre_de;
    line_shift_ram #(
        .DATA_WIDTH (8)
    ) line_shift_ram0 (
        .clk  (clk),        // input wire CLK
        .rst_n(rst_n),      // input wire RST_N
        .LINE_LENGTH(IMG_HDISP),
        .CE   (shift_en),   // input wire CE
        .D    (row3_data),  // input wire [7:0] D
        .Q    (row2_data)   // output wire [7:0] Q
    );
    line_shift_ram #(
        .DATA_WIDTH (8)
    ) line_shift_ram1 (
        .clk  (clk),        // input wire CLK
        .rst_n(rst_n),      // input wire RST_N
        .LINE_LENGTH(IMG_HDISP),
        .CE   (shift_en),   // input wire CE
        .D    (row2_data),  // input wire [7:0] D
        .Q    (row1_data)   // output wire [7:0] Q
    );

    //------------------------------------------
    // lag 2 clocks signal sync
    reg [1:0] pre_vs_r;
    reg [1:0] pre_de_r;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pre_vs_r <= 0;
            pre_de_r <= 0;
        end else begin
            pre_vs_r <= {pre_vs_r[0], pre_vs};
            pre_de_r <= {pre_de_r[0], pre_de};
        end
    end
    // Give up the 1th and 2th row edge data caculate for simple process
    // Give up the 1th and 2th point of 1 line for simple process
    wire read_de = pre_de_r[0];  // RAM read enable
    assign matrix_vs = pre_vs_r[1];
    assign matrix_de = pre_de_r[1];

    //----------------------------------------------------------------------------
    //----------------------------------------------------------------------------
    /******************************************************************************
                    ----------  Convert Matrix  ----------
                [ P31 -> P32 -> P33 -> ] ---> [ P11 P12 P13 ]
                [ P21 -> P22 -> P23 -> ] ---> [ P21 P22 P23 ]
                [ P11 -> P12 -> P11 -> ] ---> [ P31 P32 P33 ]
    ******************************************************************************/
    //---------------------------------------------------------------------------
    //---------------------------------------------------------------------------
    /***********************************************
        (1)	Read data from Shift_RAM
        (2) Caculate the Sobel
        (3) Steady data after Sobel generate
    ************************************************/
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            {matrix_p11, matrix_p12, matrix_p13} <= 24'h0;
            {matrix_p21, matrix_p22, matrix_p23} <= 24'h0;
            {matrix_p31, matrix_p32, matrix_p33} <= 24'h0;
        end else begin
            if (read_de) begin  // Shift_RAM data read clock enable
                {matrix_p11, matrix_p12, matrix_p13} <= {matrix_p12, matrix_p13, row1_data};  // 1th shift input
                {matrix_p21, matrix_p22, matrix_p23} <= {matrix_p22, matrix_p23, row2_data};  // 2th shift input
                {matrix_p31, matrix_p32, matrix_p33} <= {matrix_p32, matrix_p33, row3_data};  // 3th shift input
            end else begin
                {matrix_p11, matrix_p12, matrix_p13} <= {matrix_p11, matrix_p12, matrix_p13};
                {matrix_p21, matrix_p22, matrix_p23} <= {matrix_p21, matrix_p22, matrix_p23};
                {matrix_p31, matrix_p32, matrix_p33} <= {matrix_p31, matrix_p32, matrix_p33};
            end
        end
    end

endmodule


module line_shift_ram #(
    parameter DATA_WIDTH = 8  // 数据宽度，默认为8位
) (
    input  wire                  clk,          // 时钟信号
    input  wire                  rst_n,        // 复位信号
    input  wire [          10:0] LINE_LENGTH,  // 行长度
    input  wire                  CE,           // 使能信号
    input  wire [DATA_WIDTH-1:0] D,            // 输入数据
    output reg  [DATA_WIDTH-1:0] Q             // 输出数据
);

    // 内部存储器，存储一整行像素数据
    reg [DATA_WIDTH-1:0] line_ram[12'd1280-1:0];
    integer i;
    initial begin
        for (i = 0; i < LINE_LENGTH; i = i + 1)
            line_ram[i] = {DATA_WIDTH{1'b0}};  // 将所有位设置为0
    end

    // 读写指针，用来指示当前操作的地址
    reg [$clog2(12'd1280)-1:0] wr_ptr = 0;
    reg [$clog2(12'd1280)-1:0] rd_ptr = 0;  // 开始时，读指针与写指针相同

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位时，读写指针都置为0
            wr_ptr <= 0;
            rd_ptr <= 0;
            Q <= 0;  // 输出数据复位
        end else if (CE) begin
            // 写入新数据到当前写指针指向的位置
            line_ram[wr_ptr] <= D;
            // 更新写指针
            wr_ptr <= (wr_ptr + 1) % LINE_LENGTH;
            // 读取当前读指针指向的数据
            Q <= line_ram[rd_ptr];
            // 更新读指针
            rd_ptr <= (rd_ptr + 1) % LINE_LENGTH;
        end
    end

endmodule
