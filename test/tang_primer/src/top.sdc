//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.03 (64-bit) 
//Created Time: 2025-07-09 20:05:03
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {io_clk}]
create_clock -name sysclk -period 20 -waveform {0 10} [get_nets {sysclk_clkout}]
create_clock -name memclk -period 2.5 -waveform {0 1.25} [get_nets {memclk_clkout}]
