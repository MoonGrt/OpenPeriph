#ifndef __ST7789_SOFT_H
#define __ST7789_SOFT_H

#include "cyber.h"
#include "delay.h"
#include "st7789.h"

void ST7789_SOFT_GPIO_Init(void);
void ST7789_SOFT_Init(void);
void ST7789_SOFT_Reset(void);
void ST7789_SOFT_WriteCmd(uint8_t cmd);
void ST7789_SOFT_WriteData(uint8_t data);
void ST7789_SOFT_Fill_ColorBar(void);

#endif