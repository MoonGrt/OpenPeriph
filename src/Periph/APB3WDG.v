module Apb3WDGRouter (
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

    output wire IWDG_rst,
    output wire WWDG_rst
);

    reg  [15:0] Apb3PSEL;
    // IWDG
    wire [ 1:0] io_apb_PADDR_IWDG = io_apb_PADDR[3:2];
    wire        io_apb_PSEL_IWDG = Apb3PSEL[0];
    wire        io_apb_PENABLE_IWDG = io_apb_PENABLE;
    wire        io_apb_PREADY_IWDG;
    wire        io_apb_PWRITE_IWDG = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_IWDG = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_IWDG;
    wire        io_apb_PSLVERROR_IWDG = 1'b0;
    //WWDG
    wire [ 1:0] io_apb_PADDR_WWDG = io_apb_PADDR[4:2];
    wire        io_apb_PSEL_WWDG = Apb3PSEL[1];
    wire        io_apb_PENABLE_WWDG = io_apb_PENABLE;
    wire        io_apb_PREADY_WWDG;
    wire        io_apb_PWRITE_WWDG = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_WWDG = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_WWDG;
    wire        io_apb_PSLVERROR_WWDG = 1'b0;

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
                    _zz_io_apb_PREADY = io_apb_PREADY_IWDG;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_IWDG;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_IWDG;
                end
                16'h0002: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_WWDG;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_WWDG;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_WWDG;
                end
                default: ;
            endcase
    end

    always @(*) begin
        if (io_apb_PRESET) begin
            Apb3PSEL <= 16'h0000;
        end else begin
            Apb3PSEL[0] = ((io_apb_PADDR[15:12] == 4'd0) && io_apb_PSEL[0]);  // IWDT
            Apb3PSEL[1] = ((io_apb_PADDR[15:12] == 4'd1) && io_apb_PSEL[0]);  // WWDT
        end
    end

    IWDG IWDG (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_IWDG),    // i
        .io_apb_PSEL   (io_apb_PSEL_IWDG),     // i
        .io_apb_PENABLE(io_apb_PENABLE_IWDG),  // i
        .io_apb_PREADY (io_apb_PREADY_IWDG),   // o
        .io_apb_PWRITE (io_apb_PWRITE_IWDG),   // i
        .io_apb_PWDATA (io_apb_PWDATA_IWDG),   // i
        .io_apb_PRDATA (io_apb_PRDATA_IWDG),   // o
        .IWDG_rst      (IWDG_rst)              // o
    );

    WWDG WWDG (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_WWDG),    // i
        .io_apb_PSEL   (io_apb_PSEL_WWDG),     // i
        .io_apb_PENABLE(io_apb_PENABLE_WWDG),  // i
        .io_apb_PREADY (io_apb_PREADY_WWDG),   // o
        .io_apb_PWRITE (io_apb_PWRITE_WWDG),   // i
        .io_apb_PWDATA (io_apb_PWDATA_WWDG),   // i
        .io_apb_PRDATA (io_apb_PRDATA_WWDG),   // o
        .WWDG_rst      (WWDG_rst)              // o
    );

endmodule


module IWDG (
    input  wire        io_apb_PCLK,     // APB 时钟
    input  wire        io_apb_PRESET,   // APB 复位信号，高电平复位
    input  wire [ 1:0] io_apb_PADDR,    // 地址总线
    input  wire        io_apb_PSEL,     // 选择信号
    input  wire        io_apb_PENABLE,  // 使能信号
    input  wire        io_apb_PWRITE,   // 写信号
    input  wire [31:0] io_apb_PWDATA,   // 写数据总线
    output wire        io_apb_PREADY,   // APB 准备信号
    output reg  [31:0] io_apb_PRDATA,   // 读数据总线

    output reg IWDG_rst  // 看门狗复位信号
);

    // IWDG寄存器定义
    reg [15:0] KR;  // Key register
    reg [ 2:0] PR;  // Prescaler register (使用 3 位预分频器)
    reg [11:0] RLR;  // Reload register (12 位)
    reg [ 1:0] SR;  // Status register (使用 2 位状态寄存器)

    // IWDG内部计数器和状态
    reg [31:0] counter, prescaler_counter;
    reg IWDG_en, write_en;

    // APB 写寄存器逻辑
    assign io_apb_PREADY = 1'b1;  // APB 准备信号始终为高，表示设备始终准备好
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            KR  <= 16'h0000;
            PR  <= 3'b000;
            RLR <= 12'hFFF;
        end else begin
            // APB 写操作
            KR <= 16'h0000;
            if (io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    2'b00:   KR <= io_apb_PWDATA[15:0];  // 写 Key register
                    2'b01:   if (write_en) PR <= io_apb_PWDATA[2:0];  // 写 Prescaler register
                    2'b10:   if (write_en) RLR <= io_apb_PWDATA[11:0];  // 写 Reload register
                    default: ;  // 其他寄存器不处理
                endcase
            end
        end
    end
    // APB 读寄存器逻辑
    always @(*) begin
        if (io_apb_PRESET) io_apb_PRDATA = 32'h00000000;
        else if (io_apb_PSEL && io_apb_PENABLE && ~io_apb_PWRITE) begin
            case (io_apb_PADDR)
                2'b00:   io_apb_PRDATA = {16'b0, KR};  // 读 Key register
                2'b01:   io_apb_PRDATA = {29'b0, PR};  // 读 Prescaler register
                2'b10:   io_apb_PRDATA = {20'b0, RLR};  // 读 Reload register
                2'b11:   io_apb_PRDATA = {30'b0, SR};  // 读 Status register
                default: io_apb_PRDATA = 32'h00000000;
            endcase
        end
    end

    // 计数器和分频逻辑
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            counter <= 32'h00000000;
            write_en <= 1'b0;
            IWDG_en <= 1'b0;
            IWDG_rst <= 1'b0;
            prescaler_counter <= 16'h0000;
            SR <= 2'b00;
        end else begin
            // 看门狗计时器启用条件
            if (KR)
                case (KR)
                    16'h5555: write_en <= 1'b1;  // 写使能
                    16'hAAAA: if (write_en) counter <= {20'b0, RLR};  // 重载计数器
                    16'hCCCC: begin  // 看门狗使能
                        if (write_en) begin
                            IWDG_en <= 1'b1;
                            SR      <= 2'b00;  // 清除状态寄存器
                        end
                    end
                    default: write_en <= 1'b0;  // 写失能
                endcase

            // 分频器计数逻辑
            if (IWDG_en) begin
                if (prescaler_counter == (4 << PR) - 1) begin
                    prescaler_counter <= 16'h0000;  // 分频计数器重置
                    if (counter > 0) begin
                        counter <= counter - 1;  // 分频后主计数器减少
                    end else begin
                        IWDG_rst <= 1'b1;  // 计数器达到 0 时发出复位信号
                        SR       <= 2'b01;  // 状态寄存器置位
                    end
                end else prescaler_counter <= prescaler_counter + 1;  // 分频计数器增加
            end
        end
    end

endmodule


module WWDG (
    input  wire        io_apb_PCLK,     // APB 时钟
    input  wire        io_apb_PRESET,   // APB 复位信号，高电平复位
    input  wire [ 1:0] io_apb_PADDR,    // 地址总线
    input  wire        io_apb_PSEL,     // 选择信号
    input  wire        io_apb_PENABLE,  // 使能信号
    input  wire        io_apb_PWRITE,   // 写信号
    input  wire [31:0] io_apb_PWDATA,   // 写数据总线
    output wire        io_apb_PREADY,   // APB 准备信号
    output reg  [31:0] io_apb_PRDATA,   // 读数据总线

    output reg WWDG_rst  // 看门狗复位信号
);

    // WWDG寄存器定义
    reg [7:0] CR;  // Control register
    reg [15:0] CFR;  // Configuration register
    reg SR;  // Status register

    // WWDG内部计数器和状态
    reg [15:0] prescaler_counter;
    wire [6:0] T = CR[6:0];
    wire [6:0] W = CFR[6:0];
    wire [2:0] prescaler_value = CFR[9:7];  // CFR中的预分频器
    wire WWDG_en = CR[7];  // 看门狗使能标志

    // APB 写寄存器逻辑 && 计数器逻辑
    assign io_apb_PREADY = 1'b1;  // APB 准备信号始终为高，表示设备始终准备好
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            CR <= 8'h7F;  // 初始计数器值最大
            CFR <= 16'h7F;  // 初始窗口值最大
            SR <= 1'b0;  // 初始状态寄存器清零
            WWDG_rst <= 1'b0;  // 看门狗复位信号清零
            prescaler_counter <= 16'h0000;
        end else begin
            // APB 写寄存器逻辑
            if (io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    2'b00: begin
                        if ((T > W) && WWDG_en) WWDG_rst <= 1'b1;  // 如果重载计数器时，计数器值大于窗口值，触发看门狗复位
                        else CR <= io_apb_PWDATA[15:0];  // 重载计数器
                    end
                    2'b01:   CFR <= io_apb_PWDATA;
                    2'b10:   SR <= io_apb_PWDATA;  // 写状态寄存器 (手动清除)
                    default: ;  // 其他寄存器不处理
                endcase
            end
            // 计数器逻辑
            if (WWDG_en) begin
                if (prescaler_counter == (1 << prescaler_value) - 1) begin
                    prescaler_counter <= 16'h0000;  // 分频计数器重置
                    if (T > 7'h40) begin
                        CR <= CR - 1;  // 计数器递减
                    end else begin
                        WWDG_rst <= 1'b1;  // 计数器达到 0 时发出复位信号
                        SR    <= 1'b1;  // 设置 SR 中的超时标志位
                    end
                end else prescaler_counter <= prescaler_counter + 1;  // 分频计数器增加
            end
        end
    end
    // APB 读寄存器逻辑
    always @(*) begin
        if (io_apb_PRESET) io_apb_PRDATA = 32'h00000000;
        // else if (io_apb_PSEL && io_apb_PENABLE && ~io_apb_PWRITE) begin
        else begin
            case (io_apb_PADDR)
                2'b00:   io_apb_PRDATA = {24'h000000, CR};  // 读 Control register
                2'b01:   io_apb_PRDATA = {16'h000000, CFR};  // 读 Configuration register
                2'b10:   io_apb_PRDATA = {31'h0, SR};  // 读 Status register
                default: io_apb_PRDATA = 32'h00000000;
            endcase
        end
    end

endmodule
