#include <rthw.h>
#include <rtthread.h>

/* 中断计数器 */
volatile rt_uint8_t rt_interrupt_nest;

/**
 * This function will be invoked by BSP, when enter interrupt service routine
 *
 * @note please don't invoke this routine in application
 *
 * @see rt_interrupt_leave
 */
void rt_interrupt_enter(void)
{
    rt_base_t level;

    /* 打印调试信息 */
    //printf("irq coming, nest: %d\n", rt_interrupt_nest);

    /* 关中断 */
    level = rt_hw_interrupt_disable();

    /* 中断计数器加 1 */
    rt_interrupt_nest++;

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);
}

/**
 * This function will be invoked by BSP, when leave interrupt service routine
 *
 * @note please don't invoke this routine in application
 *
 * @see rt_interrupt_enter
 */
void rt_interrupt_leave(void)
{
    rt_base_t level;

    /* 打印调试信息 */
    //printf("irq leave, nest: %d\n", rt_interrupt_nest);

    /* 关中断 */
    level = rt_hw_interrupt_disable();

    /* 中断计数器减 1 */
    rt_interrupt_nest--;

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);
}

