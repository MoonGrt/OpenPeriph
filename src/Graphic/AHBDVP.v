module AhbDVP #(
    parameter H_DISP = 12'd1280,
    parameter V_DISP = 12'd720
) (
    // AHB interface
    input  wire        io_ahb_PCLK,
    input  wire        io_ahb_PRESET,
    input  wire [ 3:0] io_ahb_PADDR,
    input  wire [ 0:0] io_ahb_PSEL,
    input  wire        io_ahb_PENABLE,
    output wire        io_ahb_PREADY,
    input  wire        io_ahb_PWRITE,
    input  wire [31:0] io_ahb_PWDATA,
    output reg  [31:0] io_ahb_PRDATA,
    output wire        io_ahb_PSLVERROR,

    // Clock
    input  wire cmos_clk,
    input  wire serial_clk,
    input  wire video_clk,
    input  wire clk_vp,
    input  wire TMDS_DDR_pll_lock,

    // CAM interface
    output [2:0] i2c_sel,
    inout        cmos_scl,    // cmos i2c clock
    inout        cmos_sda,    // cmos i2c data
    input        cmos_vsync,  // cmos vsync
    input        cmos_href,   // cmos hsync refrence,data valid
    input        cmos_pclk,   // cmos pxiel clock
    output       cmos_xclk,   // cmos externl clock
    input  [7:0] cmos_db,     // cmos data
    output       cmos_rst_n,  // cmos reset
    output       cmos_pwdn,   // cmos power down
    // HDMI IN
    input  wire        HDMI_clk,    // HDMI clock
    input  wire        HDMI_vs,     // HDMI vertical sync
    input  wire        HDMI_de,     // HDMI data enable
    input  wire [15:0] HDMI_data,   // HDMI data
    // Video output interface
    output wire        vp_clk,
    output wire        vp_vs,
    output wire        vp_de,
    output wire [15:0] vp_data,
    // Video input interface
    output wire        vo_de,
    output wire        vo_vs,
    input  wire        video_de,
    input  wire [15:0] video_data,
    // HDMI interface
    output       tmds_clk_n_0,
    output       tmds_clk_p_0,
    output [2:0] tmds_d_n_0,  // {r,g,b}
    output [2:0] tmds_d_p_0,
    // LCD interface
    output       lcd_clk,
    output       lcd_en,
    output [5:0] lcd_r,
    output [5:0] lcd_b,
    output [5:0] lcd_g
);

    // DVP寄存器定义
    reg [31:0] VI_CR;
    reg [31:0] VI_SR;
    reg [31:0] VP_CR;
    reg [31:0] VP_SR;
    reg [31:0] VP_START;
    reg [31:0] VP_END;
    reg [31:0] VP_SCALER;
    reg [31:0] VP_THRESHOLD;
    reg [31:0] VO_CR;
    reg [31:0] VO_SR;

    // DVP Config 接口定义
    // VI
    wire       VI_EN = VI_CR[0];  // VI使能
    wire [1:0] VI_MODE = VI_CR[2:1];  // VI模式 00: test模式 01: camera模式 10: hdmi模式 11: 未定义
    // VP
    wire       VP_EN = VP_CR[0];  // VP使能
    // VO
    wire       VO_EN = VO_CR[0];  // VO使能
    wire [1:0] VO_MODE = VO_CR[2:1];  // VO模式 00: HDMI输出 01: RGB输出 10: 未定义 11: 未定义

    // AHB 写寄存器逻辑
    assign io_ahb_PREADY = 1'b1;  // AHB 准备信号始终为高，表示设备始终准备好
    assign io_ahb_PSLVERROR = 1'b0;  // AHB 错误信号始终为低，表示无错误
    always @(posedge io_ahb_PCLK or posedge io_ahb_PRESET) begin
        if (io_ahb_PRESET) begin
            VI_CR <= 32'h00000000;
            VP_CR <= 32'h00000000;
            VP_START <= 32'h00000000;
            VP_END <= 32'h00000000;
            VP_SCALER <= 32'h00000000;
            VP_THRESHOLD <= 32'h00000000;
            VO_CR <= 32'h00000000;
        end else begin
            if (io_ahb_PSEL && io_ahb_PENABLE && io_ahb_PWRITE) begin
                // 写寄存器
                case (io_ahb_PADDR)  // 假设基地址为0x00，寄存器偏移4字节
                    4'd0:  VI_CR <= io_ahb_PWDATA;
                    4'd2:  VP_CR <= io_ahb_PWDATA;
                    4'd4:  VP_START <= io_ahb_PWDATA;
                    4'd5:  VP_END <= io_ahb_PWDATA;
                    4'd6:  VP_SCALER <= io_ahb_PWDATA;
                    4'd7:  VP_THRESHOLD <= io_ahb_PWDATA;
                    4'd8:  VO_CR <= io_ahb_PWDATA;
                    default: ;  // 其他寄存器不处理
                endcase
            end
        end
    end
    // AHB 读寄存器逻辑
    always @(*) begin
        if (io_ahb_PRESET) io_ahb_PRDATA = 32'h00000000;
        else if (io_ahb_PSEL && io_ahb_PENABLE && ~io_ahb_PWRITE) begin
            case (io_ahb_PADDR)
                4'd0: io_ahb_PRDATA = VI_CR;
                4'd1: io_ahb_PRDATA = VI_SR;
                4'd2: io_ahb_PRDATA = VP_CR;
                4'd3: io_ahb_PRDATA = VP_SR;
                4'd4: io_ahb_PRDATA = VP_START;
                4'd5: io_ahb_PRDATA = VP_END;
                4'd6: io_ahb_PRDATA = VP_SCALER;
                4'd7: io_ahb_PRDATA = VP_THRESHOLD;
                4'd8: io_ahb_PRDATA = VO_CR;
                4'd9: io_ahb_PRDATA = VO_SR;
                default: io_ahb_PRDATA = 32'h00000000;  // 默认返回0
            endcase
        end
    end


    wire clk = io_ahb_PCLK;
    wire rst_n = ~io_ahb_PRESET;

    // video interface
    wire        vi_clk;
    wire        vi_vs;
    wire        vi_de;
    wire [15:0] vi_data;

    // 视频输入模块
    AHBVI AHBVI (
        .clk      (clk),
        .cmos_clk (cmos_clk),
        .video_clk(video_clk),
        .rst_n    (rst_n),
        .mode     (VI_MODE),
        // Camera interface
        .i2c_sel (i2c_sel),
        .cmos_scl(cmos_scl),
        .cmos_sda(cmos_sda),
        .cmos_vsync(cmos_vsync),
        .cmos_href (cmos_href),
        .cmos_pclk (cmos_pclk),
        .cmos_db   (cmos_db),
        .cmos_xclk (cmos_xclk),
        .cmos_rst_n(cmos_rst_n),
        .cmos_pwdn (cmos_pwdn),
        // HDMI IN
        .HDMI_clk  (HDMI_clk),
        .HDMI_vs   (HDMI_vs),
        .HDMI_de   (HDMI_de),
        .HDMI_data (HDMI_data),
        // Video interface
        .vi_clk (vi_clk),
        .vi_vs  (vi_vs),
        .vi_de  (vi_de),
        .vi_data(vi_data)
    );

    // 视频处理模块
    AHBVP #(
        .H_DISP(H_DISP),
        .V_DISP(V_DISP)
    ) AHBVP (
        .clk_vp(clk_vp),
        .rst_n (rst_n),

        .vi_clk (vi_clk),
        .vi_vs  (vi_vs),
        .vi_de  (vi_de),
        .vi_data(vi_data),

        .VP_CR       (VP_CR),
        .VP_START    (VP_START),
        .VP_END      (VP_END),
        .VP_SCALER   (VP_SCALER),
        .VP_THRESHOLD(VP_THRESHOLD),

        .vp_clk (vp_clk),
        .vp_vs  (vp_vs),
        .vp_de  (vp_de),
        .vp_data(vp_data)
    );

    // 视频输出模块
    AHBVO AHBVO (
        .video_clk        (video_clk),
        .serial_clk       (serial_clk),
        .rst_n            (rst_n),
        .TMDS_DDR_pll_lock(TMDS_DDR_pll_lock),

        // 向 ddr 请求数据
        .vo_vs   (vo_vs),
        .vo_de   (vo_de),
        // ddr 输出数据
        .video_data(video_data),
        .video_de  (video_de),
        // TMDS 输出接口
        .tmds_clk_n_0(tmds_clk_n_0),
        .tmds_clk_p_0(tmds_clk_p_0),
        .tmds_d_n_0  (tmds_d_n_0),
        .tmds_d_p_0  (tmds_d_p_0),
        // LCD interface
        .lcd_clk     (lcd_clk),
        .lcd_en      (lcd_en),
        .lcd_r       (lcd_r),
        .lcd_b       (lcd_b),
        .lcd_g       (lcd_g)
    );

endmodule
