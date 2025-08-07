// SYS
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}] -add

// HDMI_PLL video_clk
//create_generated_clock -name clk_74_25 -source [get_ports {clk}] -master_clock clk -divide_by 200 -multiply_by 297 [get_nets {Cyber/AhbDVP/video_clk}]
create_generated_clock -name clk_74_25 -source [get_ports {clk}] -master_clock clk -divide_by 200 -multiply_by 297 [get_nets {lcd_clk}]

// SYS_PLL PLL1
//create_generated_clock -name clk_vp -source [get_ports {clk}] -master_clock clk -divide_by 1 -multiply_by 2 [get_nets {vp_clk}]

// SYS_PLL PLL2
create_generated_clock -name mem_clk -source [get_ports {clk}] -master_clock clk -divide_by 1 -multiply_by 8 [get_nets {Cyber/memory_clk}]

// ddr pll
create_generated_clock -name clk_x1 -source [get_nets {Cyber/memory_clk}] -master_clock mem_clk -divide_by 4 -multiply_by 1 [get_pins {Cyber/AHBDMA/DDR3MI/gw3_top/u_ddr_phy_top/fclkdiv/CLKOUT}]

// camera pclk
//create_clock -name cmos_pclk -period 5.88 -waveform {0 2.94} [get_ports {cmos_pclk}]
create_clock -name cmos_pclk -period 23.81 -waveform {0 11.9} [get_ports {cmos_pclk}]
create_generated_clock -name cmos_pclk_div2 -source [get_ports {cmos_pclk}] -master_clock cmos_pclk -divide_by 2 -multiply_by 1 [get_nets {Cyber/AhbDVP/vi_clk_Z}]
create_clock -name cmos_vsync -period 10000 -waveform {0 5000} [get_ports {cmos_vsync}]

set_clock_groups -asynchronous
//                               -group [get_clocks {clk_vp}]
                               -group [get_clocks {clk_74_25}]
                               -group [get_clocks {clk_x1}]
                               -group [get_clocks {mem_clk}]
                               -group [get_clocks {cmos_pclk}]
                               -group [get_clocks {cmos_pclk_div2}]
                               -group [get_clocks {cmos_vsync}]
                               -group [get_clocks {clk}]

//report_timing -hold -from_clock [get_clocks {clk*}] -to_clock [get_clocks {clk*}] -max_paths 25 -max_common_paths 1
//report_timing -setup -from_clock [get_clocks {clk*}] -to_clock [get_clocks {clk*}] -max_paths 25 -max_common_paths 1

create_clock -name tmds_clk_p_1 -period 2.693 -waveform {0 1.3465} [get_ports {tmds_clk_p_1}] -add
create_clock -name HDMI_clk -period 13.468 -waveform {0 6.734} [get_nets {HDMI_clk}] -add
set_clock_groups -exclusive -group [get_clocks {tmds_clk_p_1}] -group [get_clocks {HDMI_clk}]
