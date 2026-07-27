module Dvt #(
  parameter int DATA_WIDTH = 24,
  parameter int TIMING_WIDTH = 16
) (
  input  logic                    pixel_clk,
  input  logic                    presetn,
  input  logic                    enable,
  input  logic [TIMING_WIDTH-1:0] hsync_width,
  input  logic [TIMING_WIDTH-1:0] hback_porch,
  input  logic [TIMING_WIDTH-1:0] hdisplay,
  input  logic [TIMING_WIDTH-1:0] htotal,
  input  logic [TIMING_WIDTH-1:0] vsync_width,
  input  logic [TIMING_WIDTH-1:0] vback_porch,
  input  logic [TIMING_WIDTH-1:0] vdisplay,
  input  logic [TIMING_WIDTH-1:0] vtotal,
  input  logic                    hsync_positive,
  input  logic                    vsync_positive,
  input  logic                    data_enable_invert,
  input  logic [DATA_WIDTH-1:0]   pixel_data,
  input  logic                    pixel_valid,
  output logic                    pixel_ready,
  output logic [TIMING_WIDTH-1:0] x,
  output logic [TIMING_WIDTH-1:0] y,
  output logic                    hsync,
  output logic                    vsync,
  output logic                    de,
  output logic [DATA_WIDTH-1:0]   data
);
  logic [TIMING_WIDTH-1:0] horizontal;
  logic [TIMING_WIDTH-1:0] vertical;
  logic horizontal_active;
  logic vertical_active;
  logic hsync_active;
  logic vsync_active;

  always_ff @(posedge pixel_clk or negedge presetn) begin
    if (!presetn || !enable) begin
      horizontal <= 0;
      vertical <= 0;
    end else if (horizontal >= htotal - 1'b1) begin
      horizontal <= 0;
      vertical <= vertical >= vtotal - 1'b1 ? 0 : vertical + 1'b1;
    end else begin
      horizontal <= horizontal + 1'b1;
    end
  end

  always_comb begin
    hsync_active = enable && horizontal < hsync_width;
    vsync_active = enable && vertical < vsync_width;
    horizontal_active = horizontal >= hsync_width + hback_porch &&
                        horizontal < hsync_width + hback_porch + hdisplay;
    vertical_active = vertical >= vsync_width + vback_porch &&
                      vertical < vsync_width + vback_porch + vdisplay;
    x = horizontal - hsync_width - hback_porch;
    y = vertical - vsync_width - vback_porch;
    pixel_ready = enable && horizontal_active && vertical_active;
    hsync = hsync_active ? hsync_positive : !hsync_positive;
    vsync = vsync_active ? vsync_positive : !vsync_positive;
    de = (pixel_ready && pixel_valid) ^ data_enable_invert;
    data = pixel_ready && pixel_valid ? pixel_data : 0;
  end
endmodule
