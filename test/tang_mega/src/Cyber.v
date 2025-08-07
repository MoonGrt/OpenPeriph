`timescale 1ns / 1ps
`define SYNTHESIS

module Cyber (
    // Clock and Reset
    input  wire clk,
    input  wire rst_n,
    // JTAG
    input  wire io_jtag_tms,
    input  wire io_jtag_tdi,
    output wire io_jtag_tdo,
    input  wire io_jtag_tck,
    // GPIO
    // output wire [3:0] state_led,
    inout wire [15:0] GPIOA,  // GPIO
    inout wire [15:0] GPIOB,  // GPIO
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
    // DDR3 interface
    output [16-1:0] ddr_addr,  // ROW_WIDTH=16
    output [ 3-1:0] ddr_bank,  // BANK_WIDTH=3
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
    // HDMI interface
    output       tmds_clk_n_0,
    output       tmds_clk_p_0,
    output [2:0] tmds_d_n_0,    // {r,g,b}
    output [2:0] tmds_d_p_0,
    input        tmds_clk_n_1,
    input        tmds_clk_p_1,
    input  [2:0] tmds_d_n_1,    // {r,g,b}
    input  [2:0] tmds_d_p_1,
    // LCD interface
    output       lcd_clk,
    output       lcd_en,
    output [5:0] lcd_r,
    output [5:0] lcd_b,
    output [5:0] lcd_g
);

    wire io_mainClk = clk;
    wire io_asyncReset = ~rst_n;

    // wire [3:0] O_pll_phase;
    // assign state_led = O_pll_phase; // 状态指示灯

    /* GPIO AFIO */
    // USART
    wire USART1_TX;
    wire USART1_RX = GPIOB[1];
    wire USART2_TX;
    wire USART2_RX = GPIOB[3];
    // I2C
    wire I2C1_SDA;  // 有问题
    wire I2C1_SCL;
    wire I2C2_SDA;
    wire I2C2_SCL;
    // SPI
    wire SPI1_SCK;
    wire SPI1_MOSI;
    wire SPI1_MISO = GPIOB[10];
    wire SPI1_CS;
    wire SPI2_SCK;
    wire SPI2_MOSI;
    wire SPI2_MISO = GPIOB[14];
    wire SPI2_CS;
    // TIM
    wire [3:0] TIM1_CH;
    wire [3:0] TIM2_CH;
    // AFIO Contection
    wire [15:0] AFIOA = {TIM2_CH, TIM1_CH, 8'bz};
    wire [15:0] AFIOB = {SPI2_CS, 1'bz, SPI2_MOSI, SPI2_SCK, SPI1_CS, 1'bz, SPI1_MOSI, SPI1_SCK,
                         I2C2_SDA, I2C2_SCL, I2C1_SDA, I2C1_SCL, 1'bz, USART2_TX, 1'bz, USART1_TX};
    // Interrupt
    reg system_externalInterrupt, system_timerInterrupt;
    wire timer_interrupt, uart_interrupt;
    wire USART1_interrupt, USART2_interrupt;
    wire TIM1_interrupt, TIM2_interrupt;

    // RCC
    wire pll_stop;
    wire cmos_clk;
    wire serial_clk, video_clk;  // video pixel clock
    wire memory_clk;
    wire clk_vp;
    wire DDR_pll_lock, TMDS_DDR_pll_lock;
    wire GPIO_clk, GPIO_rst;
    wire USART_clk, USART_rst;
    wire SPI_clk, SPI_rst;
    wire I2C_clk, I2C_rst;
    wire TIM_clk, TIM_rst;
    wire WDG_clk, WDG_rst;

    // DMA
    wire        vp_clk;
    wire        vp_vs;
    wire        vp_de;
    wire [15:0] vp_data;
    // Video input interface
    wire        vo_de;
    wire        vo_vs;
    wire        video_de;
    wire [15:0] video_data;

    // AHB
    reg         system_ahbBridge_io_pipelinedMemoryBus_cmd_valid;
    wire        system_ahbBridge_io_pipelinedMemoryBus_cmd_ready;
    wire        system_ahbBridge_io_pipelinedMemoryBus_rsp_valid;
    wire [31:0] system_ahbBridge_io_pipelinedMemoryBus_rsp_payload_data;
    wire [19:0] system_ahbBridge_io_ahb_PADDR;
    wire [ 0:0] system_ahbBridge_io_ahb_PSEL;
    wire        system_ahbBridge_io_ahb_PENABLE;
    wire        system_ahbBridge_io_ahb_PWRITE;
    wire [31:0] system_ahbBridge_io_ahb_PWDATA;
    wire        io_ahb_decoder_io_input_PREADY;
    wire [31:0] io_ahb_decoder_io_input_PRDATA;
    wire        io_ahb_decoder_io_input_PSLVERROR;

    wire        system_rccCtrl_io_ahb_PREADY;  // RCC
    wire [31:0] system_rccCtrl_io_ahb_PRDATA;  // RCC
    wire        system_rccCtrl_io_ahb_PSLVERROR;  // RCC
    wire        system_dmaCtrl_io_ahb_PREADY;  // DMA
    wire [31:0] system_dmaCtrl_io_ahb_PRDATA;  // DMA
    wire        system_dmaCtrl_io_ahb_PSLVERROR;  // DMA
    wire        system_dvpCtrl_io_ahb_PREADY;  // DVP
    wire [31:0] system_dvpCtrl_io_ahb_PRDATA;  // DVP
    wire        system_dvpCtrl_io_ahb_PSLVERROR;  // DVP

    wire [19:0] ahbRouter_1_io_outputs_0_PADDR;  // RCC
    wire [ 0:0] ahbRouter_1_io_outputs_0_PSEL;  // RCC
    wire        ahbRouter_1_io_outputs_0_PENABLE;  // RCC
    wire        ahbRouter_1_io_outputs_0_PWRITE;  // RCC
    wire [31:0] ahbRouter_1_io_outputs_0_PWDATA;  // RCC
    wire [19:0] ahbRouter_1_io_outputs_1_PADDR;  // DMA
    wire [ 0:0] ahbRouter_1_io_outputs_1_PSEL;  // DMA
    wire        ahbRouter_1_io_outputs_1_PENABLE;  // DMA
    wire        ahbRouter_1_io_outputs_1_PWRITE;  // DMA
    wire [31:0] ahbRouter_1_io_outputs_1_PWDATA;  // DMA
    wire [19:0] ahbRouter_1_io_outputs_2_PADDR;  // DVP
    wire [ 0:0] ahbRouter_1_io_outputs_2_PSEL;  // DVP
    wire        ahbRouter_1_io_outputs_2_PENABLE;  // DVP
    wire        ahbRouter_1_io_outputs_2_PWRITE;  // DVP
    wire [31:0] ahbRouter_1_io_outputs_2_PWDATA;  // DVP

    wire [15:0] system_rccCtrl_io_ahb_PADDR;  // RCC PADDR
    wire [15:0] system_dmaCtrl_io_ahb_PADDR;  // DMA PADDR
    wire [ 3:0] system_dvpCtrl_io_ahb_PADDR;  // DVP PADDR
    assign system_rccCtrl_io_ahb_PADDR = ahbRouter_1_io_outputs_0_PADDR[15:2];  // RCC
    assign system_dmaCtrl_io_ahb_PADDR = ahbRouter_1_io_outputs_1_PADDR[15:2];  // DMA
    assign system_dvpCtrl_io_ahb_PADDR = ahbRouter_1_io_outputs_2_PADDR[ 5:2];  // DVP

    // APB
    reg         system_apbBridge_io_pipelinedMemoryBus_cmd_valid;
    wire        system_apbBridge_io_pipelinedMemoryBus_cmd_ready;
    wire        system_apbBridge_io_pipelinedMemoryBus_rsp_valid;
    wire [31:0] system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data;
    wire [19:0] system_apbBridge_io_apb_PADDR;
    wire [ 0:0] system_apbBridge_io_apb_PSEL;
    wire        system_apbBridge_io_apb_PENABLE;
    wire        system_apbBridge_io_apb_PWRITE;
    wire [31:0] system_apbBridge_io_apb_PWDATA;
    wire        io_apb_decoder_io_input_PREADY;
    wire [31:0] io_apb_decoder_io_input_PRDATA;
    wire        io_apb_decoder_io_input_PSLVERROR;
    wire [19:0] io_apb_decoder_io_output_PADDR;
    wire [ 2:0] io_apb_decoder_io_output_PSEL;
    wire        io_apb_decoder_io_output_PENABLE;
    wire        io_apb_decoder_io_output_PWRITE;
    wire [31:0] io_apb_decoder_io_output_PWDATA;

    wire        system_gpioCtrl_io_apb_PREADY;  // GPIO
    wire [31:0] system_gpioCtrl_io_apb_PRDATA;  // GPIO
    wire        system_gpioCtrl_io_apb_PSLVERROR;  // GPIO
    wire        system_wdgCtrl_io_apb_PREADY;  // WDG
    wire [31:0] system_wdgCtrl_io_apb_PRDATA;  // WDG
    wire        system_wdgCtrl_io_apb_PSLVERROR;  // WDG
    wire        system_usartCtrl_io_apb_PREADY;  // USART
    wire [31:0] system_usartCtrl_io_apb_PRDATA;  // USART
    wire        system_usartCtrl_io_apb_PSLVERROR;  // USART
    wire        system_i2cCtrl_io_apb_PREADY;  // I2C
    wire [31:0] system_i2cCtrl_io_apb_PRDATA;  // I2C
    wire        system_i2cCtrl_io_apb_PSLVERROR;  // I2C
    wire        system_spiCtrl_io_apb_PREADY;  // SPI
    wire [31:0] system_spiCtrl_io_apb_PRDATA;  // SPI
    wire        system_spiCtrl_io_apb_PSLVERROR;  // SPI
    wire        system_timCtrl_io_apb_PREADY;  // TIM
    wire [31:0] system_timCtrl_io_apb_PRDATA;  // TIM
    wire        system_timCtrl_io_apb_PSLVERROR;  // TIM

    wire [19:0] apb3Router_1_io_outputs_0_PADDR;  // GPIO
    wire [ 0:0] apb3Router_1_io_outputs_0_PSEL;  // GPIO
    wire        apb3Router_1_io_outputs_0_PENABLE;  // GPIO
    wire        apb3Router_1_io_outputs_0_PWRITE;  // GPIO
    wire [31:0] apb3Router_1_io_outputs_0_PWDATA;  // GPIO
    wire [19:0] apb3Router_1_io_outputs_1_PADDR;  // WDG
    wire [ 0:0] apb3Router_1_io_outputs_1_PSEL;  // WDG
    wire        apb3Router_1_io_outputs_1_PENABLE;  // WDG
    wire        apb3Router_1_io_outputs_1_PWRITE;  // WDG
    wire [31:0] apb3Router_1_io_outputs_1_PWDATA;  // WDG
    wire [19:0] apb3Router_1_io_outputs_2_PADDR;  // USART
    wire [ 0:0] apb3Router_1_io_outputs_2_PSEL;  // USART
    wire        apb3Router_1_io_outputs_2_PENABLE;  // USART
    wire        apb3Router_1_io_outputs_2_PWRITE;  // USART
    wire [31:0] apb3Router_1_io_outputs_2_PWDATA;  // USART
    wire [19:0] apb3Router_1_io_outputs_3_PADDR;  // I2C
    wire [ 0:0] apb3Router_1_io_outputs_3_PSEL;  // I2C
    wire        apb3Router_1_io_outputs_3_PENABLE;  // I2C
    wire        apb3Router_1_io_outputs_3_PWRITE;  // I2C
    wire [31:0] apb3Router_1_io_outputs_3_PWDATA;  // I2C
    wire [19:0] apb3Router_1_io_outputs_4_PADDR;  // SPI
    wire [ 0:0] apb3Router_1_io_outputs_4_PSEL;  // SPI
    wire        apb3Router_1_io_outputs_4_PENABLE;  // SPI
    wire        apb3Router_1_io_outputs_4_PWRITE;  // SPI
    wire [31:0] apb3Router_1_io_outputs_4_PWDATA;  // SPI
    wire [19:0] apb3Router_1_io_outputs_5_PADDR;  // TIM
    wire [ 0:0] apb3Router_1_io_outputs_5_PSEL;  // TIM
    wire        apb3Router_1_io_outputs_5_PENABLE;  // TIM
    wire        apb3Router_1_io_outputs_5_PWRITE;  // TIM
    wire [31:0] apb3Router_1_io_outputs_5_PWDATA;  // TIM

    wire [15:0] system_gpioCtrl_io_apb_PADDR;  // GPIO PADDR
    wire [15:0] system_wdgCtrl_io_apb_PADDR;  // WDG PADDR
    wire [15:0] system_usartCtrl_io_apb_PADDR;  // USART PADDR
    wire [15:0] system_i2cCtrl_io_apb_PADDR;  // I2C PADDR
    wire [15:0] system_spiCtrl_io_apb_PADDR;  // SPI PADDR
    wire [15:0] system_timCtrl_io_apb_PADDR;  // TIM PADDR
    assign system_gpioCtrl_io_apb_PADDR = apb3Router_1_io_outputs_0_PADDR[15:0];  // GPIO
    assign system_wdgCtrl_io_apb_PADDR = apb3Router_1_io_outputs_1_PADDR[15:0];  // WDG
    assign system_usartCtrl_io_apb_PADDR = apb3Router_1_io_outputs_2_PADDR[15:0];  // USART
    assign system_i2cCtrl_io_apb_PADDR = apb3Router_1_io_outputs_3_PADDR[15:0];  // I2C
    assign system_spiCtrl_io_apb_PADDR = apb3Router_1_io_outputs_4_PADDR[15:0];  // SPI
    assign system_timCtrl_io_apb_PADDR = apb3Router_1_io_outputs_5_PADDR[15:0];  // TIM



    wire [ 7:0] system_cpu_debug_bus_cmd_payload_address;
    wire        system_cpu_dBus_cmd_ready;
    reg         system_ram_io_bus_cmd_valid;
    wire [ 3:0] system_gpioACtrl_io_apb_PADDR;
    wire [ 4:0] system_uartCtrl_io_apb_PADDR;
    wire [ 7:0] system_timer_io_apb_PADDR;
    wire        io_asyncReset_buffercc_io_dataOut;
    wire        system_mainBusArbiter_io_iBus_cmd_ready;
    wire        system_mainBusArbiter_io_iBus_rsp_valid;
    wire        system_mainBusArbiter_io_iBus_rsp_payload_error;
    wire [31:0] system_mainBusArbiter_io_iBus_rsp_payload_inst;
    wire        system_mainBusArbiter_io_dBus_cmd_ready;
    wire        system_mainBusArbiter_io_dBus_rsp_ready;
    wire        system_mainBusArbiter_io_dBus_rsp_error;
    wire [31:0] system_mainBusArbiter_io_dBus_rsp_data;
    wire        system_mainBusArbiter_io_masterBus_cmd_valid;
    wire        system_mainBusArbiter_io_masterBus_cmd_payload_write;
    wire [31:0] system_mainBusArbiter_io_masterBus_cmd_payload_address;
    wire [31:0] system_mainBusArbiter_io_masterBus_cmd_payload_data;
    wire [ 3:0] system_mainBusArbiter_io_masterBus_cmd_payload_mask;
    wire        system_cpu_iBus_cmd_valid;
    wire [31:0] system_cpu_iBus_cmd_payload_pc;
    wire        system_cpu_debug_bus_cmd_ready;
    wire [31:0] system_cpu_debug_bus_rsp_data;
    wire        system_cpu_debug_resetOut;
    wire        system_cpu_dBus_cmd_valid;
    wire        system_cpu_dBus_cmd_payload_wr;
    wire [ 3:0] system_cpu_dBus_cmd_payload_mask;
    wire [31:0] system_cpu_dBus_cmd_payload_address;
    wire [31:0] system_cpu_dBus_cmd_payload_data;
    wire [ 1:0] system_cpu_dBus_cmd_payload_size;
    wire        jtagBridge_1_io_jtag_tdo;
    wire        jtagBridge_1_io_remote_cmd_valid;
    wire        jtagBridge_1_io_remote_cmd_payload_last;
    wire [ 0:0] jtagBridge_1_io_remote_cmd_payload_fragment;
    wire        jtagBridge_1_io_remote_rsp_ready;
    wire        systemDebugger_1_io_remote_cmd_ready;
    wire        systemDebugger_1_io_remote_rsp_valid;
    wire        systemDebugger_1_io_remote_rsp_payload_error;
    wire [31:0] systemDebugger_1_io_remote_rsp_payload_data;
    wire        systemDebugger_1_io_mem_cmd_valid;
    wire [31:0] systemDebugger_1_io_mem_cmd_payload_address;
    wire [31:0] systemDebugger_1_io_mem_cmd_payload_data;
    wire        systemDebugger_1_io_mem_cmd_payload_wr;
    wire [ 1:0] systemDebugger_1_io_mem_cmd_payload_size;
    wire        system_ram_io_bus_cmd_ready;
    wire        system_ram_io_bus_rsp_valid;
    wire [31:0] system_ram_io_bus_rsp_payload_data;
    reg  [31:0] _zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data;
    reg         resetCtrl_mainClkResetUnbuffered;
    reg  [ 5:0] resetCtrl_systemClkResetCounter;
    wire [ 5:0] _zz_when_Murax_l188;
    wire        when_Murax_l188;
    wire        when_Murax_l192;
    reg         resetCtrl_mainClkReset;
    reg         resetCtrl_systemReset;
    wire        toplevel_system_cpu_dBus_cmd_halfPipe_valid;
    wire        toplevel_system_cpu_dBus_cmd_halfPipe_ready;
    wire        toplevel_system_cpu_dBus_cmd_halfPipe_payload_wr;
    wire [ 3:0] toplevel_system_cpu_dBus_cmd_halfPipe_payload_mask;
    wire [31:0] toplevel_system_cpu_dBus_cmd_halfPipe_payload_address;
    wire [31:0] toplevel_system_cpu_dBus_cmd_halfPipe_payload_data;
    wire [ 1:0] toplevel_system_cpu_dBus_cmd_halfPipe_payload_size;
    reg         toplevel_system_cpu_dBus_cmd_rValid;
    wire        toplevel_system_cpu_dBus_cmd_halfPipe_fire;
    reg         toplevel_system_cpu_dBus_cmd_rData_wr;
    reg  [ 3:0] toplevel_system_cpu_dBus_cmd_rData_mask;
    reg  [31:0] toplevel_system_cpu_dBus_cmd_rData_address;
    reg  [31:0] toplevel_system_cpu_dBus_cmd_rData_data;
    reg  [ 1:0] toplevel_system_cpu_dBus_cmd_rData_size;
    reg         toplevel_system_cpu_debug_resetOut_regNext;
    wire        toplevel_system_cpu_debug_bus_cmd_fire;
    reg         toplevel_system_cpu_debug_bus_cmd_fire_regNext;
    wire        system_mainBusDecoder_logic_masterPipelined_cmd_valid;
    reg         system_mainBusDecoder_logic_masterPipelined_cmd_ready;
    wire        system_mainBusDecoder_logic_masterPipelined_cmd_payload_write;
    wire [31:0] system_mainBusDecoder_logic_masterPipelined_cmd_payload_address;
    wire [31:0] system_mainBusDecoder_logic_masterPipelined_cmd_payload_data;
    wire [ 3:0] system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask;
    wire        system_mainBusDecoder_logic_masterPipelined_rsp_valid;
    wire [31:0] system_mainBusDecoder_logic_masterPipelined_rsp_payload_data;
    wire        system_mainBusDecoder_logic_hits_0;
    wire        _zz_io_bus_cmd_payload_write;
    wire        system_mainBusDecoder_logic_hits_1;
    wire        system_mainBusDecoder_logic_hits_2;
    wire        _zz_io_pipelinedMemoryBus_cmd_payload_write;
    wire        system_mainBusDecoder_logic_noHit;
    reg         system_mainBusDecoder_logic_rspPending;
    wire        system_mainBusDecoder_logic_masterPipelined_cmd_fire;
    wire        when_MuraxUtiles_l127;
    reg         system_mainBusDecoder_logic_rspNoHit;
    reg  [ 0:0] system_mainBusDecoder_logic_rspSourceId;
    wire        when_MuraxUtiles_l133;

    (* keep_hierarchy = "TRUE" *) BufferCC_RST BufferCC_RST (
        .io_dataIn  (io_asyncReset                    ), // i
        .io_dataOut (io_asyncReset_buffercc_io_dataOut), // o
        .io_mainClk (io_mainClk                       )  // i
    );
    JtagBridge JtagBridge (
        .io_jtag_tms                    (io_jtag_tms                                      ), // i
        .io_jtag_tdi                    (io_jtag_tdi                                      ), // i
        .io_jtag_tdo                    (jtagBridge_1_io_jtag_tdo                         ), // o
        .io_jtag_tck                    (io_jtag_tck                                      ), // i
        .io_remote_cmd_valid            (jtagBridge_1_io_remote_cmd_valid                 ), // o
        .io_remote_cmd_ready            (systemDebugger_1_io_remote_cmd_ready             ), // i
        .io_remote_cmd_payload_last     (jtagBridge_1_io_remote_cmd_payload_last          ), // o
        .io_remote_cmd_payload_fragment (jtagBridge_1_io_remote_cmd_payload_fragment      ), // o
        .io_remote_rsp_valid            (systemDebugger_1_io_remote_rsp_valid             ), // i
        .io_remote_rsp_ready            (jtagBridge_1_io_remote_rsp_ready                 ), // o
        .io_remote_rsp_payload_error    (systemDebugger_1_io_remote_rsp_payload_error     ), // i
        .io_remote_rsp_payload_data     (systemDebugger_1_io_remote_rsp_payload_data[31:0]), // i
        .io_mainClk                     (io_mainClk                                       ), // i
        .resetCtrl_mainClkReset         (resetCtrl_mainClkReset                           )  // i
    );
    Debugger Debugger (
        .io_remote_cmd_valid            (jtagBridge_1_io_remote_cmd_valid                 ), // i
        .io_remote_cmd_ready            (systemDebugger_1_io_remote_cmd_ready             ), // o
        .io_remote_cmd_payload_last     (jtagBridge_1_io_remote_cmd_payload_last          ), // i
        .io_remote_cmd_payload_fragment (jtagBridge_1_io_remote_cmd_payload_fragment      ), // i
        .io_remote_rsp_valid            (systemDebugger_1_io_remote_rsp_valid             ), // o
        .io_remote_rsp_ready            (jtagBridge_1_io_remote_rsp_ready                 ), // i
        .io_remote_rsp_payload_error    (systemDebugger_1_io_remote_rsp_payload_error     ), // o
        .io_remote_rsp_payload_data     (systemDebugger_1_io_remote_rsp_payload_data[31:0]), // o
        .io_mem_cmd_valid               (systemDebugger_1_io_mem_cmd_valid                ), // o
        .io_mem_cmd_ready               (system_cpu_debug_bus_cmd_ready                   ), // i
        .io_mem_cmd_payload_address     (systemDebugger_1_io_mem_cmd_payload_address[31:0]), // o
        .io_mem_cmd_payload_data        (systemDebugger_1_io_mem_cmd_payload_data[31:0]   ), // o
        .io_mem_cmd_payload_wr          (systemDebugger_1_io_mem_cmd_payload_wr           ), // o
        .io_mem_cmd_payload_size        (systemDebugger_1_io_mem_cmd_payload_size[1:0]    ), // o
        .io_mem_rsp_valid               (toplevel_system_cpu_debug_bus_cmd_fire_regNext   ), // i
        .io_mem_rsp_payload             (system_cpu_debug_bus_rsp_data[31:0]              ), // i
        .io_mainClk                     (io_mainClk                                       ), // i
        .resetCtrl_mainClkReset         (resetCtrl_mainClkReset                           )  // i
    );
    VexRiscv VexRiscv (
        .iBus_cmd_valid                (system_cpu_iBus_cmd_valid                           ), // o
        .iBus_cmd_ready                (system_mainBusArbiter_io_iBus_cmd_ready             ), // i
        .iBus_cmd_payload_pc           (system_cpu_iBus_cmd_payload_pc[31:0]                ), // o
        .iBus_rsp_valid                (system_mainBusArbiter_io_iBus_rsp_valid             ), // i
        .iBus_rsp_payload_error        (system_mainBusArbiter_io_iBus_rsp_payload_error     ), // i
        .iBus_rsp_payload_inst         (system_mainBusArbiter_io_iBus_rsp_payload_inst[31:0]), // i
        .timerInterrupt                (system_timerInterrupt                               ), // i
        .externalInterrupt             (system_externalInterrupt                            ), // i
        .softwareInterrupt             (1'b0                                                ), // i
        .debug_bus_cmd_valid           (systemDebugger_1_io_mem_cmd_valid                   ), // i
        .debug_bus_cmd_ready           (system_cpu_debug_bus_cmd_ready                      ), // o
        .debug_bus_cmd_payload_wr      (systemDebugger_1_io_mem_cmd_payload_wr              ), // i
        .debug_bus_cmd_payload_address (system_cpu_debug_bus_cmd_payload_address[7:0]       ), // i
        .debug_bus_cmd_payload_data    (systemDebugger_1_io_mem_cmd_payload_data[31:0]      ), // i
        .debug_bus_rsp_data            (system_cpu_debug_bus_rsp_data[31:0]                 ), // o
        .debug_resetOut                (system_cpu_debug_resetOut                           ), // o
        .dBus_cmd_valid                (system_cpu_dBus_cmd_valid                           ), // o
        .dBus_cmd_ready                (system_cpu_dBus_cmd_ready                           ), // i
        .dBus_cmd_payload_wr           (system_cpu_dBus_cmd_payload_wr                      ), // o
        .dBus_cmd_payload_mask         (system_cpu_dBus_cmd_payload_mask[3:0]               ), // o
        .dBus_cmd_payload_address      (system_cpu_dBus_cmd_payload_address[31:0]           ), // o
        .dBus_cmd_payload_data         (system_cpu_dBus_cmd_payload_data[31:0]              ), // o
        .dBus_cmd_payload_size         (system_cpu_dBus_cmd_payload_size[1:0]               ), // o
        .dBus_rsp_ready                (system_mainBusArbiter_io_dBus_rsp_ready             ), // i
        .dBus_rsp_error                (system_mainBusArbiter_io_dBus_rsp_error             ), // i
        .dBus_rsp_data                 (system_mainBusArbiter_io_dBus_rsp_data[31:0]        ), // i
        .io_mainClk                    (io_mainClk                                          ), // i
        .resetCtrl_systemReset         (resetCtrl_systemReset                               ), // i
        .resetCtrl_mainClkReset        (resetCtrl_mainClkReset                              )  // i
    );
    MasterArbiter MasterArbiter (
        .io_iBus_cmd_valid                (system_cpu_iBus_cmd_valid                                         ), // i
        .io_iBus_cmd_ready                (system_mainBusArbiter_io_iBus_cmd_ready                           ), // o
        .io_iBus_cmd_payload_pc           (system_cpu_iBus_cmd_payload_pc[31:0]                              ), // i
        .io_iBus_rsp_valid                (system_mainBusArbiter_io_iBus_rsp_valid                           ), // o
        .io_iBus_rsp_payload_error        (system_mainBusArbiter_io_iBus_rsp_payload_error                   ), // o
        .io_iBus_rsp_payload_inst         (system_mainBusArbiter_io_iBus_rsp_payload_inst[31:0]              ), // o
        .io_dBus_cmd_valid                (toplevel_system_cpu_dBus_cmd_halfPipe_valid                       ), // i
        .io_dBus_cmd_ready                (system_mainBusArbiter_io_dBus_cmd_ready                           ), // o
        .io_dBus_cmd_payload_wr           (toplevel_system_cpu_dBus_cmd_halfPipe_payload_wr                  ), // i
        .io_dBus_cmd_payload_mask         (toplevel_system_cpu_dBus_cmd_halfPipe_payload_mask[3:0]           ), // i
        .io_dBus_cmd_payload_address      (toplevel_system_cpu_dBus_cmd_halfPipe_payload_address[31:0]       ), // i
        .io_dBus_cmd_payload_data         (toplevel_system_cpu_dBus_cmd_halfPipe_payload_data[31:0]          ), // i
        .io_dBus_cmd_payload_size         (toplevel_system_cpu_dBus_cmd_halfPipe_payload_size[1:0]           ), // i
        .io_dBus_rsp_ready                (system_mainBusArbiter_io_dBus_rsp_ready                           ), // o
        .io_dBus_rsp_error                (system_mainBusArbiter_io_dBus_rsp_error                           ), // o
        .io_dBus_rsp_data                 (system_mainBusArbiter_io_dBus_rsp_data[31:0]                      ), // o
        .io_masterBus_cmd_valid           (system_mainBusArbiter_io_masterBus_cmd_valid                      ), // o
        .io_masterBus_cmd_ready           (system_mainBusDecoder_logic_masterPipelined_cmd_ready             ), // i
        .io_masterBus_cmd_payload_write   (system_mainBusArbiter_io_masterBus_cmd_payload_write              ), // o
        .io_masterBus_cmd_payload_address (system_mainBusArbiter_io_masterBus_cmd_payload_address[31:0]      ), // o
        .io_masterBus_cmd_payload_data    (system_mainBusArbiter_io_masterBus_cmd_payload_data[31:0]         ), // o
        .io_masterBus_cmd_payload_mask    (system_mainBusArbiter_io_masterBus_cmd_payload_mask[3:0]          ), // o
        .io_masterBus_rsp_valid           (system_mainBusDecoder_logic_masterPipelined_rsp_valid             ), // i
        .io_masterBus_rsp_payload_data    (system_mainBusDecoder_logic_masterPipelined_rsp_payload_data[31:0]), // i
        .io_mainClk                       (io_mainClk                                                        ), // i
        .resetCtrl_systemReset            (resetCtrl_systemReset                                             )  // i
    );
    AhbBridge AhbBridge (
        .io_pipelinedMemoryBus_cmd_valid           (system_ahbBridge_io_pipelinedMemoryBus_cmd_valid                     ), // i
        .io_pipelinedMemoryBus_cmd_ready           (system_ahbBridge_io_pipelinedMemoryBus_cmd_ready                     ), // o
        .io_pipelinedMemoryBus_cmd_payload_write   (_zz_io_pipelinedMemoryBus_cmd_payload_write                          ), // i
        .io_pipelinedMemoryBus_cmd_payload_address (system_mainBusDecoder_logic_masterPipelined_cmd_payload_address[31:0]), // i
        .io_pipelinedMemoryBus_cmd_payload_data    (system_mainBusDecoder_logic_masterPipelined_cmd_payload_data[31:0]   ), // i
        .io_pipelinedMemoryBus_cmd_payload_mask    (system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask[3:0]    ), // i
        .io_pipelinedMemoryBus_rsp_valid           (system_ahbBridge_io_pipelinedMemoryBus_rsp_valid                     ), // o
        .io_pipelinedMemoryBus_rsp_payload_data    (system_ahbBridge_io_pipelinedMemoryBus_rsp_payload_data[31:0]        ), // o
        .io_ahb_PADDR                              (system_ahbBridge_io_ahb_PADDR[19:0]                                  ), // o
        .io_ahb_PSEL                               (system_ahbBridge_io_ahb_PSEL                                         ), // o
        .io_ahb_PENABLE                            (system_ahbBridge_io_ahb_PENABLE                                      ), // o
        .io_ahb_PREADY                             (io_ahb_decoder_io_input_PREADY                                       ), // i
        .io_ahb_PWRITE                             (system_ahbBridge_io_ahb_PWRITE                                       ), // o
        .io_ahb_PWDATA                             (system_ahbBridge_io_ahb_PWDATA[31:0]                                 ), // o
        .io_ahb_PRDATA                             (io_ahb_decoder_io_input_PRDATA[31:0]                                 ), // i
        .io_ahb_PSLVERROR                          (io_ahb_decoder_io_input_PSLVERROR                                    ), // i
        .io_mainClk                                (io_mainClk                                                           ), // i
        .resetCtrl_systemReset                     (resetCtrl_systemReset                                                )  // i
    );
    AhbPRouter AhbPRouter (
        .io_input_PADDR     (system_ahbBridge_io_ahb_PADDR[19:0]),    // i
        .io_input_PSEL      (system_ahbBridge_io_ahb_PSEL),           // i
        .io_input_PENABLE   (system_ahbBridge_io_ahb_PENABLE),        // i
        .io_input_PREADY    (io_ahb_decoder_io_input_PREADY),         // o
        .io_input_PWRITE    (system_ahbBridge_io_ahb_PWRITE),         // i
        .io_input_PWDATA    (system_ahbBridge_io_ahb_PWDATA[31:0]),   // i
        .io_input_PRDATA    (io_ahb_decoder_io_input_PRDATA[31:0]),   // o
        .io_input_PSLVERROR (io_ahb_decoder_io_input_PSLVERROR),      // o

        .io_outputs_0_PADDR    (ahbRouter_1_io_outputs_0_PADDR[19:0]),   // o RCC
        .io_outputs_0_PSEL     (ahbRouter_1_io_outputs_0_PSEL),          // o RCC
        .io_outputs_0_PENABLE  (ahbRouter_1_io_outputs_0_PENABLE),       // o RCC
        .io_outputs_0_PREADY   (system_rccCtrl_io_ahb_PREADY),           // i RCC
        .io_outputs_0_PWRITE   (ahbRouter_1_io_outputs_0_PWRITE),        // o RCC
        .io_outputs_0_PWDATA   (ahbRouter_1_io_outputs_0_PWDATA[31:0]),  // o RCC
        .io_outputs_0_PRDATA   (system_rccCtrl_io_ahb_PRDATA[31:0]),     // i RCC
        .io_outputs_0_PSLVERROR(system_rccCtrl_io_ahb_PSLVERROR),        // i RCC
        .io_outputs_1_PADDR    (ahbRouter_1_io_outputs_1_PADDR[19:0]),   // o DMA
        .io_outputs_1_PSEL     (ahbRouter_1_io_outputs_1_PSEL),          // o DMA
        .io_outputs_1_PENABLE  (ahbRouter_1_io_outputs_1_PENABLE),       // o DMA
        .io_outputs_1_PREADY   (system_dmaCtrl_io_ahb_PREADY),           // i DMA
        .io_outputs_1_PWRITE   (ahbRouter_1_io_outputs_1_PWRITE),        // o DMA
        .io_outputs_1_PWDATA   (ahbRouter_1_io_outputs_1_PWDATA[31:0]),  // o DMA
        .io_outputs_1_PRDATA   (system_dmaCtrl_io_ahb_PRDATA[31:0]),     // i DMA
        .io_outputs_1_PSLVERROR(system_dmaCtrl_io_ahb_PSLVERROR),        // i DMA
        .io_outputs_2_PADDR    (ahbRouter_1_io_outputs_2_PADDR[19:0]),   // o DVP
        .io_outputs_2_PSEL     (ahbRouter_1_io_outputs_2_PSEL),          // o DVP
        .io_outputs_2_PENABLE  (ahbRouter_1_io_outputs_2_PENABLE),       // o DVP
        .io_outputs_2_PREADY   (system_dvpCtrl_io_ahb_PREADY),           // i DVP
        .io_outputs_2_PWRITE   (ahbRouter_1_io_outputs_2_PWRITE),        // o DVP
        .io_outputs_2_PWDATA   (ahbRouter_1_io_outputs_2_PWDATA[31:0]),  // o DVP
        .io_outputs_2_PRDATA   (system_dvpCtrl_io_ahb_PRDATA[31:0]),     // i DVP
        .io_outputs_2_PSLVERROR(system_dvpCtrl_io_ahb_PSLVERROR),        // i DVP

        .io_mainClk            (io_mainClk),                             // i
        .resetCtrl_systemReset (resetCtrl_systemReset)                   // i
    );
    AhbRCC AhbRCC (
        .io_ahb_PCLK      (io_mainClk),                        // i
        .io_ahb_PRESET    (resetCtrl_systemReset),             // i
        .io_ahb_PADDR     (system_rccCtrl_io_ahb_PADDR),       // i
        .io_ahb_PSEL      (ahbRouter_1_io_outputs_0_PSEL),     // i
        .io_ahb_PENABLE   (ahbRouter_1_io_outputs_0_PENABLE),  // i
        .io_ahb_PREADY    (system_rccCtrl_io_ahb_PREADY),      // o
        .io_ahb_PWRITE    (ahbRouter_1_io_outputs_0_PWRITE),   // i
        .io_ahb_PWDATA    (ahbRouter_1_io_outputs_0_PWDATA),   // i
        .io_ahb_PRDATA    (system_rccCtrl_io_ahb_PRDATA),      // o
        .io_ahb_PSLVERROR (system_rccCtrl_io_ahb_PSLVERROR),   // o
        // AHB clk and reset
        .pll_stop         (pll_stop),           // o
        .cmos_clk         (cmos_clk),           // o
        .serial_clk       (serial_clk),         // o
        .video_clk        (video_clk),          // o
        .memory_clk       (memory_clk),         // o
        .clk_vp           (clk_vp),             // o
        .DDR_pll_lock     (DDR_pll_lock),       // o
        .TMDS_DDR_pll_lock(TMDS_DDR_pll_lock),  // o
        // APB clk and reset
        .GPIO_clk         (GPIO_clk),   // o
        .GPIO_rst         (GPIO_rst),   // o
        .USART_clk        (USART_clk),  // o
        .USART_rst        (USART_rst),  // o
        .SPI_clk          (SPI_clk),    // o
        .SPI_rst          (SPI_rst),    // o
        .I2C_clk          (I2C_clk),    // o
        .I2C_rst          (I2C_rst),    // o
        .TIM_clk          (TIM_clk),    // o
        .TIM_rst          (TIM_rst),    // o
        .WDG_clk          (WDG_clk),    // o
        .WDG_rst          (WDG_rst)     // o
    );
    AHBDMA AHBDMA (
        .clk         (io_mainClk),
        .memory_clk  (memory_clk),
        .rst_n       (~resetCtrl_systemReset),
        .DDR_pll_lock(DDR_pll_lock),
        .pll_stop    (pll_stop),

        .vi_clk (vp_clk),
        .vi_vs  (vp_vs),
        .vi_de  (vp_de),
        .vi_data(vp_data),

        .ddr_addr   (ddr_addr),
        .ddr_bank   (ddr_bank),
        .ddr_cs     (ddr_cs),
        .ddr_ras    (ddr_ras),
        .ddr_cas    (ddr_cas),
        .ddr_we     (ddr_we),
        .ddr_ck     (ddr_ck),
        .ddr_ck_n   (ddr_ck_n),
        .ddr_cke    (ddr_cke),
        .ddr_odt    (ddr_odt),
        .ddr_reset_n(ddr_reset_n),
        .ddr_dm     (ddr_dm),
        .ddr_dq     (ddr_dq),
        .ddr_dqs    (ddr_dqs),
        .ddr_dqs_n  (ddr_dqs_n),

        .video_clk (video_clk),
        .vo_vs     (vo_vs),
        .vo_de     (vo_de),
        .video_de  (video_de),
        .video_data(video_data)
    );
    EDID_PROM_Top EDID_PROM_Top (
        .I_clk  (clk),    //>= 5MHz, <=200MHz 
        .I_rst_n(rst_n),
        .I_scl  (cmos_scl),
        .IO_sda (cmos_sda)
    );
    wire HDMI_clk, HDMI_vs, HDMI_hs, HDMI_de;
    wire [7:0] HDMI_r, HDMI_g, HDMI_b;
    DVI_RX DVI_RX (
        .I_rst_n         (rst_n),
        .I_tmds_clk_p    (tmds_clk_p_1),      //input I_tmds_clk_p
        .I_tmds_clk_n    (tmds_clk_n_1),      //input I_tmds_clk_n
        .I_tmds_data_p   (tmds_d_p_1),        //input [2:0] I_tmds_data_p
        .I_tmds_data_n   (tmds_d_n_1),        //input [2:0] I_tmds_data_n
        .O_pll_phase     (O_pll_phase),       //output [3:0] O_pll_phase
        .O_pll_phase_lock(O_pll_phase_lock),  //output O_pll_phase_lock
        .O_rgb_clk       (HDMI_clk),          // output O_rgb_clk
        .O_rgb_vs        (HDMI_vs),           // output O_rgb_vs
        .O_rgb_hs        (HDMI_hs),           // output O_rgb_hs
        .O_rgb_de        (HDMI_de),           // output O_rgb_de
        .O_rgb_r         (HDMI_r),            // output [7:0] O_rgb_r
        .O_rgb_g         (HDMI_g),            // output [7:0] O_rgb_g
        .O_rgb_b         (HDMI_b)             // output [7:0] O_rgb_b
    );
    AhbDVP #(
        .H_DISP (12'd1280),
        .V_DISP (12'd720)
    ) AhbDVP (
        .io_ahb_PCLK     (io_mainClk),
        .io_ahb_PRESET   (resetCtrl_systemReset),
        .io_ahb_PADDR    (system_dvpCtrl_io_ahb_PADDR),
        .io_ahb_PSEL     (ahbRouter_1_io_outputs_2_PSEL),
        .io_ahb_PENABLE  (ahbRouter_1_io_outputs_2_PENABLE),
        .io_ahb_PREADY   (system_dvpCtrl_io_ahb_PREADY),
        .io_ahb_PWRITE   (ahbRouter_1_io_outputs_2_PWRITE),
        .io_ahb_PWDATA   (ahbRouter_1_io_outputs_2_PWDATA),
        .io_ahb_PRDATA   (system_dvpCtrl_io_ahb_PRDATA),
        .io_ahb_PSLVERROR(system_dvpCtrl_io_ahb_PSLVERROR),
        // clk
        .cmos_clk         (cmos_clk),
        .serial_clk       (serial_clk),
        .video_clk        (video_clk),
        .clk_vp           (clk_vp),
        .TMDS_DDR_pll_lock(TMDS_DDR_pll_lock),
        // CAM interface
        .i2c_sel   (i2c_sel),
        .cmos_scl  (cmos_scl),
        .cmos_sda  (cmos_sda),
        .cmos_vsync(cmos_vsync),
        .cmos_href (cmos_href),
        .cmos_pclk (cmos_pclk),
        .cmos_xclk (cmos_xclk),
        .cmos_db   (cmos_db),
        .cmos_rst_n(cmos_rst_n),
        .cmos_pwdn (cmos_pwdn),
        // HDMI IN
        .HDMI_clk  (HDMI_clk),
        .HDMI_vs   (HDMI_vs),
        .HDMI_de   (HDMI_de),
        .HDMI_data ({HDMI_r[7:3], HDMI_g[7:2], HDMI_b[7:3]}),
        // Video output
        .vp_clk (vp_clk),
        .vp_vs  (vp_vs),
        .vp_de  (vp_de),
        .vp_data(vp_data),
        // Video input
        .vo_vs     (vo_vs),
        .vo_de     (vo_de),
        .video_de  (video_de),
        .video_data(video_data),
        // HDMI interface
        .tmds_clk_n_0(tmds_clk_n_0),
        .tmds_clk_p_0(tmds_clk_p_0),
        .tmds_d_n_0  (tmds_d_n_0),
        .tmds_d_p_0  (tmds_d_p_0),
        // LCD interface
        .lcd_clk     (lcd_clk),
        .lcd_en      (lcd_en),
        .lcd_r       (lcd_r),
        .lcd_b       (lcd_b),
        .lcd_g       (lcd_)
    );
    Apb3Bridge Apb3Bridge (
        .io_pipelinedMemoryBus_cmd_valid           (system_apbBridge_io_pipelinedMemoryBus_cmd_valid                     ), // i
        .io_pipelinedMemoryBus_cmd_ready           (system_apbBridge_io_pipelinedMemoryBus_cmd_ready                     ), // o
        .io_pipelinedMemoryBus_cmd_payload_write   (_zz_io_pipelinedMemoryBus_cmd_payload_write                          ), // i
        .io_pipelinedMemoryBus_cmd_payload_address (system_mainBusDecoder_logic_masterPipelined_cmd_payload_address[31:0]), // i
        .io_pipelinedMemoryBus_cmd_payload_data    (system_mainBusDecoder_logic_masterPipelined_cmd_payload_data[31:0]   ), // i
        .io_pipelinedMemoryBus_cmd_payload_mask    (system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask[3:0]    ), // i
        .io_pipelinedMemoryBus_rsp_valid           (system_apbBridge_io_pipelinedMemoryBus_rsp_valid                     ), // o
        .io_pipelinedMemoryBus_rsp_payload_data    (system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data[31:0]        ), // o
        .io_apb_PADDR                              (system_apbBridge_io_apb_PADDR[19:0]                                  ), // o
        .io_apb_PSEL                               (system_apbBridge_io_apb_PSEL                                         ), // o
        .io_apb_PENABLE                            (system_apbBridge_io_apb_PENABLE                                      ), // o
        .io_apb_PREADY                             (io_apb_decoder_io_input_PREADY                                       ), // i
        .io_apb_PWRITE                             (system_apbBridge_io_apb_PWRITE                                       ), // o
        .io_apb_PWDATA                             (system_apbBridge_io_apb_PWDATA[31:0]                                 ), // o
        .io_apb_PRDATA                             (io_apb_decoder_io_input_PRDATA[31:0]                                 ), // i
        .io_apb_PSLVERROR                          (io_apb_decoder_io_input_PSLVERROR                                    ), // i
        .io_mainClk                                (io_mainClk                                                           ), // i
        .resetCtrl_systemReset                     (resetCtrl_systemReset                                                )  // i
    );
    Apb3RAM Apb3RAM (
        .io_bus_cmd_valid           (system_ram_io_bus_cmd_valid                                          ), // i
        .io_bus_cmd_ready           (system_ram_io_bus_cmd_ready                                          ), // o
        .io_bus_cmd_payload_write   (_zz_io_bus_cmd_payload_write                                         ), // i
        .io_bus_cmd_payload_address (system_mainBusDecoder_logic_masterPipelined_cmd_payload_address[31:0]), // i
        .io_bus_cmd_payload_data    (system_mainBusDecoder_logic_masterPipelined_cmd_payload_data[31:0]   ), // i
        .io_bus_cmd_payload_mask    (system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask[3:0]    ), // i
        .io_bus_rsp_valid           (system_ram_io_bus_rsp_valid                                          ), // o
        .io_bus_rsp_payload_data    (system_ram_io_bus_rsp_payload_data[31:0]                             ), // o
        .io_mainClk                 (io_mainClk                                                           ), // i
        .resetCtrl_systemReset      (resetCtrl_systemReset                                                )  // i
    );
    Apb3PRouter Apb3PRouter (
        .io_input_PADDR     (system_apbBridge_io_apb_PADDR[19:0]),    // i
        .io_input_PSEL      (system_apbBridge_io_apb_PSEL),           // i
        .io_input_PENABLE   (system_apbBridge_io_apb_PENABLE),        // i
        .io_input_PREADY    (io_apb_decoder_io_input_PREADY),         // o
        .io_input_PWRITE    (system_apbBridge_io_apb_PWRITE),         // i
        .io_input_PWDATA    (system_apbBridge_io_apb_PWDATA[31:0]),   // i
        .io_input_PRDATA    (io_apb_decoder_io_input_PRDATA[31:0]),   // o
        .io_input_PSLVERROR (io_apb_decoder_io_input_PSLVERROR),      // o

        .io_outputs_0_PADDR    (apb3Router_1_io_outputs_0_PADDR[19:0]),   // o GPIO
        .io_outputs_0_PSEL     (apb3Router_1_io_outputs_0_PSEL),          // o GPIO
        .io_outputs_0_PENABLE  (apb3Router_1_io_outputs_0_PENABLE),       // o GPIO
        .io_outputs_0_PREADY   (system_gpioCtrl_io_apb_PREADY),           // i GPIO
        .io_outputs_0_PWRITE   (apb3Router_1_io_outputs_0_PWRITE),        // o GPIO
        .io_outputs_0_PWDATA   (apb3Router_1_io_outputs_0_PWDATA[31:0]),  // o GPIO
        .io_outputs_0_PRDATA   (system_gpioCtrl_io_apb_PRDATA[31:0]),     // i GPIO
        .io_outputs_0_PSLVERROR(system_gpioCtrl_io_apb_PSLVERROR),        // i GPIO
        .io_outputs_1_PADDR    (apb3Router_1_io_outputs_1_PADDR[19:0]),   // o USART
        .io_outputs_1_PSEL     (apb3Router_1_io_outputs_1_PSEL),          // o USART
        .io_outputs_1_PENABLE  (apb3Router_1_io_outputs_1_PENABLE),       // o USART
        .io_outputs_1_PREADY   (system_usartCtrl_io_apb_PREADY),          // i USART
        .io_outputs_1_PWRITE   (apb3Router_1_io_outputs_1_PWRITE),        // o USART
        .io_outputs_1_PWDATA   (apb3Router_1_io_outputs_1_PWDATA[31:0]),  // o USART
        .io_outputs_1_PRDATA   (system_usartCtrl_io_apb_PRDATA[31:0]),    // i USART
        .io_outputs_1_PSLVERROR(system_usartCtrl_io_apb_PSLVERROR),       // i USART
        .io_outputs_2_PADDR    (apb3Router_1_io_outputs_2_PADDR[19:0]),   // o I2C
        .io_outputs_2_PSEL     (apb3Router_1_io_outputs_2_PSEL),          // o I2C
        .io_outputs_2_PENABLE  (apb3Router_1_io_outputs_2_PENABLE),       // o I2C
        .io_outputs_2_PREADY   (system_i2cCtrl_io_apb_PREADY),            // i I2C
        .io_outputs_2_PWRITE   (apb3Router_1_io_outputs_2_PWRITE),        // o I2C
        .io_outputs_2_PWDATA   (apb3Router_1_io_outputs_2_PWDATA[31:0]),  // o I2C
        .io_outputs_2_PRDATA   (system_i2cCtrl_io_apb_PRDATA[31:0]),      // i I2C
        .io_outputs_2_PSLVERROR(system_i2cCtrl_io_apb_PSLVERROR),         // i I2C
        .io_outputs_3_PADDR    (apb3Router_1_io_outputs_3_PADDR[19:0]),   // o SPI
        .io_outputs_3_PSEL     (apb3Router_1_io_outputs_3_PSEL),          // o SPI
        .io_outputs_3_PENABLE  (apb3Router_1_io_outputs_3_PENABLE),       // o SPI
        .io_outputs_3_PREADY   (system_spiCtrl_io_apb_PREADY),            // i SPI
        .io_outputs_3_PWRITE   (apb3Router_1_io_outputs_3_PWRITE),        // o SPI
        .io_outputs_3_PWDATA   (apb3Router_1_io_outputs_3_PWDATA[31:0]),  // o SPI
        .io_outputs_3_PRDATA   (system_spiCtrl_io_apb_PRDATA[31:0]),      // i SPI
        .io_outputs_3_PSLVERROR(system_spiCtrl_io_apb_PSLVERROR),         // i SPI
        .io_outputs_4_PADDR    (apb3Router_1_io_outputs_4_PADDR[19:0]),   // o TIM
        .io_outputs_4_PSEL     (apb3Router_1_io_outputs_4_PSEL),          // o TIM
        .io_outputs_4_PENABLE  (apb3Router_1_io_outputs_4_PENABLE),       // o TIM
        .io_outputs_4_PREADY   (system_timCtrl_io_apb_PREADY),            // i TIM
        .io_outputs_4_PWRITE   (apb3Router_1_io_outputs_4_PWRITE),        // o TIM
        .io_outputs_4_PWDATA   (apb3Router_1_io_outputs_4_PWDATA[31:0]),  // o TIM
        .io_outputs_4_PRDATA   (system_timCtrl_io_apb_PRDATA[31:0]),      // i TIM
        .io_outputs_4_PSLVERROR(system_timCtrl_io_apb_PSLVERROR),         // i TIM
        .io_outputs_5_PADDR    (apb3Router_1_io_outputs_5_PADDR[19:0]),   // o WDG
        .io_outputs_5_PSEL     (apb3Router_1_io_outputs_5_PSEL),          // o WDG
        .io_outputs_5_PENABLE  (apb3Router_1_io_outputs_5_PENABLE),       // o WDG
        .io_outputs_5_PREADY   (system_wdgCtrl_io_apb_PREADY),            // i WDG
        .io_outputs_5_PWRITE   (apb3Router_1_io_outputs_5_PWRITE),        // o WDG
        .io_outputs_5_PWDATA   (apb3Router_1_io_outputs_5_PWDATA[31:0]),  // o WDG
        .io_outputs_5_PRDATA   (system_wdgCtrl_io_apb_PRDATA[31:0]),      // i WDG
        .io_outputs_5_PSLVERROR(system_wdgCtrl_io_apb_PSLVERROR),         // i WDG

        .io_mainClk            (io_mainClk),                              // i
        .resetCtrl_systemReset (resetCtrl_systemReset)                    // i
    );
    Apb3GPIORouter Apb3GPIORouter (
        .io_apb_PCLK          (GPIO_clk),                                    // i
        .io_apb_PRESET        (GPIO_rst),                                    // i
        .io_apb_PADDR         (system_gpioCtrl_io_apb_PADDR),                // i
        .io_apb_PSEL          (apb3Router_1_io_outputs_0_PSEL),              // i
        .io_apb_PENABLE       (apb3Router_1_io_outputs_0_PENABLE),           // i
        .io_apb_PREADY        (system_gpioCtrl_io_apb_PREADY),               // o
        .io_apb_PWRITE        (apb3Router_1_io_outputs_0_PWRITE),            // i
        .io_apb_PWDATA        (apb3Router_1_io_outputs_0_PWDATA),            // i
        .io_apb_PRDATA        (system_gpioCtrl_io_apb_PRDATA),               // o
        .io_apb_PSLVERROR     (system_gpioCtrl_io_apb_PSLVERROR),            // o
        .AFIOA                (AFIOA),                                       // i
        .GPIOA                (GPIOA),                                       // io
        .AFIOB                (AFIOB),                                       // i
        .GPIOB                (GPIOB)                                        // io
    );
    Apb3USARTRouter Apb3USARTRouter (
        .io_apb_PCLK          (USART_clk),                                   // i
        .io_apb_PRESET        (USART_rst),                                   // i
        .io_apb_PADDR         (system_usartCtrl_io_apb_PADDR),               // i
        .io_apb_PSEL          (apb3Router_1_io_outputs_1_PSEL),              // i
        .io_apb_PENABLE       (apb3Router_1_io_outputs_1_PENABLE),           // i
        .io_apb_PREADY        (system_usartCtrl_io_apb_PREADY),              // o
        .io_apb_PWRITE        (apb3Router_1_io_outputs_1_PWRITE),            // i
        .io_apb_PWDATA        (apb3Router_1_io_outputs_1_PWDATA),            // i
        .io_apb_PRDATA        (system_usartCtrl_io_apb_PRDATA),              // o
        .io_apb_PSLVERROR     (system_usartCtrl_io_apb_PSLVERROR),           // o
        .USART1_RX            (USART1_RX),                                   // i
        .USART1_TX            (USART1_TX),                                   // o
        .USART1_interrupt     (USART1_interrupt),                            // o  // USART interrupt
        .USART2_RX            (USART2_RX),                                   // i
        .USART2_TX            (USART2_TX),                                   // o
        .USART2_interrupt     (USART2_interrupt)                             // o
    );
    Apb3I2CRouter Apb3I2CRouter (
        .io_apb_PCLK          (I2C_clk),                                     // i
        .io_apb_PRESET        (I2C_rst),                                     // i
        .io_apb_PADDR         (system_i2cCtrl_io_apb_PADDR),                 // i
        .io_apb_PSEL          (apb3Router_1_io_outputs_2_PSEL),              // i
        .io_apb_PENABLE       (apb3Router_1_io_outputs_2_PENABLE),           // i
        .io_apb_PREADY        (system_i2cCtrl_io_apb_PREADY),                // o
        .io_apb_PWRITE        (apb3Router_1_io_outputs_2_PWRITE),            // i
        .io_apb_PWDATA        (apb3Router_1_io_outputs_2_PWDATA),            // i
        .io_apb_PRDATA        (system_i2cCtrl_io_apb_PRDATA),                // o
        .io_apb_PSLVERROR     (system_i2cCtrl_io_apb_PSLVERROR),             // o
        .I2C1_SDA             (I2C1_SDA),                                    // i
        .I2C1_SCL             (I2C1_SCL),                                    // o
        .I2C1_interrupt       (),                                            // o  // SPI interrupt
        .I2C2_SDA             (I2C1_SDA),                                    // i
        .I2C2_SCL             (I2C2_SCL),                                    // o
        .I2C2_interrupt       ()                                             // o
    );
    Apb3SPIRouter Apb3SPIRouter (
        .io_apb_PCLK          (SPI_clk),                                     // i
        .io_apb_PRESET        (SPI_rst),                                     // i
        .io_apb_PADDR         (system_spiCtrl_io_apb_PADDR),                 // i
        .io_apb_PSEL          (apb3Router_1_io_outputs_3_PSEL),              // i
        .io_apb_PENABLE       (apb3Router_1_io_outputs_3_PENABLE),           // i
        .io_apb_PREADY        (system_spiCtrl_io_apb_PREADY),                // o
        .io_apb_PWRITE        (apb3Router_1_io_outputs_3_PWRITE),            // i
        .io_apb_PWDATA        (apb3Router_1_io_outputs_3_PWDATA),            // i
        .io_apb_PRDATA        (system_spiCtrl_io_apb_PRDATA),                // o
        .io_apb_PSLVERROR     (system_spiCtrl_io_apb_PSLVERROR),             // o
        .SPI1_SCK             (SPI1_SCK),                                    // o
        .SPI1_MOSI            (SPI1_MOSI),                                   // o
        .SPI1_MISO            (SPI1_MISO),                                   // i
        .SPI1_CS              (SPI1_CS),                                     // o
        .SPI1_interrupt       (),                                            // o  // SPI interrupt
        .SPI2_SCK             (SPI2_SCK),                                    // o
        .SPI2_MOSI            (SPI2_MOSI),                                   // o
        .SPI2_MISO            (SPI2_MISO),                                   // i
        .SPI2_CS              (SPI2_CS),                                     // o
        .SPI2_interrupt       ()                                             // o
    );
    Apb3TIMRouter Apb3TIMRouter (
        .io_apb_PCLK          (TIM_clk),                                     // i
        .io_apb_PRESET        (TIM_rst),                                     // i
        .io_apb_PADDR         (system_timCtrl_io_apb_PADDR),                 // i
        .io_apb_PSEL          (apb3Router_1_io_outputs_4_PSEL),              // i
        .io_apb_PENABLE       (apb3Router_1_io_outputs_4_PENABLE),           // i
        .io_apb_PREADY        (system_timCtrl_io_apb_PREADY),                // o
        .io_apb_PWRITE        (apb3Router_1_io_outputs_4_PWRITE),            // i
        .io_apb_PWDATA        (apb3Router_1_io_outputs_4_PWDATA),            // i
        .io_apb_PRDATA        (system_timCtrl_io_apb_PRDATA),                // o
        .io_apb_PSLVERROR     (system_timCtrl_io_apb_PSLVERROR),             // o
        .TIM1_CH              (TIM1_CH),                                     // o
        .TIM1_interrupt       (TIM1_interrupt),                              // o  // TIM interrupt
        .TIM2_CH              (TIM2_CH),                                     // o
        .TIM2_interrupt       (TIM2_interrupt)                               // o
    );
    Apb3WDGRouter Apb3WDGRouter (
        .io_apb_PCLK          (WDG_clk),                                     // i
        .io_apb_PRESET        (WDG_rst),                                     // i
        .io_apb_PADDR         (system_wdgCtrl_io_apb_PADDR),                 // i
        .io_apb_PSEL          (apb3Router_1_io_outputs_5_PSEL),              // i
        .io_apb_PENABLE       (apb3Router_1_io_outputs_5_PENABLE),           // i
        .io_apb_PREADY        (system_wdgCtrl_io_apb_PREADY),                // o
        .io_apb_PWRITE        (apb3Router_1_io_outputs_5_PWRITE),            // i
        .io_apb_PWDATA        (apb3Router_1_io_outputs_5_PWDATA),            // i
        .io_apb_PRDATA        (system_wdgCtrl_io_apb_PRDATA),                // o
        .io_apb_PSLVERROR     (system_wdgCtrl_io_apb_PSLVERROR),             // o
        .IWDG_rst             (),                                            // o
        .WWDG_rst             ()                                             // o
    );

    initial begin
        resetCtrl_systemClkResetCounter = 6'h0;
    end

    always @(*) begin
        case (system_mainBusDecoder_logic_rspSourceId)
            1'b0:
            _zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data = system_ram_io_bus_rsp_payload_data;
            default:
            _zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data = system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data;
        endcase
    end

    always @(*) begin
        resetCtrl_mainClkResetUnbuffered = 1'b0;
        if (when_Murax_l188) begin
            resetCtrl_mainClkResetUnbuffered = 1'b1;
        end
    end

    assign _zz_when_Murax_l188[5 : 0] = 6'h3f;
    assign when_Murax_l188 = (resetCtrl_systemClkResetCounter != _zz_when_Murax_l188);
    assign when_Murax_l192 = io_asyncReset_buffercc_io_dataOut;
    always @(*) begin
        system_timerInterrupt = 1'b0;
        if (TIM1_interrupt | TIM2_interrupt) begin
            system_timerInterrupt = 1'b1;
        end
    end

    always @(*) begin
        system_externalInterrupt = 1'b0;
        if (USART1_interrupt | USART2_interrupt) begin
            system_externalInterrupt = 1'b1;
        end
    end

    assign toplevel_system_cpu_dBus_cmd_halfPipe_fire = (toplevel_system_cpu_dBus_cmd_halfPipe_valid && toplevel_system_cpu_dBus_cmd_halfPipe_ready);
    assign system_cpu_dBus_cmd_ready = (!toplevel_system_cpu_dBus_cmd_rValid);
    assign toplevel_system_cpu_dBus_cmd_halfPipe_valid = toplevel_system_cpu_dBus_cmd_rValid;
    assign toplevel_system_cpu_dBus_cmd_halfPipe_payload_wr = toplevel_system_cpu_dBus_cmd_rData_wr;
    assign toplevel_system_cpu_dBus_cmd_halfPipe_payload_mask = toplevel_system_cpu_dBus_cmd_rData_mask;
    assign toplevel_system_cpu_dBus_cmd_halfPipe_payload_address = toplevel_system_cpu_dBus_cmd_rData_address;
    assign toplevel_system_cpu_dBus_cmd_halfPipe_payload_data = toplevel_system_cpu_dBus_cmd_rData_data;
    assign toplevel_system_cpu_dBus_cmd_halfPipe_payload_size = toplevel_system_cpu_dBus_cmd_rData_size;
    assign toplevel_system_cpu_dBus_cmd_halfPipe_ready = system_mainBusArbiter_io_dBus_cmd_ready;
    assign system_cpu_debug_bus_cmd_payload_address = systemDebugger_1_io_mem_cmd_payload_address[7:0];
    assign toplevel_system_cpu_debug_bus_cmd_fire = (systemDebugger_1_io_mem_cmd_valid && system_cpu_debug_bus_cmd_ready);
    assign io_jtag_tdo = jtagBridge_1_io_jtag_tdo;
    assign system_mainBusDecoder_logic_masterPipelined_cmd_valid = system_mainBusArbiter_io_masterBus_cmd_valid;
    assign system_mainBusDecoder_logic_masterPipelined_cmd_payload_write = system_mainBusArbiter_io_masterBus_cmd_payload_write;
    assign system_mainBusDecoder_logic_masterPipelined_cmd_payload_address = system_mainBusArbiter_io_masterBus_cmd_payload_address;
    assign system_mainBusDecoder_logic_masterPipelined_cmd_payload_data = system_mainBusArbiter_io_masterBus_cmd_payload_data;
    assign system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask = system_mainBusArbiter_io_masterBus_cmd_payload_mask;
    assign system_mainBusDecoder_logic_hits_0 = ((system_mainBusDecoder_logic_masterPipelined_cmd_payload_address & (~ 32'h0003ffff)) == 32'h80000000);
    always @(*) begin
        system_ram_io_bus_cmd_valid = (system_mainBusDecoder_logic_masterPipelined_cmd_valid && system_mainBusDecoder_logic_hits_0);
        if (when_MuraxUtiles_l133) begin
            system_ram_io_bus_cmd_valid = 1'b0;
        end
    end

    assign _zz_io_bus_cmd_payload_write = system_mainBusDecoder_logic_masterPipelined_cmd_payload_write;
    assign system_mainBusDecoder_logic_hits_1 = ((system_mainBusDecoder_logic_masterPipelined_cmd_payload_address & (~ 32'h000fffff)) == 32'hf0000000);
    always @(*) begin
        system_apbBridge_io_pipelinedMemoryBus_cmd_valid = (system_mainBusDecoder_logic_masterPipelined_cmd_valid && system_mainBusDecoder_logic_hits_1);
        if (when_MuraxUtiles_l133) begin
            system_apbBridge_io_pipelinedMemoryBus_cmd_valid = 1'b0;
        end
    end

    assign system_mainBusDecoder_logic_hits_2 = ((system_mainBusDecoder_logic_masterPipelined_cmd_payload_address & (~ 32'h000fffff)) == 32'hf1000000);
    always @(*) begin
        system_ahbBridge_io_pipelinedMemoryBus_cmd_valid = (system_mainBusDecoder_logic_masterPipelined_cmd_valid && system_mainBusDecoder_logic_hits_2);
        if (when_MuraxUtiles_l133) begin
            system_ahbBridge_io_pipelinedMemoryBus_cmd_valid = 1'b0;
        end
    end

    assign _zz_io_pipelinedMemoryBus_cmd_payload_write = system_mainBusDecoder_logic_masterPipelined_cmd_payload_write;
    assign system_mainBusDecoder_logic_noHit = (! (|{system_mainBusDecoder_logic_hits_1,system_mainBusDecoder_logic_hits_0}));
    always @(*) begin
        system_mainBusDecoder_logic_masterPipelined_cmd_ready = ((|{(system_mainBusDecoder_logic_hits_1 && system_apbBridge_io_pipelinedMemoryBus_cmd_ready),(system_mainBusDecoder_logic_hits_0 && system_ram_io_bus_cmd_ready)}) || system_mainBusDecoder_logic_noHit);
        if (when_MuraxUtiles_l133) begin
            system_mainBusDecoder_logic_masterPipelined_cmd_ready = 1'b0;
        end
    end

    assign system_mainBusDecoder_logic_masterPipelined_cmd_fire = (system_mainBusDecoder_logic_masterPipelined_cmd_valid && system_mainBusDecoder_logic_masterPipelined_cmd_ready);
    assign when_MuraxUtiles_l127 = (system_mainBusDecoder_logic_masterPipelined_cmd_fire && (! system_mainBusDecoder_logic_masterPipelined_cmd_payload_write));
    assign system_mainBusDecoder_logic_masterPipelined_rsp_valid = ((|{system_apbBridge_io_pipelinedMemoryBus_rsp_valid,system_ram_io_bus_rsp_valid}) || (system_mainBusDecoder_logic_rspPending && system_mainBusDecoder_logic_rspNoHit));
    assign system_mainBusDecoder_logic_masterPipelined_rsp_payload_data = _zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data;
    assign when_MuraxUtiles_l133 = (system_mainBusDecoder_logic_rspPending && (! system_mainBusDecoder_logic_masterPipelined_rsp_valid));
    always @(posedge io_mainClk) begin
        if (when_Murax_l188) begin
            resetCtrl_systemClkResetCounter <= (resetCtrl_systemClkResetCounter + 6'h01);
        end
        if (when_Murax_l192) begin
            resetCtrl_systemClkResetCounter <= 6'h0;
        end
    end

    always @(posedge io_mainClk) begin
        resetCtrl_mainClkReset <= resetCtrl_mainClkResetUnbuffered;
        resetCtrl_systemReset  <= resetCtrl_mainClkResetUnbuffered;
        if (toplevel_system_cpu_debug_resetOut_regNext) begin
            resetCtrl_systemReset <= 1'b1;
        end
    end

    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            toplevel_system_cpu_dBus_cmd_rValid <= 1'b0;
            system_mainBusDecoder_logic_rspPending <= 1'b0;
            system_mainBusDecoder_logic_rspNoHit <= 1'b0;
        end else begin
            if (system_cpu_dBus_cmd_valid) begin
                toplevel_system_cpu_dBus_cmd_rValid <= 1'b1;
            end
            if (toplevel_system_cpu_dBus_cmd_halfPipe_fire) begin
                toplevel_system_cpu_dBus_cmd_rValid <= 1'b0;
            end
            if (system_mainBusDecoder_logic_masterPipelined_rsp_valid) begin
                system_mainBusDecoder_logic_rspPending <= 1'b0;
            end
            if (when_MuraxUtiles_l127) begin
                system_mainBusDecoder_logic_rspPending <= 1'b1;
            end
            system_mainBusDecoder_logic_rspNoHit <= 1'b0;
            if (system_mainBusDecoder_logic_noHit) begin
                system_mainBusDecoder_logic_rspNoHit <= 1'b1;
            end
        end
    end

    always @(posedge io_mainClk) begin
        if (system_cpu_dBus_cmd_ready) begin
            toplevel_system_cpu_dBus_cmd_rData_wr <= system_cpu_dBus_cmd_payload_wr;
            toplevel_system_cpu_dBus_cmd_rData_mask <= system_cpu_dBus_cmd_payload_mask;
            toplevel_system_cpu_dBus_cmd_rData_address <= system_cpu_dBus_cmd_payload_address;
            toplevel_system_cpu_dBus_cmd_rData_data <= system_cpu_dBus_cmd_payload_data;
            toplevel_system_cpu_dBus_cmd_rData_size <= system_cpu_dBus_cmd_payload_size;
        end
        if (system_mainBusDecoder_logic_masterPipelined_cmd_fire) begin
            system_mainBusDecoder_logic_rspSourceId <= system_mainBusDecoder_logic_hits_1;
        end
    end

    always @(posedge io_mainClk) begin
        toplevel_system_cpu_debug_resetOut_regNext <= system_cpu_debug_resetOut;
    end

    always @(posedge io_mainClk or posedge resetCtrl_mainClkReset) begin
        if (resetCtrl_mainClkReset) begin
            toplevel_system_cpu_debug_bus_cmd_fire_regNext <= 1'b0;
        end else begin
            toplevel_system_cpu_debug_bus_cmd_fire_regNext <= toplevel_system_cpu_debug_bus_cmd_fire;
        end
    end

endmodule


module BufferCC_RST (
    input  wire io_dataIn,
    output wire io_dataOut,
    input  wire io_mainClk
);

    (* async_reg = "true" *)reg buffers_0;
    (* async_reg = "true" *)reg buffers_1;

    assign io_dataOut = buffers_1;
    always @(posedge io_mainClk) begin
        buffers_0 <= io_dataIn;
        buffers_1 <= buffers_0;
    end

endmodule


module StreamFifoLowLatency (
    input  wire        io_push_valid,
    output wire        io_push_ready,
    input  wire        io_push_payload_error,
    input  wire [31:0] io_push_payload_inst,
    output wire        io_pop_valid,
    input  wire        io_pop_ready,
    output wire        io_pop_payload_error,
    output wire [31:0] io_pop_payload_inst,
    input  wire        io_flush,
    output wire [ 0:0] io_occupancy,
    output wire [ 0:0] io_availability,
    input  wire        io_mainClk,
    input  wire        resetCtrl_systemReset
);

    wire        fifo_io_push_ready;
    wire        fifo_io_pop_valid;
    wire        fifo_io_pop_payload_error;
    wire [31:0] fifo_io_pop_payload_inst;
    wire [ 0:0] fifo_io_occupancy;
    wire [ 0:0] fifo_io_availability;

    StreamFifo_VexRisv StreamFifo_VexRisv (
        .io_push_valid        (io_push_valid),                   // i
        .io_push_ready        (fifo_io_push_ready),              // o
        .io_push_payload_error(io_push_payload_error),           // i
        .io_push_payload_inst (io_push_payload_inst[31:0]),      // i
        .io_pop_valid         (fifo_io_pop_valid),               // o
        .io_pop_ready         (io_pop_ready),                    // i
        .io_pop_payload_error (fifo_io_pop_payload_error),       // o
        .io_pop_payload_inst  (fifo_io_pop_payload_inst[31:0]),  // o
        .io_flush             (io_flush),                        // i
        .io_occupancy         (fifo_io_occupancy),               // o
        .io_availability      (fifo_io_availability),            // o
        .io_mainClk           (io_mainClk),                      // i
        .resetCtrl_systemReset(resetCtrl_systemReset)            // i
    );
    assign io_push_ready = fifo_io_push_ready;
    assign io_pop_valid = fifo_io_pop_valid;
    assign io_pop_payload_error = fifo_io_pop_payload_error;
    assign io_pop_payload_inst = fifo_io_pop_payload_inst;
    assign io_occupancy = fifo_io_occupancy;
    assign io_availability = fifo_io_availability;

endmodule


module StreamFifo_VexRisv (
    input  wire        io_push_valid,
    output reg         io_push_ready,
    input  wire        io_push_payload_error,
    input  wire [31:0] io_push_payload_inst,
    output reg         io_pop_valid,
    input  wire        io_pop_ready,
    output reg         io_pop_payload_error,
    output reg  [31:0] io_pop_payload_inst,
    input  wire        io_flush,
    output wire [ 0:0] io_occupancy,
    output wire [ 0:0] io_availability,
    input  wire        io_mainClk,
    input  wire        resetCtrl_systemReset
);

    reg         oneStage_doFlush;
    wire        oneStage_buffer_valid;
    wire        oneStage_buffer_ready;
    wire        oneStage_buffer_payload_error;
    wire [31:0] oneStage_buffer_payload_inst;
    reg         io_push_rValid;
    reg         io_push_rData_error;
    reg  [31:0] io_push_rData_inst;
    wire        when_Stream_l375;
    wire        when_Stream_l1230;

    always @(*) begin
        oneStage_doFlush = io_flush;
        if (when_Stream_l1230) begin
            if (io_pop_ready) begin
                oneStage_doFlush = 1'b1;
            end
        end
    end

    always @(*) begin
        io_push_ready = oneStage_buffer_ready;
        if (when_Stream_l375) begin
            io_push_ready = 1'b1;
        end
    end

    assign when_Stream_l375 = (!oneStage_buffer_valid);
    assign oneStage_buffer_valid = io_push_rValid;
    assign oneStage_buffer_payload_error = io_push_rData_error;
    assign oneStage_buffer_payload_inst = io_push_rData_inst;
    always @(*) begin
        io_pop_valid = oneStage_buffer_valid;
        if (when_Stream_l1230) begin
            io_pop_valid = io_push_valid;
        end
    end

    assign oneStage_buffer_ready = io_pop_ready;
    always @(*) begin
        io_pop_payload_error = oneStage_buffer_payload_error;
        if (when_Stream_l1230) begin
            io_pop_payload_error = io_push_payload_error;
        end
    end

    always @(*) begin
        io_pop_payload_inst = oneStage_buffer_payload_inst;
        if (when_Stream_l1230) begin
            io_pop_payload_inst = io_push_payload_inst;
        end
    end

    assign io_occupancy = oneStage_buffer_valid;
    assign io_availability = (!oneStage_buffer_valid);
    assign when_Stream_l1230 = (!oneStage_buffer_valid);
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            io_push_rValid <= 1'b0;
        end else begin
            if (io_push_ready) begin
                io_push_rValid <= io_push_valid;
            end
            if (oneStage_doFlush) begin
                io_push_rValid <= 1'b0;
            end
        end
    end

    always @(posedge io_mainClk) begin
        if (io_push_ready) begin
            io_push_rData_error <= io_push_payload_error;
            io_push_rData_inst  <= io_push_payload_inst;
        end
    end

endmodule


module JtagBridge (
    input  wire        io_jtag_tms,
    input  wire        io_jtag_tdi,
    output wire        io_jtag_tdo,
    input  wire        io_jtag_tck,
    output wire        io_remote_cmd_valid,
    input  wire        io_remote_cmd_ready,
    output wire        io_remote_cmd_payload_last,
    output wire [ 0:0] io_remote_cmd_payload_fragment,
    input  wire        io_remote_rsp_valid,
    output wire        io_remote_rsp_ready,
    input  wire        io_remote_rsp_payload_error,
    input  wire [31:0] io_remote_rsp_payload_data,
    input  wire        io_mainClk,
    input  wire        resetCtrl_mainClkReset
);
    localparam JtagState_RESET = 4'd0;
    localparam JtagState_IDLE = 4'd1;
    localparam JtagState_IR_SELECT = 4'd2;
    localparam JtagState_IR_CAPTURE = 4'd3;
    localparam JtagState_IR_SHIFT = 4'd4;
    localparam JtagState_IR_EXIT1 = 4'd5;
    localparam JtagState_IR_PAUSE = 4'd6;
    localparam JtagState_IR_EXIT2 = 4'd7;
    localparam JtagState_IR_UPDATE = 4'd8;
    localparam JtagState_DR_SELECT = 4'd9;
    localparam JtagState_DR_CAPTURE = 4'd10;
    localparam JtagState_DR_SHIFT = 4'd11;
    localparam JtagState_DR_EXIT1 = 4'd12;
    localparam JtagState_DR_PAUSE = 4'd13;
    localparam JtagState_DR_EXIT2 = 4'd14;
    localparam JtagState_DR_UPDATE = 4'd15;

    wire        flowCCUnsafeByToggle_1_io_output_valid;
    wire        flowCCUnsafeByToggle_1_io_output_payload_last;
    wire [ 0:0] flowCCUnsafeByToggle_1_io_output_payload_fragment;
    wire [ 3:0] _zz_jtag_tap_isBypass;
    wire [ 1:0] _zz_jtag_tap_instructionShift;
    wire        system_cmd_valid;
    wire        system_cmd_payload_last;
    wire [ 0:0] system_cmd_payload_fragment;
    wire        system_cmd_toStream_valid;
    wire        system_cmd_toStream_ready;
    wire        system_cmd_toStream_payload_last;
    wire [ 0:0] system_cmd_toStream_payload_fragment;
    (* async_reg = "true" *)reg         system_rsp_valid;
    (* async_reg = "true" *)reg         system_rsp_payload_error;
    (* async_reg = "true" *)reg  [31:0] system_rsp_payload_data;
    wire        io_remote_rsp_fire;
    reg  [ 3:0] jtag_tap_fsm_stateNext;
    reg  [ 3:0] jtag_tap_fsm_state;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_1;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_2;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_3;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_4;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_5;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_6;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_7;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_8;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_9;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_10;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_11;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_12;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_13;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_14;
    wire [ 3:0] _zz_jtag_tap_fsm_stateNext_15;
    reg  [ 3:0] jtag_tap_instruction;
    reg  [ 3:0] jtag_tap_instructionShift;
    reg         jtag_tap_bypass;
    reg         jtag_tap_tdoUnbufferd;
    reg         jtag_tap_tdoDr;
    wire        jtag_tap_tdoIr;
    wire        jtag_tap_isBypass;
    reg         jtag_tap_tdoUnbufferd_regNext;
    wire        jtag_idcodeArea_ctrl_tdi;
    wire        jtag_idcodeArea_ctrl_enable;
    wire        jtag_idcodeArea_ctrl_capture;
    wire        jtag_idcodeArea_ctrl_shift;
    wire        jtag_idcodeArea_ctrl_update;
    wire        jtag_idcodeArea_ctrl_reset;
    wire        jtag_idcodeArea_ctrl_tdo;
    reg  [31:0] jtag_idcodeArea_shifter;
    wire        when_JtagTap_l121;
    wire        jtag_writeArea_ctrl_tdi;
    wire        jtag_writeArea_ctrl_enable;
    wire        jtag_writeArea_ctrl_capture;
    wire        jtag_writeArea_ctrl_shift;
    wire        jtag_writeArea_ctrl_update;
    wire        jtag_writeArea_ctrl_reset;
    wire        jtag_writeArea_ctrl_tdo;
    wire        jtag_writeArea_source_valid;
    wire        jtag_writeArea_source_payload_last;
    wire [ 0:0] jtag_writeArea_source_payload_fragment;
    reg         jtag_writeArea_valid;
    reg         jtag_writeArea_data;
    wire        jtag_readArea_ctrl_tdi;
    wire        jtag_readArea_ctrl_enable;
    wire        jtag_readArea_ctrl_capture;
    wire        jtag_readArea_ctrl_shift;
    wire        jtag_readArea_ctrl_update;
    wire        jtag_readArea_ctrl_reset;
    wire        jtag_readArea_ctrl_tdo;
    reg  [33:0] jtag_readArea_full_shifter;
`ifndef SYNTHESIS
    reg [79:0] jtag_tap_fsm_stateNext_string;
    reg [79:0] jtag_tap_fsm_state_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_1_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_2_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_3_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_4_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_5_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_6_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_7_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_8_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_9_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_10_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_11_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_12_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_13_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_14_string;
    reg [79:0] _zz_jtag_tap_fsm_stateNext_15_string;
`endif


    assign _zz_jtag_tap_isBypass = jtag_tap_instruction;
    assign _zz_jtag_tap_instructionShift = 2'b01;
    FlowCCUnsafeByToggle FlowCCUnsafeByToggle (
        .io_input_valid            (jtag_writeArea_source_valid),                        //i
        .io_input_payload_last     (jtag_writeArea_source_payload_last),                 //i
        .io_input_payload_fragment (jtag_writeArea_source_payload_fragment),             //i
        .io_output_valid           (flowCCUnsafeByToggle_1_io_output_valid),             //o
        .io_output_payload_last    (flowCCUnsafeByToggle_1_io_output_payload_last),      //o
        .io_output_payload_fragment(flowCCUnsafeByToggle_1_io_output_payload_fragment),  //o
        .io_jtag_tck               (io_jtag_tck),                                        //i
        .io_mainClk                (io_mainClk),                                         //i
        .resetCtrl_mainClkReset    (resetCtrl_mainClkReset)                              //i
    );
    initial begin
`ifndef SYNTHESIS
        jtag_tap_fsm_state = {$urandom};
`endif
    end

`ifndef SYNTHESIS
    always @(*) begin
        case (jtag_tap_fsm_stateNext)
            JtagState_RESET: jtag_tap_fsm_stateNext_string = "RESET     ";
            JtagState_IDLE: jtag_tap_fsm_stateNext_string = "IDLE      ";
            JtagState_IR_SELECT: jtag_tap_fsm_stateNext_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: jtag_tap_fsm_stateNext_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: jtag_tap_fsm_stateNext_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: jtag_tap_fsm_stateNext_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: jtag_tap_fsm_stateNext_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: jtag_tap_fsm_stateNext_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: jtag_tap_fsm_stateNext_string = "IR_UPDATE ";
            JtagState_DR_SELECT: jtag_tap_fsm_stateNext_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: jtag_tap_fsm_stateNext_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: jtag_tap_fsm_stateNext_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: jtag_tap_fsm_stateNext_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: jtag_tap_fsm_stateNext_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: jtag_tap_fsm_stateNext_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: jtag_tap_fsm_stateNext_string = "DR_UPDATE ";
            default: jtag_tap_fsm_stateNext_string = "??????????";
        endcase
    end
    always @(*) begin
        case (jtag_tap_fsm_state)
            JtagState_RESET: jtag_tap_fsm_state_string = "RESET     ";
            JtagState_IDLE: jtag_tap_fsm_state_string = "IDLE      ";
            JtagState_IR_SELECT: jtag_tap_fsm_state_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: jtag_tap_fsm_state_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: jtag_tap_fsm_state_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: jtag_tap_fsm_state_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: jtag_tap_fsm_state_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: jtag_tap_fsm_state_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: jtag_tap_fsm_state_string = "IR_UPDATE ";
            JtagState_DR_SELECT: jtag_tap_fsm_state_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: jtag_tap_fsm_state_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: jtag_tap_fsm_state_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: jtag_tap_fsm_state_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: jtag_tap_fsm_state_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: jtag_tap_fsm_state_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: jtag_tap_fsm_state_string = "DR_UPDATE ";
            default: jtag_tap_fsm_state_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_1)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_1_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_1_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_1_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_1_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_1_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_1_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_1_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_1_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_1_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_1_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_1_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_1_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_1_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_1_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_1_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_1_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_1_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_2)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_2_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_2_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_2_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_2_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_2_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_2_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_2_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_2_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_2_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_2_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_2_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_2_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_2_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_2_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_2_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_2_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_2_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_3)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_3_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_3_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_3_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_3_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_3_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_3_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_3_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_3_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_3_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_3_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_3_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_3_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_3_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_3_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_3_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_3_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_3_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_4)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_4_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_4_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_4_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_4_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_4_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_4_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_4_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_4_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_4_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_4_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_4_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_4_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_4_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_4_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_4_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_4_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_4_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_5)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_5_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_5_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_5_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_5_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_5_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_5_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_5_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_5_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_5_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_5_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_5_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_5_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_5_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_5_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_5_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_5_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_5_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_6)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_6_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_6_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_6_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_6_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_6_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_6_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_6_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_6_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_6_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_6_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_6_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_6_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_6_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_6_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_6_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_6_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_6_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_7)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_7_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_7_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_7_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_7_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_7_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_7_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_7_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_7_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_7_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_7_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_7_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_7_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_7_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_7_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_7_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_7_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_7_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_8)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_8_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_8_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_8_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_8_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_8_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_8_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_8_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_8_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_8_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_8_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_8_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_8_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_8_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_8_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_8_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_8_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_8_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_9)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_9_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_9_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_9_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_9_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_9_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_9_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_9_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_9_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_9_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_9_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_9_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_9_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_9_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_9_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_9_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_9_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_9_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_10)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_10_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_10_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_10_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_10_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_10_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_10_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_10_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_10_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_10_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_10_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_10_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_10_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_10_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_10_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_10_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_10_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_10_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_11)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_11_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_11_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_11_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_11_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_11_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_11_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_11_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_11_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_11_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_11_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_11_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_11_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_11_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_11_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_11_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_11_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_11_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_12)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_12_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_12_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_12_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_12_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_12_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_12_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_12_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_12_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_12_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_12_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_12_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_12_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_12_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_12_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_12_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_12_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_12_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_13)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_13_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_13_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_13_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_13_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_13_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_13_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_13_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_13_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_13_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_13_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_13_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_13_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_13_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_13_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_13_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_13_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_13_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_14)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_14_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_14_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_14_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_14_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_14_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_14_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_14_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_14_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_14_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_14_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_14_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_14_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_14_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_14_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_14_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_14_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_14_string = "??????????";
        endcase
    end
    always @(*) begin
        case (_zz_jtag_tap_fsm_stateNext_15)
            JtagState_RESET: _zz_jtag_tap_fsm_stateNext_15_string = "RESET     ";
            JtagState_IDLE: _zz_jtag_tap_fsm_stateNext_15_string = "IDLE      ";
            JtagState_IR_SELECT: _zz_jtag_tap_fsm_stateNext_15_string = "IR_SELECT ";
            JtagState_IR_CAPTURE: _zz_jtag_tap_fsm_stateNext_15_string = "IR_CAPTURE";
            JtagState_IR_SHIFT: _zz_jtag_tap_fsm_stateNext_15_string = "IR_SHIFT  ";
            JtagState_IR_EXIT1: _zz_jtag_tap_fsm_stateNext_15_string = "IR_EXIT1  ";
            JtagState_IR_PAUSE: _zz_jtag_tap_fsm_stateNext_15_string = "IR_PAUSE  ";
            JtagState_IR_EXIT2: _zz_jtag_tap_fsm_stateNext_15_string = "IR_EXIT2  ";
            JtagState_IR_UPDATE: _zz_jtag_tap_fsm_stateNext_15_string = "IR_UPDATE ";
            JtagState_DR_SELECT: _zz_jtag_tap_fsm_stateNext_15_string = "DR_SELECT ";
            JtagState_DR_CAPTURE: _zz_jtag_tap_fsm_stateNext_15_string = "DR_CAPTURE";
            JtagState_DR_SHIFT: _zz_jtag_tap_fsm_stateNext_15_string = "DR_SHIFT  ";
            JtagState_DR_EXIT1: _zz_jtag_tap_fsm_stateNext_15_string = "DR_EXIT1  ";
            JtagState_DR_PAUSE: _zz_jtag_tap_fsm_stateNext_15_string = "DR_PAUSE  ";
            JtagState_DR_EXIT2: _zz_jtag_tap_fsm_stateNext_15_string = "DR_EXIT2  ";
            JtagState_DR_UPDATE: _zz_jtag_tap_fsm_stateNext_15_string = "DR_UPDATE ";
            default: _zz_jtag_tap_fsm_stateNext_15_string = "??????????";
        endcase
    end
`endif

    assign system_cmd_toStream_valid = system_cmd_valid;
    assign system_cmd_toStream_payload_last = system_cmd_payload_last;
    assign system_cmd_toStream_payload_fragment = system_cmd_payload_fragment;
    assign io_remote_cmd_valid = system_cmd_toStream_valid;
    assign system_cmd_toStream_ready = io_remote_cmd_ready;
    assign io_remote_cmd_payload_last = system_cmd_toStream_payload_last;
    assign io_remote_cmd_payload_fragment = system_cmd_toStream_payload_fragment;
    assign io_remote_rsp_fire = (io_remote_rsp_valid && io_remote_rsp_ready);
    assign io_remote_rsp_ready = 1'b1;
    assign _zz_jtag_tap_fsm_stateNext = (io_jtag_tms ? JtagState_RESET : JtagState_IDLE);
    always @(*) begin
        case (jtag_tap_fsm_state)
            JtagState_RESET: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext;
            end
            JtagState_IDLE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_1;
            end
            JtagState_IR_SELECT: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_2;
            end
            JtagState_IR_CAPTURE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_3;
            end
            JtagState_IR_SHIFT: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_4;
            end
            JtagState_IR_EXIT1: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_5;
            end
            JtagState_IR_PAUSE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_6;
            end
            JtagState_IR_EXIT2: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_7;
            end
            JtagState_IR_UPDATE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_8;
            end
            JtagState_DR_SELECT: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_9;
            end
            JtagState_DR_CAPTURE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_10;
            end
            JtagState_DR_SHIFT: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_11;
            end
            JtagState_DR_EXIT1: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_12;
            end
            JtagState_DR_PAUSE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_13;
            end
            JtagState_DR_EXIT2: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_14;
            end
            JtagState_DR_UPDATE: begin
                jtag_tap_fsm_stateNext = _zz_jtag_tap_fsm_stateNext_15;
            end
            default: begin
            end
        endcase
    end

    assign _zz_jtag_tap_fsm_stateNext_1 = (io_jtag_tms ? JtagState_DR_SELECT : JtagState_IDLE);
    assign _zz_jtag_tap_fsm_stateNext_2 = (io_jtag_tms ? JtagState_RESET : JtagState_IR_CAPTURE);
    assign _zz_jtag_tap_fsm_stateNext_3 = (io_jtag_tms ? JtagState_IR_EXIT1 : JtagState_IR_SHIFT);
    assign _zz_jtag_tap_fsm_stateNext_4 = (io_jtag_tms ? JtagState_IR_EXIT1 : JtagState_IR_SHIFT);
    assign _zz_jtag_tap_fsm_stateNext_5 = (io_jtag_tms ? JtagState_IR_UPDATE : JtagState_IR_PAUSE);
    assign _zz_jtag_tap_fsm_stateNext_6 = (io_jtag_tms ? JtagState_IR_EXIT2 : JtagState_IR_PAUSE);
    assign _zz_jtag_tap_fsm_stateNext_7 = (io_jtag_tms ? JtagState_IR_UPDATE : JtagState_IR_SHIFT);
    assign _zz_jtag_tap_fsm_stateNext_8 = (io_jtag_tms ? JtagState_DR_SELECT : JtagState_IDLE);
    assign _zz_jtag_tap_fsm_stateNext_9 = (io_jtag_tms ? JtagState_IR_SELECT : JtagState_DR_CAPTURE);
    assign _zz_jtag_tap_fsm_stateNext_10 = (io_jtag_tms ? JtagState_DR_EXIT1 : JtagState_DR_SHIFT);
    assign _zz_jtag_tap_fsm_stateNext_11 = (io_jtag_tms ? JtagState_DR_EXIT1 : JtagState_DR_SHIFT);
    assign _zz_jtag_tap_fsm_stateNext_12 = (io_jtag_tms ? JtagState_DR_UPDATE : JtagState_DR_PAUSE);
    assign _zz_jtag_tap_fsm_stateNext_13 = (io_jtag_tms ? JtagState_DR_EXIT2 : JtagState_DR_PAUSE);
    assign _zz_jtag_tap_fsm_stateNext_14 = (io_jtag_tms ? JtagState_DR_UPDATE : JtagState_DR_SHIFT);
    assign _zz_jtag_tap_fsm_stateNext_15 = (io_jtag_tms ? JtagState_DR_SELECT : JtagState_IDLE);
    always @(*) begin
        jtag_tap_tdoUnbufferd = jtag_tap_bypass;
        case (jtag_tap_fsm_state)
            JtagState_IR_SHIFT: begin
                jtag_tap_tdoUnbufferd = jtag_tap_tdoIr;
            end
            JtagState_DR_SHIFT: begin
                if (jtag_tap_isBypass) begin
                    jtag_tap_tdoUnbufferd = jtag_tap_bypass;
                end else begin
                    jtag_tap_tdoUnbufferd = jtag_tap_tdoDr;
                end
            end
            default: begin
            end
        endcase
    end

    always @(*) begin
        jtag_tap_tdoDr = 1'b0;
        if (jtag_idcodeArea_ctrl_enable) begin
            jtag_tap_tdoDr = jtag_idcodeArea_ctrl_tdo;
        end
        if (jtag_writeArea_ctrl_enable) begin
            jtag_tap_tdoDr = jtag_writeArea_ctrl_tdo;
        end
        if (jtag_readArea_ctrl_enable) begin
            jtag_tap_tdoDr = jtag_readArea_ctrl_tdo;
        end
    end

    assign jtag_tap_tdoIr = jtag_tap_instructionShift[0];
    assign jtag_tap_isBypass = ($signed(_zz_jtag_tap_isBypass) == $signed(4'b1111));
    assign io_jtag_tdo = jtag_tap_tdoUnbufferd_regNext;
    assign jtag_idcodeArea_ctrl_tdo = jtag_idcodeArea_shifter[0];
    assign jtag_idcodeArea_ctrl_tdi = io_jtag_tdi;
    assign jtag_idcodeArea_ctrl_enable = (jtag_tap_instruction == 4'b0001);
    assign jtag_idcodeArea_ctrl_capture = (jtag_tap_fsm_state == JtagState_DR_CAPTURE);
    assign jtag_idcodeArea_ctrl_shift = (jtag_tap_fsm_state == JtagState_DR_SHIFT);
    assign jtag_idcodeArea_ctrl_update = (jtag_tap_fsm_state == JtagState_DR_UPDATE);
    assign jtag_idcodeArea_ctrl_reset = (jtag_tap_fsm_state == JtagState_RESET);
    assign when_JtagTap_l121 = (jtag_tap_fsm_state == JtagState_RESET);
    assign jtag_writeArea_source_valid = jtag_writeArea_valid;
    assign jtag_writeArea_source_payload_last = (! (jtag_writeArea_ctrl_enable && jtag_writeArea_ctrl_shift));
    assign jtag_writeArea_source_payload_fragment[0] = jtag_writeArea_data;
    assign system_cmd_valid = flowCCUnsafeByToggle_1_io_output_valid;
    assign system_cmd_payload_last = flowCCUnsafeByToggle_1_io_output_payload_last;
    assign system_cmd_payload_fragment = flowCCUnsafeByToggle_1_io_output_payload_fragment;
    assign jtag_writeArea_ctrl_tdo = 1'b0;
    assign jtag_writeArea_ctrl_tdi = io_jtag_tdi;
    assign jtag_writeArea_ctrl_enable = (jtag_tap_instruction == 4'b0010);
    assign jtag_writeArea_ctrl_capture = (jtag_tap_fsm_state == JtagState_DR_CAPTURE);
    assign jtag_writeArea_ctrl_shift = (jtag_tap_fsm_state == JtagState_DR_SHIFT);
    assign jtag_writeArea_ctrl_update = (jtag_tap_fsm_state == JtagState_DR_UPDATE);
    assign jtag_writeArea_ctrl_reset = (jtag_tap_fsm_state == JtagState_RESET);
    assign jtag_readArea_ctrl_tdo = jtag_readArea_full_shifter[0];
    assign jtag_readArea_ctrl_tdi = io_jtag_tdi;
    assign jtag_readArea_ctrl_enable = (jtag_tap_instruction == 4'b0011);
    assign jtag_readArea_ctrl_capture = (jtag_tap_fsm_state == JtagState_DR_CAPTURE);
    assign jtag_readArea_ctrl_shift = (jtag_tap_fsm_state == JtagState_DR_SHIFT);
    assign jtag_readArea_ctrl_update = (jtag_tap_fsm_state == JtagState_DR_UPDATE);
    assign jtag_readArea_ctrl_reset = (jtag_tap_fsm_state == JtagState_RESET);
    always @(posedge io_mainClk) begin
        if (io_remote_cmd_valid) begin
            system_rsp_valid <= 1'b0;
        end
        if (io_remote_rsp_fire) begin
            system_rsp_valid <= 1'b1;
            system_rsp_payload_error <= io_remote_rsp_payload_error;
            system_rsp_payload_data <= io_remote_rsp_payload_data;
        end
    end

    always @(posedge io_jtag_tck) begin
        jtag_tap_fsm_state <= jtag_tap_fsm_stateNext;
        jtag_tap_bypass <= io_jtag_tdi;
        case (jtag_tap_fsm_state)
            JtagState_IR_CAPTURE: begin
                jtag_tap_instructionShift <= {2'd0, _zz_jtag_tap_instructionShift};
            end
            JtagState_IR_SHIFT: begin
                jtag_tap_instructionShift <= ({io_jtag_tdi, jtag_tap_instructionShift} >>> 1'd1);
            end
            JtagState_IR_UPDATE: begin
                jtag_tap_instruction <= jtag_tap_instructionShift;
            end
            JtagState_DR_SHIFT: begin
                jtag_tap_instructionShift <= ({io_jtag_tdi, jtag_tap_instructionShift} >>> 1'd1);
            end
            default: begin
            end
        endcase
        if (jtag_idcodeArea_ctrl_enable) begin
            if (jtag_idcodeArea_ctrl_shift) begin
                jtag_idcodeArea_shifter <= ({jtag_idcodeArea_ctrl_tdi,jtag_idcodeArea_shifter} >>> 1'd1);
            end
        end
        if (jtag_idcodeArea_ctrl_capture) begin
            jtag_idcodeArea_shifter <= 32'h10001fff;
        end
        if (when_JtagTap_l121) begin
            jtag_tap_instruction <= 4'b0001;
        end
        jtag_writeArea_valid <= (jtag_writeArea_ctrl_enable && jtag_writeArea_ctrl_shift);
        jtag_writeArea_data  <= jtag_writeArea_ctrl_tdi;
        if (jtag_readArea_ctrl_enable) begin
            if (jtag_readArea_ctrl_capture) begin
                jtag_readArea_full_shifter <= {
                    {system_rsp_payload_data, system_rsp_payload_error}, system_rsp_valid
                };
            end
            if (jtag_readArea_ctrl_shift) begin
                jtag_readArea_full_shifter <= ({jtag_readArea_ctrl_tdi,jtag_readArea_full_shifter} >>> 1'd1);
            end
        end
    end

    always @(negedge io_jtag_tck) begin
        jtag_tap_tdoUnbufferd_regNext <= jtag_tap_tdoUnbufferd;
    end

endmodule


module Debugger (
    input  wire        io_remote_cmd_valid,
    output wire        io_remote_cmd_ready,
    input  wire        io_remote_cmd_payload_last,
    input  wire [ 0:0] io_remote_cmd_payload_fragment,
    output wire        io_remote_rsp_valid,
    input  wire        io_remote_rsp_ready,
    output wire        io_remote_rsp_payload_error,
    output wire [31:0] io_remote_rsp_payload_data,
    output wire        io_mem_cmd_valid,
    input  wire        io_mem_cmd_ready,
    output wire [31:0] io_mem_cmd_payload_address,
    output wire [31:0] io_mem_cmd_payload_data,
    output wire        io_mem_cmd_payload_wr,
    output wire [ 1:0] io_mem_cmd_payload_size,
    input  wire        io_mem_rsp_valid,
    input  wire [31:0] io_mem_rsp_payload,
    input  wire        io_mainClk,
    input  wire        resetCtrl_mainClkReset
);

    reg  [66:0] dispatcher_dataShifter;
    reg         dispatcher_dataLoaded;
    reg  [ 7:0] dispatcher_headerShifter;
    wire [ 7:0] dispatcher_header;
    reg         dispatcher_headerLoaded;
    reg  [ 2:0] dispatcher_counter;
    wire        when_Fragment_l356;
    wire        when_Fragment_l359;
    wire [66:0] _zz_io_mem_cmd_payload_address;
    wire        io_mem_cmd_isStall;
    wire        when_Fragment_l382;

    assign dispatcher_header = dispatcher_headerShifter[7 : 0];
    assign when_Fragment_l356 = (dispatcher_headerLoaded == 1'b0);
    assign when_Fragment_l359 = (dispatcher_counter == 3'b111);
    assign io_remote_cmd_ready = (!dispatcher_dataLoaded);
    assign _zz_io_mem_cmd_payload_address = dispatcher_dataShifter[66 : 0];
    assign io_mem_cmd_payload_address = _zz_io_mem_cmd_payload_address[31 : 0];
    assign io_mem_cmd_payload_data = _zz_io_mem_cmd_payload_address[63 : 32];
    assign io_mem_cmd_payload_wr = _zz_io_mem_cmd_payload_address[64];
    assign io_mem_cmd_payload_size = _zz_io_mem_cmd_payload_address[66 : 65];
    assign io_mem_cmd_valid = (dispatcher_dataLoaded && (dispatcher_header == 8'h0));
    assign io_mem_cmd_isStall = (io_mem_cmd_valid && (!io_mem_cmd_ready));
    assign when_Fragment_l382 = ((dispatcher_headerLoaded && dispatcher_dataLoaded) && (! io_mem_cmd_isStall));
    assign io_remote_rsp_valid = io_mem_rsp_valid;
    assign io_remote_rsp_payload_error = 1'b0;
    assign io_remote_rsp_payload_data = io_mem_rsp_payload;
    always @(posedge io_mainClk or posedge resetCtrl_mainClkReset) begin
        if (resetCtrl_mainClkReset) begin
            dispatcher_dataLoaded <= 1'b0;
            dispatcher_headerLoaded <= 1'b0;
            dispatcher_counter <= 3'b000;
        end else begin
            if (io_remote_cmd_valid) begin
                if (when_Fragment_l356) begin
                    dispatcher_counter <= (dispatcher_counter + 3'b001);
                    if (when_Fragment_l359) begin
                        dispatcher_headerLoaded <= 1'b1;
                    end
                end
                if (io_remote_cmd_payload_last) begin
                    dispatcher_headerLoaded <= 1'b1;
                    dispatcher_dataLoaded <= 1'b1;
                    dispatcher_counter <= 3'b000;
                end
            end
            if (when_Fragment_l382) begin
                dispatcher_headerLoaded <= 1'b0;
                dispatcher_dataLoaded   <= 1'b0;
            end
        end
    end

    always @(posedge io_mainClk) begin
        if (io_remote_cmd_valid) begin
            if (when_Fragment_l356) begin
                dispatcher_headerShifter <= ({io_remote_cmd_payload_fragment,dispatcher_headerShifter} >>> 1'd1);
            end else begin
                dispatcher_dataShifter <= ({io_remote_cmd_payload_fragment,dispatcher_dataShifter} >>> 1'd1);
            end
        end
    end

endmodule


module FlowCCUnsafeByToggle (
    input  wire       io_input_valid,
    input  wire       io_input_payload_last,
    input  wire [0:0] io_input_payload_fragment,
    output wire       io_output_valid,
    output wire       io_output_payload_last,
    output wire [0:0] io_output_payload_fragment,
    input  wire       io_jtag_tck,
    input  wire       io_mainClk,
    input  wire       resetCtrl_mainClkReset
);

    wire       inputArea_target_buffercc_io_dataOut;
    reg        inputArea_target;
    reg        inputArea_data_last;
    reg  [0:0] inputArea_data_fragment;
    wire       outputArea_target;
    reg        outputArea_hit;
    wire       outputArea_flow_valid;
    wire       outputArea_flow_payload_last;
    wire [0:0] outputArea_flow_payload_fragment;
    reg        outputArea_flow_m2sPipe_valid;
    (* async_reg = "true" *)reg        outputArea_flow_m2sPipe_payload_last;
    (* async_reg = "true" *)reg  [0:0] outputArea_flow_m2sPipe_payload_fragment;

    (* keep_hierarchy = "TRUE" *) BufferCC_JTAG BufferCC_JTAG (
        .io_dataIn             (inputArea_target),                      // i
        .io_dataOut            (inputArea_target_buffercc_io_dataOut),  // o
        .io_mainClk            (io_mainClk),                            // i
        .resetCtrl_mainClkReset(resetCtrl_mainClkReset)                 // i
    );
    initial begin
`ifndef SYNTHESIS
        inputArea_target = $urandom;
        outputArea_hit   = $urandom;
`endif
    end

    assign outputArea_target = inputArea_target_buffercc_io_dataOut;
    assign outputArea_flow_valid = (outputArea_target != outputArea_hit);
    assign outputArea_flow_payload_last = inputArea_data_last;
    assign outputArea_flow_payload_fragment = inputArea_data_fragment;
    assign io_output_valid = outputArea_flow_m2sPipe_valid;
    assign io_output_payload_last = outputArea_flow_m2sPipe_payload_last;
    assign io_output_payload_fragment = outputArea_flow_m2sPipe_payload_fragment;
    always @(posedge io_jtag_tck) begin
        if (io_input_valid) begin
            inputArea_target <= (!inputArea_target);
            inputArea_data_last <= io_input_payload_last;
            inputArea_data_fragment <= io_input_payload_fragment;
        end
    end

    always @(posedge io_mainClk) begin
        outputArea_hit <= outputArea_target;
        if (outputArea_flow_valid) begin
            outputArea_flow_m2sPipe_payload_last <= outputArea_flow_payload_last;
            outputArea_flow_m2sPipe_payload_fragment <= outputArea_flow_payload_fragment;
        end
    end

    always @(posedge io_mainClk or posedge resetCtrl_mainClkReset) begin
        if (resetCtrl_mainClkReset) begin
            outputArea_flow_m2sPipe_valid <= 1'b0;
        end else begin
            outputArea_flow_m2sPipe_valid <= outputArea_flow_valid;
        end
    end

endmodule


module BufferCC_JTAG (
    input  wire io_dataIn,
    output wire io_dataOut,
    input  wire io_mainClk,
    input  wire resetCtrl_mainClkReset
);

    (* async_reg = "true" *)reg buffers_0;
    (* async_reg = "true" *)reg buffers_1;

    initial begin
`ifndef SYNTHESIS
        buffers_0 = $urandom;
        buffers_1 = $urandom;
`endif
    end

    assign io_dataOut = buffers_1;
    always @(posedge io_mainClk) begin
        buffers_0 <= io_dataIn;
        buffers_1 <= buffers_0;
    end

endmodule


module MasterArbiter (
    input  wire        io_iBus_cmd_valid,
    output reg         io_iBus_cmd_ready,
    input  wire [31:0] io_iBus_cmd_payload_pc,
    output wire        io_iBus_rsp_valid,
    output wire        io_iBus_rsp_payload_error,
    output wire [31:0] io_iBus_rsp_payload_inst,
    input  wire        io_dBus_cmd_valid,
    output reg         io_dBus_cmd_ready,
    input  wire        io_dBus_cmd_payload_wr,
    input  wire [ 3:0] io_dBus_cmd_payload_mask,
    input  wire [31:0] io_dBus_cmd_payload_address,
    input  wire [31:0] io_dBus_cmd_payload_data,
    input  wire [ 1:0] io_dBus_cmd_payload_size,
    output wire        io_dBus_rsp_ready,
    output wire        io_dBus_rsp_error,
    output wire [31:0] io_dBus_rsp_data,
    output reg         io_masterBus_cmd_valid,
    input  wire        io_masterBus_cmd_ready,
    output wire        io_masterBus_cmd_payload_write,
    output wire [31:0] io_masterBus_cmd_payload_address,
    output wire [31:0] io_masterBus_cmd_payload_data,
    output wire [ 3:0] io_masterBus_cmd_payload_mask,
    input  wire        io_masterBus_rsp_valid,
    input  wire [31:0] io_masterBus_rsp_payload_data,
    input  wire        io_mainClk,
    input  wire        resetCtrl_systemReset
);

    reg  [3:0] _zz_io_masterBus_cmd_payload_mask;
    reg        rspPending;
    reg        rspTarget;
    wire       io_masterBus_cmd_fire;
    wire       when_MuraxUtiles_l31;
    wire       when_MuraxUtiles_l36;

    always @(*) begin
        io_masterBus_cmd_valid = (io_iBus_cmd_valid || io_dBus_cmd_valid);
        if (when_MuraxUtiles_l36) begin
            io_masterBus_cmd_valid = 1'b0;
        end
    end

    assign io_masterBus_cmd_payload_write = (io_dBus_cmd_valid && io_dBus_cmd_payload_wr);
    assign io_masterBus_cmd_payload_address = (io_dBus_cmd_valid ? io_dBus_cmd_payload_address : io_iBus_cmd_payload_pc);
    assign io_masterBus_cmd_payload_data = io_dBus_cmd_payload_data;
    always @(*) begin
        case (io_dBus_cmd_payload_size)
            2'b00: begin
                _zz_io_masterBus_cmd_payload_mask = 4'b0001;
            end
            2'b01: begin
                _zz_io_masterBus_cmd_payload_mask = 4'b0011;
            end
            default: begin
                _zz_io_masterBus_cmd_payload_mask = 4'b1111;
            end
        endcase
    end

    assign io_masterBus_cmd_payload_mask = (_zz_io_masterBus_cmd_payload_mask <<< io_dBus_cmd_payload_address[1 : 0]);
    always @(*) begin
        io_iBus_cmd_ready = (io_masterBus_cmd_ready && (!io_dBus_cmd_valid));
        if (when_MuraxUtiles_l36) begin
            io_iBus_cmd_ready = 1'b0;
        end
    end

    always @(*) begin
        io_dBus_cmd_ready = io_masterBus_cmd_ready;
        if (when_MuraxUtiles_l36) begin
            io_dBus_cmd_ready = 1'b0;
        end
    end

    assign io_masterBus_cmd_fire = (io_masterBus_cmd_valid && io_masterBus_cmd_ready);
    assign when_MuraxUtiles_l31 = (io_masterBus_cmd_fire && (!io_masterBus_cmd_payload_write));
    assign when_MuraxUtiles_l36 = (rspPending && (!io_masterBus_rsp_valid));
    assign io_iBus_rsp_valid = (io_masterBus_rsp_valid && (!rspTarget));
    assign io_iBus_rsp_payload_inst = io_masterBus_rsp_payload_data;
    assign io_iBus_rsp_payload_error = 1'b0;
    assign io_dBus_rsp_ready = (io_masterBus_rsp_valid && rspTarget);
    assign io_dBus_rsp_data = io_masterBus_rsp_payload_data;
    assign io_dBus_rsp_error = 1'b0;
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            rspPending <= 1'b0;
            rspTarget  <= 1'b0;
        end else begin
            if (io_masterBus_rsp_valid) begin
                rspPending <= 1'b0;
            end
            if (when_MuraxUtiles_l31) begin
                rspTarget  <= io_dBus_cmd_valid;
                rspPending <= 1'b1;
            end
        end
    end

endmodule
