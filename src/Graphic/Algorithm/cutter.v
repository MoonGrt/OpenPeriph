module cutter #(
    parameter H_DISP             = 12'd1280,  // Horizontal resolution
    parameter V_DISP             = 12'd720,   // Vertical resolution
    parameter INPUT_X_RES_WIDTH  = 11,        // Widths of input resolution control signals
    parameter INPUT_Y_RES_WIDTH  = 11,        // Widths of input resolution control signals
    parameter OUTPUT_X_RES_WIDTH = 11,        // Widths of output resolution control signals
    parameter OUTPUT_Y_RES_WIDTH = 11         // Widths of output resolution control signals
) (
    // global clock
    input wire       clk,    // cmos video pixel clock
    input wire       rst_n,  // global reset
    input wire       EN,     // enable
    input wire [1:0] mode,   // mode selection

    input wire [ INPUT_X_RES_WIDTH-1:0] START_X,  // start x-coordinate of cropping region
    input wire [ INPUT_Y_RES_WIDTH-1:0] START_Y,  // start y-coordinate of cropping region
    input wire [OUTPUT_X_RES_WIDTH-1:0] END_X,    // end x-coordinate of cropping region
    input wire [OUTPUT_Y_RES_WIDTH-1:0] END_Y,    // end y-coordinate of cropping region

    // Image data prepared to be processed
    input wire        pre_vs,   // Prepared Image data vs valid signal
    input wire        pre_de,   // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data, // Prepared Image data (24-bit color)

    // Image data after being processed
    output reg        post_vs,   // Processed Image data vs valid signal
    output reg        post_de,   // Processed Image data output/capture enable clock
    output reg [23:0] post_data  // Processed Image data (24-bit color)
);

    // Internal variables to track the current position
    reg [INPUT_X_RES_WIDTH-1:0] h_cnt;  // Horizontal position counter
    reg [INPUT_Y_RES_WIDTH-1:0] v_cnt;  // Vertical position counter
    // Control signals for output valid region
    wire in_cut_region = (h_cnt >= START_X) && (h_cnt < END_X) && (v_cnt >= START_Y) && (v_cnt < END_Y);

    // Horizontal and vertical counters
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n | pre_vs) begin
            h_cnt <= 0;
            v_cnt <= 0;
        end else if (pre_de) begin
            if (h_cnt < H_DISP - 1) h_cnt <= h_cnt + 1;
            else begin
                h_cnt <= 0;
                if (v_cnt < V_DISP - 1) v_cnt <= v_cnt + 1;
                else v_cnt <= 0;
            end
        end
    end

    // Output assignment based on the cropping region
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            post_vs   <= 1'b0;
            post_de   <= 1'b0;
            post_data <= 1'b0;
        end else begin
            post_vs <= pre_vs;
            if (EN) begin
                if (in_cut_region && pre_de) begin
                    post_de   <= 1'b1;
                    post_data <= pre_data;  // Pass through the data within the cut region
                end else begin
                    post_de   <= 1'b0;
                    post_data <= 24'h000000;  // Output black data outside cut region
                end
            end else begin
                post_de   <= pre_de;
                post_data <= pre_data;
            end
        end
    end

endmodule
