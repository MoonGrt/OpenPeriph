
// file: selectio_wiz_0_selectio_wiz.v
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
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
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//----------------------------------------------------------------------------

`timescale 1ps / 1ps

module selectio_1_10  // width of the data for the system
#(
    parameter SYS_W = 1,
    // width of the data for the device
    parameter DEV_W = 10
) (
    // From the system into the device
    input  [   SYS_W-1:0] data_in_from_pins_p,  // 差分数据输入
    input  [   SYS_W-1:0] data_in_from_pins_n,
    output [   DEV_W-1:0] data_in_to_device,    // 10bit并行数据输出
    input                 in_delay_ld,          // 加载寄存器的延迟值
    input  [SYS_W -1 : 0] in_delay_data_ce,     // 调整延迟值的有效使能
    input  [SYS_W -1 : 0] in_delay_data_inc,    // 增减延迟值

    input              ref_clock,         // 200M参考时钟
    input  [SYS_W-1:0] bitslip,           // 字对齐调整信号
    output [      4:0] in_delay_data_cnt, // 当前延迟值

    input clk_in,      // 5倍像素时钟
    input clk_div_in,  // 1倍像素时钟
    input io_reset     // io的复位
);

    localparam num_serial_bits = DEV_W / SYS_W;


    wire [SYS_W-1:0] data_in_from_pins_int;
    wire [SYS_W-1:0] data_in_from_pins_delay;
    wire [SYS_W-1:0] delay_data_busy;
    wire [SYS_W-1:0] in_delay_ce;
    wire [SYS_W-1:0] in_delay_inc_dec;
    wire             ref_clock_bufg;
    wire [SYS_W-1:0] iserdes_q               [0:13];

    assign in_delay_ce = {in_delay_data_ce[0]};
    assign in_delay_inc_dec = {in_delay_data_inc[0]};

    // We have multiple bits- step over every bit, instantiating the required elements
    genvar pin_count;
    genvar slice_count;
    generate
        for (pin_count = 0; pin_count < SYS_W; pin_count = pin_count + 1) begin : pins
            // Instantiate the buffers
            ////------------------------------
            // Instantiate a buffer for every bit of the data bus
            IBUFDS #(
                .DIFF_TERM ("FALSE"),   // Differential termination
                .IOSTANDARD("TMDS_33")
            ) ibufds_inst (
                .I (data_in_from_pins_p[pin_count]),
                .IB(data_in_from_pins_n[pin_count]),
                .O (data_in_from_pins_int[pin_count])
            );

            // Instantiate the delay primitive
            ////-------------------------------

            (* IODELAY_GROUP = "selectio_wiz_0_group" *)
            IDELAYE2 #(
                .CINVCTRL_SEL         ("FALSE"),     // TRUE, FALSE
                .DELAY_SRC            ("IDATAIN"),   // IDATAIN, DATAIN
                .HIGH_PERFORMANCE_MODE("FALSE"),     // TRUE, FALSE
                .IDELAY_TYPE          ("VARIABLE"),  // FIXED, VARIABLE, or VAR_LOADABLE
                .IDELAY_VALUE         (0),           // 0 to 31
                .REFCLK_FREQUENCY     (200.0),
                .PIPE_SEL             ("FALSE"),
                .SIGNAL_PATTERN       ("DATA")
            )  // CLOCK, DATA
                idelaye2_bus (
                .DATAOUT    (data_in_from_pins_delay[pin_count]),
                .DATAIN     (1'b0),
                .C          (clk_div_in),
                .CE         (in_delay_ce[pin_count]),
                .INC        (in_delay_inc_dec[pin_count]),
                .IDATAIN    (data_in_from_pins_int[pin_count]),
                .LD         (in_delay_ld),
                .REGRST     (io_reset),
                .LDPIPEEN   (1'b0),
                .CNTVALUEIN (5'b00000),
                .CNTVALUEOUT(in_delay_data_cnt),
                .CINVCTRL   (1'b0)
            );

            // local wire only for use in this generate loop
            wire             cascade_shift;
            wire [SYS_W-1:0] icascade1;
            wire [SYS_W-1:0] icascade2;
            wire             clk_in_int_inv;

            assign clk_in_int_inv = ~clk_in;

            // declare the iserdes
            ISERDESE2 #(
                .DATA_RATE        ("DDR"),
                .DATA_WIDTH       (10),
                .INTERFACE_TYPE   ("NETWORKING"),
                .DYN_CLKDIV_INV_EN("FALSE"),
                .DYN_CLK_INV_EN   ("FALSE"),
                .NUM_CE           (2),
                .OFB_USED         ("FALSE"),
                .IOBDELAY         ("IFD"),
                .SERDES_MODE      ("MASTER")
            ) iserdese2_master (
                .Q1       (iserdes_q[0][pin_count]),
                .Q2       (iserdes_q[1][pin_count]),
                .Q3       (iserdes_q[2][pin_count]),
                .Q4       (iserdes_q[3][pin_count]),
                .Q5       (iserdes_q[4][pin_count]),
                .Q6       (iserdes_q[5][pin_count]),
                .Q7       (iserdes_q[6][pin_count]),
                .Q8       (iserdes_q[7][pin_count]),
                .SHIFTOUT1(icascade1[pin_count]),
                .SHIFTOUT2(icascade2[pin_count]),
                .BITSLIP  (bitslip[pin_count]),

                .CE1         (1'b1),
                .CE2         (1'b1),
                .CLK         (clk_in),
                .CLKB        (clk_in_int_inv),
                .CLKDIV      (clk_div_in),
                .CLKDIVP     (1'b0),
                .D           (1'b0),
                .DDLY        (data_in_from_pins_delay[pin_count]),
                .RST         (io_reset),
                .SHIFTIN1    (1'b0),
                .SHIFTIN2    (1'b0),
                // unused connections
                .DYNCLKDIVSEL(1'b0),
                .DYNCLKSEL   (1'b0),
                .OFB         (1'b0),
                .OCLK        (1'b0),
                .OCLKB       (1'b0),
                .O           ()
            );

            ISERDESE2 #(
                .DATA_RATE        ("DDR"),
                .DATA_WIDTH       (10),
                .INTERFACE_TYPE   ("NETWORKING"),
                .DYN_CLKDIV_INV_EN("FALSE"),
                .DYN_CLK_INV_EN   ("FALSE"),
                .NUM_CE           (2),
                .OFB_USED         ("FALSE"),
                .IOBDELAY         ("IFD"),
                .SERDES_MODE      ("SLAVE")
            ) iserdese2_slave (
                .Q1       (),
                .Q2       (),
                .Q3       (iserdes_q[8][pin_count]),
                .Q4       (iserdes_q[9][pin_count]),
                .Q5       (iserdes_q[10][pin_count]),
                .Q6       (iserdes_q[11][pin_count]),
                .Q7       (iserdes_q[12][pin_count]),
                .Q8       (iserdes_q[13][pin_count]),
                .SHIFTOUT1(),
                .SHIFTOUT2(),
                .SHIFTIN1 (icascade1[pin_count]),
                .SHIFTIN2 (icascade2[pin_count]),
                .BITSLIP  (bitslip[pin_count]),

                .CE1         (1'b1),
                .CE2         (1'b1),
                .CLK         (clk_in),
                .CLKB        (clk_in_int_inv),
                .CLKDIV      (clk_div_in),
                .CLKDIVP     (1'b0),
                .D           (1'b0),
                .DDLY        (1'b0),
                .RST         (io_reset),
                // unused connections
                .DYNCLKDIVSEL(1'b0),
                .DYNCLKSEL   (1'b0),
                .OFB         (1'b0),
                .OCLK        (1'b0),
                .OCLKB       (1'b0),
                .O           ()
            );
            ////---------------------------------------------------------
            for (
                slice_count = 0; slice_count < num_serial_bits; slice_count = slice_count + 1
            ) begin : in_slices
                assign data_in_to_device[slice_count] = iserdes_q[num_serial_bits-slice_count-1];
            end
        end
    endgenerate

    // IDELAYCTRL is needed for calibration
    (* IODELAY_GROUP = "selectio_wiz_0_group" *)
    IDELAYCTRL delayctrl (
        .RDY   (delay_locked),
        .REFCLK(ref_clock),
        .RST   (io_reset)
    );

endmodule
