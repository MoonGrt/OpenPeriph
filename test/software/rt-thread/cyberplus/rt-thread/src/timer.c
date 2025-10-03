#include <rtthread.h>
#include <rthw.h>

/* 硬件定时器列表 */
static rt_list_t rt_timer_list[RT_TIMER_SKIP_LIST_LEVEL];


static void _rt_timer_init(rt_timer_t timer,
                           void (*timeout)(void *parameter),
                           void      *parameter,
                           rt_tick_t  time,
                           rt_uint8_t flag)
{
    int i;

    /* 设置标志 */
    timer->parent.flag = flag;

    /* 设置为非激活态 */
    timer->parent.flag &= ~RT_TIMER_FLAG_ACTIVATED;

    timer->timeout_func = timeout;
    timer->parameter = parameter;

    timer->timeout_tick = 0;
    timer->init_tick = time;

    /* 初始化 timer 内置 list 节点 */
    for (i = 0; i < RT_TIMER_SKIP_LIST_LEVEL; i++)
    {
        rt_list_init(&(timer->row[i]));
    }
}

rt_inline void _rt_timer_remove(rt_timer_t timer)
{
    int i;

    for (i = 0; i < RT_TIMER_SKIP_LIST_LEVEL; i++)
    {
        rt_list_remove(&(timer->row[i]));
    }
    
}

/**
 * @ingroup SystemInit
 *
 * This function will initialize system timer
 */
void rt_system_timer_init(void)
{
    int i;

    for (i = 0; i < RT_TIMER_SKIP_LIST_LEVEL; i++)
    {
        rt_list_init(&(rt_timer_list[i]));
    }
}

/**
 * This function will initialize a timer, normally this function is used to
 * initialize a static timer object.
 *
 * @param timer the static timer object
 * @param name the name of timer
 * @param timeout the timeout function
 * @param parameter the parameter of timeout function
 * @param time the tick of timer
 * @param flag the flag of timer
 */
void rt_timer_init(rt_timer_t  timer,
                   const char *name,
                   void (*timeout)(void *parameter),
                   void       *parameter,
                   rt_tick_t   time,
                   rt_uint8_t  flag)
{
    /* 定时器对象初始化 */
    rt_object_init((rt_object_t)timer, RT_Object_Class_Timer, name);
    
    /* 定时器对象初始化 */
    _rt_timer_init(timer, timeout, parameter, time, flag);
}

/**
 * This function will start the timer
 *
 * @param timer the timer to be started
 *
 * @return the operation status, RT_EOK on OK, -RT_ERROR on error
 */
rt_err_t rt_timer_start(rt_timer_t timer)
{
    unsigned int row_lvl;
    rt_list_t *timer_list;
    register rt_base_t level;
    rt_list_t *row_head[RT_TIMER_SKIP_LIST_LEVEL];
    unsigned int tst_nr;
    static unsigned int random_nr;

    /* 关中断 */
    level = rt_hw_interrupt_disable();

    /* 将定时器从列表中移除 */
    _rt_timer_remove(timer);

    /* 将定时器的状态设置为非激活态 */
    timer->parent.flag &= ~RT_TIMER_FLAG_ACTIVATED;

    /* 获取 timeout tick，并且 timeout tick 应该小于 RT_TICK_MAX/2 */
    timer->timeout_tick = rt_tick_get() + timer->init_tick;

    timer_list = rt_timer_list;
    row_head[0] = &timer_list[0];

    /* 判断定时器应该插到哪个位置 */
    for (row_lvl = 0; row_lvl < RT_TIMER_SKIP_LIST_LEVEL; row_lvl++)
    {
        for (; row_head[row_lvl] != timer_list[row_lvl].prev; row_head[row_lvl] = row_head[row_lvl]->next)
        {
            struct rt_timer *t;
            rt_list_t *p = row_head[row_lvl]->next;

            /* 获取父结构的指针 */
            t = rt_list_entry(p, struct rt_timer, row[row_lvl]);

            /* 当两个定时器的 tick 相同时，则继续在定时器列表中寻找下一个节点 */
            if ((t->timeout_tick - timer->timeout_tick) == 0)
            {
                continue;
            }
            else if ((t->timeout_tick - timer->timeout_tick) < RT_TICK_MAX / 2)
            {
                break;
            }
        }
        /* 当 RT_TIMER_SKIP_LIST_LEVEL 为 1 时，以下语句不会执行 */
        if (row_lvl != RT_TIMER_SKIP_LIST_LEVEL - 1)
            row_head[row_lvl + 1] = row_head[row_lvl] + 1;
    }

    /* 静态变量，用于记录启动了多少定时器 */
    random_nr++;
    tst_nr = random_nr;
    
    /* 将定时器插入到系统定时器列表中 */
    rt_list_insert_after(row_head[RT_TIMER_SKIP_LIST_LEVEL - 1],
                         &(timer->row[RT_TIMER_SKIP_LIST_LEVEL - 1]));
    
    /* 当 RT_TIMER_SKIP_LIST_LEVEL 为 1 时，以下语句不会执行 */
    for (row_lvl = 2; row_lvl <= RT_TIMER_SKIP_LIST_LEVEL; row_lvl++)
    {
        if (!(tst_nr & RT_TIMER_SKIP_LIST_MASK))
            rt_list_insert_after(row_head[RT_TIMER_SKIP_LIST_LEVEL - row_lvl],
                                 &(timer->row[RT_TIMER_SKIP_LIST_LEVEL - row_lvl]));
        else
            break;
        
        tst_nr >>= (RT_TIMER_SKIP_LIST_MASK + 1) >> 1;
    }

    /* 设置定时器标志位为激活态 */
    timer->parent.flag |= RT_TIMER_FLAG_ACTIVATED;

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);

    return RT_EOK;
}

/**
 * This function will stop the timer
 *
 * @param timer the timer to be stopped
 *
 * @return the operation status, RT_EOK on OK, -RT_ERROR on error
 */
rt_err_t rt_timer_stop(rt_timer_t timer)
{
    register rt_base_t level;

    /* 只有处于激活态的定时器才能被停止 */
    if (!(timer->parent.flag & RT_TIMER_FLAG_ACTIVATED))
        return -RT_ERROR;
    
    /* 关中断 */
    level = rt_hw_interrupt_disable();

    /* 将定时器从系统定时器列表中移除 */
    _rt_timer_remove(timer);

    /* 改变定时器状态为非激活态 */
    timer->parent.flag &= ~RT_TIMER_FLAG_ACTIVATED;

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);

    return RT_EOK;
}

/**
 * This function will get or set some options of the timer
 *
 * @param timer the timer to be get or set
 * @param cmd the control command
 * @param arg the argument
 *
 * @return RT_EOK
 */
rt_err_t rt_timer_control(rt_timer_t timer, int cmd, void *arg)
{
    register rt_base_t level;

    /* 关中断 */
    level = rt_hw_interrupt_disable();

    switch (cmd)
    {
    case RT_TIMER_CTRL_GET_TIME:
        *(rt_tick_t *)arg = timer->init_tick;
        break;
    
    case RT_TIMER_CTRL_SET_TIME:
        timer->init_tick = *(rt_tick_t *)arg;
        break;

    case RT_TIMER_CTRL_SET_ONESHOT:
        timer->parent.flag &= ~RT_TIMER_FLAG_PERIODIC;
        break;

    case RT_TIMER_CTRL_SET_PERIODIC:
        timer->parent.flag |= RT_TIMER_FLAG_PERIODIC;
        break;

    case RT_TIMER_CTRL_GET_STATE:
        if (timer->parent.flag & RT_TIMER_FLAG_ACTIVATED)
        {
            *(rt_tick_t *)arg = RT_TIMER_FLAG_ACTIVATED;
        }
        else
        {
            *(rt_tick_t *)arg = RT_TIMER_FLAG_DEACTIVATED;
        }
        break;
        
    default:
        break;
    }

    /* 恢复中断 */
    rt_hw_interrupt_enable(level);

    return RT_EOK;
}

/**
 * This function will check timer list, if a timeout event happens, the
 * corresponding timeout function will be invoked.
 *
 * @note this function shall be invoked in operating system timer interrupt.
 */
void rt_timer_check(void)
{
    struct rt_timer *t;
    rt_tick_t current_tick;
    register rt_base_t level;
    rt_list_t list;

    rt_list_init(&list);

    /* 获取当前系统节拍 */
    current_tick = rt_tick_get();

    /* 关中断 */
    level = rt_hw_interrupt_disable();

    /* 如果系统定时器列表非空，则进入循环 */
    while (!rt_list_isempty(&rt_timer_list[RT_TIMER_SKIP_LIST_LEVEL - 1]))
    {
        t = rt_list_entry(rt_timer_list[RT_TIMER_SKIP_LIST_LEVEL - 1].next,
                          struct rt_timer,
                          row[RT_TIMER_SKIP_LIST_LEVEL - 1]);
        
        /* 如果当前定时器已超时 */
        if ((current_tick - t->timeout_tick) < RT_TICK_MAX / 2)
        {
            /* 将定时器从系统定时器列表中移除 */
            _rt_timer_remove(t);

            /* 如果定时器不是周期定时，则设置其为非激活态 */
            if (!(t->parent.flag & RT_TIMER_FLAG_PERIODIC))
            {
                t->parent.flag &= ~RT_TIMER_FLAG_ACTIVATED;
            }

            /* 将定时器加入到临时列表中 */
            rt_list_insert_after(&list, &(t->row[RT_TIMER_SKIP_LIST_LEVEL - 1]));

            /* 调用超时函数 */
            t->timeout_func(t->parameter);

            /* 重新获取系统节拍 */
            current_tick = rt_tick_get();

            /* 检查定时器对象是分离还是重新启动 */
            if (rt_list_isempty(&list))
            {
                continue;
            }

            /* 将定时器从临时列表中删除 */
            rt_list_remove(&(t->row[RT_TIMER_SKIP_LIST_LEVEL - 1]));

            /* 如果是周期定时则重新启动定时器 */
            if ((t->parent.flag & RT_TIMER_FLAG_PERIODIC) && (t->parent.flag & RT_TIMER_FLAG_ACTIVATED))
            {
                /* 重新启动定时器 */
                t->parent.flag &= ~RT_TIMER_FLAG_ACTIVATED;
                rt_timer_start(t);
            }  
        }
        else
            break;
        
    }
    
    /* 恢复中断 */
    rt_hw_interrupt_enable(level);
}
