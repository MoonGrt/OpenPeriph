#include <nvboard.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <verilated.h>
#if defined(TOP_CyberNvboardVariant)
#include <VCyberNvboardVariant.h>
#elif defined(TOP_CyberPlusNvboardVariant)
#include <VCyberPlusNvboardVariant.h>
#else
#include <VCyberNvboard.h>
#endif

static TOP_NAME dut;

// VGA must be sampled once per pixel clock. UART uses a slower, independent
// sampling cadence: five internal samples times the 16-clock BRR divider.
#ifndef UART_CYCLES_PER_BIT
#define UART_CYCLES_PER_BIT 80
#endif
static constexpr int kUartCyclesPerBit = UART_CYCLES_PER_BIT;
extern int16_t uart_divisor_cnt;
extern bool is_uart_rx_idle;
void uart_tx_receive();
void uart_rx_send();

void nvboard_bind_all_pins(TOP_NAME* top);

static void single_cycle() {
  dut.clk = 0; dut.eval();
  dut.clk = 1; dut.eval();
}

static void reset(int n) {
  dut.rst = 1;
  while (n -- > 0) single_cycle();
  dut.rst = 0;
}

#include <time.h>
// #define CYCLE_CNT 1000 * 1000
int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  reset(10);
  int uart_sample_counter = kUartCyclesPerBit - 1;
  const bool vga_self_test = getenv("OPENPERIPH_VGA_SELF_TEST") != nullptr;
  uint64_t test_cycles = 0;
  int active_pixels = 0;
  int active_lines = 0;
  int color_runs = 0;
  int run_pixels = 0;
  uint32_t previous_color = 0;
  bool previous_de = false;
  bool vga_synchronized = false;

#ifdef CYCLE_CNT
  int cnt = 0;
  clock_t t0 = clock();
#endif
  while (1) {
      single_cycle();

      // Keep nvboard_update() from applying its fixed 16-update UART divisor.
      // The SoC UART is sampled explicitly below, while VGA remains cycle exact.
      uart_divisor_cnt = INT16_MAX;
      nvboard_update();
      if (--uart_sample_counter < 0) {
          uart_tx_receive();
          if (!is_uart_rx_idle) uart_rx_send();
          uart_sample_counter = kUartCyclesPerBit - 1;
      }
      if (vga_self_test) {
          const bool de = dut.vga_de;
          const uint32_t color = dut.vga_data;
          if (de) {
              if (!previous_de) {
                  active_pixels = 0;
                  color_runs = 1;
                  run_pixels = 0;
                  previous_color = color;
              } else if (color != previous_color) {
                  if (vga_synchronized && active_lines == 0 && run_pixels != 80) {
                      fprintf(stderr,
                              "VGA self-test: color run is %d pixels, expected 80 (x=%d old=%06x new=%06x)\n",
                              run_pixels, active_pixels, previous_color, color);
                      return 1;
                  }
                  ++color_runs;
                  run_pixels = 0;
                  previous_color = color;
              }
              ++active_pixels;
              ++run_pixels;
          } else if (previous_de) {
              if (!vga_synchronized) {
                  vga_synchronized = true;
                  active_lines = 0;
              } else if (active_pixels != 640 ||
                         (active_lines == 0 && (color_runs != 8 || run_pixels != 80))) {
                  fprintf(stderr, "VGA self-test: line=%d pixels=%d color-runs=%d\n",
                          active_lines, active_pixels, color_runs);
                  return 1;
              } else if (++active_lines == 480) {
                  fprintf(stderr, "VGA self-test passed: 640x480, 8 color bars\n");
                  return 0;
              }
          }
          previous_de = de;
          if (++test_cycles == 5000000) {
              fprintf(stderr, "VGA self-test: no complete frame after 5000000 cycles\n");
              return 1;
          }
      }
#ifdef CYCLE_CNT
      if (++cnt == CYCLE_CNT) {
          printf("%d 次耗时: %.6f 秒\n", CYCLE_CNT, (double)(clock() - t0) / CLOCKS_PER_SEC);
          cnt = 0;
          t0 = clock();
      }
#endif
  }
}
