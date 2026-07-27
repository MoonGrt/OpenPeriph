// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Oct 20 15:52:27 2025
// Host        : DESKTOP-MOONGRT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               G:/VM/share/OpenPeriph/test/project/Zynq7020-BX71/Zynq7020-BX71.srcs/bd/sys/ip/sys_Apb3PeriphWithLcd_0_0/sys_Apb3PeriphWithLcd_0_0_stub.v
// Design      : sys_Apb3PeriphWithLcd_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "Apb3PeriphWithLcd,Vivado 2018.3" *)
module sys_Apb3PeriphWithLcd_0_0(io_apb_PADDR, io_apb_PSEL, io_apb_PENABLE, 
  io_apb_PREADY, io_apb_PWRITE, io_apb_PWDATA, io_apb_PRDATA, io_apb_PSLVERROR, 
  io_axi_ar_valid, io_axi_ar_ready, io_axi_ar_payload_addr, io_axi_ar_payload_len, 
  io_axi_ar_payload_size, io_axi_ar_payload_cache, io_axi_ar_payload_prot, 
  io_axi_r_valid, io_axi_r_ready, io_axi_r_payload_data, io_axi_r_payload_last, 
  io_gpio_read, io_gpio_write, io_gpio_readEnable, io_interrupt, io_dvti_vs, io_dvti_hs, 
  io_dvti_de, io_dvti_data, io_lcdclk, dvt_clk, clk, reset, dvt_reset)
/* synthesis syn_black_box black_box_pad_pin="io_apb_PADDR[19:0],io_apb_PSEL[0:0],io_apb_PENABLE,io_apb_PREADY,io_apb_PWRITE,io_apb_PWDATA[31:0],io_apb_PRDATA[31:0],io_apb_PSLVERROR,io_axi_ar_valid,io_axi_ar_ready,io_axi_ar_payload_addr[31:0],io_axi_ar_payload_len[7:0],io_axi_ar_payload_size[2:0],io_axi_ar_payload_cache[3:0],io_axi_ar_payload_prot[2:0],io_axi_r_valid,io_axi_r_ready,io_axi_r_payload_data[31:0],io_axi_r_payload_last,io_gpio_read[31:0],io_gpio_write[31:0],io_gpio_readEnable[31:0],io_interrupt[15:0],io_dvti_vs,io_dvti_hs,io_dvti_de,io_dvti_data[23:0],io_lcdclk,dvt_clk,clk,reset,dvt_reset" */;
  input [19:0]io_apb_PADDR;
  input [0:0]io_apb_PSEL;
  input io_apb_PENABLE;
  output io_apb_PREADY;
  input io_apb_PWRITE;
  input [31:0]io_apb_PWDATA;
  output [31:0]io_apb_PRDATA;
  output io_apb_PSLVERROR;
  output io_axi_ar_valid;
  input io_axi_ar_ready;
  output [31:0]io_axi_ar_payload_addr;
  output [7:0]io_axi_ar_payload_len;
  output [2:0]io_axi_ar_payload_size;
  output [3:0]io_axi_ar_payload_cache;
  output [2:0]io_axi_ar_payload_prot;
  input io_axi_r_valid;
  output io_axi_r_ready;
  input [31:0]io_axi_r_payload_data;
  input io_axi_r_payload_last;
  input [31:0]io_gpio_read;
  output [31:0]io_gpio_write;
  output [31:0]io_gpio_readEnable;
  output [15:0]io_interrupt;
  output io_dvti_vs;
  output io_dvti_hs;
  output io_dvti_de;
  output [23:0]io_dvti_data;
  output io_lcdclk;
  input dvt_clk;
  input clk;
  input reset;
  input dvt_reset;
endmodule
