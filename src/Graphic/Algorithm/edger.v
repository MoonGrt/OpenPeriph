module edger (
    // global clock
    input wire       clk,   // cmos video pixel clock
    input wire       rst_n, // global reset
    input wire       EN,    // enable signal for edge detector
    input wire [1:0] mode,  // edge detect mode(0: Sobel, 1: Prewitt)

    // Image data parameters
    input [10:0] IMG_HDISP,
    input [10:0] IMG_VDISP,

    input wire [7:0] threshold,  // Sobel Threshold for image edge detect

    // Image data prepred to be processd
    input wire       pre_vs,  // Prepared Image data vs valid signal
    input wire       pre_de,  // Prepared Image data output/capture enable clock
    input wire [7:0] pre_data,  // Prepared Image input

    // Image data has been processd
    output wire post_vs,  // Processed Image data vs valid signal
    output wire post_de,  // Processed Image data output/capture enable clock
    output wire post_bit  // Processed Image Bit flag outout(1: Value, 0:inValid)
);

    //----------------------------------------------------
    // Generate 8Bit 3X3 Matrix for Video Image Processor.
    // Image data has been processd
    wire matrix_vs;  // Prepared Image data vs valid signal
    wire matrix_de;  // Prepared Image data output/capture enable clock	
    wire [7:0] matrix_p11, matrix_p12, matrix_p13;  // 3X3 Matrix output
    wire [7:0] matrix_p21, matrix_p22, matrix_p23;
    wire [7:0] matrix_p31, matrix_p32, matrix_p33;
    matrix3x3 matrix3x3 (
        .clk        (clk),
        .rst_n      (rst_n),
        .IMG_HDISP  (IMG_HDISP),
        .IMG_VDISP  (IMG_VDISP),
        .pre_vs     (pre_vs),
        .pre_de     (pre_de),
        .pre_data   (pre_data),
        .matrix_vs  (matrix_vs),
        .matrix_de  (matrix_de),
        .matrix_p11 (matrix_p11), .matrix_p12(matrix_p12), .matrix_p13(matrix_p13),
        .matrix_p21 (matrix_p21), .matrix_p22(matrix_p22), .matrix_p23(matrix_p23),
        .matrix_p31 (matrix_p31), .matrix_p32(matrix_p32), .matrix_p33(matrix_p33)
    );

    //------------------------------------------------------
    //                   Sobel Parameter
    //        Gx                Gy				Pixel
    //  [ -1   0   +1 ]   [ +1  +2  +1 ]   [ P11  P12  P13 ]
    //  [ -2   0   +2 ]   [  0   0   0 ]   [ P21  P22  P23 ]
    //  [ -1   0   +1 ]   [ -1  -2  -1 ]   [ P31  P32  P33 ]

    //                   Prewitt Parameter
    //        Gx                Gy				Pixel
    //  [ -1   0   +1 ]   [ +1  +1  +1 ]   [ P11  P12  P13 ]
    //  [ -1   0   +2 ]   [  0   0   0 ]   [ P21  P22  P23 ]
    //  [ -1   0   +1 ]   [ -1  -1  -1 ]   [ P31  P32  P33 ]

    // Caculate horizontal Grade with |abs|
    reg [9:0] Gx_temp1;  // positive result
    reg [9:0] Gx_temp2;  // negetive result
    reg [9:0] Gx_data;  // Horizontal grade data
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            Gx_temp1 <= 0;
            Gx_temp2 <= 0;
            Gx_data  <= 0;
        end else begin
            Gx_temp1 <= matrix_p13 + (matrix_p23 << 1) + matrix_p33;  // positive result
            Gx_temp2 <= matrix_p11 + (matrix_p21 << 1) + matrix_p31;  // negetive result
            Gx_data  <= (Gx_temp1 >= Gx_temp2) ? Gx_temp1 - Gx_temp2 : Gx_temp2 - Gx_temp1;
        end
    end

    //---------------------------------------
    // Caculate vertical Grade with |abs|
    reg [9:0] Gy_temp1;  // positive result
    reg [9:0] Gy_temp2;  // negetive result
    reg [9:0] Gy_data;  // Vertical grade data
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            Gy_temp1 <= 0;
            Gy_temp2 <= 0;
            Gy_data  <= 0;
        end else begin
            Gy_temp1 <= matrix_p11 + (matrix_p12 << 1) + matrix_p13;  // positive result
            Gy_temp2 <= matrix_p31 + (matrix_p32 << 1) + matrix_p33;  // negetive result
            Gy_data  <= (Gy_temp1 >= Gy_temp2) ? Gy_temp1 - Gy_temp2 : Gy_temp2 - Gy_temp1;
        end
    end

    //---------------------------------------
    // Caculate the square of distance = (Gx^2 + Gy^2)
    reg [31:0] Gxy_square = 0;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n | pre_vs) Gxy_square <= 0;
        else Gxy_square <= Gx_data * Gx_data + Gy_data * Gy_data;
    end

    //---------------------------------------
    // Caculate the distance of P5 = (Gx^2 + Gy^2)^0.5
    reg post_bit_r;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n | pre_vs) post_bit_r <= 1'b0;  // Default None
        else if (Gxy_square >= threshold * threshold) post_bit_r <= 1'b1;  // Edge Flag
        else post_bit_r <= 1'b0;  // Not Edge
    end

    //------------------------------------------
    // lag 5 clocks signal sync  
    reg [4:0] pre_vs_r;
    reg [4:0] pre_de_r;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pre_vs_r <= 0;
            pre_de_r <= 0;
        end else begin
            pre_vs_r <= {pre_vs_r[3:0], matrix_vs};
            pre_de_r <= {pre_de_r[3:0], matrix_de};
        end
    end

    assign post_vs = pre_vs_r[4];
    assign post_de = pre_de_r[4];
    assign post_bit = post_bit_r;

endmodule
