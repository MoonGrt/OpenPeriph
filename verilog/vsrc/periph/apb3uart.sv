module Apb3Uart (
  input  logic        pclk, presetn, psel, penable, pwrite,
  input  logic [11:0] paddr,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready, pslverr,
  input  logic        rxd,
  output logic        txd,
  output logic        interrupt
);
  logic [15:0] brr, cr1, cr2, cr3, gtpr;
  logic [7:0] fifo [0:15];
  logic [3:0] wr_ptr, rd_ptr;
  logic [4:0] count;
  logic [7:0] shift;
  logic [2:0] bit_index, sample;
  logic [19:0] divider;
  typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
  state_t state;
  wire access = psel && penable;
  wire sample_tick = divider == 0;
  wire baud_tick = sample_tick && sample == 4;
  assign pready = 1'b1;
  assign pslverr = 1'b0;
  assign interrupt = 1'b0;
  assign txd = state == START ? 1'b0 : state == DATA ? shift[bit_index] : 1'b1;

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      brr <= 0; cr1 <= 0; cr2 <= 0; cr3 <= 0; gtpr <= 0;
      wr_ptr <= 0; rd_ptr <= 0; count <= 0; state <= IDLE; shift <= 0;
      bit_index <= 0; sample <= 0; divider <= 0;
    end else begin
      divider <= sample_tick ? {8'b0, brr[15:4]} : divider - 1'b1;
      if (sample_tick) sample <= sample == 4 ? 0 : sample + 1'b1;
      if (access && pwrite) begin
        case (paddr)
          12'h004: if (count != 16) begin fifo[wr_ptr] <= pwdata[7:0]; wr_ptr <= wr_ptr + 1'b1; count <= count + 1'b1; end
          12'h008: brr <= pwdata[15:0];
          12'h00c: cr1 <= pwdata[15:0];
          12'h010: cr2 <= pwdata[15:0];
          12'h014: cr3 <= pwdata[15:0];
          12'h018: gtpr <= pwdata[15:0];
          default: ;
        endcase
      end
      if (state == IDLE && count != 0 && baud_tick) begin
        shift <= fifo[rd_ptr]; rd_ptr <= rd_ptr + 1'b1; count <= count - 1'b1; state <= START;
      end else if (baud_tick) begin
        case (state)
          START: begin bit_index <= 0; state <= DATA; end
          DATA: if (bit_index == 7) state <= STOP; else bit_index <= bit_index + 1'b1;
          STOP: state <= IDLE;
          default: ;
        endcase
      end
    end
  end

  always_comb begin
    case (paddr)
      12'h000: prdata = {24'b0, count != 16, count == 0, 6'b0};
      12'h008: prdata = {16'b0, brr};
      12'h00c: prdata = {16'b0, cr1};
      12'h010: prdata = {16'b0, cr2};
      12'h014: prdata = {16'b0, cr3};
      12'h018: prdata = {16'b0, gtpr};
      default: prdata = 0;
    endcase
  end
  logic unused_rxd;
  assign unused_rxd = rxd;
endmodule
