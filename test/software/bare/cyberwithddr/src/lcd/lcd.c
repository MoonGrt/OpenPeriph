#include "lcd.h"

// DVTiming DVTTfg = test;
static const DVTiming DVTTfg = h480_v272_r60;

// Framebuffer - 16-bit 2D array
__attribute__ ((section (".noinit"))) __attribute__ ((aligned (4*8))) uint16_t Framebuffer[DISPX][DISPY];

/* 当前使用的显存地址，不是当前显示的显存
   比如现在使用的显存为LCD_VIDEO_BUFF2_ADDR，则LCD正在显示的显存为LCD_VIDEO_BUFF0_ADDR
   这是为了避免在一边显示一边绘制图像，需要图像绘制完毕再显示 */
// uint32_t currentOptionVideoBuffAddr = LCD_VIDEO_BUFF1_ADDR;

/* 部分液晶信号线的引脚复用编号是AF9 */
#define GPIO_AF_DVTT_AF9 ((uint8_t)0x09)

/**
 * @brief  GPIO配置
 * @note   开启GPIO时钟，并配置GPIO
 * @param  None
 * @retval None
 */
static void GPIO_Config(void)
{
    // GPIO_InitTypeDef GPIO_InitStruct = {0};

    // /* GPIO配置 */
    // /* 红色数据线 */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_2 | GPIO_Pin_3 | GPIO_Pin_8;
    // GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    // GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF;
    // GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
    // GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
    // GPIO_Init(GPIOH, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource2, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource3, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource8, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
    // GPIO_Init(GPIOB, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource0, GPIO_AF_DVTT_AF9);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource1, GPIO_AF_DVTT_AF9);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    // GPIO_Init(GPIOA, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOA, GPIO_PinSource11, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOA, GPIO_PinSource12, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource6, GPIO_AF_DVTT);

    // /* 绿色数据线 */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_6;
    // GPIO_Init(GPIOE, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOE, GPIO_PinSource5, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOE, GPIO_PinSource6, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_13 | GPIO_Pin_15;
    // GPIO_Init(GPIOH, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource13, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource15, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource10, GPIO_AF_DVTT_AF9);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_2;
    // GPIO_Init(GPIOI, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource0, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource2, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7;
    // GPIO_Init(GPIOC, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOC, GPIO_PinSource7, GPIO_AF_DVTT);

    // /* 蓝色数据线 */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4;
    // GPIO_Init(GPIOE, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOE, GPIO_PinSource4, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource11, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource12, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6;
    // GPIO_Init(GPIOD, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOD, GPIO_PinSource6, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4;
    // GPIO_Init(GPIOI, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource4, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_3;
    // GPIO_Init(GPIOA, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOA, GPIO_PinSource3, GPIO_AF_DVTT);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9;
    // GPIO_Init(GPIOB, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource8, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource9, GPIO_AF_DVTT);

    // /* 控制线 */
    // /* DCLK */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource7, GPIO_AF_DVTT);

    // /* HSYNC(PI10)和VSYNC(PI9) */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_9 | GPIO_Pin_10;
    // GPIO_Init(GPIOI, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource9, GPIO_AF_DVTT);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource10, GPIO_AF_DVTT);

    // /* DE */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
    // GPIO_Init(GPIOF, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOF, GPIO_PinSource10, GPIO_AF_DVTT);

    // /* LCD_BL(PD7)和DISP(PD4) */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4 | GPIO_Pin_7;
    // GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    // GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
    // GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
    // GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_UP;
    // GPIO_Init(GPIOD, &GPIO_InitStruct);

    // /* 置位PD4和PD7 */
    // PDout(4) = 1;
    // PDout(7) = 1;
}

/**
 * @brief  DVTT配置
 * @param  None
 * @retval None
 */
static void DVTT_Config(void)
{
    DVTT_InitTypeDef DVTT_InitStruct;

    /* 配置DVTT外设 */
    /* 水平同步信号的有效极性 */
    DVTT_InitStruct.DVTT_HSPolarity = DVTT_HSPolarity_AL;
    /* 垂直同步信号的有效极性 */
    DVTT_InitStruct.DVTT_VSPolarity = DVTT_VSPolarity_AL;
    /* 数据使能信号的有效极性 */
    DVTT_InitStruct.DVTT_DEPolarity = DVTT_DEPolarity_AL;
    /* 像素时钟的有效极性，DVTT_PCPolarity_IPC为上升沿 */
    DVTT_InitStruct.DVTT_PCPolarity = DVTT_PCPolarity_IPC;
    /* 水平同步信号宽度，HSW - 1 */
    DVTT_InitStruct.DVTT_HorizontalSync = DVTTfg.hsync - 1;
    /* 垂直同步信号宽度，VSW - 1 */
    DVTT_InitStruct.DVTT_VerticalSync = DVTTfg.vsync - 1;
    /* HSW + HBP - 1 */
    DVTT_InitStruct.DVTT_AccumulatedHBP = DVTTfg.hsync + DVTTfg.hback - 1;
    /* VSW + VBP - 1 */
    DVTT_InitStruct.DVTT_AccumulatedVBP = DVTTfg.vsync + DVTTfg.vback - 1;
    /* HSW + HBP + 有效像素宽度 - 1 */
    DVTT_InitStruct.DVTT_AccumulatedActiveW = DVTTfg.hsync + DVTTfg.hback + DVTTfg.hdisp - 1;
    /* VSW + VBP + 有效像素高度 - 1 */
    DVTT_InitStruct.DVTT_AccumulatedActiveH = DVTTfg.vsync + DVTTfg.vback + DVTTfg.vdisp - 1;
    /* HSW + HBP + 有效像素宽度 + HFP - 1 */
    DVTT_InitStruct.DVTT_TotalWidth = DVTTfg.hsync + DVTTfg.hback + DVTTfg.hdisp + DVTTfg.hfront - 1;
    /* VSW + VBP + 有效像素高度 + VFP - 1 */
    DVTT_InitStruct.DVTT_TotalHeigh = DVTTfg.vsync + DVTTfg.vback + DVTTfg.vdisp + DVTTfg.vfront - 1;
    /* LCD背景默认颜色 */
    DVTT_InitStruct.DVTT_BackgroundRedValue = 0;
    DVTT_InitStruct.DVTT_BackgroundGreenValue = 0;
    DVTT_InitStruct.DVTT_BackgroundBlueValue = 0;

    /* LCD初始化 */
    DVTT_Init(&DVTT_InitStruct);
}

/**
 * @brief  DVTT配置
 * @param  None
 * @retval None
 */
static void DVTT_Layer_Config(void)
{
    DVTT_Layer_InitTypeDef DVTT_Layer_InitStruct;

    /* DVTT层级配置 */
    /* Layer1 */
    /* 水平第一个有效像素位置，HSW + HBP */
    DVTT_Layer_InitStruct.DVTT_HorizontalStart = DVTTfg.hsync + DVTTfg.hback;
    /* 水平最后一个有效像素位置，HSW + HBP + 有效像素宽度 - 1 */
    DVTT_Layer_InitStruct.DVTT_HorizontalStop = DVTTfg.hsync + DVTTfg.hback + DVTTfg.hdisp - 1;
    /* 垂直第一个有效像素位置，VSW + VBP */
    DVTT_Layer_InitStruct.DVTT_VerticalStart = DVTTfg.vsync + DVTTfg.vback;
    /* 垂直最后一个有效像素位置，VSW + VBP + 有效像素高度 - 1 */
    DVTT_Layer_InitStruct.DVTT_VerticalStop = DVTTfg.vsync + DVTTfg.vback + DVTTfg.vdisp - 1;
    /* 层使用的像素格式 */
    DVTT_Layer_InitStruct.DVTT_PixelFormat = LCD_PIXEL_FORMAT;
    /* 恒定混合系数 Alpha ，真正的系数为除以 255 后的值 */
    DVTT_Layer_InitStruct.DVTT_ConstantAlpha = 0xFF;
    /* 层默认背景颜色 */
    DVTT_Layer_InitStruct.DVTT_DefaultColorBlue = 0xFF;
    DVTT_Layer_InitStruct.DVTT_DefaultColorGreen = 0;
    DVTT_Layer_InitStruct.DVTT_DefaultColorRed = 0;
    DVTT_Layer_InitStruct.DVTT_DefaultColorAlpha = 0;
    /* 混合系数 F1 和 F2，均为CA并且混合系数 Alpha 为 0xFF，则上一层的像素不会参与运算 */
    DVTT_Layer_InitStruct.DVTT_BlendingFactor_1 = DVTT_BlendingFactor1_CA;
    DVTT_Layer_InitStruct.DVTT_BlendingFactor_2 = DVTT_BlendingFactor2_CA;
    /* 层的显存地址 */
    DVTT_Layer_InitStruct.DVTT_CFBStartAdress = LCD_VIDEO_BUFF_ADDR;
    /* 层的行数据长度，单位字节 */
    /* 行有效像素个数 * 像素占用的字节数量 + 3 */
    DVTT_Layer_InitStruct.DVTT_CFBLineLength = DVTTfg.hdisp * LCD_PIXEL_BYTES + 3;
    /* 从像素某行的起始处到下一行的起始处的增量（以字节为单位） */
    /* 行有效像素个数 * 像素占用的字节数量 */
    DVTT_Layer_InitStruct.DVTT_CFBPitch = DVTTfg.hdisp * LCD_PIXEL_BYTES;
    /* 层的行数 */
    DVTT_Layer_InitStruct.DVTT_CFBLineNumber = DVTTfg.vdisp;

    /* 初始化 */
    DVTT_LayerInit(DVTT_Layer1, &DVTT_Layer_InitStruct);

    //    /* Layer2 */
    //    /* 层默认背景颜色 */
    //    DVTT_Layer_InitStruct.DVTT_DefaultColorBlue = 0;
    //    DVTT_Layer_InitStruct.DVTT_DefaultColorGreen = 0;
    //    DVTT_Layer_InitStruct.DVTT_DefaultColorRed = 0;
    //    DVTT_Layer_InitStruct.DVTT_DefaultColorAlpha = 0;
    //    /* 层使用的像素格式 */
    //    DVTT_Layer_InitStruct.DVTT_PixelFormat = LCD_LAYER2_PIXEL_FORMAT;
    //    /* 混合系数 F1 和 F2 ，混合因子都配置成 PAxCA 以便它的透明像素能参与运算，实现透明效果 */
    //    DVTT_Layer_InitStruct.DVTT_BlendingFactor_1 = DVTT_BlendingFactor1_PAxCA;
    //    DVTT_Layer_InitStruct.DVTT_BlendingFactor_2 = DVTT_BlendingFactor2_PAxCA;
    //    /* 层的显存地址 */
    //    DVTT_Layer_InitStruct.DVTT_CFBStartAdress = LCD_LAYER2_VIDEO_BUFF_ADDR;
    //    /* 层的行数据长度，单位字节 */
    //    /* 行有效像素个数 * 像素占用的字节数量 + 3 */
    //    DVTT_Layer_InitStruct.DVTT_CFBLineLength = LCD_PIXEL_WIDTH * LCD_LAYER2_PIXEL_BYTES + 3;
    //    /* 从像素某行的起始处到下一行的起始处的增量（以字节为单位） */
    //    /* 行有效像素个数 * 像素占用的字节数量 */
    //    DVTT_Layer_InitStruct.DVTT_CFBPitch = LCD_PIXEL_WIDTH * LCD_LAYER2_PIXEL_BYTES;
    //
    //    /* 初始化 */
    //    DVTT_LayerInit(DVTT_Layer2, &DVTT_Layer_InitStruct);

    /* 层使能 */
    DVTT_LayerCmd(DVTT_Layer1, ENABLE);
    //    DVTT_LayerCmd(DVTT_Layer2, ENABLE);

    /* 立即重载影子寄存器 */
    DVTT_ReloadConfig(DVTT_IMReload);
    // DVTT_ReloadConfig(DVTT_VBReload);
    /* 使能抖动，当 LCD 与 显存的像素格式不符合的时候可开启该功能 */
    // DVTT_DitherCmd(ENABLE);
}

/**
 * @brief  LCD初始化
 * @note   使用了DVTT外设，使用2层，均为 800 * 480 分辨率，颜色格式均为 ARGB8888
 *           使用DVTT前需要先初始化SDRAM，因为显存在SDRAM中
 * @param  None
 * @retval None
 */
void LCD_DVTT_Init(void)
{
    /* GPIO配置 */
    // GPIO_Config();
    /* DVTT配置 */
    DVTT_Config();
    /* DVTT_Layer配置 */
    DVTT_Layer_Config();
}
