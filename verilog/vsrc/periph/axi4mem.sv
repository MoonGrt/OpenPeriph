module Axi4Mem #(
  parameter int ADDR_WIDTH=16, DATA_WIDTH=32, ID_WIDTH=4,
  parameter int WORDS=16384
)(
  input logic aclk,aresetn,
  input logic [ID_WIDTH-1:0] awid,input logic [ADDR_WIDTH-1:0] awaddr,input logic awvalid,output logic awready,
  input logic [DATA_WIDTH-1:0] wdata,input logic [DATA_WIDTH/8-1:0] wstrb,input logic wvalid,output logic wready,
  output logic [ID_WIDTH-1:0] bid,output logic [1:0] bresp,output logic bvalid,input logic bready,
  input logic [ID_WIDTH-1:0] arid,input logic [ADDR_WIDTH-1:0] araddr,input logic arvalid,output logic arready,
  output logic [ID_WIDTH-1:0] rid,output logic [DATA_WIDTH-1:0] rdata,output logic [1:0] rresp,output logic rvalid,input logic rready
);
  localparam int BYTE_LANES=DATA_WIDTH/8;
  localparam int SHIFT=$clog2(BYTE_LANES);
  logic [7:0] mem[0:WORDS*BYTE_LANES-1];
  logic [ADDR_WIDTH-1:0] write_addr;
  logic [ID_WIDTH-1:0] write_id;
  logic have_aw;
  integer lane;
  assign awready=!have_aw&&!bvalid;assign wready=have_aw&&!bvalid;assign arready=!rvalid;
  always_ff @(posedge aclk or negedge aresetn)begin
    if(!aresetn)begin have_aw<=0;bvalid<=0;rvalid<=0;bid<=0;bresp<=0;rid<=0;rdata<=0;rresp<=0;end
    else begin
      if(awvalid&&awready)begin write_addr<=awaddr;write_id<=awid;have_aw<=1;end
      if(wvalid&&wready)begin for(lane=0;lane<BYTE_LANES;lane++)if(wstrb[lane])mem[{write_addr[ADDR_WIDTH-1:SHIFT],{SHIFT{1'b0}}}+ADDR_WIDTH'(lane)]<=wdata[lane*8+:8];have_aw<=0;bid<=write_id;bresp<=0;bvalid<=1;end
      if(bvalid&&bready)bvalid<=0;
      if(arvalid&&arready)begin rid<=arid;for(lane=0;lane<BYTE_LANES;lane++)rdata[lane*8+:8]<=mem[{araddr[ADDR_WIDTH-1:SHIFT],{SHIFT{1'b0}}}+ADDR_WIDTH'(lane)];rresp<=0;rvalid<=1;end
      if(rvalid&&rready)rvalid<=0;
    end
  end
endmodule
