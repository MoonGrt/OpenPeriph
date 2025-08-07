module AhbRCC (
    input  wire        io_ahb_PCLK,       // AHB 时钟
    input  wire        io_ahb_PRESET,     // AHB 复位信号
    input  wire [ 3:0] io_ahb_PADDR,      // 地址总线
    input  wire        io_ahb_PSEL,       // 选择信号
    input  wire        io_ahb_PENABLE,    // 使能信号
    input  wire        io_ahb_PWRITE,     // 写信号
    input  wire [31:0] io_ahb_PWDATA,     // 写数据总线
    output wire        io_ahb_PREADY,     // AHB 准备信号
    output reg  [31:0] io_ahb_PRDATA,     // 读数据总线
    output wire        io_ahb_PSLVERROR,  // AHB 错误信号

    // AHB clk and reset
    input  wire pll_stop,
    output wire cmos_clk,
    output wire serial_clk,
    output wire video_clk,
    output wire memory_clk,
    output wire clk_vp,
    output wire DDR_pll_lock,
    output wire TMDS_DDR_pll_lock,

    // APB clk and reset
    output wire GPIO_clk,   // GPIOA 时钟
    output wire GPIO_rst,   // GPIOA 复位信号
    output wire USART_clk,  // USART1 时钟
    output wire USART_rst,  // USART1 复位信号
    output wire SPI_clk,    // SPI1 时钟
    output wire SPI_rst,    // SPI1 复位信号
    output wire I2C_clk,    // I2C1 时钟
    output wire I2C_rst,    // I2C1 复位信号
    output wire TIM_clk,    // TIM1 时钟
    output wire TIM_rst,    // TIM1 复位信号
    output wire WDG_clk,    // IWDG 时钟
    output wire WDG_rst     // IWDG 复位信号
);

    // RCC寄存器定义
    reg [31:0] CR;  // 控制寄存器
    reg [31:0] CFGR;  // 配置寄存器
    reg [31:0] CIR;  // 中断寄存器
    reg [31:0] AHBRSTR;  // AHB复位寄存器
    reg [31:0] AHBENR;  // AHB使能寄存器
    reg [31:0] APBENR;  // APB使能寄存器
    reg [31:0] BDCR;  // 回退控制寄存器
    reg [31:0] CSR;  // 控制和状态寄存器
    reg [31:0] APBRSTR;  // APB复位寄存器
    reg [31:0] CFGR2;  // 配置寄存器2

    assign GPIO_clk = APBENR[0] ? io_ahb_PCLK : 1'b0;
    assign GPIO_rst = APBENR[0] ? io_ahb_PRESET : 1'b0;
    assign USART_clk = APBENR[1] ? io_ahb_PCLK : 1'b0;
    assign USART_rst = APBENR[1] ? io_ahb_PRESET : 1'b0;
    assign SPI_clk = APBENR[2] ? io_ahb_PCLK : 1'b0;
    assign SPI_rst = APBENR[2] ? io_ahb_PRESET : 1'b0;
    assign I2C_clk = APBENR[3] ? io_ahb_PCLK : 1'b0;
    assign I2C_rst = APBENR[3] ? io_ahb_PRESET : 1'b0;
    assign TIM_clk = APBENR[4] ? io_ahb_PCLK : 1'b0;
    assign TIM_rst = APBENR[4] ? io_ahb_PRESET : 1'b0;
    assign WDG_clk = APBENR[5] ? io_ahb_PCLK : 1'b0;
    assign WDG_rst = APBENR[5] ? io_ahb_PRESET : 1'b0;

    // AHB 写寄存器逻辑
    assign io_ahb_PREADY = 1'b1;  // AHB 准备信号始终为高，表示设备始终准备好
    assign io_ahb_PSLVERROR = 1'b0;  // APB 错误信号始终为低，表示没有错误
    always @(posedge io_ahb_PCLK or posedge io_ahb_PRESET) begin
        if (io_ahb_PRESET) begin
            CR      <= 32'h00000000;
            CFGR    <= 32'h00000000;
            CIR     <= 32'h00000000;
            AHBRSTR <= 32'h00000000;
            AHBENR  <= 32'hffffffff;
            APBENR  <= 32'hffffffff;
            BDCR    <= 32'h00000000;
            CSR     <= 32'h00000000;
            APBRSTR <= 32'h00000000;
            CFGR2   <= 32'h00000000;
        end else begin
            if (io_ahb_PSEL && io_ahb_PENABLE && io_ahb_PWRITE) begin
                // 写寄存器
                case (io_ahb_PADDR)
                    // 4'd00:   CR <= io_ahb_PWDATA;
                    // 4'd01:   CFGR <= io_ahb_PWDATA;
                    // 4'd02:   CIR <= io_ahb_PWDATA;
                    // 4'd03:   AHBRSTR <= io_ahb_PWDATA;
                    // 4'd04:   AHBENR <= io_ahb_PWDATA;
                    // 4'd05:   AHBENR <= io_ahb_PWDATA;
                    // 4'd06:   BDCR <= io_ahb_PWDATA;
                    // 4'd07:   CSR <= io_ahb_PWDATA;
                    // 4'd08:   APBRSTR <= io_ahb_PWDATA;
                    // 4'd09:   CFGR2 <= io_ahb_PWDATA;
                    default: ;  // 其他寄存器不处理
                endcase
            end
        end
    end

    // AHB 读寄存器逻辑
    always @(*) begin
        if (io_ahb_PRESET) io_ahb_PRDATA = 32'h00000000;
        else if (io_ahb_PSEL && io_ahb_PENABLE && ~io_ahb_PWRITE) begin
            case (io_ahb_PADDR)
                4'd00: io_ahb_PRDATA = CR;  // 控制寄存器
                4'd01: io_ahb_PRDATA = CFGR;  // 配置寄存器
                4'd02: io_ahb_PRDATA = CIR;  // 中断寄存器
                4'd03: io_ahb_PRDATA = AHBRSTR;  // AHB复位寄存器
                4'd04: io_ahb_PRDATA = AHBENR;  // AHB使能寄存器
                4'd05: io_ahb_PRDATA = APBENR;  // APB使能寄存器
                4'd06: io_ahb_PRDATA = BDCR;  // 回退控制寄存器
                4'd07: io_ahb_PRDATA = CSR;  // 控制和状态寄存器
                4'd08: io_ahb_PRDATA = APBRSTR;  // APB复位寄存器
                4'd09: io_ahb_PRDATA = CFGR2;  // 配置寄存器2
                default: io_ahb_PRDATA = 32'h00000000;  // 默认返回0
            endcase
        end
    end

    // PLL
    HDMI_PLL HDMI_PLL (
        .clkin  (io_ahb_PCLK),       // input clk
        .clkout0(serial_clk),        // output clk x5
        .clkout1(video_clk),         // output clk x1
        .lock   (TMDS_DDR_pll_lock)  // output lock
    );
    SYS_PLL SYS_PLL (
        .clkin  (io_ahb_PCLK),
        .clkout0(cmos_clk),
        .clkout1(clk_vp),
        .clkout2(memory_clk),
        .lock   (DDR_pll_lock),
        .reset  (1'b0),
        .enclk0 (1'b1),
        .enclk1 (1'b1),
        .enclk2 (pll_stop)
    );

endmodule
