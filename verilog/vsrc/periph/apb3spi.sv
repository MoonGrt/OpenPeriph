module Apb3Spi (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [5:0] paddr, input logic [31:0] pwdata,
  output logic [31:0] prdata, output logic pready, pslverr,
  input logic miso, output logic sclk, mosi, nss, interrupt
);
  logic [15:0] cr1, cr2, crcpr, rxcrcr, txcrcr, i2scfgr, i2spr;
  logic [15:0] tx_data, rx_data, tx_shift, rx_shift;
  logic [4:0] bits_left;
  logic [8:0] divider;
  logic busy, rx_valid, tx_pending;
  wire access = psel && penable;
  wire [4:0] frame_bits = cr1[11] ? 16 : 8;
  wire [8:0] divider_reload = (9'b1 << (cr1[5:3] + 1)) - 1'b1;
  wire tick = divider == 0;
  wire [15:0] status = {8'b0, busy, 5'b0, !tx_pending, rx_valid};
  assign pready=1; assign pslverr=0;
  assign interrupt=(cr2[7]&&!tx_pending)||(cr2[6]&&rx_valid)||(cr2[5]&&|status[6:3]);
  assign nss = !(busy && cr1[2]);
  assign mosi = cr1[7] ? tx_shift[0] : tx_shift[frame_bits[3:0]-1'b1];

  always_ff @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
      cr1<=0;cr2<=0;crcpr<=7;rxcrcr<=0;txcrcr<=0;i2scfgr<=0;i2spr<=2;
      tx_data<=0;rx_data<=0;tx_shift<=0;rx_shift<=0;bits_left<=0;divider<=0;
      busy<=0;rx_valid<=0;tx_pending<=0;sclk<=0;
    end else begin
      if(access&&pwrite) case(paddr)
        6'h00:begin cr1<=pwdata[15:0];sclk<=pwdata[1];end
        6'h04:cr2<=pwdata[15:0];
        6'h0c:if(!tx_pending)begin tx_data<=pwdata[15:0];tx_pending<=1;end
        6'h10:crcpr<=pwdata[15:0]; 6'h1c:i2scfgr<=pwdata[15:0]; 6'h20:i2spr<=pwdata[15:0];
        default:;
      endcase
      if(access&&!pwrite&&paddr==6'h0c)rx_valid<=0;
      if(!busy&&tx_pending&&cr1[6])begin
        tx_shift<=tx_data;rx_shift<=0;bits_left<=frame_bits;busy<=1;tx_pending<=0;
        divider<=divider_reload;sclk<=cr1[1];
      end else if(busy)begin
        if(tick)begin
          divider<=divider_reload;sclk<=~sclk;
          if(sclk != (cr1[1]^cr1[0]))begin
            if(cr1[7])begin rx_shift<={miso,rx_shift[15:1]};tx_shift<={1'b0,tx_shift[15:1]};end
            else begin rx_shift<={rx_shift[14:0],miso};tx_shift<={tx_shift[14:0],1'b0};end
            bits_left<=bits_left-1'b1;
            if(bits_left==1)begin rx_data<=cr1[7]?{miso,rx_shift[15:1]}:{rx_shift[14:0],miso};rx_valid<=1;busy<=0;sclk<=cr1[1];end
          end
        end else divider<=divider-1'b1;
      end
    end
  end
  always_comb case(paddr)
    6'h00:prdata={16'b0,cr1};6'h04:prdata={16'b0,cr2};6'h08:prdata={16'b0,status};
    6'h0c:prdata={16'b0,rx_data};6'h10:prdata={16'b0,crcpr};6'h14:prdata={16'b0,rxcrcr};
    6'h18:prdata={16'b0,txcrcr};6'h1c:prdata={16'b0,i2scfgr};6'h20:prdata={16'b0,i2spr};default:prdata=0;
  endcase
endmodule
