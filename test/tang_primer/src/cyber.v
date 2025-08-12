// Generator : SpinalHDL v1.12.0    git head : 1aa7d7b5732f11cca2dd83bacc2a4cb92ca8e5c9
// Component : cyberwithddrlcd
// Git hash  : 2f0e43726940bed23d36096a67d939c4c2002bbe

`timescale 1ns/1ps
`define SYNTHESIS
module cyberwithddrlcd (
  input  wire          io_rstn,
  input  wire          io_clk,
  output wire [13:0]   io_sdram_O_ddr_addr,
  output wire [2:0]    io_sdram_O_ddr_ba,
  output wire          io_sdram_O_ddr_cs_n,
  output wire          io_sdram_O_ddr_ras_n,
  output wire          io_sdram_O_ddr_cas_n,
  output wire          io_sdram_O_ddr_we_n,
  output wire          io_sdram_O_ddr_clk,
  output wire          io_sdram_O_ddr_clk_n,
  output wire          io_sdram_O_ddr_cke,
  output wire          io_sdram_O_ddr_odt,
  output wire          io_sdram_O_ddr_reset_n,
  output wire [1:0]    io_sdram_O_ddr_dqm,
  inout  wire [15:0]   io_sdram_IO_ddr_dq,
  inout  wire [1:0]    io_sdram_IO_ddr_dqs,
  inout  wire [1:0]    io_sdram_IO_ddr_dqs_n,
  output wire          io_uart_tx,
  output wire          io_dvti_vs,
  output wire          io_dvti_hs,
  output wire          io_dvti_de,
  output wire [15:0]   io_dvti_data,
  output wire          io_lcdclk
);

  wire                bufferCC_37_io_dataIn;
  reg        [3:0]    axi_core_io_interrupt;
  wire       [11:0]   axi_core_io_debugBus_PADDR;
  wire                axi_sdramCtrl_io_pll_lock;
  wire       [4:0]    axi_afioCtrl_io_apb_PADDR;
  wire       [31:0]   axi_afioCtrl_io_device_read;
  wire       [4:0]    axi_extiCtrl_io_apb_PADDR;
  wire       [12:0]   axi_gpioCtrl_io_apb_PADDR;
  wire       [31:0]   axi_gpioCtrl_io_gpio_read;
  wire       [12:0]   axi_timCtrl_io_apb_PADDR;
  wire       [12:0]   axi_wdgCtrl_io_apb_PADDR;
  wire       [3:0]    axi_systickCtrl_io_apb_PADDR;
  wire       [12:0]   axi_uartCtrl_io_apb_PADDR;
  wire                axi_uartCtrl_io_uarts_0_rxd;
  wire                axi_uartCtrl_io_uarts_1_rxd;
  wire       [9:0]    axi_lcdCtrl_io_apb_PADDR;
  wire       [14:0]   axi_ram_io_axi_arbiter_io_readInputs_0_ar_payload_addr;
  wire       [14:0]   axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr;
  wire       [27:0]   axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_ar_payload_addr;
  wire       [27:0]   axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_ar_payload_addr;
  wire       [27:0]   axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_arw_ready;
  wire       [19:0]   axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr;
  wire                axi_apbBridge_io_axi_arbiter_io_output_arw_ready;
  wire                axi_apbBridge_io_axi_arbiter_io_output_w_ready;
  wire                sysclk_clkout;
  wire                sysclk_lock;
  wire                memclk_clkout;
  wire                memclk_lock;
  wire                lcdclk_clkout;
  wire                lcdclk_lock;
  wire                bufferCC_37_io_dataOut;
  wire                axi_core_io_i_ar_valid;
  wire       [31:0]   axi_core_io_i_ar_payload_addr;
  wire       [3:0]    axi_core_io_i_ar_payload_cache;
  wire       [2:0]    axi_core_io_i_ar_payload_prot;
  wire                axi_core_io_i_r_ready;
  wire                axi_core_io_d_arw_valid;
  wire       [31:0]   axi_core_io_d_arw_payload_addr;
  wire       [2:0]    axi_core_io_d_arw_payload_size;
  wire       [3:0]    axi_core_io_d_arw_payload_cache;
  wire       [2:0]    axi_core_io_d_arw_payload_prot;
  wire                axi_core_io_d_arw_payload_write;
  wire                axi_core_io_d_w_valid;
  wire       [31:0]   axi_core_io_d_w_payload_data;
  wire       [3:0]    axi_core_io_d_w_payload_strb;
  wire                axi_core_io_d_w_payload_last;
  wire                axi_core_io_d_b_ready;
  wire                axi_core_io_d_r_ready;
  wire                axi_core_io_debugResetOut;
  wire                axi_core_io_debugBus_PREADY;
  wire       [31:0]   axi_core_io_debugBus_PRDATA;
  wire                axi_core_io_debugBus_PSLVERROR;
  wire                axi_ram_io_axi_arw_ready;
  wire                axi_ram_io_axi_w_ready;
  wire                axi_ram_io_axi_b_valid;
  wire       [3:0]    axi_ram_io_axi_b_payload_id;
  wire       [1:0]    axi_ram_io_axi_b_payload_resp;
  wire                axi_ram_io_axi_r_valid;
  wire       [31:0]   axi_ram_io_axi_r_payload_data;
  wire       [3:0]    axi_ram_io_axi_r_payload_id;
  wire       [1:0]    axi_ram_io_axi_r_payload_resp;
  wire                axi_ram_io_axi_r_payload_last;
  wire                axi_sdramCtrl_io_axi_arw_ready;
  wire                axi_sdramCtrl_io_axi_w_ready;
  wire                axi_sdramCtrl_io_axi_b_valid;
  wire       [3:0]    axi_sdramCtrl_io_axi_b_payload_id;
  wire       [1:0]    axi_sdramCtrl_io_axi_b_payload_resp;
  wire                axi_sdramCtrl_io_axi_r_valid;
  wire       [31:0]   axi_sdramCtrl_io_axi_r_payload_data;
  wire       [3:0]    axi_sdramCtrl_io_axi_r_payload_id;
  wire       [1:0]    axi_sdramCtrl_io_axi_r_payload_resp;
  wire                axi_sdramCtrl_io_axi_r_payload_last;
  wire       [13:0]   axi_sdramCtrl_io_ddr_iface_O_ddr_addr;
  wire       [2:0]    axi_sdramCtrl_io_ddr_iface_O_ddr_ba;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_cs_n;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_ras_n;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_cas_n;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_we_n;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_clk;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_clk_n;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_cke;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_odt;
  wire                axi_sdramCtrl_io_ddr_iface_O_ddr_reset_n;
  wire       [1:0]    axi_sdramCtrl_io_ddr_iface_O_ddr_dqm;
  wire                axi_sdramCtrl_io_init_calib_complete;
  wire                axi_apbBridge_io_axi_arw_ready;
  wire                axi_apbBridge_io_axi_w_ready;
  wire                axi_apbBridge_io_axi_b_valid;
  wire       [3:0]    axi_apbBridge_io_axi_b_payload_id;
  wire       [1:0]    axi_apbBridge_io_axi_b_payload_resp;
  wire                axi_apbBridge_io_axi_r_valid;
  wire       [31:0]   axi_apbBridge_io_axi_r_payload_data;
  wire       [3:0]    axi_apbBridge_io_axi_r_payload_id;
  wire       [1:0]    axi_apbBridge_io_axi_r_payload_resp;
  wire                axi_apbBridge_io_axi_r_payload_last;
  wire       [19:0]   axi_apbBridge_io_apb_PADDR;
  wire       [0:0]    axi_apbBridge_io_apb_PSEL;
  wire                axi_apbBridge_io_apb_PENABLE;
  wire                axi_apbBridge_io_apb_PWRITE;
  wire       [31:0]   axi_apbBridge_io_apb_PWDATA;
  wire                axi_afioCtrl_io_apb_PREADY;
  wire       [31:0]   axi_afioCtrl_io_apb_PRDATA;
  wire                axi_afioCtrl_io_apb_PSLVERROR;
  wire       [31:0]   axi_afioCtrl_io_device_write;
  wire       [31:0]   axi_afioCtrl_io_device_writeEnable;
  wire       [31:0]   axi_afioCtrl_io_afio_write;
  wire       [31:0]   axi_afioCtrl_io_afio_writeEnable;
  wire       [15:0]   axi_afioCtrl_io_afioExti;
  wire                axi_extiCtrl_io_apb_PREADY;
  wire       [31:0]   axi_extiCtrl_io_apb_PRDATA;
  wire                axi_extiCtrl_io_apb_PSLVERROR;
  wire       [15:0]   axi_extiCtrl_io_interrupt;
  wire                axi_gpioCtrl_io_apb_PREADY;
  wire       [31:0]   axi_gpioCtrl_io_apb_PRDATA;
  wire                axi_gpioCtrl_io_apb_PSLVERROR;
  wire       [31:0]   axi_gpioCtrl_io_gpio_write;
  wire       [31:0]   axi_gpioCtrl_io_gpio_writeEnable;
  wire                axi_timCtrl_io_apb_PREADY;
  wire       [31:0]   axi_timCtrl_io_apb_PRDATA;
  wire                axi_timCtrl_io_apb_PSLVERROR;
  wire       [7:0]    axi_timCtrl_io_tim_ch;
  wire       [1:0]    axi_timCtrl_io_interrupt;
  wire                axi_wdgCtrl_io_apb_PREADY;
  wire       [31:0]   axi_wdgCtrl_io_apb_PRDATA;
  wire                axi_wdgCtrl_io_apb_PSLVERROR;
  wire                axi_wdgCtrl_io_iwdgRst;
  wire                axi_wdgCtrl_io_wwdgRst;
  wire                axi_systickCtrl_io_apb_PREADY;
  wire       [31:0]   axi_systickCtrl_io_apb_PRDATA;
  wire                axi_systickCtrl_io_apb_PSLVERROR;
  wire                axi_systickCtrl_io_interrupt;
  wire                axi_uartCtrl_io_apb_PREADY;
  wire       [31:0]   axi_uartCtrl_io_apb_PRDATA;
  wire                axi_uartCtrl_io_apb_PSLVERROR;
  wire                axi_uartCtrl_io_uarts_0_txd;
  wire                axi_uartCtrl_io_uarts_1_txd;
  wire       [1:0]    axi_uartCtrl_io_interrupt;
  wire                axi_lcdCtrl_io_apb_PREADY;
  wire       [31:0]   axi_lcdCtrl_io_apb_PRDATA;
  wire                axi_lcdCtrl_io_axi_ar_valid;
  wire       [31:0]   axi_lcdCtrl_io_axi_ar_payload_addr;
  wire       [7:0]    axi_lcdCtrl_io_axi_ar_payload_len;
  wire       [2:0]    axi_lcdCtrl_io_axi_ar_payload_size;
  wire       [3:0]    axi_lcdCtrl_io_axi_ar_payload_cache;
  wire       [2:0]    axi_lcdCtrl_io_axi_ar_payload_prot;
  wire                axi_lcdCtrl_io_axi_r_ready;
  wire                axi_lcdCtrl_io_dvti_vs;
  wire                axi_lcdCtrl_io_dvti_hs;
  wire                axi_lcdCtrl_io_dvti_de;
  wire       [15:0]   axi_lcdCtrl_io_dvti_data;
  wire                axi_lcdCtrl_io_interrupt;
  wire                axi_core_io_i_decoder_io_input_ar_ready;
  wire                axi_core_io_i_decoder_io_input_r_valid;
  wire       [31:0]   axi_core_io_i_decoder_io_input_r_payload_data;
  wire                axi_core_io_i_decoder_io_input_r_payload_last;
  wire                axi_core_io_i_decoder_io_outputs_0_ar_valid;
  wire       [31:0]   axi_core_io_i_decoder_io_outputs_0_ar_payload_addr;
  wire       [3:0]    axi_core_io_i_decoder_io_outputs_0_ar_payload_cache;
  wire       [2:0]    axi_core_io_i_decoder_io_outputs_0_ar_payload_prot;
  wire                axi_core_io_i_decoder_io_outputs_0_r_ready;
  wire                axi_core_io_i_decoder_io_outputs_1_ar_valid;
  wire       [31:0]   axi_core_io_i_decoder_io_outputs_1_ar_payload_addr;
  wire       [3:0]    axi_core_io_i_decoder_io_outputs_1_ar_payload_cache;
  wire       [2:0]    axi_core_io_i_decoder_io_outputs_1_ar_payload_prot;
  wire                axi_core_io_i_decoder_io_outputs_1_r_ready;
  wire                axi_core_io_d_decoder_io_input_arw_ready;
  wire                axi_core_io_d_decoder_io_input_w_ready;
  wire                axi_core_io_d_decoder_io_input_b_valid;
  wire                axi_core_io_d_decoder_io_input_r_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_input_r_payload_data;
  wire                axi_core_io_d_decoder_io_input_r_payload_last;
  wire                axi_core_io_d_decoder_io_sharedOutputs_0_arw_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_addr;
  wire       [2:0]    axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_size;
  wire       [3:0]    axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_cache;
  wire       [2:0]    axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_prot;
  wire                axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_write;
  wire                axi_core_io_d_decoder_io_sharedOutputs_0_w_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_data;
  wire       [3:0]    axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_strb;
  wire                axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_last;
  wire                axi_core_io_d_decoder_io_sharedOutputs_0_b_ready;
  wire                axi_core_io_d_decoder_io_sharedOutputs_0_r_ready;
  wire                axi_core_io_d_decoder_io_sharedOutputs_1_arw_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_addr;
  wire       [2:0]    axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_size;
  wire       [3:0]    axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_cache;
  wire       [2:0]    axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_prot;
  wire                axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_write;
  wire                axi_core_io_d_decoder_io_sharedOutputs_1_w_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_data;
  wire       [3:0]    axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_strb;
  wire                axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_last;
  wire                axi_core_io_d_decoder_io_sharedOutputs_1_b_ready;
  wire                axi_core_io_d_decoder_io_sharedOutputs_1_r_ready;
  wire                axi_core_io_d_decoder_io_sharedOutputs_2_arw_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_addr;
  wire       [2:0]    axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_size;
  wire       [3:0]    axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_cache;
  wire       [2:0]    axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_prot;
  wire                axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_write;
  wire                axi_core_io_d_decoder_io_sharedOutputs_2_w_valid;
  wire       [31:0]   axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_data;
  wire       [3:0]    axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_strb;
  wire                axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_last;
  wire                axi_core_io_d_decoder_io_sharedOutputs_2_b_ready;
  wire                axi_core_io_d_decoder_io_sharedOutputs_2_r_ready;
  wire                axi_lcdCtrl_io_axi_decoder_io_input_ar_ready;
  wire                axi_lcdCtrl_io_axi_decoder_io_input_r_valid;
  wire       [31:0]   axi_lcdCtrl_io_axi_decoder_io_input_r_payload_data;
  wire                axi_lcdCtrl_io_axi_decoder_io_input_r_payload_last;
  wire                axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_valid;
  wire       [31:0]   axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_addr;
  wire       [7:0]    axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_size;
  wire       [3:0]    axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_cache;
  wire       [2:0]    axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_prot;
  wire                axi_lcdCtrl_io_axi_decoder_io_outputs_0_r_ready;
  wire                axi_ram_io_axi_arbiter_io_readInputs_0_ar_ready;
  wire                axi_ram_io_axi_arbiter_io_readInputs_0_r_valid;
  wire       [31:0]   axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_data;
  wire       [2:0]    axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_id;
  wire       [1:0]    axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_resp;
  wire                axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_last;
  wire                axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  wire                axi_ram_io_axi_arbiter_io_sharedInputs_0_w_ready;
  wire                axi_ram_io_axi_arbiter_io_sharedInputs_0_b_valid;
  wire       [2:0]    axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_id;
  wire       [1:0]    axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp;
  wire                axi_ram_io_axi_arbiter_io_sharedInputs_0_r_valid;
  wire       [31:0]   axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_data;
  wire       [2:0]    axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_id;
  wire       [1:0]    axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp;
  wire                axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_last;
  wire                axi_ram_io_axi_arbiter_io_output_arw_valid;
  wire       [14:0]   axi_ram_io_axi_arbiter_io_output_arw_payload_addr;
  wire       [3:0]    axi_ram_io_axi_arbiter_io_output_arw_payload_id;
  wire       [7:0]    axi_ram_io_axi_arbiter_io_output_arw_payload_len;
  wire       [2:0]    axi_ram_io_axi_arbiter_io_output_arw_payload_size;
  wire       [1:0]    axi_ram_io_axi_arbiter_io_output_arw_payload_burst;
  wire                axi_ram_io_axi_arbiter_io_output_arw_payload_write;
  wire                axi_ram_io_axi_arbiter_io_output_w_valid;
  wire       [31:0]   axi_ram_io_axi_arbiter_io_output_w_payload_data;
  wire       [3:0]    axi_ram_io_axi_arbiter_io_output_w_payload_strb;
  wire                axi_ram_io_axi_arbiter_io_output_w_payload_last;
  wire                axi_ram_io_axi_arbiter_io_output_b_ready;
  wire                axi_ram_io_axi_arbiter_io_output_r_ready;
  wire                axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_ar_ready;
  wire                axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_valid;
  wire       [31:0]   axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_data;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_id;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_resp;
  wire                axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_last;
  wire                axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_ar_ready;
  wire                axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_valid;
  wire       [31:0]   axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_data;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_id;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_resp;
  wire                axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_last;
  wire                axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  wire                axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_w_ready;
  wire                axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_valid;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_payload_id;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_payload_resp;
  wire                axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_valid;
  wire       [31:0]   axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_data;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_id;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_resp;
  wire                axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_last;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_arw_valid;
  wire       [27:0]   axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_addr;
  wire       [3:0]    axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_id;
  wire       [7:0]    axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_len;
  wire       [2:0]    axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_size;
  wire       [1:0]    axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_burst;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_write;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_w_valid;
  wire       [31:0]   axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_data;
  wire       [3:0]    axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_strb;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_last;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_b_ready;
  wire                axi_sdramCtrl_io_axi_arbiter_io_output_r_ready;
  wire                axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  wire                axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_w_ready;
  wire                axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_valid;
  wire       [3:0]    axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_payload_id;
  wire       [1:0]    axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_payload_resp;
  wire                axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_valid;
  wire       [31:0]   axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_data;
  wire       [3:0]    axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_id;
  wire       [1:0]    axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_resp;
  wire                axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_last;
  wire                axi_apbBridge_io_axi_arbiter_io_output_arw_valid;
  wire       [19:0]   axi_apbBridge_io_axi_arbiter_io_output_arw_payload_addr;
  wire       [3:0]    axi_apbBridge_io_axi_arbiter_io_output_arw_payload_id;
  wire       [7:0]    axi_apbBridge_io_axi_arbiter_io_output_arw_payload_len;
  wire       [2:0]    axi_apbBridge_io_axi_arbiter_io_output_arw_payload_size;
  wire       [1:0]    axi_apbBridge_io_axi_arbiter_io_output_arw_payload_burst;
  wire                axi_apbBridge_io_axi_arbiter_io_output_arw_payload_write;
  wire                axi_apbBridge_io_axi_arbiter_io_output_w_valid;
  wire       [31:0]   axi_apbBridge_io_axi_arbiter_io_output_w_payload_data;
  wire       [3:0]    axi_apbBridge_io_axi_arbiter_io_output_w_payload_strb;
  wire                axi_apbBridge_io_axi_arbiter_io_output_w_payload_last;
  wire                axi_apbBridge_io_axi_arbiter_io_output_b_ready;
  wire                axi_apbBridge_io_axi_arbiter_io_output_r_ready;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [19:0]   io_apb_decoder_io_output_PADDR;
  wire       [8:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_5_io_input_PREADY;
  wire       [31:0]   apb3Router_5_io_input_PRDATA;
  wire                apb3Router_5_io_input_PSLVERROR;
  wire       [19:0]   apb3Router_5_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_0_PSEL;
  wire                apb3Router_5_io_outputs_0_PENABLE;
  wire                apb3Router_5_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_0_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_1_PSEL;
  wire                apb3Router_5_io_outputs_1_PENABLE;
  wire                apb3Router_5_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_1_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_2_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_2_PSEL;
  wire                apb3Router_5_io_outputs_2_PENABLE;
  wire                apb3Router_5_io_outputs_2_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_2_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_3_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_3_PSEL;
  wire                apb3Router_5_io_outputs_3_PENABLE;
  wire                apb3Router_5_io_outputs_3_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_3_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_4_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_4_PSEL;
  wire                apb3Router_5_io_outputs_4_PENABLE;
  wire                apb3Router_5_io_outputs_4_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_4_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_5_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_5_PSEL;
  wire                apb3Router_5_io_outputs_5_PENABLE;
  wire                apb3Router_5_io_outputs_5_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_5_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_6_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_6_PSEL;
  wire                apb3Router_5_io_outputs_6_PENABLE;
  wire                apb3Router_5_io_outputs_6_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_6_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_7_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_7_PSEL;
  wire                apb3Router_5_io_outputs_7_PENABLE;
  wire                apb3Router_5_io_outputs_7_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_7_PWDATA;
  wire       [19:0]   apb3Router_5_io_outputs_8_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_8_PSEL;
  wire                apb3Router_5_io_outputs_8_PENABLE;
  wire                apb3Router_5_io_outputs_8_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_8_PWDATA;
  reg                 resetCtrl_axiResetUnbuffered;
  reg                 resetCtrl_coreResetUnbuffered;
  reg        [5:0]    resetCtrl_axiResetCounter;
  wire       [5:0]    _zz_when_cyberwithddrlcd_l132;
  wire                when_cyberwithddrlcd_l132;
  wire                when_cyberwithddrlcd_l136;
  reg                 resetCtrl_axiReset;
  reg                 resetCtrl_coreReset;
  wire                axi_extiInterrupt;
  wire                axi_timInterrupt;
  wire                when_cyberwithddrlcd_l234;
  wire                axi_systickInterrupt;
  wire                axi_uartInterrupt;
  wire                io_outputs_0_ar_validPipe_valid;
  wire                io_outputs_0_ar_validPipe_ready;
  wire       [31:0]   io_outputs_0_ar_validPipe_payload_addr;
  wire       [3:0]    io_outputs_0_ar_validPipe_payload_cache;
  wire       [2:0]    io_outputs_0_ar_validPipe_payload_prot;
  reg                 io_outputs_0_ar_rValid;
  wire                io_outputs_0_ar_validPipe_fire;
  wire                io_outputs_1_ar_validPipe_valid;
  wire                io_outputs_1_ar_validPipe_ready;
  wire       [31:0]   io_outputs_1_ar_validPipe_payload_addr;
  wire       [3:0]    io_outputs_1_ar_validPipe_payload_cache;
  wire       [2:0]    io_outputs_1_ar_validPipe_payload_prot;
  reg                 io_outputs_1_ar_rValid;
  wire                io_outputs_1_ar_validPipe_fire;
  wire                io_sharedOutputs_0_arw_validPipe_valid;
  wire                io_sharedOutputs_0_arw_validPipe_ready;
  wire       [31:0]   io_sharedOutputs_0_arw_validPipe_payload_addr;
  wire       [2:0]    io_sharedOutputs_0_arw_validPipe_payload_size;
  wire       [3:0]    io_sharedOutputs_0_arw_validPipe_payload_cache;
  wire       [2:0]    io_sharedOutputs_0_arw_validPipe_payload_prot;
  wire                io_sharedOutputs_0_arw_validPipe_payload_write;
  reg                 io_sharedOutputs_0_arw_rValid;
  wire                io_sharedOutputs_0_arw_validPipe_fire;
  wire                io_sharedOutputs_1_arw_validPipe_valid;
  wire                io_sharedOutputs_1_arw_validPipe_ready;
  wire       [31:0]   io_sharedOutputs_1_arw_validPipe_payload_addr;
  wire       [2:0]    io_sharedOutputs_1_arw_validPipe_payload_size;
  wire       [3:0]    io_sharedOutputs_1_arw_validPipe_payload_cache;
  wire       [2:0]    io_sharedOutputs_1_arw_validPipe_payload_prot;
  wire                io_sharedOutputs_1_arw_validPipe_payload_write;
  reg                 io_sharedOutputs_1_arw_rValid;
  wire                io_sharedOutputs_1_arw_validPipe_fire;
  wire                io_sharedOutputs_2_arw_validPipe_valid;
  wire                io_sharedOutputs_2_arw_validPipe_ready;
  wire       [31:0]   io_sharedOutputs_2_arw_validPipe_payload_addr;
  wire       [2:0]    io_sharedOutputs_2_arw_validPipe_payload_size;
  wire       [3:0]    io_sharedOutputs_2_arw_validPipe_payload_cache;
  wire       [2:0]    io_sharedOutputs_2_arw_validPipe_payload_prot;
  wire                io_sharedOutputs_2_arw_validPipe_payload_write;
  reg                 io_sharedOutputs_2_arw_rValid;
  wire                io_sharedOutputs_2_arw_validPipe_fire;
  wire                io_outputs_0_ar_validPipe_valid_1;
  wire                io_outputs_0_ar_validPipe_ready_1;
  wire       [31:0]   io_outputs_0_ar_validPipe_payload_addr_1;
  wire       [7:0]    io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    io_outputs_0_ar_validPipe_payload_size;
  wire       [3:0]    io_outputs_0_ar_validPipe_payload_cache_1;
  wire       [2:0]    io_outputs_0_ar_validPipe_payload_prot_1;
  reg                 io_outputs_0_ar_rValid_1;
  wire                io_outputs_0_ar_validPipe_fire_1;
  wire       [2:0]    _zz_io_readInputs_0_ar_payload_id;
  wire       [7:0]    _zz_io_readInputs_0_ar_payload_len;
  wire       [2:0]    _zz_io_sharedInputs_0_arw_payload_id;
  wire       [7:0]    _zz_io_sharedInputs_0_arw_payload_len;
  wire       [1:0]    _zz_io_readInputs_0_ar_payload_id_1;
  wire       [7:0]    _zz_io_readInputs_0_ar_payload_len_1;
  wire       [1:0]    _zz_io_readInputs_1_ar_payload_id;
  wire       [1:0]    _zz_io_sharedInputs_0_arw_payload_id_1;
  wire       [7:0]    _zz_io_sharedInputs_0_arw_payload_len_1;
  wire                io_output_arw_halfPipe_valid;
  wire                io_output_arw_halfPipe_ready;
  wire       [27:0]   io_output_arw_halfPipe_payload_addr;
  wire       [3:0]    io_output_arw_halfPipe_payload_id;
  wire       [7:0]    io_output_arw_halfPipe_payload_len;
  wire       [2:0]    io_output_arw_halfPipe_payload_size;
  wire       [1:0]    io_output_arw_halfPipe_payload_burst;
  wire                io_output_arw_halfPipe_payload_write;
  reg                 io_output_arw_rValid;
  wire                io_output_arw_halfPipe_fire;
  reg        [27:0]   io_output_arw_rData_addr;
  reg        [3:0]    io_output_arw_rData_id;
  reg        [7:0]    io_output_arw_rData_len;
  reg        [2:0]    io_output_arw_rData_size;
  reg        [1:0]    io_output_arw_rData_burst;
  reg                 io_output_arw_rData_write;
  wire                io_output_w_s2mPipe_valid;
  reg                 io_output_w_s2mPipe_ready;
  wire       [31:0]   io_output_w_s2mPipe_payload_data;
  wire       [3:0]    io_output_w_s2mPipe_payload_strb;
  wire                io_output_w_s2mPipe_payload_last;
  reg                 io_output_w_rValidN;
  reg        [31:0]   io_output_w_rData_data;
  reg        [3:0]    io_output_w_rData_strb;
  reg                 io_output_w_rData_last;
  wire                io_output_w_s2mPipe_m2sPipe_valid;
  wire                io_output_w_s2mPipe_m2sPipe_ready;
  wire       [31:0]   io_output_w_s2mPipe_m2sPipe_payload_data;
  wire       [3:0]    io_output_w_s2mPipe_m2sPipe_payload_strb;
  wire                io_output_w_s2mPipe_m2sPipe_payload_last;
  reg                 io_output_w_s2mPipe_rValid;
  reg        [31:0]   io_output_w_s2mPipe_rData_data;
  reg        [3:0]    io_output_w_s2mPipe_rData_strb;
  reg                 io_output_w_s2mPipe_rData_last;
  wire                when_Stream_l399;
  wire       [3:0]    _zz_io_sharedInputs_0_arw_payload_id_2;
  wire       [7:0]    _zz_io_sharedInputs_0_arw_payload_len_2;
  wire                io_output_arw_halfPipe_valid_1;
  wire                io_output_arw_halfPipe_ready_1;
  wire       [19:0]   io_output_arw_halfPipe_payload_addr_1;
  wire       [3:0]    io_output_arw_halfPipe_payload_id_1;
  wire       [7:0]    io_output_arw_halfPipe_payload_len_1;
  wire       [2:0]    io_output_arw_halfPipe_payload_size_1;
  wire       [1:0]    io_output_arw_halfPipe_payload_burst_1;
  wire                io_output_arw_halfPipe_payload_write_1;
  reg                 io_output_arw_rValid_1;
  wire                io_output_arw_halfPipe_fire_1;
  reg        [19:0]   io_output_arw_rData_addr_1;
  reg        [3:0]    io_output_arw_rData_id_1;
  reg        [7:0]    io_output_arw_rData_len_1;
  reg        [2:0]    io_output_arw_rData_size_1;
  reg        [1:0]    io_output_arw_rData_burst_1;
  reg                 io_output_arw_rData_write_1;
  wire                io_output_w_halfPipe_valid;
  wire                io_output_w_halfPipe_ready;
  wire       [31:0]   io_output_w_halfPipe_payload_data;
  wire       [3:0]    io_output_w_halfPipe_payload_strb;
  wire                io_output_w_halfPipe_payload_last;
  reg                 io_output_w_rValid;
  wire                io_output_w_halfPipe_fire;
  reg        [31:0]   io_output_w_rData_data_1;
  reg        [3:0]    io_output_w_rData_strb_1;
  reg                 io_output_w_rData_last_1;

  syspll sysclk (
    .clkout (sysclk_clkout), //o
    .lock   (sysclk_lock  ), //o
    .reset  (1'b0         ), //i
    .clkin  (io_clk       )  //i
  );
  mempll memclk (
    .clkout (memclk_clkout), //o
    .lock   (memclk_lock  ), //o
    .reset  (1'b0         ), //i
    .clkin  (sysclk_clkout)  //i
  );
  lcdpll lcdclk (
    .clkout (lcdclk_clkout), //o
    .lock   (lcdclk_lock  ), //o
    .reset  (1'b0         ), //i
    .clkin  (io_clk       )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_36 bufferCC_37 (
    .io_dataIn  (bufferCC_37_io_dataIn ), //i
    .io_dataOut (bufferCC_37_io_dataOut), //o
    .clkout     (sysclk_clkout         )  //i
  );
  RiscvAxi4 axi_core (
    .io_i_ar_valid          (axi_core_io_i_ar_valid                             ), //o
    .io_i_ar_ready          (axi_core_io_i_decoder_io_input_ar_ready            ), //i
    .io_i_ar_payload_addr   (axi_core_io_i_ar_payload_addr[31:0]                ), //o
    .io_i_ar_payload_cache  (axi_core_io_i_ar_payload_cache[3:0]                ), //o
    .io_i_ar_payload_prot   (axi_core_io_i_ar_payload_prot[2:0]                 ), //o
    .io_i_r_valid           (axi_core_io_i_decoder_io_input_r_valid             ), //i
    .io_i_r_ready           (axi_core_io_i_r_ready                              ), //o
    .io_i_r_payload_data    (axi_core_io_i_decoder_io_input_r_payload_data[31:0]), //i
    .io_i_r_payload_last    (axi_core_io_i_decoder_io_input_r_payload_last      ), //i
    .io_d_arw_valid         (axi_core_io_d_arw_valid                            ), //o
    .io_d_arw_ready         (axi_core_io_d_decoder_io_input_arw_ready           ), //i
    .io_d_arw_payload_addr  (axi_core_io_d_arw_payload_addr[31:0]               ), //o
    .io_d_arw_payload_size  (axi_core_io_d_arw_payload_size[2:0]                ), //o
    .io_d_arw_payload_cache (axi_core_io_d_arw_payload_cache[3:0]               ), //o
    .io_d_arw_payload_prot  (axi_core_io_d_arw_payload_prot[2:0]                ), //o
    .io_d_arw_payload_write (axi_core_io_d_arw_payload_write                    ), //o
    .io_d_w_valid           (axi_core_io_d_w_valid                              ), //o
    .io_d_w_ready           (axi_core_io_d_decoder_io_input_w_ready             ), //i
    .io_d_w_payload_data    (axi_core_io_d_w_payload_data[31:0]                 ), //o
    .io_d_w_payload_strb    (axi_core_io_d_w_payload_strb[3:0]                  ), //o
    .io_d_w_payload_last    (axi_core_io_d_w_payload_last                       ), //o
    .io_d_b_valid           (axi_core_io_d_decoder_io_input_b_valid             ), //i
    .io_d_b_ready           (axi_core_io_d_b_ready                              ), //o
    .io_d_r_valid           (axi_core_io_d_decoder_io_input_r_valid             ), //i
    .io_d_r_ready           (axi_core_io_d_r_ready                              ), //o
    .io_d_r_payload_data    (axi_core_io_d_decoder_io_input_r_payload_data[31:0]), //i
    .io_d_r_payload_last    (axi_core_io_d_decoder_io_input_r_payload_last      ), //i
    .io_interrupt           (axi_core_io_interrupt[3:0]                         ), //i
    .io_debugResetIn        (resetCtrl_axiReset                                 ), //i
    .io_debugResetOut       (axi_core_io_debugResetOut                          ), //o
    .io_debugBus_PADDR      (axi_core_io_debugBus_PADDR[11:0]                   ), //i
    .io_debugBus_PSEL       (apb3Router_5_io_outputs_8_PSEL                     ), //i
    .io_debugBus_PENABLE    (apb3Router_5_io_outputs_8_PENABLE                  ), //i
    .io_debugBus_PREADY     (axi_core_io_debugBus_PREADY                        ), //o
    .io_debugBus_PWRITE     (apb3Router_5_io_outputs_8_PWRITE                   ), //i
    .io_debugBus_PWDATA     (apb3Router_5_io_outputs_8_PWDATA[31:0]             ), //i
    .io_debugBus_PRDATA     (axi_core_io_debugBus_PRDATA[31:0]                  ), //o
    .io_debugBus_PSLVERROR  (axi_core_io_debugBus_PSLVERROR                     ), //o
    .clkout                 (sysclk_clkout                                      ), //i
    .resetCtrl_coreReset    (resetCtrl_coreReset                                )  //i
  );
  Axi4Ram axi_ram (
    .io_axi_arw_valid         (axi_ram_io_axi_arbiter_io_output_arw_valid             ), //i
    .io_axi_arw_ready         (axi_ram_io_axi_arw_ready                               ), //o
    .io_axi_arw_payload_addr  (axi_ram_io_axi_arbiter_io_output_arw_payload_addr[14:0]), //i
    .io_axi_arw_payload_id    (axi_ram_io_axi_arbiter_io_output_arw_payload_id[3:0]   ), //i
    .io_axi_arw_payload_len   (axi_ram_io_axi_arbiter_io_output_arw_payload_len[7:0]  ), //i
    .io_axi_arw_payload_size  (axi_ram_io_axi_arbiter_io_output_arw_payload_size[2:0] ), //i
    .io_axi_arw_payload_burst (axi_ram_io_axi_arbiter_io_output_arw_payload_burst[1:0]), //i
    .io_axi_arw_payload_write (axi_ram_io_axi_arbiter_io_output_arw_payload_write     ), //i
    .io_axi_w_valid           (axi_ram_io_axi_arbiter_io_output_w_valid               ), //i
    .io_axi_w_ready           (axi_ram_io_axi_w_ready                                 ), //o
    .io_axi_w_payload_data    (axi_ram_io_axi_arbiter_io_output_w_payload_data[31:0]  ), //i
    .io_axi_w_payload_strb    (axi_ram_io_axi_arbiter_io_output_w_payload_strb[3:0]   ), //i
    .io_axi_w_payload_last    (axi_ram_io_axi_arbiter_io_output_w_payload_last        ), //i
    .io_axi_b_valid           (axi_ram_io_axi_b_valid                                 ), //o
    .io_axi_b_ready           (axi_ram_io_axi_arbiter_io_output_b_ready               ), //i
    .io_axi_b_payload_id      (axi_ram_io_axi_b_payload_id[3:0]                       ), //o
    .io_axi_b_payload_resp    (axi_ram_io_axi_b_payload_resp[1:0]                     ), //o
    .io_axi_r_valid           (axi_ram_io_axi_r_valid                                 ), //o
    .io_axi_r_ready           (axi_ram_io_axi_arbiter_io_output_r_ready               ), //i
    .io_axi_r_payload_data    (axi_ram_io_axi_r_payload_data[31:0]                    ), //o
    .io_axi_r_payload_id      (axi_ram_io_axi_r_payload_id[3:0]                       ), //o
    .io_axi_r_payload_resp    (axi_ram_io_axi_r_payload_resp[1:0]                     ), //o
    .io_axi_r_payload_last    (axi_ram_io_axi_r_payload_last                          ), //o
    .clkout                   (sysclk_clkout                                          ), //i
    .resetCtrl_axiReset       (resetCtrl_axiReset                                     )  //i
  );
  Axi4Ddr axi_sdramCtrl (
    .resetCtrl_axiReset         (resetCtrl_axiReset                            ), //i
    .clkout                     (sysclk_clkout                                 ), //i
    .clkout_1                   (memclk_clkout                                 ), //i
    .io_pll_lock                (axi_sdramCtrl_io_pll_lock                     ), //i
    .io_axi_arw_valid           (io_output_arw_halfPipe_valid                  ), //i
    .io_axi_arw_ready           (axi_sdramCtrl_io_axi_arw_ready                ), //o
    .io_axi_arw_payload_addr    (io_output_arw_halfPipe_payload_addr[27:0]     ), //i
    .io_axi_arw_payload_id      (io_output_arw_halfPipe_payload_id[3:0]        ), //i
    .io_axi_arw_payload_len     (io_output_arw_halfPipe_payload_len[7:0]       ), //i
    .io_axi_arw_payload_size    (io_output_arw_halfPipe_payload_size[2:0]      ), //i
    .io_axi_arw_payload_burst   (io_output_arw_halfPipe_payload_burst[1:0]     ), //i
    .io_axi_arw_payload_write   (io_output_arw_halfPipe_payload_write          ), //i
    .io_axi_w_valid             (io_output_w_s2mPipe_m2sPipe_valid             ), //i
    .io_axi_w_ready             (axi_sdramCtrl_io_axi_w_ready                  ), //o
    .io_axi_w_payload_data      (io_output_w_s2mPipe_m2sPipe_payload_data[31:0]), //i
    .io_axi_w_payload_strb      (io_output_w_s2mPipe_m2sPipe_payload_strb[3:0] ), //i
    .io_axi_w_payload_last      (io_output_w_s2mPipe_m2sPipe_payload_last      ), //i
    .io_axi_b_valid             (axi_sdramCtrl_io_axi_b_valid                  ), //o
    .io_axi_b_ready             (axi_sdramCtrl_io_axi_arbiter_io_output_b_ready), //i
    .io_axi_b_payload_id        (axi_sdramCtrl_io_axi_b_payload_id[3:0]        ), //o
    .io_axi_b_payload_resp      (axi_sdramCtrl_io_axi_b_payload_resp[1:0]      ), //o
    .io_axi_r_valid             (axi_sdramCtrl_io_axi_r_valid                  ), //o
    .io_axi_r_ready             (axi_sdramCtrl_io_axi_arbiter_io_output_r_ready), //i
    .io_axi_r_payload_data      (axi_sdramCtrl_io_axi_r_payload_data[31:0]     ), //o
    .io_axi_r_payload_id        (axi_sdramCtrl_io_axi_r_payload_id[3:0]        ), //o
    .io_axi_r_payload_resp      (axi_sdramCtrl_io_axi_r_payload_resp[1:0]      ), //o
    .io_axi_r_payload_last      (axi_sdramCtrl_io_axi_r_payload_last           ), //o
    .io_ddr_iface_O_ddr_addr    (axi_sdramCtrl_io_ddr_iface_O_ddr_addr[13:0]   ), //o
    .io_ddr_iface_O_ddr_ba      (axi_sdramCtrl_io_ddr_iface_O_ddr_ba[2:0]      ), //o
    .io_ddr_iface_O_ddr_cs_n    (axi_sdramCtrl_io_ddr_iface_O_ddr_cs_n         ), //o
    .io_ddr_iface_O_ddr_ras_n   (axi_sdramCtrl_io_ddr_iface_O_ddr_ras_n        ), //o
    .io_ddr_iface_O_ddr_cas_n   (axi_sdramCtrl_io_ddr_iface_O_ddr_cas_n        ), //o
    .io_ddr_iface_O_ddr_we_n    (axi_sdramCtrl_io_ddr_iface_O_ddr_we_n         ), //o
    .io_ddr_iface_O_ddr_clk     (axi_sdramCtrl_io_ddr_iface_O_ddr_clk          ), //o
    .io_ddr_iface_O_ddr_clk_n   (axi_sdramCtrl_io_ddr_iface_O_ddr_clk_n        ), //o
    .io_ddr_iface_O_ddr_cke     (axi_sdramCtrl_io_ddr_iface_O_ddr_cke          ), //o
    .io_ddr_iface_O_ddr_odt     (axi_sdramCtrl_io_ddr_iface_O_ddr_odt          ), //o
    .io_ddr_iface_O_ddr_reset_n (axi_sdramCtrl_io_ddr_iface_O_ddr_reset_n      ), //o
    .io_ddr_iface_O_ddr_dqm     (axi_sdramCtrl_io_ddr_iface_O_ddr_dqm[1:0]     ), //o
    .io_ddr_iface_IO_ddr_dq     (io_sdram_IO_ddr_dq                            ), //~
    .io_ddr_iface_IO_ddr_dqs    (io_sdram_IO_ddr_dqs                           ), //~
    .io_ddr_iface_IO_ddr_dqs_n  (io_sdram_IO_ddr_dqs_n                         ), //~
    .io_init_calib_complete     (axi_sdramCtrl_io_init_calib_complete          )  //o
  );
  Axi4SharedToApb3Bridge axi_apbBridge (
    .io_axi_arw_valid         (io_output_arw_halfPipe_valid_1                ), //i
    .io_axi_arw_ready         (axi_apbBridge_io_axi_arw_ready                ), //o
    .io_axi_arw_payload_addr  (io_output_arw_halfPipe_payload_addr_1[19:0]   ), //i
    .io_axi_arw_payload_id    (io_output_arw_halfPipe_payload_id_1[3:0]      ), //i
    .io_axi_arw_payload_len   (io_output_arw_halfPipe_payload_len_1[7:0]     ), //i
    .io_axi_arw_payload_size  (io_output_arw_halfPipe_payload_size_1[2:0]    ), //i
    .io_axi_arw_payload_burst (io_output_arw_halfPipe_payload_burst_1[1:0]   ), //i
    .io_axi_arw_payload_write (io_output_arw_halfPipe_payload_write_1        ), //i
    .io_axi_w_valid           (io_output_w_halfPipe_valid                    ), //i
    .io_axi_w_ready           (axi_apbBridge_io_axi_w_ready                  ), //o
    .io_axi_w_payload_data    (io_output_w_halfPipe_payload_data[31:0]       ), //i
    .io_axi_w_payload_strb    (io_output_w_halfPipe_payload_strb[3:0]        ), //i
    .io_axi_w_payload_last    (io_output_w_halfPipe_payload_last             ), //i
    .io_axi_b_valid           (axi_apbBridge_io_axi_b_valid                  ), //o
    .io_axi_b_ready           (axi_apbBridge_io_axi_arbiter_io_output_b_ready), //i
    .io_axi_b_payload_id      (axi_apbBridge_io_axi_b_payload_id[3:0]        ), //o
    .io_axi_b_payload_resp    (axi_apbBridge_io_axi_b_payload_resp[1:0]      ), //o
    .io_axi_r_valid           (axi_apbBridge_io_axi_r_valid                  ), //o
    .io_axi_r_ready           (axi_apbBridge_io_axi_arbiter_io_output_r_ready), //i
    .io_axi_r_payload_data    (axi_apbBridge_io_axi_r_payload_data[31:0]     ), //o
    .io_axi_r_payload_id      (axi_apbBridge_io_axi_r_payload_id[3:0]        ), //o
    .io_axi_r_payload_resp    (axi_apbBridge_io_axi_r_payload_resp[1:0]      ), //o
    .io_axi_r_payload_last    (axi_apbBridge_io_axi_r_payload_last           ), //o
    .io_apb_PADDR             (axi_apbBridge_io_apb_PADDR[19:0]              ), //o
    .io_apb_PSEL              (axi_apbBridge_io_apb_PSEL                     ), //o
    .io_apb_PENABLE           (axi_apbBridge_io_apb_PENABLE                  ), //o
    .io_apb_PREADY            (io_apb_decoder_io_input_PREADY                ), //i
    .io_apb_PWRITE            (axi_apbBridge_io_apb_PWRITE                   ), //o
    .io_apb_PWDATA            (axi_apbBridge_io_apb_PWDATA[31:0]             ), //o
    .io_apb_PRDATA            (io_apb_decoder_io_input_PRDATA[31:0]          ), //i
    .io_apb_PSLVERROR         (io_apb_decoder_io_input_PSLVERROR             ), //i
    .clkout                   (sysclk_clkout                                 ), //i
    .resetCtrl_axiReset       (resetCtrl_axiReset                            )  //i
  );
  Apb3Afio axi_afioCtrl (
    .io_apb_PADDR          (axi_afioCtrl_io_apb_PADDR[4:0]          ), //i
    .io_apb_PSEL           (apb3Router_5_io_outputs_6_PSEL          ), //i
    .io_apb_PENABLE        (apb3Router_5_io_outputs_6_PENABLE       ), //i
    .io_apb_PREADY         (axi_afioCtrl_io_apb_PREADY              ), //o
    .io_apb_PWRITE         (apb3Router_5_io_outputs_6_PWRITE        ), //i
    .io_apb_PWDATA         (apb3Router_5_io_outputs_6_PWDATA[31:0]  ), //i
    .io_apb_PRDATA         (axi_afioCtrl_io_apb_PRDATA[31:0]        ), //o
    .io_apb_PSLVERROR      (axi_afioCtrl_io_apb_PSLVERROR           ), //o
    .io_device_read        (axi_afioCtrl_io_device_read[31:0]       ), //i
    .io_device_write       (axi_afioCtrl_io_device_write[31:0]      ), //o
    .io_device_writeEnable (axi_afioCtrl_io_device_writeEnable[31:0]), //o
    .io_afio_read          (axi_gpioCtrl_io_gpio_read[31:0]         ), //i
    .io_afio_write         (axi_afioCtrl_io_afio_write[31:0]        ), //o
    .io_afio_writeEnable   (axi_afioCtrl_io_afio_writeEnable[31:0]  ), //o
    .io_afioExti           (axi_afioCtrl_io_afioExti[15:0]          ), //o
    .clkout                (sysclk_clkout                           ), //i
    .resetCtrl_axiReset    (resetCtrl_axiReset                      )  //i
  );
  Apb3Exti axi_extiCtrl (
    .io_apb_PADDR       (axi_extiCtrl_io_apb_PADDR[4:0]        ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_7_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_7_PENABLE     ), //i
    .io_apb_PREADY      (axi_extiCtrl_io_apb_PREADY            ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_7_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_7_PWDATA[31:0]), //i
    .io_apb_PRDATA      (axi_extiCtrl_io_apb_PRDATA[31:0]      ), //o
    .io_apb_PSLVERROR   (axi_extiCtrl_io_apb_PSLVERROR         ), //o
    .io_exti            (axi_afioCtrl_io_afioExti[15:0]        ), //i
    .io_interrupt       (axi_extiCtrl_io_interrupt[15:0]       ), //o
    .clkout             (sysclk_clkout                         ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  Apb3GpioArray axi_gpioCtrl (
    .io_apb_PADDR        (axi_gpioCtrl_io_apb_PADDR[12:0]       ), //i
    .io_apb_PSEL         (apb3Router_5_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_5_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY       (axi_gpioCtrl_io_apb_PREADY            ), //o
    .io_apb_PWRITE       (apb3Router_5_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_5_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA       (axi_gpioCtrl_io_apb_PRDATA[31:0]      ), //o
    .io_apb_PSLVERROR    (axi_gpioCtrl_io_apb_PSLVERROR         ), //o
    .io_gpio_read        (axi_gpioCtrl_io_gpio_read[31:0]       ), //i
    .io_gpio_write       (axi_gpioCtrl_io_gpio_write[31:0]      ), //o
    .io_gpio_writeEnable (axi_gpioCtrl_io_gpio_writeEnable[31:0]), //o
    .io_afio             (axi_afioCtrl_io_afio_write[31:0]      ), //i
    .clkout              (sysclk_clkout                         ), //i
    .resetCtrl_axiReset  (resetCtrl_axiReset                    )  //i
  );
  Apb3TimArray axi_timCtrl (
    .io_apb_PADDR       (axi_timCtrl_io_apb_PADDR[12:0]        ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_2_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_2_PENABLE     ), //i
    .io_apb_PREADY      (axi_timCtrl_io_apb_PREADY             ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_2_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_2_PWDATA[31:0]), //i
    .io_apb_PRDATA      (axi_timCtrl_io_apb_PRDATA[31:0]       ), //o
    .io_apb_PSLVERROR   (axi_timCtrl_io_apb_PSLVERROR          ), //o
    .io_tim_ch          (axi_timCtrl_io_tim_ch[7:0]            ), //o
    .io_interrupt       (axi_timCtrl_io_interrupt[1:0]         ), //o
    .clkout             (sysclk_clkout                         ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  Apb3Wdg axi_wdgCtrl (
    .io_apb_PADDR        (axi_wdgCtrl_io_apb_PADDR[12:0]        ), //i
    .io_apb_PSEL         (apb3Router_5_io_outputs_3_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_5_io_outputs_3_PENABLE     ), //i
    .io_apb_PREADY       (axi_wdgCtrl_io_apb_PREADY             ), //o
    .io_apb_PWRITE       (apb3Router_5_io_outputs_3_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_5_io_outputs_3_PWDATA[31:0]), //i
    .io_apb_PRDATA       (axi_wdgCtrl_io_apb_PRDATA[31:0]       ), //o
    .io_apb_PSLVERROR    (axi_wdgCtrl_io_apb_PSLVERROR          ), //o
    .io_iwdgRst          (axi_wdgCtrl_io_iwdgRst                ), //o
    .io_wwdgRst          (axi_wdgCtrl_io_wwdgRst                ), //o
    .clkout              (sysclk_clkout                         ), //i
    .resetCtrl_coreReset (resetCtrl_coreReset                   )  //i
  );
  Apb3SysTick axi_systickCtrl (
    .io_apb_PADDR       (axi_systickCtrl_io_apb_PADDR[3:0]     ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_4_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_4_PENABLE     ), //i
    .io_apb_PREADY      (axi_systickCtrl_io_apb_PREADY         ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_4_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_4_PWDATA[31:0]), //i
    .io_apb_PRDATA      (axi_systickCtrl_io_apb_PRDATA[31:0]   ), //o
    .io_apb_PSLVERROR   (axi_systickCtrl_io_apb_PSLVERROR      ), //o
    .io_interrupt       (axi_systickCtrl_io_interrupt          ), //o
    .clkout             (sysclk_clkout                         ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  ApbUartArray axi_uartCtrl (
    .io_apb_PADDR       (axi_uartCtrl_io_apb_PADDR[12:0]       ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY      (axi_uartCtrl_io_apb_PREADY            ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA      (axi_uartCtrl_io_apb_PRDATA[31:0]      ), //o
    .io_apb_PSLVERROR   (axi_uartCtrl_io_apb_PSLVERROR         ), //o
    .io_uarts_0_txd     (axi_uartCtrl_io_uarts_0_txd           ), //o
    .io_uarts_0_rxd     (axi_uartCtrl_io_uarts_0_rxd           ), //i
    .io_uarts_1_txd     (axi_uartCtrl_io_uarts_1_txd           ), //o
    .io_uarts_1_rxd     (axi_uartCtrl_io_uarts_1_rxd           ), //i
    .io_interrupt       (axi_uartCtrl_io_interrupt[1:0]        ), //o
    .clkout             (sysclk_clkout                         ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  Axi4Lcd axi_lcdCtrl (
    .io_apb_PADDR            (axi_lcdCtrl_io_apb_PADDR[9:0]                           ), //i
    .io_apb_PSEL             (apb3Router_5_io_outputs_5_PSEL                          ), //i
    .io_apb_PENABLE          (apb3Router_5_io_outputs_5_PENABLE                       ), //i
    .io_apb_PREADY           (axi_lcdCtrl_io_apb_PREADY                               ), //o
    .io_apb_PWRITE           (apb3Router_5_io_outputs_5_PWRITE                        ), //i
    .io_apb_PWDATA           (apb3Router_5_io_outputs_5_PWDATA[31:0]                  ), //i
    .io_apb_PRDATA           (axi_lcdCtrl_io_apb_PRDATA[31:0]                         ), //o
    .io_axi_ar_valid         (axi_lcdCtrl_io_axi_ar_valid                             ), //o
    .io_axi_ar_ready         (axi_lcdCtrl_io_axi_decoder_io_input_ar_ready            ), //i
    .io_axi_ar_payload_addr  (axi_lcdCtrl_io_axi_ar_payload_addr[31:0]                ), //o
    .io_axi_ar_payload_len   (axi_lcdCtrl_io_axi_ar_payload_len[7:0]                  ), //o
    .io_axi_ar_payload_size  (axi_lcdCtrl_io_axi_ar_payload_size[2:0]                 ), //o
    .io_axi_ar_payload_cache (axi_lcdCtrl_io_axi_ar_payload_cache[3:0]                ), //o
    .io_axi_ar_payload_prot  (axi_lcdCtrl_io_axi_ar_payload_prot[2:0]                 ), //o
    .io_axi_r_valid          (axi_lcdCtrl_io_axi_decoder_io_input_r_valid             ), //i
    .io_axi_r_ready          (axi_lcdCtrl_io_axi_r_ready                              ), //o
    .io_axi_r_payload_data   (axi_lcdCtrl_io_axi_decoder_io_input_r_payload_data[31:0]), //i
    .io_axi_r_payload_last   (axi_lcdCtrl_io_axi_decoder_io_input_r_payload_last      ), //i
    .io_dvti_vs              (axi_lcdCtrl_io_dvti_vs                                  ), //o
    .io_dvti_hs              (axi_lcdCtrl_io_dvti_hs                                  ), //o
    .io_dvti_de              (axi_lcdCtrl_io_dvti_de                                  ), //o
    .io_dvti_data            (axi_lcdCtrl_io_dvti_data[15:0]                          ), //o
    .io_interrupt            (axi_lcdCtrl_io_interrupt                                ), //o
    .clkout                  (sysclk_clkout                                           ), //i
    .resetCtrl_axiReset      (resetCtrl_axiReset                                      ), //i
    .clkout_1                (lcdclk_clkout                                           )  //i
  );
  Axi4ReadOnlyDecoder axi_core_io_i_decoder (
    .io_input_ar_valid             (axi_core_io_i_ar_valid                                           ), //i
    .io_input_ar_ready             (axi_core_io_i_decoder_io_input_ar_ready                          ), //o
    .io_input_ar_payload_addr      (axi_core_io_i_ar_payload_addr[31:0]                              ), //i
    .io_input_ar_payload_cache     (axi_core_io_i_ar_payload_cache[3:0]                              ), //i
    .io_input_ar_payload_prot      (axi_core_io_i_ar_payload_prot[2:0]                               ), //i
    .io_input_r_valid              (axi_core_io_i_decoder_io_input_r_valid                           ), //o
    .io_input_r_ready              (axi_core_io_i_r_ready                                            ), //i
    .io_input_r_payload_data       (axi_core_io_i_decoder_io_input_r_payload_data[31:0]              ), //o
    .io_input_r_payload_last       (axi_core_io_i_decoder_io_input_r_payload_last                    ), //o
    .io_outputs_0_ar_valid         (axi_core_io_i_decoder_io_outputs_0_ar_valid                      ), //o
    .io_outputs_0_ar_ready         (io_outputs_0_ar_validPipe_fire                                   ), //i
    .io_outputs_0_ar_payload_addr  (axi_core_io_i_decoder_io_outputs_0_ar_payload_addr[31:0]         ), //o
    .io_outputs_0_ar_payload_cache (axi_core_io_i_decoder_io_outputs_0_ar_payload_cache[3:0]         ), //o
    .io_outputs_0_ar_payload_prot  (axi_core_io_i_decoder_io_outputs_0_ar_payload_prot[2:0]          ), //o
    .io_outputs_0_r_valid          (axi_ram_io_axi_arbiter_io_readInputs_0_r_valid                   ), //i
    .io_outputs_0_r_ready          (axi_core_io_i_decoder_io_outputs_0_r_ready                       ), //o
    .io_outputs_0_r_payload_data   (axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_data[31:0]      ), //i
    .io_outputs_0_r_payload_last   (axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_last            ), //i
    .io_outputs_1_ar_valid         (axi_core_io_i_decoder_io_outputs_1_ar_valid                      ), //o
    .io_outputs_1_ar_ready         (io_outputs_1_ar_validPipe_fire                                   ), //i
    .io_outputs_1_ar_payload_addr  (axi_core_io_i_decoder_io_outputs_1_ar_payload_addr[31:0]         ), //o
    .io_outputs_1_ar_payload_cache (axi_core_io_i_decoder_io_outputs_1_ar_payload_cache[3:0]         ), //o
    .io_outputs_1_ar_payload_prot  (axi_core_io_i_decoder_io_outputs_1_ar_payload_prot[2:0]          ), //o
    .io_outputs_1_r_valid          (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_valid             ), //i
    .io_outputs_1_r_ready          (axi_core_io_i_decoder_io_outputs_1_r_ready                       ), //o
    .io_outputs_1_r_payload_data   (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_data[31:0]), //i
    .io_outputs_1_r_payload_last   (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_last      ), //i
    .clkout                        (sysclk_clkout                                                    ), //i
    .resetCtrl_axiReset            (resetCtrl_axiReset                                               )  //i
  );
  Axi4SharedDecoder axi_core_io_d_decoder (
    .io_input_arw_valid                   (axi_core_io_d_arw_valid                                            ), //i
    .io_input_arw_ready                   (axi_core_io_d_decoder_io_input_arw_ready                           ), //o
    .io_input_arw_payload_addr            (axi_core_io_d_arw_payload_addr[31:0]                               ), //i
    .io_input_arw_payload_size            (axi_core_io_d_arw_payload_size[2:0]                                ), //i
    .io_input_arw_payload_cache           (axi_core_io_d_arw_payload_cache[3:0]                               ), //i
    .io_input_arw_payload_prot            (axi_core_io_d_arw_payload_prot[2:0]                                ), //i
    .io_input_arw_payload_write           (axi_core_io_d_arw_payload_write                                    ), //i
    .io_input_w_valid                     (axi_core_io_d_w_valid                                              ), //i
    .io_input_w_ready                     (axi_core_io_d_decoder_io_input_w_ready                             ), //o
    .io_input_w_payload_data              (axi_core_io_d_w_payload_data[31:0]                                 ), //i
    .io_input_w_payload_strb              (axi_core_io_d_w_payload_strb[3:0]                                  ), //i
    .io_input_w_payload_last              (axi_core_io_d_w_payload_last                                       ), //i
    .io_input_b_valid                     (axi_core_io_d_decoder_io_input_b_valid                             ), //o
    .io_input_b_ready                     (axi_core_io_d_b_ready                                              ), //i
    .io_input_r_valid                     (axi_core_io_d_decoder_io_input_r_valid                             ), //o
    .io_input_r_ready                     (axi_core_io_d_r_ready                                              ), //i
    .io_input_r_payload_data              (axi_core_io_d_decoder_io_input_r_payload_data[31:0]                ), //o
    .io_input_r_payload_last              (axi_core_io_d_decoder_io_input_r_payload_last                      ), //o
    .io_sharedOutputs_0_arw_valid         (axi_core_io_d_decoder_io_sharedOutputs_0_arw_valid                 ), //o
    .io_sharedOutputs_0_arw_ready         (io_sharedOutputs_0_arw_validPipe_fire                              ), //i
    .io_sharedOutputs_0_arw_payload_addr  (axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_addr[31:0]    ), //o
    .io_sharedOutputs_0_arw_payload_size  (axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_size[2:0]     ), //o
    .io_sharedOutputs_0_arw_payload_cache (axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_cache[3:0]    ), //o
    .io_sharedOutputs_0_arw_payload_prot  (axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_prot[2:0]     ), //o
    .io_sharedOutputs_0_arw_payload_write (axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_write         ), //o
    .io_sharedOutputs_0_w_valid           (axi_core_io_d_decoder_io_sharedOutputs_0_w_valid                   ), //o
    .io_sharedOutputs_0_w_ready           (axi_ram_io_axi_arbiter_io_sharedInputs_0_w_ready                   ), //i
    .io_sharedOutputs_0_w_payload_data    (axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_data[31:0]      ), //o
    .io_sharedOutputs_0_w_payload_strb    (axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_strb[3:0]       ), //o
    .io_sharedOutputs_0_w_payload_last    (axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_last            ), //o
    .io_sharedOutputs_0_b_valid           (axi_ram_io_axi_arbiter_io_sharedInputs_0_b_valid                   ), //i
    .io_sharedOutputs_0_b_ready           (axi_core_io_d_decoder_io_sharedOutputs_0_b_ready                   ), //o
    .io_sharedOutputs_0_r_valid           (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_valid                   ), //i
    .io_sharedOutputs_0_r_ready           (axi_core_io_d_decoder_io_sharedOutputs_0_r_ready                   ), //o
    .io_sharedOutputs_0_r_payload_data    (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_data[31:0]      ), //i
    .io_sharedOutputs_0_r_payload_last    (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_last            ), //i
    .io_sharedOutputs_1_arw_valid         (axi_core_io_d_decoder_io_sharedOutputs_1_arw_valid                 ), //o
    .io_sharedOutputs_1_arw_ready         (io_sharedOutputs_1_arw_validPipe_fire                              ), //i
    .io_sharedOutputs_1_arw_payload_addr  (axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_addr[31:0]    ), //o
    .io_sharedOutputs_1_arw_payload_size  (axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_size[2:0]     ), //o
    .io_sharedOutputs_1_arw_payload_cache (axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_cache[3:0]    ), //o
    .io_sharedOutputs_1_arw_payload_prot  (axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_prot[2:0]     ), //o
    .io_sharedOutputs_1_arw_payload_write (axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_write         ), //o
    .io_sharedOutputs_1_w_valid           (axi_core_io_d_decoder_io_sharedOutputs_1_w_valid                   ), //o
    .io_sharedOutputs_1_w_ready           (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_w_ready             ), //i
    .io_sharedOutputs_1_w_payload_data    (axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_data[31:0]      ), //o
    .io_sharedOutputs_1_w_payload_strb    (axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_strb[3:0]       ), //o
    .io_sharedOutputs_1_w_payload_last    (axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_last            ), //o
    .io_sharedOutputs_1_b_valid           (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_valid             ), //i
    .io_sharedOutputs_1_b_ready           (axi_core_io_d_decoder_io_sharedOutputs_1_b_ready                   ), //o
    .io_sharedOutputs_1_r_valid           (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_valid             ), //i
    .io_sharedOutputs_1_r_ready           (axi_core_io_d_decoder_io_sharedOutputs_1_r_ready                   ), //o
    .io_sharedOutputs_1_r_payload_data    (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_data[31:0]), //i
    .io_sharedOutputs_1_r_payload_last    (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_last      ), //i
    .io_sharedOutputs_2_arw_valid         (axi_core_io_d_decoder_io_sharedOutputs_2_arw_valid                 ), //o
    .io_sharedOutputs_2_arw_ready         (io_sharedOutputs_2_arw_validPipe_fire                              ), //i
    .io_sharedOutputs_2_arw_payload_addr  (axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_addr[31:0]    ), //o
    .io_sharedOutputs_2_arw_payload_size  (axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_size[2:0]     ), //o
    .io_sharedOutputs_2_arw_payload_cache (axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_cache[3:0]    ), //o
    .io_sharedOutputs_2_arw_payload_prot  (axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_prot[2:0]     ), //o
    .io_sharedOutputs_2_arw_payload_write (axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_write         ), //o
    .io_sharedOutputs_2_w_valid           (axi_core_io_d_decoder_io_sharedOutputs_2_w_valid                   ), //o
    .io_sharedOutputs_2_w_ready           (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_w_ready             ), //i
    .io_sharedOutputs_2_w_payload_data    (axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_data[31:0]      ), //o
    .io_sharedOutputs_2_w_payload_strb    (axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_strb[3:0]       ), //o
    .io_sharedOutputs_2_w_payload_last    (axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_last            ), //o
    .io_sharedOutputs_2_b_valid           (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_valid             ), //i
    .io_sharedOutputs_2_b_ready           (axi_core_io_d_decoder_io_sharedOutputs_2_b_ready                   ), //o
    .io_sharedOutputs_2_r_valid           (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_valid             ), //i
    .io_sharedOutputs_2_r_ready           (axi_core_io_d_decoder_io_sharedOutputs_2_r_ready                   ), //o
    .io_sharedOutputs_2_r_payload_data    (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_data[31:0]), //i
    .io_sharedOutputs_2_r_payload_last    (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_last      ), //i
    .clkout                               (sysclk_clkout                                                      ), //i
    .resetCtrl_axiReset                   (resetCtrl_axiReset                                                 )  //i
  );
  Axi4ReadOnlyDecoder_1 axi_lcdCtrl_io_axi_decoder (
    .io_input_ar_valid             (axi_lcdCtrl_io_axi_ar_valid                                      ), //i
    .io_input_ar_ready             (axi_lcdCtrl_io_axi_decoder_io_input_ar_ready                     ), //o
    .io_input_ar_payload_addr      (axi_lcdCtrl_io_axi_ar_payload_addr[31:0]                         ), //i
    .io_input_ar_payload_len       (axi_lcdCtrl_io_axi_ar_payload_len[7:0]                           ), //i
    .io_input_ar_payload_size      (axi_lcdCtrl_io_axi_ar_payload_size[2:0]                          ), //i
    .io_input_ar_payload_cache     (axi_lcdCtrl_io_axi_ar_payload_cache[3:0]                         ), //i
    .io_input_ar_payload_prot      (axi_lcdCtrl_io_axi_ar_payload_prot[2:0]                          ), //i
    .io_input_r_valid              (axi_lcdCtrl_io_axi_decoder_io_input_r_valid                      ), //o
    .io_input_r_ready              (axi_lcdCtrl_io_axi_r_ready                                       ), //i
    .io_input_r_payload_data       (axi_lcdCtrl_io_axi_decoder_io_input_r_payload_data[31:0]         ), //o
    .io_input_r_payload_last       (axi_lcdCtrl_io_axi_decoder_io_input_r_payload_last               ), //o
    .io_outputs_0_ar_valid         (axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_valid                 ), //o
    .io_outputs_0_ar_ready         (io_outputs_0_ar_validPipe_fire_1                                 ), //i
    .io_outputs_0_ar_payload_addr  (axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_addr[31:0]    ), //o
    .io_outputs_0_ar_payload_len   (axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_len[7:0]      ), //o
    .io_outputs_0_ar_payload_size  (axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_size[2:0]     ), //o
    .io_outputs_0_ar_payload_cache (axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_cache[3:0]    ), //o
    .io_outputs_0_ar_payload_prot  (axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_prot[2:0]     ), //o
    .io_outputs_0_r_valid          (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_valid             ), //i
    .io_outputs_0_r_ready          (axi_lcdCtrl_io_axi_decoder_io_outputs_0_r_ready                  ), //o
    .io_outputs_0_r_payload_data   (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_data[31:0]), //i
    .io_outputs_0_r_payload_last   (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_last      ), //i
    .clkout                        (sysclk_clkout                                                    ), //i
    .resetCtrl_axiReset            (resetCtrl_axiReset                                               )  //i
  );
  Axi4SharedArbiter axi_ram_io_axi_arbiter (
    .io_readInputs_0_ar_valid            (io_outputs_0_ar_validPipe_valid                                ), //i
    .io_readInputs_0_ar_ready            (axi_ram_io_axi_arbiter_io_readInputs_0_ar_ready                ), //o
    .io_readInputs_0_ar_payload_addr     (axi_ram_io_axi_arbiter_io_readInputs_0_ar_payload_addr[14:0]   ), //i
    .io_readInputs_0_ar_payload_id       (_zz_io_readInputs_0_ar_payload_id[2:0]                         ), //i
    .io_readInputs_0_ar_payload_len      (_zz_io_readInputs_0_ar_payload_len[7:0]                        ), //i
    .io_readInputs_0_ar_payload_size     (3'b010                                                         ), //i
    .io_readInputs_0_ar_payload_burst    (2'b01                                                          ), //i
    .io_readInputs_0_r_valid             (axi_ram_io_axi_arbiter_io_readInputs_0_r_valid                 ), //o
    .io_readInputs_0_r_ready             (axi_core_io_i_decoder_io_outputs_0_r_ready                     ), //i
    .io_readInputs_0_r_payload_data      (axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_data[31:0]    ), //o
    .io_readInputs_0_r_payload_id        (axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_id[2:0]       ), //o
    .io_readInputs_0_r_payload_resp      (axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_resp[1:0]     ), //o
    .io_readInputs_0_r_payload_last      (axi_ram_io_axi_arbiter_io_readInputs_0_r_payload_last          ), //o
    .io_sharedInputs_0_arw_valid         (io_sharedOutputs_0_arw_validPipe_valid                         ), //i
    .io_sharedInputs_0_arw_ready         (axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_ready             ), //o
    .io_sharedInputs_0_arw_payload_addr  (axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr[14:0]), //i
    .io_sharedInputs_0_arw_payload_id    (_zz_io_sharedInputs_0_arw_payload_id[2:0]                      ), //i
    .io_sharedInputs_0_arw_payload_len   (_zz_io_sharedInputs_0_arw_payload_len[7:0]                     ), //i
    .io_sharedInputs_0_arw_payload_size  (io_sharedOutputs_0_arw_validPipe_payload_size[2:0]             ), //i
    .io_sharedInputs_0_arw_payload_burst (2'b01                                                          ), //i
    .io_sharedInputs_0_arw_payload_write (io_sharedOutputs_0_arw_validPipe_payload_write                 ), //i
    .io_sharedInputs_0_w_valid           (axi_core_io_d_decoder_io_sharedOutputs_0_w_valid               ), //i
    .io_sharedInputs_0_w_ready           (axi_ram_io_axi_arbiter_io_sharedInputs_0_w_ready               ), //o
    .io_sharedInputs_0_w_payload_data    (axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_data[31:0]  ), //i
    .io_sharedInputs_0_w_payload_strb    (axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_strb[3:0]   ), //i
    .io_sharedInputs_0_w_payload_last    (axi_core_io_d_decoder_io_sharedOutputs_0_w_payload_last        ), //i
    .io_sharedInputs_0_b_valid           (axi_ram_io_axi_arbiter_io_sharedInputs_0_b_valid               ), //o
    .io_sharedInputs_0_b_ready           (axi_core_io_d_decoder_io_sharedOutputs_0_b_ready               ), //i
    .io_sharedInputs_0_b_payload_id      (axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_id[2:0]     ), //o
    .io_sharedInputs_0_b_payload_resp    (axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp[1:0]   ), //o
    .io_sharedInputs_0_r_valid           (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_valid               ), //o
    .io_sharedInputs_0_r_ready           (axi_core_io_d_decoder_io_sharedOutputs_0_r_ready               ), //i
    .io_sharedInputs_0_r_payload_data    (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_data[31:0]  ), //o
    .io_sharedInputs_0_r_payload_id      (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_id[2:0]     ), //o
    .io_sharedInputs_0_r_payload_resp    (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp[1:0]   ), //o
    .io_sharedInputs_0_r_payload_last    (axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_last        ), //o
    .io_output_arw_valid                 (axi_ram_io_axi_arbiter_io_output_arw_valid                     ), //o
    .io_output_arw_ready                 (axi_ram_io_axi_arw_ready                                       ), //i
    .io_output_arw_payload_addr          (axi_ram_io_axi_arbiter_io_output_arw_payload_addr[14:0]        ), //o
    .io_output_arw_payload_id            (axi_ram_io_axi_arbiter_io_output_arw_payload_id[3:0]           ), //o
    .io_output_arw_payload_len           (axi_ram_io_axi_arbiter_io_output_arw_payload_len[7:0]          ), //o
    .io_output_arw_payload_size          (axi_ram_io_axi_arbiter_io_output_arw_payload_size[2:0]         ), //o
    .io_output_arw_payload_burst         (axi_ram_io_axi_arbiter_io_output_arw_payload_burst[1:0]        ), //o
    .io_output_arw_payload_write         (axi_ram_io_axi_arbiter_io_output_arw_payload_write             ), //o
    .io_output_w_valid                   (axi_ram_io_axi_arbiter_io_output_w_valid                       ), //o
    .io_output_w_ready                   (axi_ram_io_axi_w_ready                                         ), //i
    .io_output_w_payload_data            (axi_ram_io_axi_arbiter_io_output_w_payload_data[31:0]          ), //o
    .io_output_w_payload_strb            (axi_ram_io_axi_arbiter_io_output_w_payload_strb[3:0]           ), //o
    .io_output_w_payload_last            (axi_ram_io_axi_arbiter_io_output_w_payload_last                ), //o
    .io_output_b_valid                   (axi_ram_io_axi_b_valid                                         ), //i
    .io_output_b_ready                   (axi_ram_io_axi_arbiter_io_output_b_ready                       ), //o
    .io_output_b_payload_id              (axi_ram_io_axi_b_payload_id[3:0]                               ), //i
    .io_output_b_payload_resp            (axi_ram_io_axi_b_payload_resp[1:0]                             ), //i
    .io_output_r_valid                   (axi_ram_io_axi_r_valid                                         ), //i
    .io_output_r_ready                   (axi_ram_io_axi_arbiter_io_output_r_ready                       ), //o
    .io_output_r_payload_data            (axi_ram_io_axi_r_payload_data[31:0]                            ), //i
    .io_output_r_payload_id              (axi_ram_io_axi_r_payload_id[3:0]                               ), //i
    .io_output_r_payload_resp            (axi_ram_io_axi_r_payload_resp[1:0]                             ), //i
    .io_output_r_payload_last            (axi_ram_io_axi_r_payload_last                                  ), //i
    .clkout                              (sysclk_clkout                                                  ), //i
    .resetCtrl_axiReset                  (resetCtrl_axiReset                                             )  //i
  );
  Axi4SharedArbiter_1 axi_sdramCtrl_io_axi_arbiter (
    .io_readInputs_0_ar_valid            (io_outputs_1_ar_validPipe_valid                                      ), //i
    .io_readInputs_0_ar_ready            (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_ar_ready                ), //o
    .io_readInputs_0_ar_payload_addr     (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_ar_payload_addr[27:0]   ), //i
    .io_readInputs_0_ar_payload_id       (_zz_io_readInputs_0_ar_payload_id_1[1:0]                             ), //i
    .io_readInputs_0_ar_payload_len      (_zz_io_readInputs_0_ar_payload_len_1[7:0]                            ), //i
    .io_readInputs_0_ar_payload_size     (3'b010                                                               ), //i
    .io_readInputs_0_ar_payload_burst    (2'b01                                                                ), //i
    .io_readInputs_0_r_valid             (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_valid                 ), //o
    .io_readInputs_0_r_ready             (axi_core_io_i_decoder_io_outputs_1_r_ready                           ), //i
    .io_readInputs_0_r_payload_data      (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_data[31:0]    ), //o
    .io_readInputs_0_r_payload_id        (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_id[1:0]       ), //o
    .io_readInputs_0_r_payload_resp      (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_resp[1:0]     ), //o
    .io_readInputs_0_r_payload_last      (axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_r_payload_last          ), //o
    .io_readInputs_1_ar_valid            (io_outputs_0_ar_validPipe_valid_1                                    ), //i
    .io_readInputs_1_ar_ready            (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_ar_ready                ), //o
    .io_readInputs_1_ar_payload_addr     (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_ar_payload_addr[27:0]   ), //i
    .io_readInputs_1_ar_payload_id       (_zz_io_readInputs_1_ar_payload_id[1:0]                               ), //i
    .io_readInputs_1_ar_payload_len      (io_outputs_0_ar_validPipe_payload_len[7:0]                           ), //i
    .io_readInputs_1_ar_payload_size     (io_outputs_0_ar_validPipe_payload_size[2:0]                          ), //i
    .io_readInputs_1_ar_payload_burst    (2'b01                                                                ), //i
    .io_readInputs_1_r_valid             (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_valid                 ), //o
    .io_readInputs_1_r_ready             (axi_lcdCtrl_io_axi_decoder_io_outputs_0_r_ready                      ), //i
    .io_readInputs_1_r_payload_data      (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_data[31:0]    ), //o
    .io_readInputs_1_r_payload_id        (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_id[1:0]       ), //o
    .io_readInputs_1_r_payload_resp      (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_resp[1:0]     ), //o
    .io_readInputs_1_r_payload_last      (axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_r_payload_last          ), //o
    .io_sharedInputs_0_arw_valid         (io_sharedOutputs_1_arw_validPipe_valid                               ), //i
    .io_sharedInputs_0_arw_ready         (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_arw_ready             ), //o
    .io_sharedInputs_0_arw_payload_addr  (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr[27:0]), //i
    .io_sharedInputs_0_arw_payload_id    (_zz_io_sharedInputs_0_arw_payload_id_1[1:0]                          ), //i
    .io_sharedInputs_0_arw_payload_len   (_zz_io_sharedInputs_0_arw_payload_len_1[7:0]                         ), //i
    .io_sharedInputs_0_arw_payload_size  (io_sharedOutputs_1_arw_validPipe_payload_size[2:0]                   ), //i
    .io_sharedInputs_0_arw_payload_burst (2'b01                                                                ), //i
    .io_sharedInputs_0_arw_payload_write (io_sharedOutputs_1_arw_validPipe_payload_write                       ), //i
    .io_sharedInputs_0_w_valid           (axi_core_io_d_decoder_io_sharedOutputs_1_w_valid                     ), //i
    .io_sharedInputs_0_w_ready           (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_w_ready               ), //o
    .io_sharedInputs_0_w_payload_data    (axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_data[31:0]        ), //i
    .io_sharedInputs_0_w_payload_strb    (axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_strb[3:0]         ), //i
    .io_sharedInputs_0_w_payload_last    (axi_core_io_d_decoder_io_sharedOutputs_1_w_payload_last              ), //i
    .io_sharedInputs_0_b_valid           (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_valid               ), //o
    .io_sharedInputs_0_b_ready           (axi_core_io_d_decoder_io_sharedOutputs_1_b_ready                     ), //i
    .io_sharedInputs_0_b_payload_id      (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_payload_id[1:0]     ), //o
    .io_sharedInputs_0_b_payload_resp    (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_b_payload_resp[1:0]   ), //o
    .io_sharedInputs_0_r_valid           (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_valid               ), //o
    .io_sharedInputs_0_r_ready           (axi_core_io_d_decoder_io_sharedOutputs_1_r_ready                     ), //i
    .io_sharedInputs_0_r_payload_data    (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_data[31:0]  ), //o
    .io_sharedInputs_0_r_payload_id      (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_id[1:0]     ), //o
    .io_sharedInputs_0_r_payload_resp    (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_resp[1:0]   ), //o
    .io_sharedInputs_0_r_payload_last    (axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_r_payload_last        ), //o
    .io_output_arw_valid                 (axi_sdramCtrl_io_axi_arbiter_io_output_arw_valid                     ), //o
    .io_output_arw_ready                 (axi_sdramCtrl_io_axi_arbiter_io_output_arw_ready                     ), //i
    .io_output_arw_payload_addr          (axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_addr[27:0]        ), //o
    .io_output_arw_payload_id            (axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_id[3:0]           ), //o
    .io_output_arw_payload_len           (axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_len[7:0]          ), //o
    .io_output_arw_payload_size          (axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_size[2:0]         ), //o
    .io_output_arw_payload_burst         (axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_burst[1:0]        ), //o
    .io_output_arw_payload_write         (axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_write             ), //o
    .io_output_w_valid                   (axi_sdramCtrl_io_axi_arbiter_io_output_w_valid                       ), //o
    .io_output_w_ready                   (io_output_w_rValidN                                                  ), //i
    .io_output_w_payload_data            (axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_data[31:0]          ), //o
    .io_output_w_payload_strb            (axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_strb[3:0]           ), //o
    .io_output_w_payload_last            (axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_last                ), //o
    .io_output_b_valid                   (axi_sdramCtrl_io_axi_b_valid                                         ), //i
    .io_output_b_ready                   (axi_sdramCtrl_io_axi_arbiter_io_output_b_ready                       ), //o
    .io_output_b_payload_id              (axi_sdramCtrl_io_axi_b_payload_id[3:0]                               ), //i
    .io_output_b_payload_resp            (axi_sdramCtrl_io_axi_b_payload_resp[1:0]                             ), //i
    .io_output_r_valid                   (axi_sdramCtrl_io_axi_r_valid                                         ), //i
    .io_output_r_ready                   (axi_sdramCtrl_io_axi_arbiter_io_output_r_ready                       ), //o
    .io_output_r_payload_data            (axi_sdramCtrl_io_axi_r_payload_data[31:0]                            ), //i
    .io_output_r_payload_id              (axi_sdramCtrl_io_axi_r_payload_id[3:0]                               ), //i
    .io_output_r_payload_resp            (axi_sdramCtrl_io_axi_r_payload_resp[1:0]                             ), //i
    .io_output_r_payload_last            (axi_sdramCtrl_io_axi_r_payload_last                                  ), //i
    .clkout                              (sysclk_clkout                                                        ), //i
    .resetCtrl_axiReset                  (resetCtrl_axiReset                                                   )  //i
  );
  Axi4SharedArbiter_2 axi_apbBridge_io_axi_arbiter (
    .io_sharedInputs_0_arw_valid         (io_sharedOutputs_2_arw_validPipe_valid                               ), //i
    .io_sharedInputs_0_arw_ready         (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_arw_ready             ), //o
    .io_sharedInputs_0_arw_payload_addr  (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr[19:0]), //i
    .io_sharedInputs_0_arw_payload_id    (_zz_io_sharedInputs_0_arw_payload_id_2[3:0]                          ), //i
    .io_sharedInputs_0_arw_payload_len   (_zz_io_sharedInputs_0_arw_payload_len_2[7:0]                         ), //i
    .io_sharedInputs_0_arw_payload_size  (io_sharedOutputs_2_arw_validPipe_payload_size[2:0]                   ), //i
    .io_sharedInputs_0_arw_payload_burst (2'b01                                                                ), //i
    .io_sharedInputs_0_arw_payload_write (io_sharedOutputs_2_arw_validPipe_payload_write                       ), //i
    .io_sharedInputs_0_w_valid           (axi_core_io_d_decoder_io_sharedOutputs_2_w_valid                     ), //i
    .io_sharedInputs_0_w_ready           (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_w_ready               ), //o
    .io_sharedInputs_0_w_payload_data    (axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_data[31:0]        ), //i
    .io_sharedInputs_0_w_payload_strb    (axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_strb[3:0]         ), //i
    .io_sharedInputs_0_w_payload_last    (axi_core_io_d_decoder_io_sharedOutputs_2_w_payload_last              ), //i
    .io_sharedInputs_0_b_valid           (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_valid               ), //o
    .io_sharedInputs_0_b_ready           (axi_core_io_d_decoder_io_sharedOutputs_2_b_ready                     ), //i
    .io_sharedInputs_0_b_payload_id      (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_payload_id[3:0]     ), //o
    .io_sharedInputs_0_b_payload_resp    (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_b_payload_resp[1:0]   ), //o
    .io_sharedInputs_0_r_valid           (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_valid               ), //o
    .io_sharedInputs_0_r_ready           (axi_core_io_d_decoder_io_sharedOutputs_2_r_ready                     ), //i
    .io_sharedInputs_0_r_payload_data    (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_data[31:0]  ), //o
    .io_sharedInputs_0_r_payload_id      (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_id[3:0]     ), //o
    .io_sharedInputs_0_r_payload_resp    (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_resp[1:0]   ), //o
    .io_sharedInputs_0_r_payload_last    (axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_r_payload_last        ), //o
    .io_output_arw_valid                 (axi_apbBridge_io_axi_arbiter_io_output_arw_valid                     ), //o
    .io_output_arw_ready                 (axi_apbBridge_io_axi_arbiter_io_output_arw_ready                     ), //i
    .io_output_arw_payload_addr          (axi_apbBridge_io_axi_arbiter_io_output_arw_payload_addr[19:0]        ), //o
    .io_output_arw_payload_id            (axi_apbBridge_io_axi_arbiter_io_output_arw_payload_id[3:0]           ), //o
    .io_output_arw_payload_len           (axi_apbBridge_io_axi_arbiter_io_output_arw_payload_len[7:0]          ), //o
    .io_output_arw_payload_size          (axi_apbBridge_io_axi_arbiter_io_output_arw_payload_size[2:0]         ), //o
    .io_output_arw_payload_burst         (axi_apbBridge_io_axi_arbiter_io_output_arw_payload_burst[1:0]        ), //o
    .io_output_arw_payload_write         (axi_apbBridge_io_axi_arbiter_io_output_arw_payload_write             ), //o
    .io_output_w_valid                   (axi_apbBridge_io_axi_arbiter_io_output_w_valid                       ), //o
    .io_output_w_ready                   (axi_apbBridge_io_axi_arbiter_io_output_w_ready                       ), //i
    .io_output_w_payload_data            (axi_apbBridge_io_axi_arbiter_io_output_w_payload_data[31:0]          ), //o
    .io_output_w_payload_strb            (axi_apbBridge_io_axi_arbiter_io_output_w_payload_strb[3:0]           ), //o
    .io_output_w_payload_last            (axi_apbBridge_io_axi_arbiter_io_output_w_payload_last                ), //o
    .io_output_b_valid                   (axi_apbBridge_io_axi_b_valid                                         ), //i
    .io_output_b_ready                   (axi_apbBridge_io_axi_arbiter_io_output_b_ready                       ), //o
    .io_output_b_payload_id              (axi_apbBridge_io_axi_b_payload_id[3:0]                               ), //i
    .io_output_b_payload_resp            (axi_apbBridge_io_axi_b_payload_resp[1:0]                             ), //i
    .io_output_r_valid                   (axi_apbBridge_io_axi_r_valid                                         ), //i
    .io_output_r_ready                   (axi_apbBridge_io_axi_arbiter_io_output_r_ready                       ), //o
    .io_output_r_payload_data            (axi_apbBridge_io_axi_r_payload_data[31:0]                            ), //i
    .io_output_r_payload_id              (axi_apbBridge_io_axi_r_payload_id[3:0]                               ), //i
    .io_output_r_payload_resp            (axi_apbBridge_io_axi_r_payload_resp[1:0]                             ), //i
    .io_output_r_payload_last            (axi_apbBridge_io_axi_r_payload_last                                  ), //i
    .clkout                              (sysclk_clkout                                                        ), //i
    .resetCtrl_axiReset                  (resetCtrl_axiReset                                                   )  //i
  );
  Apb3Decoder_4 io_apb_decoder (
    .io_input_PADDR      (axi_apbBridge_io_apb_PADDR[19:0]     ), //i
    .io_input_PSEL       (axi_apbBridge_io_apb_PSEL            ), //i
    .io_input_PENABLE    (axi_apbBridge_io_apb_PENABLE         ), //i
    .io_input_PREADY     (io_apb_decoder_io_input_PREADY       ), //o
    .io_input_PWRITE     (axi_apbBridge_io_apb_PWRITE          ), //i
    .io_input_PWDATA     (axi_apbBridge_io_apb_PWDATA[31:0]    ), //i
    .io_input_PRDATA     (io_apb_decoder_io_input_PRDATA[31:0] ), //o
    .io_input_PSLVERROR  (io_apb_decoder_io_input_PSLVERROR    ), //o
    .io_output_PADDR     (io_apb_decoder_io_output_PADDR[19:0] ), //o
    .io_output_PSEL      (io_apb_decoder_io_output_PSEL[8:0]   ), //o
    .io_output_PENABLE   (io_apb_decoder_io_output_PENABLE     ), //o
    .io_output_PREADY    (apb3Router_5_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_5_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_5_io_input_PSLVERROR      )  //i
  );
  Apb3Router_4 apb3Router_5 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[19:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[8:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_5_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_5_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_5_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_5_io_outputs_0_PADDR[19:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_5_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_5_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (axi_gpioCtrl_io_apb_PREADY            ), //i
    .io_outputs_0_PWRITE    (apb3Router_5_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_5_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (axi_gpioCtrl_io_apb_PRDATA[31:0]      ), //i
    .io_outputs_0_PSLVERROR (axi_gpioCtrl_io_apb_PSLVERROR         ), //i
    .io_outputs_1_PADDR     (apb3Router_5_io_outputs_1_PADDR[19:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_5_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_5_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (axi_uartCtrl_io_apb_PREADY            ), //i
    .io_outputs_1_PWRITE    (apb3Router_5_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_5_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (axi_uartCtrl_io_apb_PRDATA[31:0]      ), //i
    .io_outputs_1_PSLVERROR (axi_uartCtrl_io_apb_PSLVERROR         ), //i
    .io_outputs_2_PADDR     (apb3Router_5_io_outputs_2_PADDR[19:0] ), //o
    .io_outputs_2_PSEL      (apb3Router_5_io_outputs_2_PSEL        ), //o
    .io_outputs_2_PENABLE   (apb3Router_5_io_outputs_2_PENABLE     ), //o
    .io_outputs_2_PREADY    (axi_timCtrl_io_apb_PREADY             ), //i
    .io_outputs_2_PWRITE    (apb3Router_5_io_outputs_2_PWRITE      ), //o
    .io_outputs_2_PWDATA    (apb3Router_5_io_outputs_2_PWDATA[31:0]), //o
    .io_outputs_2_PRDATA    (axi_timCtrl_io_apb_PRDATA[31:0]       ), //i
    .io_outputs_2_PSLVERROR (axi_timCtrl_io_apb_PSLVERROR          ), //i
    .io_outputs_3_PADDR     (apb3Router_5_io_outputs_3_PADDR[19:0] ), //o
    .io_outputs_3_PSEL      (apb3Router_5_io_outputs_3_PSEL        ), //o
    .io_outputs_3_PENABLE   (apb3Router_5_io_outputs_3_PENABLE     ), //o
    .io_outputs_3_PREADY    (axi_wdgCtrl_io_apb_PREADY             ), //i
    .io_outputs_3_PWRITE    (apb3Router_5_io_outputs_3_PWRITE      ), //o
    .io_outputs_3_PWDATA    (apb3Router_5_io_outputs_3_PWDATA[31:0]), //o
    .io_outputs_3_PRDATA    (axi_wdgCtrl_io_apb_PRDATA[31:0]       ), //i
    .io_outputs_3_PSLVERROR (axi_wdgCtrl_io_apb_PSLVERROR          ), //i
    .io_outputs_4_PADDR     (apb3Router_5_io_outputs_4_PADDR[19:0] ), //o
    .io_outputs_4_PSEL      (apb3Router_5_io_outputs_4_PSEL        ), //o
    .io_outputs_4_PENABLE   (apb3Router_5_io_outputs_4_PENABLE     ), //o
    .io_outputs_4_PREADY    (axi_systickCtrl_io_apb_PREADY         ), //i
    .io_outputs_4_PWRITE    (apb3Router_5_io_outputs_4_PWRITE      ), //o
    .io_outputs_4_PWDATA    (apb3Router_5_io_outputs_4_PWDATA[31:0]), //o
    .io_outputs_4_PRDATA    (axi_systickCtrl_io_apb_PRDATA[31:0]   ), //i
    .io_outputs_4_PSLVERROR (axi_systickCtrl_io_apb_PSLVERROR      ), //i
    .io_outputs_5_PADDR     (apb3Router_5_io_outputs_5_PADDR[19:0] ), //o
    .io_outputs_5_PSEL      (apb3Router_5_io_outputs_5_PSEL        ), //o
    .io_outputs_5_PENABLE   (apb3Router_5_io_outputs_5_PENABLE     ), //o
    .io_outputs_5_PREADY    (axi_lcdCtrl_io_apb_PREADY             ), //i
    .io_outputs_5_PWRITE    (apb3Router_5_io_outputs_5_PWRITE      ), //o
    .io_outputs_5_PWDATA    (apb3Router_5_io_outputs_5_PWDATA[31:0]), //o
    .io_outputs_5_PRDATA    (axi_lcdCtrl_io_apb_PRDATA[31:0]       ), //i
    .io_outputs_5_PSLVERROR (1'b0                                  ), //i
    .io_outputs_6_PADDR     (apb3Router_5_io_outputs_6_PADDR[19:0] ), //o
    .io_outputs_6_PSEL      (apb3Router_5_io_outputs_6_PSEL        ), //o
    .io_outputs_6_PENABLE   (apb3Router_5_io_outputs_6_PENABLE     ), //o
    .io_outputs_6_PREADY    (axi_afioCtrl_io_apb_PREADY            ), //i
    .io_outputs_6_PWRITE    (apb3Router_5_io_outputs_6_PWRITE      ), //o
    .io_outputs_6_PWDATA    (apb3Router_5_io_outputs_6_PWDATA[31:0]), //o
    .io_outputs_6_PRDATA    (axi_afioCtrl_io_apb_PRDATA[31:0]      ), //i
    .io_outputs_6_PSLVERROR (axi_afioCtrl_io_apb_PSLVERROR         ), //i
    .io_outputs_7_PADDR     (apb3Router_5_io_outputs_7_PADDR[19:0] ), //o
    .io_outputs_7_PSEL      (apb3Router_5_io_outputs_7_PSEL        ), //o
    .io_outputs_7_PENABLE   (apb3Router_5_io_outputs_7_PENABLE     ), //o
    .io_outputs_7_PREADY    (axi_extiCtrl_io_apb_PREADY            ), //i
    .io_outputs_7_PWRITE    (apb3Router_5_io_outputs_7_PWRITE      ), //o
    .io_outputs_7_PWDATA    (apb3Router_5_io_outputs_7_PWDATA[31:0]), //o
    .io_outputs_7_PRDATA    (axi_extiCtrl_io_apb_PRDATA[31:0]      ), //i
    .io_outputs_7_PSLVERROR (axi_extiCtrl_io_apb_PSLVERROR         ), //i
    .io_outputs_8_PADDR     (apb3Router_5_io_outputs_8_PADDR[19:0] ), //o
    .io_outputs_8_PSEL      (apb3Router_5_io_outputs_8_PSEL        ), //o
    .io_outputs_8_PENABLE   (apb3Router_5_io_outputs_8_PENABLE     ), //o
    .io_outputs_8_PREADY    (axi_core_io_debugBus_PREADY           ), //i
    .io_outputs_8_PWRITE    (apb3Router_5_io_outputs_8_PWRITE      ), //o
    .io_outputs_8_PWDATA    (apb3Router_5_io_outputs_8_PWDATA[31:0]), //o
    .io_outputs_8_PRDATA    (axi_core_io_debugBus_PRDATA[31:0]     ), //i
    .io_outputs_8_PSLVERROR (axi_core_io_debugBus_PSLVERROR        ), //i
    .clkout                 (sysclk_clkout                         ), //i
    .resetCtrl_axiReset     (resetCtrl_axiReset                    )  //i
  );
  initial begin
    resetCtrl_axiResetCounter = 6'h0;
  end

  assign io_lcdclk = lcdclk_clkout;
  always @(*) begin
    resetCtrl_axiResetUnbuffered = 1'b0;
    if(when_cyberwithddrlcd_l132) begin
      resetCtrl_axiResetUnbuffered = 1'b1;
    end
  end

  always @(*) begin
    resetCtrl_coreResetUnbuffered = 1'b0;
    if(resetCtrl_axiResetUnbuffered) begin
      resetCtrl_coreResetUnbuffered = 1'b1;
    end
    if(when_cyberwithddrlcd_l234) begin
      resetCtrl_coreResetUnbuffered = 1'b1;
    end
    if(axi_core_io_debugResetOut) begin
      resetCtrl_coreResetUnbuffered = 1'b1;
    end
  end

  assign _zz_when_cyberwithddrlcd_l132[5 : 0] = 6'h3f;
  assign when_cyberwithddrlcd_l132 = (resetCtrl_axiResetCounter != _zz_when_cyberwithddrlcd_l132);
  assign bufferCC_37_io_dataIn = (! io_rstn);
  assign when_cyberwithddrlcd_l136 = bufferCC_37_io_dataOut;
  assign axi_sdramCtrl_io_pll_lock = (memclk_lock && sysclk_lock);
  assign axi_extiInterrupt = (|axi_extiCtrl_io_interrupt);
  assign axi_timInterrupt = (|axi_timCtrl_io_interrupt);
  assign when_cyberwithddrlcd_l234 = ((axi_wdgCtrl_io_iwdgRst || axi_wdgCtrl_io_wwdgRst) || (! axi_sdramCtrl_io_init_calib_complete));
  assign axi_systickInterrupt = (|axi_systickCtrl_io_interrupt);
  assign axi_uartInterrupt = (|axi_uartCtrl_io_interrupt);
  assign axi_afioCtrl_io_device_read = {{{{{{12'h0,1'b0},axi_uartCtrl_io_uarts_1_txd},1'b0},axi_uartCtrl_io_uarts_0_txd},axi_timCtrl_io_tim_ch},8'h0};
  assign axi_uartCtrl_io_uarts_0_rxd = axi_afioCtrl_io_device_write[17];
  assign axi_uartCtrl_io_uarts_1_rxd = axi_afioCtrl_io_device_write[19];
  assign io_outputs_0_ar_validPipe_fire = (io_outputs_0_ar_validPipe_valid && io_outputs_0_ar_validPipe_ready);
  assign io_outputs_0_ar_validPipe_valid = io_outputs_0_ar_rValid;
  assign io_outputs_0_ar_validPipe_payload_addr = axi_core_io_i_decoder_io_outputs_0_ar_payload_addr;
  assign io_outputs_0_ar_validPipe_payload_cache = axi_core_io_i_decoder_io_outputs_0_ar_payload_cache;
  assign io_outputs_0_ar_validPipe_payload_prot = axi_core_io_i_decoder_io_outputs_0_ar_payload_prot;
  assign io_outputs_0_ar_validPipe_ready = axi_ram_io_axi_arbiter_io_readInputs_0_ar_ready;
  assign io_outputs_1_ar_validPipe_fire = (io_outputs_1_ar_validPipe_valid && io_outputs_1_ar_validPipe_ready);
  assign io_outputs_1_ar_validPipe_valid = io_outputs_1_ar_rValid;
  assign io_outputs_1_ar_validPipe_payload_addr = axi_core_io_i_decoder_io_outputs_1_ar_payload_addr;
  assign io_outputs_1_ar_validPipe_payload_cache = axi_core_io_i_decoder_io_outputs_1_ar_payload_cache;
  assign io_outputs_1_ar_validPipe_payload_prot = axi_core_io_i_decoder_io_outputs_1_ar_payload_prot;
  assign io_outputs_1_ar_validPipe_ready = axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_ar_ready;
  assign io_sharedOutputs_0_arw_validPipe_fire = (io_sharedOutputs_0_arw_validPipe_valid && io_sharedOutputs_0_arw_validPipe_ready);
  assign io_sharedOutputs_0_arw_validPipe_valid = io_sharedOutputs_0_arw_rValid;
  assign io_sharedOutputs_0_arw_validPipe_payload_addr = axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_addr;
  assign io_sharedOutputs_0_arw_validPipe_payload_size = axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_size;
  assign io_sharedOutputs_0_arw_validPipe_payload_cache = axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_cache;
  assign io_sharedOutputs_0_arw_validPipe_payload_prot = axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_prot;
  assign io_sharedOutputs_0_arw_validPipe_payload_write = axi_core_io_d_decoder_io_sharedOutputs_0_arw_payload_write;
  assign io_sharedOutputs_0_arw_validPipe_ready = axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  assign io_sharedOutputs_1_arw_validPipe_fire = (io_sharedOutputs_1_arw_validPipe_valid && io_sharedOutputs_1_arw_validPipe_ready);
  assign io_sharedOutputs_1_arw_validPipe_valid = io_sharedOutputs_1_arw_rValid;
  assign io_sharedOutputs_1_arw_validPipe_payload_addr = axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_addr;
  assign io_sharedOutputs_1_arw_validPipe_payload_size = axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_size;
  assign io_sharedOutputs_1_arw_validPipe_payload_cache = axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_cache;
  assign io_sharedOutputs_1_arw_validPipe_payload_prot = axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_prot;
  assign io_sharedOutputs_1_arw_validPipe_payload_write = axi_core_io_d_decoder_io_sharedOutputs_1_arw_payload_write;
  assign io_sharedOutputs_1_arw_validPipe_ready = axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  assign io_sharedOutputs_2_arw_validPipe_fire = (io_sharedOutputs_2_arw_validPipe_valid && io_sharedOutputs_2_arw_validPipe_ready);
  assign io_sharedOutputs_2_arw_validPipe_valid = io_sharedOutputs_2_arw_rValid;
  assign io_sharedOutputs_2_arw_validPipe_payload_addr = axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_addr;
  assign io_sharedOutputs_2_arw_validPipe_payload_size = axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_size;
  assign io_sharedOutputs_2_arw_validPipe_payload_cache = axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_cache;
  assign io_sharedOutputs_2_arw_validPipe_payload_prot = axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_prot;
  assign io_sharedOutputs_2_arw_validPipe_payload_write = axi_core_io_d_decoder_io_sharedOutputs_2_arw_payload_write;
  assign io_sharedOutputs_2_arw_validPipe_ready = axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  assign io_outputs_0_ar_validPipe_fire_1 = (io_outputs_0_ar_validPipe_valid_1 && io_outputs_0_ar_validPipe_ready_1);
  assign io_outputs_0_ar_validPipe_valid_1 = io_outputs_0_ar_rValid_1;
  assign io_outputs_0_ar_validPipe_payload_addr_1 = axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_addr;
  assign io_outputs_0_ar_validPipe_payload_len = axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_len;
  assign io_outputs_0_ar_validPipe_payload_size = axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_size;
  assign io_outputs_0_ar_validPipe_payload_cache_1 = axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_cache;
  assign io_outputs_0_ar_validPipe_payload_prot_1 = axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_payload_prot;
  assign io_outputs_0_ar_validPipe_ready_1 = axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_ar_ready;
  assign axi_ram_io_axi_arbiter_io_readInputs_0_ar_payload_addr = io_outputs_0_ar_validPipe_payload_addr[14:0];
  assign _zz_io_readInputs_0_ar_payload_id[2 : 0] = 3'b000;
  assign _zz_io_readInputs_0_ar_payload_len[7 : 0] = 8'h0;
  assign axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr = io_sharedOutputs_0_arw_validPipe_payload_addr[14:0];
  assign _zz_io_sharedInputs_0_arw_payload_id[2 : 0] = 3'b000;
  assign _zz_io_sharedInputs_0_arw_payload_len[7 : 0] = 8'h0;
  assign axi_sdramCtrl_io_axi_arbiter_io_readInputs_0_ar_payload_addr = io_outputs_1_ar_validPipe_payload_addr[27:0];
  assign _zz_io_readInputs_0_ar_payload_id_1[1 : 0] = 2'b00;
  assign _zz_io_readInputs_0_ar_payload_len_1[7 : 0] = 8'h0;
  assign axi_sdramCtrl_io_axi_arbiter_io_readInputs_1_ar_payload_addr = io_outputs_0_ar_validPipe_payload_addr_1[27:0];
  assign _zz_io_readInputs_1_ar_payload_id[1 : 0] = 2'b00;
  assign axi_sdramCtrl_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr = io_sharedOutputs_1_arw_validPipe_payload_addr[27:0];
  assign _zz_io_sharedInputs_0_arw_payload_id_1[1 : 0] = 2'b00;
  assign _zz_io_sharedInputs_0_arw_payload_len_1[7 : 0] = 8'h0;
  assign io_output_arw_halfPipe_fire = (io_output_arw_halfPipe_valid && io_output_arw_halfPipe_ready);
  assign axi_sdramCtrl_io_axi_arbiter_io_output_arw_ready = (! io_output_arw_rValid);
  assign io_output_arw_halfPipe_valid = io_output_arw_rValid;
  assign io_output_arw_halfPipe_payload_addr = io_output_arw_rData_addr;
  assign io_output_arw_halfPipe_payload_id = io_output_arw_rData_id;
  assign io_output_arw_halfPipe_payload_len = io_output_arw_rData_len;
  assign io_output_arw_halfPipe_payload_size = io_output_arw_rData_size;
  assign io_output_arw_halfPipe_payload_burst = io_output_arw_rData_burst;
  assign io_output_arw_halfPipe_payload_write = io_output_arw_rData_write;
  assign io_output_arw_halfPipe_ready = axi_sdramCtrl_io_axi_arw_ready;
  assign io_output_w_s2mPipe_valid = (axi_sdramCtrl_io_axi_arbiter_io_output_w_valid || (! io_output_w_rValidN));
  assign io_output_w_s2mPipe_payload_data = (io_output_w_rValidN ? axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_data : io_output_w_rData_data);
  assign io_output_w_s2mPipe_payload_strb = (io_output_w_rValidN ? axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_strb : io_output_w_rData_strb);
  assign io_output_w_s2mPipe_payload_last = (io_output_w_rValidN ? axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_last : io_output_w_rData_last);
  always @(*) begin
    io_output_w_s2mPipe_ready = io_output_w_s2mPipe_m2sPipe_ready;
    if(when_Stream_l399) begin
      io_output_w_s2mPipe_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! io_output_w_s2mPipe_m2sPipe_valid);
  assign io_output_w_s2mPipe_m2sPipe_valid = io_output_w_s2mPipe_rValid;
  assign io_output_w_s2mPipe_m2sPipe_payload_data = io_output_w_s2mPipe_rData_data;
  assign io_output_w_s2mPipe_m2sPipe_payload_strb = io_output_w_s2mPipe_rData_strb;
  assign io_output_w_s2mPipe_m2sPipe_payload_last = io_output_w_s2mPipe_rData_last;
  assign io_output_w_s2mPipe_m2sPipe_ready = axi_sdramCtrl_io_axi_w_ready;
  assign axi_apbBridge_io_axi_arbiter_io_sharedInputs_0_arw_payload_addr = io_sharedOutputs_2_arw_validPipe_payload_addr[19:0];
  assign _zz_io_sharedInputs_0_arw_payload_id_2[3 : 0] = 4'b0000;
  assign _zz_io_sharedInputs_0_arw_payload_len_2[7 : 0] = 8'h0;
  assign io_output_arw_halfPipe_fire_1 = (io_output_arw_halfPipe_valid_1 && io_output_arw_halfPipe_ready_1);
  assign axi_apbBridge_io_axi_arbiter_io_output_arw_ready = (! io_output_arw_rValid_1);
  assign io_output_arw_halfPipe_valid_1 = io_output_arw_rValid_1;
  assign io_output_arw_halfPipe_payload_addr_1 = io_output_arw_rData_addr_1;
  assign io_output_arw_halfPipe_payload_id_1 = io_output_arw_rData_id_1;
  assign io_output_arw_halfPipe_payload_len_1 = io_output_arw_rData_len_1;
  assign io_output_arw_halfPipe_payload_size_1 = io_output_arw_rData_size_1;
  assign io_output_arw_halfPipe_payload_burst_1 = io_output_arw_rData_burst_1;
  assign io_output_arw_halfPipe_payload_write_1 = io_output_arw_rData_write_1;
  assign io_output_arw_halfPipe_ready_1 = axi_apbBridge_io_axi_arw_ready;
  assign io_output_w_halfPipe_fire = (io_output_w_halfPipe_valid && io_output_w_halfPipe_ready);
  assign axi_apbBridge_io_axi_arbiter_io_output_w_ready = (! io_output_w_rValid);
  assign io_output_w_halfPipe_valid = io_output_w_rValid;
  assign io_output_w_halfPipe_payload_data = io_output_w_rData_data_1;
  assign io_output_w_halfPipe_payload_strb = io_output_w_rData_strb_1;
  assign io_output_w_halfPipe_payload_last = io_output_w_rData_last_1;
  assign io_output_w_halfPipe_ready = axi_apbBridge_io_axi_w_ready;
  assign axi_gpioCtrl_io_apb_PADDR = apb3Router_5_io_outputs_0_PADDR[12:0];
  assign axi_uartCtrl_io_apb_PADDR = apb3Router_5_io_outputs_1_PADDR[12:0];
  assign axi_timCtrl_io_apb_PADDR = apb3Router_5_io_outputs_2_PADDR[12:0];
  assign axi_wdgCtrl_io_apb_PADDR = apb3Router_5_io_outputs_3_PADDR[12:0];
  assign axi_systickCtrl_io_apb_PADDR = apb3Router_5_io_outputs_4_PADDR[3:0];
  assign axi_lcdCtrl_io_apb_PADDR = apb3Router_5_io_outputs_5_PADDR[9:0];
  assign axi_afioCtrl_io_apb_PADDR = apb3Router_5_io_outputs_6_PADDR[4:0];
  assign axi_extiCtrl_io_apb_PADDR = apb3Router_5_io_outputs_7_PADDR[4:0];
  assign axi_core_io_debugBus_PADDR = apb3Router_5_io_outputs_8_PADDR[11:0];
  always @(*) begin
    axi_core_io_interrupt = 4'b0000;
    axi_core_io_interrupt[0] = axi_uartInterrupt;
    axi_core_io_interrupt[1] = axi_timInterrupt;
    axi_core_io_interrupt[2] = axi_systickInterrupt;
    axi_core_io_interrupt[3] = axi_extiInterrupt;
  end

  assign axi_gpioCtrl_io_gpio_read = 32'h0;
  assign io_uart_tx = axi_uartCtrl_io_uarts_0_txd;
  assign io_sdram_O_ddr_addr = axi_sdramCtrl_io_ddr_iface_O_ddr_addr;
  assign io_sdram_O_ddr_ba = axi_sdramCtrl_io_ddr_iface_O_ddr_ba;
  assign io_sdram_O_ddr_cs_n = axi_sdramCtrl_io_ddr_iface_O_ddr_cs_n;
  assign io_sdram_O_ddr_ras_n = axi_sdramCtrl_io_ddr_iface_O_ddr_ras_n;
  assign io_sdram_O_ddr_cas_n = axi_sdramCtrl_io_ddr_iface_O_ddr_cas_n;
  assign io_sdram_O_ddr_we_n = axi_sdramCtrl_io_ddr_iface_O_ddr_we_n;
  assign io_sdram_O_ddr_clk = axi_sdramCtrl_io_ddr_iface_O_ddr_clk;
  assign io_sdram_O_ddr_clk_n = axi_sdramCtrl_io_ddr_iface_O_ddr_clk_n;
  assign io_sdram_O_ddr_cke = axi_sdramCtrl_io_ddr_iface_O_ddr_cke;
  assign io_sdram_O_ddr_odt = axi_sdramCtrl_io_ddr_iface_O_ddr_odt;
  assign io_sdram_O_ddr_reset_n = axi_sdramCtrl_io_ddr_iface_O_ddr_reset_n;
  assign io_sdram_O_ddr_dqm = axi_sdramCtrl_io_ddr_iface_O_ddr_dqm;
  assign io_dvti_vs = axi_lcdCtrl_io_dvti_vs;
  assign io_dvti_hs = axi_lcdCtrl_io_dvti_hs;
  assign io_dvti_de = axi_lcdCtrl_io_dvti_de;
  assign io_dvti_data = axi_lcdCtrl_io_dvti_data;
  always @(posedge sysclk_clkout) begin
    if(when_cyberwithddrlcd_l132) begin
      resetCtrl_axiResetCounter <= (resetCtrl_axiResetCounter + 6'h01);
    end
    if(when_cyberwithddrlcd_l136) begin
      resetCtrl_axiResetCounter <= 6'h0;
    end
  end

  always @(posedge sysclk_clkout) begin
    resetCtrl_axiReset <= resetCtrl_axiResetUnbuffered;
    resetCtrl_coreReset <= resetCtrl_coreResetUnbuffered;
  end

  always @(posedge sysclk_clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      io_outputs_0_ar_rValid <= 1'b0;
      io_outputs_1_ar_rValid <= 1'b0;
      io_sharedOutputs_0_arw_rValid <= 1'b0;
      io_sharedOutputs_1_arw_rValid <= 1'b0;
      io_sharedOutputs_2_arw_rValid <= 1'b0;
      io_outputs_0_ar_rValid_1 <= 1'b0;
      io_output_arw_rValid <= 1'b0;
      io_output_w_rValidN <= 1'b1;
      io_output_w_s2mPipe_rValid <= 1'b0;
      io_output_arw_rValid_1 <= 1'b0;
      io_output_w_rValid <= 1'b0;
    end else begin
      if(axi_core_io_i_decoder_io_outputs_0_ar_valid) begin
        io_outputs_0_ar_rValid <= 1'b1;
      end
      if(io_outputs_0_ar_validPipe_fire) begin
        io_outputs_0_ar_rValid <= 1'b0;
      end
      if(axi_core_io_i_decoder_io_outputs_1_ar_valid) begin
        io_outputs_1_ar_rValid <= 1'b1;
      end
      if(io_outputs_1_ar_validPipe_fire) begin
        io_outputs_1_ar_rValid <= 1'b0;
      end
      if(axi_core_io_d_decoder_io_sharedOutputs_0_arw_valid) begin
        io_sharedOutputs_0_arw_rValid <= 1'b1;
      end
      if(io_sharedOutputs_0_arw_validPipe_fire) begin
        io_sharedOutputs_0_arw_rValid <= 1'b0;
      end
      if(axi_core_io_d_decoder_io_sharedOutputs_1_arw_valid) begin
        io_sharedOutputs_1_arw_rValid <= 1'b1;
      end
      if(io_sharedOutputs_1_arw_validPipe_fire) begin
        io_sharedOutputs_1_arw_rValid <= 1'b0;
      end
      if(axi_core_io_d_decoder_io_sharedOutputs_2_arw_valid) begin
        io_sharedOutputs_2_arw_rValid <= 1'b1;
      end
      if(io_sharedOutputs_2_arw_validPipe_fire) begin
        io_sharedOutputs_2_arw_rValid <= 1'b0;
      end
      if(axi_lcdCtrl_io_axi_decoder_io_outputs_0_ar_valid) begin
        io_outputs_0_ar_rValid_1 <= 1'b1;
      end
      if(io_outputs_0_ar_validPipe_fire_1) begin
        io_outputs_0_ar_rValid_1 <= 1'b0;
      end
      if(axi_sdramCtrl_io_axi_arbiter_io_output_arw_valid) begin
        io_output_arw_rValid <= 1'b1;
      end
      if(io_output_arw_halfPipe_fire) begin
        io_output_arw_rValid <= 1'b0;
      end
      if(axi_sdramCtrl_io_axi_arbiter_io_output_w_valid) begin
        io_output_w_rValidN <= 1'b0;
      end
      if(io_output_w_s2mPipe_ready) begin
        io_output_w_rValidN <= 1'b1;
      end
      if(io_output_w_s2mPipe_ready) begin
        io_output_w_s2mPipe_rValid <= io_output_w_s2mPipe_valid;
      end
      if(axi_apbBridge_io_axi_arbiter_io_output_arw_valid) begin
        io_output_arw_rValid_1 <= 1'b1;
      end
      if(io_output_arw_halfPipe_fire_1) begin
        io_output_arw_rValid_1 <= 1'b0;
      end
      if(axi_apbBridge_io_axi_arbiter_io_output_w_valid) begin
        io_output_w_rValid <= 1'b1;
      end
      if(io_output_w_halfPipe_fire) begin
        io_output_w_rValid <= 1'b0;
      end
    end
  end

  always @(posedge sysclk_clkout) begin
    if(axi_sdramCtrl_io_axi_arbiter_io_output_arw_ready) begin
      io_output_arw_rData_addr <= axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_addr;
      io_output_arw_rData_id <= axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_id;
      io_output_arw_rData_len <= axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_len;
      io_output_arw_rData_size <= axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_size;
      io_output_arw_rData_burst <= axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_burst;
      io_output_arw_rData_write <= axi_sdramCtrl_io_axi_arbiter_io_output_arw_payload_write;
    end
    if(io_output_w_rValidN) begin
      io_output_w_rData_data <= axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_data;
      io_output_w_rData_strb <= axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_strb;
      io_output_w_rData_last <= axi_sdramCtrl_io_axi_arbiter_io_output_w_payload_last;
    end
    if(io_output_w_s2mPipe_ready) begin
      io_output_w_s2mPipe_rData_data <= io_output_w_s2mPipe_payload_data;
      io_output_w_s2mPipe_rData_strb <= io_output_w_s2mPipe_payload_strb;
      io_output_w_s2mPipe_rData_last <= io_output_w_s2mPipe_payload_last;
    end
    if(axi_apbBridge_io_axi_arbiter_io_output_arw_ready) begin
      io_output_arw_rData_addr_1 <= axi_apbBridge_io_axi_arbiter_io_output_arw_payload_addr;
      io_output_arw_rData_id_1 <= axi_apbBridge_io_axi_arbiter_io_output_arw_payload_id;
      io_output_arw_rData_len_1 <= axi_apbBridge_io_axi_arbiter_io_output_arw_payload_len;
      io_output_arw_rData_size_1 <= axi_apbBridge_io_axi_arbiter_io_output_arw_payload_size;
      io_output_arw_rData_burst_1 <= axi_apbBridge_io_axi_arbiter_io_output_arw_payload_burst;
      io_output_arw_rData_write_1 <= axi_apbBridge_io_axi_arbiter_io_output_arw_payload_write;
    end
    if(axi_apbBridge_io_axi_arbiter_io_output_w_ready) begin
      io_output_w_rData_data_1 <= axi_apbBridge_io_axi_arbiter_io_output_w_payload_data;
      io_output_w_rData_strb_1 <= axi_apbBridge_io_axi_arbiter_io_output_w_payload_strb;
      io_output_w_rData_last_1 <= axi_apbBridge_io_axi_arbiter_io_output_w_payload_last;
    end
  end


  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, cyberwithddrlcd);
  end

endmodule

module Apb3Router_4 (
  input  wire [19:0]   io_input_PADDR,
  input  wire [8:0]    io_input_PSEL,
  input  wire          io_input_PENABLE,
  output wire          io_input_PREADY,
  input  wire          io_input_PWRITE,
  input  wire [31:0]   io_input_PWDATA,
  output wire [31:0]   io_input_PRDATA,
  output wire          io_input_PSLVERROR,
  output wire [19:0]   io_outputs_0_PADDR,
  output wire [0:0]    io_outputs_0_PSEL,
  output wire          io_outputs_0_PENABLE,
  input  wire          io_outputs_0_PREADY,
  output wire          io_outputs_0_PWRITE,
  output wire [31:0]   io_outputs_0_PWDATA,
  input  wire [31:0]   io_outputs_0_PRDATA,
  input  wire          io_outputs_0_PSLVERROR,
  output wire [19:0]   io_outputs_1_PADDR,
  output wire [0:0]    io_outputs_1_PSEL,
  output wire          io_outputs_1_PENABLE,
  input  wire          io_outputs_1_PREADY,
  output wire          io_outputs_1_PWRITE,
  output wire [31:0]   io_outputs_1_PWDATA,
  input  wire [31:0]   io_outputs_1_PRDATA,
  input  wire          io_outputs_1_PSLVERROR,
  output wire [19:0]   io_outputs_2_PADDR,
  output wire [0:0]    io_outputs_2_PSEL,
  output wire          io_outputs_2_PENABLE,
  input  wire          io_outputs_2_PREADY,
  output wire          io_outputs_2_PWRITE,
  output wire [31:0]   io_outputs_2_PWDATA,
  input  wire [31:0]   io_outputs_2_PRDATA,
  input  wire          io_outputs_2_PSLVERROR,
  output wire [19:0]   io_outputs_3_PADDR,
  output wire [0:0]    io_outputs_3_PSEL,
  output wire          io_outputs_3_PENABLE,
  input  wire          io_outputs_3_PREADY,
  output wire          io_outputs_3_PWRITE,
  output wire [31:0]   io_outputs_3_PWDATA,
  input  wire [31:0]   io_outputs_3_PRDATA,
  input  wire          io_outputs_3_PSLVERROR,
  output wire [19:0]   io_outputs_4_PADDR,
  output wire [0:0]    io_outputs_4_PSEL,
  output wire          io_outputs_4_PENABLE,
  input  wire          io_outputs_4_PREADY,
  output wire          io_outputs_4_PWRITE,
  output wire [31:0]   io_outputs_4_PWDATA,
  input  wire [31:0]   io_outputs_4_PRDATA,
  input  wire          io_outputs_4_PSLVERROR,
  output wire [19:0]   io_outputs_5_PADDR,
  output wire [0:0]    io_outputs_5_PSEL,
  output wire          io_outputs_5_PENABLE,
  input  wire          io_outputs_5_PREADY,
  output wire          io_outputs_5_PWRITE,
  output wire [31:0]   io_outputs_5_PWDATA,
  input  wire [31:0]   io_outputs_5_PRDATA,
  input  wire          io_outputs_5_PSLVERROR,
  output wire [19:0]   io_outputs_6_PADDR,
  output wire [0:0]    io_outputs_6_PSEL,
  output wire          io_outputs_6_PENABLE,
  input  wire          io_outputs_6_PREADY,
  output wire          io_outputs_6_PWRITE,
  output wire [31:0]   io_outputs_6_PWDATA,
  input  wire [31:0]   io_outputs_6_PRDATA,
  input  wire          io_outputs_6_PSLVERROR,
  output wire [19:0]   io_outputs_7_PADDR,
  output wire [0:0]    io_outputs_7_PSEL,
  output wire          io_outputs_7_PENABLE,
  input  wire          io_outputs_7_PREADY,
  output wire          io_outputs_7_PWRITE,
  output wire [31:0]   io_outputs_7_PWDATA,
  input  wire [31:0]   io_outputs_7_PRDATA,
  input  wire          io_outputs_7_PSLVERROR,
  output wire [19:0]   io_outputs_8_PADDR,
  output wire [0:0]    io_outputs_8_PSEL,
  output wire          io_outputs_8_PENABLE,
  input  wire          io_outputs_8_PREADY,
  output wire          io_outputs_8_PWRITE,
  output wire [31:0]   io_outputs_8_PWDATA,
  input  wire [31:0]   io_outputs_8_PRDATA,
  input  wire          io_outputs_8_PSLVERROR,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 _zz_io_input_PREADY;
  reg        [31:0]   _zz_io_input_PRDATA;
  reg                 _zz_io_input_PSLVERROR;
  wire                _zz_selIndex;
  wire                _zz_selIndex_1;
  wire                _zz_selIndex_2;
  wire                _zz_selIndex_3;
  wire                _zz_selIndex_4;
  wire                _zz_selIndex_5;
  wire                _zz_selIndex_6;
  wire                _zz_selIndex_7;
  reg        [3:0]    selIndex;

  always @(*) begin
    case(selIndex)
      4'b0000 : begin
        _zz_io_input_PREADY = io_outputs_0_PREADY;
        _zz_io_input_PRDATA = io_outputs_0_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_0_PSLVERROR;
      end
      4'b0001 : begin
        _zz_io_input_PREADY = io_outputs_1_PREADY;
        _zz_io_input_PRDATA = io_outputs_1_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_1_PSLVERROR;
      end
      4'b0010 : begin
        _zz_io_input_PREADY = io_outputs_2_PREADY;
        _zz_io_input_PRDATA = io_outputs_2_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_2_PSLVERROR;
      end
      4'b0011 : begin
        _zz_io_input_PREADY = io_outputs_3_PREADY;
        _zz_io_input_PRDATA = io_outputs_3_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_3_PSLVERROR;
      end
      4'b0100 : begin
        _zz_io_input_PREADY = io_outputs_4_PREADY;
        _zz_io_input_PRDATA = io_outputs_4_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_4_PSLVERROR;
      end
      4'b0101 : begin
        _zz_io_input_PREADY = io_outputs_5_PREADY;
        _zz_io_input_PRDATA = io_outputs_5_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_5_PSLVERROR;
      end
      4'b0110 : begin
        _zz_io_input_PREADY = io_outputs_6_PREADY;
        _zz_io_input_PRDATA = io_outputs_6_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_6_PSLVERROR;
      end
      4'b0111 : begin
        _zz_io_input_PREADY = io_outputs_7_PREADY;
        _zz_io_input_PRDATA = io_outputs_7_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_7_PSLVERROR;
      end
      default : begin
        _zz_io_input_PREADY = io_outputs_8_PREADY;
        _zz_io_input_PRDATA = io_outputs_8_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_8_PSLVERROR;
      end
    endcase
  end

  assign io_outputs_0_PADDR = io_input_PADDR;
  assign io_outputs_0_PENABLE = io_input_PENABLE;
  assign io_outputs_0_PSEL[0] = io_input_PSEL[0];
  assign io_outputs_0_PWRITE = io_input_PWRITE;
  assign io_outputs_0_PWDATA = io_input_PWDATA;
  assign io_outputs_1_PADDR = io_input_PADDR;
  assign io_outputs_1_PENABLE = io_input_PENABLE;
  assign io_outputs_1_PSEL[0] = io_input_PSEL[1];
  assign io_outputs_1_PWRITE = io_input_PWRITE;
  assign io_outputs_1_PWDATA = io_input_PWDATA;
  assign io_outputs_2_PADDR = io_input_PADDR;
  assign io_outputs_2_PENABLE = io_input_PENABLE;
  assign io_outputs_2_PSEL[0] = io_input_PSEL[2];
  assign io_outputs_2_PWRITE = io_input_PWRITE;
  assign io_outputs_2_PWDATA = io_input_PWDATA;
  assign io_outputs_3_PADDR = io_input_PADDR;
  assign io_outputs_3_PENABLE = io_input_PENABLE;
  assign io_outputs_3_PSEL[0] = io_input_PSEL[3];
  assign io_outputs_3_PWRITE = io_input_PWRITE;
  assign io_outputs_3_PWDATA = io_input_PWDATA;
  assign io_outputs_4_PADDR = io_input_PADDR;
  assign io_outputs_4_PENABLE = io_input_PENABLE;
  assign io_outputs_4_PSEL[0] = io_input_PSEL[4];
  assign io_outputs_4_PWRITE = io_input_PWRITE;
  assign io_outputs_4_PWDATA = io_input_PWDATA;
  assign io_outputs_5_PADDR = io_input_PADDR;
  assign io_outputs_5_PENABLE = io_input_PENABLE;
  assign io_outputs_5_PSEL[0] = io_input_PSEL[5];
  assign io_outputs_5_PWRITE = io_input_PWRITE;
  assign io_outputs_5_PWDATA = io_input_PWDATA;
  assign io_outputs_6_PADDR = io_input_PADDR;
  assign io_outputs_6_PENABLE = io_input_PENABLE;
  assign io_outputs_6_PSEL[0] = io_input_PSEL[6];
  assign io_outputs_6_PWRITE = io_input_PWRITE;
  assign io_outputs_6_PWDATA = io_input_PWDATA;
  assign io_outputs_7_PADDR = io_input_PADDR;
  assign io_outputs_7_PENABLE = io_input_PENABLE;
  assign io_outputs_7_PSEL[0] = io_input_PSEL[7];
  assign io_outputs_7_PWRITE = io_input_PWRITE;
  assign io_outputs_7_PWDATA = io_input_PWDATA;
  assign io_outputs_8_PADDR = io_input_PADDR;
  assign io_outputs_8_PENABLE = io_input_PENABLE;
  assign io_outputs_8_PSEL[0] = io_input_PSEL[8];
  assign io_outputs_8_PWRITE = io_input_PWRITE;
  assign io_outputs_8_PWDATA = io_input_PWDATA;
  assign _zz_selIndex = io_input_PSEL[3];
  assign _zz_selIndex_1 = io_input_PSEL[5];
  assign _zz_selIndex_2 = io_input_PSEL[6];
  assign _zz_selIndex_3 = io_input_PSEL[7];
  assign _zz_selIndex_4 = io_input_PSEL[8];
  assign _zz_selIndex_5 = (((io_input_PSEL[1] || _zz_selIndex) || _zz_selIndex_1) || _zz_selIndex_3);
  assign _zz_selIndex_6 = (((io_input_PSEL[2] || _zz_selIndex) || _zz_selIndex_2) || _zz_selIndex_3);
  assign _zz_selIndex_7 = (((io_input_PSEL[4] || _zz_selIndex_1) || _zz_selIndex_2) || _zz_selIndex_3);
  assign io_input_PREADY = _zz_io_input_PREADY;
  assign io_input_PRDATA = _zz_io_input_PRDATA;
  assign io_input_PSLVERROR = _zz_io_input_PSLVERROR;
  always @(posedge clkout) begin
    selIndex <= {_zz_selIndex_4,{_zz_selIndex_7,{_zz_selIndex_6,_zz_selIndex_5}}};
  end


endmodule

module Apb3Decoder_4 (
  input  wire [19:0]   io_input_PADDR,
  input  wire [0:0]    io_input_PSEL,
  input  wire          io_input_PENABLE,
  output reg           io_input_PREADY,
  input  wire          io_input_PWRITE,
  input  wire [31:0]   io_input_PWDATA,
  output wire [31:0]   io_input_PRDATA,
  output reg           io_input_PSLVERROR,
  output wire [19:0]   io_output_PADDR,
  output reg  [8:0]    io_output_PSEL,
  output wire          io_output_PENABLE,
  input  wire          io_output_PREADY,
  output wire          io_output_PWRITE,
  output wire [31:0]   io_output_PWDATA,
  input  wire [31:0]   io_output_PRDATA,
  input  wire          io_output_PSLVERROR
);

  wire                when_Apb3Decoder_l88;

  assign io_output_PADDR = io_input_PADDR;
  assign io_output_PENABLE = io_input_PENABLE;
  assign io_output_PWRITE = io_input_PWRITE;
  assign io_output_PWDATA = io_input_PWDATA;
  always @(*) begin
    io_output_PSEL[0] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h0) && io_input_PSEL[0]);
    io_output_PSEL[1] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h10000) && io_input_PSEL[0]);
    io_output_PSEL[2] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h40000) && io_input_PSEL[0]);
    io_output_PSEL[3] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h50000) && io_input_PSEL[0]);
    io_output_PSEL[4] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h60000) && io_input_PSEL[0]);
    io_output_PSEL[5] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h70000) && io_input_PSEL[0]);
    io_output_PSEL[6] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'hd0000) && io_input_PSEL[0]);
    io_output_PSEL[7] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'he0000) && io_input_PSEL[0]);
    io_output_PSEL[8] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'hf0000) && io_input_PSEL[0]);
  end

  always @(*) begin
    io_input_PREADY = io_output_PREADY;
    if(when_Apb3Decoder_l88) begin
      io_input_PREADY = 1'b1;
    end
  end

  assign io_input_PRDATA = io_output_PRDATA;
  always @(*) begin
    io_input_PSLVERROR = io_output_PSLVERROR;
    if(when_Apb3Decoder_l88) begin
      io_input_PSLVERROR = 1'b1;
    end
  end

  assign when_Apb3Decoder_l88 = (io_input_PSEL[0] && (io_output_PSEL == 9'h0));

endmodule

module Axi4SharedArbiter_2 (
  input  wire          io_sharedInputs_0_arw_valid,
  output wire          io_sharedInputs_0_arw_ready,
  input  wire [19:0]   io_sharedInputs_0_arw_payload_addr,
  input  wire [3:0]    io_sharedInputs_0_arw_payload_id,
  input  wire [7:0]    io_sharedInputs_0_arw_payload_len,
  input  wire [2:0]    io_sharedInputs_0_arw_payload_size,
  input  wire [1:0]    io_sharedInputs_0_arw_payload_burst,
  input  wire          io_sharedInputs_0_arw_payload_write,
  input  wire          io_sharedInputs_0_w_valid,
  output wire          io_sharedInputs_0_w_ready,
  input  wire [31:0]   io_sharedInputs_0_w_payload_data,
  input  wire [3:0]    io_sharedInputs_0_w_payload_strb,
  input  wire          io_sharedInputs_0_w_payload_last,
  output wire          io_sharedInputs_0_b_valid,
  input  wire          io_sharedInputs_0_b_ready,
  output wire [3:0]    io_sharedInputs_0_b_payload_id,
  output wire [1:0]    io_sharedInputs_0_b_payload_resp,
  output wire          io_sharedInputs_0_r_valid,
  input  wire          io_sharedInputs_0_r_ready,
  output wire [31:0]   io_sharedInputs_0_r_payload_data,
  output wire [3:0]    io_sharedInputs_0_r_payload_id,
  output wire [1:0]    io_sharedInputs_0_r_payload_resp,
  output wire          io_sharedInputs_0_r_payload_last,
  output wire          io_output_arw_valid,
  input  wire          io_output_arw_ready,
  output wire [19:0]   io_output_arw_payload_addr,
  output wire [3:0]    io_output_arw_payload_id,
  output wire [7:0]    io_output_arw_payload_len,
  output wire [2:0]    io_output_arw_payload_size,
  output wire [1:0]    io_output_arw_payload_burst,
  output wire          io_output_arw_payload_write,
  output wire          io_output_w_valid,
  input  wire          io_output_w_ready,
  output wire [31:0]   io_output_w_payload_data,
  output wire [3:0]    io_output_w_payload_strb,
  output wire          io_output_w_payload_last,
  input  wire          io_output_b_valid,
  output wire          io_output_b_ready,
  input  wire [3:0]    io_output_b_payload_id,
  input  wire [1:0]    io_output_b_payload_resp,
  input  wire          io_output_r_valid,
  output wire          io_output_r_ready,
  input  wire [31:0]   io_output_r_payload_data,
  input  wire [3:0]    io_output_r_payload_id,
  input  wire [1:0]    io_output_r_payload_resp,
  input  wire          io_output_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 cmdArbiter_io_output_ready;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_pop_ready;
  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [19:0]   cmdArbiter_io_output_payload_addr;
  wire       [3:0]    cmdArbiter_io_output_payload_id;
  wire       [7:0]    cmdArbiter_io_output_payload_len;
  wire       [2:0]    cmdArbiter_io_output_payload_size;
  wire       [1:0]    cmdArbiter_io_output_payload_burst;
  wire                cmdArbiter_io_output_payload_write;
  wire       [0:0]    cmdArbiter_io_chosenOH;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_push_ready;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_pop_valid;
  wire       [2:0]    cmdRouteFork_throwWhen_translated_fifo_io_occupancy;
  wire       [2:0]    cmdRouteFork_throwWhen_translated_fifo_io_availability;
  wire                inputsCmd_0_valid;
  wire                inputsCmd_0_ready;
  wire       [19:0]   inputsCmd_0_payload_addr;
  wire       [3:0]    inputsCmd_0_payload_id;
  wire       [7:0]    inputsCmd_0_payload_len;
  wire       [2:0]    inputsCmd_0_payload_size;
  wire       [1:0]    inputsCmd_0_payload_burst;
  wire                inputsCmd_0_payload_write;
  wire                cmdOutputFork_valid;
  wire                cmdOutputFork_ready;
  wire       [19:0]   cmdOutputFork_payload_addr;
  wire       [3:0]    cmdOutputFork_payload_id;
  wire       [7:0]    cmdOutputFork_payload_len;
  wire       [2:0]    cmdOutputFork_payload_size;
  wire       [1:0]    cmdOutputFork_payload_burst;
  wire                cmdOutputFork_payload_write;
  wire                cmdRouteFork_valid;
  reg                 cmdRouteFork_ready;
  wire       [19:0]   cmdRouteFork_payload_addr;
  wire       [3:0]    cmdRouteFork_payload_id;
  wire       [7:0]    cmdRouteFork_payload_len;
  wire       [2:0]    cmdRouteFork_payload_size;
  wire       [1:0]    cmdRouteFork_payload_burst;
  wire                cmdRouteFork_payload_write;
  reg                 cmdArbiter_io_output_fork2_logic_linkEnable_0;
  reg                 cmdArbiter_io_output_fork2_logic_linkEnable_1;
  wire                when_Stream_l1119;
  wire                when_Stream_l1119_1;
  wire                cmdOutputFork_fire;
  wire                cmdRouteFork_fire;
  wire                when_Stream_l486;
  reg                 cmdRouteFork_throwWhen_valid;
  wire                cmdRouteFork_throwWhen_ready;
  wire       [19:0]   cmdRouteFork_throwWhen_payload_addr;
  wire       [3:0]    cmdRouteFork_throwWhen_payload_id;
  wire       [7:0]    cmdRouteFork_throwWhen_payload_len;
  wire       [2:0]    cmdRouteFork_throwWhen_payload_size;
  wire       [1:0]    cmdRouteFork_throwWhen_payload_burst;
  wire                cmdRouteFork_throwWhen_payload_write;
  wire                cmdRouteFork_throwWhen_translated_valid;
  wire                cmdRouteFork_throwWhen_translated_ready;
  wire                writeLogic_routeDataInput_valid;
  wire                writeLogic_routeDataInput_ready;
  wire       [31:0]   writeLogic_routeDataInput_payload_data;
  wire       [3:0]    writeLogic_routeDataInput_payload_strb;
  wire                writeLogic_routeDataInput_payload_last;
  wire                io_output_w_fire;
  wire                writeLogic_writeRspSels_0;
  wire                readRspSels_0;

  StreamArbiter_2 cmdArbiter (
    .io_inputs_0_valid         (inputsCmd_0_valid                      ), //i
    .io_inputs_0_ready         (cmdArbiter_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr  (inputsCmd_0_payload_addr[19:0]         ), //i
    .io_inputs_0_payload_id    (inputsCmd_0_payload_id[3:0]            ), //i
    .io_inputs_0_payload_len   (inputsCmd_0_payload_len[7:0]           ), //i
    .io_inputs_0_payload_size  (inputsCmd_0_payload_size[2:0]          ), //i
    .io_inputs_0_payload_burst (inputsCmd_0_payload_burst[1:0]         ), //i
    .io_inputs_0_payload_write (inputsCmd_0_payload_write              ), //i
    .io_output_valid           (cmdArbiter_io_output_valid             ), //o
    .io_output_ready           (cmdArbiter_io_output_ready             ), //i
    .io_output_payload_addr    (cmdArbiter_io_output_payload_addr[19:0]), //o
    .io_output_payload_id      (cmdArbiter_io_output_payload_id[3:0]   ), //o
    .io_output_payload_len     (cmdArbiter_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (cmdArbiter_io_output_payload_size[2:0] ), //o
    .io_output_payload_burst   (cmdArbiter_io_output_payload_burst[1:0]), //o
    .io_output_payload_write   (cmdArbiter_io_output_payload_write     ), //o
    .io_chosenOH               (cmdArbiter_io_chosenOH                 ), //o
    .clkout                    (clkout                                 ), //i
    .resetCtrl_axiReset        (resetCtrl_axiReset                     )  //i
  );
  StreamFifoLowLatency cmdRouteFork_throwWhen_translated_fifo (
    .io_push_valid      (cmdRouteFork_throwWhen_translated_valid                    ), //i
    .io_push_ready      (cmdRouteFork_throwWhen_translated_fifo_io_push_ready       ), //o
    .io_pop_valid       (cmdRouteFork_throwWhen_translated_fifo_io_pop_valid        ), //o
    .io_pop_ready       (cmdRouteFork_throwWhen_translated_fifo_io_pop_ready        ), //i
    .io_flush           (1'b0                                                       ), //i
    .io_occupancy       (cmdRouteFork_throwWhen_translated_fifo_io_occupancy[2:0]   ), //o
    .io_availability    (cmdRouteFork_throwWhen_translated_fifo_io_availability[2:0]), //o
    .clkout             (clkout                                                     ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                         )  //i
  );
  assign inputsCmd_0_valid = io_sharedInputs_0_arw_valid;
  assign io_sharedInputs_0_arw_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_sharedInputs_0_arw_payload_addr;
  assign inputsCmd_0_payload_id = io_sharedInputs_0_arw_payload_id;
  assign inputsCmd_0_payload_len = io_sharedInputs_0_arw_payload_len;
  assign inputsCmd_0_payload_size = io_sharedInputs_0_arw_payload_size;
  assign inputsCmd_0_payload_burst = io_sharedInputs_0_arw_payload_burst;
  assign inputsCmd_0_payload_write = io_sharedInputs_0_arw_payload_write;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  always @(*) begin
    cmdArbiter_io_output_ready = 1'b1;
    if(when_Stream_l1119) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
    if(when_Stream_l1119_1) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
  end

  assign when_Stream_l1119 = ((! cmdOutputFork_ready) && cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign when_Stream_l1119_1 = ((! cmdRouteFork_ready) && cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdOutputFork_valid = (cmdArbiter_io_output_valid && cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign cmdOutputFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdOutputFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdOutputFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdOutputFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdOutputFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdOutputFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdOutputFork_fire = (cmdOutputFork_valid && cmdOutputFork_ready);
  assign cmdRouteFork_valid = (cmdArbiter_io_output_valid && cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdRouteFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdRouteFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdRouteFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdRouteFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdRouteFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdRouteFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdRouteFork_fire = (cmdRouteFork_valid && cmdRouteFork_ready);
  assign io_output_arw_valid = cmdOutputFork_valid;
  assign cmdOutputFork_ready = io_output_arw_ready;
  assign io_output_arw_payload_addr = cmdOutputFork_payload_addr;
  assign io_output_arw_payload_len = cmdOutputFork_payload_len;
  assign io_output_arw_payload_size = cmdOutputFork_payload_size;
  assign io_output_arw_payload_burst = cmdOutputFork_payload_burst;
  assign io_output_arw_payload_write = cmdOutputFork_payload_write;
  assign io_output_arw_payload_id = (cmdOutputFork_payload_write ? cmdOutputFork_payload_id : cmdOutputFork_payload_id);
  assign when_Stream_l486 = (! cmdRouteFork_payload_write);
  always @(*) begin
    cmdRouteFork_throwWhen_valid = cmdRouteFork_valid;
    if(when_Stream_l486) begin
      cmdRouteFork_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    cmdRouteFork_ready = cmdRouteFork_throwWhen_ready;
    if(when_Stream_l486) begin
      cmdRouteFork_ready = 1'b1;
    end
  end

  assign cmdRouteFork_throwWhen_payload_addr = cmdRouteFork_payload_addr;
  assign cmdRouteFork_throwWhen_payload_id = cmdRouteFork_payload_id;
  assign cmdRouteFork_throwWhen_payload_len = cmdRouteFork_payload_len;
  assign cmdRouteFork_throwWhen_payload_size = cmdRouteFork_payload_size;
  assign cmdRouteFork_throwWhen_payload_burst = cmdRouteFork_payload_burst;
  assign cmdRouteFork_throwWhen_payload_write = cmdRouteFork_payload_write;
  assign cmdRouteFork_throwWhen_translated_valid = cmdRouteFork_throwWhen_valid;
  assign cmdRouteFork_throwWhen_ready = cmdRouteFork_throwWhen_translated_ready;
  assign cmdRouteFork_throwWhen_translated_ready = cmdRouteFork_throwWhen_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = io_sharedInputs_0_w_valid;
  assign writeLogic_routeDataInput_ready = io_sharedInputs_0_w_ready;
  assign writeLogic_routeDataInput_payload_data = io_sharedInputs_0_w_payload_data;
  assign writeLogic_routeDataInput_payload_strb = io_sharedInputs_0_w_payload_strb;
  assign writeLogic_routeDataInput_payload_last = io_sharedInputs_0_w_payload_last;
  assign io_output_w_valid = (cmdRouteFork_throwWhen_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_sharedInputs_0_w_ready = ((cmdRouteFork_throwWhen_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign io_output_w_fire = (io_output_w_valid && io_output_w_ready);
  assign cmdRouteFork_throwWhen_translated_fifo_io_pop_ready = (io_output_w_fire && io_output_w_payload_last);
  assign writeLogic_writeRspSels_0 = 1'b1;
  assign io_sharedInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_sharedInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_sharedInputs_0_b_payload_id = io_output_b_payload_id;
  assign io_output_b_ready = io_sharedInputs_0_b_ready;
  assign readRspSels_0 = 1'b1;
  assign io_sharedInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_sharedInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_sharedInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_sharedInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_sharedInputs_0_r_payload_id = io_output_r_payload_id;
  assign io_output_r_ready = io_sharedInputs_0_r_ready;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
      cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
    end else begin
      if(cmdOutputFork_fire) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b0;
      end
      if(cmdRouteFork_fire) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b0;
      end
      if(cmdArbiter_io_output_ready) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
        cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
      end
    end
  end


endmodule

module Axi4SharedArbiter_1 (
  input  wire          io_readInputs_0_ar_valid,
  output wire          io_readInputs_0_ar_ready,
  input  wire [27:0]   io_readInputs_0_ar_payload_addr,
  input  wire [1:0]    io_readInputs_0_ar_payload_id,
  input  wire [7:0]    io_readInputs_0_ar_payload_len,
  input  wire [2:0]    io_readInputs_0_ar_payload_size,
  input  wire [1:0]    io_readInputs_0_ar_payload_burst,
  output wire          io_readInputs_0_r_valid,
  input  wire          io_readInputs_0_r_ready,
  output wire [31:0]   io_readInputs_0_r_payload_data,
  output wire [1:0]    io_readInputs_0_r_payload_id,
  output wire [1:0]    io_readInputs_0_r_payload_resp,
  output wire          io_readInputs_0_r_payload_last,
  input  wire          io_readInputs_1_ar_valid,
  output wire          io_readInputs_1_ar_ready,
  input  wire [27:0]   io_readInputs_1_ar_payload_addr,
  input  wire [1:0]    io_readInputs_1_ar_payload_id,
  input  wire [7:0]    io_readInputs_1_ar_payload_len,
  input  wire [2:0]    io_readInputs_1_ar_payload_size,
  input  wire [1:0]    io_readInputs_1_ar_payload_burst,
  output wire          io_readInputs_1_r_valid,
  input  wire          io_readInputs_1_r_ready,
  output wire [31:0]   io_readInputs_1_r_payload_data,
  output wire [1:0]    io_readInputs_1_r_payload_id,
  output wire [1:0]    io_readInputs_1_r_payload_resp,
  output wire          io_readInputs_1_r_payload_last,
  input  wire          io_sharedInputs_0_arw_valid,
  output wire          io_sharedInputs_0_arw_ready,
  input  wire [27:0]   io_sharedInputs_0_arw_payload_addr,
  input  wire [1:0]    io_sharedInputs_0_arw_payload_id,
  input  wire [7:0]    io_sharedInputs_0_arw_payload_len,
  input  wire [2:0]    io_sharedInputs_0_arw_payload_size,
  input  wire [1:0]    io_sharedInputs_0_arw_payload_burst,
  input  wire          io_sharedInputs_0_arw_payload_write,
  input  wire          io_sharedInputs_0_w_valid,
  output wire          io_sharedInputs_0_w_ready,
  input  wire [31:0]   io_sharedInputs_0_w_payload_data,
  input  wire [3:0]    io_sharedInputs_0_w_payload_strb,
  input  wire          io_sharedInputs_0_w_payload_last,
  output wire          io_sharedInputs_0_b_valid,
  input  wire          io_sharedInputs_0_b_ready,
  output wire [1:0]    io_sharedInputs_0_b_payload_id,
  output wire [1:0]    io_sharedInputs_0_b_payload_resp,
  output wire          io_sharedInputs_0_r_valid,
  input  wire          io_sharedInputs_0_r_ready,
  output wire [31:0]   io_sharedInputs_0_r_payload_data,
  output wire [1:0]    io_sharedInputs_0_r_payload_id,
  output wire [1:0]    io_sharedInputs_0_r_payload_resp,
  output wire          io_sharedInputs_0_r_payload_last,
  output wire          io_output_arw_valid,
  input  wire          io_output_arw_ready,
  output wire [27:0]   io_output_arw_payload_addr,
  output wire [3:0]    io_output_arw_payload_id,
  output wire [7:0]    io_output_arw_payload_len,
  output wire [2:0]    io_output_arw_payload_size,
  output wire [1:0]    io_output_arw_payload_burst,
  output wire          io_output_arw_payload_write,
  output wire          io_output_w_valid,
  input  wire          io_output_w_ready,
  output wire [31:0]   io_output_w_payload_data,
  output wire [3:0]    io_output_w_payload_strb,
  output wire          io_output_w_payload_last,
  input  wire          io_output_b_valid,
  output wire          io_output_b_ready,
  input  wire [3:0]    io_output_b_payload_id,
  input  wire [1:0]    io_output_b_payload_resp,
  input  wire          io_output_r_valid,
  output wire          io_output_r_ready,
  input  wire [31:0]   io_output_r_payload_data,
  input  wire [3:0]    io_output_r_payload_id,
  input  wire [1:0]    io_output_r_payload_resp,
  input  wire          io_output_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 cmdArbiter_io_output_ready;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_pop_ready;
  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_inputs_1_ready;
  wire                cmdArbiter_io_inputs_2_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [27:0]   cmdArbiter_io_output_payload_addr;
  wire       [1:0]    cmdArbiter_io_output_payload_id;
  wire       [7:0]    cmdArbiter_io_output_payload_len;
  wire       [2:0]    cmdArbiter_io_output_payload_size;
  wire       [1:0]    cmdArbiter_io_output_payload_burst;
  wire                cmdArbiter_io_output_payload_write;
  wire       [1:0]    cmdArbiter_io_chosen;
  wire       [2:0]    cmdArbiter_io_chosenOH;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_push_ready;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_pop_valid;
  wire       [2:0]    cmdRouteFork_throwWhen_translated_fifo_io_occupancy;
  wire       [2:0]    cmdRouteFork_throwWhen_translated_fifo_io_availability;
  wire       [3:0]    _zz_io_output_arw_payload_id_3;
  wire       [1:0]    _zz_io_output_arw_payload_id_4;
  reg                 _zz_io_output_r_ready;
  wire                inputsCmd_0_valid;
  wire                inputsCmd_0_ready;
  wire       [27:0]   inputsCmd_0_payload_addr;
  wire       [1:0]    inputsCmd_0_payload_id;
  wire       [7:0]    inputsCmd_0_payload_len;
  wire       [2:0]    inputsCmd_0_payload_size;
  wire       [1:0]    inputsCmd_0_payload_burst;
  wire                inputsCmd_0_payload_write;
  wire                inputsCmd_1_valid;
  wire                inputsCmd_1_ready;
  wire       [27:0]   inputsCmd_1_payload_addr;
  wire       [1:0]    inputsCmd_1_payload_id;
  wire       [7:0]    inputsCmd_1_payload_len;
  wire       [2:0]    inputsCmd_1_payload_size;
  wire       [1:0]    inputsCmd_1_payload_burst;
  wire                inputsCmd_1_payload_write;
  wire                inputsCmd_2_valid;
  wire                inputsCmd_2_ready;
  wire       [27:0]   inputsCmd_2_payload_addr;
  wire       [1:0]    inputsCmd_2_payload_id;
  wire       [7:0]    inputsCmd_2_payload_len;
  wire       [2:0]    inputsCmd_2_payload_size;
  wire       [1:0]    inputsCmd_2_payload_burst;
  wire                inputsCmd_2_payload_write;
  wire                cmdOutputFork_valid;
  wire                cmdOutputFork_ready;
  wire       [27:0]   cmdOutputFork_payload_addr;
  wire       [1:0]    cmdOutputFork_payload_id;
  wire       [7:0]    cmdOutputFork_payload_len;
  wire       [2:0]    cmdOutputFork_payload_size;
  wire       [1:0]    cmdOutputFork_payload_burst;
  wire                cmdOutputFork_payload_write;
  wire                cmdRouteFork_valid;
  reg                 cmdRouteFork_ready;
  wire       [27:0]   cmdRouteFork_payload_addr;
  wire       [1:0]    cmdRouteFork_payload_id;
  wire       [7:0]    cmdRouteFork_payload_len;
  wire       [2:0]    cmdRouteFork_payload_size;
  wire       [1:0]    cmdRouteFork_payload_burst;
  wire                cmdRouteFork_payload_write;
  reg                 cmdArbiter_io_output_fork2_logic_linkEnable_0;
  reg                 cmdArbiter_io_output_fork2_logic_linkEnable_1;
  wire                when_Stream_l1119;
  wire                when_Stream_l1119_1;
  wire                cmdOutputFork_fire;
  wire                cmdRouteFork_fire;
  wire       [2:0]    _zz_io_output_arw_payload_id;
  wire                _zz_io_output_arw_payload_id_1;
  wire                _zz_io_output_arw_payload_id_2;
  wire                when_Stream_l486;
  reg                 cmdRouteFork_throwWhen_valid;
  wire                cmdRouteFork_throwWhen_ready;
  wire       [27:0]   cmdRouteFork_throwWhen_payload_addr;
  wire       [1:0]    cmdRouteFork_throwWhen_payload_id;
  wire       [7:0]    cmdRouteFork_throwWhen_payload_len;
  wire       [2:0]    cmdRouteFork_throwWhen_payload_size;
  wire       [1:0]    cmdRouteFork_throwWhen_payload_burst;
  wire                cmdRouteFork_throwWhen_payload_write;
  wire                cmdRouteFork_throwWhen_translated_valid;
  wire                cmdRouteFork_throwWhen_translated_ready;
  wire                writeLogic_routeDataInput_valid;
  wire                writeLogic_routeDataInput_ready;
  wire       [31:0]   writeLogic_routeDataInput_payload_data;
  wire       [3:0]    writeLogic_routeDataInput_payload_strb;
  wire                writeLogic_routeDataInput_payload_last;
  wire                io_output_w_fire;
  wire                writeLogic_writeRspSels_0;
  wire       [1:0]    readRspIndex;
  wire                readRspSels_0;
  wire                readRspSels_1;
  wire                readRspSels_2;

  assign _zz_io_output_arw_payload_id_4 = cmdOutputFork_payload_id;
  assign _zz_io_output_arw_payload_id_3 = {2'd0, _zz_io_output_arw_payload_id_4};
  StreamArbiter_1 cmdArbiter (
    .io_inputs_0_valid         (inputsCmd_0_valid                      ), //i
    .io_inputs_0_ready         (cmdArbiter_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr  (inputsCmd_0_payload_addr[27:0]         ), //i
    .io_inputs_0_payload_id    (inputsCmd_0_payload_id[1:0]            ), //i
    .io_inputs_0_payload_len   (inputsCmd_0_payload_len[7:0]           ), //i
    .io_inputs_0_payload_size  (inputsCmd_0_payload_size[2:0]          ), //i
    .io_inputs_0_payload_burst (inputsCmd_0_payload_burst[1:0]         ), //i
    .io_inputs_0_payload_write (inputsCmd_0_payload_write              ), //i
    .io_inputs_1_valid         (inputsCmd_1_valid                      ), //i
    .io_inputs_1_ready         (cmdArbiter_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr  (inputsCmd_1_payload_addr[27:0]         ), //i
    .io_inputs_1_payload_id    (inputsCmd_1_payload_id[1:0]            ), //i
    .io_inputs_1_payload_len   (inputsCmd_1_payload_len[7:0]           ), //i
    .io_inputs_1_payload_size  (inputsCmd_1_payload_size[2:0]          ), //i
    .io_inputs_1_payload_burst (inputsCmd_1_payload_burst[1:0]         ), //i
    .io_inputs_1_payload_write (inputsCmd_1_payload_write              ), //i
    .io_inputs_2_valid         (inputsCmd_2_valid                      ), //i
    .io_inputs_2_ready         (cmdArbiter_io_inputs_2_ready           ), //o
    .io_inputs_2_payload_addr  (inputsCmd_2_payload_addr[27:0]         ), //i
    .io_inputs_2_payload_id    (inputsCmd_2_payload_id[1:0]            ), //i
    .io_inputs_2_payload_len   (inputsCmd_2_payload_len[7:0]           ), //i
    .io_inputs_2_payload_size  (inputsCmd_2_payload_size[2:0]          ), //i
    .io_inputs_2_payload_burst (inputsCmd_2_payload_burst[1:0]         ), //i
    .io_inputs_2_payload_write (inputsCmd_2_payload_write              ), //i
    .io_output_valid           (cmdArbiter_io_output_valid             ), //o
    .io_output_ready           (cmdArbiter_io_output_ready             ), //i
    .io_output_payload_addr    (cmdArbiter_io_output_payload_addr[27:0]), //o
    .io_output_payload_id      (cmdArbiter_io_output_payload_id[1:0]   ), //o
    .io_output_payload_len     (cmdArbiter_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (cmdArbiter_io_output_payload_size[2:0] ), //o
    .io_output_payload_burst   (cmdArbiter_io_output_payload_burst[1:0]), //o
    .io_output_payload_write   (cmdArbiter_io_output_payload_write     ), //o
    .io_chosen                 (cmdArbiter_io_chosen[1:0]              ), //o
    .io_chosenOH               (cmdArbiter_io_chosenOH[2:0]            ), //o
    .clkout                    (clkout                                 ), //i
    .resetCtrl_axiReset        (resetCtrl_axiReset                     )  //i
  );
  StreamFifoLowLatency cmdRouteFork_throwWhen_translated_fifo (
    .io_push_valid      (cmdRouteFork_throwWhen_translated_valid                    ), //i
    .io_push_ready      (cmdRouteFork_throwWhen_translated_fifo_io_push_ready       ), //o
    .io_pop_valid       (cmdRouteFork_throwWhen_translated_fifo_io_pop_valid        ), //o
    .io_pop_ready       (cmdRouteFork_throwWhen_translated_fifo_io_pop_ready        ), //i
    .io_flush           (1'b0                                                       ), //i
    .io_occupancy       (cmdRouteFork_throwWhen_translated_fifo_io_occupancy[2:0]   ), //o
    .io_availability    (cmdRouteFork_throwWhen_translated_fifo_io_availability[2:0]), //o
    .clkout             (clkout                                                     ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                         )  //i
  );
  always @(*) begin
    case(readRspIndex)
      2'b00 : _zz_io_output_r_ready = io_readInputs_0_r_ready;
      2'b01 : _zz_io_output_r_ready = io_readInputs_1_r_ready;
      default : _zz_io_output_r_ready = io_sharedInputs_0_r_ready;
    endcase
  end

  assign inputsCmd_0_valid = io_readInputs_0_ar_valid;
  assign io_readInputs_0_ar_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_readInputs_0_ar_payload_addr;
  assign inputsCmd_0_payload_id = io_readInputs_0_ar_payload_id;
  assign inputsCmd_0_payload_len = io_readInputs_0_ar_payload_len;
  assign inputsCmd_0_payload_size = io_readInputs_0_ar_payload_size;
  assign inputsCmd_0_payload_burst = io_readInputs_0_ar_payload_burst;
  assign inputsCmd_0_payload_write = 1'b0;
  assign inputsCmd_1_valid = io_readInputs_1_ar_valid;
  assign io_readInputs_1_ar_ready = inputsCmd_1_ready;
  assign inputsCmd_1_payload_addr = io_readInputs_1_ar_payload_addr;
  assign inputsCmd_1_payload_id = io_readInputs_1_ar_payload_id;
  assign inputsCmd_1_payload_len = io_readInputs_1_ar_payload_len;
  assign inputsCmd_1_payload_size = io_readInputs_1_ar_payload_size;
  assign inputsCmd_1_payload_burst = io_readInputs_1_ar_payload_burst;
  assign inputsCmd_1_payload_write = 1'b0;
  assign inputsCmd_2_valid = io_sharedInputs_0_arw_valid;
  assign io_sharedInputs_0_arw_ready = inputsCmd_2_ready;
  assign inputsCmd_2_payload_addr = io_sharedInputs_0_arw_payload_addr;
  assign inputsCmd_2_payload_id = io_sharedInputs_0_arw_payload_id;
  assign inputsCmd_2_payload_len = io_sharedInputs_0_arw_payload_len;
  assign inputsCmd_2_payload_size = io_sharedInputs_0_arw_payload_size;
  assign inputsCmd_2_payload_burst = io_sharedInputs_0_arw_payload_burst;
  assign inputsCmd_2_payload_write = io_sharedInputs_0_arw_payload_write;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  assign inputsCmd_1_ready = cmdArbiter_io_inputs_1_ready;
  assign inputsCmd_2_ready = cmdArbiter_io_inputs_2_ready;
  always @(*) begin
    cmdArbiter_io_output_ready = 1'b1;
    if(when_Stream_l1119) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
    if(when_Stream_l1119_1) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
  end

  assign when_Stream_l1119 = ((! cmdOutputFork_ready) && cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign when_Stream_l1119_1 = ((! cmdRouteFork_ready) && cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdOutputFork_valid = (cmdArbiter_io_output_valid && cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign cmdOutputFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdOutputFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdOutputFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdOutputFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdOutputFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdOutputFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdOutputFork_fire = (cmdOutputFork_valid && cmdOutputFork_ready);
  assign cmdRouteFork_valid = (cmdArbiter_io_output_valid && cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdRouteFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdRouteFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdRouteFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdRouteFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdRouteFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdRouteFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdRouteFork_fire = (cmdRouteFork_valid && cmdRouteFork_ready);
  assign io_output_arw_valid = cmdOutputFork_valid;
  assign cmdOutputFork_ready = io_output_arw_ready;
  assign io_output_arw_payload_addr = cmdOutputFork_payload_addr;
  assign io_output_arw_payload_len = cmdOutputFork_payload_len;
  assign io_output_arw_payload_size = cmdOutputFork_payload_size;
  assign io_output_arw_payload_burst = cmdOutputFork_payload_burst;
  assign io_output_arw_payload_write = cmdOutputFork_payload_write;
  assign _zz_io_output_arw_payload_id = {cmdArbiter_io_chosenOH[2 : 2],cmdArbiter_io_chosenOH[1 : 0]};
  assign _zz_io_output_arw_payload_id_1 = _zz_io_output_arw_payload_id[1];
  assign _zz_io_output_arw_payload_id_2 = _zz_io_output_arw_payload_id[2];
  assign io_output_arw_payload_id = (cmdOutputFork_payload_write ? _zz_io_output_arw_payload_id_3 : {{_zz_io_output_arw_payload_id_2,_zz_io_output_arw_payload_id_1},cmdOutputFork_payload_id});
  assign when_Stream_l486 = (! cmdRouteFork_payload_write);
  always @(*) begin
    cmdRouteFork_throwWhen_valid = cmdRouteFork_valid;
    if(when_Stream_l486) begin
      cmdRouteFork_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    cmdRouteFork_ready = cmdRouteFork_throwWhen_ready;
    if(when_Stream_l486) begin
      cmdRouteFork_ready = 1'b1;
    end
  end

  assign cmdRouteFork_throwWhen_payload_addr = cmdRouteFork_payload_addr;
  assign cmdRouteFork_throwWhen_payload_id = cmdRouteFork_payload_id;
  assign cmdRouteFork_throwWhen_payload_len = cmdRouteFork_payload_len;
  assign cmdRouteFork_throwWhen_payload_size = cmdRouteFork_payload_size;
  assign cmdRouteFork_throwWhen_payload_burst = cmdRouteFork_payload_burst;
  assign cmdRouteFork_throwWhen_payload_write = cmdRouteFork_payload_write;
  assign cmdRouteFork_throwWhen_translated_valid = cmdRouteFork_throwWhen_valid;
  assign cmdRouteFork_throwWhen_ready = cmdRouteFork_throwWhen_translated_ready;
  assign cmdRouteFork_throwWhen_translated_ready = cmdRouteFork_throwWhen_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = io_sharedInputs_0_w_valid;
  assign writeLogic_routeDataInput_ready = io_sharedInputs_0_w_ready;
  assign writeLogic_routeDataInput_payload_data = io_sharedInputs_0_w_payload_data;
  assign writeLogic_routeDataInput_payload_strb = io_sharedInputs_0_w_payload_strb;
  assign writeLogic_routeDataInput_payload_last = io_sharedInputs_0_w_payload_last;
  assign io_output_w_valid = (cmdRouteFork_throwWhen_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_sharedInputs_0_w_ready = ((cmdRouteFork_throwWhen_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign io_output_w_fire = (io_output_w_valid && io_output_w_ready);
  assign cmdRouteFork_throwWhen_translated_fifo_io_pop_ready = (io_output_w_fire && io_output_w_payload_last);
  assign writeLogic_writeRspSels_0 = 1'b1;
  assign io_sharedInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_sharedInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_sharedInputs_0_b_payload_id = io_output_b_payload_id[1:0];
  assign io_output_b_ready = io_sharedInputs_0_b_ready;
  assign readRspIndex = io_output_r_payload_id[3 : 2];
  assign readRspSels_0 = (readRspIndex == 2'b00);
  assign readRspSels_1 = (readRspIndex == 2'b01);
  assign readRspSels_2 = (readRspIndex == 2'b10);
  assign io_readInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_readInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_readInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_readInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_readInputs_0_r_payload_id = io_output_r_payload_id[1:0];
  assign io_readInputs_1_r_valid = (io_output_r_valid && readRspSels_1);
  assign io_readInputs_1_r_payload_data = io_output_r_payload_data;
  assign io_readInputs_1_r_payload_resp = io_output_r_payload_resp;
  assign io_readInputs_1_r_payload_last = io_output_r_payload_last;
  assign io_readInputs_1_r_payload_id = io_output_r_payload_id[1:0];
  assign io_sharedInputs_0_r_valid = (io_output_r_valid && readRspSels_2);
  assign io_sharedInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_sharedInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_sharedInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_sharedInputs_0_r_payload_id = io_output_r_payload_id[1:0];
  assign io_output_r_ready = _zz_io_output_r_ready;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
      cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
    end else begin
      if(cmdOutputFork_fire) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b0;
      end
      if(cmdRouteFork_fire) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b0;
      end
      if(cmdArbiter_io_output_ready) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
        cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
      end
    end
  end


endmodule

module Axi4SharedArbiter (
  input  wire          io_readInputs_0_ar_valid,
  output wire          io_readInputs_0_ar_ready,
  input  wire [14:0]   io_readInputs_0_ar_payload_addr,
  input  wire [2:0]    io_readInputs_0_ar_payload_id,
  input  wire [7:0]    io_readInputs_0_ar_payload_len,
  input  wire [2:0]    io_readInputs_0_ar_payload_size,
  input  wire [1:0]    io_readInputs_0_ar_payload_burst,
  output wire          io_readInputs_0_r_valid,
  input  wire          io_readInputs_0_r_ready,
  output wire [31:0]   io_readInputs_0_r_payload_data,
  output wire [2:0]    io_readInputs_0_r_payload_id,
  output wire [1:0]    io_readInputs_0_r_payload_resp,
  output wire          io_readInputs_0_r_payload_last,
  input  wire          io_sharedInputs_0_arw_valid,
  output wire          io_sharedInputs_0_arw_ready,
  input  wire [14:0]   io_sharedInputs_0_arw_payload_addr,
  input  wire [2:0]    io_sharedInputs_0_arw_payload_id,
  input  wire [7:0]    io_sharedInputs_0_arw_payload_len,
  input  wire [2:0]    io_sharedInputs_0_arw_payload_size,
  input  wire [1:0]    io_sharedInputs_0_arw_payload_burst,
  input  wire          io_sharedInputs_0_arw_payload_write,
  input  wire          io_sharedInputs_0_w_valid,
  output wire          io_sharedInputs_0_w_ready,
  input  wire [31:0]   io_sharedInputs_0_w_payload_data,
  input  wire [3:0]    io_sharedInputs_0_w_payload_strb,
  input  wire          io_sharedInputs_0_w_payload_last,
  output wire          io_sharedInputs_0_b_valid,
  input  wire          io_sharedInputs_0_b_ready,
  output wire [2:0]    io_sharedInputs_0_b_payload_id,
  output wire [1:0]    io_sharedInputs_0_b_payload_resp,
  output wire          io_sharedInputs_0_r_valid,
  input  wire          io_sharedInputs_0_r_ready,
  output wire [31:0]   io_sharedInputs_0_r_payload_data,
  output wire [2:0]    io_sharedInputs_0_r_payload_id,
  output wire [1:0]    io_sharedInputs_0_r_payload_resp,
  output wire          io_sharedInputs_0_r_payload_last,
  output wire          io_output_arw_valid,
  input  wire          io_output_arw_ready,
  output wire [14:0]   io_output_arw_payload_addr,
  output wire [3:0]    io_output_arw_payload_id,
  output wire [7:0]    io_output_arw_payload_len,
  output wire [2:0]    io_output_arw_payload_size,
  output wire [1:0]    io_output_arw_payload_burst,
  output wire          io_output_arw_payload_write,
  output wire          io_output_w_valid,
  input  wire          io_output_w_ready,
  output wire [31:0]   io_output_w_payload_data,
  output wire [3:0]    io_output_w_payload_strb,
  output wire          io_output_w_payload_last,
  input  wire          io_output_b_valid,
  output wire          io_output_b_ready,
  input  wire [3:0]    io_output_b_payload_id,
  input  wire [1:0]    io_output_b_payload_resp,
  input  wire          io_output_r_valid,
  output wire          io_output_r_ready,
  input  wire [31:0]   io_output_r_payload_data,
  input  wire [3:0]    io_output_r_payload_id,
  input  wire [1:0]    io_output_r_payload_resp,
  input  wire          io_output_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 cmdArbiter_io_output_ready;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_pop_ready;
  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_inputs_1_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [14:0]   cmdArbiter_io_output_payload_addr;
  wire       [2:0]    cmdArbiter_io_output_payload_id;
  wire       [7:0]    cmdArbiter_io_output_payload_len;
  wire       [2:0]    cmdArbiter_io_output_payload_size;
  wire       [1:0]    cmdArbiter_io_output_payload_burst;
  wire                cmdArbiter_io_output_payload_write;
  wire       [0:0]    cmdArbiter_io_chosen;
  wire       [1:0]    cmdArbiter_io_chosenOH;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_push_ready;
  wire                cmdRouteFork_throwWhen_translated_fifo_io_pop_valid;
  wire       [2:0]    cmdRouteFork_throwWhen_translated_fifo_io_occupancy;
  wire       [2:0]    cmdRouteFork_throwWhen_translated_fifo_io_availability;
  wire       [1:0]    _zz__zz_io_output_arw_payload_id;
  wire       [3:0]    _zz_io_output_arw_payload_id_1;
  wire       [2:0]    _zz_io_output_arw_payload_id_2;
  reg                 _zz_io_output_r_ready;
  wire                inputsCmd_0_valid;
  wire                inputsCmd_0_ready;
  wire       [14:0]   inputsCmd_0_payload_addr;
  wire       [2:0]    inputsCmd_0_payload_id;
  wire       [7:0]    inputsCmd_0_payload_len;
  wire       [2:0]    inputsCmd_0_payload_size;
  wire       [1:0]    inputsCmd_0_payload_burst;
  wire                inputsCmd_0_payload_write;
  wire                inputsCmd_1_valid;
  wire                inputsCmd_1_ready;
  wire       [14:0]   inputsCmd_1_payload_addr;
  wire       [2:0]    inputsCmd_1_payload_id;
  wire       [7:0]    inputsCmd_1_payload_len;
  wire       [2:0]    inputsCmd_1_payload_size;
  wire       [1:0]    inputsCmd_1_payload_burst;
  wire                inputsCmd_1_payload_write;
  wire                cmdOutputFork_valid;
  wire                cmdOutputFork_ready;
  wire       [14:0]   cmdOutputFork_payload_addr;
  wire       [2:0]    cmdOutputFork_payload_id;
  wire       [7:0]    cmdOutputFork_payload_len;
  wire       [2:0]    cmdOutputFork_payload_size;
  wire       [1:0]    cmdOutputFork_payload_burst;
  wire                cmdOutputFork_payload_write;
  wire                cmdRouteFork_valid;
  reg                 cmdRouteFork_ready;
  wire       [14:0]   cmdRouteFork_payload_addr;
  wire       [2:0]    cmdRouteFork_payload_id;
  wire       [7:0]    cmdRouteFork_payload_len;
  wire       [2:0]    cmdRouteFork_payload_size;
  wire       [1:0]    cmdRouteFork_payload_burst;
  wire                cmdRouteFork_payload_write;
  reg                 cmdArbiter_io_output_fork2_logic_linkEnable_0;
  reg                 cmdArbiter_io_output_fork2_logic_linkEnable_1;
  wire                when_Stream_l1119;
  wire                when_Stream_l1119_1;
  wire                cmdOutputFork_fire;
  wire                cmdRouteFork_fire;
  wire                _zz_io_output_arw_payload_id;
  wire                when_Stream_l486;
  reg                 cmdRouteFork_throwWhen_valid;
  wire                cmdRouteFork_throwWhen_ready;
  wire       [14:0]   cmdRouteFork_throwWhen_payload_addr;
  wire       [2:0]    cmdRouteFork_throwWhen_payload_id;
  wire       [7:0]    cmdRouteFork_throwWhen_payload_len;
  wire       [2:0]    cmdRouteFork_throwWhen_payload_size;
  wire       [1:0]    cmdRouteFork_throwWhen_payload_burst;
  wire                cmdRouteFork_throwWhen_payload_write;
  wire                cmdRouteFork_throwWhen_translated_valid;
  wire                cmdRouteFork_throwWhen_translated_ready;
  wire                writeLogic_routeDataInput_valid;
  wire                writeLogic_routeDataInput_ready;
  wire       [31:0]   writeLogic_routeDataInput_payload_data;
  wire       [3:0]    writeLogic_routeDataInput_payload_strb;
  wire                writeLogic_routeDataInput_payload_last;
  wire                io_output_w_fire;
  wire                writeLogic_writeRspSels_0;
  wire       [0:0]    readRspIndex;
  wire                readRspSels_0;
  wire                readRspSels_1;

  assign _zz__zz_io_output_arw_payload_id = {cmdArbiter_io_chosenOH[1 : 1],cmdArbiter_io_chosenOH[0 : 0]};
  assign _zz_io_output_arw_payload_id_2 = cmdOutputFork_payload_id;
  assign _zz_io_output_arw_payload_id_1 = {1'd0, _zz_io_output_arw_payload_id_2};
  StreamArbiter cmdArbiter (
    .io_inputs_0_valid         (inputsCmd_0_valid                      ), //i
    .io_inputs_0_ready         (cmdArbiter_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr  (inputsCmd_0_payload_addr[14:0]         ), //i
    .io_inputs_0_payload_id    (inputsCmd_0_payload_id[2:0]            ), //i
    .io_inputs_0_payload_len   (inputsCmd_0_payload_len[7:0]           ), //i
    .io_inputs_0_payload_size  (inputsCmd_0_payload_size[2:0]          ), //i
    .io_inputs_0_payload_burst (inputsCmd_0_payload_burst[1:0]         ), //i
    .io_inputs_0_payload_write (inputsCmd_0_payload_write              ), //i
    .io_inputs_1_valid         (inputsCmd_1_valid                      ), //i
    .io_inputs_1_ready         (cmdArbiter_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr  (inputsCmd_1_payload_addr[14:0]         ), //i
    .io_inputs_1_payload_id    (inputsCmd_1_payload_id[2:0]            ), //i
    .io_inputs_1_payload_len   (inputsCmd_1_payload_len[7:0]           ), //i
    .io_inputs_1_payload_size  (inputsCmd_1_payload_size[2:0]          ), //i
    .io_inputs_1_payload_burst (inputsCmd_1_payload_burst[1:0]         ), //i
    .io_inputs_1_payload_write (inputsCmd_1_payload_write              ), //i
    .io_output_valid           (cmdArbiter_io_output_valid             ), //o
    .io_output_ready           (cmdArbiter_io_output_ready             ), //i
    .io_output_payload_addr    (cmdArbiter_io_output_payload_addr[14:0]), //o
    .io_output_payload_id      (cmdArbiter_io_output_payload_id[2:0]   ), //o
    .io_output_payload_len     (cmdArbiter_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (cmdArbiter_io_output_payload_size[2:0] ), //o
    .io_output_payload_burst   (cmdArbiter_io_output_payload_burst[1:0]), //o
    .io_output_payload_write   (cmdArbiter_io_output_payload_write     ), //o
    .io_chosen                 (cmdArbiter_io_chosen                   ), //o
    .io_chosenOH               (cmdArbiter_io_chosenOH[1:0]            ), //o
    .clkout                    (clkout                                 ), //i
    .resetCtrl_axiReset        (resetCtrl_axiReset                     )  //i
  );
  StreamFifoLowLatency cmdRouteFork_throwWhen_translated_fifo (
    .io_push_valid      (cmdRouteFork_throwWhen_translated_valid                    ), //i
    .io_push_ready      (cmdRouteFork_throwWhen_translated_fifo_io_push_ready       ), //o
    .io_pop_valid       (cmdRouteFork_throwWhen_translated_fifo_io_pop_valid        ), //o
    .io_pop_ready       (cmdRouteFork_throwWhen_translated_fifo_io_pop_ready        ), //i
    .io_flush           (1'b0                                                       ), //i
    .io_occupancy       (cmdRouteFork_throwWhen_translated_fifo_io_occupancy[2:0]   ), //o
    .io_availability    (cmdRouteFork_throwWhen_translated_fifo_io_availability[2:0]), //o
    .clkout             (clkout                                                     ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                         )  //i
  );
  always @(*) begin
    case(readRspIndex)
      1'b0 : _zz_io_output_r_ready = io_readInputs_0_r_ready;
      default : _zz_io_output_r_ready = io_sharedInputs_0_r_ready;
    endcase
  end

  assign inputsCmd_0_valid = io_readInputs_0_ar_valid;
  assign io_readInputs_0_ar_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_readInputs_0_ar_payload_addr;
  assign inputsCmd_0_payload_id = io_readInputs_0_ar_payload_id;
  assign inputsCmd_0_payload_len = io_readInputs_0_ar_payload_len;
  assign inputsCmd_0_payload_size = io_readInputs_0_ar_payload_size;
  assign inputsCmd_0_payload_burst = io_readInputs_0_ar_payload_burst;
  assign inputsCmd_0_payload_write = 1'b0;
  assign inputsCmd_1_valid = io_sharedInputs_0_arw_valid;
  assign io_sharedInputs_0_arw_ready = inputsCmd_1_ready;
  assign inputsCmd_1_payload_addr = io_sharedInputs_0_arw_payload_addr;
  assign inputsCmd_1_payload_id = io_sharedInputs_0_arw_payload_id;
  assign inputsCmd_1_payload_len = io_sharedInputs_0_arw_payload_len;
  assign inputsCmd_1_payload_size = io_sharedInputs_0_arw_payload_size;
  assign inputsCmd_1_payload_burst = io_sharedInputs_0_arw_payload_burst;
  assign inputsCmd_1_payload_write = io_sharedInputs_0_arw_payload_write;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  assign inputsCmd_1_ready = cmdArbiter_io_inputs_1_ready;
  always @(*) begin
    cmdArbiter_io_output_ready = 1'b1;
    if(when_Stream_l1119) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
    if(when_Stream_l1119_1) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
  end

  assign when_Stream_l1119 = ((! cmdOutputFork_ready) && cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign when_Stream_l1119_1 = ((! cmdRouteFork_ready) && cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdOutputFork_valid = (cmdArbiter_io_output_valid && cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign cmdOutputFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdOutputFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdOutputFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdOutputFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdOutputFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdOutputFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdOutputFork_fire = (cmdOutputFork_valid && cmdOutputFork_ready);
  assign cmdRouteFork_valid = (cmdArbiter_io_output_valid && cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdRouteFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdRouteFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdRouteFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdRouteFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdRouteFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdRouteFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdRouteFork_fire = (cmdRouteFork_valid && cmdRouteFork_ready);
  assign io_output_arw_valid = cmdOutputFork_valid;
  assign cmdOutputFork_ready = io_output_arw_ready;
  assign io_output_arw_payload_addr = cmdOutputFork_payload_addr;
  assign io_output_arw_payload_len = cmdOutputFork_payload_len;
  assign io_output_arw_payload_size = cmdOutputFork_payload_size;
  assign io_output_arw_payload_burst = cmdOutputFork_payload_burst;
  assign io_output_arw_payload_write = cmdOutputFork_payload_write;
  assign _zz_io_output_arw_payload_id = _zz__zz_io_output_arw_payload_id[1];
  assign io_output_arw_payload_id = (cmdOutputFork_payload_write ? _zz_io_output_arw_payload_id_1 : {_zz_io_output_arw_payload_id,cmdOutputFork_payload_id});
  assign when_Stream_l486 = (! cmdRouteFork_payload_write);
  always @(*) begin
    cmdRouteFork_throwWhen_valid = cmdRouteFork_valid;
    if(when_Stream_l486) begin
      cmdRouteFork_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    cmdRouteFork_ready = cmdRouteFork_throwWhen_ready;
    if(when_Stream_l486) begin
      cmdRouteFork_ready = 1'b1;
    end
  end

  assign cmdRouteFork_throwWhen_payload_addr = cmdRouteFork_payload_addr;
  assign cmdRouteFork_throwWhen_payload_id = cmdRouteFork_payload_id;
  assign cmdRouteFork_throwWhen_payload_len = cmdRouteFork_payload_len;
  assign cmdRouteFork_throwWhen_payload_size = cmdRouteFork_payload_size;
  assign cmdRouteFork_throwWhen_payload_burst = cmdRouteFork_payload_burst;
  assign cmdRouteFork_throwWhen_payload_write = cmdRouteFork_payload_write;
  assign cmdRouteFork_throwWhen_translated_valid = cmdRouteFork_throwWhen_valid;
  assign cmdRouteFork_throwWhen_ready = cmdRouteFork_throwWhen_translated_ready;
  assign cmdRouteFork_throwWhen_translated_ready = cmdRouteFork_throwWhen_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = io_sharedInputs_0_w_valid;
  assign writeLogic_routeDataInput_ready = io_sharedInputs_0_w_ready;
  assign writeLogic_routeDataInput_payload_data = io_sharedInputs_0_w_payload_data;
  assign writeLogic_routeDataInput_payload_strb = io_sharedInputs_0_w_payload_strb;
  assign writeLogic_routeDataInput_payload_last = io_sharedInputs_0_w_payload_last;
  assign io_output_w_valid = (cmdRouteFork_throwWhen_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_sharedInputs_0_w_ready = ((cmdRouteFork_throwWhen_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign io_output_w_fire = (io_output_w_valid && io_output_w_ready);
  assign cmdRouteFork_throwWhen_translated_fifo_io_pop_ready = (io_output_w_fire && io_output_w_payload_last);
  assign writeLogic_writeRspSels_0 = 1'b1;
  assign io_sharedInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_sharedInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_sharedInputs_0_b_payload_id = io_output_b_payload_id[2:0];
  assign io_output_b_ready = io_sharedInputs_0_b_ready;
  assign readRspIndex = io_output_r_payload_id[3 : 3];
  assign readRspSels_0 = (readRspIndex == 1'b0);
  assign readRspSels_1 = (readRspIndex == 1'b1);
  assign io_readInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_readInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_readInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_readInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_readInputs_0_r_payload_id = io_output_r_payload_id[2:0];
  assign io_sharedInputs_0_r_valid = (io_output_r_valid && readRspSels_1);
  assign io_sharedInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_sharedInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_sharedInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_sharedInputs_0_r_payload_id = io_output_r_payload_id[2:0];
  assign io_output_r_ready = _zz_io_output_r_ready;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
      cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
    end else begin
      if(cmdOutputFork_fire) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b0;
      end
      if(cmdRouteFork_fire) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b0;
      end
      if(cmdArbiter_io_output_ready) begin
        cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
        cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
      end
    end
  end


endmodule

module Axi4ReadOnlyDecoder_1 (
  input  wire          io_input_ar_valid,
  output wire          io_input_ar_ready,
  input  wire [31:0]   io_input_ar_payload_addr,
  input  wire [7:0]    io_input_ar_payload_len,
  input  wire [2:0]    io_input_ar_payload_size,
  input  wire [3:0]    io_input_ar_payload_cache,
  input  wire [2:0]    io_input_ar_payload_prot,
  output reg           io_input_r_valid,
  input  wire          io_input_r_ready,
  output wire [31:0]   io_input_r_payload_data,
  output reg           io_input_r_payload_last,
  output wire          io_outputs_0_ar_valid,
  input  wire          io_outputs_0_ar_ready,
  output wire [31:0]   io_outputs_0_ar_payload_addr,
  output wire [7:0]    io_outputs_0_ar_payload_len,
  output wire [2:0]    io_outputs_0_ar_payload_size,
  output wire [3:0]    io_outputs_0_ar_payload_cache,
  output wire [2:0]    io_outputs_0_ar_payload_prot,
  input  wire          io_outputs_0_r_valid,
  output wire          io_outputs_0_r_ready,
  input  wire [31:0]   io_outputs_0_r_payload_data,
  input  wire          io_outputs_0_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                errorSlave_io_axi_ar_valid;
  wire                errorSlave_io_axi_ar_ready;
  wire                errorSlave_io_axi_r_valid;
  wire       [31:0]   errorSlave_io_axi_r_payload_data;
  wire                errorSlave_io_axi_r_payload_last;
  wire                io_input_ar_fire;
  wire                io_input_r_fire;
  wire                when_Utils_l719;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_mayOverflow;
  wire                pendingCmdCounter_mayUnderflow;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  wire                pendingCmdCounter_willUnderflowIfDec;
  wire                pendingCmdCounter_willUnderflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l751;
  wire                when_Utils_l753;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;

  Axi4ReadOnlyErrorSlave_1 errorSlave (
    .io_axi_ar_valid         (errorSlave_io_axi_ar_valid            ), //i
    .io_axi_ar_ready         (errorSlave_io_axi_ar_ready            ), //o
    .io_axi_ar_payload_addr  (io_input_ar_payload_addr[31:0]        ), //i
    .io_axi_ar_payload_len   (io_input_ar_payload_len[7:0]          ), //i
    .io_axi_ar_payload_size  (io_input_ar_payload_size[2:0]         ), //i
    .io_axi_ar_payload_cache (io_input_ar_payload_cache[3:0]        ), //i
    .io_axi_ar_payload_prot  (io_input_ar_payload_prot[2:0]         ), //i
    .io_axi_r_valid          (errorSlave_io_axi_r_valid             ), //o
    .io_axi_r_ready          (io_input_r_ready                      ), //i
    .io_axi_r_payload_data   (errorSlave_io_axi_r_payload_data[31:0]), //o
    .io_axi_r_payload_last   (errorSlave_io_axi_r_payload_last      ), //o
    .clkout                  (clkout                                ), //i
    .resetCtrl_axiReset      (resetCtrl_axiReset                    )  //i
  );
  assign io_input_ar_fire = (io_input_ar_valid && io_input_ar_ready);
  assign io_input_r_fire = (io_input_r_valid && io_input_r_ready);
  assign when_Utils_l719 = (io_input_r_fire && io_input_r_payload_last);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_ar_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(when_Utils_l719) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_mayOverflow = (pendingCmdCounter_value == 3'b111);
  assign pendingCmdCounter_mayUnderflow = (pendingCmdCounter_value == 3'b000);
  assign pendingCmdCounter_willOverflowIfInc = (pendingCmdCounter_mayOverflow && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign pendingCmdCounter_willUnderflowIfDec = (pendingCmdCounter_mayUnderflow && (! pendingCmdCounter_incrementIt));
  assign pendingCmdCounter_willUnderflow = (pendingCmdCounter_willUnderflowIfDec && pendingCmdCounter_decrementIt);
  assign when_Utils_l751 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l751) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l753) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l753 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_ar_payload_addr & (~ 32'h07ffffff)) == 32'h40000000) && io_input_ar_valid);
  assign decodedCmdError = (decodedCmdSels == 1'b0);
  assign allowCmd = ((pendingCmdCounter_value == 3'b000) || ((pendingCmdCounter_value != 3'b111) && (pendingSels == decodedCmdSels)));
  assign io_input_ar_ready = (((|(decodedCmdSels & io_outputs_0_ar_ready)) || (decodedCmdError && errorSlave_io_axi_ar_ready)) && allowCmd);
  assign errorSlave_io_axi_ar_valid = ((io_input_ar_valid && decodedCmdError) && allowCmd);
  assign io_outputs_0_ar_valid = ((io_input_ar_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_ar_payload_addr = io_input_ar_payload_addr;
  assign io_outputs_0_ar_payload_len = io_input_ar_payload_len;
  assign io_outputs_0_ar_payload_size = io_input_ar_payload_size;
  assign io_outputs_0_ar_payload_cache = io_input_ar_payload_cache;
  assign io_outputs_0_ar_payload_prot = io_input_ar_payload_prot;
  always @(*) begin
    io_input_r_valid = (|io_outputs_0_r_valid);
    if(errorSlave_io_axi_r_valid) begin
      io_input_r_valid = 1'b1;
    end
  end

  assign io_input_r_payload_data = io_outputs_0_r_payload_data;
  always @(*) begin
    io_input_r_payload_last = io_outputs_0_r_payload_last;
    if(pendingError) begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_outputs_0_r_ready = io_input_r_ready;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      pendingCmdCounter_value <= 3'b000;
      pendingSels <= 1'b0;
      pendingError <= 1'b0;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      if(io_input_ar_ready) begin
        pendingSels <= decodedCmdSels;
      end
      if(io_input_ar_ready) begin
        pendingError <= decodedCmdError;
      end
    end
  end


endmodule

module Axi4SharedDecoder (
  input  wire          io_input_arw_valid,
  output wire          io_input_arw_ready,
  input  wire [31:0]   io_input_arw_payload_addr,
  input  wire [2:0]    io_input_arw_payload_size,
  input  wire [3:0]    io_input_arw_payload_cache,
  input  wire [2:0]    io_input_arw_payload_prot,
  input  wire          io_input_arw_payload_write,
  input  wire          io_input_w_valid,
  output wire          io_input_w_ready,
  input  wire [31:0]   io_input_w_payload_data,
  input  wire [3:0]    io_input_w_payload_strb,
  input  wire          io_input_w_payload_last,
  output wire          io_input_b_valid,
  input  wire          io_input_b_ready,
  output wire          io_input_r_valid,
  input  wire          io_input_r_ready,
  output wire [31:0]   io_input_r_payload_data,
  output reg           io_input_r_payload_last,
  output wire          io_sharedOutputs_0_arw_valid,
  input  wire          io_sharedOutputs_0_arw_ready,
  output wire [31:0]   io_sharedOutputs_0_arw_payload_addr,
  output wire [2:0]    io_sharedOutputs_0_arw_payload_size,
  output wire [3:0]    io_sharedOutputs_0_arw_payload_cache,
  output wire [2:0]    io_sharedOutputs_0_arw_payload_prot,
  output wire          io_sharedOutputs_0_arw_payload_write,
  output wire          io_sharedOutputs_0_w_valid,
  input  wire          io_sharedOutputs_0_w_ready,
  output wire [31:0]   io_sharedOutputs_0_w_payload_data,
  output wire [3:0]    io_sharedOutputs_0_w_payload_strb,
  output wire          io_sharedOutputs_0_w_payload_last,
  input  wire          io_sharedOutputs_0_b_valid,
  output wire          io_sharedOutputs_0_b_ready,
  input  wire          io_sharedOutputs_0_r_valid,
  output wire          io_sharedOutputs_0_r_ready,
  input  wire [31:0]   io_sharedOutputs_0_r_payload_data,
  input  wire          io_sharedOutputs_0_r_payload_last,
  output wire          io_sharedOutputs_1_arw_valid,
  input  wire          io_sharedOutputs_1_arw_ready,
  output wire [31:0]   io_sharedOutputs_1_arw_payload_addr,
  output wire [2:0]    io_sharedOutputs_1_arw_payload_size,
  output wire [3:0]    io_sharedOutputs_1_arw_payload_cache,
  output wire [2:0]    io_sharedOutputs_1_arw_payload_prot,
  output wire          io_sharedOutputs_1_arw_payload_write,
  output wire          io_sharedOutputs_1_w_valid,
  input  wire          io_sharedOutputs_1_w_ready,
  output wire [31:0]   io_sharedOutputs_1_w_payload_data,
  output wire [3:0]    io_sharedOutputs_1_w_payload_strb,
  output wire          io_sharedOutputs_1_w_payload_last,
  input  wire          io_sharedOutputs_1_b_valid,
  output wire          io_sharedOutputs_1_b_ready,
  input  wire          io_sharedOutputs_1_r_valid,
  output wire          io_sharedOutputs_1_r_ready,
  input  wire [31:0]   io_sharedOutputs_1_r_payload_data,
  input  wire          io_sharedOutputs_1_r_payload_last,
  output wire          io_sharedOutputs_2_arw_valid,
  input  wire          io_sharedOutputs_2_arw_ready,
  output wire [31:0]   io_sharedOutputs_2_arw_payload_addr,
  output wire [2:0]    io_sharedOutputs_2_arw_payload_size,
  output wire [3:0]    io_sharedOutputs_2_arw_payload_cache,
  output wire [2:0]    io_sharedOutputs_2_arw_payload_prot,
  output wire          io_sharedOutputs_2_arw_payload_write,
  output wire          io_sharedOutputs_2_w_valid,
  input  wire          io_sharedOutputs_2_w_ready,
  output wire [31:0]   io_sharedOutputs_2_w_payload_data,
  output wire [3:0]    io_sharedOutputs_2_w_payload_strb,
  output wire          io_sharedOutputs_2_w_payload_last,
  input  wire          io_sharedOutputs_2_b_valid,
  output wire          io_sharedOutputs_2_b_ready,
  input  wire          io_sharedOutputs_2_r_valid,
  output wire          io_sharedOutputs_2_r_ready,
  input  wire [31:0]   io_sharedOutputs_2_r_payload_data,
  input  wire          io_sharedOutputs_2_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                errorSlave_io_axi_arw_valid;
  wire                errorSlave_io_axi_w_valid;
  wire                errorSlave_io_axi_arw_ready;
  wire                errorSlave_io_axi_w_ready;
  wire                errorSlave_io_axi_b_valid;
  wire                errorSlave_io_axi_r_valid;
  wire       [31:0]   errorSlave_io_axi_r_payload_data;
  wire                errorSlave_io_axi_r_payload_last;
  reg        [31:0]   _zz_io_input_r_payload_data;
  reg                 _zz_io_input_r_payload_last;
  reg        [2:0]    _zz_pendingCmdCounter;
  reg        [2:0]    _zz_pendingCmdCounter_1;
  reg        [2:0]    _zz_pendingCmdCounter_2;
  wire                cmdAllowedStart;
  wire                io_input_arw_fire;
  wire                io_input_b_fire;
  wire                io_input_r_fire;
  wire                when_Utils_l782;
  reg        [2:0]    pendingCmdCounter;
  wire       [2:0]    _zz_pendingCmdCounter_3;
  wire                when_Utils_l716;
  wire                io_input_w_fire;
  wire                when_Utils_l719;
  reg                 pendingDataCounter_incrementIt;
  reg                 pendingDataCounter_decrementIt;
  wire       [2:0]    pendingDataCounter_valueNext;
  reg        [2:0]    pendingDataCounter_value;
  wire                pendingDataCounter_mayOverflow;
  wire                pendingDataCounter_mayUnderflow;
  wire                pendingDataCounter_willOverflowIfInc;
  wire                pendingDataCounter_willOverflow;
  wire                pendingDataCounter_willUnderflowIfDec;
  wire                pendingDataCounter_willUnderflow;
  reg        [2:0]    pendingDataCounter_finalIncrement;
  wire                when_Utils_l751;
  wire                when_Utils_l753;
  wire       [2:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [2:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;
  wire                allowData;
  reg                 _zz_cmdAllowedStart;
  wire       [2:0]    _zz_io_sharedOutputs_0_arw_valid;
  wire       [2:0]    _zz_io_sharedOutputs_0_w_valid;
  wire       [2:0]    _zz_writeRspIndex;
  wire                _zz_writeRspIndex_1;
  wire                _zz_writeRspIndex_2;
  wire       [1:0]    writeRspIndex;
  wire       [2:0]    _zz_readRspIndex;
  wire                _zz_readRspIndex_1;
  wire                _zz_readRspIndex_2;
  wire       [1:0]    readRspIndex;

  Axi4SharedErrorSlave errorSlave (
    .io_axi_arw_valid         (errorSlave_io_axi_arw_valid           ), //i
    .io_axi_arw_ready         (errorSlave_io_axi_arw_ready           ), //o
    .io_axi_arw_payload_addr  (io_input_arw_payload_addr[31:0]       ), //i
    .io_axi_arw_payload_size  (io_input_arw_payload_size[2:0]        ), //i
    .io_axi_arw_payload_cache (io_input_arw_payload_cache[3:0]       ), //i
    .io_axi_arw_payload_prot  (io_input_arw_payload_prot[2:0]        ), //i
    .io_axi_arw_payload_write (io_input_arw_payload_write            ), //i
    .io_axi_w_valid           (errorSlave_io_axi_w_valid             ), //i
    .io_axi_w_ready           (errorSlave_io_axi_w_ready             ), //o
    .io_axi_w_payload_data    (io_input_w_payload_data[31:0]         ), //i
    .io_axi_w_payload_strb    (io_input_w_payload_strb[3:0]          ), //i
    .io_axi_w_payload_last    (io_input_w_payload_last               ), //i
    .io_axi_b_valid           (errorSlave_io_axi_b_valid             ), //o
    .io_axi_b_ready           (io_input_b_ready                      ), //i
    .io_axi_r_valid           (errorSlave_io_axi_r_valid             ), //o
    .io_axi_r_ready           (io_input_r_ready                      ), //i
    .io_axi_r_payload_data    (errorSlave_io_axi_r_payload_data[31:0]), //o
    .io_axi_r_payload_last    (errorSlave_io_axi_r_payload_last      ), //o
    .clkout                   (clkout                                ), //i
    .resetCtrl_axiReset       (resetCtrl_axiReset                    )  //i
  );
  always @(*) begin
    case(readRspIndex)
      2'b00 : begin
        _zz_io_input_r_payload_data = io_sharedOutputs_0_r_payload_data;
        _zz_io_input_r_payload_last = io_sharedOutputs_0_r_payload_last;
      end
      2'b01 : begin
        _zz_io_input_r_payload_data = io_sharedOutputs_1_r_payload_data;
        _zz_io_input_r_payload_last = io_sharedOutputs_1_r_payload_last;
      end
      default : begin
        _zz_io_input_r_payload_data = io_sharedOutputs_2_r_payload_data;
        _zz_io_input_r_payload_last = io_sharedOutputs_2_r_payload_last;
      end
    endcase
  end

  always @(*) begin
    _zz_pendingCmdCounter = _zz_pendingCmdCounter_1;
    if(when_Utils_l782) begin
      _zz_pendingCmdCounter = (_zz_pendingCmdCounter_1 - 3'b001);
    end
  end

  always @(*) begin
    _zz_pendingCmdCounter_1 = _zz_pendingCmdCounter_2;
    if(io_input_b_fire) begin
      _zz_pendingCmdCounter_1 = (_zz_pendingCmdCounter_2 - 3'b001);
    end
  end

  always @(*) begin
    _zz_pendingCmdCounter_2 = _zz_pendingCmdCounter_3;
    if(io_input_arw_fire) begin
      _zz_pendingCmdCounter_2 = (_zz_pendingCmdCounter_3 + 3'b001);
    end
  end

  assign io_input_arw_fire = (io_input_arw_valid && io_input_arw_ready);
  assign io_input_b_fire = (io_input_b_valid && io_input_b_ready);
  assign io_input_r_fire = (io_input_r_valid && io_input_r_ready);
  assign when_Utils_l782 = (io_input_r_fire && io_input_r_payload_last);
  assign _zz_pendingCmdCounter_3 = pendingCmdCounter;
  assign when_Utils_l716 = (cmdAllowedStart && io_input_arw_payload_write);
  assign io_input_w_fire = (io_input_w_valid && io_input_w_ready);
  assign when_Utils_l719 = (io_input_w_fire && io_input_w_payload_last);
  always @(*) begin
    pendingDataCounter_incrementIt = 1'b0;
    if(when_Utils_l716) begin
      pendingDataCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingDataCounter_decrementIt = 1'b0;
    if(when_Utils_l719) begin
      pendingDataCounter_decrementIt = 1'b1;
    end
  end

  assign pendingDataCounter_mayOverflow = (pendingDataCounter_value == 3'b111);
  assign pendingDataCounter_mayUnderflow = (pendingDataCounter_value == 3'b000);
  assign pendingDataCounter_willOverflowIfInc = (pendingDataCounter_mayOverflow && (! pendingDataCounter_decrementIt));
  assign pendingDataCounter_willOverflow = (pendingDataCounter_willOverflowIfInc && pendingDataCounter_incrementIt);
  assign pendingDataCounter_willUnderflowIfDec = (pendingDataCounter_mayUnderflow && (! pendingDataCounter_incrementIt));
  assign pendingDataCounter_willUnderflow = (pendingDataCounter_willUnderflowIfDec && pendingDataCounter_decrementIt);
  assign when_Utils_l751 = (pendingDataCounter_incrementIt && (! pendingDataCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l751) begin
      pendingDataCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l753) begin
        pendingDataCounter_finalIncrement = 3'b111;
      end else begin
        pendingDataCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l753 = ((! pendingDataCounter_incrementIt) && pendingDataCounter_decrementIt);
  assign pendingDataCounter_valueNext = (pendingDataCounter_value + pendingDataCounter_finalIncrement);
  assign decodedCmdSels = {((io_input_arw_payload_addr & (~ 32'h000fffff)) == 32'hf0000000),{((io_input_arw_payload_addr & (~ 32'h07ffffff)) == 32'h40000000),((io_input_arw_payload_addr & (~ 32'h00007fff)) == 32'h0)}};
  assign decodedCmdError = (decodedCmdSels == 3'b000);
  assign allowCmd = ((pendingCmdCounter == 3'b000) || ((pendingCmdCounter != 3'b111) && (pendingSels == decodedCmdSels)));
  assign allowData = (pendingDataCounter_value != 3'b000);
  assign cmdAllowedStart = ((io_input_arw_valid && allowCmd) && _zz_cmdAllowedStart);
  assign io_input_arw_ready = (((|(decodedCmdSels & {io_sharedOutputs_2_arw_ready,{io_sharedOutputs_1_arw_ready,io_sharedOutputs_0_arw_ready}})) || (decodedCmdError && errorSlave_io_axi_arw_ready)) && allowCmd);
  assign errorSlave_io_axi_arw_valid = ((io_input_arw_valid && decodedCmdError) && allowCmd);
  assign _zz_io_sharedOutputs_0_arw_valid = decodedCmdSels[2 : 0];
  assign io_sharedOutputs_0_arw_valid = ((io_input_arw_valid && _zz_io_sharedOutputs_0_arw_valid[0]) && allowCmd);
  assign io_sharedOutputs_0_arw_payload_addr = io_input_arw_payload_addr;
  assign io_sharedOutputs_0_arw_payload_size = io_input_arw_payload_size;
  assign io_sharedOutputs_0_arw_payload_cache = io_input_arw_payload_cache;
  assign io_sharedOutputs_0_arw_payload_prot = io_input_arw_payload_prot;
  assign io_sharedOutputs_0_arw_payload_write = io_input_arw_payload_write;
  assign io_sharedOutputs_1_arw_valid = ((io_input_arw_valid && _zz_io_sharedOutputs_0_arw_valid[1]) && allowCmd);
  assign io_sharedOutputs_1_arw_payload_addr = io_input_arw_payload_addr;
  assign io_sharedOutputs_1_arw_payload_size = io_input_arw_payload_size;
  assign io_sharedOutputs_1_arw_payload_cache = io_input_arw_payload_cache;
  assign io_sharedOutputs_1_arw_payload_prot = io_input_arw_payload_prot;
  assign io_sharedOutputs_1_arw_payload_write = io_input_arw_payload_write;
  assign io_sharedOutputs_2_arw_valid = ((io_input_arw_valid && _zz_io_sharedOutputs_0_arw_valid[2]) && allowCmd);
  assign io_sharedOutputs_2_arw_payload_addr = io_input_arw_payload_addr;
  assign io_sharedOutputs_2_arw_payload_size = io_input_arw_payload_size;
  assign io_sharedOutputs_2_arw_payload_cache = io_input_arw_payload_cache;
  assign io_sharedOutputs_2_arw_payload_prot = io_input_arw_payload_prot;
  assign io_sharedOutputs_2_arw_payload_write = io_input_arw_payload_write;
  assign io_input_w_ready = (((|(pendingSels[2 : 0] & {io_sharedOutputs_2_w_ready,{io_sharedOutputs_1_w_ready,io_sharedOutputs_0_w_ready}})) || (pendingError && errorSlave_io_axi_w_ready)) && allowData);
  assign errorSlave_io_axi_w_valid = ((io_input_w_valid && pendingError) && allowData);
  assign _zz_io_sharedOutputs_0_w_valid = pendingSels[2 : 0];
  assign io_sharedOutputs_0_w_valid = ((io_input_w_valid && _zz_io_sharedOutputs_0_w_valid[0]) && allowData);
  assign io_sharedOutputs_0_w_payload_data = io_input_w_payload_data;
  assign io_sharedOutputs_0_w_payload_strb = io_input_w_payload_strb;
  assign io_sharedOutputs_0_w_payload_last = io_input_w_payload_last;
  assign io_sharedOutputs_1_w_valid = ((io_input_w_valid && _zz_io_sharedOutputs_0_w_valid[1]) && allowData);
  assign io_sharedOutputs_1_w_payload_data = io_input_w_payload_data;
  assign io_sharedOutputs_1_w_payload_strb = io_input_w_payload_strb;
  assign io_sharedOutputs_1_w_payload_last = io_input_w_payload_last;
  assign io_sharedOutputs_2_w_valid = ((io_input_w_valid && _zz_io_sharedOutputs_0_w_valid[2]) && allowData);
  assign io_sharedOutputs_2_w_payload_data = io_input_w_payload_data;
  assign io_sharedOutputs_2_w_payload_strb = io_input_w_payload_strb;
  assign io_sharedOutputs_2_w_payload_last = io_input_w_payload_last;
  assign _zz_writeRspIndex = pendingSels[2 : 0];
  assign _zz_writeRspIndex_1 = _zz_writeRspIndex[1];
  assign _zz_writeRspIndex_2 = _zz_writeRspIndex[2];
  assign writeRspIndex = {_zz_writeRspIndex_2,_zz_writeRspIndex_1};
  assign io_input_b_valid = ((|{io_sharedOutputs_2_b_valid,{io_sharedOutputs_1_b_valid,io_sharedOutputs_0_b_valid}}) || errorSlave_io_axi_b_valid);
  assign io_sharedOutputs_0_b_ready = io_input_b_ready;
  assign io_sharedOutputs_1_b_ready = io_input_b_ready;
  assign io_sharedOutputs_2_b_ready = io_input_b_ready;
  assign _zz_readRspIndex = pendingSels[2 : 0];
  assign _zz_readRspIndex_1 = _zz_readRspIndex[1];
  assign _zz_readRspIndex_2 = _zz_readRspIndex[2];
  assign readRspIndex = {_zz_readRspIndex_2,_zz_readRspIndex_1};
  assign io_input_r_valid = ((|{io_sharedOutputs_2_r_valid,{io_sharedOutputs_1_r_valid,io_sharedOutputs_0_r_valid}}) || errorSlave_io_axi_r_valid);
  assign io_input_r_payload_data = _zz_io_input_r_payload_data;
  always @(*) begin
    io_input_r_payload_last = _zz_io_input_r_payload_last;
    if(pendingError) begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_sharedOutputs_0_r_ready = io_input_r_ready;
  assign io_sharedOutputs_1_r_ready = io_input_r_ready;
  assign io_sharedOutputs_2_r_ready = io_input_r_ready;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      pendingCmdCounter <= 3'b000;
      pendingDataCounter_value <= 3'b000;
      pendingSels <= 3'b000;
      pendingError <= 1'b0;
      _zz_cmdAllowedStart <= 1'b1;
    end else begin
      pendingCmdCounter <= _zz_pendingCmdCounter;
      pendingDataCounter_value <= pendingDataCounter_valueNext;
      if(cmdAllowedStart) begin
        pendingSels <= decodedCmdSels;
      end
      if(cmdAllowedStart) begin
        pendingError <= decodedCmdError;
      end
      if(cmdAllowedStart) begin
        _zz_cmdAllowedStart <= 1'b0;
      end
      if(io_input_arw_ready) begin
        _zz_cmdAllowedStart <= 1'b1;
      end
    end
  end


endmodule

module Axi4ReadOnlyDecoder (
  input  wire          io_input_ar_valid,
  output wire          io_input_ar_ready,
  input  wire [31:0]   io_input_ar_payload_addr,
  input  wire [3:0]    io_input_ar_payload_cache,
  input  wire [2:0]    io_input_ar_payload_prot,
  output reg           io_input_r_valid,
  input  wire          io_input_r_ready,
  output wire [31:0]   io_input_r_payload_data,
  output reg           io_input_r_payload_last,
  output wire          io_outputs_0_ar_valid,
  input  wire          io_outputs_0_ar_ready,
  output wire [31:0]   io_outputs_0_ar_payload_addr,
  output wire [3:0]    io_outputs_0_ar_payload_cache,
  output wire [2:0]    io_outputs_0_ar_payload_prot,
  input  wire          io_outputs_0_r_valid,
  output wire          io_outputs_0_r_ready,
  input  wire [31:0]   io_outputs_0_r_payload_data,
  input  wire          io_outputs_0_r_payload_last,
  output wire          io_outputs_1_ar_valid,
  input  wire          io_outputs_1_ar_ready,
  output wire [31:0]   io_outputs_1_ar_payload_addr,
  output wire [3:0]    io_outputs_1_ar_payload_cache,
  output wire [2:0]    io_outputs_1_ar_payload_prot,
  input  wire          io_outputs_1_r_valid,
  output wire          io_outputs_1_r_ready,
  input  wire [31:0]   io_outputs_1_r_payload_data,
  input  wire          io_outputs_1_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                errorSlave_io_axi_ar_valid;
  wire                errorSlave_io_axi_ar_ready;
  wire                errorSlave_io_axi_r_valid;
  wire       [31:0]   errorSlave_io_axi_r_payload_data;
  wire                errorSlave_io_axi_r_payload_last;
  wire                io_input_ar_fire;
  wire                io_input_r_fire;
  wire                when_Utils_l719;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_mayOverflow;
  wire                pendingCmdCounter_mayUnderflow;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  wire                pendingCmdCounter_willUnderflowIfDec;
  wire                pendingCmdCounter_willUnderflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l751;
  wire                when_Utils_l753;
  wire       [1:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [1:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;
  wire                _zz_io_input_r_payload_data;
  wire                _zz_readRspIndex;
  wire       [0:0]    readRspIndex;

  Axi4ReadOnlyErrorSlave errorSlave (
    .io_axi_ar_valid         (errorSlave_io_axi_ar_valid            ), //i
    .io_axi_ar_ready         (errorSlave_io_axi_ar_ready            ), //o
    .io_axi_ar_payload_addr  (io_input_ar_payload_addr[31:0]        ), //i
    .io_axi_ar_payload_cache (io_input_ar_payload_cache[3:0]        ), //i
    .io_axi_ar_payload_prot  (io_input_ar_payload_prot[2:0]         ), //i
    .io_axi_r_valid          (errorSlave_io_axi_r_valid             ), //o
    .io_axi_r_ready          (io_input_r_ready                      ), //i
    .io_axi_r_payload_data   (errorSlave_io_axi_r_payload_data[31:0]), //o
    .io_axi_r_payload_last   (errorSlave_io_axi_r_payload_last      ), //o
    .clkout                  (clkout                                ), //i
    .resetCtrl_axiReset      (resetCtrl_axiReset                    )  //i
  );
  assign io_input_ar_fire = (io_input_ar_valid && io_input_ar_ready);
  assign io_input_r_fire = (io_input_r_valid && io_input_r_ready);
  assign when_Utils_l719 = (io_input_r_fire && io_input_r_payload_last);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_ar_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(when_Utils_l719) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_mayOverflow = (pendingCmdCounter_value == 3'b111);
  assign pendingCmdCounter_mayUnderflow = (pendingCmdCounter_value == 3'b000);
  assign pendingCmdCounter_willOverflowIfInc = (pendingCmdCounter_mayOverflow && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign pendingCmdCounter_willUnderflowIfDec = (pendingCmdCounter_mayUnderflow && (! pendingCmdCounter_incrementIt));
  assign pendingCmdCounter_willUnderflow = (pendingCmdCounter_willUnderflowIfDec && pendingCmdCounter_decrementIt);
  assign when_Utils_l751 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l751) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l753) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l753 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign decodedCmdSels = {(((io_input_ar_payload_addr & (~ 32'h07ffffff)) == 32'h40000000) && io_input_ar_valid),(((io_input_ar_payload_addr & (~ 32'h00007fff)) == 32'h0) && io_input_ar_valid)};
  assign decodedCmdError = (decodedCmdSels == 2'b00);
  assign allowCmd = ((pendingCmdCounter_value == 3'b000) || ((pendingCmdCounter_value != 3'b111) && (pendingSels == decodedCmdSels)));
  assign io_input_ar_ready = (((|(decodedCmdSels & {io_outputs_1_ar_ready,io_outputs_0_ar_ready})) || (decodedCmdError && errorSlave_io_axi_ar_ready)) && allowCmd);
  assign errorSlave_io_axi_ar_valid = ((io_input_ar_valid && decodedCmdError) && allowCmd);
  assign io_outputs_0_ar_valid = ((io_input_ar_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_ar_payload_addr = io_input_ar_payload_addr;
  assign io_outputs_0_ar_payload_cache = io_input_ar_payload_cache;
  assign io_outputs_0_ar_payload_prot = io_input_ar_payload_prot;
  assign io_outputs_1_ar_valid = ((io_input_ar_valid && decodedCmdSels[1]) && allowCmd);
  assign io_outputs_1_ar_payload_addr = io_input_ar_payload_addr;
  assign io_outputs_1_ar_payload_cache = io_input_ar_payload_cache;
  assign io_outputs_1_ar_payload_prot = io_input_ar_payload_prot;
  assign _zz_io_input_r_payload_data = pendingSels[0];
  assign _zz_readRspIndex = pendingSels[1];
  assign readRspIndex = _zz_readRspIndex;
  always @(*) begin
    io_input_r_valid = (|{io_outputs_1_r_valid,io_outputs_0_r_valid});
    if(errorSlave_io_axi_r_valid) begin
      io_input_r_valid = 1'b1;
    end
  end

  assign io_input_r_payload_data = (_zz_io_input_r_payload_data ? io_outputs_0_r_payload_data : io_outputs_1_r_payload_data);
  always @(*) begin
    io_input_r_payload_last = (_zz_io_input_r_payload_data ? io_outputs_0_r_payload_last : io_outputs_1_r_payload_last);
    if(pendingError) begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_outputs_0_r_ready = io_input_r_ready;
  assign io_outputs_1_r_ready = io_input_r_ready;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      pendingCmdCounter_value <= 3'b000;
      pendingSels <= 2'b00;
      pendingError <= 1'b0;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      if(io_input_ar_ready) begin
        pendingSels <= decodedCmdSels;
      end
      if(io_input_ar_ready) begin
        pendingError <= decodedCmdError;
      end
    end
  end


endmodule

module Axi4Lcd (
  input  wire [9:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_axi_ar_valid,
  input  wire          io_axi_ar_ready,
  output wire [31:0]   io_axi_ar_payload_addr,
  output wire [7:0]    io_axi_ar_payload_len,
  output wire [2:0]    io_axi_ar_payload_size,
  output wire [3:0]    io_axi_ar_payload_cache,
  output wire [2:0]    io_axi_ar_payload_prot,
  input  wire          io_axi_r_valid,
  output wire          io_axi_r_ready,
  input  wire [31:0]   io_axi_r_payload_data,
  input  wire          io_axi_r_payload_last,
  output wire          io_dvti_vs,
  output wire          io_dvti_hs,
  output wire          io_dvti_de,
  output wire [15:0]   io_dvti_data,
  output wire          io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clkout_1
);

  wire                dvtc_io_apb_PREADY;
  wire       [31:0]   dvtc_io_apb_PRDATA;
  wire                dvtc_io_axi_ar_valid;
  wire       [31:0]   dvtc_io_axi_ar_payload_addr;
  wire       [7:0]    dvtc_io_axi_ar_payload_len;
  wire       [2:0]    dvtc_io_axi_ar_payload_size;
  wire       [3:0]    dvtc_io_axi_ar_payload_cache;
  wire       [2:0]    dvtc_io_axi_ar_payload_prot;
  wire                dvtc_io_axi_r_ready;
  wire                dvtc_io_dvti_vs;
  wire                dvtc_io_dvti_hs;
  wire                dvtc_io_dvti_de;
  wire       [15:0]   dvtc_io_dvti_data;
  wire                dvtc_io_interrupt;

  Apb3Dvtc dvtc (
    .io_apb_PADDR            (io_apb_PADDR[9:0]                ), //i
    .io_apb_PSEL             (io_apb_PSEL                      ), //i
    .io_apb_PENABLE          (io_apb_PENABLE                   ), //i
    .io_apb_PREADY           (dvtc_io_apb_PREADY               ), //o
    .io_apb_PWRITE           (io_apb_PWRITE                    ), //i
    .io_apb_PWDATA           (io_apb_PWDATA[31:0]              ), //i
    .io_apb_PRDATA           (dvtc_io_apb_PRDATA[31:0]         ), //o
    .io_axi_ar_valid         (dvtc_io_axi_ar_valid             ), //o
    .io_axi_ar_ready         (io_axi_ar_ready                  ), //i
    .io_axi_ar_payload_addr  (dvtc_io_axi_ar_payload_addr[31:0]), //o
    .io_axi_ar_payload_len   (dvtc_io_axi_ar_payload_len[7:0]  ), //o
    .io_axi_ar_payload_size  (dvtc_io_axi_ar_payload_size[2:0] ), //o
    .io_axi_ar_payload_cache (dvtc_io_axi_ar_payload_cache[3:0]), //o
    .io_axi_ar_payload_prot  (dvtc_io_axi_ar_payload_prot[2:0] ), //o
    .io_axi_r_valid          (io_axi_r_valid                   ), //i
    .io_axi_r_ready          (dvtc_io_axi_r_ready              ), //o
    .io_axi_r_payload_data   (io_axi_r_payload_data[31:0]      ), //i
    .io_axi_r_payload_last   (io_axi_r_payload_last            ), //i
    .io_dvti_vs              (dvtc_io_dvti_vs                  ), //o
    .io_dvti_hs              (dvtc_io_dvti_hs                  ), //o
    .io_dvti_de              (dvtc_io_dvti_de                  ), //o
    .io_dvti_data            (dvtc_io_dvti_data[15:0]          ), //o
    .io_interrupt            (dvtc_io_interrupt                ), //o
    .clkout                  (clkout                           ), //i
    .resetCtrl_axiReset      (resetCtrl_axiReset               ), //i
    .clkout_1                (clkout_1                         )  //i
  );
  assign io_apb_PREADY = dvtc_io_apb_PREADY;
  assign io_apb_PRDATA = dvtc_io_apb_PRDATA;
  assign io_axi_ar_valid = dvtc_io_axi_ar_valid;
  assign io_axi_ar_payload_addr = dvtc_io_axi_ar_payload_addr;
  assign io_axi_ar_payload_len = dvtc_io_axi_ar_payload_len;
  assign io_axi_ar_payload_size = dvtc_io_axi_ar_payload_size;
  assign io_axi_ar_payload_cache = dvtc_io_axi_ar_payload_cache;
  assign io_axi_ar_payload_prot = dvtc_io_axi_ar_payload_prot;
  assign io_axi_r_ready = dvtc_io_axi_r_ready;
  assign io_dvti_vs = dvtc_io_dvti_vs;
  assign io_dvti_hs = dvtc_io_dvti_hs;
  assign io_dvti_de = dvtc_io_dvti_de;
  assign io_dvti_data = dvtc_io_dvti_data;
  assign io_interrupt = dvtc_io_interrupt;

endmodule

module ApbUartArray (
  input  wire [12:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_uarts_0_txd,
  input  wire          io_uarts_0_rxd,
  output wire          io_uarts_1_txd,
  input  wire          io_uarts_1_rxd,
  output reg  [1:0]    io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [4:0]    UART_0_io_apb_PADDR;
  wire       [4:0]    UART_1_io_apb_PADDR;
  wire                UART_0_io_apb_PREADY;
  wire       [31:0]   UART_0_io_apb_PRDATA;
  wire                UART_0_io_apb_PSLVERROR;
  wire                UART_0_io_uart_txd;
  wire                UART_0_io_interrupt;
  wire                UART_1_io_apb_PREADY;
  wire       [31:0]   UART_1_io_apb_PRDATA;
  wire                UART_1_io_apb_PSLVERROR;
  wire                UART_1_io_uart_txd;
  wire                UART_1_io_interrupt;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_5_io_input_PREADY;
  wire       [31:0]   apb3Router_5_io_input_PRDATA;
  wire                apb3Router_5_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_5_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_0_PSEL;
  wire                apb3Router_5_io_outputs_0_PENABLE;
  wire                apb3Router_5_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_5_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_1_PSEL;
  wire                apb3Router_5_io_outputs_1_PENABLE;
  wire                apb3Router_5_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_1_PWDATA;

  ApbUart UART_0 (
    .io_apb_PADDR       (UART_0_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY      (UART_0_io_apb_PREADY                  ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA      (UART_0_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR   (UART_0_io_apb_PSLVERROR               ), //o
    .io_uart_txd        (UART_0_io_uart_txd                    ), //o
    .io_uart_rxd        (io_uarts_0_rxd                        ), //i
    .io_interrupt       (UART_0_io_interrupt                   ), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  ApbUart UART_1 (
    .io_apb_PADDR       (UART_1_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY      (UART_1_io_apb_PREADY                  ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA      (UART_1_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR   (UART_1_io_apb_PSLVERROR               ), //o
    .io_uart_txd        (UART_1_io_uart_txd                    ), //o
    .io_uart_rxd        (io_uarts_1_rxd                        ), //i
    .io_interrupt       (UART_1_io_interrupt                   ), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  Apb3Decoder io_apb_decoder (
    .io_input_PADDR      (io_apb_PADDR[12:0]                   ), //i
    .io_input_PSEL       (io_apb_PSEL                          ), //i
    .io_input_PENABLE    (io_apb_PENABLE                       ), //i
    .io_input_PREADY     (io_apb_decoder_io_input_PREADY       ), //o
    .io_input_PWRITE     (io_apb_PWRITE                        ), //i
    .io_input_PWDATA     (io_apb_PWDATA[31:0]                  ), //i
    .io_input_PRDATA     (io_apb_decoder_io_input_PRDATA[31:0] ), //o
    .io_input_PSLVERROR  (io_apb_decoder_io_input_PSLVERROR    ), //o
    .io_output_PADDR     (io_apb_decoder_io_output_PADDR[12:0] ), //o
    .io_output_PSEL      (io_apb_decoder_io_output_PSEL[1:0]   ), //o
    .io_output_PENABLE   (io_apb_decoder_io_output_PENABLE     ), //o
    .io_output_PREADY    (apb3Router_5_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_5_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_5_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_5 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_5_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_5_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_5_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_5_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_5_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_5_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (UART_0_io_apb_PREADY                  ), //i
    .io_outputs_0_PWRITE    (apb3Router_5_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_5_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (UART_0_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_0_PSLVERROR (UART_0_io_apb_PSLVERROR               ), //i
    .io_outputs_1_PADDR     (apb3Router_5_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_5_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_5_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (UART_1_io_apb_PREADY                  ), //i
    .io_outputs_1_PWRITE    (apb3Router_5_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_5_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (UART_1_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_1_PSLVERROR (UART_1_io_apb_PSLVERROR               ), //i
    .clkout                 (clkout                                ), //i
    .resetCtrl_axiReset     (resetCtrl_axiReset                    )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign UART_0_io_apb_PADDR = apb3Router_5_io_outputs_0_PADDR[4:0];
  assign UART_1_io_apb_PADDR = apb3Router_5_io_outputs_1_PADDR[4:0];
  assign io_uarts_0_txd = UART_0_io_uart_txd;
  always @(*) begin
    io_interrupt[0] = UART_0_io_interrupt;
    io_interrupt[1] = UART_1_io_interrupt;
  end

  assign io_uarts_1_txd = UART_1_io_uart_txd;

endmodule

module Apb3SysTick (
  input  wire [3:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [31:0]   CTRL;
  reg        [31:0]   LOAD;
  reg        [31:0]   VAL;
  wire       [31:0]   CALIB;
  wire                ENABLE;
  wire                TICKINT;
  wire                CLKSOURCE;
  wire                COUNTFLAG;
  wire                when_apb3systick_l39;
  wire                when_apb3systick_l42;

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      4'b0000 : begin
        io_apb_PRDATA[31 : 0] = CTRL;
      end
      4'b0100 : begin
        io_apb_PRDATA[31 : 0] = LOAD;
      end
      4'b1000 : begin
        io_apb_PRDATA[31 : 0] = VAL;
      end
      4'b1100 : begin
        io_apb_PRDATA[31 : 0] = CALIB;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign CALIB = 32'h000003e8;
  assign ENABLE = CTRL[0];
  assign TICKINT = CTRL[1];
  assign CLKSOURCE = CTRL[2];
  assign COUNTFLAG = CTRL[16];
  assign when_apb3systick_l39 = (VAL == 32'h0);
  assign when_apb3systick_l42 = (VAL == 32'h00000001);
  assign io_interrupt = (TICKINT && COUNTFLAG);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      CTRL <= 32'h0;
      LOAD <= 32'h0;
      VAL <= 32'h0;
    end else begin
      if(ENABLE) begin
        if(when_apb3systick_l39) begin
          VAL <= LOAD;
        end else begin
          if(when_apb3systick_l42) begin
            CTRL[16] <= 1'b1;
          end
          VAL <= (VAL - 32'h00000001);
        end
      end else begin
        CTRL[16] <= 1'b0;
      end
      case(io_apb_PADDR)
        4'b0000 : begin
          if(ctrl_doWrite) begin
            CTRL <= io_apb_PWDATA[31 : 0];
          end
        end
        4'b0100 : begin
          if(ctrl_doWrite) begin
            LOAD <= io_apb_PWDATA[31 : 0];
          end
        end
        4'b1000 : begin
          if(ctrl_doWrite) begin
            VAL <= io_apb_PWDATA[31 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Apb3Wdg (
  input  wire [12:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_iwdgRst,
  output wire          io_wwdgRst,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  wire       [3:0]    iwdg_io_apb_PADDR;
  wire       [4:0]    wwdg_io_apb_PADDR;
  wire                iwdg_io_apb_PREADY;
  wire       [31:0]   iwdg_io_apb_PRDATA;
  wire                iwdg_io_apb_PSLVERROR;
  wire                iwdg_io_rst;
  wire                wwdg_io_apb_PREADY;
  wire       [31:0]   wwdg_io_apb_PRDATA;
  wire                wwdg_io_apb_PSLVERROR;
  wire                wwdg_io_rst;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_5_io_input_PREADY;
  wire       [31:0]   apb3Router_5_io_input_PRDATA;
  wire                apb3Router_5_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_5_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_0_PSEL;
  wire                apb3Router_5_io_outputs_0_PENABLE;
  wire                apb3Router_5_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_5_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_1_PSEL;
  wire                apb3Router_5_io_outputs_1_PENABLE;
  wire                apb3Router_5_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_1_PWDATA;

  Apb3Iwdg iwdg (
    .io_apb_PADDR        (iwdg_io_apb_PADDR[3:0]                ), //i
    .io_apb_PSEL         (apb3Router_5_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_5_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY       (iwdg_io_apb_PREADY                    ), //o
    .io_apb_PWRITE       (apb3Router_5_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_5_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA       (iwdg_io_apb_PRDATA[31:0]              ), //o
    .io_apb_PSLVERROR    (iwdg_io_apb_PSLVERROR                 ), //o
    .io_rst              (iwdg_io_rst                           ), //o
    .clkout              (clkout                                ), //i
    .resetCtrl_coreReset (resetCtrl_coreReset                   )  //i
  );
  Apb3Wwdg wwdg (
    .io_apb_PADDR        (wwdg_io_apb_PADDR[4:0]                ), //i
    .io_apb_PSEL         (apb3Router_5_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_5_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY       (wwdg_io_apb_PREADY                    ), //o
    .io_apb_PWRITE       (apb3Router_5_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_5_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA       (wwdg_io_apb_PRDATA[31:0]              ), //o
    .io_apb_PSLVERROR    (wwdg_io_apb_PSLVERROR                 ), //o
    .io_rst              (wwdg_io_rst                           ), //o
    .clkout              (clkout                                ), //i
    .resetCtrl_coreReset (resetCtrl_coreReset                   )  //i
  );
  Apb3Decoder io_apb_decoder (
    .io_input_PADDR      (io_apb_PADDR[12:0]                   ), //i
    .io_input_PSEL       (io_apb_PSEL                          ), //i
    .io_input_PENABLE    (io_apb_PENABLE                       ), //i
    .io_input_PREADY     (io_apb_decoder_io_input_PREADY       ), //o
    .io_input_PWRITE     (io_apb_PWRITE                        ), //i
    .io_input_PWDATA     (io_apb_PWDATA[31:0]                  ), //i
    .io_input_PRDATA     (io_apb_decoder_io_input_PRDATA[31:0] ), //o
    .io_input_PSLVERROR  (io_apb_decoder_io_input_PSLVERROR    ), //o
    .io_output_PADDR     (io_apb_decoder_io_output_PADDR[12:0] ), //o
    .io_output_PSEL      (io_apb_decoder_io_output_PSEL[1:0]   ), //o
    .io_output_PENABLE   (io_apb_decoder_io_output_PENABLE     ), //o
    .io_output_PREADY    (apb3Router_5_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_5_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_5_io_input_PSLVERROR      )  //i
  );
  Apb3Router_2 apb3Router_5 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_5_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_5_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_5_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_5_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_5_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_5_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (iwdg_io_apb_PREADY                    ), //i
    .io_outputs_0_PWRITE    (apb3Router_5_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_5_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (iwdg_io_apb_PRDATA[31:0]              ), //i
    .io_outputs_0_PSLVERROR (iwdg_io_apb_PSLVERROR                 ), //i
    .io_outputs_1_PADDR     (apb3Router_5_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_5_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_5_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (wwdg_io_apb_PREADY                    ), //i
    .io_outputs_1_PWRITE    (apb3Router_5_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_5_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (wwdg_io_apb_PRDATA[31:0]              ), //i
    .io_outputs_1_PSLVERROR (wwdg_io_apb_PSLVERROR                 ), //i
    .clkout                 (clkout                                ), //i
    .resetCtrl_coreReset    (resetCtrl_coreReset                   )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign iwdg_io_apb_PADDR = apb3Router_5_io_outputs_0_PADDR[3:0];
  assign wwdg_io_apb_PADDR = apb3Router_5_io_outputs_1_PADDR[4:0];
  assign io_iwdgRst = iwdg_io_rst;
  assign io_wwdgRst = wwdg_io_rst;

endmodule

module Apb3TimArray (
  input  wire [12:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output reg  [7:0]    io_tim_ch,
  output reg  [1:0]    io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [6:0]    TIM_0_io_apb_PADDR;
  wire       [6:0]    TIM_1_io_apb_PADDR;
  wire                TIM_0_io_apb_PREADY;
  wire       [31:0]   TIM_0_io_apb_PRDATA;
  wire                TIM_0_io_apb_PSLVERROR;
  wire       [3:0]    TIM_0_io_tim_ch;
  wire                TIM_0_io_interrupt;
  wire                TIM_1_io_apb_PREADY;
  wire       [31:0]   TIM_1_io_apb_PRDATA;
  wire                TIM_1_io_apb_PSLVERROR;
  wire       [3:0]    TIM_1_io_tim_ch;
  wire                TIM_1_io_interrupt;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_5_io_input_PREADY;
  wire       [31:0]   apb3Router_5_io_input_PRDATA;
  wire                apb3Router_5_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_5_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_0_PSEL;
  wire                apb3Router_5_io_outputs_0_PENABLE;
  wire                apb3Router_5_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_5_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_1_PSEL;
  wire                apb3Router_5_io_outputs_1_PENABLE;
  wire                apb3Router_5_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_1_PWDATA;

  Apb3Tim TIM_0 (
    .io_apb_PADDR       (TIM_0_io_apb_PADDR[6:0]               ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY      (TIM_0_io_apb_PREADY                   ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA      (TIM_0_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR   (TIM_0_io_apb_PSLVERROR                ), //o
    .io_tim_ch          (TIM_0_io_tim_ch[3:0]                  ), //o
    .io_interrupt       (TIM_0_io_interrupt                    ), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  Apb3Tim TIM_1 (
    .io_apb_PADDR       (TIM_1_io_apb_PADDR[6:0]               ), //i
    .io_apb_PSEL        (apb3Router_5_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE     (apb3Router_5_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY      (TIM_1_io_apb_PREADY                   ), //o
    .io_apb_PWRITE      (apb3Router_5_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA      (apb3Router_5_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA      (TIM_1_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR   (TIM_1_io_apb_PSLVERROR                ), //o
    .io_tim_ch          (TIM_1_io_tim_ch[3:0]                  ), //o
    .io_interrupt       (TIM_1_io_interrupt                    ), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  Apb3Decoder io_apb_decoder (
    .io_input_PADDR      (io_apb_PADDR[12:0]                   ), //i
    .io_input_PSEL       (io_apb_PSEL                          ), //i
    .io_input_PENABLE    (io_apb_PENABLE                       ), //i
    .io_input_PREADY     (io_apb_decoder_io_input_PREADY       ), //o
    .io_input_PWRITE     (io_apb_PWRITE                        ), //i
    .io_input_PWDATA     (io_apb_PWDATA[31:0]                  ), //i
    .io_input_PRDATA     (io_apb_decoder_io_input_PRDATA[31:0] ), //o
    .io_input_PSLVERROR  (io_apb_decoder_io_input_PSLVERROR    ), //o
    .io_output_PADDR     (io_apb_decoder_io_output_PADDR[12:0] ), //o
    .io_output_PSEL      (io_apb_decoder_io_output_PSEL[1:0]   ), //o
    .io_output_PENABLE   (io_apb_decoder_io_output_PENABLE     ), //o
    .io_output_PREADY    (apb3Router_5_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_5_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_5_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_5 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_5_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_5_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_5_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_5_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_5_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_5_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (TIM_0_io_apb_PREADY                   ), //i
    .io_outputs_0_PWRITE    (apb3Router_5_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_5_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (TIM_0_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_0_PSLVERROR (TIM_0_io_apb_PSLVERROR                ), //i
    .io_outputs_1_PADDR     (apb3Router_5_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_5_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_5_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (TIM_1_io_apb_PREADY                   ), //i
    .io_outputs_1_PWRITE    (apb3Router_5_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_5_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (TIM_1_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_1_PSLVERROR (TIM_1_io_apb_PSLVERROR                ), //i
    .clkout                 (clkout                                ), //i
    .resetCtrl_axiReset     (resetCtrl_axiReset                    )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign TIM_0_io_apb_PADDR = apb3Router_5_io_outputs_0_PADDR[6:0];
  assign TIM_1_io_apb_PADDR = apb3Router_5_io_outputs_1_PADDR[6:0];
  always @(*) begin
    io_tim_ch[3 : 0] = TIM_0_io_tim_ch;
    io_tim_ch[7 : 4] = TIM_1_io_tim_ch;
  end

  always @(*) begin
    io_interrupt[0] = TIM_0_io_interrupt;
    io_interrupt[1] = TIM_1_io_interrupt;
  end


endmodule

module Apb3GpioArray (
  input  wire [12:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  input  wire [31:0]   io_gpio_read,
  output wire [31:0]   io_gpio_write,
  output wire [31:0]   io_gpio_writeEnable,
  input  wire [31:0]   io_afio,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [4:0]    GPIO_0_io_apb_PADDR;
  wire       [15:0]   GPIO_0_io_gpio_read;
  wire       [15:0]   GPIO_0_io_afio;
  wire       [4:0]    GPIO_1_io_apb_PADDR;
  wire       [15:0]   GPIO_1_io_gpio_read;
  wire       [15:0]   GPIO_1_io_afio;
  wire                GPIO_0_io_apb_PREADY;
  wire       [31:0]   GPIO_0_io_apb_PRDATA;
  wire                GPIO_0_io_apb_PSLVERROR;
  wire       [15:0]   GPIO_0_io_gpio_write;
  wire       [15:0]   GPIO_0_io_gpio_writeEnable;
  wire                GPIO_1_io_apb_PREADY;
  wire       [31:0]   GPIO_1_io_apb_PRDATA;
  wire                GPIO_1_io_apb_PSLVERROR;
  wire       [15:0]   GPIO_1_io_gpio_write;
  wire       [15:0]   GPIO_1_io_gpio_writeEnable;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_5_io_input_PREADY;
  wire       [31:0]   apb3Router_5_io_input_PRDATA;
  wire                apb3Router_5_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_5_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_0_PSEL;
  wire                apb3Router_5_io_outputs_0_PENABLE;
  wire                apb3Router_5_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_5_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_5_io_outputs_1_PSEL;
  wire                apb3Router_5_io_outputs_1_PENABLE;
  wire                apb3Router_5_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_5_io_outputs_1_PWDATA;
  wire       [31:0]   gpioVec_read;
  reg        [31:0]   gpioVec_write;
  reg        [31:0]   gpioVec_writeEnable;

  Apb3Gpio GPIO_0 (
    .io_apb_PADDR        (GPIO_0_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL         (apb3Router_5_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_5_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY       (GPIO_0_io_apb_PREADY                  ), //o
    .io_apb_PWRITE       (apb3Router_5_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_5_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA       (GPIO_0_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR    (GPIO_0_io_apb_PSLVERROR               ), //o
    .io_gpio_read        (GPIO_0_io_gpio_read[15:0]             ), //i
    .io_gpio_write       (GPIO_0_io_gpio_write[15:0]            ), //o
    .io_gpio_writeEnable (GPIO_0_io_gpio_writeEnable[15:0]      ), //o
    .io_afio             (GPIO_0_io_afio[15:0]                  ), //i
    .clkout              (clkout                                ), //i
    .resetCtrl_axiReset  (resetCtrl_axiReset                    )  //i
  );
  Apb3Gpio GPIO_1 (
    .io_apb_PADDR        (GPIO_1_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL         (apb3Router_5_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_5_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY       (GPIO_1_io_apb_PREADY                  ), //o
    .io_apb_PWRITE       (apb3Router_5_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_5_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA       (GPIO_1_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR    (GPIO_1_io_apb_PSLVERROR               ), //o
    .io_gpio_read        (GPIO_1_io_gpio_read[15:0]             ), //i
    .io_gpio_write       (GPIO_1_io_gpio_write[15:0]            ), //o
    .io_gpio_writeEnable (GPIO_1_io_gpio_writeEnable[15:0]      ), //o
    .io_afio             (GPIO_1_io_afio[15:0]                  ), //i
    .clkout              (clkout                                ), //i
    .resetCtrl_axiReset  (resetCtrl_axiReset                    )  //i
  );
  Apb3Decoder io_apb_decoder (
    .io_input_PADDR      (io_apb_PADDR[12:0]                   ), //i
    .io_input_PSEL       (io_apb_PSEL                          ), //i
    .io_input_PENABLE    (io_apb_PENABLE                       ), //i
    .io_input_PREADY     (io_apb_decoder_io_input_PREADY       ), //o
    .io_input_PWRITE     (io_apb_PWRITE                        ), //i
    .io_input_PWDATA     (io_apb_PWDATA[31:0]                  ), //i
    .io_input_PRDATA     (io_apb_decoder_io_input_PRDATA[31:0] ), //o
    .io_input_PSLVERROR  (io_apb_decoder_io_input_PSLVERROR    ), //o
    .io_output_PADDR     (io_apb_decoder_io_output_PADDR[12:0] ), //o
    .io_output_PSEL      (io_apb_decoder_io_output_PSEL[1:0]   ), //o
    .io_output_PENABLE   (io_apb_decoder_io_output_PENABLE     ), //o
    .io_output_PREADY    (apb3Router_5_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_5_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_5_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_5 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_5_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_5_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_5_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_5_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_5_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_5_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (GPIO_0_io_apb_PREADY                  ), //i
    .io_outputs_0_PWRITE    (apb3Router_5_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_5_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (GPIO_0_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_0_PSLVERROR (GPIO_0_io_apb_PSLVERROR               ), //i
    .io_outputs_1_PADDR     (apb3Router_5_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_5_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_5_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (GPIO_1_io_apb_PREADY                  ), //i
    .io_outputs_1_PWRITE    (apb3Router_5_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_5_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (GPIO_1_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_1_PSLVERROR (GPIO_1_io_apb_PSLVERROR               ), //i
    .clkout                 (clkout                                ), //i
    .resetCtrl_axiReset     (resetCtrl_axiReset                    )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign GPIO_0_io_apb_PADDR = apb3Router_5_io_outputs_0_PADDR[4:0];
  assign GPIO_1_io_apb_PADDR = apb3Router_5_io_outputs_1_PADDR[4:0];
  always @(*) begin
    gpioVec_write[15 : 0] = GPIO_0_io_gpio_write;
    gpioVec_write[31 : 16] = GPIO_1_io_gpio_write;
  end

  always @(*) begin
    gpioVec_writeEnable[15 : 0] = GPIO_0_io_gpio_writeEnable;
    gpioVec_writeEnable[31 : 16] = GPIO_1_io_gpio_writeEnable;
  end

  assign GPIO_0_io_gpio_read = gpioVec_read[15 : 0];
  assign GPIO_0_io_afio = io_afio[15 : 0];
  assign GPIO_1_io_gpio_read = gpioVec_read[31 : 16];
  assign GPIO_1_io_afio = io_afio[31 : 16];
  assign gpioVec_read = io_gpio_read;
  assign io_gpio_write = gpioVec_write;
  assign io_gpio_writeEnable = gpioVec_writeEnable;

endmodule

module Apb3Exti (
  input  wire [4:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  input  wire [15:0]   io_exti,
  output wire [15:0]   io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [15:0]   IMR;
  reg        [15:0]   EMR;
  reg        [15:0]   RTSR;
  reg        [15:0]   FTSR;
  reg        [15:0]   SWIER;
  reg        [15:0]   PR;
  reg        [15:0]   extiReg;
  wire       [15:0]   risingEdge;
  wire       [15:0]   fallingEdge;
  wire       [15:0]   edgeTriggered;
  wire       [15:0]   swTriggered;
  wire       [15:0]   newPending;

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      5'h0 : begin
        io_apb_PRDATA[15 : 0] = IMR;
      end
      5'h04 : begin
        io_apb_PRDATA[15 : 0] = EMR;
      end
      5'h08 : begin
        io_apb_PRDATA[15 : 0] = RTSR;
      end
      5'h0c : begin
        io_apb_PRDATA[15 : 0] = FTSR;
      end
      5'h10 : begin
        io_apb_PRDATA[15 : 0] = SWIER;
      end
      5'h14 : begin
        io_apb_PRDATA[15 : 0] = PR;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign risingEdge = (io_exti & (~ extiReg));
  assign fallingEdge = ((~ io_exti) & extiReg);
  assign edgeTriggered = ((risingEdge & RTSR) | (fallingEdge & FTSR));
  assign swTriggered = (SWIER & IMR);
  assign newPending = ((edgeTriggered | swTriggered) & IMR);
  assign io_interrupt = (PR & IMR);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      IMR <= 16'h0;
      EMR <= 16'h0;
      RTSR <= 16'h0;
      FTSR <= 16'h0;
      SWIER <= 16'h0;
      PR <= 16'h0;
      extiReg <= 16'h0;
    end else begin
      extiReg <= io_exti;
      PR <= (PR | edgeTriggered);
      case(io_apb_PADDR)
        5'h0 : begin
          if(ctrl_doWrite) begin
            IMR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h04 : begin
          if(ctrl_doWrite) begin
            EMR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h08 : begin
          if(ctrl_doWrite) begin
            RTSR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h0c : begin
          if(ctrl_doWrite) begin
            FTSR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h10 : begin
          if(ctrl_doWrite) begin
            SWIER <= (SWIER | io_apb_PWDATA[15 : 0]);
          end
        end
        5'h14 : begin
          if(ctrl_doWrite) begin
            PR <= (PR & (~ io_apb_PWDATA[15 : 0]));
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Apb3Afio (
  input  wire [4:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  input  wire [31:0]   io_device_read,
  output wire [31:0]   io_device_write,
  output wire [31:0]   io_device_writeEnable,
  input  wire [31:0]   io_afio_read,
  output wire [31:0]   io_afio_write,
  output wire [31:0]   io_afio_writeEnable,
  output wire [15:0]   io_afioExti,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [3:0]    _zz_switch_Misc_l245;
  wire       [31:0]   _zz_switch_Misc_l245_1;
  wire       [3:0]    _zz_switch_Misc_l245_1_1;
  wire       [31:0]   _zz_switch_Misc_l245_1_2;
  wire       [3:0]    _zz_switch_Misc_l245_2;
  wire       [31:0]   _zz_switch_Misc_l245_2_1;
  wire       [3:0]    _zz_switch_Misc_l245_3;
  wire       [31:0]   _zz_switch_Misc_l245_3_1;
  wire       [3:0]    _zz_switch_Misc_l245_4;
  wire       [31:0]   _zz_switch_Misc_l245_4_1;
  wire       [3:0]    _zz_switch_Misc_l245_5;
  wire       [31:0]   _zz_switch_Misc_l245_5_1;
  wire       [3:0]    _zz_switch_Misc_l245_6;
  wire       [31:0]   _zz_switch_Misc_l245_6_1;
  wire       [3:0]    _zz_switch_Misc_l245_7;
  wire       [31:0]   _zz_switch_Misc_l245_7_1;
  wire       [3:0]    _zz_switch_Misc_l245_8;
  wire       [31:0]   _zz_switch_Misc_l245_8_1;
  wire       [3:0]    _zz_switch_Misc_l245_9;
  wire       [31:0]   _zz_switch_Misc_l245_9_1;
  wire       [3:0]    _zz_switch_Misc_l245_10;
  wire       [31:0]   _zz_switch_Misc_l245_10_1;
  wire       [3:0]    _zz_switch_Misc_l245_11;
  wire       [31:0]   _zz_switch_Misc_l245_11_1;
  wire       [3:0]    _zz_switch_Misc_l245_12;
  wire       [31:0]   _zz_switch_Misc_l245_12_1;
  wire       [3:0]    _zz_switch_Misc_l245_13;
  wire       [31:0]   _zz_switch_Misc_l245_13_1;
  wire       [3:0]    _zz_switch_Misc_l245_14;
  wire       [31:0]   _zz_switch_Misc_l245_14_1;
  wire       [3:0]    _zz_switch_Misc_l245_15;
  wire       [31:0]   _zz_switch_Misc_l245_15_1;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [31:0]   EVCR;
  reg        [31:0]   MAPR;
  reg        [31:0]   EXTICR_0;
  reg        [31:0]   EXTICR_1;
  reg        [31:0]   EXTICR_2;
  reg        [31:0]   EXTICR_3;
  reg        [31:0]   MAPR2;
  reg        [15:0]   afioExti;
  wire       [0:0]    switch_Misc_l245;
  reg                 _zz_afioExti;
  wire       [0:0]    switch_Misc_l245_1;
  reg                 _zz_afioExti_1;
  wire       [0:0]    switch_Misc_l245_2;
  reg                 _zz_afioExti_2;
  wire       [0:0]    switch_Misc_l245_3;
  reg                 _zz_afioExti_3;
  wire       [0:0]    switch_Misc_l245_4;
  reg                 _zz_afioExti_4;
  wire       [0:0]    switch_Misc_l245_5;
  reg                 _zz_afioExti_5;
  wire       [0:0]    switch_Misc_l245_6;
  reg                 _zz_afioExti_6;
  wire       [0:0]    switch_Misc_l245_7;
  reg                 _zz_afioExti_7;
  wire       [0:0]    switch_Misc_l245_8;
  reg                 _zz_afioExti_8;
  wire       [0:0]    switch_Misc_l245_9;
  reg                 _zz_afioExti_9;
  wire       [0:0]    switch_Misc_l245_10;
  reg                 _zz_afioExti_10;
  wire       [0:0]    switch_Misc_l245_11;
  reg                 _zz_afioExti_11;
  wire       [0:0]    switch_Misc_l245_12;
  reg                 _zz_afioExti_12;
  wire       [0:0]    switch_Misc_l245_13;
  reg                 _zz_afioExti_13;
  wire       [0:0]    switch_Misc_l245_14;
  reg                 _zz_afioExti_14;
  wire       [0:0]    switch_Misc_l245_15;
  reg                 _zz_afioExti_15;

  assign _zz_switch_Misc_l245 = _zz_switch_Misc_l245_1[3 : 0];
  assign _zz_switch_Misc_l245_1 = EXTICR_0;
  assign _zz_switch_Misc_l245_1_1 = _zz_switch_Misc_l245_1_2[7 : 4];
  assign _zz_switch_Misc_l245_1_2 = EXTICR_0;
  assign _zz_switch_Misc_l245_2 = _zz_switch_Misc_l245_2_1[11 : 8];
  assign _zz_switch_Misc_l245_2_1 = EXTICR_0;
  assign _zz_switch_Misc_l245_3 = _zz_switch_Misc_l245_3_1[15 : 12];
  assign _zz_switch_Misc_l245_3_1 = EXTICR_0;
  assign _zz_switch_Misc_l245_4 = _zz_switch_Misc_l245_4_1[3 : 0];
  assign _zz_switch_Misc_l245_4_1 = EXTICR_1;
  assign _zz_switch_Misc_l245_5 = _zz_switch_Misc_l245_5_1[7 : 4];
  assign _zz_switch_Misc_l245_5_1 = EXTICR_1;
  assign _zz_switch_Misc_l245_6 = _zz_switch_Misc_l245_6_1[11 : 8];
  assign _zz_switch_Misc_l245_6_1 = EXTICR_1;
  assign _zz_switch_Misc_l245_7 = _zz_switch_Misc_l245_7_1[15 : 12];
  assign _zz_switch_Misc_l245_7_1 = EXTICR_1;
  assign _zz_switch_Misc_l245_8 = _zz_switch_Misc_l245_8_1[3 : 0];
  assign _zz_switch_Misc_l245_8_1 = EXTICR_2;
  assign _zz_switch_Misc_l245_9 = _zz_switch_Misc_l245_9_1[7 : 4];
  assign _zz_switch_Misc_l245_9_1 = EXTICR_2;
  assign _zz_switch_Misc_l245_10 = _zz_switch_Misc_l245_10_1[11 : 8];
  assign _zz_switch_Misc_l245_10_1 = EXTICR_2;
  assign _zz_switch_Misc_l245_11 = _zz_switch_Misc_l245_11_1[15 : 12];
  assign _zz_switch_Misc_l245_11_1 = EXTICR_2;
  assign _zz_switch_Misc_l245_12 = _zz_switch_Misc_l245_12_1[3 : 0];
  assign _zz_switch_Misc_l245_12_1 = EXTICR_3;
  assign _zz_switch_Misc_l245_13 = _zz_switch_Misc_l245_13_1[7 : 4];
  assign _zz_switch_Misc_l245_13_1 = EXTICR_3;
  assign _zz_switch_Misc_l245_14 = _zz_switch_Misc_l245_14_1[11 : 8];
  assign _zz_switch_Misc_l245_14_1 = EXTICR_3;
  assign _zz_switch_Misc_l245_15 = _zz_switch_Misc_l245_15_1[15 : 12];
  assign _zz_switch_Misc_l245_15_1 = EXTICR_3;
  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      5'h0 : begin
        io_apb_PRDATA[31 : 0] = EVCR;
      end
      5'h04 : begin
        io_apb_PRDATA[31 : 0] = MAPR;
      end
      5'h08 : begin
        io_apb_PRDATA[31 : 0] = EXTICR_0;
      end
      5'h0c : begin
        io_apb_PRDATA[31 : 0] = EXTICR_1;
      end
      5'h10 : begin
        io_apb_PRDATA[31 : 0] = EXTICR_2;
      end
      5'h14 : begin
        io_apb_PRDATA[31 : 0] = EXTICR_3;
      end
      5'h1c : begin
        io_apb_PRDATA[31 : 0] = MAPR2;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign switch_Misc_l245 = _zz_switch_Misc_l245[0:0];
  always @(*) begin
    case(switch_Misc_l245)
      1'b0 : begin
        _zz_afioExti = io_afio_read[0];
      end
      default : begin
        _zz_afioExti = io_afio_read[16];
      end
    endcase
  end

  always @(*) begin
    afioExti[0] = _zz_afioExti;
    afioExti[1] = _zz_afioExti_1;
    afioExti[2] = _zz_afioExti_2;
    afioExti[3] = _zz_afioExti_3;
    afioExti[4] = _zz_afioExti_4;
    afioExti[5] = _zz_afioExti_5;
    afioExti[6] = _zz_afioExti_6;
    afioExti[7] = _zz_afioExti_7;
    afioExti[8] = _zz_afioExti_8;
    afioExti[9] = _zz_afioExti_9;
    afioExti[10] = _zz_afioExti_10;
    afioExti[11] = _zz_afioExti_11;
    afioExti[12] = _zz_afioExti_12;
    afioExti[13] = _zz_afioExti_13;
    afioExti[14] = _zz_afioExti_14;
    afioExti[15] = _zz_afioExti_15;
  end

  assign switch_Misc_l245_1 = _zz_switch_Misc_l245_1_1[0:0];
  always @(*) begin
    case(switch_Misc_l245_1)
      1'b0 : begin
        _zz_afioExti_1 = io_afio_read[1];
      end
      default : begin
        _zz_afioExti_1 = io_afio_read[17];
      end
    endcase
  end

  assign switch_Misc_l245_2 = _zz_switch_Misc_l245_2[0:0];
  always @(*) begin
    case(switch_Misc_l245_2)
      1'b0 : begin
        _zz_afioExti_2 = io_afio_read[2];
      end
      default : begin
        _zz_afioExti_2 = io_afio_read[18];
      end
    endcase
  end

  assign switch_Misc_l245_3 = _zz_switch_Misc_l245_3[0:0];
  always @(*) begin
    case(switch_Misc_l245_3)
      1'b0 : begin
        _zz_afioExti_3 = io_afio_read[3];
      end
      default : begin
        _zz_afioExti_3 = io_afio_read[19];
      end
    endcase
  end

  assign switch_Misc_l245_4 = _zz_switch_Misc_l245_4[0:0];
  always @(*) begin
    case(switch_Misc_l245_4)
      1'b0 : begin
        _zz_afioExti_4 = io_afio_read[4];
      end
      default : begin
        _zz_afioExti_4 = io_afio_read[20];
      end
    endcase
  end

  assign switch_Misc_l245_5 = _zz_switch_Misc_l245_5[0:0];
  always @(*) begin
    case(switch_Misc_l245_5)
      1'b0 : begin
        _zz_afioExti_5 = io_afio_read[5];
      end
      default : begin
        _zz_afioExti_5 = io_afio_read[21];
      end
    endcase
  end

  assign switch_Misc_l245_6 = _zz_switch_Misc_l245_6[0:0];
  always @(*) begin
    case(switch_Misc_l245_6)
      1'b0 : begin
        _zz_afioExti_6 = io_afio_read[6];
      end
      default : begin
        _zz_afioExti_6 = io_afio_read[22];
      end
    endcase
  end

  assign switch_Misc_l245_7 = _zz_switch_Misc_l245_7[0:0];
  always @(*) begin
    case(switch_Misc_l245_7)
      1'b0 : begin
        _zz_afioExti_7 = io_afio_read[7];
      end
      default : begin
        _zz_afioExti_7 = io_afio_read[23];
      end
    endcase
  end

  assign switch_Misc_l245_8 = _zz_switch_Misc_l245_8[0:0];
  always @(*) begin
    case(switch_Misc_l245_8)
      1'b0 : begin
        _zz_afioExti_8 = io_afio_read[8];
      end
      default : begin
        _zz_afioExti_8 = io_afio_read[24];
      end
    endcase
  end

  assign switch_Misc_l245_9 = _zz_switch_Misc_l245_9[0:0];
  always @(*) begin
    case(switch_Misc_l245_9)
      1'b0 : begin
        _zz_afioExti_9 = io_afio_read[9];
      end
      default : begin
        _zz_afioExti_9 = io_afio_read[25];
      end
    endcase
  end

  assign switch_Misc_l245_10 = _zz_switch_Misc_l245_10[0:0];
  always @(*) begin
    case(switch_Misc_l245_10)
      1'b0 : begin
        _zz_afioExti_10 = io_afio_read[10];
      end
      default : begin
        _zz_afioExti_10 = io_afio_read[26];
      end
    endcase
  end

  assign switch_Misc_l245_11 = _zz_switch_Misc_l245_11[0:0];
  always @(*) begin
    case(switch_Misc_l245_11)
      1'b0 : begin
        _zz_afioExti_11 = io_afio_read[11];
      end
      default : begin
        _zz_afioExti_11 = io_afio_read[27];
      end
    endcase
  end

  assign switch_Misc_l245_12 = _zz_switch_Misc_l245_12[0:0];
  always @(*) begin
    case(switch_Misc_l245_12)
      1'b0 : begin
        _zz_afioExti_12 = io_afio_read[12];
      end
      default : begin
        _zz_afioExti_12 = io_afio_read[28];
      end
    endcase
  end

  assign switch_Misc_l245_13 = _zz_switch_Misc_l245_13[0:0];
  always @(*) begin
    case(switch_Misc_l245_13)
      1'b0 : begin
        _zz_afioExti_13 = io_afio_read[13];
      end
      default : begin
        _zz_afioExti_13 = io_afio_read[29];
      end
    endcase
  end

  assign switch_Misc_l245_14 = _zz_switch_Misc_l245_14[0:0];
  always @(*) begin
    case(switch_Misc_l245_14)
      1'b0 : begin
        _zz_afioExti_14 = io_afio_read[14];
      end
      default : begin
        _zz_afioExti_14 = io_afio_read[30];
      end
    endcase
  end

  assign switch_Misc_l245_15 = _zz_switch_Misc_l245_15[0:0];
  always @(*) begin
    case(switch_Misc_l245_15)
      1'b0 : begin
        _zz_afioExti_15 = io_afio_read[15];
      end
      default : begin
        _zz_afioExti_15 = io_afio_read[31];
      end
    endcase
  end

  assign io_afioExti = afioExti;
  assign io_afio_write = io_device_read;
  assign io_device_write = io_afio_read;
  assign io_afio_writeEnable = 32'h00000001;
  assign io_device_writeEnable = 32'h00000001;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      EVCR <= 32'h0;
      MAPR <= 32'h0;
      EXTICR_0 <= 32'h0;
      EXTICR_1 <= 32'h0;
      EXTICR_2 <= 32'h0;
      EXTICR_3 <= 32'h0;
      MAPR2 <= 32'h0;
    end else begin
      case(io_apb_PADDR)
        5'h0 : begin
          if(ctrl_doWrite) begin
            EVCR <= io_apb_PWDATA[31 : 0];
          end
        end
        5'h04 : begin
          if(ctrl_doWrite) begin
            MAPR <= io_apb_PWDATA[31 : 0];
          end
        end
        5'h08 : begin
          if(ctrl_doWrite) begin
            EXTICR_0 <= io_apb_PWDATA[31 : 0];
          end
        end
        5'h0c : begin
          if(ctrl_doWrite) begin
            EXTICR_1 <= io_apb_PWDATA[31 : 0];
          end
        end
        5'h10 : begin
          if(ctrl_doWrite) begin
            EXTICR_2 <= io_apb_PWDATA[31 : 0];
          end
        end
        5'h14 : begin
          if(ctrl_doWrite) begin
            EXTICR_3 <= io_apb_PWDATA[31 : 0];
          end
        end
        5'h1c : begin
          if(ctrl_doWrite) begin
            MAPR2 <= io_apb_PWDATA[31 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Axi4SharedToApb3Bridge (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [19:0]   io_axi_arw_payload_addr,
  input  wire [3:0]    io_axi_arw_payload_id,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output reg           io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output reg           io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [3:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output reg           io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire [19:0]   io_apb_PADDR,
  output reg  [0:0]    io_apb_PSEL,
  output reg           io_apb_PENABLE,
  input  wire          io_apb_PREADY,
  output wire          io_apb_PWRITE,
  output wire [31:0]   io_apb_PWDATA,
  input  wire [31:0]   io_apb_PRDATA,
  input  wire          io_apb_PSLVERROR,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);
  localparam Axi4ToApb3BridgePhase_SETUP = 2'd0;
  localparam Axi4ToApb3BridgePhase_ACCESS_1 = 2'd1;
  localparam Axi4ToApb3BridgePhase_RESPONSE = 2'd2;

  reg        [1:0]    phase;
  reg                 write;
  reg        [31:0]   readedData;
  reg        [3:0]    id;
  wire                when_Axi4SharedToApb3Bridge_l91;
  wire                when_Axi4SharedToApb3Bridge_l97;
  `ifndef SYNTHESIS
  reg [63:0] phase_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : phase_string = "SETUP   ";
      Axi4ToApb3BridgePhase_ACCESS_1 : phase_string = "ACCESS_1";
      Axi4ToApb3BridgePhase_RESPONSE : phase_string = "RESPONSE";
      default : phase_string = "????????";
    endcase
  end
  `endif

  always @(*) begin
    io_axi_arw_ready = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        if(when_Axi4SharedToApb3Bridge_l91) begin
          if(when_Axi4SharedToApb3Bridge_l97) begin
            io_axi_arw_ready = 1'b1;
          end
        end
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        if(io_apb_PREADY) begin
          io_axi_arw_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_w_ready = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        if(when_Axi4SharedToApb3Bridge_l91) begin
          if(when_Axi4SharedToApb3Bridge_l97) begin
            io_axi_w_ready = 1'b1;
          end
        end
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        if(io_apb_PREADY) begin
          io_axi_w_ready = write;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_b_valid = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
      end
      default : begin
        if(write) begin
          io_axi_b_valid = 1'b1;
        end
      end
    endcase
  end

  always @(*) begin
    io_axi_r_valid = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
      end
      default : begin
        if(!write) begin
          io_axi_r_valid = 1'b1;
        end
      end
    endcase
  end

  always @(*) begin
    io_apb_PSEL[0] = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        if(when_Axi4SharedToApb3Bridge_l91) begin
          io_apb_PSEL[0] = 1'b1;
          if(when_Axi4SharedToApb3Bridge_l97) begin
            io_apb_PSEL[0] = 1'b0;
          end
        end
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        io_apb_PSEL[0] = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_apb_PENABLE = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        io_apb_PENABLE = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign when_Axi4SharedToApb3Bridge_l91 = (io_axi_arw_valid && ((! io_axi_arw_payload_write) || io_axi_w_valid));
  assign when_Axi4SharedToApb3Bridge_l97 = (io_axi_arw_payload_write && (io_axi_w_payload_strb == 4'b0000));
  assign io_apb_PADDR = io_axi_arw_payload_addr;
  assign io_apb_PWDATA = io_axi_w_payload_data;
  assign io_apb_PWRITE = io_axi_arw_payload_write;
  assign io_axi_r_payload_resp = {io_apb_PSLVERROR,1'b0};
  assign io_axi_b_payload_resp = {io_apb_PSLVERROR,1'b0};
  assign io_axi_r_payload_id = id;
  assign io_axi_b_payload_id = id;
  assign io_axi_r_payload_data = readedData;
  assign io_axi_r_payload_last = 1'b1;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      phase <= Axi4ToApb3BridgePhase_SETUP;
    end else begin
      case(phase)
        Axi4ToApb3BridgePhase_SETUP : begin
          if(when_Axi4SharedToApb3Bridge_l91) begin
            phase <= Axi4ToApb3BridgePhase_ACCESS_1;
            if(when_Axi4SharedToApb3Bridge_l97) begin
              phase <= Axi4ToApb3BridgePhase_RESPONSE;
            end
          end
        end
        Axi4ToApb3BridgePhase_ACCESS_1 : begin
          if(io_apb_PREADY) begin
            phase <= Axi4ToApb3BridgePhase_RESPONSE;
          end
        end
        default : begin
          if(write) begin
            if(io_axi_b_ready) begin
              phase <= Axi4ToApb3BridgePhase_SETUP;
            end
          end else begin
            if(io_axi_r_ready) begin
              phase <= Axi4ToApb3BridgePhase_SETUP;
            end
          end
        end
      endcase
    end
  end

  always @(posedge clkout) begin
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        write <= io_axi_arw_payload_write;
        id <= io_axi_arw_payload_id;
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        if(io_apb_PREADY) begin
          readedData <= io_apb_PRDATA;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module Axi4Ddr (
  input  wire          resetCtrl_axiReset,
  input  wire          clkout,
  input  wire          clkout_1,
  input  wire          io_pll_lock,
  input  wire          io_axi_arw_valid,
  output wire          io_axi_arw_ready,
  input  wire [27:0]   io_axi_arw_payload_addr,
  input  wire [3:0]    io_axi_arw_payload_id,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [3:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire [13:0]   io_ddr_iface_O_ddr_addr,
  output wire [2:0]    io_ddr_iface_O_ddr_ba,
  output wire          io_ddr_iface_O_ddr_cs_n,
  output wire          io_ddr_iface_O_ddr_ras_n,
  output wire          io_ddr_iface_O_ddr_cas_n,
  output wire          io_ddr_iface_O_ddr_we_n,
  output wire          io_ddr_iface_O_ddr_clk,
  output wire          io_ddr_iface_O_ddr_clk_n,
  output wire          io_ddr_iface_O_ddr_cke,
  output wire          io_ddr_iface_O_ddr_odt,
  output wire          io_ddr_iface_O_ddr_reset_n,
  output wire [1:0]    io_ddr_iface_O_ddr_dqm,
  inout  wire [15:0]   io_ddr_iface_IO_ddr_dq,
  inout  wire [1:0]    io_ddr_iface_IO_ddr_dqs,
  inout  wire [1:0]    io_ddr_iface_IO_ddr_dqs_n,
  output wire          io_init_calib_complete
);

  wire                gowin_DDR3_rst_n;
  wire                gowin_DDR3_cmd_ready;
  wire                gowin_DDR3_wr_data_rdy;
  wire       [127:0]  gowin_DDR3_rd_data;
  wire                gowin_DDR3_rd_data_valid;
  wire                gowin_DDR3_rd_data_end;
  wire                gowin_DDR3_sr_ack;
  wire                gowin_DDR3_ref_ack;
  wire                gowin_DDR3_init_calib_complete;
  wire                gowin_DDR3_clk_out;
  wire                gowin_DDR3_ddr_rst;
  wire       [13:0]   gowin_DDR3_O_ddr_addr;
  wire       [2:0]    gowin_DDR3_O_ddr_ba;
  wire                gowin_DDR3_O_ddr_cs_n;
  wire                gowin_DDR3_O_ddr_ras_n;
  wire                gowin_DDR3_O_ddr_cas_n;
  wire                gowin_DDR3_O_ddr_we_n;
  wire                gowin_DDR3_O_ddr_clk;
  wire                gowin_DDR3_O_ddr_clk_n;
  wire                gowin_DDR3_O_ddr_cke;
  wire                gowin_DDR3_O_ddr_odt;
  wire                gowin_DDR3_O_ddr_reset_n;
  wire       [1:0]    gowin_DDR3_O_ddr_dqm;
  wire                axiController_io_axi_arw_ready;
  wire                axiController_io_axi_w_ready;
  wire                axiController_io_axi_b_valid;
  wire       [3:0]    axiController_io_axi_b_payload_id;
  wire       [1:0]    axiController_io_axi_b_payload_resp;
  wire                axiController_io_axi_r_valid;
  wire       [31:0]   axiController_io_axi_r_payload_data;
  wire       [3:0]    axiController_io_axi_r_payload_id;
  wire       [1:0]    axiController_io_axi_r_payload_resp;
  wire                axiController_io_axi_r_payload_last;
  wire       [5:0]    axiController_io_app_burst_number;
  wire       [2:0]    axiController_io_cmd;
  wire                axiController_io_cmd_en;
  wire       [27:0]   axiController_io_addr;
  wire       [127:0]  axiController_io_wr_data;
  wire                axiController_io_wr_data_en;
  wire       [15:0]   axiController_io_wr_data_mask;

  DDR3_Memory_Interface_Top gowin_DDR3 (
    .memory_clk          (clkout_1                              ), //i
    .clk                 (clkout                                ), //i
    .pll_lock            (io_pll_lock                           ), //i
    .rst_n               (gowin_DDR3_rst_n                      ), //i
    .app_burst_number    (axiController_io_app_burst_number[5:0]), //i
    .cmd_ready           (gowin_DDR3_cmd_ready                  ), //o
    .cmd                 (axiController_io_cmd[2:0]             ), //i
    .cmd_en              (axiController_io_cmd_en               ), //i
    .addr                (axiController_io_addr[27:0]           ), //i
    .wr_data_rdy         (gowin_DDR3_wr_data_rdy                ), //o
    .wr_data             (axiController_io_wr_data[127:0]       ), //i
    .wr_data_en          (axiController_io_wr_data_en           ), //i
    .wr_data_end         (axiController_io_wr_data_en           ), //i
    .wr_data_mask        (axiController_io_wr_data_mask[15:0]   ), //i
    .rd_data             (gowin_DDR3_rd_data[127:0]             ), //o
    .rd_data_valid       (gowin_DDR3_rd_data_valid              ), //o
    .rd_data_end         (gowin_DDR3_rd_data_end                ), //o
    .sr_req              (1'b0                                  ), //i
    .ref_req             (1'b0                                  ), //i
    .sr_ack              (gowin_DDR3_sr_ack                     ), //o
    .ref_ack             (gowin_DDR3_ref_ack                    ), //o
    .init_calib_complete (gowin_DDR3_init_calib_complete        ), //o
    .clk_out             (gowin_DDR3_clk_out                    ), //o
    .ddr_rst             (gowin_DDR3_ddr_rst                    ), //o
    .burst               (1'b1                                  ), //i
    .O_ddr_addr          (gowin_DDR3_O_ddr_addr[13:0]           ), //o
    .O_ddr_ba            (gowin_DDR3_O_ddr_ba[2:0]              ), //o
    .O_ddr_cs_n          (gowin_DDR3_O_ddr_cs_n                 ), //o
    .O_ddr_ras_n         (gowin_DDR3_O_ddr_ras_n                ), //o
    .O_ddr_cas_n         (gowin_DDR3_O_ddr_cas_n                ), //o
    .O_ddr_we_n          (gowin_DDR3_O_ddr_we_n                 ), //o
    .O_ddr_clk           (gowin_DDR3_O_ddr_clk                  ), //o
    .O_ddr_clk_n         (gowin_DDR3_O_ddr_clk_n                ), //o
    .O_ddr_cke           (gowin_DDR3_O_ddr_cke                  ), //o
    .O_ddr_odt           (gowin_DDR3_O_ddr_odt                  ), //o
    .O_ddr_reset_n       (gowin_DDR3_O_ddr_reset_n              ), //o
    .O_ddr_dqm           (gowin_DDR3_O_ddr_dqm[1:0]             ), //o
    .IO_ddr_dq           (io_ddr_iface_IO_ddr_dq                ), //~
    .IO_ddr_dqs          (io_ddr_iface_IO_ddr_dqs               ), //~
    .IO_ddr_dqs_n        (io_ddr_iface_IO_ddr_dqs_n             )  //~
  );
  Axi4DdrControllerWithCache axiController (
    .io_axi_arw_valid         (io_axi_arw_valid                         ), //i
    .io_axi_arw_ready         (axiController_io_axi_arw_ready           ), //o
    .io_axi_arw_payload_addr  (io_axi_arw_payload_addr[27:0]            ), //i
    .io_axi_arw_payload_id    (io_axi_arw_payload_id[3:0]               ), //i
    .io_axi_arw_payload_len   (io_axi_arw_payload_len[7:0]              ), //i
    .io_axi_arw_payload_size  (io_axi_arw_payload_size[2:0]             ), //i
    .io_axi_arw_payload_burst (io_axi_arw_payload_burst[1:0]            ), //i
    .io_axi_arw_payload_write (io_axi_arw_payload_write                 ), //i
    .io_axi_w_valid           (io_axi_w_valid                           ), //i
    .io_axi_w_ready           (axiController_io_axi_w_ready             ), //o
    .io_axi_w_payload_data    (io_axi_w_payload_data[31:0]              ), //i
    .io_axi_w_payload_strb    (io_axi_w_payload_strb[3:0]               ), //i
    .io_axi_w_payload_last    (io_axi_w_payload_last                    ), //i
    .io_axi_b_valid           (axiController_io_axi_b_valid             ), //o
    .io_axi_b_ready           (io_axi_b_ready                           ), //i
    .io_axi_b_payload_id      (axiController_io_axi_b_payload_id[3:0]   ), //o
    .io_axi_b_payload_resp    (axiController_io_axi_b_payload_resp[1:0] ), //o
    .io_axi_r_valid           (axiController_io_axi_r_valid             ), //o
    .io_axi_r_ready           (io_axi_r_ready                           ), //i
    .io_axi_r_payload_data    (axiController_io_axi_r_payload_data[31:0]), //o
    .io_axi_r_payload_id      (axiController_io_axi_r_payload_id[3:0]   ), //o
    .io_axi_r_payload_resp    (axiController_io_axi_r_payload_resp[1:0] ), //o
    .io_axi_r_payload_last    (axiController_io_axi_r_payload_last      ), //o
    .io_app_burst_number      (axiController_io_app_burst_number[5:0]   ), //o
    .io_cmd_ready             (gowin_DDR3_cmd_ready                     ), //i
    .io_cmd                   (axiController_io_cmd[2:0]                ), //o
    .io_cmd_en                (axiController_io_cmd_en                  ), //o
    .io_addr                  (axiController_io_addr[27:0]              ), //o
    .io_wr_data_rdy           (gowin_DDR3_wr_data_rdy                   ), //i
    .io_wr_data               (axiController_io_wr_data[127:0]          ), //o
    .io_wr_data_en            (axiController_io_wr_data_en              ), //o
    .io_wr_data_mask          (axiController_io_wr_data_mask[15:0]      ), //o
    .io_rd_data               (gowin_DDR3_rd_data[127:0]                ), //i
    .io_rd_data_valid         (gowin_DDR3_rd_data_valid                 ), //i
    .io_init_calib_complete   (gowin_DDR3_init_calib_complete           ), //i
    .clkout                   (clkout                                   ), //i
    .resetCtrl_axiReset       (resetCtrl_axiReset                       ), //i
    .clk_out                  (gowin_DDR3_clk_out                       ), //i
    .ddr_rst                  (gowin_DDR3_ddr_rst                       )  //i
  );
  assign gowin_DDR3_rst_n = (! resetCtrl_axiReset);
  assign io_init_calib_complete = gowin_DDR3_init_calib_complete;
  assign io_axi_arw_ready = axiController_io_axi_arw_ready;
  assign io_axi_w_ready = axiController_io_axi_w_ready;
  assign io_axi_b_valid = axiController_io_axi_b_valid;
  assign io_axi_b_payload_id = axiController_io_axi_b_payload_id;
  assign io_axi_b_payload_resp = axiController_io_axi_b_payload_resp;
  assign io_axi_r_valid = axiController_io_axi_r_valid;
  assign io_axi_r_payload_data = axiController_io_axi_r_payload_data;
  assign io_axi_r_payload_id = axiController_io_axi_r_payload_id;
  assign io_axi_r_payload_resp = axiController_io_axi_r_payload_resp;
  assign io_axi_r_payload_last = axiController_io_axi_r_payload_last;
  assign io_ddr_iface_O_ddr_addr = gowin_DDR3_O_ddr_addr;
  assign io_ddr_iface_O_ddr_ba = gowin_DDR3_O_ddr_ba;
  assign io_ddr_iface_O_ddr_cs_n = gowin_DDR3_O_ddr_cs_n;
  assign io_ddr_iface_O_ddr_ras_n = gowin_DDR3_O_ddr_ras_n;
  assign io_ddr_iface_O_ddr_cas_n = gowin_DDR3_O_ddr_cas_n;
  assign io_ddr_iface_O_ddr_we_n = gowin_DDR3_O_ddr_we_n;
  assign io_ddr_iface_O_ddr_clk = gowin_DDR3_O_ddr_clk;
  assign io_ddr_iface_O_ddr_clk_n = gowin_DDR3_O_ddr_clk_n;
  assign io_ddr_iface_O_ddr_cke = gowin_DDR3_O_ddr_cke;
  assign io_ddr_iface_O_ddr_odt = gowin_DDR3_O_ddr_odt;
  assign io_ddr_iface_O_ddr_reset_n = gowin_DDR3_O_ddr_reset_n;
  assign io_ddr_iface_O_ddr_dqm = gowin_DDR3_O_ddr_dqm;

endmodule

module Axi4Ram (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [14:0]   io_axi_arw_payload_addr,
  input  wire [3:0]    io_axi_arw_payload_id,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [3:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg        [31:0]   ram_spinal_port0;
  wire       [1:0]    _zz_Axi4Incr_alignMask;
  wire       [11:0]   _zz_Axi4Incr_baseIncr;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_1;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_2;
  reg        [11:0]   _zz_Axi4Incr_result;
  wire       [10:0]   _zz_Axi4Incr_result_1;
  wire       [0:0]    _zz_Axi4Incr_result_2;
  wire       [9:0]    _zz_Axi4Incr_result_3;
  wire       [1:0]    _zz_Axi4Incr_result_4;
  wire       [8:0]    _zz_Axi4Incr_result_5;
  wire       [2:0]    _zz_Axi4Incr_result_6;
  wire       [7:0]    _zz_Axi4Incr_result_7;
  wire       [3:0]    _zz_Axi4Incr_result_8;
  wire       [6:0]    _zz_Axi4Incr_result_9;
  wire       [4:0]    _zz_Axi4Incr_result_10;
  wire       [5:0]    _zz_Axi4Incr_result_11;
  wire       [5:0]    _zz_Axi4Incr_result_12;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [14:0]   unburstify_result_payload_fragment_addr;
  reg        [3:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [14:0]   unburstify_buffer_transaction_addr;
  reg        [3:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [14:0]   Axi4Incr_result;
  wire       [2:0]    Axi4Incr_highCat;
  wire       [2:0]    Axi4Incr_sizeValue;
  wire       [11:0]   Axi4Incr_alignMask;
  wire       [11:0]   Axi4Incr_base;
  wire       [11:0]   Axi4Incr_baseIncr;
  reg        [1:0]    _zz_Axi4Incr_wrapCase;
  wire       [2:0]    Axi4Incr_wrapCase;
  wire                when_Axi4Channel_l323;
  wire                _zz_unburstify_result_ready;
  wire                stage0_valid;
  reg                 stage0_ready;
  wire                stage0_payload_last;
  wire       [14:0]   stage0_payload_fragment_addr;
  wire       [3:0]    stage0_payload_fragment_id;
  wire       [2:0]    stage0_payload_fragment_size;
  wire       [1:0]    stage0_payload_fragment_burst;
  wire                stage0_payload_fragment_write;
  wire       [12:0]   _zz_io_axi_r_payload_data;
  wire                stage0_fire;
  wire       [31:0]   _zz_io_axi_r_payload_data_1;
  wire                stage1_valid;
  wire                stage1_ready;
  wire                stage1_payload_last;
  wire       [14:0]   stage1_payload_fragment_addr;
  wire       [3:0]    stage1_payload_fragment_id;
  wire       [2:0]    stage1_payload_fragment_size;
  wire       [1:0]    stage1_payload_fragment_burst;
  wire                stage1_payload_fragment_write;
  reg                 stage0_rValid;
  reg                 stage0_rData_last;
  reg        [14:0]   stage0_rData_fragment_addr;
  reg        [3:0]    stage0_rData_fragment_id;
  reg        [2:0]    stage0_rData_fragment_size;
  reg        [1:0]    stage0_rData_fragment_burst;
  reg                 stage0_rData_fragment_write;
  wire                when_Stream_l399;
  reg [7:0] ram_symbol0 [0:8191];
  reg [7:0] ram_symbol1 [0:8191];
  reg [7:0] ram_symbol2 [0:8191];
  reg [7:0] ram_symbol3 [0:8191];
  reg [7:0] _zz_ramsymbol_read;
  reg [7:0] _zz_ramsymbol_read_1;
  reg [7:0] _zz_ramsymbol_read_2;
  reg [7:0] _zz_ramsymbol_read_3;

  assign _zz_Axi4Incr_alignMask = {(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)};
  assign _zz_Axi4Incr_baseIncr = {9'd0, Axi4Incr_sizeValue};
  assign _zz_Axi4Incr_wrapCase_1 = {1'd0, Axi4Incr_validSize};
  assign _zz_Axi4Incr_wrapCase_2 = {1'd0, _zz_Axi4Incr_wrapCase};
  assign _zz_Axi4Incr_result_1 = Axi4Incr_base[11 : 1];
  assign _zz_Axi4Incr_result_2 = Axi4Incr_baseIncr[0 : 0];
  assign _zz_Axi4Incr_result_3 = Axi4Incr_base[11 : 2];
  assign _zz_Axi4Incr_result_4 = Axi4Incr_baseIncr[1 : 0];
  assign _zz_Axi4Incr_result_5 = Axi4Incr_base[11 : 3];
  assign _zz_Axi4Incr_result_6 = Axi4Incr_baseIncr[2 : 0];
  assign _zz_Axi4Incr_result_7 = Axi4Incr_base[11 : 4];
  assign _zz_Axi4Incr_result_8 = Axi4Incr_baseIncr[3 : 0];
  assign _zz_Axi4Incr_result_9 = Axi4Incr_base[11 : 5];
  assign _zz_Axi4Incr_result_10 = Axi4Incr_baseIncr[4 : 0];
  assign _zz_Axi4Incr_result_11 = Axi4Incr_base[11 : 6];
  assign _zz_Axi4Incr_result_12 = Axi4Incr_baseIncr[5 : 0];
  initial begin
    $readmemb("G:/VM/share/OpenPeriph/test/cyberwithddr/build/mem/demo1.bin",ram_symbol0);
    $readmemb("G:/VM/share/OpenPeriph/test/cyberwithddr/build/mem/demo2.bin",ram_symbol1);
    $readmemb("G:/VM/share/OpenPeriph/test/cyberwithddr/build/mem/demo3.bin",ram_symbol2);
    $readmemb("G:/VM/share/OpenPeriph/test/cyberwithddr/build/mem/demo4.bin",ram_symbol3);
  end
  always @(*) begin
    ram_spinal_port0 = {_zz_ramsymbol_read_3, _zz_ramsymbol_read_2, _zz_ramsymbol_read_1, _zz_ramsymbol_read};
  end
  always @(posedge clkout) begin
    if(stage0_fire) begin
      _zz_ramsymbol_read <= ram_symbol0[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_1 <= ram_symbol1[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_2 <= ram_symbol2[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_3 <= ram_symbol3[_zz_io_axi_r_payload_data];
    end
  end

  always @(posedge clkout) begin
    if(io_axi_w_payload_strb[0] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol0[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[7 : 0];
    end
    if(io_axi_w_payload_strb[1] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol1[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[15 : 8];
    end
    if(io_axi_w_payload_strb[2] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol2[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[23 : 16];
    end
    if(io_axi_w_payload_strb[3] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol3[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[31 : 24];
    end
  end

  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_1,_zz_Axi4Incr_result_2};
      3'b001 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_3,_zz_Axi4Incr_result_4};
      3'b010 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_5,_zz_Axi4Incr_result_6};
      3'b011 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_7,_zz_Axi4Incr_result_8};
      3'b100 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_9,_zz_Axi4Incr_result_10};
      default : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_11,_zz_Axi4Incr_result_12};
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[14 : 12];
  assign Axi4Incr_sizeValue = {(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_Axi4Incr_alignMask};
  assign Axi4Incr_base = (unburstify_buffer_transaction_addr[11 : 0] & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_Axi4Incr_baseIncr);
  always @(*) begin
    casez(unburstify_buffer_len)
      8'b????1??? : begin
        _zz_Axi4Incr_wrapCase = 2'b11;
      end
      8'b????01?? : begin
        _zz_Axi4Incr_wrapCase = 2'b10;
      end
      8'b????001? : begin
        _zz_Axi4Incr_wrapCase = 2'b01;
      end
      default : begin
        _zz_Axi4Incr_wrapCase = 2'b00;
      end
    endcase
  end

  assign Axi4Incr_wrapCase = (_zz_Axi4Incr_wrapCase_1 + _zz_Axi4Incr_wrapCase_2);
  always @(*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        Axi4Incr_result = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        Axi4Incr_result = {Axi4Incr_highCat,_zz_Axi4Incr_result};
      end
      default : begin
        Axi4Incr_result = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @(*) begin
    io_axi_arw_ready = 1'b0;
    if(!unburstify_buffer_valid) begin
      io_axi_arw_ready = unburstify_result_ready;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_valid = 1'b1;
    end else begin
      unburstify_result_valid = io_axi_arw_valid;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_last = unburstify_buffer_last;
    end else begin
      unburstify_result_payload_last = 1'b1;
      if(when_Axi4Channel_l323) begin
        unburstify_result_payload_last = 1'b0;
      end
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      unburstify_result_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      unburstify_result_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      unburstify_result_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      unburstify_result_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_addr = Axi4Incr_result;
    end else begin
      unburstify_result_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign when_Axi4Channel_l323 = (io_axi_arw_payload_len != 8'h0);
  assign _zz_unburstify_result_ready = (! (unburstify_result_payload_fragment_write && (! io_axi_w_valid)));
  assign stage0_valid = (unburstify_result_valid && _zz_unburstify_result_ready);
  assign unburstify_result_ready = (stage0_ready && _zz_unburstify_result_ready);
  assign stage0_payload_last = unburstify_result_payload_last;
  assign stage0_payload_fragment_addr = unburstify_result_payload_fragment_addr;
  assign stage0_payload_fragment_id = unburstify_result_payload_fragment_id;
  assign stage0_payload_fragment_size = unburstify_result_payload_fragment_size;
  assign stage0_payload_fragment_burst = unburstify_result_payload_fragment_burst;
  assign stage0_payload_fragment_write = unburstify_result_payload_fragment_write;
  assign _zz_io_axi_r_payload_data = stage0_payload_fragment_addr[14 : 2];
  assign stage0_fire = (stage0_valid && stage0_ready);
  assign _zz_io_axi_r_payload_data_1 = io_axi_w_payload_data;
  assign io_axi_r_payload_data = ram_spinal_port0;
  assign io_axi_w_ready = ((unburstify_result_valid && unburstify_result_payload_fragment_write) && stage0_ready);
  always @(*) begin
    stage0_ready = stage1_ready;
    if(when_Stream_l399) begin
      stage0_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! stage1_valid);
  assign stage1_valid = stage0_rValid;
  assign stage1_payload_last = stage0_rData_last;
  assign stage1_payload_fragment_addr = stage0_rData_fragment_addr;
  assign stage1_payload_fragment_id = stage0_rData_fragment_id;
  assign stage1_payload_fragment_size = stage0_rData_fragment_size;
  assign stage1_payload_fragment_burst = stage0_rData_fragment_burst;
  assign stage1_payload_fragment_write = stage0_rData_fragment_write;
  assign stage1_ready = ((io_axi_r_ready && (! stage1_payload_fragment_write)) || ((io_axi_b_ready || (! stage1_payload_last)) && stage1_payload_fragment_write));
  assign io_axi_r_valid = (stage1_valid && (! stage1_payload_fragment_write));
  assign io_axi_r_payload_id = stage1_payload_fragment_id;
  assign io_axi_r_payload_last = stage1_payload_last;
  assign io_axi_r_payload_resp = 2'b00;
  assign io_axi_b_valid = ((stage1_valid && stage1_payload_fragment_write) && stage1_payload_last);
  assign io_axi_b_payload_resp = 2'b00;
  assign io_axi_b_payload_id = stage1_payload_fragment_id;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      unburstify_buffer_valid <= 1'b0;
      stage0_rValid <= 1'b0;
    end else begin
      if(unburstify_result_ready) begin
        if(unburstify_buffer_last) begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(!unburstify_buffer_valid) begin
        if(when_Axi4Channel_l323) begin
          if(unburstify_result_ready) begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(stage0_ready) begin
        stage0_rValid <= stage0_valid;
      end
    end
  end

  always @(posedge clkout) begin
    if(unburstify_result_ready) begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[11 : 0] <= Axi4Incr_result[11 : 0];
    end
    if(!unburstify_buffer_valid) begin
      if(when_Axi4Channel_l323) begin
        if(unburstify_result_ready) begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(stage0_ready) begin
      stage0_rData_last <= stage0_payload_last;
      stage0_rData_fragment_addr <= stage0_payload_fragment_addr;
      stage0_rData_fragment_id <= stage0_payload_fragment_id;
      stage0_rData_fragment_size <= stage0_payload_fragment_size;
      stage0_rData_fragment_burst <= stage0_payload_fragment_burst;
      stage0_rData_fragment_write <= stage0_payload_fragment_write;
    end
  end


endmodule

module RiscvAxi4 (
  output wire          io_i_ar_valid,
  input  wire          io_i_ar_ready,
  output wire [31:0]   io_i_ar_payload_addr,
  output wire [3:0]    io_i_ar_payload_cache,
  output wire [2:0]    io_i_ar_payload_prot,
  input  wire          io_i_r_valid,
  output wire          io_i_r_ready,
  input  wire [31:0]   io_i_r_payload_data,
  input  wire          io_i_r_payload_last,
  output wire          io_d_arw_valid,
  input  wire          io_d_arw_ready,
  output wire [31:0]   io_d_arw_payload_addr,
  output wire [2:0]    io_d_arw_payload_size,
  output wire [3:0]    io_d_arw_payload_cache,
  output wire [2:0]    io_d_arw_payload_prot,
  output wire          io_d_arw_payload_write,
  output wire          io_d_w_valid,
  input  wire          io_d_w_ready,
  output wire [31:0]   io_d_w_payload_data,
  output wire [3:0]    io_d_w_payload_strb,
  output wire          io_d_w_payload_last,
  input  wire          io_d_b_valid,
  output wire          io_d_b_ready,
  input  wire          io_d_r_valid,
  output wire          io_d_r_ready,
  input  wire [31:0]   io_d_r_payload_data,
  input  wire          io_d_r_payload_last,
  input  wire [3:0]    io_interrupt,
  input  wire          io_debugResetIn,
  output wire          io_debugResetOut,
  input  wire [11:0]   io_debugBus_PADDR,
  input  wire [0:0]    io_debugBus_PSEL,
  input  wire          io_debugBus_PENABLE,
  output wire          io_debugBus_PREADY,
  input  wire          io_debugBus_PWRITE,
  input  wire [31:0]   io_debugBus_PWDATA,
  output wire [31:0]   io_debugBus_PRDATA,
  output wire          io_debugBus_PSLVERROR,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  wire                core_io_interrupt_1;
  wire                core_io_interrupt_0;
  wire                core_io_interrupt_3;
  wire                core_io_interrupt_2;
  wire                core_io_i_branchCachePort_cmd_valid;
  wire       [6:0]    core_io_i_branchCachePort_cmd_payload;
  wire       [31:0]   core_io_i_rsp_payload_instruction;
  wire       [31:0]   core_io_i_rsp_payload_pc;
  wire       [22:0]   core_io_i_rsp_payload_branchCacheLine_pc;
  wire       [1:0]    core_io_i_rsp_payload_branchCacheLine_history;
  wire                core__zz_9;
  wire       [7:0]    core__zz_decode_regFileReadAddress0;
  wire                core_io_i_cmd_valid;
  wire       [31:0]   core_io_i_cmd_payload_pc;
  wire       [22:0]   core_io_i_branchCachePort_rsp_pc;
  wire       [1:0]    core_io_i_branchCachePort_rsp_history;
  wire                core_io_i_rsp_ready;
  wire                core_io_d_cmd_valid;
  wire                core_io_d_cmd_payload_wr;
  wire       [31:0]   core_io_d_cmd_payload_address;
  wire       [31:0]   core_io_d_cmd_payload_data;
  wire       [1:0]    core_io_d_cmd_payload_size;
  wire                core_io_d_rsp_ready;
  wire       [31:0]   core__zz_io_debugBus_PRDATA;
  wire                core__zz_io_debugResetOut;
  wire       [9:0]    _zz__zz_decode_regFileReadAddress0;
  wire       [29:0]   _zz_io_i_branchCachePort_cmd_payload;
  wire       [6:0]    _zz_dBridge_mm_w_payload_strb_1;
  wire                _zz_io_i_branchCachePort_cmd_valid;
  wire                _zz_io_i_cmd_ready;
  wire       [31:0]   _zz_io_i_ar_payload_addr;
  wire                _zz_io_i_rsp_valid;
  wire                _zz_io_i_ar_valid;
  wire                _zz_io_i_ar_valid_1;
  wire                _zz_io_i_cmd_ready_1;
  wire                _zz_io_i_ar_valid_2;
  reg                 _zz_io_i_ar_valid_3;
  wire                _zz_io_i_ar_valid_4;
  wire                _zz_io_i_rsp_valid_1;
  wire       [31:0]   _zz_io_i_rsp_payload_instruction;
  wire       [31:0]   _zz_io_i_rsp_payload_pc;
  wire       [22:0]   _zz_io_i_rsp_payload_branchCacheLine_pc;
  wire       [1:0]    _zz_io_i_rsp_payload_branchCacheLine_history;
  reg        [31:0]   _zz_io_i_rsp_payload_pc_1;
  reg                 _zz_io_i_rsp_payload_instruction_1;
  reg        [31:0]   _zz_io_i_rsp_payload_instruction_2;
  reg        [31:0]   _zz_io_i_rsp_payload_pc_2;
  reg        [22:0]   _zz_io_i_rsp_payload_branchCacheLine_pc_1;
  reg        [1:0]    _zz_io_i_rsp_payload_branchCacheLine_history_1;
  reg                 _zz_core_io_d_cmd_s2mPipe_ready;
  wire                _zz_dBridge_contextOut_ready;
  reg        [31:0]   _zz_io_d_rsp_payload;
  wire                core_io_d_cmd_s2mPipe_valid;
  wire                core_io_d_cmd_s2mPipe_ready;
  wire                core_io_d_cmd_s2mPipe_payload_wr;
  wire       [31:0]   core_io_d_cmd_s2mPipe_payload_address;
  wire       [31:0]   core_io_d_cmd_s2mPipe_payload_data;
  wire       [1:0]    core_io_d_cmd_s2mPipe_payload_size;
  reg                 core_io_d_cmd_rValidN;
  reg                 core_io_d_cmd_rData_wr;
  reg        [31:0]   core_io_d_cmd_rData_address;
  reg        [31:0]   core_io_d_cmd_rData_data;
  reg        [1:0]    core_io_d_cmd_rData_size;
  wire                dBridge_mm_arw_valid;
  wire                dBridge_mm_arw_ready;
  wire       [31:0]   dBridge_mm_arw_payload_addr;
  wire       [2:0]    dBridge_mm_arw_payload_size;
  wire       [3:0]    dBridge_mm_arw_payload_cache;
  wire       [2:0]    dBridge_mm_arw_payload_prot;
  wire                dBridge_mm_arw_payload_write;
  wire                dBridge_mm_w_valid;
  wire                dBridge_mm_w_ready;
  wire       [31:0]   dBridge_mm_w_payload_data;
  wire       [3:0]    dBridge_mm_w_payload_strb;
  wire                dBridge_mm_w_payload_last;
  wire                dBridge_mm_b_valid;
  wire                dBridge_mm_b_ready;
  wire                dBridge_mm_r_valid;
  wire                dBridge_mm_r_ready;
  wire       [31:0]   dBridge_mm_r_payload_data;
  wire                dBridge_mm_r_payload_last;
  wire                dBridge_mm_arw_fire;
  wire                dBridge_mm_r_fire;
  wire                dBridge_mm_b_fire;
  wire                when_Utils_l719;
  reg                 dBridge_pendingCmd_incrementIt;
  reg                 dBridge_pendingCmd_decrementIt;
  wire       [2:0]    dBridge_pendingCmd_valueNext;
  reg        [2:0]    dBridge_pendingCmd_value;
  wire                dBridge_pendingCmd_mayOverflow;
  wire                dBridge_pendingCmd_mayUnderflow;
  wire                dBridge_pendingCmd_willOverflowIfInc;
  wire                dBridge_pendingCmd_willOverflow;
  wire                dBridge_pendingCmd_willUnderflowIfDec;
  wire                dBridge_pendingCmd_willUnderflow;
  reg        [2:0]    dBridge_pendingCmd_finalIncrement;
  wire                when_Utils_l751;
  wire                when_Utils_l753;
  reg                 dBridge_pendingIsWrite;
  wire                dBridge_cmdPreFork_valid;
  wire                dBridge_cmdPreFork_ready;
  wire                dBridge_cmdPreFork_payload_wr;
  wire       [31:0]   dBridge_cmdPreFork_payload_address;
  wire       [31:0]   dBridge_cmdPreFork_payload_data;
  wire       [1:0]    dBridge_cmdPreFork_payload_size;
  reg                 _zz_dBridge_cmdPreFork_valid;
  reg                 _zz_dBridge_cmdPreFork_payload_wr;
  reg        [31:0]   _zz_dBridge_cmdPreFork_payload_address;
  reg        [31:0]   _zz_dBridge_cmdPreFork_payload_data;
  reg        [1:0]    _zz_dBridge_cmdPreFork_payload_size;
  wire                when_Stream_l399;
  wire                _zz_dBridge_cmdPreFork_ready;
  wire                dBridge_cmdPreFork_haltWhen_valid;
  reg                 dBridge_cmdPreFork_haltWhen_ready;
  wire                dBridge_cmdPreFork_haltWhen_payload_wr;
  wire       [31:0]   dBridge_cmdPreFork_haltWhen_payload_address;
  wire       [31:0]   dBridge_cmdPreFork_haltWhen_payload_data;
  wire       [1:0]    dBridge_cmdPreFork_haltWhen_payload_size;
  wire                dBridge_cmdFork_valid;
  wire                dBridge_cmdFork_ready;
  wire                dBridge_cmdFork_payload_wr;
  wire       [31:0]   dBridge_cmdFork_payload_address;
  wire       [31:0]   dBridge_cmdFork_payload_data;
  wire       [1:0]    dBridge_cmdFork_payload_size;
  wire                dBridge_dataFork_valid;
  reg                 dBridge_dataFork_ready;
  wire                dBridge_dataFork_payload_wr;
  wire       [31:0]   dBridge_dataFork_payload_address;
  wire       [31:0]   dBridge_dataFork_payload_data;
  wire       [1:0]    dBridge_dataFork_payload_size;
  reg                 dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_0;
  reg                 dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_1;
  wire                when_Stream_l1119;
  wire                when_Stream_l1119_1;
  wire                dBridge_cmdFork_fire;
  wire                dBridge_dataFork_fire;
  wire                when_Stream_l486;
  reg                 dBridge_dataStage_valid;
  wire                dBridge_dataStage_ready;
  wire                dBridge_dataStage_payload_wr;
  wire       [31:0]   dBridge_dataStage_payload_address;
  wire       [31:0]   dBridge_dataStage_payload_data;
  wire       [1:0]    dBridge_dataStage_payload_size;
  reg        [31:0]   _zz_dBridge_mm_w_payload_data;
  reg        [3:0]    _zz_dBridge_mm_w_payload_strb;
  wire                dBridge_contextIn_valid;
  reg                 dBridge_contextIn_ready;
  wire       [1:0]    dBridge_contextIn_payload;
  wire                dBridge_contextIn_m2sPipe_valid;
  wire                dBridge_contextIn_m2sPipe_ready;
  wire       [1:0]    dBridge_contextIn_m2sPipe_payload;
  reg                 dBridge_contextIn_rValid;
  reg        [1:0]    dBridge_contextIn_rData;
  wire                when_Stream_l399_1;
  wire                dBridge_contextOut_valid;
  wire                dBridge_contextOut_ready;
  wire       [1:0]    dBridge_contextOut_payload;
  reg                 dBridge_contextIn_m2sPipe_rValidN;
  reg        [1:0]    dBridge_contextIn_m2sPipe_rData;

  assign _zz__zz_decode_regFileReadAddress0 = (io_debugBus_PADDR >>> 2'd2);
  assign _zz_io_i_branchCachePort_cmd_payload = (_zz_io_i_ar_payload_addr >>> 2'd2);
  assign _zz_dBridge_mm_w_payload_strb_1 = ({3'd0,_zz_dBridge_mm_w_payload_strb} <<< dBridge_dataStage_payload_address[1 : 0]);
  RiscvCore core (
    .io_interrupt_1                           (core_io_interrupt_1                               ), //i
    .io_interrupt_0                           (core_io_interrupt_0                               ), //i
    .io_interrupt_3                           (core_io_interrupt_3                               ), //i
    .io_interrupt_2                           (core_io_interrupt_2                               ), //i
    .io_i_cmd_valid                           (core_io_i_cmd_valid                               ), //o
    .io_i_cmd_ready                           (_zz_io_i_cmd_ready                                ), //i
    .io_i_cmd_payload_pc                      (core_io_i_cmd_payload_pc[31:0]                    ), //o
    .io_i_branchCachePort_cmd_valid           (core_io_i_branchCachePort_cmd_valid               ), //i
    .io_i_branchCachePort_cmd_payload         (core_io_i_branchCachePort_cmd_payload[6:0]        ), //i
    .io_i_branchCachePort_rsp_pc              (core_io_i_branchCachePort_rsp_pc[22:0]            ), //o
    .io_i_branchCachePort_rsp_history         (core_io_i_branchCachePort_rsp_history[1:0]        ), //o
    .io_i_rsp_valid                           (_zz_io_i_rsp_valid                                ), //i
    .io_i_rsp_ready                           (core_io_i_rsp_ready                               ), //o
    .io_i_rsp_payload_instruction             (core_io_i_rsp_payload_instruction[31:0]           ), //i
    .io_i_rsp_payload_pc                      (core_io_i_rsp_payload_pc[31:0]                    ), //i
    .io_i_rsp_payload_branchCacheLine_pc      (core_io_i_rsp_payload_branchCacheLine_pc[22:0]    ), //i
    .io_i_rsp_payload_branchCacheLine_history (core_io_i_rsp_payload_branchCacheLine_history[1:0]), //i
    .io_d_cmd_valid                           (core_io_d_cmd_valid                               ), //o
    .io_d_cmd_ready                           (core_io_d_cmd_rValidN                             ), //i
    .io_d_cmd_payload_wr                      (core_io_d_cmd_payload_wr                          ), //o
    .io_d_cmd_payload_address                 (core_io_d_cmd_payload_address[31:0]               ), //o
    .io_d_cmd_payload_data                    (core_io_d_cmd_payload_data[31:0]                  ), //o
    .io_d_cmd_payload_size                    (core_io_d_cmd_payload_size[1:0]                   ), //o
    .io_d_rsp_valid                           (_zz_dBridge_contextOut_ready                      ), //i
    .io_d_rsp_ready                           (core_io_d_rsp_ready                               ), //o
    .io_d_rsp_payload                         (_zz_io_d_rsp_payload[31:0]                        ), //i
    ._zz_9                                    (core__zz_9                                        ), //i
    ._zz_10                                   (io_debugBus_PWRITE                                ), //i
    ._zz_decode_regFileReadAddress0           (core__zz_decode_regFileReadAddress0[7:0]          ), //i
    ._zz_prefetch_pc                          (io_debugBus_PWDATA[31:0]                          ), //i
    ._zz_io_debugBus_PRDATA                   (core__zz_io_debugBus_PRDATA[31:0]                 ), //o
    ._zz_io_debugResetOut                     (core__zz_io_debugResetOut                         ), //o
    .clkout                                   (clkout                                            ), //i
    .resetCtrl_coreReset                      (resetCtrl_coreReset                               ), //i
    .io_debugResetIn                          (io_debugResetIn                                   )  //i
  );
  initial begin
  `ifndef SYNTHESIS
    dBridge_pendingIsWrite = $urandom;
  `endif
  end

  assign core_io_interrupt_1 = io_interrupt[1];
  assign core_io_interrupt_0 = io_interrupt[0];
  assign core_io_interrupt_3 = io_interrupt[3];
  assign core_io_interrupt_2 = io_interrupt[2];
  assign core__zz_9 = (io_debugBus_PSEL[0] && (! io_debugBus_PENABLE));
  assign core__zz_decode_regFileReadAddress0 = _zz__zz_decode_regFileReadAddress0[7:0];
  assign io_debugBus_PSLVERROR = 1'b0;
  assign io_debugBus_PREADY = 1'b1;
  assign io_debugBus_PRDATA = core__zz_io_debugBus_PRDATA;
  assign io_debugResetOut = core__zz_io_debugResetOut;
  assign _zz_io_i_branchCachePort_cmd_valid = core_io_i_cmd_valid;
  assign _zz_io_i_ar_payload_addr = core_io_i_cmd_payload_pc;
  assign _zz_io_i_ar_valid = core_io_i_rsp_ready;
  assign core_io_i_rsp_payload_instruction = (_zz_io_i_rsp_payload_instruction_1 ? _zz_io_i_rsp_payload_instruction : _zz_io_i_rsp_payload_instruction_2);
  assign core_io_i_rsp_payload_pc = (_zz_io_i_rsp_payload_instruction_1 ? _zz_io_i_rsp_payload_pc : _zz_io_i_rsp_payload_pc_2);
  assign core_io_i_rsp_payload_branchCacheLine_pc = (_zz_io_i_rsp_payload_instruction_1 ? _zz_io_i_rsp_payload_branchCacheLine_pc : _zz_io_i_rsp_payload_branchCacheLine_pc_1);
  assign core_io_i_rsp_payload_branchCacheLine_history = (_zz_io_i_rsp_payload_instruction_1 ? _zz_io_i_rsp_payload_branchCacheLine_history : _zz_io_i_rsp_payload_branchCacheLine_history_1);
  assign _zz_io_i_ar_valid_4 = ((_zz_io_i_rsp_valid && (! _zz_io_i_ar_valid)) || (_zz_io_i_ar_valid_3 && (! _zz_io_i_ar_valid_2)));
  assign _zz_io_i_ar_valid_1 = (_zz_io_i_branchCachePort_cmd_valid && (! _zz_io_i_ar_valid_4));
  assign _zz_io_i_cmd_ready = (_zz_io_i_cmd_ready_1 && (! _zz_io_i_ar_valid_4));
  assign _zz_io_i_rsp_valid_1 = _zz_io_i_ar_valid_2;
  assign _zz_io_i_rsp_payload_instruction = io_i_r_payload_data;
  assign _zz_io_i_rsp_payload_pc = _zz_io_i_rsp_payload_pc_1;
  assign _zz_io_i_rsp_valid = (_zz_io_i_rsp_valid_1 || (! _zz_io_i_rsp_payload_instruction_1));
  assign _zz_io_i_rsp_payload_branchCacheLine_pc = core_io_i_branchCachePort_rsp_pc;
  assign _zz_io_i_rsp_payload_branchCacheLine_history = core_io_i_branchCachePort_rsp_history;
  assign io_i_ar_valid = _zz_io_i_ar_valid_1;
  assign _zz_io_i_cmd_ready_1 = io_i_ar_ready;
  assign io_i_ar_payload_addr = {_zz_io_i_ar_payload_addr[31 : 2],2'b00};
  assign io_i_ar_payload_cache = 4'b1111;
  assign io_i_ar_payload_prot = 3'b110;
  assign _zz_io_i_ar_valid_2 = io_i_r_valid;
  assign io_i_r_ready = 1'b1;
  assign core_io_i_branchCachePort_cmd_valid = (_zz_io_i_branchCachePort_cmd_valid && _zz_io_i_cmd_ready);
  assign core_io_i_branchCachePort_cmd_payload = _zz_io_i_branchCachePort_cmd_payload[6:0];
  assign core_io_d_cmd_s2mPipe_valid = (core_io_d_cmd_valid || (! core_io_d_cmd_rValidN));
  assign core_io_d_cmd_s2mPipe_payload_wr = (core_io_d_cmd_rValidN ? core_io_d_cmd_payload_wr : core_io_d_cmd_rData_wr);
  assign core_io_d_cmd_s2mPipe_payload_address = (core_io_d_cmd_rValidN ? core_io_d_cmd_payload_address : core_io_d_cmd_rData_address);
  assign core_io_d_cmd_s2mPipe_payload_data = (core_io_d_cmd_rValidN ? core_io_d_cmd_payload_data : core_io_d_cmd_rData_data);
  assign core_io_d_cmd_s2mPipe_payload_size = (core_io_d_cmd_rValidN ? core_io_d_cmd_payload_size : core_io_d_cmd_rData_size);
  assign core_io_d_cmd_s2mPipe_ready = _zz_core_io_d_cmd_s2mPipe_ready;
  assign dBridge_mm_arw_fire = (dBridge_mm_arw_valid && dBridge_mm_arw_ready);
  assign dBridge_mm_r_fire = (dBridge_mm_r_valid && dBridge_mm_r_ready);
  assign dBridge_mm_b_fire = (dBridge_mm_b_valid && dBridge_mm_b_ready);
  assign when_Utils_l719 = ((dBridge_mm_r_fire && dBridge_mm_r_payload_last) || dBridge_mm_b_fire);
  always @(*) begin
    dBridge_pendingCmd_incrementIt = 1'b0;
    if(dBridge_mm_arw_fire) begin
      dBridge_pendingCmd_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    dBridge_pendingCmd_decrementIt = 1'b0;
    if(when_Utils_l719) begin
      dBridge_pendingCmd_decrementIt = 1'b1;
    end
  end

  assign dBridge_pendingCmd_mayOverflow = (dBridge_pendingCmd_value == 3'b111);
  assign dBridge_pendingCmd_mayUnderflow = (dBridge_pendingCmd_value == 3'b000);
  assign dBridge_pendingCmd_willOverflowIfInc = (dBridge_pendingCmd_mayOverflow && (! dBridge_pendingCmd_decrementIt));
  assign dBridge_pendingCmd_willOverflow = (dBridge_pendingCmd_willOverflowIfInc && dBridge_pendingCmd_incrementIt);
  assign dBridge_pendingCmd_willUnderflowIfDec = (dBridge_pendingCmd_mayUnderflow && (! dBridge_pendingCmd_incrementIt));
  assign dBridge_pendingCmd_willUnderflow = (dBridge_pendingCmd_willUnderflowIfDec && dBridge_pendingCmd_decrementIt);
  assign when_Utils_l751 = (dBridge_pendingCmd_incrementIt && (! dBridge_pendingCmd_decrementIt));
  always @(*) begin
    if(when_Utils_l751) begin
      dBridge_pendingCmd_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l753) begin
        dBridge_pendingCmd_finalIncrement = 3'b111;
      end else begin
        dBridge_pendingCmd_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l753 = ((! dBridge_pendingCmd_incrementIt) && dBridge_pendingCmd_decrementIt);
  assign dBridge_pendingCmd_valueNext = (dBridge_pendingCmd_value + dBridge_pendingCmd_finalIncrement);
  always @(*) begin
    _zz_core_io_d_cmd_s2mPipe_ready = dBridge_cmdPreFork_ready;
    if(when_Stream_l399) begin
      _zz_core_io_d_cmd_s2mPipe_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! dBridge_cmdPreFork_valid);
  assign dBridge_cmdPreFork_valid = _zz_dBridge_cmdPreFork_valid;
  assign dBridge_cmdPreFork_payload_wr = _zz_dBridge_cmdPreFork_payload_wr;
  assign dBridge_cmdPreFork_payload_address = _zz_dBridge_cmdPreFork_payload_address;
  assign dBridge_cmdPreFork_payload_data = _zz_dBridge_cmdPreFork_payload_data;
  assign dBridge_cmdPreFork_payload_size = _zz_dBridge_cmdPreFork_payload_size;
  assign _zz_dBridge_cmdPreFork_ready = (! (((dBridge_pendingCmd_value != 3'b000) && (dBridge_pendingIsWrite ^ dBridge_cmdPreFork_payload_wr)) || (dBridge_pendingCmd_value == 3'b111)));
  assign dBridge_cmdPreFork_haltWhen_valid = (dBridge_cmdPreFork_valid && _zz_dBridge_cmdPreFork_ready);
  assign dBridge_cmdPreFork_ready = (dBridge_cmdPreFork_haltWhen_ready && _zz_dBridge_cmdPreFork_ready);
  assign dBridge_cmdPreFork_haltWhen_payload_wr = dBridge_cmdPreFork_payload_wr;
  assign dBridge_cmdPreFork_haltWhen_payload_address = dBridge_cmdPreFork_payload_address;
  assign dBridge_cmdPreFork_haltWhen_payload_data = dBridge_cmdPreFork_payload_data;
  assign dBridge_cmdPreFork_haltWhen_payload_size = dBridge_cmdPreFork_payload_size;
  always @(*) begin
    dBridge_cmdPreFork_haltWhen_ready = 1'b1;
    if(when_Stream_l1119) begin
      dBridge_cmdPreFork_haltWhen_ready = 1'b0;
    end
    if(when_Stream_l1119_1) begin
      dBridge_cmdPreFork_haltWhen_ready = 1'b0;
    end
  end

  assign when_Stream_l1119 = ((! dBridge_cmdFork_ready) && dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_0);
  assign when_Stream_l1119_1 = ((! dBridge_dataFork_ready) && dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_1);
  assign dBridge_cmdFork_valid = (dBridge_cmdPreFork_haltWhen_valid && dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_0);
  assign dBridge_cmdFork_payload_wr = dBridge_cmdPreFork_haltWhen_payload_wr;
  assign dBridge_cmdFork_payload_address = dBridge_cmdPreFork_haltWhen_payload_address;
  assign dBridge_cmdFork_payload_data = dBridge_cmdPreFork_haltWhen_payload_data;
  assign dBridge_cmdFork_payload_size = dBridge_cmdPreFork_haltWhen_payload_size;
  assign dBridge_cmdFork_fire = (dBridge_cmdFork_valid && dBridge_cmdFork_ready);
  assign dBridge_dataFork_valid = (dBridge_cmdPreFork_haltWhen_valid && dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_1);
  assign dBridge_dataFork_payload_wr = dBridge_cmdPreFork_haltWhen_payload_wr;
  assign dBridge_dataFork_payload_address = dBridge_cmdPreFork_haltWhen_payload_address;
  assign dBridge_dataFork_payload_data = dBridge_cmdPreFork_haltWhen_payload_data;
  assign dBridge_dataFork_payload_size = dBridge_cmdPreFork_haltWhen_payload_size;
  assign dBridge_dataFork_fire = (dBridge_dataFork_valid && dBridge_dataFork_ready);
  assign dBridge_mm_arw_valid = dBridge_cmdFork_valid;
  assign dBridge_mm_arw_payload_write = dBridge_cmdFork_payload_wr;
  assign dBridge_mm_arw_payload_prot = 3'b010;
  assign dBridge_mm_arw_payload_cache = 4'b1111;
  assign dBridge_mm_arw_payload_size = {1'd0, dBridge_cmdFork_payload_size};
  assign dBridge_mm_arw_payload_addr = dBridge_cmdFork_payload_address;
  assign when_Stream_l486 = (! dBridge_dataFork_payload_wr);
  always @(*) begin
    dBridge_dataStage_valid = dBridge_dataFork_valid;
    if(when_Stream_l486) begin
      dBridge_dataStage_valid = 1'b0;
    end
  end

  always @(*) begin
    dBridge_dataFork_ready = dBridge_dataStage_ready;
    if(when_Stream_l486) begin
      dBridge_dataFork_ready = 1'b1;
    end
  end

  assign dBridge_dataStage_payload_wr = dBridge_dataFork_payload_wr;
  assign dBridge_dataStage_payload_address = dBridge_dataFork_payload_address;
  assign dBridge_dataStage_payload_data = dBridge_dataFork_payload_data;
  assign dBridge_dataStage_payload_size = dBridge_dataFork_payload_size;
  assign dBridge_mm_w_valid = dBridge_dataStage_valid;
  assign dBridge_dataStage_ready = dBridge_mm_w_ready;
  assign dBridge_mm_w_payload_last = 1'b1;
  always @(*) begin
    case(dBridge_dataStage_payload_size)
      2'b00 : begin
        _zz_dBridge_mm_w_payload_data = {{{dBridge_dataStage_payload_data[7 : 0],dBridge_dataStage_payload_data[7 : 0]},dBridge_dataStage_payload_data[7 : 0]},dBridge_dataStage_payload_data[7 : 0]};
      end
      2'b01 : begin
        _zz_dBridge_mm_w_payload_data = {dBridge_dataStage_payload_data[15 : 0],dBridge_dataStage_payload_data[15 : 0]};
      end
      default : begin
        _zz_dBridge_mm_w_payload_data = dBridge_dataStage_payload_data[31 : 0];
      end
    endcase
  end

  assign dBridge_mm_w_payload_data = _zz_dBridge_mm_w_payload_data;
  always @(*) begin
    case(dBridge_dataStage_payload_size)
      2'b00 : begin
        _zz_dBridge_mm_w_payload_strb = 4'b0001;
      end
      2'b01 : begin
        _zz_dBridge_mm_w_payload_strb = 4'b0011;
      end
      default : begin
        _zz_dBridge_mm_w_payload_strb = 4'b1111;
      end
    endcase
  end

  assign dBridge_mm_w_payload_strb = _zz_dBridge_mm_w_payload_strb_1[3:0];
  assign dBridge_contextIn_valid = (dBridge_cmdFork_fire && (! dBridge_cmdFork_payload_wr));
  assign dBridge_contextIn_payload = dBridge_cmdFork_payload_address[1 : 0];
  always @(*) begin
    dBridge_contextIn_ready = dBridge_contextIn_m2sPipe_ready;
    if(when_Stream_l399_1) begin
      dBridge_contextIn_ready = 1'b1;
    end
  end

  assign when_Stream_l399_1 = (! dBridge_contextIn_m2sPipe_valid);
  assign dBridge_contextIn_m2sPipe_valid = dBridge_contextIn_rValid;
  assign dBridge_contextIn_m2sPipe_payload = dBridge_contextIn_rData;
  assign dBridge_contextIn_m2sPipe_ready = dBridge_contextIn_m2sPipe_rValidN;
  assign dBridge_contextOut_valid = (dBridge_contextIn_m2sPipe_valid || (! dBridge_contextIn_m2sPipe_rValidN));
  assign dBridge_contextOut_payload = (dBridge_contextIn_m2sPipe_rValidN ? dBridge_contextIn_m2sPipe_payload : dBridge_contextIn_m2sPipe_rData);
  assign dBridge_contextOut_ready = (_zz_dBridge_contextOut_ready && core_io_d_rsp_ready);
  assign dBridge_cmdFork_ready = dBridge_mm_arw_ready;
  assign _zz_dBridge_contextOut_ready = dBridge_mm_r_valid;
  always @(*) begin
    _zz_io_d_rsp_payload = dBridge_mm_r_payload_data;
    case(dBridge_contextOut_payload)
      2'b01 : begin
        _zz_io_d_rsp_payload[7 : 0] = dBridge_mm_r_payload_data[15 : 8];
      end
      2'b10 : begin
        _zz_io_d_rsp_payload[15 : 0] = dBridge_mm_r_payload_data[31 : 16];
      end
      2'b11 : begin
        _zz_io_d_rsp_payload[7 : 0] = dBridge_mm_r_payload_data[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign dBridge_mm_b_ready = 1'b1;
  assign dBridge_mm_r_ready = 1'b1;
  assign io_d_arw_valid = dBridge_mm_arw_valid;
  assign dBridge_mm_arw_ready = io_d_arw_ready;
  assign io_d_arw_payload_addr = dBridge_mm_arw_payload_addr;
  assign io_d_arw_payload_size = dBridge_mm_arw_payload_size;
  assign io_d_arw_payload_cache = dBridge_mm_arw_payload_cache;
  assign io_d_arw_payload_prot = dBridge_mm_arw_payload_prot;
  assign io_d_arw_payload_write = dBridge_mm_arw_payload_write;
  assign io_d_w_valid = dBridge_mm_w_valid;
  assign dBridge_mm_w_ready = io_d_w_ready;
  assign io_d_w_payload_data = dBridge_mm_w_payload_data;
  assign io_d_w_payload_strb = dBridge_mm_w_payload_strb;
  assign io_d_w_payload_last = dBridge_mm_w_payload_last;
  assign dBridge_mm_b_valid = io_d_b_valid;
  assign io_d_b_ready = dBridge_mm_b_ready;
  assign dBridge_mm_r_valid = io_d_r_valid;
  assign io_d_r_ready = dBridge_mm_r_ready;
  assign dBridge_mm_r_payload_data = io_d_r_payload_data;
  assign dBridge_mm_r_payload_last = io_d_r_payload_last;
  always @(posedge clkout or posedge resetCtrl_coreReset) begin
    if(resetCtrl_coreReset) begin
      _zz_io_i_ar_valid_3 <= 1'b0;
      _zz_io_i_rsp_payload_instruction_1 <= 1'b1;
      core_io_d_cmd_rValidN <= 1'b1;
      dBridge_pendingCmd_value <= 3'b000;
      _zz_dBridge_cmdPreFork_valid <= 1'b0;
      dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_0 <= 1'b1;
      dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_1 <= 1'b1;
      dBridge_contextIn_rValid <= 1'b0;
      dBridge_contextIn_m2sPipe_rValidN <= 1'b1;
    end else begin
      _zz_io_i_ar_valid_3 <= ((_zz_io_i_ar_valid_3 && (! _zz_io_i_ar_valid_2)) || (_zz_io_i_ar_valid_1 && _zz_io_i_cmd_ready_1));
      if(_zz_io_i_rsp_valid_1) begin
        _zz_io_i_rsp_payload_instruction_1 <= 1'b0;
      end
      if(_zz_io_i_ar_valid) begin
        _zz_io_i_rsp_payload_instruction_1 <= 1'b1;
      end
      if(core_io_d_cmd_valid) begin
        core_io_d_cmd_rValidN <= 1'b0;
      end
      if(core_io_d_cmd_s2mPipe_ready) begin
        core_io_d_cmd_rValidN <= 1'b1;
      end
      dBridge_pendingCmd_value <= dBridge_pendingCmd_valueNext;
      if(_zz_core_io_d_cmd_s2mPipe_ready) begin
        _zz_dBridge_cmdPreFork_valid <= core_io_d_cmd_s2mPipe_valid;
      end
      if(dBridge_cmdFork_fire) begin
        dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_0 <= 1'b0;
      end
      if(dBridge_dataFork_fire) begin
        dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_1 <= 1'b0;
      end
      if(dBridge_cmdPreFork_haltWhen_ready) begin
        dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_0 <= 1'b1;
        dBridge_cmdPreFork_haltWhen_fork2_logic_linkEnable_1 <= 1'b1;
      end
      if(dBridge_contextIn_ready) begin
        dBridge_contextIn_rValid <= dBridge_contextIn_valid;
      end
      if(dBridge_contextIn_m2sPipe_valid) begin
        dBridge_contextIn_m2sPipe_rValidN <= 1'b0;
      end
      if(dBridge_contextOut_ready) begin
        dBridge_contextIn_m2sPipe_rValidN <= 1'b1;
      end
    end
  end

  always @(posedge clkout) begin
    if(_zz_io_i_cmd_ready) begin
      _zz_io_i_rsp_payload_pc_1 <= _zz_io_i_ar_payload_addr;
    end
    if(_zz_io_i_rsp_payload_instruction_1) begin
      _zz_io_i_rsp_payload_instruction_2 <= _zz_io_i_rsp_payload_instruction;
      _zz_io_i_rsp_payload_pc_2 <= _zz_io_i_rsp_payload_pc;
      _zz_io_i_rsp_payload_branchCacheLine_pc_1 <= _zz_io_i_rsp_payload_branchCacheLine_pc;
      _zz_io_i_rsp_payload_branchCacheLine_history_1 <= _zz_io_i_rsp_payload_branchCacheLine_history;
    end
    if(core_io_d_cmd_rValidN) begin
      core_io_d_cmd_rData_wr <= core_io_d_cmd_payload_wr;
      core_io_d_cmd_rData_address <= core_io_d_cmd_payload_address;
      core_io_d_cmd_rData_data <= core_io_d_cmd_payload_data;
      core_io_d_cmd_rData_size <= core_io_d_cmd_payload_size;
    end
    if(dBridge_mm_arw_fire) begin
      dBridge_pendingIsWrite <= dBridge_mm_arw_payload_write;
    end
    if(_zz_core_io_d_cmd_s2mPipe_ready) begin
      _zz_dBridge_cmdPreFork_payload_wr <= core_io_d_cmd_s2mPipe_payload_wr;
      _zz_dBridge_cmdPreFork_payload_address <= core_io_d_cmd_s2mPipe_payload_address;
      _zz_dBridge_cmdPreFork_payload_data <= core_io_d_cmd_s2mPipe_payload_data;
      _zz_dBridge_cmdPreFork_payload_size <= core_io_d_cmd_s2mPipe_payload_size;
    end
    if(dBridge_contextIn_ready) begin
      dBridge_contextIn_rData <= dBridge_contextIn_payload;
    end
    if(dBridge_contextIn_m2sPipe_ready) begin
      dBridge_contextIn_m2sPipe_rData <= dBridge_contextIn_m2sPipe_payload;
    end
  end


endmodule

module BufferCC_36 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clkout
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

//StreamFifoLowLatency_2 replaced by StreamFifoLowLatency

module StreamArbiter_2 (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [19:0]   io_inputs_0_payload_addr,
  input  wire [3:0]    io_inputs_0_payload_id,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [1:0]    io_inputs_0_payload_burst,
  input  wire          io_inputs_0_payload_write,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [19:0]   io_output_payload_addr,
  output wire [3:0]    io_output_payload_id,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [1:0]    io_output_payload_burst,
  output wire          io_output_payload_write,
  output wire [0:0]    io_chosenOH,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [1:0]    _zz__zz_maskProposal_0_2;
  wire       [1:0]    _zz__zz_maskProposal_0_2_1;
  wire       [0:0]    _zz__zz_maskProposal_0_2_2;
  wire       [0:0]    _zz_maskProposal_0_3;
  reg                 locked;
  wire                maskProposal_0;
  reg                 maskLocked_0;
  wire                maskRouted_0;
  wire       [0:0]    _zz_maskProposal_0;
  wire       [1:0]    _zz_maskProposal_0_1;
  wire       [1:0]    _zz_maskProposal_0_2;
  wire                io_output_fire;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = maskLocked_0;
  assign _zz__zz_maskProposal_0_2_1 = {1'd0, _zz__zz_maskProposal_0_2_2};
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[1 : 1] | _zz_maskProposal_0_2[0 : 0]);
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign _zz_maskProposal_0 = io_inputs_0_valid;
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = (io_inputs_0_valid && maskRouted_0);
  assign io_output_payload_addr = io_inputs_0_payload_addr;
  assign io_output_payload_id = io_inputs_0_payload_id;
  assign io_output_payload_len = io_inputs_0_payload_len;
  assign io_output_payload_size = io_inputs_0_payload_size;
  assign io_output_payload_burst = io_inputs_0_payload_burst;
  assign io_output_payload_write = io_inputs_0_payload_write;
  assign io_inputs_0_ready = ((1'b0 || maskRouted_0) && io_output_ready);
  assign io_chosenOH = maskRouted_0;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

//StreamFifoLowLatency_1 replaced by StreamFifoLowLatency

module StreamArbiter_1 (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [27:0]   io_inputs_0_payload_addr,
  input  wire [1:0]    io_inputs_0_payload_id,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [1:0]    io_inputs_0_payload_burst,
  input  wire          io_inputs_0_payload_write,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [27:0]   io_inputs_1_payload_addr,
  input  wire [1:0]    io_inputs_1_payload_id,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [1:0]    io_inputs_1_payload_burst,
  input  wire          io_inputs_1_payload_write,
  input  wire          io_inputs_2_valid,
  output wire          io_inputs_2_ready,
  input  wire [27:0]   io_inputs_2_payload_addr,
  input  wire [1:0]    io_inputs_2_payload_id,
  input  wire [7:0]    io_inputs_2_payload_len,
  input  wire [2:0]    io_inputs_2_payload_size,
  input  wire [1:0]    io_inputs_2_payload_burst,
  input  wire          io_inputs_2_payload_write,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [27:0]   io_output_payload_addr,
  output wire [1:0]    io_output_payload_id,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [1:0]    io_output_payload_burst,
  output wire          io_output_payload_write,
  output wire [1:0]    io_chosen,
  output wire [2:0]    io_chosenOH,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [5:0]    _zz__zz_maskProposal_0_2;
  wire       [5:0]    _zz__zz_maskProposal_0_2_1;
  wire       [2:0]    _zz__zz_maskProposal_0_2_2;
  reg        [27:0]   _zz_io_output_payload_addr_1;
  reg        [1:0]    _zz_io_output_payload_id;
  reg        [7:0]    _zz_io_output_payload_len;
  reg        [2:0]    _zz_io_output_payload_size;
  reg        [1:0]    _zz_io_output_payload_burst;
  reg                 _zz_io_output_payload_write;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  wire                maskProposal_2;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  reg                 maskLocked_2;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire                maskRouted_2;
  wire       [2:0]    _zz_maskProposal_0;
  wire       [5:0]    _zz_maskProposal_0_1;
  wire       [5:0]    _zz_maskProposal_0_2;
  wire       [2:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire       [1:0]    _zz_io_output_payload_addr;
  wire                _zz_io_chosen;
  wire                _zz_io_chosen_1;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_1,{maskLocked_0,maskLocked_2}};
  assign _zz__zz_maskProposal_0_2_1 = {3'd0, _zz__zz_maskProposal_0_2_2};
  always @(*) begin
    case(_zz_io_output_payload_addr)
      2'b00 : begin
        _zz_io_output_payload_addr_1 = io_inputs_0_payload_addr;
        _zz_io_output_payload_id = io_inputs_0_payload_id;
        _zz_io_output_payload_len = io_inputs_0_payload_len;
        _zz_io_output_payload_size = io_inputs_0_payload_size;
        _zz_io_output_payload_burst = io_inputs_0_payload_burst;
        _zz_io_output_payload_write = io_inputs_0_payload_write;
      end
      2'b01 : begin
        _zz_io_output_payload_addr_1 = io_inputs_1_payload_addr;
        _zz_io_output_payload_id = io_inputs_1_payload_id;
        _zz_io_output_payload_len = io_inputs_1_payload_len;
        _zz_io_output_payload_size = io_inputs_1_payload_size;
        _zz_io_output_payload_burst = io_inputs_1_payload_burst;
        _zz_io_output_payload_write = io_inputs_1_payload_write;
      end
      default : begin
        _zz_io_output_payload_addr_1 = io_inputs_2_payload_addr;
        _zz_io_output_payload_id = io_inputs_2_payload_id;
        _zz_io_output_payload_len = io_inputs_2_payload_len;
        _zz_io_output_payload_size = io_inputs_2_payload_size;
        _zz_io_output_payload_burst = io_inputs_2_payload_burst;
        _zz_io_output_payload_write = io_inputs_2_payload_write;
      end
    endcase
  end

  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign maskRouted_2 = (locked ? maskLocked_2 : maskProposal_2);
  assign _zz_maskProposal_0 = {io_inputs_2_valid,{io_inputs_1_valid,io_inputs_0_valid}};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[5 : 3] | _zz_maskProposal_0_2[2 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign maskProposal_2 = _zz_maskProposal_0_3[2];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = (((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1)) || (io_inputs_2_valid && maskRouted_2));
  assign _zz_io_output_payload_addr = {maskRouted_2,maskRouted_1};
  assign io_output_payload_addr = _zz_io_output_payload_addr_1;
  assign io_output_payload_id = _zz_io_output_payload_id;
  assign io_output_payload_len = _zz_io_output_payload_len;
  assign io_output_payload_size = _zz_io_output_payload_size;
  assign io_output_payload_burst = _zz_io_output_payload_burst;
  assign io_output_payload_write = _zz_io_output_payload_write;
  assign io_inputs_0_ready = ((1'b0 || maskRouted_0) && io_output_ready);
  assign io_inputs_1_ready = ((1'b0 || maskRouted_1) && io_output_ready);
  assign io_inputs_2_ready = ((1'b0 || maskRouted_2) && io_output_ready);
  assign io_chosenOH = {maskRouted_2,{maskRouted_1,maskRouted_0}};
  assign _zz_io_chosen = io_chosenOH[1];
  assign _zz_io_chosen_1 = io_chosenOH[2];
  assign io_chosen = {_zz_io_chosen_1,_zz_io_chosen};
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b0;
      maskLocked_2 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
        maskLocked_2 <= maskRouted_2;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module StreamFifoLowLatency (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  input  wire          io_flush,
  output wire [2:0]    io_occupancy,
  output wire [2:0]    io_availability,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [2:0]    fifo_io_occupancy;
  wire       [2:0]    fifo_io_availability;

  StreamFifo_4 fifo (
    .io_push_valid      (io_push_valid            ), //i
    .io_push_ready      (fifo_io_push_ready       ), //o
    .io_pop_valid       (fifo_io_pop_valid        ), //o
    .io_pop_ready       (io_pop_ready             ), //i
    .io_flush           (io_flush                 ), //i
    .io_occupancy       (fifo_io_occupancy[2:0]   ), //o
    .io_availability    (fifo_io_availability[2:0]), //o
    .clkout             (clkout                   ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset       )  //i
  );
  assign io_push_ready = fifo_io_push_ready;
  assign io_pop_valid = fifo_io_pop_valid;
  assign io_occupancy = fifo_io_occupancy;
  assign io_availability = fifo_io_availability;

endmodule

module StreamArbiter (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [14:0]   io_inputs_0_payload_addr,
  input  wire [2:0]    io_inputs_0_payload_id,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [1:0]    io_inputs_0_payload_burst,
  input  wire          io_inputs_0_payload_write,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [14:0]   io_inputs_1_payload_addr,
  input  wire [2:0]    io_inputs_1_payload_id,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [1:0]    io_inputs_1_payload_burst,
  input  wire          io_inputs_1_payload_write,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [14:0]   io_output_payload_addr,
  output wire [2:0]    io_output_payload_id,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [1:0]    io_output_payload_burst,
  output wire          io_output_payload_write,
  output wire [0:0]    io_chosen,
  output wire [1:0]    io_chosenOH,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [3:0]    _zz__zz_maskProposal_0_2;
  wire       [3:0]    _zz__zz_maskProposal_0_2_1;
  wire       [1:0]    _zz__zz_maskProposal_0_2_2;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_maskProposal_0;
  wire       [3:0]    _zz_maskProposal_0_1;
  wire       [3:0]    _zz_maskProposal_0_2;
  wire       [1:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire                _zz_io_chosen;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_0,maskLocked_1};
  assign _zz__zz_maskProposal_0_2_1 = {2'd0, _zz__zz_maskProposal_0_2_2};
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_maskProposal_0 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[3 : 2] | _zz_maskProposal_0_2[1 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_id = (maskRouted_0 ? io_inputs_0_payload_id : io_inputs_1_payload_id);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_burst = (maskRouted_0 ? io_inputs_0_payload_burst : io_inputs_1_payload_burst);
  assign io_output_payload_write = (maskRouted_0 ? io_inputs_0_payload_write : io_inputs_1_payload_write);
  assign io_inputs_0_ready = ((1'b0 || maskRouted_0) && io_output_ready);
  assign io_inputs_1_ready = ((1'b0 || maskRouted_1) && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_io_chosen = io_chosenOH[1];
  assign io_chosen = _zz_io_chosen;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module Axi4ReadOnlyErrorSlave_1 (
  input  wire          io_axi_ar_valid,
  output wire          io_axi_ar_ready,
  input  wire [31:0]   io_axi_ar_payload_addr,
  input  wire [7:0]    io_axi_ar_payload_len,
  input  wire [2:0]    io_axi_ar_payload_size,
  input  wire [3:0]    io_axi_ar_payload_cache,
  input  wire [2:0]    io_axi_ar_payload_prot,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire          io_axi_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 sendRsp;
  reg        [7:0]    remaining;
  wire                remainingZero;
  wire                io_axi_ar_fire;

  assign remainingZero = (remaining == 8'h0);
  assign io_axi_ar_ready = (! sendRsp);
  assign io_axi_ar_fire = (io_axi_ar_valid && io_axi_ar_ready);
  assign io_axi_r_valid = sendRsp;
  assign io_axi_r_payload_last = remainingZero;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      sendRsp <= 1'b0;
    end else begin
      if(io_axi_ar_fire) begin
        sendRsp <= 1'b1;
      end
      if(sendRsp) begin
        if(io_axi_r_ready) begin
          if(remainingZero) begin
            sendRsp <= 1'b0;
          end
        end
      end
    end
  end

  always @(posedge clkout) begin
    if(io_axi_ar_fire) begin
      remaining <= io_axi_ar_payload_len;
    end
    if(sendRsp) begin
      if(io_axi_r_ready) begin
        remaining <= (remaining - 8'h01);
      end
    end
  end


endmodule

module Axi4SharedErrorSlave (
  input  wire          io_axi_arw_valid,
  output wire          io_axi_arw_ready,
  input  wire [31:0]   io_axi_arw_payload_addr,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [3:0]    io_axi_arw_payload_cache,
  input  wire [2:0]    io_axi_arw_payload_prot,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire          io_axi_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 consumeData;
  reg                 sendReadRsp;
  reg                 sendWriteRsp;
  reg        [7:0]    remaining;
  wire                remainingZero;
  wire                io_axi_arw_fire;
  wire                io_axi_w_fire;
  wire                when_Axi4ErrorSlave_l92;
  wire                io_axi_b_fire;

  assign remainingZero = (remaining == 8'h0);
  assign io_axi_arw_ready = (! ((consumeData || sendWriteRsp) || sendReadRsp));
  assign io_axi_arw_fire = (io_axi_arw_valid && io_axi_arw_ready);
  assign io_axi_w_ready = consumeData;
  assign io_axi_w_fire = (io_axi_w_valid && io_axi_w_ready);
  assign when_Axi4ErrorSlave_l92 = (io_axi_w_fire && io_axi_w_payload_last);
  assign io_axi_b_valid = sendWriteRsp;
  assign io_axi_b_fire = (io_axi_b_valid && io_axi_b_ready);
  assign io_axi_r_valid = sendReadRsp;
  assign io_axi_r_payload_last = remainingZero;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      consumeData <= 1'b0;
      sendReadRsp <= 1'b0;
      sendWriteRsp <= 1'b0;
    end else begin
      if(io_axi_arw_fire) begin
        consumeData <= io_axi_arw_payload_write;
        sendReadRsp <= (! io_axi_arw_payload_write);
      end
      if(when_Axi4ErrorSlave_l92) begin
        consumeData <= 1'b0;
        sendWriteRsp <= 1'b1;
      end
      if(io_axi_b_fire) begin
        sendWriteRsp <= 1'b0;
      end
      if(sendReadRsp) begin
        if(io_axi_r_ready) begin
          if(remainingZero) begin
            sendReadRsp <= 1'b0;
          end
        end
      end
    end
  end

  always @(posedge clkout) begin
    if(io_axi_arw_fire) begin
      remaining <= 8'h0;
    end
    if(sendReadRsp) begin
      if(io_axi_r_ready) begin
        remaining <= (remaining - 8'h01);
      end
    end
  end


endmodule

module Axi4ReadOnlyErrorSlave (
  input  wire          io_axi_ar_valid,
  output wire          io_axi_ar_ready,
  input  wire [31:0]   io_axi_ar_payload_addr,
  input  wire [3:0]    io_axi_ar_payload_cache,
  input  wire [2:0]    io_axi_ar_payload_prot,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire          io_axi_r_payload_last,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 sendRsp;
  reg        [7:0]    remaining;
  wire                remainingZero;
  wire                io_axi_ar_fire;

  assign remainingZero = (remaining == 8'h0);
  assign io_axi_ar_ready = (! sendRsp);
  assign io_axi_ar_fire = (io_axi_ar_valid && io_axi_ar_ready);
  assign io_axi_r_valid = sendRsp;
  assign io_axi_r_payload_last = remainingZero;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      sendRsp <= 1'b0;
    end else begin
      if(io_axi_ar_fire) begin
        sendRsp <= 1'b1;
      end
      if(sendRsp) begin
        if(io_axi_r_ready) begin
          if(remainingZero) begin
            sendRsp <= 1'b0;
          end
        end
      end
    end
  end

  always @(posedge clkout) begin
    if(io_axi_ar_fire) begin
      remaining <= 8'h0;
    end
    if(sendRsp) begin
      if(io_axi_r_ready) begin
        remaining <= (remaining - 8'h01);
      end
    end
  end


endmodule

module Apb3Dvtc (
  input  wire [9:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_axi_ar_valid,
  input  wire          io_axi_ar_ready,
  output wire [31:0]   io_axi_ar_payload_addr,
  output wire [7:0]    io_axi_ar_payload_len,
  output wire [2:0]    io_axi_ar_payload_size,
  output wire [3:0]    io_axi_ar_payload_cache,
  output wire [2:0]    io_axi_ar_payload_prot,
  input  wire          io_axi_r_valid,
  output wire          io_axi_r_ready,
  input  wire [31:0]   io_axi_r_payload_data,
  input  wire          io_axi_r_payload_last,
  output wire          io_dvti_vs,
  output wire          io_dvti_hs,
  output wire          io_dvti_de,
  output wire [15:0]   io_dvti_data,
  output wire          io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clkout_1
);

  wire                layerDma_io_start;
  wire       [26:0]   layerDma_io_base;
  wire       [17:0]   layerDma_io_size;
  reg                 layerDma_io_frame_ready;
  wire                bufferCC_37_io_dataIn;
  wire                bufferCC_38_io_dataIn;
  wire                bufferCC_39_io_dataIn;
  wire       [11:0]   bufferCC_40_io_dataIn;
  wire       [11:0]   bufferCC_41_io_dataIn;
  wire       [11:0]   bufferCC_42_io_dataIn;
  wire       [11:0]   bufferCC_43_io_dataIn;
  wire                bufferCC_44_io_dataIn;
  wire       [11:0]   bufferCC_45_io_dataIn;
  wire       [11:0]   bufferCC_46_io_dataIn;
  wire       [11:0]   bufferCC_47_io_dataIn;
  wire       [11:0]   bufferCC_48_io_dataIn;
  wire                bufferCC_49_io_dataIn;
  wire                bufferCC_50_io_dataIn;
  wire                layerDma_io_busy;
  wire                layerDma_io_mem_cmd_valid;
  wire       [26:0]   layerDma_io_mem_cmd_payload;
  wire                layerDma_io_frame_valid;
  wire                layerDma_io_frame_payload_last;
  wire       [15:0]   layerDma_io_frame_payload_fragment;
  wire                dvt_io_pixel_ready;
  wire       [15:0]   dvt_io_pos_x;
  wire       [15:0]   dvt_io_pos_y;
  wire                dvt_io_dvti_vs;
  wire                dvt_io_dvti_hs;
  wire                dvt_io_dvti_de;
  wire       [15:0]   dvt_io_dvti_data;
  wire                dvt_io_hen;
  wire                dvt_io_ven;
  wire                bufferCC_37_io_dataOut;
  wire                bufferCC_38_io_dataOut;
  wire                bufferCC_39_io_dataOut;
  wire       [11:0]   bufferCC_40_io_dataOut;
  wire       [11:0]   bufferCC_41_io_dataOut;
  wire       [11:0]   bufferCC_42_io_dataOut;
  wire       [11:0]   bufferCC_43_io_dataOut;
  wire                bufferCC_44_io_dataOut;
  wire       [11:0]   bufferCC_45_io_dataOut;
  wire       [11:0]   bufferCC_46_io_dataOut;
  wire       [11:0]   bufferCC_47_io_dataOut;
  wire       [11:0]   bufferCC_48_io_dataOut;
  wire                bufferCC_49_io_dataOut;
  wire                bufferCC_50_io_dataOut;
  wire       [15:0]   dvt_io_pos_x_buffercc_io_dataOut;
  wire       [15:0]   dvt_io_pos_y_buffercc_io_dataOut;
  wire                dvt_io_dvti_vs_buffercc_io_dataOut;
  wire                dvt_io_dvti_hs_buffercc_io_dataOut;
  wire                dvt_io_hen_buffercc_io_dataOut;
  wire                dvt_io_ven_buffercc_io_dataOut;
  wire                dvtArea_frameStart_pulseCCByToggle_io_pulseOut;
  wire       [15:0]   _zz_line_match;
  wire       [11:0]   _zz_line_match_1;
  wire       [26:0]   _zz_io_size;
  wire       [31:0]   _zz_io_size_1;
  wire       [31:0]   _zz_io_size_2;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [31:0]   SSCR;
  reg        [31:0]   BPCR;
  reg        [31:0]   AWCR;
  reg        [31:0]   TWCR;
  reg        [31:0]   GCR;
  reg        [31:0]   SRCR;
  reg        [31:0]   BCCR;
  reg        [31:0]   IER;
  reg        [31:0]   ISR;
  reg        [31:0]   ICR;
  reg        [31:0]   LIPCR;
  reg        [31:0]   CPSR;
  reg        [31:0]   CDSR;
  reg        [31:0]   CR;
  reg        [31:0]   WHPCR;
  reg        [31:0]   WVPCR;
  reg        [31:0]   CKCR;
  reg        [31:0]   PFCR;
  reg        [31:0]   CACR;
  reg        [31:0]   DCCR;
  reg        [31:0]   BFCR;
  reg        [31:0]   CFBAR;
  reg        [31:0]   CFBLR;
  reg        [31:0]   CFBLNR;
  reg        [31:0]   CLUTWR;
  reg                 dvt_io_dvti_vs_regNext;
  reg                 dvt_io_dvti_vs_regNext_1;
  wire                _zz_dvtArea_frameStart;
  reg                 _zz_dvtArea_frameStart_1;
  wire                dvtArea_frameStart;
  reg                 dvtArea_error;
  reg                 dvtArea_waitStartOfFrame;
  reg                 dvtArea_firstPixel;
  wire                layerDma_io_frame_fire;
  reg                 layerDma_io_frame_payload_first;
  wire                when_Apb3Dvtc_l262;
  wire                when_Apb3Dvtc_l267;
  wire                when_Apb3Dvtc_l271;
  wire                when_Apb3Dvtc_l272;
  wire                layerDma_io_frame_translated_valid;
  wire                layerDma_io_frame_translated_ready;
  wire       [15:0]   layerDma_io_frame_translated_payload;
  wire                _zz_layerDma_io_frame_translated_ready;
  wire                layerDma_io_frame_translated_haltWhen_valid;
  wire                layerDma_io_frame_translated_haltWhen_ready;
  wire       [15:0]   layerDma_io_frame_translated_haltWhen_payload;
  wire                when_Apb3Dvtc_l296;
  wire       [15:0]   pos_x_sync;
  wire       [15:0]   pos_y_sync;
  wire                vs_sync;
  wire                hs_sync;
  wire                hen_sync;
  wire                ven_sync;
  reg                 vs_sync_regNext;
  reg                 vs_sync_regNext_1;
  wire                vs_rise;
  reg                 hs_sync_regNext;
  reg                 hs_sync_regNext_1;
  wire                hs_rise;
  wire                line_match;
  wire                when_Apb3Dvtc_l316;

  assign _zz_line_match_1 = LIPCR[11 : 0];
  assign _zz_line_match = {4'd0, _zz_line_match_1};
  assign _zz_io_size = (_zz_io_size_1 >>> 3'd5);
  assign _zz_io_size_1 = (_zz_io_size_2 - 32'h00000001);
  assign _zz_io_size_2 = (CFBLNR[15 : 0] * CFBLR[31 : 16]);
  VideoDma layerDma (
    .io_start                    (layerDma_io_start                       ), //i
    .io_busy                     (layerDma_io_busy                        ), //o
    .io_base                     (layerDma_io_base[26:0]                  ), //i
    .io_size                     (layerDma_io_size[17:0]                  ), //i
    .io_mem_cmd_valid            (layerDma_io_mem_cmd_valid               ), //o
    .io_mem_cmd_ready            (io_axi_ar_ready                         ), //i
    .io_mem_cmd_payload          (layerDma_io_mem_cmd_payload[26:0]       ), //o
    .io_mem_rsp_valid            (io_axi_r_valid                          ), //i
    .io_mem_rsp_payload_last     (io_axi_r_payload_last                   ), //i
    .io_mem_rsp_payload_fragment (io_axi_r_payload_data[31:0]             ), //i
    .io_frame_valid              (layerDma_io_frame_valid                 ), //o
    .io_frame_ready              (layerDma_io_frame_ready                 ), //i
    .io_frame_payload_last       (layerDma_io_frame_payload_last          ), //o
    .io_frame_payload_fragment   (layerDma_io_frame_payload_fragment[15:0]), //o
    .clkout                      (clkout                                  ), //i
    .resetCtrl_axiReset          (resetCtrl_axiReset                      ), //i
    .clkout_1                    (clkout_1                                )  //i
  );
  DVTiming dvt (
    .io_en              (bufferCC_37_io_dataOut                             ), //i
    .io_cfg_vsync       (bufferCC_40_io_dataOut[11:0]                       ), //i
    .io_cfg_vback       (bufferCC_41_io_dataOut[11:0]                       ), //i
    .io_cfg_vdisp       (bufferCC_42_io_dataOut[11:0]                       ), //i
    .io_cfg_vtotal      (bufferCC_43_io_dataOut[11:0]                       ), //i
    .io_cfg_hsync       (bufferCC_45_io_dataOut[11:0]                       ), //i
    .io_cfg_hback       (bufferCC_46_io_dataOut[11:0]                       ), //i
    .io_cfg_hdisp       (bufferCC_47_io_dataOut[11:0]                       ), //i
    .io_cfg_htotal      (bufferCC_48_io_dataOut[11:0]                       ), //i
    .io_cfg_vspol       (bufferCC_44_io_dataOut                             ), //i
    .io_cfg_hspol       (bufferCC_49_io_dataOut                             ), //i
    .io_cfg_depol       (bufferCC_39_io_dataOut                             ), //i
    .io_cfg_pcpol       (bufferCC_38_io_dataOut                             ), //i
    .io_pixel_valid     (layerDma_io_frame_translated_haltWhen_valid        ), //i
    .io_pixel_ready     (dvt_io_pixel_ready                                 ), //o
    .io_pixel_payload   (layerDma_io_frame_translated_haltWhen_payload[15:0]), //i
    .io_pos_x           (dvt_io_pos_x[15:0]                                 ), //o
    .io_pos_y           (dvt_io_pos_y[15:0]                                 ), //o
    .io_dvti_vs         (dvt_io_dvti_vs                                     ), //o
    .io_dvti_hs         (dvt_io_dvti_hs                                     ), //o
    .io_dvti_de         (dvt_io_dvti_de                                     ), //o
    .io_dvti_data       (dvt_io_dvti_data[15:0]                             ), //o
    .io_hen             (dvt_io_hen                                         ), //o
    .io_ven             (dvt_io_ven                                         ), //o
    .clkout             (clkout_1                                           ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 bufferCC_37 (
    .io_dataIn          (bufferCC_37_io_dataIn ), //i
    .io_dataOut         (bufferCC_37_io_dataOut), //o
    .clkout             (clkout_1              ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 bufferCC_38 (
    .io_dataIn          (bufferCC_38_io_dataIn ), //i
    .io_dataOut         (bufferCC_38_io_dataOut), //o
    .clkout             (clkout_1              ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 bufferCC_39 (
    .io_dataIn          (bufferCC_39_io_dataIn ), //i
    .io_dataOut         (bufferCC_39_io_dataOut), //o
    .clkout             (clkout_1              ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_40 (
    .io_dataIn          (bufferCC_40_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_40_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_41 (
    .io_dataIn          (bufferCC_41_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_41_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_42 (
    .io_dataIn          (bufferCC_42_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_42_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_43 (
    .io_dataIn          (bufferCC_43_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_43_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 bufferCC_44 (
    .io_dataIn          (bufferCC_44_io_dataIn ), //i
    .io_dataOut         (bufferCC_44_io_dataOut), //o
    .clkout             (clkout_1              ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_45 (
    .io_dataIn          (bufferCC_45_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_45_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_46 (
    .io_dataIn          (bufferCC_46_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_46_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_47 (
    .io_dataIn          (bufferCC_47_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_47_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_19 bufferCC_48 (
    .io_dataIn          (bufferCC_48_io_dataIn[11:0] ), //i
    .io_dataOut         (bufferCC_48_io_dataOut[11:0]), //o
    .clkout             (clkout_1                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 bufferCC_49 (
    .io_dataIn          (bufferCC_49_io_dataIn ), //i
    .io_dataOut         (bufferCC_49_io_dataOut), //o
    .clkout             (clkout_1              ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 bufferCC_50 (
    .io_dataIn          (bufferCC_50_io_dataIn ), //i
    .io_dataOut         (bufferCC_50_io_dataOut), //o
    .clkout             (clkout_1              ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_6 dvt_io_pos_x_buffercc (
    .io_dataIn          (dvt_io_pos_x[15:0]                    ), //i
    .io_dataOut         (dvt_io_pos_x_buffercc_io_dataOut[15:0]), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_6 dvt_io_pos_y_buffercc (
    .io_dataIn          (dvt_io_pos_y[15:0]                    ), //i
    .io_dataOut         (dvt_io_pos_y_buffercc_io_dataOut[15:0]), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 dvt_io_dvti_vs_buffercc (
    .io_dataIn          (dvt_io_dvti_vs                    ), //i
    .io_dataOut         (dvt_io_dvti_vs_buffercc_io_dataOut), //o
    .clkout             (clkout                            ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 dvt_io_dvti_hs_buffercc (
    .io_dataIn          (dvt_io_dvti_hs                    ), //i
    .io_dataOut         (dvt_io_dvti_hs_buffercc_io_dataOut), //o
    .clkout             (clkout                            ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 dvt_io_hen_buffercc (
    .io_dataIn          (dvt_io_hen                    ), //i
    .io_dataOut         (dvt_io_hen_buffercc_io_dataOut), //o
    .clkout             (clkout                        ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset            )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_16 dvt_io_ven_buffercc (
    .io_dataIn          (dvt_io_ven                    ), //i
    .io_dataOut         (dvt_io_ven_buffercc_io_dataOut), //o
    .clkout             (clkout                        ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset            )  //i
  );
  PulseCCByToggle dvtArea_frameStart_pulseCCByToggle (
    .io_pulseIn         (dvtArea_frameStart                            ), //i
    .io_pulseOut        (dvtArea_frameStart_pulseCCByToggle_io_pulseOut), //o
    .clkout             (clkout_1                                      ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                            ), //i
    .clkout_1           (clkout                                        )  //i
  );
  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      10'h008 : begin
        io_apb_PRDATA[31 : 0] = SSCR;
      end
      10'h00c : begin
        io_apb_PRDATA[31 : 0] = BPCR;
      end
      10'h010 : begin
        io_apb_PRDATA[31 : 0] = AWCR;
      end
      10'h014 : begin
        io_apb_PRDATA[31 : 0] = TWCR;
      end
      10'h018 : begin
        io_apb_PRDATA[31 : 0] = GCR;
      end
      10'h024 : begin
        io_apb_PRDATA[31 : 0] = SRCR;
      end
      10'h02c : begin
        io_apb_PRDATA[31 : 0] = BCCR;
      end
      10'h034 : begin
        io_apb_PRDATA[31 : 0] = IER;
      end
      10'h038 : begin
        io_apb_PRDATA[31 : 0] = ISR;
      end
      10'h040 : begin
        io_apb_PRDATA[31 : 0] = LIPCR;
      end
      10'h044 : begin
        io_apb_PRDATA[31 : 0] = CPSR;
      end
      10'h048 : begin
        io_apb_PRDATA[31 : 0] = CDSR;
      end
      10'h084 : begin
        io_apb_PRDATA[31 : 0] = CR;
      end
      10'h088 : begin
        io_apb_PRDATA[31 : 0] = WHPCR;
      end
      10'h08c : begin
        io_apb_PRDATA[31 : 0] = WVPCR;
      end
      10'h090 : begin
        io_apb_PRDATA[31 : 0] = CKCR;
      end
      10'h094 : begin
        io_apb_PRDATA[31 : 0] = PFCR;
      end
      10'h098 : begin
        io_apb_PRDATA[31 : 0] = CACR;
      end
      10'h09c : begin
        io_apb_PRDATA[31 : 0] = DCCR;
      end
      10'h0a0 : begin
        io_apb_PRDATA[31 : 0] = BFCR;
      end
      10'h0ac : begin
        io_apb_PRDATA[31 : 0] = CFBAR;
      end
      10'h0b0 : begin
        io_apb_PRDATA[31 : 0] = CFBLR;
      end
      10'h0b4 : begin
        io_apb_PRDATA[31 : 0] = CFBLNR;
      end
      10'h0c4 : begin
        io_apb_PRDATA[31 : 0] = CLUTWR;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign bufferCC_37_io_dataIn = GCR[0];
  assign bufferCC_38_io_dataIn = GCR[28];
  assign bufferCC_39_io_dataIn = GCR[29];
  assign bufferCC_40_io_dataIn = SSCR[11 : 0];
  assign bufferCC_41_io_dataIn = BPCR[11 : 0];
  assign bufferCC_42_io_dataIn = AWCR[11 : 0];
  assign bufferCC_43_io_dataIn = TWCR[11 : 0];
  assign bufferCC_44_io_dataIn = GCR[30];
  assign bufferCC_45_io_dataIn = SSCR[27 : 16];
  assign bufferCC_46_io_dataIn = BPCR[27 : 16];
  assign bufferCC_47_io_dataIn = AWCR[27 : 16];
  assign bufferCC_48_io_dataIn = TWCR[27 : 16];
  assign bufferCC_49_io_dataIn = GCR[31];
  assign _zz_dvtArea_frameStart = (dvt_io_dvti_vs && (! dvt_io_dvti_vs_regNext_1));
  assign dvtArea_frameStart = (bufferCC_44_io_dataOut ? (dvt_io_dvti_vs && (! dvt_io_dvti_vs_regNext)) : ((! _zz_dvtArea_frameStart) && _zz_dvtArea_frameStart_1));
  assign layerDma_io_frame_fire = (layerDma_io_frame_valid && layerDma_io_frame_ready);
  assign when_Apb3Dvtc_l262 = (layerDma_io_frame_fire && layerDma_io_frame_payload_first);
  assign when_Apb3Dvtc_l267 = (layerDma_io_frame_fire && layerDma_io_frame_payload_last);
  assign when_Apb3Dvtc_l271 = ((! dvtArea_waitStartOfFrame) && (! dvtArea_error));
  assign when_Apb3Dvtc_l272 = ((dvtArea_firstPixel && layerDma_io_frame_valid) && (! layerDma_io_frame_payload_first));
  assign layerDma_io_frame_translated_valid = layerDma_io_frame_valid;
  always @(*) begin
    layerDma_io_frame_ready = layerDma_io_frame_translated_ready;
    if(when_Apb3Dvtc_l296) begin
      layerDma_io_frame_ready = 1'b1;
    end
  end

  assign layerDma_io_frame_translated_payload = layerDma_io_frame_payload_fragment;
  assign _zz_layerDma_io_frame_translated_ready = (! (dvtArea_waitStartOfFrame && (! dvtArea_error)));
  assign layerDma_io_frame_translated_haltWhen_valid = (layerDma_io_frame_translated_valid && _zz_layerDma_io_frame_translated_ready);
  assign layerDma_io_frame_translated_ready = (layerDma_io_frame_translated_haltWhen_ready && _zz_layerDma_io_frame_translated_ready);
  assign layerDma_io_frame_translated_haltWhen_payload = layerDma_io_frame_translated_payload;
  assign layerDma_io_frame_translated_haltWhen_ready = dvt_io_pixel_ready;
  assign bufferCC_50_io_dataIn = (! CR[0]);
  assign when_Apb3Dvtc_l296 = bufferCC_50_io_dataOut;
  assign pos_x_sync = dvt_io_pos_x_buffercc_io_dataOut;
  assign pos_y_sync = dvt_io_pos_y_buffercc_io_dataOut;
  assign vs_sync = dvt_io_dvti_vs_buffercc_io_dataOut;
  assign hs_sync = dvt_io_dvti_hs_buffercc_io_dataOut;
  assign hen_sync = dvt_io_hen_buffercc_io_dataOut;
  assign ven_sync = dvt_io_ven_buffercc_io_dataOut;
  assign vs_rise = (GCR[30] ? (vs_sync && (! vs_sync_regNext)) : ((! vs_sync) && vs_sync_regNext_1));
  assign hs_rise = (GCR[31] ? (hs_sync && (! hs_sync_regNext)) : ((! hs_sync) && hs_sync_regNext_1));
  assign line_match = ((pos_y_sync == _zz_line_match) && hs_rise);
  assign when_Apb3Dvtc_l316 = (line_match && IER[0]);
  assign io_axi_ar_valid = layerDma_io_mem_cmd_valid;
  assign io_axi_ar_payload_addr = ({5'd0,layerDma_io_mem_cmd_payload} <<< 3'd5);
  assign io_axi_ar_payload_len = 8'h07;
  assign io_axi_ar_payload_size = 3'b010;
  assign io_axi_ar_payload_cache = 4'b1111;
  assign io_axi_ar_payload_prot = 3'b010;
  assign io_axi_r_ready = 1'b1;
  assign layerDma_io_base = (CFBAR >>> 3'd5);
  assign layerDma_io_size = _zz_io_size[17:0];
  assign layerDma_io_start = (dvtArea_frameStart_pulseCCByToggle_io_pulseOut && CR[0]);
  assign io_dvti_vs = dvt_io_dvti_vs;
  assign io_dvti_hs = dvt_io_dvti_hs;
  assign io_dvti_de = dvt_io_dvti_de;
  assign io_dvti_data = dvt_io_dvti_data;
  assign io_interrupt = (|(ISR & IER));
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      SSCR <= 32'h0;
      BPCR <= 32'h0;
      AWCR <= 32'h0;
      TWCR <= 32'h0;
      GCR <= 32'h0;
      SRCR <= 32'h0;
      BCCR <= 32'h0;
      IER <= 32'h0;
      ISR <= 32'h0;
      ICR <= 32'h0;
      LIPCR <= 32'h0;
      CPSR <= 32'h0;
      CDSR <= 32'h0;
      CR <= 32'h0;
      WHPCR <= 32'h0;
      WVPCR <= 32'h0;
      CKCR <= 32'h0;
      PFCR <= 32'h0;
      CACR <= 32'h0;
      DCCR <= 32'h0;
      BFCR <= 32'h0;
      CFBAR <= 32'h0;
      CFBLR <= 32'h0;
      CFBLNR <= 32'h0;
      CLUTWR <= 32'h0;
    end else begin
      CPSR <= {pos_x_sync,pos_y_sync};
      CDSR <= {{{{28'h0,vs_sync},hs_sync},hen_sync},ven_sync};
      if(when_Apb3Dvtc_l316) begin
        ISR[0] <= 1'b1;
      end
      case(io_apb_PADDR)
        10'h008 : begin
          if(ctrl_doWrite) begin
            SSCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h00c : begin
          if(ctrl_doWrite) begin
            BPCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h010 : begin
          if(ctrl_doWrite) begin
            AWCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h014 : begin
          if(ctrl_doWrite) begin
            TWCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h018 : begin
          if(ctrl_doWrite) begin
            GCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h024 : begin
          if(ctrl_doWrite) begin
            SRCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h02c : begin
          if(ctrl_doWrite) begin
            BCCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h034 : begin
          if(ctrl_doWrite) begin
            IER <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h03c : begin
          if(ctrl_doWrite) begin
            ICR <= io_apb_PWDATA[31 : 0];
            ISR <= (ISR & (~ io_apb_PWDATA));
          end
        end
        10'h040 : begin
          if(ctrl_doWrite) begin
            LIPCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h084 : begin
          if(ctrl_doWrite) begin
            CR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h088 : begin
          if(ctrl_doWrite) begin
            WHPCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h08c : begin
          if(ctrl_doWrite) begin
            WVPCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h090 : begin
          if(ctrl_doWrite) begin
            CKCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h094 : begin
          if(ctrl_doWrite) begin
            PFCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h098 : begin
          if(ctrl_doWrite) begin
            CACR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h09c : begin
          if(ctrl_doWrite) begin
            DCCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h0a0 : begin
          if(ctrl_doWrite) begin
            BFCR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h0ac : begin
          if(ctrl_doWrite) begin
            CFBAR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h0b0 : begin
          if(ctrl_doWrite) begin
            CFBLR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h0b4 : begin
          if(ctrl_doWrite) begin
            CFBLNR <= io_apb_PWDATA[31 : 0];
          end
        end
        10'h0c4 : begin
          if(ctrl_doWrite) begin
            CLUTWR <= io_apb_PWDATA[31 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @(posedge clkout_1) begin
    dvt_io_dvti_vs_regNext <= dvt_io_dvti_vs;
    dvt_io_dvti_vs_regNext_1 <= dvt_io_dvti_vs;
    _zz_dvtArea_frameStart_1 <= _zz_dvtArea_frameStart;
    if(dvtArea_frameStart) begin
      dvtArea_firstPixel <= 1'b1;
    end
    if(when_Apb3Dvtc_l262) begin
      dvtArea_firstPixel <= 1'b0;
    end
  end

  always @(posedge clkout_1 or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      dvtArea_error <= 1'b0;
      dvtArea_waitStartOfFrame <= 1'b0;
      layerDma_io_frame_payload_first <= 1'b1;
    end else begin
      if(layerDma_io_frame_fire) begin
        layerDma_io_frame_payload_first <= layerDma_io_frame_payload_last;
      end
      if(dvtArea_frameStart) begin
        dvtArea_waitStartOfFrame <= 1'b0;
      end
      if(when_Apb3Dvtc_l267) begin
        dvtArea_error <= 1'b0;
        dvtArea_waitStartOfFrame <= dvtArea_error;
      end
      if(when_Apb3Dvtc_l271) begin
        if(when_Apb3Dvtc_l272) begin
          dvtArea_error <= 1'b1;
        end
      end
    end
  end

  always @(posedge clkout) begin
    vs_sync_regNext <= vs_sync;
    vs_sync_regNext_1 <= vs_sync;
    hs_sync_regNext <= hs_sync;
    hs_sync_regNext_1 <= hs_sync;
  end


endmodule

//Apb3Router_3 replaced by Apb3Router

//Apb3Decoder_3 replaced by Apb3Decoder

//ApbUart_1 replaced by ApbUart

module ApbUart (
  input  wire [4:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_uart_txd,
  input  wire          io_uart_rxd,
  output wire          io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;

  reg                 txFifo_io_push_valid;
  wire       [8:0]    txFifo_io_push_payload;
  reg                 rxFifo_io_pop_ready;
  wire                tx_io_write_ready;
  wire                tx_io_txd;
  wire                rx_io_read_valid;
  wire       [8:0]    rx_io_read_payload;
  wire                rx_io_rts;
  wire                rx_io_error;
  wire                rx_io_break;
  wire                txFifo_io_push_ready;
  wire                txFifo_io_pop_valid;
  wire       [8:0]    txFifo_io_pop_payload;
  wire       [4:0]    txFifo_io_occupancy;
  wire       [4:0]    txFifo_io_availability;
  wire                rxFifo_io_push_ready;
  wire                rxFifo_io_pop_valid;
  wire       [8:0]    rxFifo_io_pop_payload;
  wire       [4:0]    rxFifo_io_occupancy;
  wire       [4:0]    rxFifo_io_availability;
  wire       [11:0]   _zz_clockDivider_counter;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [15:0]   CR1;
  reg        [15:0]   CR2;
  reg        [15:0]   CR3;
  reg        [15:0]   GTPR;
  reg        [15:0]   BRR;
  wire       [15:0]   DR;
  reg        [15:0]   SR;
  wire       [3:0]    frame_dataLength;
  wire       [0:0]    frame_stop;
  wire       [1:0]    frame_parity;
  wire       [1:0]    _zz_frame_parity;
  wire       [1:0]    _zz_frame_parity_1;
  wire       [0:0]    _zz_frame_stop;
  wire       [0:0]    _zz_frame_stop_1;
  reg        [19:0]   clockDivider_counter;
  wire                clockDivider_tick;
  reg                 clockDivider_tickReg;
  wire                rxneInterrupt;
  wire                txeInterrupt;
  wire                tcInterrupt;
  wire                peInterrupt;
  wire                feInterrupt;
  `ifndef SYNTHESIS
  reg [23:0] frame_stop_string;
  reg [31:0] frame_parity_string;
  reg [31:0] _zz_frame_parity_string;
  reg [31:0] _zz_frame_parity_1_string;
  reg [23:0] _zz_frame_stop_string;
  reg [23:0] _zz_frame_stop_1_string;
  `endif


  assign _zz_clockDivider_counter = BRR[15 : 4];
  UartCtrlTx tx (
    .io_configFrame_dataLength (frame_dataLength[3:0]     ), //i
    .io_configFrame_stop       (frame_stop                ), //i
    .io_configFrame_parity     (frame_parity[1:0]         ), //i
    .io_samplingTick           (clockDivider_tickReg      ), //i
    .io_write_valid            (txFifo_io_pop_valid       ), //i
    .io_write_ready            (tx_io_write_ready         ), //o
    .io_write_payload          (txFifo_io_pop_payload[8:0]), //i
    .io_cts                    (1'b0                      ), //i
    .io_txd                    (tx_io_txd                 ), //o
    .io_break                  (1'b0                      ), //i
    .clkout                    (clkout                    ), //i
    .resetCtrl_axiReset        (resetCtrl_axiReset        )  //i
  );
  UartCtrlRx rx (
    .io_configFrame_dataLength (frame_dataLength[3:0]  ), //i
    .io_configFrame_stop       (frame_stop             ), //i
    .io_configFrame_parity     (frame_parity[1:0]      ), //i
    .io_samplingTick           (clockDivider_tickReg   ), //i
    .io_read_valid             (rx_io_read_valid       ), //o
    .io_read_ready             (rxFifo_io_push_ready   ), //i
    .io_read_payload           (rx_io_read_payload[8:0]), //o
    .io_rxd                    (io_uart_rxd            ), //i
    .io_rts                    (rx_io_rts              ), //o
    .io_error                  (rx_io_error            ), //o
    .io_break                  (rx_io_break            ), //o
    .clkout                    (clkout                 ), //i
    .resetCtrl_axiReset        (resetCtrl_axiReset     )  //i
  );
  StreamFifo txFifo (
    .io_push_valid      (txFifo_io_push_valid       ), //i
    .io_push_ready      (txFifo_io_push_ready       ), //o
    .io_push_payload    (txFifo_io_push_payload[8:0]), //i
    .io_pop_valid       (txFifo_io_pop_valid        ), //o
    .io_pop_ready       (tx_io_write_ready          ), //i
    .io_pop_payload     (txFifo_io_pop_payload[8:0] ), //o
    .io_flush           (1'b0                       ), //i
    .io_occupancy       (txFifo_io_occupancy[4:0]   ), //o
    .io_availability    (txFifo_io_availability[4:0]), //o
    .clkout             (clkout                     ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset         )  //i
  );
  StreamFifo rxFifo (
    .io_push_valid      (rx_io_read_valid           ), //i
    .io_push_ready      (rxFifo_io_push_ready       ), //o
    .io_push_payload    (rx_io_read_payload[8:0]    ), //i
    .io_pop_valid       (rxFifo_io_pop_valid        ), //o
    .io_pop_ready       (rxFifo_io_pop_ready        ), //i
    .io_pop_payload     (rxFifo_io_pop_payload[8:0] ), //o
    .io_flush           (1'b0                       ), //i
    .io_occupancy       (rxFifo_io_occupancy[4:0]   ), //o
    .io_availability    (rxFifo_io_availability[4:0]), //o
    .clkout             (clkout                     ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset         )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(frame_stop)
      UartStopType_ONE : frame_stop_string = "ONE";
      UartStopType_TWO : frame_stop_string = "TWO";
      default : frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(frame_parity)
      UartParityType_NONE : frame_parity_string = "NONE";
      UartParityType_EVEN : frame_parity_string = "EVEN";
      UartParityType_ODD : frame_parity_string = "ODD ";
      default : frame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_frame_parity)
      UartParityType_NONE : _zz_frame_parity_string = "NONE";
      UartParityType_EVEN : _zz_frame_parity_string = "EVEN";
      UartParityType_ODD : _zz_frame_parity_string = "ODD ";
      default : _zz_frame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_frame_parity_1)
      UartParityType_NONE : _zz_frame_parity_1_string = "NONE";
      UartParityType_EVEN : _zz_frame_parity_1_string = "EVEN";
      UartParityType_ODD : _zz_frame_parity_1_string = "ODD ";
      default : _zz_frame_parity_1_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_frame_stop)
      UartStopType_ONE : _zz_frame_stop_string = "ONE";
      UartStopType_TWO : _zz_frame_stop_string = "TWO";
      default : _zz_frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_frame_stop_1)
      UartStopType_ONE : _zz_frame_stop_1_string = "ONE";
      UartStopType_TWO : _zz_frame_stop_1_string = "TWO";
      default : _zz_frame_stop_1_string = "???";
    endcase
  end
  `endif

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      5'h04 : begin
        if(ctrl_doRead) begin
          io_apb_PRDATA[8 : 0] = rxFifo_io_pop_payload;
        end
      end
      5'h0 : begin
        io_apb_PRDATA[15 : 0] = SR;
      end
      5'h08 : begin
        io_apb_PRDATA[15 : 0] = BRR;
      end
      5'h0c : begin
        io_apb_PRDATA[15 : 0] = CR1;
      end
      5'h10 : begin
        io_apb_PRDATA[15 : 0] = CR2;
      end
      5'h14 : begin
        io_apb_PRDATA[15 : 0] = CR3;
      end
      5'h18 : begin
        io_apb_PRDATA[15 : 0] = GTPR;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign io_uart_txd = tx_io_txd;
  assign DR = 16'h0;
  assign frame_dataLength = (CR1[12] ? 4'b1000 : 4'b0111);
  assign _zz_frame_parity_1 = CR1[10 : 9];
  assign _zz_frame_parity = _zz_frame_parity_1;
  assign frame_parity = _zz_frame_parity;
  assign _zz_frame_stop_1 = CR2[13];
  assign _zz_frame_stop = _zz_frame_stop_1;
  assign frame_stop = _zz_frame_stop;
  assign clockDivider_tick = (clockDivider_counter == 20'h0);
  assign rxneInterrupt = (CR1[5] && SR[5]);
  assign txeInterrupt = (CR1[7] && SR[7]);
  assign tcInterrupt = (CR1[6] && SR[6]);
  assign peInterrupt = (CR1[8] && SR[1]);
  assign feInterrupt = (CR1[4] && SR[3]);
  assign io_interrupt = ((((rxneInterrupt || txeInterrupt) || tcInterrupt) || peInterrupt) || feInterrupt);
  always @(*) begin
    txFifo_io_push_valid = 1'b0;
    case(io_apb_PADDR)
      5'h04 : begin
        if(ctrl_doWrite) begin
          txFifo_io_push_valid = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign txFifo_io_push_payload = io_apb_PWDATA[8 : 0];
  always @(*) begin
    rxFifo_io_pop_ready = 1'b0;
    case(io_apb_PADDR)
      5'h04 : begin
        if(ctrl_doRead) begin
          rxFifo_io_pop_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      CR1 <= 16'h0;
      CR2 <= 16'h0;
      CR3 <= 16'h0;
      GTPR <= 16'h0;
      BRR <= 16'h0;
      SR <= 16'h0;
      clockDivider_counter <= 20'h0;
      clockDivider_tickReg <= 1'b0;
    end else begin
      SR <= 16'h0;
      SR[7] <= txFifo_io_push_ready;
      SR[6] <= (txFifo_io_availability != 5'h0);
      SR[5] <= (rxFifo_io_occupancy != 5'h0);
      SR[3] <= rx_io_error;
      clockDivider_tickReg <= clockDivider_tick;
      clockDivider_counter <= (clockDivider_counter - 20'h00001);
      if(clockDivider_tick) begin
        clockDivider_counter <= {8'd0, _zz_clockDivider_counter};
      end
      case(io_apb_PADDR)
        5'h08 : begin
          if(ctrl_doWrite) begin
            BRR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h0c : begin
          if(ctrl_doWrite) begin
            CR1 <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h10 : begin
          if(ctrl_doWrite) begin
            CR2 <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h14 : begin
          if(ctrl_doWrite) begin
            CR3 <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h18 : begin
          if(ctrl_doWrite) begin
            GTPR <= io_apb_PWDATA[15 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Apb3Router_2 (
  input  wire [12:0]   io_input_PADDR,
  input  wire [1:0]    io_input_PSEL,
  input  wire          io_input_PENABLE,
  output wire          io_input_PREADY,
  input  wire          io_input_PWRITE,
  input  wire [31:0]   io_input_PWDATA,
  output wire [31:0]   io_input_PRDATA,
  output wire          io_input_PSLVERROR,
  output wire [12:0]   io_outputs_0_PADDR,
  output wire [0:0]    io_outputs_0_PSEL,
  output wire          io_outputs_0_PENABLE,
  input  wire          io_outputs_0_PREADY,
  output wire          io_outputs_0_PWRITE,
  output wire [31:0]   io_outputs_0_PWDATA,
  input  wire [31:0]   io_outputs_0_PRDATA,
  input  wire          io_outputs_0_PSLVERROR,
  output wire [12:0]   io_outputs_1_PADDR,
  output wire [0:0]    io_outputs_1_PSEL,
  output wire          io_outputs_1_PENABLE,
  input  wire          io_outputs_1_PREADY,
  output wire          io_outputs_1_PWRITE,
  output wire [31:0]   io_outputs_1_PWDATA,
  input  wire [31:0]   io_outputs_1_PRDATA,
  input  wire          io_outputs_1_PSLVERROR,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  reg                 _zz_io_input_PREADY;
  reg        [31:0]   _zz_io_input_PRDATA;
  reg                 _zz_io_input_PSLVERROR;
  wire                _zz_selIndex;
  reg        [0:0]    selIndex;

  always @(*) begin
    case(selIndex)
      1'b0 : begin
        _zz_io_input_PREADY = io_outputs_0_PREADY;
        _zz_io_input_PRDATA = io_outputs_0_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_0_PSLVERROR;
      end
      default : begin
        _zz_io_input_PREADY = io_outputs_1_PREADY;
        _zz_io_input_PRDATA = io_outputs_1_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_1_PSLVERROR;
      end
    endcase
  end

  assign io_outputs_0_PADDR = io_input_PADDR;
  assign io_outputs_0_PENABLE = io_input_PENABLE;
  assign io_outputs_0_PSEL[0] = io_input_PSEL[0];
  assign io_outputs_0_PWRITE = io_input_PWRITE;
  assign io_outputs_0_PWDATA = io_input_PWDATA;
  assign io_outputs_1_PADDR = io_input_PADDR;
  assign io_outputs_1_PENABLE = io_input_PENABLE;
  assign io_outputs_1_PSEL[0] = io_input_PSEL[1];
  assign io_outputs_1_PWRITE = io_input_PWRITE;
  assign io_outputs_1_PWDATA = io_input_PWDATA;
  assign _zz_selIndex = io_input_PSEL[1];
  assign io_input_PREADY = _zz_io_input_PREADY;
  assign io_input_PRDATA = _zz_io_input_PRDATA;
  assign io_input_PSLVERROR = _zz_io_input_PSLVERROR;
  always @(posedge clkout) begin
    selIndex <= _zz_selIndex;
  end


endmodule

//Apb3Decoder_2 replaced by Apb3Decoder

module Apb3Wwdg (
  input  wire [4:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_rst,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  wire       [14:0]   _zz_prescalerMax;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [7:0]    CR;
  reg        [15:0]   CFR;
  reg        [31:0]   SR;
  wire                WDGA;
  wire       [6:0]    W;
  wire                EWI;
  reg                 EWIF;
  wire       [1:0]    WDGTB;
  reg                 rstReg;
  reg        [6:0]    counter;
  wire       [14:0]   prescalerMax;
  reg        [14:0]   prescalerCounter;
  wire                tick;
  wire                when_apb3wdg_l138;
  wire       [6:0]    _zz_CR;
  wire                when_apb3wdg_l115;

  assign _zz_prescalerMax = (15'h1000 <<< WDGTB);
  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      5'h04 : begin
        io_apb_PRDATA[15 : 0] = CFR;
      end
      5'h08 : begin
        io_apb_PRDATA[31 : 0] = SR;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign WDGA = (CR[7] == 1'b1);
  assign W = CFR[6 : 0];
  assign EWI = CFR[9];
  assign WDGTB = CFR[8 : 7];
  assign io_rst = rstReg;
  assign prescalerMax = (_zz_prescalerMax - 15'h0001);
  assign tick = (prescalerCounter == prescalerMax);
  assign when_apb3wdg_l138 = (counter == 7'h0);
  assign _zz_CR = io_apb_PWDATA[6 : 0];
  assign when_apb3wdg_l115 = (_zz_CR < W);
  always @(posedge clkout or posedge resetCtrl_coreReset) begin
    if(resetCtrl_coreReset) begin
      CR <= 8'h0;
      CFR <= 16'h0;
      SR <= 32'h0;
      EWIF <= 1'b0;
      rstReg <= 1'b0;
      counter <= 7'h7f;
      prescalerCounter <= 15'h0;
    end else begin
      SR <= {EWIF,31'h0};
      if(WDGA) begin
        prescalerCounter <= (prescalerCounter + 15'h0001);
        if(tick) begin
          prescalerCounter <= 15'h0;
          if(when_apb3wdg_l138) begin
            rstReg <= 1'b1;
          end else begin
            counter <= (counter - 7'h01);
            rstReg <= 1'b0;
          end
        end
      end else begin
        prescalerCounter <= 15'h0;
        rstReg <= 1'b0;
      end
      case(io_apb_PADDR)
        5'h0 : begin
          if(ctrl_doWrite) begin
            CR <= (((CR & 8'h80) | {1'b0,_zz_CR}) | {io_apb_PWDATA[7],7'h0});
            if(when_apb3wdg_l115) begin
              counter <= _zz_CR;
              EWIF <= 1'b0;
            end
          end
        end
        5'h04 : begin
          if(ctrl_doWrite) begin
            CFR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h08 : begin
          if(ctrl_doWrite) begin
            SR <= io_apb_PWDATA[31 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Apb3Iwdg (
  input  wire [3:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_rst,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  wire       [7:0]    _zz_prescalerMax;
  wire       [2:0]    _zz_prescalerMax_1;
  wire       [31:0]   _zz_io_apb_PRDATA;
  wire       [31:0]   _zz_io_apb_PRDATA_1;
  wire       [31:0]   _zz_io_apb_PRDATA_2;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [2:0]    PR;
  reg        [11:0]   RLR;
  reg        [2:0]    SR;
  reg                 enable;
  reg                 rstReg;
  reg        [11:0]   counter;
  reg        [7:0]    prescalerCounter;
  wire       [7:0]    prescalerMax;
  wire                tick;
  wire                when_apb3wdg_l75;
  wire       [31:0]   switch_apb3wdg_l29;
  wire                when_apb3wdg_l44;
  wire                when_apb3wdg_l53;

  assign _zz_prescalerMax = (8'h01 <<< _zz_prescalerMax_1);
  assign _zz_prescalerMax_1 = (PR + 3'b010);
  assign _zz_io_apb_PRDATA = {29'd0, PR};
  assign _zz_io_apb_PRDATA_1 = {20'd0, RLR};
  assign _zz_io_apb_PRDATA_2 = {29'd0, SR};
  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      4'b0100 : begin
        io_apb_PRDATA[31 : 0] = _zz_io_apb_PRDATA;
      end
      4'b1000 : begin
        io_apb_PRDATA[31 : 0] = _zz_io_apb_PRDATA_1;
      end
      4'b1100 : begin
        io_apb_PRDATA[31 : 0] = _zz_io_apb_PRDATA_2;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign io_rst = rstReg;
  assign prescalerMax = (_zz_prescalerMax - 8'h01);
  assign tick = (prescalerCounter == prescalerMax);
  assign when_apb3wdg_l75 = (counter == 12'h0);
  assign switch_apb3wdg_l29 = io_apb_PWDATA;
  assign when_apb3wdg_l44 = SR[0];
  assign when_apb3wdg_l53 = SR[1];
  always @(posedge clkout or posedge resetCtrl_coreReset) begin
    if(resetCtrl_coreReset) begin
      PR <= 3'b000;
      RLR <= 12'hfff;
      SR <= 3'b000;
      enable <= 1'b0;
      rstReg <= 1'b0;
      counter <= 12'h0;
      prescalerCounter <= 8'h0;
    end else begin
      if(enable) begin
        prescalerCounter <= (prescalerCounter + 8'h01);
        if(tick) begin
          prescalerCounter <= 8'h0;
          if(when_apb3wdg_l75) begin
            rstReg <= 1'b1;
          end else begin
            counter <= (counter - 12'h001);
            rstReg <= 1'b0;
          end
        end
      end else begin
        prescalerCounter <= 8'h0;
        rstReg <= 1'b0;
      end
      case(io_apb_PADDR)
        4'b0000 : begin
          if(ctrl_doWrite) begin
            case(switch_apb3wdg_l29)
              32'h0000cccc : begin
                enable <= 1'b1;
              end
              32'h0000aaaa : begin
                counter <= RLR;
              end
              32'h00005555 : begin
                SR <= 3'b011;
              end
              default : begin
              end
            endcase
          end
        end
        4'b0100 : begin
          if(ctrl_doWrite) begin
            if(when_apb3wdg_l44) begin
              PR <= io_apb_PWDATA[2 : 0];
              SR[0] <= 1'b0;
            end
          end
        end
        4'b1000 : begin
          if(ctrl_doWrite) begin
            if(when_apb3wdg_l53) begin
              RLR <= io_apb_PWDATA[11 : 0];
              SR[1] <= 1'b0;
            end
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

//Apb3Router_1 replaced by Apb3Router

//Apb3Decoder_1 replaced by Apb3Decoder

//Apb3Tim_1 replaced by Apb3Tim

module Apb3Tim (
  input  wire [6:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output reg  [3:0]    io_tim_ch,
  output wire          io_interrupt,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [15:0]   CR1;
  reg        [15:0]   CR2;
  reg        [15:0]   SMCR;
  reg        [15:0]   DIER;
  reg        [15:0]   SR;
  reg        [15:0]   EGR;
  reg        [15:0]   CCMR1;
  reg        [15:0]   CCMR2;
  reg        [15:0]   CCER;
  reg        [15:0]   CNT;
  reg        [15:0]   PSC;
  reg        [15:0]   ARR;
  reg        [15:0]   RCR;
  reg        [15:0]   CCR_0;
  reg        [15:0]   CCR_1;
  reg        [15:0]   CCR_2;
  reg        [15:0]   CCR_3;
  reg        [15:0]   BDTR;
  reg        [15:0]   DCR;
  reg        [15:0]   DMAR;
  wire                CEN;
  wire                DIR;
  wire       [1:0]    CMS;
  wire                ARPE;
  wire       [1:0]    CKD;
  wire       [2:0]    MMS;
  wire                UIE;
  wire                CC1IE;
  wire                CC2IE;
  wire                CC3IE;
  wire                CC4IE;
  wire                TIE;
  wire                UIF;
  wire                CC1IF;
  wire                CC2IF;
  wire                CC3IF;
  wire                CC4IF;
  wire                TIF;
  reg        [15:0]   prescaler;
  wire                when_apb3tim_l87;
  wire                when_apb3tim_l89;
  wire                when_apb3tim_l91;
  wire                when_apb3tim_l93;
  wire                when_apb3tim_l99;
  wire                when_apb3tim_l108;
  wire                when_apb3tim_l112;
  wire                when_apb3tim_l115;
  wire                when_apb3tim_l118;
  wire                when_apb3tim_l121;
  wire                when_apb3tim_l124;
  reg                 _zz_io_tim_ch;
  reg                 _zz_io_tim_ch_1;
  reg                 _zz_io_tim_ch_2;
  reg                 _zz_io_tim_ch_3;

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      7'h0 : begin
        io_apb_PRDATA[15 : 0] = CR1;
      end
      7'h04 : begin
        io_apb_PRDATA[15 : 0] = CR2;
      end
      7'h08 : begin
        io_apb_PRDATA[15 : 0] = SMCR;
      end
      7'h0c : begin
        io_apb_PRDATA[15 : 0] = DIER;
      end
      7'h10 : begin
        io_apb_PRDATA[15 : 0] = SR;
      end
      7'h14 : begin
        io_apb_PRDATA[15 : 0] = EGR;
      end
      7'h18 : begin
        io_apb_PRDATA[15 : 0] = CCMR1;
      end
      7'h1c : begin
        io_apb_PRDATA[15 : 0] = CCMR2;
      end
      7'h20 : begin
        io_apb_PRDATA[15 : 0] = CCER;
      end
      7'h24 : begin
        io_apb_PRDATA[15 : 0] = CNT;
      end
      7'h28 : begin
        io_apb_PRDATA[15 : 0] = PSC;
      end
      7'h2c : begin
        io_apb_PRDATA[15 : 0] = ARR;
      end
      7'h30 : begin
        io_apb_PRDATA[15 : 0] = RCR;
      end
      7'h34 : begin
        io_apb_PRDATA[15 : 0] = CCR_0;
      end
      7'h38 : begin
        io_apb_PRDATA[15 : 0] = CCR_1;
      end
      7'h3c : begin
        io_apb_PRDATA[15 : 0] = CCR_2;
      end
      7'h40 : begin
        io_apb_PRDATA[15 : 0] = CCR_3;
      end
      7'h44 : begin
        io_apb_PRDATA[15 : 0] = BDTR;
      end
      7'h48 : begin
        io_apb_PRDATA[15 : 0] = DCR;
      end
      7'h4c : begin
        io_apb_PRDATA[15 : 0] = DMAR;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign CEN = CR1[0];
  assign DIR = CR1[4];
  assign CMS = CR1[6 : 5];
  assign ARPE = CR1[7];
  assign CKD = CR1[9 : 8];
  assign MMS = CR2[6 : 4];
  assign UIE = DIER[0];
  assign CC1IE = DIER[1];
  assign CC2IE = DIER[2];
  assign CC3IE = DIER[3];
  assign CC4IE = DIER[4];
  assign TIE = DIER[6];
  assign UIF = SR[0];
  assign CC1IF = SR[1];
  assign CC2IF = SR[2];
  assign CC3IF = SR[3];
  assign CC4IF = SR[4];
  assign TIF = SR[6];
  assign when_apb3tim_l87 = (CEN == 1'b1);
  assign when_apb3tim_l89 = (prescaler == PSC);
  assign when_apb3tim_l91 = (DIR == 1'b0);
  assign when_apb3tim_l93 = (CNT == ARR);
  assign when_apb3tim_l99 = (CNT == 16'h0);
  assign when_apb3tim_l108 = EGR[0];
  assign when_apb3tim_l112 = EGR[1];
  assign when_apb3tim_l115 = EGR[2];
  assign when_apb3tim_l118 = EGR[3];
  assign when_apb3tim_l121 = EGR[4];
  assign when_apb3tim_l124 = EGR[6];
  assign io_interrupt = (SR[0] && DIER[0]);
  always @(*) begin
    io_tim_ch[0] = _zz_io_tim_ch;
    io_tim_ch[1] = _zz_io_tim_ch_1;
    io_tim_ch[2] = _zz_io_tim_ch_2;
    io_tim_ch[3] = _zz_io_tim_ch_3;
  end

  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      CR1 <= 16'h0;
      CR2 <= 16'h0;
      SMCR <= 16'h0;
      DIER <= 16'h0;
      SR <= 16'h0;
      EGR <= 16'h0;
      CCMR1 <= 16'h0;
      CCMR2 <= 16'h0;
      CCER <= 16'h0;
      CNT <= 16'h0;
      PSC <= 16'h0;
      ARR <= 16'hffff;
      RCR <= 16'h0;
      CCR_0 <= 16'h0;
      CCR_1 <= 16'h0;
      CCR_2 <= 16'h0;
      CCR_3 <= 16'h0;
      BDTR <= 16'h0;
      DCR <= 16'h0;
      DMAR <= 16'h0;
      prescaler <= 16'h0;
      _zz_io_tim_ch <= 1'b0;
      _zz_io_tim_ch_1 <= 1'b0;
      _zz_io_tim_ch_2 <= 1'b0;
      _zz_io_tim_ch_3 <= 1'b0;
    end else begin
      if(when_apb3tim_l87) begin
        prescaler <= (prescaler + 16'h0001);
        if(when_apb3tim_l89) begin
          prescaler <= 16'h0;
          if(when_apb3tim_l91) begin
            CNT <= (CNT + 16'h0001);
            if(when_apb3tim_l93) begin
              CNT <= 16'h0;
              SR[0] <= 1'b1;
            end
          end else begin
            CNT <= (CNT - 16'h0001);
            if(when_apb3tim_l99) begin
              CNT <= ARR;
              SR[0] <= 1'b1;
            end
          end
        end
      end
      if(when_apb3tim_l108) begin
        CNT <= 16'h0;
        EGR <= 16'h0;
      end
      if(when_apb3tim_l112) begin
        EGR <= 16'h0;
      end
      if(when_apb3tim_l115) begin
        EGR <= 16'h0;
      end
      if(when_apb3tim_l118) begin
        EGR <= 16'h0;
      end
      if(when_apb3tim_l121) begin
        EGR <= 16'h0;
      end
      if(when_apb3tim_l124) begin
        EGR <= 16'h0;
      end
      _zz_io_tim_ch <= ((CNT < CCR_0) && CCER[0]);
      _zz_io_tim_ch_1 <= ((CNT < CCR_1) && CCER[1]);
      _zz_io_tim_ch_2 <= ((CNT < CCR_2) && CCER[2]);
      _zz_io_tim_ch_3 <= ((CNT < CCR_3) && CCER[3]);
      case(io_apb_PADDR)
        7'h0 : begin
          if(ctrl_doWrite) begin
            CR1 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h04 : begin
          if(ctrl_doWrite) begin
            CR2 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h08 : begin
          if(ctrl_doWrite) begin
            SMCR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h0c : begin
          if(ctrl_doWrite) begin
            DIER <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h10 : begin
          if(ctrl_doWrite) begin
            SR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h14 : begin
          if(ctrl_doWrite) begin
            EGR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h18 : begin
          if(ctrl_doWrite) begin
            CCMR1 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h1c : begin
          if(ctrl_doWrite) begin
            CCMR2 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h20 : begin
          if(ctrl_doWrite) begin
            CCER <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h28 : begin
          if(ctrl_doWrite) begin
            PSC <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h2c : begin
          if(ctrl_doWrite) begin
            ARR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h30 : begin
          if(ctrl_doWrite) begin
            RCR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h34 : begin
          if(ctrl_doWrite) begin
            CCR_0 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h38 : begin
          if(ctrl_doWrite) begin
            CCR_1 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h3c : begin
          if(ctrl_doWrite) begin
            CCR_2 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h40 : begin
          if(ctrl_doWrite) begin
            CCR_3 <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h44 : begin
          if(ctrl_doWrite) begin
            BDTR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h48 : begin
          if(ctrl_doWrite) begin
            DCR <= io_apb_PWDATA[15 : 0];
          end
        end
        7'h4c : begin
          if(ctrl_doWrite) begin
            DMAR <= io_apb_PWDATA[15 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Apb3Router (
  input  wire [12:0]   io_input_PADDR,
  input  wire [1:0]    io_input_PSEL,
  input  wire          io_input_PENABLE,
  output wire          io_input_PREADY,
  input  wire          io_input_PWRITE,
  input  wire [31:0]   io_input_PWDATA,
  output wire [31:0]   io_input_PRDATA,
  output wire          io_input_PSLVERROR,
  output wire [12:0]   io_outputs_0_PADDR,
  output wire [0:0]    io_outputs_0_PSEL,
  output wire          io_outputs_0_PENABLE,
  input  wire          io_outputs_0_PREADY,
  output wire          io_outputs_0_PWRITE,
  output wire [31:0]   io_outputs_0_PWDATA,
  input  wire [31:0]   io_outputs_0_PRDATA,
  input  wire          io_outputs_0_PSLVERROR,
  output wire [12:0]   io_outputs_1_PADDR,
  output wire [0:0]    io_outputs_1_PSEL,
  output wire          io_outputs_1_PENABLE,
  input  wire          io_outputs_1_PREADY,
  output wire          io_outputs_1_PWRITE,
  output wire [31:0]   io_outputs_1_PWDATA,
  input  wire [31:0]   io_outputs_1_PRDATA,
  input  wire          io_outputs_1_PSLVERROR,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 _zz_io_input_PREADY;
  reg        [31:0]   _zz_io_input_PRDATA;
  reg                 _zz_io_input_PSLVERROR;
  wire                _zz_selIndex;
  reg        [0:0]    selIndex;

  always @(*) begin
    case(selIndex)
      1'b0 : begin
        _zz_io_input_PREADY = io_outputs_0_PREADY;
        _zz_io_input_PRDATA = io_outputs_0_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_0_PSLVERROR;
      end
      default : begin
        _zz_io_input_PREADY = io_outputs_1_PREADY;
        _zz_io_input_PRDATA = io_outputs_1_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_1_PSLVERROR;
      end
    endcase
  end

  assign io_outputs_0_PADDR = io_input_PADDR;
  assign io_outputs_0_PENABLE = io_input_PENABLE;
  assign io_outputs_0_PSEL[0] = io_input_PSEL[0];
  assign io_outputs_0_PWRITE = io_input_PWRITE;
  assign io_outputs_0_PWDATA = io_input_PWDATA;
  assign io_outputs_1_PADDR = io_input_PADDR;
  assign io_outputs_1_PENABLE = io_input_PENABLE;
  assign io_outputs_1_PSEL[0] = io_input_PSEL[1];
  assign io_outputs_1_PWRITE = io_input_PWRITE;
  assign io_outputs_1_PWDATA = io_input_PWDATA;
  assign _zz_selIndex = io_input_PSEL[1];
  assign io_input_PREADY = _zz_io_input_PREADY;
  assign io_input_PRDATA = _zz_io_input_PRDATA;
  assign io_input_PSLVERROR = _zz_io_input_PSLVERROR;
  always @(posedge clkout) begin
    selIndex <= _zz_selIndex;
  end


endmodule

module Apb3Decoder (
  input  wire [12:0]   io_input_PADDR,
  input  wire [0:0]    io_input_PSEL,
  input  wire          io_input_PENABLE,
  output reg           io_input_PREADY,
  input  wire          io_input_PWRITE,
  input  wire [31:0]   io_input_PWDATA,
  output wire [31:0]   io_input_PRDATA,
  output reg           io_input_PSLVERROR,
  output wire [12:0]   io_output_PADDR,
  output reg  [1:0]    io_output_PSEL,
  output wire          io_output_PENABLE,
  input  wire          io_output_PREADY,
  output wire          io_output_PWRITE,
  output wire [31:0]   io_output_PWDATA,
  input  wire [31:0]   io_output_PRDATA,
  input  wire          io_output_PSLVERROR
);

  wire                when_Apb3Decoder_l88;

  assign io_output_PADDR = io_input_PADDR;
  assign io_output_PENABLE = io_input_PENABLE;
  assign io_output_PWRITE = io_input_PWRITE;
  assign io_output_PWDATA = io_input_PWDATA;
  always @(*) begin
    io_output_PSEL[0] = (((io_input_PADDR & (~ 13'h0fff)) == 13'h0) && io_input_PSEL[0]);
    io_output_PSEL[1] = (((io_input_PADDR & (~ 13'h0fff)) == 13'h1000) && io_input_PSEL[0]);
  end

  always @(*) begin
    io_input_PREADY = io_output_PREADY;
    if(when_Apb3Decoder_l88) begin
      io_input_PREADY = 1'b1;
    end
  end

  assign io_input_PRDATA = io_output_PRDATA;
  always @(*) begin
    io_input_PSLVERROR = io_output_PSLVERROR;
    if(when_Apb3Decoder_l88) begin
      io_input_PSLVERROR = 1'b1;
    end
  end

  assign when_Apb3Decoder_l88 = (io_input_PSEL[0] && (io_output_PSEL == 2'b00));

endmodule

//Apb3Gpio_1 replaced by Apb3Gpio

module Apb3Gpio (
  input  wire [4:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  input  wire [15:0]   io_gpio_read,
  output reg  [15:0]   io_gpio_write,
  output reg  [15:0]   io_gpio_writeEnable,
  input  wire [15:0]   io_afio,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire       [15:0]   io_gpio_read_buffercc_io_dataOut;
  wire                _zz__zz_CRL;
  wire                _zz__zz_CRL_1;
  wire       [3:0]    _zz__zz_CRL_2;
  wire       [3:0]    _zz__zz_CRL_3;
  wire       [3:0]    _zz__zz_CRL_4;
  wire       [7:0]    _zz__zz_CRL_5;
  wire                _zz__zz_CRH;
  wire                _zz__zz_CRH_1;
  wire       [3:0]    _zz__zz_CRH_2;
  wire       [3:0]    _zz__zz_CRH_3;
  wire       [3:0]    _zz__zz_CRH_4;
  wire       [3:0]    _zz__zz_CRH_5;
  wire       [7:0]    _zz__zz_CRH_6;
  wire       [15:0]   gpioInput;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [31:0]   CRL;
  reg        [31:0]   CRH;
  wire       [15:0]   IDR;
  reg        [15:0]   ODR;
  reg        [15:0]   LCKR;
  reg                 LCKK;
  wire       [1:0]    gpioCfg_0_mode;
  wire       [1:0]    gpioCfg_0_cnf;
  wire       [1:0]    gpioCfg_1_mode;
  wire       [1:0]    gpioCfg_1_cnf;
  wire       [1:0]    gpioCfg_2_mode;
  wire       [1:0]    gpioCfg_2_cnf;
  wire       [1:0]    gpioCfg_3_mode;
  wire       [1:0]    gpioCfg_3_cnf;
  wire       [1:0]    gpioCfg_4_mode;
  wire       [1:0]    gpioCfg_4_cnf;
  wire       [1:0]    gpioCfg_5_mode;
  wire       [1:0]    gpioCfg_5_cnf;
  wire       [1:0]    gpioCfg_6_mode;
  wire       [1:0]    gpioCfg_6_cnf;
  wire       [1:0]    gpioCfg_7_mode;
  wire       [1:0]    gpioCfg_7_cnf;
  wire       [1:0]    gpioCfg_8_mode;
  wire       [1:0]    gpioCfg_8_cnf;
  wire       [1:0]    gpioCfg_9_mode;
  wire       [1:0]    gpioCfg_9_cnf;
  wire       [1:0]    gpioCfg_10_mode;
  wire       [1:0]    gpioCfg_10_cnf;
  wire       [1:0]    gpioCfg_11_mode;
  wire       [1:0]    gpioCfg_11_cnf;
  wire       [1:0]    gpioCfg_12_mode;
  wire       [1:0]    gpioCfg_12_cnf;
  wire       [1:0]    gpioCfg_13_mode;
  wire       [1:0]    gpioCfg_13_cnf;
  wire       [1:0]    gpioCfg_14_mode;
  wire       [1:0]    gpioCfg_14_cnf;
  wire       [1:0]    gpioCfg_15_mode;
  wire       [1:0]    gpioCfg_15_cnf;
  wire       [3:0]    _zz_gpioCfg_0_mode;
  wire       [3:0]    _zz_gpioCfg_1_mode;
  wire       [3:0]    _zz_gpioCfg_2_mode;
  wire       [3:0]    _zz_gpioCfg_3_mode;
  wire       [3:0]    _zz_gpioCfg_4_mode;
  wire       [3:0]    _zz_gpioCfg_5_mode;
  wire       [3:0]    _zz_gpioCfg_6_mode;
  wire       [3:0]    _zz_gpioCfg_7_mode;
  wire       [3:0]    _zz_gpioCfg_8_mode;
  wire       [3:0]    _zz_gpioCfg_9_mode;
  wire       [3:0]    _zz_gpioCfg_10_mode;
  wire       [3:0]    _zz_gpioCfg_11_mode;
  wire       [3:0]    _zz_gpioCfg_12_mode;
  wire       [3:0]    _zz_gpioCfg_13_mode;
  wire       [3:0]    _zz_gpioCfg_14_mode;
  wire       [3:0]    _zz_gpioCfg_15_mode;
  wire                _zz_io_gpio_write;
  wire                _zz_io_gpio_write_1;
  wire                _zz_io_gpio_write_2;
  wire                _zz_io_gpio_write_3;
  wire                _zz_io_gpio_write_4;
  wire                _zz_io_gpio_write_5;
  wire                _zz_io_gpio_write_6;
  wire                _zz_io_gpio_write_7;
  wire                _zz_io_gpio_write_8;
  wire                _zz_io_gpio_write_9;
  wire                _zz_io_gpio_write_10;
  wire                _zz_io_gpio_write_11;
  wire                _zz_io_gpio_write_12;
  wire                _zz_io_gpio_write_13;
  wire                _zz_io_gpio_write_14;
  wire                _zz_io_gpio_write_15;
  wire       [31:0]   _zz_CRL;
  wire       [31:0]   _zz_CRH;
  wire                _zz_when_apb3gpio_l84;
  wire                when_apb3gpio_l84;
  wire                when_apb3gpio_l86;
  wire                when_apb3gpio_l88;

  assign _zz__zz_CRL = LCKR[4];
  assign _zz__zz_CRL_1 = (! LCKR[3]);
  assign _zz__zz_CRL_2 = 4'b1111;
  assign _zz__zz_CRL_3 = 4'b0000;
  assign _zz__zz_CRL_4 = ((! LCKR[2]) ? 4'b1111 : 4'b0000);
  assign _zz__zz_CRL_5 = {((! LCKR[1]) ? 4'b1111 : 4'b0000),((! LCKR[0]) ? 4'b1111 : 4'b0000)};
  assign _zz__zz_CRH = LCKR[13];
  assign _zz__zz_CRH_1 = (! LCKR[12]);
  assign _zz__zz_CRH_2 = 4'b1111;
  assign _zz__zz_CRH_3 = 4'b0000;
  assign _zz__zz_CRH_4 = ((! LCKR[11]) ? 4'b1111 : 4'b0000);
  assign _zz__zz_CRH_5 = ((! LCKR[10]) ? 4'b1111 : 4'b0000);
  assign _zz__zz_CRH_6 = {((! LCKR[9]) ? 4'b1111 : 4'b0000),((! LCKR[8]) ? 4'b1111 : 4'b0000)};
  (* keep_hierarchy = "TRUE" *) BufferCC_6 io_gpio_read_buffercc (
    .io_dataIn          (io_gpio_read[15:0]                    ), //i
    .io_dataOut         (io_gpio_read_buffercc_io_dataOut[15:0]), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  assign gpioInput = io_gpio_read_buffercc_io_dataOut;
  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      5'h0 : begin
        io_apb_PRDATA[31 : 0] = CRL;
      end
      5'h04 : begin
        io_apb_PRDATA[31 : 0] = CRH;
      end
      5'h08 : begin
        io_apb_PRDATA[15 : 0] = IDR;
      end
      5'h0c : begin
        io_apb_PRDATA[15 : 0] = ODR;
      end
      5'h18 : begin
        io_apb_PRDATA[16 : 0] = {LCKK,LCKR};
      end
      default : begin
      end
    endcase
  end

  assign ctrl_askWrite = ((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PWRITE);
  assign ctrl_askRead = ((io_apb_PSEL[0] && io_apb_PENABLE) && (! io_apb_PWRITE));
  assign ctrl_doWrite = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && io_apb_PWRITE);
  assign ctrl_doRead = (((io_apb_PSEL[0] && io_apb_PENABLE) && io_apb_PREADY) && (! io_apb_PWRITE));
  assign io_apb_PSLVERROR = ((ctrl_doWrite && ctrl_writeErrorFlag) || (ctrl_doRead && ctrl_readErrorFlag));
  assign IDR = gpioInput;
  assign _zz_gpioCfg_0_mode = CRL[3 : 0];
  assign gpioCfg_0_mode = _zz_gpioCfg_0_mode[1 : 0];
  assign gpioCfg_0_cnf = _zz_gpioCfg_0_mode[3 : 2];
  assign _zz_gpioCfg_1_mode = CRL[7 : 4];
  assign gpioCfg_1_mode = _zz_gpioCfg_1_mode[1 : 0];
  assign gpioCfg_1_cnf = _zz_gpioCfg_1_mode[3 : 2];
  assign _zz_gpioCfg_2_mode = CRL[11 : 8];
  assign gpioCfg_2_mode = _zz_gpioCfg_2_mode[1 : 0];
  assign gpioCfg_2_cnf = _zz_gpioCfg_2_mode[3 : 2];
  assign _zz_gpioCfg_3_mode = CRL[15 : 12];
  assign gpioCfg_3_mode = _zz_gpioCfg_3_mode[1 : 0];
  assign gpioCfg_3_cnf = _zz_gpioCfg_3_mode[3 : 2];
  assign _zz_gpioCfg_4_mode = CRL[19 : 16];
  assign gpioCfg_4_mode = _zz_gpioCfg_4_mode[1 : 0];
  assign gpioCfg_4_cnf = _zz_gpioCfg_4_mode[3 : 2];
  assign _zz_gpioCfg_5_mode = CRL[23 : 20];
  assign gpioCfg_5_mode = _zz_gpioCfg_5_mode[1 : 0];
  assign gpioCfg_5_cnf = _zz_gpioCfg_5_mode[3 : 2];
  assign _zz_gpioCfg_6_mode = CRL[27 : 24];
  assign gpioCfg_6_mode = _zz_gpioCfg_6_mode[1 : 0];
  assign gpioCfg_6_cnf = _zz_gpioCfg_6_mode[3 : 2];
  assign _zz_gpioCfg_7_mode = CRL[31 : 28];
  assign gpioCfg_7_mode = _zz_gpioCfg_7_mode[1 : 0];
  assign gpioCfg_7_cnf = _zz_gpioCfg_7_mode[3 : 2];
  assign _zz_gpioCfg_8_mode = CRH[3 : 0];
  assign gpioCfg_8_mode = _zz_gpioCfg_8_mode[1 : 0];
  assign gpioCfg_8_cnf = _zz_gpioCfg_8_mode[3 : 2];
  assign _zz_gpioCfg_9_mode = CRH[7 : 4];
  assign gpioCfg_9_mode = _zz_gpioCfg_9_mode[1 : 0];
  assign gpioCfg_9_cnf = _zz_gpioCfg_9_mode[3 : 2];
  assign _zz_gpioCfg_10_mode = CRH[11 : 8];
  assign gpioCfg_10_mode = _zz_gpioCfg_10_mode[1 : 0];
  assign gpioCfg_10_cnf = _zz_gpioCfg_10_mode[3 : 2];
  assign _zz_gpioCfg_11_mode = CRH[15 : 12];
  assign gpioCfg_11_mode = _zz_gpioCfg_11_mode[1 : 0];
  assign gpioCfg_11_cnf = _zz_gpioCfg_11_mode[3 : 2];
  assign _zz_gpioCfg_12_mode = CRH[19 : 16];
  assign gpioCfg_12_mode = _zz_gpioCfg_12_mode[1 : 0];
  assign gpioCfg_12_cnf = _zz_gpioCfg_12_mode[3 : 2];
  assign _zz_gpioCfg_13_mode = CRH[23 : 20];
  assign gpioCfg_13_mode = _zz_gpioCfg_13_mode[1 : 0];
  assign gpioCfg_13_cnf = _zz_gpioCfg_13_mode[3 : 2];
  assign _zz_gpioCfg_14_mode = CRH[27 : 24];
  assign gpioCfg_14_mode = _zz_gpioCfg_14_mode[1 : 0];
  assign gpioCfg_14_cnf = _zz_gpioCfg_14_mode[3 : 2];
  assign _zz_gpioCfg_15_mode = CRH[31 : 28];
  assign gpioCfg_15_mode = _zz_gpioCfg_15_mode[1 : 0];
  assign gpioCfg_15_cnf = _zz_gpioCfg_15_mode[3 : 2];
  assign _zz_io_gpio_write = (((gpioCfg_0_cnf == 2'b10) || (gpioCfg_0_cnf == 2'b11)) ? io_afio[0] : ODR[0]);
  always @(*) begin
    io_gpio_write[0] = _zz_io_gpio_write;
    io_gpio_write[1] = _zz_io_gpio_write_1;
    io_gpio_write[2] = _zz_io_gpio_write_2;
    io_gpio_write[3] = _zz_io_gpio_write_3;
    io_gpio_write[4] = _zz_io_gpio_write_4;
    io_gpio_write[5] = _zz_io_gpio_write_5;
    io_gpio_write[6] = _zz_io_gpio_write_6;
    io_gpio_write[7] = _zz_io_gpio_write_7;
    io_gpio_write[8] = _zz_io_gpio_write_8;
    io_gpio_write[9] = _zz_io_gpio_write_9;
    io_gpio_write[10] = _zz_io_gpio_write_10;
    io_gpio_write[11] = _zz_io_gpio_write_11;
    io_gpio_write[12] = _zz_io_gpio_write_12;
    io_gpio_write[13] = _zz_io_gpio_write_13;
    io_gpio_write[14] = _zz_io_gpio_write_14;
    io_gpio_write[15] = _zz_io_gpio_write_15;
  end

  always @(*) begin
    io_gpio_writeEnable[0] = ((gpioCfg_0_mode != 2'b00) && ((! ((gpioCfg_0_cnf == 2'b01) || (gpioCfg_0_cnf == 2'b11))) || (_zz_io_gpio_write == 1'b0)));
    io_gpio_writeEnable[1] = ((gpioCfg_1_mode != 2'b00) && ((! ((gpioCfg_1_cnf == 2'b01) || (gpioCfg_1_cnf == 2'b11))) || (_zz_io_gpio_write_1 == 1'b0)));
    io_gpio_writeEnable[2] = ((gpioCfg_2_mode != 2'b00) && ((! ((gpioCfg_2_cnf == 2'b01) || (gpioCfg_2_cnf == 2'b11))) || (_zz_io_gpio_write_2 == 1'b0)));
    io_gpio_writeEnable[3] = ((gpioCfg_3_mode != 2'b00) && ((! ((gpioCfg_3_cnf == 2'b01) || (gpioCfg_3_cnf == 2'b11))) || (_zz_io_gpio_write_3 == 1'b0)));
    io_gpio_writeEnable[4] = ((gpioCfg_4_mode != 2'b00) && ((! ((gpioCfg_4_cnf == 2'b01) || (gpioCfg_4_cnf == 2'b11))) || (_zz_io_gpio_write_4 == 1'b0)));
    io_gpio_writeEnable[5] = ((gpioCfg_5_mode != 2'b00) && ((! ((gpioCfg_5_cnf == 2'b01) || (gpioCfg_5_cnf == 2'b11))) || (_zz_io_gpio_write_5 == 1'b0)));
    io_gpio_writeEnable[6] = ((gpioCfg_6_mode != 2'b00) && ((! ((gpioCfg_6_cnf == 2'b01) || (gpioCfg_6_cnf == 2'b11))) || (_zz_io_gpio_write_6 == 1'b0)));
    io_gpio_writeEnable[7] = ((gpioCfg_7_mode != 2'b00) && ((! ((gpioCfg_7_cnf == 2'b01) || (gpioCfg_7_cnf == 2'b11))) || (_zz_io_gpio_write_7 == 1'b0)));
    io_gpio_writeEnable[8] = ((gpioCfg_8_mode != 2'b00) && ((! ((gpioCfg_8_cnf == 2'b01) || (gpioCfg_8_cnf == 2'b11))) || (_zz_io_gpio_write_8 == 1'b0)));
    io_gpio_writeEnable[9] = ((gpioCfg_9_mode != 2'b00) && ((! ((gpioCfg_9_cnf == 2'b01) || (gpioCfg_9_cnf == 2'b11))) || (_zz_io_gpio_write_9 == 1'b0)));
    io_gpio_writeEnable[10] = ((gpioCfg_10_mode != 2'b00) && ((! ((gpioCfg_10_cnf == 2'b01) || (gpioCfg_10_cnf == 2'b11))) || (_zz_io_gpio_write_10 == 1'b0)));
    io_gpio_writeEnable[11] = ((gpioCfg_11_mode != 2'b00) && ((! ((gpioCfg_11_cnf == 2'b01) || (gpioCfg_11_cnf == 2'b11))) || (_zz_io_gpio_write_11 == 1'b0)));
    io_gpio_writeEnable[12] = ((gpioCfg_12_mode != 2'b00) && ((! ((gpioCfg_12_cnf == 2'b01) || (gpioCfg_12_cnf == 2'b11))) || (_zz_io_gpio_write_12 == 1'b0)));
    io_gpio_writeEnable[13] = ((gpioCfg_13_mode != 2'b00) && ((! ((gpioCfg_13_cnf == 2'b01) || (gpioCfg_13_cnf == 2'b11))) || (_zz_io_gpio_write_13 == 1'b0)));
    io_gpio_writeEnable[14] = ((gpioCfg_14_mode != 2'b00) && ((! ((gpioCfg_14_cnf == 2'b01) || (gpioCfg_14_cnf == 2'b11))) || (_zz_io_gpio_write_14 == 1'b0)));
    io_gpio_writeEnable[15] = ((gpioCfg_15_mode != 2'b00) && ((! ((gpioCfg_15_cnf == 2'b01) || (gpioCfg_15_cnf == 2'b11))) || (_zz_io_gpio_write_15 == 1'b0)));
  end

  assign _zz_io_gpio_write_1 = (((gpioCfg_1_cnf == 2'b10) || (gpioCfg_1_cnf == 2'b11)) ? io_afio[1] : ODR[1]);
  assign _zz_io_gpio_write_2 = (((gpioCfg_2_cnf == 2'b10) || (gpioCfg_2_cnf == 2'b11)) ? io_afio[2] : ODR[2]);
  assign _zz_io_gpio_write_3 = (((gpioCfg_3_cnf == 2'b10) || (gpioCfg_3_cnf == 2'b11)) ? io_afio[3] : ODR[3]);
  assign _zz_io_gpio_write_4 = (((gpioCfg_4_cnf == 2'b10) || (gpioCfg_4_cnf == 2'b11)) ? io_afio[4] : ODR[4]);
  assign _zz_io_gpio_write_5 = (((gpioCfg_5_cnf == 2'b10) || (gpioCfg_5_cnf == 2'b11)) ? io_afio[5] : ODR[5]);
  assign _zz_io_gpio_write_6 = (((gpioCfg_6_cnf == 2'b10) || (gpioCfg_6_cnf == 2'b11)) ? io_afio[6] : ODR[6]);
  assign _zz_io_gpio_write_7 = (((gpioCfg_7_cnf == 2'b10) || (gpioCfg_7_cnf == 2'b11)) ? io_afio[7] : ODR[7]);
  assign _zz_io_gpio_write_8 = (((gpioCfg_8_cnf == 2'b10) || (gpioCfg_8_cnf == 2'b11)) ? io_afio[8] : ODR[8]);
  assign _zz_io_gpio_write_9 = (((gpioCfg_9_cnf == 2'b10) || (gpioCfg_9_cnf == 2'b11)) ? io_afio[9] : ODR[9]);
  assign _zz_io_gpio_write_10 = (((gpioCfg_10_cnf == 2'b10) || (gpioCfg_10_cnf == 2'b11)) ? io_afio[10] : ODR[10]);
  assign _zz_io_gpio_write_11 = (((gpioCfg_11_cnf == 2'b10) || (gpioCfg_11_cnf == 2'b11)) ? io_afio[11] : ODR[11]);
  assign _zz_io_gpio_write_12 = (((gpioCfg_12_cnf == 2'b10) || (gpioCfg_12_cnf == 2'b11)) ? io_afio[12] : ODR[12]);
  assign _zz_io_gpio_write_13 = (((gpioCfg_13_cnf == 2'b10) || (gpioCfg_13_cnf == 2'b11)) ? io_afio[13] : ODR[13]);
  assign _zz_io_gpio_write_14 = (((gpioCfg_14_cnf == 2'b10) || (gpioCfg_14_cnf == 2'b11)) ? io_afio[14] : ODR[14]);
  assign _zz_io_gpio_write_15 = (((gpioCfg_15_cnf == 2'b10) || (gpioCfg_15_cnf == 2'b11)) ? io_afio[15] : ODR[15]);
  assign _zz_CRL = {((! LCKR[7]) ? 4'b1111 : 4'b0000),{((! LCKR[6]) ? 4'b1111 : 4'b0000),{((! LCKR[5]) ? 4'b1111 : 4'b0000),{((! _zz__zz_CRL) ? 4'b1111 : 4'b0000),{(_zz__zz_CRL_1 ? _zz__zz_CRL_2 : _zz__zz_CRL_3),{_zz__zz_CRL_4,_zz__zz_CRL_5}}}}}};
  assign _zz_CRH = {((! LCKR[15]) ? 4'b1111 : 4'b0000),{((! LCKR[14]) ? 4'b1111 : 4'b0000),{((! _zz__zz_CRH) ? 4'b1111 : 4'b0000),{(_zz__zz_CRH_1 ? _zz__zz_CRH_2 : _zz__zz_CRH_3),{_zz__zz_CRH_4,{_zz__zz_CRH_5,_zz__zz_CRH_6}}}}}};
  assign _zz_when_apb3gpio_l84 = io_apb_PWDATA[16];
  assign when_apb3gpio_l84 = (_zz_when_apb3gpio_l84 && (! LCKK));
  assign when_apb3gpio_l86 = ((! _zz_when_apb3gpio_l84) && (! LCKK));
  assign when_apb3gpio_l88 = (_zz_when_apb3gpio_l84 && (! LCKK));
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      CRL <= 32'h0;
      CRH <= 32'h0;
      ODR <= 16'h0;
      LCKR <= 16'h0;
      LCKK <= 1'b0;
    end else begin
      case(io_apb_PADDR)
        5'h0 : begin
          if(ctrl_doWrite) begin
            CRL <= ((CRL & (~ _zz_CRL)) | (io_apb_PWDATA & _zz_CRL));
          end
        end
        5'h04 : begin
          if(ctrl_doWrite) begin
            CRH <= ((CRH & (~ _zz_CRH)) | (io_apb_PWDATA & _zz_CRH));
          end
        end
        5'h0c : begin
          if(ctrl_doWrite) begin
            ODR <= io_apb_PWDATA[15 : 0];
          end
        end
        5'h10 : begin
          if(ctrl_doWrite) begin
            ODR <= ((ODR | io_apb_PWDATA[15 : 0]) & (~ io_apb_PWDATA[31 : 16]));
          end
        end
        5'h14 : begin
          if(ctrl_doWrite) begin
            ODR <= (ODR & (~ io_apb_PWDATA[15 : 0]));
          end
        end
        5'h18 : begin
          if(ctrl_doWrite) begin
            if(when_apb3gpio_l84) begin
              LCKK <= 1'b0;
            end else begin
              if(when_apb3gpio_l86) begin
                LCKK <= 1'b0;
              end else begin
                if(when_apb3gpio_l88) begin
                  LCKK <= 1'b1;
                end
              end
            end
            LCKR <= (LCKR | (io_apb_PWDATA[15 : 0] & (~ LCKR)));
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module Axi4DdrControllerWithCache (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [27:0]   io_axi_arw_payload_addr,
  input  wire [3:0]    io_axi_arw_payload_id,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [3:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output reg  [31:0]   io_axi_r_payload_data,
  output wire [3:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire [5:0]    io_app_burst_number,
  input  wire          io_cmd_ready,
  output wire [2:0]    io_cmd,
  output wire          io_cmd_en,
  output wire [27:0]   io_addr,
  input  wire          io_wr_data_rdy,
  output reg  [127:0]  io_wr_data,
  output wire          io_wr_data_en,
  output reg  [15:0]   io_wr_data_mask,
  input  wire [127:0]  io_rd_data,
  input  wire          io_rd_data_valid,
  input  wire          io_init_calib_complete,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clk_out,
  input  wire          ddr_rst
);
  localparam Axi4Ddr_CMDTYPE_read = 1'd0;
  localparam Axi4Ddr_CMDTYPE_write = 1'd1;

  wire                cmd_fifo_io_pop_ready;
  wire                cmd_fifo_io_push_ready;
  wire                cmd_fifo_io_pop_valid;
  wire       [0:0]    cmd_fifo_io_pop_payload_cmdtype;
  wire       [27:0]   cmd_fifo_io_pop_payload_addr;
  wire       [5:0]    cmd_fifo_io_pop_payload_burst_cnt;
  wire       [127:0]  cmd_fifo_io_pop_payload_wr_data;
  wire       [15:0]   cmd_fifo_io_pop_payload_wr_mask;
  wire       [0:0]    cmd_fifo_io_pop_payload_context;
  wire       [2:0]    cmd_fifo_io_pushOccupancy;
  wire       [2:0]    cmd_fifo_io_popOccupancy;
  wire                rsp_fifo_io_push_ready;
  wire                rsp_fifo_io_pop_valid;
  wire       [127:0]  rsp_fifo_io_pop_payload_rsp_data;
  wire       [0:0]    rsp_fifo_io_pop_payload_context;
  wire       [2:0]    rsp_fifo_io_pushOccupancy;
  wire       [2:0]    rsp_fifo_io_popOccupancy;
  wire       [1:0]    _zz_Axi4Incr_alignMask;
  wire       [11:0]   _zz_Axi4Incr_baseIncr;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_1;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_2;
  reg        [11:0]   _zz_Axi4Incr_result;
  wire       [10:0]   _zz_Axi4Incr_result_1;
  wire       [0:0]    _zz_Axi4Incr_result_2;
  wire       [9:0]    _zz_Axi4Incr_result_3;
  wire       [1:0]    _zz_Axi4Incr_result_4;
  wire       [8:0]    _zz_Axi4Incr_result_5;
  wire       [2:0]    _zz_Axi4Incr_result_6;
  wire       [7:0]    _zz_Axi4Incr_result_7;
  wire       [3:0]    _zz_Axi4Incr_result_8;
  wire       [6:0]    _zz_Axi4Incr_result_9;
  wire       [4:0]    _zz_Axi4Incr_result_10;
  wire       [5:0]    _zz_Axi4Incr_result_11;
  wire       [5:0]    _zz_Axi4Incr_result_12;
  wire       [0:0]    _zz_when;
  wire       [0:0]    _zz_when_1;
  wire       [0:0]    _zz_when_2;
  wire       [0:0]    _zz_when_3;
  wire       [0:0]    _zz_when_4;
  wire       [0:0]    _zz__zz_1;
  wire       [6:0]    _zz_when_axi4ddrgowin_l712;
  wire       [6:0]    _zz_when_axi4ddrgowin_l712_1;
  wire       [1:0]    _zz_when_axi4ddrgowin_l712_2;
  wire       [6:0]    _zz_io_wr_data_en;
  wire       [6:0]    _zz_io_wr_data_en_1;
  wire       [1:0]    _zz_io_wr_data_en_2;
  wire       [6:0]    _zz_ddr_control_area_push_valid_reg;
  wire       [0:0]    contextType;
  wire                ddr_cmd_valid;
  wire                ddr_cmd_ready;
  wire       [0:0]    ddr_cmd_payload_cmdtype;
  wire       [27:0]   ddr_cmd_payload_addr;
  wire       [5:0]    ddr_cmd_payload_burst_cnt;
  wire       [127:0]  ddr_cmd_payload_wr_data;
  wire       [15:0]   ddr_cmd_payload_wr_mask;
  wire       [0:0]    ddr_cmd_payload_context;
  wire                ddr_rsp_valid;
  wire                ddr_rsp_ready;
  wire       [127:0]  ddr_rsp_payload_rsp_data;
  wire       [0:0]    ddr_rsp_payload_context;
  reg        [27:0]   sys_area_cache_addr_0;
  reg        [127:0]  sys_area_cache_data_0;
  reg                 sys_area_cache_dirty_0;
  reg                 sys_area_cache_valid_0;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [27:0]   unburstify_result_payload_fragment_addr;
  reg        [3:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [27:0]   unburstify_buffer_transaction_addr;
  reg        [3:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [27:0]   Axi4Incr_result;
  wire       [15:0]   Axi4Incr_highCat;
  wire       [2:0]    Axi4Incr_sizeValue;
  wire       [11:0]   Axi4Incr_alignMask;
  wire       [11:0]   Axi4Incr_base;
  wire       [11:0]   Axi4Incr_baseIncr;
  reg        [1:0]    _zz_Axi4Incr_wrapCase;
  wire       [2:0]    Axi4Incr_wrapCase;
  wire                when_Axi4Channel_l323;
  reg                 sys_area_arwcmd_free;
  wire                unburstify_result_fire;
  reg                 sys_area_arwcmd_last;
  reg        [27:0]   sys_area_arwcmd_fragment_addr;
  reg        [3:0]    sys_area_arwcmd_fragment_id;
  reg        [2:0]    sys_area_arwcmd_fragment_size;
  reg        [1:0]    sys_area_arwcmd_fragment_burst;
  reg                 sys_area_arwcmd_fragment_write;
  wire       [23:0]   sys_area_current_page_tag;
  wire                sys_area_page_hit_vec_0;
  wire                sys_area_hit;
  wire                sys_area_miss;
  reg                 sys_area_ddr_write_pending;
  reg                 sys_area_ddr_read_pending;
  reg                 sys_area_ddr_cmd_valid;
  reg        [0:0]    sys_area_ddr_cmd_payload_cmdtype;
  reg        [27:0]   sys_area_ddr_cmd_payload_addr;
  wire       [5:0]    sys_area_ddr_cmd_payload_burst_cnt;
  wire       [127:0]  sys_area_ddr_cmd_payload_wr_data;
  wire       [15:0]   sys_area_ddr_cmd_payload_wr_mask;
  wire       [0:0]    sys_area_ddr_cmd_payload_context;
  wire                sys_area_dirty;
  wire                when_axi4ddrgowin_l605;
  wire                when_axi4ddrgowin_l606;
  wire                ddr_cmd_fire;
  wire                when_axi4ddrgowin_l612;
  wire                ddr_rsp_fire;
  wire                when_axi4ddrgowin_l622;
  reg                 sys_area_write_data_ready;
  reg                 sys_area_write_response_valid;
  wire                when_axi4ddrgowin_l642;
  wire                when_axi4ddrgowin_l647;
  wire                io_axi_w_fire;
  wire                when_axi4ddrgowin_l649;
  wire       [127:0]  _zz_io_axi_r_payload_data;
  wire                _zz_1;
  wire                when_axi4ddrgowin_l649_1;
  wire                when_axi4ddrgowin_l649_2;
  wire                when_axi4ddrgowin_l649_3;
  wire                when_axi4ddrgowin_l647_1;
  wire                when_axi4ddrgowin_l649_4;
  wire                when_axi4ddrgowin_l649_5;
  wire                when_axi4ddrgowin_l649_6;
  wire                when_axi4ddrgowin_l649_7;
  wire                when_axi4ddrgowin_l647_2;
  wire                when_axi4ddrgowin_l649_8;
  wire                when_axi4ddrgowin_l649_9;
  wire                when_axi4ddrgowin_l649_10;
  wire                when_axi4ddrgowin_l649_11;
  wire                when_axi4ddrgowin_l647_3;
  wire                when_axi4ddrgowin_l649_12;
  wire                when_axi4ddrgowin_l649_13;
  wire                when_axi4ddrgowin_l649_14;
  wire                when_axi4ddrgowin_l649_15;
  wire                io_axi_b_fire;
  reg                 sys_area_read_response_valid;
  wire                when_axi4ddrgowin_l674;
  wire                when_axi4ddrgowin_l676;
  wire                when_axi4ddrgowin_l676_1;
  wire                when_axi4ddrgowin_l676_2;
  wire                when_axi4ddrgowin_l676_3;
  wire                io_axi_r_fire;
  reg                 ddr_control_area_cmd_free;
  reg                 ddr_control_area_cmd_can_send;
  reg                 ddr_control_area_cmd_trigger;
  reg        [6:0]    ddr_control_area_burst_cnt;
  wire                ddr_control_area_wr_fire;
  wire                ddr_control_area_data_fire;
  wire                cmd_fifo_io_pop_fire;
  reg        [0:0]    ddr_control_area_cmd_cmdtype;
  reg        [27:0]   ddr_control_area_cmd_addr;
  reg        [5:0]    ddr_control_area_cmd_burst_cnt;
  reg        [127:0]  ddr_control_area_cmd_wr_data;
  reg        [15:0]   ddr_control_area_cmd_wr_mask;
  reg        [0:0]    ddr_control_area_cmd_context;
  wire                when_axi4ddrgowin_l712;
  wire                when_axi4ddrgowin_l713;
  wire                ddr_control_area_is_write;
  wire                when_axi4ddrgowin_l725;
  reg                 ddr_control_area_push_valid_reg;
  reg        [0:0]    ddr_control_area_push_context_reg;
  reg        [127:0]  ddr_control_area_push_data_reg;
  wire                when_axi4ddrgowin_l735;
  `ifndef SYNTHESIS
  reg [39:0] ddr_cmd_payload_cmdtype_string;
  reg [39:0] sys_area_ddr_cmd_payload_cmdtype_string;
  reg [39:0] ddr_control_area_cmd_cmdtype_string;
  `endif


  assign _zz_Axi4Incr_alignMask = {(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)};
  assign _zz_Axi4Incr_baseIncr = {9'd0, Axi4Incr_sizeValue};
  assign _zz_Axi4Incr_wrapCase_1 = {1'd0, Axi4Incr_validSize};
  assign _zz_Axi4Incr_wrapCase_2 = {1'd0, _zz_Axi4Incr_wrapCase};
  assign _zz_when = 1'b1;
  assign _zz_when_1 = 1'b1;
  assign _zz_when_2 = 1'b1;
  assign _zz_when_3 = 1'b1;
  assign _zz_when_4 = 1'b1;
  assign _zz__zz_1 = 1'b1;
  assign _zz_when_axi4ddrgowin_l712 = ({1'b0,ddr_control_area_cmd_burst_cnt} + _zz_when_axi4ddrgowin_l712_1);
  assign _zz_when_axi4ddrgowin_l712_2 = {1'b0,1'b1};
  assign _zz_when_axi4ddrgowin_l712_1 = {5'd0, _zz_when_axi4ddrgowin_l712_2};
  assign _zz_io_wr_data_en = ({1'b0,ddr_control_area_cmd_burst_cnt} + _zz_io_wr_data_en_1);
  assign _zz_io_wr_data_en_2 = {1'b0,1'b1};
  assign _zz_io_wr_data_en_1 = {5'd0, _zz_io_wr_data_en_2};
  assign _zz_ddr_control_area_push_valid_reg = {1'd0, ddr_control_area_cmd_burst_cnt};
  assign _zz_Axi4Incr_result_1 = Axi4Incr_base[11 : 1];
  assign _zz_Axi4Incr_result_2 = Axi4Incr_baseIncr[0 : 0];
  assign _zz_Axi4Incr_result_3 = Axi4Incr_base[11 : 2];
  assign _zz_Axi4Incr_result_4 = Axi4Incr_baseIncr[1 : 0];
  assign _zz_Axi4Incr_result_5 = Axi4Incr_base[11 : 3];
  assign _zz_Axi4Incr_result_6 = Axi4Incr_baseIncr[2 : 0];
  assign _zz_Axi4Incr_result_7 = Axi4Incr_base[11 : 4];
  assign _zz_Axi4Incr_result_8 = Axi4Incr_baseIncr[3 : 0];
  assign _zz_Axi4Incr_result_9 = Axi4Incr_base[11 : 5];
  assign _zz_Axi4Incr_result_10 = Axi4Incr_baseIncr[4 : 0];
  assign _zz_Axi4Incr_result_11 = Axi4Incr_base[11 : 6];
  assign _zz_Axi4Incr_result_12 = Axi4Incr_baseIncr[5 : 0];
  StreamFifoCC cmd_fifo (
    .io_push_valid             (ddr_cmd_valid                         ), //i
    .io_push_ready             (cmd_fifo_io_push_ready                ), //o
    .io_push_payload_cmdtype   (ddr_cmd_payload_cmdtype               ), //i
    .io_push_payload_addr      (ddr_cmd_payload_addr[27:0]            ), //i
    .io_push_payload_burst_cnt (ddr_cmd_payload_burst_cnt[5:0]        ), //i
    .io_push_payload_wr_data   (ddr_cmd_payload_wr_data[127:0]        ), //i
    .io_push_payload_wr_mask   (ddr_cmd_payload_wr_mask[15:0]         ), //i
    .io_push_payload_context   (ddr_cmd_payload_context               ), //i
    .io_pop_valid              (cmd_fifo_io_pop_valid                 ), //o
    .io_pop_ready              (cmd_fifo_io_pop_ready                 ), //i
    .io_pop_payload_cmdtype    (cmd_fifo_io_pop_payload_cmdtype       ), //o
    .io_pop_payload_addr       (cmd_fifo_io_pop_payload_addr[27:0]    ), //o
    .io_pop_payload_burst_cnt  (cmd_fifo_io_pop_payload_burst_cnt[5:0]), //o
    .io_pop_payload_wr_data    (cmd_fifo_io_pop_payload_wr_data[127:0]), //o
    .io_pop_payload_wr_mask    (cmd_fifo_io_pop_payload_wr_mask[15:0] ), //o
    .io_pop_payload_context    (cmd_fifo_io_pop_payload_context       ), //o
    .io_pushOccupancy          (cmd_fifo_io_pushOccupancy[2:0]        ), //o
    .io_popOccupancy           (cmd_fifo_io_popOccupancy[2:0]         ), //o
    .clkout                    (clkout                                ), //i
    .resetCtrl_axiReset        (resetCtrl_axiReset                    ), //i
    .clk_out                   (clk_out                               )  //i
  );
  StreamFifoCC_1 rsp_fifo (
    .io_push_valid            (ddr_control_area_push_valid_reg        ), //i
    .io_push_ready            (rsp_fifo_io_push_ready                 ), //o
    .io_push_payload_rsp_data (ddr_control_area_push_data_reg[127:0]  ), //i
    .io_push_payload_context  (ddr_control_area_push_context_reg      ), //i
    .io_pop_valid             (rsp_fifo_io_pop_valid                  ), //o
    .io_pop_ready             (ddr_rsp_ready                          ), //i
    .io_pop_payload_rsp_data  (rsp_fifo_io_pop_payload_rsp_data[127:0]), //o
    .io_pop_payload_context   (rsp_fifo_io_pop_payload_context        ), //o
    .io_pushOccupancy         (rsp_fifo_io_pushOccupancy[2:0]         ), //o
    .io_popOccupancy          (rsp_fifo_io_popOccupancy[2:0]          ), //o
    .clk_out                  (clk_out                                ), //i
    .ddr_rst                  (ddr_rst                                ), //i
    .clkout                   (clkout                                 )  //i
  );
  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_1,_zz_Axi4Incr_result_2};
      3'b001 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_3,_zz_Axi4Incr_result_4};
      3'b010 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_5,_zz_Axi4Incr_result_6};
      3'b011 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_7,_zz_Axi4Incr_result_8};
      3'b100 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_9,_zz_Axi4Incr_result_10};
      default : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_11,_zz_Axi4Incr_result_12};
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(ddr_cmd_payload_cmdtype)
      Axi4Ddr_CMDTYPE_read : ddr_cmd_payload_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : ddr_cmd_payload_cmdtype_string = "write";
      default : ddr_cmd_payload_cmdtype_string = "?????";
    endcase
  end
  always @(*) begin
    case(sys_area_ddr_cmd_payload_cmdtype)
      Axi4Ddr_CMDTYPE_read : sys_area_ddr_cmd_payload_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : sys_area_ddr_cmd_payload_cmdtype_string = "write";
      default : sys_area_ddr_cmd_payload_cmdtype_string = "?????";
    endcase
  end
  always @(*) begin
    case(ddr_control_area_cmd_cmdtype)
      Axi4Ddr_CMDTYPE_read : ddr_control_area_cmd_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : ddr_control_area_cmd_cmdtype_string = "write";
      default : ddr_control_area_cmd_cmdtype_string = "?????";
    endcase
  end
  `endif

  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[27 : 12];
  assign Axi4Incr_sizeValue = {(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_Axi4Incr_alignMask};
  assign Axi4Incr_base = (unburstify_buffer_transaction_addr[11 : 0] & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_Axi4Incr_baseIncr);
  always @(*) begin
    casez(unburstify_buffer_len)
      8'b????1??? : begin
        _zz_Axi4Incr_wrapCase = 2'b11;
      end
      8'b????01?? : begin
        _zz_Axi4Incr_wrapCase = 2'b10;
      end
      8'b????001? : begin
        _zz_Axi4Incr_wrapCase = 2'b01;
      end
      default : begin
        _zz_Axi4Incr_wrapCase = 2'b00;
      end
    endcase
  end

  assign Axi4Incr_wrapCase = (_zz_Axi4Incr_wrapCase_1 + _zz_Axi4Incr_wrapCase_2);
  always @(*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        Axi4Incr_result = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        Axi4Incr_result = {Axi4Incr_highCat,_zz_Axi4Incr_result};
      end
      default : begin
        Axi4Incr_result = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @(*) begin
    io_axi_arw_ready = 1'b0;
    if(!unburstify_buffer_valid) begin
      io_axi_arw_ready = unburstify_result_ready;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_valid = 1'b1;
    end else begin
      unburstify_result_valid = io_axi_arw_valid;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_last = unburstify_buffer_last;
    end else begin
      unburstify_result_payload_last = 1'b1;
      if(when_Axi4Channel_l323) begin
        unburstify_result_payload_last = 1'b0;
      end
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      unburstify_result_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      unburstify_result_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      unburstify_result_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      unburstify_result_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_addr = Axi4Incr_result;
    end else begin
      unburstify_result_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign when_Axi4Channel_l323 = (io_axi_arw_payload_len != 8'h0);
  assign unburstify_result_fire = (unburstify_result_valid && unburstify_result_ready);
  assign unburstify_result_ready = sys_area_arwcmd_free;
  assign sys_area_current_page_tag = sys_area_arwcmd_fragment_addr[27 : 4];
  assign sys_area_page_hit_vec_0 = (sys_area_cache_valid_0 && (sys_area_cache_addr_0[27 : 4] == sys_area_current_page_tag));
  assign sys_area_hit = (|sys_area_page_hit_vec_0);
  assign sys_area_miss = (! sys_area_hit);
  assign ddr_cmd_payload_cmdtype = sys_area_ddr_cmd_payload_cmdtype;
  assign ddr_cmd_payload_addr = sys_area_ddr_cmd_payload_addr;
  assign ddr_cmd_payload_burst_cnt = sys_area_ddr_cmd_payload_burst_cnt;
  assign ddr_cmd_payload_wr_data = sys_area_ddr_cmd_payload_wr_data;
  assign ddr_cmd_payload_wr_mask = sys_area_ddr_cmd_payload_wr_mask;
  assign ddr_cmd_payload_context = sys_area_ddr_cmd_payload_context;
  assign ddr_cmd_valid = sys_area_ddr_cmd_valid;
  assign ddr_rsp_ready = 1'b1;
  always @(*) begin
    sys_area_ddr_cmd_payload_addr = 28'h0;
    if(when_axi4ddrgowin_l605) begin
      if(when_axi4ddrgowin_l606) begin
        sys_area_ddr_cmd_payload_addr = {sys_area_cache_addr_0[27 : 4],4'b0000};
      end else begin
        if(when_axi4ddrgowin_l612) begin
          sys_area_ddr_cmd_payload_addr = {sys_area_arwcmd_fragment_addr[27 : 4],4'b0000};
        end
      end
    end
  end

  always @(*) begin
    sys_area_ddr_cmd_payload_cmdtype = Axi4Ddr_CMDTYPE_write;
    if(when_axi4ddrgowin_l605) begin
      if(when_axi4ddrgowin_l606) begin
        sys_area_ddr_cmd_payload_cmdtype = Axi4Ddr_CMDTYPE_write;
      end else begin
        if(when_axi4ddrgowin_l612) begin
          sys_area_ddr_cmd_payload_cmdtype = Axi4Ddr_CMDTYPE_read;
        end
      end
    end
  end

  assign sys_area_ddr_cmd_payload_burst_cnt = 6'h0;
  assign sys_area_ddr_cmd_payload_wr_data = sys_area_cache_data_0;
  assign sys_area_ddr_cmd_payload_wr_mask = 16'h0;
  assign sys_area_ddr_cmd_payload_context = 1'b0;
  assign sys_area_dirty = sys_area_cache_dirty_0;
  assign when_axi4ddrgowin_l605 = ((sys_area_arwcmd_free == 1'b0) && sys_area_miss);
  assign when_axi4ddrgowin_l606 = (sys_area_dirty && (! sys_area_ddr_write_pending));
  assign ddr_cmd_fire = (ddr_cmd_valid && ddr_cmd_ready);
  assign when_axi4ddrgowin_l612 = (! sys_area_ddr_read_pending);
  assign ddr_rsp_fire = (ddr_rsp_valid && ddr_rsp_ready);
  assign when_axi4ddrgowin_l622 = (ddr_rsp_fire && sys_area_ddr_read_pending);
  assign io_axi_w_ready = sys_area_write_data_ready;
  assign io_axi_b_valid = sys_area_write_response_valid;
  assign io_axi_b_payload_id = sys_area_arwcmd_fragment_id;
  assign io_axi_b_payload_resp = 2'b00;
  assign when_axi4ddrgowin_l642 = ((sys_area_hit && sys_area_arwcmd_fragment_write) && (sys_area_arwcmd_free == 1'b0));
  assign when_axi4ddrgowin_l647 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b00);
  assign io_axi_w_fire = (io_axi_w_valid && io_axi_w_ready);
  assign when_axi4ddrgowin_l649 = (io_axi_w_payload_strb[0] && io_axi_w_fire);
  assign _zz_io_axi_r_payload_data = sys_area_cache_data_0;
  assign _zz_1 = _zz__zz_1[0];
  assign when_axi4ddrgowin_l649_1 = (io_axi_w_payload_strb[1] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_2 = (io_axi_w_payload_strb[2] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_3 = (io_axi_w_payload_strb[3] && io_axi_w_fire);
  assign when_axi4ddrgowin_l647_1 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b01);
  assign when_axi4ddrgowin_l649_4 = (io_axi_w_payload_strb[0] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_5 = (io_axi_w_payload_strb[1] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_6 = (io_axi_w_payload_strb[2] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_7 = (io_axi_w_payload_strb[3] && io_axi_w_fire);
  assign when_axi4ddrgowin_l647_2 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b10);
  assign when_axi4ddrgowin_l649_8 = (io_axi_w_payload_strb[0] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_9 = (io_axi_w_payload_strb[1] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_10 = (io_axi_w_payload_strb[2] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_11 = (io_axi_w_payload_strb[3] && io_axi_w_fire);
  assign when_axi4ddrgowin_l647_3 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b11);
  assign when_axi4ddrgowin_l649_12 = (io_axi_w_payload_strb[0] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_13 = (io_axi_w_payload_strb[1] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_14 = (io_axi_w_payload_strb[2] && io_axi_w_fire);
  assign when_axi4ddrgowin_l649_15 = (io_axi_w_payload_strb[3] && io_axi_w_fire);
  assign io_axi_b_fire = (io_axi_b_valid && io_axi_b_ready);
  assign io_axi_r_valid = sys_area_read_response_valid;
  assign io_axi_r_payload_id = sys_area_arwcmd_fragment_id;
  assign io_axi_r_payload_last = sys_area_arwcmd_last;
  assign io_axi_r_payload_resp = 2'b00;
  always @(*) begin
    io_axi_r_payload_data = 32'h0;
    if(when_axi4ddrgowin_l674) begin
      if(when_axi4ddrgowin_l676) begin
        io_axi_r_payload_data = _zz_io_axi_r_payload_data[31 : 0];
      end
      if(when_axi4ddrgowin_l676_1) begin
        io_axi_r_payload_data = _zz_io_axi_r_payload_data[63 : 32];
      end
      if(when_axi4ddrgowin_l676_2) begin
        io_axi_r_payload_data = _zz_io_axi_r_payload_data[95 : 64];
      end
      if(when_axi4ddrgowin_l676_3) begin
        io_axi_r_payload_data = _zz_io_axi_r_payload_data[127 : 96];
      end
    end
  end

  assign when_axi4ddrgowin_l674 = ((sys_area_hit && (! sys_area_arwcmd_fragment_write)) && (sys_area_arwcmd_free == 1'b0));
  assign when_axi4ddrgowin_l676 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b00);
  assign when_axi4ddrgowin_l676_1 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b01);
  assign when_axi4ddrgowin_l676_2 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b10);
  assign when_axi4ddrgowin_l676_3 = (sys_area_arwcmd_fragment_addr[3 : 2] == 2'b11);
  assign io_axi_r_fire = (io_axi_r_valid && io_axi_r_ready);
  assign ddr_cmd_ready = cmd_fifo_io_push_ready;
  assign ddr_rsp_valid = rsp_fifo_io_pop_valid;
  assign ddr_rsp_payload_rsp_data = rsp_fifo_io_pop_payload_rsp_data;
  assign ddr_rsp_payload_context = rsp_fifo_io_pop_payload_context;
  assign ddr_control_area_wr_fire = (io_wr_data_en && io_wr_data_rdy);
  assign ddr_control_area_data_fire = (io_rd_data_valid || ddr_control_area_wr_fire);
  assign cmd_fifo_io_pop_fire = (cmd_fifo_io_pop_valid && cmd_fifo_io_pop_ready);
  assign cmd_fifo_io_pop_ready = (ddr_control_area_cmd_free && ddr_control_area_cmd_can_send);
  assign when_axi4ddrgowin_l712 = (ddr_control_area_burst_cnt == _zz_when_axi4ddrgowin_l712);
  assign when_axi4ddrgowin_l713 = (ddr_control_area_cmd_free == 1'b0);
  assign ddr_control_area_is_write = (ddr_control_area_cmd_cmdtype == Axi4Ddr_CMDTYPE_write);
  assign io_cmd_en = ddr_control_area_cmd_trigger;
  assign io_cmd = (ddr_control_area_is_write ? 3'b000 : 3'b001);
  assign io_app_burst_number = ddr_control_area_cmd_burst_cnt;
  assign io_addr = ddr_control_area_cmd_addr;
  assign io_wr_data_en = ((ddr_control_area_is_write && (ddr_control_area_burst_cnt != _zz_io_wr_data_en)) && io_wr_data_rdy);
  always @(*) begin
    io_wr_data = 128'h0;
    if(when_axi4ddrgowin_l725) begin
      io_wr_data = ddr_control_area_cmd_wr_data[127 : 0];
    end
  end

  always @(*) begin
    io_wr_data_mask = 16'h0;
    if(when_axi4ddrgowin_l725) begin
      io_wr_data_mask = ddr_control_area_cmd_wr_mask[15 : 0];
    end
  end

  assign when_axi4ddrgowin_l725 = (7'h0 == ddr_control_area_burst_cnt);
  assign when_axi4ddrgowin_l735 = (7'h0 == ddr_control_area_burst_cnt);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      sys_area_cache_addr_0 <= 28'h0;
      sys_area_cache_data_0 <= 128'h0;
      sys_area_cache_dirty_0 <= 1'b0;
      sys_area_cache_valid_0 <= 1'b0;
      unburstify_buffer_valid <= 1'b0;
      sys_area_arwcmd_free <= 1'b1;
      sys_area_ddr_write_pending <= 1'b0;
      sys_area_ddr_read_pending <= 1'b0;
      sys_area_ddr_cmd_valid <= 1'b0;
      sys_area_write_data_ready <= 1'b0;
      sys_area_write_response_valid <= 1'b0;
      sys_area_read_response_valid <= 1'b0;
    end else begin
      if(unburstify_result_ready) begin
        if(unburstify_buffer_last) begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(!unburstify_buffer_valid) begin
        if(when_Axi4Channel_l323) begin
          if(unburstify_result_ready) begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(unburstify_result_fire) begin
        sys_area_arwcmd_free <= 1'b0;
      end
      if(when_axi4ddrgowin_l605) begin
        if(when_axi4ddrgowin_l606) begin
          sys_area_ddr_cmd_valid <= (! ddr_cmd_fire);
          if(ddr_cmd_fire) begin
            sys_area_ddr_write_pending <= 1'b1;
          end
        end else begin
          if(when_axi4ddrgowin_l612) begin
            sys_area_ddr_cmd_valid <= (! ddr_cmd_fire);
            if(ddr_cmd_fire) begin
              sys_area_ddr_read_pending <= 1'b1;
            end
          end
        end
      end
      if(when_axi4ddrgowin_l622) begin
        if(_zz_when[0]) begin
          sys_area_cache_addr_0 <= {sys_area_arwcmd_fragment_addr[27 : 4],4'b0000};
        end
        if(_zz_when_1[0]) begin
          sys_area_cache_data_0 <= ddr_rsp_payload_rsp_data;
        end
        if(_zz_when_2[0]) begin
          sys_area_cache_dirty_0 <= 1'b0;
        end
        if(_zz_when_3[0]) begin
          sys_area_cache_valid_0 <= 1'b1;
        end
        sys_area_ddr_read_pending <= 1'b0;
        sys_area_ddr_write_pending <= 1'b0;
      end
      if(when_axi4ddrgowin_l642) begin
        if(_zz_when_4[0]) begin
          sys_area_cache_dirty_0 <= 1'b1;
        end
        if(when_axi4ddrgowin_l647) begin
          if(when_axi4ddrgowin_l649) begin
            if(_zz_1) begin
              sys_area_cache_data_0[7 : 0] <= io_axi_w_payload_data[7 : 0];
            end
          end
          if(when_axi4ddrgowin_l649_1) begin
            if(_zz_1) begin
              sys_area_cache_data_0[15 : 8] <= io_axi_w_payload_data[15 : 8];
            end
          end
          if(when_axi4ddrgowin_l649_2) begin
            if(_zz_1) begin
              sys_area_cache_data_0[23 : 16] <= io_axi_w_payload_data[23 : 16];
            end
          end
          if(when_axi4ddrgowin_l649_3) begin
            if(_zz_1) begin
              sys_area_cache_data_0[31 : 24] <= io_axi_w_payload_data[31 : 24];
            end
          end
        end
        if(when_axi4ddrgowin_l647_1) begin
          if(when_axi4ddrgowin_l649_4) begin
            if(_zz_1) begin
              sys_area_cache_data_0[39 : 32] <= io_axi_w_payload_data[7 : 0];
            end
          end
          if(when_axi4ddrgowin_l649_5) begin
            if(_zz_1) begin
              sys_area_cache_data_0[47 : 40] <= io_axi_w_payload_data[15 : 8];
            end
          end
          if(when_axi4ddrgowin_l649_6) begin
            if(_zz_1) begin
              sys_area_cache_data_0[55 : 48] <= io_axi_w_payload_data[23 : 16];
            end
          end
          if(when_axi4ddrgowin_l649_7) begin
            if(_zz_1) begin
              sys_area_cache_data_0[63 : 56] <= io_axi_w_payload_data[31 : 24];
            end
          end
        end
        if(when_axi4ddrgowin_l647_2) begin
          if(when_axi4ddrgowin_l649_8) begin
            if(_zz_1) begin
              sys_area_cache_data_0[71 : 64] <= io_axi_w_payload_data[7 : 0];
            end
          end
          if(when_axi4ddrgowin_l649_9) begin
            if(_zz_1) begin
              sys_area_cache_data_0[79 : 72] <= io_axi_w_payload_data[15 : 8];
            end
          end
          if(when_axi4ddrgowin_l649_10) begin
            if(_zz_1) begin
              sys_area_cache_data_0[87 : 80] <= io_axi_w_payload_data[23 : 16];
            end
          end
          if(when_axi4ddrgowin_l649_11) begin
            if(_zz_1) begin
              sys_area_cache_data_0[95 : 88] <= io_axi_w_payload_data[31 : 24];
            end
          end
        end
        if(when_axi4ddrgowin_l647_3) begin
          if(when_axi4ddrgowin_l649_12) begin
            if(_zz_1) begin
              sys_area_cache_data_0[103 : 96] <= io_axi_w_payload_data[7 : 0];
            end
          end
          if(when_axi4ddrgowin_l649_13) begin
            if(_zz_1) begin
              sys_area_cache_data_0[111 : 104] <= io_axi_w_payload_data[15 : 8];
            end
          end
          if(when_axi4ddrgowin_l649_14) begin
            if(_zz_1) begin
              sys_area_cache_data_0[119 : 112] <= io_axi_w_payload_data[23 : 16];
            end
          end
          if(when_axi4ddrgowin_l649_15) begin
            if(_zz_1) begin
              sys_area_cache_data_0[127 : 120] <= io_axi_w_payload_data[31 : 24];
            end
          end
        end
        sys_area_write_data_ready <= (! sys_area_write_response_valid);
        if(io_axi_w_fire) begin
          sys_area_write_data_ready <= 1'b0;
          sys_area_write_response_valid <= 1'b1;
        end
        if(io_axi_b_fire) begin
          sys_area_write_response_valid <= 1'b0;
          sys_area_arwcmd_free <= 1'b1;
        end
      end
      if(when_axi4ddrgowin_l674) begin
        sys_area_read_response_valid <= (! io_axi_r_fire);
        if(io_axi_r_fire) begin
          sys_area_arwcmd_free <= 1'b1;
        end
      end
    end
  end

  always @(posedge clkout) begin
    if(unburstify_result_ready) begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[11 : 0] <= Axi4Incr_result[11 : 0];
    end
    if(!unburstify_buffer_valid) begin
      if(when_Axi4Channel_l323) begin
        if(unburstify_result_ready) begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(unburstify_result_fire) begin
      sys_area_arwcmd_last <= unburstify_result_payload_last;
      sys_area_arwcmd_fragment_addr <= unburstify_result_payload_fragment_addr;
      sys_area_arwcmd_fragment_id <= unburstify_result_payload_fragment_id;
      sys_area_arwcmd_fragment_size <= unburstify_result_payload_fragment_size;
      sys_area_arwcmd_fragment_burst <= unburstify_result_payload_fragment_burst;
      sys_area_arwcmd_fragment_write <= unburstify_result_payload_fragment_write;
    end
  end

  always @(posedge clk_out or posedge ddr_rst) begin
    if(ddr_rst) begin
      ddr_control_area_cmd_free <= 1'b1;
      ddr_control_area_cmd_can_send <= 1'b0;
      ddr_control_area_cmd_trigger <= 1'b0;
      ddr_control_area_burst_cnt <= 7'h0;
      ddr_control_area_push_valid_reg <= 1'b0;
      ddr_control_area_push_context_reg <= 1'b0;
      ddr_control_area_push_data_reg <= 128'h0;
    end else begin
      ddr_control_area_cmd_can_send <= ((io_cmd_ready && io_wr_data_rdy) && io_init_calib_complete);
      if(cmd_fifo_io_pop_fire) begin
        ddr_control_area_cmd_free <= 1'b0;
        ddr_control_area_cmd_trigger <= 1'b1;
        ddr_control_area_burst_cnt <= 7'h0;
      end
      if(ddr_control_area_data_fire) begin
        ddr_control_area_burst_cnt <= (ddr_control_area_burst_cnt + 7'h01);
      end
      if(ddr_control_area_cmd_trigger) begin
        ddr_control_area_cmd_trigger <= 1'b0;
      end
      if(when_axi4ddrgowin_l712) begin
        if(when_axi4ddrgowin_l713) begin
          ddr_control_area_cmd_free <= 1'b1;
        end
      end
      ddr_control_area_push_valid_reg <= (io_rd_data_valid && (ddr_control_area_burst_cnt == _zz_ddr_control_area_push_valid_reg));
      ddr_control_area_push_context_reg <= ddr_control_area_cmd_context;
      if(when_axi4ddrgowin_l735) begin
        ddr_control_area_push_data_reg[127 : 0] <= io_rd_data;
      end
    end
  end

  always @(posedge clk_out) begin
    if(cmd_fifo_io_pop_fire) begin
      ddr_control_area_cmd_cmdtype <= cmd_fifo_io_pop_payload_cmdtype;
      ddr_control_area_cmd_addr <= cmd_fifo_io_pop_payload_addr;
      ddr_control_area_cmd_burst_cnt <= cmd_fifo_io_pop_payload_burst_cnt;
      ddr_control_area_cmd_wr_data <= cmd_fifo_io_pop_payload_wr_data;
      ddr_control_area_cmd_wr_mask <= cmd_fifo_io_pop_payload_wr_mask;
      ddr_control_area_cmd_context <= cmd_fifo_io_pop_payload_context;
    end
  end


endmodule

module RiscvCore (
  input  wire          io_interrupt_1,
  input  wire          io_interrupt_0,
  input  wire          io_interrupt_3,
  input  wire          io_interrupt_2,
  output wire          io_i_cmd_valid,
  input  wire          io_i_cmd_ready,
  output wire [31:0]   io_i_cmd_payload_pc,
  input  wire          io_i_branchCachePort_cmd_valid,
  input  wire [6:0]    io_i_branchCachePort_cmd_payload,
  output wire [22:0]   io_i_branchCachePort_rsp_pc,
  output wire [1:0]    io_i_branchCachePort_rsp_history,
  input  wire          io_i_rsp_valid,
  output wire          io_i_rsp_ready,
  input  wire [31:0]   io_i_rsp_payload_instruction,
  input  wire [31:0]   io_i_rsp_payload_pc,
  input  wire [22:0]   io_i_rsp_payload_branchCacheLine_pc,
  input  wire [1:0]    io_i_rsp_payload_branchCacheLine_history,
  output wire          io_d_cmd_valid,
  input  wire          io_d_cmd_ready,
  output wire          io_d_cmd_payload_wr,
  output wire [31:0]   io_d_cmd_payload_address,
  output wire [31:0]   io_d_cmd_payload_data,
  output wire [1:0]    io_d_cmd_payload_size,
  input  wire          io_d_rsp_valid,
  output wire          io_d_rsp_ready,
  input  wire [31:0]   io_d_rsp_payload,
  input  wire          _zz_9,
  input  wire          _zz_10,
  input  wire [7:0]    _zz_decode_regFileReadAddress0,
  input  wire [31:0]   _zz_prefetch_pc,
  output reg  [31:0]   _zz_io_debugBus_PRDATA,
  output wire          _zz_io_debugResetOut,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset,
  input  wire          io_debugResetIn
);
  localparam BR_N = 4'd8;
  localparam BR_NE = 4'd1;
  localparam BR_EQ = 4'd0;
  localparam BR_GE = 4'd5;
  localparam BR_GEU = 4'd7;
  localparam BR_LT = 4'd4;
  localparam BR_LTU = 4'd6;
  localparam BR_J = 4'd2;
  localparam BR_JR = 4'd3;
  localparam OP0_RS = 2'd0;
  localparam OP0_IMU = 2'd1;
  localparam OP0_IMZ = 2'd2;
  localparam OP0_IMJB = 2'd3;
  localparam OP1_RS = 2'd0;
  localparam OP1_IMI = 2'd1;
  localparam OP1_IMS = 2'd2;
  localparam OP1_PC = 2'd3;
  localparam ALU_ADD = 4'd0;
  localparam ALU_SLL1 = 4'd1;
  localparam ALU_SLT = 4'd2;
  localparam ALU_SLTU = 4'd3;
  localparam ALU_XOR_1 = 4'd4;
  localparam ALU_SRL_1 = 4'd5;
  localparam ALU_OR_1 = 4'd6;
  localparam ALU_AND_1 = 4'd7;
  localparam ALU_SUB = 4'd8;
  localparam ALU_COPY = 4'd15;
  localparam ALU_SRA_1 = 4'd13;
  localparam WB_ALU = 2'd0;
  localparam WB_MEM = 2'd1;
  localparam WB_PC4 = 2'd2;
  localparam WB_CSR1 = 2'd3;
  localparam M_XRD = 1'd0;
  localparam M_XWR = 1'd1;
  localparam MSK_B = 2'd0;
  localparam MSK_H = 2'd1;
  localparam MSK_W = 2'd2;
  localparam CSR_N = 2'd0;
  localparam CSR_W = 2'd1;
  localparam CSR_S = 2'd2;
  localparam CSR_C = 2'd3;
  localparam MFS_N = 3'd0;
  localparam MFS_SI = 3'd1;
  localparam MFS_SD = 3'd2;
  localparam MFS_FA = 3'd3;
  localparam MFS_FD = 3'd4;
  localparam PC_INC = 2'd0;
  localparam PC_BRA = 2'd1;
  localparam PC_J = 2'd2;
  localparam PC_JR = 2'd3;

  reg                 DivExtension_divider_io_cmd_valid;
  wire                DivExtension_divider_io_cmd_payload_signed;
  reg                 DivExtension_divider_io_rsp_ready;
  reg        [31:0]   regFile_spinal_port0;
  reg        [31:0]   regFile_spinal_port1;
  reg        [24:0]   brancheCache_spinal_port1;
  wire       [31:0]   execute0_alu_io_result;
  wire       [31:0]   execute0_alu_io_adder;
  wire                DivExtension_divider_io_cmd_ready;
  wire                DivExtension_divider_io_rsp_valid;
  wire       [31:0]   DivExtension_divider_io_rsp_payload_quotient;
  wire       [31:0]   DivExtension_divider_io_rsp_payload_remainder;
  wire                DivExtension_divider_io_rsp_payload_error;
  wire       [1:0]    _zz_fetch_throwRemaining;
  wire       [0:0]    _zz_fetch_throwRemaining_1;
  wire                _zz_regFile_port;
  wire                _zz_decode_src0;
  wire                _zz_regFile_port_1;
  wire                _zz_decode_src1;
  wire       [19:0]   _zz__zz_decode_brjmpImm;
  wire       [11:0]   _zz__zz_decode_brjmpImm_2;
  wire                _zz_decode_brjmpImm_4;
  wire                _zz_decode_brjmpImm_5;
  wire                _zz_decode_brjmpImm_6;
  wire       [4:0]    _zz__zz_decode_outInst_payload_alu_op0;
  wire       [11:0]   _zz__zz_decode_outInst_payload_alu_op1_2;
  wire       [3:0]    _zz_execute0_br_signed;
  wire       [32:0]   _zz_execute0_br_ltx;
  wire       [2:0]    _zz_execute1_newHistory;
  wire       [2:0]    _zz_execute1_newHistory_1;
  wire       [1:0]    _zz_execute1_newHistory_2;
  wire       [0:0]    _zz_execute1_line_history;
  wire       [1:0]    _zz_when_RiscvCore_l793;
  wire       [1:0]    _zz_when_RiscvCore_l793_1;
  wire       [6:0]    _zz_brancheCache_port;
  wire       [24:0]   _zz_brancheCache_port_1;
  wire       [49:0]   _zz_MulExtension_s2_low;
  wire       [49:0]   _zz_MulExtension_s2_low_1;
  wire       [35:0]   _zz_MulExtension_s2_low_2;
  wire       [35:0]   _zz_MulExtension_s2_low_3;
  wire       [32:0]   _zz_MulExtension_s2_low_4;
  wire       [49:0]   _zz_MulExtension_s2_low_5;
  wire       [49:0]   _zz_MulExtension_s2_low_6;
  wire       [65:0]   _zz_MulExtension_s3_result;
  wire       [65:0]   _zz_MulExtension_s3_result_1;
  wire       [31:0]   _zz_writeBack_inInst_payload_result;
  wire       [31:0]   _zz_writeBack_inInst_payload_result_1;
  wire       [31:0]   _zz_BarrelShifterFullExtension_s1_shiftRight;
  wire       [32:0]   _zz_BarrelShifterFullExtension_s1_shiftRight_1;
  wire       [32:0]   _zz_BarrelShifterFullExtension_s1_shiftRight_2;
  reg                 _zz_1;
  reg                 _zz_2;
  reg                 iCmd_valid;
  wire                iCmd_ready;
  wire       [31:0]   iCmd_payload_pc;
  wire                iRsp_valid;
  reg                 iRsp_ready;
  wire       [31:0]   iRsp_payload_instruction;
  wire       [31:0]   iRsp_payload_pc;
  wire       [22:0]   iRsp_payload_branchCacheLine_pc;
  wire       [1:0]    iRsp_payload_branchCacheLine_history;
  wire                dCmd_valid;
  wire                dCmd_ready;
  wire                dCmd_payload_wr;
  wire       [31:0]   dCmd_payload_address;
  wire       [31:0]   dCmd_payload_data;
  wire       [1:0]    dCmd_payload_size;
  wire                dRsp_valid;
  reg                 dRsp_ready;
  wire       [31:0]   dRsp_payload;
  reg                 prefetch_halt;
  reg        [31:0]   prefetch_pc;
  reg                 prefetch_inc;
  (* keep *) wire       [31:0]   _zz_prefetch_pcNext;
  reg        [31:0]   prefetch_pcNext;
  reg                 prefetch_pcLoad_valid;
  reg        [31:0]   prefetch_pcLoad_payload;
  reg                 prefetch_resetDone;
  wire                iCmd_fire;
  wire                when_RiscvCore_l530;
  wire                fetch_outInst_valid;
  reg                 fetch_outInst_ready;
  wire       [31:0]   fetch_outInst_payload_pc;
  wire       [31:0]   fetch_outInst_payload_instruction;
  wire       [22:0]   fetch_outInst_payload_branchCacheLine_pc;
  wire       [1:0]    fetch_outInst_payload_branchCacheLine_history;
  reg                 fetch_throwIt;
  reg                 fetch_flush;
  wire                iRsp_fire;
  reg                 fetch_pendingPrefetch_incrementIt;
  reg                 fetch_pendingPrefetch_decrementIt;
  wire       [1:0]    fetch_pendingPrefetch_valueNext;
  reg        [1:0]    fetch_pendingPrefetch_value;
  wire                fetch_pendingPrefetch_mayOverflow;
  wire                fetch_pendingPrefetch_mayUnderflow;
  wire                fetch_pendingPrefetch_willOverflowIfInc;
  wire                fetch_pendingPrefetch_willOverflow;
  wire                fetch_pendingPrefetch_willUnderflowIfDec;
  wire                fetch_pendingPrefetch_willUnderflow;
  reg        [1:0]    fetch_pendingPrefetch_finalIncrement;
  wire                when_Utils_l751;
  wire                when_Utils_l753;
  wire                when_RiscvCore_l552;
  reg        [1:0]    fetch_throwRemaining;
  wire                fetch_throwNextIRsp;
  wire                when_RiscvCore_l558;
  wire                when_Stream_l486;
  reg                 iRsp_throwWhen_valid;
  wire                iRsp_throwWhen_ready;
  wire       [31:0]   iRsp_throwWhen_payload_instruction;
  wire       [31:0]   iRsp_throwWhen_payload_pc;
  wire       [22:0]   iRsp_throwWhen_payload_branchCacheLine_pc;
  wire       [1:0]    iRsp_throwWhen_payload_branchCacheLine_history;
  wire                decode_inInst_valid;
  reg                 decode_inInst_ready;
  wire       [31:0]   decode_inInst_payload_pc;
  wire       [31:0]   decode_inInst_payload_instruction;
  wire       [22:0]   decode_inInst_payload_branchCacheLine_pc;
  wire       [1:0]    decode_inInst_payload_branchCacheLine_history;
  reg                 fetch_outInst_rValid;
  reg        [31:0]   fetch_outInst_rData_pc;
  reg        [31:0]   fetch_outInst_rData_instruction;
  reg        [22:0]   fetch_outInst_rData_branchCacheLine_pc;
  reg        [1:0]    fetch_outInst_rData_branchCacheLine_history;
  wire                when_Stream_l399;
  reg                 decode_ctrl_instVal;
  reg        [3:0]    decode_ctrl_br;
  reg                 decode_ctrl_jmp;
  reg        [1:0]    decode_ctrl_op0;
  reg        [1:0]    decode_ctrl_op1;
  reg        [3:0]    decode_ctrl_alu;
  reg        [1:0]    decode_ctrl_wb;
  reg                 decode_ctrl_rfen;
  reg                 decode_ctrl_execute0AluBypass;
  reg                 decode_ctrl_execute1AluBypass;
  wire                decode_ctrl_canInternalyStallWriteBack0;
  reg                 decode_ctrl_men;
  reg        [0:0]    decode_ctrl_m;
  wire       [1:0]    decode_ctrl_msk;
  reg        [1:0]    decode_ctrl_csr;
  wire       [2:0]    decode_ctrl_mfs;
  reg                 decode_ctrl_useSrc0;
  reg                 decode_ctrl_useSrc1;
  reg        [2:0]    decode_ctrl_extensionTag;
  reg                 decode_ctrl_fencei;
  wire       [1:0]    _zz_decode_ctrl_msk;
  wire                when_Misc_l166;
  wire                when_Misc_l168;
  wire                when_Misc_l174;
  wire                when_Misc_l185;
  wire                when_Misc_l195;
  wire                when_Misc_l204;
  wire                _zz_decode_ctrl_execute0AluBypass;
  wire                when_Misc_l206;
  wire                when_Misc_l207;
  wire       [3:0]    _zz_decode_ctrl_alu;
  wire                when_Misc_l219;
  wire                when_Misc_l220;
  wire       [3:0]    _zz_decode_ctrl_alu_1;
  wire                when_Misc_l235;
  wire                when_Misc_l245;
  wire                when_Misc_l256;
  wire       [3:0]    _zz_decode_ctrl_br;
  wire                when_Misc_l265;
  wire                when_Misc_l267;
  wire       [1:0]    _zz_decode_ctrl_csr;
  wire                when_MulExtension_l89;
  wire                when_DivExtension_l52;
  wire                when_SimpleInterruptExtension_l85;
  wire                when_SimpleInterruptExtension_l90;
  wire                when_DebugExtension_l192;
  wire                decode_hazard;
  reg                 decode_throwIt;
  reg                 decode_halt;
  wire       [4:0]    decode_addr0;
  wire       [4:0]    decode_addr1;
  wire                decode_addr0IsZero;
  wire                decode_addr1IsZero;
  wire                decode_inInst_isStall;
  wire       [31:0]   decode_srcInstruction;
  reg        [4:0]    decode_regFileReadAddress0;
  wire       [4:0]    decode_regFileReadAddress1;
  reg        [31:0]   decode_src0;
  reg        [31:0]   decode_src1;
  wire                _zz_decode_brjmpImm;
  reg        [10:0]   _zz_decode_brjmpImm_1;
  wire                _zz_decode_brjmpImm_2;
  reg        [18:0]   _zz_decode_brjmpImm_3;
  wire       [31:0]   decode_brjmpImm;
  wire       [31:0]   decode_brJumpPc;
  wire                decode_branchCacheHit;
  wire                decode_staticBranchPrediction;
  reg                 decode_shouldTakeBranch;
  wire                decode_outInst_valid;
  wire                decode_outInst_ready;
  wire       [31:0]   decode_outInst_payload_pc;
  wire       [31:0]   decode_outInst_payload_instruction;
  wire                decode_outInst_payload_ctrl_instVal;
  wire       [3:0]    decode_outInst_payload_ctrl_br;
  wire                decode_outInst_payload_ctrl_jmp;
  wire       [1:0]    decode_outInst_payload_ctrl_op0;
  wire       [1:0]    decode_outInst_payload_ctrl_op1;
  wire       [3:0]    decode_outInst_payload_ctrl_alu;
  wire       [1:0]    decode_outInst_payload_ctrl_wb;
  wire                decode_outInst_payload_ctrl_rfen;
  wire                decode_outInst_payload_ctrl_execute0AluBypass;
  wire                decode_outInst_payload_ctrl_execute1AluBypass;
  wire                decode_outInst_payload_ctrl_canInternalyStallWriteBack0;
  wire                decode_outInst_payload_ctrl_men;
  wire       [0:0]    decode_outInst_payload_ctrl_m;
  wire       [1:0]    decode_outInst_payload_ctrl_msk;
  wire       [1:0]    decode_outInst_payload_ctrl_csr;
  wire       [2:0]    decode_outInst_payload_ctrl_mfs;
  wire                decode_outInst_payload_ctrl_useSrc0;
  wire                decode_outInst_payload_ctrl_useSrc1;
  wire       [2:0]    decode_outInst_payload_ctrl_extensionTag;
  wire                decode_outInst_payload_ctrl_fencei;
  wire       [31:0]   decode_outInst_payload_src0;
  wire       [31:0]   decode_outInst_payload_src1;
  wire       [31:0]   decode_outInst_payload_alu_op0;
  wire       [31:0]   decode_outInst_payload_alu_op1;
  wire                decode_outInst_payload_doSub;
  wire                decode_outInst_payload_predictorHasBranch;
  wire                decode_outInst_payload_branchHistory_valid;
  wire       [1:0]    decode_outInst_payload_branchHistory_payload;
  wire                decode_pcLoad_valid;
  wire       [31:0]   decode_pcLoad_payload;
  reg                 decode_inInst_throwWhen_valid;
  wire                decode_inInst_throwWhen_ready;
  wire       [31:0]   decode_inInst_throwWhen_payload_pc;
  wire       [31:0]   decode_inInst_throwWhen_payload_instruction;
  wire       [22:0]   decode_inInst_throwWhen_payload_branchCacheLine_pc;
  wire       [1:0]    decode_inInst_throwWhen_payload_branchCacheLine_history;
  wire                _zz_decode_inInst_throwWhen_ready;
  wire                decode_inInst_throwWhen_haltWhen_valid;
  wire                decode_inInst_throwWhen_haltWhen_ready;
  wire       [31:0]   decode_inInst_throwWhen_haltWhen_payload_pc;
  wire       [31:0]   decode_inInst_throwWhen_haltWhen_payload_instruction;
  wire       [22:0]   decode_inInst_throwWhen_haltWhen_payload_branchCacheLine_pc;
  wire       [1:0]    decode_inInst_throwWhen_haltWhen_payload_branchCacheLine_history;
  reg        [31:0]   _zz_decode_outInst_payload_alu_op0;
  wire                _zz_decode_outInst_payload_alu_op1;
  reg        [19:0]   _zz_decode_outInst_payload_alu_op1_1;
  wire                _zz_decode_outInst_payload_alu_op1_2;
  reg        [19:0]   _zz_decode_outInst_payload_alu_op1_3;
  reg        [31:0]   _zz_decode_outInst_payload_alu_op1_4;
  wire                decode_flush;
  wire                execute0_inInst_valid;
  reg                 execute0_inInst_ready;
  wire       [31:0]   execute0_inInst_payload_pc;
  wire       [31:0]   execute0_inInst_payload_instruction;
  wire                execute0_inInst_payload_ctrl_instVal;
  wire       [3:0]    execute0_inInst_payload_ctrl_br;
  wire                execute0_inInst_payload_ctrl_jmp;
  wire       [1:0]    execute0_inInst_payload_ctrl_op0;
  wire       [1:0]    execute0_inInst_payload_ctrl_op1;
  wire       [3:0]    execute0_inInst_payload_ctrl_alu;
  wire       [1:0]    execute0_inInst_payload_ctrl_wb;
  wire                execute0_inInst_payload_ctrl_rfen;
  wire                execute0_inInst_payload_ctrl_execute0AluBypass;
  wire                execute0_inInst_payload_ctrl_execute1AluBypass;
  wire                execute0_inInst_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute0_inInst_payload_ctrl_men;
  wire       [0:0]    execute0_inInst_payload_ctrl_m;
  wire       [1:0]    execute0_inInst_payload_ctrl_msk;
  wire       [1:0]    execute0_inInst_payload_ctrl_csr;
  wire       [2:0]    execute0_inInst_payload_ctrl_mfs;
  wire                execute0_inInst_payload_ctrl_useSrc0;
  wire                execute0_inInst_payload_ctrl_useSrc1;
  wire       [2:0]    execute0_inInst_payload_ctrl_extensionTag;
  wire                execute0_inInst_payload_ctrl_fencei;
  wire       [31:0]   execute0_inInst_payload_src0;
  wire       [31:0]   execute0_inInst_payload_src1;
  wire       [31:0]   execute0_inInst_payload_alu_op0;
  wire       [31:0]   execute0_inInst_payload_alu_op1;
  wire                execute0_inInst_payload_doSub;
  wire                execute0_inInst_payload_predictorHasBranch;
  wire                execute0_inInst_payload_branchHistory_valid;
  wire       [1:0]    execute0_inInst_payload_branchHistory_payload;
  reg                 decode_outInst_rValid;
  reg        [31:0]   decode_outInst_rData_pc;
  reg        [31:0]   decode_outInst_rData_instruction;
  reg                 decode_outInst_rData_ctrl_instVal;
  reg        [3:0]    decode_outInst_rData_ctrl_br;
  reg                 decode_outInst_rData_ctrl_jmp;
  reg        [1:0]    decode_outInst_rData_ctrl_op0;
  reg        [1:0]    decode_outInst_rData_ctrl_op1;
  reg        [3:0]    decode_outInst_rData_ctrl_alu;
  reg        [1:0]    decode_outInst_rData_ctrl_wb;
  reg                 decode_outInst_rData_ctrl_rfen;
  reg                 decode_outInst_rData_ctrl_execute0AluBypass;
  reg                 decode_outInst_rData_ctrl_execute1AluBypass;
  reg                 decode_outInst_rData_ctrl_canInternalyStallWriteBack0;
  reg                 decode_outInst_rData_ctrl_men;
  reg        [0:0]    decode_outInst_rData_ctrl_m;
  reg        [1:0]    decode_outInst_rData_ctrl_msk;
  reg        [1:0]    decode_outInst_rData_ctrl_csr;
  reg        [2:0]    decode_outInst_rData_ctrl_mfs;
  reg                 decode_outInst_rData_ctrl_useSrc0;
  reg                 decode_outInst_rData_ctrl_useSrc1;
  reg        [2:0]    decode_outInst_rData_ctrl_extensionTag;
  reg                 decode_outInst_rData_ctrl_fencei;
  reg        [31:0]   decode_outInst_rData_src0;
  reg        [31:0]   decode_outInst_rData_src1;
  reg        [31:0]   decode_outInst_rData_alu_op0;
  reg        [31:0]   decode_outInst_rData_alu_op1;
  reg                 decode_outInst_rData_doSub;
  reg                 decode_outInst_rData_predictorHasBranch;
  reg                 decode_outInst_rData_branchHistory_valid;
  reg        [1:0]    decode_outInst_rData_branchHistory_payload;
  reg                 execute0_throwIt;
  reg                 execute0_halt;
  wire                execute0_haltFromDataRequest;
  wire                execute0_br_signed;
  wire       [32:0]   execute0_br_src0Ext;
  wire       [32:0]   execute0_br_src1Ext;
  wire                execute0_br_ltx;
  wire                execute0_br_eq;
  wire       [1:0]    _zz_execute0_br_pc_sel;
  wire       [1:0]    _zz_execute0_br_pc_sel_1;
  wire       [1:0]    _zz_execute0_br_pc_sel_2;
  wire       [1:0]    _zz_execute0_br_pc_sel_3;
  reg        [1:0]    execute0_br_pc_sel;
  wire                execute0_outInst_valid;
  wire                execute0_outInst_ready;
  wire       [31:0]   execute0_outInst_payload_pc;
  wire       [31:0]   execute0_outInst_payload_instruction;
  wire                execute0_outInst_payload_ctrl_instVal;
  wire       [3:0]    execute0_outInst_payload_ctrl_br;
  wire                execute0_outInst_payload_ctrl_jmp;
  wire       [1:0]    execute0_outInst_payload_ctrl_op0;
  wire       [1:0]    execute0_outInst_payload_ctrl_op1;
  wire       [3:0]    execute0_outInst_payload_ctrl_alu;
  wire       [1:0]    execute0_outInst_payload_ctrl_wb;
  wire                execute0_outInst_payload_ctrl_rfen;
  wire                execute0_outInst_payload_ctrl_execute0AluBypass;
  wire                execute0_outInst_payload_ctrl_execute1AluBypass;
  wire                execute0_outInst_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute0_outInst_payload_ctrl_men;
  wire       [0:0]    execute0_outInst_payload_ctrl_m;
  wire       [1:0]    execute0_outInst_payload_ctrl_msk;
  wire       [1:0]    execute0_outInst_payload_ctrl_csr;
  wire       [2:0]    execute0_outInst_payload_ctrl_mfs;
  wire                execute0_outInst_payload_ctrl_useSrc0;
  wire                execute0_outInst_payload_ctrl_useSrc1;
  wire       [2:0]    execute0_outInst_payload_ctrl_extensionTag;
  wire                execute0_outInst_payload_ctrl_fencei;
  wire                execute0_outInst_payload_br_eq;
  wire                execute0_outInst_payload_br_ltx;
  wire       [31:0]   execute0_outInst_payload_src1;
  wire       [31:0]   execute0_outInst_payload_result;
  wire       [31:0]   execute0_outInst_payload_adder;
  wire                execute0_outInst_payload_predictorHasBranch;
  wire                execute0_outInst_payload_branchHistory_valid;
  wire       [1:0]    execute0_outInst_payload_branchHistory_payload;
  wire       [31:0]   execute0_outInst_payload_pcPlus4;
  wire       [1:0]    execute0_outInst_payload_pc_sel;
  wire                execute0_outInst_payload_unalignedMemoryAccessException;
  wire                execute0_outInst_payload_needMemRsp;
  wire       [31:0]   execute0_outInst_payload_dCmdAddress;
  reg                 execute0_inInst_throwWhen_valid;
  wire                execute0_inInst_throwWhen_ready;
  wire       [31:0]   execute0_inInst_throwWhen_payload_pc;
  wire       [31:0]   execute0_inInst_throwWhen_payload_instruction;
  wire                execute0_inInst_throwWhen_payload_ctrl_instVal;
  wire       [3:0]    execute0_inInst_throwWhen_payload_ctrl_br;
  wire                execute0_inInst_throwWhen_payload_ctrl_jmp;
  wire       [1:0]    execute0_inInst_throwWhen_payload_ctrl_op0;
  wire       [1:0]    execute0_inInst_throwWhen_payload_ctrl_op1;
  wire       [3:0]    execute0_inInst_throwWhen_payload_ctrl_alu;
  wire       [1:0]    execute0_inInst_throwWhen_payload_ctrl_wb;
  wire                execute0_inInst_throwWhen_payload_ctrl_rfen;
  wire                execute0_inInst_throwWhen_payload_ctrl_execute0AluBypass;
  wire                execute0_inInst_throwWhen_payload_ctrl_execute1AluBypass;
  wire                execute0_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute0_inInst_throwWhen_payload_ctrl_men;
  wire       [0:0]    execute0_inInst_throwWhen_payload_ctrl_m;
  wire       [1:0]    execute0_inInst_throwWhen_payload_ctrl_msk;
  wire       [1:0]    execute0_inInst_throwWhen_payload_ctrl_csr;
  wire       [2:0]    execute0_inInst_throwWhen_payload_ctrl_mfs;
  wire                execute0_inInst_throwWhen_payload_ctrl_useSrc0;
  wire                execute0_inInst_throwWhen_payload_ctrl_useSrc1;
  wire       [2:0]    execute0_inInst_throwWhen_payload_ctrl_extensionTag;
  wire                execute0_inInst_throwWhen_payload_ctrl_fencei;
  wire       [31:0]   execute0_inInst_throwWhen_payload_src0;
  wire       [31:0]   execute0_inInst_throwWhen_payload_src1;
  wire       [31:0]   execute0_inInst_throwWhen_payload_alu_op0;
  wire       [31:0]   execute0_inInst_throwWhen_payload_alu_op1;
  wire                execute0_inInst_throwWhen_payload_doSub;
  wire                execute0_inInst_throwWhen_payload_predictorHasBranch;
  wire                execute0_inInst_throwWhen_payload_branchHistory_valid;
  wire       [1:0]    execute0_inInst_throwWhen_payload_branchHistory_payload;
  wire                _zz_execute0_inInst_throwWhen_ready;
  wire                execute0_inInst_throwWhen_haltWhen_valid;
  wire                execute0_inInst_throwWhen_haltWhen_ready;
  wire       [31:0]   execute0_inInst_throwWhen_haltWhen_payload_pc;
  wire       [31:0]   execute0_inInst_throwWhen_haltWhen_payload_instruction;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_instVal;
  wire       [3:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_br;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_jmp;
  wire       [1:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0;
  wire       [1:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1;
  wire       [3:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu;
  wire       [1:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_rfen;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_execute0AluBypass;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_execute1AluBypass;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_men;
  wire       [0:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_m;
  wire       [1:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk;
  wire       [1:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr;
  wire       [2:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_useSrc0;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_useSrc1;
  wire       [2:0]    execute0_inInst_throwWhen_haltWhen_payload_ctrl_extensionTag;
  wire                execute0_inInst_throwWhen_haltWhen_payload_ctrl_fencei;
  wire       [31:0]   execute0_inInst_throwWhen_haltWhen_payload_src0;
  wire       [31:0]   execute0_inInst_throwWhen_haltWhen_payload_src1;
  wire       [31:0]   execute0_inInst_throwWhen_haltWhen_payload_alu_op0;
  wire       [31:0]   execute0_inInst_throwWhen_haltWhen_payload_alu_op1;
  wire                execute0_inInst_throwWhen_haltWhen_payload_doSub;
  wire                execute0_inInst_throwWhen_haltWhen_payload_predictorHasBranch;
  wire                execute0_inInst_throwWhen_haltWhen_payload_branchHistory_valid;
  wire       [1:0]    execute0_inInst_throwWhen_haltWhen_payload_branchHistory_payload;
  reg                 _zz_execute0_outInst_payload_unalignedMemoryAccessException;
  reg        [1:0]    _zz_dCmd_payload_size;
  reg        [1:0]    execute0_pendingDataCmd_readCount;
  wire                dCmd_fire;
  wire                execute0_pendingDataCmd_readCountInc;
  wire                execute0_pendingDataCmd_readCountDec;
  wire                when_RiscvCore_l742;
  wire                when_RiscvCore_l745;
  reg                 execute0_flush;
  wire                execute1_inInst_valid;
  reg                 execute1_inInst_ready;
  wire       [31:0]   execute1_inInst_payload_pc;
  wire       [31:0]   execute1_inInst_payload_instruction;
  wire                execute1_inInst_payload_ctrl_instVal;
  wire       [3:0]    execute1_inInst_payload_ctrl_br;
  wire                execute1_inInst_payload_ctrl_jmp;
  wire       [1:0]    execute1_inInst_payload_ctrl_op0;
  wire       [1:0]    execute1_inInst_payload_ctrl_op1;
  wire       [3:0]    execute1_inInst_payload_ctrl_alu;
  wire       [1:0]    execute1_inInst_payload_ctrl_wb;
  wire                execute1_inInst_payload_ctrl_rfen;
  wire                execute1_inInst_payload_ctrl_execute0AluBypass;
  wire                execute1_inInst_payload_ctrl_execute1AluBypass;
  wire                execute1_inInst_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute1_inInst_payload_ctrl_men;
  wire       [0:0]    execute1_inInst_payload_ctrl_m;
  wire       [1:0]    execute1_inInst_payload_ctrl_msk;
  wire       [1:0]    execute1_inInst_payload_ctrl_csr;
  wire       [2:0]    execute1_inInst_payload_ctrl_mfs;
  wire                execute1_inInst_payload_ctrl_useSrc0;
  wire                execute1_inInst_payload_ctrl_useSrc1;
  wire       [2:0]    execute1_inInst_payload_ctrl_extensionTag;
  wire                execute1_inInst_payload_ctrl_fencei;
  wire                execute1_inInst_payload_br_eq;
  wire                execute1_inInst_payload_br_ltx;
  wire       [31:0]   execute1_inInst_payload_src1;
  wire       [31:0]   execute1_inInst_payload_result;
  reg        [31:0]   execute1_inInst_payload_adder;
  wire                execute1_inInst_payload_predictorHasBranch;
  wire                execute1_inInst_payload_branchHistory_valid;
  wire       [1:0]    execute1_inInst_payload_branchHistory_payload;
  wire       [31:0]   execute1_inInst_payload_pcPlus4;
  reg        [1:0]    execute1_inInst_payload_pc_sel;
  wire                execute1_inInst_payload_unalignedMemoryAccessException;
  wire                execute1_inInst_payload_needMemRsp;
  wire       [31:0]   execute1_inInst_payload_dCmdAddress;
  reg                 execute0_outInst_rValid;
  reg        [31:0]   execute0_outInst_rData_pc;
  reg        [31:0]   execute0_outInst_rData_instruction;
  reg                 execute0_outInst_rData_ctrl_instVal;
  reg        [3:0]    execute0_outInst_rData_ctrl_br;
  reg                 execute0_outInst_rData_ctrl_jmp;
  reg        [1:0]    execute0_outInst_rData_ctrl_op0;
  reg        [1:0]    execute0_outInst_rData_ctrl_op1;
  reg        [3:0]    execute0_outInst_rData_ctrl_alu;
  reg        [1:0]    execute0_outInst_rData_ctrl_wb;
  reg                 execute0_outInst_rData_ctrl_rfen;
  reg                 execute0_outInst_rData_ctrl_execute0AluBypass;
  reg                 execute0_outInst_rData_ctrl_execute1AluBypass;
  reg                 execute0_outInst_rData_ctrl_canInternalyStallWriteBack0;
  reg                 execute0_outInst_rData_ctrl_men;
  reg        [0:0]    execute0_outInst_rData_ctrl_m;
  reg        [1:0]    execute0_outInst_rData_ctrl_msk;
  reg        [1:0]    execute0_outInst_rData_ctrl_csr;
  reg        [2:0]    execute0_outInst_rData_ctrl_mfs;
  reg                 execute0_outInst_rData_ctrl_useSrc0;
  reg                 execute0_outInst_rData_ctrl_useSrc1;
  reg        [2:0]    execute0_outInst_rData_ctrl_extensionTag;
  reg                 execute0_outInst_rData_ctrl_fencei;
  reg                 execute0_outInst_rData_br_eq;
  reg                 execute0_outInst_rData_br_ltx;
  reg        [31:0]   execute0_outInst_rData_src1;
  reg        [31:0]   execute0_outInst_rData_result;
  reg        [31:0]   execute0_outInst_rData_adder;
  reg                 execute0_outInst_rData_predictorHasBranch;
  reg                 execute0_outInst_rData_branchHistory_valid;
  reg        [1:0]    execute0_outInst_rData_branchHistory_payload;
  reg        [31:0]   execute0_outInst_rData_pcPlus4;
  reg        [1:0]    execute0_outInst_rData_pc_sel;
  reg                 execute0_outInst_rData_unalignedMemoryAccessException;
  reg                 execute0_outInst_rData_needMemRsp;
  reg        [31:0]   execute0_outInst_rData_dCmdAddress;
  reg                 execute1_halt;
  reg                 execute1_throwIt;
  wire                execute1_pcLoad_valid;
  wire       [31:0]   execute1_pcLoad_payload;
  wire                execute1_inInst_fire;
  reg                 _zz_execute1_pcLoad_valid;
  reg        [31:0]   _zz_execute1_pcLoad_payload;
  wire       [22:0]   execute1_line_pc;
  reg        [1:0]    execute1_line_history;
  wire       [2:0]    execute1_newHistory;
  wire                when_RiscvCore_l792;
  wire                when_RiscvCore_l793;
  wire                execute1_outInst_valid;
  wire                execute1_outInst_ready;
  wire       [31:0]   execute1_outInst_payload_pc;
  wire       [31:0]   execute1_outInst_payload_instruction;
  wire                execute1_outInst_payload_ctrl_instVal;
  wire       [3:0]    execute1_outInst_payload_ctrl_br;
  wire                execute1_outInst_payload_ctrl_jmp;
  wire       [1:0]    execute1_outInst_payload_ctrl_op0;
  wire       [1:0]    execute1_outInst_payload_ctrl_op1;
  wire       [3:0]    execute1_outInst_payload_ctrl_alu;
  wire       [1:0]    execute1_outInst_payload_ctrl_wb;
  wire                execute1_outInst_payload_ctrl_rfen;
  wire                execute1_outInst_payload_ctrl_execute0AluBypass;
  wire                execute1_outInst_payload_ctrl_execute1AluBypass;
  wire                execute1_outInst_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute1_outInst_payload_ctrl_men;
  wire       [0:0]    execute1_outInst_payload_ctrl_m;
  wire       [1:0]    execute1_outInst_payload_ctrl_msk;
  wire       [1:0]    execute1_outInst_payload_ctrl_csr;
  wire       [2:0]    execute1_outInst_payload_ctrl_mfs;
  wire                execute1_outInst_payload_ctrl_useSrc0;
  wire                execute1_outInst_payload_ctrl_useSrc1;
  wire       [2:0]    execute1_outInst_payload_ctrl_extensionTag;
  wire                execute1_outInst_payload_ctrl_fencei;
  reg        [31:0]   execute1_outInst_payload_result;
  wire       [4:0]    execute1_outInst_payload_regFileAddress;
  wire       [31:0]   execute1_outInst_payload_pcPlus4;
  wire                execute1_outInst_payload_unalignedMemoryAccessException;
  wire                execute1_outInst_payload_needMemRsp;
  wire       [31:0]   execute1_outInst_payload_dCmdAddress;
  reg                 execute1_inInst_throwWhen_valid;
  wire                execute1_inInst_throwWhen_ready;
  wire       [31:0]   execute1_inInst_throwWhen_payload_pc;
  wire       [31:0]   execute1_inInst_throwWhen_payload_instruction;
  wire                execute1_inInst_throwWhen_payload_ctrl_instVal;
  wire       [3:0]    execute1_inInst_throwWhen_payload_ctrl_br;
  wire                execute1_inInst_throwWhen_payload_ctrl_jmp;
  wire       [1:0]    execute1_inInst_throwWhen_payload_ctrl_op0;
  wire       [1:0]    execute1_inInst_throwWhen_payload_ctrl_op1;
  wire       [3:0]    execute1_inInst_throwWhen_payload_ctrl_alu;
  wire       [1:0]    execute1_inInst_throwWhen_payload_ctrl_wb;
  wire                execute1_inInst_throwWhen_payload_ctrl_rfen;
  wire                execute1_inInst_throwWhen_payload_ctrl_execute0AluBypass;
  wire                execute1_inInst_throwWhen_payload_ctrl_execute1AluBypass;
  wire                execute1_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute1_inInst_throwWhen_payload_ctrl_men;
  wire       [0:0]    execute1_inInst_throwWhen_payload_ctrl_m;
  wire       [1:0]    execute1_inInst_throwWhen_payload_ctrl_msk;
  wire       [1:0]    execute1_inInst_throwWhen_payload_ctrl_csr;
  wire       [2:0]    execute1_inInst_throwWhen_payload_ctrl_mfs;
  wire                execute1_inInst_throwWhen_payload_ctrl_useSrc0;
  wire                execute1_inInst_throwWhen_payload_ctrl_useSrc1;
  wire       [2:0]    execute1_inInst_throwWhen_payload_ctrl_extensionTag;
  wire                execute1_inInst_throwWhen_payload_ctrl_fencei;
  wire                execute1_inInst_throwWhen_payload_br_eq;
  wire                execute1_inInst_throwWhen_payload_br_ltx;
  wire       [31:0]   execute1_inInst_throwWhen_payload_src1;
  wire       [31:0]   execute1_inInst_throwWhen_payload_result;
  wire       [31:0]   execute1_inInst_throwWhen_payload_adder;
  wire                execute1_inInst_throwWhen_payload_predictorHasBranch;
  wire                execute1_inInst_throwWhen_payload_branchHistory_valid;
  wire       [1:0]    execute1_inInst_throwWhen_payload_branchHistory_payload;
  wire       [31:0]   execute1_inInst_throwWhen_payload_pcPlus4;
  wire       [1:0]    execute1_inInst_throwWhen_payload_pc_sel;
  wire                execute1_inInst_throwWhen_payload_unalignedMemoryAccessException;
  wire                execute1_inInst_throwWhen_payload_needMemRsp;
  wire       [31:0]   execute1_inInst_throwWhen_payload_dCmdAddress;
  wire                _zz_execute1_inInst_throwWhen_ready;
  wire                execute1_inInst_throwWhen_haltWhen_valid;
  wire                execute1_inInst_throwWhen_haltWhen_ready;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_pc;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_instruction;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_instVal;
  wire       [3:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_br;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_jmp;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1;
  wire       [3:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_rfen;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_execute0AluBypass;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_execute1AluBypass;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_canInternalyStallWriteBack0;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_men;
  wire       [0:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_m;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr;
  wire       [2:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_useSrc0;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_useSrc1;
  wire       [2:0]    execute1_inInst_throwWhen_haltWhen_payload_ctrl_extensionTag;
  wire                execute1_inInst_throwWhen_haltWhen_payload_ctrl_fencei;
  wire                execute1_inInst_throwWhen_haltWhen_payload_br_eq;
  wire                execute1_inInst_throwWhen_haltWhen_payload_br_ltx;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_src1;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_result;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_adder;
  wire                execute1_inInst_throwWhen_haltWhen_payload_predictorHasBranch;
  wire                execute1_inInst_throwWhen_haltWhen_payload_branchHistory_valid;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_branchHistory_payload;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_pcPlus4;
  wire       [1:0]    execute1_inInst_throwWhen_haltWhen_payload_pc_sel;
  wire                execute1_inInst_throwWhen_haltWhen_payload_unalignedMemoryAccessException;
  wire                execute1_inInst_throwWhen_haltWhen_payload_needMemRsp;
  wire       [31:0]   execute1_inInst_throwWhen_haltWhen_payload_dCmdAddress;
  reg                 execute1_flush;
  wire                writeBack_inInst_valid;
  reg                 writeBack_inInst_ready;
  wire       [31:0]   writeBack_inInst_payload_pc;
  wire       [31:0]   writeBack_inInst_payload_instruction;
  wire                writeBack_inInst_payload_ctrl_instVal;
  wire       [3:0]    writeBack_inInst_payload_ctrl_br;
  wire                writeBack_inInst_payload_ctrl_jmp;
  wire       [1:0]    writeBack_inInst_payload_ctrl_op0;
  wire       [1:0]    writeBack_inInst_payload_ctrl_op1;
  wire       [3:0]    writeBack_inInst_payload_ctrl_alu;
  wire       [1:0]    writeBack_inInst_payload_ctrl_wb;
  wire                writeBack_inInst_payload_ctrl_rfen;
  wire                writeBack_inInst_payload_ctrl_execute0AluBypass;
  wire                writeBack_inInst_payload_ctrl_execute1AluBypass;
  wire                writeBack_inInst_payload_ctrl_canInternalyStallWriteBack0;
  wire                writeBack_inInst_payload_ctrl_men;
  wire       [0:0]    writeBack_inInst_payload_ctrl_m;
  wire       [1:0]    writeBack_inInst_payload_ctrl_msk;
  wire       [1:0]    writeBack_inInst_payload_ctrl_csr;
  wire       [2:0]    writeBack_inInst_payload_ctrl_mfs;
  wire                writeBack_inInst_payload_ctrl_useSrc0;
  wire                writeBack_inInst_payload_ctrl_useSrc1;
  wire       [2:0]    writeBack_inInst_payload_ctrl_extensionTag;
  wire                writeBack_inInst_payload_ctrl_fencei;
  reg        [31:0]   writeBack_inInst_payload_result;
  wire       [4:0]    writeBack_inInst_payload_regFileAddress;
  wire       [31:0]   writeBack_inInst_payload_pcPlus4;
  wire                writeBack_inInst_payload_unalignedMemoryAccessException;
  wire                writeBack_inInst_payload_needMemRsp;
  wire       [31:0]   writeBack_inInst_payload_dCmdAddress;
  reg                 execute1_outInst_rValid;
  reg        [31:0]   execute1_outInst_rData_pc;
  reg        [31:0]   execute1_outInst_rData_instruction;
  reg                 execute1_outInst_rData_ctrl_instVal;
  reg        [3:0]    execute1_outInst_rData_ctrl_br;
  reg                 execute1_outInst_rData_ctrl_jmp;
  reg        [1:0]    execute1_outInst_rData_ctrl_op0;
  reg        [1:0]    execute1_outInst_rData_ctrl_op1;
  reg        [3:0]    execute1_outInst_rData_ctrl_alu;
  reg        [1:0]    execute1_outInst_rData_ctrl_wb;
  reg                 execute1_outInst_rData_ctrl_rfen;
  reg                 execute1_outInst_rData_ctrl_execute0AluBypass;
  reg                 execute1_outInst_rData_ctrl_execute1AluBypass;
  reg                 execute1_outInst_rData_ctrl_canInternalyStallWriteBack0;
  reg                 execute1_outInst_rData_ctrl_men;
  reg        [0:0]    execute1_outInst_rData_ctrl_m;
  reg        [1:0]    execute1_outInst_rData_ctrl_msk;
  reg        [1:0]    execute1_outInst_rData_ctrl_csr;
  reg        [2:0]    execute1_outInst_rData_ctrl_mfs;
  reg                 execute1_outInst_rData_ctrl_useSrc0;
  reg                 execute1_outInst_rData_ctrl_useSrc1;
  reg        [2:0]    execute1_outInst_rData_ctrl_extensionTag;
  reg                 execute1_outInst_rData_ctrl_fencei;
  reg        [31:0]   execute1_outInst_rData_result;
  reg        [4:0]    execute1_outInst_rData_regFileAddress;
  reg        [31:0]   execute1_outInst_rData_pcPlus4;
  reg                 execute1_outInst_rData_unalignedMemoryAccessException;
  reg                 execute1_outInst_rData_needMemRsp;
  reg        [31:0]   execute1_outInst_rData_dCmdAddress;
  reg                 writeBack_throwIt;
  reg                 writeBack_halt;
  reg        [7:0]    writeBack_irq_sources;
  reg        [7:0]    writeBack_irq_mask;
  wire       [7:0]    writeBack_irq_masked;
  reg                 writeBack_irq_inhibate;
  wire                when_RiscvCore_l828;
  wire                when_RiscvCore_l834;
  reg                 writeBack_pcLoad_valid;
  reg        [31:0]   writeBack_pcLoad_payload;
  reg                 writeBack_flushMemoryResponse;
  wire                when_RiscvCore_l857;
  wire                when_RiscvCore_l858;
  wire                when_RiscvCore_l864;
  wire                _zz_writeBack_dataRspFormated;
  reg        [31:0]   _zz_writeBack_dataRspFormated_1;
  wire                _zz_writeBack_dataRspFormated_2;
  reg        [31:0]   _zz_writeBack_dataRspFormated_3;
  reg        [31:0]   writeBack_dataRspFormated;
  reg        [31:0]   writeBack_regFileData;
  wire                writeBack_outInst_valid;
  wire                writeBack_outInst_ready;
  wire       [4:0]    writeBack_outInst_payload_addr;
  wire       [31:0]   writeBack_outInst_payload_data;
  reg                 writeBack_inInst_throwWhen_valid;
  wire                writeBack_inInst_throwWhen_ready;
  wire       [31:0]   writeBack_inInst_throwWhen_payload_pc;
  wire       [31:0]   writeBack_inInst_throwWhen_payload_instruction;
  wire                writeBack_inInst_throwWhen_payload_ctrl_instVal;
  wire       [3:0]    writeBack_inInst_throwWhen_payload_ctrl_br;
  wire                writeBack_inInst_throwWhen_payload_ctrl_jmp;
  wire       [1:0]    writeBack_inInst_throwWhen_payload_ctrl_op0;
  wire       [1:0]    writeBack_inInst_throwWhen_payload_ctrl_op1;
  wire       [3:0]    writeBack_inInst_throwWhen_payload_ctrl_alu;
  wire       [1:0]    writeBack_inInst_throwWhen_payload_ctrl_wb;
  wire                writeBack_inInst_throwWhen_payload_ctrl_rfen;
  wire                writeBack_inInst_throwWhen_payload_ctrl_execute0AluBypass;
  wire                writeBack_inInst_throwWhen_payload_ctrl_execute1AluBypass;
  wire                writeBack_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0;
  wire                writeBack_inInst_throwWhen_payload_ctrl_men;
  wire       [0:0]    writeBack_inInst_throwWhen_payload_ctrl_m;
  wire       [1:0]    writeBack_inInst_throwWhen_payload_ctrl_msk;
  wire       [1:0]    writeBack_inInst_throwWhen_payload_ctrl_csr;
  wire       [2:0]    writeBack_inInst_throwWhen_payload_ctrl_mfs;
  wire                writeBack_inInst_throwWhen_payload_ctrl_useSrc0;
  wire                writeBack_inInst_throwWhen_payload_ctrl_useSrc1;
  wire       [2:0]    writeBack_inInst_throwWhen_payload_ctrl_extensionTag;
  wire                writeBack_inInst_throwWhen_payload_ctrl_fencei;
  wire       [31:0]   writeBack_inInst_throwWhen_payload_result;
  wire       [4:0]    writeBack_inInst_throwWhen_payload_regFileAddress;
  wire       [31:0]   writeBack_inInst_throwWhen_payload_pcPlus4;
  wire                writeBack_inInst_throwWhen_payload_unalignedMemoryAccessException;
  wire                writeBack_inInst_throwWhen_payload_needMemRsp;
  wire       [31:0]   writeBack_inInst_throwWhen_payload_dCmdAddress;
  wire                _zz_writeBack_inInst_throwWhen_ready;
  wire                writeBack_inInst_throwWhen_haltWhen_valid;
  wire                writeBack_inInst_throwWhen_haltWhen_ready;
  wire       [31:0]   writeBack_inInst_throwWhen_haltWhen_payload_pc;
  wire       [31:0]   writeBack_inInst_throwWhen_haltWhen_payload_instruction;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_instVal;
  wire       [3:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_jmp;
  wire       [1:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0;
  wire       [1:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1;
  wire       [3:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu;
  wire       [1:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_rfen;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_execute0AluBypass;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_execute1AluBypass;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_canInternalyStallWriteBack0;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_men;
  wire       [0:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m;
  wire       [1:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk;
  wire       [1:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr;
  wire       [2:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_useSrc0;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_useSrc1;
  wire       [2:0]    writeBack_inInst_throwWhen_haltWhen_payload_ctrl_extensionTag;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_ctrl_fencei;
  wire       [31:0]   writeBack_inInst_throwWhen_haltWhen_payload_result;
  wire       [4:0]    writeBack_inInst_throwWhen_haltWhen_payload_regFileAddress;
  wire       [31:0]   writeBack_inInst_throwWhen_haltWhen_payload_pcPlus4;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_unalignedMemoryAccessException;
  wire                writeBack_inInst_throwWhen_haltWhen_payload_needMemRsp;
  wire       [31:0]   writeBack_inInst_throwWhen_haltWhen_payload_dCmdAddress;
  reg                 writeBack_regFileWrite_valid;
  reg        [4:0]    writeBack_regFileWrite_payload_address;
  reg        [31:0]   writeBack_regFileWrite_payload_data;
  wire                writeBack_outInst_fire;
  reg                 writeBack_flush;
  wire                writeBackBuffer_inInst_valid;
  wire                writeBackBuffer_inInst_ready;
  wire       [4:0]    writeBackBuffer_inInst_payload_addr;
  wire       [31:0]   writeBackBuffer_inInst_payload_data;
  reg                 writeBack_outInst_rValid;
  reg        [4:0]    writeBack_outInst_rData_addr;
  reg        [31:0]   writeBack_outInst_rData_data;
  reg                 hazardTracker_src0Hazard;
  reg                 hazardTracker_src1Hazard;
  wire                hazardTracker_W2R_addr0Match;
  wire                hazardTracker_W2R_addr1Match;
  wire                hazardTracker_A_addr0Match;
  wire                hazardTracker_A_addr1Match;
  wire                when_RiscvCore_l980;
  wire                when_RiscvCore_l989;
  wire                hazardTracker_E1_addr0Match;
  wire                hazardTracker_E1_addr1Match;
  wire                when_RiscvCore_l1004;
  wire                when_RiscvCore_l1015;
  wire                hazardTracker_E0_addr0Match;
  wire                hazardTracker_E0_addr1Match;
  wire                when_RiscvCore_l1030;
  wire                when_RiscvCore_l1041;
  wire                when_RiscvCore_l1052;
  wire                when_RiscvCore_l1055;
  wire                when_RiscvCore_l1063;
  wire                when_RiscvCore_l1064;
  wire                writeBack_inInst_isStall;
  wire                when_RiscvCore_l1067;
  reg                 MulExtension_s1_aSigned;
  reg                 MulExtension_s1_bSigned;
  wire       [31:0]   MulExtension_s1_a;
  wire       [31:0]   MulExtension_s1_b;
  wire       [1:0]    switch_MulExtension_l30;
  wire       [15:0]   MulExtension_s1_aULow;
  wire       [15:0]   MulExtension_s1_bULow;
  wire       [16:0]   MulExtension_s1_aSLow;
  wire       [16:0]   MulExtension_s1_bSLow;
  wire       [16:0]   MulExtension_s1_aHigh;
  wire       [16:0]   MulExtension_s1_bHigh;
  wire       [31:0]   MulExtension_s1_mul_ll;
  wire       [33:0]   MulExtension_s1_mul_lh;
  wire       [33:0]   MulExtension_s1_mul_hl;
  wire       [33:0]   MulExtension_s1_mul_hh;
  reg        [31:0]   MulExtension_s2_mul_ll;
  reg        [33:0]   MulExtension_s2_mul_lh;
  reg        [33:0]   MulExtension_s2_mul_hl;
  reg        [33:0]   MulExtension_s2_mul_hh;
  wire       [49:0]   MulExtension_s2_low;
  reg        [49:0]   MulExtension_s3_low;
  reg        [33:0]   MulExtension_s3_mul_hh;
  wire       [65:0]   MulExtension_s3_result;
  wire                when_MulExtension_l74;
  wire       [1:0]    switch_MulExtension_l75;
  reg                 DivExtension_rspReady;
  reg        [31:0]   DivExtension_rsp;
  wire                when_DivExtension_l26;
  wire                when_DivExtension_l28;
  wire                when_DivExtension_l33;
  wire                when_DivExtension_l36;
  wire       [4:0]    BarrelShifterFullExtension_s1_amplitude;
  reg        [31:0]   _zz_BarrelShifterFullExtension_s1_reversed;
  wire       [31:0]   BarrelShifterFullExtension_s1_reversed;
  wire       [31:0]   BarrelShifterFullExtension_s1_shiftRight;
  reg        [31:0]   BarrelShifterFullExtension_s2_shiftRight;
  reg        [31:0]   _zz_execute1_outInst_payload_result;
  reg                 SimpleInterrupExtension_inIrq;
  reg        [31:0]   SimpleInterrupExtension_exitPc;
  reg        [7:0]    SimpleInterrupExtension_irqValue;
  wire                when_SimpleInterruptExtension_l34;
  reg                 _zz_SimpleInterrupExtension_irqValue;
  wire                when_SimpleInterruptExtension_l38;
  wire                when_SimpleInterruptExtension_l39;
  wire                when_SimpleInterruptExtension_l48;
  reg                 _zz_7;
  wire                when_SimpleInterruptExtension_l57;
  wire       [1:0]    switch_SimpleInterruptExtension_l58;
  wire                execute1_outInst_fire;
  wire                _zz_io_i_branchCachePort_rsp_pc;
  wire       [6:0]    _zz_io_i_branchCachePort_rsp_pc_1;
  wire       [24:0]   _zz_io_i_branchCachePort_rsp_pc_2;
  reg        [31:0]   DebugExtension_busReadDataReg;
  reg                 DebugExtension_readRegFileReg;
  reg                 DebugExtension_resetIt;
  reg                 DebugExtension_haltIt;
  reg                 DebugExtension_flushIt;
  reg                 DebugExtension_stepIt;
  reg                 iCmd_valid_regNext;
  reg                 DebugExtension_isPipActive;
  reg                 DebugExtension_isPipActive_regNext;
  wire                DebugExtension_isPipBusy;
  wire                DebugExtension_isInBreakpoint;
  wire                when_DebugExtension_l101;
  wire       [6:0]    switch_DebugExtension_l102;
  wire                when_DebugExtension_l107;
  wire                when_DebugExtension_l108;
  wire                when_DebugExtension_l109;
  wire                when_DebugExtension_l110;
  wire                decode_inInst_fire;
  reg                 decode_inInst_fire_regNext;
  wire                when_DebugExtension_l157;
  wire                when_DebugExtension_l178;
  reg                 DebugExtension_resetIt_regNext;
  wire                when_DebugExtension_l184;
  `ifndef SYNTHESIS
  reg [23:0] decode_ctrl_br_string;
  reg [31:0] decode_ctrl_op0_string;
  reg [23:0] decode_ctrl_op1_string;
  reg [39:0] decode_ctrl_alu_string;
  reg [31:0] decode_ctrl_wb_string;
  reg [23:0] decode_ctrl_m_string;
  reg [7:0] decode_ctrl_msk_string;
  reg [7:0] decode_ctrl_csr_string;
  reg [15:0] decode_ctrl_mfs_string;
  reg [7:0] _zz_decode_ctrl_msk_string;
  reg [39:0] _zz_decode_ctrl_alu_string;
  reg [39:0] _zz_decode_ctrl_alu_1_string;
  reg [23:0] _zz_decode_ctrl_br_string;
  reg [7:0] _zz_decode_ctrl_csr_string;
  reg [23:0] decode_outInst_payload_ctrl_br_string;
  reg [31:0] decode_outInst_payload_ctrl_op0_string;
  reg [23:0] decode_outInst_payload_ctrl_op1_string;
  reg [39:0] decode_outInst_payload_ctrl_alu_string;
  reg [31:0] decode_outInst_payload_ctrl_wb_string;
  reg [23:0] decode_outInst_payload_ctrl_m_string;
  reg [7:0] decode_outInst_payload_ctrl_msk_string;
  reg [7:0] decode_outInst_payload_ctrl_csr_string;
  reg [15:0] decode_outInst_payload_ctrl_mfs_string;
  reg [23:0] execute0_inInst_payload_ctrl_br_string;
  reg [31:0] execute0_inInst_payload_ctrl_op0_string;
  reg [23:0] execute0_inInst_payload_ctrl_op1_string;
  reg [39:0] execute0_inInst_payload_ctrl_alu_string;
  reg [31:0] execute0_inInst_payload_ctrl_wb_string;
  reg [23:0] execute0_inInst_payload_ctrl_m_string;
  reg [7:0] execute0_inInst_payload_ctrl_msk_string;
  reg [7:0] execute0_inInst_payload_ctrl_csr_string;
  reg [15:0] execute0_inInst_payload_ctrl_mfs_string;
  reg [23:0] decode_outInst_rData_ctrl_br_string;
  reg [31:0] decode_outInst_rData_ctrl_op0_string;
  reg [23:0] decode_outInst_rData_ctrl_op1_string;
  reg [39:0] decode_outInst_rData_ctrl_alu_string;
  reg [31:0] decode_outInst_rData_ctrl_wb_string;
  reg [23:0] decode_outInst_rData_ctrl_m_string;
  reg [7:0] decode_outInst_rData_ctrl_msk_string;
  reg [7:0] decode_outInst_rData_ctrl_csr_string;
  reg [15:0] decode_outInst_rData_ctrl_mfs_string;
  reg [23:0] _zz_execute0_br_pc_sel_string;
  reg [23:0] _zz_execute0_br_pc_sel_1_string;
  reg [23:0] _zz_execute0_br_pc_sel_2_string;
  reg [23:0] _zz_execute0_br_pc_sel_3_string;
  reg [23:0] execute0_br_pc_sel_string;
  reg [23:0] execute0_outInst_payload_ctrl_br_string;
  reg [31:0] execute0_outInst_payload_ctrl_op0_string;
  reg [23:0] execute0_outInst_payload_ctrl_op1_string;
  reg [39:0] execute0_outInst_payload_ctrl_alu_string;
  reg [31:0] execute0_outInst_payload_ctrl_wb_string;
  reg [23:0] execute0_outInst_payload_ctrl_m_string;
  reg [7:0] execute0_outInst_payload_ctrl_msk_string;
  reg [7:0] execute0_outInst_payload_ctrl_csr_string;
  reg [15:0] execute0_outInst_payload_ctrl_mfs_string;
  reg [23:0] execute0_outInst_payload_pc_sel_string;
  reg [23:0] execute0_inInst_throwWhen_payload_ctrl_br_string;
  reg [31:0] execute0_inInst_throwWhen_payload_ctrl_op0_string;
  reg [23:0] execute0_inInst_throwWhen_payload_ctrl_op1_string;
  reg [39:0] execute0_inInst_throwWhen_payload_ctrl_alu_string;
  reg [31:0] execute0_inInst_throwWhen_payload_ctrl_wb_string;
  reg [23:0] execute0_inInst_throwWhen_payload_ctrl_m_string;
  reg [7:0] execute0_inInst_throwWhen_payload_ctrl_msk_string;
  reg [7:0] execute0_inInst_throwWhen_payload_ctrl_csr_string;
  reg [15:0] execute0_inInst_throwWhen_payload_ctrl_mfs_string;
  reg [23:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string;
  reg [31:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0_string;
  reg [23:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1_string;
  reg [39:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string;
  reg [31:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb_string;
  reg [23:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_m_string;
  reg [7:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk_string;
  reg [7:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr_string;
  reg [15:0] execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string;
  reg [23:0] execute1_inInst_payload_ctrl_br_string;
  reg [31:0] execute1_inInst_payload_ctrl_op0_string;
  reg [23:0] execute1_inInst_payload_ctrl_op1_string;
  reg [39:0] execute1_inInst_payload_ctrl_alu_string;
  reg [31:0] execute1_inInst_payload_ctrl_wb_string;
  reg [23:0] execute1_inInst_payload_ctrl_m_string;
  reg [7:0] execute1_inInst_payload_ctrl_msk_string;
  reg [7:0] execute1_inInst_payload_ctrl_csr_string;
  reg [15:0] execute1_inInst_payload_ctrl_mfs_string;
  reg [23:0] execute1_inInst_payload_pc_sel_string;
  reg [23:0] execute0_outInst_rData_ctrl_br_string;
  reg [31:0] execute0_outInst_rData_ctrl_op0_string;
  reg [23:0] execute0_outInst_rData_ctrl_op1_string;
  reg [39:0] execute0_outInst_rData_ctrl_alu_string;
  reg [31:0] execute0_outInst_rData_ctrl_wb_string;
  reg [23:0] execute0_outInst_rData_ctrl_m_string;
  reg [7:0] execute0_outInst_rData_ctrl_msk_string;
  reg [7:0] execute0_outInst_rData_ctrl_csr_string;
  reg [15:0] execute0_outInst_rData_ctrl_mfs_string;
  reg [23:0] execute0_outInst_rData_pc_sel_string;
  reg [23:0] execute1_outInst_payload_ctrl_br_string;
  reg [31:0] execute1_outInst_payload_ctrl_op0_string;
  reg [23:0] execute1_outInst_payload_ctrl_op1_string;
  reg [39:0] execute1_outInst_payload_ctrl_alu_string;
  reg [31:0] execute1_outInst_payload_ctrl_wb_string;
  reg [23:0] execute1_outInst_payload_ctrl_m_string;
  reg [7:0] execute1_outInst_payload_ctrl_msk_string;
  reg [7:0] execute1_outInst_payload_ctrl_csr_string;
  reg [15:0] execute1_outInst_payload_ctrl_mfs_string;
  reg [23:0] execute1_inInst_throwWhen_payload_ctrl_br_string;
  reg [31:0] execute1_inInst_throwWhen_payload_ctrl_op0_string;
  reg [23:0] execute1_inInst_throwWhen_payload_ctrl_op1_string;
  reg [39:0] execute1_inInst_throwWhen_payload_ctrl_alu_string;
  reg [31:0] execute1_inInst_throwWhen_payload_ctrl_wb_string;
  reg [23:0] execute1_inInst_throwWhen_payload_ctrl_m_string;
  reg [7:0] execute1_inInst_throwWhen_payload_ctrl_msk_string;
  reg [7:0] execute1_inInst_throwWhen_payload_ctrl_csr_string;
  reg [15:0] execute1_inInst_throwWhen_payload_ctrl_mfs_string;
  reg [23:0] execute1_inInst_throwWhen_payload_pc_sel_string;
  reg [23:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string;
  reg [31:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0_string;
  reg [23:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1_string;
  reg [39:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string;
  reg [31:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb_string;
  reg [23:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_m_string;
  reg [7:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk_string;
  reg [7:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr_string;
  reg [15:0] execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string;
  reg [23:0] execute1_inInst_throwWhen_haltWhen_payload_pc_sel_string;
  reg [23:0] writeBack_inInst_payload_ctrl_br_string;
  reg [31:0] writeBack_inInst_payload_ctrl_op0_string;
  reg [23:0] writeBack_inInst_payload_ctrl_op1_string;
  reg [39:0] writeBack_inInst_payload_ctrl_alu_string;
  reg [31:0] writeBack_inInst_payload_ctrl_wb_string;
  reg [23:0] writeBack_inInst_payload_ctrl_m_string;
  reg [7:0] writeBack_inInst_payload_ctrl_msk_string;
  reg [7:0] writeBack_inInst_payload_ctrl_csr_string;
  reg [15:0] writeBack_inInst_payload_ctrl_mfs_string;
  reg [23:0] execute1_outInst_rData_ctrl_br_string;
  reg [31:0] execute1_outInst_rData_ctrl_op0_string;
  reg [23:0] execute1_outInst_rData_ctrl_op1_string;
  reg [39:0] execute1_outInst_rData_ctrl_alu_string;
  reg [31:0] execute1_outInst_rData_ctrl_wb_string;
  reg [23:0] execute1_outInst_rData_ctrl_m_string;
  reg [7:0] execute1_outInst_rData_ctrl_msk_string;
  reg [7:0] execute1_outInst_rData_ctrl_csr_string;
  reg [15:0] execute1_outInst_rData_ctrl_mfs_string;
  reg [23:0] writeBack_inInst_throwWhen_payload_ctrl_br_string;
  reg [31:0] writeBack_inInst_throwWhen_payload_ctrl_op0_string;
  reg [23:0] writeBack_inInst_throwWhen_payload_ctrl_op1_string;
  reg [39:0] writeBack_inInst_throwWhen_payload_ctrl_alu_string;
  reg [31:0] writeBack_inInst_throwWhen_payload_ctrl_wb_string;
  reg [23:0] writeBack_inInst_throwWhen_payload_ctrl_m_string;
  reg [7:0] writeBack_inInst_throwWhen_payload_ctrl_msk_string;
  reg [7:0] writeBack_inInst_throwWhen_payload_ctrl_csr_string;
  reg [15:0] writeBack_inInst_throwWhen_payload_ctrl_mfs_string;
  reg [23:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string;
  reg [31:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0_string;
  reg [23:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1_string;
  reg [39:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string;
  reg [31:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb_string;
  reg [23:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m_string;
  reg [7:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk_string;
  reg [7:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr_string;
  reg [15:0] writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string;
  `endif

  reg [31:0] regFile [0:31];
  reg [24:0] brancheCache [0:127];

  assign _zz_fetch_throwRemaining_1 = iRsp_valid;
  assign _zz_fetch_throwRemaining = {1'd0, _zz_fetch_throwRemaining_1};
  assign _zz__zz_decode_brjmpImm = {{{decode_inInst_payload_instruction[31],decode_inInst_payload_instruction[19 : 12]},decode_inInst_payload_instruction[20]},decode_inInst_payload_instruction[30 : 21]};
  assign _zz__zz_decode_brjmpImm_2 = {{{decode_inInst_payload_instruction[31],decode_inInst_payload_instruction[7]},decode_inInst_payload_instruction[30 : 25]},decode_inInst_payload_instruction[11 : 8]};
  assign _zz__zz_decode_outInst_payload_alu_op0 = decode_inInst_payload_instruction[19 : 15];
  assign _zz__zz_decode_outInst_payload_alu_op1_2 = {decode_inInst_payload_instruction[31 : 25],decode_inInst_payload_instruction[11 : 7]};
  assign _zz_execute0_br_signed = execute0_inInst_payload_ctrl_br;
  assign _zz_execute0_br_ltx = (execute0_br_src0Ext - execute0_br_src1Ext);
  assign _zz_execute1_newHistory = {{1{execute1_inInst_payload_branchHistory_payload[1]}}, execute1_inInst_payload_branchHistory_payload};
  assign _zz_execute1_newHistory_2 = ((execute1_inInst_payload_pc_sel == PC_INC) ? 2'b01 : 2'b11);
  assign _zz_execute1_newHistory_1 = {{1{_zz_execute1_newHistory_2[1]}}, _zz_execute1_newHistory_2};
  assign _zz_execute1_line_history = (execute1_inInst_payload_pc_sel != PC_INC);
  assign _zz_when_RiscvCore_l793 = execute1_newHistory[2 : 1];
  assign _zz_when_RiscvCore_l793_1 = execute1_newHistory[2 : 1];
  assign _zz_MulExtension_s2_low = ($signed(_zz_MulExtension_s2_low_1) + $signed(_zz_MulExtension_s2_low_5));
  assign _zz_MulExtension_s2_low_2 = ($signed(36'h0) + $signed(_zz_MulExtension_s2_low_3));
  assign _zz_MulExtension_s2_low_1 = {{14{_zz_MulExtension_s2_low_2[35]}}, _zz_MulExtension_s2_low_2};
  assign _zz_MulExtension_s2_low_4 = {1'b0,MulExtension_s2_mul_ll};
  assign _zz_MulExtension_s2_low_3 = {{3{_zz_MulExtension_s2_low_4[32]}}, _zz_MulExtension_s2_low_4};
  assign _zz_MulExtension_s2_low_5 = ({16'd0,MulExtension_s2_mul_lh} <<< 5'd16);
  assign _zz_MulExtension_s2_low_6 = ({16'd0,MulExtension_s2_mul_hl} <<< 5'd16);
  assign _zz_MulExtension_s3_result = {{16{MulExtension_s3_low[49]}}, MulExtension_s3_low};
  assign _zz_MulExtension_s3_result_1 = ({32'd0,MulExtension_s3_mul_hh} <<< 6'd32);
  assign _zz_writeBack_inInst_payload_result = MulExtension_s3_low[31 : 0];
  assign _zz_writeBack_inInst_payload_result_1 = MulExtension_s3_result[63 : 32];
  assign _zz_BarrelShifterFullExtension_s1_shiftRight_1 = ($signed(_zz_BarrelShifterFullExtension_s1_shiftRight_2) >>> BarrelShifterFullExtension_s1_amplitude);
  assign _zz_BarrelShifterFullExtension_s1_shiftRight = _zz_BarrelShifterFullExtension_s1_shiftRight_1[31 : 0];
  assign _zz_BarrelShifterFullExtension_s1_shiftRight_2 = {((execute0_inInst_payload_ctrl_alu == ALU_SRA_1) && BarrelShifterFullExtension_s1_reversed[31]),BarrelShifterFullExtension_s1_reversed};
  assign _zz_decode_src0 = 1'b1;
  assign _zz_decode_src1 = 1'b1;
  assign _zz_brancheCache_port = execute1_inInst_payload_pc[8 : 2];
  assign _zz_brancheCache_port_1 = {execute1_line_history,execute1_line_pc};
  assign _zz_decode_brjmpImm_4 = decode_inInst_payload_instruction[31];
  assign _zz_decode_brjmpImm_5 = decode_inInst_payload_instruction[31];
  assign _zz_decode_brjmpImm_6 = decode_inInst_payload_instruction[7];
  always @(posedge clkout) begin
    if(_zz_decode_src0) begin
      regFile_spinal_port0 <= regFile[decode_regFileReadAddress0];
    end
  end

  always @(posedge clkout) begin
    if(_zz_decode_src1) begin
      regFile_spinal_port1 <= regFile[decode_regFileReadAddress1];
    end
  end

  always @(posedge clkout) begin
    if(_zz_1) begin
      regFile[writeBack_regFileWrite_payload_address] <= writeBack_regFileWrite_payload_data;
    end
  end

integer verilogIndex;

initial begin
  for (verilogIndex = 0; verilogIndex < 128; verilogIndex = verilogIndex + 1)begin
brancheCache[verilogIndex] = -1;
  end
end
  always @(posedge clkout) begin
    if(_zz_2) begin
      brancheCache[_zz_brancheCache_port] <= _zz_brancheCache_port_1;
    end
  end

  always @(posedge clkout) begin
    if(_zz_io_i_branchCachePort_rsp_pc) begin
      brancheCache_spinal_port1 <= brancheCache[_zz_io_i_branchCachePort_rsp_pc_1];
    end
  end

  Alu_1 execute0_alu (
    .io_func   (execute0_inInst_payload_ctrl_alu[3:0]), //i
    .io_doSub  (execute0_inInst_payload_doSub        ), //i
    .io_src0   (execute0_inInst_payload_alu_op0[31:0]), //i
    .io_src1   (execute0_inInst_payload_alu_op1[31:0]), //i
    .io_result (execute0_alu_io_result[31:0]         ), //o
    .io_adder  (execute0_alu_io_adder[31:0]          )  //o
  );
  MixedDivider DivExtension_divider (
    .io_flush                   (execute1_throwIt                                   ), //i
    .io_cmd_valid               (DivExtension_divider_io_cmd_valid                  ), //i
    .io_cmd_ready               (DivExtension_divider_io_cmd_ready                  ), //o
    .io_cmd_payload_numerator   (execute0_inInst_payload_alu_op0[31:0]              ), //i
    .io_cmd_payload_denominator (execute0_inInst_payload_alu_op1[31:0]              ), //i
    .io_cmd_payload_signed      (DivExtension_divider_io_cmd_payload_signed         ), //i
    .io_rsp_valid               (DivExtension_divider_io_rsp_valid                  ), //o
    .io_rsp_ready               (DivExtension_divider_io_rsp_ready                  ), //i
    .io_rsp_payload_quotient    (DivExtension_divider_io_rsp_payload_quotient[31:0] ), //o
    .io_rsp_payload_remainder   (DivExtension_divider_io_rsp_payload_remainder[31:0]), //o
    .io_rsp_payload_error       (DivExtension_divider_io_rsp_payload_error          ), //o
    .clkout                     (clkout                                             ), //i
    .resetCtrl_coreReset        (resetCtrl_coreReset                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(decode_ctrl_br)
      BR_N : decode_ctrl_br_string = "N  ";
      BR_NE : decode_ctrl_br_string = "NE ";
      BR_EQ : decode_ctrl_br_string = "EQ ";
      BR_GE : decode_ctrl_br_string = "GE ";
      BR_GEU : decode_ctrl_br_string = "GEU";
      BR_LT : decode_ctrl_br_string = "LT ";
      BR_LTU : decode_ctrl_br_string = "LTU";
      BR_J : decode_ctrl_br_string = "J  ";
      BR_JR : decode_ctrl_br_string = "JR ";
      default : decode_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_op0)
      OP0_RS : decode_ctrl_op0_string = "RS  ";
      OP0_IMU : decode_ctrl_op0_string = "IMU ";
      OP0_IMZ : decode_ctrl_op0_string = "IMZ ";
      OP0_IMJB : decode_ctrl_op0_string = "IMJB";
      default : decode_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_op1)
      OP1_RS : decode_ctrl_op1_string = "RS ";
      OP1_IMI : decode_ctrl_op1_string = "IMI";
      OP1_IMS : decode_ctrl_op1_string = "IMS";
      OP1_PC : decode_ctrl_op1_string = "PC ";
      default : decode_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_alu)
      ALU_ADD : decode_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : decode_ctrl_alu_string = "SLL1 ";
      ALU_SLT : decode_ctrl_alu_string = "SLT  ";
      ALU_SLTU : decode_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : decode_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : decode_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : decode_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : decode_ctrl_alu_string = "AND_1";
      ALU_SUB : decode_ctrl_alu_string = "SUB  ";
      ALU_COPY : decode_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : decode_ctrl_alu_string = "SRA_1";
      default : decode_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_wb)
      WB_ALU : decode_ctrl_wb_string = "ALU ";
      WB_MEM : decode_ctrl_wb_string = "MEM ";
      WB_PC4 : decode_ctrl_wb_string = "PC4 ";
      WB_CSR1 : decode_ctrl_wb_string = "CSR1";
      default : decode_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_m)
      M_XRD : decode_ctrl_m_string = "XRD";
      M_XWR : decode_ctrl_m_string = "XWR";
      default : decode_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_msk)
      MSK_B : decode_ctrl_msk_string = "B";
      MSK_H : decode_ctrl_msk_string = "H";
      MSK_W : decode_ctrl_msk_string = "W";
      default : decode_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_csr)
      CSR_N : decode_ctrl_csr_string = "N";
      CSR_W : decode_ctrl_csr_string = "W";
      CSR_S : decode_ctrl_csr_string = "S";
      CSR_C : decode_ctrl_csr_string = "C";
      default : decode_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_ctrl_mfs)
      MFS_N : decode_ctrl_mfs_string = "N ";
      MFS_SI : decode_ctrl_mfs_string = "SI";
      MFS_SD : decode_ctrl_mfs_string = "SD";
      MFS_FA : decode_ctrl_mfs_string = "FA";
      MFS_FD : decode_ctrl_mfs_string = "FD";
      default : decode_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ctrl_msk)
      MSK_B : _zz_decode_ctrl_msk_string = "B";
      MSK_H : _zz_decode_ctrl_msk_string = "H";
      MSK_W : _zz_decode_ctrl_msk_string = "W";
      default : _zz_decode_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ctrl_alu)
      ALU_ADD : _zz_decode_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : _zz_decode_ctrl_alu_string = "SLL1 ";
      ALU_SLT : _zz_decode_ctrl_alu_string = "SLT  ";
      ALU_SLTU : _zz_decode_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : _zz_decode_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : _zz_decode_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : _zz_decode_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : _zz_decode_ctrl_alu_string = "AND_1";
      ALU_SUB : _zz_decode_ctrl_alu_string = "SUB  ";
      ALU_COPY : _zz_decode_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : _zz_decode_ctrl_alu_string = "SRA_1";
      default : _zz_decode_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ctrl_alu_1)
      ALU_ADD : _zz_decode_ctrl_alu_1_string = "ADD  ";
      ALU_SLL1 : _zz_decode_ctrl_alu_1_string = "SLL1 ";
      ALU_SLT : _zz_decode_ctrl_alu_1_string = "SLT  ";
      ALU_SLTU : _zz_decode_ctrl_alu_1_string = "SLTU ";
      ALU_XOR_1 : _zz_decode_ctrl_alu_1_string = "XOR_1";
      ALU_SRL_1 : _zz_decode_ctrl_alu_1_string = "SRL_1";
      ALU_OR_1 : _zz_decode_ctrl_alu_1_string = "OR_1 ";
      ALU_AND_1 : _zz_decode_ctrl_alu_1_string = "AND_1";
      ALU_SUB : _zz_decode_ctrl_alu_1_string = "SUB  ";
      ALU_COPY : _zz_decode_ctrl_alu_1_string = "COPY ";
      ALU_SRA_1 : _zz_decode_ctrl_alu_1_string = "SRA_1";
      default : _zz_decode_ctrl_alu_1_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ctrl_br)
      BR_N : _zz_decode_ctrl_br_string = "N  ";
      BR_NE : _zz_decode_ctrl_br_string = "NE ";
      BR_EQ : _zz_decode_ctrl_br_string = "EQ ";
      BR_GE : _zz_decode_ctrl_br_string = "GE ";
      BR_GEU : _zz_decode_ctrl_br_string = "GEU";
      BR_LT : _zz_decode_ctrl_br_string = "LT ";
      BR_LTU : _zz_decode_ctrl_br_string = "LTU";
      BR_J : _zz_decode_ctrl_br_string = "J  ";
      BR_JR : _zz_decode_ctrl_br_string = "JR ";
      default : _zz_decode_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ctrl_csr)
      CSR_N : _zz_decode_ctrl_csr_string = "N";
      CSR_W : _zz_decode_ctrl_csr_string = "W";
      CSR_S : _zz_decode_ctrl_csr_string = "S";
      CSR_C : _zz_decode_ctrl_csr_string = "C";
      default : _zz_decode_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_br)
      BR_N : decode_outInst_payload_ctrl_br_string = "N  ";
      BR_NE : decode_outInst_payload_ctrl_br_string = "NE ";
      BR_EQ : decode_outInst_payload_ctrl_br_string = "EQ ";
      BR_GE : decode_outInst_payload_ctrl_br_string = "GE ";
      BR_GEU : decode_outInst_payload_ctrl_br_string = "GEU";
      BR_LT : decode_outInst_payload_ctrl_br_string = "LT ";
      BR_LTU : decode_outInst_payload_ctrl_br_string = "LTU";
      BR_J : decode_outInst_payload_ctrl_br_string = "J  ";
      BR_JR : decode_outInst_payload_ctrl_br_string = "JR ";
      default : decode_outInst_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_op0)
      OP0_RS : decode_outInst_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : decode_outInst_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : decode_outInst_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : decode_outInst_payload_ctrl_op0_string = "IMJB";
      default : decode_outInst_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_op1)
      OP1_RS : decode_outInst_payload_ctrl_op1_string = "RS ";
      OP1_IMI : decode_outInst_payload_ctrl_op1_string = "IMI";
      OP1_IMS : decode_outInst_payload_ctrl_op1_string = "IMS";
      OP1_PC : decode_outInst_payload_ctrl_op1_string = "PC ";
      default : decode_outInst_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_alu)
      ALU_ADD : decode_outInst_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : decode_outInst_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : decode_outInst_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : decode_outInst_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : decode_outInst_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : decode_outInst_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : decode_outInst_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : decode_outInst_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : decode_outInst_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : decode_outInst_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : decode_outInst_payload_ctrl_alu_string = "SRA_1";
      default : decode_outInst_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_wb)
      WB_ALU : decode_outInst_payload_ctrl_wb_string = "ALU ";
      WB_MEM : decode_outInst_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : decode_outInst_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : decode_outInst_payload_ctrl_wb_string = "CSR1";
      default : decode_outInst_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_m)
      M_XRD : decode_outInst_payload_ctrl_m_string = "XRD";
      M_XWR : decode_outInst_payload_ctrl_m_string = "XWR";
      default : decode_outInst_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_msk)
      MSK_B : decode_outInst_payload_ctrl_msk_string = "B";
      MSK_H : decode_outInst_payload_ctrl_msk_string = "H";
      MSK_W : decode_outInst_payload_ctrl_msk_string = "W";
      default : decode_outInst_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_csr)
      CSR_N : decode_outInst_payload_ctrl_csr_string = "N";
      CSR_W : decode_outInst_payload_ctrl_csr_string = "W";
      CSR_S : decode_outInst_payload_ctrl_csr_string = "S";
      CSR_C : decode_outInst_payload_ctrl_csr_string = "C";
      default : decode_outInst_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_outInst_payload_ctrl_mfs)
      MFS_N : decode_outInst_payload_ctrl_mfs_string = "N ";
      MFS_SI : decode_outInst_payload_ctrl_mfs_string = "SI";
      MFS_SD : decode_outInst_payload_ctrl_mfs_string = "SD";
      MFS_FA : decode_outInst_payload_ctrl_mfs_string = "FA";
      MFS_FD : decode_outInst_payload_ctrl_mfs_string = "FD";
      default : decode_outInst_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_br)
      BR_N : execute0_inInst_payload_ctrl_br_string = "N  ";
      BR_NE : execute0_inInst_payload_ctrl_br_string = "NE ";
      BR_EQ : execute0_inInst_payload_ctrl_br_string = "EQ ";
      BR_GE : execute0_inInst_payload_ctrl_br_string = "GE ";
      BR_GEU : execute0_inInst_payload_ctrl_br_string = "GEU";
      BR_LT : execute0_inInst_payload_ctrl_br_string = "LT ";
      BR_LTU : execute0_inInst_payload_ctrl_br_string = "LTU";
      BR_J : execute0_inInst_payload_ctrl_br_string = "J  ";
      BR_JR : execute0_inInst_payload_ctrl_br_string = "JR ";
      default : execute0_inInst_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_op0)
      OP0_RS : execute0_inInst_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute0_inInst_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute0_inInst_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute0_inInst_payload_ctrl_op0_string = "IMJB";
      default : execute0_inInst_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_op1)
      OP1_RS : execute0_inInst_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute0_inInst_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute0_inInst_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute0_inInst_payload_ctrl_op1_string = "PC ";
      default : execute0_inInst_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_alu)
      ALU_ADD : execute0_inInst_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute0_inInst_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute0_inInst_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute0_inInst_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute0_inInst_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute0_inInst_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute0_inInst_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute0_inInst_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute0_inInst_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute0_inInst_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute0_inInst_payload_ctrl_alu_string = "SRA_1";
      default : execute0_inInst_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_wb)
      WB_ALU : execute0_inInst_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute0_inInst_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute0_inInst_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute0_inInst_payload_ctrl_wb_string = "CSR1";
      default : execute0_inInst_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_m)
      M_XRD : execute0_inInst_payload_ctrl_m_string = "XRD";
      M_XWR : execute0_inInst_payload_ctrl_m_string = "XWR";
      default : execute0_inInst_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_msk)
      MSK_B : execute0_inInst_payload_ctrl_msk_string = "B";
      MSK_H : execute0_inInst_payload_ctrl_msk_string = "H";
      MSK_W : execute0_inInst_payload_ctrl_msk_string = "W";
      default : execute0_inInst_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_csr)
      CSR_N : execute0_inInst_payload_ctrl_csr_string = "N";
      CSR_W : execute0_inInst_payload_ctrl_csr_string = "W";
      CSR_S : execute0_inInst_payload_ctrl_csr_string = "S";
      CSR_C : execute0_inInst_payload_ctrl_csr_string = "C";
      default : execute0_inInst_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_payload_ctrl_mfs)
      MFS_N : execute0_inInst_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute0_inInst_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute0_inInst_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute0_inInst_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute0_inInst_payload_ctrl_mfs_string = "FD";
      default : execute0_inInst_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_br)
      BR_N : decode_outInst_rData_ctrl_br_string = "N  ";
      BR_NE : decode_outInst_rData_ctrl_br_string = "NE ";
      BR_EQ : decode_outInst_rData_ctrl_br_string = "EQ ";
      BR_GE : decode_outInst_rData_ctrl_br_string = "GE ";
      BR_GEU : decode_outInst_rData_ctrl_br_string = "GEU";
      BR_LT : decode_outInst_rData_ctrl_br_string = "LT ";
      BR_LTU : decode_outInst_rData_ctrl_br_string = "LTU";
      BR_J : decode_outInst_rData_ctrl_br_string = "J  ";
      BR_JR : decode_outInst_rData_ctrl_br_string = "JR ";
      default : decode_outInst_rData_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_op0)
      OP0_RS : decode_outInst_rData_ctrl_op0_string = "RS  ";
      OP0_IMU : decode_outInst_rData_ctrl_op0_string = "IMU ";
      OP0_IMZ : decode_outInst_rData_ctrl_op0_string = "IMZ ";
      OP0_IMJB : decode_outInst_rData_ctrl_op0_string = "IMJB";
      default : decode_outInst_rData_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_op1)
      OP1_RS : decode_outInst_rData_ctrl_op1_string = "RS ";
      OP1_IMI : decode_outInst_rData_ctrl_op1_string = "IMI";
      OP1_IMS : decode_outInst_rData_ctrl_op1_string = "IMS";
      OP1_PC : decode_outInst_rData_ctrl_op1_string = "PC ";
      default : decode_outInst_rData_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_alu)
      ALU_ADD : decode_outInst_rData_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : decode_outInst_rData_ctrl_alu_string = "SLL1 ";
      ALU_SLT : decode_outInst_rData_ctrl_alu_string = "SLT  ";
      ALU_SLTU : decode_outInst_rData_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : decode_outInst_rData_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : decode_outInst_rData_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : decode_outInst_rData_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : decode_outInst_rData_ctrl_alu_string = "AND_1";
      ALU_SUB : decode_outInst_rData_ctrl_alu_string = "SUB  ";
      ALU_COPY : decode_outInst_rData_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : decode_outInst_rData_ctrl_alu_string = "SRA_1";
      default : decode_outInst_rData_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_wb)
      WB_ALU : decode_outInst_rData_ctrl_wb_string = "ALU ";
      WB_MEM : decode_outInst_rData_ctrl_wb_string = "MEM ";
      WB_PC4 : decode_outInst_rData_ctrl_wb_string = "PC4 ";
      WB_CSR1 : decode_outInst_rData_ctrl_wb_string = "CSR1";
      default : decode_outInst_rData_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_m)
      M_XRD : decode_outInst_rData_ctrl_m_string = "XRD";
      M_XWR : decode_outInst_rData_ctrl_m_string = "XWR";
      default : decode_outInst_rData_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_msk)
      MSK_B : decode_outInst_rData_ctrl_msk_string = "B";
      MSK_H : decode_outInst_rData_ctrl_msk_string = "H";
      MSK_W : decode_outInst_rData_ctrl_msk_string = "W";
      default : decode_outInst_rData_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_csr)
      CSR_N : decode_outInst_rData_ctrl_csr_string = "N";
      CSR_W : decode_outInst_rData_ctrl_csr_string = "W";
      CSR_S : decode_outInst_rData_ctrl_csr_string = "S";
      CSR_C : decode_outInst_rData_ctrl_csr_string = "C";
      default : decode_outInst_rData_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(decode_outInst_rData_ctrl_mfs)
      MFS_N : decode_outInst_rData_ctrl_mfs_string = "N ";
      MFS_SI : decode_outInst_rData_ctrl_mfs_string = "SI";
      MFS_SD : decode_outInst_rData_ctrl_mfs_string = "SD";
      MFS_FA : decode_outInst_rData_ctrl_mfs_string = "FA";
      MFS_FD : decode_outInst_rData_ctrl_mfs_string = "FD";
      default : decode_outInst_rData_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(_zz_execute0_br_pc_sel)
      PC_INC : _zz_execute0_br_pc_sel_string = "INC";
      PC_BRA : _zz_execute0_br_pc_sel_string = "BRA";
      PC_J : _zz_execute0_br_pc_sel_string = "J  ";
      PC_JR : _zz_execute0_br_pc_sel_string = "JR ";
      default : _zz_execute0_br_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_execute0_br_pc_sel_1)
      PC_INC : _zz_execute0_br_pc_sel_1_string = "INC";
      PC_BRA : _zz_execute0_br_pc_sel_1_string = "BRA";
      PC_J : _zz_execute0_br_pc_sel_1_string = "J  ";
      PC_JR : _zz_execute0_br_pc_sel_1_string = "JR ";
      default : _zz_execute0_br_pc_sel_1_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_execute0_br_pc_sel_2)
      PC_INC : _zz_execute0_br_pc_sel_2_string = "INC";
      PC_BRA : _zz_execute0_br_pc_sel_2_string = "BRA";
      PC_J : _zz_execute0_br_pc_sel_2_string = "J  ";
      PC_JR : _zz_execute0_br_pc_sel_2_string = "JR ";
      default : _zz_execute0_br_pc_sel_2_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_execute0_br_pc_sel_3)
      PC_INC : _zz_execute0_br_pc_sel_3_string = "INC";
      PC_BRA : _zz_execute0_br_pc_sel_3_string = "BRA";
      PC_J : _zz_execute0_br_pc_sel_3_string = "J  ";
      PC_JR : _zz_execute0_br_pc_sel_3_string = "JR ";
      default : _zz_execute0_br_pc_sel_3_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_br_pc_sel)
      PC_INC : execute0_br_pc_sel_string = "INC";
      PC_BRA : execute0_br_pc_sel_string = "BRA";
      PC_J : execute0_br_pc_sel_string = "J  ";
      PC_JR : execute0_br_pc_sel_string = "JR ";
      default : execute0_br_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_br)
      BR_N : execute0_outInst_payload_ctrl_br_string = "N  ";
      BR_NE : execute0_outInst_payload_ctrl_br_string = "NE ";
      BR_EQ : execute0_outInst_payload_ctrl_br_string = "EQ ";
      BR_GE : execute0_outInst_payload_ctrl_br_string = "GE ";
      BR_GEU : execute0_outInst_payload_ctrl_br_string = "GEU";
      BR_LT : execute0_outInst_payload_ctrl_br_string = "LT ";
      BR_LTU : execute0_outInst_payload_ctrl_br_string = "LTU";
      BR_J : execute0_outInst_payload_ctrl_br_string = "J  ";
      BR_JR : execute0_outInst_payload_ctrl_br_string = "JR ";
      default : execute0_outInst_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_op0)
      OP0_RS : execute0_outInst_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute0_outInst_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute0_outInst_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute0_outInst_payload_ctrl_op0_string = "IMJB";
      default : execute0_outInst_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_op1)
      OP1_RS : execute0_outInst_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute0_outInst_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute0_outInst_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute0_outInst_payload_ctrl_op1_string = "PC ";
      default : execute0_outInst_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_alu)
      ALU_ADD : execute0_outInst_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute0_outInst_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute0_outInst_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute0_outInst_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute0_outInst_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute0_outInst_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute0_outInst_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute0_outInst_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute0_outInst_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute0_outInst_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute0_outInst_payload_ctrl_alu_string = "SRA_1";
      default : execute0_outInst_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_wb)
      WB_ALU : execute0_outInst_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute0_outInst_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute0_outInst_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute0_outInst_payload_ctrl_wb_string = "CSR1";
      default : execute0_outInst_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_m)
      M_XRD : execute0_outInst_payload_ctrl_m_string = "XRD";
      M_XWR : execute0_outInst_payload_ctrl_m_string = "XWR";
      default : execute0_outInst_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_msk)
      MSK_B : execute0_outInst_payload_ctrl_msk_string = "B";
      MSK_H : execute0_outInst_payload_ctrl_msk_string = "H";
      MSK_W : execute0_outInst_payload_ctrl_msk_string = "W";
      default : execute0_outInst_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_csr)
      CSR_N : execute0_outInst_payload_ctrl_csr_string = "N";
      CSR_W : execute0_outInst_payload_ctrl_csr_string = "W";
      CSR_S : execute0_outInst_payload_ctrl_csr_string = "S";
      CSR_C : execute0_outInst_payload_ctrl_csr_string = "C";
      default : execute0_outInst_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_ctrl_mfs)
      MFS_N : execute0_outInst_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute0_outInst_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute0_outInst_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute0_outInst_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute0_outInst_payload_ctrl_mfs_string = "FD";
      default : execute0_outInst_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_payload_pc_sel)
      PC_INC : execute0_outInst_payload_pc_sel_string = "INC";
      PC_BRA : execute0_outInst_payload_pc_sel_string = "BRA";
      PC_J : execute0_outInst_payload_pc_sel_string = "J  ";
      PC_JR : execute0_outInst_payload_pc_sel_string = "JR ";
      default : execute0_outInst_payload_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_br)
      BR_N : execute0_inInst_throwWhen_payload_ctrl_br_string = "N  ";
      BR_NE : execute0_inInst_throwWhen_payload_ctrl_br_string = "NE ";
      BR_EQ : execute0_inInst_throwWhen_payload_ctrl_br_string = "EQ ";
      BR_GE : execute0_inInst_throwWhen_payload_ctrl_br_string = "GE ";
      BR_GEU : execute0_inInst_throwWhen_payload_ctrl_br_string = "GEU";
      BR_LT : execute0_inInst_throwWhen_payload_ctrl_br_string = "LT ";
      BR_LTU : execute0_inInst_throwWhen_payload_ctrl_br_string = "LTU";
      BR_J : execute0_inInst_throwWhen_payload_ctrl_br_string = "J  ";
      BR_JR : execute0_inInst_throwWhen_payload_ctrl_br_string = "JR ";
      default : execute0_inInst_throwWhen_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_op0)
      OP0_RS : execute0_inInst_throwWhen_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute0_inInst_throwWhen_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute0_inInst_throwWhen_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute0_inInst_throwWhen_payload_ctrl_op0_string = "IMJB";
      default : execute0_inInst_throwWhen_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_op1)
      OP1_RS : execute0_inInst_throwWhen_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute0_inInst_throwWhen_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute0_inInst_throwWhen_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute0_inInst_throwWhen_payload_ctrl_op1_string = "PC ";
      default : execute0_inInst_throwWhen_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_alu)
      ALU_ADD : execute0_inInst_throwWhen_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute0_inInst_throwWhen_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute0_inInst_throwWhen_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute0_inInst_throwWhen_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute0_inInst_throwWhen_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute0_inInst_throwWhen_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute0_inInst_throwWhen_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute0_inInst_throwWhen_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute0_inInst_throwWhen_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute0_inInst_throwWhen_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute0_inInst_throwWhen_payload_ctrl_alu_string = "SRA_1";
      default : execute0_inInst_throwWhen_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_wb)
      WB_ALU : execute0_inInst_throwWhen_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute0_inInst_throwWhen_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute0_inInst_throwWhen_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute0_inInst_throwWhen_payload_ctrl_wb_string = "CSR1";
      default : execute0_inInst_throwWhen_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_m)
      M_XRD : execute0_inInst_throwWhen_payload_ctrl_m_string = "XRD";
      M_XWR : execute0_inInst_throwWhen_payload_ctrl_m_string = "XWR";
      default : execute0_inInst_throwWhen_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_msk)
      MSK_B : execute0_inInst_throwWhen_payload_ctrl_msk_string = "B";
      MSK_H : execute0_inInst_throwWhen_payload_ctrl_msk_string = "H";
      MSK_W : execute0_inInst_throwWhen_payload_ctrl_msk_string = "W";
      default : execute0_inInst_throwWhen_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_csr)
      CSR_N : execute0_inInst_throwWhen_payload_ctrl_csr_string = "N";
      CSR_W : execute0_inInst_throwWhen_payload_ctrl_csr_string = "W";
      CSR_S : execute0_inInst_throwWhen_payload_ctrl_csr_string = "S";
      CSR_C : execute0_inInst_throwWhen_payload_ctrl_csr_string = "C";
      default : execute0_inInst_throwWhen_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_payload_ctrl_mfs)
      MFS_N : execute0_inInst_throwWhen_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute0_inInst_throwWhen_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute0_inInst_throwWhen_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute0_inInst_throwWhen_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute0_inInst_throwWhen_payload_ctrl_mfs_string = "FD";
      default : execute0_inInst_throwWhen_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_br)
      BR_N : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "N  ";
      BR_NE : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "NE ";
      BR_EQ : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "EQ ";
      BR_GE : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "GE ";
      BR_GEU : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "GEU";
      BR_LT : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "LT ";
      BR_LTU : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "LTU";
      BR_J : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "J  ";
      BR_JR : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "JR ";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0)
      OP0_RS : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMJB";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1)
      OP1_RS : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "PC ";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu)
      ALU_ADD : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SRA_1";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb)
      WB_ALU : execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "CSR1";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_m)
      M_XRD : execute0_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "XRD";
      M_XWR : execute0_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "XWR";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk)
      MSK_B : execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "B";
      MSK_H : execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "H";
      MSK_W : execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "W";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr)
      CSR_N : execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "N";
      CSR_W : execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "W";
      CSR_S : execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "S";
      CSR_C : execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "C";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs)
      MFS_N : execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "FD";
      default : execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_br)
      BR_N : execute1_inInst_payload_ctrl_br_string = "N  ";
      BR_NE : execute1_inInst_payload_ctrl_br_string = "NE ";
      BR_EQ : execute1_inInst_payload_ctrl_br_string = "EQ ";
      BR_GE : execute1_inInst_payload_ctrl_br_string = "GE ";
      BR_GEU : execute1_inInst_payload_ctrl_br_string = "GEU";
      BR_LT : execute1_inInst_payload_ctrl_br_string = "LT ";
      BR_LTU : execute1_inInst_payload_ctrl_br_string = "LTU";
      BR_J : execute1_inInst_payload_ctrl_br_string = "J  ";
      BR_JR : execute1_inInst_payload_ctrl_br_string = "JR ";
      default : execute1_inInst_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_op0)
      OP0_RS : execute1_inInst_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute1_inInst_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute1_inInst_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute1_inInst_payload_ctrl_op0_string = "IMJB";
      default : execute1_inInst_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_op1)
      OP1_RS : execute1_inInst_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute1_inInst_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute1_inInst_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute1_inInst_payload_ctrl_op1_string = "PC ";
      default : execute1_inInst_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_alu)
      ALU_ADD : execute1_inInst_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute1_inInst_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute1_inInst_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute1_inInst_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute1_inInst_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute1_inInst_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute1_inInst_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute1_inInst_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute1_inInst_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute1_inInst_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute1_inInst_payload_ctrl_alu_string = "SRA_1";
      default : execute1_inInst_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_wb)
      WB_ALU : execute1_inInst_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute1_inInst_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute1_inInst_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute1_inInst_payload_ctrl_wb_string = "CSR1";
      default : execute1_inInst_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_m)
      M_XRD : execute1_inInst_payload_ctrl_m_string = "XRD";
      M_XWR : execute1_inInst_payload_ctrl_m_string = "XWR";
      default : execute1_inInst_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_msk)
      MSK_B : execute1_inInst_payload_ctrl_msk_string = "B";
      MSK_H : execute1_inInst_payload_ctrl_msk_string = "H";
      MSK_W : execute1_inInst_payload_ctrl_msk_string = "W";
      default : execute1_inInst_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_csr)
      CSR_N : execute1_inInst_payload_ctrl_csr_string = "N";
      CSR_W : execute1_inInst_payload_ctrl_csr_string = "W";
      CSR_S : execute1_inInst_payload_ctrl_csr_string = "S";
      CSR_C : execute1_inInst_payload_ctrl_csr_string = "C";
      default : execute1_inInst_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_ctrl_mfs)
      MFS_N : execute1_inInst_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute1_inInst_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute1_inInst_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute1_inInst_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute1_inInst_payload_ctrl_mfs_string = "FD";
      default : execute1_inInst_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_payload_pc_sel)
      PC_INC : execute1_inInst_payload_pc_sel_string = "INC";
      PC_BRA : execute1_inInst_payload_pc_sel_string = "BRA";
      PC_J : execute1_inInst_payload_pc_sel_string = "J  ";
      PC_JR : execute1_inInst_payload_pc_sel_string = "JR ";
      default : execute1_inInst_payload_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_br)
      BR_N : execute0_outInst_rData_ctrl_br_string = "N  ";
      BR_NE : execute0_outInst_rData_ctrl_br_string = "NE ";
      BR_EQ : execute0_outInst_rData_ctrl_br_string = "EQ ";
      BR_GE : execute0_outInst_rData_ctrl_br_string = "GE ";
      BR_GEU : execute0_outInst_rData_ctrl_br_string = "GEU";
      BR_LT : execute0_outInst_rData_ctrl_br_string = "LT ";
      BR_LTU : execute0_outInst_rData_ctrl_br_string = "LTU";
      BR_J : execute0_outInst_rData_ctrl_br_string = "J  ";
      BR_JR : execute0_outInst_rData_ctrl_br_string = "JR ";
      default : execute0_outInst_rData_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_op0)
      OP0_RS : execute0_outInst_rData_ctrl_op0_string = "RS  ";
      OP0_IMU : execute0_outInst_rData_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute0_outInst_rData_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute0_outInst_rData_ctrl_op0_string = "IMJB";
      default : execute0_outInst_rData_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_op1)
      OP1_RS : execute0_outInst_rData_ctrl_op1_string = "RS ";
      OP1_IMI : execute0_outInst_rData_ctrl_op1_string = "IMI";
      OP1_IMS : execute0_outInst_rData_ctrl_op1_string = "IMS";
      OP1_PC : execute0_outInst_rData_ctrl_op1_string = "PC ";
      default : execute0_outInst_rData_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_alu)
      ALU_ADD : execute0_outInst_rData_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute0_outInst_rData_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute0_outInst_rData_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute0_outInst_rData_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute0_outInst_rData_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute0_outInst_rData_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute0_outInst_rData_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute0_outInst_rData_ctrl_alu_string = "AND_1";
      ALU_SUB : execute0_outInst_rData_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute0_outInst_rData_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute0_outInst_rData_ctrl_alu_string = "SRA_1";
      default : execute0_outInst_rData_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_wb)
      WB_ALU : execute0_outInst_rData_ctrl_wb_string = "ALU ";
      WB_MEM : execute0_outInst_rData_ctrl_wb_string = "MEM ";
      WB_PC4 : execute0_outInst_rData_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute0_outInst_rData_ctrl_wb_string = "CSR1";
      default : execute0_outInst_rData_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_m)
      M_XRD : execute0_outInst_rData_ctrl_m_string = "XRD";
      M_XWR : execute0_outInst_rData_ctrl_m_string = "XWR";
      default : execute0_outInst_rData_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_msk)
      MSK_B : execute0_outInst_rData_ctrl_msk_string = "B";
      MSK_H : execute0_outInst_rData_ctrl_msk_string = "H";
      MSK_W : execute0_outInst_rData_ctrl_msk_string = "W";
      default : execute0_outInst_rData_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_csr)
      CSR_N : execute0_outInst_rData_ctrl_csr_string = "N";
      CSR_W : execute0_outInst_rData_ctrl_csr_string = "W";
      CSR_S : execute0_outInst_rData_ctrl_csr_string = "S";
      CSR_C : execute0_outInst_rData_ctrl_csr_string = "C";
      default : execute0_outInst_rData_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_ctrl_mfs)
      MFS_N : execute0_outInst_rData_ctrl_mfs_string = "N ";
      MFS_SI : execute0_outInst_rData_ctrl_mfs_string = "SI";
      MFS_SD : execute0_outInst_rData_ctrl_mfs_string = "SD";
      MFS_FA : execute0_outInst_rData_ctrl_mfs_string = "FA";
      MFS_FD : execute0_outInst_rData_ctrl_mfs_string = "FD";
      default : execute0_outInst_rData_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute0_outInst_rData_pc_sel)
      PC_INC : execute0_outInst_rData_pc_sel_string = "INC";
      PC_BRA : execute0_outInst_rData_pc_sel_string = "BRA";
      PC_J : execute0_outInst_rData_pc_sel_string = "J  ";
      PC_JR : execute0_outInst_rData_pc_sel_string = "JR ";
      default : execute0_outInst_rData_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_br)
      BR_N : execute1_outInst_payload_ctrl_br_string = "N  ";
      BR_NE : execute1_outInst_payload_ctrl_br_string = "NE ";
      BR_EQ : execute1_outInst_payload_ctrl_br_string = "EQ ";
      BR_GE : execute1_outInst_payload_ctrl_br_string = "GE ";
      BR_GEU : execute1_outInst_payload_ctrl_br_string = "GEU";
      BR_LT : execute1_outInst_payload_ctrl_br_string = "LT ";
      BR_LTU : execute1_outInst_payload_ctrl_br_string = "LTU";
      BR_J : execute1_outInst_payload_ctrl_br_string = "J  ";
      BR_JR : execute1_outInst_payload_ctrl_br_string = "JR ";
      default : execute1_outInst_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_op0)
      OP0_RS : execute1_outInst_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute1_outInst_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute1_outInst_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute1_outInst_payload_ctrl_op0_string = "IMJB";
      default : execute1_outInst_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_op1)
      OP1_RS : execute1_outInst_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute1_outInst_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute1_outInst_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute1_outInst_payload_ctrl_op1_string = "PC ";
      default : execute1_outInst_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_alu)
      ALU_ADD : execute1_outInst_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute1_outInst_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute1_outInst_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute1_outInst_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute1_outInst_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute1_outInst_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute1_outInst_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute1_outInst_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute1_outInst_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute1_outInst_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute1_outInst_payload_ctrl_alu_string = "SRA_1";
      default : execute1_outInst_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_wb)
      WB_ALU : execute1_outInst_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute1_outInst_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute1_outInst_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute1_outInst_payload_ctrl_wb_string = "CSR1";
      default : execute1_outInst_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_m)
      M_XRD : execute1_outInst_payload_ctrl_m_string = "XRD";
      M_XWR : execute1_outInst_payload_ctrl_m_string = "XWR";
      default : execute1_outInst_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_msk)
      MSK_B : execute1_outInst_payload_ctrl_msk_string = "B";
      MSK_H : execute1_outInst_payload_ctrl_msk_string = "H";
      MSK_W : execute1_outInst_payload_ctrl_msk_string = "W";
      default : execute1_outInst_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_csr)
      CSR_N : execute1_outInst_payload_ctrl_csr_string = "N";
      CSR_W : execute1_outInst_payload_ctrl_csr_string = "W";
      CSR_S : execute1_outInst_payload_ctrl_csr_string = "S";
      CSR_C : execute1_outInst_payload_ctrl_csr_string = "C";
      default : execute1_outInst_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_payload_ctrl_mfs)
      MFS_N : execute1_outInst_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute1_outInst_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute1_outInst_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute1_outInst_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute1_outInst_payload_ctrl_mfs_string = "FD";
      default : execute1_outInst_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_br)
      BR_N : execute1_inInst_throwWhen_payload_ctrl_br_string = "N  ";
      BR_NE : execute1_inInst_throwWhen_payload_ctrl_br_string = "NE ";
      BR_EQ : execute1_inInst_throwWhen_payload_ctrl_br_string = "EQ ";
      BR_GE : execute1_inInst_throwWhen_payload_ctrl_br_string = "GE ";
      BR_GEU : execute1_inInst_throwWhen_payload_ctrl_br_string = "GEU";
      BR_LT : execute1_inInst_throwWhen_payload_ctrl_br_string = "LT ";
      BR_LTU : execute1_inInst_throwWhen_payload_ctrl_br_string = "LTU";
      BR_J : execute1_inInst_throwWhen_payload_ctrl_br_string = "J  ";
      BR_JR : execute1_inInst_throwWhen_payload_ctrl_br_string = "JR ";
      default : execute1_inInst_throwWhen_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_op0)
      OP0_RS : execute1_inInst_throwWhen_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute1_inInst_throwWhen_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute1_inInst_throwWhen_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute1_inInst_throwWhen_payload_ctrl_op0_string = "IMJB";
      default : execute1_inInst_throwWhen_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_op1)
      OP1_RS : execute1_inInst_throwWhen_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute1_inInst_throwWhen_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute1_inInst_throwWhen_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute1_inInst_throwWhen_payload_ctrl_op1_string = "PC ";
      default : execute1_inInst_throwWhen_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_alu)
      ALU_ADD : execute1_inInst_throwWhen_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute1_inInst_throwWhen_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute1_inInst_throwWhen_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute1_inInst_throwWhen_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute1_inInst_throwWhen_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute1_inInst_throwWhen_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute1_inInst_throwWhen_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute1_inInst_throwWhen_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute1_inInst_throwWhen_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute1_inInst_throwWhen_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute1_inInst_throwWhen_payload_ctrl_alu_string = "SRA_1";
      default : execute1_inInst_throwWhen_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_wb)
      WB_ALU : execute1_inInst_throwWhen_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute1_inInst_throwWhen_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute1_inInst_throwWhen_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute1_inInst_throwWhen_payload_ctrl_wb_string = "CSR1";
      default : execute1_inInst_throwWhen_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_m)
      M_XRD : execute1_inInst_throwWhen_payload_ctrl_m_string = "XRD";
      M_XWR : execute1_inInst_throwWhen_payload_ctrl_m_string = "XWR";
      default : execute1_inInst_throwWhen_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_msk)
      MSK_B : execute1_inInst_throwWhen_payload_ctrl_msk_string = "B";
      MSK_H : execute1_inInst_throwWhen_payload_ctrl_msk_string = "H";
      MSK_W : execute1_inInst_throwWhen_payload_ctrl_msk_string = "W";
      default : execute1_inInst_throwWhen_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_csr)
      CSR_N : execute1_inInst_throwWhen_payload_ctrl_csr_string = "N";
      CSR_W : execute1_inInst_throwWhen_payload_ctrl_csr_string = "W";
      CSR_S : execute1_inInst_throwWhen_payload_ctrl_csr_string = "S";
      CSR_C : execute1_inInst_throwWhen_payload_ctrl_csr_string = "C";
      default : execute1_inInst_throwWhen_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_ctrl_mfs)
      MFS_N : execute1_inInst_throwWhen_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute1_inInst_throwWhen_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute1_inInst_throwWhen_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute1_inInst_throwWhen_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute1_inInst_throwWhen_payload_ctrl_mfs_string = "FD";
      default : execute1_inInst_throwWhen_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_payload_pc_sel)
      PC_INC : execute1_inInst_throwWhen_payload_pc_sel_string = "INC";
      PC_BRA : execute1_inInst_throwWhen_payload_pc_sel_string = "BRA";
      PC_J : execute1_inInst_throwWhen_payload_pc_sel_string = "J  ";
      PC_JR : execute1_inInst_throwWhen_payload_pc_sel_string = "JR ";
      default : execute1_inInst_throwWhen_payload_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_br)
      BR_N : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "N  ";
      BR_NE : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "NE ";
      BR_EQ : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "EQ ";
      BR_GE : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "GE ";
      BR_GEU : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "GEU";
      BR_LT : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "LT ";
      BR_LTU : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "LTU";
      BR_J : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "J  ";
      BR_JR : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "JR ";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0)
      OP0_RS : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMJB";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1)
      OP1_RS : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "RS ";
      OP1_IMI : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "IMI";
      OP1_IMS : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "IMS";
      OP1_PC : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "PC ";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu)
      ALU_ADD : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SRA_1";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb)
      WB_ALU : execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "ALU ";
      WB_MEM : execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "CSR1";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_m)
      M_XRD : execute1_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "XRD";
      M_XWR : execute1_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "XWR";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk)
      MSK_B : execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "B";
      MSK_H : execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "H";
      MSK_W : execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "W";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr)
      CSR_N : execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "N";
      CSR_W : execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "W";
      CSR_S : execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "S";
      CSR_C : execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "C";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs)
      MFS_N : execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "N ";
      MFS_SI : execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "SI";
      MFS_SD : execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "SD";
      MFS_FA : execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "FA";
      MFS_FD : execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "FD";
      default : execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute1_inInst_throwWhen_haltWhen_payload_pc_sel)
      PC_INC : execute1_inInst_throwWhen_haltWhen_payload_pc_sel_string = "INC";
      PC_BRA : execute1_inInst_throwWhen_haltWhen_payload_pc_sel_string = "BRA";
      PC_J : execute1_inInst_throwWhen_haltWhen_payload_pc_sel_string = "J  ";
      PC_JR : execute1_inInst_throwWhen_haltWhen_payload_pc_sel_string = "JR ";
      default : execute1_inInst_throwWhen_haltWhen_payload_pc_sel_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_br)
      BR_N : writeBack_inInst_payload_ctrl_br_string = "N  ";
      BR_NE : writeBack_inInst_payload_ctrl_br_string = "NE ";
      BR_EQ : writeBack_inInst_payload_ctrl_br_string = "EQ ";
      BR_GE : writeBack_inInst_payload_ctrl_br_string = "GE ";
      BR_GEU : writeBack_inInst_payload_ctrl_br_string = "GEU";
      BR_LT : writeBack_inInst_payload_ctrl_br_string = "LT ";
      BR_LTU : writeBack_inInst_payload_ctrl_br_string = "LTU";
      BR_J : writeBack_inInst_payload_ctrl_br_string = "J  ";
      BR_JR : writeBack_inInst_payload_ctrl_br_string = "JR ";
      default : writeBack_inInst_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_op0)
      OP0_RS : writeBack_inInst_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : writeBack_inInst_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : writeBack_inInst_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : writeBack_inInst_payload_ctrl_op0_string = "IMJB";
      default : writeBack_inInst_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_op1)
      OP1_RS : writeBack_inInst_payload_ctrl_op1_string = "RS ";
      OP1_IMI : writeBack_inInst_payload_ctrl_op1_string = "IMI";
      OP1_IMS : writeBack_inInst_payload_ctrl_op1_string = "IMS";
      OP1_PC : writeBack_inInst_payload_ctrl_op1_string = "PC ";
      default : writeBack_inInst_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_alu)
      ALU_ADD : writeBack_inInst_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : writeBack_inInst_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : writeBack_inInst_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : writeBack_inInst_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : writeBack_inInst_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : writeBack_inInst_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : writeBack_inInst_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : writeBack_inInst_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : writeBack_inInst_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : writeBack_inInst_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : writeBack_inInst_payload_ctrl_alu_string = "SRA_1";
      default : writeBack_inInst_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_wb)
      WB_ALU : writeBack_inInst_payload_ctrl_wb_string = "ALU ";
      WB_MEM : writeBack_inInst_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : writeBack_inInst_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : writeBack_inInst_payload_ctrl_wb_string = "CSR1";
      default : writeBack_inInst_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_m)
      M_XRD : writeBack_inInst_payload_ctrl_m_string = "XRD";
      M_XWR : writeBack_inInst_payload_ctrl_m_string = "XWR";
      default : writeBack_inInst_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_msk)
      MSK_B : writeBack_inInst_payload_ctrl_msk_string = "B";
      MSK_H : writeBack_inInst_payload_ctrl_msk_string = "H";
      MSK_W : writeBack_inInst_payload_ctrl_msk_string = "W";
      default : writeBack_inInst_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_csr)
      CSR_N : writeBack_inInst_payload_ctrl_csr_string = "N";
      CSR_W : writeBack_inInst_payload_ctrl_csr_string = "W";
      CSR_S : writeBack_inInst_payload_ctrl_csr_string = "S";
      CSR_C : writeBack_inInst_payload_ctrl_csr_string = "C";
      default : writeBack_inInst_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_payload_ctrl_mfs)
      MFS_N : writeBack_inInst_payload_ctrl_mfs_string = "N ";
      MFS_SI : writeBack_inInst_payload_ctrl_mfs_string = "SI";
      MFS_SD : writeBack_inInst_payload_ctrl_mfs_string = "SD";
      MFS_FA : writeBack_inInst_payload_ctrl_mfs_string = "FA";
      MFS_FD : writeBack_inInst_payload_ctrl_mfs_string = "FD";
      default : writeBack_inInst_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_br)
      BR_N : execute1_outInst_rData_ctrl_br_string = "N  ";
      BR_NE : execute1_outInst_rData_ctrl_br_string = "NE ";
      BR_EQ : execute1_outInst_rData_ctrl_br_string = "EQ ";
      BR_GE : execute1_outInst_rData_ctrl_br_string = "GE ";
      BR_GEU : execute1_outInst_rData_ctrl_br_string = "GEU";
      BR_LT : execute1_outInst_rData_ctrl_br_string = "LT ";
      BR_LTU : execute1_outInst_rData_ctrl_br_string = "LTU";
      BR_J : execute1_outInst_rData_ctrl_br_string = "J  ";
      BR_JR : execute1_outInst_rData_ctrl_br_string = "JR ";
      default : execute1_outInst_rData_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_op0)
      OP0_RS : execute1_outInst_rData_ctrl_op0_string = "RS  ";
      OP0_IMU : execute1_outInst_rData_ctrl_op0_string = "IMU ";
      OP0_IMZ : execute1_outInst_rData_ctrl_op0_string = "IMZ ";
      OP0_IMJB : execute1_outInst_rData_ctrl_op0_string = "IMJB";
      default : execute1_outInst_rData_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_op1)
      OP1_RS : execute1_outInst_rData_ctrl_op1_string = "RS ";
      OP1_IMI : execute1_outInst_rData_ctrl_op1_string = "IMI";
      OP1_IMS : execute1_outInst_rData_ctrl_op1_string = "IMS";
      OP1_PC : execute1_outInst_rData_ctrl_op1_string = "PC ";
      default : execute1_outInst_rData_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_alu)
      ALU_ADD : execute1_outInst_rData_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : execute1_outInst_rData_ctrl_alu_string = "SLL1 ";
      ALU_SLT : execute1_outInst_rData_ctrl_alu_string = "SLT  ";
      ALU_SLTU : execute1_outInst_rData_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : execute1_outInst_rData_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : execute1_outInst_rData_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : execute1_outInst_rData_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : execute1_outInst_rData_ctrl_alu_string = "AND_1";
      ALU_SUB : execute1_outInst_rData_ctrl_alu_string = "SUB  ";
      ALU_COPY : execute1_outInst_rData_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : execute1_outInst_rData_ctrl_alu_string = "SRA_1";
      default : execute1_outInst_rData_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_wb)
      WB_ALU : execute1_outInst_rData_ctrl_wb_string = "ALU ";
      WB_MEM : execute1_outInst_rData_ctrl_wb_string = "MEM ";
      WB_PC4 : execute1_outInst_rData_ctrl_wb_string = "PC4 ";
      WB_CSR1 : execute1_outInst_rData_ctrl_wb_string = "CSR1";
      default : execute1_outInst_rData_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_m)
      M_XRD : execute1_outInst_rData_ctrl_m_string = "XRD";
      M_XWR : execute1_outInst_rData_ctrl_m_string = "XWR";
      default : execute1_outInst_rData_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_msk)
      MSK_B : execute1_outInst_rData_ctrl_msk_string = "B";
      MSK_H : execute1_outInst_rData_ctrl_msk_string = "H";
      MSK_W : execute1_outInst_rData_ctrl_msk_string = "W";
      default : execute1_outInst_rData_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_csr)
      CSR_N : execute1_outInst_rData_ctrl_csr_string = "N";
      CSR_W : execute1_outInst_rData_ctrl_csr_string = "W";
      CSR_S : execute1_outInst_rData_ctrl_csr_string = "S";
      CSR_C : execute1_outInst_rData_ctrl_csr_string = "C";
      default : execute1_outInst_rData_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(execute1_outInst_rData_ctrl_mfs)
      MFS_N : execute1_outInst_rData_ctrl_mfs_string = "N ";
      MFS_SI : execute1_outInst_rData_ctrl_mfs_string = "SI";
      MFS_SD : execute1_outInst_rData_ctrl_mfs_string = "SD";
      MFS_FA : execute1_outInst_rData_ctrl_mfs_string = "FA";
      MFS_FD : execute1_outInst_rData_ctrl_mfs_string = "FD";
      default : execute1_outInst_rData_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_br)
      BR_N : writeBack_inInst_throwWhen_payload_ctrl_br_string = "N  ";
      BR_NE : writeBack_inInst_throwWhen_payload_ctrl_br_string = "NE ";
      BR_EQ : writeBack_inInst_throwWhen_payload_ctrl_br_string = "EQ ";
      BR_GE : writeBack_inInst_throwWhen_payload_ctrl_br_string = "GE ";
      BR_GEU : writeBack_inInst_throwWhen_payload_ctrl_br_string = "GEU";
      BR_LT : writeBack_inInst_throwWhen_payload_ctrl_br_string = "LT ";
      BR_LTU : writeBack_inInst_throwWhen_payload_ctrl_br_string = "LTU";
      BR_J : writeBack_inInst_throwWhen_payload_ctrl_br_string = "J  ";
      BR_JR : writeBack_inInst_throwWhen_payload_ctrl_br_string = "JR ";
      default : writeBack_inInst_throwWhen_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_op0)
      OP0_RS : writeBack_inInst_throwWhen_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : writeBack_inInst_throwWhen_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : writeBack_inInst_throwWhen_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : writeBack_inInst_throwWhen_payload_ctrl_op0_string = "IMJB";
      default : writeBack_inInst_throwWhen_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_op1)
      OP1_RS : writeBack_inInst_throwWhen_payload_ctrl_op1_string = "RS ";
      OP1_IMI : writeBack_inInst_throwWhen_payload_ctrl_op1_string = "IMI";
      OP1_IMS : writeBack_inInst_throwWhen_payload_ctrl_op1_string = "IMS";
      OP1_PC : writeBack_inInst_throwWhen_payload_ctrl_op1_string = "PC ";
      default : writeBack_inInst_throwWhen_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_alu)
      ALU_ADD : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "SRA_1";
      default : writeBack_inInst_throwWhen_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_wb)
      WB_ALU : writeBack_inInst_throwWhen_payload_ctrl_wb_string = "ALU ";
      WB_MEM : writeBack_inInst_throwWhen_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : writeBack_inInst_throwWhen_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : writeBack_inInst_throwWhen_payload_ctrl_wb_string = "CSR1";
      default : writeBack_inInst_throwWhen_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_m)
      M_XRD : writeBack_inInst_throwWhen_payload_ctrl_m_string = "XRD";
      M_XWR : writeBack_inInst_throwWhen_payload_ctrl_m_string = "XWR";
      default : writeBack_inInst_throwWhen_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_msk)
      MSK_B : writeBack_inInst_throwWhen_payload_ctrl_msk_string = "B";
      MSK_H : writeBack_inInst_throwWhen_payload_ctrl_msk_string = "H";
      MSK_W : writeBack_inInst_throwWhen_payload_ctrl_msk_string = "W";
      default : writeBack_inInst_throwWhen_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_csr)
      CSR_N : writeBack_inInst_throwWhen_payload_ctrl_csr_string = "N";
      CSR_W : writeBack_inInst_throwWhen_payload_ctrl_csr_string = "W";
      CSR_S : writeBack_inInst_throwWhen_payload_ctrl_csr_string = "S";
      CSR_C : writeBack_inInst_throwWhen_payload_ctrl_csr_string = "C";
      default : writeBack_inInst_throwWhen_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_payload_ctrl_mfs)
      MFS_N : writeBack_inInst_throwWhen_payload_ctrl_mfs_string = "N ";
      MFS_SI : writeBack_inInst_throwWhen_payload_ctrl_mfs_string = "SI";
      MFS_SD : writeBack_inInst_throwWhen_payload_ctrl_mfs_string = "SD";
      MFS_FA : writeBack_inInst_throwWhen_payload_ctrl_mfs_string = "FA";
      MFS_FD : writeBack_inInst_throwWhen_payload_ctrl_mfs_string = "FD";
      default : writeBack_inInst_throwWhen_payload_ctrl_mfs_string = "??";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br)
      BR_N : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "N  ";
      BR_NE : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "NE ";
      BR_EQ : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "EQ ";
      BR_GE : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "GE ";
      BR_GEU : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "GEU";
      BR_LT : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "LT ";
      BR_LTU : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "LTU";
      BR_J : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "J  ";
      BR_JR : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "JR ";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0)
      OP0_RS : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "RS  ";
      OP0_IMU : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMU ";
      OP0_IMZ : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMZ ";
      OP0_IMJB : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "IMJB";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0_string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1)
      OP1_RS : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "RS ";
      OP1_IMI : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "IMI";
      OP1_IMS : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "IMS";
      OP1_PC : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "PC ";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu)
      ALU_ADD : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "ADD  ";
      ALU_SLL1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLL1 ";
      ALU_SLT : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLT  ";
      ALU_SLTU : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SLTU ";
      ALU_XOR_1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "XOR_1";
      ALU_SRL_1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SRL_1";
      ALU_OR_1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "OR_1 ";
      ALU_AND_1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "AND_1";
      ALU_SUB : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SUB  ";
      ALU_COPY : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "COPY ";
      ALU_SRA_1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "SRA_1";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu_string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb)
      WB_ALU : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "ALU ";
      WB_MEM : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "MEM ";
      WB_PC4 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "PC4 ";
      WB_CSR1 : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "CSR1";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb_string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m)
      M_XRD : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "XRD";
      M_XWR : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "XWR";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m_string = "???";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk)
      MSK_B : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "B";
      MSK_H : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "H";
      MSK_W : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "W";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk_string = "?";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr)
      CSR_N : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "N";
      CSR_W : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "W";
      CSR_S : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "S";
      CSR_C : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "C";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr_string = "?";
    endcase
  end
  always @(*) begin
    case(writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs)
      MFS_N : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "N ";
      MFS_SI : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "SI";
      MFS_SD : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "SD";
      MFS_FA : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "FA";
      MFS_FD : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "FD";
      default : writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs_string = "??";
    endcase
  end
  `endif

  always @(*) begin
    _zz_1 = 1'b0;
    if(writeBack_regFileWrite_valid) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    _zz_2 = 1'b0;
    if(when_RiscvCore_l792) begin
      if(when_RiscvCore_l793) begin
        _zz_2 = 1'b1;
      end
    end
  end

  always @(*) begin
    prefetch_halt = 1'b0;
    if(DebugExtension_haltIt) begin
      prefetch_halt = 1'b1;
    end
  end

  assign _zz_prefetch_pcNext = (prefetch_pc + 32'h00000004);
  always @(*) begin
    prefetch_pcNext = (prefetch_inc ? _zz_prefetch_pcNext : prefetch_pc);
    if(prefetch_pcLoad_valid) begin
      prefetch_pcNext = prefetch_pcLoad_payload;
    end
  end

  always @(*) begin
    iCmd_valid = (prefetch_resetDone && (! prefetch_halt));
    if(when_RiscvCore_l552) begin
      iCmd_valid = 1'b0;
    end
  end

  assign iCmd_payload_pc = prefetch_pcNext;
  assign iCmd_fire = (iCmd_valid && iCmd_ready);
  assign when_RiscvCore_l530 = (iCmd_fire || prefetch_pcLoad_valid);
  always @(*) begin
    fetch_throwIt = 1'b0;
    if(fetch_flush) begin
      fetch_throwIt = 1'b1;
    end
    if(decode_flush) begin
      fetch_throwIt = 1'b1;
    end
    if(execute0_flush) begin
      fetch_throwIt = 1'b1;
    end
    if(execute1_flush) begin
      fetch_throwIt = 1'b1;
    end
    if(writeBack_flush) begin
      fetch_throwIt = 1'b1;
    end
  end

  always @(*) begin
    fetch_flush = 1'b0;
    if(decode_pcLoad_valid) begin
      fetch_flush = 1'b1;
    end
  end

  assign iRsp_fire = (iRsp_valid && iRsp_ready);
  always @(*) begin
    fetch_pendingPrefetch_incrementIt = 1'b0;
    if(iCmd_fire) begin
      fetch_pendingPrefetch_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    fetch_pendingPrefetch_decrementIt = 1'b0;
    if(iRsp_fire) begin
      fetch_pendingPrefetch_decrementIt = 1'b1;
    end
  end

  assign fetch_pendingPrefetch_mayOverflow = (fetch_pendingPrefetch_value == 2'b11);
  assign fetch_pendingPrefetch_mayUnderflow = (fetch_pendingPrefetch_value == 2'b00);
  assign fetch_pendingPrefetch_willOverflowIfInc = (fetch_pendingPrefetch_mayOverflow && (! fetch_pendingPrefetch_decrementIt));
  assign fetch_pendingPrefetch_willOverflow = (fetch_pendingPrefetch_willOverflowIfInc && fetch_pendingPrefetch_incrementIt);
  assign fetch_pendingPrefetch_willUnderflowIfDec = (fetch_pendingPrefetch_mayUnderflow && (! fetch_pendingPrefetch_incrementIt));
  assign fetch_pendingPrefetch_willUnderflow = (fetch_pendingPrefetch_willUnderflowIfDec && fetch_pendingPrefetch_decrementIt);
  assign when_Utils_l751 = (fetch_pendingPrefetch_incrementIt && (! fetch_pendingPrefetch_decrementIt));
  always @(*) begin
    if(when_Utils_l751) begin
      fetch_pendingPrefetch_finalIncrement = 2'b01;
    end else begin
      if(when_Utils_l753) begin
        fetch_pendingPrefetch_finalIncrement = 2'b11;
      end else begin
        fetch_pendingPrefetch_finalIncrement = 2'b00;
      end
    end
  end

  assign when_Utils_l753 = ((! fetch_pendingPrefetch_incrementIt) && fetch_pendingPrefetch_decrementIt);
  assign fetch_pendingPrefetch_valueNext = (fetch_pendingPrefetch_value + fetch_pendingPrefetch_finalIncrement);
  assign when_RiscvCore_l552 = (fetch_pendingPrefetch_value == 2'b11);
  assign fetch_throwNextIRsp = (fetch_throwRemaining != 2'b00);
  assign when_RiscvCore_l558 = (fetch_throwNextIRsp && iRsp_fire);
  assign when_Stream_l486 = (fetch_throwIt || fetch_throwNextIRsp);
  always @(*) begin
    iRsp_throwWhen_valid = iRsp_valid;
    if(when_Stream_l486) begin
      iRsp_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    iRsp_ready = iRsp_throwWhen_ready;
    if(when_Stream_l486) begin
      iRsp_ready = 1'b1;
    end
  end

  assign iRsp_throwWhen_payload_instruction = iRsp_payload_instruction;
  assign iRsp_throwWhen_payload_pc = iRsp_payload_pc;
  assign iRsp_throwWhen_payload_branchCacheLine_pc = iRsp_payload_branchCacheLine_pc;
  assign iRsp_throwWhen_payload_branchCacheLine_history = iRsp_payload_branchCacheLine_history;
  assign fetch_outInst_valid = iRsp_throwWhen_valid;
  assign iRsp_throwWhen_ready = fetch_outInst_ready;
  assign fetch_outInst_payload_pc = iRsp_payload_pc;
  assign fetch_outInst_payload_instruction = iRsp_payload_instruction;
  assign fetch_outInst_payload_branchCacheLine_pc = iRsp_payload_branchCacheLine_pc;
  assign fetch_outInst_payload_branchCacheLine_history = iRsp_payload_branchCacheLine_history;
  always @(*) begin
    fetch_outInst_ready = decode_inInst_ready;
    if(when_Stream_l399) begin
      fetch_outInst_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! decode_inInst_valid);
  assign decode_inInst_valid = fetch_outInst_rValid;
  assign decode_inInst_payload_pc = fetch_outInst_rData_pc;
  assign decode_inInst_payload_instruction = fetch_outInst_rData_instruction;
  assign decode_inInst_payload_branchCacheLine_pc = fetch_outInst_rData_branchCacheLine_pc;
  assign decode_inInst_payload_branchCacheLine_history = fetch_outInst_rData_branchCacheLine_history;
  always @(*) begin
    decode_ctrl_instVal = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        decode_ctrl_instVal = 1'b1;
      end
      if(when_Misc_l185) begin
        decode_ctrl_instVal = 1'b1;
      end
      if(when_Misc_l195) begin
        decode_ctrl_instVal = 1'b1;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_instVal = 1'b1;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_instVal = 1'b1;
            end
          end
        end
      end
      if(when_Misc_l235) begin
        decode_ctrl_instVal = 1'b1;
      end
      if(when_Misc_l245) begin
        decode_ctrl_instVal = 1'b1;
      end
      if(when_Misc_l256) begin
        decode_ctrl_instVal = 1'b1;
      end
      if(when_Misc_l265) begin
        decode_ctrl_instVal = 1'b1;
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_instVal = 1'b1;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_instVal = 1'b1;
    end
    if(when_SimpleInterruptExtension_l85) begin
      decode_ctrl_instVal = 1'b1;
    end
  end

  always @(*) begin
    decode_ctrl_br = BR_N;
    if(when_Misc_l166) begin
      if(when_Misc_l235) begin
        decode_ctrl_br = BR_J;
      end
      if(when_Misc_l245) begin
        decode_ctrl_br = BR_JR;
      end
      if(when_Misc_l256) begin
        decode_ctrl_br = _zz_decode_ctrl_br;
      end
    end
  end

  always @(*) begin
    decode_ctrl_jmp = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l235) begin
        decode_ctrl_jmp = 1'b1;
      end
      if(when_Misc_l245) begin
        decode_ctrl_jmp = 1'b1;
      end
    end
  end

  always @(*) begin
    decode_ctrl_op0 = OP0_RS;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        decode_ctrl_op0 = OP0_RS;
      end
      if(when_Misc_l185) begin
        decode_ctrl_op0 = OP0_IMU;
      end
      if(when_Misc_l195) begin
        decode_ctrl_op0 = OP0_IMU;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_op0 = OP0_RS;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_op0 = OP0_RS;
            end
          end
        end
      end
      if(when_Misc_l235) begin
        decode_ctrl_op0 = OP0_IMJB;
      end
      if(when_Misc_l245) begin
        decode_ctrl_op0 = OP0_RS;
      end
      if(when_Misc_l256) begin
        decode_ctrl_op0 = OP0_IMJB;
      end
      if(when_Misc_l265) begin
        if(when_Misc_l267) begin
          decode_ctrl_op0 = OP0_IMZ;
        end else begin
          decode_ctrl_op0 = OP0_RS;
        end
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_op0 = OP0_RS;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_op0 = OP0_RS;
    end
  end

  always @(*) begin
    decode_ctrl_op1 = OP1_RS;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        if(when_Misc_l174) begin
          decode_ctrl_op1 = OP1_IMI;
        end else begin
          decode_ctrl_op1 = OP1_IMS;
        end
      end
      if(when_Misc_l185) begin
        decode_ctrl_op1 = OP1_PC;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_op1 = OP1_IMI;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_op1 = OP1_RS;
            end
          end
        end
      end
      if(when_Misc_l235) begin
        decode_ctrl_op1 = OP1_PC;
      end
      if(when_Misc_l245) begin
        decode_ctrl_op1 = OP1_IMI;
      end
      if(when_Misc_l256) begin
        decode_ctrl_op1 = OP1_PC;
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_op1 = OP1_RS;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_op1 = OP1_RS;
    end
  end

  always @(*) begin
    decode_ctrl_alu = ALU_ADD;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        decode_ctrl_alu = ALU_ADD;
      end
      if(when_Misc_l185) begin
        decode_ctrl_alu = ALU_ADD;
      end
      if(when_Misc_l195) begin
        decode_ctrl_alu = ALU_COPY;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_alu = _zz_decode_ctrl_alu;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_alu = _zz_decode_ctrl_alu_1;
            end
          end
        end
      end
      if(when_Misc_l235) begin
        decode_ctrl_alu = ALU_ADD;
      end
      if(when_Misc_l245) begin
        decode_ctrl_alu = ALU_ADD;
      end
      if(when_Misc_l256) begin
        decode_ctrl_alu = ALU_ADD;
      end
      if(when_Misc_l265) begin
        decode_ctrl_alu = ALU_COPY;
      end
    end
    if(when_SimpleInterruptExtension_l85) begin
      decode_ctrl_alu = ALU_COPY;
    end
  end

  always @(*) begin
    decode_ctrl_wb = WB_ALU;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        if(when_Misc_l174) begin
          decode_ctrl_wb = WB_MEM;
        end
      end
      if(when_Misc_l185) begin
        decode_ctrl_wb = WB_ALU;
      end
      if(when_Misc_l195) begin
        decode_ctrl_wb = WB_ALU;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_wb = WB_ALU;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_wb = WB_ALU;
            end
          end
        end
      end
      if(when_Misc_l235) begin
        decode_ctrl_wb = WB_PC4;
      end
      if(when_Misc_l245) begin
        decode_ctrl_wb = WB_PC4;
      end
      if(when_Misc_l265) begin
        decode_ctrl_wb = WB_CSR1;
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_wb = WB_ALU;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_wb = WB_ALU;
    end
    if(when_SimpleInterruptExtension_l85) begin
      decode_ctrl_wb = WB_ALU;
    end
  end

  always @(*) begin
    decode_ctrl_rfen = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        if(when_Misc_l174) begin
          decode_ctrl_rfen = 1'b1;
        end
      end
      if(when_Misc_l185) begin
        decode_ctrl_rfen = 1'b1;
      end
      if(when_Misc_l195) begin
        decode_ctrl_rfen = 1'b1;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_rfen = 1'b1;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_rfen = 1'b1;
            end
          end
        end
      end
      if(when_Misc_l235) begin
        decode_ctrl_rfen = 1'b1;
      end
      if(when_Misc_l245) begin
        decode_ctrl_rfen = 1'b1;
      end
      if(when_Misc_l265) begin
        decode_ctrl_rfen = 1'b1;
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_rfen = 1'b1;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_rfen = 1'b1;
    end
    if(when_SimpleInterruptExtension_l85) begin
      if(when_SimpleInterruptExtension_l90) begin
        decode_ctrl_rfen = 1'b1;
      end
    end
  end

  always @(*) begin
    decode_ctrl_execute0AluBypass = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l185) begin
        decode_ctrl_execute0AluBypass = 1'b1;
      end
      if(when_Misc_l195) begin
        decode_ctrl_execute0AluBypass = 1'b1;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_execute0AluBypass = (! _zz_decode_ctrl_execute0AluBypass);
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_execute0AluBypass = (! _zz_decode_ctrl_execute0AluBypass);
            end
          end
        end
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_execute0AluBypass = 1'b0;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_execute0AluBypass = 1'b0;
    end
  end

  always @(*) begin
    decode_ctrl_execute1AluBypass = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l185) begin
        decode_ctrl_execute1AluBypass = 1'b1;
      end
      if(when_Misc_l195) begin
        decode_ctrl_execute1AluBypass = 1'b1;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_execute1AluBypass = 1'b1;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_execute1AluBypass = 1'b1;
            end
          end
        end
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_execute1AluBypass = 1'b0;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_execute1AluBypass = 1'b1;
    end
  end

  assign decode_ctrl_canInternalyStallWriteBack0 = 1'b0;
  always @(*) begin
    decode_ctrl_men = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        decode_ctrl_men = 1'b1;
      end
    end
  end

  always @(*) begin
    decode_ctrl_m = M_XRD;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        if(when_Misc_l174) begin
          decode_ctrl_m = M_XRD;
        end else begin
          decode_ctrl_m = M_XWR;
        end
      end
    end
  end

  assign _zz_decode_ctrl_msk = decode_inInst_payload_instruction[13 : 12];
  assign decode_ctrl_msk = _zz_decode_ctrl_msk;
  always @(*) begin
    decode_ctrl_csr = CSR_N;
    if(when_Misc_l166) begin
      if(when_Misc_l265) begin
        decode_ctrl_csr = _zz_decode_ctrl_csr;
      end
    end
  end

  assign decode_ctrl_mfs = MFS_N;
  always @(*) begin
    decode_ctrl_useSrc0 = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        decode_ctrl_useSrc0 = 1'b1;
      end
      if(when_Misc_l204) begin
        if(when_Misc_l206) begin
          if(when_Misc_l207) begin
            decode_ctrl_useSrc0 = 1'b1;
          end
        end else begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_useSrc0 = 1'b1;
            end
          end
        end
      end
      if(when_Misc_l245) begin
        decode_ctrl_useSrc0 = 1'b1;
      end
      if(when_Misc_l256) begin
        decode_ctrl_useSrc0 = 1'b1;
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_useSrc0 = 1'b1;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_useSrc0 = 1'b1;
    end
  end

  always @(*) begin
    decode_ctrl_useSrc1 = 1'b0;
    if(when_Misc_l166) begin
      if(when_Misc_l168) begin
        if(!when_Misc_l174) begin
          decode_ctrl_useSrc1 = 1'b1;
        end
      end
      if(when_Misc_l204) begin
        if(!when_Misc_l206) begin
          if(when_Misc_l219) begin
            if(when_Misc_l220) begin
              decode_ctrl_useSrc1 = 1'b1;
            end
          end
        end
      end
      if(when_Misc_l256) begin
        decode_ctrl_useSrc1 = 1'b1;
      end
    end
    if(when_MulExtension_l89) begin
      decode_ctrl_useSrc1 = 1'b1;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_useSrc1 = 1'b1;
    end
  end

  always @(*) begin
    decode_ctrl_extensionTag = 3'b000;
    if(when_MulExtension_l89) begin
      decode_ctrl_extensionTag = 3'b001;
    end
    if(when_DivExtension_l52) begin
      decode_ctrl_extensionTag = 3'b010;
    end
    if(when_SimpleInterruptExtension_l85) begin
      decode_ctrl_extensionTag = 3'b011;
    end
    if(when_DebugExtension_l192) begin
      decode_ctrl_extensionTag = 3'b100;
    end
  end

  always @(*) begin
    decode_ctrl_fencei = 1'b0;
    if(when_Misc_l166) begin
      decode_ctrl_fencei = ((decode_inInst_payload_instruction & 32'hfffffffc) == 32'h0000100c);
    end
  end

  assign when_Misc_l166 = ((decode_inInst_payload_instruction & 32'h00000003) == 32'h00000003);
  assign when_Misc_l168 = ((decode_inInst_payload_instruction & 32'h0000005c) == 32'h0);
  assign when_Misc_l174 = ((decode_inInst_payload_instruction & 32'h00000020) == 32'h0);
  assign when_Misc_l185 = ((decode_inInst_payload_instruction & 32'h0000007c) == 32'h00000014);
  assign when_Misc_l195 = ((decode_inInst_payload_instruction & 32'h0000007c) == 32'h00000034);
  assign when_Misc_l204 = ((decode_inInst_payload_instruction & 32'h0000005c) == 32'h00000010);
  assign _zz_decode_ctrl_execute0AluBypass = ((decode_inInst_payload_instruction & 32'h00003000) == 32'h00001000);
  assign when_Misc_l206 = ((decode_inInst_payload_instruction & 32'h00000020) == 32'h0);
  assign when_Misc_l207 = ((! _zz_decode_ctrl_execute0AluBypass) || (((decode_inInst_payload_instruction & 32'hbe000000) == 32'h0) && (! (decode_inInst_payload_instruction[30] && (! decode_inInst_payload_instruction[14])))));
  assign _zz_decode_ctrl_alu = {(_zz_decode_ctrl_execute0AluBypass && decode_inInst_payload_instruction[30]),decode_inInst_payload_instruction[14 : 12]};
  assign when_Misc_l219 = ((decode_inInst_payload_instruction & 32'hbe000000) == 32'h0);
  assign when_Misc_l220 = (((decode_inInst_payload_instruction[30] == 1'b0) || (decode_inInst_payload_instruction[14 : 12] == 3'b000)) || (decode_inInst_payload_instruction[14 : 12] == 3'b101));
  assign _zz_decode_ctrl_alu_1 = {decode_inInst_payload_instruction[30],decode_inInst_payload_instruction[14 : 12]};
  assign when_Misc_l235 = ((decode_inInst_payload_instruction & 32'h0000007c) == 32'h0000006c);
  assign when_Misc_l245 = ((decode_inInst_payload_instruction & 32'h0000007c) == 32'h00000064);
  assign when_Misc_l256 = ((decode_inInst_payload_instruction & 32'h0000007c) == 32'h00000060);
  assign _zz_decode_ctrl_br = {1'b0,decode_inInst_payload_instruction[14 : 12]};
  assign when_Misc_l265 = ((decode_inInst_payload_instruction & 32'h0000007c) == 32'h00000070);
  assign when_Misc_l267 = ((decode_inInst_payload_instruction & 32'h00004000) == 32'h00004000);
  assign _zz_decode_ctrl_csr = decode_inInst_payload_instruction[13 : 12];
  assign when_MulExtension_l89 = ((decode_inInst_payload_instruction & 32'hfe00407f) == 32'h02000033);
  assign when_DivExtension_l52 = ((decode_inInst_payload_instruction & 32'hfe00407f) == 32'h02004033);
  assign when_SimpleInterruptExtension_l85 = ((decode_inInst_payload_instruction & 32'hf800007f) == 32'h0000000b);
  assign when_SimpleInterruptExtension_l90 = decode_inInst_payload_instruction[25];
  assign when_DebugExtension_l192 = (decode_inInst_payload_instruction == 32'h00100073);
  always @(*) begin
    decode_throwIt = 1'b0;
    if(decode_flush) begin
      decode_throwIt = 1'b1;
    end
    if(execute0_flush) begin
      decode_throwIt = 1'b1;
    end
    if(execute1_flush) begin
      decode_throwIt = 1'b1;
    end
    if(writeBack_flush) begin
      decode_throwIt = 1'b1;
    end
  end

  always @(*) begin
    decode_halt = 1'b0;
    if(decode_hazard) begin
      decode_halt = 1'b1;
    end
    if(when_SimpleInterruptExtension_l38) begin
      if(!when_SimpleInterruptExtension_l39) begin
        if(_zz_7) begin
          decode_halt = 1'b1;
        end
      end
    end
  end

  assign decode_addr0 = decode_inInst_payload_instruction[19 : 15];
  assign decode_addr1 = decode_inInst_payload_instruction[24 : 20];
  assign decode_addr0IsZero = (decode_addr0 == 5'h0);
  assign decode_addr1IsZero = (decode_addr1 == 5'h0);
  assign decode_inInst_isStall = (decode_inInst_valid && (! decode_inInst_ready));
  assign decode_srcInstruction = (decode_inInst_isStall ? decode_inInst_payload_instruction : fetch_outInst_payload_instruction);
  always @(*) begin
    decode_regFileReadAddress0 = decode_srcInstruction[19 : 15];
    if(_zz_9) begin
      if(!when_DebugExtension_l101) begin
        if(!_zz_10) begin
          decode_regFileReadAddress0 = _zz_decode_regFileReadAddress0[4 : 0];
        end
      end
    end
  end

  assign decode_regFileReadAddress1 = decode_srcInstruction[24 : 20];
  always @(*) begin
    decode_src0 = regFile_spinal_port0;
    if(writeBackBuffer_inInst_valid) begin
      if(hazardTracker_W2R_addr0Match) begin
        decode_src0 = writeBackBuffer_inInst_payload_data;
      end
    end
    if(when_RiscvCore_l980) begin
      if(hazardTracker_A_addr0Match) begin
        decode_src0 = writeBack_regFileData;
      end
    end
    if(when_RiscvCore_l1004) begin
      if(execute1_outInst_payload_ctrl_execute1AluBypass) begin
        if(hazardTracker_E1_addr0Match) begin
          decode_src0 = execute1_outInst_payload_result;
        end
      end
    end
    if(when_RiscvCore_l1030) begin
      if(execute0_outInst_payload_ctrl_execute0AluBypass) begin
        if(hazardTracker_E0_addr0Match) begin
          decode_src0 = execute0_outInst_payload_result;
        end
      end
    end
  end

  always @(*) begin
    decode_src1 = regFile_spinal_port1;
    if(writeBackBuffer_inInst_valid) begin
      if(hazardTracker_W2R_addr1Match) begin
        decode_src1 = writeBackBuffer_inInst_payload_data;
      end
    end
    if(when_RiscvCore_l980) begin
      if(hazardTracker_A_addr1Match) begin
        decode_src1 = writeBack_regFileData;
      end
    end
    if(when_RiscvCore_l1004) begin
      if(execute1_outInst_payload_ctrl_execute1AluBypass) begin
        if(hazardTracker_E1_addr1Match) begin
          decode_src1 = execute1_outInst_payload_result;
        end
      end
    end
    if(when_RiscvCore_l1030) begin
      if(execute0_outInst_payload_ctrl_execute0AluBypass) begin
        if(hazardTracker_E0_addr1Match) begin
          decode_src1 = execute0_outInst_payload_result;
        end
      end
    end
  end

  assign _zz_decode_brjmpImm = _zz__zz_decode_brjmpImm[19];
  always @(*) begin
    _zz_decode_brjmpImm_1[10] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[9] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[8] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[7] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[6] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[5] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[4] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[3] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[2] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[1] = _zz_decode_brjmpImm;
    _zz_decode_brjmpImm_1[0] = _zz_decode_brjmpImm;
  end

  assign _zz_decode_brjmpImm_2 = _zz__zz_decode_brjmpImm_2[11];
  always @(*) begin
    _zz_decode_brjmpImm_3[18] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[17] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[16] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[15] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[14] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[13] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[12] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[11] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[10] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[9] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[8] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[7] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[6] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[5] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[4] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[3] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[2] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[1] = _zz_decode_brjmpImm_2;
    _zz_decode_brjmpImm_3[0] = _zz_decode_brjmpImm_2;
  end

  assign decode_brjmpImm = (decode_ctrl_jmp ? {{_zz_decode_brjmpImm_1,{{{_zz_decode_brjmpImm_4,decode_inInst_payload_instruction[19 : 12]},decode_inInst_payload_instruction[20]},decode_inInst_payload_instruction[30 : 21]}},1'b0} : {{_zz_decode_brjmpImm_3,{{{_zz_decode_brjmpImm_5,_zz_decode_brjmpImm_6},decode_inInst_payload_instruction[30 : 25]},decode_inInst_payload_instruction[11 : 8]}},1'b0});
  assign decode_brJumpPc = (decode_inInst_payload_pc + decode_brjmpImm);
  assign decode_branchCacheHit = (decode_inInst_payload_branchCacheLine_pc == decode_inInst_payload_pc[31 : 9]);
  assign decode_staticBranchPrediction = (decode_brjmpImm[31] || (decode_ctrl_br == BR_J));
  always @(*) begin
    decode_shouldTakeBranch = decode_staticBranchPrediction;
    if(decode_branchCacheHit) begin
      decode_shouldTakeBranch = decode_inInst_payload_branchCacheLine_history[1];
    end
  end

  assign decode_pcLoad_valid = ((((((decode_inInst_valid && (! decode_throwIt)) && (! decode_hazard)) && decode_outInst_ready) && ((decode_ctrl_br != BR_JR) && (decode_ctrl_br != BR_N))) && decode_ctrl_instVal) && decode_shouldTakeBranch);
  assign decode_pcLoad_payload = decode_brJumpPc;
  always @(*) begin
    decode_inInst_throwWhen_valid = decode_inInst_valid;
    if(decode_throwIt) begin
      decode_inInst_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    decode_inInst_ready = decode_inInst_throwWhen_ready;
    if(decode_throwIt) begin
      decode_inInst_ready = 1'b1;
    end
  end

  assign decode_inInst_throwWhen_payload_pc = decode_inInst_payload_pc;
  assign decode_inInst_throwWhen_payload_instruction = decode_inInst_payload_instruction;
  assign decode_inInst_throwWhen_payload_branchCacheLine_pc = decode_inInst_payload_branchCacheLine_pc;
  assign decode_inInst_throwWhen_payload_branchCacheLine_history = decode_inInst_payload_branchCacheLine_history;
  assign _zz_decode_inInst_throwWhen_ready = (! decode_halt);
  assign decode_inInst_throwWhen_haltWhen_valid = (decode_inInst_throwWhen_valid && _zz_decode_inInst_throwWhen_ready);
  assign decode_inInst_throwWhen_ready = (decode_inInst_throwWhen_haltWhen_ready && _zz_decode_inInst_throwWhen_ready);
  assign decode_inInst_throwWhen_haltWhen_payload_pc = decode_inInst_throwWhen_payload_pc;
  assign decode_inInst_throwWhen_haltWhen_payload_instruction = decode_inInst_throwWhen_payload_instruction;
  assign decode_inInst_throwWhen_haltWhen_payload_branchCacheLine_pc = decode_inInst_throwWhen_payload_branchCacheLine_pc;
  assign decode_inInst_throwWhen_haltWhen_payload_branchCacheLine_history = decode_inInst_throwWhen_payload_branchCacheLine_history;
  assign decode_outInst_valid = decode_inInst_throwWhen_haltWhen_valid;
  assign decode_inInst_throwWhen_haltWhen_ready = decode_outInst_ready;
  assign decode_outInst_payload_pc = decode_inInst_payload_pc;
  assign decode_outInst_payload_instruction = decode_inInst_payload_instruction;
  assign decode_outInst_payload_ctrl_instVal = decode_ctrl_instVal;
  assign decode_outInst_payload_ctrl_br = decode_ctrl_br;
  assign decode_outInst_payload_ctrl_jmp = decode_ctrl_jmp;
  assign decode_outInst_payload_ctrl_op0 = decode_ctrl_op0;
  assign decode_outInst_payload_ctrl_op1 = decode_ctrl_op1;
  assign decode_outInst_payload_ctrl_alu = decode_ctrl_alu;
  assign decode_outInst_payload_ctrl_wb = decode_ctrl_wb;
  assign decode_outInst_payload_ctrl_rfen = decode_ctrl_rfen;
  assign decode_outInst_payload_ctrl_execute0AluBypass = decode_ctrl_execute0AluBypass;
  assign decode_outInst_payload_ctrl_execute1AluBypass = decode_ctrl_execute1AluBypass;
  assign decode_outInst_payload_ctrl_canInternalyStallWriteBack0 = decode_ctrl_canInternalyStallWriteBack0;
  assign decode_outInst_payload_ctrl_men = decode_ctrl_men;
  assign decode_outInst_payload_ctrl_m = decode_ctrl_m;
  assign decode_outInst_payload_ctrl_msk = decode_ctrl_msk;
  assign decode_outInst_payload_ctrl_csr = decode_ctrl_csr;
  assign decode_outInst_payload_ctrl_mfs = decode_ctrl_mfs;
  assign decode_outInst_payload_ctrl_useSrc0 = decode_ctrl_useSrc0;
  assign decode_outInst_payload_ctrl_useSrc1 = decode_ctrl_useSrc1;
  assign decode_outInst_payload_ctrl_extensionTag = decode_ctrl_extensionTag;
  assign decode_outInst_payload_ctrl_fencei = decode_ctrl_fencei;
  assign decode_outInst_payload_doSub = (decode_outInst_payload_ctrl_alu != ALU_ADD);
  assign decode_outInst_payload_src0 = ((! decode_addr0IsZero) ? decode_src0 : 32'h0);
  assign decode_outInst_payload_src1 = ((! decode_addr1IsZero) ? decode_src1 : 32'h0);
  always @(*) begin
    case(decode_outInst_payload_ctrl_op0)
      OP0_IMU : begin
        _zz_decode_outInst_payload_alu_op0 = {decode_inInst_payload_instruction[31 : 12],12'h0};
      end
      OP0_IMZ : begin
        _zz_decode_outInst_payload_alu_op0 = {27'd0, _zz__zz_decode_outInst_payload_alu_op0};
      end
      OP0_IMJB : begin
        _zz_decode_outInst_payload_alu_op0 = decode_brjmpImm;
      end
      default : begin
        _zz_decode_outInst_payload_alu_op0 = decode_outInst_payload_src0;
      end
    endcase
  end

  assign decode_outInst_payload_alu_op0 = _zz_decode_outInst_payload_alu_op0;
  assign _zz_decode_outInst_payload_alu_op1 = decode_inInst_payload_instruction[31];
  always @(*) begin
    _zz_decode_outInst_payload_alu_op1_1[19] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[18] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[17] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[16] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[15] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[14] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[13] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[12] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[11] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[10] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[9] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[8] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[7] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[6] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[5] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[4] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[3] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[2] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[1] = _zz_decode_outInst_payload_alu_op1;
    _zz_decode_outInst_payload_alu_op1_1[0] = _zz_decode_outInst_payload_alu_op1;
  end

  assign _zz_decode_outInst_payload_alu_op1_2 = _zz__zz_decode_outInst_payload_alu_op1_2[11];
  always @(*) begin
    _zz_decode_outInst_payload_alu_op1_3[19] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[18] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[17] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[16] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[15] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[14] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[13] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[12] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[11] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[10] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[9] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[8] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[7] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[6] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[5] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[4] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[3] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[2] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[1] = _zz_decode_outInst_payload_alu_op1_2;
    _zz_decode_outInst_payload_alu_op1_3[0] = _zz_decode_outInst_payload_alu_op1_2;
  end

  always @(*) begin
    case(decode_outInst_payload_ctrl_op1)
      OP1_IMI : begin
        _zz_decode_outInst_payload_alu_op1_4 = {_zz_decode_outInst_payload_alu_op1_1,decode_inInst_payload_instruction[31 : 20]};
      end
      OP1_IMS : begin
        _zz_decode_outInst_payload_alu_op1_4 = {_zz_decode_outInst_payload_alu_op1_3,{decode_inInst_payload_instruction[31 : 25],decode_inInst_payload_instruction[11 : 7]}};
      end
      OP1_PC : begin
        _zz_decode_outInst_payload_alu_op1_4 = decode_inInst_payload_pc;
      end
      default : begin
        _zz_decode_outInst_payload_alu_op1_4 = decode_outInst_payload_src1;
      end
    endcase
  end

  assign decode_outInst_payload_alu_op1 = _zz_decode_outInst_payload_alu_op1_4;
  assign decode_outInst_payload_predictorHasBranch = decode_pcLoad_valid;
  assign decode_outInst_payload_branchHistory_valid = decode_branchCacheHit;
  assign decode_outInst_payload_branchHistory_payload = decode_inInst_payload_branchCacheLine_history;
  assign decode_flush = 1'b0;
  assign decode_outInst_ready = execute0_inInst_ready;
  assign execute0_inInst_valid = decode_outInst_rValid;
  assign execute0_inInst_payload_pc = decode_outInst_rData_pc;
  assign execute0_inInst_payload_instruction = decode_outInst_rData_instruction;
  assign execute0_inInst_payload_ctrl_instVal = decode_outInst_rData_ctrl_instVal;
  assign execute0_inInst_payload_ctrl_br = decode_outInst_rData_ctrl_br;
  assign execute0_inInst_payload_ctrl_jmp = decode_outInst_rData_ctrl_jmp;
  assign execute0_inInst_payload_ctrl_op0 = decode_outInst_rData_ctrl_op0;
  assign execute0_inInst_payload_ctrl_op1 = decode_outInst_rData_ctrl_op1;
  assign execute0_inInst_payload_ctrl_alu = decode_outInst_rData_ctrl_alu;
  assign execute0_inInst_payload_ctrl_wb = decode_outInst_rData_ctrl_wb;
  assign execute0_inInst_payload_ctrl_rfen = decode_outInst_rData_ctrl_rfen;
  assign execute0_inInst_payload_ctrl_execute0AluBypass = decode_outInst_rData_ctrl_execute0AluBypass;
  assign execute0_inInst_payload_ctrl_execute1AluBypass = decode_outInst_rData_ctrl_execute1AluBypass;
  assign execute0_inInst_payload_ctrl_canInternalyStallWriteBack0 = decode_outInst_rData_ctrl_canInternalyStallWriteBack0;
  assign execute0_inInst_payload_ctrl_men = decode_outInst_rData_ctrl_men;
  assign execute0_inInst_payload_ctrl_m = decode_outInst_rData_ctrl_m;
  assign execute0_inInst_payload_ctrl_msk = decode_outInst_rData_ctrl_msk;
  assign execute0_inInst_payload_ctrl_csr = decode_outInst_rData_ctrl_csr;
  assign execute0_inInst_payload_ctrl_mfs = decode_outInst_rData_ctrl_mfs;
  assign execute0_inInst_payload_ctrl_useSrc0 = decode_outInst_rData_ctrl_useSrc0;
  assign execute0_inInst_payload_ctrl_useSrc1 = decode_outInst_rData_ctrl_useSrc1;
  assign execute0_inInst_payload_ctrl_extensionTag = decode_outInst_rData_ctrl_extensionTag;
  assign execute0_inInst_payload_ctrl_fencei = decode_outInst_rData_ctrl_fencei;
  assign execute0_inInst_payload_src0 = decode_outInst_rData_src0;
  assign execute0_inInst_payload_src1 = decode_outInst_rData_src1;
  assign execute0_inInst_payload_alu_op0 = decode_outInst_rData_alu_op0;
  assign execute0_inInst_payload_alu_op1 = decode_outInst_rData_alu_op1;
  assign execute0_inInst_payload_doSub = decode_outInst_rData_doSub;
  assign execute0_inInst_payload_predictorHasBranch = decode_outInst_rData_predictorHasBranch;
  assign execute0_inInst_payload_branchHistory_valid = decode_outInst_rData_branchHistory_valid;
  assign execute0_inInst_payload_branchHistory_payload = decode_outInst_rData_branchHistory_payload;
  always @(*) begin
    execute0_throwIt = 1'b0;
    if(execute0_flush) begin
      execute0_throwIt = 1'b1;
    end
    if(execute1_flush) begin
      execute0_throwIt = 1'b1;
    end
    if(writeBack_flush) begin
      execute0_throwIt = 1'b1;
    end
  end

  always @(*) begin
    execute0_halt = 1'b0;
    if(when_RiscvCore_l745) begin
      execute0_halt = 1'b1;
    end
    if(when_RiscvCore_l1063) begin
      if(when_RiscvCore_l1064) begin
        execute0_halt = 1'b1;
      end
      if(when_RiscvCore_l1067) begin
        execute0_halt = 1'b1;
      end
    end
    if(when_DivExtension_l26) begin
      if(when_DivExtension_l28) begin
        execute0_halt = 1'b1;
      end
    end
    if(when_DebugExtension_l157) begin
      execute0_halt = 1'b1;
    end
    if(DebugExtension_isInBreakpoint) begin
      execute0_halt = 1'b1;
    end
  end

  assign execute0_haltFromDataRequest = ((execute0_inInst_valid && execute0_inInst_payload_ctrl_men) && (! dCmd_ready));
  assign execute0_br_signed = (! _zz_execute0_br_signed[1]);
  assign execute0_br_src0Ext = {(execute0_inInst_payload_src0[31] && execute0_br_signed),execute0_inInst_payload_src0};
  assign execute0_br_src1Ext = {(execute0_inInst_payload_src1[31] && execute0_br_signed),execute0_inInst_payload_src1};
  assign execute0_br_ltx = _zz_execute0_br_ltx[32];
  assign execute0_br_eq = (execute0_inInst_payload_src0 == execute0_inInst_payload_src1);
  assign _zz_execute0_br_pc_sel = ((! execute0_br_eq) ? PC_BRA : PC_INC);
  assign _zz_execute0_br_pc_sel_1 = (execute0_br_eq ? PC_BRA : PC_INC);
  assign _zz_execute0_br_pc_sel_2 = ((! execute0_br_ltx) ? PC_BRA : PC_INC);
  assign _zz_execute0_br_pc_sel_3 = (execute0_br_ltx ? PC_BRA : PC_INC);
  always @(*) begin
    case(execute0_inInst_payload_ctrl_br)
      BR_NE : begin
        execute0_br_pc_sel = _zz_execute0_br_pc_sel;
      end
      BR_EQ : begin
        execute0_br_pc_sel = _zz_execute0_br_pc_sel_1;
      end
      BR_GE, BR_GEU : begin
        execute0_br_pc_sel = _zz_execute0_br_pc_sel_2;
      end
      BR_LT, BR_LTU : begin
        execute0_br_pc_sel = _zz_execute0_br_pc_sel_3;
      end
      BR_J : begin
        execute0_br_pc_sel = PC_J;
      end
      BR_JR : begin
        execute0_br_pc_sel = PC_JR;
      end
      default : begin
        execute0_br_pc_sel = PC_INC;
      end
    endcase
  end

  always @(*) begin
    execute0_inInst_throwWhen_valid = execute0_inInst_valid;
    if(execute0_throwIt) begin
      execute0_inInst_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    execute0_inInst_ready = execute0_inInst_throwWhen_ready;
    if(execute0_throwIt) begin
      execute0_inInst_ready = 1'b1;
    end
  end

  assign execute0_inInst_throwWhen_payload_pc = execute0_inInst_payload_pc;
  assign execute0_inInst_throwWhen_payload_instruction = execute0_inInst_payload_instruction;
  assign execute0_inInst_throwWhen_payload_ctrl_instVal = execute0_inInst_payload_ctrl_instVal;
  assign execute0_inInst_throwWhen_payload_ctrl_br = execute0_inInst_payload_ctrl_br;
  assign execute0_inInst_throwWhen_payload_ctrl_jmp = execute0_inInst_payload_ctrl_jmp;
  assign execute0_inInst_throwWhen_payload_ctrl_op0 = execute0_inInst_payload_ctrl_op0;
  assign execute0_inInst_throwWhen_payload_ctrl_op1 = execute0_inInst_payload_ctrl_op1;
  assign execute0_inInst_throwWhen_payload_ctrl_alu = execute0_inInst_payload_ctrl_alu;
  assign execute0_inInst_throwWhen_payload_ctrl_wb = execute0_inInst_payload_ctrl_wb;
  assign execute0_inInst_throwWhen_payload_ctrl_rfen = execute0_inInst_payload_ctrl_rfen;
  assign execute0_inInst_throwWhen_payload_ctrl_execute0AluBypass = execute0_inInst_payload_ctrl_execute0AluBypass;
  assign execute0_inInst_throwWhen_payload_ctrl_execute1AluBypass = execute0_inInst_payload_ctrl_execute1AluBypass;
  assign execute0_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0 = execute0_inInst_payload_ctrl_canInternalyStallWriteBack0;
  assign execute0_inInst_throwWhen_payload_ctrl_men = execute0_inInst_payload_ctrl_men;
  assign execute0_inInst_throwWhen_payload_ctrl_m = execute0_inInst_payload_ctrl_m;
  assign execute0_inInst_throwWhen_payload_ctrl_msk = execute0_inInst_payload_ctrl_msk;
  assign execute0_inInst_throwWhen_payload_ctrl_csr = execute0_inInst_payload_ctrl_csr;
  assign execute0_inInst_throwWhen_payload_ctrl_mfs = execute0_inInst_payload_ctrl_mfs;
  assign execute0_inInst_throwWhen_payload_ctrl_useSrc0 = execute0_inInst_payload_ctrl_useSrc0;
  assign execute0_inInst_throwWhen_payload_ctrl_useSrc1 = execute0_inInst_payload_ctrl_useSrc1;
  assign execute0_inInst_throwWhen_payload_ctrl_extensionTag = execute0_inInst_payload_ctrl_extensionTag;
  assign execute0_inInst_throwWhen_payload_ctrl_fencei = execute0_inInst_payload_ctrl_fencei;
  assign execute0_inInst_throwWhen_payload_src0 = execute0_inInst_payload_src0;
  assign execute0_inInst_throwWhen_payload_src1 = execute0_inInst_payload_src1;
  assign execute0_inInst_throwWhen_payload_alu_op0 = execute0_inInst_payload_alu_op0;
  assign execute0_inInst_throwWhen_payload_alu_op1 = execute0_inInst_payload_alu_op1;
  assign execute0_inInst_throwWhen_payload_doSub = execute0_inInst_payload_doSub;
  assign execute0_inInst_throwWhen_payload_predictorHasBranch = execute0_inInst_payload_predictorHasBranch;
  assign execute0_inInst_throwWhen_payload_branchHistory_valid = execute0_inInst_payload_branchHistory_valid;
  assign execute0_inInst_throwWhen_payload_branchHistory_payload = execute0_inInst_payload_branchHistory_payload;
  assign _zz_execute0_inInst_throwWhen_ready = (! (execute0_halt || execute0_haltFromDataRequest));
  assign execute0_inInst_throwWhen_haltWhen_valid = (execute0_inInst_throwWhen_valid && _zz_execute0_inInst_throwWhen_ready);
  assign execute0_inInst_throwWhen_ready = (execute0_inInst_throwWhen_haltWhen_ready && _zz_execute0_inInst_throwWhen_ready);
  assign execute0_inInst_throwWhen_haltWhen_payload_pc = execute0_inInst_throwWhen_payload_pc;
  assign execute0_inInst_throwWhen_haltWhen_payload_instruction = execute0_inInst_throwWhen_payload_instruction;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_instVal = execute0_inInst_throwWhen_payload_ctrl_instVal;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_br = execute0_inInst_throwWhen_payload_ctrl_br;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_jmp = execute0_inInst_throwWhen_payload_ctrl_jmp;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_op0 = execute0_inInst_throwWhen_payload_ctrl_op0;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_op1 = execute0_inInst_throwWhen_payload_ctrl_op1;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_alu = execute0_inInst_throwWhen_payload_ctrl_alu;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_wb = execute0_inInst_throwWhen_payload_ctrl_wb;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_rfen = execute0_inInst_throwWhen_payload_ctrl_rfen;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_execute0AluBypass = execute0_inInst_throwWhen_payload_ctrl_execute0AluBypass;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_execute1AluBypass = execute0_inInst_throwWhen_payload_ctrl_execute1AluBypass;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_canInternalyStallWriteBack0 = execute0_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_men = execute0_inInst_throwWhen_payload_ctrl_men;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_m = execute0_inInst_throwWhen_payload_ctrl_m;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_msk = execute0_inInst_throwWhen_payload_ctrl_msk;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_csr = execute0_inInst_throwWhen_payload_ctrl_csr;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_mfs = execute0_inInst_throwWhen_payload_ctrl_mfs;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_useSrc0 = execute0_inInst_throwWhen_payload_ctrl_useSrc0;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_useSrc1 = execute0_inInst_throwWhen_payload_ctrl_useSrc1;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_extensionTag = execute0_inInst_throwWhen_payload_ctrl_extensionTag;
  assign execute0_inInst_throwWhen_haltWhen_payload_ctrl_fencei = execute0_inInst_throwWhen_payload_ctrl_fencei;
  assign execute0_inInst_throwWhen_haltWhen_payload_src0 = execute0_inInst_throwWhen_payload_src0;
  assign execute0_inInst_throwWhen_haltWhen_payload_src1 = execute0_inInst_throwWhen_payload_src1;
  assign execute0_inInst_throwWhen_haltWhen_payload_alu_op0 = execute0_inInst_throwWhen_payload_alu_op0;
  assign execute0_inInst_throwWhen_haltWhen_payload_alu_op1 = execute0_inInst_throwWhen_payload_alu_op1;
  assign execute0_inInst_throwWhen_haltWhen_payload_doSub = execute0_inInst_throwWhen_payload_doSub;
  assign execute0_inInst_throwWhen_haltWhen_payload_predictorHasBranch = execute0_inInst_throwWhen_payload_predictorHasBranch;
  assign execute0_inInst_throwWhen_haltWhen_payload_branchHistory_valid = execute0_inInst_throwWhen_payload_branchHistory_valid;
  assign execute0_inInst_throwWhen_haltWhen_payload_branchHistory_payload = execute0_inInst_throwWhen_payload_branchHistory_payload;
  assign execute0_outInst_valid = execute0_inInst_throwWhen_haltWhen_valid;
  assign execute0_inInst_throwWhen_haltWhen_ready = execute0_outInst_ready;
  assign execute0_outInst_payload_pc = execute0_inInst_payload_pc;
  assign execute0_outInst_payload_instruction = execute0_inInst_payload_instruction;
  assign execute0_outInst_payload_predictorHasBranch = execute0_inInst_payload_predictorHasBranch;
  assign execute0_outInst_payload_branchHistory_valid = execute0_inInst_payload_branchHistory_valid;
  assign execute0_outInst_payload_branchHistory_payload = execute0_inInst_payload_branchHistory_payload;
  assign execute0_outInst_payload_ctrl_instVal = execute0_inInst_payload_ctrl_instVal;
  assign execute0_outInst_payload_ctrl_br = execute0_inInst_payload_ctrl_br;
  assign execute0_outInst_payload_ctrl_jmp = execute0_inInst_payload_ctrl_jmp;
  assign execute0_outInst_payload_ctrl_op0 = execute0_inInst_payload_ctrl_op0;
  assign execute0_outInst_payload_ctrl_op1 = execute0_inInst_payload_ctrl_op1;
  assign execute0_outInst_payload_ctrl_alu = execute0_inInst_payload_ctrl_alu;
  assign execute0_outInst_payload_ctrl_wb = execute0_inInst_payload_ctrl_wb;
  assign execute0_outInst_payload_ctrl_rfen = execute0_inInst_payload_ctrl_rfen;
  assign execute0_outInst_payload_ctrl_execute0AluBypass = execute0_inInst_payload_ctrl_execute0AluBypass;
  assign execute0_outInst_payload_ctrl_execute1AluBypass = execute0_inInst_payload_ctrl_execute1AluBypass;
  assign execute0_outInst_payload_ctrl_canInternalyStallWriteBack0 = execute0_inInst_payload_ctrl_canInternalyStallWriteBack0;
  assign execute0_outInst_payload_ctrl_men = execute0_inInst_payload_ctrl_men;
  assign execute0_outInst_payload_ctrl_m = execute0_inInst_payload_ctrl_m;
  assign execute0_outInst_payload_ctrl_msk = execute0_inInst_payload_ctrl_msk;
  assign execute0_outInst_payload_ctrl_csr = execute0_inInst_payload_ctrl_csr;
  assign execute0_outInst_payload_ctrl_mfs = execute0_inInst_payload_ctrl_mfs;
  assign execute0_outInst_payload_ctrl_useSrc0 = execute0_inInst_payload_ctrl_useSrc0;
  assign execute0_outInst_payload_ctrl_useSrc1 = execute0_inInst_payload_ctrl_useSrc1;
  assign execute0_outInst_payload_ctrl_extensionTag = execute0_inInst_payload_ctrl_extensionTag;
  assign execute0_outInst_payload_ctrl_fencei = execute0_inInst_payload_ctrl_fencei;
  assign execute0_outInst_payload_br_eq = execute0_br_eq;
  assign execute0_outInst_payload_br_ltx = execute0_br_ltx;
  assign execute0_outInst_payload_pc_sel = execute0_br_pc_sel;
  assign execute0_outInst_payload_src1 = execute0_inInst_payload_src1;
  assign execute0_outInst_payload_result = execute0_alu_io_result;
  assign execute0_outInst_payload_adder = execute0_alu_io_adder;
  assign execute0_outInst_payload_pcPlus4 = (execute0_inInst_payload_pc + 32'h00000004);
  assign execute0_outInst_payload_needMemRsp = (execute0_inInst_payload_ctrl_men && (execute0_inInst_payload_ctrl_m == M_XRD));
  assign execute0_outInst_payload_dCmdAddress = dCmd_payload_address;
  always @(*) begin
    case(execute0_outInst_payload_ctrl_msk)
      MSK_H : begin
        _zz_execute0_outInst_payload_unalignedMemoryAccessException = dCmd_payload_address[0];
      end
      MSK_W : begin
        _zz_execute0_outInst_payload_unalignedMemoryAccessException = (dCmd_payload_address[0] || dCmd_payload_address[1]);
      end
      default : begin
        _zz_execute0_outInst_payload_unalignedMemoryAccessException = 1'b0;
      end
    endcase
  end

  assign execute0_outInst_payload_unalignedMemoryAccessException = (execute0_inInst_payload_ctrl_men && _zz_execute0_outInst_payload_unalignedMemoryAccessException);
  assign dCmd_valid = (((((execute0_inInst_valid && execute0_inInst_payload_ctrl_men) && (! execute0_outInst_payload_unalignedMemoryAccessException)) && (! execute0_halt)) && (! execute0_throwIt)) && execute0_outInst_ready);
  assign dCmd_payload_wr = (execute0_inInst_payload_ctrl_m == M_XWR);
  assign dCmd_payload_address = execute0_outInst_payload_adder;
  assign dCmd_payload_data = execute0_inInst_payload_src1;
  always @(*) begin
    case(execute0_inInst_payload_ctrl_msk)
      MSK_B : begin
        _zz_dCmd_payload_size = 2'b00;
      end
      MSK_H : begin
        _zz_dCmd_payload_size = 2'b01;
      end
      default : begin
        _zz_dCmd_payload_size = 2'b10;
      end
    endcase
  end

  assign dCmd_payload_size = _zz_dCmd_payload_size;
  assign dCmd_fire = (dCmd_valid && dCmd_ready);
  assign execute0_pendingDataCmd_readCountInc = (dCmd_fire && (! dCmd_payload_wr));
  assign execute0_pendingDataCmd_readCountDec = (dRsp_valid && dRsp_ready);
  assign when_RiscvCore_l742 = (execute0_pendingDataCmd_readCountInc != execute0_pendingDataCmd_readCountDec);
  assign when_RiscvCore_l745 = (((execute0_inInst_valid && execute0_inInst_payload_ctrl_men) && (execute0_inInst_payload_ctrl_m == M_XRD)) && (execute0_pendingDataCmd_readCount == 2'b10));
  always @(*) begin
    execute0_flush = 1'b0;
    if(execute1_pcLoad_valid) begin
      execute0_flush = 1'b1;
    end
  end

  assign execute0_outInst_ready = execute1_inInst_ready;
  assign execute1_inInst_valid = execute0_outInst_rValid;
  assign execute1_inInst_payload_pc = execute0_outInst_rData_pc;
  assign execute1_inInst_payload_instruction = execute0_outInst_rData_instruction;
  assign execute1_inInst_payload_ctrl_instVal = execute0_outInst_rData_ctrl_instVal;
  assign execute1_inInst_payload_ctrl_br = execute0_outInst_rData_ctrl_br;
  assign execute1_inInst_payload_ctrl_jmp = execute0_outInst_rData_ctrl_jmp;
  assign execute1_inInst_payload_ctrl_op0 = execute0_outInst_rData_ctrl_op0;
  assign execute1_inInst_payload_ctrl_op1 = execute0_outInst_rData_ctrl_op1;
  assign execute1_inInst_payload_ctrl_alu = execute0_outInst_rData_ctrl_alu;
  assign execute1_inInst_payload_ctrl_wb = execute0_outInst_rData_ctrl_wb;
  assign execute1_inInst_payload_ctrl_rfen = execute0_outInst_rData_ctrl_rfen;
  assign execute1_inInst_payload_ctrl_execute0AluBypass = execute0_outInst_rData_ctrl_execute0AluBypass;
  assign execute1_inInst_payload_ctrl_execute1AluBypass = execute0_outInst_rData_ctrl_execute1AluBypass;
  assign execute1_inInst_payload_ctrl_canInternalyStallWriteBack0 = execute0_outInst_rData_ctrl_canInternalyStallWriteBack0;
  assign execute1_inInst_payload_ctrl_men = execute0_outInst_rData_ctrl_men;
  assign execute1_inInst_payload_ctrl_m = execute0_outInst_rData_ctrl_m;
  assign execute1_inInst_payload_ctrl_msk = execute0_outInst_rData_ctrl_msk;
  assign execute1_inInst_payload_ctrl_csr = execute0_outInst_rData_ctrl_csr;
  assign execute1_inInst_payload_ctrl_mfs = execute0_outInst_rData_ctrl_mfs;
  assign execute1_inInst_payload_ctrl_useSrc0 = execute0_outInst_rData_ctrl_useSrc0;
  assign execute1_inInst_payload_ctrl_useSrc1 = execute0_outInst_rData_ctrl_useSrc1;
  assign execute1_inInst_payload_ctrl_extensionTag = execute0_outInst_rData_ctrl_extensionTag;
  assign execute1_inInst_payload_ctrl_fencei = execute0_outInst_rData_ctrl_fencei;
  assign execute1_inInst_payload_br_eq = execute0_outInst_rData_br_eq;
  assign execute1_inInst_payload_br_ltx = execute0_outInst_rData_br_ltx;
  assign execute1_inInst_payload_src1 = execute0_outInst_rData_src1;
  assign execute1_inInst_payload_result = execute0_outInst_rData_result;
  always @(*) begin
    execute1_inInst_payload_adder = execute0_outInst_rData_adder;
    if(execute1_inInst_valid) begin
      if(when_SimpleInterruptExtension_l57) begin
        case(switch_SimpleInterruptExtension_l58)
          2'b00 : begin
            execute1_inInst_payload_adder = SimpleInterrupExtension_exitPc;
          end
          2'b01 : begin
          end
          2'b10 : begin
          end
          default : begin
          end
        endcase
      end
    end
  end

  assign execute1_inInst_payload_predictorHasBranch = execute0_outInst_rData_predictorHasBranch;
  assign execute1_inInst_payload_branchHistory_valid = execute0_outInst_rData_branchHistory_valid;
  assign execute1_inInst_payload_branchHistory_payload = execute0_outInst_rData_branchHistory_payload;
  assign execute1_inInst_payload_pcPlus4 = execute0_outInst_rData_pcPlus4;
  always @(*) begin
    execute1_inInst_payload_pc_sel = execute0_outInst_rData_pc_sel;
    if(execute1_inInst_valid) begin
      if(when_SimpleInterruptExtension_l57) begin
        case(switch_SimpleInterruptExtension_l58)
          2'b00 : begin
            execute1_inInst_payload_pc_sel = PC_J;
          end
          2'b01 : begin
          end
          2'b10 : begin
          end
          default : begin
          end
        endcase
      end
    end
  end

  assign execute1_inInst_payload_unalignedMemoryAccessException = execute0_outInst_rData_unalignedMemoryAccessException;
  assign execute1_inInst_payload_needMemRsp = execute0_outInst_rData_needMemRsp;
  assign execute1_inInst_payload_dCmdAddress = execute0_outInst_rData_dCmdAddress;
  always @(*) begin
    execute1_halt = 1'b0;
    if(when_DivExtension_l33) begin
      if(when_DivExtension_l36) begin
        execute1_halt = 1'b1;
      end
    end
  end

  always @(*) begin
    execute1_throwIt = 1'b0;
    if(execute1_flush) begin
      execute1_throwIt = 1'b1;
    end
    if(writeBack_flush) begin
      execute1_throwIt = 1'b1;
    end
  end

  assign execute1_inInst_fire = (execute1_inInst_valid && execute1_inInst_ready);
  always @(*) begin
    case(execute1_inInst_payload_pc_sel)
      PC_INC : begin
        _zz_execute1_pcLoad_valid = execute1_inInst_payload_predictorHasBranch;
      end
      default : begin
        _zz_execute1_pcLoad_valid = (! execute1_inInst_payload_predictorHasBranch);
      end
    endcase
  end

  assign execute1_pcLoad_valid = (((! execute1_throwIt) && execute1_inInst_fire) && _zz_execute1_pcLoad_valid);
  always @(*) begin
    case(execute1_inInst_payload_pc_sel)
      PC_INC : begin
        _zz_execute1_pcLoad_payload = execute1_inInst_payload_pcPlus4;
      end
      default : begin
        _zz_execute1_pcLoad_payload = execute1_inInst_payload_adder;
      end
    endcase
  end

  assign execute1_pcLoad_payload = _zz_execute1_pcLoad_payload;
  assign execute1_newHistory = ($signed(_zz_execute1_newHistory) + $signed(_zz_execute1_newHistory_1));
  assign execute1_line_pc = execute1_inInst_payload_pc[31 : 9];
  always @(*) begin
    if(execute1_inInst_payload_branchHistory_valid) begin
      execute1_line_history = execute1_newHistory[1:0];
    end else begin
      execute1_line_history = {{1{_zz_execute1_line_history[0]}}, _zz_execute1_line_history};
    end
  end

  assign when_RiscvCore_l792 = (((execute1_inInst_fire && (execute1_inInst_payload_ctrl_br != BR_JR)) && (execute1_inInst_payload_ctrl_br != BR_N)) && (execute1_inInst_payload_ctrl_br != BR_J));
  assign when_RiscvCore_l793 = (($signed(_zz_when_RiscvCore_l793) != $signed(2'b10)) && ($signed(_zz_when_RiscvCore_l793_1) != $signed(2'b01)));
  always @(*) begin
    execute1_inInst_throwWhen_valid = execute1_inInst_valid;
    if(execute1_throwIt) begin
      execute1_inInst_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    execute1_inInst_ready = execute1_inInst_throwWhen_ready;
    if(execute1_throwIt) begin
      execute1_inInst_ready = 1'b1;
    end
  end

  assign execute1_inInst_throwWhen_payload_pc = execute1_inInst_payload_pc;
  assign execute1_inInst_throwWhen_payload_instruction = execute1_inInst_payload_instruction;
  assign execute1_inInst_throwWhen_payload_ctrl_instVal = execute1_inInst_payload_ctrl_instVal;
  assign execute1_inInst_throwWhen_payload_ctrl_br = execute1_inInst_payload_ctrl_br;
  assign execute1_inInst_throwWhen_payload_ctrl_jmp = execute1_inInst_payload_ctrl_jmp;
  assign execute1_inInst_throwWhen_payload_ctrl_op0 = execute1_inInst_payload_ctrl_op0;
  assign execute1_inInst_throwWhen_payload_ctrl_op1 = execute1_inInst_payload_ctrl_op1;
  assign execute1_inInst_throwWhen_payload_ctrl_alu = execute1_inInst_payload_ctrl_alu;
  assign execute1_inInst_throwWhen_payload_ctrl_wb = execute1_inInst_payload_ctrl_wb;
  assign execute1_inInst_throwWhen_payload_ctrl_rfen = execute1_inInst_payload_ctrl_rfen;
  assign execute1_inInst_throwWhen_payload_ctrl_execute0AluBypass = execute1_inInst_payload_ctrl_execute0AluBypass;
  assign execute1_inInst_throwWhen_payload_ctrl_execute1AluBypass = execute1_inInst_payload_ctrl_execute1AluBypass;
  assign execute1_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0 = execute1_inInst_payload_ctrl_canInternalyStallWriteBack0;
  assign execute1_inInst_throwWhen_payload_ctrl_men = execute1_inInst_payload_ctrl_men;
  assign execute1_inInst_throwWhen_payload_ctrl_m = execute1_inInst_payload_ctrl_m;
  assign execute1_inInst_throwWhen_payload_ctrl_msk = execute1_inInst_payload_ctrl_msk;
  assign execute1_inInst_throwWhen_payload_ctrl_csr = execute1_inInst_payload_ctrl_csr;
  assign execute1_inInst_throwWhen_payload_ctrl_mfs = execute1_inInst_payload_ctrl_mfs;
  assign execute1_inInst_throwWhen_payload_ctrl_useSrc0 = execute1_inInst_payload_ctrl_useSrc0;
  assign execute1_inInst_throwWhen_payload_ctrl_useSrc1 = execute1_inInst_payload_ctrl_useSrc1;
  assign execute1_inInst_throwWhen_payload_ctrl_extensionTag = execute1_inInst_payload_ctrl_extensionTag;
  assign execute1_inInst_throwWhen_payload_ctrl_fencei = execute1_inInst_payload_ctrl_fencei;
  assign execute1_inInst_throwWhen_payload_br_eq = execute1_inInst_payload_br_eq;
  assign execute1_inInst_throwWhen_payload_br_ltx = execute1_inInst_payload_br_ltx;
  assign execute1_inInst_throwWhen_payload_src1 = execute1_inInst_payload_src1;
  assign execute1_inInst_throwWhen_payload_result = execute1_inInst_payload_result;
  assign execute1_inInst_throwWhen_payload_adder = execute1_inInst_payload_adder;
  assign execute1_inInst_throwWhen_payload_predictorHasBranch = execute1_inInst_payload_predictorHasBranch;
  assign execute1_inInst_throwWhen_payload_branchHistory_valid = execute1_inInst_payload_branchHistory_valid;
  assign execute1_inInst_throwWhen_payload_branchHistory_payload = execute1_inInst_payload_branchHistory_payload;
  assign execute1_inInst_throwWhen_payload_pcPlus4 = execute1_inInst_payload_pcPlus4;
  assign execute1_inInst_throwWhen_payload_pc_sel = execute1_inInst_payload_pc_sel;
  assign execute1_inInst_throwWhen_payload_unalignedMemoryAccessException = execute1_inInst_payload_unalignedMemoryAccessException;
  assign execute1_inInst_throwWhen_payload_needMemRsp = execute1_inInst_payload_needMemRsp;
  assign execute1_inInst_throwWhen_payload_dCmdAddress = execute1_inInst_payload_dCmdAddress;
  assign _zz_execute1_inInst_throwWhen_ready = (! execute1_halt);
  assign execute1_inInst_throwWhen_haltWhen_valid = (execute1_inInst_throwWhen_valid && _zz_execute1_inInst_throwWhen_ready);
  assign execute1_inInst_throwWhen_ready = (execute1_inInst_throwWhen_haltWhen_ready && _zz_execute1_inInst_throwWhen_ready);
  assign execute1_inInst_throwWhen_haltWhen_payload_pc = execute1_inInst_throwWhen_payload_pc;
  assign execute1_inInst_throwWhen_haltWhen_payload_instruction = execute1_inInst_throwWhen_payload_instruction;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_instVal = execute1_inInst_throwWhen_payload_ctrl_instVal;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_br = execute1_inInst_throwWhen_payload_ctrl_br;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_jmp = execute1_inInst_throwWhen_payload_ctrl_jmp;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_op0 = execute1_inInst_throwWhen_payload_ctrl_op0;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_op1 = execute1_inInst_throwWhen_payload_ctrl_op1;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_alu = execute1_inInst_throwWhen_payload_ctrl_alu;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_wb = execute1_inInst_throwWhen_payload_ctrl_wb;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_rfen = execute1_inInst_throwWhen_payload_ctrl_rfen;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_execute0AluBypass = execute1_inInst_throwWhen_payload_ctrl_execute0AluBypass;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_execute1AluBypass = execute1_inInst_throwWhen_payload_ctrl_execute1AluBypass;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_canInternalyStallWriteBack0 = execute1_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_men = execute1_inInst_throwWhen_payload_ctrl_men;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_m = execute1_inInst_throwWhen_payload_ctrl_m;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_msk = execute1_inInst_throwWhen_payload_ctrl_msk;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_csr = execute1_inInst_throwWhen_payload_ctrl_csr;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_mfs = execute1_inInst_throwWhen_payload_ctrl_mfs;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_useSrc0 = execute1_inInst_throwWhen_payload_ctrl_useSrc0;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_useSrc1 = execute1_inInst_throwWhen_payload_ctrl_useSrc1;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_extensionTag = execute1_inInst_throwWhen_payload_ctrl_extensionTag;
  assign execute1_inInst_throwWhen_haltWhen_payload_ctrl_fencei = execute1_inInst_throwWhen_payload_ctrl_fencei;
  assign execute1_inInst_throwWhen_haltWhen_payload_br_eq = execute1_inInst_throwWhen_payload_br_eq;
  assign execute1_inInst_throwWhen_haltWhen_payload_br_ltx = execute1_inInst_throwWhen_payload_br_ltx;
  assign execute1_inInst_throwWhen_haltWhen_payload_src1 = execute1_inInst_throwWhen_payload_src1;
  assign execute1_inInst_throwWhen_haltWhen_payload_result = execute1_inInst_throwWhen_payload_result;
  assign execute1_inInst_throwWhen_haltWhen_payload_adder = execute1_inInst_throwWhen_payload_adder;
  assign execute1_inInst_throwWhen_haltWhen_payload_predictorHasBranch = execute1_inInst_throwWhen_payload_predictorHasBranch;
  assign execute1_inInst_throwWhen_haltWhen_payload_branchHistory_valid = execute1_inInst_throwWhen_payload_branchHistory_valid;
  assign execute1_inInst_throwWhen_haltWhen_payload_branchHistory_payload = execute1_inInst_throwWhen_payload_branchHistory_payload;
  assign execute1_inInst_throwWhen_haltWhen_payload_pcPlus4 = execute1_inInst_throwWhen_payload_pcPlus4;
  assign execute1_inInst_throwWhen_haltWhen_payload_pc_sel = execute1_inInst_throwWhen_payload_pc_sel;
  assign execute1_inInst_throwWhen_haltWhen_payload_unalignedMemoryAccessException = execute1_inInst_throwWhen_payload_unalignedMemoryAccessException;
  assign execute1_inInst_throwWhen_haltWhen_payload_needMemRsp = execute1_inInst_throwWhen_payload_needMemRsp;
  assign execute1_inInst_throwWhen_haltWhen_payload_dCmdAddress = execute1_inInst_throwWhen_payload_dCmdAddress;
  assign execute1_outInst_valid = execute1_inInst_throwWhen_haltWhen_valid;
  assign execute1_inInst_throwWhen_haltWhen_ready = execute1_outInst_ready;
  assign execute1_outInst_payload_pc = execute1_inInst_payload_pc;
  always @(*) begin
    execute1_outInst_payload_result = execute1_inInst_payload_result;
    if(when_DivExtension_l33) begin
      execute1_outInst_payload_result = DivExtension_rsp;
    end
    case(execute1_inInst_payload_ctrl_alu)
      ALU_SLL1 : begin
        execute1_outInst_payload_result = _zz_execute1_outInst_payload_result;
      end
      ALU_SRL_1, ALU_SRA_1 : begin
        execute1_outInst_payload_result = BarrelShifterFullExtension_s2_shiftRight;
      end
      default : begin
      end
    endcase
    if(execute1_inInst_valid) begin
      if(when_SimpleInterruptExtension_l57) begin
        case(switch_SimpleInterruptExtension_l58)
          2'b00 : begin
          end
          2'b01 : begin
            execute1_outInst_payload_result = {24'd0, SimpleInterrupExtension_irqValue};
          end
          2'b10 : begin
          end
          default : begin
            execute1_outInst_payload_result = {24'd0, writeBack_irq_mask};
          end
        endcase
      end
    end
  end

  assign execute1_outInst_payload_regFileAddress = execute1_inInst_payload_instruction[11 : 7];
  assign execute1_outInst_payload_ctrl_instVal = execute1_inInst_payload_ctrl_instVal;
  assign execute1_outInst_payload_ctrl_br = execute1_inInst_payload_ctrl_br;
  assign execute1_outInst_payload_ctrl_jmp = execute1_inInst_payload_ctrl_jmp;
  assign execute1_outInst_payload_ctrl_op0 = execute1_inInst_payload_ctrl_op0;
  assign execute1_outInst_payload_ctrl_op1 = execute1_inInst_payload_ctrl_op1;
  assign execute1_outInst_payload_ctrl_alu = execute1_inInst_payload_ctrl_alu;
  assign execute1_outInst_payload_ctrl_wb = execute1_inInst_payload_ctrl_wb;
  assign execute1_outInst_payload_ctrl_rfen = execute1_inInst_payload_ctrl_rfen;
  assign execute1_outInst_payload_ctrl_execute0AluBypass = execute1_inInst_payload_ctrl_execute0AluBypass;
  assign execute1_outInst_payload_ctrl_execute1AluBypass = execute1_inInst_payload_ctrl_execute1AluBypass;
  assign execute1_outInst_payload_ctrl_canInternalyStallWriteBack0 = execute1_inInst_payload_ctrl_canInternalyStallWriteBack0;
  assign execute1_outInst_payload_ctrl_men = execute1_inInst_payload_ctrl_men;
  assign execute1_outInst_payload_ctrl_m = execute1_inInst_payload_ctrl_m;
  assign execute1_outInst_payload_ctrl_msk = execute1_inInst_payload_ctrl_msk;
  assign execute1_outInst_payload_ctrl_csr = execute1_inInst_payload_ctrl_csr;
  assign execute1_outInst_payload_ctrl_mfs = execute1_inInst_payload_ctrl_mfs;
  assign execute1_outInst_payload_ctrl_useSrc0 = execute1_inInst_payload_ctrl_useSrc0;
  assign execute1_outInst_payload_ctrl_useSrc1 = execute1_inInst_payload_ctrl_useSrc1;
  assign execute1_outInst_payload_ctrl_extensionTag = execute1_inInst_payload_ctrl_extensionTag;
  assign execute1_outInst_payload_ctrl_fencei = execute1_inInst_payload_ctrl_fencei;
  assign execute1_outInst_payload_instruction = execute1_inInst_payload_instruction;
  assign execute1_outInst_payload_pcPlus4 = execute1_inInst_payload_pcPlus4;
  assign execute1_outInst_payload_unalignedMemoryAccessException = execute1_inInst_payload_unalignedMemoryAccessException;
  assign execute1_outInst_payload_needMemRsp = execute1_inInst_payload_needMemRsp;
  assign execute1_outInst_payload_dCmdAddress = execute1_inInst_payload_dCmdAddress;
  always @(*) begin
    execute1_flush = 1'b0;
    if(writeBack_pcLoad_valid) begin
      execute1_flush = 1'b1;
    end
  end

  assign execute1_outInst_ready = writeBack_inInst_ready;
  assign writeBack_inInst_valid = execute1_outInst_rValid;
  assign writeBack_inInst_payload_pc = execute1_outInst_rData_pc;
  assign writeBack_inInst_payload_instruction = execute1_outInst_rData_instruction;
  assign writeBack_inInst_payload_ctrl_instVal = execute1_outInst_rData_ctrl_instVal;
  assign writeBack_inInst_payload_ctrl_br = execute1_outInst_rData_ctrl_br;
  assign writeBack_inInst_payload_ctrl_jmp = execute1_outInst_rData_ctrl_jmp;
  assign writeBack_inInst_payload_ctrl_op0 = execute1_outInst_rData_ctrl_op0;
  assign writeBack_inInst_payload_ctrl_op1 = execute1_outInst_rData_ctrl_op1;
  assign writeBack_inInst_payload_ctrl_alu = execute1_outInst_rData_ctrl_alu;
  assign writeBack_inInst_payload_ctrl_wb = execute1_outInst_rData_ctrl_wb;
  assign writeBack_inInst_payload_ctrl_rfen = execute1_outInst_rData_ctrl_rfen;
  assign writeBack_inInst_payload_ctrl_execute0AluBypass = execute1_outInst_rData_ctrl_execute0AluBypass;
  assign writeBack_inInst_payload_ctrl_execute1AluBypass = execute1_outInst_rData_ctrl_execute1AluBypass;
  assign writeBack_inInst_payload_ctrl_canInternalyStallWriteBack0 = execute1_outInst_rData_ctrl_canInternalyStallWriteBack0;
  assign writeBack_inInst_payload_ctrl_men = execute1_outInst_rData_ctrl_men;
  assign writeBack_inInst_payload_ctrl_m = execute1_outInst_rData_ctrl_m;
  assign writeBack_inInst_payload_ctrl_msk = execute1_outInst_rData_ctrl_msk;
  assign writeBack_inInst_payload_ctrl_csr = execute1_outInst_rData_ctrl_csr;
  assign writeBack_inInst_payload_ctrl_mfs = execute1_outInst_rData_ctrl_mfs;
  assign writeBack_inInst_payload_ctrl_useSrc0 = execute1_outInst_rData_ctrl_useSrc0;
  assign writeBack_inInst_payload_ctrl_useSrc1 = execute1_outInst_rData_ctrl_useSrc1;
  assign writeBack_inInst_payload_ctrl_extensionTag = execute1_outInst_rData_ctrl_extensionTag;
  assign writeBack_inInst_payload_ctrl_fencei = execute1_outInst_rData_ctrl_fencei;
  always @(*) begin
    writeBack_inInst_payload_result = execute1_outInst_rData_result;
    if(when_MulExtension_l74) begin
      case(switch_MulExtension_l75)
        2'b00 : begin
          writeBack_inInst_payload_result = _zz_writeBack_inInst_payload_result;
        end
        default : begin
          writeBack_inInst_payload_result = _zz_writeBack_inInst_payload_result_1;
        end
      endcase
    end
  end

  assign writeBack_inInst_payload_regFileAddress = execute1_outInst_rData_regFileAddress;
  assign writeBack_inInst_payload_pcPlus4 = execute1_outInst_rData_pcPlus4;
  assign writeBack_inInst_payload_unalignedMemoryAccessException = execute1_outInst_rData_unalignedMemoryAccessException;
  assign writeBack_inInst_payload_needMemRsp = execute1_outInst_rData_needMemRsp;
  assign writeBack_inInst_payload_dCmdAddress = execute1_outInst_rData_dCmdAddress;
  always @(*) begin
    writeBack_throwIt = (! writeBack_inInst_payload_ctrl_rfen);
    if(writeBack_flush) begin
      writeBack_throwIt = 1'b1;
    end
    if(when_SimpleInterruptExtension_l38) begin
      if(when_SimpleInterruptExtension_l39) begin
        writeBack_throwIt = 1'b1;
      end
    end
  end

  always @(*) begin
    writeBack_halt = 1'b0;
    if(when_RiscvCore_l828) begin
      writeBack_halt = 1'b1;
    end
    if(when_RiscvCore_l857) begin
      if(when_RiscvCore_l858) begin
        writeBack_halt = 1'b1;
      end
    end
    if(writeBack_flushMemoryResponse) begin
      writeBack_halt = 1'b1;
    end
    if(DebugExtension_isInBreakpoint) begin
      writeBack_halt = 1'b1;
    end
  end

  always @(*) begin
    writeBack_irq_sources = 8'h0;
    if(writeBack_inInst_valid) begin
      if(when_RiscvCore_l834) begin
        writeBack_irq_sources[0] = 1'b1;
      end
      if(writeBack_inInst_payload_unalignedMemoryAccessException) begin
        writeBack_irq_sources[1] = 1'b1;
      end
    end
    writeBack_irq_sources[5] = io_interrupt_1;
    writeBack_irq_sources[4] = io_interrupt_0;
    writeBack_irq_sources[7] = io_interrupt_3;
    writeBack_irq_sources[6] = io_interrupt_2;
  end

  assign writeBack_irq_masked = (writeBack_irq_sources & writeBack_irq_mask);
  always @(*) begin
    writeBack_irq_inhibate = 1'b0;
    if(when_DebugExtension_l184) begin
      writeBack_irq_inhibate = 1'b1;
    end
  end

  assign when_RiscvCore_l828 = (((writeBack_irq_sources & (~ writeBack_irq_mask)) & 8'h02) != 8'h0);
  assign when_RiscvCore_l834 = (! writeBack_inInst_payload_ctrl_instVal);
  always @(*) begin
    writeBack_pcLoad_valid = 1'b0;
    if(when_SimpleInterruptExtension_l38) begin
      if(when_SimpleInterruptExtension_l39) begin
        writeBack_pcLoad_valid = 1'b1;
      end else begin
        if(_zz_7) begin
          if(when_SimpleInterruptExtension_l48) begin
            writeBack_pcLoad_valid = 1'b1;
          end
        end
      end
    end
  end

  always @(*) begin
    writeBack_pcLoad_payload = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(when_SimpleInterruptExtension_l38) begin
      if(when_SimpleInterruptExtension_l39) begin
        writeBack_pcLoad_payload = 32'h00000020;
      end else begin
        if(_zz_7) begin
          if(when_SimpleInterruptExtension_l48) begin
            writeBack_pcLoad_payload = 32'h00000020;
          end
        end
      end
    end
  end

  always @(*) begin
    dRsp_ready = 1'b1;
    if(writeBack_flushMemoryResponse) begin
      dRsp_ready = 1'b1;
    end
  end

  assign when_RiscvCore_l857 = (writeBack_inInst_valid && writeBack_inInst_payload_needMemRsp);
  assign when_RiscvCore_l858 = (! dRsp_valid);
  assign when_RiscvCore_l864 = (execute0_pendingDataCmd_readCount == 2'b00);
  assign _zz_writeBack_dataRspFormated = (dRsp_payload[7] && (! writeBack_inInst_payload_instruction[14]));
  always @(*) begin
    _zz_writeBack_dataRspFormated_1[31] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[30] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[29] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[28] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[27] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[26] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[25] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[24] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[23] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[22] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[21] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[20] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[19] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[18] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[17] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[16] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[15] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[14] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[13] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[12] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[11] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[10] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[9] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[8] = _zz_writeBack_dataRspFormated;
    _zz_writeBack_dataRspFormated_1[7 : 0] = dRsp_payload[7 : 0];
  end

  assign _zz_writeBack_dataRspFormated_2 = (dRsp_payload[15] && (! writeBack_inInst_payload_instruction[14]));
  always @(*) begin
    _zz_writeBack_dataRspFormated_3[31] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[30] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[29] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[28] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[27] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[26] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[25] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[24] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[23] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[22] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[21] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[20] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[19] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[18] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[17] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[16] = _zz_writeBack_dataRspFormated_2;
    _zz_writeBack_dataRspFormated_3[15 : 0] = dRsp_payload[15 : 0];
  end

  always @(*) begin
    case(writeBack_inInst_payload_ctrl_msk)
      MSK_B : begin
        writeBack_dataRspFormated = _zz_writeBack_dataRspFormated_1;
      end
      MSK_H : begin
        writeBack_dataRspFormated = _zz_writeBack_dataRspFormated_3;
      end
      default : begin
        writeBack_dataRspFormated = dRsp_payload;
      end
    endcase
  end

  always @(*) begin
    case(writeBack_inInst_payload_ctrl_wb)
      WB_ALU : begin
        writeBack_regFileData = writeBack_inInst_payload_result;
      end
      WB_MEM : begin
        writeBack_regFileData = writeBack_dataRspFormated;
      end
      WB_PC4 : begin
        writeBack_regFileData = writeBack_inInst_payload_pcPlus4;
      end
      default : begin
        writeBack_regFileData = 32'h0;
      end
    endcase
  end

  always @(*) begin
    writeBack_inInst_throwWhen_valid = writeBack_inInst_valid;
    if(writeBack_throwIt) begin
      writeBack_inInst_throwWhen_valid = 1'b0;
    end
  end

  always @(*) begin
    writeBack_inInst_ready = writeBack_inInst_throwWhen_ready;
    if(writeBack_throwIt) begin
      writeBack_inInst_ready = 1'b1;
    end
  end

  assign writeBack_inInst_throwWhen_payload_pc = writeBack_inInst_payload_pc;
  assign writeBack_inInst_throwWhen_payload_instruction = writeBack_inInst_payload_instruction;
  assign writeBack_inInst_throwWhen_payload_ctrl_instVal = writeBack_inInst_payload_ctrl_instVal;
  assign writeBack_inInst_throwWhen_payload_ctrl_br = writeBack_inInst_payload_ctrl_br;
  assign writeBack_inInst_throwWhen_payload_ctrl_jmp = writeBack_inInst_payload_ctrl_jmp;
  assign writeBack_inInst_throwWhen_payload_ctrl_op0 = writeBack_inInst_payload_ctrl_op0;
  assign writeBack_inInst_throwWhen_payload_ctrl_op1 = writeBack_inInst_payload_ctrl_op1;
  assign writeBack_inInst_throwWhen_payload_ctrl_alu = writeBack_inInst_payload_ctrl_alu;
  assign writeBack_inInst_throwWhen_payload_ctrl_wb = writeBack_inInst_payload_ctrl_wb;
  assign writeBack_inInst_throwWhen_payload_ctrl_rfen = writeBack_inInst_payload_ctrl_rfen;
  assign writeBack_inInst_throwWhen_payload_ctrl_execute0AluBypass = writeBack_inInst_payload_ctrl_execute0AluBypass;
  assign writeBack_inInst_throwWhen_payload_ctrl_execute1AluBypass = writeBack_inInst_payload_ctrl_execute1AluBypass;
  assign writeBack_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0 = writeBack_inInst_payload_ctrl_canInternalyStallWriteBack0;
  assign writeBack_inInst_throwWhen_payload_ctrl_men = writeBack_inInst_payload_ctrl_men;
  assign writeBack_inInst_throwWhen_payload_ctrl_m = writeBack_inInst_payload_ctrl_m;
  assign writeBack_inInst_throwWhen_payload_ctrl_msk = writeBack_inInst_payload_ctrl_msk;
  assign writeBack_inInst_throwWhen_payload_ctrl_csr = writeBack_inInst_payload_ctrl_csr;
  assign writeBack_inInst_throwWhen_payload_ctrl_mfs = writeBack_inInst_payload_ctrl_mfs;
  assign writeBack_inInst_throwWhen_payload_ctrl_useSrc0 = writeBack_inInst_payload_ctrl_useSrc0;
  assign writeBack_inInst_throwWhen_payload_ctrl_useSrc1 = writeBack_inInst_payload_ctrl_useSrc1;
  assign writeBack_inInst_throwWhen_payload_ctrl_extensionTag = writeBack_inInst_payload_ctrl_extensionTag;
  assign writeBack_inInst_throwWhen_payload_ctrl_fencei = writeBack_inInst_payload_ctrl_fencei;
  assign writeBack_inInst_throwWhen_payload_result = writeBack_inInst_payload_result;
  assign writeBack_inInst_throwWhen_payload_regFileAddress = writeBack_inInst_payload_regFileAddress;
  assign writeBack_inInst_throwWhen_payload_pcPlus4 = writeBack_inInst_payload_pcPlus4;
  assign writeBack_inInst_throwWhen_payload_unalignedMemoryAccessException = writeBack_inInst_payload_unalignedMemoryAccessException;
  assign writeBack_inInst_throwWhen_payload_needMemRsp = writeBack_inInst_payload_needMemRsp;
  assign writeBack_inInst_throwWhen_payload_dCmdAddress = writeBack_inInst_payload_dCmdAddress;
  assign _zz_writeBack_inInst_throwWhen_ready = (! writeBack_halt);
  assign writeBack_inInst_throwWhen_haltWhen_valid = (writeBack_inInst_throwWhen_valid && _zz_writeBack_inInst_throwWhen_ready);
  assign writeBack_inInst_throwWhen_ready = (writeBack_inInst_throwWhen_haltWhen_ready && _zz_writeBack_inInst_throwWhen_ready);
  assign writeBack_inInst_throwWhen_haltWhen_payload_pc = writeBack_inInst_throwWhen_payload_pc;
  assign writeBack_inInst_throwWhen_haltWhen_payload_instruction = writeBack_inInst_throwWhen_payload_instruction;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_instVal = writeBack_inInst_throwWhen_payload_ctrl_instVal;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_br = writeBack_inInst_throwWhen_payload_ctrl_br;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_jmp = writeBack_inInst_throwWhen_payload_ctrl_jmp;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op0 = writeBack_inInst_throwWhen_payload_ctrl_op0;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_op1 = writeBack_inInst_throwWhen_payload_ctrl_op1;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_alu = writeBack_inInst_throwWhen_payload_ctrl_alu;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_wb = writeBack_inInst_throwWhen_payload_ctrl_wb;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_rfen = writeBack_inInst_throwWhen_payload_ctrl_rfen;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_execute0AluBypass = writeBack_inInst_throwWhen_payload_ctrl_execute0AluBypass;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_execute1AluBypass = writeBack_inInst_throwWhen_payload_ctrl_execute1AluBypass;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_canInternalyStallWriteBack0 = writeBack_inInst_throwWhen_payload_ctrl_canInternalyStallWriteBack0;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_men = writeBack_inInst_throwWhen_payload_ctrl_men;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_m = writeBack_inInst_throwWhen_payload_ctrl_m;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_msk = writeBack_inInst_throwWhen_payload_ctrl_msk;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_csr = writeBack_inInst_throwWhen_payload_ctrl_csr;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_mfs = writeBack_inInst_throwWhen_payload_ctrl_mfs;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_useSrc0 = writeBack_inInst_throwWhen_payload_ctrl_useSrc0;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_useSrc1 = writeBack_inInst_throwWhen_payload_ctrl_useSrc1;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_extensionTag = writeBack_inInst_throwWhen_payload_ctrl_extensionTag;
  assign writeBack_inInst_throwWhen_haltWhen_payload_ctrl_fencei = writeBack_inInst_throwWhen_payload_ctrl_fencei;
  assign writeBack_inInst_throwWhen_haltWhen_payload_result = writeBack_inInst_throwWhen_payload_result;
  assign writeBack_inInst_throwWhen_haltWhen_payload_regFileAddress = writeBack_inInst_throwWhen_payload_regFileAddress;
  assign writeBack_inInst_throwWhen_haltWhen_payload_pcPlus4 = writeBack_inInst_throwWhen_payload_pcPlus4;
  assign writeBack_inInst_throwWhen_haltWhen_payload_unalignedMemoryAccessException = writeBack_inInst_throwWhen_payload_unalignedMemoryAccessException;
  assign writeBack_inInst_throwWhen_haltWhen_payload_needMemRsp = writeBack_inInst_throwWhen_payload_needMemRsp;
  assign writeBack_inInst_throwWhen_haltWhen_payload_dCmdAddress = writeBack_inInst_throwWhen_payload_dCmdAddress;
  assign writeBack_outInst_valid = writeBack_inInst_throwWhen_haltWhen_valid;
  assign writeBack_inInst_throwWhen_haltWhen_ready = writeBack_outInst_ready;
  assign writeBack_outInst_payload_addr = writeBack_inInst_payload_regFileAddress;
  assign writeBack_outInst_payload_data = writeBack_regFileData;
  assign writeBack_outInst_fire = (writeBack_outInst_valid && writeBack_outInst_ready);
  always @(*) begin
    writeBack_regFileWrite_valid = writeBack_outInst_fire;
    if(_zz_9) begin
      if(!when_DebugExtension_l101) begin
        if(_zz_10) begin
          writeBack_regFileWrite_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    writeBack_regFileWrite_payload_address = writeBack_outInst_payload_addr;
    if(_zz_9) begin
      if(!when_DebugExtension_l101) begin
        if(_zz_10) begin
          writeBack_regFileWrite_payload_address = _zz_decode_regFileReadAddress0[4 : 0];
        end
      end
    end
  end

  always @(*) begin
    writeBack_regFileWrite_payload_data = writeBack_regFileData;
    if(_zz_9) begin
      if(!when_DebugExtension_l101) begin
        if(_zz_10) begin
          writeBack_regFileWrite_payload_data = _zz_prefetch_pc;
        end
      end
    end
  end

  always @(*) begin
    writeBack_flush = 1'b0;
    if(DebugExtension_flushIt) begin
      writeBack_flush = 1'b1;
    end
  end

  assign writeBack_outInst_ready = writeBackBuffer_inInst_ready;
  assign writeBackBuffer_inInst_valid = writeBack_outInst_rValid;
  assign writeBackBuffer_inInst_payload_addr = writeBack_outInst_rData_addr;
  assign writeBackBuffer_inInst_payload_data = writeBack_outInst_rData_data;
  assign writeBackBuffer_inInst_ready = 1'b1;
  always @(*) begin
    prefetch_pcLoad_valid = decode_pcLoad_valid;
    if(execute1_pcLoad_valid) begin
      prefetch_pcLoad_valid = 1'b1;
    end
    if(writeBack_pcLoad_valid) begin
      prefetch_pcLoad_valid = 1'b1;
    end
  end

  always @(*) begin
    prefetch_pcLoad_payload = decode_pcLoad_payload;
    if(execute1_pcLoad_valid) begin
      prefetch_pcLoad_payload = execute1_pcLoad_payload;
    end
    if(writeBack_pcLoad_valid) begin
      prefetch_pcLoad_payload = writeBack_pcLoad_payload;
    end
  end

  always @(*) begin
    hazardTracker_src0Hazard = 1'b0;
    if(when_RiscvCore_l980) begin
      if(when_RiscvCore_l989) begin
        if(hazardTracker_A_addr0Match) begin
          hazardTracker_src0Hazard = 1'b1;
        end
      end
    end
    if(when_RiscvCore_l1004) begin
      if(when_RiscvCore_l1015) begin
        if(hazardTracker_E1_addr0Match) begin
          hazardTracker_src0Hazard = 1'b1;
        end
      end
    end
    if(when_RiscvCore_l1030) begin
      if(when_RiscvCore_l1041) begin
        if(hazardTracker_E0_addr0Match) begin
          hazardTracker_src0Hazard = 1'b1;
        end
      end
    end
    if(when_RiscvCore_l1052) begin
      hazardTracker_src0Hazard = 1'b0;
    end
  end

  always @(*) begin
    hazardTracker_src1Hazard = 1'b0;
    if(when_RiscvCore_l980) begin
      if(when_RiscvCore_l989) begin
        if(hazardTracker_A_addr1Match) begin
          hazardTracker_src1Hazard = 1'b1;
        end
      end
    end
    if(when_RiscvCore_l1004) begin
      if(when_RiscvCore_l1015) begin
        if(hazardTracker_E1_addr1Match) begin
          hazardTracker_src1Hazard = 1'b1;
        end
      end
    end
    if(when_RiscvCore_l1030) begin
      if(when_RiscvCore_l1041) begin
        if(hazardTracker_E0_addr1Match) begin
          hazardTracker_src1Hazard = 1'b1;
        end
      end
    end
    if(when_RiscvCore_l1055) begin
      hazardTracker_src1Hazard = 1'b0;
    end
  end

  assign decode_hazard = (hazardTracker_src0Hazard || hazardTracker_src1Hazard);
  assign hazardTracker_W2R_addr0Match = (writeBackBuffer_inInst_payload_addr == decode_addr0);
  assign hazardTracker_W2R_addr1Match = (writeBackBuffer_inInst_payload_addr == decode_addr1);
  assign hazardTracker_A_addr0Match = (writeBack_outInst_payload_addr == decode_addr0);
  assign hazardTracker_A_addr1Match = (writeBack_outInst_payload_addr == decode_addr1);
  assign when_RiscvCore_l980 = (writeBack_inInst_valid && writeBack_inInst_payload_ctrl_rfen);
  assign when_RiscvCore_l989 = (1'b0 || (! writeBack_outInst_valid));
  assign hazardTracker_E1_addr0Match = (execute1_outInst_payload_instruction[11 : 7] == decode_addr0);
  assign hazardTracker_E1_addr1Match = (execute1_outInst_payload_instruction[11 : 7] == decode_addr1);
  assign when_RiscvCore_l1004 = (execute1_inInst_valid && execute1_outInst_payload_ctrl_rfen);
  assign when_RiscvCore_l1015 = ((1'b0 || (! execute1_inInst_payload_ctrl_execute1AluBypass)) || (! execute1_outInst_valid));
  assign hazardTracker_E0_addr0Match = (execute0_outInst_payload_instruction[11 : 7] == decode_addr0);
  assign hazardTracker_E0_addr1Match = (execute0_outInst_payload_instruction[11 : 7] == decode_addr1);
  assign when_RiscvCore_l1030 = (execute0_inInst_valid && execute0_outInst_payload_ctrl_rfen);
  assign when_RiscvCore_l1041 = ((1'b0 || (! execute0_inInst_payload_ctrl_execute0AluBypass)) || (! execute0_outInst_valid));
  assign when_RiscvCore_l1052 = (decode_addr0IsZero || (! decode_ctrl_useSrc0));
  assign when_RiscvCore_l1055 = (decode_addr1IsZero || (! decode_ctrl_useSrc1));
  assign when_RiscvCore_l1063 = ((execute0_inInst_valid && execute0_inInst_payload_ctrl_men) && (execute0_inInst_payload_ctrl_m == M_XRD));
  assign when_RiscvCore_l1064 = (execute1_inInst_valid && execute1_inInst_payload_ctrl_canInternalyStallWriteBack0);
  assign writeBack_inInst_isStall = (writeBack_inInst_valid && (! writeBack_inInst_ready));
  assign when_RiscvCore_l1067 = (writeBack_inInst_isStall && writeBack_inInst_payload_ctrl_canInternalyStallWriteBack0);
  assign MulExtension_s1_a = execute0_inInst_payload_alu_op0;
  assign MulExtension_s1_b = execute0_inInst_payload_alu_op1;
  assign switch_MulExtension_l30 = execute0_inInst_payload_instruction[13 : 12];
  always @(*) begin
    case(switch_MulExtension_l30)
      2'b01 : begin
        MulExtension_s1_aSigned = 1'b1;
      end
      2'b10 : begin
        MulExtension_s1_aSigned = 1'b1;
      end
      default : begin
        MulExtension_s1_aSigned = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(switch_MulExtension_l30)
      2'b01 : begin
        MulExtension_s1_bSigned = 1'b1;
      end
      2'b10 : begin
        MulExtension_s1_bSigned = 1'b0;
      end
      default : begin
        MulExtension_s1_bSigned = 1'b0;
      end
    endcase
  end

  assign MulExtension_s1_aULow = MulExtension_s1_a[15 : 0];
  assign MulExtension_s1_bULow = MulExtension_s1_b[15 : 0];
  assign MulExtension_s1_aSLow = {1'b0,MulExtension_s1_a[15 : 0]};
  assign MulExtension_s1_bSLow = {1'b0,MulExtension_s1_b[15 : 0]};
  assign MulExtension_s1_aHigh = {(MulExtension_s1_aSigned && MulExtension_s1_a[31]),MulExtension_s1_a[31 : 16]};
  assign MulExtension_s1_bHigh = {(MulExtension_s1_bSigned && MulExtension_s1_b[31]),MulExtension_s1_b[31 : 16]};
  assign MulExtension_s1_mul_ll = (MulExtension_s1_aULow * MulExtension_s1_bULow);
  assign MulExtension_s1_mul_lh = ($signed(MulExtension_s1_aSLow) * $signed(MulExtension_s1_bHigh));
  assign MulExtension_s1_mul_hl = ($signed(MulExtension_s1_aHigh) * $signed(MulExtension_s1_bSLow));
  assign MulExtension_s1_mul_hh = ($signed(MulExtension_s1_aHigh) * $signed(MulExtension_s1_bHigh));
  assign MulExtension_s2_low = ($signed(_zz_MulExtension_s2_low) + $signed(_zz_MulExtension_s2_low_6));
  assign MulExtension_s3_result = ($signed(_zz_MulExtension_s3_result) + $signed(_zz_MulExtension_s3_result_1));
  assign when_MulExtension_l74 = (writeBack_inInst_payload_ctrl_extensionTag == 3'b001);
  assign switch_MulExtension_l75 = writeBack_inInst_payload_instruction[13 : 12];
  always @(*) begin
    DivExtension_divider_io_cmd_valid = 1'b0;
    if(when_DivExtension_l26) begin
      DivExtension_divider_io_cmd_valid = execute0_outInst_valid;
    end
  end

  assign DivExtension_divider_io_cmd_payload_signed = (! execute0_inInst_payload_instruction[12]);
  always @(*) begin
    DivExtension_divider_io_rsp_ready = 1'b0;
    if(when_DivExtension_l33) begin
      DivExtension_divider_io_rsp_ready = (execute1_inInst_ready && DivExtension_rspReady);
    end
  end

  assign when_DivExtension_l26 = (execute0_inInst_valid && (execute0_inInst_payload_ctrl_extensionTag == 3'b010));
  assign when_DivExtension_l28 = (! DivExtension_divider_io_cmd_ready);
  assign when_DivExtension_l33 = (execute1_inInst_valid && (execute1_inInst_payload_ctrl_extensionTag == 3'b010));
  assign when_DivExtension_l36 = (! DivExtension_rspReady);
  assign BarrelShifterFullExtension_s1_amplitude = execute0_inInst_payload_alu_op1[4 : 0];
  always @(*) begin
    _zz_BarrelShifterFullExtension_s1_reversed[0] = execute0_inInst_payload_alu_op0[31];
    _zz_BarrelShifterFullExtension_s1_reversed[1] = execute0_inInst_payload_alu_op0[30];
    _zz_BarrelShifterFullExtension_s1_reversed[2] = execute0_inInst_payload_alu_op0[29];
    _zz_BarrelShifterFullExtension_s1_reversed[3] = execute0_inInst_payload_alu_op0[28];
    _zz_BarrelShifterFullExtension_s1_reversed[4] = execute0_inInst_payload_alu_op0[27];
    _zz_BarrelShifterFullExtension_s1_reversed[5] = execute0_inInst_payload_alu_op0[26];
    _zz_BarrelShifterFullExtension_s1_reversed[6] = execute0_inInst_payload_alu_op0[25];
    _zz_BarrelShifterFullExtension_s1_reversed[7] = execute0_inInst_payload_alu_op0[24];
    _zz_BarrelShifterFullExtension_s1_reversed[8] = execute0_inInst_payload_alu_op0[23];
    _zz_BarrelShifterFullExtension_s1_reversed[9] = execute0_inInst_payload_alu_op0[22];
    _zz_BarrelShifterFullExtension_s1_reversed[10] = execute0_inInst_payload_alu_op0[21];
    _zz_BarrelShifterFullExtension_s1_reversed[11] = execute0_inInst_payload_alu_op0[20];
    _zz_BarrelShifterFullExtension_s1_reversed[12] = execute0_inInst_payload_alu_op0[19];
    _zz_BarrelShifterFullExtension_s1_reversed[13] = execute0_inInst_payload_alu_op0[18];
    _zz_BarrelShifterFullExtension_s1_reversed[14] = execute0_inInst_payload_alu_op0[17];
    _zz_BarrelShifterFullExtension_s1_reversed[15] = execute0_inInst_payload_alu_op0[16];
    _zz_BarrelShifterFullExtension_s1_reversed[16] = execute0_inInst_payload_alu_op0[15];
    _zz_BarrelShifterFullExtension_s1_reversed[17] = execute0_inInst_payload_alu_op0[14];
    _zz_BarrelShifterFullExtension_s1_reversed[18] = execute0_inInst_payload_alu_op0[13];
    _zz_BarrelShifterFullExtension_s1_reversed[19] = execute0_inInst_payload_alu_op0[12];
    _zz_BarrelShifterFullExtension_s1_reversed[20] = execute0_inInst_payload_alu_op0[11];
    _zz_BarrelShifterFullExtension_s1_reversed[21] = execute0_inInst_payload_alu_op0[10];
    _zz_BarrelShifterFullExtension_s1_reversed[22] = execute0_inInst_payload_alu_op0[9];
    _zz_BarrelShifterFullExtension_s1_reversed[23] = execute0_inInst_payload_alu_op0[8];
    _zz_BarrelShifterFullExtension_s1_reversed[24] = execute0_inInst_payload_alu_op0[7];
    _zz_BarrelShifterFullExtension_s1_reversed[25] = execute0_inInst_payload_alu_op0[6];
    _zz_BarrelShifterFullExtension_s1_reversed[26] = execute0_inInst_payload_alu_op0[5];
    _zz_BarrelShifterFullExtension_s1_reversed[27] = execute0_inInst_payload_alu_op0[4];
    _zz_BarrelShifterFullExtension_s1_reversed[28] = execute0_inInst_payload_alu_op0[3];
    _zz_BarrelShifterFullExtension_s1_reversed[29] = execute0_inInst_payload_alu_op0[2];
    _zz_BarrelShifterFullExtension_s1_reversed[30] = execute0_inInst_payload_alu_op0[1];
    _zz_BarrelShifterFullExtension_s1_reversed[31] = execute0_inInst_payload_alu_op0[0];
  end

  assign BarrelShifterFullExtension_s1_reversed = ((execute0_inInst_payload_ctrl_alu == ALU_SLL1) ? _zz_BarrelShifterFullExtension_s1_reversed : execute0_inInst_payload_alu_op0);
  assign BarrelShifterFullExtension_s1_shiftRight = _zz_BarrelShifterFullExtension_s1_shiftRight;
  always @(*) begin
    _zz_execute1_outInst_payload_result[0] = BarrelShifterFullExtension_s2_shiftRight[31];
    _zz_execute1_outInst_payload_result[1] = BarrelShifterFullExtension_s2_shiftRight[30];
    _zz_execute1_outInst_payload_result[2] = BarrelShifterFullExtension_s2_shiftRight[29];
    _zz_execute1_outInst_payload_result[3] = BarrelShifterFullExtension_s2_shiftRight[28];
    _zz_execute1_outInst_payload_result[4] = BarrelShifterFullExtension_s2_shiftRight[27];
    _zz_execute1_outInst_payload_result[5] = BarrelShifterFullExtension_s2_shiftRight[26];
    _zz_execute1_outInst_payload_result[6] = BarrelShifterFullExtension_s2_shiftRight[25];
    _zz_execute1_outInst_payload_result[7] = BarrelShifterFullExtension_s2_shiftRight[24];
    _zz_execute1_outInst_payload_result[8] = BarrelShifterFullExtension_s2_shiftRight[23];
    _zz_execute1_outInst_payload_result[9] = BarrelShifterFullExtension_s2_shiftRight[22];
    _zz_execute1_outInst_payload_result[10] = BarrelShifterFullExtension_s2_shiftRight[21];
    _zz_execute1_outInst_payload_result[11] = BarrelShifterFullExtension_s2_shiftRight[20];
    _zz_execute1_outInst_payload_result[12] = BarrelShifterFullExtension_s2_shiftRight[19];
    _zz_execute1_outInst_payload_result[13] = BarrelShifterFullExtension_s2_shiftRight[18];
    _zz_execute1_outInst_payload_result[14] = BarrelShifterFullExtension_s2_shiftRight[17];
    _zz_execute1_outInst_payload_result[15] = BarrelShifterFullExtension_s2_shiftRight[16];
    _zz_execute1_outInst_payload_result[16] = BarrelShifterFullExtension_s2_shiftRight[15];
    _zz_execute1_outInst_payload_result[17] = BarrelShifterFullExtension_s2_shiftRight[14];
    _zz_execute1_outInst_payload_result[18] = BarrelShifterFullExtension_s2_shiftRight[13];
    _zz_execute1_outInst_payload_result[19] = BarrelShifterFullExtension_s2_shiftRight[12];
    _zz_execute1_outInst_payload_result[20] = BarrelShifterFullExtension_s2_shiftRight[11];
    _zz_execute1_outInst_payload_result[21] = BarrelShifterFullExtension_s2_shiftRight[10];
    _zz_execute1_outInst_payload_result[22] = BarrelShifterFullExtension_s2_shiftRight[9];
    _zz_execute1_outInst_payload_result[23] = BarrelShifterFullExtension_s2_shiftRight[8];
    _zz_execute1_outInst_payload_result[24] = BarrelShifterFullExtension_s2_shiftRight[7];
    _zz_execute1_outInst_payload_result[25] = BarrelShifterFullExtension_s2_shiftRight[6];
    _zz_execute1_outInst_payload_result[26] = BarrelShifterFullExtension_s2_shiftRight[5];
    _zz_execute1_outInst_payload_result[27] = BarrelShifterFullExtension_s2_shiftRight[4];
    _zz_execute1_outInst_payload_result[28] = BarrelShifterFullExtension_s2_shiftRight[3];
    _zz_execute1_outInst_payload_result[29] = BarrelShifterFullExtension_s2_shiftRight[2];
    _zz_execute1_outInst_payload_result[30] = BarrelShifterFullExtension_s2_shiftRight[1];
    _zz_execute1_outInst_payload_result[31] = BarrelShifterFullExtension_s2_shiftRight[0];
  end

  always @(*) begin
    SimpleInterrupExtension_irqValue = 8'h0;
    SimpleInterrupExtension_irqValue[5] = writeBack_irq_masked[5];
    SimpleInterrupExtension_irqValue[4] = writeBack_irq_masked[4];
    SimpleInterrupExtension_irqValue[7] = writeBack_irq_masked[7];
    SimpleInterrupExtension_irqValue[1] = _zz_SimpleInterrupExtension_irqValue;
    SimpleInterrupExtension_irqValue[6] = writeBack_irq_masked[6];
  end

  assign when_SimpleInterruptExtension_l34 = (! SimpleInterrupExtension_inIrq);
  assign when_SimpleInterruptExtension_l38 = ((! SimpleInterrupExtension_inIrq) && (! writeBack_irq_inhibate));
  assign when_SimpleInterruptExtension_l39 = ((writeBack_irq_masked & 8'h02) != 8'h0);
  assign when_SimpleInterruptExtension_l48 = (((decode_inInst_valid && (! execute0_inInst_valid)) && (! execute1_inInst_valid)) && (! writeBack_inInst_valid));
  assign when_SimpleInterruptExtension_l57 = (execute1_inInst_payload_ctrl_extensionTag == 3'b011);
  assign switch_SimpleInterruptExtension_l58 = execute1_inInst_payload_instruction[26 : 25];
  assign execute1_outInst_fire = (execute1_outInst_valid && execute1_outInst_ready);
  assign io_i_cmd_valid = iCmd_valid;
  assign iCmd_ready = io_i_cmd_ready;
  assign io_i_cmd_payload_pc = iCmd_payload_pc;
  assign iRsp_valid = io_i_rsp_valid;
  assign io_i_rsp_ready = iRsp_ready;
  assign iRsp_payload_instruction = io_i_rsp_payload_instruction;
  assign iRsp_payload_pc = io_i_rsp_payload_pc;
  assign iRsp_payload_branchCacheLine_pc = io_i_rsp_payload_branchCacheLine_pc;
  assign iRsp_payload_branchCacheLine_history = io_i_rsp_payload_branchCacheLine_history;
  assign _zz_io_i_branchCachePort_rsp_pc_2 = brancheCache_spinal_port1;
  assign _zz_io_i_branchCachePort_rsp_pc = io_i_branchCachePort_cmd_valid;
  assign _zz_io_i_branchCachePort_rsp_pc_1 = io_i_branchCachePort_cmd_payload;
  assign io_i_branchCachePort_rsp_pc = _zz_io_i_branchCachePort_rsp_pc_2[22 : 0];
  assign io_i_branchCachePort_rsp_history = _zz_io_i_branchCachePort_rsp_pc_2[24 : 23];
  assign io_d_cmd_valid = dCmd_valid;
  assign dCmd_ready = io_d_cmd_ready;
  assign io_d_cmd_payload_wr = dCmd_payload_wr;
  assign io_d_cmd_payload_address = dCmd_payload_address;
  assign io_d_cmd_payload_data = dCmd_payload_data;
  assign io_d_cmd_payload_size = dCmd_payload_size;
  assign dRsp_valid = io_d_rsp_valid;
  assign io_d_rsp_ready = dRsp_ready;
  assign dRsp_payload = io_d_rsp_payload;
  always @(*) begin
    _zz_io_debugBus_PRDATA = DebugExtension_busReadDataReg;
    if(DebugExtension_readRegFileReg) begin
      _zz_io_debugBus_PRDATA = decode_src0;
    end
  end

  assign DebugExtension_isPipBusy = (DebugExtension_isPipActive || DebugExtension_isPipActive_regNext);
  assign DebugExtension_isInBreakpoint = (writeBack_inInst_valid && (writeBack_inInst_payload_ctrl_extensionTag == 3'b100));
  assign when_DebugExtension_l101 = _zz_decode_regFileReadAddress0[7];
  assign switch_DebugExtension_l102 = _zz_decode_regFileReadAddress0[6 : 0];
  assign when_DebugExtension_l107 = _zz_prefetch_pc[16];
  assign when_DebugExtension_l108 = _zz_prefetch_pc[17];
  assign when_DebugExtension_l109 = _zz_prefetch_pc[24];
  assign when_DebugExtension_l110 = _zz_prefetch_pc[25];
  assign decode_inInst_fire = (decode_inInst_valid && decode_inInst_ready);
  assign when_DebugExtension_l157 = (execute1_inInst_valid && (execute1_inInst_payload_ctrl_extensionTag == 3'b100));
  assign when_DebugExtension_l178 = (DebugExtension_stepIt && iCmd_fire);
  assign _zz_io_debugResetOut = DebugExtension_resetIt_regNext;
  assign when_DebugExtension_l184 = (DebugExtension_haltIt || DebugExtension_stepIt);
  always @(posedge clkout or posedge resetCtrl_coreReset) begin
    if(resetCtrl_coreReset) begin
      prefetch_pc <= 32'h0;
      prefetch_inc <= 1'b0;
      prefetch_resetDone <= 1'b0;
      fetch_pendingPrefetch_value <= 2'b00;
      fetch_throwRemaining <= 2'b00;
      fetch_outInst_rValid <= 1'b0;
      decode_outInst_rValid <= 1'b0;
      execute0_pendingDataCmd_readCount <= 2'b00;
      execute0_outInst_rValid <= 1'b0;
      execute1_outInst_rValid <= 1'b0;
      writeBack_irq_mask <= 8'h0;
      writeBack_flushMemoryResponse <= 1'b0;
      writeBack_outInst_rValid <= 1'b0;
      DivExtension_rspReady <= 1'b0;
      SimpleInterrupExtension_inIrq <= 1'b0;
    end else begin
      prefetch_resetDone <= 1'b1;
      if(when_RiscvCore_l530) begin
        prefetch_pc <= prefetch_pcNext;
      end
      if(iCmd_fire) begin
        prefetch_inc <= 1'b1;
      end else begin
        if(prefetch_pcLoad_valid) begin
          prefetch_inc <= 1'b0;
        end
      end
      fetch_pendingPrefetch_value <= fetch_pendingPrefetch_valueNext;
      if(when_RiscvCore_l558) begin
        fetch_throwRemaining <= (fetch_throwRemaining - 2'b01);
      end
      if(fetch_throwIt) begin
        fetch_throwRemaining <= (fetch_pendingPrefetch_value - _zz_fetch_throwRemaining);
      end
      if(fetch_outInst_ready) begin
        fetch_outInst_rValid <= fetch_outInst_valid;
      end
      if(decode_outInst_ready) begin
        decode_outInst_rValid <= decode_outInst_valid;
      end
      if(when_RiscvCore_l742) begin
        execute0_pendingDataCmd_readCount <= (execute0_pendingDataCmd_readCount + (execute0_pendingDataCmd_readCountInc ? 2'b01 : 2'b11));
      end
      if(execute0_outInst_ready) begin
        execute0_outInst_rValid <= execute0_outInst_valid;
      end
      if(execute1_outInst_ready) begin
        execute1_outInst_rValid <= execute1_outInst_valid;
      end
      if(when_RiscvCore_l864) begin
        writeBack_flushMemoryResponse <= 1'b0;
      end
      if(writeBack_outInst_ready) begin
        writeBack_outInst_rValid <= writeBack_outInst_valid;
      end
      if(when_DivExtension_l33) begin
        DivExtension_rspReady <= (DivExtension_divider_io_rsp_valid && (! execute1_inInst_ready));
      end
      if(execute1_throwIt) begin
        DivExtension_rspReady <= 1'b0;
      end
      if(when_SimpleInterruptExtension_l38) begin
        if(when_SimpleInterruptExtension_l39) begin
          writeBack_flushMemoryResponse <= 1'b1;
          SimpleInterrupExtension_inIrq <= 1'b1;
        end else begin
          if(_zz_7) begin
            if(when_SimpleInterruptExtension_l48) begin
              SimpleInterrupExtension_inIrq <= 1'b1;
            end
          end
        end
      end
      if(execute1_inInst_valid) begin
        if(when_SimpleInterruptExtension_l57) begin
          case(switch_SimpleInterruptExtension_l58)
            2'b00 : begin
              if(execute1_outInst_fire) begin
                SimpleInterrupExtension_inIrq <= 1'b0;
              end
            end
            2'b01 : begin
            end
            2'b10 : begin
              writeBack_irq_mask <= execute1_inInst_payload_result[7:0];
            end
            default : begin
            end
          endcase
        end
      end
      if(_zz_9) begin
        if(when_DebugExtension_l101) begin
          case(switch_DebugExtension_l102)
            7'h01 : begin
              if(_zz_10) begin
                prefetch_pc <= _zz_prefetch_pc;
                prefetch_inc <= 1'b0;
              end
            end
            7'h02 : begin
              if(_zz_10) begin
                fetch_outInst_rValid <= (! decode_inInst_fire_regNext);
              end
            end
            default : begin
            end
          endcase
        end
      end
    end
  end

  always @(posedge clkout) begin
    if(fetch_outInst_ready) begin
      fetch_outInst_rData_pc <= fetch_outInst_payload_pc;
      fetch_outInst_rData_instruction <= fetch_outInst_payload_instruction;
      fetch_outInst_rData_branchCacheLine_pc <= fetch_outInst_payload_branchCacheLine_pc;
      fetch_outInst_rData_branchCacheLine_history <= fetch_outInst_payload_branchCacheLine_history;
    end
    if(decode_outInst_ready) begin
      decode_outInst_rData_pc <= decode_outInst_payload_pc;
      decode_outInst_rData_instruction <= decode_outInst_payload_instruction;
      decode_outInst_rData_ctrl_instVal <= decode_outInst_payload_ctrl_instVal;
      decode_outInst_rData_ctrl_br <= decode_outInst_payload_ctrl_br;
      decode_outInst_rData_ctrl_jmp <= decode_outInst_payload_ctrl_jmp;
      decode_outInst_rData_ctrl_op0 <= decode_outInst_payload_ctrl_op0;
      decode_outInst_rData_ctrl_op1 <= decode_outInst_payload_ctrl_op1;
      decode_outInst_rData_ctrl_alu <= decode_outInst_payload_ctrl_alu;
      decode_outInst_rData_ctrl_wb <= decode_outInst_payload_ctrl_wb;
      decode_outInst_rData_ctrl_rfen <= decode_outInst_payload_ctrl_rfen;
      decode_outInst_rData_ctrl_execute0AluBypass <= decode_outInst_payload_ctrl_execute0AluBypass;
      decode_outInst_rData_ctrl_execute1AluBypass <= decode_outInst_payload_ctrl_execute1AluBypass;
      decode_outInst_rData_ctrl_canInternalyStallWriteBack0 <= decode_outInst_payload_ctrl_canInternalyStallWriteBack0;
      decode_outInst_rData_ctrl_men <= decode_outInst_payload_ctrl_men;
      decode_outInst_rData_ctrl_m <= decode_outInst_payload_ctrl_m;
      decode_outInst_rData_ctrl_msk <= decode_outInst_payload_ctrl_msk;
      decode_outInst_rData_ctrl_csr <= decode_outInst_payload_ctrl_csr;
      decode_outInst_rData_ctrl_mfs <= decode_outInst_payload_ctrl_mfs;
      decode_outInst_rData_ctrl_useSrc0 <= decode_outInst_payload_ctrl_useSrc0;
      decode_outInst_rData_ctrl_useSrc1 <= decode_outInst_payload_ctrl_useSrc1;
      decode_outInst_rData_ctrl_extensionTag <= decode_outInst_payload_ctrl_extensionTag;
      decode_outInst_rData_ctrl_fencei <= decode_outInst_payload_ctrl_fencei;
      decode_outInst_rData_src0 <= decode_outInst_payload_src0;
      decode_outInst_rData_src1 <= decode_outInst_payload_src1;
      decode_outInst_rData_alu_op0 <= decode_outInst_payload_alu_op0;
      decode_outInst_rData_alu_op1 <= decode_outInst_payload_alu_op1;
      decode_outInst_rData_doSub <= decode_outInst_payload_doSub;
      decode_outInst_rData_predictorHasBranch <= decode_outInst_payload_predictorHasBranch;
      decode_outInst_rData_branchHistory_valid <= decode_outInst_payload_branchHistory_valid;
      decode_outInst_rData_branchHistory_payload <= decode_outInst_payload_branchHistory_payload;
    end
    if(execute0_outInst_ready) begin
      execute0_outInst_rData_pc <= execute0_outInst_payload_pc;
      execute0_outInst_rData_instruction <= execute0_outInst_payload_instruction;
      execute0_outInst_rData_ctrl_instVal <= execute0_outInst_payload_ctrl_instVal;
      execute0_outInst_rData_ctrl_br <= execute0_outInst_payload_ctrl_br;
      execute0_outInst_rData_ctrl_jmp <= execute0_outInst_payload_ctrl_jmp;
      execute0_outInst_rData_ctrl_op0 <= execute0_outInst_payload_ctrl_op0;
      execute0_outInst_rData_ctrl_op1 <= execute0_outInst_payload_ctrl_op1;
      execute0_outInst_rData_ctrl_alu <= execute0_outInst_payload_ctrl_alu;
      execute0_outInst_rData_ctrl_wb <= execute0_outInst_payload_ctrl_wb;
      execute0_outInst_rData_ctrl_rfen <= execute0_outInst_payload_ctrl_rfen;
      execute0_outInst_rData_ctrl_execute0AluBypass <= execute0_outInst_payload_ctrl_execute0AluBypass;
      execute0_outInst_rData_ctrl_execute1AluBypass <= execute0_outInst_payload_ctrl_execute1AluBypass;
      execute0_outInst_rData_ctrl_canInternalyStallWriteBack0 <= execute0_outInst_payload_ctrl_canInternalyStallWriteBack0;
      execute0_outInst_rData_ctrl_men <= execute0_outInst_payload_ctrl_men;
      execute0_outInst_rData_ctrl_m <= execute0_outInst_payload_ctrl_m;
      execute0_outInst_rData_ctrl_msk <= execute0_outInst_payload_ctrl_msk;
      execute0_outInst_rData_ctrl_csr <= execute0_outInst_payload_ctrl_csr;
      execute0_outInst_rData_ctrl_mfs <= execute0_outInst_payload_ctrl_mfs;
      execute0_outInst_rData_ctrl_useSrc0 <= execute0_outInst_payload_ctrl_useSrc0;
      execute0_outInst_rData_ctrl_useSrc1 <= execute0_outInst_payload_ctrl_useSrc1;
      execute0_outInst_rData_ctrl_extensionTag <= execute0_outInst_payload_ctrl_extensionTag;
      execute0_outInst_rData_ctrl_fencei <= execute0_outInst_payload_ctrl_fencei;
      execute0_outInst_rData_br_eq <= execute0_outInst_payload_br_eq;
      execute0_outInst_rData_br_ltx <= execute0_outInst_payload_br_ltx;
      execute0_outInst_rData_src1 <= execute0_outInst_payload_src1;
      execute0_outInst_rData_result <= execute0_outInst_payload_result;
      execute0_outInst_rData_adder <= execute0_outInst_payload_adder;
      execute0_outInst_rData_predictorHasBranch <= execute0_outInst_payload_predictorHasBranch;
      execute0_outInst_rData_branchHistory_valid <= execute0_outInst_payload_branchHistory_valid;
      execute0_outInst_rData_branchHistory_payload <= execute0_outInst_payload_branchHistory_payload;
      execute0_outInst_rData_pcPlus4 <= execute0_outInst_payload_pcPlus4;
      execute0_outInst_rData_pc_sel <= execute0_outInst_payload_pc_sel;
      execute0_outInst_rData_unalignedMemoryAccessException <= execute0_outInst_payload_unalignedMemoryAccessException;
      execute0_outInst_rData_needMemRsp <= execute0_outInst_payload_needMemRsp;
      execute0_outInst_rData_dCmdAddress <= execute0_outInst_payload_dCmdAddress;
    end
    if(execute1_outInst_ready) begin
      execute1_outInst_rData_pc <= execute1_outInst_payload_pc;
      execute1_outInst_rData_instruction <= execute1_outInst_payload_instruction;
      execute1_outInst_rData_ctrl_instVal <= execute1_outInst_payload_ctrl_instVal;
      execute1_outInst_rData_ctrl_br <= execute1_outInst_payload_ctrl_br;
      execute1_outInst_rData_ctrl_jmp <= execute1_outInst_payload_ctrl_jmp;
      execute1_outInst_rData_ctrl_op0 <= execute1_outInst_payload_ctrl_op0;
      execute1_outInst_rData_ctrl_op1 <= execute1_outInst_payload_ctrl_op1;
      execute1_outInst_rData_ctrl_alu <= execute1_outInst_payload_ctrl_alu;
      execute1_outInst_rData_ctrl_wb <= execute1_outInst_payload_ctrl_wb;
      execute1_outInst_rData_ctrl_rfen <= execute1_outInst_payload_ctrl_rfen;
      execute1_outInst_rData_ctrl_execute0AluBypass <= execute1_outInst_payload_ctrl_execute0AluBypass;
      execute1_outInst_rData_ctrl_execute1AluBypass <= execute1_outInst_payload_ctrl_execute1AluBypass;
      execute1_outInst_rData_ctrl_canInternalyStallWriteBack0 <= execute1_outInst_payload_ctrl_canInternalyStallWriteBack0;
      execute1_outInst_rData_ctrl_men <= execute1_outInst_payload_ctrl_men;
      execute1_outInst_rData_ctrl_m <= execute1_outInst_payload_ctrl_m;
      execute1_outInst_rData_ctrl_msk <= execute1_outInst_payload_ctrl_msk;
      execute1_outInst_rData_ctrl_csr <= execute1_outInst_payload_ctrl_csr;
      execute1_outInst_rData_ctrl_mfs <= execute1_outInst_payload_ctrl_mfs;
      execute1_outInst_rData_ctrl_useSrc0 <= execute1_outInst_payload_ctrl_useSrc0;
      execute1_outInst_rData_ctrl_useSrc1 <= execute1_outInst_payload_ctrl_useSrc1;
      execute1_outInst_rData_ctrl_extensionTag <= execute1_outInst_payload_ctrl_extensionTag;
      execute1_outInst_rData_ctrl_fencei <= execute1_outInst_payload_ctrl_fencei;
      execute1_outInst_rData_result <= execute1_outInst_payload_result;
      execute1_outInst_rData_regFileAddress <= execute1_outInst_payload_regFileAddress;
      execute1_outInst_rData_pcPlus4 <= execute1_outInst_payload_pcPlus4;
      execute1_outInst_rData_unalignedMemoryAccessException <= execute1_outInst_payload_unalignedMemoryAccessException;
      execute1_outInst_rData_needMemRsp <= execute1_outInst_payload_needMemRsp;
      execute1_outInst_rData_dCmdAddress <= execute1_outInst_payload_dCmdAddress;
    end
    if(writeBack_outInst_ready) begin
      writeBack_outInst_rData_addr <= writeBack_outInst_payload_addr;
      writeBack_outInst_rData_data <= writeBack_outInst_payload_data;
    end
    if(execute0_outInst_ready) begin
      MulExtension_s2_mul_ll <= MulExtension_s1_mul_ll;
    end
    if(execute0_outInst_ready) begin
      MulExtension_s2_mul_lh <= MulExtension_s1_mul_lh;
    end
    if(execute0_outInst_ready) begin
      MulExtension_s2_mul_hl <= MulExtension_s1_mul_hl;
    end
    if(execute0_outInst_ready) begin
      MulExtension_s2_mul_hh <= MulExtension_s1_mul_hh;
    end
    if(execute1_outInst_ready) begin
      MulExtension_s3_low <= MulExtension_s2_low;
    end
    if(execute1_outInst_ready) begin
      MulExtension_s3_mul_hh <= MulExtension_s2_mul_hh;
    end
    DivExtension_rsp <= (execute1_inInst_payload_instruction[13] ? DivExtension_divider_io_rsp_payload_remainder : DivExtension_divider_io_rsp_payload_quotient);
    if(execute0_outInst_ready) begin
      BarrelShifterFullExtension_s2_shiftRight <= BarrelShifterFullExtension_s1_shiftRight;
    end
    if(when_SimpleInterruptExtension_l34) begin
      _zz_SimpleInterrupExtension_irqValue <= writeBack_irq_masked[1];
    end
    if(when_SimpleInterruptExtension_l38) begin
      if(when_SimpleInterruptExtension_l39) begin
        SimpleInterrupExtension_exitPc <= writeBack_inInst_payload_pc;
      end else begin
        if(_zz_7) begin
          if(when_SimpleInterruptExtension_l48) begin
            SimpleInterrupExtension_exitPc <= decode_inInst_payload_pc;
          end
        end
      end
    end
    if(_zz_9) begin
      if(when_DebugExtension_l101) begin
        case(switch_DebugExtension_l102)
          7'h02 : begin
            if(_zz_10) begin
              fetch_outInst_rData_instruction <= _zz_prefetch_pc;
            end
          end
          default : begin
          end
        endcase
      end
    end
  end

  always @(posedge clkout) begin
    _zz_7 <= ((writeBack_irq_masked & (~ 8'h02)) != 8'h0);
  end

  always @(posedge clkout) begin
    DebugExtension_readRegFileReg <= 1'b0;
    DebugExtension_flushIt <= 1'b0;
    iCmd_valid_regNext <= iCmd_valid;
    DebugExtension_isPipActive <= (((((iCmd_valid_regNext || (fetch_pendingPrefetch_value != 2'b00)) || decode_inInst_valid) || execute0_inInst_valid) || execute1_inInst_valid) || writeBack_inInst_valid);
    DebugExtension_isPipActive_regNext <= DebugExtension_isPipActive;
    if(_zz_9) begin
      if(when_DebugExtension_l101) begin
        case(switch_DebugExtension_l102)
          7'h0 : begin
            if(_zz_10) begin
              DebugExtension_flushIt <= _zz_prefetch_pc[2];
            end else begin
              DebugExtension_busReadDataReg[0] <= DebugExtension_resetIt;
              DebugExtension_busReadDataReg[1] <= DebugExtension_haltIt;
              DebugExtension_busReadDataReg[2] <= DebugExtension_isPipBusy;
              DebugExtension_busReadDataReg[3] <= DebugExtension_isInBreakpoint;
              DebugExtension_busReadDataReg[4] <= DebugExtension_stepIt;
              DebugExtension_busReadDataReg[5] <= prefetch_inc;
            end
          end
          7'h01 : begin
            if(!_zz_10) begin
              if(DebugExtension_isInBreakpoint) begin
                DebugExtension_busReadDataReg <= writeBack_inInst_payload_pc;
              end else begin
                DebugExtension_busReadDataReg <= prefetch_pc;
              end
            end
          end
          default : begin
          end
        endcase
      end else begin
        if(!_zz_10) begin
          DebugExtension_readRegFileReg <= 1'b1;
        end
      end
    end
    DebugExtension_resetIt_regNext <= DebugExtension_resetIt;
  end

  always @(posedge clkout or posedge io_debugResetIn) begin
    if(io_debugResetIn) begin
      DebugExtension_resetIt <= 1'b0;
      DebugExtension_haltIt <= 1'b0;
      DebugExtension_stepIt <= 1'b0;
    end else begin
      if(_zz_9) begin
        if(when_DebugExtension_l101) begin
          case(switch_DebugExtension_l102)
            7'h0 : begin
              if(_zz_10) begin
                DebugExtension_stepIt <= _zz_prefetch_pc[4];
                if(when_DebugExtension_l107) begin
                  DebugExtension_resetIt <= 1'b1;
                end
                if(when_DebugExtension_l108) begin
                  DebugExtension_haltIt <= 1'b1;
                end
                if(when_DebugExtension_l109) begin
                  DebugExtension_resetIt <= 1'b0;
                end
                if(when_DebugExtension_l110) begin
                  DebugExtension_haltIt <= 1'b0;
                end
              end
            end
            default : begin
            end
          endcase
        end
      end
      if(when_DebugExtension_l178) begin
        DebugExtension_haltIt <= 1'b1;
      end
    end
  end

  always @(posedge clkout or posedge io_debugResetIn) begin
    if(io_debugResetIn) begin
      decode_inInst_fire_regNext <= 1'b0;
    end else begin
      decode_inInst_fire_regNext <= decode_inInst_fire;
    end
  end


endmodule

//StreamFifo_6 replaced by StreamFifo_4

//StreamFifo_5 replaced by StreamFifo_4

module StreamFifo_4 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  output reg           io_pop_valid,
  input  wire          io_pop_ready,
  input  wire          io_flush,
  output wire [2:0]    io_occupancy,
  output wire [2:0]    io_availability,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg                 logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [2:0]    logic_ptr_push;
  reg        [2:0]    logic_ptr_pop;
  wire       [2:0]    logic_ptr_occupancy;
  wire       [2:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1304;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [1:0]    logic_push_onRam_write_payload_address;
  wire                logic_pop_addressGen_valid;
  wire                logic_pop_addressGen_ready;
  wire       [1:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_addressGen_translated_valid;
  wire                logic_pop_addressGen_translated_ready;

  assign when_Stream_l1304 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 3'b100) == 3'b000);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  always @(*) begin
    logic_ptr_doPush = io_push_fire;
    if(logic_ptr_empty) begin
      if(io_pop_ready) begin
        logic_ptr_doPush = 1'b0;
      end
    end
  end

  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[1:0];
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[1:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  assign logic_pop_addressGen_translated_valid = logic_pop_addressGen_valid;
  assign logic_pop_addressGen_ready = logic_pop_addressGen_translated_ready;
  always @(*) begin
    io_pop_valid = logic_pop_addressGen_translated_valid;
    if(logic_ptr_empty) begin
      io_pop_valid = io_push_valid;
    end
  end

  assign logic_pop_addressGen_translated_ready = io_pop_ready;
  assign logic_ptr_popOnIo = logic_ptr_pop;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (3'b100 - logic_ptr_occupancy);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      logic_ptr_push <= 3'b000;
      logic_ptr_pop <= 3'b000;
      logic_ptr_wentUp <= 1'b0;
    end else begin
      if(when_Stream_l1304) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 3'b001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 3'b001);
      end
      if(io_flush) begin
        logic_ptr_push <= 3'b000;
        logic_ptr_pop <= 3'b000;
      end
    end
  end


endmodule

module PulseCCByToggle (
  input  wire          io_pulseIn,
  output wire          io_pulseOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clkout_1
);

  wire                dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  wire                inArea_target_buffercc_io_dataOut;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg                 inArea_target;
  wire                dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert;
  wire                dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized;
  wire                outArea_target;
  reg                 outArea_target_regNext;

  (* keep_hierarchy = "TRUE" *) BufferCC_11 dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc (
    .io_dataIn          (dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert                    ), //i
    .io_dataOut         (dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .clkout             (clkout_1                                                                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                                                      )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_15 inArea_target_buffercc (
    .io_dataIn                                                 (inArea_target                                            ), //i
    .io_dataOut                                                (inArea_target_buffercc_io_dataOut                        ), //o
    .clkout                                                    (clkout_1                                                 ), //i
    .dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized (dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized)  //i
  );
  assign dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized = dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  assign outArea_target = inArea_target_buffercc_io_dataOut;
  assign io_pulseOut = (outArea_target ^ outArea_target_regNext);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      inArea_target <= 1'b0;
    end else begin
      if(io_pulseIn) begin
        inArea_target <= (! inArea_target);
      end
    end
  end

  always @(posedge clkout_1 or posedge dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
    if(dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
      outArea_target_regNext <= 1'b0;
    end else begin
      outArea_target_regNext <= outArea_target;
    end
  end


endmodule

//BufferCC_35 replaced by BufferCC_16

//BufferCC_34 replaced by BufferCC_16

//BufferCC_33 replaced by BufferCC_16

//BufferCC_32 replaced by BufferCC_16

//BufferCC_31 replaced by BufferCC_6

//BufferCC_30 replaced by BufferCC_6

//BufferCC_29 replaced by BufferCC_16

//BufferCC_28 replaced by BufferCC_16

//BufferCC_27 replaced by BufferCC_19

//BufferCC_26 replaced by BufferCC_19

//BufferCC_25 replaced by BufferCC_19

//BufferCC_24 replaced by BufferCC_19

//BufferCC_23 replaced by BufferCC_16

//BufferCC_22 replaced by BufferCC_19

//BufferCC_21 replaced by BufferCC_19

//BufferCC_20 replaced by BufferCC_19

module BufferCC_19 (
  input  wire [11:0]   io_dataIn,
  output wire [11:0]   io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" *) reg        [11:0]   buffers_0;
  (* async_reg = "true" *) reg        [11:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

//BufferCC_18 replaced by BufferCC_16

//BufferCC_17 replaced by BufferCC_16

module BufferCC_16 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module DVTiming (
  input  wire          io_en,
  input  wire [11:0]   io_cfg_vsync,
  input  wire [11:0]   io_cfg_vback,
  input  wire [11:0]   io_cfg_vdisp,
  input  wire [11:0]   io_cfg_vtotal,
  input  wire [11:0]   io_cfg_hsync,
  input  wire [11:0]   io_cfg_hback,
  input  wire [11:0]   io_cfg_hdisp,
  input  wire [11:0]   io_cfg_htotal,
  input  wire          io_cfg_vspol,
  input  wire          io_cfg_hspol,
  input  wire          io_cfg_depol,
  input  wire          io_cfg_pcpol,
  input  wire          io_pixel_valid,
  output wire          io_pixel_ready,
  input  wire [15:0]   io_pixel_payload,
  output wire [15:0]   io_pos_x,
  output wire [15:0]   io_pos_y,
  output wire          io_dvti_vs,
  output wire          io_dvti_hs,
  output wire          io_dvti_de,
  output wire [15:0]   io_dvti_data,
  output wire          io_hen,
  output wire          io_ven,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  wire                dvtArea_en;
  reg        [11:0]   dvtArea_hCnt;
  reg        [11:0]   dvtArea_vCnt;
  wire                when_Apb3Dvtc_l118;
  wire                when_Apb3Dvtc_l120;

  assign dvtArea_en = (io_hen && io_ven);
  assign io_hen = ((io_cfg_hback <= dvtArea_hCnt) && (dvtArea_hCnt < io_cfg_hdisp));
  assign io_ven = ((io_cfg_vback <= dvtArea_vCnt) && (dvtArea_vCnt < io_cfg_vdisp));
  assign when_Apb3Dvtc_l118 = (dvtArea_hCnt == io_cfg_htotal);
  assign when_Apb3Dvtc_l120 = (dvtArea_vCnt == io_cfg_vtotal);
  assign io_dvti_data = io_pixel_payload;
  assign io_dvti_vs = (((dvtArea_vCnt <= io_cfg_vsync) ^ io_cfg_vspol) && io_en);
  assign io_dvti_hs = (((dvtArea_hCnt <= io_cfg_hsync) ^ io_cfg_hspol) && io_en);
  assign io_dvti_de = ((dvtArea_en ^ io_cfg_depol) && io_en);
  assign io_pos_x = {4'd0, dvtArea_hCnt};
  assign io_pos_y = {4'd0, dvtArea_vCnt};
  assign io_pixel_ready = (dvtArea_en || (! io_en));
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      dvtArea_hCnt <= 12'h0;
      dvtArea_vCnt <= 12'h0;
    end else begin
      if(io_en) begin
        if(when_Apb3Dvtc_l118) begin
          dvtArea_hCnt <= 12'h0;
          if(when_Apb3Dvtc_l120) begin
            dvtArea_vCnt <= 12'h0;
          end else begin
            dvtArea_vCnt <= (dvtArea_vCnt + 12'h001);
          end
        end else begin
          dvtArea_hCnt <= (dvtArea_hCnt + 12'h001);
        end
      end else begin
        dvtArea_hCnt <= 12'h0;
        dvtArea_vCnt <= 12'h0;
      end
    end
  end


endmodule

module VideoDma (
  input  wire          io_start,
  output wire          io_busy,
  input  wire [26:0]   io_base,
  input  wire [17:0]   io_size,
  output reg           io_mem_cmd_valid,
  input  wire          io_mem_cmd_ready,
  output wire [26:0]   io_mem_cmd_payload,
  input  wire          io_mem_rsp_valid,
  input  wire          io_mem_rsp_payload_last,
  input  wire [31:0]   io_mem_rsp_payload_fragment,
  output wire          io_frame_valid,
  input  wire          io_frame_ready,
  output wire          io_frame_payload_last,
  output wire [15:0]   io_frame_payload_fragment,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clkout_1
);

  wire                rspArea_fifo_io_push_ready;
  wire                rspArea_fifo_io_pop_valid;
  wire                rspArea_fifo_io_pop_payload_last;
  wire       [31:0]   rspArea_fifo_io_pop_payload_fragment;
  wire       [9:0]    rspArea_fifo_io_pushOccupancy;
  wire       [9:0]    rspArea_fifo_io_popOccupancy;
  wire       [6:0]    rspArea_frameClockArea_popCmdGray_buffercc_io_dataOut;
  wire       [26:0]   _zz_io_mem_cmd_payload;
  wire       [2:0]    _zz_rspArea_frameClockArea_popBeatCounter_valueNext;
  wire       [0:0]    _zz_rspArea_frameClockArea_popBeatCounter_valueNext_1;
  reg        [15:0]   _zz_io_frame_payload_fragment_1;
  reg        [5:0]    _zz_pendingMemRsp;
  reg        [5:0]    _zz_pendingMemRsp_1;
  wire                io_mem_cmd_fire;
  wire                when_Utils_l719;
  reg                 pendingMemCmd_incrementIt;
  reg                 pendingMemCmd_decrementIt;
  wire       [2:0]    pendingMemCmd_valueNext;
  reg        [2:0]    pendingMemCmd_value;
  wire                pendingMemCmd_mayOverflow;
  wire                pendingMemCmd_mayUnderflow;
  wire                pendingMemCmd_willOverflowIfInc;
  wire                pendingMemCmd_willOverflow;
  wire                pendingMemCmd_willUnderflowIfDec;
  wire                pendingMemCmd_willUnderflow;
  reg        [2:0]    pendingMemCmd_finalIncrement;
  wire                when_Utils_l751;
  wire                when_Utils_l753;
  reg        [5:0]    pendingMemRsp;
  wire       [5:0]    _zz_pendingMemRsp_2;
  wire                toManyPendingCmd;
  wire                toManyPendingRsp;
  reg                 isActive;
  reg                 cmdActive;
  reg        [17:0]   memCmdCounter;
  wire                memCmdLast;
  wire                when_VideoDma_l94;
  wire                when_VideoDma_l102;
  wire                when_VideoDma_l104;
  wire                when_VideoDma_l108;
  wire                memRsp_valid;
  wire                memRsp_payload_last;
  wire       [31:0]   memRsp_payload_fragment;
  wire                fifoPop_valid;
  wire                fifoPop_ready;
  wire                fifoPop_payload_last;
  wire       [31:0]   fifoPop_payload_fragment;
  wire                memRsp_toStream_valid;
  wire                memRsp_toStream_ready;
  wire                memRsp_toStream_payload_last;
  wire       [31:0]   memRsp_toStream_payload_fragment;
  reg                 rspArea_frameClockArea_popBeatCounter_willIncrement;
  wire                rspArea_frameClockArea_popBeatCounter_willClear;
  reg        [2:0]    rspArea_frameClockArea_popBeatCounter_valueNext;
  reg        [2:0]    rspArea_frameClockArea_popBeatCounter_value;
  wire                rspArea_frameClockArea_popBeatCounter_willOverflowIfInc;
  wire                rspArea_frameClockArea_popBeatCounter_willOverflow;
  wire                rspArea_fifo_io_pop_fire;
  reg        [6:0]    rspArea_frameClockArea_popCmdGray;
  reg                 _zz_when_Utils_l452;
  wire       [6:0]    _zz_when_Utils_l452_1;
  reg                 _zz_when_Utils_l452_2;
  reg                 _zz_when_Utils_l452_3;
  reg                 _zz_when_Utils_l452_4;
  reg                 _zz_when_Utils_l452_5;
  reg                 _zz_when_Utils_l452_6;
  reg                 _zz_when_Utils_l452_7;
  wire                when_Utils_l452;
  wire                when_Utils_l452_1;
  wire                when_Utils_l452_2;
  wire                when_Utils_l452_3;
  wire                when_Utils_l452_4;
  wire                when_Utils_l452_5;
  wire                when_Utils_l452_6;
  wire       [6:0]    rspArea_popCmdGray;
  reg        [6:0]    rspArea_pushCmdGray;
  reg                 _zz_when_Utils_l452_8;
  wire       [6:0]    _zz_when_Utils_l452_9;
  reg                 _zz_when_Utils_l452_10;
  reg                 _zz_when_Utils_l452_11;
  reg                 _zz_when_Utils_l452_12;
  reg                 _zz_when_Utils_l452_13;
  reg                 _zz_when_Utils_l452_14;
  reg                 _zz_when_Utils_l452_15;
  wire                when_Utils_l452_7;
  wire                when_Utils_l452_8;
  wire                when_Utils_l452_9;
  wire                when_Utils_l452_10;
  wire                when_Utils_l452_11;
  wire                when_Utils_l452_12;
  wire                when_Utils_l452_13;
  wire                io_frame_fire;
  reg                 fifoPop_widthAdapter_counter_willIncrement;
  wire                fifoPop_widthAdapter_counter_willClear;
  reg        [0:0]    fifoPop_widthAdapter_counter_valueNext;
  reg        [0:0]    fifoPop_widthAdapter_counter_value;
  wire                fifoPop_widthAdapter_counter_willOverflowIfInc;
  wire                fifoPop_widthAdapter_counter_willOverflow;
  wire       [31:0]   _zz_io_frame_payload_fragment;

  assign _zz_io_mem_cmd_payload = {9'd0, memCmdCounter};
  assign _zz_rspArea_frameClockArea_popBeatCounter_valueNext_1 = rspArea_frameClockArea_popBeatCounter_willIncrement;
  assign _zz_rspArea_frameClockArea_popBeatCounter_valueNext = {2'd0, _zz_rspArea_frameClockArea_popBeatCounter_valueNext_1};
  StreamFifoCC_2 rspArea_fifo (
    .io_push_valid            (memRsp_toStream_valid                     ), //i
    .io_push_ready            (rspArea_fifo_io_push_ready                ), //o
    .io_push_payload_last     (memRsp_toStream_payload_last              ), //i
    .io_push_payload_fragment (memRsp_toStream_payload_fragment[31:0]    ), //i
    .io_pop_valid             (rspArea_fifo_io_pop_valid                 ), //o
    .io_pop_ready             (fifoPop_ready                             ), //i
    .io_pop_payload_last      (rspArea_fifo_io_pop_payload_last          ), //o
    .io_pop_payload_fragment  (rspArea_fifo_io_pop_payload_fragment[31:0]), //o
    .io_pushOccupancy         (rspArea_fifo_io_pushOccupancy[9:0]        ), //o
    .io_popOccupancy          (rspArea_fifo_io_popOccupancy[9:0]         ), //o
    .clkout                   (clkout                                    ), //i
    .resetCtrl_axiReset       (resetCtrl_axiReset                        ), //i
    .clkout_1                 (clkout_1                                  )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 rspArea_frameClockArea_popCmdGray_buffercc (
    .io_dataIn          (rspArea_frameClockArea_popCmdGray[6:0]                    ), //i
    .io_dataOut         (rspArea_frameClockArea_popCmdGray_buffercc_io_dataOut[6:0]), //o
    .clkout             (clkout                                                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                        )  //i
  );
  always @(*) begin
    case(fifoPop_widthAdapter_counter_value)
      1'b0 : _zz_io_frame_payload_fragment_1 = _zz_io_frame_payload_fragment[15 : 0];
      default : _zz_io_frame_payload_fragment_1 = _zz_io_frame_payload_fragment[31 : 16];
    endcase
  end

  always @(*) begin
    _zz_pendingMemRsp = _zz_pendingMemRsp_1;
    if(io_mem_rsp_valid) begin
      _zz_pendingMemRsp = (_zz_pendingMemRsp_1 - 6'h01);
    end
  end

  always @(*) begin
    _zz_pendingMemRsp_1 = _zz_pendingMemRsp_2;
    if(io_mem_cmd_fire) begin
      _zz_pendingMemRsp_1 = (_zz_pendingMemRsp_2 + 6'h08);
    end
  end

  assign io_mem_cmd_fire = (io_mem_cmd_valid && io_mem_cmd_ready);
  assign when_Utils_l719 = (io_mem_rsp_valid && io_mem_rsp_payload_last);
  always @(*) begin
    pendingMemCmd_incrementIt = 1'b0;
    if(io_mem_cmd_fire) begin
      pendingMemCmd_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingMemCmd_decrementIt = 1'b0;
    if(when_Utils_l719) begin
      pendingMemCmd_decrementIt = 1'b1;
    end
  end

  assign pendingMemCmd_mayOverflow = (pendingMemCmd_value == 3'b111);
  assign pendingMemCmd_mayUnderflow = (pendingMemCmd_value == 3'b000);
  assign pendingMemCmd_willOverflowIfInc = (pendingMemCmd_mayOverflow && (! pendingMemCmd_decrementIt));
  assign pendingMemCmd_willOverflow = (pendingMemCmd_willOverflowIfInc && pendingMemCmd_incrementIt);
  assign pendingMemCmd_willUnderflowIfDec = (pendingMemCmd_mayUnderflow && (! pendingMemCmd_incrementIt));
  assign pendingMemCmd_willUnderflow = (pendingMemCmd_willUnderflowIfDec && pendingMemCmd_decrementIt);
  assign when_Utils_l751 = (pendingMemCmd_incrementIt && (! pendingMemCmd_decrementIt));
  always @(*) begin
    if(when_Utils_l751) begin
      pendingMemCmd_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l753) begin
        pendingMemCmd_finalIncrement = 3'b111;
      end else begin
        pendingMemCmd_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l753 = ((! pendingMemCmd_incrementIt) && pendingMemCmd_decrementIt);
  assign pendingMemCmd_valueNext = (pendingMemCmd_value + pendingMemCmd_finalIncrement);
  assign _zz_pendingMemRsp_2 = pendingMemRsp;
  assign toManyPendingCmd = (3'b110 < pendingMemCmd_value);
  assign io_busy = isActive;
  assign memCmdLast = (memCmdCounter == io_size);
  always @(*) begin
    io_mem_cmd_valid = 1'b0;
    if(!when_VideoDma_l94) begin
      if(cmdActive) begin
        if(when_VideoDma_l102) begin
          io_mem_cmd_valid = 1'b1;
        end
      end
    end
  end

  assign io_mem_cmd_payload = (io_base + _zz_io_mem_cmd_payload);
  assign when_VideoDma_l94 = (! isActive);
  assign when_VideoDma_l102 = ((! toManyPendingCmd) && (! toManyPendingRsp));
  assign when_VideoDma_l104 = (memCmdLast && io_mem_cmd_ready);
  assign when_VideoDma_l108 = (pendingMemRsp == 6'h0);
  assign memRsp_valid = io_mem_rsp_valid;
  assign memRsp_payload_last = ((! cmdActive) && (pendingMemRsp == 6'h01));
  assign memRsp_payload_fragment = io_mem_rsp_payload_fragment;
  assign memRsp_toStream_valid = memRsp_valid;
  assign memRsp_toStream_payload_last = memRsp_payload_last;
  assign memRsp_toStream_payload_fragment = memRsp_payload_fragment;
  assign memRsp_toStream_ready = rspArea_fifo_io_push_ready;
  assign fifoPop_valid = rspArea_fifo_io_pop_valid;
  assign fifoPop_payload_last = rspArea_fifo_io_pop_payload_last;
  assign fifoPop_payload_fragment = rspArea_fifo_io_pop_payload_fragment;
  always @(*) begin
    rspArea_frameClockArea_popBeatCounter_willIncrement = 1'b0;
    if(rspArea_fifo_io_pop_fire) begin
      rspArea_frameClockArea_popBeatCounter_willIncrement = 1'b1;
    end
  end

  assign rspArea_frameClockArea_popBeatCounter_willClear = 1'b0;
  assign rspArea_frameClockArea_popBeatCounter_willOverflowIfInc = (rspArea_frameClockArea_popBeatCounter_value == 3'b111);
  assign rspArea_frameClockArea_popBeatCounter_willOverflow = (rspArea_frameClockArea_popBeatCounter_willOverflowIfInc && rspArea_frameClockArea_popBeatCounter_willIncrement);
  always @(*) begin
    rspArea_frameClockArea_popBeatCounter_valueNext = (rspArea_frameClockArea_popBeatCounter_value + _zz_rspArea_frameClockArea_popBeatCounter_valueNext);
    if(rspArea_frameClockArea_popBeatCounter_willClear) begin
      rspArea_frameClockArea_popBeatCounter_valueNext = 3'b000;
    end
  end

  assign rspArea_fifo_io_pop_fire = (rspArea_fifo_io_pop_valid && fifoPop_ready);
  assign _zz_when_Utils_l452_1 = {1'b1,{rspArea_frameClockArea_popCmdGray[4 : 0],_zz_when_Utils_l452}};
  always @(*) begin
    _zz_when_Utils_l452_2 = _zz_when_Utils_l452_3;
    if(when_Utils_l452_5) begin
      _zz_when_Utils_l452_2 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_3 = _zz_when_Utils_l452_4;
    if(when_Utils_l452_4) begin
      _zz_when_Utils_l452_3 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_4 = _zz_when_Utils_l452_5;
    if(when_Utils_l452_3) begin
      _zz_when_Utils_l452_4 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_5 = _zz_when_Utils_l452_6;
    if(when_Utils_l452_2) begin
      _zz_when_Utils_l452_5 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_6 = _zz_when_Utils_l452_7;
    if(when_Utils_l452_1) begin
      _zz_when_Utils_l452_6 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_7 = 1'b0;
    if(when_Utils_l452) begin
      _zz_when_Utils_l452_7 = 1'b1;
    end
  end

  assign when_Utils_l452 = (_zz_when_Utils_l452_1[0] && (! 1'b0));
  assign when_Utils_l452_1 = (_zz_when_Utils_l452_1[1] && (! _zz_when_Utils_l452_7));
  assign when_Utils_l452_2 = (_zz_when_Utils_l452_1[2] && (! _zz_when_Utils_l452_6));
  assign when_Utils_l452_3 = (_zz_when_Utils_l452_1[3] && (! _zz_when_Utils_l452_5));
  assign when_Utils_l452_4 = (_zz_when_Utils_l452_1[4] && (! _zz_when_Utils_l452_4));
  assign when_Utils_l452_5 = (_zz_when_Utils_l452_1[5] && (! _zz_when_Utils_l452_3));
  assign when_Utils_l452_6 = (_zz_when_Utils_l452_1[6] && (! _zz_when_Utils_l452_2));
  assign rspArea_popCmdGray = rspArea_frameClockArea_popCmdGray_buffercc_io_dataOut;
  assign _zz_when_Utils_l452_9 = {1'b1,{rspArea_pushCmdGray[4 : 0],_zz_when_Utils_l452_8}};
  always @(*) begin
    _zz_when_Utils_l452_10 = _zz_when_Utils_l452_11;
    if(when_Utils_l452_12) begin
      _zz_when_Utils_l452_10 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_11 = _zz_when_Utils_l452_12;
    if(when_Utils_l452_11) begin
      _zz_when_Utils_l452_11 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_12 = _zz_when_Utils_l452_13;
    if(when_Utils_l452_10) begin
      _zz_when_Utils_l452_12 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_13 = _zz_when_Utils_l452_14;
    if(when_Utils_l452_9) begin
      _zz_when_Utils_l452_13 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_14 = _zz_when_Utils_l452_15;
    if(when_Utils_l452_8) begin
      _zz_when_Utils_l452_14 = 1'b1;
    end
  end

  always @(*) begin
    _zz_when_Utils_l452_15 = 1'b0;
    if(when_Utils_l452_7) begin
      _zz_when_Utils_l452_15 = 1'b1;
    end
  end

  assign when_Utils_l452_7 = (_zz_when_Utils_l452_9[0] && (! 1'b0));
  assign when_Utils_l452_8 = (_zz_when_Utils_l452_9[1] && (! _zz_when_Utils_l452_15));
  assign when_Utils_l452_9 = (_zz_when_Utils_l452_9[2] && (! _zz_when_Utils_l452_14));
  assign when_Utils_l452_10 = (_zz_when_Utils_l452_9[3] && (! _zz_when_Utils_l452_13));
  assign when_Utils_l452_11 = (_zz_when_Utils_l452_9[4] && (! _zz_when_Utils_l452_12));
  assign when_Utils_l452_12 = (_zz_when_Utils_l452_9[5] && (! _zz_when_Utils_l452_11));
  assign when_Utils_l452_13 = (_zz_when_Utils_l452_9[6] && (! _zz_when_Utils_l452_10));
  assign toManyPendingRsp = ((rspArea_pushCmdGray[6 : 5] == (~ rspArea_popCmdGray[6 : 5])) && (rspArea_pushCmdGray[4 : 0] == rspArea_popCmdGray[4 : 0]));
  assign io_frame_fire = (io_frame_valid && io_frame_ready);
  always @(*) begin
    fifoPop_widthAdapter_counter_willIncrement = 1'b0;
    if(io_frame_fire) begin
      fifoPop_widthAdapter_counter_willIncrement = 1'b1;
    end
  end

  assign fifoPop_widthAdapter_counter_willClear = 1'b0;
  assign fifoPop_widthAdapter_counter_willOverflowIfInc = (fifoPop_widthAdapter_counter_value == 1'b1);
  assign fifoPop_widthAdapter_counter_willOverflow = (fifoPop_widthAdapter_counter_willOverflowIfInc && fifoPop_widthAdapter_counter_willIncrement);
  always @(*) begin
    fifoPop_widthAdapter_counter_valueNext = (fifoPop_widthAdapter_counter_value + fifoPop_widthAdapter_counter_willIncrement);
    if(fifoPop_widthAdapter_counter_willClear) begin
      fifoPop_widthAdapter_counter_valueNext = 1'b0;
    end
  end

  assign io_frame_valid = fifoPop_valid;
  assign _zz_io_frame_payload_fragment = fifoPop_payload_fragment;
  assign io_frame_payload_fragment = _zz_io_frame_payload_fragment_1;
  assign io_frame_payload_last = (fifoPop_payload_last && fifoPop_widthAdapter_counter_willOverflowIfInc);
  assign fifoPop_ready = (io_frame_ready && fifoPop_widthAdapter_counter_willOverflowIfInc);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      pendingMemCmd_value <= 3'b000;
      pendingMemRsp <= 6'h0;
      isActive <= 1'b0;
      cmdActive <= 1'b0;
      rspArea_pushCmdGray <= 7'h0;
      _zz_when_Utils_l452_8 <= 1'b1;
    end else begin
      pendingMemCmd_value <= pendingMemCmd_valueNext;
      pendingMemRsp <= _zz_pendingMemRsp;
      if(when_VideoDma_l94) begin
        if(io_start) begin
          isActive <= 1'b1;
          cmdActive <= 1'b1;
        end
      end else begin
        if(cmdActive) begin
          if(when_VideoDma_l102) begin
            if(when_VideoDma_l104) begin
              cmdActive <= 1'b0;
            end
          end
        end else begin
          if(when_VideoDma_l108) begin
            isActive <= 1'b0;
          end
        end
      end
      if(io_mem_cmd_fire) begin
        if(when_Utils_l452_7) begin
          rspArea_pushCmdGray[0] <= (! rspArea_pushCmdGray[0]);
        end
        if(when_Utils_l452_8) begin
          rspArea_pushCmdGray[1] <= (! rspArea_pushCmdGray[1]);
        end
        if(when_Utils_l452_9) begin
          rspArea_pushCmdGray[2] <= (! rspArea_pushCmdGray[2]);
        end
        if(when_Utils_l452_10) begin
          rspArea_pushCmdGray[3] <= (! rspArea_pushCmdGray[3]);
        end
        if(when_Utils_l452_11) begin
          rspArea_pushCmdGray[4] <= (! rspArea_pushCmdGray[4]);
        end
        if(when_Utils_l452_12) begin
          rspArea_pushCmdGray[5] <= (! rspArea_pushCmdGray[5]);
        end
        if(when_Utils_l452_13) begin
          rspArea_pushCmdGray[6] <= (! rspArea_pushCmdGray[6]);
        end
        _zz_when_Utils_l452_8 <= (! _zz_when_Utils_l452_8);
      end
    end
  end

  always @(posedge clkout) begin
    if(when_VideoDma_l94) begin
      if(io_start) begin
        memCmdCounter <= 18'h0;
      end
    end
    if(io_mem_cmd_fire) begin
      memCmdCounter <= (memCmdCounter + 18'h00001);
    end
  end

  always @(posedge clkout_1 or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      rspArea_frameClockArea_popBeatCounter_value <= 3'b000;
      rspArea_frameClockArea_popCmdGray <= 7'h0;
      _zz_when_Utils_l452 <= 1'b1;
      fifoPop_widthAdapter_counter_value <= 1'b0;
    end else begin
      rspArea_frameClockArea_popBeatCounter_value <= rspArea_frameClockArea_popBeatCounter_valueNext;
      if(rspArea_frameClockArea_popBeatCounter_willOverflow) begin
        if(when_Utils_l452) begin
          rspArea_frameClockArea_popCmdGray[0] <= (! rspArea_frameClockArea_popCmdGray[0]);
        end
        if(when_Utils_l452_1) begin
          rspArea_frameClockArea_popCmdGray[1] <= (! rspArea_frameClockArea_popCmdGray[1]);
        end
        if(when_Utils_l452_2) begin
          rspArea_frameClockArea_popCmdGray[2] <= (! rspArea_frameClockArea_popCmdGray[2]);
        end
        if(when_Utils_l452_3) begin
          rspArea_frameClockArea_popCmdGray[3] <= (! rspArea_frameClockArea_popCmdGray[3]);
        end
        if(when_Utils_l452_4) begin
          rspArea_frameClockArea_popCmdGray[4] <= (! rspArea_frameClockArea_popCmdGray[4]);
        end
        if(when_Utils_l452_5) begin
          rspArea_frameClockArea_popCmdGray[5] <= (! rspArea_frameClockArea_popCmdGray[5]);
        end
        if(when_Utils_l452_6) begin
          rspArea_frameClockArea_popCmdGray[6] <= (! rspArea_frameClockArea_popCmdGray[6]);
        end
        _zz_when_Utils_l452 <= (! _zz_when_Utils_l452);
      end
      fifoPop_widthAdapter_counter_value <= fifoPop_widthAdapter_counter_valueNext;
    end
  end


endmodule

//StreamFifo_3 replaced by StreamFifo

//StreamFifo_2 replaced by StreamFifo

//UartCtrlRx_1 replaced by UartCtrlRx

//UartCtrlTx_1 replaced by UartCtrlTx

//StreamFifo_1 replaced by StreamFifo

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [8:0]    io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [8:0]    io_pop_payload,
  input  wire          io_flush,
  output wire [4:0]    io_occupancy,
  output wire [4:0]    io_availability,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  reg        [8:0]    logic_ram_spinal_port1;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [4:0]    logic_ptr_push;
  reg        [4:0]    logic_ptr_pop;
  wire       [4:0]    logic_ptr_occupancy;
  wire       [4:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1304;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [3:0]    logic_push_onRam_write_payload_address;
  wire       [8:0]    logic_push_onRam_write_payload_data;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [3:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [3:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [3:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l399;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [3:0]    logic_pop_sync_readPort_cmd_payload;
  wire       [8:0]    logic_pop_sync_readPort_rsp;
  wire                logic_pop_addressGen_toFlowFire_valid;
  wire       [3:0]    logic_pop_addressGen_toFlowFire_payload;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [8:0]    logic_pop_sync_readArbitation_translated_payload;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [4:0]    logic_pop_sync_popReg;
  reg [8:0] logic_ram [0:15];

  always @(posedge clkout) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
    end
  end

  always @(posedge clkout) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1304 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 5'h10) == 5'h0);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[3:0];
  assign logic_push_onRam_write_payload_data = io_push_payload;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[3:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l399) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign logic_pop_sync_readPort_rsp = logic_ram_spinal_port1;
  assign logic_pop_addressGen_toFlowFire_valid = logic_pop_addressGen_fire;
  assign logic_pop_addressGen_toFlowFire_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_toFlowFire_valid;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_toFlowFire_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload = logic_pop_sync_readPort_rsp;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload = logic_pop_sync_readArbitation_translated_payload;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (5'h10 - logic_ptr_occupancy);
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      logic_ptr_push <= 5'h0;
      logic_ptr_pop <= 5'h0;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 5'h0;
    end else begin
      if(when_Stream_l1304) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 5'h01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 5'h01);
      end
      if(io_flush) begin
        logic_ptr_push <= 5'h0;
        logic_ptr_pop <= 5'h0;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 5'h0;
      end
    end
  end

  always @(posedge clkout) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module UartCtrlRx (
  input  wire [3:0]    io_configFrame_dataLength,
  input  wire [0:0]    io_configFrame_stop,
  input  wire [1:0]    io_configFrame_parity,
  input  wire          io_samplingTick,
  output wire          io_read_valid,
  input  wire          io_read_ready,
  output wire [8:0]    io_read_payload,
  input  wire          io_rxd,
  output wire          io_rts,
  output reg           io_error,
  output wire          io_break,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;
  localparam UartCtrlRxState_IDLE = 3'd0;
  localparam UartCtrlRxState_START = 3'd1;
  localparam UartCtrlRxState_DATA = 3'd2;
  localparam UartCtrlRxState_PARITY = 3'd3;
  localparam UartCtrlRxState_STOP = 3'd4;

  wire                io_rxd_buffercc_io_dataOut;
  wire       [3:0]    _zz_when_UartCtrlRx_l139;
  wire       [0:0]    _zz_when_UartCtrlRx_l139_1;
  reg                 _zz_io_rts;
  wire                sampler_synchroniser;
  wire                sampler_samples_0;
  reg                 sampler_samples_1;
  reg                 sampler_samples_2;
  reg                 sampler_value;
  reg                 sampler_tick;
  reg        [2:0]    bitTimer_counter;
  reg                 bitTimer_tick;
  wire                when_UartCtrlRx_l43;
  reg        [3:0]    bitCounter_value;
  reg        [6:0]    break_counter;
  wire                break_valid;
  wire                when_UartCtrlRx_l69;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg        [8:0]    stateMachine_shifter;
  reg                 stateMachine_validReg;
  wire                when_UartCtrlRx_l93;
  wire                when_UartCtrlRx_l103;
  wire                when_UartCtrlRx_l111;
  wire                when_UartCtrlRx_l113;
  wire                when_UartCtrlRx_l125;
  wire                when_UartCtrlRx_l136;
  wire                when_UartCtrlRx_l139;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_when_UartCtrlRx_l139_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_UartCtrlRx_l139 = {3'd0, _zz_when_UartCtrlRx_l139_1};
  (* keep_hierarchy = "TRUE" *) BufferCC_8 io_rxd_buffercc (
    .io_dataIn          (io_rxd                    ), //i
    .io_dataOut         (io_rxd_buffercc_io_dataOut), //o
    .clkout             (clkout                    ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset        )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      UartStopType_ONE : io_configFrame_stop_string = "ONE";
      UartStopType_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      UartParityType_NONE : io_configFrame_parity_string = "NONE";
      UartParityType_EVEN : io_configFrame_parity_string = "EVEN";
      UartParityType_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      UartCtrlRxState_IDLE : stateMachine_state_string = "IDLE  ";
      UartCtrlRxState_START : stateMachine_state_string = "START ";
      UartCtrlRxState_DATA : stateMachine_state_string = "DATA  ";
      UartCtrlRxState_PARITY : stateMachine_state_string = "PARITY";
      UartCtrlRxState_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    io_error = 1'b0;
    case(stateMachine_state)
      UartCtrlRxState_IDLE : begin
      end
      UartCtrlRxState_START : begin
      end
      UartCtrlRxState_DATA : begin
      end
      UartCtrlRxState_PARITY : begin
        if(bitTimer_tick) begin
          if(!when_UartCtrlRx_l125) begin
            io_error = 1'b1;
          end
        end
      end
      default : begin
        if(bitTimer_tick) begin
          if(when_UartCtrlRx_l136) begin
            io_error = 1'b1;
          end
        end
      end
    endcase
  end

  assign io_rts = _zz_io_rts;
  assign sampler_synchroniser = io_rxd_buffercc_io_dataOut;
  assign sampler_samples_0 = sampler_synchroniser;
  always @(*) begin
    bitTimer_tick = 1'b0;
    if(sampler_tick) begin
      if(when_UartCtrlRx_l43) begin
        bitTimer_tick = 1'b1;
      end
    end
  end

  assign when_UartCtrlRx_l43 = (bitTimer_counter == 3'b000);
  assign break_valid = (break_counter == 7'h41);
  assign when_UartCtrlRx_l69 = (io_samplingTick && (! break_valid));
  assign io_break = break_valid;
  assign io_read_valid = stateMachine_validReg;
  assign when_UartCtrlRx_l93 = ((sampler_tick && (! sampler_value)) && (! break_valid));
  assign when_UartCtrlRx_l103 = (sampler_value == 1'b1);
  assign when_UartCtrlRx_l111 = (bitCounter_value == io_configFrame_dataLength);
  assign when_UartCtrlRx_l113 = (io_configFrame_parity == UartParityType_NONE);
  assign when_UartCtrlRx_l125 = (stateMachine_parity == sampler_value);
  assign when_UartCtrlRx_l136 = (! sampler_value);
  assign when_UartCtrlRx_l139 = (bitCounter_value == _zz_when_UartCtrlRx_l139);
  assign io_read_payload = stateMachine_shifter;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      _zz_io_rts <= 1'b0;
      sampler_samples_1 <= 1'b1;
      sampler_samples_2 <= 1'b1;
      sampler_value <= 1'b1;
      sampler_tick <= 1'b0;
      break_counter <= 7'h0;
      stateMachine_state <= UartCtrlRxState_IDLE;
      stateMachine_validReg <= 1'b0;
    end else begin
      _zz_io_rts <= (! io_read_ready);
      if(io_samplingTick) begin
        sampler_samples_1 <= sampler_samples_0;
      end
      if(io_samplingTick) begin
        sampler_samples_2 <= sampler_samples_1;
      end
      sampler_value <= (((1'b0 || ((1'b1 && sampler_samples_0) && sampler_samples_1)) || ((1'b1 && sampler_samples_0) && sampler_samples_2)) || ((1'b1 && sampler_samples_1) && sampler_samples_2));
      sampler_tick <= io_samplingTick;
      if(sampler_value) begin
        break_counter <= 7'h0;
      end else begin
        if(when_UartCtrlRx_l69) begin
          break_counter <= (break_counter + 7'h01);
        end
      end
      stateMachine_validReg <= 1'b0;
      case(stateMachine_state)
        UartCtrlRxState_IDLE : begin
          if(when_UartCtrlRx_l93) begin
            stateMachine_state <= UartCtrlRxState_START;
          end
        end
        UartCtrlRxState_START : begin
          if(bitTimer_tick) begin
            stateMachine_state <= UartCtrlRxState_DATA;
            if(when_UartCtrlRx_l103) begin
              stateMachine_state <= UartCtrlRxState_IDLE;
            end
          end
        end
        UartCtrlRxState_DATA : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l111) begin
              if(when_UartCtrlRx_l113) begin
                stateMachine_state <= UartCtrlRxState_STOP;
                stateMachine_validReg <= 1'b1;
              end else begin
                stateMachine_state <= UartCtrlRxState_PARITY;
              end
            end
          end
        end
        UartCtrlRxState_PARITY : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l125) begin
              stateMachine_state <= UartCtrlRxState_STOP;
              stateMachine_validReg <= 1'b1;
            end else begin
              stateMachine_state <= UartCtrlRxState_IDLE;
            end
          end
        end
        default : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l136) begin
              stateMachine_state <= UartCtrlRxState_IDLE;
            end else begin
              if(when_UartCtrlRx_l139) begin
                stateMachine_state <= UartCtrlRxState_IDLE;
              end
            end
          end
        end
      endcase
    end
  end

  always @(posedge clkout) begin
    if(sampler_tick) begin
      bitTimer_counter <= (bitTimer_counter - 3'b001);
      if(when_UartCtrlRx_l43) begin
        bitTimer_counter <= 3'b100;
      end
    end
    if(bitTimer_tick) begin
      bitCounter_value <= (bitCounter_value + 4'b0001);
    end
    if(bitTimer_tick) begin
      stateMachine_parity <= (stateMachine_parity ^ sampler_value);
    end
    case(stateMachine_state)
      UartCtrlRxState_IDLE : begin
        if(when_UartCtrlRx_l93) begin
          bitTimer_counter <= 3'b001;
        end
      end
      UartCtrlRxState_START : begin
        if(bitTimer_tick) begin
          bitCounter_value <= 4'b0000;
          stateMachine_parity <= (io_configFrame_parity == UartParityType_ODD);
        end
      end
      UartCtrlRxState_DATA : begin
        if(bitTimer_tick) begin
          stateMachine_shifter[bitCounter_value] <= sampler_value;
          if(when_UartCtrlRx_l111) begin
            bitCounter_value <= 4'b0000;
          end
        end
      end
      UartCtrlRxState_PARITY : begin
        if(bitTimer_tick) begin
          bitCounter_value <= 4'b0000;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module UartCtrlTx (
  input  wire [3:0]    io_configFrame_dataLength,
  input  wire [0:0]    io_configFrame_stop,
  input  wire [1:0]    io_configFrame_parity,
  input  wire          io_samplingTick,
  input  wire          io_write_valid,
  output reg           io_write_ready,
  input  wire [8:0]    io_write_payload,
  input  wire          io_cts,
  output wire          io_txd,
  input  wire          io_break,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;
  localparam UartCtrlTxState_IDLE = 3'd0;
  localparam UartCtrlTxState_START = 3'd1;
  localparam UartCtrlTxState_DATA = 3'd2;
  localparam UartCtrlTxState_PARITY = 3'd3;
  localparam UartCtrlTxState_STOP = 3'd4;

  wire       [2:0]    _zz_clockDivider_counter_valueNext;
  wire       [0:0]    _zz_clockDivider_counter_valueNext_1;
  wire       [3:0]    _zz_when_UartCtrlTx_l93;
  wire       [0:0]    _zz_when_UartCtrlTx_l93_1;
  reg                 clockDivider_counter_willIncrement;
  wire                clockDivider_counter_willClear;
  reg        [2:0]    clockDivider_counter_valueNext;
  reg        [2:0]    clockDivider_counter_value;
  wire                clockDivider_counter_willOverflowIfInc;
  wire                clockDivider_counter_willOverflow;
  reg        [3:0]    tickCounter_value;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg                 stateMachine_txd;
  wire                when_UartCtrlTx_l58;
  wire                when_UartCtrlTx_l73;
  wire                when_UartCtrlTx_l76;
  wire                when_UartCtrlTx_l93;
  wire       [2:0]    _zz_stateMachine_state;
  reg                 _zz_io_txd;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  reg [47:0] _zz_stateMachine_state_string;
  `endif


  assign _zz_clockDivider_counter_valueNext_1 = clockDivider_counter_willIncrement;
  assign _zz_clockDivider_counter_valueNext = {2'd0, _zz_clockDivider_counter_valueNext_1};
  assign _zz_when_UartCtrlTx_l93_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_UartCtrlTx_l93 = {3'd0, _zz_when_UartCtrlTx_l93_1};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      UartStopType_ONE : io_configFrame_stop_string = "ONE";
      UartStopType_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      UartParityType_NONE : io_configFrame_parity_string = "NONE";
      UartParityType_EVEN : io_configFrame_parity_string = "EVEN";
      UartParityType_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      UartCtrlTxState_IDLE : stateMachine_state_string = "IDLE  ";
      UartCtrlTxState_START : stateMachine_state_string = "START ";
      UartCtrlTxState_DATA : stateMachine_state_string = "DATA  ";
      UartCtrlTxState_PARITY : stateMachine_state_string = "PARITY";
      UartCtrlTxState_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_stateMachine_state)
      UartCtrlTxState_IDLE : _zz_stateMachine_state_string = "IDLE  ";
      UartCtrlTxState_START : _zz_stateMachine_state_string = "START ";
      UartCtrlTxState_DATA : _zz_stateMachine_state_string = "DATA  ";
      UartCtrlTxState_PARITY : _zz_stateMachine_state_string = "PARITY";
      UartCtrlTxState_STOP : _zz_stateMachine_state_string = "STOP  ";
      default : _zz_stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    clockDivider_counter_willIncrement = 1'b0;
    if(io_samplingTick) begin
      clockDivider_counter_willIncrement = 1'b1;
    end
  end

  assign clockDivider_counter_willClear = 1'b0;
  assign clockDivider_counter_willOverflowIfInc = (clockDivider_counter_value == 3'b100);
  assign clockDivider_counter_willOverflow = (clockDivider_counter_willOverflowIfInc && clockDivider_counter_willIncrement);
  always @(*) begin
    if(clockDivider_counter_willOverflow) begin
      clockDivider_counter_valueNext = 3'b000;
    end else begin
      clockDivider_counter_valueNext = (clockDivider_counter_value + _zz_clockDivider_counter_valueNext);
    end
    if(clockDivider_counter_willClear) begin
      clockDivider_counter_valueNext = 3'b000;
    end
  end

  always @(*) begin
    stateMachine_txd = 1'b1;
    case(stateMachine_state)
      UartCtrlTxState_IDLE : begin
      end
      UartCtrlTxState_START : begin
        stateMachine_txd = 1'b0;
      end
      UartCtrlTxState_DATA : begin
        stateMachine_txd = io_write_payload[tickCounter_value];
      end
      UartCtrlTxState_PARITY : begin
        stateMachine_txd = stateMachine_parity;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_write_ready = io_break;
    case(stateMachine_state)
      UartCtrlTxState_IDLE : begin
      end
      UartCtrlTxState_START : begin
      end
      UartCtrlTxState_DATA : begin
        if(clockDivider_counter_willOverflow) begin
          if(when_UartCtrlTx_l73) begin
            io_write_ready = 1'b1;
          end
        end
      end
      UartCtrlTxState_PARITY : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UartCtrlTx_l58 = ((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow);
  assign when_UartCtrlTx_l73 = (tickCounter_value == io_configFrame_dataLength);
  assign when_UartCtrlTx_l76 = (io_configFrame_parity == UartParityType_NONE);
  assign when_UartCtrlTx_l93 = (tickCounter_value == _zz_when_UartCtrlTx_l93);
  assign _zz_stateMachine_state = (io_write_valid ? UartCtrlTxState_START : UartCtrlTxState_IDLE);
  assign io_txd = _zz_io_txd;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      clockDivider_counter_value <= 3'b000;
      stateMachine_state <= UartCtrlTxState_IDLE;
      _zz_io_txd <= 1'b1;
    end else begin
      clockDivider_counter_value <= clockDivider_counter_valueNext;
      case(stateMachine_state)
        UartCtrlTxState_IDLE : begin
          if(when_UartCtrlTx_l58) begin
            stateMachine_state <= UartCtrlTxState_START;
          end
        end
        UartCtrlTxState_START : begin
          if(clockDivider_counter_willOverflow) begin
            stateMachine_state <= UartCtrlTxState_DATA;
          end
        end
        UartCtrlTxState_DATA : begin
          if(clockDivider_counter_willOverflow) begin
            if(when_UartCtrlTx_l73) begin
              if(when_UartCtrlTx_l76) begin
                stateMachine_state <= UartCtrlTxState_STOP;
              end else begin
                stateMachine_state <= UartCtrlTxState_PARITY;
              end
            end
          end
        end
        UartCtrlTxState_PARITY : begin
          if(clockDivider_counter_willOverflow) begin
            stateMachine_state <= UartCtrlTxState_STOP;
          end
        end
        default : begin
          if(clockDivider_counter_willOverflow) begin
            if(when_UartCtrlTx_l93) begin
              stateMachine_state <= _zz_stateMachine_state;
            end
          end
        end
      endcase
      _zz_io_txd <= (stateMachine_txd && (! io_break));
    end
  end

  always @(posedge clkout) begin
    if(clockDivider_counter_willOverflow) begin
      tickCounter_value <= (tickCounter_value + 4'b0001);
    end
    if(clockDivider_counter_willOverflow) begin
      stateMachine_parity <= (stateMachine_parity ^ stateMachine_txd);
    end
    case(stateMachine_state)
      UartCtrlTxState_IDLE : begin
      end
      UartCtrlTxState_START : begin
        if(clockDivider_counter_willOverflow) begin
          stateMachine_parity <= (io_configFrame_parity == UartParityType_ODD);
          tickCounter_value <= 4'b0000;
        end
      end
      UartCtrlTxState_DATA : begin
        if(clockDivider_counter_willOverflow) begin
          if(when_UartCtrlTx_l73) begin
            tickCounter_value <= 4'b0000;
          end
        end
      end
      UartCtrlTxState_PARITY : begin
        if(clockDivider_counter_willOverflow) begin
          tickCounter_value <= 4'b0000;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

//BufferCC_7 replaced by BufferCC_6

module BufferCC_6 (
  input  wire [15:0]   io_dataIn,
  output wire [15:0]   io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" *) reg        [15:0]   buffers_0;
  (* async_reg = "true" *) reg        [15:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module StreamFifoCC_1 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [127:0]  io_push_payload_rsp_data,
  input  wire [0:0]    io_push_payload_context,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [127:0]  io_pop_payload_rsp_data,
  output wire [0:0]    io_pop_payload_context,
  output wire [2:0]    io_pushOccupancy,
  output wire [2:0]    io_popOccupancy,
  input  wire          clk_out,
  input  wire          ddr_rst,
  input  wire          clkout
);

  reg        [128:0]  ram_spinal_port1;
  wire       [2:0]    popToPushGray_buffercc_io_dataOut;
  wire                axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert_buffercc_io_dataOut;
  wire       [2:0]    pushToPopGray_buffercc_io_dataOut;
  wire       [2:0]    _zz_pushCC_pushPtrGray;
  wire       [1:0]    _zz_ram_port;
  wire       [128:0]  _zz_ram_port_1;
  wire       [2:0]    _zz_popCC_popPtrGray;
  reg                 _zz_1;
  wire       [2:0]    popToPushGray;
  wire       [2:0]    pushToPopGray;
  reg        [2:0]    pushCC_pushPtr;
  wire       [2:0]    pushCC_pushPtrPlus;
  wire                io_push_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    pushCC_pushPtrGray;
  wire       [2:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_io_pushOccupancy;
  wire                _zz_io_pushOccupancy_1;
  wire                axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert;
  wire                axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized;
  reg        [2:0]    popCC_popPtr;
  (* keep , syn_keep *) wire       [2:0]    popCC_popPtrPlus /* synthesis syn_keep = 1 */ ;
  wire       [2:0]    popCC_popPtrGray;
  wire       [2:0]    popCC_pushPtrGray;
  wire                popCC_addressGen_valid;
  reg                 popCC_addressGen_ready;
  wire       [1:0]    popCC_addressGen_payload;
  wire                popCC_empty;
  wire                popCC_addressGen_fire;
  wire                popCC_readArbitation_valid;
  wire                popCC_readArbitation_ready;
  wire       [1:0]    popCC_readArbitation_payload;
  reg                 popCC_addressGen_rValid;
  reg        [1:0]    popCC_addressGen_rData;
  wire                when_Stream_l399;
  wire                popCC_readPort_cmd_valid;
  wire       [1:0]    popCC_readPort_cmd_payload;
  wire       [127:0]  popCC_readPort_rsp_rsp_data;
  wire       [0:0]    popCC_readPort_rsp_context;
  wire       [128:0]  _zz_popCC_readPort_rsp_rsp_data;
  wire                popCC_addressGen_toFlowFire_valid;
  wire       [1:0]    popCC_addressGen_toFlowFire_payload;
  wire                popCC_readArbitation_translated_valid;
  wire                popCC_readArbitation_translated_ready;
  wire       [127:0]  popCC_readArbitation_translated_payload_rsp_data;
  wire       [0:0]    popCC_readArbitation_translated_payload_context;
  wire                popCC_readArbitation_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    popCC_ptrToPush;
  reg        [2:0]    popCC_ptrToOccupancy;
  wire                _zz_io_popOccupancy;
  wire                _zz_io_popOccupancy_1;
  reg [128:0] ram [0:3];

  assign _zz_pushCC_pushPtrGray = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_ram_port = pushCC_pushPtr[1:0];
  assign _zz_popCC_popPtrGray = (popCC_popPtr >>> 1'b1);
  assign _zz_ram_port_1 = {io_push_payload_context,io_push_payload_rsp_data};
  always @(posedge clk_out) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= _zz_ram_port_1;
    end
  end

  always @(posedge clkout) begin
    if(popCC_readPort_cmd_valid) begin
      ram_spinal_port1 <= ram[popCC_readPort_cmd_payload];
    end
  end

  (* keep_hierarchy = "TRUE" *) BufferCC_3 popToPushGray_buffercc (
    .io_dataIn  (popToPushGray[2:0]                    ), //i
    .io_dataOut (popToPushGray_buffercc_io_dataOut[2:0]), //o
    .clk_out    (clk_out                               ), //i
    .ddr_rst    (ddr_rst                               )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_4 axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert_buffercc (
    .io_dataIn  (axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert                    ), //i
    .io_dataOut (axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .clkout     (clkout                                                                                    ), //i
    .ddr_rst    (ddr_rst                                                                                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_5 pushToPopGray_buffercc (
    .io_dataIn                                                   (pushToPopGray[2:0]                                         ), //i
    .io_dataOut                                                  (pushToPopGray_buffercc_io_dataOut[2:0]                     ), //o
    .clkout                                                      (clkout                                                     ), //i
    .axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized (axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized)  //i
  );
  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 3'b001);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[2 : 1] == (~ pushCC_popPtrGray[2 : 1])) && (pushCC_pushPtrGray[0 : 0] == pushCC_popPtrGray[0 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_io_pushOccupancy = (pushCC_popPtrGray[1] ^ _zz_io_pushOccupancy_1);
  assign _zz_io_pushOccupancy_1 = pushCC_popPtrGray[2];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_io_pushOccupancy_1,{_zz_io_pushOccupancy,(pushCC_popPtrGray[0] ^ _zz_io_pushOccupancy)}});
  assign axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized = axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_asyncAssertSyncDeassert_buffercc_io_dataOut;
  assign popCC_popPtrPlus = (popCC_popPtr + 3'b001);
  assign popCC_popPtrGray = (_zz_popCC_popPtrGray ^ popCC_popPtr);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign popCC_addressGen_valid = (! popCC_empty);
  assign popCC_addressGen_payload = popCC_popPtr[1:0];
  assign popCC_addressGen_fire = (popCC_addressGen_valid && popCC_addressGen_ready);
  always @(*) begin
    popCC_addressGen_ready = popCC_readArbitation_ready;
    if(when_Stream_l399) begin
      popCC_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! popCC_readArbitation_valid);
  assign popCC_readArbitation_valid = popCC_addressGen_rValid;
  assign popCC_readArbitation_payload = popCC_addressGen_rData;
  assign _zz_popCC_readPort_rsp_rsp_data = ram_spinal_port1;
  assign popCC_readPort_rsp_rsp_data = _zz_popCC_readPort_rsp_rsp_data[127 : 0];
  assign popCC_readPort_rsp_context = _zz_popCC_readPort_rsp_rsp_data[128 : 128];
  assign popCC_addressGen_toFlowFire_valid = popCC_addressGen_fire;
  assign popCC_addressGen_toFlowFire_payload = popCC_addressGen_payload;
  assign popCC_readPort_cmd_valid = popCC_addressGen_toFlowFire_valid;
  assign popCC_readPort_cmd_payload = popCC_addressGen_toFlowFire_payload;
  assign popCC_readArbitation_translated_valid = popCC_readArbitation_valid;
  assign popCC_readArbitation_ready = popCC_readArbitation_translated_ready;
  assign popCC_readArbitation_translated_payload_rsp_data = popCC_readPort_rsp_rsp_data;
  assign popCC_readArbitation_translated_payload_context = popCC_readPort_rsp_context;
  assign io_pop_valid = popCC_readArbitation_translated_valid;
  assign popCC_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_rsp_data = popCC_readArbitation_translated_payload_rsp_data;
  assign io_pop_payload_context = popCC_readArbitation_translated_payload_context;
  assign popCC_readArbitation_fire = (popCC_readArbitation_valid && popCC_readArbitation_ready);
  assign _zz_io_popOccupancy = (popCC_pushPtrGray[1] ^ _zz_io_popOccupancy_1);
  assign _zz_io_popOccupancy_1 = popCC_pushPtrGray[2];
  assign io_popOccupancy = ({_zz_io_popOccupancy_1,{_zz_io_popOccupancy,(popCC_pushPtrGray[0] ^ _zz_io_popOccupancy)}} - popCC_ptrToOccupancy);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_ptrToPush;
  always @(posedge clk_out or posedge ddr_rst) begin
    if(ddr_rst) begin
      pushCC_pushPtr <= 3'b000;
      pushCC_pushPtrGray <= 3'b000;
    end else begin
      if(io_push_fire) begin
        pushCC_pushPtrGray <= (_zz_pushCC_pushPtrGray ^ pushCC_pushPtrPlus);
      end
      if(io_push_fire) begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @(posedge clkout or posedge axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized) begin
    if(axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized) begin
      popCC_popPtr <= 3'b000;
      popCC_addressGen_rValid <= 1'b0;
      popCC_ptrToPush <= 3'b000;
      popCC_ptrToOccupancy <= 3'b000;
    end else begin
      if(popCC_addressGen_fire) begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
      if(popCC_addressGen_ready) begin
        popCC_addressGen_rValid <= popCC_addressGen_valid;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToPush <= popCC_popPtrGray;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToOccupancy <= popCC_popPtr;
      end
    end
  end

  always @(posedge clkout) begin
    if(popCC_addressGen_ready) begin
      popCC_addressGen_rData <= popCC_addressGen_payload;
    end
  end


endmodule

module StreamFifoCC (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [0:0]    io_push_payload_cmdtype,
  input  wire [27:0]   io_push_payload_addr,
  input  wire [5:0]    io_push_payload_burst_cnt,
  input  wire [127:0]  io_push_payload_wr_data,
  input  wire [15:0]   io_push_payload_wr_mask,
  input  wire [0:0]    io_push_payload_context,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [0:0]    io_pop_payload_cmdtype,
  output wire [27:0]   io_pop_payload_addr,
  output wire [5:0]    io_pop_payload_burst_cnt,
  output wire [127:0]  io_pop_payload_wr_data,
  output wire [15:0]   io_pop_payload_wr_mask,
  output wire [0:0]    io_pop_payload_context,
  output wire [2:0]    io_pushOccupancy,
  output wire [2:0]    io_popOccupancy,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clk_out
);
  localparam Axi4Ddr_CMDTYPE_read = 1'd0;
  localparam Axi4Ddr_CMDTYPE_write = 1'd1;

  reg        [179:0]  ram_spinal_port1;
  wire       [2:0]    popToPushGray_buffercc_io_dataOut;
  wire                axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  wire       [2:0]    pushToPopGray_buffercc_io_dataOut;
  wire       [2:0]    _zz_pushCC_pushPtrGray;
  wire       [1:0]    _zz_ram_port;
  wire       [179:0]  _zz_ram_port_1;
  wire       [2:0]    _zz_popCC_popPtrGray;
  reg                 _zz_1;
  wire       [2:0]    popToPushGray;
  wire       [2:0]    pushToPopGray;
  reg        [2:0]    pushCC_pushPtr;
  wire       [2:0]    pushCC_pushPtrPlus;
  wire                io_push_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    pushCC_pushPtrGray;
  wire       [2:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_io_pushOccupancy;
  wire                _zz_io_pushOccupancy_1;
  wire                axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert;
  wire                axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized;
  reg        [2:0]    popCC_popPtr;
  (* keep , syn_keep *) wire       [2:0]    popCC_popPtrPlus /* synthesis syn_keep = 1 */ ;
  wire       [2:0]    popCC_popPtrGray;
  wire       [2:0]    popCC_pushPtrGray;
  wire                popCC_addressGen_valid;
  reg                 popCC_addressGen_ready;
  wire       [1:0]    popCC_addressGen_payload;
  wire                popCC_empty;
  wire                popCC_addressGen_fire;
  wire                popCC_readArbitation_valid;
  wire                popCC_readArbitation_ready;
  wire       [1:0]    popCC_readArbitation_payload;
  reg                 popCC_addressGen_rValid;
  reg        [1:0]    popCC_addressGen_rData;
  wire                when_Stream_l399;
  wire                popCC_readPort_cmd_valid;
  wire       [1:0]    popCC_readPort_cmd_payload;
  wire       [0:0]    popCC_readPort_rsp_cmdtype;
  wire       [27:0]   popCC_readPort_rsp_addr;
  wire       [5:0]    popCC_readPort_rsp_burst_cnt;
  wire       [127:0]  popCC_readPort_rsp_wr_data;
  wire       [15:0]   popCC_readPort_rsp_wr_mask;
  wire       [0:0]    popCC_readPort_rsp_context;
  wire       [0:0]    _zz_popCC_readPort_rsp_cmdtype;
  wire       [179:0]  _zz_popCC_readPort_rsp_addr;
  wire       [0:0]    _zz_popCC_readPort_rsp_cmdtype_1;
  wire                popCC_addressGen_toFlowFire_valid;
  wire       [1:0]    popCC_addressGen_toFlowFire_payload;
  wire                popCC_readArbitation_translated_valid;
  wire                popCC_readArbitation_translated_ready;
  wire       [0:0]    popCC_readArbitation_translated_payload_cmdtype;
  wire       [27:0]   popCC_readArbitation_translated_payload_addr;
  wire       [5:0]    popCC_readArbitation_translated_payload_burst_cnt;
  wire       [127:0]  popCC_readArbitation_translated_payload_wr_data;
  wire       [15:0]   popCC_readArbitation_translated_payload_wr_mask;
  wire       [0:0]    popCC_readArbitation_translated_payload_context;
  wire                popCC_readArbitation_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    popCC_ptrToPush;
  reg        [2:0]    popCC_ptrToOccupancy;
  wire                _zz_io_popOccupancy;
  wire                _zz_io_popOccupancy_1;
  `ifndef SYNTHESIS
  reg [39:0] io_push_payload_cmdtype_string;
  reg [39:0] io_pop_payload_cmdtype_string;
  reg [39:0] popCC_readPort_rsp_cmdtype_string;
  reg [39:0] _zz_popCC_readPort_rsp_cmdtype_string;
  reg [39:0] _zz_popCC_readPort_rsp_cmdtype_1_string;
  reg [39:0] popCC_readArbitation_translated_payload_cmdtype_string;
  `endif

  reg [179:0] ram [0:3];

  assign _zz_pushCC_pushPtrGray = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_ram_port = pushCC_pushPtr[1:0];
  assign _zz_popCC_popPtrGray = (popCC_popPtr >>> 1'b1);
  assign _zz_ram_port_1 = {io_push_payload_context,{io_push_payload_wr_mask,{io_push_payload_wr_data,{io_push_payload_burst_cnt,{io_push_payload_addr,io_push_payload_cmdtype}}}}};
  always @(posedge clkout) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= _zz_ram_port_1;
    end
  end

  always @(posedge clk_out) begin
    if(popCC_readPort_cmd_valid) begin
      ram_spinal_port1 <= ram[popCC_readPort_cmd_payload];
    end
  end

  (* keep_hierarchy = "TRUE" *) BufferCC popToPushGray_buffercc (
    .io_dataIn          (popToPushGray[2:0]                    ), //i
    .io_dataOut         (popToPushGray_buffercc_io_dataOut[2:0]), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_1 axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc (
    .io_dataIn          (axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert                    ), //i
    .io_dataOut         (axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .clk_out            (clk_out                                                                                            ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                                                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_2 pushToPopGray_buffercc (
    .io_dataIn                                                            (pushToPopGray[2:0]                                                  ), //i
    .io_dataOut                                                           (pushToPopGray_buffercc_io_dataOut[2:0]                              ), //o
    .clk_out                                                              (clk_out                                                             ), //i
    .axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized (axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized)  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_push_payload_cmdtype)
      Axi4Ddr_CMDTYPE_read : io_push_payload_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : io_push_payload_cmdtype_string = "write";
      default : io_push_payload_cmdtype_string = "?????";
    endcase
  end
  always @(*) begin
    case(io_pop_payload_cmdtype)
      Axi4Ddr_CMDTYPE_read : io_pop_payload_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : io_pop_payload_cmdtype_string = "write";
      default : io_pop_payload_cmdtype_string = "?????";
    endcase
  end
  always @(*) begin
    case(popCC_readPort_rsp_cmdtype)
      Axi4Ddr_CMDTYPE_read : popCC_readPort_rsp_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : popCC_readPort_rsp_cmdtype_string = "write";
      default : popCC_readPort_rsp_cmdtype_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_popCC_readPort_rsp_cmdtype)
      Axi4Ddr_CMDTYPE_read : _zz_popCC_readPort_rsp_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : _zz_popCC_readPort_rsp_cmdtype_string = "write";
      default : _zz_popCC_readPort_rsp_cmdtype_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_popCC_readPort_rsp_cmdtype_1)
      Axi4Ddr_CMDTYPE_read : _zz_popCC_readPort_rsp_cmdtype_1_string = "read ";
      Axi4Ddr_CMDTYPE_write : _zz_popCC_readPort_rsp_cmdtype_1_string = "write";
      default : _zz_popCC_readPort_rsp_cmdtype_1_string = "?????";
    endcase
  end
  always @(*) begin
    case(popCC_readArbitation_translated_payload_cmdtype)
      Axi4Ddr_CMDTYPE_read : popCC_readArbitation_translated_payload_cmdtype_string = "read ";
      Axi4Ddr_CMDTYPE_write : popCC_readArbitation_translated_payload_cmdtype_string = "write";
      default : popCC_readArbitation_translated_payload_cmdtype_string = "?????";
    endcase
  end
  `endif

  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 3'b001);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[2 : 1] == (~ pushCC_popPtrGray[2 : 1])) && (pushCC_pushPtrGray[0 : 0] == pushCC_popPtrGray[0 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_io_pushOccupancy = (pushCC_popPtrGray[1] ^ _zz_io_pushOccupancy_1);
  assign _zz_io_pushOccupancy_1 = pushCC_popPtrGray[2];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_io_pushOccupancy_1,{_zz_io_pushOccupancy,(pushCC_popPtrGray[0] ^ _zz_io_pushOccupancy)}});
  assign axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized = axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  assign popCC_popPtrPlus = (popCC_popPtr + 3'b001);
  assign popCC_popPtrGray = (_zz_popCC_popPtrGray ^ popCC_popPtr);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign popCC_addressGen_valid = (! popCC_empty);
  assign popCC_addressGen_payload = popCC_popPtr[1:0];
  assign popCC_addressGen_fire = (popCC_addressGen_valid && popCC_addressGen_ready);
  always @(*) begin
    popCC_addressGen_ready = popCC_readArbitation_ready;
    if(when_Stream_l399) begin
      popCC_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! popCC_readArbitation_valid);
  assign popCC_readArbitation_valid = popCC_addressGen_rValid;
  assign popCC_readArbitation_payload = popCC_addressGen_rData;
  assign _zz_popCC_readPort_rsp_addr = ram_spinal_port1;
  assign _zz_popCC_readPort_rsp_cmdtype_1 = _zz_popCC_readPort_rsp_addr[0 : 0];
  assign _zz_popCC_readPort_rsp_cmdtype = _zz_popCC_readPort_rsp_cmdtype_1;
  assign popCC_readPort_rsp_cmdtype = _zz_popCC_readPort_rsp_cmdtype;
  assign popCC_readPort_rsp_addr = _zz_popCC_readPort_rsp_addr[28 : 1];
  assign popCC_readPort_rsp_burst_cnt = _zz_popCC_readPort_rsp_addr[34 : 29];
  assign popCC_readPort_rsp_wr_data = _zz_popCC_readPort_rsp_addr[162 : 35];
  assign popCC_readPort_rsp_wr_mask = _zz_popCC_readPort_rsp_addr[178 : 163];
  assign popCC_readPort_rsp_context = _zz_popCC_readPort_rsp_addr[179 : 179];
  assign popCC_addressGen_toFlowFire_valid = popCC_addressGen_fire;
  assign popCC_addressGen_toFlowFire_payload = popCC_addressGen_payload;
  assign popCC_readPort_cmd_valid = popCC_addressGen_toFlowFire_valid;
  assign popCC_readPort_cmd_payload = popCC_addressGen_toFlowFire_payload;
  assign popCC_readArbitation_translated_valid = popCC_readArbitation_valid;
  assign popCC_readArbitation_ready = popCC_readArbitation_translated_ready;
  assign popCC_readArbitation_translated_payload_cmdtype = popCC_readPort_rsp_cmdtype;
  assign popCC_readArbitation_translated_payload_addr = popCC_readPort_rsp_addr;
  assign popCC_readArbitation_translated_payload_burst_cnt = popCC_readPort_rsp_burst_cnt;
  assign popCC_readArbitation_translated_payload_wr_data = popCC_readPort_rsp_wr_data;
  assign popCC_readArbitation_translated_payload_wr_mask = popCC_readPort_rsp_wr_mask;
  assign popCC_readArbitation_translated_payload_context = popCC_readPort_rsp_context;
  assign io_pop_valid = popCC_readArbitation_translated_valid;
  assign popCC_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_cmdtype = popCC_readArbitation_translated_payload_cmdtype;
  assign io_pop_payload_addr = popCC_readArbitation_translated_payload_addr;
  assign io_pop_payload_burst_cnt = popCC_readArbitation_translated_payload_burst_cnt;
  assign io_pop_payload_wr_data = popCC_readArbitation_translated_payload_wr_data;
  assign io_pop_payload_wr_mask = popCC_readArbitation_translated_payload_wr_mask;
  assign io_pop_payload_context = popCC_readArbitation_translated_payload_context;
  assign popCC_readArbitation_fire = (popCC_readArbitation_valid && popCC_readArbitation_ready);
  assign _zz_io_popOccupancy = (popCC_pushPtrGray[1] ^ _zz_io_popOccupancy_1);
  assign _zz_io_popOccupancy_1 = popCC_pushPtrGray[2];
  assign io_popOccupancy = ({_zz_io_popOccupancy_1,{_zz_io_popOccupancy,(popCC_pushPtrGray[0] ^ _zz_io_popOccupancy)}} - popCC_ptrToOccupancy);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_ptrToPush;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      pushCC_pushPtr <= 3'b000;
      pushCC_pushPtrGray <= 3'b000;
    end else begin
      if(io_push_fire) begin
        pushCC_pushPtrGray <= (_zz_pushCC_pushPtrGray ^ pushCC_pushPtrPlus);
      end
      if(io_push_fire) begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @(posedge clk_out or posedge axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
    if(axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
      popCC_popPtr <= 3'b000;
      popCC_addressGen_rValid <= 1'b0;
      popCC_ptrToPush <= 3'b000;
      popCC_ptrToOccupancy <= 3'b000;
    end else begin
      if(popCC_addressGen_fire) begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
      if(popCC_addressGen_ready) begin
        popCC_addressGen_rValid <= popCC_addressGen_valid;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToPush <= popCC_popPtrGray;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToOccupancy <= popCC_popPtr;
      end
    end
  end

  always @(posedge clk_out) begin
    if(popCC_addressGen_ready) begin
      popCC_addressGen_rData <= popCC_addressGen_payload;
    end
  end


endmodule

module MixedDivider (
  input  wire          io_flush,
  input  wire          io_cmd_valid,
  output wire          io_cmd_ready,
  input  wire [31:0]   io_cmd_payload_numerator,
  input  wire [31:0]   io_cmd_payload_denominator,
  input  wire          io_cmd_payload_signed,
  output wire          io_rsp_valid,
  input  wire          io_rsp_ready,
  output wire [31:0]   io_rsp_payload_quotient,
  output wire [31:0]   io_rsp_payload_remainder,
  output wire          io_rsp_payload_error,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  wire       [31:0]   divider_io_cmd_payload_numerator;
  wire       [31:0]   divider_io_cmd_payload_denominator;
  reg        [1:0]    divider_io_cmd_payload_context;
  wire                divider_io_cmd_ready;
  wire                divider_io_rsp_valid;
  wire       [31:0]   divider_io_rsp_payload_quotient;
  wire       [31:0]   divider_io_rsp_payload_remainder;
  wire                divider_io_rsp_payload_error;
  wire       [1:0]    divider_io_rsp_payload_context;
  wire       [31:0]   _zz_io_cmd_payload_numerator_1;
  wire       [31:0]   _zz_io_cmd_payload_numerator_2;
  wire       [31:0]   _zz_io_cmd_payload_numerator_3;
  wire       [0:0]    _zz_io_cmd_payload_numerator_4;
  wire       [31:0]   _zz_io_cmd_payload_denominator_1;
  wire       [31:0]   _zz_io_cmd_payload_denominator_2;
  wire       [31:0]   _zz_io_cmd_payload_denominator_3;
  wire       [0:0]    _zz_io_cmd_payload_denominator_4;
  wire       [32:0]   _zz_io_rsp_payload_quotient_1;
  wire       [32:0]   _zz_io_rsp_payload_quotient_2;
  wire       [32:0]   _zz_io_rsp_payload_quotient_3;
  wire       [32:0]   _zz_io_rsp_payload_quotient_4;
  wire       [0:0]    _zz_io_rsp_payload_quotient_5;
  wire       [32:0]   _zz_io_rsp_payload_remainder_1;
  wire       [32:0]   _zz_io_rsp_payload_remainder_2;
  wire       [32:0]   _zz_io_rsp_payload_remainder_3;
  wire       [32:0]   _zz_io_rsp_payload_remainder_4;
  wire       [0:0]    _zz_io_rsp_payload_remainder_5;
  wire       [31:0]   _zz_io_cmd_payload_numerator;
  wire       [31:0]   _zz_io_cmd_payload_denominator;
  wire                _zz_io_rsp_payload_quotient;
  wire                _zz_io_rsp_payload_remainder;

  assign _zz_io_cmd_payload_numerator_1 = ((_zz_io_cmd_payload_numerator[31] && io_cmd_payload_signed) ? _zz_io_cmd_payload_numerator_2 : _zz_io_cmd_payload_numerator);
  assign _zz_io_cmd_payload_numerator_2 = (~ _zz_io_cmd_payload_numerator);
  assign _zz_io_cmd_payload_numerator_4 = (_zz_io_cmd_payload_numerator[31] && io_cmd_payload_signed);
  assign _zz_io_cmd_payload_numerator_3 = {31'd0, _zz_io_cmd_payload_numerator_4};
  assign _zz_io_cmd_payload_denominator_1 = ((_zz_io_cmd_payload_denominator[31] && io_cmd_payload_signed) ? _zz_io_cmd_payload_denominator_2 : _zz_io_cmd_payload_denominator);
  assign _zz_io_cmd_payload_denominator_2 = (~ _zz_io_cmd_payload_denominator);
  assign _zz_io_cmd_payload_denominator_4 = (_zz_io_cmd_payload_denominator[31] && io_cmd_payload_signed);
  assign _zz_io_cmd_payload_denominator_3 = {31'd0, _zz_io_cmd_payload_denominator_4};
  assign _zz_io_rsp_payload_quotient_1 = _zz_io_rsp_payload_quotient_2;
  assign _zz_io_rsp_payload_quotient_2 = _zz_io_rsp_payload_quotient_3;
  assign _zz_io_rsp_payload_quotient_3 = ({_zz_io_rsp_payload_quotient,(_zz_io_rsp_payload_quotient ? (~ divider_io_rsp_payload_quotient) : divider_io_rsp_payload_quotient)} + _zz_io_rsp_payload_quotient_4);
  assign _zz_io_rsp_payload_quotient_5 = _zz_io_rsp_payload_quotient;
  assign _zz_io_rsp_payload_quotient_4 = {32'd0, _zz_io_rsp_payload_quotient_5};
  assign _zz_io_rsp_payload_remainder_1 = _zz_io_rsp_payload_remainder_2;
  assign _zz_io_rsp_payload_remainder_2 = _zz_io_rsp_payload_remainder_3;
  assign _zz_io_rsp_payload_remainder_3 = ({_zz_io_rsp_payload_remainder,(_zz_io_rsp_payload_remainder ? (~ divider_io_rsp_payload_remainder) : divider_io_rsp_payload_remainder)} + _zz_io_rsp_payload_remainder_4);
  assign _zz_io_rsp_payload_remainder_5 = _zz_io_rsp_payload_remainder;
  assign _zz_io_rsp_payload_remainder_4 = {32'd0, _zz_io_rsp_payload_remainder_5};
  UnsignedDivider divider (
    .io_flush                   (io_flush                                ), //i
    .io_cmd_valid               (io_cmd_valid                            ), //i
    .io_cmd_ready               (divider_io_cmd_ready                    ), //o
    .io_cmd_payload_numerator   (divider_io_cmd_payload_numerator[31:0]  ), //i
    .io_cmd_payload_denominator (divider_io_cmd_payload_denominator[31:0]), //i
    .io_cmd_payload_context     (divider_io_cmd_payload_context[1:0]     ), //i
    .io_rsp_valid               (divider_io_rsp_valid                    ), //o
    .io_rsp_ready               (io_rsp_ready                            ), //i
    .io_rsp_payload_quotient    (divider_io_rsp_payload_quotient[31:0]   ), //o
    .io_rsp_payload_remainder   (divider_io_rsp_payload_remainder[31:0]  ), //o
    .io_rsp_payload_error       (divider_io_rsp_payload_error            ), //o
    .io_rsp_payload_context     (divider_io_rsp_payload_context[1:0]     ), //o
    .clkout                     (clkout                                  ), //i
    .resetCtrl_coreReset        (resetCtrl_coreReset                     )  //i
  );
  assign io_cmd_ready = divider_io_cmd_ready;
  assign _zz_io_cmd_payload_numerator = io_cmd_payload_numerator;
  assign divider_io_cmd_payload_numerator = (_zz_io_cmd_payload_numerator_1 + _zz_io_cmd_payload_numerator_3);
  assign _zz_io_cmd_payload_denominator = io_cmd_payload_denominator;
  assign divider_io_cmd_payload_denominator = (_zz_io_cmd_payload_denominator_1 + _zz_io_cmd_payload_denominator_3);
  always @(*) begin
    divider_io_cmd_payload_context[0] = (io_cmd_payload_signed && (io_cmd_payload_numerator[31] ^ io_cmd_payload_denominator[31]));
    divider_io_cmd_payload_context[1] = (io_cmd_payload_signed && io_cmd_payload_numerator[31]);
  end

  assign io_rsp_valid = divider_io_rsp_valid;
  assign _zz_io_rsp_payload_quotient = divider_io_rsp_payload_context[0];
  assign io_rsp_payload_quotient = _zz_io_rsp_payload_quotient_1[31:0];
  assign _zz_io_rsp_payload_remainder = divider_io_rsp_payload_context[1];
  assign io_rsp_payload_remainder = _zz_io_rsp_payload_remainder_1[31:0];
  assign io_rsp_payload_error = divider_io_rsp_payload_error;

endmodule

module Alu_1 (
  input  wire [3:0]    io_func,
  input  wire          io_doSub,
  input  wire [31:0]   io_src0,
  input  wire [31:0]   io_src1,
  output wire [31:0]   io_result,
  output wire [31:0]   io_adder
);
  localparam ALU_ADD = 4'd0;
  localparam ALU_SLL1 = 4'd1;
  localparam ALU_SLT = 4'd2;
  localparam ALU_SLTU = 4'd3;
  localparam ALU_XOR_1 = 4'd4;
  localparam ALU_SRL_1 = 4'd5;
  localparam ALU_OR_1 = 4'd6;
  localparam ALU_AND_1 = 4'd7;
  localparam ALU_SUB = 4'd8;
  localparam ALU_COPY = 4'd15;
  localparam ALU_SRA_1 = 4'd13;

  wire       [31:0]   _zz_addSub;
  wire       [31:0]   _zz_addSub_1;
  wire       [31:0]   _zz_addSub_2;
  wire       [31:0]   _zz_addSub_3;
  wire       [31:0]   _zz_addSub_4;
  wire       [1:0]    _zz_addSub_5;
  wire       [0:0]    _zz__zz_io_result;
  wire       [31:0]   addSub;
  reg        [31:0]   bitwise;
  wire                less;
  reg        [31:0]   _zz_io_result;
  `ifndef SYNTHESIS
  reg [39:0] io_func_string;
  `endif


  assign _zz_addSub = ($signed(_zz_addSub_1) + $signed(_zz_addSub_4));
  assign _zz_addSub_1 = ($signed(_zz_addSub_2) + $signed(_zz_addSub_3));
  assign _zz_addSub_2 = io_src0;
  assign _zz_addSub_3 = (io_doSub ? (~ io_src1) : io_src1);
  assign _zz_addSub_5 = (io_doSub ? 2'b01 : 2'b00);
  assign _zz_addSub_4 = {{30{_zz_addSub_5[1]}}, _zz_addSub_5};
  assign _zz__zz_io_result = less;
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_func)
      ALU_ADD : io_func_string = "ADD  ";
      ALU_SLL1 : io_func_string = "SLL1 ";
      ALU_SLT : io_func_string = "SLT  ";
      ALU_SLTU : io_func_string = "SLTU ";
      ALU_XOR_1 : io_func_string = "XOR_1";
      ALU_SRL_1 : io_func_string = "SRL_1";
      ALU_OR_1 : io_func_string = "OR_1 ";
      ALU_AND_1 : io_func_string = "AND_1";
      ALU_SUB : io_func_string = "SUB  ";
      ALU_COPY : io_func_string = "COPY ";
      ALU_SRA_1 : io_func_string = "SRA_1";
      default : io_func_string = "?????";
    endcase
  end
  `endif

  assign addSub = _zz_addSub;
  always @(*) begin
    case(io_func)
      ALU_AND_1 : begin
        bitwise = (io_src0 & io_src1);
      end
      ALU_OR_1 : begin
        bitwise = (io_src0 | io_src1);
      end
      ALU_XOR_1 : begin
        bitwise = (io_src0 ^ io_src1);
      end
      default : begin
        bitwise = io_src0;
      end
    endcase
  end

  assign less = ((io_src0[31] == io_src1[31]) ? addSub[31] : ((io_func == ALU_SLTU) ? io_src1[31] : io_src0[31]));
  always @(*) begin
    case(io_func)
      ALU_SLT, ALU_SLTU : begin
        _zz_io_result = {31'd0, _zz__zz_io_result};
      end
      ALU_ADD, ALU_SUB : begin
        _zz_io_result = addSub;
      end
      default : begin
        _zz_io_result = bitwise;
      end
    endcase
  end

  assign io_result = _zz_io_result;
  assign io_adder = addSub;

endmodule

module BufferCC_15 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clkout,
  input  wire          dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
    if(dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

//BufferCC_14 replaced by BufferCC_11

module BufferCC_13 (
  input  wire [6:0]    io_dataIn,
  output wire [6:0]    io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" *) reg        [6:0]    buffers_0;
  (* async_reg = "true" *) reg        [6:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module StreamFifoCC_2 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire          io_push_payload_last,
  input  wire [31:0]   io_push_payload_fragment,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire          io_pop_payload_last,
  output wire [31:0]   io_pop_payload_fragment,
  output wire [9:0]    io_pushOccupancy,
  output wire [9:0]    io_popOccupancy,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset,
  input  wire          clkout_1
);

  reg        [32:0]   ram_spinal_port1;
  wire       [9:0]    popToPushGray_buffercc_io_dataOut;
  wire                layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  wire       [9:0]    pushToPopGray_buffercc_io_dataOut;
  wire       [9:0]    _zz_pushCC_pushPtrGray;
  wire       [8:0]    _zz_ram_port;
  wire       [32:0]   _zz_ram_port_1;
  wire                _zz_io_pushOccupancy_9;
  wire       [9:0]    _zz_popCC_popPtrGray;
  wire                _zz_io_popOccupancy_9;
  reg                 _zz_1;
  wire       [9:0]    popToPushGray;
  wire       [9:0]    pushToPopGray;
  reg        [9:0]    pushCC_pushPtr;
  wire       [9:0]    pushCC_pushPtrPlus;
  wire                io_push_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [9:0]    pushCC_pushPtrGray;
  wire       [9:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_io_pushOccupancy;
  wire                _zz_io_pushOccupancy_1;
  wire                _zz_io_pushOccupancy_2;
  wire                _zz_io_pushOccupancy_3;
  wire                _zz_io_pushOccupancy_4;
  wire                _zz_io_pushOccupancy_5;
  wire                _zz_io_pushOccupancy_6;
  wire                _zz_io_pushOccupancy_7;
  wire                _zz_io_pushOccupancy_8;
  wire                layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert;
  wire                layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized;
  reg        [9:0]    popCC_popPtr;
  (* keep , syn_keep *) wire       [9:0]    popCC_popPtrPlus /* synthesis syn_keep = 1 */ ;
  wire       [9:0]    popCC_popPtrGray;
  wire       [9:0]    popCC_pushPtrGray;
  wire                popCC_addressGen_valid;
  reg                 popCC_addressGen_ready;
  wire       [8:0]    popCC_addressGen_payload;
  wire                popCC_empty;
  wire                popCC_addressGen_fire;
  wire                popCC_readArbitation_valid;
  wire                popCC_readArbitation_ready;
  wire       [8:0]    popCC_readArbitation_payload;
  reg                 popCC_addressGen_rValid;
  reg        [8:0]    popCC_addressGen_rData;
  wire                when_Stream_l399;
  wire                popCC_readPort_cmd_valid;
  wire       [8:0]    popCC_readPort_cmd_payload;
  wire                popCC_readPort_rsp_last;
  wire       [31:0]   popCC_readPort_rsp_fragment;
  wire       [32:0]   _zz_popCC_readPort_rsp_last;
  wire                popCC_addressGen_toFlowFire_valid;
  wire       [8:0]    popCC_addressGen_toFlowFire_payload;
  wire                popCC_readArbitation_translated_valid;
  wire                popCC_readArbitation_translated_ready;
  wire                popCC_readArbitation_translated_payload_last;
  wire       [31:0]   popCC_readArbitation_translated_payload_fragment;
  wire                popCC_readArbitation_fire;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [9:0]    popCC_ptrToPush;
  reg        [9:0]    popCC_ptrToOccupancy;
  wire                _zz_io_popOccupancy;
  wire                _zz_io_popOccupancy_1;
  wire                _zz_io_popOccupancy_2;
  wire                _zz_io_popOccupancy_3;
  wire                _zz_io_popOccupancy_4;
  wire                _zz_io_popOccupancy_5;
  wire                _zz_io_popOccupancy_6;
  wire                _zz_io_popOccupancy_7;
  wire                _zz_io_popOccupancy_8;
  reg [32:0] ram [0:511];

  assign _zz_pushCC_pushPtrGray = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_ram_port = pushCC_pushPtr[8:0];
  assign _zz_popCC_popPtrGray = (popCC_popPtr >>> 1'b1);
  assign _zz_ram_port_1 = {io_push_payload_fragment,io_push_payload_last};
  assign _zz_io_pushOccupancy_9 = (pushCC_popPtrGray[0] ^ _zz_io_pushOccupancy);
  assign _zz_io_popOccupancy_9 = (popCC_pushPtrGray[0] ^ _zz_io_popOccupancy);
  always @(posedge clkout) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= _zz_ram_port_1;
    end
  end

  always @(posedge clkout_1) begin
    if(popCC_readPort_cmd_valid) begin
      ram_spinal_port1 <= ram[popCC_readPort_cmd_payload];
    end
  end

  (* keep_hierarchy = "TRUE" *) BufferCC_10 popToPushGray_buffercc (
    .io_dataIn          (popToPushGray[9:0]                    ), //i
    .io_dataOut         (popToPushGray_buffercc_io_dataOut[9:0]), //o
    .clkout             (clkout                                ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                    )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_11 layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc (
    .io_dataIn          (layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert                    ), //i
    .io_dataOut         (layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .clkout             (clkout_1                                                                                         ), //i
    .resetCtrl_axiReset (resetCtrl_axiReset                                                                               )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_12 pushToPopGray_buffercc (
    .io_dataIn                                                          (pushToPopGray[9:0]                                                ), //i
    .io_dataOut                                                         (pushToPopGray_buffercc_io_dataOut[9:0]                            ), //o
    .clkout                                                             (clkout_1                                                          ), //i
    .layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized (layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized)  //i
  );
  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire) begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 10'h001);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[9 : 8] == (~ pushCC_popPtrGray[9 : 8])) && (pushCC_pushPtrGray[7 : 0] == pushCC_popPtrGray[7 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_io_pushOccupancy = (pushCC_popPtrGray[1] ^ _zz_io_pushOccupancy_1);
  assign _zz_io_pushOccupancy_1 = (pushCC_popPtrGray[2] ^ _zz_io_pushOccupancy_2);
  assign _zz_io_pushOccupancy_2 = (pushCC_popPtrGray[3] ^ _zz_io_pushOccupancy_3);
  assign _zz_io_pushOccupancy_3 = (pushCC_popPtrGray[4] ^ _zz_io_pushOccupancy_4);
  assign _zz_io_pushOccupancy_4 = (pushCC_popPtrGray[5] ^ _zz_io_pushOccupancy_5);
  assign _zz_io_pushOccupancy_5 = (pushCC_popPtrGray[6] ^ _zz_io_pushOccupancy_6);
  assign _zz_io_pushOccupancy_6 = (pushCC_popPtrGray[7] ^ _zz_io_pushOccupancy_7);
  assign _zz_io_pushOccupancy_7 = (pushCC_popPtrGray[8] ^ _zz_io_pushOccupancy_8);
  assign _zz_io_pushOccupancy_8 = pushCC_popPtrGray[9];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_io_pushOccupancy_8,{_zz_io_pushOccupancy_7,{_zz_io_pushOccupancy_6,{_zz_io_pushOccupancy_5,{_zz_io_pushOccupancy_4,{_zz_io_pushOccupancy_3,{_zz_io_pushOccupancy_2,{_zz_io_pushOccupancy_1,{_zz_io_pushOccupancy,_zz_io_pushOccupancy_9}}}}}}}}});
  assign layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized = layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  assign popCC_popPtrPlus = (popCC_popPtr + 10'h001);
  assign popCC_popPtrGray = (_zz_popCC_popPtrGray ^ popCC_popPtr);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign popCC_addressGen_valid = (! popCC_empty);
  assign popCC_addressGen_payload = popCC_popPtr[8:0];
  assign popCC_addressGen_fire = (popCC_addressGen_valid && popCC_addressGen_ready);
  always @(*) begin
    popCC_addressGen_ready = popCC_readArbitation_ready;
    if(when_Stream_l399) begin
      popCC_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l399 = (! popCC_readArbitation_valid);
  assign popCC_readArbitation_valid = popCC_addressGen_rValid;
  assign popCC_readArbitation_payload = popCC_addressGen_rData;
  assign _zz_popCC_readPort_rsp_last = ram_spinal_port1;
  assign popCC_readPort_rsp_last = _zz_popCC_readPort_rsp_last[0];
  assign popCC_readPort_rsp_fragment = _zz_popCC_readPort_rsp_last[32 : 1];
  assign popCC_addressGen_toFlowFire_valid = popCC_addressGen_fire;
  assign popCC_addressGen_toFlowFire_payload = popCC_addressGen_payload;
  assign popCC_readPort_cmd_valid = popCC_addressGen_toFlowFire_valid;
  assign popCC_readPort_cmd_payload = popCC_addressGen_toFlowFire_payload;
  assign popCC_readArbitation_translated_valid = popCC_readArbitation_valid;
  assign popCC_readArbitation_ready = popCC_readArbitation_translated_ready;
  assign popCC_readArbitation_translated_payload_last = popCC_readPort_rsp_last;
  assign popCC_readArbitation_translated_payload_fragment = popCC_readPort_rsp_fragment;
  assign io_pop_valid = popCC_readArbitation_translated_valid;
  assign popCC_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_last = popCC_readArbitation_translated_payload_last;
  assign io_pop_payload_fragment = popCC_readArbitation_translated_payload_fragment;
  assign popCC_readArbitation_fire = (popCC_readArbitation_valid && popCC_readArbitation_ready);
  assign _zz_io_popOccupancy = (popCC_pushPtrGray[1] ^ _zz_io_popOccupancy_1);
  assign _zz_io_popOccupancy_1 = (popCC_pushPtrGray[2] ^ _zz_io_popOccupancy_2);
  assign _zz_io_popOccupancy_2 = (popCC_pushPtrGray[3] ^ _zz_io_popOccupancy_3);
  assign _zz_io_popOccupancy_3 = (popCC_pushPtrGray[4] ^ _zz_io_popOccupancy_4);
  assign _zz_io_popOccupancy_4 = (popCC_pushPtrGray[5] ^ _zz_io_popOccupancy_5);
  assign _zz_io_popOccupancy_5 = (popCC_pushPtrGray[6] ^ _zz_io_popOccupancy_6);
  assign _zz_io_popOccupancy_6 = (popCC_pushPtrGray[7] ^ _zz_io_popOccupancy_7);
  assign _zz_io_popOccupancy_7 = (popCC_pushPtrGray[8] ^ _zz_io_popOccupancy_8);
  assign _zz_io_popOccupancy_8 = popCC_pushPtrGray[9];
  assign io_popOccupancy = ({_zz_io_popOccupancy_8,{_zz_io_popOccupancy_7,{_zz_io_popOccupancy_6,{_zz_io_popOccupancy_5,{_zz_io_popOccupancy_4,{_zz_io_popOccupancy_3,{_zz_io_popOccupancy_2,{_zz_io_popOccupancy_1,{_zz_io_popOccupancy,_zz_io_popOccupancy_9}}}}}}}}} - popCC_ptrToOccupancy);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_ptrToPush;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      pushCC_pushPtr <= 10'h0;
      pushCC_pushPtrGray <= 10'h0;
    end else begin
      if(io_push_fire) begin
        pushCC_pushPtrGray <= (_zz_pushCC_pushPtrGray ^ pushCC_pushPtrPlus);
      end
      if(io_push_fire) begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @(posedge clkout_1 or posedge layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
    if(layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
      popCC_popPtr <= 10'h0;
      popCC_addressGen_rValid <= 1'b0;
      popCC_ptrToPush <= 10'h0;
      popCC_ptrToOccupancy <= 10'h0;
    end else begin
      if(popCC_addressGen_fire) begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
      if(popCC_addressGen_ready) begin
        popCC_addressGen_rValid <= popCC_addressGen_valid;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToPush <= popCC_popPtrGray;
      end
      if(popCC_readArbitation_fire) begin
        popCC_ptrToOccupancy <= popCC_popPtr;
      end
    end
  end

  always @(posedge clkout_1) begin
    if(popCC_addressGen_ready) begin
      popCC_addressGen_rData <= popCC_addressGen_payload;
    end
  end


endmodule

//BufferCC_9 replaced by BufferCC_8

module BufferCC_8 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_5 (
  input  wire [2:0]    io_dataIn,
  output wire [2:0]    io_dataOut,
  input  wire          clkout,
  input  wire          axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    buffers_0;
  (* async_reg = "true" *) reg        [2:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized) begin
    if(axiController_axi_sdramCtrl_gowin_DDR3_ddr_rst_synchronized) begin
      buffers_0 <= 3'b000;
      buffers_1 <= 3'b000;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_4 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clkout,
  input  wire          ddr_rst
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge ddr_rst) begin
    if(ddr_rst) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_3 (
  input  wire [2:0]    io_dataIn,
  output wire [2:0]    io_dataOut,
  input  wire          clk_out,
  input  wire          ddr_rst
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    buffers_0;
  (* async_reg = "true" *) reg        [2:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk_out or posedge ddr_rst) begin
    if(ddr_rst) begin
      buffers_0 <= 3'b000;
      buffers_1 <= 3'b000;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_2 (
  input  wire [2:0]    io_dataIn,
  output wire [2:0]    io_dataOut,
  input  wire          clk_out,
  input  wire          axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    buffers_0;
  (* async_reg = "true" *) reg        [2:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk_out or posedge axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
    if(axiController_axi_sdramCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
      buffers_0 <= 3'b000;
      buffers_1 <= 3'b000;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_1 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk_out,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk_out or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC (
  input  wire [2:0]    io_dataIn,
  output wire [2:0]    io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [2:0]    buffers_0;
  (* async_reg = "true" *) reg        [2:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      buffers_0 <= 3'b000;
      buffers_1 <= 3'b000;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module UnsignedDivider (
  input  wire          io_flush,
  input  wire          io_cmd_valid,
  output reg           io_cmd_ready,
  input  wire [31:0]   io_cmd_payload_numerator,
  input  wire [31:0]   io_cmd_payload_denominator,
  input  wire [1:0]    io_cmd_payload_context,
  output wire          io_rsp_valid,
  input  wire          io_rsp_ready,
  output wire [31:0]   io_rsp_payload_quotient,
  output wire [31:0]   io_rsp_payload_remainder,
  output wire          io_rsp_payload_error,
  output wire [1:0]    io_rsp_payload_context,
  input  wire          clkout,
  input  wire          resetCtrl_coreReset
);

  wire       [4:0]    _zz_counter_valueNext;
  wire       [0:0]    _zz_counter_valueNext_1;
  wire       [32:0]   _zz_remainderMinusDenominator;
  wire       [32:0]   _zz_numerator;
  reg                 done;
  reg                 waitRsp;
  reg                 counter_willIncrement;
  reg                 counter_willClear;
  reg        [4:0]    counter_valueNext;
  reg        [4:0]    counter_value;
  wire                counter_willOverflowIfInc;
  wire                counter_willOverflow;
  reg        [31:0]   numerator;
  reg        [31:0]   denominator;
  reg        [1:0]    context_1;
  reg        [31:0]   remainder;
  wire       [32:0]   remainderShifted;
  wire       [32:0]   remainderMinusDenominator;
  wire                when_Divider_l109;
  wire                when_Divider_l128;

  assign _zz_counter_valueNext_1 = counter_willIncrement;
  assign _zz_counter_valueNext = {4'd0, _zz_counter_valueNext_1};
  assign _zz_remainderMinusDenominator = {1'd0, denominator};
  assign _zz_numerator = {numerator,(! remainderMinusDenominator[32])};
  always @(*) begin
    counter_willIncrement = 1'b0;
    if(!done) begin
      counter_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    counter_willClear = 1'b0;
    if(done) begin
      if(when_Divider_l109) begin
        counter_willClear = 1'b1;
      end
    end
  end

  assign counter_willOverflowIfInc = (counter_value == 5'h1f);
  assign counter_willOverflow = (counter_willOverflowIfInc && counter_willIncrement);
  always @(*) begin
    counter_valueNext = (counter_value + _zz_counter_valueNext);
    if(counter_willClear) begin
      counter_valueNext = 5'h0;
    end
  end

  assign remainderShifted = {remainder,numerator[31]};
  assign remainderMinusDenominator = (remainderShifted - _zz_remainderMinusDenominator);
  always @(*) begin
    io_cmd_ready = 1'b0;
    if(done) begin
      if(when_Divider_l109) begin
        io_cmd_ready = 1'b1;
      end
    end else begin
      if(counter_willOverflowIfInc) begin
        io_cmd_ready = 1'b1;
      end
    end
  end

  assign io_rsp_valid = waitRsp;
  assign io_rsp_payload_quotient = numerator;
  assign io_rsp_payload_remainder = remainder;
  assign io_rsp_payload_context = context_1;
  assign io_rsp_payload_error = (denominator == 32'h0);
  assign when_Divider_l109 = ((! waitRsp) || io_rsp_ready);
  assign when_Divider_l128 = (! remainderMinusDenominator[32]);
  always @(posedge clkout or posedge resetCtrl_coreReset) begin
    if(resetCtrl_coreReset) begin
      done <= 1'b1;
      waitRsp <= 1'b0;
      counter_value <= 5'h0;
    end else begin
      counter_value <= counter_valueNext;
      if(io_rsp_ready) begin
        waitRsp <= 1'b0;
      end
      if(done) begin
        if(when_Divider_l109) begin
          done <= (! io_cmd_valid);
        end
      end else begin
        if(counter_willOverflowIfInc) begin
          done <= 1'b1;
          waitRsp <= 1'b1;
        end
      end
      if(io_flush) begin
        done <= 1'b1;
        waitRsp <= 1'b0;
      end
    end
  end

  always @(posedge clkout) begin
    if(done) begin
      if(when_Divider_l109) begin
        remainder <= 32'h0;
        numerator <= io_cmd_payload_numerator;
        denominator <= io_cmd_payload_denominator;
        context_1 <= io_cmd_payload_context;
      end
    end else begin
      remainder <= remainderShifted[31:0];
      numerator <= _zz_numerator[31:0];
      if(when_Divider_l128) begin
        remainder <= remainderMinusDenominator[31:0];
      end
    end
  end


endmodule

module BufferCC_12 (
  input  wire [9:0]    io_dataIn,
  output wire [9:0]    io_dataOut,
  input  wire          clkout,
  input  wire          layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [9:0]    buffers_0;
  (* async_reg = "true" *) reg        [9:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
    if(layerDma_dvtc_axi_lcdCtrl_toplevel_resetCtrl_axiReset_synchronized) begin
      buffers_0 <= 10'h0;
      buffers_1 <= 10'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_11 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_10 (
  input  wire [9:0]    io_dataIn,
  output wire [9:0]    io_dataOut,
  input  wire          clkout,
  input  wire          resetCtrl_axiReset
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [9:0]    buffers_0;
  (* async_reg = "true" *) reg        [9:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clkout or posedge resetCtrl_axiReset) begin
    if(resetCtrl_axiReset) begin
      buffers_0 <= 10'h0;
      buffers_1 <= 10'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
