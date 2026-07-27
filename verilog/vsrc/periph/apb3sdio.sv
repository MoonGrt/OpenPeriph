module Apb3Sdio (
  input logic pclk,presetn,psel,penable,pwrite,
  input logic [7:0] paddr,input logic [31:0] pwdata,
  output logic [31:0] prdata,output logic pready,pslverr,
  input logic cmd_in,input logic [3:0] data_in,
  output logic sd_clk,cmd_out,cmd_output_enable,
  output logic [3:0] data_out,data_output_enable,output logic interrupt
);
  logic [31:0] power,clkcr,arg,cmd,respcmd,resp1,resp2,resp3,resp4;
  logic [31:0] dtimer,dlen,dctrl,dcount,sta,mask;
  logic [31:0] fifo[0:31];
  logic [5:0] fifo_count,wr_ptr,rd_ptr;
  logic [7:0] divider;
  wire access=psel&&penable;
  assign pready=1;assign pslverr=0;assign interrupt=|(sta&mask);
  always_ff @(posedge pclk or negedge presetn)begin
    if(!presetn)begin
      power<=0;clkcr<=0;arg<=0;cmd<=0;respcmd<=0;resp1<=0;resp2<=0;resp3<=0;resp4<=0;
      dtimer<=0;dlen<=0;dctrl<=0;dcount<=0;sta<=32'h00040000;mask<=0;fifo_count<=0;wr_ptr<=0;rd_ptr<=0;
      divider<=0;sd_clk<=0;cmd_out<=1;cmd_output_enable<=0;data_out<=4'hf;data_output_enable<=0;
    end else begin
      if(clkcr[8]&&power[1:0]!=0)begin if(divider==0)begin divider<=clkcr[7:0];sd_clk<=~sd_clk;end else divider<=divider-1'b1;end else sd_clk<=0;
      if(access&&pwrite)case(paddr)
        8'h00:power<=pwdata;8'h04:clkcr<=pwdata;8'h08:arg<=pwdata;
        8'h0c:begin cmd<=pwdata;if(pwdata[10])begin sta[11]<=1;respcmd<={26'b0,pwdata[5:0]};resp1<=arg;sta[11]<=0;if(pwdata[7:6]==0)sta[7]<=1;else sta[6]<=1;end end
        8'h24:dtimer<=pwdata;8'h28:dlen<=pwdata;8'h2c:begin dctrl<=pwdata;dcount<=dlen;end
        8'h38:sta<=sta&~pwdata;8'h3c:mask<=pwdata;
        8'h80:if(fifo_count<32)begin fifo[wr_ptr[4:0]]<=pwdata;wr_ptr<=wr_ptr+1'b1;fifo_count<=fifo_count+1'b1;sta[18]<=0;end
        default:;
      endcase
      if(access&&!pwrite&&paddr==8'h80&&fifo_count!=0)begin rd_ptr<=rd_ptr+1'b1;fifo_count<=fifo_count-1'b1;end
      sta[20]<=fifo_count!=0;sta[18]<=fifo_count==0;sta[16]<=fifo_count==32;sta[14]<=fifo_count<=16;
    end
  end
  always_comb case(paddr)
    8'h00:prdata=power;8'h04:prdata=clkcr;8'h08:prdata=arg;8'h0c:prdata=cmd;8'h10:prdata=respcmd;
    8'h14:prdata=resp1;8'h18:prdata=resp2;8'h1c:prdata=resp3;8'h20:prdata=resp4;8'h24:prdata=dtimer;
    8'h28:prdata=dlen;8'h2c:prdata=dctrl;8'h30:prdata=dcount;8'h34:prdata=sta;8'h38:prdata=0;
    8'h3c:prdata=mask;8'h48:prdata={26'b0,fifo_count};8'h80:prdata=fifo_count!=0?fifo[rd_ptr[4:0]]:0;default:prdata=0;
  endcase
  logic unused_inputs;assign unused_inputs=cmd_in|(|data_in);
endmodule
