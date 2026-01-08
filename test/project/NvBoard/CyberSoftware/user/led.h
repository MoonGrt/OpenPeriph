
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __LED_H
#define __LED_H

/* Includes ------------------------------------------------------------------*/
#include <rtthread.h>
#include "led.h"
#include "finsh.h"
#include "cyber.h"

/* 线程控制块定义 */
struct rt_thread th_led;

ALIGN(RT_ALIGN_SIZE)
/* 定义线程栈 */
rt_uint8_t rt_thled_stack[512];

void GPIO_init(void);
void th_led_en(void *p_arg);
// long led_init(void);

#endif /* __LED_H */
