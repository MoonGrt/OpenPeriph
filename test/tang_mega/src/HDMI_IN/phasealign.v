`timescale 1ns / 1ps

module phasealign #(
    parameter kTimeoutMs = 50,
    parameter kRefClkFrqMHz = 200,
    parameter kCtlTknCount = 128
) (
    input        prst,
    input        arst,
    input        refclk,
    input        pixelclk,
    output       pbitslip,
    input  [9:0] pdata,
    output       pidly_ld,
    output       pidly_ce,
    output       pidly_inc,
    input  [4:0] pidly_cnt,
    output       paligned,
    output       perror,
    output [4:0] peyesize
);

    // parameter define
    parameter kBitslipDelay = 3;  // BITSLIP_DELAY
    parameter kTimeoutEnd = kTimeoutMs * 1000 * kRefClkFrqMHz;
    parameter CTRLTOKEN0 = 10'h354;
    parameter CTRLTOKEN1 = 10'h0ab;
    parameter CTRLTOKEN2 = 10'h154;
    parameter CTRLTOKEN3 = 10'h2ab;
    parameter kTapCntEnd = 0;
    parameter kFastTapCntEnd = 20;
    parameter kDelayWaitEnd = 3;
    parameter kEyeOpenCntMin = 3;
    parameter kEyeOpenCntEnough = 16;
    parameter ResetSt = 11'b00000000001;  // 全局复位状态
    parameter IdleSt = 11'b00000000010;  // IDLE状态
    parameter TokenSt = 11'b00000000100;  // 判断检测字符状态
    parameter EyeOpenSt = 11'b00000001000;  // 寻找延时区间状态
    parameter JtrZoneSt = 11'b00000010000;  // 判断延时区间状态
    parameter DlyIncSt = 11'b00000100000;  // 重新查找延迟区间状态
    parameter DlyTstOvfSt = 11'b00001000000;  // 延迟测试
    parameter DlyDecSt = 11'b00010000000;  // 寻找延迟中间值
    parameter DlyTstCenterSt = 11'b00100000000;  // 判断延迟中间值
    parameter AlignedSt = 11'b01000000000;  // 找到延迟中间值
    parameter AlignErrorSt = 11'b10000000000;  // 中间值错误状态

    // reg define
    reg         palign_rst = 0;  // 对齐复位信号
    reg  [ 1:0] pbitslip_cnt = 0;  // bitslip计数器
    reg         palign_err_q = 0;  // 对齐错误寄存器
    reg  [31:0] rtimeout_cnt = 0;
    reg         pbitslip = 0;
    reg         ptkn0_flagq = 0;
    reg         ptkn1_flagq = 0;
    reg         ptkn2_flagq = 0;
    reg         ptkn3_flagq = 0;
    reg         ptkn_flag = 0;
    reg         ptkn_flagq = 0;
    reg         pblank_begin = 0;
    reg  [ 9:0] pctltkn_cnt = 0;
    reg  [ 9:0] pdataq = 0;
    reg  [ 5:0] pcenter_tap = 0;
    reg  [ 4:0] peyeopen_cnt = 0;
    reg  [ 4:0] pidly_cnt_q = 0;
    reg         pdelay_ovf = 0;
    reg         pdelay_center = 0;
    reg  [ 1:0] pdelaywait_cnt = 0;
    reg         pdelaywait_ovf = 0;
    reg  [10:0] pstate = 0;
    reg         pidly_ld = 0;
    reg         pidly_inc = 0;
    reg         pidly_ce = 0;
    reg         paligned = 0;
    reg         perror = 0;
    reg         pfoundeye_flag = 0;
    reg         pfoundjtr_flag = 0;
    reg  [11:0] pStateNxt = 1;
    reg  [ 8:0] pctltkn_cnt = 0;
    reg         pctltkn_ovf = 0;
    reg         pdelayfast_ovf = 0;

    // wire define
    wire        ptimeout_rst;
    wire        pctltkn_rst;
    wire        pdelaywait_rst;
    wire        peyeopen_rst;
    wire        peyeopen_en;
    wire        ptkn0_flag;  // 特征字符标志位0
    wire        ptkn1_flag;  // 特征字符标志位1
    wire        ptkn2_flag;  // 特征字符标志位2
    wire        ptkn3_flag;  // 特征字符标志位3
    wire [ 4:0] peyesize;  // 开眼大小
    wire        ptimeout_ovf;
    wire        rtimeout_rst;
    wire        rtimeout_ovf;

    //*****************************************************
    //**                    main code
    //*****************************************************
    // FSM Outputs
    assign ptimeout_rst = (pstate == IdleSt || pstate == TokenSt) ? 1'b0 : 1'b1;
    assign pctltkn_rst = (pstate == TokenSt) ? 1'b0 : 1'b1;
    assign pdelaywait_rst = (pstate == DlyTstOvfSt || pstate == DlyTstCenterSt) ? 1'b0 : 1'b1;
    assign  peyeopen_rst = (pstate == ResetSt || ( (pstate == JtrZoneSt) && (pfoundeye_flag == 0) ) ) ? 1'b1 : 1'b0;
    assign peyeopen_en = (pstate == EyeOpenSt) ? 1'b1 : 1'b0;
    // Control Token Detection
    assign ptkn0_flag = (pdataq == CTRLTOKEN0) ? 1'b1 : 1'b0;
    assign ptkn1_flag = (pdataq == CTRLTOKEN1) ? 1'b1 : 1'b0;
    assign ptkn2_flag = (pdataq == CTRLTOKEN2) ? 1'b1 : 1'b0;
    assign ptkn3_flag = (pdataq == CTRLTOKEN3) ? 1'b1 : 1'b0;
    assign peyesize = peyeopen_cnt;
    assign rtimeout_ovf = (rtimeout_cnt != (kTimeoutEnd - 1)) ? 1'b0 : 1'b1;

    // Bitslip when phase alignment exhausted the whole tap range and still no lock
    always @(posedge pixelclk) begin
        palign_err_q <= perror;
        pbitslip <= ~palign_err_q && perror; // single pulse bitslip on failed alignment attempt
    end

    // 输出时间计数器
    always @(posedge refclk) begin
        if (rtimeout_rst) rtimeout_cnt <= 0;
        else if (rtimeout_ovf == 0) rtimeout_cnt <= rtimeout_cnt + 1;
        else rtimeout_cnt <= rtimeout_cnt;
    end

    // 对齐复位信号
    always @(posedge pixelclk) begin
        if (arst) palign_rst <= 1;
        else if (prst || pbitslip) palign_rst <= 1;
        else if (pbitslip_cnt == 0) palign_rst <= 0;
        else palign_rst <= palign_rst;
    end

    // Reset phase aligment module after bitslip + 3 CLKDIV cycles (ISERDESE2 requirement)
    always @(posedge pixelclk) begin
        if (pbitslip) pbitslip_cnt <= kBitslipDelay - 1;
        else if (pbitslip_cnt != 0) pbitslip_cnt <= pbitslip_cnt - 1;
        else pbitslip_cnt <= pbitslip_cnt;
    end

    always @(posedge pixelclk) begin
        if (pctltkn_rst) pctltkn_cnt <= 0;
        else begin
            pctltkn_cnt <= pctltkn_cnt + 1;

            if (pctltkn_cnt == kCtlTknCount - 1) pctltkn_ovf <= 1;
            else pctltkn_ovf <= 0;
        end
    end

    // Register pipeline
    always @(posedge pixelclk) begin
        pdataq <= pdata;
        ptkn0_flagq <= ptkn0_flag;
        ptkn1_flagq <= ptkn1_flag;
        ptkn2_flagq <= ptkn2_flag;
        ptkn3_flagq <= ptkn3_flag;
        ptkn_flag <= ptkn0_flag || ptkn1_flag || ptkn2_flag || ptkn3_flag;
        ptkn_flagq <= ptkn_flag;
        pblank_begin <= ~ptkn_flagq && ptkn_flag;
    end

    // Open Eye Width Counter
    always @(posedge pixelclk) begin
        if (peyeopen_rst) begin
            peyeopen_cnt <= 0;
            pcenter_tap  <= {pidly_cnt_q, 1'b1};
        end else if (peyeopen_en) begin
            peyeopen_cnt <= peyeopen_cnt + 1;
            pcenter_tap  <= pcenter_tap + 1;
        end
    end

    // Tap Delay Overflow
    always @(posedge pixelclk) begin
        pidly_cnt_q <= pidly_cnt;

        if (pidly_cnt_q == kTapCntEnd) pdelay_ovf <= 1'b1;
        else pdelay_ovf <= 1'b0;

        if (pidly_cnt_q == kFastTapCntEnd) pdelayfast_ovf <= 1'b1;
        else pdelayfast_ovf <= 1'b0;
    end

    // Tap Delay Center
    always @(posedge pixelclk) begin
        if (pidly_cnt_q == pcenter_tap / 2) pdelay_center <= 1'b1;
        else pdelay_center <= 1'b0;
    end

    always @(posedge pixelclk) begin
        if (pdelaywait_rst) pdelaywait_cnt <= 0;
        else begin
            pdelaywait_cnt <= pdelaywait_cnt + 1;

            if (pdelaywait_cnt == kDelayWaitEnd - 1) pdelaywait_ovf <= 1'b1;
            else pdelaywait_ovf <= 1'b0;
        end
    end

    // FSM
    always @(posedge pixelclk) begin
        if (palign_rst) pstate <= ResetSt;
        else pstate <= pStateNxt;
    end

    // FSM Registered Outputs
    always @(posedge pixelclk) begin
        if (pstate == ResetSt) begin
            pidly_ld <= 1;
        end else begin
            pidly_ld <= 0;
        end

        if (palign_rst) begin
            pidly_inc <= 0;
            pidly_ce  <= 0;
        end else if (pstate == DlyIncSt) begin
            pidly_inc <= 1;
            pidly_ce  <= 1;
        end else if (pstate == DlyDecSt) begin
            pidly_inc <= 0;
            pidly_ce  <= 1;
        end else begin
            pidly_inc <= pidly_inc;
            pidly_ce  <= 0;
        end

        if (pstate == AlignedSt) begin
            paligned <= 1;
        end else begin
            paligned <= 0;
        end

        if (pstate == AlignErrorSt) begin
            perror <= 1;
        end else begin
            perror <= 0;
        end
    end

    always @(posedge pixelclk) begin
        case (pstate)
            ResetSt: begin
                pfoundeye_flag <= 0;
                pfoundjtr_flag <= 0;
            end
            JtrZoneSt: begin
                pfoundeye_flag <= 0;
                pfoundjtr_flag <= 1;
            end
            EyeOpenSt: begin
                if( (pfoundjtr_flag && (peyeopen_cnt == kEyeOpenCntMin) ) || (peyeopen_cnt == kEyeOpenCntEnough) )begin
                    pfoundeye_flag <= 1;
                end else begin
                    pfoundeye_flag <= pfoundeye_flag;
                end
            end
            default: begin
                pfoundeye_flag <= pfoundeye_flag;
                pfoundjtr_flag <= pfoundjtr_flag;
            end
        endcase
    end

    always @(*) begin
        case (pstate)
            ResetSt: begin
                pStateNxt <= IdleSt;
            end
            IdleSt: begin
                if (pblank_begin) pStateNxt <= TokenSt;
                else if (ptimeout_ovf) pStateNxt <= JtrZoneSt;
                else pStateNxt <= IdleSt;
            end
            TokenSt: begin
                if (!ptkn_flagq) pStateNxt <= IdleSt;
                else if (pctltkn_ovf) pStateNxt <= EyeOpenSt;
                else pStateNxt <= TokenSt;
            end
            JtrZoneSt: begin
                if (pfoundeye_flag) pStateNxt <= DlyDecSt;
                else pStateNxt <= DlyIncSt;
            end
            EyeOpenSt: begin
                if (peyeopen_cnt == kEyeOpenCntEnough) pStateNxt <= JtrZoneSt;
                else pStateNxt <= DlyIncSt;
            end
            DlyIncSt: begin
                pStateNxt <= DlyTstOvfSt;
            end
            DlyTstOvfSt: begin
                if (pdelaywait_ovf)
                    if (pdelay_ovf) pStateNxt <= AlignErrorSt;
                    else pStateNxt <= IdleSt;
                else pStateNxt <= DlyTstOvfSt;
            end
            DlyDecSt: begin
                pStateNxt <= DlyTstCenterSt;
            end
            DlyTstCenterSt: begin
                if (pdelaywait_ovf)
                    if (pdelay_center) pStateNxt <= AlignedSt;
                    else pStateNxt <= DlyDecSt;
                else pStateNxt <= DlyTstCenterSt;
            end
            AlignedSt: begin
                pStateNxt <= AlignedSt;
            end
            AlignErrorSt: begin
                pStateNxt <= AlignErrorSt;
            end
            default: begin
                pStateNxt <= IdleSt;

            end
        endcase
    end

    syncbase #(
        .kResetTo(0)
    ) u_syncbaseovf (
        .areset(arst),
        .inclk (refclk),
        .iin   (rtimeout_ovf),
        .outclk(pixelclk),
        .oout  (ptimeout_ovf)
    );

    syncbase #(
        .kResetTo(1)
    ) u_syncbaserst (
        .areset(arst),
        .inclk (pixelclk),
        .iin   (ptimeout_rst),
        .outclk(refclk),
        .oout  (rtimeout_rst)
    );

endmodule
