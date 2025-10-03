#include <rthw.h>
#include <rtthread.h>

/* 系统时基计数器 */
static rt_tick_t rt_tick = 0;

/**
 * This function will return current tick from operating system startup
 *
 * @return current tick
 */
rt_tick_t rt_tick_get(void)
{
    /* return the global tick */
    return rt_tick;
}

/**
 * This function will set current tick
 */
void rt_tick_set(rt_tick_t tick)
{
    rt_base_t level;

    level = rt_hw_interrupt_disable();
    rt_tick = tick;
    rt_hw_interrupt_enable(level);
}

/**
 * This function will notify kernel there is one tick passed. Normally,
 * this function is invoked by clock ISR.
 */
void rt_tick_increase(void)
{
    struct rt_thread *thread;

    /* 系统时基计数器加 1 */
    ++ rt_tick;

    thread = rt_thread_self();

    /* 时间片递减 */
    -- thread->remaining_tick;

    /* 检查当前线程的时间片是否用尽 */
    if (thread->remaining_tick == 0)
    {
        /* 重置时间片 */
        thread->remaining_tick = thread->init_tick;

        /* 让出处理器 */
        rt_thread_yield();
    }
    

    /* 扫描定时器列表 */
    rt_timer_check();
}
