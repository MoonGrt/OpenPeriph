#include "VAxi4Mem.h"
#include "verilated.h"

#include <cstdint>
#include <cstdio>

static void tick(VAxi4Mem &dut) {
  dut.aclk = 0;
  dut.eval();
  dut.aclk = 1;
  dut.eval();
}

static bool check(bool condition, const char *message) {
  if (!condition) {
    std::fprintf(stderr, "FAIL: %s\n", message);
  }
  return condition;
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  VAxi4Mem dut;
  dut.aresetn = 0;
  dut.awvalid = 0;
  dut.wvalid = 0;
  dut.bready = 0;
  dut.arvalid = 0;
  dut.rready = 0;
  tick(dut);
  dut.aresetn = 1;
  tick(dut);

  dut.awid = 3;
  dut.awaddr = 0x20;
  dut.awvalid = 1;
  tick(dut);
  dut.awvalid = 0;
  dut.wdata = 0x11223344;
  dut.wstrb = 0xf;
  dut.wvalid = 1;
  tick(dut);
  dut.wvalid = 0;
  if (!check(dut.bvalid && dut.bid == 3 && dut.bresp == 0,
             "write response")) return 1;
  dut.bready = 1;
  tick(dut);
  dut.bready = 0;

  dut.awid = 4;
  dut.awaddr = 0x20;
  dut.awvalid = 1;
  tick(dut);
  dut.awvalid = 0;
  dut.wdata = 0xaabbccdd;
  dut.wstrb = 0x5;
  dut.wvalid = 1;
  tick(dut);
  dut.wvalid = 0;
  dut.bready = 1;
  tick(dut);
  dut.bready = 0;

  dut.arid = 7;
  dut.araddr = 0x20;
  dut.arvalid = 1;
  tick(dut);
  dut.arvalid = 0;
  if (!check(dut.rvalid && dut.rid == 7 && dut.rdata == 0x11bb33dd,
             "read data and byte strobes")) return 1;
  dut.rready = 1;
  tick(dut);
  if (!check(!dut.rvalid, "read response handshake")) return 1;

  std::puts("PASS: SystemVerilog AXI4 memory");
  return 0;
}
