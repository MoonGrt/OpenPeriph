module Apb3Tim (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [6:0] paddr,
  input logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic pready, pslverr,
  output logic [3:0] channel,
  output logic interrupt
);
  logic [15:0] cr1, cr2, smcr, dier, sr, egr, ccmr1, ccmr2, ccer;
  logic [15:0] cnt, psc, arr, rcr, ccr1, ccr2, ccr3, ccr4, bdtr, dcr, dmar;
  logic [15:0] prescaler;
  wire access = psel && penable;
  assign pready = 1'b1; assign pslverr = 1'b0;
  assign channel = {ccer[3] && cnt < ccr4, ccer[2] && cnt < ccr3,
                    ccer[1] && cnt < ccr2, ccer[0] && cnt < ccr1};
  assign interrupt = sr[0] && dier[0];

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      cr1<=0; cr2<=0; smcr<=0; dier<=0; sr<=0; egr<=0; ccmr1<=0; ccmr2<=0;
      ccer<=0; cnt<=0; psc<=0; arr<=16'hffff; rcr<=0; ccr1<=0; ccr2<=0;
      ccr3<=0; ccr4<=0; bdtr<=0; dcr<=0; dmar<=0; prescaler<=0;
    end else begin
      if (cr1[0]) begin
        if (prescaler == psc) begin
          prescaler <= 0;
          if (!cr1[4]) begin
            if (cnt == arr) begin cnt <= 0; sr[0] <= 1'b1; end else cnt <= cnt + 1'b1;
          end else begin
            if (cnt == 0) begin cnt <= arr; sr[0] <= 1'b1; end else cnt <= cnt - 1'b1;
          end
        end else prescaler <= prescaler + 1'b1;
      end
      if (egr[0]) cnt <= 0;
      if (|{egr[6], egr[4:0]}) egr <= 0;
      if (access && pwrite) case (paddr)
        7'h00: cr1<=pwdata[15:0]; 7'h04: cr2<=pwdata[15:0]; 7'h08: smcr<=pwdata[15:0]; 7'h0c: dier<=pwdata[15:0];
        7'h10: sr<=pwdata[15:0]; 7'h14: egr<=pwdata[15:0]; 7'h18: ccmr1<=pwdata[15:0]; 7'h1c: ccmr2<=pwdata[15:0];
        7'h20: ccer<=pwdata[15:0]; 7'h28: psc<=pwdata[15:0]; 7'h2c: arr<=pwdata[15:0]; 7'h30: rcr<=pwdata[15:0];
        7'h34: ccr1<=pwdata[15:0]; 7'h38: ccr2<=pwdata[15:0]; 7'h3c: ccr3<=pwdata[15:0]; 7'h40: ccr4<=pwdata[15:0];
        7'h44: bdtr<=pwdata[15:0]; 7'h48: dcr<=pwdata[15:0]; 7'h4c: dmar<=pwdata[15:0];
        default: ;
      endcase
    end
  end
  always_comb case (paddr)
    7'h00:prdata={16'b0,cr1}; 7'h04:prdata={16'b0,cr2}; 7'h08:prdata={16'b0,smcr};
    7'h0c:prdata={16'b0,dier}; 7'h10:prdata={16'b0,sr}; 7'h14:prdata={16'b0,egr};
    7'h18:prdata={16'b0,ccmr1}; 7'h1c:prdata={16'b0,ccmr2}; 7'h20:prdata={16'b0,ccer};
    7'h24:prdata={16'b0,cnt}; 7'h28:prdata={16'b0,psc}; 7'h2c:prdata={16'b0,arr};
    7'h30:prdata={16'b0,rcr}; 7'h34:prdata={16'b0,ccr1}; 7'h38:prdata={16'b0,ccr2};
    7'h3c:prdata={16'b0,ccr3}; 7'h40:prdata={16'b0,ccr4}; 7'h44:prdata={16'b0,bdtr};
    7'h48:prdata={16'b0,dcr}; 7'h4c:prdata={16'b0,dmar}; default:prdata=0;
  endcase
endmodule
