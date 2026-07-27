#ifndef __ST7789_HARD_H
#define __ST7789_HARD_H

#include "cyber.h"
#include "delay.h"
#include "st7789.h"

void ST7789_HARD_GPIO_Init(void);
void ST7789_HARD_Init(void);
void ST7789_HARD_Reset(void);
void ST7789_HARD_WriteCmd(uint8_t cmd);
void ST7789_HARD_WriteData(uint8_t data);
void ST7789_HARD_Fill_ColorBar(void);

#endif