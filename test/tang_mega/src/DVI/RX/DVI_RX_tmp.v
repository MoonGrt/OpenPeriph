//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.02
//Part Number: GW5AST-LV138FPG676AES
//Device: GW5AST-138
//Device Version: B
//Created Time: Wed Nov 27 17:30:54 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	DVI_RX your_instance_name(
		.I_rst_n(I_rst_n), //input I_rst_n
		.I_tmds_clk_p(I_tmds_clk_p), //input I_tmds_clk_p
		.I_tmds_clk_n(I_tmds_clk_n), //input I_tmds_clk_n
		.I_tmds_data_p(I_tmds_data_p), //input [2:0] I_tmds_data_p
		.I_tmds_data_n(I_tmds_data_n), //input [2:0] I_tmds_data_n
		.O_pll_phase(O_pll_phase), //output [3:0] O_pll_phase
		.O_pll_phase_lock(O_pll_phase_lock), //output O_pll_phase_lock
		.O_rgb_clk(O_rgb_clk), //output O_rgb_clk
		.O_rgb_vs(O_rgb_vs), //output O_rgb_vs
		.O_rgb_hs(O_rgb_hs), //output O_rgb_hs
		.O_rgb_de(O_rgb_de), //output O_rgb_de
		.O_rgb_r(O_rgb_r), //output [7:0] O_rgb_r
		.O_rgb_g(O_rgb_g), //output [7:0] O_rgb_g
		.O_rgb_b(O_rgb_b) //output [7:0] O_rgb_b
	);

//--------Copy end-------------------
