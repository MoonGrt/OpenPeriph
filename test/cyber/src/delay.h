#ifndef __DELAY_H
#define __DELAY_H

#include "cyber.h"

void delay_init(void);
void delay_ms(uint16_t nms);
void delay_us(uint32_t nus);
void delay_us(uint32_t ns);

#endif
