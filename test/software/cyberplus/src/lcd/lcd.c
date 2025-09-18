#include "lcd.h"

// DVTiming DVTCfg = test;
static const DVTiming DVTCfg = h480_v272_r60;

// Framebuffer - 16-bit 2D array
__attribute__ ((section (".noinit"))) __attribute__ ((aligned (4*8))) uint16_t Framebuffer[DISPX][DISPY];

/* 当前使用的显存地址，不是当前显示的显存
   比如现在使用的显存为LCD_VIDEO_BUFF2_ADDR，则LCD正在显示的显存为LCD_VIDEO_BUFF0_ADDR
   这是为了避免在一边显示一边绘制图像，需要图像绘制完毕再显示 */
// uint32_t currentOptionVideoBuffAddr = LCD_VIDEO_BUFF1_ADDR;

/* 部分液晶信号线的引脚复用编号是AF9 */
#define GPIO_AF_DVTC_AF9 ((uint8_t)0x09)

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
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource2, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource3, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource8, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
    // GPIO_Init(GPIOB, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource0, GPIO_AF_DVTC_AF9);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource1, GPIO_AF_DVTC_AF9);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    // GPIO_Init(GPIOA, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOA, GPIO_PinSource11, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOA, GPIO_PinSource12, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource6, GPIO_AF_DVTC);

    // /* 绿色数据线 */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_6;
    // GPIO_Init(GPIOE, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOE, GPIO_PinSource5, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOE, GPIO_PinSource6, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_13 | GPIO_Pin_15;
    // GPIO_Init(GPIOH, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource13, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOH, GPIO_PinSource15, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource10, GPIO_AF_DVTC_AF9);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_2;
    // GPIO_Init(GPIOI, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource0, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource2, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7;
    // GPIO_Init(GPIOC, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOC, GPIO_PinSource7, GPIO_AF_DVTC);

    // /* 蓝色数据线 */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4;
    // GPIO_Init(GPIOE, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOE, GPIO_PinSource4, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource11, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource12, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6;
    // GPIO_Init(GPIOD, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOD, GPIO_PinSource6, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4;
    // GPIO_Init(GPIOI, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource4, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_3;
    // GPIO_Init(GPIOA, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOA, GPIO_PinSource3, GPIO_AF_DVTC);
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9;
    // GPIO_Init(GPIOB, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource8, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOB, GPIO_PinSource9, GPIO_AF_DVTC);

    // /* 控制线 */
    // /* DCLK */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7;
    // GPIO_Init(GPIOG, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOG, GPIO_PinSource7, GPIO_AF_DVTC);

    // /* HSYNC(PI10)和VSYNC(PI9) */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_9 | GPIO_Pin_10;
    // GPIO_Init(GPIOI, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource9, GPIO_AF_DVTC);
    // GPIO_PinAFConfig(GPIOI, GPIO_PinSource10, GPIO_AF_DVTC);

    // /* DE */
    // GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
    // GPIO_Init(GPIOF, &GPIO_InitStruct);
    // GPIO_PinAFConfig(GPIOF, GPIO_PinSource10, GPIO_AF_DVTC);

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
 * @brief  DVTC配置
 * @param  None
 * @retval None
 */
static void DVTC_Config(void)
{
    DVTC_InitTypeDef DVTC_InitStruct;

    /* 配置DVTC外设 */
    /* 水平同步信号的有效极性 */
    DVTC_InitStruct.DVTC_HSPolarity = DVTC_HSPolarity_AL;
    /* 垂直同步信号的有效极性 */
    DVTC_InitStruct.DVTC_VSPolarity = DVTC_VSPolarity_AL;
    /* 数据使能信号的有效极性 */
    DVTC_InitStruct.DVTC_DEPolarity = DVTC_DEPolarity_AL;
    /* 像素时钟的有效极性，DVTC_PCPolarity_IPC为上升沿 */
    DVTC_InitStruct.DVTC_PCPolarity = DVTC_PCPolarity_IPC;
    /* 水平同步信号宽度，HSW - 1 */
    DVTC_InitStruct.DVTC_HorizontalSync = DVTCfg.hsync - 1;
    /* 垂直同步信号宽度，VSW - 1 */
    DVTC_InitStruct.DVTC_VerticalSync = DVTCfg.vsync - 1;
    /* HSW + HBP - 1 */
    DVTC_InitStruct.DVTC_AccumulatedHBP = DVTCfg.hsync + DVTCfg.hback - 1;
    /* VSW + VBP - 1 */
    DVTC_InitStruct.DVTC_AccumulatedVBP = DVTCfg.vsync + DVTCfg.vback - 1;
    /* HSW + HBP + 有效像素宽度 - 1 */
    DVTC_InitStruct.DVTC_AccumulatedActiveW = DVTCfg.hsync + DVTCfg.hback + DVTCfg.hdisp - 1;
    /* VSW + VBP + 有效像素高度 - 1 */
    DVTC_InitStruct.DVTC_AccumulatedActiveH = DVTCfg.vsync + DVTCfg.vback + DVTCfg.vdisp - 1;
    /* HSW + HBP + 有效像素宽度 + HFP - 1 */
    DVTC_InitStruct.DVTC_TotalWidth = DVTCfg.hsync + DVTCfg.hback + DVTCfg.hdisp + DVTCfg.hfront - 1;
    /* VSW + VBP + 有效像素高度 + VFP - 1 */
    DVTC_InitStruct.DVTC_TotalHeigh = DVTCfg.vsync + DVTCfg.vback + DVTCfg.vdisp + DVTCfg.vfront - 1;
    /* LCD背景默认颜色 */
    DVTC_InitStruct.DVTC_BackgroundRedValue = 0;
    DVTC_InitStruct.DVTC_BackgroundGreenValue = 0;
    DVTC_InitStruct.DVTC_BackgroundBlueValue = 0;

    /* LCD初始化 */
    DVTC_Init(&DVTC_InitStruct);
}

/**
 * @brief  DVTC配置
 * @param  None
 * @retval None
 */
static void DVTC_Layer_Config(void)
{
    DVTC_Layer_InitTypeDef DVTC_Layer_InitStruct;

    /* DVTC层级配置 */
    /* Layer1 */
    /* 水平第一个有效像素位置，HSW + HBP */
    DVTC_Layer_InitStruct.DVTC_HorizontalStart = DVTCfg.hsync + DVTCfg.hback;
    /* 水平最后一个有效像素位置，HSW + HBP + 有效像素宽度 - 1 */
    DVTC_Layer_InitStruct.DVTC_HorizontalStop = DVTCfg.hsync + DVTCfg.hback + DVTCfg.hdisp - 1;
    /* 垂直第一个有效像素位置，VSW + VBP */
    DVTC_Layer_InitStruct.DVTC_VerticalStart = DVTCfg.vsync + DVTCfg.vback;
    /* 垂直最后一个有效像素位置，VSW + VBP + 有效像素高度 - 1 */
    DVTC_Layer_InitStruct.DVTC_VerticalStop = DVTCfg.vsync + DVTCfg.vback + DVTCfg.vdisp - 1;
    /* 层使用的像素格式 */
    DVTC_Layer_InitStruct.DVTC_PixelFormat = LCD_PIXEL_FORMAT;
    /* 恒定混合系数 Alpha ，真正的系数为除以 255 后的值 */
    DVTC_Layer_InitStruct.DVTC_ConstantAlpha = 0xFF;
    /* 层默认背景颜色 */
    DVTC_Layer_InitStruct.DVTC_DefaultColorBlue = 0xFF;
    DVTC_Layer_InitStruct.DVTC_DefaultColorGreen = 0;
    DVTC_Layer_InitStruct.DVTC_DefaultColorRed = 0;
    DVTC_Layer_InitStruct.DVTC_DefaultColorAlpha = 0;
    /* 混合系数 F1 和 F2，均为CA并且混合系数 Alpha 为 0xFF，则上一层的像素不会参与运算 */
    DVTC_Layer_InitStruct.DVTC_BlendingFactor_1 = DVTC_BlendingFactor1_CA;
    DVTC_Layer_InitStruct.DVTC_BlendingFactor_2 = DVTC_BlendingFactor2_CA;
    /* 层的显存地址 */
    DVTC_Layer_InitStruct.DVTC_CFBStartAdress = LCD_VIDEO_BUFF_ADDR;
    /* 层的行数据长度，单位字节 */
    /* 行有效像素个数 * 像素占用的字节数量 + 3 */
    DVTC_Layer_InitStruct.DVTC_CFBLineLength = DVTCfg.hdisp * LCD_PIXEL_BYTES + 3;
    /* 从像素某行的起始处到下一行的起始处的增量（以字节为单位） */
    /* 行有效像素个数 * 像素占用的字节数量 */
    DVTC_Layer_InitStruct.DVTC_CFBPitch = DVTCfg.hdisp * LCD_PIXEL_BYTES;
    /* 层的行数 */
    DVTC_Layer_InitStruct.DVTC_CFBLineNumber = DVTCfg.vdisp;

    /* 初始化 */
    DVTC_LayerInit(DVTC_Layer1, &DVTC_Layer_InitStruct);

    //    /* Layer2 */
    //    /* 层默认背景颜色 */
    //    DVTC_Layer_InitStruct.DVTC_DefaultColorBlue = 0;
    //    DVTC_Layer_InitStruct.DVTC_DefaultColorGreen = 0;
    //    DVTC_Layer_InitStruct.DVTC_DefaultColorRed = 0;
    //    DVTC_Layer_InitStruct.DVTC_DefaultColorAlpha = 0;
    //    /* 层使用的像素格式 */
    //    DVTC_Layer_InitStruct.DVTC_PixelFormat = LCD_LAYER2_PIXEL_FORMAT;
    //    /* 混合系数 F1 和 F2 ，混合因子都配置成 PAxCA 以便它的透明像素能参与运算，实现透明效果 */
    //    DVTC_Layer_InitStruct.DVTC_BlendingFactor_1 = DVTC_BlendingFactor1_PAxCA;
    //    DVTC_Layer_InitStruct.DVTC_BlendingFactor_2 = DVTC_BlendingFactor2_PAxCA;
    //    /* 层的显存地址 */
    //    DVTC_Layer_InitStruct.DVTC_CFBStartAdress = LCD_LAYER2_VIDEO_BUFF_ADDR;
    //    /* 层的行数据长度，单位字节 */
    //    /* 行有效像素个数 * 像素占用的字节数量 + 3 */
    //    DVTC_Layer_InitStruct.DVTC_CFBLineLength = LCD_PIXEL_WIDTH * LCD_LAYER2_PIXEL_BYTES + 3;
    //    /* 从像素某行的起始处到下一行的起始处的增量（以字节为单位） */
    //    /* 行有效像素个数 * 像素占用的字节数量 */
    //    DVTC_Layer_InitStruct.DVTC_CFBPitch = LCD_PIXEL_WIDTH * LCD_LAYER2_PIXEL_BYTES;
    //
    //    /* 初始化 */
    //    DVTC_LayerInit(DVTC_Layer2, &DVTC_Layer_InitStruct);

    /* 层使能 */
    DVTC_LayerCmd(DVTC_Layer1, ENABLE);
    //    DVTC_LayerCmd(DVTC_Layer2, ENABLE);

    /* 立即重载影子寄存器 */
    DVTC_ReloadConfig(DVTC_IMReload);
    // DVTC_ReloadConfig(DVTC_VBReload);
    /* 使能抖动，当 LCD 与 显存的像素格式不符合的时候可开启该功能 */
    // DVTC_DitherCmd(ENABLE);
}

/**
 * @brief  LCD初始化
 * @note   使用了DVTC外设，使用2层，均为 800 * 480 分辨率，颜色格式均为 ARGB8888
 *           使用DVTC前需要先初始化SDRAM，因为显存在SDRAM中
 * @param  None
 * @retval None
 */
void LCD_DVTC_Init(void)
{
    /* GPIO配置 */
    // GPIO_Config();
    /* DVTC配置 */
    DVTC_Config();
    /* DVTC_Layer配置 */
    DVTC_Layer_Config();
}
