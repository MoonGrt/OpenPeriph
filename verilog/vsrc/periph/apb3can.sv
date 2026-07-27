module Apb3Can (
  input logic pclk,presetn,psel,penable,pwrite,
  input logic [9:0] paddr,input logic [31:0] pwdata,
  output logic [31:0] prdata,output logic pready,pslverr,
  input logic can_rx,output logic can_tx,interrupt
);
  logic [31:0] mcr,msr,tsr,rf0r,rf1r,ier,esr,btr;
  logic [31:0] tx[0:11];
  logic [31:0] rx[0:7];
  logic [31:0] filter_ctrl[0:5];
  logic [31:0] filters[0:27];
  wire access=psel&&penable;
  wire [3:0] tx_index=paddr[5:2];
  wire [2:0] rx_index=paddr[4:2]-3'd4;
  wire [4:0] filter_index=paddr[6:2]-5'd16;
  integer index;
  assign pready=1;assign pslverr=0;assign can_tx=1;
  assign interrupt=|(ier&{24'b0,rf1r[3],rf0r[3],tsr[0],5'b0});
  always_ff @(posedge pclk or negedge presetn)begin
    if(!presetn)begin
      mcr<=2;msr<=1;tsr<=32'h1c000000;rf0r<=0;rf1r<=0;ier<=0;esr<=0;btr<=0;
      for(index=0;index<12;index++)tx[index]<=0;
      for(index=0;index<8;index++)rx[index]<=0;
      for(index=0;index<6;index++)filter_ctrl[index]<=0;
      for(index=0;index<28;index++)filters[index]<=0;
    end else if(access&&pwrite)begin
      case(paddr)
        10'h000:mcr<=pwdata;10'h004:msr<=msr&~pwdata;10'h008:tsr<=tsr&~pwdata;
        10'h00c:rf0r<=rf0r&~pwdata;10'h010:rf1r<=rf1r&~pwdata;10'h014:ier<=pwdata;10'h01c:btr<=pwdata;
        10'h200:filter_ctrl[0]<=pwdata;10'h204:filter_ctrl[1]<=pwdata;10'h20c:filter_ctrl[2]<=pwdata;
        10'h214:filter_ctrl[3]<=pwdata;10'h21c:filter_ctrl[4]<=pwdata;10'h224:filter_ctrl[5]<=pwdata;
        default:begin
          if(paddr>=10'h180&&paddr<10'h1b0)begin
            tx[tx_index]<=pwdata;
            if(paddr[3:0]==0&&pwdata[0])begin
              rx[0]<=pwdata;rx[1]<=tx[tx_index+4'd1];rx[2]<=tx[tx_index+4'd2];rx[3]<=tx[tx_index+4'd3];
              rf0r[1:0]<=rf0r[1:0]==3?3:rf0r[1:0]+1'b1;rf0r[3]<=1;tsr[0]<=1;tsr[26]<=1;
            end
          end else if(paddr>=10'h240&&paddr<10'h2b0)filters[filter_index]<=pwdata;
        end
      endcase
      msr[0]<=mcr[0];msr[1]<=mcr[1];
    end
  end
  always_comb begin
    prdata=0;
    case(paddr)
      10'h000:prdata=mcr;10'h004:prdata=msr;10'h008:prdata=tsr;10'h00c:prdata=rf0r;
      10'h010:prdata=rf1r;10'h014:prdata=ier;10'h018:prdata=esr;10'h01c:prdata=btr;
      10'h200:prdata=filter_ctrl[0];10'h204:prdata=filter_ctrl[1];10'h20c:prdata=filter_ctrl[2];
      10'h214:prdata=filter_ctrl[3];10'h21c:prdata=filter_ctrl[4];10'h224:prdata=filter_ctrl[5];
      default:begin
        if(paddr>=10'h180&&paddr<10'h1b0)prdata=tx[tx_index];
        else if(paddr>=10'h1b0&&paddr<10'h1d0)prdata=rx[rx_index];
        else if(paddr>=10'h240&&paddr<10'h2b0)prdata=filters[filter_index];
      end
    endcase
  end
  logic unused_rx;assign unused_rx=can_rx;
endmodule
