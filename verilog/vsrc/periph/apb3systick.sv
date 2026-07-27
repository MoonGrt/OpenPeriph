module Apb3SysTick #(
  parameter logic [31:0] CALIB = 32'd1000
) (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [3:0] paddr,
  input logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic pready, pslverr, interrupt
);
  logic [31:0] ctrl, load, value;
  wire access = psel && penable;
  assign pready=1'b1; assign pslverr=1'b0; assign interrupt=ctrl[1] && ctrl[16];
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin ctrl<=0; load<=0; value<=0; end
    else begin
      if (ctrl[0]) begin
        if (value == 0) value <= load;
        else begin if (value == 1) ctrl[16] <= 1'b1; value <= value - 1'b1; end
      end else ctrl[16] <= 1'b0;
      if (access && pwrite) case (paddr)
        4'h0: ctrl<=pwdata; 4'h4: load<=pwdata; 4'h8: value<=pwdata; default: ;
      endcase
    end
  end
  always_comb case(paddr)
    4'h0:prdata=ctrl; 4'h4:prdata=load; 4'h8:prdata=value; 4'hc:prdata=CALIB; default:prdata=0;
  endcase
endmodule
