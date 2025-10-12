// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Oct 12 15:04:30 2025
// Host        : DESKTOP-MOONGRT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top sys_Apb3Periph_0_0 -prefix
//               sys_Apb3Periph_0_0_ sys_Apb3Periph_0_0_stub.v
// Design      : sys_Apb3Periph_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010iclg225-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "Apb3Periph,Vivado 2018.3" *)
module sys_Apb3Periph_0_0(io_apb_PADDR, io_apb_PSEL, io_apb_PENABLE, 
  io_apb_PREADY, io_apb_PWRITE, io_apb_PWDATA, io_apb_PRDATA, io_apb_PSLVERROR, io_gpio_read, 
  io_gpio_write, io_gpio_writeEnable, io_interrupt, clk, reset)
/* synthesis syn_black_box black_box_pad_pin="io_apb_PADDR[19:0],io_apb_PSEL[0:0],io_apb_PENABLE,io_apb_PREADY,io_apb_PWRITE,io_apb_PWDATA[31:0],io_apb_PRDATA[31:0],io_apb_PSLVERROR,io_gpio_read[31:0],io_gpio_write[31:0],io_gpio_writeEnable[31:0],io_interrupt[15:0],clk,reset" */;
  input [19:0]io_apb_PADDR;
  input [0:0]io_apb_PSEL;
  input io_apb_PENABLE;
  output io_apb_PREADY;
  input io_apb_PWRITE;
  input [31:0]io_apb_PWDATA;
  output [31:0]io_apb_PRDATA;
  output io_apb_PSLVERROR;
  input [31:0]io_gpio_read;
  output [31:0]io_gpio_write;
  output [31:0]io_gpio_writeEnable;
  output [15:0]io_interrupt;
  input clk;
  input reset;
endmodule
