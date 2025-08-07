module AHBDMA (
    input  clk,
    input  memory_clk,
    input  video_clk,
    input  rst_n,
    input  DDR_pll_lock,
    output pll_stop,

    // video input
    input        vi_clk,
    input        vi_vs,
    input        vi_de,
    input [15:0] vi_data,

    // ddr interface
    output [16-1:0] ddr_addr,     // ROW_WIDTH=16
    output [ 3-1:0] ddr_bank,     // BANK_WIDTH=3
    output          ddr_cs,
    output          ddr_ras,
    output          ddr_cas,
    output          ddr_we,
    output          ddr_ck,
    output          ddr_ck_n,
    output          ddr_cke,
    output          ddr_odt,
    output          ddr_reset_n,
    output [ 4-1:0] ddr_dm,       // DM_WIDTH=4
    inout  [32-1:0] ddr_dq,       // DQ_WIDTH=32
    inout  [ 4-1:0] ddr_dqs,      // DQS_WIDTH=4
    inout  [ 4-1:0] ddr_dqs_n,    // DQS_WIDTH=4

    // video output
    input         vo_vs,
    input         vo_de,
    output        video_de,
    output [15:0] video_data
);

    // SRAM parameters
    `define USE_THREE_FRAME_BUFFER
    parameter ADDR_WIDTH     = 29;   // 存储单元是byte，总容量=2^29*16bit = 8Gbit,增加1位rank地址，{rank[0],bank[2:0],row[15:0],cloumn[9:0]}
    parameter DATA_WIDTH     = 256;  // 与生成DDR3IP有关，此ddr3 4Gbit, x32， 时钟比例1:4 ，则固定256bit
    parameter WR_VIDEO_WIDTH = 32;
    parameter RD_VIDEO_WIDTH = 32;

    // memory interface
    wire                    dma_clk;
    wire                    cmd_ready;
    wire [             2:0] cmd;
    wire                    cmd_en;
    // wire[5:0]              app_burst_number   ;
    wire [  ADDR_WIDTH-1:0] addr;
    wire                    wr_data_rdy;
    wire                    wr_data_en;
    wire                    wr_data_end;
    wire [  DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH/8-1:0] wr_data_mask;
    wire                    rd_data_valid;
    wire                    rd_data_end;  // unused
    wire [  DATA_WIDTH-1:0] rd_data;
    wire                    init_calib_complete;

    Frame_Buffer Frame_Buffer (
        .I_rst_n         (init_calib_complete),
        .I_dma_clk       (dma_clk),
`ifdef USE_THREE_FRAME_BUFFER
        .I_wr_halt       (1'd0),                 // 1:halt,  0:no halt
        .I_rd_halt       (1'd0),                 // 1:halt,  0:no halt
`endif
        // video data input
        .I_vin0_clk      (vi_clk),
        .I_vin0_vs_n     (~vi_vs),              // 只接收负极性
        .I_vin0_de       (vi_de),
        .I_vin0_data     (vi_data),
        .O_vin0_fifo_full(),

        // video data output
        .I_vout0_clk          (video_clk),
        .I_vout0_vs_n         (~vo_vs),            // 只接收负极性
        .I_vout0_de           (vo_de),
        .O_vout0_den          (video_de),
        .O_vout0_data         (video_data),
        .O_vout0_fifo_empty   (),
        // ddr write request
        .I_cmd_ready          (cmd_ready),
        .O_cmd                (cmd),                 // 0:write;  1:read
        .O_cmd_en             (cmd_en),
        //    .O_app_burst_number   (app_burst_number   ),
        .O_addr               (addr),                // [ADDR_WIDTH-1:0]
        .I_wr_data_rdy        (wr_data_rdy),
        .O_wr_data_en         (wr_data_en),
        .O_wr_data_end        (wr_data_end),
        .O_wr_data            (wr_data),             // [DATA_WIDTH-1:0]
        .O_wr_data_mask       (wr_data_mask),
        .I_rd_data_valid      (rd_data_valid),
        .I_rd_data_end        (rd_data_end),         // unused
        .I_rd_data            (rd_data),             // [DATA_WIDTH-1:0]
        .I_init_calib_complete(init_calib_complete)
    );

    DDR3MI DDR3MI (
        .clk                (clk),
        .memory_clk         (memory_clk),
        .pll_stop           (pll_stop),
        .pll_lock           (DDR_pll_lock),
        .rst_n              (rst_n),
        //    .app_burst_number   (app_burst_number   ),
        .cmd_ready          (cmd_ready),
        .cmd                (cmd),
        .cmd_en             (cmd_en),
        .addr               (addr),
        .wr_data_rdy        (wr_data_rdy),
        .wr_data            (wr_data),
        .wr_data_en         (wr_data_en),
        .wr_data_end        (wr_data_end),
        .wr_data_mask       (wr_data_mask),
        .rd_data            (rd_data),
        .rd_data_valid      (rd_data_valid),
        .rd_data_end        (rd_data_end),
        .sr_req             (1'b0),
        .ref_req            (1'b0),
        .sr_ack             (),
        .ref_ack            (),
        .init_calib_complete(init_calib_complete),
        .clk_out            (dma_clk),
        .burst              (1'b1),
        // mem interface
        .ddr_rst            (),
        .O_ddr_addr         (ddr_addr),
        .O_ddr_ba           (ddr_bank),
        .O_ddr_cs_n         (ddr_cs),
        .O_ddr_ras_n        (ddr_ras),
        .O_ddr_cas_n        (ddr_cas),
        .O_ddr_we_n         (ddr_we),
        .O_ddr_clk          (ddr_ck),
        .O_ddr_clk_n        (ddr_ck_n),
        .O_ddr_cke          (ddr_cke),
        .O_ddr_odt          (ddr_odt),
        .O_ddr_reset_n      (ddr_reset_n),
        .O_ddr_dqm          (ddr_dm),
        .IO_ddr_dq          (ddr_dq),
        .IO_ddr_dqs         (ddr_dqs),
        .IO_ddr_dqs_n       (ddr_dqs_n)
    );

endmodule
