module Apb3Exti #(
  parameter int WIDTH = 16
) (
  input logic pclk, presetn, psel, penable, pwrite,
  input logic [4:0] paddr,
  input logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic pready, pslverr,
  input logic [WIDTH-1:0] exti,
  output logic [WIDTH-1:0] interrupt
);
  logic [WIDTH-1:0] imr, emr, rtsr, ftsr, swier, pending, exti_d;
  wire access = psel && penable;
  wire [WIDTH-1:0] edges = (exti & ~exti_d & rtsr) | (~exti & exti_d & ftsr);
  assign pready=1'b1; assign pslverr=1'b0; assign interrupt=pending & imr;
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin imr<=0; emr<=0; rtsr<=0; ftsr<=0; swier<=0; pending<=0; exti_d<=0; end
    else begin
      exti_d <= exti;
      pending <= pending | edges;
      if (access && pwrite) case(paddr)
        5'h00:imr<=pwdata[WIDTH-1:0]; 5'h04:emr<=pwdata[WIDTH-1:0];
        5'h08:rtsr<=pwdata[WIDTH-1:0]; 5'h0c:ftsr<=pwdata[WIDTH-1:0];
        5'h10:begin swier<=swier|pwdata[WIDTH-1:0]; pending<=pending|pwdata[WIDTH-1:0]; end
        5'h14:pending<=pending & ~pwdata[WIDTH-1:0];
        default: ;
      endcase
    end
  end
  always_comb case(paddr)
    5'h00:prdata={{(32-WIDTH){1'b0}},imr}; 5'h04:prdata={{(32-WIDTH){1'b0}},emr};
    5'h08:prdata={{(32-WIDTH){1'b0}},rtsr}; 5'h0c:prdata={{(32-WIDTH){1'b0}},ftsr};
    5'h10:prdata={{(32-WIDTH){1'b0}},swier}; 5'h14:prdata={{(32-WIDTH){1'b0}},pending};
    default:prdata=0;
  endcase
endmodule
