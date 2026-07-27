module Apb3I2c (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [5:0] paddr, input logic [31:0] pwdata,
  output logic [31:0] prdata, output logic pready, pslverr,
  input logic sda_in, output logic scl, sda_out, sda_output_enable, interrupt
);
  logic [15:0] cr1,cr2,oar1,oar2,dr,sr1,sr2,ccr,trise;
  logic [11:0] divider;
  logic [3:0] bit_count;
  logic [7:0] shift;
  typedef enum logic [2:0]{IDLE,START_BIT,DATA_BITS,ACK_BIT,STOP_BIT} state_t;
  state_t state;
  wire access=psel&&penable;
  wire tick=divider==0;
  wire [11:0] reload=ccr[11:0]==0?12'd1:ccr[11:0];
  assign pready=1;assign pslverr=0;
  assign interrupt=(cr2[8]&&|sr1[15:8])||(cr2[9]&&|sr1[4:0])||(cr2[10]&&|sr1[7:6]);
  always_ff @(posedge pclk or negedge presetn)begin
    if(!presetn)begin cr1<=0;cr2<=0;oar1<=0;oar2<=0;dr<=0;sr1<=16'h0080;sr2<=0;ccr<=0;trise<=2;
      divider<=0;bit_count<=0;shift<=0;state<=IDLE;scl<=1;sda_out<=1;sda_output_enable<=0;end
    else begin
      if(access&&pwrite)case(paddr)
        6'h00:cr1<=pwdata[15:0];6'h04:cr2<=pwdata[15:0];6'h08:oar1<=pwdata[15:0];6'h0c:oar2<=pwdata[15:0];
        6'h10:begin dr<=pwdata[15:0];shift<=pwdata[7:0];sr1[7]<=0;end
        6'h14:sr1<=sr1&~pwdata[15:0];6'h1c:ccr<=pwdata[15:0];6'h20:trise<=pwdata[15:0];default:;
      endcase
      if(cr1[15])begin cr1<=0;sr1<=16'h0080;sr2<=0;state<=IDLE;scl<=1;sda_output_enable<=0;end
      else if(cr1[0])begin
        if(tick)begin
          divider<=reload;
          case(state)
            IDLE:if(cr1[8])begin state<=START_BIT;sda_out<=0;sda_output_enable<=1;sr1[0]<=1;sr2[1:0]<=2'b11;cr1[8]<=0;end
            START_BIT:begin scl<=0;bit_count<=0;state<=DATA_BITS;sr1[0]<=0;end
            DATA_BITS:begin scl<=~scl;if(scl)begin sda_out<=shift[7];shift<={shift[6:0],1'b0};bit_count<=bit_count+1'b1;if(bit_count==7)begin state<=ACK_BIT;sda_output_enable<=0;end end end
            ACK_BIT:begin scl<=1;if(sda_in)sr1[10]<=1;else begin sr1[2]<=1;sr1[7]<=1;end state<=cr1[9]?STOP_BIT:IDLE;end
            STOP_BIT:begin scl<=1;sda_out<=1;sda_output_enable<=1;cr1[9]<=0;sr2[1:0]<=0;state<=IDLE;end
            default:state<=IDLE;
          endcase
        end else divider<=divider-1'b1;
      end else begin state<=IDLE;scl<=1;sda_output_enable<=0;sr2[1:0]<=0;end
    end
  end
  always_comb case(paddr)
    6'h00:prdata={16'b0,cr1};6'h04:prdata={16'b0,cr2};6'h08:prdata={16'b0,oar1};6'h0c:prdata={16'b0,oar2};
    6'h10:prdata={16'b0,dr};6'h14:prdata={16'b0,sr1};6'h18:prdata={16'b0,sr2};6'h1c:prdata={16'b0,ccr};6'h20:prdata={16'b0,trise};default:prdata=0;
  endcase
endmodule
