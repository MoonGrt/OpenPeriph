#ifndef __LCD_H
#define __LCD_H

#include "cyber.h"
#include "dvtc.h"

// #define DISPX 30
// #define DISPY 20
#define DISPX 480
#define DISPY 272

/* 根据液晶数据手册的参数配置 */
static const DVTiming test = {
    .hsync = 1, .hback = 2, .hdisp = DISPX, .hfront = 1,
    .vsync = 1, .vback = 2, .vdisp = DISPY, .vfront = 1,
    .vspol = FALSE, .hspol = FALSE, .depol = FALSE, .pcpol = FALSE
};
static const DVTiming h480_v272_r60 = {
    .hsync = 41, .hback = 2, .hdisp = DISPX, .hfront = 2,
    .vsync = 10, .vback = 2, .vdisp = DISPY, .vfront = 2,
    .vspol = FALSE, .hspol = FALSE, .depol = FALSE, .pcpol = FALSE
};

/* LCD使用的像素格式 */
#define LCD_PIXEL_FORMAT DVTC_Pixelformat_RGB565
/* LCD使用的像素格式需要占用字节 */
#define LCD_PIXEL_BYTES (2)
/* 显存起始地址 */
extern uint16_t Framebuffer[DISPX][DISPY];
#define LCD_VIDEO_BUFF_ADDR (uint32_t)Framebuffer;

void LCD_DVTC_Init(void);

#endif /* __LCD_H */
