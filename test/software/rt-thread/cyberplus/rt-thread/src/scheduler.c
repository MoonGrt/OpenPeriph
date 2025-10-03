#include <rtthread.h>
#include <rthw.h>

/* 线程优先级列表 */
rt_list_t rt_thread_priority_table[RT_THREAD_PRIORITY_MAX];

/* 线程就绪优先级组，每一位对应 rt_thread_priority_table 对应下标是否有就绪线程 */
rt_uint32_t rt_thread_ready_priority_group;

/* 中断嵌套层数（当前 cpu 不支持中断嵌套，所以此值只用来判断当前是否处在中断中） */
extern volatile rt_uint8_t rt_interrupt_nest;

/* 调度器是否上锁 */
static rt_int16_t rt_scheduler_lock_nest;

/* 当前线程控制块指针 */
struct rt_thread *rt_current_thread = RT_NULL; 

/* 当前优先级 */
rt_uint8_t rt_current_priority;

/**
 * @ingroup SystemInit
 * This function will initialize the system scheduler
 */
void rt_system_scheduler_init(void)
{
    register rt_base_t offset;

    rt_scheduler_lock_nest = 0;

    /* 线程就绪列表初始化 */
    for (offset = 0; offset < RT_THREAD_PRIORITY_MAX; offset++)
    {
        rt_list_init(&rt_thread_priority_table[offset]);
    }

    /* 初始化当前优先级为空闲线程的优先级 */
    rt_current_priority = RT_THREAD_PRIORITY_MAX - 1;

    /* 初始化当前线程控制块指针 */
    rt_current_thread = RT_NULL;

    /* 初始化就绪优先级组 */
    rt_thread_ready_priority_group = 0;
}

/**
 * @ingroup SystemInit
 * This function will startup scheduler. It will select one thread
 * with the highest priority level, then switch to it.
 */
void rt_system_scheduler_start(void)
{
    register struct rt_thread *to_thread;
    register rt_ubase_t highest_ready_priority;

    /* 获取就绪的最高优先级（RT_THREAD_PRIORITY_MAX < 32） */
    highest_ready_priority = __rt_ffs(rt_thread_ready_priority_group) - 1;

    /* 获取将要运行线程的线程控制块 */
    to_thread = rt_list_entry(rt_thread_priority_table[highest_ready_priority].next,
                              struct rt_thread,
                              tlist);
    
    rt_current_thread = to_thread;

    /* 切换到新线程 */
    rt_hw_context_switch_to((rt_uint32_t)&to_thread->sp);

    /* never come back */
}

/**
 * This function will perform one schedule. It will select one thread
 * with the highest priority level, then switch to it.
 * 本章加入了优先级，所以此处要选择当前优先级最高的线程切换
 */
void rt_schedule(void)
{
    rt_base_t level;
    struct rt_thread *to_thread;
    struct rt_thread *from_thread;

    /* 关中断 */
    level = rt_hw_interrupt_disable();
    
    /* 检查调度器是否使能 */
    if (rt_scheduler_lock_nest == 0)
    {
        register rt_ubase_t highest_ready_priority;

        /* 获取线程就绪的最高优先级 */
        highest_ready_priority = __rt_ffs(rt_thread_ready_priority_group) - 1;

        /* 获取就绪的最高优先级对应的线程控制块 */
        to_thread = rt_list_entry(rt_thread_priority_table[highest_ready_priority].next,
                                struct rt_thread,
                                tlist);
        
        /* 如果不是当前线程，则需要进行线程切换 */
        if (to_thread != rt_current_thread)
        {
            rt_current_priority = (rt_uint8_t)highest_ready_priority;
            from_thread = rt_current_thread;
            rt_current_thread = to_thread;

            /* 上下文切换 */
            if (rt_interrupt_nest == 0)  /* 若 rt_interrupt_nest = 0 则表示当前未处在中断状态 */
            {
                //printf("switch not in interrupt\n");
                rt_hw_context_switch((rt_uint32_t)&from_thread->sp, 
                                     (rt_uint32_t)&to_thread->sp);
                
                /* 恢复中断 */
                rt_hw_interrupt_enable(level);

                return;
            }
            else
            {
                //printf("switch in interrupt\n");
                rt_hw_context_switch_interrupt((rt_ubase_t)&from_thread->sp,
                                               (rt_ubase_t)&to_thread->sp);
            }
        }
    }

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);
}

/*
 * This function will insert a thread to system ready queue. The state of
 * thread will be set as READY and remove from suspend queue.
 *
 * @param thread the thread to be inserted
 * @note Please do not invoke this function in user application.
 */
void rt_schedule_insert_thread(struct rt_thread *thread)
{
    register rt_base_t temp;

    /* 关中断 */
    temp = rt_hw_interrupt_disable();

    /* 改变线程状态 */
    thread->stat = RT_THREAD_READY | (thread->stat & ~RT_THREAD_STAT_MASK);

    /* 将线程插入就绪列表 */
    rt_list_insert_before(&(rt_thread_priority_table[thread->current_priority]),
                          &(thread->tlist));

    /* 设置线程就绪优先级组中对应位 */
    rt_thread_ready_priority_group |= thread->number_mask;

    /* 恢复中断 */
    rt_hw_interrupt_enable(temp);
}

/*
 * This function will remove a thread from system ready queue.
 *
 * @param thread the thread to be removed
 *
 * @note Please do not invoke this function in user application.
 */
void rt_schedule_remove_thread(struct rt_thread *thread)
{
    register rt_base_t temp;

    /* 关中断 */
    temp = rt_hw_interrupt_disable();

    /* 将线程从就绪列表中移除 */
    rt_list_remove(&(thread->tlist));

    /* 将线程就绪优先级组对应的位清除 */
    if (rt_list_isempty(&(rt_thread_priority_table[thread->current_priority])))
    {
        rt_thread_ready_priority_group &= ~thread->number_mask;
    }

    /* 恢复中断 */
    rt_hw_interrupt_enable(temp);
}
