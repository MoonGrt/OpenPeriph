#ifndef __LCD_H
#define __LCD_H

#include "cyber.h"
#include "dvtc.h"

/**
 * @brief LCD水平像素个数
 */
#define LCD_PIXEL_WIDTH ((uint16_t)480)

/**
 * @brief LCD垂直像素个数
 */
#define LCD_PIXEL_HEIGHT ((uint16_t)272)

/**
 * @brief LCD使用的像素格式
 */
#define LCD_PIXEL_FORMAT DVTC_Pixelformat_RGB888

/**
 * @brief LCD使用的像素格式需要占用字节
 */
#define LCD_PIXEL_BYTES (2)

/**
 * @brief 显存0起始地址
 */
#define LCD_VIDEO_BUFF0_ADDR ((uint32_t)0x40000000)

/**
 * @brief LCD显存大小，单位：字节
 */
#define LCD_VIDER_BUFF_SIZE ((uint32_t)LCD_PIXEL_WIDTH * LCD_PIXEL_HEIGHT * LCD_PIXEL_BYTES)

extern uint8_t FPS;

void LCD_DVTC_Init(void);

#endif /* __LCD_H */
