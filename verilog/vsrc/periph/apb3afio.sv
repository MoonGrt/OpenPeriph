module Apb3Afio #(
  parameter int GPIO_WIDTH = 16,
  parameter int GPIO_GROUPS = 2
) (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [4:0] paddr,
  input logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic pready, pslverr,
  input logic [GPIO_WIDTH*GPIO_GROUPS-1:0] afio_read,
  output logic [GPIO_WIDTH-1:0] exti
);
  logic [31:0] evcr, mapr, exticr[0:3], mapr2;
  wire access = psel && penable;
  integer pin;
  logic [3:0] group_select;
  assign pready=1'b1; assign pslverr=1'b0;
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      evcr<=0; mapr<=0; exticr[0]<=0; exticr[1]<=0; exticr[2]<=0; exticr[3]<=0; mapr2<=0;
    end else if (access && pwrite) case(paddr)
      5'h00:evcr<=pwdata; 5'h04:mapr<=pwdata; 5'h08:exticr[0]<=pwdata;
      5'h0c:exticr[1]<=pwdata; 5'h10:exticr[2]<=pwdata; 5'h14:exticr[3]<=pwdata;
      5'h1c:mapr2<=pwdata; default: ;
    endcase
  end
  always_comb begin
    case(paddr)
      5'h00:prdata=evcr; 5'h04:prdata=mapr; 5'h08:prdata=exticr[0];
      5'h0c:prdata=exticr[1]; 5'h10:prdata=exticr[2]; 5'h14:prdata=exticr[3];
      5'h1c:prdata=mapr2; default:prdata=0;
    endcase
    exti = '0;
    for (pin=0; pin<GPIO_WIDTH; pin++) begin
      group_select = exticr[pin/4][(pin%4)*4 +: 4];
      if (int'(group_select) < GPIO_GROUPS) exti[pin] = afio_read[group_select*GPIO_WIDTH+pin];
    end
  end
endmodule
