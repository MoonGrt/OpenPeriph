#ifndef __RT_THREAD_H__
#define __RT_THREAD_H__

#include <rtdef.h>
#include <rtservice.h>
#include <rtconfig.h>

/*
 * kernel object interface
 */
struct rt_object_information *
rt_object_get_information(enum rt_object_class_type type);
void rt_object_init(struct rt_object         *object,
                    enum rt_object_class_type type,
                    const char               *name);

/*
 * clock & timer interface
 */
rt_tick_t rt_tick_get(void);
void rt_tick_set(rt_tick_t tick);
void rt_tick_increase(void);

void rt_system_timer_init(void);

void rt_timer_init(rt_timer_t  timer,
                   const char *name,
                   void (*timeout)(void *parameter),
                   void       *parameter,
                   rt_tick_t   time,
                   rt_uint8_t  flag);
rt_err_t rt_timer_start(rt_timer_t timer);
rt_err_t rt_timer_stop(rt_timer_t timer);
rt_err_t rt_timer_control(rt_timer_t timer, int cmd, void *arg);

void rt_timer_check(void);

/*
 * thread interface
 */
rt_err_t rt_thread_init(struct rt_thread *thread,
                        const char       *name,
                        void (*entry)(void *parameter),
                        void             *parameter,
                        void             *stack_start,
                        rt_uint32_t       stack_size,
                        rt_uint8_t        priority,
                        rt_uint32_t       tick);
rt_thread_t rt_thread_self(void);
rt_err_t rt_thread_startup(rt_thread_t thread);

rt_err_t rt_thread_yield(void);
rt_err_t rt_thread_delay(rt_tick_t tick);
rt_err_t rt_thread_suspend(rt_thread_t thread);
rt_err_t rt_thread_resume(rt_thread_t thread);
void rt_thread_timeout(void *parameter);

/*
 * idle thread interface
 */
void rt_thread_idle_init(void);
rt_thread_t rt_thread_idle_gethandler(void);

/*
 * schedule service
 */
void rt_system_scheduler_init(void);
void rt_system_scheduler_start(void);
void rt_schedule(void);
void rt_schedule_insert_thread(struct rt_thread *thread);
void rt_schedule_remove_thread(struct rt_thread *thread);

/*
 * interrupt service
 */

/*
 * rt_interrupt_enter and rt_interrupt_leave only can be called by BSP
 */
void rt_interrupt_enter(void);
void rt_interrupt_leave(void);

/*
 * general kernel service
 */
rt_int32_t rt_strncmp(const char *cs, const char *ct, rt_ubase_t count);
char *rt_strncpy(char *dest, const char *src, rt_ubase_t n);
void *rt_memmove(void *dest, const void *src, rt_ubase_t n);
rt_size_t rt_strlen(const char *src);
int __rt_ffs(int value);
void *rt_memset(void *src, int c, rt_ubase_t n);
void *rt_memcpy(void *dst, const void *src, rt_ubase_t count);
rt_int32_t rt_memcmp(const void *cs, const void *ct, rt_ubase_t count);
void rt_show_version(void);

#endif
