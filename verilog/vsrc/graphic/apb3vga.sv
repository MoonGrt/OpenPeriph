module Apb3Vga (
  input  logic        pclk,
  input  logic        presetn,
  input  logic        psel,
  input  logic        penable,
  input  logic        pwrite,
  input  logic [7:0]  paddr,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready,
  output logic        pslverr,
  output logic        hsync,
  output logic        vsync,
  output logic        de,
  output logic [23:0] rgb
);
  logic enable;
  logic [1:0] pattern;
  logic hsync_positive;
  logic vsync_positive;
  logic data_enable_invert;
  logic [15:0] hsync_width;
  logic [15:0] hback_porch;
  logic [15:0] hdisplay;
  logic [15:0] htotal;
  logic [15:0] vsync_width;
  logic [15:0] vback_porch;
  logic [15:0] vdisplay;
  logic [15:0] vtotal;
  logic [23:0] solid_color;
  logic [15:0] x;
  logic [15:0] y;
  logic pixel_ready;
  logic [23:0] pattern_data;
  logic [2:0] color_index;
  logic [31:0] scaled_x;
  wire access = psel && penable;

  assign pready = 1'b1;
  assign pslverr = 1'b0;
  assign scaled_x = hdisplay == 0 ? 0 :
                    ({16'b0, x} * 32'd8) / {16'b0, hdisplay};
  assign color_index = scaled_x[2:0];

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      enable <= 1'b0;
      pattern <= 0;
      hsync_positive <= 1'b0;
      vsync_positive <= 1'b0;
      data_enable_invert <= 1'b0;
      hsync_width <= 16'd96;
      hback_porch <= 16'd48;
      hdisplay <= 16'd640;
      htotal <= 16'd800;
      vsync_width <= 16'd2;
      vback_porch <= 16'd33;
      vdisplay <= 16'd480;
      vtotal <= 16'd525;
      solid_color <= 24'hffffff;
    end else if (access && pwrite) begin
      case (paddr)
        8'h00: begin
          enable <= pwdata[0];
          pattern <= pwdata[2:1];
          hsync_positive <= pwdata[4];
          vsync_positive <= pwdata[5];
          data_enable_invert <= pwdata[6];
        end
        8'h04: begin hsync_width <= pwdata[15:0]; hback_porch <= pwdata[31:16]; end
        8'h08: begin hdisplay <= pwdata[15:0]; htotal <= pwdata[31:16]; end
        8'h0c: begin vsync_width <= pwdata[15:0]; vback_porch <= pwdata[31:16]; end
        8'h10: begin vdisplay <= pwdata[15:0]; vtotal <= pwdata[31:16]; end
        8'h14: solid_color <= pwdata[23:0];
        default: ;
      endcase
    end
  end

  always_comb begin
    case (pattern)
      2'd0: begin
        case (color_index)
          3'd0: pattern_data = 24'hffffff;
          3'd1: pattern_data = 24'hffff00;
          3'd2: pattern_data = 24'h00ffff;
          3'd3: pattern_data = 24'h00ff00;
          3'd4: pattern_data = 24'hff00ff;
          3'd5: pattern_data = 24'hff0000;
          3'd6: pattern_data = 24'h0000ff;
          default: pattern_data = 24'h000000;
        endcase
      end
      2'd1: pattern_data = {3{x[7:0]}};
      2'd2: pattern_data = (x[4:0] == 0 || y[4:0] == 0) ? 24'hffffff : 24'h000000;
      default: pattern_data = solid_color;
    endcase
  end

  always_comb begin
    case (paddr)
      8'h00: prdata = {25'b0, data_enable_invert, vsync_positive,
                      hsync_positive, 1'b0, pattern, enable};
      8'h04: prdata = {hback_porch, hsync_width};
      8'h08: prdata = {htotal, hdisplay};
      8'h0c: prdata = {vback_porch, vsync_width};
      8'h10: prdata = {vtotal, vdisplay};
      8'h14: prdata = {8'b0, solid_color};
      8'h18: prdata = {y, x};
      default: prdata = 0;
    endcase
  end

  Dvt #(.DATA_WIDTH(24), .TIMING_WIDTH(16)) timing (
    .pixel_clk(pclk),
    .presetn(presetn),
    .enable(enable),
    .hsync_width(hsync_width),
    .hback_porch(hback_porch),
    .hdisplay(hdisplay),
    .htotal(htotal),
    .vsync_width(vsync_width),
    .vback_porch(vback_porch),
    .vdisplay(vdisplay),
    .vtotal(vtotal),
    .hsync_positive(hsync_positive),
    .vsync_positive(vsync_positive),
    .data_enable_invert(data_enable_invert),
    .pixel_data(pattern_data),
    .pixel_valid(1'b1),
    .pixel_ready(pixel_ready),
    .x(x),
    .y(y),
    .hsync(hsync),
    .vsync(vsync),
    .de(de),
    .data(rgb)
  );
endmodule
