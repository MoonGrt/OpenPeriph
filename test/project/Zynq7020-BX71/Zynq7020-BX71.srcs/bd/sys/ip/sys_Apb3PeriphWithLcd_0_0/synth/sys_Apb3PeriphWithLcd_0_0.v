// (c) Copyright 1995-2025 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:Apb3PeriphWithLcd:1.0
// IP Revision: 5

(* X_CORE_INFO = "Apb3PeriphWithLcd,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "sys_Apb3PeriphWithLcd_0_0,Apb3PeriphWithLcd,{}" *)
(* CORE_GENERATION_INFO = "sys_Apb3PeriphWithLcd_0_0,Apb3PeriphWithLcd,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=Apb3PeriphWithLcd,x_ipVersion=1.0,x_ipCoreRevision=5,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module sys_Apb3PeriphWithLcd_0_0 (
  io_apb_PADDR,
  io_apb_PSEL,
  io_apb_PENABLE,
  io_apb_PREADY,
  io_apb_PWRITE,
  io_apb_PWDATA,
  io_apb_PRDATA,
  io_apb_PSLVERROR,
  io_axi_ar_valid,
  io_axi_ar_ready,
  io_axi_ar_payload_addr,
  io_axi_ar_payload_len,
  io_axi_ar_payload_size,
  io_axi_ar_payload_cache,
  io_axi_ar_payload_prot,
  io_axi_r_valid,
  io_axi_r_ready,
  io_axi_r_payload_data,
  io_axi_r_payload_last,
  io_gpio_read,
  io_gpio_write,
  io_gpio_readEnable,
  io_interrupt,
  io_dvti_vs,
  io_dvti_hs,
  io_dvti_de,
  io_dvti_data,
  io_lcdclk,
  dvt_clk,
  clk,
  reset,
  dvt_reset
);

(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PADDR" *)
input wire [19 : 0] io_apb_PADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PSEL" *)
input wire [0 : 0] io_apb_PSEL;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PENABLE" *)
input wire io_apb_PENABLE;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PREADY" *)
output wire io_apb_PREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PWRITE" *)
input wire io_apb_PWRITE;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PWDATA" *)
input wire [31 : 0] io_apb_PWDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PRDATA" *)
output wire [31 : 0] io_apb_PRDATA;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME SAPB_PERIPH, ASSOCIATED_BUSIF clk" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PSLVERR" *)
output wire io_apb_PSLVERROR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARVALID" *)
output wire io_axi_ar_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARREADY" *)
input wire io_axi_ar_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARADDR" *)
output wire [31 : 0] io_axi_ar_payload_addr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARLEN" *)
output wire [7 : 0] io_axi_ar_payload_len;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARSIZE" *)
output wire [2 : 0] io_axi_ar_payload_size;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARCACHE" *)
output wire [3 : 0] io_axi_ar_payload_cache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC ARPROT" *)
output wire [2 : 0] io_axi_ar_payload_prot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC RVALID" *)
input wire io_axi_r_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC RREADY" *)
output wire io_axi_r_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC RDATA" *)
input wire [31 : 0] io_axi_r_payload_data;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MAXI_DVTC, NUM_READ_OUTSTANDING 32, NUM_WRITE_OUTSTANDING 32, ASSOCIATED_BUSIF MAXI_DVTC, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 5e+07, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_ONLY, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 0, HAS_BRESP 0, HAS_RRESP 0, SUPPORTS_NARROW_BURST 1, MAX_BURST_LENGTH 256, PHASE 0.000, CLK_DOMAIN sys_processing_system7_0_0_FCLK\
_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MAXI_DVTC RLAST" *)
input wire io_axi_r_payload_last;
(* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO TRI_I" *)
input wire [31 : 0] io_gpio_read;
(* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO TRI_O" *)
output wire [31 : 0] io_gpio_write;
(* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO TRI_T" *)
output wire [31 : 0] io_gpio_readEnable;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME io_interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 16" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 io_interrupt INTERRUPT" *)
output wire [15 : 0] io_interrupt;
(* X_INTERFACE_INFO = "xilinx.com:interface:dvi:1.0 DVTI VSYNC" *)
output wire io_dvti_vs;
(* X_INTERFACE_INFO = "xilinx.com:interface:dvi:1.0 DVTI HSYNC" *)
output wire io_dvti_hs;
(* X_INTERFACE_INFO = "xilinx.com:interface:dvi:1.0 DVTI DE" *)
output wire io_dvti_de;
(* X_INTERFACE_INFO = "xilinx.com:interface:dvi:1.0 DVTI DATA" *)
output wire [23 : 0] io_dvti_data;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DVTI, CAN_DEBUG false" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:dvi:1.0 DVTI CLK_P" *)
output wire io_lcdclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dvt_clk, ASSOCIATED_RESET dvt_reset, ASSOCIATED_BUSIF DVTI, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN sys_axi_dynclk_0_0_PXL_CLK_O, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dvt_clk CLK" *)
input wire dvt_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET reset, ASSOCIATED_BUSIF MAXI_DVTC, FREQ_HZ 5e+07, PHASE 0.000, CLK_DOMAIN sys_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset RST" *)
input wire reset;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dvt_reset, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 dvt_reset RST" *)
input wire dvt_reset;

  Apb3PeriphWithLcd inst (
    .io_apb_PADDR(io_apb_PADDR),
    .io_apb_PSEL(io_apb_PSEL),
    .io_apb_PENABLE(io_apb_PENABLE),
    .io_apb_PREADY(io_apb_PREADY),
    .io_apb_PWRITE(io_apb_PWRITE),
    .io_apb_PWDATA(io_apb_PWDATA),
    .io_apb_PRDATA(io_apb_PRDATA),
    .io_apb_PSLVERROR(io_apb_PSLVERROR),
    .io_axi_ar_valid(io_axi_ar_valid),
    .io_axi_ar_ready(io_axi_ar_ready),
    .io_axi_ar_payload_addr(io_axi_ar_payload_addr),
    .io_axi_ar_payload_len(io_axi_ar_payload_len),
    .io_axi_ar_payload_size(io_axi_ar_payload_size),
    .io_axi_ar_payload_cache(io_axi_ar_payload_cache),
    .io_axi_ar_payload_prot(io_axi_ar_payload_prot),
    .io_axi_r_valid(io_axi_r_valid),
    .io_axi_r_ready(io_axi_r_ready),
    .io_axi_r_payload_data(io_axi_r_payload_data),
    .io_axi_r_payload_last(io_axi_r_payload_last),
    .io_gpio_read(io_gpio_read),
    .io_gpio_write(io_gpio_write),
    .io_gpio_readEnable(io_gpio_readEnable),
    .io_interrupt(io_interrupt),
    .io_dvti_vs(io_dvti_vs),
    .io_dvti_hs(io_dvti_hs),
    .io_dvti_de(io_dvti_de),
    .io_dvti_data(io_dvti_data),
    .io_lcdclk(io_lcdclk),
    .dvt_clk(dvt_clk),
    .clk(clk),
    .reset(reset),
    .dvt_reset(dvt_reset)
  );
endmodule
