//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-6
//Part Number: GW2A-LV18PG484C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Tue Oct 24 09:49:57 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	EDID_PROM_Top your_instance_name(
		.I_clk(I_clk_i), //input I_clk
		.I_rst_n(I_rst_n_i), //input I_rst_n
		.I_scl(I_scl_i), //input I_scl
		.IO_sda(IO_sda_io) //inout IO_sda
	);

//--------Copy end-------------------
