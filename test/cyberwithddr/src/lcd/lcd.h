#ifndef __LCD_H
#define __LCD_H

#include "main.h"

/* LTDC仅使用一个图层，前景和背景通过DMA2D来实现 */

/**
 * @brief LCD水平像素个数
 */
#define LCD_PIXEL_WIDTH ((uint16_t)800)

/**
 * @brief LCD垂直像素个数
 */
#define LCD_PIXEL_HEIGHT ((uint16_t)480)

/**
 * @brief LCD使用的像素格式
 */
#define LCD_PIXEL_FORMAT LTDC_Pixelformat_RGB888

/**
 * @brief LCD使用的像素格式需要占用字节
 */
#define LCD_PIXEL_BYTES (3)

/**
 * @brief 显存0起始地址
 */
#define LCD_VIDEO_BUFF0_ADDR ((uint32_t)0xD0000000)

/**
 * @brief LCD显存大小，单位：字节
 */
#define LCD_VIDER_BUFF_SIZE ((uint32_t)LCD_PIXEL_WIDTH * LCD_PIXEL_HEIGHT * LCD_PIXEL_BYTES)

// #define LCD_VIDEO_BUFF1_ADDR            ((uint32_t)0xD0000000 + LCD_VIDER_BUFF_SIZE * 1)

extern uint8_t FPS;
// extern uint32_t currentOptionVideoBuffAddr;

void LCD_LTDC_DMA2D_Init(void);
int LCD_Fill(uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint8_t alpha, uint8_t red, uint8_t green, uint8_t blue);
int LCD_Copy(uint32_t srcAddr, uint32_t destAddr,
             uint8_t srcOffLine,
             uint16_t x0, uint16_t y0, uint16_t width, uint16_t height,
             uint16_t x1, uint16_t y1);
int LCD_PFC_Copy(uint32_t srcAddr, uint32_t destAddr,
                 uint8_t srcOffLine,
                 uint16_t x0, uint16_t y0, uint16_t width, uint16_t height,
                 uint16_t x1, uint16_t y1, uint32_t pixelFormat);
int LCD_Mix_Copy(uint32_t FGAddr, uint32_t BGAddr, uint32_t destAddr,
                 uint8_t FGOffLine, uint8_t BGOffLine,
                 uint16_t xfg, uint16_t yfg, uint16_t width, uint16_t height,
                 uint16_t xbg, uint16_t ybg,
                 uint16_t x1, uint16_t y1, uint32_t FGpixelFormat, uint32_t BGpixelFormat);
uint32_t LCD_Change_Video_Buff(void);
void LCD_Copy_Demo(void);
void LCD_PFC_Copy_Demo(void);
void LCD_Mix_Copy_Demo(void);

#endif /* __LCD_H */
