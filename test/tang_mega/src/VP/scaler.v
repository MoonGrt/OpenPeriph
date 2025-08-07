module scaler #(
    parameter INPUT_X_RES_WIDTH = 11,  // Widths of input/output resolution control signals
    parameter INPUT_Y_RES_WIDTH = 11,
    parameter OUTPUT_X_RES_WIDTH = 11,
    parameter OUTPUT_Y_RES_WIDTH = 11
) (
    input wire       EN,  // Enable
    input wire [1:0] mode,  // Select algorithm

    input wire [ INPUT_X_RES_WIDTH-1:0] inputXRes,  // Resolution of input data minus 1
    input wire [ INPUT_Y_RES_WIDTH-1:0] inputYRes,
    input wire [OUTPUT_X_RES_WIDTH-1:0] outputXRes,  // Resolution of input data minus 1
    input wire [OUTPUT_Y_RES_WIDTH-1:0] outputYRes,

    // Image data prepred to be processed
    input wire        pre_clk,  // Prepared Image data clock
    input wire        pre_vs,   // Prepared Image data vs valid signal
    input wire        pre_de,   // Prepared Image data output/capture enable clock
    input wire [23:0] pre_data, // Prepared Image data

    // Image data has been processed
    input  wire        post_clk,  // Processed Image data clock
    output wire        post_vs,   // Processed Image data vs valid signal
    output wire        post_de,   // Processed Image data output/capture enable clock
    output wire [23:0] post_data  // Processed Image data
);
    // Scaler Parameters
    parameter DATA_WIDTH = 8;
    parameter CHANNELS = 3;
    parameter BUFFER_SIZE = 3;

    parameter DISCARD_CNT_WIDTH = 2;
    parameter FRACTION_BITS = 8;  // Don't modify
    parameter SCALE_INT_BITS = 4;  // Don't modify
    parameter SCALE_FRAC_BITS = 14;  // Don't modify
    parameter SCALE_BITS = SCALE_INT_BITS + SCALE_FRAC_BITS;

    wire [SCALE_BITS-1:0] xScale = 32'h4000 * (inputXRes + 1) / (outputXRes + 1);  // Scaling factors. Input resolution scaled up by 1/xScale. Format Q SCALE_INT_BITS.SCALE_FRAC_BITS
    wire [SCALE_BITS-1:0] yScale = 32'h4000 * (inputYRes + 1) / (outputYRes + 1);  // Scaling factors. Input resolution scaled up by 1/yScale. Format Q SCALE_INT_BITS.SCALE_FRAC_BITS

    wire fifo_empty;
    wire [23:0] fifo_data;
    wire        scaler_re;

    reg         algorithm_sel = 1'b1;
    // reg         algorithm_sel = (mode == 2'b01) ? 1'b1 : 1'b0;  // 0: Bilinear, 1: Nearest Neighbor
    wire [23:0] scaler_data;
    wire        scaler_dataValid;
    FIFO #(
        .FIFO_MODE ("Normal"),  //"Normal"; //"ShowAhead"
        .DATA_WIDTH(24),
        .FIFO_DEPTH(1024)
    ) FIFO (
        /*i*/.Reset(pre_vs),  // System Reset

        /*i*/.WrClk (pre_clk),  // (I)Wirte Clock
        /*i*/.WrEn  (pre_de),   // (I)Write Enable
        /*o*/.WrDNum(),         // (O)Write Data Number In Fifo
        /*o*/.WrFull(),         // (I)Write Full
        /*i*/.WrData(pre_data), // (I)Write Data

        /*i*/.RdClk  (post_clk),     // (I)Read Clock
        /*i*/.RdEn   (scaler_re),    // (I)Read Enable
        /*o*/.RdDNum (),             // (O)Radd Data Number In Fifo
        /*o*/.RdEmpty(fifo_empty),  // (O)Read FifoEmpty
        /*o*/.RdData (fifo_data)    // (O)Read Data
    );

    streamScaler #(
        .DATA_WIDTH        (DATA_WIDTH),
        .CHANNELS          (CHANNELS),
        .DISCARD_CNT_WIDTH (DISCARD_CNT_WIDTH),
        .INPUT_X_RES_WIDTH (INPUT_X_RES_WIDTH),
        .INPUT_Y_RES_WIDTH (INPUT_Y_RES_WIDTH),
        .OUTPUT_X_RES_WIDTH(OUTPUT_X_RES_WIDTH),
        .OUTPUT_Y_RES_WIDTH(OUTPUT_Y_RES_WIDTH),
        .BUFFER_SIZE       (BUFFER_SIZE),  // Number of RAMs in RAM ring buffer
        .FRACTION_BITS     (FRACTION_BITS),
        .SCALE_INT_BITS    (SCALE_INT_BITS),
        .SCALE_FRAC_BITS   (SCALE_FRAC_BITS)
    ) streamScaler (
        .clk(post_clk),

        .dIn     (fifo_data),
        .dInValid(scaler_re & ~fifo_empty),
        .nextDin (scaler_re),
        .start   (pre_vs),

        .dOut     (scaler_data),
        .dOutValid(scaler_dataValid),
        .nextDout (1'b1),

        // Control
        .inputXRes (inputXRes),  // Input data number of pixels per line
        .inputYRes (inputYRes),
        .outputXRes(outputXRes),  // Resolution of output data
        .outputYRes(outputYRes),
        .xScale    (xScale),  // Scaling factors. Input resolution scaled by 1/xScale. Format Q4.14
        .yScale    (yScale),  // Scaling factors. Input resolution scaled by 1/yScale. Format Q4.14

        .nearestNeighbor(algorithm_sel),
        .inputDiscardCnt(0),  // Number of input pixels to discard before processing data. Used for clipping
        .leftOffset     (0),
        .topFracOffset  (0)
    );

    assign post_vs   = pre_vs;
    assign post_de   = EN ? scaler_dataValid : pre_de;
    assign post_data = EN ? scaler_data : pre_data;

endmodule


module streamScaler #(
    // ---------------------------Parameters----------------------------------------
    parameter DATA_WIDTH = 8,  // Width of input/output data
    parameter CHANNELS = 3,  // Number of channels of DATA_WIDTH, for color images
    parameter DISCARD_CNT_WIDTH = 8,  // Width of inputDiscardCnt
    parameter INPUT_X_RES_WIDTH = 11,  // Widths of input/output resolution control signals
    parameter INPUT_Y_RES_WIDTH = 11,
    parameter OUTPUT_X_RES_WIDTH = 11,
    parameter OUTPUT_Y_RES_WIDTH = 11,
    parameter FRACTION_BITS = 8,  // Number of bits for fractional component of coefficients.

    parameter SCALE_INT_BITS = 4,  // Width of integer component of scaling factor. The maximum input data width to
    // multipliers created will be SCALE_INT_BITS + SCALE_FRAC_BITS. Typically these
    // values will sum to 18 to match multipliers available in FPGAs.
    parameter SCALE_FRAC_BITS = 14,  // Width of fractional component of scaling factor
    parameter BUFFER_SIZE = 4,  // Depth of RFIFO
    // ---------------------Non-user-definable parameters----------------------------
    parameter COEFF_WIDTH = FRACTION_BITS + 1,
    parameter SCALE_BITS = SCALE_INT_BITS + SCALE_FRAC_BITS,
    parameter BUFFER_SIZE_WIDTH = ((BUFFER_SIZE+1) <= 2) ? 1 :  // wide enough to hold value BUFFER_SIZE + 1
                                    ((BUFFER_SIZE+1) <= 4) ? 2 :
                                    ((BUFFER_SIZE+1) <= 8) ? 3 :
                                    ((BUFFER_SIZE+1) <= 16) ? 4 :
                                    ((BUFFER_SIZE+1) <= 32) ? 5 :
                                    ((BUFFER_SIZE+1) <= 64) ? 6 : 7
) (
    // ---------------------------Module IO-----------------------------------------
    // Clock and reset
    input wire clk,

    // User interface
    // Input
    input  wire [DATA_WIDTH*CHANNELS-1:0] dIn,
    input  wire                           dInValid,
    output wire                           nextDin,
    input  wire                           start,

    // Output
    output reg [DATA_WIDTH*CHANNELS-1:0] dOut,
    output reg dOutValid = 0,  // latency of 4 clock cycles after nextDout is asserted
    input wire nextDout,

    // Control
    input wire [DISCARD_CNT_WIDTH-1:0] inputDiscardCnt,  // Number of input pixels to discard before processing data. Used for clipping
    input wire [INPUT_X_RES_WIDTH-1:0] inputXRes,  // Resolution of input data minus 1
    input wire [INPUT_Y_RES_WIDTH-1:0] inputYRes,
    input wire [OUTPUT_X_RES_WIDTH-1:0] outputXRes,  // Resolution of output data minus 1
    input wire [OUTPUT_Y_RES_WIDTH-1:0] outputYRes,
    input wire [SCALE_BITS-1:0] xScale,  // Scaling factors. Input resolution scaled up by 1/xScale. Format Q SCALE_INT_BITS.SCALE_FRAC_BITS
    input wire [SCALE_BITS-1:0] yScale,  // Scaling factors. Input resolution scaled up by 1/yScale. Format Q SCALE_INT_BITS.SCALE_FRAC_BITS

    input wire [OUTPUT_X_RES_WIDTH-1+SCALE_FRAC_BITS:0] leftOffset,  // Integer/fraction of input pixel to offset output data horizontally right. Format Q OUTPUT_X_RES_WIDTH.SCALE_FRAC_BITS
    input wire [SCALE_FRAC_BITS-1:0] topFracOffset,  // Fraction of input pixel to offset data vertically down. Format Q0.SCALE_FRAC_BITS
    input wire nearestNeighbor  // Use nearest neighbor resize instead of bilinear
);
    // -----------------------Internal signals and registers------------------------
    reg advanceRead1 = 0;
    reg advanceRead2 = 0;

    wire [DATA_WIDTH*CHANNELS-1:0] readData00;
    wire [DATA_WIDTH*CHANNELS-1:0] readData01;
    wire [DATA_WIDTH*CHANNELS-1:0] readData10;
    wire [DATA_WIDTH*CHANNELS-1:0] readData11;
    reg [DATA_WIDTH*CHANNELS-1:0] readData00Reg = {DATA_WIDTH * CHANNELS{1'bz}};
    reg [DATA_WIDTH*CHANNELS-1:0] readData01Reg = {DATA_WIDTH * CHANNELS{1'bz}};
    reg [DATA_WIDTH*CHANNELS-1:0] readData10Reg = {DATA_WIDTH * CHANNELS{1'bz}};
    reg [DATA_WIDTH*CHANNELS-1:0] readData11Reg = {DATA_WIDTH * CHANNELS{1'bz}};

    wire [INPUT_X_RES_WIDTH-1:0] readAddress;

    reg readyForRead = 0;  // Indicates two full lines have been put into the buffer
    reg [OUTPUT_Y_RES_WIDTH-1:0] outputLine = 0;  // which output video line we're on
    reg [OUTPUT_X_RES_WIDTH-1:0] outputColumn = 0;  // which output video column we're on
    reg [INPUT_X_RES_WIDTH-1+SCALE_FRAC_BITS:0] xScaleAmount = 0;  // Fractional and integer components of input pixel select (multiply result)
    reg [INPUT_Y_RES_WIDTH-1+SCALE_FRAC_BITS:0] yScaleAmount = 0;  // Fractional and integer components of input pixel select (multiply result)
    reg [INPUT_Y_RES_WIDTH-1+SCALE_FRAC_BITS:0] yScaleAmountNext = 0; // Fractional and integer components of input pixel select (multiply result)
    wire [BUFFER_SIZE_WIDTH-1:0] fillCount;  // Numbers used rams in the ram fifo
    reg lineSwitchOutputDisable = 0;  // On the end of an output line, disable the output for one cycle to let the RAM data become valid
    reg dOutValidInt = 0;

    reg [COEFF_WIDTH-1:0] xBlend = 0;
    wire [COEFF_WIDTH-1:0] yBlend = {1'b0, yScaleAmount[SCALE_FRAC_BITS-1:SCALE_FRAC_BITS-FRACTION_BITS]};

    wire [INPUT_X_RES_WIDTH-1:0] xPixLow = xScaleAmount[INPUT_X_RES_WIDTH-1+SCALE_FRAC_BITS:SCALE_FRAC_BITS];
    wire [INPUT_Y_RES_WIDTH-1:0] yPixLow = yScaleAmount[INPUT_Y_RES_WIDTH-1+SCALE_FRAC_BITS:SCALE_FRAC_BITS];
    wire [INPUT_Y_RES_WIDTH-1:0] yPixLowNext = yScaleAmountNext[INPUT_Y_RES_WIDTH-1+SCALE_FRAC_BITS:SCALE_FRAC_BITS];

    wire allDataWritten;  // Indicates that all data from input has been read in
    reg [1:0] readState = 0;

    // States for read state machine
    localparam RS_START = 0;
    localparam RS_READ_LINE = 1;
    localparam RS_DONE = 3;

    // Read state machine
    // Controls the RFIFO(ram FIFO) readout and generates output data valid signals
    always @(posedge clk or posedge start) begin
        if (start) begin
            outputLine <= 0;
            outputColumn <= 0;
            xScaleAmount <= 0;
            yScaleAmount <= 0;
            readState <= RS_START;
            dOutValidInt <= 0;
            lineSwitchOutputDisable <= 0;
            advanceRead1 <= 0;
            advanceRead2 <= 0;
            yScaleAmountNext <= 0;
        end else begin
            case (readState)
                RS_START: begin
                    xScaleAmount <= leftOffset;
                    yScaleAmount <= {{INPUT_Y_RES_WIDTH{1'b0}}, topFracOffset};
                    if (readyForRead) begin
                        readState <= RS_READ_LINE;
                        dOutValidInt <= 1;
                    end
                end
                RS_READ_LINE: begin
                    // outputLine goes through all output lines, and the logic determines which input lines to read into the RRB and which ones to discard.
                    if (nextDout && dOutValidInt) begin
                        if (outputColumn == outputXRes) begin  // On the last input pixel of the line
                            if(yPixLowNext == (yPixLow + 1)) begin // If the next input line is only one greater, advance the RRB by one only
                                advanceRead1 <= 1;
                                if(fillCount < 3)  // If the RRB doesn't have enough data, stop reading it out
                                    dOutValidInt <= 0;
                            end
                        else if(yPixLowNext > (yPixLow + 1)) begin  // If the next input line is two or more greater, advance the read by two
                                advanceRead2 <= 1;
                                if(fillCount < 4)  // If the RRB doesn't have enough data, stop reading it out
                                    dOutValidInt <= 0;
                            end

                            if (outputLine == outputYRes) readState <= RS_DONE;

                            outputColumn <= 0;
                            xScaleAmount <= leftOffset;
                            outputLine <= outputLine + 1;
                            yScaleAmount <= yScaleAmountNext;
                            lineSwitchOutputDisable <= 1;
                        end else begin
                            // Advance the output pixel selection values except when waiting for the ram data to become valid
                            if (lineSwitchOutputDisable == 0) begin
                                outputColumn <= outputColumn + 1;
                                xScaleAmount <= (outputColumn + 1) * xScale + leftOffset;
                            end
                            advanceRead1 <= 0;
                            advanceRead2 <= 0;
                            lineSwitchOutputDisable <= 0;
                        end
                    end else begin  // else from if(nextDout && dOutValidInt)
                        advanceRead1 <= 0;
                        advanceRead2 <= 0;
                        lineSwitchOutputDisable <= 0;
                    end

                    // Once the RRB has enough data, let data be read from it. If all input data has been written, always allow read
                    if (fillCount >= 2 && dOutValidInt == 0 || allDataWritten) begin
                        if ((!advanceRead1 && !advanceRead2)) begin
                            dOutValidInt <= 1;
                            // lineSwitchOutputDisable <= 0;
                        end
                    end
                end  // state RS_READ_LINE:
                RS_DONE: begin
                    advanceRead1 <= 0;
                    advanceRead2 <= 0;
                    dOutValidInt <= 0;
                end
            endcase
            // yScaleAmountNext is used to determine which input lines are valid.
            yScaleAmountNext <= (outputLine + 1) * yScale + {{OUTPUT_Y_RES_WIDTH{1'b0}}, topFracOffset};
        end
    end

    assign readAddress = xPixLow;

    // Generate dOutValid signal, delayed to account for delays in data path
    reg dOutValid_1 = 0;
    reg dOutValid_2 = 0;
    reg dOutValid_3 = 0;
    always @(posedge clk or posedge start) begin
        if (start) begin
            dOutValid_1 <= 0;
            dOutValid_2 <= 0;
            dOutValid_3 <= 0;
            dOutValid   <= 0;
        end else begin
            dOutValid_1 <= nextDout && dOutValidInt && !lineSwitchOutputDisable;
            dOutValid_2 <= dOutValid_1;
            dOutValid_3 <= dOutValid_2;
            dOutValid   <= dOutValid_3;
            //  dOutValid <= dOutValid_2;
        end
    end

    // -----------------------Output data generation-----------------------------
    // Scale amount values are used to generate coefficients for the four pixels coming out of the RRB to be multiplied with.

    // Coefficients for each of the four pixels
    // Format Q1.FRACTION_BITS
    // yx
    reg [COEFF_WIDTH-1:0] coeff00 = 0;  // Top left
    reg [COEFF_WIDTH-1:0] coeff01 = 0;  // Top right
    reg [COEFF_WIDTH-1:0] coeff10 = 0;  // Bottom left
    reg [COEFF_WIDTH-1:0] coeff11 = 0;  // Bottom right

    // Coefficient value of one, format Q1.COEFF_WIDTH-1
    wire [COEFF_WIDTH-1:0] coeffOne = {1'b1, {(COEFF_WIDTH - 1) {1'b0}}};  // One in MSb, zeros elsewhere
    // Coefficient value of one half, format Q1.COEFF_WIDTH-1
    wire [COEFF_WIDTH-1:0] coeffHalf = {2'b01, {(COEFF_WIDTH - 2) {1'b0}}};

    // Compute bilinear interpolation coefficinets. Done here because these pre-registerd values are used twice.
    // Adding coeffHalf to get the nearest value.
    wire [COEFF_WIDTH-1:0]	preCoeff00 = (((coeffOne - xBlend) * (coeffOne - yBlend) + (coeffHalf - 1)) >> FRACTION_BITS) & {{COEFF_WIDTH{1'b0}}, {COEFF_WIDTH{1'b1}}};
    wire [COEFF_WIDTH-1:0]	preCoeff01 = ((xBlend * (coeffOne - yBlend) + (coeffHalf - 1)) >> FRACTION_BITS) & {{COEFF_WIDTH{1'b0}}, {COEFF_WIDTH{1'b1}}};
    wire [COEFF_WIDTH-1:0]	preCoeff10 = (((coeffOne - xBlend) * yBlend + (coeffHalf - 1)) >> FRACTION_BITS) & {{COEFF_WIDTH{1'b0}}, {COEFF_WIDTH{1'b1}}};

    // Compute the coefficients
    always @(posedge clk or posedge start) begin
        if (start) begin
            coeff00 <= 0;
            coeff01 <= 0;
            coeff10 <= 0;
            coeff11 <= 0;
            xBlend  <= 0;
        end else begin
            xBlend <= {1'b0, xScaleAmount[SCALE_FRAC_BITS-1:SCALE_FRAC_BITS-FRACTION_BITS]};  // Changed to registered to improve timing
            if (nearestNeighbor == 1'b0) begin
                // Normal bilinear interpolation
                coeff00 <= preCoeff00;
                coeff01 <= preCoeff01;
                coeff10 <= preCoeff10;
                coeff11 <= ((xBlend * yBlend + (coeffHalf - 1)) >> FRACTION_BITS) &	{{COEFF_WIDTH{1'b0}}, {COEFF_WIDTH{1'b1}}};
                // coeff11 <= coeffOne - preCoeff00 - preCoeff01 - preCoeff10;  // Guarantee that all coefficients sum to coeffOne. Saves a multiply too. Reverted to previous method due to timing issues.
            end else begin
                // Nearest neighbor interploation, set one coefficient to 1.0, the rest to zero based on the fractions
                coeff00 <= xBlend < coeffHalf && yBlend < coeffHalf ? coeffOne : {COEFF_WIDTH{1'b0}};
                coeff01 <= xBlend >= coeffHalf && yBlend < coeffHalf ? coeffOne : {COEFF_WIDTH{1'b0}};
                coeff10 <= xBlend < coeffHalf && yBlend >= coeffHalf ? coeffOne : {COEFF_WIDTH{1'b0}};
                coeff11 <= xBlend >= coeffHalf && yBlend >= coeffHalf ? coeffOne : {COEFF_WIDTH{1'b0}};
            end
        end
    end


    // Generate the blending multipliers
    reg [(DATA_WIDTH+COEFF_WIDTH)*CHANNELS-1:0] product00, product01, product10, product11;
    reg fix = 0;
    always @(posedge clk) begin
        fix <= readAddress == inputXRes;
    end
    generate
        genvar channel;
        for (channel = 0; channel < CHANNELS; channel = channel + 1) begin : blend_mult_generate
            always @(posedge clk or posedge start) begin
                if (start) begin
                    // productxx[channel] <= 0;
                    product00[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= 0;
                    product01[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= 0;
                    product10[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= 0;
                    product11[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= 0;

                    // readDataxxReg[channel] <= 0;
                    readData00Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= 0;
                    readData01Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= 0;
                    readData10Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= 0;
                    readData11Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= 0;

                    // dOut[channel] <= 0;
                    dOut[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= 0;
                end else begin
                    // readDataxxReg[channel] <= readDataxx[channel];
                    readData00Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= readData00[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel];
                    if (fix)
                        readData01Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= readData00[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel];
                    else
                        readData01Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= readData01[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel];
                    readData10Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= readData10[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel];
                    if (fix)
                        readData11Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= readData10[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel];
                    else
                        readData11Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <= readData11[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel];

                    // productxx[channel] <= readDataxxReg[channel] * coeffxx
                    product00[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= readData00Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] * coeff00;
                    product01[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= readData01Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] * coeff01;
                    product10[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= readData10Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] * coeff10;
                    product11[(DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel] <= readData11Reg[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] * coeff11;

                    // dOut[channel] <= (((product00[channel]) + 
                    //                   (product01[channel]) +
                    //                   (product10[channel]) +
                    //                   (product11[channel])) >> FRACTION_BITS) & ({ {COEFF_WIDTH{1'b0}}, {DATA_WIDTH{1'b1}} });
                    dOut[DATA_WIDTH*(channel+1)-1 : DATA_WIDTH*channel] <=
                        (((product00[ (DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel]) + 
                        (product01[ (DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel]) +
                        (product10[ (DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel]) +
                        (product11[ (DATA_WIDTH+COEFF_WIDTH)*(channel+1)-1 : (DATA_WIDTH+COEFF_WIDTH)*channel])) >> FRACTION_BITS) & ({ {COEFF_WIDTH{1'b0}}, {DATA_WIDTH{1'b1}} });
                end
            end
        end
    endgenerate


    // ---------------------------Data write logic----------------------------------
    // Places input data into the correct ram in the RFIFO (ram FIFO)
    // Controls writing to the RFIFO, and discards lines that arn't used
    reg [INPUT_Y_RES_WIDTH-1:0] writeNextValidLine = 0;	// Which line greater than writeRowCount is the next one that must be read in
    reg [INPUT_Y_RES_WIDTH-1:0] writeNextPlusOne = 0;	// One greater than writeNextValidLine, because we must always read in two adjacent lines
    reg [INPUT_Y_RES_WIDTH-1:0] writeRowCount = 0;  // Which line we're reading from dIn
    reg [OUTPUT_Y_RES_WIDTH-1:0] writeOutputLine = 0;  // The output line that corresponds to the input line. This is incremented until writeNextValidLine is greater than writeRowCount
    reg getNextPlusOne = 0;  // Flag so that writeNextPlusOne is captured only once after writeRowCount >= writeNextValidLine. This is in case multiple cycles are requred until writeNextValidLine changes.

    // Determine which lines to read out and which to discard.
    // writeNextValidLine is the next valid line number that needs to be read out above current value writeRowCount
    // writeNextPlusOne also needs to be read out (to do interpolation), this may or may not be equal to writeNextValidLine
    always @(posedge clk or posedge start) begin
        if (start) begin
            writeOutputLine <= 0;
            writeNextValidLine <= 0;
            writeNextPlusOne <= 1;
            getNextPlusOne <= 1;
        end else begin
            if(writeRowCount >= writeNextValidLine) begin  // When writeRowCount becomes higher than the next valid line to read out, comptue the next valid line.
                if(getNextPlusOne) begin  // Keep writeNextPlusOne
                    writeNextPlusOne <= writeNextValidLine + 1;
                end
                getNextPlusOne <= 0;
                writeOutputLine <= writeOutputLine + 1;
                writeNextValidLine <= ((writeOutputLine*yScale + {{(OUTPUT_Y_RES_WIDTH + SCALE_INT_BITS){1'b0}}, topFracOffset}) >> SCALE_FRAC_BITS) & {{SCALE_BITS{1'b0}}, {OUTPUT_Y_RES_WIDTH{1'b1}}};
            end else begin
                getNextPlusOne <= 1;
            end
        end
    end

    reg  discardInput = 0;
    reg  [DISCARD_CNT_WIDTH-1:0] discardCountReg = 0;
    wire advanceWrite;
    reg  [ 1:0] writeState = 0;
    reg  [INPUT_X_RES_WIDTH-1:0] writeColCount = 0;
    reg  enableNextDin = 0;
    reg  forceRead = 0;

    // Write state machine
    // Controls writing scaler input data into the RRB
    localparam WS_START = 0;
    localparam WS_DISCARD = 1;
    localparam WS_READ = 2;
    localparam WS_DONE = 3;

    // Control write and address signals to write data into ram FIFO
    always @(posedge clk or posedge start) begin
        if (start) begin
            writeState <= WS_START;
            enableNextDin <= 0;
            discardInput <= 0;
            readyForRead <= 0;
            writeRowCount <= 0;
            writeColCount <= 0;
            discardCountReg <= 0;
            forceRead <= 0;
        end else begin
            case (writeState)
                WS_START: begin
                    discardCountReg <= inputDiscardCnt;
                    if (inputDiscardCnt > 0) begin
                        discardInput <= 1;
                        enableNextDin <= 1;
                        writeState <= WS_DISCARD;
                    end else begin
                        discardInput <= 0;
                        enableNextDin <= 1;
                        writeState <= WS_READ;
                    end
                    discardInput <= (inputDiscardCnt > 0) ? 1'b1 : 1'b0;
                end
                WS_DISCARD:	begin  // Discard pixels from input data
                    if (dInValid) begin
                        discardCountReg <= discardCountReg - 1;
                        if ((discardCountReg - 1) == 0) begin
                            discardInput <= 0;
                            writeState   <= WS_READ;
                        end
                    end
                end
                WS_READ: begin
                    if (dInValid & nextDin) begin
                        if(writeColCount == inputXRes) begin  // Occurs on the last pixel in the line
                            if((writeNextValidLine == writeRowCount + 1) ||
							(writeNextPlusOne == writeRowCount + 1)) begin  // Next line is valid, write into buffer
                                discardInput <= 0;
                            end else begin  // Next line is not valid, discard
                                discardInput <= 1;
                            end

                            // Once writeRowCount is >= 2, data is ready to start being output.
                            // if(writeRowCount[1])
                            //      readyForRead <= 1;
                            if (writeRowCount == 1) readyForRead <= 1;

                            if(writeRowCount == inputYRes) begin  // When all data has been read in, stop reading.
                                writeState <= WS_DONE;
                                enableNextDin <= 0;
                                forceRead <= 1;
                            end

                            writeColCount <= 0;
                            writeRowCount <= writeRowCount + 1;
                        end else begin
                            writeColCount <= writeColCount + 1;
                        end
                    end
                end
                WS_DONE: begin
                    // do nothing, wait for reset
                end
            endcase
        end
    end

    // Advance write whenever we have just written a valid line (discardInput == 0)
    // Generate this signal one earlier than discardInput above that uses the same conditions, to advance the buffer at the right time.
    assign advanceWrite = (writeColCount == inputXRes) & (discardInput == 0) & dInValid & nextDin;
    assign allDataWritten = writeState == WS_DONE;
    assign nextDin = (fillCount < BUFFER_SIZE) & enableNextDin;

    ramFifo #(
        .DATA_WIDTH(DATA_WIDTH * CHANNELS),
        .ADDRESS_WIDTH(INPUT_X_RES_WIDTH),  // Controls width of RAMs
        .BUFFER_SIZE(BUFFER_SIZE)  // Number of RAMs
    ) ramFifo (
        .clk         (clk),
        .rst         (start),
        .advanceRead1(advanceRead1),
        .advanceRead2(advanceRead2),
        .advanceWrite(advanceWrite),
        .forceRead   (forceRead),

        .writeData   (dIn),
        .writeAddress(writeColCount),
        .writeEnable (dInValid & nextDin & enableNextDin & ~discardInput),
        .fillCount   (fillCount),

        .readData00 (readData00),
        .readData01 (readData01),
        .readData10 (readData10),
        .readData11 (readData11),
        .readAddress(readAddress)
    );

endmodule  // scaler


//---------------------------Ram FIFO (RFIFO)-----------------------------
// FIFO buffer with rams as the elements, instead of data
// One ram is filled, while two others are simultaneously read out.
// Four neighboring pixels are read out at once, at the selected RAM and one line down, and at readAddress and readAddress + 1
module ramFifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS_WIDTH = 8,
    parameter BUFFER_SIZE = 2,
    parameter BUFFER_SIZE_WIDTH = ((BUFFER_SIZE + 1) <= 2) ? 1 :  // wide enough to hold value BUFFER_SIZE + 1
    ((BUFFER_SIZE + 1) <= 4) ? 2 : ((BUFFER_SIZE + 1) <= 8) ? 3 : ((BUFFER_SIZE + 1) <= 16) ? 4 : ((BUFFER_SIZE + 1) <= 32) ? 5 : ((BUFFER_SIZE + 1) <= 64) ? 6 : 7
) (
    input wire clk,
    input wire rst,
    input wire advanceRead1,  // Advance selected read RAM by one 
    input wire advanceRead2,  // Advance selected read RAM by two 
    input wire advanceWrite,  // Advance selected write RAM by one
    input wire forceRead,     // Disables writing to allow all data to be read out (RAM being written to cannot be read from normally)

    input  wire [       DATA_WIDTH-1:0] writeData,
    input  wire [    ADDRESS_WIDTH-1:0] writeAddress,
    input  wire                         writeEnable,
    output reg  [BUFFER_SIZE_WIDTH-1:0] fillCount = 0,

    // yx
    output wire [   DATA_WIDTH-1:0] readData00,  // Read from deepest RAM (earliest data), at readAddress
    output wire [   DATA_WIDTH-1:0] readData01,  // Read from deepest RAM (earliest data), at readAddress + 1
    output wire [   DATA_WIDTH-1:0] readData10,  // Read from second deepest RAM (second earliest data), at readAddress
    output wire [   DATA_WIDTH-1:0] readData11,  // Read from second deepest RAM (second earliest data), at readAddress + 1
    input  wire [ADDRESS_WIDTH-1:0] readAddress
);

    reg [BUFFER_SIZE-1:0] writeSelect = 1;
    reg [BUFFER_SIZE-1:0] readSelect = 1;

    // Read select ring register
    always @(posedge clk or posedge rst) begin
        if (rst) readSelect <= 1;
        else begin
            if (advanceRead1) begin
                readSelect <= {readSelect[BUFFER_SIZE-2 : 0], readSelect[BUFFER_SIZE-1]};
            end else if (advanceRead2) begin
                readSelect <= {readSelect[BUFFER_SIZE-3 : 0], readSelect[BUFFER_SIZE-1:BUFFER_SIZE-2]};
            end
        end
    end

    // Write select ring register
    always @(posedge clk or posedge rst) begin
        if (rst) writeSelect <= 1;
        else begin
            if (advanceWrite) begin
                writeSelect <= {writeSelect[BUFFER_SIZE-2 : 0], writeSelect[BUFFER_SIZE-1]};
            end
        end
    end

    wire [DATA_WIDTH-1:0] ramDataOutA[2**BUFFER_SIZE-1:0];
    wire [DATA_WIDTH-1:0] ramDataOutB[2**BUFFER_SIZE-1:0];

    // Generate to instantiate the RAMs
    generate
        genvar i;
        for (i = 0; i < BUFFER_SIZE; i = i + 1) begin
            ramDualPort #(
                .DATA_WIDTH(DATA_WIDTH),
                .ADDRESS_WIDTH(ADDRESS_WIDTH)
            ) ramDualPort (
                .clk(clk),
                // Port A is written to as well as read from. When writing, this port cannot be read from.
                // As long as the buffer is large enough, this will not cause any problem.
                .addrA(((writeSelect[i] == 1'b1) && !forceRead && writeEnable) ? writeAddress : readAddress),  //&& writeEnable is 
                // to allow the full buffer to be used. After the buffer is filled, write is advanced, so writeSelect
                // and readSelect are the same. The full buffer isn't written to, so this allows the read to work properly.
                .dataA(writeData),
                .weA  (((writeSelect[i] == 1'b1) && !forceRead) ? writeEnable : 1'b0),
                .qA   (ramDataOutA[2**i]),

                .addrB(readAddress + 1),
                .dataB(0),
                .weB  (1'b0),
                .qB   (ramDataOutB[2**i])
            );
        end
    endgenerate

    // Select which ram to read from
    wire [BUFFER_SIZE-1:0] readSelect0 = readSelect;
    wire [BUFFER_SIZE-1:0] readSelect1 = (readSelect << 1) | readSelect[BUFFER_SIZE-1];

    // Steer the output data to the right ports
    assign readData00 = ramDataOutA[readSelect0];
    assign readData10 = ramDataOutA[readSelect1];
    assign readData01 = ramDataOutB[readSelect0];
    assign readData11 = ramDataOutB[readSelect1];

    // Keep track of fill level
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fillCount <= 0;
        end else begin
            if (advanceWrite) begin
                if (advanceRead1) fillCount <= fillCount;
                else if (advanceRead2) fillCount <= fillCount - 1;
                else fillCount <= fillCount + 1;
            end else begin
                if (advanceRead1) fillCount <= fillCount - 1;
                else if (advanceRead2) fillCount <= fillCount - 2;
                else fillCount <= fillCount;
            end
        end
    end

endmodule  // ramFifo


// Dual port RAM
module ramDualPort #(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS_WIDTH = 8
) (
    input wire [(DATA_WIDTH-1):0] dataA, dataB,
    input wire [(ADDRESS_WIDTH-1):0] addrA, addrB,
    input wire weA, weB, clk,
    output reg [(DATA_WIDTH-1):0] qA, qB
);

    // Declare the RAM variable
    reg [DATA_WIDTH-1:0] ram[2**ADDRESS_WIDTH-1:0];

    // Port A
    always @(posedge clk) begin
        if (weA) begin
            ram[addrA] <= dataA;
            qA <= dataA;
        end else begin
            qA <= ram[addrA];
        end
    end

    // Port B
    always @(posedge clk) begin
        if (weB) begin
            ram[addrB] <= dataB;
            qB <= dataB;
        end else begin
            qB <= ram[addrB];
        end
    end

endmodule  //ramDualPort


/*例化模板和参数说明
    // System Signal
    // 复位信号输入；高电平有效
    // 内部做复位同步，保证两个时钟域都复位了才开始工作；
    wire Reset;  // System Reset

    // Write Signal
    // 写时钟输入；上升沿有效
    wire WrClk;  // (I)Wirte Clock
    // 写允许信号；高电平有效
    wire WrEn;  // (I)Write Enable
    // 写数据输入；
    wire [DW_C-1:0] WrData;  // (I)Write Data
    // 数据个数；表示从WrClk时钟域中FIFO中数据的个数
    // 由于读写时钟不在一个时钟域，该值可能会不连续
    // 可以使用数据个数（WrDNum）在 WrClk 时钟域实现
    // Almostfull 、 AlmostEmpty、 WrEmpty 信号
    wire [AW_C-1:0] WrDNum;  // (O)Write Data Number In Fifo
    //满信号；有效时，WrEn无效
    wire WrFull;  // (O)Write Full

    // Read Signal    
    // 读时钟输入；上升沿有效
    wire RdClk;  // (I)Read Clock
    // 读允许信号；高电平有效
    wire RdEn;  // (I)Read Enable
    // 读数据输出；
    wire [DW_C-1:0] RdData;  // (O)Read Data
    // 数据个数；表示从 RdClk 时钟域中FIFO中数据的个数
    // 由于读写时钟不在一个时钟域，该值可能会不连续
    // 可以使用数据个数（RdDNum）在 RdClk 时钟域实现
    // Almostfull 、 AlmostEmpty、 Rdfull 信号
    wire [AW_C-1:0] RdDNum;  // (O)Radd Data Number In Fifo
    // 指示当前的数据有效
    wire DataVal;  // (O)Data Valid 
    // 空信号；有效时 RdEn 无效
    wire RdEmpty;  // (O)Read FifoEmpty

    // FIFO数据输出模式： "Normal" & "ShowAhead"
    // Normal : RdEn 有效的下一个时钟周期出数据
    // ShowAhead ：RdEn 有效，数据有效
    // 仅对数据输出有影响
    defparam UX_XXXXXXXXXXXXX.FIFO_MODE = "Normal", //"Normal"; //"ShowAhead"
    // 数据宽度
    defparam UX_XXXXXXXXXXXXX.DATA_WIDTH = 8,
    // FIFO深度
    // FIFO深度会自动使用满足设置的2的n次方作为深度设置
    defparam UX_XXXXXXXXXXXXX.FIFO_DEPTH = 512

    ///////////////////////////
    DC_FIFO UX_XXXXXXXXXXXXX(
        // System Signal
        .Reset    ( Reset   ),  // System Reset
        // Write Signal
        .WrClk    ( WrClk   ),  // (I)Wirte Clock
        .WrEn     ( WrEn    ),  // (I)Write Enable
        .WrDNum   ( WrDNum  ),  // (O)Write Data Number In Fifo
        .WrFull   ( WrFull  ),  // (O)Write Full
        .WrData   ( WrData  ),  // (I)Write Data
        // Read Signal
        .RdClk    ( RdClk   ),  // (I)Read Clock
        .RdEn     ( RdEn    ),  // (I)Read Enable
        .RdDNum   ( RdDNum  ),  // (O)Radd Data Number In Fifo
        .RdEmpty  ( RdEmpty ),  // (O)Read FifoEmpty
        .DataVal  ( DataVal ),  // (O)Data Valid
        .RdData   ( RdData  )   // (O)Read Data
    );
    ///////////////////////////
*/

module FIFO #(
  	parameter FIFO_MODE  = "Normal"          ,  //"Normal"; //"ShowAhead"
    parameter DATA_WIDTH = 8                 ,
    parameter FIFO_DEPTH = 512               ,
    parameter AW_C       = $clog2(FIFO_DEPTH),
    parameter DW_C       = DATA_WIDTH        ,
    parameter DD_C       = 2**AW_C
)(   
    // System Signal
    input                 Reset   ,  // System Reset
    // Write Signal
    input                 WrClk   ,  // (I)Wirte Clock
    input                 WrEn    ,  // (I)Write Enable
    output  [AW_C  :0]    WrDNum  ,  // (O)Write Data Number In Fifo
    output                WrFull  ,  // (O)Write Full
    input   [DW_C -1:0]   WrData  ,  // (I)Write Data
    // Read Signal
    input                 RdClk   ,  // (I)Read Clock
    input                 RdEn    ,  // (I)Read Enable
    output  [AW_C  :0]    RdDNum  ,  // (O)Radd Data Number In Fifo
    output                RdEmpty ,  // (O)Read FifoEmpty
    output                DataVal ,  // (O)Data Valid
    output  [DW_C-1 :0]   RdData     // (O)Read Data
);

// Define Parameter
localparam TCo_C = 1;

//********************************************************/
// 将输入的异步复位信号，同步到内部时钟源；
// 保证两个时钟域都接收到了复位信号，才释放同步复位信号	
//********************************************************/
reg  [1:0] WrClkRstGen = 2'h3;
reg  [1:0] RdClkRstGen = 2'h3;

always @(posedge WrClk or posedge Reset) begin
    if(Reset)              WrClkRstGen <= # TCo_C 2'h3;
    else if(&WrClkRstGen)  WrClkRstGen <= # TCo_C 2'h2;
    else if(~&RdClkRstGen) WrClkRstGen <= # TCo_C WrClkRstGen - {1'h0,(|WrClkRstGen)};
end

always @(posedge RdClk or posedge Reset) begin
    if(Reset)              RdClkRstGen <= # TCo_C 2'h3;
    else if(&RdClkRstGen)  RdClkRstGen <= # TCo_C 2'h2;
    else if(~&WrClkRstGen) RdClkRstGen <= # TCo_C RdClkRstGen - {1'h0,(|RdClkRstGen)};
end  

/////////////////////////////////////////////////////////
reg  WrClkRst = 1'h1;
reg  RdClkRst = 1'h1;

always @(posedge WrClk or posedge Reset) begin
    if(Reset) WrClkRst <= # TCo_C 1'h1;
    else WrClkRst <= # TCo_C |WrClkRstGen;
end 
always @(posedge RdClk or posedge Reset) begin
    if(Reset) RdClkRst <= # TCo_C 1'h1;
    else RdClkRst <= # TCo_C |RdClkRstGen;
end
/////////////////////////////////////////////////////////

//********************************************************/
// 写数据到 FifoBuff
// 地址采用格雷码
//********************************************************/
wire           FifoWrEn = WrEn & (~WrFull);
wire [AW_C :0] WrNextAddr;
wire [AW_C :0] FifoWrAddr;
wire           FifoWrFull;

FifoAddrCnt #(
    .CounterWidth_C (AW_C))
U1_WrAddrCnt(
    // System Signal
    .Reset          ( WrClkRst   ),  // System Reset
    .SysClk         ( WrClk      ),  // System Clock
    // Counter Signal            
    .ClkEn          ( FifoWrEn   ),  // (I)Clock Enable
    .FifoFlag       ( FifoWrFull ),  // (I)Fifo Flag
    .AddrCnt        ( WrNextAddr ),  // (O)Next Address
    .Addess         ( FifoWrAddr )   // (O)Address Output
);

///////////////////////////////////////////////////////// 
reg [DW_C-1:0] FifoBuff [DD_C-1:0];

always @(posedge WrClk) begin
    if(WrEn & (~WrFull))
        FifoBuff[FifoWrAddr[AW_C-1:0]] <= # TCo_C WrData;
end
/////////////////////////////////////////////////////////


//********************************************************/
// 从 FifoBuff 中读出数据
// 地址采用格雷码
//********************************************************/
wire           FifoEmpty;
wire           FifoRdEn;
wire [AW_C :0] RdNextAddr;
wire [AW_C :0] FifoRdAddr;

FifoAddrCnt #( 
    .CounterWidth_C (AW_C))
U2_RdAddrCnt(
    // System Signal
    .Reset          ( RdClkRst   ),  // System Reset
    .SysClk         ( RdClk      ),  // System Clock
    // Counter Signal
    .ClkEn          ( FifoRdEn   ),  // (I)Clock Enable
    .FifoFlag       ( FifoEmpty  ),  // (I)Fifo Flag
    .AddrCnt        ( RdNextAddr ),  // (O)Next Address
    .Addess         ( FifoRdAddr )   // (O)Address Output
);

/////////////////////////////////////////////////////////
reg  [DW_C-1 :0] FifoRdData = 0;

always @(posedge RdClk) begin
    if(FifoRdEn) FifoRdData <= # TCo_C FifoBuff[FifoRdAddr[AW_C-1:0]];
end

/////////////////////////////////////////////////////////
assign RdData   =   FifoRdData  ;  // (O)Read Data
/////////////////////////////////////////////////////////


//********************************************************/
// 在写时钟域计算读写地址差
//********************************************************/
// 把读地址搬到写时钟域(WrClk)
reg  [AW_C:0] RdAddrOut = {AW_C+1{1'h0}};
reg  [AW_C:0] WrRdAddr = {AW_C+1{1'h0}};

always @(posedge WrClk)   begin
    if(WrClkRst) WrRdAddr <= # TCo_C {AW_C+1{1'h0}};
    else WrRdAddr <= # TCo_C RdAddrOut [AW_C:0];
end

/////////////////////////////////////////////////////////
// 把读写地址的格雷码转化为16进制
wire [AW_C-1:0] WrRdAHex;
wire [AW_C-1:0] WrWrAHex;
GrayDecode #(AW_C) WRAGray2Hex (WrRdAddr   [AW_C-1:0], WrRdAHex[AW_C-1:0]);
GrayDecode #(AW_C) WWAGray2Hex (FifoWrAddr [AW_C-1:0], WrWrAHex[AW_C-1:0]);

/////////////////////////////////////////////////////////
// 写时钟域中计算读写地址差
reg  [AW_C:0] WrAddrDiff = {AW_C+1{1'h0}};

wire [AW_C:0] Calc_WrAddrDiff = ({FifoWrAddr[AW_C], WrWrAHex} + {{AW_C{1'h0}}, FifoWrEn});
always @(posedge WrClk) begin
    if(WrClkRst) WrAddrDiff <= # TCo_C {AW_C+1{1'h0}};
    else WrAddrDiff <= # TCo_C Calc_WrAddrDiff - {WrRdAddr[AW_C], WrRdAHex};
end

/////////////////////////////////////////////////////////
assign WrDNum = WrAddrDiff;  // (O)Data Number In Fifo
/////////////////////////////////////////////////////////

//********************************************************/
// 计算 WrFull 信号
//********************************************************/
// 产生 WrFull 的清除信号 （ WrFullClr ）
// 当 FifoRdAddr 发生变化，产生 WrFullClr
reg  [AW_C:0] WrRdAddrReg = {AW_C+1{1'h0}};
reg  WrFullClr = 1'h0;

always @(posedge WrClk) begin
    if(WrClkRst) WrRdAddrReg <= # TCo_C {AW_C+1{1'h0}};
    else WrRdAddrReg <= # TCo_C WrRdAddr[AW_C : 0];
end

always @(posedge WrClk) begin
    if(WrClkRst) WrFullClr <= # TCo_C 1'h0;
    else WrFullClr <= # TCo_C (WrRdAddr[AW_C-1:0] != WrRdAddrReg[AW_C-1:0]);
end
  
/////////////////////////////////////////////////////////
// 计算满信号 
reg  RdAHighNext = 1'h0;
wire RdAHighRise = (~WrRdAddrReg[AW_C-1]) & WrRdAddr[AW_C-1];

always @(posedge WrClk) begin
    if(WrClkRst) RdAHighNext <= # TCo_C 1'h0;
    else if(RdAHighRise)RdAHighNext <= # TCo_C (~WrRdAddr[AW_C]);
end

wire FullCalc = (WrNextAddr[AW_C-1:0] == WrRdAddr[AW_C-1:0]) 
                && (WrNextAddr[AW_C] != (WrRdAddr[AW_C-1] ? WrRdAddrReg[AW_C] : RdAHighNext));

///////////////////////////////////////////////////
reg  FullFlag = 1'h0;

always @(posedge WrClk) begin
    if(WrClkRst)      FullFlag <= # TCo_C 1'h0;
    else if(FullFlag) FullFlag <= # TCo_C (~WrFullClr);
    else if(FifoWrEn) FullFlag <= # TCo_C FullCalc;
end

assign FifoWrFull = FullFlag;

///////////////////////////////////////////////////
assign WrFull = FifoWrFull;  // (I)Write Full 
///////////////////////////////////////////////////


//********************************************************/
// 在读时钟域计算读写地址差
//********************************************************/
// 把写地址 （ FifoWrAddr ）搬到读时钟域
reg  [AW_C :0] RdWrAddr = {AW_C+1{1'h0}}; 

always @(posedge RdClk) begin
    if(RdClkRst) RdWrAddr <= # TCo_C {AW_C+1{1'h0}};
    else RdWrAddr <= # TCo_C FifoWrAddr [AW_C:0];
end

/////////////////////////////////////////////////////////
// 根据 FIFO_MODE的设置，产生运算 WrDNum 和 RdDNum 用的 RdAddr
wire ReadEn = (RdEn & (~RdEmpty));

generate
if(FIFO_MODE == "ShowAhead") begin
    always @(posedge RdClk) begin
        if(RdClkRst )   RdAddrOut <= # TCo_C {AW_C+1{1'h0}};
        else if(ReadEn) RdAddrOut <= # TCo_C FifoRdAddr [AW_C:0];
    end
end else begin
    always @(*)RdAddrOut = # TCo_C FifoRdAddr [AW_C:0];
end
endgenerate

/////////////////////////////////////////////////////////
wire [AW_C-1:0] RdWrAHex;
wire [AW_C-1:0] RdRdAHex;
GrayDecode # (AW_C) RWAGray2Hex (RdWrAddr   [AW_C-1:0], RdWrAHex[AW_C-1:0]);
GrayDecode # (AW_C) RRAGray2Hex (RdAddrOut  [AW_C-1:0], RdRdAHex[AW_C-1:0]);

/////////////////////////////////////////////////////////
// 在读时钟域计算地址差  
reg  [AW_C:0] RdAddrDiff = {AW_C+1{1'h0}};

wire [AW_C:0] Calc_RdAddrDiff = ({RdAddrOut[AW_C], RdRdAHex} + {{AW_C{1'h0}}, ReadEn});
always @(posedge RdClk) begin
    if(RdClkRst) RdAddrDiff <= # TCo_C {AW_C+1{1'h0}};
    else RdAddrDiff <= # TCo_C {RdWrAddr[AW_C], RdWrAHex } - Calc_RdAddrDiff;
end

/////////////////////////////////////////////////////////
assign RdDNum = RdAddrDiff;  // (O)Data Number In Fifo
/////////////////////////////////////////////////////////


//********************************************************/
// 计算 RdEmpty 信号
//********************************************************/
// 产生 RdEmpty 的清除信号  
reg  [AW_C:0] RdWrAddrReg = {AW_C+1{1'h0}}; 
reg           EmptyClr    = 1'h0;

always @(posedge RdClk) begin
    if(RdClkRst) RdWrAddrReg <= # TCo_C {AW_C+1{1'h0}};
    else RdWrAddrReg <= # TCo_C RdWrAddr [AW_C:0];
end

always @(posedge RdClk) begin
    if(RdClkRst) EmptyClr <= # TCo_C 1'h0;
    else EmptyClr <= # TCo_C (RdWrAddr[AW_C-1:0] != RdWrAddrReg[AW_C-1:0]);
end

reg  EmptyClrReg = 1'h0;
always @(posedge RdClk ) EmptyClrReg <= EmptyClr;

/////////////////////////////////////////////////////////
// 计算空信号 （EmptyCalc）
reg  WrAHighNext = 1'h0;
wire WrAHighRise = (~RdWrAddrReg[AW_C-1]) & RdWrAddr[AW_C-1];

always @(posedge RdClk) begin
    if(RdClkRst) WrAHighNext <= # TCo_C 1'h0;
    else if(WrAHighRise) WrAHighNext <= # TCo_C (~RdWrAddr[AW_C]);
end
wire EmptyCalc = (RdNextAddr[AW_C-1:0] == RdWrAddr[AW_C-1:0])
                 && (RdNextAddr[AW_C] == (RdWrAddr[AW_C-1] ? RdWrAddrReg[AW_C] : WrAHighNext));

/////////////////////////////////////////////////////////
reg  EmptyFlag = 1'h1;

always @(posedge RdClk) begin
    if(RdClkRst) EmptyFlag <= # TCo_C 1'h1;
    else if(EmptyFlag) EmptyFlag <= # TCo_C ~EmptyClr;
    else if(FifoRdEn) EmptyFlag <= # TCo_C EmptyCalc;
end

assign FifoEmpty = EmptyFlag;

/////////////////////////////////////////////////////////
reg  EmptyReg = 1'h0;

always @(posedge RdClk ) begin
    if(RdClkRst)      EmptyReg <= # TCo_C 1'h1;
    else if(FifoRdEn) EmptyReg <= # TCo_C FifoEmpty;
end

///////////////////////////////////////////////////////// 
assign RdEmpty = (FIFO_MODE == "ShowAhead") ? EmptyReg : FifoEmpty;  // (O)Read FifoEmpty
///////////////////////////////////////////////////////// 

//********************************************************/
//
//********************************************************/
reg  RdFirst = 1'h0;

always @(posedge RdClk) begin
    if(FIFO_MODE == "ShowAhead") begin
        if(RdClkRst) RdFirst <= # TCo_C 1'h0;
        else if(RdFirst) RdFirst <= # TCo_C 1'h0;
        else if(EmptyClr) RdFirst <= # TCo_C RdEmpty;
        else if(EmptyReg ^ EmptyFlag) RdFirst <= # TCo_C RdEmpty;
    end else 
        RdFirst <= # TCo_C 1'h0;
end

/////////////////////////////////////////////////////////
reg  ReadEn_Reg = 1'h0;

always @(posedge RdClk) ReadEn_Reg <= ReadEn;

wire Data_Valid = (FIFO_MODE == "ShowAhead") ? ReadEn : ReadEn_Reg;

///////////////////////////////////////////////////////// 
assign FifoRdEn = ReadEn || RdFirst;
assign DataVal = Data_Valid;  // (O)Data Valid
/////////////////////////////////////////////////////////

endmodule
//////////////// FIFO //////////////////////////////



/**********************************************************
// Module Name:    FifoAddrCnt
**********************************************************/
module FifoAddrCnt #(
    parameter CounterWidth_C = 9,
    parameter CW_C = CounterWidth_C
)(   
    // System Signal
    input             Reset   ,  // System Reset
    input             SysClk  ,  // System Clock
    // Counter Signal            
    input             ClkEn   ,  // (I)Clock Enable 
    input             FifoFlag,  // (I)Fifo Flag
    output  [CW_C:0]  AddrCnt ,  // (O)Address Counter
    output  [CW_C:0]  Addess     // (O)Address Output
);

// Define Parameter
/////////////////////////////////////////////////////////
localparam TCo_C = 1;    
/////////////////////////////////////////////////////////
wire [CW_C-1:0] GrayAddrCnt;
wire            CarryOut;

GrayCnt #(
    .CounterWidth_C (CW_C))
U1_AddrCnt(
    //System Signal
    .Reset    ( Reset       ),  // System Reset
    .SysClk   ( SysClk      ),  // System Clock
    //Counter Signal             
    .SyncClr  ( 1'h0        ),  // (I)Sync Clear
    .ClkEn    ( ClkEn       ),  // (I)Clock Enable 
    .CarryIn  ( ~FifoFlag   ),  // (I)Carry input
    .CarryOut ( CarryOut    ),  // (O)Carry output
    .Count    ( GrayAddrCnt )   // (O)Counter Value Output
);
        
/////////////////////////////////////////////////////////
reg  CntHighBit;

always @(posedge SysClk ) begin
    if(Reset)      CntHighBit <= # TCo_C 1'h0;
    else if(ClkEn) CntHighBit <= # TCo_C CntHighBit + CarryOut;
end

/////////////////////////////////////////////////////////
reg  [CW_C:0] AddrOut;  // (O)Address Output

always @(posedge SysClk) begin
    if(Reset)      AddrOut <= # TCo_C {CW_C{1'h0}};
    else if(ClkEn) AddrOut <= # TCo_C FifoFlag ? AddrOut : AddrCnt;
end    

/////////////////////////////////////////////////////////
assign AddrCnt = {CntHighBit, GrayAddrCnt};  // (O)Next Address           
assign Addess = AddrOut;  // (O)Address Output    
/////////////////////////////////////////////////////////

endmodule
/////////////////// FifoAddrCnt //////////////////////////



/**********************************************************
// Module Name:    GrayCnt
**********************************************************/
module GrayCnt #(
    parameter CounterWidth_C = 9,
    parameter CW_C = CounterWidth_C
)( 
    //System Signal
    input             Reset   ,  // System Reset
    input             SysClk  ,  // System Clock
    //Counter Signal
    input             SyncClr ,  // (I)Sync Clear
    input             ClkEn   ,  // (I)Clock Enable 
    input             CarryIn ,  // (I)Carry input
    output            CarryOut,  // (O)Carry output
    output [CW_C-1:0] Count      // (O)Counter Value Output
);

// Define Parameter
/////////////////////////////////////////////////////////
localparam TCo_C = 1;
/////////////////////////////////////////////////////////
wire [CW_C:0  ] CryIn;
wire [CW_C-1:0] CryOut;
reg  [CW_C-1:0] GrayCnt;
assign CryIn[0] = CarryIn;

genvar i;
generate
for(i=0;i<CW_C;i=i+1) begin : GrayCnt_CrayCntUnit
    always @(posedge SysClk ) begin
        if(Reset)        GrayCnt[i] <= # TCo_C (i>1) ? 1'h0: 1'h1;
        else if(SyncClr) GrayCnt[i] <= # TCo_C (i>1) ? 1'h0: 1'h1;
        else if(ClkEn)   GrayCnt[i] <= # TCo_C GrayCnt[i] + CryIn[i];
    end

    if(i==0) begin
        assign CryOut[0] =  GrayCnt[0] && CarryIn;
        assign CryIn [1] = ~GrayCnt[0] && CarryIn;
    end else begin
        assign CryOut[i  ] = CryOut[0] && (~|GrayCnt[i:1]);
        assign CryIn [i+1] = CryOut[i-1] && GrayCnt[i];
    end
end
endgenerate

wire GrayCarry = CryOut[CW_C-2];
reg  CntHigh = 1'h0;

always @(posedge SysClk) begin
    if(Reset)      CntHigh <= # TCo_C 1'h0;
    else if(ClkEn) CntHigh <= # TCo_C (CntHigh + GrayCarry);
end

/////////////////////////////////////////////////////////
assign Count    = {CntHigh , GrayCnt[CW_C-1:1]};  // (O)Counter Value Output
assign CarryOut =  CntHigh & GrayCarry;           // (O)Carry output
/////////////////////////////////////////////////////////

endmodule
////////////////////// GrayCnt ////////////////////////////



/**********************************************************
// Module Name:    GrayDecode
**********************************************************/
module GrayDecode #(
    parameter DataWidht_C = 8
)(
    input  [DataWidht_C-1:0] GrayIn,
    output [DataWidht_C-1:0] HexOut
);

// Define Parameter
/////////////////////////////////////////////////////////
localparam TCo_C = 1;
localparam DW_C = DataWidht_C;
/////////////////////////////////////////////////////////
reg [DW_C-1:0] Hex; 
integer i;

always @ (GrayIn) begin
    Hex[DW_C-1]=GrayIn[DW_C-1];
    for(i=DW_C-2;i>=0;i=i-1) Hex[i]=Hex[i+1]^GrayIn[i];
end

assign HexOut = Hex;

endmodule 
