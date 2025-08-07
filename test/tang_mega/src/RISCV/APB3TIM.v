module Apb3TIMRouter (
    input  wire        io_apb_PCLK,
    input  wire        io_apb_PRESET,
    input  wire [15:0] io_apb_PADDR,
    input  wire [ 0:0] io_apb_PSEL,
    input  wire        io_apb_PENABLE,
    output wire        io_apb_PREADY,
    input  wire        io_apb_PWRITE,
    input  wire [31:0] io_apb_PWDATA,
    output wire [31:0] io_apb_PRDATA,
    output wire        io_apb_PSLVERROR,

    output wire [3:0] TIM1_CH,
    output wire       TIM1_interrupt,
    output wire [3:0] TIM2_CH,
    output wire       TIM2_interrupt
);

    reg  [15:0] Apb3PSEL = 16'h0000;
    // TIM1
    wire [ 4:0] io_apb_PADDR_TIM1 = io_apb_PADDR[6:2];
    wire        io_apb_PSEL_TIM1 = Apb3PSEL[0];
    wire        io_apb_PENABLE_TIM1 = io_apb_PENABLE;
    wire        io_apb_PREADY_TIM1;
    wire        io_apb_PWRITE_TIM1 = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_TIM1 = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_TIM1;
    wire        io_apb_PSLVERROR_TIM1 = 1'b0;
    // TIM2
    wire [ 4:0] io_apb_PADDR_TIM2 = io_apb_PADDR[6:2];
    wire        io_apb_PSEL_TIM2 = Apb3PSEL[1];
    wire        io_apb_PENABLE_TIM2 = io_apb_PENABLE;
    wire        io_apb_PREADY_TIM2;
    wire        io_apb_PWRITE_TIM2 = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_TIM2 = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_TIM2;
    wire        io_apb_PSLVERROR_TIM2 = 1'b0;

    reg [15:0] selIndex;
    reg        _zz_io_apb_PREADY;
    reg [31:0] _zz_io_apb_PRDATA;
    reg        _zz_io_apb_PSLVERROR;
    assign io_apb_PREADY = _zz_io_apb_PREADY;
    assign io_apb_PRDATA = _zz_io_apb_PRDATA;
    assign io_apb_PSLVERROR = _zz_io_apb_PSLVERROR;
    always @(posedge io_apb_PCLK) selIndex <= Apb3PSEL;
    always @(*) begin
        if (io_apb_PRESET) begin
            _zz_io_apb_PREADY <= 1'b1;
            _zz_io_apb_PRDATA <= 32'h0;
            _zz_io_apb_PSLVERROR <= 1'b0;
        end
        else
            case (selIndex)
                16'h0001: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_TIM1;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_TIM1;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_TIM1;
                end
                16'h0002: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_TIM2;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_TIM2;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_TIM2;
                end
                default: ;
            endcase
    end

    always @(*) begin
        if (io_apb_PRESET) begin
            Apb3PSEL = 16'h0000;
        end else begin
            Apb3PSEL[0] = ((io_apb_PADDR[15:12] == 4'd0) && io_apb_PSEL[0]);  // TIM1
            Apb3PSEL[1] = ((io_apb_PADDR[15:12] == 4'd1) && io_apb_PSEL[0]);  // TIM2
        end
    end

    Apb3TIM Apb3TIM1 (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_TIM1),    // i
        .io_apb_PSEL   (io_apb_PSEL_TIM1),     // i
        .io_apb_PENABLE(io_apb_PENABLE_TIM1),  // i
        .io_apb_PREADY (io_apb_PREADY_TIM1),   // o
        .io_apb_PWRITE (io_apb_PWRITE_TIM1),   // i
        .io_apb_PWDATA (io_apb_PWDATA_TIM1),   // i
        .io_apb_PRDATA (io_apb_PRDATA_TIM1),   // o
        .TIM_CH        (TIM1_CH),              // o
        .interrupt     (TIM1_interrupt)        // o
    );

    Apb3TIM Apb3TIM2 (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_TIM2),    // i
        .io_apb_PSEL   (io_apb_PSEL_TIM2),     // i
        .io_apb_PENABLE(io_apb_PENABLE_TIM2),  // i
        .io_apb_PREADY (io_apb_PREADY_TIM2),   // o
        .io_apb_PWRITE (io_apb_PWRITE_TIM2),   // i
        .io_apb_PWDATA (io_apb_PWDATA_TIM2),   // i
        .io_apb_PRDATA (io_apb_PRDATA_TIM2),   // o
        .TIM_CH        (TIM2_CH),              // o
        .interrupt     (TIM2_interrupt)        // o
    );

endmodule


module Apb3TIM (
    input  wire        io_apb_PCLK,     // APB 时钟
    input  wire        io_apb_PRESET,   // APB 复位信号，高电平复位
    input  wire [ 4:0] io_apb_PADDR,    // 地址总线
    input  wire        io_apb_PSEL,     // 选择信号
    input  wire        io_apb_PENABLE,  // 使能信号
    input  wire        io_apb_PWRITE,   // 写信号
    input  wire [31:0] io_apb_PWDATA,   // 写数据总线
    output wire        io_apb_PREADY,   // APB 准备信号
    output reg  [31:0] io_apb_PRDATA,   // 读数据总线

    output wire [ 3:0] TIM_CH,    // TIM 通道输出
    output wire        interrupt  // TIM 中断输出
);

    // TIM 寄存器定义
    reg [15:0] CR1;  // 控制寄存器1
    reg [15:0] CR2;  // 控制寄存器2
    reg [15:0] SMCR;  // 从模式控制寄存器
    reg [15:0] DIER;  // DMA/中断使能寄存器
    reg [15:0] SR;  // 状态寄存器
    reg [15:0] EGR;  // 事件生成寄存器
    reg [15:0] CCMR1;  // 捕获/比较模式寄存器1
    reg [15:0] CCMR2;  // 捕获/比较模式寄存器2
    reg [15:0] CCER;  // 捕获/比较使能寄存器
    reg [15:0] CNT;  // 计数器
    reg [15:0] PSC;  // 预分频器
    reg [15:0] ARR;  // 自动重装载寄存器
    reg [15:0] RCR;  // 重装载寄存器
    reg [15:0] CCR1;  // 捕获/比较寄存器1
    reg [15:0] CCR2;  // 捕获/比较寄存器2
    reg [15:0] CCR3;  // 捕获/比较寄存器3
    reg [15:0] CCR4;  // 捕获/比较寄存器4
    reg [15:0] BDTR;  // 刹车和死区寄存器
    reg [15:0] DCR;  // DMA 控制寄存器
    reg [15:0] DMAR;  // DMA 地址寄存器

    // TIM Config 接口定义
    // CR1
    wire        CEN = CR1[0];  // 使能计数器
    wire        DIR = CR1[4];  // 方向  0：计数器向上计数；1：计数器向下计数。
    wire [ 1:0] CMS = CR1[6:5];  // 选择中央对齐模式
    wire        ARPE = CR1[7];  // 自动重装载预装载允许位
    wire [ 1:0] CKD = CR1[9:8];  // 时钟分频因子
    // CR2
    wire [ 2:0] MMS = CR2[6:4];  // 主输出模式
    // DIER
    wire        UIE = DIER[0];  // 允许更新中断
    wire        CC1IE = DIER[1];  // 允许捕获/比较1中断
    wire        CC2IE = DIER[2];  // 允许捕获/比较2中断
    wire        CC3IE = DIER[3];  // 允许捕获/比较3中断
    wire        CC4IE = DIER[4];  // 允许捕获/比较4中断
    wire        TIE = DIER[6];  // 触发中断使能
    // SR
    wire        UIF = SR[0];  // 更新中断标志
    wire        CC1IF = SR[1];  // 捕获/比较1中断标志
    wire        CC2IF = SR[2];  // 捕获/比较2中断标志
    wire        CC3IF = SR[3];  // 捕获/比较3中断标志
    wire        CC4IF = SR[4];  // 捕获/比较4中断标志
    wire        TIF = SR[6];  // 触发中断标志

    // TIM 中断输出
    assign interrupt = (UIE & UIF);  // 更新中断

    // 定时器逻辑寄存器
    reg [15:0] prescaler_counter;  // 用于实现预分频的计数器
    reg [ 1:0] clk_div_counter;  // 用于实现时钟分频的计数器

    // APB 写寄存器逻辑  && 定时器逻辑
    assign io_apb_PREADY = 1'b1;  // APB 准备信号始终为高，表示设备始终准备好
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            CR1 <= 16'h0000;
            CR2 <= 16'h0000;
            SMCR <= 16'h0000;
            DIER <= 16'h0000;
            SR <= 16'h0000;
            EGR <= 16'h0000;
            CCMR1 <= 16'h0000;
            CCMR2 <= 16'h0000;
            CCER <= 16'h0000;
            CNT <= 16'h0000;
            PSC <= 16'h0000;
            ARR <= 16'hFFFF;
            RCR <= 16'h0000;
            CCR1 <= 16'h0000;
            CCR2 <= 16'h0000;
            CCR3 <= 16'h0000;
            CCR4 <= 16'h0000;
            BDTR <= 16'h0000;
            DCR <= 16'h0000;
            DMAR <= 16'h0000;
            prescaler_counter <= 16'h0000;
            clk_div_counter   <= 2'b00;
        end else begin
            // APB 写寄存器逻辑
            if (io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE) 
                case (io_apb_PADDR)
                    5'd00:   CR1 <= io_apb_PWDATA[15:0];  // 写 CR1
                    5'd01:   CR2 <= io_apb_PWDATA[15:0];  // 写 CR2
                    5'd02:   SMCR <= io_apb_PWDATA[15:0];  // 写 SMCR
                    5'd03:   DIER <= io_apb_PWDATA[15:0];  // 写 DIER
                    5'd04:   SR <= io_apb_PWDATA[15:0];  // 写 SR
                    5'd05:   EGR <= io_apb_PWDATA[15:0];  // 写 EGR
                    5'd06:   CCMR1 <= io_apb_PWDATA[15:0];  // 写 CCMR1
                    5'd07:   CCMR2 <= io_apb_PWDATA[15:0];  // 写 CCMR2
                    5'd08:   CCER <= io_apb_PWDATA[15:0];  // 写 CCER
                    5'd09:   CNT <= io_apb_PWDATA[15:0];  // 写 CNT
                    5'd10:   PSC <= io_apb_PWDATA[15:0];  // 写 PSC
                    5'd11:   ARR <= io_apb_PWDATA[15:0];  // 写 ARR
                    5'd12:   RCR <= io_apb_PWDATA[15:0];  // 写 CCR1
                    5'd13:   CCR1 <= io_apb_PWDATA[15:0];  // 写 CCR1
                    5'd14:   CCR2 <= io_apb_PWDATA[15:0];  // 写 CCR2
                    5'd15:   CCR3 <= io_apb_PWDATA[15:0];  // 写 CCR3
                    5'd16:   CCR4 <= io_apb_PWDATA[15:0];  // 写 CCR4
                    5'd17:   BDTR <= io_apb_PWDATA[15:0];  // 写 BDTR
                    5'd18:   DCR <= io_apb_PWDATA[15:0];  // 写 DCR
                    5'd19:   DMAR <= io_apb_PWDATA[15:0];  // 写 DMAR
                    default: ;  // 其他寄存器不处理
                endcase
            // 计数器逻辑
            if (CEN) begin
                // 时钟分频逻辑 (CKD)
                case (CKD)
                    2'b00:  // 不进行时钟分频，直接使用时钟
                        clk_div_counter <= 2'b00;
                    2'b01:  // tDTS = 2 x tCK_INT
                        clk_div_counter <= (clk_div_counter == 2'b01) ? 2'b00 : clk_div_counter + 1'b1;
                    2'b10:  // tDTS = 4 x tCK_INT
                        clk_div_counter <= (clk_div_counter == 2'b11) ? 2'b00 : clk_div_counter + 1'b1;
                endcase
                // 预分频逻辑 (PSC)
                if (prescaler_counter == PSC) begin
                    prescaler_counter <= 16'h0000;  // 当计数达到预分频器值时，重置计数器
                    if (clk_div_counter == 2'b00 || CKD == 2'b00)
                        if (CNT == ARR) begin
                            CNT <= 16'h0000;    // 当计数器达到自动重装载值时，重置计数器
                            if (UIE)
                                SR[0] <= 1'b1;  // 设置更新中断标志位
                        end else
                            CNT <= CNT + 1'b1;
                end else if (~UIF) prescaler_counter <= prescaler_counter + 1'b1;
            end
        end
    end
    // APB 读寄存器逻辑
    always @(*) begin
        if (io_apb_PRESET) begin
            io_apb_PRDATA = 32'h00000000;  // 复位时返回0
        end else if (io_apb_PSEL && io_apb_PENABLE && ~io_apb_PWRITE) begin
            case (io_apb_PADDR)
                5'd00:   io_apb_PRDATA = {16'b0, CR1};  // 读 CR1
                5'd01:   io_apb_PRDATA = {16'b0, CR2};  // 读 CR2
                5'd02:   io_apb_PRDATA = {16'b0, SMCR};  // 读 SMCR
                5'd03:   io_apb_PRDATA = {16'b0, DIER};  // 读 DIER
                5'd04:   io_apb_PRDATA = {16'b0, SR};  // 读 SR
                5'd05:   io_apb_PRDATA = {16'b0, EGR};  // 读 EGR
                5'd06:   io_apb_PRDATA = {16'b0, CCMR1};  // 读 CCMR1
                5'd07:   io_apb_PRDATA = {16'b0, CCMR2};  // 读 CCMR2
                5'd08:   io_apb_PRDATA = {16'b0, CCER};  // 读 CCER
                5'd09:   io_apb_PRDATA = {16'b0, CNT};  // 读 CNT
                5'd10:   io_apb_PRDATA = {16'b0, PSC};  // 读 PSC
                5'd11:   io_apb_PRDATA = {16'b0, ARR};  // 读 ARR
                5'd12:   io_apb_PRDATA = {16'b0, RCR};  // 读 CCR1
                5'd13:   io_apb_PRDATA = {16'b0, CCR1};  // 读 CCR1
                5'd14:   io_apb_PRDATA = {16'b0, CCR2};  // 读 CCR2
                5'd15:   io_apb_PRDATA = {16'b0, CCR3};  // 读 CCR3
                5'd16:   io_apb_PRDATA = {16'b0, CCR4};  // 读 CCR4
                5'd17:   io_apb_PRDATA = {16'b0, BDTR};  // 读 BDTR
                5'd18:   io_apb_PRDATA = {16'b0, DCR};  // 读 DCR
                5'd19:   io_apb_PRDATA = {16'b0, DMAR};  // 读 DMAR
                default: io_apb_PRDATA = 32'h00000000;  // 默认返回0
            endcase
        end
    end

    // 输出通道逻辑
    reg  [ 3:0] TIM_CH_reg;  // 输出通道寄存器
    wire [ 3:0] ccxe, ccxp;  // 输出使能位和输出极性位
    wire [63:0] CCR = {CCR4, CCR3, CCR2, CCR1};  // 合并 CCR1-4
    wire [31:0] CCMR = {CCMR2, CCMR1};  // 合并 CCMR1 和 CCMR2
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin
            assign ccxe[i] = CCER[i*4];  // CCxE 位，决定是否启用输出
            assign ccxp[i] = CCER[i*4+1];  // CCxP 位，决定输出极性
            assign TIM_CH[i] = ccxp[i] ? ~TIM_CH_reg[i] : TIM_CH_reg[i];  // 输出信号极性控制
            always @(*) begin
                if (ccxe[i])  // 如果输出使能
                    case (CCMR[i*8+6:i*8+4])  // OCxM PWM 模式控制
                        3'b110: begin  // PWM 模式 1
                            if (DIR) TIM_CH_reg[i] = (CNT > CCR[i*16+15:i*16]) ? 1'b0 : 1'b1;  // 向下计数
                            else TIM_CH_reg[i] = (CNT < CCR[i*16+15:i*16]) ? 1'b1 : 1'b0;  // 向上计数
                        end
                        3'b111: begin  // PWM 模式 2
                            if (DIR) TIM_CH_reg[i] = (CNT > CCR[i*16+15:i*16]) ? 1'b1 : 1'b0;  // 向下计数
                            else TIM_CH_reg[i] = (CNT < CCR[i*16+15:i*16]) ? 1'b0 : 1'b1;  // 向上计数
                        end
                        default: TIM_CH_reg[i] = 1'b0;  // 其他模式，默认输出低电平
                    endcase
                else TIM_CH_reg[i] = 1'b0;  // 输出未使能时，输出低电平
            end
        end
    endgenerate

endmodule
