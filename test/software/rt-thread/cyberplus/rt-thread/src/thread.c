#include <rthw.h>
#include <rtthread.h>

extern rt_list_t rt_thread_priority_table[RT_THREAD_PRIORITY_MAX];
extern struct rt_thread *rt_current_thread;
extern rt_uint32_t rt_thread_ready_priority_group;

rt_err_t _rt_thread_init(struct rt_thread *thread,
                        const char       *name,
                        void (*entry)(void *parameter),
                        void             *parameter,
                        void             *stack_start,
                        rt_uint32_t       stack_size,
                        rt_uint8_t        priority,
                        rt_uint32_t       tick)
{
    /* 初始化线程链表 */
    rt_list_init(&(thread->tlist));

    /* entry 是一个函数指针 */
    thread->entry = (void *)entry;
    thread->parameter = parameter;

    /* 初始化线程栈起始地址与大小 */
    thread->stack_addr = stack_start;
    thread->stack_size = stack_size;

    /* 初始化线程栈 */
    rt_memset(thread->stack_addr, '#', thread->stack_size);

    /* 初始化线程栈，并返回线程栈指针 */
    thread->sp = (void *)rt_hw_stack_init(thread->entry, thread->parameter,
                                          (rt_uint8_t *)((char *)thread->stack_addr + thread->stack_size - sizeof(rt_ubase_t)));
    /* 优先级初始化 */
    thread->init_priority = priority;
    thread->current_priority = priority;

    thread->number_mask = 0;
    
    /* 时间片初始化 */
    thread->init_tick = tick;
    thread->remaining_tick = tick;

    /* 线程错误码和状态初始化 */
    thread->error = RT_EOK;
    thread->stat = RT_THREAD_INIT;

    /* 初始化线程定时器 */
    rt_timer_init(&(thread->thread_timer),
                  thread->name,
                  rt_thread_timeout,
                  thread,
                  0,
                  RT_TIMER_FLAG_ONE_SHOT);

    return RT_EOK;
}

/**
 * This function will initialize a thread, normally it's used to initialize a
 * static thread object.
 *
 * @param thread the static thread object
 * @param name the name of thread, which shall be unique
 * @param entry the entry function of thread
 * @param parameter the parameter of thread enter function
 * @param stack_start the start address of thread stack
 * @param stack_size the size of thread stack
 *
 * @return the operation status, RT_EOK on OK, -RT_ERROR on error
 */
rt_err_t rt_thread_init(struct rt_thread *thread,
                        const char       *name,
                        void (*entry)(void *parameter),
                        void             *parameter,
                        void             *stack_start,
                        rt_uint32_t       stack_size,
                        rt_uint8_t        priority,
                        rt_uint32_t       tick)
{
    /* 线程对象初始化，线程结构体开头部分的四个成员就是 rt_object */
    rt_object_init((rt_object_t)thread, RT_Object_Class_Thread, name);

    return _rt_thread_init(thread,
                           name,
                           entry,
                           parameter,
                           stack_start,
                           stack_size,
                           priority,
                           tick);
}

/**
 * This function will return self thread object
 *
 * @return the self thread object
 */
rt_thread_t rt_thread_self(void)
{
    return rt_current_thread;
}

/**
 * This function will start a thread and put it to system ready queue
 *
 * @param thread the thread to be started
 *
 * @return the operation status, RT_EOK on OK, -RT_ERROR on error
 */
rt_err_t rt_thread_startup(rt_thread_t thread)
{
    /* 将当前优先级设置为初始优先级 */
    thread->current_priority = thread->init_priority;

    /* 计算优先级掩码 */
    thread->number_mask = 1L << thread->current_priority;

    /* 改变线程状态为挂起态 */
    thread->stat = RT_THREAD_SUSPEND;

    /* 恢复线程 */
    rt_thread_resume(thread);

    if (rt_thread_self() != RT_NULL)
    {
        /* 系统调度 */
        rt_schedule();
    }

    return RT_EOK;
}

/**
 * This function will suspend the specified thread.
 *
 * @param thread the thread to be suspended
 *
 * @return the operation status, RT_EOK on OK, -RT_ERROR on error
 *
 * @note if suspend self thread, after this function call, the
 * rt_schedule() must be invoked.
 */
rt_err_t rt_thread_suspend(rt_thread_t thread)
{
    register rt_base_t temp;

    if ((thread->stat & RT_THREAD_STAT_MASK) != RT_THREAD_READY)
    {
        return -RT_ERROR;
    }
    
    /* 关中断 */
    temp = rt_hw_interrupt_disable();

    /* 将线程从就绪列表中移除 */
    rt_schedule_remove_thread(thread);

    /* 改变线程状态 */
    thread->stat = RT_THREAD_SUSPEND | (thread->stat & ~RT_THREAD_STAT_MASK);

    /* 停止线程定时器 */
    rt_timer_stop(&(thread->thread_timer));

    /* 恢复中断 */
    rt_hw_interrupt_enable(temp);

    return RT_EOK;
}

/**
 * This function will resume a thread and put it to system ready queue.
 *
 * @param thread the thread to be resumed
 *
 * @return the operation status, RT_EOK on OK, -RT_ERROR on error
 */
rt_err_t rt_thread_resume(rt_thread_t thread)
{
    register rt_base_t temp;

    /* 被恢复的线程必须在挂起态，否则返回错误码 */
    if ((thread->stat & RT_THREAD_STAT_MASK) != RT_THREAD_SUSPEND)
    {
        return -RT_ERROR;
    }

    /* 关中断 */
    temp = rt_hw_interrupt_disable();

    /* 从挂起队列中移除 */
    rt_list_remove(&(thread->tlist));

    /* 恢复中断 */
    rt_hw_interrupt_enable(temp);

    /* 插入就绪列表 */
    rt_schedule_insert_thread(thread);

    return RT_EOK;
}

/**
 * This function will let current thread yield processor, and scheduler will
 * choose a highest thread to run. After yield processor, the current thread
 * is still in READY state.
 *
 * @return RT_EOK
 */
rt_err_t rt_thread_yield(void)
{
    register rt_base_t level;
    struct rt_thread *thread;

    /* 关中断 */
    level = rt_hw_interrupt_disable();

    /* 获取当前线程控制块指针 */
    thread = rt_current_thread;

    /* 如果线程状态为就绪态，并且同一个优先级下不止一个线程 */
    if ((thread->stat & RT_THREAD_STAT_MASK) == RT_THREAD_READY &&
        thread->tlist.next != thread->tlist.prev)
    {
        /* 将线程移出就绪列表 */
        rt_list_remove(&(thread->tlist));

        /* 将线程插入对应优先级就绪列表尾部 */
        rt_list_insert_before(&(rt_thread_priority_table[thread->current_priority]),
                              &(thread->tlist));

        /* 恢复中断 */
        rt_hw_interrupt_enable(level);

        /* 调度 */
        rt_schedule();

        return RT_EOK;
    }

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);
    
    return RT_EOK;
}

/**
 * This function will let current thread sleep for some ticks.
 *
 * @param tick the sleep ticks
 *
 * @return RT_EOK
 */
rt_err_t rt_thread_sleep(rt_tick_t tick)
{
    register rt_base_t temp;
    struct rt_thread *thread;

    /* 关中断 */
    temp = rt_hw_interrupt_disable();

    /* 获取当前线程的线程控制块 */
    thread = rt_current_thread;

    /* 挂起线程 */
    rt_thread_suspend(thread);

    /* 设置延时时间 */
    rt_timer_control(&(thread->thread_timer), RT_TIMER_CTRL_SET_TIME, &tick);

    /* 启动定时器 */
    rt_timer_start(&(thread->thread_timer));

    /* 恢复中断 */
    rt_hw_interrupt_enable(temp);

    /* 进行系统调度 */
    rt_schedule();

    /* 如果超时则改变线程的错误码为 RT_EOK */
    if (thread->error == -RT_ETIMEOUT)
        thread->error = RT_EOK;

    return RT_EOK;
}

/**
 * This function will let current thread delay for some ticks.
 *
 * @param tick the delay ticks
 *
 * @return RT_EOK
 */
rt_err_t rt_thread_delay(rt_tick_t tick)
{
    return rt_thread_sleep(tick);
}

/**
 * This function is the timeout function for thread, normally which is invoked
 * when thread is timeout to wait some resource.
 *
 * @param parameter the parameter of thread timeout function
 */
void rt_thread_timeout(void *parameter)
{
    struct rt_thread *thread;

    thread = (struct rt_thread *)parameter;

    /* 设置错误码为超时 */
    thread->error = -RT_ETIMEOUT;

    /* 将线程从挂起队列中移除 */
    rt_list_remove(&(thread->tlist));

    /* 将线程插入到就绪队列 */
    rt_schedule_insert_thread(thread);

    /* 系统调度 */
    rt_schedule();
}