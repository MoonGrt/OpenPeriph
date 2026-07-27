#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <verilated.h>
#include "VApb3Peripherals.h"

static VApb3Peripherals dut;

static void tick() {
  dut.pclk = 0;
  dut.eval();
  dut.pclk = 1;
  dut.eval();
}

static void idle() {
  dut.psel = 0;
  dut.penable = 0;
  dut.pwrite = 0;
  dut.paddr = 0;
  dut.pwdata = 0;
}

static void apb_write(uint32_t address, uint32_t data) {
  dut.paddr = address;
  dut.pwdata = data;
  dut.pwrite = 1;
  dut.psel = 1;
  dut.penable = 0;
  tick();
  dut.penable = 1;
  tick();
  if (!dut.pready || dut.pslverr) {
    std::fprintf(stderr, "APB write failed at 0x%05x\n", address);
    std::exit(1);
  }
  idle();
  tick();
}

static uint32_t apb_read(uint32_t address, bool expect_error = false) {
  dut.paddr = address;
  dut.pwrite = 0;
  dut.psel = 1;
  dut.penable = 0;
  tick();
  dut.penable = 1;
  tick();
  const uint32_t data = dut.prdata;
  if (!dut.pready || static_cast<bool>(dut.pslverr) != expect_error) {
    std::fprintf(stderr, "APB read response mismatch at 0x%05x\n", address);
    std::exit(1);
  }
  idle();
  tick();
  return data;
}

static void expect(bool condition, const char* message) {
  if (!condition) {
    std::fprintf(stderr, "FAIL: %s\n", message);
    std::exit(1);
  }
}

static uint32_t crc32_word(uint32_t crc, uint32_t data) {
  for (int bit = 31; bit >= 0; --bit)
    crc = (crc << 1) ^ ((((crc >> 31) ^ (data >> bit)) & 1) ? 0x04c11db7u : 0);
  return crc;
}

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  idle();
  dut.gpioa_read = 0;
  dut.gpiob_read = 0;
  dut.uart_rxd = 1;
  dut.i2c_sda_in = 0;
  dut.spi_miso = 1;
  dut.can_rx = 1;
  dut.sdio_cmd_in = 1;
  dut.sdio_data_in = 0xf;
  dut.presetn = 0;
  tick();
  tick();
  dut.presetn = 1;
  tick();

  apb_write(0x00000, 0x00000001);
  apb_write(0x0000c, 0x00000005);
  expect((dut.gpioa_write & 1) == 1, "GPIO output data");
  expect((dut.gpioa_write_enable & 1) == 1, "GPIO output enable");
  apb_write(0x00010, 0x00010002);
  expect(apb_read(0x0000c) == 0x00000006, "GPIO atomic set/reset");

  apb_write(0x4002c, 3);
  apb_write(0x4000c, 1);
  apb_write(0x40000, 1);
  for (int i = 0; i < 10; ++i) tick();
  expect(dut.timer_interrupt, "timer update interrupt");

  apb_write(0x60004, 2);
  apb_write(0x60008, 2);
  apb_write(0x60000, 3);
  for (int i = 0; i < 4; ++i) tick();
  expect(dut.systick_interrupt, "SysTick interrupt");

  apb_write(0x50000, 0x5555);
  apb_write(0x50004, 2);
  apb_write(0x50008, 7);
  expect(apb_read(0x50004) == 2, "independent watchdog prescaler");
  expect(apb_read(0x50008) == 7, "independent watchdog reload");
  apb_write(0x50404, 0x23);
  expect(apb_read(0x50404) == 0x23, "window watchdog configuration");

  apb_write(0xe0000, 1u << 2);
  apb_write(0xe0008, 1u << 2);
  dut.gpioa_read = 1u << 2;
  tick();
  tick();
  expect(dut.exti_interrupt == (1u << 2), "AFIO routed EXTI rising edge");
  apb_write(0xe0014, 1u << 2);
  expect(dut.exti_interrupt == 0, "EXTI pending clear");

  apb_write(0x10008, 0);
  apb_write(0x10004, 'A');
  bool saw_start = false;
  for (int i = 0; i < 20; ++i) {
    tick();
    saw_start |= !dut.uart_txd;
  }
  expect(saw_start, "UART start bit");

  apb_write(0xb0008, 1);
  apb_write(0xb0000, 0x12345678);
  expect(apb_read(0xb0000) == crc32_word(0xffffffffu, 0x12345678), "CRC-32 data path");
  apb_write(0xb0004, 0x5a);
  expect(apb_read(0xb0004) == 0x5a, "CRC independent register");

  apb_write(0x30000, 0x44);
  apb_write(0x3000c, 0xa5);
  for (int i = 0; i < 80; ++i) tick();
  expect((apb_read(0x30008) & 1) != 0, "SPI receive complete");

  apb_write(0x2001c, 1);
  apb_write(0x20010, 0xa0);
  apb_write(0x20000, 0x101);
  for (int i = 0; i < 50; ++i) tick();
  expect((apb_read(0x20018) & 2) != 0, "I2C bus busy after START");

  apb_write(0x90184, 8);
  apb_write(0x90188, 0x44332211);
  apb_write(0x9018c, 0x88776655);
  apb_write(0x90180, 1);
  expect((apb_read(0x9000c) & 3) == 1, "CAN loopback receive FIFO");
  expect(apb_read(0x901b8) == 0x44332211, "CAN loopback payload");

  apb_write(0xa0000, 3);
  apb_write(0xa0008, 0x1234);
  apb_write(0xa000c, (1u << 10) | 17);
  expect((apb_read(0xa0034) & (1u << 7)) != 0, "SDIO command sent");

  apb_write(0x70004, (1u << 16) | 1u);
  apb_write(0x70008, (8u << 16) | 4u);
  apb_write(0x7000c, (1u << 16) | 1u);
  apb_write(0x70010, (4u << 16) | 2u);
  apb_write(0x70014, 0x123456);
  apb_write(0x70000, 1u | (3u << 1));
  bool saw_active_video = false;
  bool saw_sync = false;
  for (int i = 0; i < 40; ++i) {
    tick();
    saw_active_video |= dut.vga_de && dut.vga_rgb == 0x123456;
    saw_sync |= !dut.vga_hsync;
  }
  expect(saw_active_video, "configurable VGA solid-color output");
  expect(saw_sync, "configurable VGA horizontal sync");
  expect(apb_read(0x70008) == ((8u << 16) | 4u), "VGA timing registers");

  (void)apb_read(0xc0000, true);

  std::puts("PASS: SystemVerilog APB peripherals");
  return 0;
}
