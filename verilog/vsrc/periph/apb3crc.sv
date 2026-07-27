module Apb3Crc (
  input  logic        pclk, presetn, psel, penable, pwrite,
  input  logic [4:0]  paddr,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready, pslverr, interrupt
);
  logic [31:0] crc;
  logic [7:0] idr;
  wire access = psel && penable;

  function automatic [31:0] crc32_word(input [31:0] initial_crc, input [31:0] data);
    reg [31:0] value;
    integer bit_index;
    begin
      value = initial_crc;
      for (bit_index = 31; bit_index >= 0; bit_index = bit_index - 1)
        value = {value[30:0], 1'b0} ^ ((value[31] ^ data[bit_index]) ? 32'h04c11db7 : 32'b0);
      crc32_word = value;
    end
  endfunction

  assign pready = 1'b1;
  assign pslverr = 1'b0;
  assign interrupt = 1'b0;
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin crc <= 32'hffffffff; idr <= 0; end
    else if (access && pwrite) begin
      case (paddr)
        5'h00: crc <= crc32_word(crc, pwdata);
        5'h04: idr <= pwdata[7:0];
        5'h08: if (pwdata[0]) crc <= 32'hffffffff;
        default: ;
      endcase
    end
  end
  always_comb case (paddr)
    5'h00: prdata = crc;
    5'h04: prdata = {24'b0, idr};
    5'h08: prdata = 0;
    default: prdata = 0;
  endcase
endmodule
