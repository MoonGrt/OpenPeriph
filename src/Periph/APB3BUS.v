module Apb3Bridge (
    input  wire        io_pipelinedMemoryBus_cmd_valid,
    output wire        io_pipelinedMemoryBus_cmd_ready,
    input  wire        io_pipelinedMemoryBus_cmd_payload_write,
    input  wire [31:0] io_pipelinedMemoryBus_cmd_payload_address,
    input  wire [31:0] io_pipelinedMemoryBus_cmd_payload_data,
    input  wire [ 3:0] io_pipelinedMemoryBus_cmd_payload_mask,
    output wire        io_pipelinedMemoryBus_rsp_valid,
    output wire [31:0] io_pipelinedMemoryBus_rsp_payload_data,
    output wire [19:0] io_apb_PADDR,
    output wire [ 0:0] io_apb_PSEL,
    output wire        io_apb_PENABLE,
    input  wire        io_apb_PREADY,
    output wire        io_apb_PWRITE,
    output wire [31:0] io_apb_PWDATA,
    input  wire [31:0] io_apb_PRDATA,
    input  wire        io_apb_PSLVERROR,
    input  wire        io_mainClk,
    input  wire        resetCtrl_systemReset
);

    wire        pipelinedMemoryBusStage_cmd_valid;
    reg         pipelinedMemoryBusStage_cmd_ready;
    wire        pipelinedMemoryBusStage_cmd_payload_write;
    wire [31:0] pipelinedMemoryBusStage_cmd_payload_address;
    wire [31:0] pipelinedMemoryBusStage_cmd_payload_data;
    wire [ 3:0] pipelinedMemoryBusStage_cmd_payload_mask;
    reg         pipelinedMemoryBusStage_rsp_valid;
    wire [31:0] pipelinedMemoryBusStage_rsp_payload_data;
    wire        io_pipelinedMemoryBus_cmd_halfPipe_valid;
    wire        io_pipelinedMemoryBus_cmd_halfPipe_ready;
    wire        io_pipelinedMemoryBus_cmd_halfPipe_payload_write;
    wire [31:0] io_pipelinedMemoryBus_cmd_halfPipe_payload_address;
    wire [31:0] io_pipelinedMemoryBus_cmd_halfPipe_payload_data;
    wire [ 3:0] io_pipelinedMemoryBus_cmd_halfPipe_payload_mask;
    reg         io_pipelinedMemoryBus_cmd_rValid;
    wire        io_pipelinedMemoryBus_cmd_halfPipe_fire;
    reg         io_pipelinedMemoryBus_cmd_rData_write;
    reg  [31:0] io_pipelinedMemoryBus_cmd_rData_address;
    reg  [31:0] io_pipelinedMemoryBus_cmd_rData_data;
    reg  [ 3:0] io_pipelinedMemoryBus_cmd_rData_mask;
    reg         pipelinedMemoryBusStage_rsp_regNext_valid;
    reg  [31:0] pipelinedMemoryBusStage_rsp_regNext_payload_data;
    reg         state;
    wire        when_PipelinedMemoryBus_l369;

    assign io_pipelinedMemoryBus_cmd_halfPipe_fire = (io_pipelinedMemoryBus_cmd_halfPipe_valid && io_pipelinedMemoryBus_cmd_halfPipe_ready);
    assign io_pipelinedMemoryBus_cmd_ready = (!io_pipelinedMemoryBus_cmd_rValid);
    assign io_pipelinedMemoryBus_cmd_halfPipe_valid = io_pipelinedMemoryBus_cmd_rValid;
    assign io_pipelinedMemoryBus_cmd_halfPipe_payload_write = io_pipelinedMemoryBus_cmd_rData_write;
    assign io_pipelinedMemoryBus_cmd_halfPipe_payload_address = io_pipelinedMemoryBus_cmd_rData_address;
    assign io_pipelinedMemoryBus_cmd_halfPipe_payload_data = io_pipelinedMemoryBus_cmd_rData_data;
    assign io_pipelinedMemoryBus_cmd_halfPipe_payload_mask = io_pipelinedMemoryBus_cmd_rData_mask;
    assign pipelinedMemoryBusStage_cmd_valid = io_pipelinedMemoryBus_cmd_halfPipe_valid;
    assign io_pipelinedMemoryBus_cmd_halfPipe_ready = pipelinedMemoryBusStage_cmd_ready;
    assign pipelinedMemoryBusStage_cmd_payload_write = io_pipelinedMemoryBus_cmd_halfPipe_payload_write;
    assign pipelinedMemoryBusStage_cmd_payload_address = io_pipelinedMemoryBus_cmd_halfPipe_payload_address;
    assign pipelinedMemoryBusStage_cmd_payload_data = io_pipelinedMemoryBus_cmd_halfPipe_payload_data;
    assign pipelinedMemoryBusStage_cmd_payload_mask = io_pipelinedMemoryBus_cmd_halfPipe_payload_mask;
    assign io_pipelinedMemoryBus_rsp_valid = pipelinedMemoryBusStage_rsp_regNext_valid;
    assign io_pipelinedMemoryBus_rsp_payload_data = pipelinedMemoryBusStage_rsp_regNext_payload_data;
    always @(*) begin
        pipelinedMemoryBusStage_cmd_ready = 1'b0;
        if (!when_PipelinedMemoryBus_l369) begin
            if (io_apb_PREADY) begin
                pipelinedMemoryBusStage_cmd_ready = 1'b1;
            end
        end
    end

    assign io_apb_PSEL[0] = pipelinedMemoryBusStage_cmd_valid;
    assign io_apb_PENABLE = state;
    assign io_apb_PWRITE  = pipelinedMemoryBusStage_cmd_payload_write;
    assign io_apb_PADDR   = pipelinedMemoryBusStage_cmd_payload_address[19:0];
    assign io_apb_PWDATA  = pipelinedMemoryBusStage_cmd_payload_data;
    always @(*) begin
        pipelinedMemoryBusStage_rsp_valid = 1'b0;
        if (!when_PipelinedMemoryBus_l369) begin
            if (io_apb_PREADY) begin
                pipelinedMemoryBusStage_rsp_valid = (!pipelinedMemoryBusStage_cmd_payload_write);
            end
        end
    end

    assign pipelinedMemoryBusStage_rsp_payload_data = io_apb_PRDATA;
    assign when_PipelinedMemoryBus_l369 = (!state);
    always @(posedge io_mainClk or posedge resetCtrl_systemReset) begin
        if (resetCtrl_systemReset) begin
            io_pipelinedMemoryBus_cmd_rValid <= 1'b0;
            pipelinedMemoryBusStage_rsp_regNext_valid <= 1'b0;
            state <= 1'b0;
        end else begin
            if (io_pipelinedMemoryBus_cmd_valid) begin
                io_pipelinedMemoryBus_cmd_rValid <= 1'b1;
            end
            if (io_pipelinedMemoryBus_cmd_halfPipe_fire) begin
                io_pipelinedMemoryBus_cmd_rValid <= 1'b0;
            end
            pipelinedMemoryBusStage_rsp_regNext_valid <= pipelinedMemoryBusStage_rsp_valid;
            if (when_PipelinedMemoryBus_l369) begin
                state <= pipelinedMemoryBusStage_cmd_valid;
            end else begin
                if (io_apb_PREADY) begin
                    state <= 1'b0;
                end
            end
        end
    end

    always @(posedge io_mainClk) begin
        if (io_pipelinedMemoryBus_cmd_ready) begin
            io_pipelinedMemoryBus_cmd_rData_write <= io_pipelinedMemoryBus_cmd_payload_write;
            io_pipelinedMemoryBus_cmd_rData_address <= io_pipelinedMemoryBus_cmd_payload_address;
            io_pipelinedMemoryBus_cmd_rData_data <= io_pipelinedMemoryBus_cmd_payload_data;
            io_pipelinedMemoryBus_cmd_rData_mask <= io_pipelinedMemoryBus_cmd_payload_mask;
        end
        pipelinedMemoryBusStage_rsp_regNext_payload_data <= pipelinedMemoryBusStage_rsp_payload_data;
    end

endmodule


module Apb3PRouter (
    input  wire [19:0] io_input_PADDR,
    input  wire [ 0:0] io_input_PSEL,
    input  wire        io_input_PENABLE,
    output reg         io_input_PREADY,
    input  wire        io_input_PWRITE,
    input  wire [31:0] io_input_PWDATA,
    output wire [31:0] io_input_PRDATA,
    output reg         io_input_PSLVERROR,

    // GPIO
    output wire [19:0] io_outputs_0_PADDR,
    output wire [ 0:0] io_outputs_0_PSEL,
    output wire        io_outputs_0_PENABLE,
    input  wire        io_outputs_0_PREADY,
    output wire        io_outputs_0_PWRITE,
    output wire [31:0] io_outputs_0_PWDATA,
    input  wire [31:0] io_outputs_0_PRDATA,
    input  wire        io_outputs_0_PSLVERROR,
    // USART
    output wire [19:0] io_outputs_1_PADDR,
    output wire [ 0:0] io_outputs_1_PSEL,
    output wire        io_outputs_1_PENABLE,
    input  wire        io_outputs_1_PREADY,
    output wire        io_outputs_1_PWRITE,
    output wire [31:0] io_outputs_1_PWDATA,
    input  wire [31:0] io_outputs_1_PRDATA,
    input  wire        io_outputs_1_PSLVERROR,
    // I2C
    output wire [19:0] io_outputs_2_PADDR,
    output wire [ 0:0] io_outputs_2_PSEL,
    output wire        io_outputs_2_PENABLE,
    input  wire        io_outputs_2_PREADY,
    output wire        io_outputs_2_PWRITE,
    output wire [31:0] io_outputs_2_PWDATA,
    input  wire [31:0] io_outputs_2_PRDATA,
    input  wire        io_outputs_2_PSLVERROR,
    // SPI
    output wire [19:0] io_outputs_3_PADDR,
    output wire [ 0:0] io_outputs_3_PSEL,
    output wire        io_outputs_3_PENABLE,
    input  wire        io_outputs_3_PREADY,
    output wire        io_outputs_3_PWRITE,
    output wire [31:0] io_outputs_3_PWDATA,
    input  wire [31:0] io_outputs_3_PRDATA,
    input  wire        io_outputs_3_PSLVERROR,
    // TIM
    output wire [19:0] io_outputs_4_PADDR,
    output wire [ 0:0] io_outputs_4_PSEL,
    output wire        io_outputs_4_PENABLE,
    input  wire        io_outputs_4_PREADY,
    output wire        io_outputs_4_PWRITE,
    output wire [31:0] io_outputs_4_PWDATA,
    input  wire [31:0] io_outputs_4_PRDATA,
    input  wire        io_outputs_4_PSLVERROR,
    // WDG
    output wire [19:0] io_outputs_5_PADDR,
    output wire [ 0:0] io_outputs_5_PSEL,
    output wire        io_outputs_5_PENABLE,
    input  wire        io_outputs_5_PREADY,
    output wire        io_outputs_5_PWRITE,
    output wire [31:0] io_outputs_5_PWDATA,
    input  wire [31:0] io_outputs_5_PRDATA,
    input  wire        io_outputs_5_PSLVERROR,

    input  wire        io_mainClk,
    input  wire        resetCtrl_systemReset
);

    wire when_Apb3Decoder_l88;
    reg         _zz_io_input_PREADY;
    reg  [31:0] _zz_io_input_PRDATA;
    reg         _zz_io_input_PSLVERROR;
    reg  [15:0] selIndex;
    reg  [15:0] Apb3PSEL;

    always @(*) begin
        if (resetCtrl_systemReset) begin
            Apb3PSEL <= 16'h0000;
        end else begin
            Apb3PSEL[0] = ((io_input_PADDR[19:16] == 4'd0) && io_input_PSEL[0]);  // GPIO
            Apb3PSEL[1] = ((io_input_PADDR[19:16] == 4'd1) && io_input_PSEL[0]);  // USART
            Apb3PSEL[2] = ((io_input_PADDR[19:16] == 4'd2) && io_input_PSEL[0]);  // I2C
            Apb3PSEL[3] = ((io_input_PADDR[19:16] == 4'd3) && io_input_PSEL[0]);  // SPI
            Apb3PSEL[4] = ((io_input_PADDR[19:16] == 4'd4) && io_input_PSEL[0]);  // TIM
            Apb3PSEL[5] = ((io_input_PADDR[19:16] == 4'd5) && io_input_PSEL[0]);  // WDG
        end
    end

    always @(*) begin
        io_input_PREADY = _zz_io_input_PREADY;
        if (when_Apb3Decoder_l88) begin
            io_input_PREADY = 1'b1;
        end
    end

    assign io_input_PRDATA = _zz_io_input_PRDATA;
    always @(*) begin
        io_input_PSLVERROR = _zz_io_input_PSLVERROR;
        if (when_Apb3Decoder_l88) begin
            io_input_PSLVERROR = 1'b1;
        end
    end

    assign when_Apb3Decoder_l88 = (io_input_PSEL[0] && (Apb3PSEL == 16'h0000));


    always @(posedge io_mainClk) selIndex <= Apb3PSEL;
    always @(*) begin
        if (resetCtrl_systemReset) begin
            _zz_io_input_PREADY <= 1'b1;
            _zz_io_input_PRDATA <= 32'h0;
            _zz_io_input_PSLVERROR <= 1'b0;
        end
        else
            case (selIndex)
                16'h0001: begin
                    _zz_io_input_PREADY = io_outputs_0_PREADY;
                    _zz_io_input_PRDATA = io_outputs_0_PRDATA;
                    _zz_io_input_PSLVERROR = io_outputs_0_PSLVERROR;
                end
                16'h0002: begin
                    _zz_io_input_PREADY = io_outputs_1_PREADY;
                    _zz_io_input_PRDATA = io_outputs_1_PRDATA;
                    _zz_io_input_PSLVERROR = io_outputs_1_PSLVERROR;
                end
                16'h0004: begin
                    _zz_io_input_PREADY = io_outputs_2_PREADY;
                    _zz_io_input_PRDATA = io_outputs_2_PRDATA;
                    _zz_io_input_PSLVERROR = io_outputs_2_PSLVERROR;
                end
                16'h0008: begin
                    _zz_io_input_PREADY = io_outputs_3_PREADY;
                    _zz_io_input_PRDATA = io_outputs_3_PRDATA;
                    _zz_io_input_PSLVERROR = io_outputs_3_PSLVERROR;
                end
                16'h0010: begin
                    _zz_io_input_PREADY = io_outputs_4_PREADY;
                    _zz_io_input_PRDATA = io_outputs_4_PRDATA;
                    _zz_io_input_PSLVERROR = io_outputs_4_PSLVERROR;
                end
                16'h0020: begin
                    _zz_io_input_PREADY = io_outputs_5_PREADY;
                    _zz_io_input_PRDATA = io_outputs_5_PRDATA;
                    _zz_io_input_PSLVERROR = io_outputs_5_PSLVERROR;
                end
                default: ;
            endcase
    end

    // GPIO
    assign io_outputs_0_PADDR = io_input_PADDR;
    assign io_outputs_0_PENABLE = io_input_PENABLE;
    assign io_outputs_0_PSEL = Apb3PSEL[0];
    assign io_outputs_0_PWRITE = io_input_PWRITE;
    assign io_outputs_0_PWDATA = io_input_PWDATA;
    // USART
    assign io_outputs_1_PADDR = io_input_PADDR;
    assign io_outputs_1_PENABLE = io_input_PENABLE;
    assign io_outputs_1_PSEL = Apb3PSEL[1];
    assign io_outputs_1_PWRITE = io_input_PWRITE;
    assign io_outputs_1_PWDATA = io_input_PWDATA;
    // I2C
    assign io_outputs_2_PADDR = io_input_PADDR;
    assign io_outputs_2_PENABLE = io_input_PENABLE;
    assign io_outputs_2_PSEL = Apb3PSEL[2];
    assign io_outputs_2_PWRITE = io_input_PWRITE;
    assign io_outputs_2_PWDATA = io_input_PWDATA;
    // SPI
    assign io_outputs_3_PADDR = io_input_PADDR;
    assign io_outputs_3_PENABLE = io_input_PENABLE;
    assign io_outputs_3_PSEL = Apb3PSEL[3];
    assign io_outputs_3_PWRITE = io_input_PWRITE;
    assign io_outputs_3_PWDATA = io_input_PWDATA;
    // TIM
    assign io_outputs_4_PADDR = io_input_PADDR;
    assign io_outputs_4_PENABLE = io_input_PENABLE;
    assign io_outputs_4_PSEL = Apb3PSEL[4];
    assign io_outputs_4_PWRITE = io_input_PWRITE;
    assign io_outputs_4_PWDATA = io_input_PWDATA;
    // WDG
    assign io_outputs_5_PADDR = io_input_PADDR;
    assign io_outputs_5_PENABLE = io_input_PENABLE;
    assign io_outputs_5_PSEL = Apb3PSEL[5];
    assign io_outputs_5_PWRITE = io_input_PWRITE;
    assign io_outputs_5_PWDATA = io_input_PWDATA;

endmodule
