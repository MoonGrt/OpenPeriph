module Apb3Gpio #(
  parameter int WIDTH = 16
) (
  input  logic             pclk,
  input  logic             presetn,
  input  logic             psel,
  input  logic             penable,
  input  logic             pwrite,
  input  logic [4:0]       paddr,
  input  logic [31:0]      pwdata,
  output logic [31:0]      prdata,
  output logic             pready,
  output logic             pslverr,
  input  logic [WIDTH-1:0] gpio_read,
  input  logic [WIDTH-1:0] afio_write,
  output logic [WIDTH-1:0] gpio_write,
  output logic [WIDTH-1:0] gpio_write_enable
);
  logic [31:0] crl, crh;
  logic [WIDTH-1:0] odr, lckr;
  logic lckk;
  wire access = psel && penable;
  integer i;

  assign pready = 1'b1;
  assign pslverr = 1'b0;

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      crl <= '0; crh <= '0; odr <= '0; lckr <= '0; lckk <= 1'b0;
    end else if (access && pwrite) begin
      case (paddr)
        5'h00: for (i = 0; i < 8; i++) if (!lckr[i]) crl[i*4 +: 4] <= pwdata[i*4 +: 4];
        5'h04: for (i = 0; i < 8; i++) if (!lckr[i+8]) crh[i*4 +: 4] <= pwdata[i*4 +: 4];
        5'h0c: odr <= pwdata[WIDTH-1:0];
        5'h10: odr <= (odr | pwdata[15:0]) & ~pwdata[31:16];
        5'h14: odr <= odr & ~pwdata[15:0];
        5'h18: begin lckr <= lckr | pwdata[15:0]; if (pwdata[16]) lckk <= 1'b1; end
        default: ;
      endcase
    end
  end

  always_comb begin
    prdata = 32'b0;
    case (paddr)
      5'h00: prdata = crl;
      5'h04: prdata = crh;
      5'h08: prdata = {{(32-WIDTH){1'b0}}, gpio_read};
      5'h0c: prdata = {{(32-WIDTH){1'b0}}, odr};
      5'h18: prdata = {15'b0, lckk, lckr};
      default: ;
    endcase
    for (i = 0; i < WIDTH; i++) begin
      if (i < 8) begin
        gpio_write[i] = (crl[i*4+3 -: 2] inside {2'b10, 2'b11}) ? afio_write[i] : odr[i];
        gpio_write_enable[i] = |crl[i*4 +: 2] && (!(crl[i*4+3 -: 2] inside {2'b01, 2'b11}) || !gpio_write[i]);
      end else begin
        gpio_write[i] = (crh[(i-8)*4+3 -: 2] inside {2'b10, 2'b11}) ? afio_write[i] : odr[i];
        gpio_write_enable[i] = |crh[(i-8)*4 +: 2] && (!(crh[(i-8)*4+3 -: 2] inside {2'b01, 2'b11}) || !gpio_write[i]);
      end
    end
  end
endmodule
