module Apb3USARTRouter (
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

    input  wire USART1_RX,
    output wire USART1_TX,
    output wire USART1_interrupt,
    input  wire USART2_RX,
    output wire USART2_TX,
    output wire USART2_interrupt
);

    reg  [15:0] Apb3PSEL;
    // UART1
    wire [ 2:0] io_apb_PADDR_GPIOA = io_apb_PADDR[4:2];
    wire        io_apb_PSEL_GPIOA = Apb3PSEL[0];
    wire        io_apb_PENABLE_GPIOA = io_apb_PENABLE;
    wire        io_apb_PREADY_GPIOA;
    wire        io_apb_PWRITE_GPIOA = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_GPIOA = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_GPIOA;
    wire        io_apb_PSLVERROR_GPIOA = 1'b0;
    // UART2
    wire [ 2:0] io_apb_PADDR_GPIOB = io_apb_PADDR[4:2];
    wire        io_apb_PSEL_GPIOB = Apb3PSEL[1];
    wire        io_apb_PENABLE_GPIOB = io_apb_PENABLE;
    wire        io_apb_PREADY_GPIOB;
    wire        io_apb_PWRITE_GPIOB = io_apb_PWRITE;
    wire [31:0] io_apb_PWDATA_GPIOB = io_apb_PWDATA;
    wire [31:0] io_apb_PRDATA_GPIOB;
    wire        io_apb_PSLVERROR_GPIOB = 1'b0;

    reg [15:0] selIndex;
    reg _zz_io_apb_PREADY;
    reg [31:0] _zz_io_apb_PRDATA;
    reg _zz_io_apb_PSLVERROR;
    assign io_apb_PREADY = _zz_io_apb_PREADY;
    assign io_apb_PRDATA = _zz_io_apb_PRDATA;
    assign io_apb_PSLVERROR = _zz_io_apb_PSLVERROR;
    always @(posedge io_apb_PCLK) selIndex <= Apb3PSEL;
    always @(*) begin
        if (io_apb_PRESET) begin
            _zz_io_apb_PREADY <= 1'b1;
            _zz_io_apb_PRDATA <= 32'h0;
            _zz_io_apb_PSLVERROR <= 1'b0;
        end else
            case (selIndex)
                16'h0001: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_GPIOA;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_GPIOA;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_GPIOA;
                end
                16'h0002: begin
                    _zz_io_apb_PREADY = io_apb_PREADY_GPIOB;
                    _zz_io_apb_PRDATA = io_apb_PRDATA_GPIOB;
                    _zz_io_apb_PSLVERROR = io_apb_PSLVERROR_GPIOB;
                end
                default: ;
            endcase
    end

    always @(*) begin
        if (io_apb_PRESET) begin
            Apb3PSEL <= 16'h0000;
        end else begin
            Apb3PSEL[0] = ((io_apb_PADDR[15:12] == 4'd0) && io_apb_PSEL[0]);  // GPIOA
            Apb3PSEL[1] = ((io_apb_PADDR[15:12] == 4'd1) && io_apb_PSEL[0]);  // GPIOB
        end
    end

    Apb3USART Apb3USART1 (
        .io_apb_PCLK   (io_apb_PCLK),           // i
        .io_apb_PRESET (io_apb_PRESET),         // i
        .io_apb_PADDR  (io_apb_PADDR_GPIOA),    // i
        .io_apb_PSEL   (io_apb_PSEL_GPIOA),     // i
        .io_apb_PENABLE(io_apb_PENABLE_GPIOA),  // i
        .io_apb_PREADY (io_apb_PREADY_GPIOA),   // o
        .io_apb_PWRITE (io_apb_PWRITE_GPIOA),   // i
        .io_apb_PWDATA (io_apb_PWDATA_GPIOA),   // i
        .io_apb_PRDATA (io_apb_PRDATA_GPIOA),   // o
        .USART_RX      (USART1_RX),             // i
        .USART_TX      (USART1_TX),             // o
        .interrupt     (USART1_interrupt)       // o
    );

    Apb3USART Apb3USART2 (
        .io_apb_PCLK   (io_apb_PCLK),           // i
        .io_apb_PRESET (io_apb_PRESET),         // i
        .io_apb_PADDR  (io_apb_PADDR_GPIOB),    // i
        .io_apb_PSEL   (io_apb_PSEL_GPIOB),     // i
        .io_apb_PENABLE(io_apb_PENABLE_GPIOB),  // i
        .io_apb_PREADY (io_apb_PREADY_GPIOB),   // o
        .io_apb_PWRITE (io_apb_PWRITE_GPIOB),   // i
        .io_apb_PWDATA (io_apb_PWDATA_GPIOB),   // i
        .io_apb_PRDATA (io_apb_PRDATA_GPIOB),   // o
        .USART_RX      (USART2_RX),             // i
        .USART_TX      (USART2_TX),             // o
        .interrupt     (USART2_interrupt)       // o
    );

endmodule


module Apb3USART (
    input  wire        io_apb_PCLK,     // APB 时钟
    input  wire        io_apb_PRESET,   // APB 复位信号，高电平复位
    input  wire [ 2:0] io_apb_PADDR,    // 地址总线
    input  wire        io_apb_PSEL,     // 选择信号
    input  wire        io_apb_PENABLE,  // 使能信号
    input  wire        io_apb_PWRITE,   // 写信号
    input  wire [31:0] io_apb_PWDATA,   // 写数据总线
    output wire        io_apb_PREADY,   // APB 准备信号
    output reg  [31:0] io_apb_PRDATA,   // 读数据总线

    // USART 接口信号
    input  wire USART_RX,  // USART 接收数据输入
    output wire USART_TX,  // USART 发送数据输出
    output wire interrupt  // USART 中断输出
);

    // USART 寄存器定义
    wire [15:0] SR;  // 状态寄存器
    reg  [15:0] DR;  // 数据寄存器
    reg  [15:0] BRR;  // 波特率寄存器
    reg  [15:0] CR1;  // 控制寄存器1
    reg  [15:0] CR2;  // 控制寄存器2
    reg  [15:0] CR3;  // 控制寄存器3  暂时不支持流控制和其他高级功能
    reg  [15:0] GTPR;  // 保护时间和预分频寄存器  暂时不支持

    // USART StreamFifo 接口定义
    wire       io_push_ready_TX;
    reg        io_push_valid_TX;
    reg  [7:0] io_push_payload_TX;
    wire       io_pop_ready_TX;
    wire       io_pop_valid_TX;
    wire [7:0] io_pop_payload_TX;
    wire [4:0] io_availability_TX;
    wire [4:0] io_occupancy_TX;
    wire       io_push_ready_RX;
    wire       io_push_valid_RX;
    wire [7:0] io_push_payload_RX;
    reg        io_pop_ready_RX;
    wire       io_pop_valid_RX;
    wire [7:0] io_pop_payload_RX;
    wire [4:0] io_availability_RX;
    wire [4:0] io_occupancy_RX;

    // USART Config 接口定义
    // SR
    wire        PE   = 1'b0;  // 校验错误
    wire        FE   = 1'b0;  // 帧错误
    wire        NF   = 1'b0;  // 噪声错误标志
    wire        ORE  = 1'b0;  // 过载错误
    wire        IDLE = 1'b0;  // 监测到总线空闲
    wire        RXNE = io_occupancy_RX ? 1'b1 : 1'b0;  // 读数据寄存器非空
    wire        TC   = io_availability_TX ? 1'b1 : 1'b0;  // (发送完成) 改为写数据寄存器有空闲
    wire        TXE  = 1'b0;  // 发送数据寄存器空
    wire        LBD  = 1'b0;  // LIN断开检测标志
    wire        CTS  = 1'b0;  // CTS 标志
    assign      SR   = {6'b0, CTS, LBD, TXE, TC, RXNE, IDLE, ORE, NF, FE, PE};
    // CR1
    wire        RE     = CR1[2];
    wire        TE     = CR1[3];
    wire        IDLEIE = CR1[4];
    wire        RXNEIE = CR1[5];
    wire        TCIE   = CR1[6];
    wire        TXEIE  = CR1[7];
    wire        PEIE   = CR1[8];
    wire        PS     = CR1[9];
    wire        PCE    = CR1[10];
    wire [ 2:0] M      = CR1[12] ? 3'b000 : 3'b111;
    wire        UE     = CR1[13];
    // CR2
    wire [ 1:0] STOP = CR2[13:12];
    // CR3
    wire        DMAT = CR3[7];
    wire        DMAR = CR3[6];
    // BRR
    wire [11:0] DIV_Mantissa = BRR[15:4];
    wire [ 3:0] DIV_Fraction = BRR[ 3:0];

    // USART 状态寄存器
    wire        io_readError;
    wire        io_writeBreak = 1'b0;
    wire        io_readBreak;

    // USART 中断输出
    assign interrupt = (PEIE & PE) | (TCIE & TC) | (RXNEIE & RXNE) | (TXEIE & TXE) | (IDLEIE & IDLE);

    // APB 写寄存器逻辑
    assign io_apb_PREADY = 1'b1;  // APB 准备信号始终为高，表示设备始终准备好
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            // SR   <= 16'h0000;
            DR   <= 16'h0000;
            BRR  <= 16'h0000;
            CR1  <= 16'h0000;
            CR2  <= 16'h0000;
            CR3  <= 16'h0000;
            GTPR <= 16'h0000;
        end else begin
            if (io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    // 3'b000:  SR <= io_apb_PWDATA[15:0];  // 写 SR  // 暂时不可写入
                    3'b001:  DR <= io_apb_PWDATA[15:0];  // 写 DR
                    3'b010:  BRR <= io_apb_PWDATA[15:0];  // 写 BRR
                    3'b011:  CR1 <= io_apb_PWDATA[15:0];  // 写 CR1
                    3'b100:  CR2 <= io_apb_PWDATA[15:0];  // 写 CR2
                    3'b101:  CR3 <= io_apb_PWDATA[15:0];  // 写 CR3
                    3'b110:  GTPR <= io_apb_PWDATA[15:0];  // 写 GTPR
                    default: ;  // 其他寄存器不处理
                endcase
            end
        end
    end
    // APB 读寄存器逻辑
    always @(*) begin
        if (io_apb_PRESET) begin
            io_apb_PRDATA = 32'h00000000;  // 复位时返回0
            io_pop_ready_RX = 1'b0;
        end
        else begin
            io_pop_ready_RX = 1'b0;
            if (io_apb_PSEL && io_apb_PENABLE && ~io_apb_PWRITE) begin
                case (io_apb_PADDR)
                    3'b000:  io_apb_PRDATA = {16'b0, SR};  // 读 SR
                    3'b001:  begin 
                        io_apb_PRDATA = io_pop_valid_RX ? {16'b0, io_pop_payload_RX} : 32'h00000000;  // 读
                        io_pop_ready_RX = 1'b1;
                    end
                    3'b010:  io_apb_PRDATA = {16'b0, BRR};  // 读 BRR
                    3'b011:  io_apb_PRDATA = {16'b0, CR1};  // 读 CR1
                    3'b100:  io_apb_PRDATA = {16'b0, CR2};  // 读 CR2
                    3'b101:  io_apb_PRDATA = {16'b0, CR3};  // 读 CR3
                    3'b110:  io_apb_PRDATA = {16'b0, GTPR};  // 读 GTPR
                    default: io_apb_PRDATA = 32'h00000000;  // 默认返回0
                endcase
            end
        end
    end


    // StreamFifo 接口
    reg TXFifo_push = 1'b0;
    always @(posedge io_apb_PCLK)
        TXFifo_push <= io_apb_PSEL && io_apb_PENABLE && io_apb_PWRITE && io_apb_PADDR == 3'b001;
    always @(posedge io_apb_PCLK or posedge io_apb_PRESET) begin
        if (io_apb_PRESET) begin
            io_push_valid_TX   <= 1'b0;
            io_push_payload_TX <= 8'h00;
        end else begin
            io_push_valid_TX   <= 1'b0;
            io_push_payload_TX <= 8'h00;
            if (TXFifo_push) begin
                io_push_valid_TX   <= 1'b1;
                io_push_payload_TX <= DR[7:0];
            end
        end
    end

    // 串口收发逻辑
    StreamFifo_UART StreamFifo_UART_TX (
        .io_push_ready        (io_push_ready_TX),           // o
        .io_push_valid        (io_push_valid_TX),           // i
        .io_push_payload      (io_push_payload_TX),         // i
        .io_pop_ready         (io_pop_ready_TX),            // i
        .io_pop_valid         (io_pop_valid_TX),            // o
        .io_pop_payload       (io_pop_payload_TX),          // o
        .io_flush             (1'b0),                       // i
        .io_occupancy         (io_occupancy_TX),            // o
        .io_availability      (io_availability_TX),         // o
        .io_mainClk           (io_apb_PCLK),                // i
        .resetCtrl_systemReset(io_apb_PRESET | ~(RE & UE))  // i
    );
    UartCtrl UartCtrl (
        .io_config_frame_dataLength(M),                     // i
        .io_config_frame_stop      (STOP[1]),               // i
        .io_config_frame_parity    ({PS, PCE}),             // i
        .io_config_clockDivider    ({8'b0, DIV_Mantissa}),  // i
        .io_write_ready            (io_pop_ready_TX),       // o
        .io_write_valid            (io_pop_valid_TX),       // i
        .io_write_payload          (io_pop_payload_TX),     // i
        .io_read_ready             (io_push_ready_RX),      // i
        .io_read_valid             (io_push_valid_RX),      // o
        .io_read_payload           (io_push_payload_RX),    // o
        .io_uart_txd               (USART_TX),              // o
        .io_uart_rxd               (USART_RX),              // i
        .io_readError              (io_readError),          // o
        .io_writeBreak             (io_writeBreak),         // i
        .io_readBreak              (io_readBreak),          // o
        .io_uart_rxen              (RE & UE),               // i
        .io_uart_txen              (TE & UE),               // i
        .io_mainClk                (io_apb_PCLK),           // i
        .resetCtrl_systemReset     (io_apb_PRESET)          // i
    );
    StreamFifo_UART StreamFifo_UART_RX (
        .io_push_ready        (io_push_ready_RX),           // o
        .io_push_valid        (io_push_valid_RX),           // i
        .io_push_payload      (io_push_payload_RX),         // i
        .io_pop_ready         (io_pop_ready_RX),            // i
        .io_pop_valid         (io_pop_valid_RX),            // o
        .io_pop_payload       (io_pop_payload_RX),          // o
        .io_flush             (1'b0),                       // i
        .io_occupancy         (io_occupancy_RX),            // o
        .io_availability      (io_availability_RX),         // o
        .io_mainClk           (io_apb_PCLK),                // i
        .resetCtrl_systemReset(io_apb_PRESET | ~(RE & UE))  // i
    );

endmodule


module StreamFifo_UART (
    input  wire       io_push_valid,
    output wire       io_push_ready,
    input  wire [7:0] io_push_payload,
    output wire       io_pop_valid,
    input  wire       io_pop_ready,
    output wire [7:0] io_pop_payload,
    input  wire       io_flush,
    output wire [4:0] io_occupancy,
    output wire [4:0] io_availability,
    input  wire       io_mainClk,
    input  wire       resetCtrl_systemReset
);

    reg  [7:0] logic_ram_spinal_port1;
    reg        _zz_1;
    wire       logic_ptr_doPush;
    wire       logic_ptr_doPop;
    wire       logic_ptr_full;
    wire       logic_ptr_empty;
    reg  [4:0] logic_ptr_push;
    reg  [4:0] logic_ptr_pop;
    wire [4:0] logic_ptr_occupancy;
    wire [4:0] logic_ptr_popOnIo;
    wire       when_Stream_l1248;
    reg        logic_ptr_wentUp;
    wire       io_push_fire;
    wire       logic_push_onRam_write_valid;
    wire [3:0] logic_push_onRam_write_payload_address;
    wire [7:0] logic_push_onRam_write_payload_data;
    wire       logic_pop_addressGen_valid;
    reg        logic_pop_addressGen_ready;
    wire [3:0] logic_pop_addressGen_payload;
    wire       logic_pop_addressGen_fire;
    wire       logic_pop_sync_readArbitation_valid;
    wire       logic_pop_sync_readArbitation_ready;
    wire [3:0] logic_pop_sync_readArbitation_payload;
    reg        logic_pop_addressGen_rValid;
    reg  [3:0] logic_pop_addressGen_rData;
    wire       when_Stream_l375;
    wire       logic_pop_sync_readPort_cmd_valid;
    wire [3:0] logic_pop_sync_readPort_cmd_payload;
    wire [7:0] logic_pop_sync_readPort_rsp;
    wire       logic_pop_sync_readArbitation_translated_valid;
    wire       logic_pop_sync_readArbitation_translated_ready;
    wire [7:0] logic_pop_sync_readArbitation_translated_payload;
    wire       logic_pop_sync_readArbitation_fire;
    reg  [4:0] logic_pop_sync_popReg;
    reg  [7:0] logic_ram                                        [0:15];

    always @(posedge io_mainClk) begin
        if (_zz_1) begin
            logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
        end
    end

    always @(posedge io_mainClk) begin
        if (logic_pop_sync_readPort_cmd_valid) begin
            logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
        end
    end

    always @(*) begin
        _zz_1 = 1'b0;
        if (logic_push_onRam_write_valid) begin
            _zz_1 = 1'b1;
        end
    end

    assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
    assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 5'h10) == 5'h0);
    assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
    assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
    assign io_push_ready = (!logic_ptr_full);
    assign io_push_fire = (io_push_valid && io_push_ready);
    assign logic_ptr_doPush = io_push_fire;
    assign logic_push_onRam_write_valid = io_push_fire;
    assign logic_push_onRam_write_payload_address = logic_ptr_push[3:0];
    assign logic_push_onRam_write_payload_data = io_push_payload;
    assign logic_pop_addressGen_valid = (!logic_ptr_empty);
    assign logic_pop_addressGen_payload = logic_ptr_pop[3:0];
    assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
    assign logic_ptr_doPop = logic_pop_addressGen_fire;
    always @(*) begin
        logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
        if (when_Stream_l375) begin
            logic_pop_addressGen_ready = 1'b1;
        end
    end

    assign when_Stream_l375 = (!logic_pop_sync_readArbitation_valid);
    assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
    assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
    assign logic_pop_sync_readPort_rsp = logic_ram_spinal_port1;
    assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
    assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
    assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
    assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
    assign logic_pop_sync_readArbitation_translated_payload = logic_pop_sync_readPort_rsp;
    assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
    assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
    assign io_pop_payload = logic_pop_sync_readArbitation_translated_payload;
    assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
    assign logic_ptr_popOnIo = logic_pop_sync_popReg;
    assign io_occupancy = logic_ptr_occupancy;
    assign io_availability = (5'h10 - logic_ptr_occupancy);
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            logic_ptr_push <= 5'h0;
            logic_ptr_pop <= 5'h0;
            logic_ptr_wentUp <= 1'b0;
            logic_pop_addressGen_rValid <= 1'b0;
            logic_pop_sync_popReg <= 5'h0;
        end else begin
            if (when_Stream_l1248) begin
                logic_ptr_wentUp <= logic_ptr_doPush;
            end
            if (io_flush) begin
                logic_ptr_wentUp <= 1'b0;
            end
            if (logic_ptr_doPush) begin
                logic_ptr_push <= (logic_ptr_push + 5'h01);
            end
            if (logic_ptr_doPop) begin
                logic_ptr_pop <= (logic_ptr_pop + 5'h01);
            end
            if (io_flush) begin
                logic_ptr_push <= 5'h0;
                logic_ptr_pop  <= 5'h0;
            end
            if (logic_pop_addressGen_ready) begin
                logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
            end
            if (io_flush) begin
                logic_pop_addressGen_rValid <= 1'b0;
            end
            if (logic_pop_sync_readArbitation_fire) begin
                logic_pop_sync_popReg <= logic_ptr_pop;
            end
            if (io_flush) begin
                logic_pop_sync_popReg <= 5'h0;
            end
        end
    end

    always @(posedge io_mainClk) begin
        if (logic_pop_addressGen_ready) begin
            logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
        end
    end

endmodule


module UartCtrl (
    input  wire [ 2:0] io_config_frame_dataLength,
    input  wire [ 0:0] io_config_frame_stop,
    input  wire [ 1:0] io_config_frame_parity,
    input  wire [19:0] io_config_clockDivider,
    input  wire        io_write_valid,
    output reg         io_write_ready,
    input  wire [ 7:0] io_write_payload,
    output wire        io_read_valid,
    input  wire        io_read_ready,
    output wire [ 7:0] io_read_payload,
    output wire        io_uart_txd,
    input  wire        io_uart_rxd,
    output wire        io_readError,
    input  wire        io_writeBreak,
    output wire        io_readBreak,
    input  wire        io_uart_rxen,
    input  wire        io_uart_txen,
    input  wire        io_mainClk,
    input  wire        resetCtrl_systemReset
);
    localparam UartStopType_ONE = 1'd0;
    localparam UartStopType_TWO = 1'd1;
    localparam UartParityType_NONE = 2'b00;
    localparam UartParityType_EVEN = 2'b10;
    localparam UartParityType_ODD = 2'b11;

    wire        tx_io_write_ready;
    wire        tx_io_txd;
    wire        rx_io_read_valid;
    wire [ 7:0] rx_io_read_payload;
    wire        rx_io_rts;
    wire        rx_io_error;
    wire        rx_io_break;
    reg  [19:0] clockDivider_counter;
    wire        clockDivider_tick;
    reg         clockDivider_tickReg;
    reg         io_write_thrown_valid;
    wire        io_write_thrown_ready;
    wire [ 7:0] io_write_thrown_payload;
`ifndef SYNTHESIS
    reg [23:0] io_config_frame_stop_string;
    reg [31:0] io_config_frame_parity_string;
`endif


    UartCtrlTx tx (
        .io_configFrame_dataLength(io_config_frame_dataLength[2:0]),       //i
        .io_configFrame_stop      (io_config_frame_stop),                  //i
        .io_configFrame_parity    (io_config_frame_parity[1:0]),           //i
        .io_samplingTick          (clockDivider_tickReg),                  //i
        .io_write_valid           (io_write_thrown_valid),                 //i
        .io_write_ready           (tx_io_write_ready),                     //o
        .io_write_payload         (io_write_thrown_payload[7:0]),          //i
        .io_cts                   (1'b0),                                  //i
        .io_txd                   (tx_io_txd),                             //o
        .io_break                 (io_writeBreak),                         //i
        .io_mainClk               (io_mainClk),                            //i
        .resetCtrl_systemReset    (resetCtrl_systemReset | ~io_uart_txen)  //i
    );
    UartCtrlRx rx (
        .io_configFrame_dataLength(io_config_frame_dataLength[2:0]),       //i
        .io_configFrame_stop      (io_config_frame_stop),                  //i
        .io_configFrame_parity    (io_config_frame_parity[1:0]),           //i
        .io_samplingTick          (clockDivider_tickReg),                  //i
        .io_read_valid            (rx_io_read_valid),                      //o
        .io_read_ready            (io_read_ready),                         //i
        .io_read_payload          (rx_io_read_payload[7:0]),               //o
        .io_rxd                   (io_uart_rxd),                           //i
        .io_rts                   (rx_io_rts),                             //o
        .io_error                 (rx_io_error),                           //o
        .io_break                 (rx_io_break),                           //o
        .io_mainClk               (io_mainClk),                            //i
        .resetCtrl_systemReset    (resetCtrl_systemReset | ~io_uart_rxen)  //i
    );
`ifndef SYNTHESIS
    always @(*) begin
        case (io_config_frame_stop)
            UartStopType_ONE: io_config_frame_stop_string = "ONE";
            UartStopType_TWO: io_config_frame_stop_string = "TWO";
            default: io_config_frame_stop_string = "???";
        endcase
    end
    always @(*) begin
        case (io_config_frame_parity)
            UartParityType_NONE: io_config_frame_parity_string = "NONE";
            UartParityType_EVEN: io_config_frame_parity_string = "EVEN";
            UartParityType_ODD: io_config_frame_parity_string = "ODD ";
            default: io_config_frame_parity_string = "????";
        endcase
    end
`endif

    assign clockDivider_tick = (clockDivider_counter == 20'h0);
    always @(*) begin
        io_write_thrown_valid = io_write_valid;
        if (rx_io_break) begin
            io_write_thrown_valid = 1'b0;
        end
    end

    always @(*) begin
        io_write_ready = io_write_thrown_ready;
        if (rx_io_break) begin
            io_write_ready = 1'b1;
        end
    end

    assign io_write_thrown_payload = io_write_payload;
    assign io_write_thrown_ready = tx_io_write_ready;
    assign io_read_valid = rx_io_read_valid;
    assign io_read_payload = rx_io_read_payload;
    assign io_uart_txd = tx_io_txd;
    assign io_readError = rx_io_error;
    assign io_readBreak = rx_io_break;
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            clockDivider_counter <= 20'h0;
            clockDivider_tickReg <= 1'b0;
        end else begin
            clockDivider_tickReg <= clockDivider_tick;
            clockDivider_counter <= (clockDivider_counter - 20'h00001);
            if (clockDivider_tick) begin
                clockDivider_counter <= io_config_clockDivider;
            end
        end
    end

endmodule


module UartCtrlTx (
    input  wire [2:0] io_configFrame_dataLength,
    input  wire [0:0] io_configFrame_stop,
    input  wire [1:0] io_configFrame_parity,
    input  wire       io_samplingTick,
    input  wire       io_write_valid,
    output reg        io_write_ready,
    input  wire [7:0] io_write_payload,
    input  wire       io_cts,
    output wire       io_txd,
    input  wire       io_break,
    input  wire       io_mainClk,
    input  wire       resetCtrl_systemReset
);
    localparam UartStopType_ONE = 1'd0;
    localparam UartStopType_TWO = 1'd1;
    localparam UartParityType_NONE = 2'd0;
    localparam UartParityType_EVEN = 2'd1;
    localparam UartParityType_ODD = 2'd2;
    localparam UartCtrlTxState_IDLE = 3'd0;
    localparam UartCtrlTxState_START = 3'd1;
    localparam UartCtrlTxState_DATA = 3'd2;
    localparam UartCtrlTxState_PARITY = 3'd3;
    localparam UartCtrlTxState_STOP = 3'd4;

    wire [2:0] _zz_clockDivider_counter_valueNext;
    wire [0:0] _zz_clockDivider_counter_valueNext_1;
    wire [2:0] _zz_when_UartCtrlTx_l93;
    wire [0:0] _zz_when_UartCtrlTx_l93_1;
    reg        clockDivider_counter_willIncrement;
    wire       clockDivider_counter_willClear;
    reg  [2:0] clockDivider_counter_valueNext;
    reg  [2:0] clockDivider_counter_value;
    wire       clockDivider_counter_willOverflowIfInc;
    wire       clockDivider_counter_willOverflow;
    reg  [2:0] tickCounter_value;
    reg  [2:0] stateMachine_state;
    reg        stateMachine_parity;
    reg        stateMachine_txd;
    wire       when_UartCtrlTx_l58;
    wire       when_UartCtrlTx_l73;
    wire       when_UartCtrlTx_l76;
    wire       when_UartCtrlTx_l93;
    wire [2:0] _zz_stateMachine_state;
    reg        _zz_io_txd;
`ifndef SYNTHESIS
    reg [23:0] io_configFrame_stop_string;
    reg [31:0] io_configFrame_parity_string;
    reg [47:0] stateMachine_state_string;
    reg [47:0] _zz_stateMachine_state_string;
`endif


    assign _zz_clockDivider_counter_valueNext_1 = clockDivider_counter_willIncrement;
    assign _zz_clockDivider_counter_valueNext = {2'd0, _zz_clockDivider_counter_valueNext_1};
    assign _zz_when_UartCtrlTx_l93_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
    assign _zz_when_UartCtrlTx_l93 = {2'd0, _zz_when_UartCtrlTx_l93_1};
`ifndef SYNTHESIS
    always @(*) begin
        case (io_configFrame_stop)
            UartStopType_ONE: io_configFrame_stop_string = "ONE";
            UartStopType_TWO: io_configFrame_stop_string = "TWO";
            default: io_configFrame_stop_string = "???";
        endcase
    end
    always @(*) begin
        case (io_configFrame_parity)
            UartParityType_NONE: io_configFrame_parity_string = "NONE";
            UartParityType_EVEN: io_configFrame_parity_string = "EVEN";
            UartParityType_ODD: io_configFrame_parity_string = "ODD ";
            default: io_configFrame_parity_string = "????";
        endcase
    end
    always @(*) begin
        case (stateMachine_state)
            UartCtrlTxState_IDLE: stateMachine_state_string = "IDLE  ";
            UartCtrlTxState_START: stateMachine_state_string = "START ";
            UartCtrlTxState_DATA: stateMachine_state_string = "DATA  ";
            UartCtrlTxState_PARITY: stateMachine_state_string = "PARITY";
            UartCtrlTxState_STOP: stateMachine_state_string = "STOP  ";
            default: stateMachine_state_string = "??????";
        endcase
    end
    always @(*) begin
        case (_zz_stateMachine_state)
            UartCtrlTxState_IDLE: _zz_stateMachine_state_string = "IDLE  ";
            UartCtrlTxState_START: _zz_stateMachine_state_string = "START ";
            UartCtrlTxState_DATA: _zz_stateMachine_state_string = "DATA  ";
            UartCtrlTxState_PARITY: _zz_stateMachine_state_string = "PARITY";
            UartCtrlTxState_STOP: _zz_stateMachine_state_string = "STOP  ";
            default: _zz_stateMachine_state_string = "??????";
        endcase
    end
`endif

    always @(*) begin
        clockDivider_counter_willIncrement = 1'b0;
        if (io_samplingTick) begin
            clockDivider_counter_willIncrement = 1'b1;
        end
    end

    assign clockDivider_counter_willClear = 1'b0;
    assign clockDivider_counter_willOverflowIfInc = (clockDivider_counter_value == 3'b100);
    assign clockDivider_counter_willOverflow = (clockDivider_counter_willOverflowIfInc && clockDivider_counter_willIncrement);
    always @(*) begin
        if (clockDivider_counter_willOverflow) begin
            clockDivider_counter_valueNext = 3'b000;
        end else begin
            clockDivider_counter_valueNext = (clockDivider_counter_value + _zz_clockDivider_counter_valueNext);
        end
        if (clockDivider_counter_willClear) begin
            clockDivider_counter_valueNext = 3'b000;
        end
    end

    always @(*) begin
        stateMachine_txd = 1'b1;
        case (stateMachine_state)
            UartCtrlTxState_IDLE: begin
            end
            UartCtrlTxState_START: begin
                stateMachine_txd = 1'b0;
            end
            UartCtrlTxState_DATA: begin
                stateMachine_txd = io_write_payload[tickCounter_value];
            end
            UartCtrlTxState_PARITY: begin
                stateMachine_txd = stateMachine_parity;
            end
            default: begin
            end
        endcase
    end

    always @(*) begin
        io_write_ready = io_break;
        case (stateMachine_state)
            UartCtrlTxState_IDLE: begin
            end
            UartCtrlTxState_START: begin
            end
            UartCtrlTxState_DATA: begin
                if (clockDivider_counter_willOverflow) begin
                    if (when_UartCtrlTx_l73) begin
                        io_write_ready = 1'b1;
                    end
                end
            end
            UartCtrlTxState_PARITY: begin
            end
            default: begin
            end
        endcase
    end

    assign when_UartCtrlTx_l58 = ((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow);
    assign when_UartCtrlTx_l73 = (tickCounter_value == io_configFrame_dataLength);
    assign when_UartCtrlTx_l76 = (io_configFrame_parity == UartParityType_NONE);
    assign when_UartCtrlTx_l93 = (tickCounter_value == _zz_when_UartCtrlTx_l93);
    assign _zz_stateMachine_state = (io_write_valid ? UartCtrlTxState_START : UartCtrlTxState_IDLE);
    assign io_txd = _zz_io_txd;
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            clockDivider_counter_value <= 3'b000;
            stateMachine_state <= UartCtrlTxState_IDLE;
            _zz_io_txd <= 1'b1;
        end else begin
            clockDivider_counter_value <= clockDivider_counter_valueNext;
            case (stateMachine_state)
                UartCtrlTxState_IDLE: begin
                    if (when_UartCtrlTx_l58) begin
                        stateMachine_state <= UartCtrlTxState_START;
                    end
                end
                UartCtrlTxState_START: begin
                    if (clockDivider_counter_willOverflow) begin
                        stateMachine_state <= UartCtrlTxState_DATA;
                    end
                end
                UartCtrlTxState_DATA: begin
                    if (clockDivider_counter_willOverflow) begin
                        if (when_UartCtrlTx_l73) begin
                            if (when_UartCtrlTx_l76) begin
                                stateMachine_state <= UartCtrlTxState_STOP;
                            end else begin
                                stateMachine_state <= UartCtrlTxState_PARITY;
                            end
                        end
                    end
                end
                UartCtrlTxState_PARITY: begin
                    if (clockDivider_counter_willOverflow) begin
                        stateMachine_state <= UartCtrlTxState_STOP;
                    end
                end
                default: begin
                    if (clockDivider_counter_willOverflow) begin
                        if (when_UartCtrlTx_l93) begin
                            stateMachine_state <= _zz_stateMachine_state;
                        end
                    end
                end
            endcase
            _zz_io_txd <= (stateMachine_txd && (!io_break));
        end
    end

    always @(posedge io_mainClk) begin
        if (clockDivider_counter_willOverflow) begin
            tickCounter_value <= (tickCounter_value + 3'b001);
        end
        if (clockDivider_counter_willOverflow) begin
            stateMachine_parity <= (stateMachine_parity ^ stateMachine_txd);
        end
        case (stateMachine_state)
            UartCtrlTxState_IDLE: begin
            end
            UartCtrlTxState_START: begin
                if (clockDivider_counter_willOverflow) begin
                    stateMachine_parity <= (io_configFrame_parity == UartParityType_ODD);
                    tickCounter_value   <= 3'b000;
                end
            end
            UartCtrlTxState_DATA: begin
                if (clockDivider_counter_willOverflow) begin
                    if (when_UartCtrlTx_l73) begin
                        tickCounter_value <= 3'b000;
                    end
                end
            end
            UartCtrlTxState_PARITY: begin
                if (clockDivider_counter_willOverflow) begin
                    tickCounter_value <= 3'b000;
                end
            end
            default: begin
            end
        endcase
    end

endmodule


module UartCtrlRx (
    input  wire [2:0] io_configFrame_dataLength,
    input  wire [0:0] io_configFrame_stop,
    input  wire [1:0] io_configFrame_parity,
    input  wire       io_samplingTick,
    output wire       io_read_valid,
    input  wire       io_read_ready,
    output wire [7:0] io_read_payload,
    input  wire       io_rxd,
    output wire       io_rts,
    output reg        io_error,
    output wire       io_break,
    input  wire       io_mainClk,
    input  wire       resetCtrl_systemReset
);
    localparam UartStopType_ONE = 1'd0;
    localparam UartStopType_TWO = 1'd1;
    localparam UartParityType_NONE = 2'd0;
    localparam UartParityType_EVEN = 2'd1;
    localparam UartParityType_ODD = 2'd2;
    localparam UartCtrlRxState_IDLE = 3'd0;
    localparam UartCtrlRxState_START = 3'd1;
    localparam UartCtrlRxState_DATA = 3'd2;
    localparam UartCtrlRxState_PARITY = 3'd3;
    localparam UartCtrlRxState_STOP = 3'd4;

    wire       io_rxd_buffercc_io_dataOut;
    wire [2:0] _zz_when_UartCtrlRx_l139;
    wire [0:0] _zz_when_UartCtrlRx_l139_1;
    reg        _zz_io_rts;
    wire       sampler_synchroniser;
    wire       sampler_samples_0;
    reg        sampler_samples_1;
    reg        sampler_samples_2;
    reg        sampler_value;
    reg        sampler_tick;
    reg  [2:0] bitTimer_counter;
    reg        bitTimer_tick;
    wire       when_UartCtrlRx_l43;
    reg  [2:0] bitCounter_value;
    reg  [6:0] break_counter;
    wire       break_valid;
    wire       when_UartCtrlRx_l69;
    reg  [2:0] stateMachine_state;
    reg        stateMachine_parity;
    reg  [7:0] stateMachine_shifter;
    reg        stateMachine_validReg;
    wire       when_UartCtrlRx_l93;
    wire       when_UartCtrlRx_l103;
    wire       when_UartCtrlRx_l111;
    wire       when_UartCtrlRx_l113;
    wire       when_UartCtrlRx_l125;
    wire       when_UartCtrlRx_l136;
    wire       when_UartCtrlRx_l139;
`ifndef SYNTHESIS
    reg [23:0] io_configFrame_stop_string;
    reg [31:0] io_configFrame_parity_string;
    reg [47:0] stateMachine_state_string;
`endif


    assign _zz_when_UartCtrlRx_l139_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
    assign _zz_when_UartCtrlRx_l139   = {2'd0, _zz_when_UartCtrlRx_l139_1};
    (* keep_hierarchy = "TRUE" *) BufferCC_UART BufferCC_UART (
        .io_dataIn            (io_rxd),                      //i
        .io_dataOut           (io_rxd_buffercc_io_dataOut),  //o
        .io_mainClk           (io_mainClk),                  //i
        .resetCtrl_systemReset(resetCtrl_systemReset)        //i
    );
`ifndef SYNTHESIS
    always @(*) begin
        case (io_configFrame_stop)
            UartStopType_ONE: io_configFrame_stop_string = "ONE";
            UartStopType_TWO: io_configFrame_stop_string = "TWO";
            default: io_configFrame_stop_string = "???";
        endcase
    end
    always @(*) begin
        case (io_configFrame_parity)
            UartParityType_NONE: io_configFrame_parity_string = "NONE";
            UartParityType_EVEN: io_configFrame_parity_string = "EVEN";
            UartParityType_ODD: io_configFrame_parity_string = "ODD ";
            default: io_configFrame_parity_string = "????";
        endcase
    end
    always @(*) begin
        case (stateMachine_state)
            UartCtrlRxState_IDLE: stateMachine_state_string = "IDLE  ";
            UartCtrlRxState_START: stateMachine_state_string = "START ";
            UartCtrlRxState_DATA: stateMachine_state_string = "DATA  ";
            UartCtrlRxState_PARITY: stateMachine_state_string = "PARITY";
            UartCtrlRxState_STOP: stateMachine_state_string = "STOP  ";
            default: stateMachine_state_string = "??????";
        endcase
    end
`endif

    always @(*) begin
        io_error = 1'b0;
        case (stateMachine_state)
            UartCtrlRxState_IDLE: begin
            end
            UartCtrlRxState_START: begin
            end
            UartCtrlRxState_DATA: begin
            end
            UartCtrlRxState_PARITY: begin
                if (bitTimer_tick) begin
                    if (!when_UartCtrlRx_l125) begin
                        io_error = 1'b1;
                    end
                end
            end
            default: begin
                if (bitTimer_tick) begin
                    if (when_UartCtrlRx_l136) begin
                        io_error = 1'b1;
                    end
                end
            end
        endcase
    end

    assign io_rts = _zz_io_rts;
    assign sampler_synchroniser = io_rxd_buffercc_io_dataOut;
    assign sampler_samples_0 = sampler_synchroniser;
    always @(*) begin
        bitTimer_tick = 1'b0;
        if (sampler_tick) begin
            if (when_UartCtrlRx_l43) begin
                bitTimer_tick = 1'b1;
            end
        end
    end

    assign when_UartCtrlRx_l43 = (bitTimer_counter == 3'b000);
    assign break_valid = (break_counter == 7'h41);
    assign when_UartCtrlRx_l69 = (io_samplingTick && (!break_valid));
    assign io_break = break_valid;
    assign io_read_valid = stateMachine_validReg;
    assign when_UartCtrlRx_l93 = ((sampler_tick && (!sampler_value)) && (!break_valid));
    assign when_UartCtrlRx_l103 = (sampler_value == 1'b1);
    assign when_UartCtrlRx_l111 = (bitCounter_value == io_configFrame_dataLength);
    assign when_UartCtrlRx_l113 = (io_configFrame_parity == UartParityType_NONE);
    assign when_UartCtrlRx_l125 = (stateMachine_parity == sampler_value);
    assign when_UartCtrlRx_l136 = (!sampler_value);
    assign when_UartCtrlRx_l139 = (bitCounter_value == _zz_when_UartCtrlRx_l139);
    assign io_read_payload = stateMachine_shifter;
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            _zz_io_rts <= 1'b0;
            sampler_samples_1 <= 1'b1;
            sampler_samples_2 <= 1'b1;
            sampler_value <= 1'b1;
            sampler_tick <= 1'b0;
            break_counter <= 7'h0;
            stateMachine_state <= UartCtrlRxState_IDLE;
            stateMachine_validReg <= 1'b0;
        end else begin
            _zz_io_rts <= (!io_read_ready);
            if (io_samplingTick) begin
                sampler_samples_1 <= sampler_samples_0;
            end
            if (io_samplingTick) begin
                sampler_samples_2 <= sampler_samples_1;
            end
            sampler_value <= (((1'b0 || ((1'b1 && sampler_samples_0) && sampler_samples_1)) || ((1'b1 && sampler_samples_0) && sampler_samples_2)) || ((1'b1 && sampler_samples_1) && sampler_samples_2));
            sampler_tick <= io_samplingTick;
            if (sampler_value) begin
                break_counter <= 7'h0;
            end else begin
                if (when_UartCtrlRx_l69) begin
                    break_counter <= (break_counter + 7'h01);
                end
            end
            stateMachine_validReg <= 1'b0;
            case (stateMachine_state)
                UartCtrlRxState_IDLE: begin
                    if (when_UartCtrlRx_l93) begin
                        stateMachine_state <= UartCtrlRxState_START;
                    end
                end
                UartCtrlRxState_START: begin
                    if (bitTimer_tick) begin
                        stateMachine_state <= UartCtrlRxState_DATA;
                        if (when_UartCtrlRx_l103) begin
                            stateMachine_state <= UartCtrlRxState_IDLE;
                        end
                    end
                end
                UartCtrlRxState_DATA: begin
                    if (bitTimer_tick) begin
                        if (when_UartCtrlRx_l111) begin
                            if (when_UartCtrlRx_l113) begin
                                stateMachine_state <= UartCtrlRxState_STOP;
                                stateMachine_validReg <= 1'b1;
                            end else begin
                                stateMachine_state <= UartCtrlRxState_PARITY;
                            end
                        end
                    end
                end
                UartCtrlRxState_PARITY: begin
                    if (bitTimer_tick) begin
                        if (when_UartCtrlRx_l125) begin
                            stateMachine_state <= UartCtrlRxState_STOP;
                            stateMachine_validReg <= 1'b1;
                        end else begin
                            stateMachine_state <= UartCtrlRxState_IDLE;
                        end
                    end
                end
                default: begin
                    if (bitTimer_tick) begin
                        if (when_UartCtrlRx_l136) begin
                            stateMachine_state <= UartCtrlRxState_IDLE;
                        end else begin
                            if (when_UartCtrlRx_l139) begin
                                stateMachine_state <= UartCtrlRxState_IDLE;
                            end
                        end
                    end
                end
            endcase
        end
    end

    always @(posedge io_mainClk) begin
        if (sampler_tick) begin
            bitTimer_counter <= (bitTimer_counter - 3'b001);
            if (when_UartCtrlRx_l43) begin
                bitTimer_counter <= 3'b100;
            end
        end
        if (bitTimer_tick) begin
            bitCounter_value <= (bitCounter_value + 3'b001);
        end
        if (bitTimer_tick) begin
            stateMachine_parity <= (stateMachine_parity ^ sampler_value);
        end
        case (stateMachine_state)
            UartCtrlRxState_IDLE: begin
                if (when_UartCtrlRx_l93) begin
                    bitTimer_counter <= 3'b001;
                end
            end
            UartCtrlRxState_START: begin
                if (bitTimer_tick) begin
                    bitCounter_value <= 3'b000;
                    stateMachine_parity <= (io_configFrame_parity == UartParityType_ODD);
                end
            end
            UartCtrlRxState_DATA: begin
                if (bitTimer_tick) begin
                    stateMachine_shifter[bitCounter_value] <= sampler_value;
                    if (when_UartCtrlRx_l111) begin
                        bitCounter_value <= 3'b000;
                    end
                end
            end
            UartCtrlRxState_PARITY: begin
                if (bitTimer_tick) begin
                    bitCounter_value <= 3'b000;
                end
            end
            default: begin
            end
        endcase
    end

endmodule


module BufferCC_UART (
    input  wire io_dataIn,
    output wire io_dataOut,
    input  wire io_mainClk,
    input  wire resetCtrl_systemReset
);

    (* async_reg = "true" *)reg buffers_0;
    (* async_reg = "true" *)reg buffers_1;

    assign io_dataOut = buffers_1;
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            buffers_0 <= 1'b0;
            buffers_1 <= 1'b0;
        end else begin
            buffers_0 <= io_dataIn;
            buffers_1 <= buffers_0;
        end
    end

endmodule
