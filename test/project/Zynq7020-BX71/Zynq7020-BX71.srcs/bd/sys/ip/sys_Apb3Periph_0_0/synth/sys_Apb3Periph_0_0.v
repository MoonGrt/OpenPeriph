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


// IP VLNV: xilinx.com:user:Apb3Periph:1.0
// IP Revision: 2

(* X_CORE_INFO = "Apb3Periph,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "sys_Apb3Periph_0_0,Apb3Periph,{}" *)
(* CORE_GENERATION_INFO = "sys_Apb3Periph_0_0,Apb3Periph,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=Apb3Periph,x_ipVersion=1.0,x_ipCoreRevision=2,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module sys_Apb3Periph_0_0 (
  io_apb_PADDR,
  io_apb_PSEL,
  io_apb_PENABLE,
  io_apb_PREADY,
  io_apb_PWRITE,
  io_apb_PWDATA,
  io_apb_PRDATA,
  io_apb_PSLVERROR,
  io_gpio_read,
  io_gpio_write,
  io_gpio_writeEnable,
  io_interrupt,
  clk,
  reset
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
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME SAPB_PERIPH, ASSOCIATED_BUSIF SAPB_PERIPH" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 SAPB_PERIPH PSLVERR" *)
output wire io_apb_PSLVERROR;
(* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO TRI_I" *)
input wire [31 : 0] io_gpio_read;
(* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO TRI_O" *)
output wire [31 : 0] io_gpio_write;
(* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO TRI_T" *)
output wire [31 : 0] io_gpio_writeEnable;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME io_interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 io_interrupt INTERRUPT" *)
output wire [15 : 0] io_interrupt;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET reset, ASSOCIATED_BUSIF SAPB_PERIPH, FREQ_HZ 50000000, PHASE 0.000, CLK_DOMAIN sys_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset RST" *)
input wire reset;

  Apb3Periph inst (
    .io_apb_PADDR(io_apb_PADDR),
    .io_apb_PSEL(io_apb_PSEL),
    .io_apb_PENABLE(io_apb_PENABLE),
    .io_apb_PREADY(io_apb_PREADY),
    .io_apb_PWRITE(io_apb_PWRITE),
    .io_apb_PWDATA(io_apb_PWDATA),
    .io_apb_PRDATA(io_apb_PRDATA),
    .io_apb_PSLVERROR(io_apb_PSLVERROR),
    .io_gpio_read(io_gpio_read),
    .io_gpio_write(io_gpio_write),
    .io_gpio_writeEnable(io_gpio_writeEnable),
    .io_interrupt(io_interrupt),
    .clk(clk),
    .reset(reset)
  );
endmodule
