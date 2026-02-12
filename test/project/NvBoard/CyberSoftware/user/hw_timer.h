#ifndef __TIMER_H__
#define __TIMER_H__

#include <rtthread.h>

/* timer */
extern void hw_timer_init();
extern void hw_timer_irq_handler();

#endif