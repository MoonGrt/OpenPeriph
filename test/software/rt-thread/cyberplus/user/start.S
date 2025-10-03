.section .init;
.globl _start;
.type _start, @function

_start:
    j crtInit
    nop
    nop
    nop
    nop
    nop
    nop
    nop

crtInit:
.option push
.option norelax
    la gp, __global_pointer$
.option pop
    la sp, _sp

    /* 将 bss section 初始化为 0 */
bss_init:
    la a0, __bss_start
    la a1, _end
bss_loop:
    beq a0,a1,bss_done
    sw zero,0(a0)
    add a0,a0,4
    j bss_loop
bss_done:

    li a0, 0x880     //880 enable timer + external interrupts
    csrw mie,a0
    li a0, 0x1808     //1808 enable interrupts
    csrw mstatus,a0

    /* 调用初始化函数 */
    call _init
    /* 跳转到 main */
    call main

/* never came here */
loop:
    j loop


/* 声明所有中断处理程序为弱符号 */
.weak WDG_IRQHandler
.weak GPIO0_3_IRQHandler
.weak GPIO4_7_IRQHandler
.weak GPIO8_11_IRQHandler
.weak GPIO12_15_IRQHandler
.weak TIM_IRQHandler
.weak USART_IRQHandler
.weak SPI_IRQHandler
.weak I2C_IRQHandler

/* 中断向量表 */
.section .vector, "a", @progbits
  .align 6
  .globl interrupt_vector_table
interrupt_vector_table:
  .word reset_handler      /* 0: 重置中断处理函数 */
  .word wdg_handler        /* 1: 看门狗中断处理函数 */
  .word gpio0_3_handler    /* 2: GPIO 0-3  中断处理函数 */
  .word gpio4_7_handler    /* 3: GPIO 4-7  中断处理函数 */
  .word gpio8_11_handler   /* 4: GPIO 8-11 中断处理函数 */
  .word gpio12_15_handler  /* 5: GPIO 12-15中断处理函数 */
  .word timer_handler      /* 6: 定时器中断处理函数 */
  .word usart_handler      /* 7: USART中断处理函数 */
  .word spi_handler        /* 8: SPI中断处理函数 */
  .word i2c_handler        /* 9: I2C中断处理函数 */

reset_handler:
  j crtStart              /* 重置中断时跳转到程序启动 */
wdg_handler:
  la t0, WDG_IRQHandler     /* 加载目标地址到 t0 */
  jalr t0                   /* 跳转到目标地址 */
gpio0_3_handler:
  la t0, GPIO0_3_IRQHandler
  jalr t0
gpio4_7_handler:
  la t0, GPIO4_7_IRQHandler
  jalr t0
gpio8_11_handler:
  la t0, GPIO8_11_IRQHandler
  jalr t0
gpio12_15_handler:
  la t0, GPIO12_15_IRQHandler
  jalr t0
timer_handler:
  la t0, TIM_IRQHandler
  jalr t0
usart_handler:
  la t0, USART_IRQHandler
  jalr t0
spi_handler:
  la t0, SPI_IRQHandler
  jalr t0
i2c_handler:
  la t0, I2C_IRQHandler
  jalr t0
