module Apb3I2CRouter (
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

    input  wire I2C1_SDA,
    output wire I2C1_SCL,
    output wire I2C1_interrupt,
    input  wire I2C2_SDA,
    output wire I2C2_SCL,
    output wire I2C2_interrupt
);

    reg  [15:0] Apb3PSEL = 16'h0000;
    // I2C1
    wire [ 3:0] io_apb_PADDR_I2C1 = io_apb_PADDR[5:2];
    wire        io_apb_PSEL_I2C1 = Apb3PSEL[0];
    wire        io_apb_PENABLE_I2C1 = io_apb_PENABLE;
    wire        io_apb_PREADY_I2C1;
    wire        io_apb_PWRITE_I2C1 = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_I2C1 = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_I2C1;
    wire        io_apb_PSLVERROR_I2C1 = 1'b0;
    // I2C2
    wire [ 3:0] io_apb_PADDR_I2C2 = io_apb_PADDR[5:2];
    wire        io_apb_PSEL_I2C2 = Apb3PSEL[1];
    wire        io_apb_PENABLE_I2C2 = io_apb_PENABLE;
    wire        io_apb_PREADY_I2C2;
    wire        io_apb_PWRITE_I2C2 = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_I2C2 = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_I2C2;
    wire        io_apb_PSLVERROR_I2C2 = 1'b0;

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
                    _zz_io_apb_PREADY = io_apb_PREADY_I2C1;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_I2C1;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_I2C1;
                end
                16'h0002: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_I2C2;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_I2C2;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_I2C2;
                end
                default: ;
            endcase
    end

    always @(*) begin
        if (io_apb_PRESET) begin
            Apb3PSEL = 16'h0000;
        end else begin
            Apb3PSEL[0] = ((io_apb_PADDR[15:12] == 4'd0) && io_apb_PSEL[0]);  // I2C1
            Apb3PSEL[1] = ((io_apb_PADDR[15:12] == 4'd1) && io_apb_PSEL[0]);  // I2C2
        end
    end

    Apb3I2C Apb3I2C1 (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_I2C1),    // i
        .io_apb_PSEL   (io_apb_PSEL_I2C1),     // i
        .io_apb_PENABLE(io_apb_PENABLE_I2C1),  // i
        .io_apb_PREADY (io_apb_PREADY_I2C1),   // o
        .io_apb_PWRITE (io_apb_PWRITE_I2C1),   // i
        .io_apb_PWDATA (io_apb_PWDATA_I2C1),   // i
        .io_apb_PRDATA (io_apb_PRDATA_I2C1),   // o
        .I2C_SDA       (I2C1_SDA),             // i
        .I2C_SCL       (I2C1_SCL),             // o
        .interrupt     (I2C1_interrupt)        // o
    );

    Apb3I2C Apb3I2C2 (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_I2C2),    // i
        .io_apb_PSEL   (io_apb_PSEL_I2C2),     // i
        .io_apb_PENABLE(io_apb_PENABLE_I2C2),  // i
        .io_apb_PREADY (io_apb_PREADY_I2C2),   // o
        .io_apb_PWRITE (io_apb_PWRITE_I2C2),   // i
        .io_apb_PWDATA (io_apb_PWDATA_I2C2),   // i
        .io_apb_PRDATA (io_apb_PRDATA_I2C2),   // o
        .I2C_SDA       (I2C2_SDA),             // i
        .I2C_SCL       (I2C2_SCL),             // o
        .interrupt     (I2C1_interrupt)        // o
    );

endmodule


module Apb3I2C (
    input  wire        io_apb_PCLK,     // APB 时钟
    input  wire        io_apb_PRESET,   // APB 复位信号，高电平复位
    input  wire [ 3:0] io_apb_PADDR,    // 地址总线
    input  wire        io_apb_PSEL,     // 选择信号
    input  wire        io_apb_PENABLE,  // 使能信号
    input  wire        io_apb_PWRITE,   // 写信号
    input  wire [31:0] io_apb_PWDATA,   // 写数据总线
    output wire        io_apb_PREADY,   // APB 准备信号
    output reg  [31:0] io_apb_PRDATA,   // 读数据总线

    // I2C 接口信号
    input  wire I2C_SDA,   // I2C 数据线
    inout  wire I2C_SCL,   // I2C 时钟线
    output wire interrupt  // I2C 中断输出
);

    // I2C 寄存器定义
    reg  [15:0] CR1;  // 控制寄存器1
    reg  [15:0] CR2;  // 控制寄存器2
    reg  [15:0] OAR1;  // 地址寄存器1
    reg  [15:0] OAR2;  // 地址寄存器2
    reg  [15:0] DR;  // 数据寄存器
    wire [15:0] SR1;  // 状态寄存器1
    wire [15:0] SR2;  // 状态寄存器2
    reg  [15:0] CCR;  // 时钟控制寄存器
    reg  [15:0] TRISE;  // 上升时间寄存器

    // I2C 中断输出
    assign interrupt = 1'b0;  // 未实现中断输出

    // I2C Config 接口定义
    // CR1
    wire       PE = CR1[0];  // I2C 使能
    wire       START = CR1[8];  // 启动条件产生
    wire       STOP = CR1[9];  // 停止条件产生
    wire       ACK = CR1[10];  // 应答使能
    // CR2
    wire       ITERREN = CR2[8];  // 出错中断使能
    wire       ITEVTEN = CR2[9];  // 事件中断使能
    wire       ITBUFEN = CR2[10];  // 缓冲区中断使能
    wire       DMAEN = CR2[11];  // DMA 使能
    // OAR1
    wire [6:0] ADD_7 = OAR1[7:1];  // 7位 从机地址
    wire [9:0] ADD_10 = OAR1[9:0];  // 10位 从机地址
    wire       ADDMODE = OAR1[15];  // 地址模式
    // SR1
    reg        SB = 1'b0;  // 起始位(主模式)
    wire       ADDR = 1'b0;  // 地址已被发送(主模式)/地址匹配(从模式)
    wire       BTF = 1'b0;  // 字节发送结束
    wire       ADD10 = 1'b0;  // 10位头序列已发送(主模式)
    wire       STOPF = 1'b0;  // 停止条件检测位(从模式)
    wire       RXNE = 1'b0;  // 数据寄存器非空(接收时)
    wire       TXE = 1'b0;  // 数据寄存器为空(发送时)
    wire       BERR = 1'b0;  // 总线出错
    wire       ARLO = 1'b0;  // 仲裁丢失(主模式)
    wire       AF = 1'b0;  // 应答失败
    wire       OVR = 1'b0;  // 过载/欠载
    wire       PECERR = 1'b0;  // 在接收时发生PEC错误
    wire       TMOUT = 1'b0;  // 超时或Tlow错误
    wire       SMBALERT = 1'b0;  // SMBus 提醒
    assign     SR1 = {SMBALERT, TMOUT, 1'b0, PECERR, OVR, AF, ARLO, BERR, TXE, RXNE, 1'b0, STOPF, ADD10, BTF, ADDR, SB};  // 状态寄存器1
    // SR2
    wire       MSL = 1'b0;  // 主从模式
    wire       BUSY = 1'b0;  // 总线忙
    wire       TRA = 1'b0;  // 发送/接收
    wire       GENCALL = 1'b0;  // 广播呼叫地址(从模式)
    wire       SMBDEFAULT = 1'b0;  // SMB 默认
    wire       SMBHOST = 1'b0;  // SMB 主机
    wire       DUALF = 1'b0;  // 双工模式
    wire [7:0] PEC = 1'b0;  // 错误校验位
    assign     SR2 = {PEC, DUALF, SMBHOST, SMBDEFAULT, GENCALL, 1'b0, TRA, BUSY, MSL};  // 状态寄存器2

    // APB 写寄存器逻辑
    assign io_apb_PREADY = 1'b1;  // APB 准备信号始终为高，表示设备始终准备好
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            CR1 <= 16'h0000;
            CR2 <= 16'h0000;
            OAR1 <= 16'h0000;
            OAR2 <= 16'h0000;
            DR <= 16'h0000;
            CCR <= 16'h0000;
            TRISE <= 16'h0000;
            SB <= 1'b0;
        end else begin
            CR1[8] <= 1'b0;  // 启动条件清除
            CR1[9] <= 1'b0;  // 停止条件清除
            if (io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    4'h0: CR1 <= io_apb_PWDATA[15:0];
                    4'h1: CR2 <= io_apb_PWDATA[15:0];
                    4'h2: OAR1 <= io_apb_PWDATA[15:0];
                    4'h3: OAR2 <= io_apb_PWDATA[15:0];
                    4'h4: DR <= io_apb_PWDATA[15:0];
                    4'h7: CCR <= io_apb_PWDATA[15:0];
                    4'h8: TRISE <= io_apb_PWDATA[15:0];
                    default: ;  // 其他寄存器不处理
                endcase
            end
            if (io_apb_PSEL)
                SB <= 1'b1;  // 已发送出起始条件
            if (io_apb_PSEL && io_apb_PENABLE && ~io_apb_PWRITE && io_apb_PADDR == 4'h5)
                SB <= 1'b0;
        end
    end

    // APB 读寄存器逻辑
    always @(*) begin
        if (io_apb_PRESET) begin
            io_apb_PRDATA = 32'h00000000;  // 复位时返回0
        end else begin
            if (io_apb_PSEL && io_apb_PENABLE && ~io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    4'h0: io_apb_PRDATA <= {16'b0, CR1};
                    4'h1: io_apb_PRDATA <= {16'b0, CR2};
                    4'h2: io_apb_PRDATA <= {16'b0, OAR1};
                    4'h3: io_apb_PRDATA <= {16'b0, OAR2};
                    4'h4: io_apb_PRDATA <= {16'b0, DR};
                    4'h5: io_apb_PRDATA <= {16'b0, SR1};
                    4'h6: io_apb_PRDATA <= {16'b0, SR2};
                    4'h7: io_apb_PRDATA <= {16'b0, CCR};
                    4'h8: io_apb_PRDATA <= {16'b0, TRISE};
                    default: io_apb_PRDATA = 32'h00000000;  // 默认返回0
                endcase
            end
        end
    end

    // I2C 收发逻辑

endmodule


// module I2CCtrl(
//     input wire clk,               // 时钟信号
//     input wire rst_n,             // 复位信号，低电平有效
//     input wire start,             // 启动信号
//     input wire [6:0] dev_addr,    // 从设备7位地址
//     input wire [7:0] reg_addr,    // 寄存器地址
//     input wire [7:0] data_in,     // 要写入的数据
//     output reg sda,               // I2C数据线
//     output reg scl,               // I2C时钟线
//     output reg busy,              // 表示模块是否忙碌
//     output reg done,              // 表示传输是否完成
//     output reg [7:0] flags        // 标志位输出
// );

//     // 定义 I2C 状态机的状态
//     typedef enum reg [3:0] {
//         IDLE,         // 空闲状态
//         START,        // 生成起始条件
//         ADDR,         // 发送设备地址
//         ADDR_ACK,     // 检查ADDR应答（ACK）
//         REG_ADDR,     // 发送寄存器地址
//         REG_ADDR_ACK, // 检查寄存器地址ACK
//         DATA,         // 发送数据
//         DATA_ACK,     // 检查数据ACK
//         STOP,         // 生成停止条件
//         DONE          // 完成状态
//     } state_t;

//     state_t state, next_state;

//     // I2C 信号控制
//     reg [7:0] bit_counter;        // 位计数器，用于跟踪发送的位数
//     reg scl_out;                  // 用于驱动 SCL 的寄存器
//     reg sda_out;                  // 用于驱动 SDA 的寄存器

//     // I2C 时钟分频
//     reg [15:0] clk_div;           // 时钟分频器，用于生成 SCL 时钟
//     reg scl_enable;               // 控制 SCL 的时钟
//     reg [7:0] flags_reg;          // 状态标志寄存器（模拟 STM32 中的标志）

//     // 将 sda 和 scl 信号分别连接到外部信号
//     assign sda = sda_out;
//     assign scl = scl_out;

//     // 定义标志位
//     localparam BUSY = 1;  // 总线忙标志
//     localparam MSL = 2;   // 主模式标志
//     localparam SB = 4;    // 起始条件标志
//     localparam ADDR = 8;  // 地址发送完成标志
//     localparam TXE = 16;  // 数据寄存器空标志
//     localparam TRA = 32;  // 传输状态标志
//     localparam BTF = 64;  // 数据传输完成标志
//     localparam RXNE = 128;// 接收寄存器非空标志

//     // I2C 时钟分频，假设SCL频率为100kHz
//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             clk_div <= 16'd0;
//             scl_enable <= 1'b0;
//         end else begin
//             if (clk_div == 16'd5000) begin
//                 clk_div <= 16'd0;
//                 scl_enable <= 1'b1;
//             end else begin
//                 clk_div <= clk_div + 1'b1;
//                 scl_enable <= 1'b0;
//             end
//         end
//     end

//     // 状态机的状态切换
//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             state <= IDLE;
//         end else if (scl_enable) begin
//             state <= next_state;
//         end
//     end

//     // 根据当前状态计算下一个状态
//     always @(*) begin
//         case (state)
//             IDLE: begin
//                 if (start) begin
//                     next_state = START;
//                 end else begin
//                     next_state = IDLE;
//                 end
//             end

//             START: begin
//                 next_state = ADDR;
//             end

//             ADDR: begin
//                 if (bit_counter == 7) begin
//                     next_state = ADDR_ACK;
//                 end else begin
//                     next_state = ADDR;
//                 end
//             end

//             ADDR_ACK: begin
//                 if (flags_reg[ADDR]) begin
//                     next_state = REG_ADDR;
//                 end else begin
//                     next_state = IDLE; // 错误处理
//                 end
//             end

//             REG_ADDR: begin
//                 if (bit_counter == 7) begin
//                     next_state = REG_ADDR_ACK;
//                 end else begin
//                     next_state = REG_ADDR;
//                 end
//             end

//             REG_ADDR_ACK: begin
//                 if (flags_reg[TXE]) begin
//                     next_state = DATA;
//                 end else begin
//                     next_state = IDLE; // 错误处理
//                 end
//             end

//             DATA: begin
//                 if (bit_counter == 7) begin
//                     next_state = DATA_ACK;
//                 end else begin
//                     next_state = DATA;
//                 end
//             end

//             DATA_ACK: begin
//                 if (flags_reg[BTF]) begin
//                     next_state = STOP;
//                 end else begin
//                     next_state = IDLE; // 错误处理
//                 end
//             end

//             STOP: begin
//                 next_state = DONE;
//             end

//             DONE: begin
//                 next_state = IDLE;
//             end

//             default: begin
//                 next_state = IDLE;
//             end
//         endcase
//     end

//     // 控制输出信号和标志位
//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             sda_out <= 1'b1;
//             scl_out <= 1'b1;
//             flags_reg <= 8'd0;
//             busy <= 1'b0;
//             done <= 1'b0;
//             bit_counter <= 8'd0;
//         end else if (scl_enable) begin
//             case (state)
//                 IDLE: begin
//                     sda_out <= 1'b1;
//                     scl_out <= 1'b1;
//                     busy <= 1'b0;
//                     done <= 1'b0;
//                     flags_reg[BUSY] <= 1'b0;
//                 end

//                 START: begin
//                     sda_out <= 1'b0;  // SDA 拉低，生成起始条件
//                     scl_out <= 1'b1;
//                     busy <= 1'b1;     // 设置忙标志
//                     flags_reg[BUSY] <= 1'b1;   // 总线忙
//                     flags_reg[MSL] <= 1'b1;    // 主模式
//                     flags_reg[SB] <= 1'b1;     // 起始条件
//                 end

//                 ADDR: begin
//                     scl_out <= 1'b0;  // SCL 拉低，准备发送设备地址
//                     sda_out <= dev_addr[7 - bit_counter]; // 发送设备地址
//                     bit_counter <= bit_counter + 1'b1;
//                     flags_reg[TRA] <= 1'b1;    // 传输模式
//                 end

//                 ADDR_ACK: begin
//                     scl_out <= 1'b1;  // SCL 拉高，等待 ACK
//                     if (/* 检测到ACK */) begin
//                         flags_reg[ADDR] <= 1'b1; // 地址传输完成
//                     end
//                 end

//                 REG_ADDR: begin
//                     scl_out <= 1'b0;
//                     sda_out <= reg_addr[7 - bit_counter]; // 发送寄存器地址
//                     bit_counter <= bit_counter + 1'b1;
//                 end

//                 REG_ADDR_ACK: begin
//                     scl_out <= 1'b1;  // SCL 拉高，等待 ACK
//                     if (/* 检测到ACK */) begin
//                         flags_reg[TXE] <= 1'b1; // 数据寄存器为空，准备发送数据
//                     end
//                 end

//                 DATA: begin
//                     scl_out <= 1'b0;
//                     sda_out <= data_in[7 - bit_counter]; // 发送数据
//                     bit_counter <= bit_counter + 1'b1;
//                 end

//                 DATA_ACK: begin
//                     scl_out <= 1'b1;  // SCL 拉高，等待数据传输完成
//                     if (/* 检测到BTF */) begin
//                         flags_reg[BTF] <= 1'b1; // 数据传输完成
//                     end
//                 end

//                 STOP: begin
//                     sda_out <= 1'b0;  // SDA 拉低，准备停止
//                     scl_out <= 1'b1;  // SCL 拉高，生成停止条件
//                     flags_reg[TRA] <= 1'b0;    // 传输结束
//                 end

//                 DONE: begin
//                     sda_out <= 1'b1; // 停止条件，SDA 拉高
//                     scl_out <= 1'b1;
//                     busy <= 1'b0;
//                     done <= 1'b1;
//                     flags_reg <= 8'd0; // 清除所有标志
//                 end
//             endcase
//         end
//     end

//     // 将标志寄存器输出到外部
//     assign flags = flags_reg;

// endmodule
