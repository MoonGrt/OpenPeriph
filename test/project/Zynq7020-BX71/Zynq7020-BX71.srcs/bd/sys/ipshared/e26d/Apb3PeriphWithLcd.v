// Generator : SpinalHDL v1.12.0    git head : 1aa7d7b5732f11cca2dd83bacc2a4cb92ca8e5c9
// Component : Apb3PeriphWithLcd
// Git hash  : 438687ba5fbfee184928732ba99e39b47eced179

`timescale 1ns/1ps

module Apb3PeriphWithLcd (
  input  wire [19:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
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
  input  wire [31:0]   io_gpio_read,
  output wire [31:0]   io_gpio_write,
  output wire [31:0]   io_gpio_readEnable,
  output reg  [15:0]   io_interrupt,
  output wire          io_dvti_vs,
  output wire          io_dvti_hs,
  output wire          io_dvti_de,
  output wire [23:0]   io_dvti_data,
  output wire          io_lcdclk,
  input  wire          dvt_clk,
  input  wire          clk,
  input  wire          reset,
  input  wire          dvt_reset
);

  wire       [4:0]    afioCtrl_io_apb_PADDR;
  wire       [31:0]   afioCtrl_io_device_read;
  wire       [4:0]    extiCtrl_io_apb_PADDR;
  wire       [12:0]   gpioCtrl_io_apb_PADDR;
  wire       [12:0]   timCtrl_io_apb_PADDR;
  wire       [12:0]   wdgCtrl_io_apb_PADDR;
  wire       [3:0]    systickCtrl_io_apb_PADDR;
  wire       [12:0]   uartCtrl_io_apb_PADDR;
  wire                uartCtrl_io_uarts_0_rxd;
  wire                uartCtrl_io_uarts_1_rxd;
  wire       [12:0]   i2cCtrl_io_apb_PADDR;
  wire       [0:0]    i2cCtrl_io_i2cs_0_sda_read;
  wire       [0:0]    i2cCtrl_io_i2cs_1_sda_read;
  wire       [12:0]   spiCtrl_io_apb_PADDR;
  wire                spiCtrl_io_spis_0_miso;
  wire                spiCtrl_io_spis_1_miso;
  wire       [9:0]    lcdCtrl_io_apb_PADDR;
  wire                afioCtrl_io_apb_PREADY;
  wire       [31:0]   afioCtrl_io_apb_PRDATA;
  wire                afioCtrl_io_apb_PSLVERROR;
  wire       [31:0]   afioCtrl_io_device_write;
  wire       [31:0]   afioCtrl_io_device_writeEnable;
  wire       [31:0]   afioCtrl_io_afio_write;
  wire       [31:0]   afioCtrl_io_afio_writeEnable;
  wire       [15:0]   afioCtrl_io_afioExti;
  wire                extiCtrl_io_apb_PREADY;
  wire       [31:0]   extiCtrl_io_apb_PRDATA;
  wire                extiCtrl_io_apb_PSLVERROR;
  wire       [15:0]   extiCtrl_io_interrupt;
  wire                gpioCtrl_io_apb_PREADY;
  wire       [31:0]   gpioCtrl_io_apb_PRDATA;
  wire                gpioCtrl_io_apb_PSLVERROR;
  wire       [31:0]   gpioCtrl_io_gpio_write;
  wire       [31:0]   gpioCtrl_io_gpio_writeEnable;
  wire                timCtrl_io_apb_PREADY;
  wire       [31:0]   timCtrl_io_apb_PRDATA;
  wire                timCtrl_io_apb_PSLVERROR;
  wire       [7:0]    timCtrl_io_ch;
  wire       [1:0]    timCtrl_io_interrupt;
  wire                wdgCtrl_io_apb_PREADY;
  wire       [31:0]   wdgCtrl_io_apb_PRDATA;
  wire                wdgCtrl_io_apb_PSLVERROR;
  wire                wdgCtrl_io_iwdgRst;
  wire                wdgCtrl_io_wwdgRst;
  wire                systickCtrl_io_apb_PREADY;
  wire       [31:0]   systickCtrl_io_apb_PRDATA;
  wire                systickCtrl_io_apb_PSLVERROR;
  wire                systickCtrl_io_interrupt;
  wire                uartCtrl_io_apb_PREADY;
  wire       [31:0]   uartCtrl_io_apb_PRDATA;
  wire                uartCtrl_io_apb_PSLVERROR;
  wire                uartCtrl_io_uarts_0_txd;
  wire                uartCtrl_io_uarts_1_txd;
  wire       [1:0]    uartCtrl_io_interrupt;
  wire                i2cCtrl_io_apb_PREADY;
  wire       [31:0]   i2cCtrl_io_apb_PRDATA;
  wire                i2cCtrl_io_apb_PSLVERROR;
  wire                i2cCtrl_io_i2cs_0_scl;
  wire       [0:0]    i2cCtrl_io_i2cs_0_sda_write;
  wire       [0:0]    i2cCtrl_io_i2cs_0_sda_writeEnable;
  wire                i2cCtrl_io_i2cs_1_scl;
  wire       [0:0]    i2cCtrl_io_i2cs_1_sda_write;
  wire       [0:0]    i2cCtrl_io_i2cs_1_sda_writeEnable;
  wire       [1:0]    i2cCtrl_io_interrupt;
  wire                spiCtrl_io_apb_PREADY;
  wire       [31:0]   spiCtrl_io_apb_PRDATA;
  wire                spiCtrl_io_apb_PSLVERROR;
  wire                spiCtrl_io_spis_0_sclk;
  wire                spiCtrl_io_spis_0_mosi;
  wire                spiCtrl_io_spis_0_ss;
  wire                spiCtrl_io_spis_1_sclk;
  wire                spiCtrl_io_spis_1_mosi;
  wire                spiCtrl_io_spis_1_ss;
  wire       [1:0]    spiCtrl_io_interrupt;
  wire                lcdCtrl_io_apb_PREADY;
  wire       [31:0]   lcdCtrl_io_apb_PRDATA;
  wire                lcdCtrl_io_axi_ar_valid;
  wire       [31:0]   lcdCtrl_io_axi_ar_payload_addr;
  wire       [7:0]    lcdCtrl_io_axi_ar_payload_len;
  wire       [2:0]    lcdCtrl_io_axi_ar_payload_size;
  wire       [3:0]    lcdCtrl_io_axi_ar_payload_cache;
  wire       [2:0]    lcdCtrl_io_axi_ar_payload_prot;
  wire                lcdCtrl_io_axi_r_ready;
  wire                lcdCtrl_io_dvti_vs;
  wire                lcdCtrl_io_dvti_hs;
  wire                lcdCtrl_io_dvti_de;
  wire       [15:0]   lcdCtrl_io_dvti_data;
  wire                lcdCtrl_io_interrupt;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [19:0]   io_apb_decoder_io_output_PADDR;
  wire       [9:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [19:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_2_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_2_PSEL;
  wire                apb3Router_7_io_outputs_2_PENABLE;
  wire                apb3Router_7_io_outputs_2_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_2_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_3_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_3_PSEL;
  wire                apb3Router_7_io_outputs_3_PENABLE;
  wire                apb3Router_7_io_outputs_3_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_3_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_4_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_4_PSEL;
  wire                apb3Router_7_io_outputs_4_PENABLE;
  wire                apb3Router_7_io_outputs_4_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_4_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_5_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_5_PSEL;
  wire                apb3Router_7_io_outputs_5_PENABLE;
  wire                apb3Router_7_io_outputs_5_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_5_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_6_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_6_PSEL;
  wire                apb3Router_7_io_outputs_6_PENABLE;
  wire                apb3Router_7_io_outputs_6_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_6_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_7_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_7_PSEL;
  wire                apb3Router_7_io_outputs_7_PENABLE;
  wire                apb3Router_7_io_outputs_7_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_7_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_8_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_8_PSEL;
  wire                apb3Router_7_io_outputs_8_PENABLE;
  wire                apb3Router_7_io_outputs_8_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_8_PWDATA;
  wire       [19:0]   apb3Router_7_io_outputs_9_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_9_PSEL;
  wire                apb3Router_7_io_outputs_9_PENABLE;
  wire                apb3Router_7_io_outputs_9_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_9_PWDATA;
  wire       [5:0]    _zz_io_device_read;
  wire       [0:0]    _zz_io_device_read_1;
  wire                extiInterrupt;
  wire                timInterrupt;
  wire                systickInterrupt;
  wire                uartInterrupt;
  wire                i2cInterrupt;
  wire                spiInterrupt;

  assign _zz_io_device_read = {{{{{1'b0,spiCtrl_io_spis_1_mosi},spiCtrl_io_spis_1_ss},spiCtrl_io_spis_0_sclk},1'b0},spiCtrl_io_spis_0_mosi};
  assign _zz_io_device_read_1 = spiCtrl_io_spis_0_ss;
  Apb3Afio afioCtrl (
    .io_apb_PADDR          (afioCtrl_io_apb_PADDR[4:0]            ), //i
    .io_apb_PSEL           (apb3Router_7_io_outputs_8_PSEL        ), //i
    .io_apb_PENABLE        (apb3Router_7_io_outputs_8_PENABLE     ), //i
    .io_apb_PREADY         (afioCtrl_io_apb_PREADY                ), //o
    .io_apb_PWRITE         (apb3Router_7_io_outputs_8_PWRITE      ), //i
    .io_apb_PWDATA         (apb3Router_7_io_outputs_8_PWDATA[31:0]), //i
    .io_apb_PRDATA         (afioCtrl_io_apb_PRDATA[31:0]          ), //o
    .io_apb_PSLVERROR      (afioCtrl_io_apb_PSLVERROR             ), //o
    .io_device_read        (afioCtrl_io_device_read[31:0]         ), //i
    .io_device_write       (afioCtrl_io_device_write[31:0]        ), //o
    .io_device_writeEnable (afioCtrl_io_device_writeEnable[31:0]  ), //o
    .io_afio_read          (io_gpio_read[31:0]                    ), //i
    .io_afio_write         (afioCtrl_io_afio_write[31:0]          ), //o
    .io_afio_writeEnable   (afioCtrl_io_afio_writeEnable[31:0]    ), //o
    .io_afioExti           (afioCtrl_io_afioExti[15:0]            ), //o
    .clk                   (clk                                   ), //i
    .reset                 (reset                                 )  //i
  );
  Apb3Exti extiCtrl (
    .io_apb_PADDR     (extiCtrl_io_apb_PADDR[4:0]            ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_9_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_9_PENABLE     ), //i
    .io_apb_PREADY    (extiCtrl_io_apb_PREADY                ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_9_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_9_PWDATA[31:0]), //i
    .io_apb_PRDATA    (extiCtrl_io_apb_PRDATA[31:0]          ), //o
    .io_apb_PSLVERROR (extiCtrl_io_apb_PSLVERROR             ), //o
    .io_exti          (afioCtrl_io_afioExti[15:0]            ), //i
    .io_interrupt     (extiCtrl_io_interrupt[15:0]           ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3GpioArray gpioCtrl (
    .io_apb_PADDR        (gpioCtrl_io_apb_PADDR[12:0]           ), //i
    .io_apb_PSEL         (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY       (gpioCtrl_io_apb_PREADY                ), //o
    .io_apb_PWRITE       (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA       (gpioCtrl_io_apb_PRDATA[31:0]          ), //o
    .io_apb_PSLVERROR    (gpioCtrl_io_apb_PSLVERROR             ), //o
    .io_gpio_read        (io_gpio_read[31:0]                    ), //i
    .io_gpio_write       (gpioCtrl_io_gpio_write[31:0]          ), //o
    .io_gpio_writeEnable (gpioCtrl_io_gpio_writeEnable[31:0]    ), //o
    .io_afio             (afioCtrl_io_afio_write[31:0]          ), //i
    .clk                 (clk                                   ), //i
    .reset               (reset                                 )  //i
  );
  Apb3TimArray timCtrl (
    .io_apb_PADDR     (timCtrl_io_apb_PADDR[12:0]            ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_4_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_4_PENABLE     ), //i
    .io_apb_PREADY    (timCtrl_io_apb_PREADY                 ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_4_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_4_PWDATA[31:0]), //i
    .io_apb_PRDATA    (timCtrl_io_apb_PRDATA[31:0]           ), //o
    .io_apb_PSLVERROR (timCtrl_io_apb_PSLVERROR              ), //o
    .io_ch            (timCtrl_io_ch[7:0]                    ), //o
    .io_interrupt     (timCtrl_io_interrupt[1:0]             ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3Wdg wdgCtrl (
    .io_apb_PADDR     (wdgCtrl_io_apb_PADDR[12:0]            ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_5_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_5_PENABLE     ), //i
    .io_apb_PREADY    (wdgCtrl_io_apb_PREADY                 ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_5_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_5_PWDATA[31:0]), //i
    .io_apb_PRDATA    (wdgCtrl_io_apb_PRDATA[31:0]           ), //o
    .io_apb_PSLVERROR (wdgCtrl_io_apb_PSLVERROR              ), //o
    .io_iwdgRst       (wdgCtrl_io_iwdgRst                    ), //o
    .io_wwdgRst       (wdgCtrl_io_wwdgRst                    ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3SysTick systickCtrl (
    .io_apb_PADDR     (systickCtrl_io_apb_PADDR[3:0]         ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_6_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_6_PENABLE     ), //i
    .io_apb_PREADY    (systickCtrl_io_apb_PREADY             ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_6_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_6_PWDATA[31:0]), //i
    .io_apb_PRDATA    (systickCtrl_io_apb_PRDATA[31:0]       ), //o
    .io_apb_PSLVERROR (systickCtrl_io_apb_PSLVERROR          ), //o
    .io_interrupt     (systickCtrl_io_interrupt              ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3UartArray uartCtrl (
    .io_apb_PADDR     (uartCtrl_io_apb_PADDR[12:0]           ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY    (uartCtrl_io_apb_PREADY                ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA    (uartCtrl_io_apb_PRDATA[31:0]          ), //o
    .io_apb_PSLVERROR (uartCtrl_io_apb_PSLVERROR             ), //o
    .io_uarts_0_txd   (uartCtrl_io_uarts_0_txd               ), //o
    .io_uarts_0_rxd   (uartCtrl_io_uarts_0_rxd               ), //i
    .io_uarts_1_txd   (uartCtrl_io_uarts_1_txd               ), //o
    .io_uarts_1_rxd   (uartCtrl_io_uarts_1_rxd               ), //i
    .io_interrupt     (uartCtrl_io_interrupt[1:0]            ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3I2cArray i2cCtrl (
    .io_apb_PADDR              (i2cCtrl_io_apb_PADDR[12:0]            ), //i
    .io_apb_PSEL               (apb3Router_7_io_outputs_2_PSEL        ), //i
    .io_apb_PENABLE            (apb3Router_7_io_outputs_2_PENABLE     ), //i
    .io_apb_PREADY             (i2cCtrl_io_apb_PREADY                 ), //o
    .io_apb_PWRITE             (apb3Router_7_io_outputs_2_PWRITE      ), //i
    .io_apb_PWDATA             (apb3Router_7_io_outputs_2_PWDATA[31:0]), //i
    .io_apb_PRDATA             (i2cCtrl_io_apb_PRDATA[31:0]           ), //o
    .io_apb_PSLVERROR          (i2cCtrl_io_apb_PSLVERROR              ), //o
    .io_i2cs_0_scl             (i2cCtrl_io_i2cs_0_scl                 ), //o
    .io_i2cs_0_sda_read        (i2cCtrl_io_i2cs_0_sda_read            ), //i
    .io_i2cs_0_sda_write       (i2cCtrl_io_i2cs_0_sda_write           ), //o
    .io_i2cs_0_sda_writeEnable (i2cCtrl_io_i2cs_0_sda_writeEnable     ), //o
    .io_i2cs_1_scl             (i2cCtrl_io_i2cs_1_scl                 ), //o
    .io_i2cs_1_sda_read        (i2cCtrl_io_i2cs_1_sda_read            ), //i
    .io_i2cs_1_sda_write       (i2cCtrl_io_i2cs_1_sda_write           ), //o
    .io_i2cs_1_sda_writeEnable (i2cCtrl_io_i2cs_1_sda_writeEnable     ), //o
    .io_interrupt              (i2cCtrl_io_interrupt[1:0]             ), //o
    .clk                       (clk                                   ), //i
    .reset                     (reset                                 )  //i
  );
  Apb3SpiArray spiCtrl (
    .io_apb_PADDR     (spiCtrl_io_apb_PADDR[12:0]            ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_3_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_3_PENABLE     ), //i
    .io_apb_PREADY    (spiCtrl_io_apb_PREADY                 ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_3_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_3_PWDATA[31:0]), //i
    .io_apb_PRDATA    (spiCtrl_io_apb_PRDATA[31:0]           ), //o
    .io_apb_PSLVERROR (spiCtrl_io_apb_PSLVERROR              ), //o
    .io_spis_0_sclk   (spiCtrl_io_spis_0_sclk                ), //o
    .io_spis_0_mosi   (spiCtrl_io_spis_0_mosi                ), //o
    .io_spis_0_miso   (spiCtrl_io_spis_0_miso                ), //i
    .io_spis_0_ss     (spiCtrl_io_spis_0_ss                  ), //o
    .io_spis_1_sclk   (spiCtrl_io_spis_1_sclk                ), //o
    .io_spis_1_mosi   (spiCtrl_io_spis_1_mosi                ), //o
    .io_spis_1_miso   (spiCtrl_io_spis_1_miso                ), //i
    .io_spis_1_ss     (spiCtrl_io_spis_1_ss                  ), //o
    .io_interrupt     (spiCtrl_io_interrupt[1:0]             ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Axi4Lcd lcdCtrl (
    .io_apb_PADDR            (lcdCtrl_io_apb_PADDR[9:0]             ), //i
    .io_apb_PSEL             (apb3Router_7_io_outputs_7_PSEL        ), //i
    .io_apb_PENABLE          (apb3Router_7_io_outputs_7_PENABLE     ), //i
    .io_apb_PREADY           (lcdCtrl_io_apb_PREADY                 ), //o
    .io_apb_PWRITE           (apb3Router_7_io_outputs_7_PWRITE      ), //i
    .io_apb_PWDATA           (apb3Router_7_io_outputs_7_PWDATA[31:0]), //i
    .io_apb_PRDATA           (lcdCtrl_io_apb_PRDATA[31:0]           ), //o
    .io_axi_ar_valid         (lcdCtrl_io_axi_ar_valid               ), //o
    .io_axi_ar_ready         (io_axi_ar_ready                       ), //i
    .io_axi_ar_payload_addr  (lcdCtrl_io_axi_ar_payload_addr[31:0]  ), //o
    .io_axi_ar_payload_len   (lcdCtrl_io_axi_ar_payload_len[7:0]    ), //o
    .io_axi_ar_payload_size  (lcdCtrl_io_axi_ar_payload_size[2:0]   ), //o
    .io_axi_ar_payload_cache (lcdCtrl_io_axi_ar_payload_cache[3:0]  ), //o
    .io_axi_ar_payload_prot  (lcdCtrl_io_axi_ar_payload_prot[2:0]   ), //o
    .io_axi_r_valid          (io_axi_r_valid                        ), //i
    .io_axi_r_ready          (lcdCtrl_io_axi_r_ready                ), //o
    .io_axi_r_payload_data   (io_axi_r_payload_data[31:0]           ), //i
    .io_axi_r_payload_last   (io_axi_r_payload_last                 ), //i
    .io_dvti_vs              (lcdCtrl_io_dvti_vs                    ), //o
    .io_dvti_hs              (lcdCtrl_io_dvti_hs                    ), //o
    .io_dvti_de              (lcdCtrl_io_dvti_de                    ), //o
    .io_dvti_data            (lcdCtrl_io_dvti_data[15:0]            ), //o
    .io_interrupt            (lcdCtrl_io_interrupt                  ), //o
    .clk                     (clk                                   ), //i
    .reset                   (reset                                 ), //i
    .dvt_clk                 (dvt_clk                               ), //i
    .dvt_reset               (dvt_reset                             )  //i
  );
  Apb3Decoder_6 io_apb_decoder (
    .io_input_PADDR      (io_apb_PADDR[19:0]                   ), //i
    .io_input_PSEL       (io_apb_PSEL                          ), //i
    .io_input_PENABLE    (io_apb_PENABLE                       ), //i
    .io_input_PREADY     (io_apb_decoder_io_input_PREADY       ), //o
    .io_input_PWRITE     (io_apb_PWRITE                        ), //i
    .io_input_PWDATA     (io_apb_PWDATA[31:0]                  ), //i
    .io_input_PRDATA     (io_apb_decoder_io_input_PRDATA[31:0] ), //o
    .io_input_PSLVERROR  (io_apb_decoder_io_input_PSLVERROR    ), //o
    .io_output_PADDR     (io_apb_decoder_io_output_PADDR[19:0] ), //o
    .io_output_PSEL      (io_apb_decoder_io_output_PSEL[9:0]   ), //o
    .io_output_PENABLE   (io_apb_decoder_io_output_PENABLE     ), //o
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router_6 apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[19:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[9:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[19:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (gpioCtrl_io_apb_PREADY                ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (gpioCtrl_io_apb_PRDATA[31:0]          ), //i
    .io_outputs_0_PSLVERROR (gpioCtrl_io_apb_PSLVERROR             ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[19:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (uartCtrl_io_apb_PREADY                ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (uartCtrl_io_apb_PRDATA[31:0]          ), //i
    .io_outputs_1_PSLVERROR (uartCtrl_io_apb_PSLVERROR             ), //i
    .io_outputs_2_PADDR     (apb3Router_7_io_outputs_2_PADDR[19:0] ), //o
    .io_outputs_2_PSEL      (apb3Router_7_io_outputs_2_PSEL        ), //o
    .io_outputs_2_PENABLE   (apb3Router_7_io_outputs_2_PENABLE     ), //o
    .io_outputs_2_PREADY    (i2cCtrl_io_apb_PREADY                 ), //i
    .io_outputs_2_PWRITE    (apb3Router_7_io_outputs_2_PWRITE      ), //o
    .io_outputs_2_PWDATA    (apb3Router_7_io_outputs_2_PWDATA[31:0]), //o
    .io_outputs_2_PRDATA    (i2cCtrl_io_apb_PRDATA[31:0]           ), //i
    .io_outputs_2_PSLVERROR (i2cCtrl_io_apb_PSLVERROR              ), //i
    .io_outputs_3_PADDR     (apb3Router_7_io_outputs_3_PADDR[19:0] ), //o
    .io_outputs_3_PSEL      (apb3Router_7_io_outputs_3_PSEL        ), //o
    .io_outputs_3_PENABLE   (apb3Router_7_io_outputs_3_PENABLE     ), //o
    .io_outputs_3_PREADY    (spiCtrl_io_apb_PREADY                 ), //i
    .io_outputs_3_PWRITE    (apb3Router_7_io_outputs_3_PWRITE      ), //o
    .io_outputs_3_PWDATA    (apb3Router_7_io_outputs_3_PWDATA[31:0]), //o
    .io_outputs_3_PRDATA    (spiCtrl_io_apb_PRDATA[31:0]           ), //i
    .io_outputs_3_PSLVERROR (spiCtrl_io_apb_PSLVERROR              ), //i
    .io_outputs_4_PADDR     (apb3Router_7_io_outputs_4_PADDR[19:0] ), //o
    .io_outputs_4_PSEL      (apb3Router_7_io_outputs_4_PSEL        ), //o
    .io_outputs_4_PENABLE   (apb3Router_7_io_outputs_4_PENABLE     ), //o
    .io_outputs_4_PREADY    (timCtrl_io_apb_PREADY                 ), //i
    .io_outputs_4_PWRITE    (apb3Router_7_io_outputs_4_PWRITE      ), //o
    .io_outputs_4_PWDATA    (apb3Router_7_io_outputs_4_PWDATA[31:0]), //o
    .io_outputs_4_PRDATA    (timCtrl_io_apb_PRDATA[31:0]           ), //i
    .io_outputs_4_PSLVERROR (timCtrl_io_apb_PSLVERROR              ), //i
    .io_outputs_5_PADDR     (apb3Router_7_io_outputs_5_PADDR[19:0] ), //o
    .io_outputs_5_PSEL      (apb3Router_7_io_outputs_5_PSEL        ), //o
    .io_outputs_5_PENABLE   (apb3Router_7_io_outputs_5_PENABLE     ), //o
    .io_outputs_5_PREADY    (wdgCtrl_io_apb_PREADY                 ), //i
    .io_outputs_5_PWRITE    (apb3Router_7_io_outputs_5_PWRITE      ), //o
    .io_outputs_5_PWDATA    (apb3Router_7_io_outputs_5_PWDATA[31:0]), //o
    .io_outputs_5_PRDATA    (wdgCtrl_io_apb_PRDATA[31:0]           ), //i
    .io_outputs_5_PSLVERROR (wdgCtrl_io_apb_PSLVERROR              ), //i
    .io_outputs_6_PADDR     (apb3Router_7_io_outputs_6_PADDR[19:0] ), //o
    .io_outputs_6_PSEL      (apb3Router_7_io_outputs_6_PSEL        ), //o
    .io_outputs_6_PENABLE   (apb3Router_7_io_outputs_6_PENABLE     ), //o
    .io_outputs_6_PREADY    (systickCtrl_io_apb_PREADY             ), //i
    .io_outputs_6_PWRITE    (apb3Router_7_io_outputs_6_PWRITE      ), //o
    .io_outputs_6_PWDATA    (apb3Router_7_io_outputs_6_PWDATA[31:0]), //o
    .io_outputs_6_PRDATA    (systickCtrl_io_apb_PRDATA[31:0]       ), //i
    .io_outputs_6_PSLVERROR (systickCtrl_io_apb_PSLVERROR          ), //i
    .io_outputs_7_PADDR     (apb3Router_7_io_outputs_7_PADDR[19:0] ), //o
    .io_outputs_7_PSEL      (apb3Router_7_io_outputs_7_PSEL        ), //o
    .io_outputs_7_PENABLE   (apb3Router_7_io_outputs_7_PENABLE     ), //o
    .io_outputs_7_PREADY    (lcdCtrl_io_apb_PREADY                 ), //i
    .io_outputs_7_PWRITE    (apb3Router_7_io_outputs_7_PWRITE      ), //o
    .io_outputs_7_PWDATA    (apb3Router_7_io_outputs_7_PWDATA[31:0]), //o
    .io_outputs_7_PRDATA    (lcdCtrl_io_apb_PRDATA[31:0]           ), //i
    .io_outputs_7_PSLVERROR (1'b0                                  ), //i
    .io_outputs_8_PADDR     (apb3Router_7_io_outputs_8_PADDR[19:0] ), //o
    .io_outputs_8_PSEL      (apb3Router_7_io_outputs_8_PSEL        ), //o
    .io_outputs_8_PENABLE   (apb3Router_7_io_outputs_8_PENABLE     ), //o
    .io_outputs_8_PREADY    (afioCtrl_io_apb_PREADY                ), //i
    .io_outputs_8_PWRITE    (apb3Router_7_io_outputs_8_PWRITE      ), //o
    .io_outputs_8_PWDATA    (apb3Router_7_io_outputs_8_PWDATA[31:0]), //o
    .io_outputs_8_PRDATA    (afioCtrl_io_apb_PRDATA[31:0]          ), //i
    .io_outputs_8_PSLVERROR (afioCtrl_io_apb_PSLVERROR             ), //i
    .io_outputs_9_PADDR     (apb3Router_7_io_outputs_9_PADDR[19:0] ), //o
    .io_outputs_9_PSEL      (apb3Router_7_io_outputs_9_PSEL        ), //o
    .io_outputs_9_PENABLE   (apb3Router_7_io_outputs_9_PENABLE     ), //o
    .io_outputs_9_PREADY    (extiCtrl_io_apb_PREADY                ), //i
    .io_outputs_9_PWRITE    (apb3Router_7_io_outputs_9_PWRITE      ), //o
    .io_outputs_9_PWDATA    (apb3Router_7_io_outputs_9_PWDATA[31:0]), //o
    .io_outputs_9_PRDATA    (extiCtrl_io_apb_PRDATA[31:0]          ), //i
    .io_outputs_9_PSLVERROR (extiCtrl_io_apb_PSLVERROR             ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_lcdclk = dvt_clk;
  assign extiInterrupt = (|extiCtrl_io_interrupt);
  assign timInterrupt = (|timCtrl_io_interrupt);
  assign systickInterrupt = (|systickCtrl_io_interrupt);
  assign uartInterrupt = (|uartCtrl_io_interrupt);
  assign i2cInterrupt = (|i2cCtrl_io_interrupt);
  assign spiInterrupt = (|spiCtrl_io_interrupt);
  assign afioCtrl_io_device_read = {{{{{{{{{{{{_zz_io_device_read,_zz_io_device_read_1},spiCtrl_io_spis_0_sclk},i2cCtrl_io_i2cs_1_scl},i2cCtrl_io_i2cs_1_sda_write},i2cCtrl_io_i2cs_0_scl},i2cCtrl_io_i2cs_0_sda_write},1'b0},uartCtrl_io_uarts_1_txd},1'b0},uartCtrl_io_uarts_0_txd},timCtrl_io_ch},8'h0};
  assign uartCtrl_io_uarts_0_rxd = afioCtrl_io_device_write[17];
  assign uartCtrl_io_uarts_1_rxd = afioCtrl_io_device_write[19];
  assign spiCtrl_io_spis_0_miso = afioCtrl_io_device_write[27];
  assign spiCtrl_io_spis_1_miso = afioCtrl_io_device_write[31];
  assign i2cCtrl_io_i2cs_0_sda_read = afioCtrl_io_device_write[20];
  assign i2cCtrl_io_i2cs_1_sda_read = afioCtrl_io_device_write[22];
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign gpioCtrl_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[12:0];
  assign uartCtrl_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[12:0];
  assign i2cCtrl_io_apb_PADDR = apb3Router_7_io_outputs_2_PADDR[12:0];
  assign spiCtrl_io_apb_PADDR = apb3Router_7_io_outputs_3_PADDR[12:0];
  assign timCtrl_io_apb_PADDR = apb3Router_7_io_outputs_4_PADDR[12:0];
  assign wdgCtrl_io_apb_PADDR = apb3Router_7_io_outputs_5_PADDR[12:0];
  assign systickCtrl_io_apb_PADDR = apb3Router_7_io_outputs_6_PADDR[3:0];
  assign lcdCtrl_io_apb_PADDR = apb3Router_7_io_outputs_7_PADDR[9:0];
  assign afioCtrl_io_apb_PADDR = apb3Router_7_io_outputs_8_PADDR[4:0];
  assign extiCtrl_io_apb_PADDR = apb3Router_7_io_outputs_9_PADDR[4:0];
  always @(*) begin
    io_interrupt = 16'h0;
    io_interrupt[0] = uartInterrupt;
    io_interrupt[1] = timInterrupt;
    io_interrupt[2] = systickInterrupt;
    io_interrupt[3] = extiInterrupt;
    io_interrupt[4] = i2cInterrupt;
    io_interrupt[15] = spiInterrupt;
  end

  assign io_gpio_write = gpioCtrl_io_gpio_write;
  assign io_gpio_readEnable = ~gpioCtrl_io_gpio_writeEnable;
  assign io_dvti_vs = lcdCtrl_io_dvti_vs;
  assign io_dvti_hs = lcdCtrl_io_dvti_hs;
  assign io_dvti_de = lcdCtrl_io_dvti_de;
  assign io_dvti_data = { lcdCtrl_io_dvti_data[15:11], lcdCtrl_io_dvti_data[15:13],  // R 5¡ú8
                          lcdCtrl_io_dvti_data[10:5],  lcdCtrl_io_dvti_data[10:9],   // G 6¡ú8
                          lcdCtrl_io_dvti_data[4:0],   lcdCtrl_io_dvti_data[4:2]     // B 5¡ú8
                        };
  assign io_axi_ar_valid = lcdCtrl_io_axi_ar_valid;
  assign io_axi_ar_payload_addr = lcdCtrl_io_axi_ar_payload_addr;
  assign io_axi_ar_payload_len = lcdCtrl_io_axi_ar_payload_len;
  assign io_axi_ar_payload_size = lcdCtrl_io_axi_ar_payload_size;
  assign io_axi_ar_payload_cache = lcdCtrl_io_axi_ar_payload_cache;
  assign io_axi_ar_payload_prot = lcdCtrl_io_axi_ar_payload_prot;
  assign io_axi_r_ready = lcdCtrl_io_axi_r_ready;

endmodule

module Apb3Router_6 (
  input  wire [19:0]   io_input_PADDR,
  input  wire [9:0]    io_input_PSEL,
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
  output wire [19:0]   io_outputs_9_PADDR,
  output wire [0:0]    io_outputs_9_PSEL,
  output wire          io_outputs_9_PENABLE,
  input  wire          io_outputs_9_PREADY,
  output wire          io_outputs_9_PWRITE,
  output wire [31:0]   io_outputs_9_PWDATA,
  input  wire [31:0]   io_outputs_9_PRDATA,
  input  wire          io_outputs_9_PSLVERROR,
  input  wire          clk,
  input  wire          reset
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
  wire                _zz_selIndex_8;
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
      4'b1000 : begin
        _zz_io_input_PREADY = io_outputs_8_PREADY;
        _zz_io_input_PRDATA = io_outputs_8_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_8_PSLVERROR;
      end
      default : begin
        _zz_io_input_PREADY = io_outputs_9_PREADY;
        _zz_io_input_PRDATA = io_outputs_9_PRDATA;
        _zz_io_input_PSLVERROR = io_outputs_9_PSLVERROR;
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
  assign io_outputs_9_PADDR = io_input_PADDR;
  assign io_outputs_9_PENABLE = io_input_PENABLE;
  assign io_outputs_9_PSEL[0] = io_input_PSEL[9];
  assign io_outputs_9_PWRITE = io_input_PWRITE;
  assign io_outputs_9_PWDATA = io_input_PWDATA;
  assign _zz_selIndex = io_input_PSEL[3];
  assign _zz_selIndex_1 = io_input_PSEL[5];
  assign _zz_selIndex_2 = io_input_PSEL[6];
  assign _zz_selIndex_3 = io_input_PSEL[7];
  assign _zz_selIndex_4 = io_input_PSEL[9];
  assign _zz_selIndex_5 = ((((io_input_PSEL[1] || _zz_selIndex) || _zz_selIndex_1) || _zz_selIndex_3) || _zz_selIndex_4);
  assign _zz_selIndex_6 = (((io_input_PSEL[2] || _zz_selIndex) || _zz_selIndex_2) || _zz_selIndex_3);
  assign _zz_selIndex_7 = (((io_input_PSEL[4] || _zz_selIndex_1) || _zz_selIndex_2) || _zz_selIndex_3);
  assign _zz_selIndex_8 = (io_input_PSEL[8] || _zz_selIndex_4);
  assign io_input_PREADY = _zz_io_input_PREADY;
  assign io_input_PRDATA = _zz_io_input_PRDATA;
  assign io_input_PSLVERROR = _zz_io_input_PSLVERROR;
  always @(posedge clk) begin
    selIndex <= {_zz_selIndex_8,{_zz_selIndex_7,{_zz_selIndex_6,_zz_selIndex_5}}};
  end


endmodule

module Apb3Decoder_6 (
  input  wire [19:0]   io_input_PADDR,
  input  wire [0:0]    io_input_PSEL,
  input  wire          io_input_PENABLE,
  output reg           io_input_PREADY,
  input  wire          io_input_PWRITE,
  input  wire [31:0]   io_input_PWDATA,
  output wire [31:0]   io_input_PRDATA,
  output reg           io_input_PSLVERROR,
  output wire [19:0]   io_output_PADDR,
  output reg  [9:0]    io_output_PSEL,
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
    io_output_PSEL[2] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h20000) && io_input_PSEL[0]);
    io_output_PSEL[3] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h30000) && io_input_PSEL[0]);
    io_output_PSEL[4] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h40000) && io_input_PSEL[0]);
    io_output_PSEL[5] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h50000) && io_input_PSEL[0]);
    io_output_PSEL[6] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h60000) && io_input_PSEL[0]);
    io_output_PSEL[7] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'h70000) && io_input_PSEL[0]);
    io_output_PSEL[8] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'hd0000) && io_input_PSEL[0]);
    io_output_PSEL[9] = (((io_input_PADDR & (~ 20'h0ffff)) == 20'he0000) && io_input_PSEL[0]);
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

  assign when_Apb3Decoder_l88 = (io_input_PSEL[0] && (io_output_PSEL == 10'h0));

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
  input  wire          clk,
  input  wire          reset,
  input  wire          dvt_clk,
  input  wire          dvt_reset
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
    .clk                     (clk                              ), //i
    .reset                   (reset                            ), //i
    .dvt_clk                 (dvt_clk                          ), //i
    .dvt_reset               (dvt_reset                        )  //i
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

module Apb3SpiArray (
  input  wire [12:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_spis_0_sclk,
  output wire          io_spis_0_mosi,
  input  wire          io_spis_0_miso,
  output wire          io_spis_0_ss,
  output wire          io_spis_1_sclk,
  output wire          io_spis_1_mosi,
  input  wire          io_spis_1_miso,
  output wire          io_spis_1_ss,
  output reg  [1:0]    io_interrupt,
  input  wire          clk,
  input  wire          reset
);

  wire       [5:0]    SPI_0_io_apb_PADDR;
  wire       [5:0]    SPI_1_io_apb_PADDR;
  wire                SPI_0_io_apb_PREADY;
  wire       [31:0]   SPI_0_io_apb_PRDATA;
  wire                SPI_0_io_apb_PSLVERROR;
  wire                SPI_0_io_spi_sclk;
  wire                SPI_0_io_spi_mosi;
  wire                SPI_0_io_spi_ss;
  wire                SPI_0_io_interrupt;
  wire                SPI_1_io_apb_PREADY;
  wire       [31:0]   SPI_1_io_apb_PRDATA;
  wire                SPI_1_io_apb_PSLVERROR;
  wire                SPI_1_io_spi_sclk;
  wire                SPI_1_io_spi_mosi;
  wire                SPI_1_io_spi_ss;
  wire                SPI_1_io_interrupt;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;

  Apb3Spi SPI_0 (
    .io_apb_PADDR     (SPI_0_io_apb_PADDR[5:0]               ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY    (SPI_0_io_apb_PREADY                   ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA    (SPI_0_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR (SPI_0_io_apb_PSLVERROR                ), //o
    .io_spi_sclk      (SPI_0_io_spi_sclk                     ), //o
    .io_spi_mosi      (SPI_0_io_spi_mosi                     ), //o
    .io_spi_miso      (io_spis_0_miso                        ), //i
    .io_spi_ss        (SPI_0_io_spi_ss                       ), //o
    .io_interrupt     (SPI_0_io_interrupt                    ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3Spi SPI_1 (
    .io_apb_PADDR     (SPI_1_io_apb_PADDR[5:0]               ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY    (SPI_1_io_apb_PREADY                   ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA    (SPI_1_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR (SPI_1_io_apb_PSLVERROR                ), //o
    .io_spi_sclk      (SPI_1_io_spi_sclk                     ), //o
    .io_spi_mosi      (SPI_1_io_spi_mosi                     ), //o
    .io_spi_miso      (io_spis_1_miso                        ), //i
    .io_spi_ss        (SPI_1_io_spi_ss                       ), //o
    .io_interrupt     (SPI_1_io_interrupt                    ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
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
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (SPI_0_io_apb_PREADY                   ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (SPI_0_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_0_PSLVERROR (SPI_0_io_apb_PSLVERROR                ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (SPI_1_io_apb_PREADY                   ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (SPI_1_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_1_PSLVERROR (SPI_1_io_apb_PSLVERROR                ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign SPI_0_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[5:0];
  assign SPI_1_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[5:0];
  assign io_spis_0_sclk = SPI_0_io_spi_sclk;
  assign io_spis_0_mosi = SPI_0_io_spi_mosi;
  assign io_spis_0_ss = SPI_0_io_spi_ss;
  always @(*) begin
    io_interrupt[0] = SPI_0_io_interrupt;
    io_interrupt[1] = SPI_1_io_interrupt;
  end

  assign io_spis_1_sclk = SPI_1_io_spi_sclk;
  assign io_spis_1_mosi = SPI_1_io_spi_mosi;
  assign io_spis_1_ss = SPI_1_io_spi_ss;

endmodule

module Apb3I2cArray (
  input  wire [12:0]   io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output wire [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_i2cs_0_scl,
  input  wire [0:0]    io_i2cs_0_sda_read,
  output wire [0:0]    io_i2cs_0_sda_write,
  output wire [0:0]    io_i2cs_0_sda_writeEnable,
  output wire          io_i2cs_1_scl,
  input  wire [0:0]    io_i2cs_1_sda_read,
  output wire [0:0]    io_i2cs_1_sda_write,
  output wire [0:0]    io_i2cs_1_sda_writeEnable,
  output reg  [1:0]    io_interrupt,
  input  wire          clk,
  input  wire          reset
);

  wire       [5:0]    I2C_0_io_apb_PADDR;
  wire       [5:0]    I2C_1_io_apb_PADDR;
  wire                I2C_0_io_apb_PREADY;
  wire       [31:0]   I2C_0_io_apb_PRDATA;
  wire                I2C_0_io_apb_PSLVERROR;
  wire                I2C_0_io_i2c_scl;
  wire       [0:0]    I2C_0_io_i2c_sda_write;
  wire       [0:0]    I2C_0_io_i2c_sda_writeEnable;
  wire                I2C_0_io_interrupt;
  wire                I2C_1_io_apb_PREADY;
  wire       [31:0]   I2C_1_io_apb_PRDATA;
  wire                I2C_1_io_apb_PSLVERROR;
  wire                I2C_1_io_i2c_scl;
  wire       [0:0]    I2C_1_io_i2c_sda_write;
  wire       [0:0]    I2C_1_io_i2c_sda_writeEnable;
  wire                I2C_1_io_interrupt;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;

  Apb3I2c I2C_0 (
    .io_apb_PADDR           (I2C_0_io_apb_PADDR[5:0]               ), //i
    .io_apb_PSEL            (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE         (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY          (I2C_0_io_apb_PREADY                   ), //o
    .io_apb_PWRITE          (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA          (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA          (I2C_0_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR       (I2C_0_io_apb_PSLVERROR                ), //o
    .io_i2c_scl             (I2C_0_io_i2c_scl                      ), //o
    .io_i2c_sda_read        (io_i2cs_0_sda_read                    ), //i
    .io_i2c_sda_write       (I2C_0_io_i2c_sda_write                ), //o
    .io_i2c_sda_writeEnable (I2C_0_io_i2c_sda_writeEnable          ), //o
    .io_interrupt           (I2C_0_io_interrupt                    ), //o
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  Apb3I2c I2C_1 (
    .io_apb_PADDR           (I2C_1_io_apb_PADDR[5:0]               ), //i
    .io_apb_PSEL            (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE         (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY          (I2C_1_io_apb_PREADY                   ), //o
    .io_apb_PWRITE          (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA          (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA          (I2C_1_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR       (I2C_1_io_apb_PSLVERROR                ), //o
    .io_i2c_scl             (I2C_1_io_i2c_scl                      ), //o
    .io_i2c_sda_read        (io_i2cs_1_sda_read                    ), //i
    .io_i2c_sda_write       (I2C_1_io_i2c_sda_write                ), //o
    .io_i2c_sda_writeEnable (I2C_1_io_i2c_sda_writeEnable          ), //o
    .io_interrupt           (I2C_1_io_interrupt                    ), //o
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
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
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (I2C_0_io_apb_PREADY                   ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (I2C_0_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_0_PSLVERROR (I2C_0_io_apb_PSLVERROR                ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (I2C_1_io_apb_PREADY                   ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (I2C_1_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_1_PSLVERROR (I2C_1_io_apb_PSLVERROR                ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign I2C_0_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[5:0];
  assign I2C_1_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[5:0];
  assign io_i2cs_0_scl = I2C_0_io_i2c_scl;
  assign io_i2cs_0_sda_write = I2C_0_io_i2c_sda_write;
  assign io_i2cs_0_sda_writeEnable = I2C_0_io_i2c_sda_writeEnable;
  always @(*) begin
    io_interrupt[0] = I2C_0_io_interrupt;
    io_interrupt[1] = I2C_1_io_interrupt;
  end

  assign io_i2cs_1_scl = I2C_1_io_i2c_scl;
  assign io_i2cs_1_sda_write = I2C_1_io_i2c_sda_write;
  assign io_i2cs_1_sda_writeEnable = I2C_1_io_i2c_sda_writeEnable;

endmodule

module Apb3UartArray (
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
  input  wire          clk,
  input  wire          reset
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
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;

  Apb3Uart UART_0 (
    .io_apb_PADDR     (UART_0_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY    (UART_0_io_apb_PREADY                  ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA    (UART_0_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR (UART_0_io_apb_PSLVERROR               ), //o
    .io_uart_txd      (UART_0_io_uart_txd                    ), //o
    .io_uart_rxd      (io_uarts_0_rxd                        ), //i
    .io_interrupt     (UART_0_io_interrupt                   ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3Uart UART_1 (
    .io_apb_PADDR     (UART_1_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY    (UART_1_io_apb_PREADY                  ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA    (UART_1_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR (UART_1_io_apb_PSLVERROR               ), //o
    .io_uart_txd      (UART_1_io_uart_txd                    ), //o
    .io_uart_rxd      (io_uarts_1_rxd                        ), //i
    .io_interrupt     (UART_1_io_interrupt                   ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
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
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (UART_0_io_apb_PREADY                  ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (UART_0_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_0_PSLVERROR (UART_0_io_apb_PSLVERROR               ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (UART_1_io_apb_PREADY                  ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (UART_1_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_1_PSLVERROR (UART_1_io_apb_PSLVERROR               ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign UART_0_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[4:0];
  assign UART_1_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[4:0];
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
  input  wire          clk,
  input  wire          reset
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
  input  wire          clk,
  input  wire          reset
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
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;

  Apb3Iwdg iwdg (
    .io_apb_PADDR     (iwdg_io_apb_PADDR[3:0]                ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY    (iwdg_io_apb_PREADY                    ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA    (iwdg_io_apb_PRDATA[31:0]              ), //o
    .io_apb_PSLVERROR (iwdg_io_apb_PSLVERROR                 ), //o
    .io_rst           (iwdg_io_rst                           ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3Wwdg wwdg (
    .io_apb_PADDR     (wwdg_io_apb_PADDR[4:0]                ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY    (wwdg_io_apb_PREADY                    ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA    (wwdg_io_apb_PRDATA[31:0]              ), //o
    .io_apb_PSLVERROR (wwdg_io_apb_PSLVERROR                 ), //o
    .io_rst           (wwdg_io_rst                           ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
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
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (iwdg_io_apb_PREADY                    ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (iwdg_io_apb_PRDATA[31:0]              ), //i
    .io_outputs_0_PSLVERROR (iwdg_io_apb_PSLVERROR                 ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (wwdg_io_apb_PREADY                    ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (wwdg_io_apb_PRDATA[31:0]              ), //i
    .io_outputs_1_PSLVERROR (wwdg_io_apb_PSLVERROR                 ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign iwdg_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[3:0];
  assign wwdg_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[4:0];
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
  output reg  [7:0]    io_ch,
  output reg  [1:0]    io_interrupt,
  input  wire          clk,
  input  wire          reset
);

  wire       [6:0]    TIM_0_io_apb_PADDR;
  wire       [6:0]    TIM_1_io_apb_PADDR;
  wire                TIM_0_io_apb_PREADY;
  wire       [31:0]   TIM_0_io_apb_PRDATA;
  wire                TIM_0_io_apb_PSLVERROR;
  wire       [3:0]    TIM_0_io_ch;
  wire                TIM_0_io_interrupt;
  wire                TIM_1_io_apb_PREADY;
  wire       [31:0]   TIM_1_io_apb_PRDATA;
  wire                TIM_1_io_apb_PSLVERROR;
  wire       [3:0]    TIM_1_io_ch;
  wire                TIM_1_io_interrupt;
  wire                io_apb_decoder_io_input_PREADY;
  wire       [31:0]   io_apb_decoder_io_input_PRDATA;
  wire                io_apb_decoder_io_input_PSLVERROR;
  wire       [12:0]   io_apb_decoder_io_output_PADDR;
  wire       [1:0]    io_apb_decoder_io_output_PSEL;
  wire                io_apb_decoder_io_output_PENABLE;
  wire                io_apb_decoder_io_output_PWRITE;
  wire       [31:0]   io_apb_decoder_io_output_PWDATA;
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;

  Apb3Tim TIM_0 (
    .io_apb_PADDR     (TIM_0_io_apb_PADDR[6:0]               ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY    (TIM_0_io_apb_PREADY                   ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA    (TIM_0_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR (TIM_0_io_apb_PSLVERROR                ), //o
    .io_ch            (TIM_0_io_ch[3:0]                      ), //o
    .io_interrupt     (TIM_0_io_interrupt                    ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
  );
  Apb3Tim TIM_1 (
    .io_apb_PADDR     (TIM_1_io_apb_PADDR[6:0]               ), //i
    .io_apb_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY    (TIM_1_io_apb_PREADY                   ), //o
    .io_apb_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA    (TIM_1_io_apb_PRDATA[31:0]             ), //o
    .io_apb_PSLVERROR (TIM_1_io_apb_PSLVERROR                ), //o
    .io_ch            (TIM_1_io_ch[3:0]                      ), //o
    .io_interrupt     (TIM_1_io_interrupt                    ), //o
    .clk              (clk                                   ), //i
    .reset            (reset                                 )  //i
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
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (TIM_0_io_apb_PREADY                   ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (TIM_0_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_0_PSLVERROR (TIM_0_io_apb_PSLVERROR                ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (TIM_1_io_apb_PREADY                   ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (TIM_1_io_apb_PRDATA[31:0]             ), //i
    .io_outputs_1_PSLVERROR (TIM_1_io_apb_PSLVERROR                ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign TIM_0_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[6:0];
  assign TIM_1_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[6:0];
  always @(*) begin
    io_ch[3 : 0] = TIM_0_io_ch;
    io_ch[7 : 4] = TIM_1_io_ch;
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
  input  wire          clk,
  input  wire          reset
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
  wire                apb3Router_7_io_input_PREADY;
  wire       [31:0]   apb3Router_7_io_input_PRDATA;
  wire                apb3Router_7_io_input_PSLVERROR;
  wire       [12:0]   apb3Router_7_io_outputs_0_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_0_PSEL;
  wire                apb3Router_7_io_outputs_0_PENABLE;
  wire                apb3Router_7_io_outputs_0_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_0_PWDATA;
  wire       [12:0]   apb3Router_7_io_outputs_1_PADDR;
  wire       [0:0]    apb3Router_7_io_outputs_1_PSEL;
  wire                apb3Router_7_io_outputs_1_PENABLE;
  wire                apb3Router_7_io_outputs_1_PWRITE;
  wire       [31:0]   apb3Router_7_io_outputs_1_PWDATA;
  wire       [31:0]   gpioVec_read;
  reg        [31:0]   gpioVec_write;
  reg        [31:0]   gpioVec_writeEnable;

  Apb3Gpio GPIO_0 (
    .io_apb_PADDR        (GPIO_0_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL         (apb3Router_7_io_outputs_0_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_7_io_outputs_0_PENABLE     ), //i
    .io_apb_PREADY       (GPIO_0_io_apb_PREADY                  ), //o
    .io_apb_PWRITE       (apb3Router_7_io_outputs_0_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_7_io_outputs_0_PWDATA[31:0]), //i
    .io_apb_PRDATA       (GPIO_0_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR    (GPIO_0_io_apb_PSLVERROR               ), //o
    .io_gpio_read        (GPIO_0_io_gpio_read[15:0]             ), //i
    .io_gpio_write       (GPIO_0_io_gpio_write[15:0]            ), //o
    .io_gpio_writeEnable (GPIO_0_io_gpio_writeEnable[15:0]      ), //o
    .io_afio             (GPIO_0_io_afio[15:0]                  ), //i
    .clk                 (clk                                   ), //i
    .reset               (reset                                 )  //i
  );
  Apb3Gpio GPIO_1 (
    .io_apb_PADDR        (GPIO_1_io_apb_PADDR[4:0]              ), //i
    .io_apb_PSEL         (apb3Router_7_io_outputs_1_PSEL        ), //i
    .io_apb_PENABLE      (apb3Router_7_io_outputs_1_PENABLE     ), //i
    .io_apb_PREADY       (GPIO_1_io_apb_PREADY                  ), //o
    .io_apb_PWRITE       (apb3Router_7_io_outputs_1_PWRITE      ), //i
    .io_apb_PWDATA       (apb3Router_7_io_outputs_1_PWDATA[31:0]), //i
    .io_apb_PRDATA       (GPIO_1_io_apb_PRDATA[31:0]            ), //o
    .io_apb_PSLVERROR    (GPIO_1_io_apb_PSLVERROR               ), //o
    .io_gpio_read        (GPIO_1_io_gpio_read[15:0]             ), //i
    .io_gpio_write       (GPIO_1_io_gpio_write[15:0]            ), //o
    .io_gpio_writeEnable (GPIO_1_io_gpio_writeEnable[15:0]      ), //o
    .io_afio             (GPIO_1_io_afio[15:0]                  ), //i
    .clk                 (clk                                   ), //i
    .reset               (reset                                 )  //i
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
    .io_output_PREADY    (apb3Router_7_io_input_PREADY         ), //i
    .io_output_PWRITE    (io_apb_decoder_io_output_PWRITE      ), //o
    .io_output_PWDATA    (io_apb_decoder_io_output_PWDATA[31:0]), //o
    .io_output_PRDATA    (apb3Router_7_io_input_PRDATA[31:0]   ), //i
    .io_output_PSLVERROR (apb3Router_7_io_input_PSLVERROR      )  //i
  );
  Apb3Router apb3Router_7 (
    .io_input_PADDR         (io_apb_decoder_io_output_PADDR[12:0]  ), //i
    .io_input_PSEL          (io_apb_decoder_io_output_PSEL[1:0]    ), //i
    .io_input_PENABLE       (io_apb_decoder_io_output_PENABLE      ), //i
    .io_input_PREADY        (apb3Router_7_io_input_PREADY          ), //o
    .io_input_PWRITE        (io_apb_decoder_io_output_PWRITE       ), //i
    .io_input_PWDATA        (io_apb_decoder_io_output_PWDATA[31:0] ), //i
    .io_input_PRDATA        (apb3Router_7_io_input_PRDATA[31:0]    ), //o
    .io_input_PSLVERROR     (apb3Router_7_io_input_PSLVERROR       ), //o
    .io_outputs_0_PADDR     (apb3Router_7_io_outputs_0_PADDR[12:0] ), //o
    .io_outputs_0_PSEL      (apb3Router_7_io_outputs_0_PSEL        ), //o
    .io_outputs_0_PENABLE   (apb3Router_7_io_outputs_0_PENABLE     ), //o
    .io_outputs_0_PREADY    (GPIO_0_io_apb_PREADY                  ), //i
    .io_outputs_0_PWRITE    (apb3Router_7_io_outputs_0_PWRITE      ), //o
    .io_outputs_0_PWDATA    (apb3Router_7_io_outputs_0_PWDATA[31:0]), //o
    .io_outputs_0_PRDATA    (GPIO_0_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_0_PSLVERROR (GPIO_0_io_apb_PSLVERROR               ), //i
    .io_outputs_1_PADDR     (apb3Router_7_io_outputs_1_PADDR[12:0] ), //o
    .io_outputs_1_PSEL      (apb3Router_7_io_outputs_1_PSEL        ), //o
    .io_outputs_1_PENABLE   (apb3Router_7_io_outputs_1_PENABLE     ), //o
    .io_outputs_1_PREADY    (GPIO_1_io_apb_PREADY                  ), //i
    .io_outputs_1_PWRITE    (apb3Router_7_io_outputs_1_PWRITE      ), //o
    .io_outputs_1_PWDATA    (apb3Router_7_io_outputs_1_PWDATA[31:0]), //o
    .io_outputs_1_PRDATA    (GPIO_1_io_apb_PRDATA[31:0]            ), //i
    .io_outputs_1_PSLVERROR (GPIO_1_io_apb_PSLVERROR               ), //i
    .clk                    (clk                                   ), //i
    .reset                  (reset                                 )  //i
  );
  assign io_apb_PREADY = io_apb_decoder_io_input_PREADY;
  assign io_apb_PRDATA = io_apb_decoder_io_input_PRDATA;
  assign io_apb_PSLVERROR = io_apb_decoder_io_input_PSLVERROR;
  assign GPIO_0_io_apb_PADDR = apb3Router_7_io_outputs_0_PADDR[4:0];
  assign GPIO_1_io_apb_PADDR = apb3Router_7_io_outputs_1_PADDR[4:0];
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
  input  wire          clk,
  input  wire          reset
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
  input  wire          clk,
  input  wire          reset
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
  assign io_afio_write = io_device_read;
  assign io_device_write = io_afio_read;
  assign io_afio_writeEnable = 32'h00000001;
  assign io_device_writeEnable = 32'h00000001;
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
  input  wire          clk,
  input  wire          reset,
  input  wire          dvt_clk,
  input  wire          dvt_reset
);

  wire                layerDma_io_start;
  wire       [26:0]   layerDma_io_base;
  wire       [16:0]   layerDma_io_size;
  reg                 layerDma_io_frame_ready;
  wire                bufferCC_30_io_dataIn;
  wire                bufferCC_31_io_dataIn;
  wire                bufferCC_32_io_dataIn;
  wire       [11:0]   bufferCC_33_io_dataIn;
  wire       [11:0]   bufferCC_34_io_dataIn;
  wire       [11:0]   bufferCC_35_io_dataIn;
  wire       [11:0]   bufferCC_36_io_dataIn;
  wire                bufferCC_37_io_dataIn;
  wire       [11:0]   bufferCC_38_io_dataIn;
  wire       [11:0]   bufferCC_39_io_dataIn;
  wire       [11:0]   bufferCC_40_io_dataIn;
  wire       [11:0]   bufferCC_41_io_dataIn;
  wire                bufferCC_42_io_dataIn;
  wire                bufferCC_43_io_dataIn;
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
  wire                bufferCC_30_io_dataOut;
  wire                bufferCC_31_io_dataOut;
  wire                bufferCC_32_io_dataOut;
  wire       [11:0]   bufferCC_33_io_dataOut;
  wire       [11:0]   bufferCC_34_io_dataOut;
  wire       [11:0]   bufferCC_35_io_dataOut;
  wire       [11:0]   bufferCC_36_io_dataOut;
  wire                bufferCC_37_io_dataOut;
  wire       [11:0]   bufferCC_38_io_dataOut;
  wire       [11:0]   bufferCC_39_io_dataOut;
  wire       [11:0]   bufferCC_40_io_dataOut;
  wire       [11:0]   bufferCC_41_io_dataOut;
  wire                bufferCC_42_io_dataOut;
  wire                bufferCC_43_io_dataOut;
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
  wire                when_Apb3Dvtc_l325;
  wire                when_Apb3Dvtc_l330;
  wire                when_Apb3Dvtc_l334;
  wire                when_Apb3Dvtc_l335;
  wire                layerDma_io_frame_translated_valid;
  wire                layerDma_io_frame_translated_ready;
  wire       [15:0]   layerDma_io_frame_translated_payload;
  wire                _zz_layerDma_io_frame_translated_ready;
  wire                layerDma_io_frame_translated_haltWhen_valid;
  wire                layerDma_io_frame_translated_haltWhen_ready;
  wire       [15:0]   layerDma_io_frame_translated_haltWhen_payload;
  wire                when_Apb3Dvtc_l359;
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
  wire                when_Apb3Dvtc_l379;

  assign _zz_line_match_1 = LIPCR[11 : 0];
  assign _zz_line_match = {4'd0, _zz_line_match_1};
  assign _zz_io_size = (_zz_io_size_1 >>> 3'd5);
  assign _zz_io_size_1 = (_zz_io_size_2 - 32'h00000001);
  assign _zz_io_size_2 = (CFBLNR[15 : 0] * CFBLR[31 : 16]);
  VideoDma layerDma (
    .io_start                    (layerDma_io_start                       ), //i
    .io_busy                     (layerDma_io_busy                        ), //o
    .io_base                     (layerDma_io_base[26:0]                  ), //i
    .io_size                     (layerDma_io_size[16:0]                  ), //i
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
    .clk                         (clk                                     ), //i
    .reset                       (reset                                   ), //i
    .dvt_clk                     (dvt_clk                                 ), //i
    .dvt_reset                   (dvt_reset                               )  //i
  );
  DVTimingDyn dvt (
    .io_en            (bufferCC_30_io_dataOut                             ), //i
    .io_cfg_hsync     (bufferCC_38_io_dataOut[11:0]                       ), //i
    .io_cfg_hback     (bufferCC_39_io_dataOut[11:0]                       ), //i
    .io_cfg_hdisp     (bufferCC_40_io_dataOut[11:0]                       ), //i
    .io_cfg_htotal    (bufferCC_41_io_dataOut[11:0]                       ), //i
    .io_cfg_vsync     (bufferCC_33_io_dataOut[11:0]                       ), //i
    .io_cfg_vback     (bufferCC_34_io_dataOut[11:0]                       ), //i
    .io_cfg_vdisp     (bufferCC_35_io_dataOut[11:0]                       ), //i
    .io_cfg_vtotal    (bufferCC_36_io_dataOut[11:0]                       ), //i
    .io_cfg_vspol     (bufferCC_37_io_dataOut                             ), //i
    .io_cfg_hspol     (bufferCC_42_io_dataOut                             ), //i
    .io_cfg_depol     (bufferCC_32_io_dataOut                             ), //i
    .io_cfg_pcpol     (bufferCC_31_io_dataOut                             ), //i
    .io_pixel_valid   (layerDma_io_frame_translated_haltWhen_valid        ), //i
    .io_pixel_ready   (dvt_io_pixel_ready                                 ), //o
    .io_pixel_payload (layerDma_io_frame_translated_haltWhen_payload[15:0]), //i
    .io_pos_x         (dvt_io_pos_x[15:0]                                 ), //o
    .io_pos_y         (dvt_io_pos_y[15:0]                                 ), //o
    .io_dvti_vs       (dvt_io_dvti_vs                                     ), //o
    .io_dvti_hs       (dvt_io_dvti_hs                                     ), //o
    .io_dvti_de       (dvt_io_dvti_de                                     ), //o
    .io_dvti_data     (dvt_io_dvti_data[15:0]                             ), //o
    .io_hen           (dvt_io_hen                                         ), //o
    .io_ven           (dvt_io_ven                                         ), //o
    .dvt_clk          (dvt_clk                                            ), //i
    .dvt_reset        (dvt_reset                                          )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_10 bufferCC_30 (
    .io_dataIn  (bufferCC_30_io_dataIn ), //i
    .io_dataOut (bufferCC_30_io_dataOut), //o
    .dvt_clk    (dvt_clk               ), //i
    .dvt_reset  (dvt_reset             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_10 bufferCC_31 (
    .io_dataIn  (bufferCC_31_io_dataIn ), //i
    .io_dataOut (bufferCC_31_io_dataOut), //o
    .dvt_clk    (dvt_clk               ), //i
    .dvt_reset  (dvt_reset             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_10 bufferCC_32 (
    .io_dataIn  (bufferCC_32_io_dataIn ), //i
    .io_dataOut (bufferCC_32_io_dataOut), //o
    .dvt_clk    (dvt_clk               ), //i
    .dvt_reset  (dvt_reset             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_33 (
    .io_dataIn  (bufferCC_33_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_33_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_34 (
    .io_dataIn  (bufferCC_34_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_34_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_35 (
    .io_dataIn  (bufferCC_35_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_35_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_36 (
    .io_dataIn  (bufferCC_36_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_36_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_10 bufferCC_37 (
    .io_dataIn  (bufferCC_37_io_dataIn ), //i
    .io_dataOut (bufferCC_37_io_dataOut), //o
    .dvt_clk    (dvt_clk               ), //i
    .dvt_reset  (dvt_reset             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_38 (
    .io_dataIn  (bufferCC_38_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_38_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_39 (
    .io_dataIn  (bufferCC_39_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_39_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_40 (
    .io_dataIn  (bufferCC_40_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_40_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_13 bufferCC_41 (
    .io_dataIn  (bufferCC_41_io_dataIn[11:0] ), //i
    .io_dataOut (bufferCC_41_io_dataOut[11:0]), //o
    .dvt_clk    (dvt_clk                     ), //i
    .dvt_reset  (dvt_reset                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_10 bufferCC_42 (
    .io_dataIn  (bufferCC_42_io_dataIn ), //i
    .io_dataOut (bufferCC_42_io_dataOut), //o
    .dvt_clk    (dvt_clk               ), //i
    .dvt_reset  (dvt_reset             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_10 bufferCC_43 (
    .io_dataIn  (bufferCC_43_io_dataIn ), //i
    .io_dataOut (bufferCC_43_io_dataOut), //o
    .dvt_clk    (dvt_clk               ), //i
    .dvt_reset  (dvt_reset             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC dvt_io_pos_x_buffercc (
    .io_dataIn  (dvt_io_pos_x[15:0]                    ), //i
    .io_dataOut (dvt_io_pos_x_buffercc_io_dataOut[15:0]), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC dvt_io_pos_y_buffercc (
    .io_dataIn  (dvt_io_pos_y[15:0]                    ), //i
    .io_dataOut (dvt_io_pos_y_buffercc_io_dataOut[15:0]), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_26 dvt_io_dvti_vs_buffercc (
    .io_dataIn  (dvt_io_dvti_vs                    ), //i
    .io_dataOut (dvt_io_dvti_vs_buffercc_io_dataOut), //o
    .clk        (clk                               ), //i
    .reset      (reset                             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_26 dvt_io_dvti_hs_buffercc (
    .io_dataIn  (dvt_io_dvti_hs                    ), //i
    .io_dataOut (dvt_io_dvti_hs_buffercc_io_dataOut), //o
    .clk        (clk                               ), //i
    .reset      (reset                             )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_26 dvt_io_hen_buffercc (
    .io_dataIn  (dvt_io_hen                    ), //i
    .io_dataOut (dvt_io_hen_buffercc_io_dataOut), //o
    .clk        (clk                           ), //i
    .reset      (reset                         )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_26 dvt_io_ven_buffercc (
    .io_dataIn  (dvt_io_ven                    ), //i
    .io_dataOut (dvt_io_ven_buffercc_io_dataOut), //o
    .clk        (clk                           ), //i
    .reset      (reset                         )  //i
  );
  PulseCCByToggle dvtArea_frameStart_pulseCCByToggle (
    .io_pulseIn  (dvtArea_frameStart                            ), //i
    .io_pulseOut (dvtArea_frameStart_pulseCCByToggle_io_pulseOut), //o
    .dvt_clk     (dvt_clk                                       ), //i
    .dvt_reset   (dvt_reset                                     ), //i
    .clk         (clk                                           )  //i
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
  assign bufferCC_30_io_dataIn = GCR[0];
  assign bufferCC_31_io_dataIn = GCR[28];
  assign bufferCC_32_io_dataIn = GCR[29];
  assign bufferCC_33_io_dataIn = SSCR[11 : 0];
  assign bufferCC_34_io_dataIn = BPCR[11 : 0];
  assign bufferCC_35_io_dataIn = AWCR[11 : 0];
  assign bufferCC_36_io_dataIn = TWCR[11 : 0];
  assign bufferCC_37_io_dataIn = GCR[30];
  assign bufferCC_38_io_dataIn = SSCR[27 : 16];
  assign bufferCC_39_io_dataIn = BPCR[27 : 16];
  assign bufferCC_40_io_dataIn = AWCR[27 : 16];
  assign bufferCC_41_io_dataIn = TWCR[27 : 16];
  assign bufferCC_42_io_dataIn = GCR[31];
  assign _zz_dvtArea_frameStart = (dvt_io_dvti_vs && (! dvt_io_dvti_vs_regNext_1));
  assign dvtArea_frameStart = (bufferCC_37_io_dataOut ? (dvt_io_dvti_vs && (! dvt_io_dvti_vs_regNext)) : ((! _zz_dvtArea_frameStart) && _zz_dvtArea_frameStart_1));
  assign layerDma_io_frame_fire = (layerDma_io_frame_valid && layerDma_io_frame_ready);
  assign when_Apb3Dvtc_l325 = (layerDma_io_frame_fire && layerDma_io_frame_payload_first);
  assign when_Apb3Dvtc_l330 = (layerDma_io_frame_fire && layerDma_io_frame_payload_last);
  assign when_Apb3Dvtc_l334 = ((! dvtArea_waitStartOfFrame) && (! dvtArea_error));
  assign when_Apb3Dvtc_l335 = ((dvtArea_firstPixel && layerDma_io_frame_valid) && (! layerDma_io_frame_payload_first));
  assign layerDma_io_frame_translated_valid = layerDma_io_frame_valid;
  always @(*) begin
    layerDma_io_frame_ready = layerDma_io_frame_translated_ready;
    if(when_Apb3Dvtc_l359) begin
      layerDma_io_frame_ready = 1'b1;
    end
  end

  assign layerDma_io_frame_translated_payload = layerDma_io_frame_payload_fragment;
  assign _zz_layerDma_io_frame_translated_ready = (! (dvtArea_waitStartOfFrame && (! dvtArea_error)));
  assign layerDma_io_frame_translated_haltWhen_valid = (layerDma_io_frame_translated_valid && _zz_layerDma_io_frame_translated_ready);
  assign layerDma_io_frame_translated_ready = (layerDma_io_frame_translated_haltWhen_ready && _zz_layerDma_io_frame_translated_ready);
  assign layerDma_io_frame_translated_haltWhen_payload = layerDma_io_frame_translated_payload;
  assign layerDma_io_frame_translated_haltWhen_ready = dvt_io_pixel_ready;
  assign bufferCC_43_io_dataIn = (! CR[0]);
  assign when_Apb3Dvtc_l359 = bufferCC_43_io_dataOut;
  assign pos_x_sync = dvt_io_pos_x_buffercc_io_dataOut;
  assign pos_y_sync = dvt_io_pos_y_buffercc_io_dataOut;
  assign vs_sync = dvt_io_dvti_vs_buffercc_io_dataOut;
  assign hs_sync = dvt_io_dvti_hs_buffercc_io_dataOut;
  assign hen_sync = dvt_io_hen_buffercc_io_dataOut;
  assign ven_sync = dvt_io_ven_buffercc_io_dataOut;
  assign vs_rise = (GCR[30] ? (vs_sync && (! vs_sync_regNext)) : ((! vs_sync) && vs_sync_regNext_1));
  assign hs_rise = (GCR[31] ? (hs_sync && (! hs_sync_regNext)) : ((! hs_sync) && hs_sync_regNext_1));
  assign line_match = ((pos_y_sync == _zz_line_match) && hs_rise);
  assign when_Apb3Dvtc_l379 = (line_match && IER[0]);
  assign io_axi_ar_valid = layerDma_io_mem_cmd_valid;
  assign io_axi_ar_payload_addr = ({5'd0,layerDma_io_mem_cmd_payload} <<< 3'd5);
  assign io_axi_ar_payload_len = 8'h07;
  assign io_axi_ar_payload_size = 3'b010;
  assign io_axi_ar_payload_cache = 4'b1111;
  assign io_axi_ar_payload_prot = 3'b010;
  assign io_axi_r_ready = 1'b1;
  assign layerDma_io_base = (CFBAR >>> 3'd5);
  assign layerDma_io_size = _zz_io_size[16:0];
  assign layerDma_io_start = (dvtArea_frameStart_pulseCCByToggle_io_pulseOut && CR[0]);
  assign io_dvti_vs = dvt_io_dvti_vs;
  assign io_dvti_hs = dvt_io_dvti_hs;
  assign io_dvti_de = dvt_io_dvti_de;
  assign io_dvti_data = dvt_io_dvti_data;
  assign io_interrupt = (|(ISR & IER));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
      if(when_Apb3Dvtc_l379) begin
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

  always @(posedge dvt_clk) begin
    dvt_io_dvti_vs_regNext <= dvt_io_dvti_vs;
    dvt_io_dvti_vs_regNext_1 <= dvt_io_dvti_vs;
    _zz_dvtArea_frameStart_1 <= _zz_dvtArea_frameStart;
    if(dvtArea_frameStart) begin
      dvtArea_firstPixel <= 1'b1;
    end
    if(when_Apb3Dvtc_l325) begin
      dvtArea_firstPixel <= 1'b0;
    end
  end

  always @(posedge dvt_clk or posedge dvt_reset) begin
    if(dvt_reset) begin
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
      if(when_Apb3Dvtc_l330) begin
        dvtArea_error <= 1'b0;
        dvtArea_waitStartOfFrame <= dvtArea_error;
      end
      if(when_Apb3Dvtc_l334) begin
        if(when_Apb3Dvtc_l335) begin
          dvtArea_error <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    vs_sync_regNext <= vs_sync;
    vs_sync_regNext_1 <= vs_sync;
    hs_sync_regNext <= hs_sync;
    hs_sync_regNext_1 <= hs_sync;
  end


endmodule

//Apb3Router_5 replaced by Apb3Router

//Apb3Decoder_5 replaced by Apb3Decoder

//Apb3Spi_1 replaced by Apb3Spi

module Apb3Spi (
  input  wire [5:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_spi_sclk,
  output wire          io_spi_mosi,
  input  wire          io_spi_miso,
  output wire          io_spi_ss,
  output wire          io_interrupt,
  input  wire          clk,
  input  wire          reset
);
  localparam SpiState_IDLE = 2'd0;
  localparam SpiState_LOAD = 2'd1;
  localparam SpiState_SHIFT = 2'd2;
  localparam SpiState_DONE = 2'd3;

  reg                 txFifo_io_push_valid;
  reg        [15:0]   txFifo_io_push_payload;
  reg                 txFifo_io_pop_ready;
  reg                 rxFifo_io_push_valid;
  reg        [15:0]   rxFifo_io_push_payload;
  reg                 rxFifo_io_pop_ready;
  wire                txFifo_io_push_ready;
  wire                txFifo_io_pop_valid;
  wire       [15:0]   txFifo_io_pop_payload;
  wire       [4:0]    txFifo_io_occupancy;
  wire       [4:0]    txFifo_io_availability;
  wire                rxFifo_io_push_ready;
  wire                rxFifo_io_pop_valid;
  wire       [15:0]   rxFifo_io_pop_payload;
  wire       [4:0]    rxFifo_io_occupancy;
  wire       [4:0]    rxFifo_io_availability;
  wire       [7:0]    _zz_spiMaster_clockDivider;
  wire       [2:0]    _zz_spiMaster_clockDivider_1;
  wire       [15:0]   _zz_spiMaster_txShiftReg;
  wire       [7:0]    _zz_spiMaster_txShiftReg_1;
  wire       [15:0]   _zz_spiMaster_txShiftReg_2;
  wire       [7:0]    _zz_spiMaster_txShiftReg_3;
  wire       [15:0]   _zz_spiMaster_rxShiftReg;
  wire       [7:0]    _zz_spiMaster_rxShiftReg_1;
  wire       [15:0]   _zz_spiMaster_rxShiftReg_2;
  wire       [7:0]    _zz_spiMaster_rxShiftReg_3;
  wire       [15:0]   _zz_TXCRCR;
  wire       [16:0]   _zz_TXCRCR_1;
  wire       [0:0]    _zz_TXCRCR_2;
  wire       [15:0]   _zz_RXCRCR;
  wire       [16:0]   _zz_RXCRCR_1;
  wire       [0:0]    _zz_RXCRCR_2;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [15:0]   CR1;
  reg        [15:0]   CR2;
  reg        [15:0]   SR;
  wire       [15:0]   DR;
  reg        [15:0]   CRCPR;
  reg        [15:0]   RXCRCR;
  reg        [15:0]   TXCRCR;
  reg        [15:0]   I2SCFGR;
  reg        [15:0]   I2SPR;
  wire                CPHA;
  wire                CPOL;
  wire                MSTR;
  wire       [2:0]    BR;
  wire                SPE;
  wire                LSBFIRST;
  reg                 SSI;
  wire                SSM;
  wire                RXONLY;
  wire                DFF;
  wire                CRCNEXT;
  wire                CRCEN;
  wire                BIDIOE;
  wire                BIDIMODE;
  wire                RXDMAEN;
  wire                TXDMAEN;
  wire                SSOE;
  wire                ERRIE;
  wire                RXEIE;
  wire                TXEIE;
  wire                RXNE;
  wire                TXE;
  wire                CHSIDE;
  wire                UDR;
  wire                CRCERR;
  wire                MODF;
  wire                OVR;
  wire                BSY;
  reg        [7:0]    spiMaster_clockDivider;
  reg        [7:0]    spiMaster_clockCounter;
  wire                spiMaster_sclkToggle;
  reg                 spiMaster_sclkReg;
  wire       [4:0]    spiMaster_frameLength;
  reg        [1:0]    spiMaster_state;
  reg        [15:0]   spiMaster_rxShiftReg;
  reg        [15:0]   spiMaster_txShiftReg;
  reg        [4:0]    spiMaster_txBitCnt;
  reg        [4:0]    spiMaster_rxBitCnt;
  reg                 spiMaster_mosiReg;
  wire                when_apb3spi_l157;
  wire                when_apb3spi_l167;
  wire                when_apb3spi_l169;
  wire                when_apb3spi_l177;
  wire                when_apb3spi_l179;
  wire                when_apb3spi_l181;
  wire                txEmptyInterrupt;
  wire                rxNotEmptyInterrupt;
  wire                errorInterrupt;
  `ifndef SYNTHESIS
  reg [39:0] spiMaster_state_string;
  `endif


  assign _zz_spiMaster_clockDivider = ({7'd0,1'b1} <<< _zz_spiMaster_clockDivider_1);
  assign _zz_spiMaster_clockDivider_1 = (BR + 3'b001);
  assign _zz_spiMaster_txShiftReg_1 = {1'b0,spiMaster_txShiftReg[7 : 1]};
  assign _zz_spiMaster_txShiftReg = {8'd0, _zz_spiMaster_txShiftReg_1};
  assign _zz_spiMaster_txShiftReg_3 = {spiMaster_txShiftReg[6 : 0],1'b0};
  assign _zz_spiMaster_txShiftReg_2 = {8'd0, _zz_spiMaster_txShiftReg_3};
  assign _zz_spiMaster_rxShiftReg_1 = {io_spi_miso,spiMaster_rxShiftReg[7 : 1]};
  assign _zz_spiMaster_rxShiftReg = {8'd0, _zz_spiMaster_rxShiftReg_1};
  assign _zz_spiMaster_rxShiftReg_3 = {spiMaster_rxShiftReg[6 : 0],io_spi_miso};
  assign _zz_spiMaster_rxShiftReg_2 = {8'd0, _zz_spiMaster_rxShiftReg_3};
  assign _zz_TXCRCR_1 = ({1'd0,TXCRCR} <<< 1'd1);
  assign _zz_TXCRCR = _zz_TXCRCR_1[15:0];
  assign _zz_TXCRCR_2 = io_spi_mosi;
  assign _zz_RXCRCR_1 = ({1'd0,RXCRCR} <<< 1'd1);
  assign _zz_RXCRCR = _zz_RXCRCR_1[15:0];
  assign _zz_RXCRCR_2 = io_spi_miso;
  StreamFifo_4 txFifo (
    .io_push_valid   (txFifo_io_push_valid        ), //i
    .io_push_ready   (txFifo_io_push_ready        ), //o
    .io_push_payload (txFifo_io_push_payload[15:0]), //i
    .io_pop_valid    (txFifo_io_pop_valid         ), //o
    .io_pop_ready    (txFifo_io_pop_ready         ), //i
    .io_pop_payload  (txFifo_io_pop_payload[15:0] ), //o
    .io_flush        (1'b0                        ), //i
    .io_occupancy    (txFifo_io_occupancy[4:0]    ), //o
    .io_availability (txFifo_io_availability[4:0] ), //o
    .clk             (clk                         ), //i
    .reset           (reset                       )  //i
  );
  StreamFifo_4 rxFifo (
    .io_push_valid   (rxFifo_io_push_valid        ), //i
    .io_push_ready   (rxFifo_io_push_ready        ), //o
    .io_push_payload (rxFifo_io_push_payload[15:0]), //i
    .io_pop_valid    (rxFifo_io_pop_valid         ), //o
    .io_pop_ready    (rxFifo_io_pop_ready         ), //i
    .io_pop_payload  (rxFifo_io_pop_payload[15:0] ), //o
    .io_flush        (1'b0                        ), //i
    .io_occupancy    (rxFifo_io_occupancy[4:0]    ), //o
    .io_availability (rxFifo_io_availability[4:0] ), //o
    .clk             (clk                         ), //i
    .reset           (reset                       )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(spiMaster_state)
      SpiState_IDLE : spiMaster_state_string = "IDLE ";
      SpiState_LOAD : spiMaster_state_string = "LOAD ";
      SpiState_SHIFT : spiMaster_state_string = "SHIFT";
      SpiState_DONE : spiMaster_state_string = "DONE ";
      default : spiMaster_state_string = "?????";
    endcase
  end
  `endif

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      6'h0 : begin
        io_apb_PRDATA[15 : 0] = CR1;
      end
      6'h04 : begin
        io_apb_PRDATA[15 : 0] = CR2;
      end
      6'h08 : begin
        io_apb_PRDATA[15 : 0] = SR;
      end
      6'h0c : begin
        if(ctrl_doRead) begin
          if(RXNE) begin
            io_apb_PRDATA = {16'd0, rxFifo_io_pop_payload};
          end
        end
      end
      6'h10 : begin
        io_apb_PRDATA[15 : 0] = CRCPR;
      end
      6'h14 : begin
        io_apb_PRDATA[15 : 0] = RXCRCR;
      end
      6'h18 : begin
        io_apb_PRDATA[15 : 0] = TXCRCR;
      end
      6'h1c : begin
        io_apb_PRDATA[15 : 0] = I2SCFGR;
      end
      6'h20 : begin
        io_apb_PRDATA[15 : 0] = I2SPR;
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
  assign DR = 16'h0;
  assign CPHA = CR1[0];
  assign CPOL = CR1[1];
  assign MSTR = CR1[2];
  assign BR = CR1[5 : 3];
  assign SPE = CR1[6];
  assign LSBFIRST = CR1[7];
  assign SSM = CR1[9];
  assign RXONLY = CR1[10];
  assign DFF = CR1[11];
  assign CRCNEXT = CR1[12];
  assign CRCEN = CR1[13];
  assign BIDIOE = CR1[14];
  assign BIDIMODE = CR1[15];
  assign RXDMAEN = CR2[0];
  assign TXDMAEN = CR2[1];
  assign SSOE = CR2[2];
  assign ERRIE = CR2[5];
  assign RXEIE = CR2[6];
  assign TXEIE = CR2[7];
  assign RXNE = SR[0];
  assign TXE = SR[1];
  assign CHSIDE = SR[2];
  assign UDR = SR[3];
  assign CRCERR = SR[4];
  assign MODF = SR[5];
  assign OVR = SR[6];
  assign BSY = SR[7];
  assign spiMaster_sclkToggle = (spiMaster_clockCounter == 8'h0);
  assign io_spi_sclk = (spiMaster_sclkReg ^ CPOL);
  assign spiMaster_frameLength = (DFF ? 5'h10 : 5'h08);
  always @(*) begin
    SSI = 1'b1;
    case(spiMaster_state)
      SpiState_SHIFT : begin
        SSI = 1'b0;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txFifo_io_pop_ready = 1'b0;
    case(spiMaster_state)
      SpiState_IDLE : begin
        if(when_apb3spi_l157) begin
          txFifo_io_pop_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxFifo_io_push_valid = 1'b0;
    case(spiMaster_state)
      SpiState_DONE : begin
        rxFifo_io_push_valid = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxFifo_io_push_payload = 16'h0;
    case(spiMaster_state)
      SpiState_DONE : begin
        rxFifo_io_push_payload = spiMaster_rxShiftReg;
      end
      default : begin
      end
    endcase
  end

  assign when_apb3spi_l157 = ((txFifo_io_pop_valid && spiMaster_sclkToggle) && (spiMaster_sclkReg == CPOL));
  assign when_apb3spi_l167 = (spiMaster_sclkToggle && (spiMaster_sclkReg != (CPHA ^ CPOL)));
  assign when_apb3spi_l169 = (spiMaster_frameLength == 5'h08);
  assign when_apb3spi_l177 = (spiMaster_txBitCnt == spiMaster_frameLength);
  assign when_apb3spi_l179 = (spiMaster_sclkToggle && (spiMaster_sclkReg == (CPHA ^ CPOL)));
  assign when_apb3spi_l181 = (spiMaster_frameLength == 5'h08);
  assign txEmptyInterrupt = (TXEIE && TXE);
  assign rxNotEmptyInterrupt = (RXEIE && RXNE);
  assign errorInterrupt = (ERRIE && (((OVR || MODF) || CRCERR) || UDR));
  assign io_interrupt = ((txEmptyInterrupt || rxNotEmptyInterrupt) || errorInterrupt);
  always @(*) begin
    txFifo_io_push_valid = 1'b0;
    case(io_apb_PADDR)
      6'h0c : begin
        if(ctrl_doWrite) begin
          if(TXE) begin
            txFifo_io_push_valid = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txFifo_io_push_payload = 16'h0;
    case(io_apb_PADDR)
      6'h0c : begin
        if(ctrl_doWrite) begin
          if(TXE) begin
            txFifo_io_push_payload = io_apb_PWDATA[15 : 0];
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxFifo_io_pop_ready = 1'b0;
    case(io_apb_PADDR)
      6'h0c : begin
        if(ctrl_doRead) begin
          if(RXNE) begin
            rxFifo_io_pop_ready = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign io_spi_ss = (((! SSM) && SSOE) ? SSI : 1'b1);
  assign io_spi_mosi = spiMaster_mosiReg;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      CR1 <= 16'h0;
      CR2 <= 16'h0;
      SR <= 16'h0;
      CRCPR <= 16'h0;
      RXCRCR <= 16'h0;
      TXCRCR <= 16'h0;
      I2SCFGR <= 16'h0;
      I2SPR <= 16'h0;
      spiMaster_clockDivider <= 8'h0;
      spiMaster_clockCounter <= 8'h0;
      spiMaster_sclkReg <= 1'b0;
      spiMaster_state <= SpiState_IDLE;
      spiMaster_rxShiftReg <= 16'h0;
      spiMaster_txShiftReg <= 16'h0;
      spiMaster_txBitCnt <= 5'h0;
      spiMaster_rxBitCnt <= 5'h0;
      spiMaster_mosiReg <= 1'b0;
    end else begin
      spiMaster_clockDivider <= (_zz_spiMaster_clockDivider - 8'h01);
      if(SPE) begin
        spiMaster_clockCounter <= (spiMaster_clockCounter - 8'h01);
        if(spiMaster_sclkToggle) begin
          spiMaster_clockCounter <= spiMaster_clockDivider;
          spiMaster_sclkReg <= (! spiMaster_sclkReg);
        end
      end
      case(spiMaster_state)
        SpiState_IDLE : begin
          spiMaster_mosiReg <= 1'b1;
          if(when_apb3spi_l157) begin
            spiMaster_txShiftReg <= txFifo_io_pop_payload;
            spiMaster_txBitCnt <= 5'h0;
            spiMaster_rxBitCnt <= 5'h0;
            spiMaster_state <= SpiState_SHIFT;
          end
        end
        SpiState_SHIFT : begin
          if(when_apb3spi_l167) begin
            if(when_apb3spi_l169) begin
              spiMaster_mosiReg <= (LSBFIRST ? spiMaster_txShiftReg[0] : spiMaster_txShiftReg[7]);
              spiMaster_txShiftReg <= (LSBFIRST ? _zz_spiMaster_txShiftReg : _zz_spiMaster_txShiftReg_2);
            end else begin
              spiMaster_mosiReg <= (LSBFIRST ? spiMaster_txShiftReg[0] : spiMaster_txShiftReg[15]);
              spiMaster_txShiftReg <= (LSBFIRST ? {1'b0,spiMaster_txShiftReg[15 : 1]} : {spiMaster_txShiftReg[14 : 0],1'b0});
            end
            spiMaster_txBitCnt <= (spiMaster_txBitCnt + 5'h01);
            if(when_apb3spi_l177) begin
              spiMaster_state <= SpiState_DONE;
            end
          end
          if(when_apb3spi_l179) begin
            if(when_apb3spi_l181) begin
              spiMaster_rxShiftReg <= (LSBFIRST ? _zz_spiMaster_rxShiftReg : _zz_spiMaster_rxShiftReg_2);
            end else begin
              spiMaster_rxShiftReg <= (LSBFIRST ? {io_spi_miso,spiMaster_rxShiftReg[15 : 1]} : {spiMaster_rxShiftReg[14 : 0],io_spi_miso});
            end
            spiMaster_rxBitCnt <= (spiMaster_rxBitCnt + 5'h01);
          end
        end
        SpiState_DONE : begin
          spiMaster_state <= SpiState_IDLE;
        end
        default : begin
        end
      endcase
      if(spiMaster_sclkToggle) begin
        if(CRCEN) begin
          TXCRCR <= (_zz_TXCRCR ^ (CRCPR & ((TXCRCR[15] ^ _zz_TXCRCR_2[0]) ? 16'hffff : 16'h0)));
          RXCRCR <= (_zz_RXCRCR ^ (CRCPR & ((RXCRCR[15] ^ _zz_RXCRCR_2[0]) ? 16'hffff : 16'h0)));
        end
      end
      SR[0] <= (rxFifo_io_occupancy != 5'h0);
      SR[1] <= txFifo_io_push_ready;
      SR[2] <= 1'b0;
      SR[3] <= 1'b0;
      SR[4] <= (CRCEN ? (RXCRCR != TXCRCR) : 1'b0);
      SR[5] <= 1'b0;
      SR[6] <= 1'b0;
      SR[7] <= (spiMaster_state != SpiState_IDLE);
      case(io_apb_PADDR)
        6'h0 : begin
          if(ctrl_doWrite) begin
            CR1 <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h04 : begin
          if(ctrl_doWrite) begin
            CR2 <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h10 : begin
          if(ctrl_doWrite) begin
            CRCPR <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h1c : begin
          if(ctrl_doWrite) begin
            I2SCFGR <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h20 : begin
          if(ctrl_doWrite) begin
            I2SPR <= io_apb_PWDATA[15 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

//Apb3Router_4 replaced by Apb3Router

//Apb3Decoder_4 replaced by Apb3Decoder

//Apb3I2c_1 replaced by Apb3I2c

module Apb3I2c (
  input  wire [5:0]    io_apb_PADDR,
  input  wire [0:0]    io_apb_PSEL,
  input  wire          io_apb_PENABLE,
  output wire          io_apb_PREADY,
  input  wire          io_apb_PWRITE,
  input  wire [31:0]   io_apb_PWDATA,
  output reg  [31:0]   io_apb_PRDATA,
  output wire          io_apb_PSLVERROR,
  output wire          io_i2c_scl,
  input  wire [0:0]    io_i2c_sda_read,
  output reg  [0:0]    io_i2c_sda_write,
  output reg  [0:0]    io_i2c_sda_writeEnable,
  output wire          io_interrupt,
  input  wire          clk,
  input  wire          reset
);

  reg                 txFifo_io_push_valid;
  reg        [15:0]   txFifo_io_push_payload;
  reg                 txFifo_io_pop_ready;
  reg                 rxFifo_io_push_valid;
  reg        [15:0]   rxFifo_io_push_payload;
  reg                 rxFifo_io_pop_ready;
  wire                txFifo_io_push_ready;
  wire                txFifo_io_pop_valid;
  wire       [15:0]   txFifo_io_pop_payload;
  wire       [4:0]    txFifo_io_occupancy;
  wire       [4:0]    txFifo_io_availability;
  wire                rxFifo_io_push_ready;
  wire                rxFifo_io_pop_valid;
  wire       [15:0]   rxFifo_io_pop_payload;
  wire       [4:0]    rxFifo_io_occupancy;
  wire       [4:0]    rxFifo_io_availability;
  wire       [3:0]    _zz_io_i2c_sda_write;
  wire       [3:0]    _zz_io_i2c_sda_write_1;
  wire       [3:0]    _zz_io_i2c_sda_write_2;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg        [15:0]   CR1;
  reg        [15:0]   CR2;
  reg        [15:0]   OAR1;
  reg        [15:0]   OAR2;
  wire       [15:0]   DR;
  reg        [15:0]   SR1;
  reg        [15:0]   SR2;
  reg        [15:0]   CCR;
  reg        [15:0]   TRISE;
  wire                PE;
  wire                SMBUS;
  wire                SMBTYPE;
  wire                ENARP;
  wire                ENPEC;
  wire                ENGC;
  wire                NOSTRETCH;
  wire                START;
  wire                STOP;
  wire                ACK;
  wire                POS;
  wire                CR1PEC;
  wire                ALERT;
  wire                SWRST;
  wire       [5:0]    FREQ;
  wire                ITERREN;
  wire                ITEVTEN;
  wire                ITBUFEN;
  wire                DMAEN;
  wire                LAST;
  wire                ADDMODE;
  wire       [9:0]    ADD;
  wire       [6:0]    ADD2;
  wire                ENDUAL;
  wire                SB;
  wire                ADDR;
  wire                BTF;
  wire                ADD10;
  wire                STOPF;
  wire                RXNE;
  wire                TXE;
  wire                BERR;
  wire                ARLO;
  wire                AF;
  wire                OVR;
  wire                PECERR;
  wire                TIMEOUT;
  wire                SMBALERT;
  wire                MSL;
  wire                BUSY;
  wire                TRA;
  wire                GENCALL;
  wire                SMBDEFAULT;
  wire                SMBHOST;
  wire                DUALF;
  wire       [7:0]    SR2PEC;
  wire                CCR_FS;
  wire                CCR_DUTY;
  wire       [11:0]   CCR_CCR;
  reg        [3:0]    i2cState;
  reg        [3:0]    bitCounter;
  reg        [15:0]   txShiftReg;
  reg        [15:0]   rxShiftReg;
  reg                 isRead;
  reg        [11:0]   clockCounter;
  wire                clockTick;
  wire                when_apb3i2c_l149;
  wire                when_apb3i2c_l158;
  wire                when_apb3i2c_l162;
  wire                when_apb3i2c_l171;
  wire                when_apb3i2c_l175;
  wire                when_apb3i2c_l189;
  wire                when_apb3i2c_l202;
  wire                when_apb3i2c_l212;
  wire                when_apb3i2c_l236;
  wire                errorInterrupt;
  wire                eventInterrupt;
  wire                bufferInterrupt;

  assign _zz_io_i2c_sda_write = (4'b1001 - bitCounter);
  assign _zz_io_i2c_sda_write_1 = (4'b0111 - bitCounter);
  assign _zz_io_i2c_sda_write_2 = (4'b0111 - bitCounter);
  StreamFifo_4 txFifo (
    .io_push_valid   (txFifo_io_push_valid        ), //i
    .io_push_ready   (txFifo_io_push_ready        ), //o
    .io_push_payload (txFifo_io_push_payload[15:0]), //i
    .io_pop_valid    (txFifo_io_pop_valid         ), //o
    .io_pop_ready    (txFifo_io_pop_ready         ), //i
    .io_pop_payload  (txFifo_io_pop_payload[15:0] ), //o
    .io_flush        (1'b0                        ), //i
    .io_occupancy    (txFifo_io_occupancy[4:0]    ), //o
    .io_availability (txFifo_io_availability[4:0] ), //o
    .clk             (clk                         ), //i
    .reset           (reset                       )  //i
  );
  StreamFifo_4 rxFifo (
    .io_push_valid   (rxFifo_io_push_valid        ), //i
    .io_push_ready   (rxFifo_io_push_ready        ), //o
    .io_push_payload (rxFifo_io_push_payload[15:0]), //i
    .io_pop_valid    (rxFifo_io_pop_valid         ), //o
    .io_pop_ready    (rxFifo_io_pop_ready         ), //i
    .io_pop_payload  (rxFifo_io_pop_payload[15:0] ), //o
    .io_flush        (1'b0                        ), //i
    .io_occupancy    (rxFifo_io_occupancy[4:0]    ), //o
    .io_availability (rxFifo_io_availability[4:0] ), //o
    .clk             (clk                         ), //i
    .reset           (reset                       )  //i
  );
  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign io_apb_PREADY = 1'b1;
  always @(*) begin
    io_apb_PRDATA = 32'h0;
    case(io_apb_PADDR)
      6'h0 : begin
        io_apb_PRDATA[15 : 0] = CR1;
      end
      6'h04 : begin
        io_apb_PRDATA[15 : 0] = CR2;
      end
      6'h08 : begin
        io_apb_PRDATA[15 : 0] = OAR1;
      end
      6'h0c : begin
        io_apb_PRDATA[15 : 0] = OAR2;
      end
      6'h10 : begin
        if(ctrl_doRead) begin
          if(RXNE) begin
            io_apb_PRDATA = {16'd0, rxFifo_io_pop_payload};
          end
        end
      end
      6'h14 : begin
        io_apb_PRDATA[15 : 0] = SR1;
      end
      6'h18 : begin
        io_apb_PRDATA[15 : 0] = SR2;
      end
      6'h1c : begin
        io_apb_PRDATA[15 : 0] = CCR;
      end
      6'h20 : begin
        io_apb_PRDATA[15 : 0] = TRISE;
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
  assign DR = 16'h0;
  assign PE = CR1[0];
  assign SMBUS = CR1[1];
  assign SMBTYPE = CR1[3];
  assign ENARP = CR1[4];
  assign ENPEC = CR1[5];
  assign ENGC = CR1[6];
  assign NOSTRETCH = CR1[7];
  assign START = CR1[8];
  assign STOP = CR1[9];
  assign ACK = CR1[10];
  assign POS = CR1[11];
  assign CR1PEC = CR1[12];
  assign ALERT = CR1[13];
  assign SWRST = CR1[15];
  assign FREQ = CR2[5 : 0];
  assign ITERREN = CR2[8];
  assign ITEVTEN = CR2[9];
  assign ITBUFEN = CR2[10];
  assign DMAEN = CR2[11];
  assign LAST = CR2[12];
  assign ADDMODE = OAR1[15];
  assign ADD = OAR1[9 : 0];
  assign ADD2 = OAR2[7 : 1];
  assign ENDUAL = OAR2[0];
  assign SB = SR1[0];
  assign ADDR = SR1[1];
  assign BTF = SR1[2];
  assign ADD10 = SR1[3];
  assign STOPF = SR1[4];
  assign RXNE = SR1[6];
  assign TXE = SR1[7];
  assign BERR = SR1[8];
  assign ARLO = SR1[9];
  assign AF = SR1[10];
  assign OVR = SR1[11];
  assign PECERR = SR1[12];
  assign TIMEOUT = SR1[14];
  assign SMBALERT = SR1[15];
  assign MSL = SR2[0];
  assign BUSY = SR2[1];
  assign TRA = SR2[2];
  assign GENCALL = SR2[4];
  assign SMBDEFAULT = SR2[5];
  assign SMBHOST = SR2[6];
  assign DUALF = SR2[7];
  assign SR2PEC = SR2[15 : 8];
  assign CCR_FS = CCR[15];
  assign CCR_DUTY = CCR[14];
  assign CCR_CCR = CCR[11 : 0];
  assign clockTick = (clockCounter == 12'h0);
  always @(*) begin
    txFifo_io_pop_ready = 1'b0;
    case(i2cState)
      4'b0100 : begin
        if(when_apb3i2c_l212) begin
          txFifo_io_pop_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxFifo_io_push_valid = 1'b0;
    case(i2cState)
      4'b0011 : begin
        if(clockTick) begin
          if(when_apb3i2c_l202) begin
            rxFifo_io_push_valid = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxFifo_io_push_payload = 16'h0;
    case(i2cState)
      4'b0011 : begin
        if(clockTick) begin
          if(when_apb3i2c_l202) begin
            rxFifo_io_push_payload = rxShiftReg;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_i2c_sda_write = 1'b1;
    case(i2cState)
      4'b0001 : begin
        if(clockTick) begin
          if(ADDMODE) begin
            if(when_apb3i2c_l158) begin
              io_i2c_sda_write = ADD[_zz_io_i2c_sda_write];
            end else begin
              if(when_apb3i2c_l162) begin
                io_i2c_sda_write = isRead;
              end
            end
          end else begin
            if(when_apb3i2c_l171) begin
              io_i2c_sda_write = ADD[_zz_io_i2c_sda_write_1];
            end else begin
              if(when_apb3i2c_l175) begin
                io_i2c_sda_write = isRead;
              end
            end
          end
        end
      end
      4'b0100 : begin
        if(when_apb3i2c_l212) begin
          io_i2c_sda_write = txShiftReg[7];
        end
      end
      4'b0110 : begin
        if(clockTick) begin
          io_i2c_sda_write = txShiftReg[_zz_io_i2c_sda_write_2];
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_i2c_sda_writeEnable = 1'b0;
    case(i2cState)
      4'b0001 : begin
        if(clockTick) begin
          if(ADDMODE) begin
            if(when_apb3i2c_l158) begin
              io_i2c_sda_writeEnable = 1'b1;
            end
          end else begin
            if(when_apb3i2c_l171) begin
              io_i2c_sda_writeEnable = 1'b1;
            end else begin
              if(when_apb3i2c_l175) begin
                io_i2c_sda_writeEnable = 1'b1;
              end
            end
          end
        end
      end
      4'b0100 : begin
        if(when_apb3i2c_l212) begin
          io_i2c_sda_writeEnable = 1'b1;
        end
      end
      4'b0110 : begin
        if(clockTick) begin
          io_i2c_sda_writeEnable = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_apb3i2c_l149 = (START && PE);
  assign when_apb3i2c_l158 = (bitCounter < 4'b1010);
  assign when_apb3i2c_l162 = (bitCounter == 4'b1010);
  assign when_apb3i2c_l171 = (bitCounter < 4'b0111);
  assign when_apb3i2c_l175 = (bitCounter == 4'b0111);
  assign when_apb3i2c_l189 = (io_i2c_sda_read == 1'b0);
  assign when_apb3i2c_l202 = (bitCounter == 4'b0111);
  assign when_apb3i2c_l212 = (txFifo_io_pop_valid && clockTick);
  assign when_apb3i2c_l236 = (bitCounter == 4'b0111);
  assign errorInterrupt = (ITERREN && (((((BERR || ARLO) || AF) || OVR) || PECERR) || TIMEOUT));
  assign eventInterrupt = (ITEVTEN && (((SB || ADDR) || BTF) || STOPF));
  assign bufferInterrupt = (ITBUFEN && (TXE || RXNE));
  assign io_interrupt = ((errorInterrupt || eventInterrupt) || bufferInterrupt);
  always @(*) begin
    txFifo_io_push_valid = 1'b0;
    case(io_apb_PADDR)
      6'h10 : begin
        if(ctrl_doWrite) begin
          if(TXE) begin
            txFifo_io_push_valid = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txFifo_io_push_payload = 16'h0;
    case(io_apb_PADDR)
      6'h10 : begin
        if(ctrl_doWrite) begin
          if(TXE) begin
            txFifo_io_push_payload = io_apb_PWDATA[15 : 0];
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxFifo_io_pop_ready = 1'b0;
    case(io_apb_PADDR)
      6'h10 : begin
        if(ctrl_doRead) begin
          if(RXNE) begin
            rxFifo_io_pop_ready = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign io_i2c_scl = clockTick;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      CR1 <= 16'h0;
      CR2 <= 16'h0;
      OAR1 <= 16'h0;
      OAR2 <= 16'h0;
      SR1 <= 16'h0;
      SR2 <= 16'h0;
      CCR <= 16'h0;
      TRISE <= 16'h0;
      i2cState <= 4'b0000;
      bitCounter <= 4'b0000;
      txShiftReg <= 16'h0;
      rxShiftReg <= 16'h0;
      isRead <= 1'b0;
      clockCounter <= 12'h0;
    end else begin
      isRead <= 1'b0;
      if(PE) begin
        clockCounter <= (clockCounter - 12'h001);
        if(clockTick) begin
          clockCounter <= CCR_CCR;
        end
      end
      case(i2cState)
        4'b0000 : begin
          if(when_apb3i2c_l149) begin
            i2cState <= 4'b0001;
            SR1[0] <= 1'b1;
            bitCounter <= 4'b0000;
          end
        end
        4'b0001 : begin
          if(clockTick) begin
            if(ADDMODE) begin
              if(when_apb3i2c_l158) begin
                bitCounter <= (bitCounter + 4'b0001);
              end else begin
                if(when_apb3i2c_l162) begin
                  bitCounter <= (bitCounter + 4'b0001);
                  SR1[1] <= 1'b1;
                end else begin
                  i2cState <= 4'b0010;
                  SR1[1] <= 1'b0;
                end
              end
            end else begin
              if(when_apb3i2c_l171) begin
                bitCounter <= (bitCounter + 4'b0001);
              end else begin
                if(when_apb3i2c_l175) begin
                  bitCounter <= (bitCounter + 4'b0001);
                  SR1[1] <= 1'b1;
                end else begin
                  i2cState <= 4'b0010;
                  SR1[1] <= 1'b0;
                end
              end
            end
          end
        end
        4'b0010 : begin
          if(clockTick) begin
            if(when_apb3i2c_l189) begin
              if(isRead) begin
                i2cState <= 4'b0011;
              end else begin
                i2cState <= 4'b0100;
              end
            end else begin
              SR1[10] <= 1'b1;
              i2cState <= 4'b0000;
            end
          end
        end
        4'b0011 : begin
          if(clockTick) begin
            rxShiftReg <= {rxShiftReg[14 : 0],io_i2c_sda_read};
            bitCounter <= (bitCounter + 4'b0001);
            if(when_apb3i2c_l202) begin
              SR1[6] <= 1'b1;
              i2cState <= 4'b0101;
            end
          end
        end
        4'b0100 : begin
          if(when_apb3i2c_l212) begin
            txShiftReg <= txFifo_io_pop_payload;
            bitCounter <= 4'b0001;
            i2cState <= 4'b0110;
          end
        end
        4'b0101 : begin
          if(clockTick) begin
            if(STOP) begin
              i2cState <= 4'b0000;
              SR1[4] <= 1'b1;
            end else begin
              i2cState <= 4'b0011;
            end
          end
        end
        4'b0110 : begin
          if(clockTick) begin
            bitCounter <= (bitCounter + 4'b0001);
            if(when_apb3i2c_l236) begin
              SR1[2] <= 1'b1;
              i2cState <= 4'b0111;
            end
          end
        end
        4'b0111 : begin
          if(clockTick) begin
            if(STOP) begin
              i2cState <= 4'b0000;
              SR1[4] <= 1'b1;
            end else begin
              i2cState <= 4'b0100;
            end
          end
        end
        default : begin
        end
      endcase
      SR1[7] <= txFifo_io_pop_ready;
      SR1[6] <= rxFifo_io_pop_valid;
      SR2[1] <= (i2cState != 4'b0000);
      SR2[2] <= isRead;
      case(io_apb_PADDR)
        6'h0 : begin
          if(ctrl_doWrite) begin
            CR1 <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h04 : begin
          if(ctrl_doWrite) begin
            CR2 <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h08 : begin
          if(ctrl_doWrite) begin
            OAR1 <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h0c : begin
          if(ctrl_doWrite) begin
            OAR2 <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h1c : begin
          if(ctrl_doWrite) begin
            CCR <= io_apb_PWDATA[15 : 0];
          end
        end
        6'h20 : begin
          if(ctrl_doWrite) begin
            TRISE <= io_apb_PWDATA[15 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

//Apb3Router_3 replaced by Apb3Router

//Apb3Decoder_3 replaced by Apb3Decoder

//Apb3Uart_1 replaced by Apb3Uart

module Apb3Uart (
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
  input  wire          clk,
  input  wire          reset
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
  wire                feInterrupt;
  wire                rxneInterrupt;
  wire                tcInterrupt;
  wire                txeInterrupt;
  wire                peInterrupt;
  `ifndef SYNTHESIS
  reg [23:0] frame_stop_string;
  reg [31:0] frame_parity_string;
  reg [31:0] _zz_frame_parity_string;
  reg [31:0] _zz_frame_parity_1_string;
  reg [23:0] _zz_frame_stop_string;
  reg [23:0] _zz_frame_stop_1_string;
  `endif


  assign _zz_clockDivider_counter = BRR[15 : 4];
  uartCtrlTx tx (
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
    .clk                       (clk                       ), //i
    .reset                     (reset                     )  //i
  );
  uartCtrlRx rx (
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
    .clk                       (clk                    ), //i
    .reset                     (reset                  )  //i
  );
  StreamFifo txFifo (
    .io_push_valid   (txFifo_io_push_valid       ), //i
    .io_push_ready   (txFifo_io_push_ready       ), //o
    .io_push_payload (txFifo_io_push_payload[8:0]), //i
    .io_pop_valid    (txFifo_io_pop_valid        ), //o
    .io_pop_ready    (tx_io_write_ready          ), //i
    .io_pop_payload  (txFifo_io_pop_payload[8:0] ), //o
    .io_flush        (1'b0                       ), //i
    .io_occupancy    (txFifo_io_occupancy[4:0]   ), //o
    .io_availability (txFifo_io_availability[4:0]), //o
    .clk             (clk                        ), //i
    .reset           (reset                      )  //i
  );
  StreamFifo rxFifo (
    .io_push_valid   (rx_io_read_valid           ), //i
    .io_push_ready   (rxFifo_io_push_ready       ), //o
    .io_push_payload (rx_io_read_payload[8:0]    ), //i
    .io_pop_valid    (rxFifo_io_pop_valid        ), //o
    .io_pop_ready    (rxFifo_io_pop_ready        ), //i
    .io_pop_payload  (rxFifo_io_pop_payload[8:0] ), //o
    .io_flush        (1'b0                       ), //i
    .io_occupancy    (rxFifo_io_occupancy[4:0]   ), //o
    .io_availability (rxFifo_io_availability[4:0]), //o
    .clk             (clk                        ), //i
    .reset           (reset                      )  //i
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
          io_apb_PRDATA = 32'h0;
          if(rxFifo_io_pop_valid) begin
            io_apb_PRDATA[8 : 0] = rxFifo_io_pop_payload;
          end
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
  assign feInterrupt = (CR1[4] && SR[3]);
  assign rxneInterrupt = (CR1[5] && SR[5]);
  assign tcInterrupt = (CR1[6] && SR[6]);
  assign txeInterrupt = (CR1[7] && SR[7]);
  assign peInterrupt = (CR1[8] && SR[1]);
  assign io_interrupt = ((((rxneInterrupt || txeInterrupt) || tcInterrupt) || peInterrupt) || feInterrupt);
  always @(*) begin
    txFifo_io_push_valid = 1'b0;
    case(io_apb_PADDR)
      5'h04 : begin
        if(ctrl_doWrite) begin
          if(txFifo_io_push_ready) begin
            txFifo_io_push_valid = 1'b1;
          end
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
          if(rxFifo_io_pop_valid) begin
            rxFifo_io_pop_ready = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
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

//Apb3Router_2 replaced by Apb3Router

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
  input  wire          clk,
  input  wire          reset
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
  input  wire          clk,
  input  wire          reset
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
  output reg  [3:0]    io_ch,
  output wire          io_interrupt,
  input  wire          clk,
  input  wire          reset
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
  reg                 _zz_io_ch;
  reg                 _zz_io_ch_1;
  reg                 _zz_io_ch_2;
  reg                 _zz_io_ch_3;

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
    io_ch[0] = _zz_io_ch;
    io_ch[1] = _zz_io_ch_1;
    io_ch[2] = _zz_io_ch_2;
    io_ch[3] = _zz_io_ch_3;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
      _zz_io_ch <= 1'b0;
      _zz_io_ch_1 <= 1'b0;
      _zz_io_ch_2 <= 1'b0;
      _zz_io_ch_3 <= 1'b0;
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
      _zz_io_ch <= ((CNT < CCR_0) && CCER[0]);
      _zz_io_ch_1 <= ((CNT < CCR_1) && CCER[1]);
      _zz_io_ch_2 <= ((CNT < CCR_2) && CCER[2]);
      _zz_io_ch_3 <= ((CNT < CCR_3) && CCER[3]);
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
  input  wire          clk,
  input  wire          reset
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
  always @(posedge clk) begin
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
  input  wire          clk,
  input  wire          reset
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
  wire                _zz_when_apb3gpio_l83;
  wire                when_apb3gpio_l83;
  wire                when_apb3gpio_l85;
  wire                when_apb3gpio_l87;

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
  (* keep_hierarchy = "TRUE" *) BufferCC io_gpio_read_buffercc (
    .io_dataIn  (io_gpio_read[15:0]                    ), //i
    .io_dataOut (io_gpio_read_buffercc_io_dataOut[15:0]), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
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
  assign _zz_when_apb3gpio_l83 = io_apb_PWDATA[16];
  assign when_apb3gpio_l83 = (_zz_when_apb3gpio_l83 && (! LCKK));
  assign when_apb3gpio_l85 = ((! _zz_when_apb3gpio_l83) && (! LCKK));
  assign when_apb3gpio_l87 = (_zz_when_apb3gpio_l83 && (! LCKK));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
            if(when_apb3gpio_l83) begin
              LCKK <= 1'b0;
            end else begin
              if(when_apb3gpio_l85) begin
                LCKK <= 1'b0;
              end else begin
                if(when_apb3gpio_l87) begin
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

module PulseCCByToggle (
  input  wire          io_pulseIn,
  output wire          io_pulseOut,
  input  wire          dvt_clk,
  input  wire          dvt_reset,
  input  wire          clk
);

  wire                dvt_reset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  wire                inArea_target_buffercc_io_dataOut;
  (* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg                 inArea_target;
  wire                dvt_reset_asyncAssertSyncDeassert;
  wire                dvt_reset_synchronized;
  wire                outArea_target;
  reg                 outArea_target_regNext;

  (* keep_hierarchy = "TRUE" *) BufferCC_8 dvt_reset_asyncAssertSyncDeassert_buffercc (
    .io_dataIn  (dvt_reset_asyncAssertSyncDeassert                    ), //i
    .io_dataOut (dvt_reset_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .clk        (clk                                                  ), //i
    .dvt_reset  (dvt_reset                                            )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_9 inArea_target_buffercc (
    .io_dataIn              (inArea_target                    ), //i
    .io_dataOut             (inArea_target_buffercc_io_dataOut), //o
    .clk                    (clk                              ), //i
    .dvt_reset_synchronized (dvt_reset_synchronized           )  //i
  );
  assign dvt_reset_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign dvt_reset_synchronized = dvt_reset_asyncAssertSyncDeassert_buffercc_io_dataOut;
  assign outArea_target = inArea_target_buffercc_io_dataOut;
  assign io_pulseOut = (outArea_target ^ outArea_target_regNext);
  always @(posedge dvt_clk or posedge dvt_reset) begin
    if(dvt_reset) begin
      inArea_target <= 1'b0;
    end else begin
      if(io_pulseIn) begin
        inArea_target <= (! inArea_target);
      end
    end
  end

  always @(posedge clk or posedge dvt_reset_synchronized) begin
    if(dvt_reset_synchronized) begin
      outArea_target_regNext <= 1'b0;
    end else begin
      outArea_target_regNext <= outArea_target;
    end
  end


endmodule

//BufferCC_29 replaced by BufferCC_26

//BufferCC_28 replaced by BufferCC_26

//BufferCC_27 replaced by BufferCC_26

module BufferCC_26 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

//BufferCC_25 replaced by BufferCC

//BufferCC_24 replaced by BufferCC

//BufferCC_23 replaced by BufferCC_10

//BufferCC_22 replaced by BufferCC_10

//BufferCC_21 replaced by BufferCC_13

//BufferCC_20 replaced by BufferCC_13

//BufferCC_19 replaced by BufferCC_13

//BufferCC_18 replaced by BufferCC_13

//BufferCC_17 replaced by BufferCC_10

//BufferCC_16 replaced by BufferCC_13

//BufferCC_15 replaced by BufferCC_13

//BufferCC_14 replaced by BufferCC_13

module BufferCC_13 (
  input  wire [11:0]   io_dataIn,
  output wire [11:0]   io_dataOut,
  input  wire          dvt_clk,
  input  wire          dvt_reset
);

  (* async_reg = "true" *) reg        [11:0]   buffers_0;
  (* async_reg = "true" *) reg        [11:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge dvt_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

//BufferCC_12 replaced by BufferCC_10

//BufferCC_11 replaced by BufferCC_10

module BufferCC_10 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          dvt_clk,
  input  wire          dvt_reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge dvt_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module DVTimingDyn (
  input  wire          io_en,
  input  wire [11:0]   io_cfg_hsync,
  input  wire [11:0]   io_cfg_hback,
  input  wire [11:0]   io_cfg_hdisp,
  input  wire [11:0]   io_cfg_htotal,
  input  wire [11:0]   io_cfg_vsync,
  input  wire [11:0]   io_cfg_vback,
  input  wire [11:0]   io_cfg_vdisp,
  input  wire [11:0]   io_cfg_vtotal,
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
  input  wire          dvt_clk,
  input  wire          dvt_reset
);

  wire                dvtArea_en;
  reg        [11:0]   dvtArea_hCnt;
  reg        [11:0]   dvtArea_vCnt;
  wire                when_Apb3Dvtc_l133;
  wire                when_Apb3Dvtc_l135;

  assign dvtArea_en = (io_hen && io_ven);
  assign io_hen = ((io_cfg_hback <= dvtArea_hCnt) && (dvtArea_hCnt < io_cfg_hdisp));
  assign io_ven = ((io_cfg_vback <= dvtArea_vCnt) && (dvtArea_vCnt < io_cfg_vdisp));
  assign when_Apb3Dvtc_l133 = (dvtArea_hCnt == io_cfg_htotal);
  assign when_Apb3Dvtc_l135 = (dvtArea_vCnt == io_cfg_vtotal);
  assign io_dvti_data = io_pixel_payload;
  assign io_dvti_vs = (((dvtArea_vCnt <= io_cfg_vsync) ^ io_cfg_vspol) && io_en);
  assign io_dvti_hs = (((dvtArea_hCnt <= io_cfg_hsync) ^ io_cfg_hspol) && io_en);
  assign io_dvti_de = ((dvtArea_en ^ io_cfg_depol) && io_en);
  assign io_pos_x = {4'd0, dvtArea_hCnt};
  assign io_pos_y = {4'd0, dvtArea_vCnt};
  assign io_pixel_ready = (dvtArea_en || (! io_en));
  always @(posedge dvt_clk or posedge dvt_reset) begin
    if(dvt_reset) begin
      dvtArea_hCnt <= 12'h0;
      dvtArea_vCnt <= 12'h0;
    end else begin
      if(io_en) begin
        if(when_Apb3Dvtc_l133) begin
          dvtArea_hCnt <= 12'h0;
          if(when_Apb3Dvtc_l135) begin
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
  input  wire [16:0]   io_size,
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
  input  wire          clk,
  input  wire          reset,
  input  wire          dvt_clk,
  input  wire          dvt_reset
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
  reg        [16:0]   memCmdCounter;
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

  assign _zz_io_mem_cmd_payload = {10'd0, memCmdCounter};
  assign _zz_rspArea_frameClockArea_popBeatCounter_valueNext_1 = rspArea_frameClockArea_popBeatCounter_willIncrement;
  assign _zz_rspArea_frameClockArea_popBeatCounter_valueNext = {2'd0, _zz_rspArea_frameClockArea_popBeatCounter_valueNext_1};
  StreamFifoCC rspArea_fifo (
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
    .clk                      (clk                                       ), //i
    .reset                    (reset                                     ), //i
    .dvt_clk                  (dvt_clk                                   )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_7 rspArea_frameClockArea_popCmdGray_buffercc (
    .io_dataIn  (rspArea_frameClockArea_popCmdGray[6:0]                    ), //i
    .io_dataOut (rspArea_frameClockArea_popCmdGray_buffercc_io_dataOut[6:0]), //o
    .clk        (clk                                                       ), //i
    .reset      (reset                                                     )  //i
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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

  always @(posedge clk) begin
    if(when_VideoDma_l94) begin
      if(io_start) begin
        memCmdCounter <= 17'h0;
      end
    end
    if(io_mem_cmd_fire) begin
      memCmdCounter <= (memCmdCounter + 17'h00001);
    end
  end

  always @(posedge dvt_clk or posedge dvt_reset) begin
    if(dvt_reset) begin
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

//StreamFifo_11 replaced by StreamFifo_4

//StreamFifo_10 replaced by StreamFifo_4

//StreamFifo_9 replaced by StreamFifo_4

//StreamFifo_8 replaced by StreamFifo_4

//StreamFifo_7 replaced by StreamFifo_4

//StreamFifo_6 replaced by StreamFifo_4

//StreamFifo_5 replaced by StreamFifo_4

module StreamFifo_4 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [15:0]   io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [15:0]   io_pop_payload,
  input  wire          io_flush,
  output wire [4:0]    io_occupancy,
  output wire [4:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [15:0]   logic_ram_spinal_port1;
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
  wire       [15:0]   logic_push_onRam_write_payload_data;
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
  wire       [15:0]   logic_pop_sync_readPort_rsp;
  wire                logic_pop_addressGen_toFlowFire_valid;
  wire       [3:0]    logic_pop_addressGen_toFlowFire_payload;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [15:0]   logic_pop_sync_readArbitation_translated_payload;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [4:0]    logic_pop_sync_popReg;
  reg [15:0] logic_ram [0:15];

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
    end
  end

  always @(posedge clk) begin
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

//StreamFifo_3 replaced by StreamFifo

//StreamFifo_2 replaced by StreamFifo

//uartCtrlRx_1 replaced by uartCtrlRx

//uartCtrlTx_1 replaced by uartCtrlTx

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
  input  wire          clk,
  input  wire          reset
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

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
    end
  end

  always @(posedge clk) begin
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module uartCtrlRx (
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
  input  wire          clk,
  input  wire          reset
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
  wire       [3:0]    _zz_when_uartCtrlRx_l152;
  wire       [0:0]    _zz_when_uartCtrlRx_l152_1;
  reg                 _zz_io_rts;
  wire                sampler_synchroniser;
  wire                sampler_samples_0;
  reg                 sampler_samples_1;
  reg                 sampler_samples_2;
  reg                 sampler_value;
  reg                 sampler_tick;
  reg        [2:0]    bitTimer_counter;
  reg                 bitTimer_tick;
  wire                when_uartCtrlRx_l50;
  reg        [3:0]    bitCounter_value;
  reg        [6:0]    break_counter;
  wire                break_valid;
  wire                when_uartCtrlRx_l82;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg        [8:0]    stateMachine_shifter;
  reg                 stateMachine_validReg;
  wire                when_uartCtrlRx_l106;
  wire                when_uartCtrlRx_l116;
  wire                when_uartCtrlRx_l124;
  wire                when_uartCtrlRx_l126;
  wire                when_uartCtrlRx_l138;
  wire                when_uartCtrlRx_l149;
  wire                when_uartCtrlRx_l152;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_when_uartCtrlRx_l152_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_uartCtrlRx_l152 = {3'd0, _zz_when_uartCtrlRx_l152_1};
  (* keep_hierarchy = "TRUE" *) BufferCC_2 io_rxd_buffercc (
    .io_dataIn  (io_rxd                    ), //i
    .io_dataOut (io_rxd_buffercc_io_dataOut), //o
    .clk        (clk                       ), //i
    .reset      (reset                     )  //i
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
          if(!when_uartCtrlRx_l138) begin
            io_error = 1'b1;
          end
        end
      end
      default : begin
        if(bitTimer_tick) begin
          if(when_uartCtrlRx_l149) begin
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
      if(when_uartCtrlRx_l50) begin
        bitTimer_tick = 1'b1;
      end
    end
  end

  assign when_uartCtrlRx_l50 = (bitTimer_counter == 3'b000);
  assign break_valid = (break_counter == 7'h41);
  assign when_uartCtrlRx_l82 = (io_samplingTick && (! break_valid));
  assign io_break = break_valid;
  assign io_read_valid = stateMachine_validReg;
  assign when_uartCtrlRx_l106 = ((sampler_tick && (! sampler_value)) && (! break_valid));
  assign when_uartCtrlRx_l116 = (sampler_value == 1'b1);
  assign when_uartCtrlRx_l124 = (bitCounter_value == io_configFrame_dataLength);
  assign when_uartCtrlRx_l126 = (io_configFrame_parity == UartParityType_NONE);
  assign when_uartCtrlRx_l138 = (stateMachine_parity == sampler_value);
  assign when_uartCtrlRx_l149 = (! sampler_value);
  assign when_uartCtrlRx_l152 = (bitCounter_value == _zz_when_uartCtrlRx_l152);
  assign io_read_payload = stateMachine_shifter;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
        if(when_uartCtrlRx_l82) begin
          break_counter <= (break_counter + 7'h01);
        end
      end
      stateMachine_validReg <= 1'b0;
      case(stateMachine_state)
        UartCtrlRxState_IDLE : begin
          if(when_uartCtrlRx_l106) begin
            stateMachine_state <= UartCtrlRxState_START;
          end
        end
        UartCtrlRxState_START : begin
          if(bitTimer_tick) begin
            stateMachine_state <= UartCtrlRxState_DATA;
            if(when_uartCtrlRx_l116) begin
              stateMachine_state <= UartCtrlRxState_IDLE;
            end
          end
        end
        UartCtrlRxState_DATA : begin
          if(bitTimer_tick) begin
            if(when_uartCtrlRx_l124) begin
              if(when_uartCtrlRx_l126) begin
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
            if(when_uartCtrlRx_l138) begin
              stateMachine_state <= UartCtrlRxState_STOP;
              stateMachine_validReg <= 1'b1;
            end else begin
              stateMachine_state <= UartCtrlRxState_IDLE;
            end
          end
        end
        default : begin
          if(bitTimer_tick) begin
            if(when_uartCtrlRx_l149) begin
              stateMachine_state <= UartCtrlRxState_IDLE;
            end else begin
              if(when_uartCtrlRx_l152) begin
                stateMachine_state <= UartCtrlRxState_IDLE;
              end
            end
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if(sampler_tick) begin
      bitTimer_counter <= (bitTimer_counter - 3'b001);
      if(when_uartCtrlRx_l50) begin
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
        if(when_uartCtrlRx_l106) begin
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
          if(when_uartCtrlRx_l124) begin
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

module uartCtrlTx (
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
  input  wire          clk,
  input  wire          reset
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
  wire       [3:0]    _zz_when_uartCtrlTx_l94;
  wire       [0:0]    _zz_when_uartCtrlTx_l94_1;
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
  wire                when_uartCtrlTx_l59;
  wire                when_uartCtrlTx_l74;
  wire                when_uartCtrlTx_l77;
  wire                when_uartCtrlTx_l94;
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
  assign _zz_when_uartCtrlTx_l94_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_uartCtrlTx_l94 = {3'd0, _zz_when_uartCtrlTx_l94_1};
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
          if(when_uartCtrlTx_l74) begin
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

  assign when_uartCtrlTx_l59 = ((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow);
  assign when_uartCtrlTx_l74 = (tickCounter_value == io_configFrame_dataLength);
  assign when_uartCtrlTx_l77 = (io_configFrame_parity == UartParityType_NONE);
  assign when_uartCtrlTx_l94 = (tickCounter_value == _zz_when_uartCtrlTx_l94);
  assign _zz_stateMachine_state = (io_write_valid ? UartCtrlTxState_START : UartCtrlTxState_IDLE);
  assign io_txd = _zz_io_txd;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      clockDivider_counter_value <= 3'b000;
      stateMachine_state <= UartCtrlTxState_IDLE;
      _zz_io_txd <= 1'b1;
    end else begin
      clockDivider_counter_value <= clockDivider_counter_valueNext;
      case(stateMachine_state)
        UartCtrlTxState_IDLE : begin
          if(when_uartCtrlTx_l59) begin
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
            if(when_uartCtrlTx_l74) begin
              if(when_uartCtrlTx_l77) begin
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
            if(when_uartCtrlTx_l94) begin
              stateMachine_state <= _zz_stateMachine_state;
            end
          end
        end
      endcase
      _zz_io_txd <= (stateMachine_txd && (! io_break));
    end
  end

  always @(posedge clk) begin
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
          if(when_uartCtrlTx_l74) begin
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

//BufferCC_1 replaced by BufferCC

module BufferCC (
  input  wire [15:0]   io_dataIn,
  output wire [15:0]   io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg        [15:0]   buffers_0;
  (* async_reg = "true" *) reg        [15:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module BufferCC_9 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          dvt_reset_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge dvt_reset_synchronized) begin
    if(dvt_reset_synchronized) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_8 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          dvt_reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge dvt_reset) begin
    if(dvt_reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_7 (
  input  wire [6:0]    io_dataIn,
  output wire [6:0]    io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg        [6:0]    buffers_0;
  (* async_reg = "true" *) reg        [6:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module StreamFifoCC (
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
  input  wire          clk,
  input  wire          reset,
  input  wire          dvt_clk
);

  reg        [32:0]   ram_spinal_port1;
  wire       [9:0]    popToPushGray_buffercc_io_dataOut;
  wire                reset_asyncAssertSyncDeassert_buffercc_io_dataOut;
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
  wire                reset_asyncAssertSyncDeassert;
  wire                reset_synchronized;
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
  always @(posedge clk) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= _zz_ram_port_1;
    end
  end

  always @(posedge dvt_clk) begin
    if(popCC_readPort_cmd_valid) begin
      ram_spinal_port1 <= ram[popCC_readPort_cmd_payload];
    end
  end

  (* keep_hierarchy = "TRUE" *) BufferCC_4 popToPushGray_buffercc (
    .io_dataIn  (popToPushGray[9:0]                    ), //i
    .io_dataOut (popToPushGray_buffercc_io_dataOut[9:0]), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_5 reset_asyncAssertSyncDeassert_buffercc (
    .io_dataIn  (reset_asyncAssertSyncDeassert                    ), //i
    .io_dataOut (reset_asyncAssertSyncDeassert_buffercc_io_dataOut), //o
    .dvt_clk    (dvt_clk                                          ), //i
    .reset      (reset                                            )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_6 pushToPopGray_buffercc (
    .io_dataIn          (pushToPopGray[9:0]                    ), //i
    .io_dataOut         (pushToPopGray_buffercc_io_dataOut[9:0]), //o
    .dvt_clk            (dvt_clk                               ), //i
    .reset_synchronized (reset_synchronized                    )  //i
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
  assign reset_asyncAssertSyncDeassert = (1'b0 ^ 1'b0);
  assign reset_synchronized = reset_asyncAssertSyncDeassert_buffercc_io_dataOut;
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
  always @(posedge clk or posedge reset) begin
    if(reset) begin
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

  always @(posedge dvt_clk or posedge reset_synchronized) begin
    if(reset_synchronized) begin
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

  always @(posedge dvt_clk) begin
    if(popCC_addressGen_ready) begin
      popCC_addressGen_rData <= popCC_addressGen_payload;
    end
  end


endmodule

//BufferCC_3 replaced by BufferCC_2

module BufferCC_2 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_6 (
  input  wire [9:0]    io_dataIn,
  output wire [9:0]    io_dataOut,
  input  wire          dvt_clk,
  input  wire          reset_synchronized
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [9:0]    buffers_0;
  (* async_reg = "true" *) reg        [9:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge dvt_clk or posedge reset_synchronized) begin
    if(reset_synchronized) begin
      buffers_0 <= 10'h0;
      buffers_1 <= 10'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_5 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          dvt_clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge dvt_clk or posedge reset) begin
    if(reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_4 (
  input  wire [9:0]    io_dataIn,
  output wire [9:0]    io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" , altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *) reg        [9:0]    buffers_0;
  (* async_reg = "true" *) reg        [9:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      buffers_0 <= 10'h0;
      buffers_1 <= 10'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
