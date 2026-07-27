module Apb3Iwdg (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [3:0] paddr, input logic [31:0] pwdata,
  output logic [31:0] prdata, output logic pready, pslverr, reset_out
);
  logic [2:0] prescale, status;
  logic [11:0] reload, counter;
  logic [7:0] prescale_counter;
  logic enabled;
  wire access=psel&&penable;
  wire [7:0] prescale_max=(8'b1 << (prescale+2))-1'b1;
  assign pready=1'b1; assign pslverr=1'b0;
  always_ff @(posedge pclk or negedge presetn) begin
    if(!presetn) begin prescale<=0; reload<=12'hfff; status<=0; enabled<=0; counter<=0; prescale_counter<=0; reset_out<=0; end
    else begin
      if(enabled) begin
        if(prescale_counter==prescale_max) begin prescale_counter<=0; if(counter==0) reset_out<=1; else begin counter<=counter-1'b1; reset_out<=0; end end
        else prescale_counter<=prescale_counter+1'b1;
      end else begin prescale_counter<=0; reset_out<=0; end
      if(access&&pwrite) case(paddr)
        4'h0:case(pwdata[15:0]) 16'hcccc:enabled<=1; 16'haaaa:counter<=reload; 16'h5555:status<=3; default:; endcase
        4'h4:if(status[0]) begin prescale<=pwdata[2:0]; status[0]<=0; end
        4'h8:if(status[1]) begin reload<=pwdata[11:0]; status[1]<=0; end
        default:;
      endcase
    end
  end
  always_comb case(paddr) 4'h4:prdata={29'b0,prescale}; 4'h8:prdata={20'b0,reload}; 4'hc:prdata={29'b0,status}; default:prdata=0; endcase
endmodule

module Apb3Wwdg (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [4:0] paddr, input logic [31:0] pwdata,
  output logic [31:0] prdata, output logic pready, pslverr, reset_out
);
  logic [7:0] cr;
  logic [15:0] cfr;
  logic interrupt_flag;
  logic [6:0] counter;
  logic [14:0] prescale_counter;
  wire access=psel&&penable;
  wire [14:0] prescale_max=(15'd4096 << cfr[8:7])-1'b1;
  assign pready=1'b1; assign pslverr=1'b0;
  always_ff @(posedge pclk or negedge presetn) begin
    if(!presetn) begin cr<=0;cfr<=0;interrupt_flag<=0;counter<=7'h7f;prescale_counter<=0;reset_out<=0;end
    else begin
      if(cr[7]) begin
        if(prescale_counter==prescale_max) begin prescale_counter<=0;if(counter==0)reset_out<=1;else begin counter<=counter-1'b1;reset_out<=0;end end
        else prescale_counter<=prescale_counter+1'b1;
      end else begin prescale_counter<=0;reset_out<=0;end
      if(access&&pwrite) case(paddr)
        5'h00:begin cr<={cr[7]|pwdata[7],pwdata[6:0]};if(pwdata[6:0]<cfr[6:0])begin counter<=pwdata[6:0];interrupt_flag<=0;end end
        5'h04:cfr<=pwdata[15:0]; default:;
      endcase
    end
  end
  always_comb case(paddr) 5'h00:prdata={24'b0,cr};5'h04:prdata={16'b0,cfr};5'h08:prdata={31'b0,interrupt_flag};default:prdata=0;endcase
endmodule
