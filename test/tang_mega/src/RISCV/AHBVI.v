module AHBVI (
    input wire       clk,        // system clock
    input wire       cmos_clk,   // cmos pixel clock
    input wire       video_clk,  // video clock
    input wire       rst_n,      // system reset
    input wire [1:0] mode,       // data select

    // cam interface
    output wire [2:0] i2c_sel,
    inout  wire       cmos_scl,    // cmos i2c clock
    inout  wire       cmos_sda,    // cmos i2c data
    input  wire       cmos_vsync,  // cmos vsync
    input  wire       cmos_href,   // cmos hsync refrence,data valid
    input  wire       cmos_pclk,   // cmos pxiel clock
    output wire       cmos_xclk,   // cmos externl clock
    input  wire [7:0] cmos_db,     // cmos data
    output wire       cmos_rst_n,  // cmos reset
    output wire       cmos_pwdn,   // cmos power down
    // HDMI IN
    input  wire        HDMI_clk,    // HDMI clock
    input  wire        HDMI_vs,     // HDMI vertical sync
    input  wire        HDMI_de,     // HDMI data enable
    input  wire [15:0] HDMI_data,   // HDMI data
    // output video interface
    output reg        vi_clk,
    output reg        vi_vs,
    output reg [15:0] vi_data,
    output reg        vi_de
);

    // I2C 输出选择逻辑
    localparam HDMI_SEL = 3'b011;
    localparam CMOS_SEL = 3'b101;
    assign i2c_sel = (mode == 2'b10) ? CMOS_SEL : HDMI_SEL;

    // 输入测试图
    wire       tp0_vs_in;
    wire       tp0_hs_in;
    wire       tp0_de_in;
    wire [7:0] tp0_data_r;
    wire [7:0] tp0_data_g;
    wire [7:0] tp0_data_b;
    testpattern testpattern (
        // .I_pxl_clk(video_clk),  // pixel clock
        .I_pxl_clk (cmos_clk),
        .I_rst_n   (rst_n),  // low active
        .I_mode    (3'b000),  // data select
        .I_single_r(8'd255),
        .I_single_g(8'd255),
        .I_single_b(8'd255),  
                                                   // 800x600   // 1024x768  // 1280x720  // 1920x1080
        .I_h_total (12'd1650),  // hor total time  // 12'd1056  // 12'd1344  // 12'd1650  // 12'd2200
        .I_h_sync  (12'd40),    // hor sync time   // 12'd128   // 12'd136   // 12'd40    // 12'd44
        .I_h_bporch(12'd220),   // hor back porch  // 12'd88    // 12'd160   // 12'd220   // 12'd148
        .I_h_res   (12'd1280),  // hor resolution  // 12'd800   // 12'd1024  // 12'd1280  // 12'd1920
        .I_v_total (12'd750),   // ver total time  // 12'd628   // 12'd806   // 12'd750   // 12'd1125
        .I_v_sync  (12'd5),     // ver sync time   // 12'd4     // 12'd6     // 12'd5     // 12'd5
        .I_v_bporch(12'd20),    // ver back porch  // 12'd23    // 12'd29    // 12'd20    // 12'd36
        .I_v_res   (12'd720),   // ver resolution  // 12'd600   // 12'd768   // 12'd720   // 12'd1080
        .I_hs_pol  (1'b1),  // 0,负极性;1,正极性
        .I_vs_pol  (1'b1),  // 0,负极性;1,正极性

        .O_de(tp0_de_in),
        .O_hs(tp0_hs_in),
        .O_vs(tp0_vs_in),
        .O_data_r(tp0_data_r),
        .O_data_g(tp0_data_g),
        .O_data_b(tp0_data_b)
    );

    // camera interface
    wire cmos_16bit_clk, cmos_16bit_wr;
    wire [15:0] write_data;
    CAM CAM (
        .clk     (clk),
        .cmos_clk(cmos_clk),
        .rst_n   (rst_n & (mode == 2'b10)),

        .cmos_scl  (cmos_scl),
        .cmos_sda  (cmos_sda),
        .cmos_vsync(cmos_vsync),
        .cmos_href (cmos_href),
        .cmos_pclk (cmos_pclk),
        .cmos_db   (cmos_db),
        .cmos_xclk (cmos_xclk),
        .cmos_rst_n(cmos_rst_n),
        .cmos_pwdn (cmos_pwdn),

        .write_data    (write_data),
        .cmos_16bit_wr (cmos_16bit_wr),
        .cmos_16bit_clk(cmos_16bit_clk)
    );

    always @(*) begin
        if(~rst_n) begin
            vi_clk  = 1'b0;
            vi_vs   = 1'b0;
            vi_data = 16'b0;
            vi_de   = 1'b0;
        end else begin
            case(mode)  // data select
                2'b01: begin  // test pattern
                    vi_clk  = cmos_clk;
                    vi_vs   = tp0_vs_in;
                    vi_de   = tp0_de_in;
                    vi_data = {tp0_data_r[7:3], tp0_data_g[7:2], tp0_data_b[7:3]};
                end
                2'b10: begin  // cmos data
                    vi_clk  = cmos_16bit_clk;
                    vi_vs   = cmos_vsync;
                    vi_de   = cmos_16bit_wr;
                    vi_data = write_data;
                end
                2'b11: begin  // HDMI data
                    vi_clk  = HDMI_clk;
                    vi_vs   = HDMI_vs;
                    vi_de   = HDMI_de;
                    vi_data = HDMI_data;
                end
                default: begin
                    vi_clk  = 1'b0;
                    vi_vs   = 1'b0;
                    vi_de   = 1'b0;
                    vi_data = 16'b0;
                end
            endcase
        end
    end

endmodule


// ---------------------------------------------------------------------
// File name         : testpattern.v
// Module name       : testpattern
// Module Description:
//						I_mode[2:0] = "000" : color bar
//						I_mode[2:0] = "001" : net grid
//						I_mode[2:0] = "010" : gray
//						I_mode[2:0] = "011" : single color
// ---------------------------------------------------------------------
// Release history
// VERSION |   Date      | AUTHOR  |    DESCRIPTION
// --------------------------------------------------------------------
//   1.0   | 24-Sep-2009 | Caojie  |    initial
// --------------------------------------------------------------------

module testpattern (
    input             I_pxl_clk,   // pixel clock
    input             I_rst_n,     // low active
    input      [ 2:0] I_mode,      // data select
    input      [ 7:0] I_single_r,
    input      [ 7:0] I_single_g,
    input      [ 7:0] I_single_b,
    input      [11:0] I_h_total,   // hor total time
    input      [11:0] I_h_sync,    // hor sync time
    input      [11:0] I_h_bporch,  // hor back porch
    input      [11:0] I_h_res,     // hor resolution
    input      [11:0] I_v_total,   // ver total time
    input      [11:0] I_v_sync,    // ver sync time
    input      [11:0] I_v_bporch,  // ver back porch
    input      [11:0] I_v_res,     // ver resolution
    input             I_hs_pol,    // HS polarity , 0:负极性，1：正极性
    input             I_vs_pol,    // VS polarity , 0:负极性，1：正极性
    output            O_de,
    output reg        O_hs,        // 负极性
    output reg        O_vs,        // 负极性
    output     [ 7:0] O_data_r,
    output     [ 7:0] O_data_g,
    output     [ 7:0] O_data_b
);

    //====================================================
    localparam N = 5;  // delay N clocks

    localparam WHITE = {8'd255, 8'd255, 8'd255};  // {B,G,R}
    localparam YELLOW = {8'd0, 8'd255, 8'd255};
    localparam CYAN = {8'd255, 8'd255, 8'd0};
    localparam GREEN = {8'd0, 8'd255, 8'd0};
    localparam MAGENTA = {8'd255, 8'd0, 8'd255};
    localparam RED = {8'd0, 8'd0, 8'd255};
    localparam BLUE = {8'd255, 8'd0, 8'd0};
    localparam BLACK = {8'd0, 8'd0, 8'd0};

    //====================================================
    reg  [ 11:0] V_cnt;
    reg  [ 11:0] H_cnt;

    wire         Pout_de_w;
    wire         Pout_hs_w;
    wire         Pout_vs_w;

    reg  [N-1:0] Pout_de_dn;
    reg  [N-1:0] Pout_hs_dn;
    reg  [N-1:0] Pout_vs_dn;

    //----------------------------
    wire         De_pos;
    wire         De_neg;
    wire         Vs_pos;

    reg  [ 11:0] De_vcnt;
    reg  [ 11:0] De_hcnt;
    reg  [ 11:0] De_hcnt_d1;
    reg  [ 11:0] De_hcnt_d2;

    //-------------------------
    // Color bar // 8色彩条
    reg  [ 11:0] Color_trig_num;
    reg          Color_trig;
    reg  [  3:0] Color_cnt;
    reg  [ 23:0] Color_bar;

    //----------------------------
    // Net grid // 32网格
    reg          Net_h_trig;
    reg          Net_v_trig;
    wire [  1:0] Net_pos;
    reg  [ 23:0] Net_grid;

    //----------------------------
    // Gray  // 黑白灰阶
    reg  [ 23:0] Gray;
    reg  [ 23:0] Gray_d1;

    //-----------------------------
    wire [ 23:0] Single_color;

    //-------------------------------
    wire [ 23:0] Data_sel;

    //-------------------------------
    reg  [ 23:0] Data_tmp  /*synthesis syn_keep=1*/;

    //==============================================================================
    // Generate HS, VS, DE signals
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) V_cnt <= 12'd0;
        else begin
            if ((V_cnt >= (I_v_total - 1'b1)) && (H_cnt >= (I_h_total - 1'b1))) V_cnt <= 12'd0;
            else if (H_cnt >= (I_h_total - 1'b1)) V_cnt <= V_cnt + 1'b1;
            else V_cnt <= V_cnt;
        end
    end

    //-------------------------------------------------------------
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) H_cnt <= 12'd0;
        else if (H_cnt >= (I_h_total - 1'b1)) H_cnt <= 12'd0;
        else H_cnt <= H_cnt + 1'b1;
    end

    //-------------------------------------------------------------
    assign  Pout_de_w = ((H_cnt>=(I_h_sync+I_h_bporch))&(H_cnt<=(I_h_sync+I_h_bporch+I_h_res-1'b1)))&
                    ((V_cnt>=(I_v_sync+I_v_bporch))&(V_cnt<=(I_v_sync+I_v_bporch+I_v_res-1'b1))) ;
    assign Pout_hs_w = ~((H_cnt >= 12'd0) & (H_cnt <= (I_h_sync - 1'b1)));
    assign Pout_vs_w = ~((V_cnt >= 12'd0) & (V_cnt <= (I_v_sync - 1'b1)));

    //-------------------------------------------------------------
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) begin
            Pout_de_dn <= {N{1'b0}};
            Pout_hs_dn <= {N{1'b1}};
            Pout_vs_dn <= {N{1'b1}};
        end else begin
            Pout_de_dn <= {Pout_de_dn[N-2:0], Pout_de_w};
            Pout_hs_dn <= {Pout_hs_dn[N-2:0], Pout_hs_w};
            Pout_vs_dn <= {Pout_vs_dn[N-2:0], Pout_vs_w};
        end
    end

    assign O_de = Pout_de_dn[4];  // 注意与数据对齐

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) begin
            O_hs <= 1'b1;
            O_vs <= 1'b1;
        end else begin
            O_hs <= I_hs_pol ? ~Pout_hs_dn[3] : Pout_hs_dn[3];
            O_vs <= I_vs_pol ? ~Pout_vs_dn[3] : Pout_vs_dn[3];
        end
    end

    //=================================================================================
    // Test Pattern
    assign De_pos = !Pout_de_dn[1] & Pout_de_dn[0];  // de rising edge
    assign De_neg = Pout_de_dn[1] && !Pout_de_dn[0];  // de falling edge
    assign Vs_pos = !Pout_vs_dn[1] && Pout_vs_dn[0];  // vs rising edge

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) De_hcnt <= 12'd0;
        else if (De_pos == 1'b1) De_hcnt <= 12'd0;
        else if (Pout_de_dn[1] == 1'b1) De_hcnt <= De_hcnt + 1'b1;
        else De_hcnt <= De_hcnt;
    end

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) De_vcnt <= 12'd0;
        else if (Vs_pos == 1'b1) De_vcnt <= 12'd0;
        else if (De_neg == 1'b1) De_vcnt <= De_vcnt + 1'b1;
        else De_vcnt <= De_vcnt;
    end

    //---------------------------------------------------
    // Color bar
    //---------------------------------------------------
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Color_trig_num <= 12'd0;
        else if (Pout_de_dn[1] == 1'b0) Color_trig_num <= I_h_res[11:3];  // 8色彩条宽度
        else if ((Color_trig == 1'b1) && (Pout_de_dn[1] == 1'b1))
            Color_trig_num <= Color_trig_num + I_h_res[11:3];
        else Color_trig_num <= Color_trig_num;
    end

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Color_trig <= 1'b0;
        else if (De_hcnt == (Color_trig_num - 1'b1)) Color_trig <= 1'b1;
        else Color_trig <= 1'b0;
    end

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Color_cnt <= 3'd0;
        else if (Pout_de_dn[1] == 1'b0) Color_cnt <= 3'd0;
        else if ((Color_trig == 1'b1) && (Pout_de_dn[1] == 1'b1)) Color_cnt <= Color_cnt + 1'b1;
        else Color_cnt <= Color_cnt;
    end

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Color_bar <= 24'd0;
        else if (Pout_de_dn[2] == 1'b1)
            case (Color_cnt)
                3'd0:    Color_bar <= WHITE;
                3'd1:    Color_bar <= YELLOW;
                3'd2:    Color_bar <= CYAN;
                3'd3:    Color_bar <= GREEN;
                3'd4:    Color_bar <= MAGENTA;
                3'd5:    Color_bar <= RED;
                3'd6:    Color_bar <= BLACK;
                3'd7:    Color_bar <= BLUE;
                default: Color_bar <= BLACK;
            endcase
        else Color_bar <= BLACK;
    end

    //---------------------------------------------------
    // Net grid
    //---------------------------------------------------
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Net_h_trig <= 1'b0;
        else if (((De_hcnt[4:0] == 5'd0) || (De_hcnt == (I_h_res-1'b1))) && (Pout_de_dn[1] == 1'b1))
            Net_h_trig <= 1'b1;
        else Net_h_trig <= 1'b0;
    end

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Net_v_trig <= 1'b0;
        else if (((De_vcnt[4:0] == 5'd0) || (De_vcnt == (I_v_res-1'b1))) && (Pout_de_dn[1] == 1'b1))
            Net_v_trig <= 1'b1;
        else Net_v_trig <= 1'b0;
    end

    assign Net_pos = {Net_v_trig, Net_h_trig};

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Net_grid <= 24'd0;
        else if (Pout_de_dn[2] == 1'b1)
            case (Net_pos)
                2'b00:   Net_grid <= BLACK;
                2'b01:   Net_grid <= RED;
                2'b10:   Net_grid <= RED;
                2'b11:   Net_grid <= RED;
                default: Net_grid <= BLACK;
            endcase
        else Net_grid <= BLACK;
    end

    //---------------------------------------------------
    // Gray
    //---------------------------------------------------
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Gray <= 24'd0;
        else Gray <= {De_hcnt[7:0], De_hcnt[7:0], De_hcnt[7:0]};
    end

    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Gray_d1 <= 24'd0;
        else Gray_d1 <= Gray;
    end

    //---------------------------------------------------
    // Single color
    //---------------------------------------------------
    assign Single_color = {I_single_b, I_single_g, I_single_r};

    //============================================================
    assign Data_sel = (I_mode[2:0] == 3'b000) ? Color_bar		:
                  (I_mode[2:0] == 3'b001) ? Net_grid 		:
                  (I_mode[2:0] == 3'b010) ? Gray_d1    		:
				  (I_mode[2:0] == 3'b011) ? Single_color	: BLUE;

    //---------------------------------------------------
    always @(posedge I_pxl_clk or negedge I_rst_n) begin
        if (!I_rst_n) Data_tmp <= 24'd0;
        else Data_tmp <= Data_sel;
    end

    assign O_data_r = Data_tmp[7:0];
    assign O_data_g = Data_tmp[15:8];
    assign O_data_b = Data_tmp[23:16];

endmodule


module CAM (
    input         clk,         // system clock
    input         cmos_clk,    // cmos pixel clock
    input         rst_n,       // system reset

    inout         cmos_scl,    // cmos i2c clock
    inout         cmos_sda,    // cmos i2c data
    input         cmos_vsync,  // cmos vsync
    input         cmos_href,   // cmos hsync refrence,data valid
    input         cmos_pclk,   // cmos pxiel clock
    output        cmos_xclk,   // cmos externl clock
    input  [ 7:0] cmos_db,     // cmos data
    output        cmos_rst_n,  // cmos reset
    output        cmos_pwdn,   // cmos power down

    output [15:0] write_data,
    output        cmos_16bit_wr,
    output        cmos_16bit_clk
);

    wire [ 9:0] lut_index;
    wire [31:0] lut_data;
    wire        i2c_done;
    wire        i2c_err;

    wire [15:0] HActive;
    wire        HA_valid;
    wire [15:0] VActive;
    wire        VA_valid;
    wire [ 7:0] fps;
    wire        fps_valid;

    wire [15:0] cmos_16bit_data;
    reg  [31:0] cmos_reset_delay_cnt;
    reg         cmos_reset;
    reg         cmos_start_config;
    reg  [ 4:0] cmos_vs_cnt;
    always @(posedge cmos_vsync) cmos_vs_cnt <= cmos_vs_cnt + 1;

    assign cmos_xclk  = cmos_clk;
    assign cmos_pwdn  = 1'b0;
    // assign cmos_rst_n = 1'b1;
    assign cmos_rst_n = cmos_reset;
    assign write_data = cmos_16bit_data;
    // assign write_data = {cmos_16bit_data[4:0],cmos_16bit_data[10:5],cmos_16bit_data[15:11]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cmos_reset_delay_cnt <= 0;
            cmos_reset <= 0;
            cmos_start_config <= 0;
        end else begin
            if (cmos_reset_delay_cnt == 32'd3_000_000) begin
                cmos_reset_delay_cnt <= cmos_reset_delay_cnt;
                cmos_reset <= 1'b1;
                cmos_start_config <= 1'b1;
            end else if (cmos_reset_delay_cnt == 32'd100_000) begin
                cmos_reset_delay_cnt <= cmos_reset_delay_cnt + 1;
                cmos_reset <= 1'b1;
                cmos_start_config <= 1'b0;
            end else begin
                cmos_reset_delay_cnt <= cmos_reset_delay_cnt + 1;
                cmos_reset <= cmos_reset;
                cmos_start_config <= cmos_start_config;
            end
        end
    end

    timing_check #(
        .REFCLK_FREQ_MHZ(50),
        .IS_2Pclk_1Pixel("true")
    ) timing_check (
        .Refclk     (clk),
        .pxl_clk    (cmos_pclk),
        .rst_n      (rst_n),
        .video_de   (cmos_href),
        .video_vsync(cmos_vsync),
        .H_Active   (HActive),
        .Ha_updated (HA_valid),
        .V_Active   (VActive),
        .va_updated (VA_valid),
        .fps        (fps),
        .fps_valid  (fps_valid)
    );

    // configure look-up table
    lut_ov5640_rgb565 #(
        .HActive(12'd1280),
        .VActive(12'd720),
        .HTotal(13'd1892),
        .VTotal(13'd740),
        .USE_4vs3_frame("false")
    ) lut_ov5640_rgb565 (
        .lut_index(lut_index),
        .lut_data (lut_data)
    );

    // I2C master controller
    i2c_config i2c_config (
        .rst           (~cmos_start_config),
        .clk           (clk),
        .clk_div_cnt   (16'd500),
        .i2c_addr_2byte(1'b1),
        .lut_index     (lut_index),
        .lut_dev_addr  (lut_data[31:24]),
        .lut_reg_addr  (lut_data[23:8]),
        .lut_reg_data  (lut_data[7:0]),
        .error         (i2c_err),
        .done          (i2c_done),
        .i2c_scl       (cmos_scl),
        .i2c_sda       (cmos_sda)
    );

    // CMOS sensor 8bit data is converted to 16bit data
    cmos_8_16bit cmos_8_16bit (
        .rst    (~rst_n),
        .pclk   (cmos_pclk),
        .pdata_i(cmos_db),
        .de_i   (cmos_href),
        .pdata_o(cmos_16bit_data),
        .hblank (cmos_16bit_wr),
        .de_o   (cmos_16bit_clk)
    );

endmodule


module cmos_8_16bit (
    input             rst,
    input             pclk,
    input      [ 7:0] pdata_i,
    input             de_i,
    output reg [15:0] pdata_o,
    output reg        hblank,
    output reg        de_o
);

    reg [7:0] pdata_i_d0;
    reg       x_cnt;
    always@(posedge pclk)  // Latch
	begin
        pdata_i_d0 <= pdata_i;
    end

    reg de_d1;  // ,de_d2;
    always@(posedge pclk)
	begin
        if (de_i & !de_d1) x_cnt <= 1;
        else x_cnt <= ~x_cnt;
    end

    always @(posedge pclk or posedge rst) begin
        if (rst) de_o <= 1'b0;
        else if (x_cnt) de_o <= 1'b1;
        else de_o <= 1'b0;
    end

    always @(posedge pclk) begin
        de_d1  <= de_i;
        // de_d2 <= de_d1;
        hblank <= de_d1;
    end

    always @(posedge pclk or posedge rst) begin
        if (rst) pdata_o <= 16'd0;
        else if (de_i && x_cnt) pdata_o <= {pdata_i_d0, pdata_i};
        else pdata_o <= pdata_o;
    end

endmodule


module timing_check #(
    parameter REFCLK_FREQ_MHZ = 50,
    parameter IS_2Pclk_1Pixel = "true"
) (
    input Refclk,
    input pxl_clk,
    input rst_n,
    input video_de,
    input video_vsync,

    output [15:0] H_Active,
    output        Ha_updated,
    output [15:0] V_Active,
    output        va_updated,
    output [ 7:0] fps,
    output        fps_valid
);

    localparam PPS_DIV_CNT = REFCLK_FREQ_MHZ * 500_000;

    reg        pps_1Hz_clk;
    reg [31:0] pps_cnt;
    always @(posedge Refclk or negedge rst_n) begin
        if (!rst_n) begin
            pps_1Hz_clk <= 1'b0;
            pps_cnt <= 32'd0;
        end else begin
            if (pps_cnt == PPS_DIV_CNT - 1) begin
                pps_1Hz_clk <= ~pps_1Hz_clk;
                pps_cnt <= 32'd0;
            end else begin
                pps_1Hz_clk <= pps_1Hz_clk;
                pps_cnt <= pps_cnt + 1;
            end
        end
    end

    reg [15:0] HA_Out;
    reg        HA_updated;
    reg [15:0] VA_Out;
    reg        VA_updated;
    reg [ 7:0] fps_out;
    reg        fps_updated;
    reg [15:0] HA_CNT;
    reg [15:0] VA_CNT;
    reg [ 7:0] fps_CNT;
    reg [ 3:0] pps_clk_d;
    reg        pixel_clk;
    reg        de_d;
    reg        vsync_d;
    generate
        always @(posedge pxl_clk or negedge rst_n) begin
            if (!rst_n) begin
                HA_Out <= 0;
                HA_updated <= 0;
                VA_Out <= 0;
                VA_updated <= 0;
                fps_out <= 0;
                fps_updated <= 0;
                HA_CNT <= 0;
                VA_CNT <= 0;
                fps_CNT <= 0;
                pps_clk_d <= 0;
                pixel_clk <= 0;
                de_d <= 0;
                vsync_d <= 0;
            end else begin
                // Sync
                pps_clk_d <= {pps_clk_d[2:0], pps_1Hz_clk};
                de_d <= video_de;
                vsync_d <= video_vsync;

                // Horzental
                if(de_d & ~video_de)    // Negedge of DE, H end
                begin
                    HA_CNT <= 0;
                    HA_Out <= HA_CNT;
                    HA_updated <= 1;
                    pixel_clk <= 0;
                end else if (video_de) begin
                    HA_updated <= 0;
                    HA_Out <= HA_Out;
                    if (IS_2Pclk_1Pixel == "true") begin
                        pixel_clk <= ~pixel_clk;
                        if (pixel_clk) begin
                            HA_CNT <= HA_CNT + 1;
                        end else begin
                            HA_CNT <= HA_CNT;
                        end
                    end else begin
                        HA_CNT <= HA_CNT + 1;
                        pixel_clk <= 0;
                    end
                end else begin
                    HA_CNT <= 0;
                    HA_Out <= HA_Out;
                    HA_updated <= 0;
                    pixel_clk <= 0;
                end

                // Vertical
                if(~vsync_d & video_vsync)    // Posedge of vsync
                begin
                    VA_Out <= VA_CNT;
                    VA_updated <= 1;
                    VA_CNT <= 0;
                end else begin
                    VA_Out <= VA_Out;
                    VA_updated <= 0;
                    if(video_de & ~de_d)    // Posedge of DE, H start
                    begin
                        VA_CNT = VA_CNT + 1;
                    end else begin
                        VA_CNT = VA_CNT;
                    end
                end

                // FPS
                if(pps_clk_d[2] & ~pps_clk_d[3])  // Posedge of pps_1Hz_clk
                begin
                    fps_out <= fps_CNT;
                    fps_updated <= 1;
                    fps_CNT <= 0;
                end else begin
                    fps_out <= fps_out;
                    fps_updated <= 0;
                    if(~vsync_d & video_vsync)  // Posedge of VSYNC
                    begin
                        fps_CNT = fps_CNT + 1;
                    end else begin
                        fps_CNT = fps_CNT;
                    end
                end
            end
        end
    endgenerate

    assign H_Active = HA_Out;
    assign Ha_updated = HA_updated;
    assign V_Active = VA_Out;
    assign va_updated = VA_updated;
    assign fps = fps_out;
    assign fps_valid = fps_updated;

endmodule


`timescale 1ns / 10ps
`define I2C_CMD_NOP 4'b0000
`define I2C_CMD_START 4'b0001
`define I2C_CMD_STOP 4'b0010
`define I2C_CMD_WRITE 4'b0100
`define I2C_CMD_READ 4'b1000

module i2c_config (
    input             rst,
    input             clk,
    input      [15:0] clk_div_cnt,
    input             i2c_addr_2byte,
    output reg [ 9:0] lut_index,
    input      [ 7:0] lut_dev_addr,
    input      [15:0] lut_reg_addr,
    input      [ 7:0] lut_reg_data,
    output reg        error,
    output            done,
    inout             i2c_scl,
    inout             i2c_sda
);
    wire scl_pad_i;
    wire scl_pad_o;
    wire scl_padoen_o;

    wire sda_pad_i;
    wire sda_pad_o;
    wire sda_padoen_o;

    assign sda_pad_i = i2c_sda;
    assign i2c_sda   = ~sda_padoen_o ? sda_pad_o : 1'bz;
    assign scl_pad_i = i2c_scl;
    assign i2c_scl   = ~scl_padoen_o ? scl_pad_o : 1'bz;

    reg         i2c_read_req;
    wire        i2c_read_req_ack;
    reg         i2c_write_req;
    wire        i2c_write_req_ack;
    wire [ 7:0] i2c_slave_dev_addr;
    wire [15:0] i2c_slave_reg_addr;
    wire [ 7:0] i2c_write_data;
    wire [ 7:0] i2c_read_data;

    wire        err;
    reg  [ 2:0] state;

    localparam S_IDLE = 0;
    localparam S_WR_I2C_CHECK = 1;
    localparam S_WR_I2C = 2;
    localparam S_WR_I2C_DONE = 3;


    assign done = (state == S_WR_I2C_DONE);
    assign i2c_slave_dev_addr = lut_dev_addr;
    assign i2c_slave_reg_addr = lut_reg_addr;
    assign i2c_write_data = lut_reg_data;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            error <= 1'b0;
            lut_index <= 8'd0;
        end else
            case (state)
                S_IDLE: begin
                    state <= S_WR_I2C_CHECK;
                    error <= 1'b0;
                    lut_index <= 8'd0;
                end
                S_WR_I2C_CHECK: begin
                    if (i2c_slave_dev_addr != 8'hff) begin
                        i2c_write_req <= 1'b1;
                        state <= S_WR_I2C;
                    end else begin
                        state <= S_WR_I2C_DONE;
                    end
                end
                S_WR_I2C: begin
                    if (i2c_write_req_ack) begin
                        error <= err ? 1'b1 : error;
                        lut_index <= lut_index + 8'd1;
                        i2c_write_req <= 1'b0;
                        state <= S_WR_I2C_CHECK;
                    end
                end
                S_WR_I2C_DONE: begin
                    state <= S_WR_I2C_DONE;
                end
                default: state <= S_IDLE;
            endcase
    end



    i2c_master_top i2c_master_top_m0 (
        .rst        (rst),
        .clk        (clk),
        .clk_div_cnt(clk_div_cnt),

        // I2C signals
        // i2c clock line
        .scl_pad_i   (scl_pad_i),    // SCL-line input
        .scl_pad_o   (scl_pad_o),    // SCL-line output (always 1'b0)
        .scl_padoen_o(scl_padoen_o), // SCL-line output enable (active low)

        // i2c data line
        .sda_pad_i   (sda_pad_i),    // SDA-line input
        .sda_pad_o   (sda_pad_o),    // SDA-line output (always 1'b0)
        .sda_padoen_o(sda_padoen_o), // SDA-line output enable (active low)

        .i2c_read_req      (i2c_read_req),
        .i2c_addr_2byte    (i2c_addr_2byte),
        .i2c_read_req_ack  (i2c_read_req_ack),
        .i2c_write_req     (i2c_write_req),
        .i2c_write_req_ack (i2c_write_req_ack),
        .i2c_slave_dev_addr(i2c_slave_dev_addr),
        .i2c_slave_reg_addr(i2c_slave_reg_addr),
        .i2c_write_data    (i2c_write_data),
        .i2c_read_data     (i2c_read_data),
        .error             (err)
    );

endmodule


module i2c_master_top (
    input        rst,
    input        clk,
    input [15:0] clk_div_cnt,

    // I2C signals
    // i2c clock line
    input             scl_pad_i,           // SCL-line input
    output            scl_pad_o,           // SCL-line output (always 1'b0)
    output            scl_padoen_o,        // SCL-line output enable (active low)
    // i2c data line
    input             sda_pad_i,           // SDA-line input
    output            sda_pad_o,           // SDA-line output (always 1'b0)
    output            sda_padoen_o,        // SDA-line output enable (active low)
    input             i2c_addr_2byte,      // Is the register address 16bit?
    input             i2c_read_req,        // Read register request
    output            i2c_read_req_ack,    // Read register request response
    input             i2c_write_req,       // Write register request
    output            i2c_write_req_ack,   // Write register request response
    input      [ 7:0] i2c_slave_dev_addr,  // I2c device address
    input      [15:0] i2c_slave_reg_addr,  // I2c register address
    input      [ 7:0] i2c_write_data,      // I2c write register data
    output reg [ 7:0] i2c_read_data,       // I2c read register data
    output reg        error                // The error indication, generally there is no response
);
    // State machine definition
    localparam S_IDLE = 0;  // Idle state, waiting for read and write
    localparam S_WR_DEV_ADDR = 1;  // Write device address
    localparam S_WR_REG_ADDR = 2;  // Write register address
    localparam S_WR_DATA = 3;  // Write register data
    localparam S_WR_ACK = 4;  // Write request response
    localparam S_WR_ERR_NACK = 5;  // Write error, I2C device is not responding
    localparam S_RD_DEV_ADDR0 = 6;  // I2C read state, first writes the device address and the register address
    localparam S_RD_REG_ADDR = 7;  // I2C read state, read register address (8bit)
    localparam S_RD_DEV_ADDR1 = 8;  // Write the device address again
    localparam S_RD_DATA = 9;  // Read data
    localparam S_RD_STOP = 10;
    localparam S_WR_STOP = 11;
    localparam S_WAIT = 12;
    localparam S_WR_REG_ADDR1 = 13;
    localparam S_RD_REG_ADDR1 = 14;
    localparam S_RD_ACK = 15;
    reg        start;
    reg        stop;
    reg        read;
    reg        write;
    reg        ack_in;
    reg  [7:0] txr;
    wire [7:0] rxr;
    wire       i2c_busy;
    wire       i2c_al;
    wire       done;
    wire       irxack;
    reg [3:0] state, next_state;
    assign i2c_read_req_ack  = (state == S_RD_ACK);
    assign i2c_write_req_ack = (state == S_WR_ACK);
    always @(posedge clk or posedge rst) begin
        if (rst) state <= S_IDLE;
        else state <= next_state;
    end

    always@(*)
    begin
        case(state)
            S_IDLE:
                // Waiting for read and write requests
                if(i2c_write_req)
                    next_state <= S_WR_DEV_ADDR;
                else if(i2c_read_req)
                    next_state <= S_RD_DEV_ADDR0;
                else
                    next_state <= S_IDLE;
            // Write I2C device address
            S_WR_DEV_ADDR:
                if(done && irxack)
                    next_state <= S_WR_ERR_NACK;
                else if(done)
                    next_state <= S_WR_REG_ADDR;
                else
                    next_state <= S_WR_DEV_ADDR;
            // Write the address of the I2C register
            S_WR_REG_ADDR:
                if(done)
                    // If it is the 8bit register address, it enters the write data state
                    next_state <= i2c_addr_2byte ? S_WR_REG_ADDR1 : S_WR_DATA;
                else
                    next_state <= S_WR_REG_ADDR;
            S_WR_REG_ADDR1:
                if(done)
                    next_state <= S_WR_DATA;
                else
                    next_state <= S_WR_REG_ADDR1;
            // Write data
            S_WR_DATA:
                if(done)
                    next_state <= S_WR_STOP;
                else
                    next_state <= S_WR_DATA;
            S_WR_ERR_NACK:
                next_state <= S_WR_STOP;
            S_RD_ACK,S_WR_ACK:
                next_state <= S_WAIT;
            S_WAIT:
                next_state <= S_IDLE;
            S_RD_DEV_ADDR0:
                if(done && irxack)
                    next_state <= S_WR_ERR_NACK;
                else if(done)
                    next_state <= S_RD_REG_ADDR;
                else
                    next_state <= S_RD_DEV_ADDR0;
            S_RD_REG_ADDR:
                if(done)
                    next_state <= i2c_addr_2byte ? S_RD_REG_ADDR1 : S_RD_DEV_ADDR1;
                else
                    next_state <= S_RD_REG_ADDR;
            S_RD_REG_ADDR1:
                if(done)
                    next_state <= S_RD_DEV_ADDR1;
                else
                    next_state <= S_RD_REG_ADDR1;
            S_RD_DEV_ADDR1:
                if(done)
                    next_state <= S_RD_DATA;
                else
                    next_state <= S_RD_DEV_ADDR1;
            S_RD_DATA:
                if(done)
                    next_state <= S_RD_STOP;
                else
                    next_state <= S_RD_DATA;
            S_RD_STOP:
                if(done)
                    next_state <= S_RD_ACK;
                else
                    next_state <= S_RD_STOP;
            S_WR_STOP:
                if(done)
                    next_state <= S_WR_ACK;
                else
                    next_state <= S_WR_STOP;
            default:
                next_state <= S_IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) error <= 1'b0;
        else if (state == S_IDLE) error <= 1'b0;
        else if (state == S_WR_ERR_NACK) error <= 1'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) start <= 1'b0;
        else if (done) start <= 1'b0;
        else if (state == S_WR_DEV_ADDR || state == S_RD_DEV_ADDR0 || state == S_RD_DEV_ADDR1)
            start <= 1'b1;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) stop <= 1'b0;
        else if (done) stop <= 1'b0;
        else if (state == S_WR_STOP || state == S_RD_STOP) stop <= 1'b1;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) ack_in <= 1'b0;
        else ack_in <= 1'b1;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) write <= 1'b0;
        else if (done) write <= 1'b0;
        else if(state == S_WR_DEV_ADDR || state == S_WR_REG_ADDR || state == S_WR_REG_ADDR1|| state == S_WR_DATA || state == S_RD_DEV_ADDR0 || state == S_RD_DEV_ADDR1 || state == S_RD_REG_ADDR || state == S_RD_REG_ADDR1)
            write <= 1'b1;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) read <= 1'b0;
        else if (done) read <= 1'b0;
        else if (state == S_RD_DATA) read <= 1'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) i2c_read_data <= 8'h00;
        else if (state == S_RD_DATA && done) i2c_read_data <= rxr;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) txr <= 8'd0;
        else
            case (state)
                S_WR_DEV_ADDR, S_RD_DEV_ADDR0: txr <= {i2c_slave_dev_addr[7:1], 1'b0};
                S_RD_DEV_ADDR1: txr <= {i2c_slave_dev_addr[7:1], 1'b1};
                S_WR_REG_ADDR, S_RD_REG_ADDR:
                txr <= (i2c_addr_2byte == 1'b1) ? i2c_slave_reg_addr[15:8] : i2c_slave_reg_addr[7:0];
                S_WR_REG_ADDR1, S_RD_REG_ADDR1: txr <= i2c_slave_reg_addr[7:0];
                S_WR_DATA: txr <= i2c_write_data;
                default: txr <= 8'hff;
            endcase
    end
    i2c_master_byte_ctrl byte_controller (
        .clk     (clk),
        .rst     (rst),
        .nReset  (1'b1),
        .ena     (1'b1),
        .clk_cnt (clk_div_cnt),
        .start   (start),
        .stop    (stop),
        .read    (read),
        .write   (write),
        .ack_in  (ack_in),
        .din     (txr),
        .cmd_ack (done),
        .ack_out (irxack),
        .dout    (rxr),
        .i2c_busy(i2c_busy),
        .i2c_al  (i2c_al),
        .scl_i   (scl_pad_i),
        .scl_o   (scl_pad_o),
        .scl_oen (scl_padoen_o),
        .sda_i   (sda_pad_i),
        .sda_o   (sda_pad_o),
        .sda_oen (sda_padoen_o)
    );

endmodule


/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE rev.B2 compliant I2C Master byte-controller       ////
////                                                             ////
////                                                             ////
////  Author: Richard Herveille                                  ////
////          richard@asics.ws                                   ////
////          www.asics.ws                                       ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/projects/i2c/    ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Richard Herveille                        ////
////                    richard@asics.ws                         ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: i2c_master_byte_ctrl.v,v 1.8 2009-01-19 20:29:26 rherveille Exp $
//
//  $Date: 2009-01-19 20:29:26 $
//  $Revision: 1.8 $
//  $Author: rherveille $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.7  2004/02/18 11:40:46  rherveille
//               Fixed a potential bug in the statemachine. During a 'stop' 2 cmd_ack signals were generated. Possibly canceling a new start command.
//
//               Revision 1.6  2003/08/09 07:01:33  rherveille
//               Fixed a bug in the Arbitration Lost generation caused by delay on the (external) sda line.
//               Fixed a potential bug in the byte controller's host-acknowledge generation.
//
//               Revision 1.5  2002/12/26 15:02:32  rherveille
//               Core is now a Multimaster I2C controller
//
//               Revision 1.4  2002/11/30 22:24:40  rherveille
//               Cleaned up code
//
//               Revision 1.3  2001/11/05 11:59:25  rherveille
//               Fixed wb_ack_o generation bug.
//               Fixed bug in the byte_controller statemachine.
//               Added headers.
//

// synopsys translate_off
// synopsys translate_on

module i2c_master_byte_ctrl (
    clk, rst, nReset, ena, clk_cnt, start, stop, read, write, ack_in, din,
    cmd_ack, ack_out, dout, i2c_busy, i2c_al, scl_i, scl_o, scl_oen, sda_i, sda_o, sda_oen );

    //
    // inputs & outputs
    //
    input clk;  // master clock
    input rst;  // synchronous active high reset
    input nReset;  // asynchronous active low reset
    input ena;  // core enable signal

    input [15:0] clk_cnt;  // 4x SCL

    // control inputs
    input start;
    input stop;
    input read;
    input write;
    input ack_in;
    input [7:0] din;

    // status outputs
    output cmd_ack;
    reg cmd_ack;
    output ack_out;
    reg ack_out;
    output i2c_busy;
    output i2c_al;
    output [7:0] dout;

    // I2C signals
    input scl_i;
    output scl_o;
    output scl_oen;
    input sda_i;
    output sda_o;
    output sda_oen;


    //
    // Variable declarations
    //

    // statemachine
    parameter [4:0] ST_IDLE = 5'b0_0000;
    parameter [4:0] ST_START = 5'b0_0001;
    parameter [4:0] ST_READ = 5'b0_0010;
    parameter [4:0] ST_WRITE = 5'b0_0100;
    parameter [4:0] ST_ACK = 5'b0_1000;
    parameter [4:0] ST_STOP = 5'b1_0000;

    // signals for bit_controller
    reg [3:0] core_cmd;
    reg       core_txd;
    wire core_ack, core_rxd;

    // signals for shift register
    reg [7:0] sr;  //8bit shift register
    reg shift, ld;

    // signals for state machine
    wire       go;
    reg  [2:0] dcnt;
    wire       cnt_done;

    //
    // Module body
    //

    // hookup bit_controller
    i2c_master_bit_ctrl bit_controller (
        .clk    (clk),
        .rst    (rst),
        .nReset (nReset),
        .ena    (ena),
        .clk_cnt(clk_cnt),
        .cmd    (core_cmd),
        .cmd_ack(core_ack),
        .busy   (i2c_busy),
        .al     (i2c_al),
        .din    (core_txd),
        .dout   (core_rxd),
        .scl_i  (scl_i),
        .scl_o  (scl_o),
        .scl_oen(scl_oen),
        .sda_i  (sda_i),
        .sda_o  (sda_o),
        .sda_oen(sda_oen)
    );

    // generate go-signal
    assign go   = (read | write | stop) & ~cmd_ack;

    // assign dout output to shift-register
    assign dout = sr;

    // generate shift register
    always @(posedge clk or negedge nReset)
        if (!nReset) sr <= #1 8'h0;
        else if (rst) sr <= #1 8'h0;
        else if (ld) sr <= #1 din;
        else if (shift) sr <= #1{sr[6:0], core_rxd};

    // generate counter
    always @(posedge clk or negedge nReset)
        if (!nReset) dcnt <= #1 3'h0;
        else if (rst) dcnt <= #1 3'h0;
        else if (ld) dcnt <= #1 3'h7;
        else if (shift) dcnt <= #1 dcnt - 3'h1;

    assign cnt_done = ~(|dcnt);

    //
    // state machine
    //
    reg [4:0] c_state;  // synopsys enum_state

    always @(posedge clk or negedge nReset)
        if (!nReset) begin
            core_cmd <= #1 `I2C_CMD_NOP;
            core_txd <= #1 1'b0;
            shift    <= #1 1'b0;
            ld       <= #1 1'b0;
            cmd_ack  <= #1 1'b0;
            c_state  <= #1 ST_IDLE;
            ack_out  <= #1 1'b0;
        end else if (rst | i2c_al) begin
            core_cmd <= #1 `I2C_CMD_NOP;
            core_txd <= #1 1'b0;
            shift    <= #1 1'b0;
            ld       <= #1 1'b0;
            cmd_ack  <= #1 1'b0;
            c_state  <= #1 ST_IDLE;
            ack_out  <= #1 1'b0;
        end else begin
            // initially reset all signals
            core_txd <= #1 sr[7];
            shift    <= #1 1'b0;
            ld       <= #1 1'b0;
            cmd_ack  <= #1 1'b0;

            case (c_state)  // synopsys full_case parallel_case
                ST_IDLE:
                if (go) begin
                    if (start) begin
                        c_state  <= #1 ST_START;
                        core_cmd <= #1 `I2C_CMD_START;
                    end else if (read) begin
                        c_state  <= #1 ST_READ;
                        core_cmd <= #1 `I2C_CMD_READ;
                    end else if (write) begin
                        c_state  <= #1 ST_WRITE;
                        core_cmd <= #1 `I2C_CMD_WRITE;
                    end else  // stop
                    begin
                        c_state  <= #1 ST_STOP;
                        core_cmd <= #1 `I2C_CMD_STOP;
                    end

                    ld <= #1 1'b1;
                end

                ST_START:
                if (core_ack) begin
                    if (read) begin
                        c_state  <= #1 ST_READ;
                        core_cmd <= #1 `I2C_CMD_READ;
                    end else begin
                        c_state  <= #1 ST_WRITE;
                        core_cmd <= #1 `I2C_CMD_WRITE;
                    end

                    ld <= #1 1'b1;
                end

                ST_WRITE:
                if (core_ack)
                    if (cnt_done) begin
                        c_state  <= #1 ST_ACK;
                        core_cmd <= #1 `I2C_CMD_READ;
                    end else begin
                        c_state  <= #1 ST_WRITE;  // stay in same state
                        core_cmd <= #1 `I2C_CMD_WRITE;  // write next bit
                        shift    <= #1 1'b1;
                    end

                ST_READ:
                if (core_ack) begin
                    if (cnt_done) begin
                        c_state  <= #1 ST_ACK;
                        core_cmd <= #1 `I2C_CMD_WRITE;
                    end else begin
                        c_state  <= #1 ST_READ;  // stay in same state
                        core_cmd <= #1 `I2C_CMD_READ;  // read next bit
                    end

                    shift    <= #1 1'b1;
                    core_txd <= #1 ack_in;
                end

                ST_ACK:
                if (core_ack) begin
                    if (stop) begin
                        c_state  <= #1 ST_STOP;
                        core_cmd <= #1 `I2C_CMD_STOP;
                    end else begin
                        c_state  <= #1 ST_IDLE;
                        core_cmd <= #1 `I2C_CMD_NOP;

                        // generate command acknowledge signal
                        cmd_ack  <= #1 1'b1;
                    end

                    // assign ack_out output to bit_controller_rxd (contains last received bit)
                    ack_out  <= #1 core_rxd;

                    core_txd <= #1 1'b1;
                end else core_txd <= #1 ack_in;

                ST_STOP:
                if (core_ack) begin
                    c_state  <= #1 ST_IDLE;
                    core_cmd <= #1 `I2C_CMD_NOP;

                    // generate command acknowledge signal
                    cmd_ack  <= #1 1'b1;
                end

            endcase
        end

endmodule


/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE rev.B2 compliant I2C Master bit-controller        ////
////                                                             ////
////                                                             ////
////  Author: Richard Herveille                                  ////
////          richard@asics.ws                                   ////
////          www.asics.ws                                       ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/projects/i2c/    ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Richard Herveille                        ////
////                    richard@asics.ws                         ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: i2c_master_bit_ctrl.v,v 1.14 2009-01-20 10:25:29 rherveille Exp $
//
//  $Date: 2009-01-20 10:25:29 $
//  $Revision: 1.14 $
//  $Author: rherveille $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: $
//               Revision 1.14  2009/01/20 10:25:29  rherveille
//               Added clock synchronization logic
//               Fixed slave_wait signal
//
//               Revision 1.13  2009/01/19 20:29:26  rherveille
//               Fixed synopsys miss spell (synopsis)
//               Fixed cr[0] register width
//               Fixed ! usage instead of ~
//               Fixed bit controller parameter width to 18bits
//
//               Revision 1.12  2006/09/04 09:08:13  rherveille
//               fixed short scl high pulse after clock stretch
//               fixed slave model not returning correct '(n)ack' signal
//
//               Revision 1.11  2004/05/07 11:02:26  rherveille
//               Fixed a bug where the core would signal an arbitration lost (AL bit set), when another master controls the bus and the other master generates a STOP bit.
//
//               Revision 1.10  2003/08/09 07:01:33  rherveille
//               Fixed a bug in the Arbitration Lost generation caused by delay on the (external) sda line.
//               Fixed a potential bug in the byte controller's host-acknowledge generation.
//
//               Revision 1.9  2003/03/10 14:26:37  rherveille
//               Fixed cmd_ack generation item (no bug).
//
//               Revision 1.8  2003/02/05 00:06:10  rherveille
//               Fixed a bug where the core would trigger an erroneous 'arbitration lost' interrupt after being reset, when the reset pulse width < 3 clk cycles.
//
//               Revision 1.7  2002/12/26 16:05:12  rherveille
//               Small code simplifications
//
//               Revision 1.6  2002/12/26 15:02:32  rherveille
//               Core is now a Multimaster I2C controller
//
//               Revision 1.5  2002/11/30 22:24:40  rherveille
//               Cleaned up code
//
//               Revision 1.4  2002/10/30 18:10:07  rherveille
//               Fixed some reported minor start/stop generation timing issuess.
//
//               Revision 1.3  2002/06/15 07:37:03  rherveille
//               Fixed a small timing bug in the bit controller.\nAdded verilog simulation environment.
//
//               Revision 1.2  2001/11/05 11:59:25  rherveille
//               Fixed wb_ack_o generation bug.
//               Fixed bug in the byte_controller statemachine.
//               Added headers.
//

//
/////////////////////////////////////
// Bit controller section
/////////////////////////////////////
//
// Translate simple commands into SCL/SDA transitions
// Each command has 5 states, A/B/C/D/idle
//
// start:	SCL	~~~~~~~~~~\____
//	SDA	~~~~~~~~\______
//		 x | A | B | C | D | i
//
// repstart	SCL	____/~~~~\___
//	SDA	__/~~~\______
//		 x | A | B | C | D | i
//
// stop	SCL	____/~~~~~~~~
//	SDA	==\____/~~~~~
//		 x | A | B | C | D | i
//
//- write	SCL	____/~~~~\____
//	SDA	==X=========X=
//		 x | A | B | C | D | i
//
//- read	SCL	____/~~~~\____
//	SDA	XXXX=====XXXX
//		 x | A | B | C | D | i
//

// Timing:     Normal mode      Fast mode
///////////////////////////////////////////////////////////////////////
// Fscl        100KHz           400KHz
// Th_scl      4.0us            0.6us   High period of SCL
// Tl_scl      4.7us            1.3us   Low period of SCL
// Tsu:sta     4.7us            0.6us   setup time for a repeated start condition
// Tsu:sto     4.0us            0.6us   setup time for a stop conditon
// Tbuf        4.7us            1.3us   Bus free time between a stop and start condition
//

// synopsys translate_off
// synopsys translate_on

module i2c_master_bit_ctrl (
    input clk,     // system clock
    input rst,     // synchronous active high reset
    input nReset,  // asynchronous active low reset
    input ena,     // core enable signal

    input [15:0] clk_cnt,  // clock prescale value

    input      [3:0] cmd,      // command (from byte controller)
    output reg       cmd_ack,  // command complete acknowledge
    output reg       busy,     // i2c bus busy
    output reg       al,       // i2c bus arbitration lost

    input      din,
    output reg dout,

    input      scl_i,    // i2c clock line input
    output     scl_o,    // i2c clock line output
    output reg scl_oen,  // i2c clock line output enable (active low)
    input      sda_i,    // i2c data line input
    output     sda_o,    // i2c data line output
    output reg sda_oen   // i2c data line output enable (active low)
);

    //
    // variable declarations
    //

    reg [1:0] cSCL, cSDA;  // capture SCL and SDA
    reg [2:0] fSCL, fSDA;  // SCL and SDA filter inputs
    reg sSCL, sSDA;  // filtered and synchronized SCL and SDA inputs
    reg dSCL, dSDA;  // delayed versions of sSCL and sSDA
    reg        dscl_oen;  // delayed scl_oen
    reg        sda_chk;  // check SDA output (Multi-master arbitration)
    reg        clk_en;  // clock generation signals
    reg        slave_wait;  // slave inserts wait states
    reg [15:0] cnt;  // clock divider counter (synthesis)
    reg [13:0] filter_cnt;  // clock divider for filter


    // state machine variable
    reg [17:0] c_state;  // synopsys enum_state

    //
    // module body
    //

    // whenever the slave is not ready it can delay the cycle by pulling SCL low
    // delay scl_oen
    always @(posedge clk) dscl_oen <= #1 scl_oen;

    // slave_wait is asserted when master wants to drive SCL high, but the slave pulls it low
    // slave_wait remains asserted until the slave releases SCL
    always @(posedge clk or negedge nReset)
        if (!nReset) slave_wait <= 1'b0;
        else slave_wait <= (scl_oen & ~dscl_oen & ~sSCL) | (slave_wait & ~sSCL);

    // master drives SCL high, but another master pulls it low
    // master start counting down its low cycle now (clock synchronization)
    wire scl_sync = dSCL & ~sSCL & scl_oen;


    // generate clk enable signal
    always @(posedge clk or negedge nReset)
        if (~nReset) begin
            cnt    <= #1 16'h0;
            clk_en <= #1 1'b1;
        end else if (rst || ~|cnt || !ena || scl_sync) begin
            cnt    <= #1 clk_cnt;
            clk_en <= #1 1'b1;
        end else if (slave_wait) begin
            cnt    <= #1 cnt;
            clk_en <= #1 1'b0;
        end else begin
            cnt    <= #1 cnt - 16'h1;
            clk_en <= #1 1'b0;
        end


    // generate bus status controller

    // capture SDA and SCL
    // reduce metastability risk
    always @(posedge clk or negedge nReset)
        if (!nReset) begin
            cSCL <= #1 2'b00;
            cSDA <= #1 2'b00;
        end else if (rst) begin
            cSCL <= #1 2'b00;
            cSDA <= #1 2'b00;
        end else begin
            cSCL <= {cSCL[0], scl_i};
            cSDA <= {cSDA[0], sda_i};
        end


    // filter SCL and SDA signals; (attempt to) remove glitches
    always @(posedge clk or negedge nReset)
        if (!nReset) filter_cnt <= 14'h0;
        else if (rst || !ena) filter_cnt <= 14'h0;
        else if (~|filter_cnt) filter_cnt <= clk_cnt >> 2;  //16x I2C bus frequency
        else filter_cnt <= filter_cnt - 1;


    always @(posedge clk or negedge nReset)
        if (!nReset) begin
            fSCL <= 3'b111;
            fSDA <= 3'b111;
        end else if (rst) begin
            fSCL <= 3'b111;
            fSDA <= 3'b111;
        end else if (~|filter_cnt) begin
            fSCL <= {fSCL[1:0], cSCL[1]};
            fSDA <= {fSDA[1:0], cSDA[1]};
        end


    // generate filtered SCL and SDA signals
    always @(posedge clk or negedge nReset)
        if (~nReset) begin
            sSCL <= #1 1'b1;
            sSDA <= #1 1'b1;

            dSCL <= #1 1'b1;
            dSDA <= #1 1'b1;
        end else if (rst) begin
            sSCL <= #1 1'b1;
            sSDA <= #1 1'b1;

            dSCL <= #1 1'b1;
            dSDA <= #1 1'b1;
        end else begin
            sSCL <= #1 &fSCL[2:1] | &fSCL[1:0] | (fSCL[2] & fSCL[0]);
            sSDA <= #1 &fSDA[2:1] | &fSDA[1:0] | (fSDA[2] & fSDA[0]);

            dSCL <= #1 sSCL;
            dSDA <= #1 sSDA;
        end

    // detect start condition => detect falling edge on SDA while SCL is high
    // detect stop condition => detect rising edge on SDA while SCL is high
    reg sta_condition;
    reg sto_condition;
    always @(posedge clk or negedge nReset)
        if (~nReset) begin
            sta_condition <= #1 1'b0;
            sto_condition <= #1 1'b0;
        end else if (rst) begin
            sta_condition <= #1 1'b0;
            sto_condition <= #1 1'b0;
        end else begin
            sta_condition <= #1 ~sSDA & dSDA & sSCL;
            sto_condition <= #1 sSDA & ~dSDA & sSCL;
        end


    // generate i2c bus busy signal
    always @(posedge clk or negedge nReset)
        if (!nReset) busy <= #1 1'b0;
        else if (rst) busy <= #1 1'b0;
        else busy <= #1 (sta_condition | busy) & ~sto_condition;


    // generate arbitration lost signal
    // aribitration lost when:
    // 1) master drives SDA high, but the i2c bus is low
    // 2) stop detected while not requested
    reg cmd_stop;
    always @(posedge clk or negedge nReset)
        if (~nReset) cmd_stop <= #1 1'b0;
        else if (rst) cmd_stop <= #1 1'b0;
        else if (clk_en) cmd_stop <= #1 cmd == `I2C_CMD_STOP;

    always @(posedge clk or negedge nReset)
        if (~nReset) al <= #1 1'b0;
        else if (rst) al <= #1 1'b0;
        else al <= #1 (sda_chk & ~sSDA & sda_oen) | (|c_state & sto_condition & ~cmd_stop);


    // generate dout signal (store SDA on rising edge of SCL)
    always @(posedge clk) if (sSCL & ~dSCL) dout <= #1 sSDA;


    // generate statemachine

    // nxt_state decoder
    parameter [17:0] idle = 18'b0_0000_0000_0000_0000;
    parameter [17:0] start_a = 18'b0_0000_0000_0000_0001;
    parameter [17:0] start_b = 18'b0_0000_0000_0000_0010;
    parameter [17:0] start_c = 18'b0_0000_0000_0000_0100;
    parameter [17:0] start_d = 18'b0_0000_0000_0000_1000;
    parameter [17:0] start_e = 18'b0_0000_0000_0001_0000;
    parameter [17:0] stop_a = 18'b0_0000_0000_0010_0000;
    parameter [17:0] stop_b = 18'b0_0000_0000_0100_0000;
    parameter [17:0] stop_c = 18'b0_0000_0000_1000_0000;
    parameter [17:0] stop_d = 18'b0_0000_0001_0000_0000;
    parameter [17:0] rd_a = 18'b0_0000_0010_0000_0000;
    parameter [17:0] rd_b = 18'b0_0000_0100_0000_0000;
    parameter [17:0] rd_c = 18'b0_0000_1000_0000_0000;
    parameter [17:0] rd_d = 18'b0_0001_0000_0000_0000;
    parameter [17:0] wr_a = 18'b0_0010_0000_0000_0000;
    parameter [17:0] wr_b = 18'b0_0100_0000_0000_0000;
    parameter [17:0] wr_c = 18'b0_1000_0000_0000_0000;
    parameter [17:0] wr_d = 18'b1_0000_0000_0000_0000;

    always @(posedge clk or negedge nReset)
        if (!nReset) begin
            c_state <= #1 idle;
            cmd_ack <= #1 1'b0;
            scl_oen <= #1 1'b1;
            sda_oen <= #1 1'b1;
            sda_chk <= #1 1'b0;
        end else if (rst | al) begin
            c_state <= #1 idle;
            cmd_ack <= #1 1'b0;
            scl_oen <= #1 1'b1;
            sda_oen <= #1 1'b1;
            sda_chk <= #1 1'b0;
        end else begin
            cmd_ack <= #1 1'b0;  // default no command acknowledge + assert cmd_ack only 1clk cycle

            if (clk_en)
                case (c_state)  // synopsys full_case parallel_case
                    // idle state
                    idle: begin
                        case (cmd)  // synopsys full_case parallel_case
                            `I2C_CMD_START: c_state <= #1 start_a;
                            `I2C_CMD_STOP:  c_state <= #1 stop_a;
                            `I2C_CMD_WRITE: c_state <= #1 wr_a;
                            `I2C_CMD_READ:  c_state <= #1 rd_a;
                            default:        c_state <= #1 idle;
                        endcase

                        scl_oen <= #1 scl_oen;  // keep SCL in same state
                        sda_oen <= #1 sda_oen;  // keep SDA in same state
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    // start
                    start_a: begin
                        c_state <= #1 start_b;
                        scl_oen <= #1 scl_oen;  // keep SCL in same state
                        sda_oen <= #1 1'b1;  // set SDA high
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    start_b: begin
                        c_state <= #1 start_c;
                        scl_oen <= #1 1'b1;  // set SCL high
                        sda_oen <= #1 1'b1;  // keep SDA high
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    start_c: begin
                        c_state <= #1 start_d;
                        scl_oen <= #1 1'b1;  // keep SCL high
                        sda_oen <= #1 1'b0;  // set SDA low
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    start_d: begin
                        c_state <= #1 start_e;
                        scl_oen <= #1 1'b1;  // keep SCL high
                        sda_oen <= #1 1'b0;  // keep SDA low
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    start_e: begin
                        c_state <= #1 idle;
                        cmd_ack <= #1 1'b1;
                        scl_oen <= #1 1'b0;  // set SCL low
                        sda_oen <= #1 1'b0;  // keep SDA low
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    // stop
                    stop_a: begin
                        c_state <= #1 stop_b;
                        scl_oen <= #1 1'b0;  // keep SCL low
                        sda_oen <= #1 1'b0;  // set SDA low
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    stop_b: begin
                        c_state <= #1 stop_c;
                        scl_oen <= #1 1'b1;  // set SCL high
                        sda_oen <= #1 1'b0;  // keep SDA low
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    stop_c: begin
                        c_state <= #1 stop_d;
                        scl_oen <= #1 1'b1;  // keep SCL high
                        sda_oen <= #1 1'b0;  // keep SDA low
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    stop_d: begin
                        c_state <= #1 idle;
                        cmd_ack <= #1 1'b1;
                        scl_oen <= #1 1'b1;  // keep SCL high
                        sda_oen <= #1 1'b1;  // set SDA high
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    // read
                    rd_a: begin
                        c_state <= #1 rd_b;
                        scl_oen <= #1 1'b0;  // keep SCL low
                        sda_oen <= #1 1'b1;  // tri-state SDA
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    rd_b: begin
                        c_state <= #1 rd_c;
                        scl_oen <= #1 1'b1;  // set SCL high
                        sda_oen <= #1 1'b1;  // keep SDA tri-stated
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    rd_c: begin
                        c_state <= #1 rd_d;
                        scl_oen <= #1 1'b1;  // keep SCL high
                        sda_oen <= #1 1'b1;  // keep SDA tri-stated
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    rd_d: begin
                        c_state <= #1 idle;
                        cmd_ack <= #1 1'b1;
                        scl_oen <= #1 1'b0;  // set SCL low
                        sda_oen <= #1 1'b1;  // keep SDA tri-stated
                        sda_chk <= #1 1'b0;  // don't check SDA output
                    end

                    // write
                    wr_a: begin
                        c_state <= #1 wr_b;
                        scl_oen <= #1 1'b0;  // keep SCL low
                        sda_oen <= #1 din;  // set SDA
                        sda_chk <= #1 1'b0;  // don't check SDA output (SCL low)
                    end

                    wr_b: begin
                        c_state <= #1 wr_c;
                        scl_oen <= #1 1'b1;  // set SCL high
                        sda_oen <= #1 din;  // keep SDA
                        sda_chk <= #1 1'b0;  // don't check SDA output yet
                                             // allow some time for SDA and SCL to settle
                    end

                    wr_c: begin
                        c_state <= #1 wr_d;
                        scl_oen <= #1 1'b1;  // keep SCL high
                        sda_oen <= #1 din;
                        sda_chk <= #1 1'b1;  // check SDA output
                    end

                    wr_d: begin
                        c_state <= #1 idle;
                        cmd_ack <= #1 1'b1;
                        scl_oen <= #1 1'b0;  // set SCL low
                        sda_oen <= #1 din;
                        sda_chk <= #1 1'b0;  // don't check SDA output (SCL low)
                    end

                endcase
        end


    // assign scl and sda output (always gnd)
    assign scl_o = 1'b0;
    assign sda_o = 1'b0;

endmodule


module lut_ov5640_rgb565 #(
    parameter [11:0] HActive = 12'd800,
    parameter [11:0] VActive = 12'd600,
    parameter [12:0] HTotal = 13'd2200,
    parameter [12:0] VTotal = 13'd1000,
    parameter USE_4vs3_frame = "true"
) (
    input [9:0] lut_index,  //Look-up table address
    output reg [31:0] lut_data  //Device address (8bit I2C address), register address, register data
);

    generate
        always @(*) begin
            case (lut_index)
                10'd0: lut_data <= {8'h78, 24'h3008_02};
                10'd1: lut_data <= {8'h78, 24'h3103_02};
                10'd2: lut_data <= {8'h78, 24'h3017_ff};
                10'd3: lut_data <= {8'h78, 24'h3018_ff};
                10'd4: lut_data <= {8'h78, 24'h3037_13};
                10'd5: lut_data <= {8'h78, 24'h3108_01};
                10'd6: lut_data <= {8'h78, 24'h3630_36};
                10'd7: lut_data <= {8'h78, 24'h3631_0e};
                10'd8: lut_data <= {8'h78, 24'h3632_e2};
                10'd9: lut_data <= {8'h78, 24'h3633_12};
                10'd10: lut_data <= {8'h78, 24'h3621_e0};
                10'd11: lut_data <= {8'h78, 24'h3704_a0};
                10'd12: lut_data <= {8'h78, 24'h3703_5a};
                10'd13: lut_data <= {8'h78, 24'h3715_78};
                10'd14: lut_data <= {8'h78, 24'h3717_01};
                10'd15: lut_data <= {8'h78, 24'h370b_60};
                10'd16: lut_data <= {8'h78, 24'h3705_1a};
                10'd17: lut_data <= {8'h78, 24'h3905_02};
                10'd18: lut_data <= {8'h78, 24'h3906_10};
                10'd19: lut_data <= {8'h78, 24'h3901_0a};
                10'd20: lut_data <= {8'h78, 24'h3731_12};
                10'd21: lut_data <= {8'h78, 24'h3600_08};
                10'd22: lut_data <= {8'h78, 24'h3601_33};
                10'd23: lut_data <= {8'h78, 24'h302d_60};
                10'd24: lut_data <= {8'h78, 24'h3620_52};
                10'd25: lut_data <= {8'h78, 24'h371b_20};
                10'd26: lut_data <= {8'h78, 24'h471c_50};
                10'd27: lut_data <= {8'h78, 24'h3a13_43};
                10'd28: lut_data <= {8'h78, 24'h3a18_00};
                10'd29: lut_data <= {8'h78, 24'h3a19_f8};
                10'd30: lut_data <= {8'h78, 24'h3635_13};
                10'd31: lut_data <= {8'h78, 24'h3636_03};
                10'd32: lut_data <= {8'h78, 24'h3634_40};
                10'd33: lut_data <= {8'h78, 24'h3622_01};
                10'd34: lut_data <= {8'h78, 24'h3c01_34};
                10'd35: lut_data <= {8'h78, 24'h3c04_28};
                10'd36: lut_data <= {8'h78, 24'h3c05_98};
                10'd37: lut_data <= {8'h78, 24'h3c06_00};
                10'd38: lut_data <= {8'h78, 24'h3c07_07};
                10'd39: lut_data <= {8'h78, 24'h3c08_00};
                10'd40: lut_data <= {8'h78, 24'h3c09_1c};
                10'd41: lut_data <= {8'h78, 24'h3c0a_9c};
                10'd42: lut_data <= {8'h78, 24'h3c0b_40};
                10'd43: lut_data <= {8'h78, 24'h3810_00};
                10'd44: lut_data <= {8'h78, 24'h3811_10};
                10'd45: lut_data <= {8'h78, 24'h3812_00};
                10'd46: lut_data <= {8'h78, 24'h3708_64};
                10'd47: lut_data <= {8'h78, 24'h4001_02};
                10'd48: lut_data <= {8'h78, 24'h4005_1a};
                10'd49: lut_data <= {8'h78, 24'h3000_00};
                10'd50: lut_data <= {8'h78, 24'h3004_ff};
                10'd51: lut_data <= {8'h78, 24'h4300_61};
                10'd52: lut_data <= {8'h78, 24'h501f_01};
                10'd53: lut_data <= {8'h78, 24'h440e_00};
                10'd54: lut_data <= {8'h78, 24'h5000_a7};
                10'd55: lut_data <= {8'h78, 24'h3a0f_30};
                10'd56: lut_data <= {8'h78, 24'h3a10_28};
                10'd57: lut_data <= {8'h78, 24'h3a1b_30};
                10'd58: lut_data <= {8'h78, 24'h3a1e_26};
                10'd59: lut_data <= {8'h78, 24'h3a11_60};
                10'd60: lut_data <= {8'h78, 24'h3a1f_14};
                10'd61: lut_data <= {8'h78, 24'h5800_23};
                10'd62: lut_data <= {8'h78, 24'h5801_14};
                10'd63: lut_data <= {8'h78, 24'h5802_0f};
                10'd64: lut_data <= {8'h78, 24'h5803_0f};
                10'd65: lut_data <= {8'h78, 24'h5804_12};
                10'd66: lut_data <= {8'h78, 24'h5805_26};
                10'd67: lut_data <= {8'h78, 24'h5806_0c};
                10'd68: lut_data <= {8'h78, 24'h5807_08};
                10'd69: lut_data <= {8'h78, 24'h5808_05};
                10'd70: lut_data <= {8'h78, 24'h5809_05};
                10'd71: lut_data <= {8'h78, 24'h580a_08};
                10'd72: lut_data <= {8'h78, 24'h580b_0d};
                10'd73: lut_data <= {8'h78, 24'h580c_08};
                10'd74: lut_data <= {8'h78, 24'h580d_03};
                10'd75: lut_data <= {8'h78, 24'h580e_00};
                10'd76: lut_data <= {8'h78, 24'h580f_00};
                10'd77: lut_data <= {8'h78, 24'h5810_03};
                10'd78: lut_data <= {8'h78, 24'h5811_09};
                10'd79: lut_data <= {8'h78, 24'h5812_07};
                10'd80: lut_data <= {8'h78, 24'h5813_03};
                10'd81: lut_data <= {8'h78, 24'h5814_00};
                10'd82: lut_data <= {8'h78, 24'h5815_01};
                10'd83: lut_data <= {8'h78, 24'h5816_03};
                10'd84: lut_data <= {8'h78, 24'h5817_08};
                10'd85: lut_data <= {8'h78, 24'h5818_0d};
                10'd86: lut_data <= {8'h78, 24'h5819_08};
                10'd87: lut_data <= {8'h78, 24'h581a_05};
                10'd88: lut_data <= {8'h78, 24'h581b_06};
                10'd89: lut_data <= {8'h78, 24'h581c_08};
                10'd90: lut_data <= {8'h78, 24'h581d_0e};
                10'd91: lut_data <= {8'h78, 24'h581e_29};
                10'd92: lut_data <= {8'h78, 24'h581f_17};
                10'd93: lut_data <= {8'h78, 24'h5820_11};
                10'd94: lut_data <= {8'h78, 24'h5821_11};
                10'd95: lut_data <= {8'h78, 24'h5822_15};
                10'd96: lut_data <= {8'h78, 24'h5823_28};
                10'd97: lut_data <= {8'h78, 24'h5824_46};
                10'd98: lut_data <= {8'h78, 24'h5825_26};
                10'd99: lut_data <= {8'h78, 24'h5826_08};
                10'd100: lut_data <= {8'h78, 24'h5827_26};
                10'd101: lut_data <= {8'h78, 24'h5828_64};
                10'd102: lut_data <= {8'h78, 24'h5829_26};
                10'd103: lut_data <= {8'h78, 24'h582a_24};
                10'd104: lut_data <= {8'h78, 24'h582b_22};
                10'd105: lut_data <= {8'h78, 24'h582c_24};
                10'd106: lut_data <= {8'h78, 24'h582d_24};
                10'd107: lut_data <= {8'h78, 24'h582e_06};
                10'd108: lut_data <= {8'h78, 24'h582f_22};
                10'd109: lut_data <= {8'h78, 24'h5830_40};
                10'd110: lut_data <= {8'h78, 24'h5831_42};
                10'd111: lut_data <= {8'h78, 24'h5832_24};
                10'd112: lut_data <= {8'h78, 24'h5833_26};
                10'd113: lut_data <= {8'h78, 24'h5834_24};
                10'd114: lut_data <= {8'h78, 24'h5835_22};
                10'd115: lut_data <= {8'h78, 24'h5836_22};
                10'd116: lut_data <= {8'h78, 24'h5837_26};
                10'd117: lut_data <= {8'h78, 24'h5838_44};
                10'd118: lut_data <= {8'h78, 24'h5839_24};
                10'd119: lut_data <= {8'h78, 24'h583a_26};
                10'd120: lut_data <= {8'h78, 24'h583b_28};
                10'd121: lut_data <= {8'h78, 24'h583c_42};
                10'd122: lut_data <= {8'h78, 24'h583d_ce};
                10'd123: lut_data <= {8'h78, 24'h5180_ff};
                10'd124: lut_data <= {8'h78, 24'h5181_f2};
                10'd125: lut_data <= {8'h78, 24'h5182_00};
                10'd126: lut_data <= {8'h78, 24'h5183_14};
                10'd127: lut_data <= {8'h78, 24'h5184_25};
                10'd128: lut_data <= {8'h78, 24'h5185_24};
                10'd129: lut_data <= {8'h78, 24'h5186_09};
                10'd130: lut_data <= {8'h78, 24'h5187_09};
                10'd131: lut_data <= {8'h78, 24'h5188_09};
                10'd132: lut_data <= {8'h78, 24'h5189_75};
                10'd133: lut_data <= {8'h78, 24'h518a_54};
                10'd134: lut_data <= {8'h78, 24'h518b_e0};
                10'd135: lut_data <= {8'h78, 24'h518c_b2};
                10'd136: lut_data <= {8'h78, 24'h518d_42};
                10'd137: lut_data <= {8'h78, 24'h518e_3d};
                10'd138: lut_data <= {8'h78, 24'h518f_56};
                10'd139: lut_data <= {8'h78, 24'h5190_46};
                10'd140: lut_data <= {8'h78, 24'h5191_f8};
                10'd141: lut_data <= {8'h78, 24'h5192_04};
                10'd142: lut_data <= {8'h78, 24'h5193_70};
                10'd143: lut_data <= {8'h78, 24'h5194_f0};
                10'd144: lut_data <= {8'h78, 24'h5195_f0};
                10'd145: lut_data <= {8'h78, 24'h5196_03};
                10'd146: lut_data <= {8'h78, 24'h5197_01};
                10'd147: lut_data <= {8'h78, 24'h5198_04};
                10'd148: lut_data <= {8'h78, 24'h5199_12};
                10'd149: lut_data <= {8'h78, 24'h519a_04};
                10'd150: lut_data <= {8'h78, 24'h519b_00};
                10'd151: lut_data <= {8'h78, 24'h519c_06};
                10'd152: lut_data <= {8'h78, 24'h519d_82};
                10'd153: lut_data <= {8'h78, 24'h519e_38};
                10'd154: lut_data <= {8'h78, 24'h5480_01};
                10'd155: lut_data <= {8'h78, 24'h5481_08};
                10'd156: lut_data <= {8'h78, 24'h5482_14};
                10'd157: lut_data <= {8'h78, 24'h5483_28};
                10'd158: lut_data <= {8'h78, 24'h5484_51};
                10'd159: lut_data <= {8'h78, 24'h5485_65};
                10'd160: lut_data <= {8'h78, 24'h5486_71};
                10'd161: lut_data <= {8'h78, 24'h5487_7d};
                10'd162: lut_data <= {8'h78, 24'h5488_87};
                10'd163: lut_data <= {8'h78, 24'h5489_91};
                10'd164: lut_data <= {8'h78, 24'h548a_9a};
                10'd165: lut_data <= {8'h78, 24'h548b_aa};
                10'd166: lut_data <= {8'h78, 24'h548c_b8};
                10'd167: lut_data <= {8'h78, 24'h548d_cd};
                10'd168: lut_data <= {8'h78, 24'h548e_dd};
                10'd169: lut_data <= {8'h78, 24'h548f_ea};
                10'd170: lut_data <= {8'h78, 24'h5490_1d};
                10'd171: lut_data <= {8'h78, 24'h5381_1e};
                10'd172: lut_data <= {8'h78, 24'h5382_5b};
                10'd173: lut_data <= {8'h78, 24'h5383_08};
                10'd174: lut_data <= {8'h78, 24'h5384_0a};
                10'd175: lut_data <= {8'h78, 24'h5385_7e};
                10'd176: lut_data <= {8'h78, 24'h5386_88};
                10'd177: lut_data <= {8'h78, 24'h5387_7c};
                10'd178: lut_data <= {8'h78, 24'h5388_6c};
                10'd179: lut_data <= {8'h78, 24'h5389_10};
                10'd180: lut_data <= {8'h78, 24'h538a_01};
                10'd181: lut_data <= {8'h78, 24'h538b_98};
                10'd182: lut_data <= {8'h78, 24'h5580_06};
                10'd183: lut_data <= {8'h78, 24'h5583_40};
                10'd184: lut_data <= {8'h78, 24'h5584_10};
                10'd185: lut_data <= {8'h78, 24'h5589_10};
                10'd186: lut_data <= {8'h78, 24'h558a_00};
                10'd187: lut_data <= {8'h78, 24'h558b_f8};
                10'd188: lut_data <= {8'h78, 24'h501d_40};
                10'd189: lut_data <= {8'h78, 24'h5300_08};
                10'd190: lut_data <= {8'h78, 24'h5301_30};
                10'd191: lut_data <= {8'h78, 24'h5302_10};
                10'd192: lut_data <= {8'h78, 24'h5303_00};
                10'd193: lut_data <= {8'h78, 24'h5304_08};
                10'd194: lut_data <= {8'h78, 24'h5305_30};
                10'd195: lut_data <= {8'h78, 24'h5306_08};
                10'd196: lut_data <= {8'h78, 24'h5307_16};
                10'd197: lut_data <= {8'h78, 24'h5309_08};
                10'd198: lut_data <= {8'h78, 24'h530a_30};
                10'd199: lut_data <= {8'h78, 24'h530b_04};
                10'd200: lut_data <= {8'h78, 24'h530c_06};
                10'd201: lut_data <= {8'h78, 24'h5025_00};
                //系统时钟分频
                // 10'd202: lut_data <= {8'h78, 24'h3035_11};  //41:15fps, 21:30Fps, 11:60Fps
                // 10'd202: lut_data <= {8'h78, 24'h3035_21};  //41:15fps, 21:30Fps, 11:60Fps
                10'd202: lut_data <= {8'h78, 24'h3035_41};  //41:15fps, 21:30Fps, 11:60Fps
                10'd203:
                if (USE_4vs3_frame == "true")
                    lut_data <= {8'h78, 24'h3036_72};  //PLL倍频 , 800x600(0x5A)
                else lut_data <= {8'h78, 24'h3036_69};  //PLL倍频 , 1280x720(0x69)
                10'd204: lut_data <= {8'h78, 24'h3c07_08};
                10'd205: lut_data <= {8'h78, 24'h3820_41};  //Sensor vflip, 47=N, 41=T
                10'd206: lut_data <= {8'h78, 24'h3821_07};  //Sensor mirror, 01=N, 07=T
                10'd207: lut_data <= {8'h78, 24'h3814_31};  // timing X inc
                10'd208: lut_data <= {8'h78, 24'h3815_31};  // timing Y inc
                10'd209: lut_data <= {8'h78, 24'h3800_00};  //TIMING HS start
                10'd210: lut_data <= {8'h78, 24'h3801_00};
                10'd211: lut_data <= {8'h78, 24'h3802_00};
                10'd212:
                if (USE_4vs3_frame == "true") lut_data <= {8'h78, 24'h3803_04};  //4:3 use 04
                else lut_data <= {8'h78, 24'h3803_fa};  //16:9 use fa
                10'd213: lut_data <= {8'h78, 24'h3804_0a};
                10'd214: lut_data <= {8'h78, 24'h3805_3f};
                10'd215:
                if (USE_4vs3_frame == "true") lut_data <= {8'h78, 24'h3806_07};  //4:3 use 07
                else lut_data <= {8'h78, 24'h3806_06};  //16:9 use 06
                10'd216:
                if (USE_4vs3_frame == "true") lut_data <= {8'h78, 24'h3807_9b};  //4:3 use 9b
                else lut_data <= {8'h78, 24'h3807_a9};  //16:9 use a9
                //10'd216: lut_data <= {8'h78 , 24'h3807_a9}; //4:3 use 9b
                10'd217:
                lut_data <= {
                    8'h78, {16'h3808, 4'd0, HActive[11:8]}
                };  //DVP 输出水平像素点数高4位
                10'd218:
                lut_data <= {
                    8'h78, {16'h3809, HActive[7:0]}
                };  //DVP 输出水平像素点数低8位
                10'd219:
                lut_data <= {
                    8'h78, {16'h380a, 4'd0, VActive[11:8]}
                };  //DVP 输出垂直像素点数高3位
                10'd220:
                lut_data <= {
                    8'h78, {16'h380b, VActive[7:0]}
                };  //DVP 输出垂直像素点数低8位
                10'd221:
                lut_data <= {8'h78, {16'h380c, 3'd0, HTotal[12:8]}};  //水平总像素大小高5位
                10'd222:
                lut_data <= {8'h78, {16'h380d, HTotal[7:0]}};  //水平总像素大小低8位
                10'd223:
                lut_data <= {8'h78, {16'h380e, 3'd0, VTotal[12:8]}};  //垂直总像素大小高5位
                10'd224:
                lut_data <= {8'h78, {16'h380f, VTotal[7:0]}};  //垂直总像素大小低8位
                10'd225:
                if (USE_4vs3_frame == "true") lut_data <= {8'h78, 24'h3813_06};  //4:3 use 06
                else lut_data <= {8'h78, 24'h3813_04};  //16:9 use 04
                //10'd225: lut_data <= {8'h78 , 24'h3813_04};	//4:3 use 06
                10'd226: lut_data <= {8'h78, 24'h3618_00};
                10'd227: lut_data <= {8'h78, 24'h3612_29};
                10'd228: lut_data <= {8'h78, 24'h3709_52};
                10'd229: lut_data <= {8'h78, 24'h370c_03};
                10'd230: lut_data <= {8'h78, 24'h3a02_17};
                10'd231: lut_data <= {8'h78, 24'h3a03_10};
                10'd232: lut_data <= {8'h78, 24'h3a14_17};
                10'd233: lut_data <= {8'h78, 24'h3a15_10};
                10'd234: lut_data <= {8'h78, 24'h4004_02};
                10'd235: lut_data <= {8'h78, 24'h4713_03};
                10'd236: lut_data <= {8'h78, 24'h4407_04};
                10'd237: lut_data <= {8'h78, 24'h460c_20};
                10'd238: lut_data <= {8'h78, 24'h4837_22};
                10'd239: lut_data <= {8'h78, 24'h3824_02};
                10'd240:
                if (USE_4vs3_frame == "true") lut_data <= {8'h78, 24'h5001_a3};
                else lut_data <= {8'h78, 24'h5001_83};
                10'd241: lut_data <= {8'h78, 24'h3b07_0a};
                //彩条测试使能
                10'd242: lut_data <= {8'h78, 24'h503d_00};  //0x00:正常模式 0x80:彩条显示
                // 10'd242: lut_data <= {8'h78, 24'h503d_80};  //0x00:正常模式 0x80:彩条显示
                //闪光灯禁用
                10'd243: lut_data <= {8'h78, 24'h3016_00};  //Disable
                10'd244: lut_data <= {8'h78, 24'h301c_00};
                10'd245: lut_data <= {8'h78, 24'h3019_00};  //关闭闪光灯
                10'd246: lut_data <= {8'h78, 24'h3031_08};  //Bypass regulator
                10'd247: lut_data <= {8'h78, 24'h302c_C2};  //output drive 4x
                10'd248: lut_data <= {8'hff, 24'hffff_ff};
                default: lut_data <= {8'h00, 24'h0000_00};
            endcase
        end
    endgenerate

endmodule
