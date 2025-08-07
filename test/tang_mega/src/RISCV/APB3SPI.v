module Apb3SPIRouter (
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

    output wire SPI1_SCK,
    output wire SPI1_MOSI,
    input  wire SPI1_MISO,
    output wire SPI1_CS,
    output wire SPI1_interrupt,
    output wire SPI2_SCK,
    output wire SPI2_MOSI,
    input  wire SPI2_MISO,
    output wire SPI2_CS,
    output wire SPI2_interrupt
);

    reg  [15:0] Apb3PSEL = 16'h0000;
    // SPI1
    wire [ 3:0] io_apb_PADDR_SPI1 = io_apb_PADDR[5:2];
    wire        io_apb_PSEL_SPI1 = Apb3PSEL[0];
    wire        io_apb_PENABLE_SPI1 = io_apb_PENABLE;
    wire        io_apb_PREADY_SPI1;
    wire        io_apb_PWRITE_SPI1 = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_SPI1 = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_SPI1;
    wire        io_apb_PSLVERROR_SPI1 = 1'b0;
    // SPI2
    wire [ 3:0] io_apb_PADDR_SPI2 = io_apb_PADDR[5:2];
    wire        io_apb_PSEL_SPI2 = Apb3PSEL[1];
    wire        io_apb_PENABLE_SPI2 = io_apb_PENABLE;
    wire        io_apb_PREADY_SPI2;
    wire        io_apb_PWRITE_SPI2 = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_SPI2 = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_SPI2;
    wire        io_apb_PSLVERROR_SPI2 = 1'b0;

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
                    _zz_io_apb_PREADY = io_apb_PREADY_SPI1;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_SPI1;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_SPI1;
                end
                16'h0002: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_SPI2;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_SPI2;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_SPI2;
                end
                default: ;
            endcase
    end

    always @(*) begin
        if (io_apb_PRESET) begin
            Apb3PSEL = 16'h0000;
        end else begin
            Apb3PSEL[0] = ((io_apb_PADDR[15:12] == 4'd0) && io_apb_PSEL[0]);  // SPI1
            Apb3PSEL[1] = ((io_apb_PADDR[15:12] == 4'd1) && io_apb_PSEL[0]);  // SPI2
        end
    end

    Apb3SPI Apb3SPI1 (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_SPI1),    // i
        .io_apb_PSEL   (io_apb_PSEL_SPI1),     // i
        .io_apb_PENABLE(io_apb_PENABLE_SPI1),  // i
        .io_apb_PREADY (io_apb_PREADY_SPI1),   // o
        .io_apb_PWRITE (io_apb_PWRITE_SPI1),   // i
        .io_apb_PWDATA (io_apb_PWDATA_SPI1),   // i
        .io_apb_PRDATA (io_apb_PRDATA_SPI1),   // o
        .SPI_SCK       (SPI1_SCK),             // o
        .SPI_MOSI      (SPI1_MOSI),            // o
        .SPI_MISO      (SPI1_MISO),            // i
        .SPI_CS        (SPI1_CS),              // o
        .interrupt     (SPI1_interrupt)        // o
    );

    Apb3SPI Apb3SPI2 (
        .io_apb_PCLK   (io_apb_PCLK),          // i
        .io_apb_PRESET (io_apb_PRESET),        // i
        .io_apb_PADDR  (io_apb_PADDR_SPI2),    // i
        .io_apb_PSEL   (io_apb_PSEL_SPI2),     // i
        .io_apb_PENABLE(io_apb_PENABLE_SPI2),  // i
        .io_apb_PREADY (io_apb_PREADY_SPI2),   // o
        .io_apb_PWRITE (io_apb_PWRITE_SPI2),   // i
        .io_apb_PWDATA (io_apb_PWDATA_SPI2),   // i
        .io_apb_PRDATA (io_apb_PRDATA_SPI2),   // o
        .SPI_SCK       (SPI2_SCK),             // o
        .SPI_MOSI      (SPI2_MOSI),            // o
        .SPI_MISO      (SPI2_MISO),            // i
        .SPI_CS        (SPI2_CS),              // o
        .interrupt     (SPI2_interrupt)        // o
    );

endmodule


module Apb3SPI (
    input  wire        io_apb_PCLK,     // APB 时钟
    input  wire        io_apb_PRESET,   // APB 复位信号，高电平复位
    input  wire [ 3:0] io_apb_PADDR,    // 地址总线
    input  wire        io_apb_PSEL,     // 选择信号
    input  wire        io_apb_PENABLE,  // 使能信号
    input  wire        io_apb_PWRITE,   // 写信号
    input  wire [31:0] io_apb_PWDATA,   // 写数据总线
    output wire        io_apb_PREADY,   // APB 准备信号
    output reg  [31:0] io_apb_PRDATA,   // 读数据总线

    // SPI 接口信号
    output wire SPI_SCK,   // SPI 时钟
    output wire SPI_MOSI,  // SPI 主输出从输入
    input  wire SPI_MISO,  // SPI 主输入从输出
    output wire SPI_CS,    // SPI 片选信号
    output wire interrupt  // SPI 中断输出
);

    // SPI 寄存器定义
    reg  [15:0] CR1;                // 控制寄存器1
    reg  [15:0] CR2;                // 控制寄存器2
    wire [15:0] SR;                 // 状态寄存器
    reg  [15:0] DR;                 // 数据寄存器
    reg  [15:0] CRCPR;              // CRC 寄存器
    wire [15:0] RXCRCR = 16'h0000;  // 接收 CRC 寄存器
    wire [15:0] TXCRCR = 16'h0000;  // 发送 CRC 寄存器
    reg  [15:0] I2SCFGR;            // I2S 配置寄存器
    reg  [15:0] I2SPR;              // I2S 预分频寄存器

    // SPI Config 接口定义
    // CR1
    wire        CPHA = CR1[0];  // 时钟相位
    wire        CPOL = CR1[1];  // 时钟极性
    wire        MSTR = CR1[2];  // 主设备选择
    wire [ 2:0] BR = CR1[5:3];  // 波特率控制
    wire        SPE = CR1[6];   // SPI使能
    wire        LSBFIRST = CR1[7];  // 帧格式  0：先发送MSB；1：先发送LSB。
    wire        SSI = CR1[8];   // 内部从设备选择
    wire        SSM = CR1[9];   // 软件从设备管理
    wire        RXONLY = CR1[10];  // 只接收
    wire        DFF = CR1[11];  // 数据帧格式  0：8位数据帧格式； 1：16位数据帧格式。
    wire        CRCNEXT = CR1[12];  // 下一个发送CRC
    wire        CRCEN = CR1[13];  // 硬件CRC校验使能
    wire        BIDIOE = CR1[14];  // 双向模式下的输出使能
    wire        BIDIMODE = CR1[14];  // 双向数据模式使能
    // CR2
    wire        RXDMAEN = CR2[0];  // 接收缓冲区DMA使能
    wire        TXDMAEN = CR2[1];  // 发送缓冲区DMA使能
    wire        SSOE = CR2[2];   // SS输出使能
    wire        ERRIE = CR2[5];  // 错误中断使能
    wire        RXNEIE = CR2[6];  // 接收缓冲区非空中断使能
    wire        TXEIE = CR2[7];   // 发送缓冲区空中断使能
    // SR
    wire        RXNE = 1'b0;    // 接收缓冲非空
    wire        TXE = 1'b1;     // 发送缓冲为空
    // wire        TXE;     // 发送缓冲为空
    wire        CHSIDE = 1'b0;  // 声道
    wire        UDR = 1'b0;     // 下溢标志位
    wire        CRCERR = 1'b0;  // CRC错误标志
    wire        MODF = 1'b0;    // 模式错误
    wire        OVR = 1'b0;     // 溢出标志
    wire        BSY = 1'b0;     // 忙标志
    assign      SR = {8'b0, BSY, OVR, MODF, CRCERR, UDR, CHSIDE, TXE, RXNE};  // 状态寄存器

    // APB 写寄存器逻辑
    assign io_apb_PREADY = 1'b1;  // APB 总线始终准备好
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            CR1     <= 16'h0000;
            CR2     <= 16'h0000;
            DR      <= 16'h0000;
            CRCPR   <= 16'h0000;
            I2SCFGR <= 16'h0000;
            I2SPR   <= 16'h0000;
        end else begin
            if (io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    4'h0: CR1 <= io_apb_PWDATA[15:0];  // 写 CR1
                    4'h1: CR2 <= io_apb_PWDATA[15:0];  // 写 CR2
                    4'h3: DR <= io_apb_PWDATA[15:0];  // 写 DR
                    4'h4: CRCPR <= io_apb_PWDATA[15:0];  // 写 CRCPR
                    4'h7: I2SCFGR <= io_apb_PWDATA[15:0];  // 写 I2SCFGR
                    4'h8: I2SPR <= io_apb_PWDATA[15:0];  // 写 I2SPR
                    default: ;  // 其他寄存器不处理
                endcase
            end
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
                    4'h2: io_apb_PRDATA <= {16'b0, SR};
                    4'h3: io_apb_PRDATA <= {16'b0, DR};
                    4'h4: io_apb_PRDATA <= {16'b0, CRCPR};
                    4'h5: io_apb_PRDATA <= {16'b0, RXCRCR};
                    4'h6: io_apb_PRDATA <= {16'b0, TXCRCR};
                    4'h7: io_apb_PRDATA <= {16'b0, I2SCFGR};
                    4'h8: io_apb_PRDATA <= {16'b0, I2SPR};
                    default: io_apb_PRDATA = 32'h00000000;  // 默认返回0
                endcase
            end
        end
    end

    // 发送 SPI 接口定义
    reg TX_Vaild = 1'b0;
    always @(posedge io_apb_PCLK)
        TX_Vaild <= io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE && io_apb_PADDR == 4'h3;

    // SPI 逻辑
    SPICtrl SPICtrl (
        .clk       (io_apb_PCLK),
        .rst       (io_apb_PRESET),
        .CPOL      (CPOL),
        .CPHA      (CPHA),
        .BR        (BR),
        .DFF       (DFF),
        .LSBFIRST  (LSBFIRST),

        .i_TX_Byte (DR),
        .i_TX_Vaild(TX_Vaild),
        .o_TX_Ready(),
        .o_RX_Vaild(),
        .o_RX_Byte (),

        .o_SPI_SCK (SPI_SCK),
        .i_SPI_MISO(SPI_MISO),
        .o_SPI_MOSI(SPI_MOSI),
        .o_SPI_CS  (SPI_CS)
    );

endmodule


module SPICtrl (
    // Control / Data Signals
    input clk,  // FPGA Clock
    input rst,  // FPGA Reset

    // SPI Config Signals
    input       CPOL,     // Clock Polarity
    input       CPHA,     // Clock Phase
    input [2:0] BR,       // Baud Rate
    input       DFF,      // Data Frame Format
    input       LSBFIRST, // Bit First Config

    // TX (MOSI) Signals
    input      [15:0] i_TX_Byte,   // Byte to transmit on MOSI
    input             i_TX_Vaild,  // Data Valid Pulse with i_TX_Byte
    output reg        o_TX_Ready,  // Transmit Ready for next byte

    // RX (MISO) Signals
    output reg        o_RX_Vaild,  // Data Valid pulse (1 clock cycle)
    output reg [15:0] o_RX_Byte,   // Byte received on MISO

    // SPI Interface
    output reg o_SPI_SCK,
    input      i_SPI_MISO,
    output reg o_SPI_MOSI,
    output reg o_SPI_CS = 1'b0
);

    // CPOL: Clock Polarity
    // CPOL=0 means clock idles at 0, leading edge is rising edge.
    // CPOL=1 means clock idles at 1, leading edge is falling edge.
    // CPHA: Clock Phase
    // CPHA=0 means the "out" side changes the data on trailing edge of clock
    //              the "in" side captures data on leading edge of clock
    // CPHA=1 means the "out" side changes the data on leading edge of clock
    //              the "in" side captures data on the trailing edge of clock

    // SPI Interface (All Runs at SPI Clock Domain)
    reg [7:0] r_SPI_clk_Count, HALF_BIT;  // 000:2 001:4 010:8 011:16 100:32 101:64 110:128 111:256
    reg        r_SPI_clk;
    reg [ 4:0] r_SPI_clk_Edges;
    reg        r_Leading_Edge;
    reg        r_Trailing_Edge;
    reg        r_TX_DV;
    reg [15:0] r_TX_Byte;
    reg [ 3:0] r_RX_Bit_Count;
    reg [ 3:0] r_TX_Bit_Count;

    // HALF_BIT: Number of clock cycles for half bit time.
    always @* begin
        case (BR)
            3'b000: HALF_BIT = 8'b00000001;
            3'b001: HALF_BIT = 8'b00000010;
            3'b010: HALF_BIT = 8'b00000100;
            3'b011: HALF_BIT = 8'b00001000;
            3'b100: HALF_BIT = 8'b00010000;
            3'b101: HALF_BIT = 8'b00100000;
            3'b110: HALF_BIT = 8'b01000000;
            3'b111: HALF_BIT = 8'b10000000;
        endcase
    end

    // Purpose: Generate SPI Clock correct number of times when DV pulse comes
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_TX_Ready      <= 1'b0;
            r_SPI_clk_Edges <= 0;
            r_Leading_Edge  <= 1'b0;
            r_Trailing_Edge <= 1'b0;
            r_SPI_clk       <= CPOL;  // assign default state to idle state
            r_SPI_clk_Count <= 0;
        end else begin
            // Default assignments
            r_Leading_Edge  <= 1'b0;
            r_Trailing_Edge <= 1'b0;
            if (i_TX_Vaild) begin
                o_TX_Ready      <= 1'b0;
                r_SPI_clk_Edges <= 16;  // Total # edges in one byte ALWAYS 16
            end else if (r_SPI_clk_Edges > 0) begin
                o_TX_Ready <= 1'b0;
                if (r_SPI_clk_Count == HALF_BIT * 2 - 1) begin
                    r_SPI_clk_Edges <= r_SPI_clk_Edges - 1'b1;
                    r_Trailing_Edge <= 1'b1;
                    r_SPI_clk_Count <= 0;
                    r_SPI_clk       <= ~r_SPI_clk;
                end else if (r_SPI_clk_Count == HALF_BIT - 1) begin
                    r_SPI_clk_Edges <= r_SPI_clk_Edges - 1'b1;
                    r_Leading_Edge  <= 1'b1;
                    r_SPI_clk_Count <= r_SPI_clk_Count + 1'b1;
                    r_SPI_clk       <= ~r_SPI_clk;
                end else begin
                    r_SPI_clk_Count <= r_SPI_clk_Count + 1'b1;
                end
            end else o_TX_Ready <= 1'b1;
        end
    end

    // Purpose: Register i_TX_Byte when Data Valid is pulsed.
    // Keeps local storage of byte in case higher level module changes the data
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_TX_Byte <= 16'h0000;
            r_TX_DV   <= 1'b0;
        end else begin
            r_TX_DV <= i_TX_Vaild;  // 1 clock cycle delay
            if (i_TX_Vaild) r_TX_Byte <= i_TX_Byte;
        end  // else: !if(~rst_n)
    end  // always @ (posedge clk or negedge rst_n)

    // Purpose: Generate MOSI data
    // Works with both CPHA=0 and CPHA=1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_SPI_MOSI <= 1'b0;
            if (LSBFIRST) r_TX_Bit_Count <= 4'b0000;  // send LSB first
            else r_TX_Bit_Count <= DFF ? 4'b1111 : 4'b0111;  // send MSB first  // 16位 : 8位
        end else begin
            // If ready is high, reset bit counts to default
            if (o_TX_Ready) begin
                if (LSBFIRST) r_TX_Bit_Count <= 4'b0000;  // send LSB first
                else r_TX_Bit_Count <= DFF ? 4'b1111 : 4'b0111;  // send MSB first
            end else if (r_TX_DV & ~CPHA) begin
                o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
                r_TX_Bit_Count <= LSBFIRST ? r_TX_Bit_Count + 1'b1 : r_TX_Bit_Count - 1'b1;
            end else if ((r_Leading_Edge & CPHA) | (r_Trailing_Edge & ~CPHA)) begin
                r_TX_Bit_Count <= LSBFIRST ? r_TX_Bit_Count + 1'b1 : r_TX_Bit_Count - 1'b1;
                o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
            end
        end
    end

    // Purpose: Read in MISO data.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_RX_Byte  <= 8'h00;
            o_RX_Vaild <= 1'b0;
            if (LSBFIRST) r_RX_Bit_Count <= 4'b0000;  // recv LSB first
            else r_RX_Bit_Count <= DFF ? 4'b1111 : 4'b0111;  // recv MSB first  // 16位 : 8位
        end else begin
            // Default Assignments
            o_RX_Vaild <= 1'b0;
            if (o_TX_Ready) begin  // Check if ready is high, if so reset bit count to default
                if (LSBFIRST) r_RX_Bit_Count <= 4'b0000;  // recv LSB first
                else r_RX_Bit_Count <= DFF ? 4'b1111 : 4'b0111;  // recv MSB first  // 16位 : 8位
            end else if ((r_Leading_Edge & ~CPHA) | (r_Trailing_Edge & CPHA)) begin
                o_RX_Byte[r_RX_Bit_Count] <= i_SPI_MISO;  // Sample data
                r_RX_Bit_Count <= LSBFIRST ? r_RX_Bit_Count + 1'b1 : r_RX_Bit_Count - 1'b1;
                o_RX_Vaild <= LSBFIRST ? (DFF ? 4'b1111 : 4'b0111) : 4'b0000;  // Byte done, pulse Data Valid
            end
        end
    end

    // Purpose: Add clock delay to signals for alignment.
    always @(posedge clk or posedge rst) begin
        if (rst) o_SPI_SCK <= CPOL;
        else o_SPI_SCK <= r_SPI_clk;
    end

endmodule  // SPI_Master
