//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.03 (64-bit) 
//Created Time: 2025-07-30 21:07:12
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {io_clk}]
create_clock -name sysclk -period 10 -waveform {0 5} [get_nets {sysclk_clkout}]
create_clock -name memclk -period 2.5 -waveform {0 1.25} [get_nets {memclk_clkout}]
// create_clock -name hdmiclk -period 2.694 -waveform {0 1.347} [get_nets {hdmiclk_clkout}]
set_clock_groups -asynchronous -group [get_clocks {clk}] -group [get_clocks {sysclk}] -group [get_clocks {memclk}]
