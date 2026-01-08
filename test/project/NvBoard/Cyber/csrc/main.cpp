#include <nvboard.h>
// #include <VCyber.h>
#include <VCyberNvboard.h>

static TOP_NAME dut;

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
int main() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  reset(10);

#ifdef CYCLE_CNT
  int cnt = 0;
  clock_t t0 = clock();
#endif
  while (1) {
      nvboard_update();
      single_cycle();
#ifdef CYCLE_CNT
      if (++cnt == CYCLE_CNT) {
          printf("%d 次耗时: %.6f 秒\n", CYCLE_CNT, (double)(clock() - t0) / CLOCKS_PER_SEC);
          cnt = 0;
          t0 = clock();
      }
#endif
  }
}
