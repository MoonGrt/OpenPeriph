#include "lcd.h"

/* 刷新率 */
uint8_t FPS = 0;

/* 当前使用的显存地址，不是当前显示的显存
   比如现在使用的显存为LCD_VIDEO_BUFF2_ADDR，则LCD正在显示的显存为LCD_VIDEO_BUFF0_ADDR
   这是为了避免在一边显示一边绘制图像，需要图像绘制完毕再显示 */
// uint32_t currentOptionVideoBuffAddr = LCD_VIDEO_BUFF1_ADDR;

/* 部分液晶信号线的引脚复用编号是AF9 */
#define GPIO_AF_DVTC_AF9 ((uint8_t)0x09)

/* DVTC 最大超时时间，单位：CPU时间 */
#define DVTC_DMA2D_TIMEOUT ((uint32_t)0xFFFFFF00)

/* 根据液晶数据手册的参数配置 */
/**
 * @brief 水平同步信号HSYNC宽度
 */
#define HSW (1)

/**
 * @brief 垂直同步信号VSYNC宽度
 */
#define VSW (1)

/**
 * @brief HSYNC后的无效像素
 */
#define HBP (46)

/**
 * @brief VSYNC后的无效行数
 */
#define VBP (23)

/**
 * @brief HSYNC前的无效像素
 */
#define HFP (20)

/**
 * @brief VSYNC前的无效行数
 */
#define VFP (22)

uint32_t LCD_Change_Video_Buff(void);

/**
 * @brief  GPIO配置
 * @note   开启GPIO时钟，并配置GPIO
 * @param  None
 * @retval None
 */
static void GPIO_Config(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    /* GPIO配置 */
    /* 红色数据线 */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_2 | GPIO_Pin_3 | GPIO_Pin_8;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF;
    GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
    GPIO_Init(GPIOH, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOH, GPIO_PinSource2, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOH, GPIO_PinSource3, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOH, GPIO_PinSource8, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
    GPIO_Init(GPIOB, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOB, GPIO_PinSource0, GPIO_AF_DVTC_AF9);
    GPIO_PinAFConfig(GPIOB, GPIO_PinSource1, GPIO_AF_DVTC_AF9);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    GPIO_Init(GPIOA, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOA, GPIO_PinSource11, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOA, GPIO_PinSource12, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6;
    GPIO_Init(GPIOG, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOG, GPIO_PinSource6, GPIO_AF_DVTC);

    /* 绿色数据线 */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_6;
    GPIO_Init(GPIOE, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOE, GPIO_PinSource5, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOE, GPIO_PinSource6, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_13 | GPIO_Pin_15;
    GPIO_Init(GPIOH, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOH, GPIO_PinSource13, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOH, GPIO_PinSource15, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
    GPIO_Init(GPIOG, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOG, GPIO_PinSource10, GPIO_AF_DVTC_AF9);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_2;
    GPIO_Init(GPIOI, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOI, GPIO_PinSource0, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOI, GPIO_PinSource2, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7;
    GPIO_Init(GPIOC, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOC, GPIO_PinSource7, GPIO_AF_DVTC);

    /* 蓝色数据线 */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4;
    GPIO_Init(GPIOE, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOE, GPIO_PinSource4, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    GPIO_Init(GPIOG, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOG, GPIO_PinSource11, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOG, GPIO_PinSource12, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6;
    GPIO_Init(GPIOD, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOD, GPIO_PinSource6, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4;
    GPIO_Init(GPIOI, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOI, GPIO_PinSource4, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_3;
    GPIO_Init(GPIOA, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOA, GPIO_PinSource3, GPIO_AF_DVTC);

    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9;
    GPIO_Init(GPIOB, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOB, GPIO_PinSource8, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOB, GPIO_PinSource9, GPIO_AF_DVTC);

    /* 控制线 */
    /* DCLK */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7;
    GPIO_Init(GPIOG, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOG, GPIO_PinSource7, GPIO_AF_DVTC);

    /* HSYNC(PI10)和VSYNC(PI9) */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_9 | GPIO_Pin_10;
    GPIO_Init(GPIOI, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOI, GPIO_PinSource9, GPIO_AF_DVTC);
    GPIO_PinAFConfig(GPIOI, GPIO_PinSource10, GPIO_AF_DVTC);

    /* DE */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
    GPIO_Init(GPIOF, &GPIO_InitStruct);
    GPIO_PinAFConfig(GPIOF, GPIO_PinSource10, GPIO_AF_DVTC);

    /* LCD_BL(PD7)和DISP(PD4) */
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_4 | GPIO_Pin_7;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
    GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_UP;
    GPIO_Init(GPIOD, &GPIO_InitStruct);

    /* 置位PD4和PD7 */
    PDout(4) = 1;
    PDout(7) = 1;
}

/**
 * @brief  DVTC配置
 * @param  None
 * @retval None
 */
static void DVTC_Config(void)
{
    DVTC_InitTypeDef DVTC_InitStruct = {0};

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
    DVTC_InitStruct.DVTC_HorizontalSync = HSW - 1;
    /* 垂直同步信号宽度，VSW - 1 */
    DVTC_InitStruct.DVTC_VerticalSync = VSW - 1;
    /* HSW + HBP - 1 */
    DVTC_InitStruct.DVTC_AccumulatedHBP = HSW + HBP - 1;
    /* VSW + VBP - 1 */
    DVTC_InitStruct.DVTC_AccumulatedVBP = VSW + VBP - 1;
    /* HSW + HBP + 有效像素宽度 - 1 */
    DVTC_InitStruct.DVTC_AccumulatedActiveW = HSW + HBP + LCD_PIXEL_WIDTH - 1;
    /* VSW + VBP + 有效像素高度 - 1 */
    DVTC_InitStruct.DVTC_AccumulatedActiveH = VSW + VBP + LCD_PIXEL_HEIGHT - 1;
    /* HSW + HBP + 有效像素宽度 + HFP - 1 */
    DVTC_InitStruct.DVTC_TotalWidth = HSW + HBP + LCD_PIXEL_WIDTH + HFP - 1;
    /* VSW + VBP + 有效像素高度 + VFP - 1 */
    DVTC_InitStruct.DVTC_TotalHeigh = VSW + VBP + LCD_PIXEL_HEIGHT + VFP - 1;
    /* LCD背景默认颜色 */
    DVTC_InitStruct.DVTC_BackgroundRedValue = 0;
    DVTC_InitStruct.DVTC_BackgroundGreenValue = 0;
    DVTC_InitStruct.DVTC_BackgroundBlueValue = 0;

    /* LCD初始化 */
    DVTC_Init(&DVTC_InitStruct);
}

/**
 * @brief  中断配置
 * @param  None
 * @retval None
 */
static void NVIC_Config(void)
{
    NVIC_InitTypeDef NVIC_InitStruct = {0};
    EXTI_InitTypeDef EXTI_InitStruct = {0};

    /* EXTI初始化 */
    EXTI_ClearFlag(EXTI_Line9); // 清除标志位
    EXTI_InitStruct.EXTI_Line = EXTI_Line9;
    EXTI_InitStruct.EXTI_Mode = EXTI_Mode_Interrupt;
    EXTI_InitStruct.EXTI_Trigger = EXTI_Trigger_Rising;
    EXTI_InitStruct.EXTI_LineCmd = ENABLE;
    EXTI_Init(&EXTI_InitStruct);

    /* 外部中断线9链接PI9，垂直同步信号 */
    SYSCFG_EXTILineConfig(EXTI_PortSourceGPIOI, EXTI_PinSource9);

    /* 中断配置 */
    NVIC_InitStruct.NVIC_IRQChannel = EXTI9_5_IRQn;
    NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority = 0;
    NVIC_InitStruct.NVIC_IRQChannelSubPriority = 0;
    NVIC_InitStruct.NVIC_IRQChannelCmd = ENABLE;
    NVIC_Init(&NVIC_InitStruct);

    //    /* 开启DVTC行中断 */
    //    DVTC_LIPConfig(VSW + VBP + LCD_PIXEL_HEIGHT + VFP - 1);
    //    DVTC_ClearFlag(DVTC_FLAG_LI);
    //    DVTC_ITConfig(DVTC_IT_LI, ENABLE);
    //    NVIC_InitStruct.NVIC_IRQChannel = DVTC_IRQn;
    //    NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority = 0;
    //    NVIC_InitStruct.NVIC_IRQChannelSubPriority = 0;
    //    NVIC_InitStruct.NVIC_IRQChannelCmd = ENABLE;
    //    NVIC_Init(&NVIC_InitStruct);
}

/**
 * @brief  DVTC配置
 * @param  None
 * @retval None
 */
static void DVTC_Layer_Config(void)
{
    DVTC_Layer_InitTypeDef DVTC_Layer_InitStruct = {0};

    /* DVTC层级配置 */
    /* Layer1 */
    /* 水平第一个有效像素位置，HSW + HBP */
    DVTC_Layer_InitStruct.DVTC_HorizontalStart = HSW + HBP;
    /* 水平最后一个有效像素位置，HSW + HBP + 有效像素宽度 - 1 */
    DVTC_Layer_InitStruct.DVTC_HorizontalStop = HSW + HBP + LCD_PIXEL_WIDTH - 1;
    /* 垂直第一个有效像素位置，VSW + VBP */
    DVTC_Layer_InitStruct.DVTC_VerticalStart = VSW + VBP;
    /* 垂直最后一个有效像素位置，VSW + VBP + 有效像素高度 - 1 */
    DVTC_Layer_InitStruct.DVTC_VerticalStop = VSW + VBP + LCD_PIXEL_HEIGHT - 1;
    /* 层使用的像素格式 */
    DVTC_Layer_InitStruct.DVTC_PixelFormat = LCD_PIXEL_FORMAT;
    /* 恒定混合系数 Alpha ，真正的系数为除以 255 后的值 */
    DVTC_Layer_InitStruct.DVTC_ConstantAlpha = 0xFF;
    /* 层默认背景颜色 */
    DVTC_Layer_InitStruct.DVTC_DefaultColorBlue = 0;
    DVTC_Layer_InitStruct.DVTC_DefaultColorGreen = 0;
    DVTC_Layer_InitStruct.DVTC_DefaultColorRed = 0;
    DVTC_Layer_InitStruct.DVTC_DefaultColorAlpha = 0;
    /* 混合系数 F1 和 F2，均为CA并且混合系数 Alpha 为 0xFF，则上一层的像素不会参与运算 */
    DVTC_Layer_InitStruct.DVTC_BlendingFactor_1 = DVTC_BlendingFactor1_CA;
    DVTC_Layer_InitStruct.DVTC_BlendingFactor_2 = DVTC_BlendingFactor2_CA;
    /* 层的显存地址 */
    DVTC_Layer_InitStruct.DVTC_CFBStartAdress = LCD_VIDEO_BUFF0_ADDR;
    /* 层的行数据长度，单位字节 */
    /* 行有效像素个数 * 像素占用的字节数量 + 3 */
    DVTC_Layer_InitStruct.DVTC_CFBLineLength = LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES + 3;
    /* 从像素某行的起始处到下一行的起始处的增量（以字节为单位） */
    /* 行有效像素个数 * 像素占用的字节数量 */
    DVTC_Layer_InitStruct.DVTC_CFBPitch = LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES;
    /* 层的行数 */
    DVTC_Layer_InitStruct.DVTC_CFBLineNumber = LCD_PIXEL_HEIGHT;

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
 * @brief  DMA2D配置
 * @param  None
 * @retval None
 */
static void DVTC_DMA2D_Config(void)
{

}

/**
 * @brief  LCD初始化
 * @note   使用了DVTC和DMA2D外设，使用2层，均为 800 * 480 分辨率，颜色格式均为 ARGB8888
 *           使用DVTC前需要先初始化SDRAM，因为显存在SDRAM中
 * @param  None
 * @retval None
 */
void LCD_DVTC_DMA2D_Init(void)
{
    /* GPIO配置 */
    GPIO_Config();
    /* DVTC配置 */
    DVTC_Config();
    /* 中断配置 */
    NVIC_Config();
    /* DVTC_Layer配置 */
    DVTC_Layer_Config();
    /* DMA2D配置 */
    DVTC_DMA2D_Config();
    /* 使能DVTC */
    DVTC_Cmd(ENABLE);
    /* 把显存初始化 */
    /* 绘制默认颜色，一般为黑色 */
    LCD_Fill(0, 0, LCD_PIXEL_WIDTH, LCD_PIXEL_HEIGHT, 0xFF, 0, 0, 0);
}

/**
  * @brief  使用 DMA2D 来填充颜色
  *         寄存器到存储器模式
  * @note   DMA2D工作在寄存器到存储器模式，DMA2D充当画笔，
              画笔颜色由 DMA2D_OutputAlpha、DMA2D_OutputRed、DMA2D_OutputGreen、DMA2D_OutputBlue 定义
              输出像素格式由 DMA2D_CMode 定义
  * @param  x：起始点
  * @param  y：起始点
  * @param  width：宽度
  * @param  height：高度
  * @param  alpha：透明度
  * @param  reg：红色分量
  * @param  green：绿色分量
  * @param  blue：蓝色分量
  * @retval 0：成功
  *         1：失败
  */
int LCD_Fill(uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint8_t alpha, uint8_t red, uint8_t green, uint8_t blue)
{
    uint32_t timeout = 0;
    DMA2D_InitTypeDef DMA2D_InitStruct = {0};

    /* 检查函数参数 */
    if ((x + width) > LCD_PIXEL_WIDTH || (y + height) > LCD_PIXEL_HEIGHT)
    {
        return -1;
    }

    /* 检查 DMA2D 是否在运行 */
    while (READ_BIT(DMA2D->CR, DMA2D_CR_START) != RESET)
    {
        timeout++;
        if (timeout >= DVTC_DMA2D_TIMEOUT)
        {
            return -1;
        }
    }

    /* DMA2D配置 */
    /* DMA2D 的工作模式 */
    /* DMA2D工作在寄存器到存储器模式，DMA2D充当画笔
       画笔颜色由DMA2D_OutputAlpha、DMA2D_OutputRed、DMA2D_OutputGreen、DMA2D_OutputBlue定义
       输出像素格式由 DMA2D_CMode 定义 */
    DMA2D_InitStruct.DMA2D_Mode = DMA2D_R2M;
    /* DMA2D 的输出 PFC 颜色格式，需要与显存的格式一致 */
    DMA2D_InitStruct.DMA2D_CMode = LCD_PIXEL_FORMAT;
    /* 配置 DMA2D 的寄存器颜色值，
       若 DMA2D 工作在寄存器到存储器(DMA2D_R2M)模式时，
       这个颜色值作为数据源，被 DMA2D 复制到显存空间 */
    DMA2D_InitStruct.DMA2D_OutputBlue = blue;
    DMA2D_InitStruct.DMA2D_OutputGreen = green;
    DMA2D_InitStruct.DMA2D_OutputRed = red;
    DMA2D_InitStruct.DMA2D_OutputAlpha = alpha;
    /* 配置 DMA2D 的输出 FIFO 的地址，内存地址
       DMA2D 的数据会被搬运到该空间，
       一般把它设置为本次传输显示位置的起始地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_InitStruct.DMA2D_OutputMemoryAdd = LCD_VIDEO_BUFF0_ADDR + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y + LCD_PIXEL_BYTES * x;
    /* 配置行偏移 (以像素为单位)，行偏移会被添加到各行的结尾，
       用于确定下一行的起始地址 */
    /* 行偏移的意思是一行结束到下一行开始的距离，单位像素个数 */
    /* 显存的行偏移公式：LCD 横向分辨率 - width */
    /* 不是显存则设置为0 */
    DMA2D_InitStruct.DMA2D_OutputOffset = LCD_PIXEL_WIDTH - width;
    /* 配置 DMA2D 一共要传输多少行数据 */
    /* 公式：height */
    DMA2D_InitStruct.DMA2D_NumberOfLine = height;
    /* 配置要传输区域的每行像素数。 */
    /* 公式：width */
    DMA2D_InitStruct.DMA2D_PixelPerLine = width;
    DMA2D_Init(&DMA2D_InitStruct);

    /* 开启DMA2D传输 */
    DMA2D_StartTransfer();

    return 0;
}

/**
 * @brief  使用 DMA2D 来从src复制到dest，DMA不进行像素颜色格式转换
 *         存储器到存储器模式，不执行像素转换，从前景层到输出层，前景层和输出层像素必须一致
 * @note   DMA2D工作在存储器到存储器模式，DMA2D不进行像素格式转换
 *           源地址：DMA2D_FGMA，目的地址：DMA2D_OutputMemoryAdd
 *           源行偏移：DMA2D_FGO，目的行偏移：DMA2D_OutputOffset
 *           输入输出像素格式由 DMA2D_FGCM 定义
 *           前景和输出的像素颜色格式为宏LCD_PIXEL_FORMAT
 * @param  srcAddr：源地址
 * @param  destAddr：目的地址
 * @param  srcOffLine：源地址行偏移
 *             srcOffLine：1，如果源地址是显存：LCD_PIXEL_WIDTH - width
 *             srcOffLine：0，如果源地址不是显存：0
 * @param  x0：源地址起始点
 * @param  y0：源地址起始点
 * @param  width：宽度
 * @param  height：高度
 * @param  x1：目的地址起始点
 * @param  y1：目的地址起始点
 * @retval 0：成功
 *         1：失败
 */
int LCD_Copy(uint32_t srcAddr, uint32_t destAddr,
             uint8_t srcOffLine,
             uint16_t x0, uint16_t y0, uint16_t width, uint16_t height,
             uint16_t x1, uint16_t y1)
{
    uint32_t timeout = 0;
    DMA2D_FG_InitTypeDef DMA2D_FG_InitStruct = {0};
    DMA2D_InitTypeDef DMA2D_InitStruct = {0};

    /* 检查函数参数 */
    if ((x0 + width) > LCD_PIXEL_WIDTH || (y0 + height) > LCD_PIXEL_HEIGHT ||
        (x1 + width) > LCD_PIXEL_WIDTH || (y1 + height) > LCD_PIXEL_HEIGHT)
    {
        return -1;
    }

    /* 检查 DMA2D 是否在运行 */
    while (READ_BIT(DMA2D->CR, DMA2D_CR_START) != RESET)
    {
        timeout++;
        if (timeout >= DVTC_DMA2D_TIMEOUT)
        {
            return -1;
        }
    }

    /* 配置源地址 */
    /* 配置前景层 */
    /* 前景层地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_FG_InitStruct.DMA2D_FGMA = srcAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y0 + LCD_PIXEL_BYTES * x0;
    /* 前景层行偏移 */
    /* 公式：LCD 横向分辨率 - width */
    if (srcOffLine)
    {
        DMA2D_FG_InitStruct.DMA2D_FGO = LCD_PIXEL_WIDTH - width;
    }
    else
    {
        DMA2D_FG_InitStruct.DMA2D_FGO = 0;
    }
    /* 前景层传输的颜色格式 */
    DMA2D_FG_InitStruct.DMA2D_FGCM = LCD_PIXEL_FORMAT;
    //    DMA2D_FG_InitStruct.DMA2D_FG_CLUT_CM;
    //    DMA2D_FG_InitStruct.DMA2D_FG_CLUT_SIZE;
    //    DMA2D_FG_InitStruct.DMA2D_FGPFC_ALPHA_MODE;
    //    DMA2D_FG_InitStruct.DMA2D_FGPFC_ALPHA_VALUE;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_BLUE;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_GREEN;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_RED;
    //    DMA2D_FG_InitStruct.DMA2D_FGCMAR;
    DMA2D_FGConfig(&DMA2D_FG_InitStruct);

    /* 配置目的地址 */
    /* DMA2D配置 */
    /* DMA2D 的工作模式 */
    DMA2D_InitStruct.DMA2D_Mode = DMA2D_M2M;
    //    /* DMA2D 的输出 PFC 颜色格式，需要与显存的格式一致 */
    //    DMA2D_InitStruct.DMA2D_CMode = LCD_PIXEL_FORMAT;
    /* 配置 DMA2D 的寄存器颜色值，
       若 DMA2D 工作在寄存器到存储器(DMA2D_R2M)模式时，
       这个颜色值作为数据源，被 DMA2D 复制到显存空间 */
    //    DMA2D_InitStruct.DMA2D_OutputBlue = blue;
    //    DMA2D_InitStruct.DMA2D_OutputGreen = green;
    //    DMA2D_InitStruct.DMA2D_OutputRed = red;
    //    DMA2D_InitStruct.DMA2D_OutputAlpha = alpha;
    /* 配置 DMA2D 的输出 FIFO 的地址，内存地址
       DMA2D 的数据会被搬运到该空间，
       一般把它设置为本次传输显示位置的起始地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_InitStruct.DMA2D_OutputMemoryAdd = destAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y1 + LCD_PIXEL_BYTES * x1;
    /* 配置行偏移 (以像素为单位)，行偏移会被添加到各行的结尾，
       用于确定下一行的起始地址 */
    /* 行偏移的意思是一行结束到下一行开始的距离，单位像素个数 */
    /* 显存的行偏移公式：LCD 横向分辨率 - width */
    /* 不是显存则设置为0 */
    DMA2D_InitStruct.DMA2D_OutputOffset = LCD_PIXEL_WIDTH - width;
    /* 配置 DMA2D 一共要传输多少行数据 */
    /* 公式：height */
    DMA2D_InitStruct.DMA2D_NumberOfLine = height;
    /* 配置要传输区域的每行像素数。 */
    /* 公式：width */
    DMA2D_InitStruct.DMA2D_PixelPerLine = width;
    DMA2D_Init(&DMA2D_InitStruct);

    /* 开启DMA2D传输 */
    DMA2D_StartTransfer();

    return 0;
}

/**
 * @brief  使用 DMA2D 来从src复制到dest，DMA进行像素颜色格式转换
 *         存储器到存储器模式，并执行像素转换，从前景层到输出
 * @note   DMA2D工作在存储器到存储器模式，DMA2D进行像素格式转换
 *           源地址：DMA2D_FGMA，目的地址：DMA2D_OutputMemoryAdd
 *           源行偏移：DMA2D_FGO，目的行偏移：DMA2D_OutputOffset
 *           输入像素格式由 DMA2D_FGCM 定义，输出像素格式由 DMA2D_CMode 定义
 * @param  srcAddr：源地址
 * @param  destAddr：目的地址
 * @param  srcOffLine：源地址行偏移
 *             srcOffLine：1，如果源地址是显存：LCD_PIXEL_WIDTH - width
 *             srcOffLine：0，如果源地址不是显存：0
 * @param  x0：源地址起始点
 * @param  y0：源地址起始点
 * @param  width：宽度
 * @param  height：高度
 * @param  x1：目的地址起始点
 * @param  y1：目的地址起始点
 * @param  pixelFormat：源地址的像素格式
 * @retval 0：成功
 *         1：失败
 */
int LCD_PFC_Copy(uint32_t srcAddr, uint32_t destAddr,
                 uint8_t srcOffLine,
                 uint16_t x0, uint16_t y0, uint16_t width, uint16_t height,
                 uint16_t x1, uint16_t y1, uint32_t pixelFormat)
{
    uint32_t timeout = 0;
    DMA2D_FG_InitTypeDef DMA2D_FG_InitStruct = {0};
    DMA2D_InitTypeDef DMA2D_InitStruct = {0};

    /* 检查函数参数 */
    if ((x0 + width) > LCD_PIXEL_WIDTH || (y0 + height) > LCD_PIXEL_HEIGHT ||
        (x1 + width) > LCD_PIXEL_WIDTH || (y1 + height) > LCD_PIXEL_HEIGHT)
    {
        return -1;
    }

    /* 检查 DMA2D 是否在运行 */
    while (READ_BIT(DMA2D->CR, DMA2D_CR_START) != RESET)
    {
        timeout++;
        if (timeout >= DVTC_DMA2D_TIMEOUT)
        {
            return -1;
        }
    }

    /* 配置源地址 */
    /* 配置前景层 */
    /* 前景层地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_FG_InitStruct.DMA2D_FGMA = srcAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y0 + LCD_PIXEL_BYTES * x0;
    /* 前景层行偏移 */
    /* 公式：LCD 横向分辨率 - width */
    if (srcOffLine)
    {
        DMA2D_FG_InitStruct.DMA2D_FGO = LCD_PIXEL_WIDTH - width;
    }
    else
    {
        DMA2D_FG_InitStruct.DMA2D_FGO = 0;
    }
    /* 前景层传输的颜色格式 */
    DMA2D_FG_InitStruct.DMA2D_FGCM = pixelFormat;
    //    DMA2D_FG_InitStruct.DMA2D_FG_CLUT_CM;
    //    DMA2D_FG_InitStruct.DMA2D_FG_CLUT_SIZE;
    //    DMA2D_FG_InitStruct.DMA2D_FGPFC_ALPHA_MODE;
    //    DMA2D_FG_InitStruct.DMA2D_FGPFC_ALPHA_VALUE;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_BLUE;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_GREEN;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_RED;
    //    DMA2D_FG_InitStruct.DMA2D_FGCMAR;
    /* 初始化前景层 */
    DMA2D_FGConfig(&DMA2D_FG_InitStruct);

    //    /* 配置背景层，颜色与目的地址像素颜色格式一致 */

    //    /* 背景层地址 */
    //    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    //    DMA2D_BG_InitStruct.DMA2D_BGMA = destAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y0 + LCD_PIXEL_BYTES * x0;;
    //    /* 背景层行偏移 */
    //    /* 公式：LCD 横向分辨率 - width */
    //    DMA2D_BG_InitStruct.DMA2D_BGO = LCD_PIXEL_WIDTH - width;
    //    /* 背景层传输的颜色格式 */
    //    DMA2D_BG_InitStruct.DMA2D_BGCM = LCD_PIXEL_FORMAT;
    ////    DMA2D_BG_InitStruct.DMA2D_BG_CLUT_CM;
    ////    DMA2D_BG_InitStruct.DMA2D_BG_CLUT_SIZE;
    ////    DMA2D_BG_InitStruct.DMA2D_BGPFC_ALPHA_MODE;
    ////    DMA2D_BG_InitStruct.DMA2D_BGPFC_ALPHA_VALUE;
    ////    DMA2D_BG_InitStruct.DMA2D_BGC_BLUE;
    ////    DMA2D_BG_InitStruct.DMA2D_BGC_GREEN;
    ////    DMA2D_BG_InitStruct.DMA2D_BGC_RED;
    ////    DMA2D_BG_InitStruct.DMA2D_BGCMAR;
    //    DMA2D_BGConfig(&DMA2D_BG_InitStruct);

    /* 配置目的地址 */
    /* DMA2D配置 */
    /* DMA2D 的工作模式 */
    DMA2D_InitStruct.DMA2D_Mode = DMA2D_M2M_PFC;
    //    /* DMA2D 的输出 PFC 颜色格式，需要与显存的格式一致 */
    DMA2D_InitStruct.DMA2D_CMode = LCD_PIXEL_FORMAT;
    /* 配置 DMA2D 的寄存器颜色值，
       若 DMA2D 工作在寄存器到存储器(DMA2D_R2M)模式时，
       这个颜色值作为数据源，被 DMA2D 复制到显存空间 */
    //    DMA2D_InitStruct.DMA2D_OutputBlue = blue;
    //    DMA2D_InitStruct.DMA2D_OutputGreen = green;
    //    DMA2D_InitStruct.DMA2D_OutputRed = red;
    //    DMA2D_InitStruct.DMA2D_OutputAlpha = alpha;
    /* 配置 DMA2D 的输出 FIFO 的地址，内存地址
       DMA2D 的数据会被搬运到该空间，
       一般把它设置为本次传输显示位置的起始地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_InitStruct.DMA2D_OutputMemoryAdd = destAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y1 + LCD_PIXEL_BYTES * x1;
    /* 配置行偏移 (以像素为单位)，行偏移会被添加到各行的结尾，
       用于确定下一行的起始地址 */
    /* 行偏移的意思是一行结束到下一行开始的距离，单位像素个数 */
    /* 显存的行偏移公式：LCD 横向分辨率 - width */
    /* 不是显存则设置为0 */
    DMA2D_InitStruct.DMA2D_OutputOffset = LCD_PIXEL_WIDTH - width;
    /* 配置 DMA2D 一共要传输多少行数据 */
    /* 公式：height */
    DMA2D_InitStruct.DMA2D_NumberOfLine = height;
    /* 配置要传输区域的每行像素数。 */
    /* 公式：width */
    DMA2D_InitStruct.DMA2D_PixelPerLine = width;
    DMA2D_Init(&DMA2D_InitStruct);

    /* 开启DMA2D传输 */
    DMA2D_StartTransfer();

    return 0;
}

/**
 * @brief  使用 DMA2D 来从src复制到dest，DMA进行像素颜色格式转换
 * @note   DMA2D工作在存储器到存储器模式，DMA2D不进行像素格式转换
 *           源地址：DMA2D_FGMA，目的地址：DMA2D_OutputMemoryAdd
 *           源行偏移：DMA2D_FGO，目的行偏移：DMA2D_OutputOffset
 *           输入输出像素格式由 DMA2D_FGCM 定义
 *           前景和输出的像素颜色格式为宏LCD_PIXEL_FORMAT
 * @param  srcAddr：源地址
 * @param  destAddr：目的地址
 * @param  FGOffLine：前景地址行偏移
 *             FGOffLine：1，如果源地址是显存：LCD_PIXEL_WIDTH - width
 *             FGOffLine：0，如果源地址不是显存：0
 * @param  BGOffLine：背景地址行偏移
 *             BGOffLine：1，如果源地址是显存：LCD_PIXEL_WIDTH - width
 *             BGOffLine：0，如果源地址不是显存：0
 * @param  x0：源地址起始点
 * @param  y0：源地址起始点
 * @param  width：宽度
 * @param  height：高度
 * @param  x1：目的地址起始点
 * @param  y1：目的地址起始点
 * @param  pixelFormat：源地址的像素格式
 * @retval 0：成功
 *         1：失败
 */
int LCD_Mix_Copy(uint32_t FGAddr, uint32_t BGAddr, uint32_t destAddr,
                 uint8_t FGOffLine, uint8_t BGOffLine,
                 uint16_t xfg, uint16_t yfg, uint16_t width, uint16_t height,
                 uint16_t xbg, uint16_t ybg,
                 uint16_t x1, uint16_t y1, uint32_t FGpixelFormat, uint32_t BGpixelFormat)
{
    uint32_t timeout = 0;
    DMA2D_FG_InitTypeDef DMA2D_FG_InitStruct = {0};
    DMA2D_BG_InitTypeDef DMA2D_BG_InitStruct = {0};
    DMA2D_InitTypeDef DMA2D_InitStruct = {0};

    /* 检查函数参数 */
    if ((xfg + width) > LCD_PIXEL_WIDTH || (yfg + height) > LCD_PIXEL_HEIGHT ||
        (x1 + width) > LCD_PIXEL_WIDTH || (y1 + height) > LCD_PIXEL_HEIGHT)
    {
        return -1;
    }

    /* 检查 DMA2D 是否在运行 */
    while (READ_BIT(DMA2D->CR, DMA2D_CR_START) != RESET)
    {
        timeout++;
        if (timeout >= DVTC_DMA2D_TIMEOUT)
        {
            return -1;
        }
    }

    /* 配置源地址 */
    /* 配置前景层 */
    /* 前景层地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_FG_InitStruct.DMA2D_FGMA = FGAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * yfg + LCD_PIXEL_BYTES * xfg;
    /* 前景层行偏移 */
    /* 公式：LCD 横向分辨率 - width */
    if (FGOffLine)
    {
        DMA2D_FG_InitStruct.DMA2D_FGO = LCD_PIXEL_WIDTH - width;
    }
    else
    {
        DMA2D_FG_InitStruct.DMA2D_FGO = 0;
    }
    /* 前景层传输的颜色格式 */
    DMA2D_FG_InitStruct.DMA2D_FGCM = FGpixelFormat;
    //    DMA2D_FG_InitStruct.DMA2D_FG_CLUT_CM;
    //    DMA2D_FG_InitStruct.DMA2D_FG_CLUT_SIZE;
    //    DMA2D_FG_InitStruct.DMA2D_FGPFC_ALPHA_MODE;
    //    DMA2D_FG_InitStruct.DMA2D_FGPFC_ALPHA_VALUE;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_BLUE;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_GREEN;
    //    DMA2D_FG_InitStruct.DMA2D_FGC_RED;
    //    DMA2D_FG_InitStruct.DMA2D_FGCMAR;
    /* 初始化前景层 */
    DMA2D_FGConfig(&DMA2D_FG_InitStruct);

    /* 配置背景层，颜色与目的地址像素颜色格式一致 */

    /* 背景层地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_BG_InitStruct.DMA2D_BGMA = BGAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * ybg + LCD_PIXEL_BYTES * xbg;
    /* 背景层行偏移 */
    /* 公式：LCD 横向分辨率 - width */
    if (BGOffLine)
    {
        DMA2D_BG_InitStruct.DMA2D_BGO = LCD_PIXEL_WIDTH - width;
    }
    else
    {
        DMA2D_BG_InitStruct.DMA2D_BGO = 0;
    }
    /* 背景层传输的颜色格式 */
    DMA2D_BG_InitStruct.DMA2D_BGCM = BGpixelFormat;
    //    DMA2D_BG_InitStruct.DMA2D_BG_CLUT_CM;
    //    DMA2D_BG_InitStruct.DMA2D_BG_CLUT_SIZE;
    //    DMA2D_BG_InitStruct.DMA2D_BGPFC_ALPHA_MODE;
    //    DMA2D_BG_InitStruct.DMA2D_BGPFC_ALPHA_VALUE;
    //    DMA2D_BG_InitStruct.DMA2D_BGC_BLUE;
    //    DMA2D_BG_InitStruct.DMA2D_BGC_GREEN;
    //    DMA2D_BG_InitStruct.DMA2D_BGC_RED;
    //    DMA2D_BG_InitStruct.DMA2D_BGCMAR;
    DMA2D_BGConfig(&DMA2D_BG_InitStruct);

    /* 配置目的地址 */
    /* DMA2D配置 */
    /* DMA2D 的工作模式 */
    DMA2D_InitStruct.DMA2D_Mode = DMA2D_M2M_BLEND;
    //    /* DMA2D 的输出 PFC 颜色格式，需要与显存的格式一致 */
    DMA2D_InitStruct.DMA2D_CMode = LCD_PIXEL_FORMAT;
    /* 配置 DMA2D 的寄存器颜色值，
       若 DMA2D 工作在寄存器到存储器(DMA2D_R2M)模式时，
       这个颜色值作为数据源，被 DMA2D 复制到显存空间 */
    //    DMA2D_InitStruct.DMA2D_OutputBlue = blue;
    //    DMA2D_InitStruct.DMA2D_OutputGreen = green;
    //    DMA2D_InitStruct.DMA2D_OutputRed = red;
    //    DMA2D_InitStruct.DMA2D_OutputAlpha = alpha;
    /* 配置 DMA2D 的输出 FIFO 的地址，内存地址
       DMA2D 的数据会被搬运到该空间，
       一般把它设置为本次传输显示位置的起始地址 */
    /* 公式：显存起始地址 + LCD 横向分辨率 * 像素点占用的字节数 * y + 像素点占用的字节数 * x */
    DMA2D_InitStruct.DMA2D_OutputMemoryAdd = destAddr + LCD_PIXEL_WIDTH * LCD_PIXEL_BYTES * y1 + LCD_PIXEL_BYTES * x1;
    /* 配置行偏移 (以像素为单位)，行偏移会被添加到各行的结尾，
       用于确定下一行的起始地址 */
    /* 行偏移的意思是一行结束到下一行开始的距离，单位像素个数 */
    /* 显存的行偏移公式：LCD 横向分辨率 - width */
    /* 不是显存则设置为0 */
    DMA2D_InitStruct.DMA2D_OutputOffset = LCD_PIXEL_WIDTH - width;
    /* 配置 DMA2D 一共要传输多少行数据 */
    /* 公式：height */
    DMA2D_InitStruct.DMA2D_NumberOfLine = height;
    /* 配置要传输区域的每行像素数。 */
    /* 公式：width */
    DMA2D_InitStruct.DMA2D_PixelPerLine = width;
    DMA2D_Init(&DMA2D_InitStruct);

    /* 开启DMA2D传输 */
    DMA2D_StartTransfer();

    return 0;
}

/* gImage_qq为RGB888格式 */
extern const unsigned char gImage_qq[6912];
void LCD_Copy_Demo(void)
{
    LCD_Copy((uint32_t)gImage_qq, LCD_VIDEO_BUFF0_ADDR, 0, 0, 0, 48, 48, 0, 0);
}

/* gImage_zfb 为ARGB888格式 */
extern const unsigned char gImage_zfb[9216];
extern const unsigned char gImage_wechat[8192];
extern const unsigned char gImage_ouyu[15800];
void LCD_PFC_Copy_Demo(void)
{
    /* 将图片显示到当前显存上 */
    LCD_PFC_Copy((uint32_t)gImage_zfb, LCD_VIDEO_BUFF0_ADDR, 0, 0, 0, 48, 48, 50, 0, DVTC_Pixelformat_ARGB8888);
    LCD_PFC_Copy((uint32_t)gImage_ouyu, LCD_VIDEO_BUFF0_ADDR, 0, 0, 0, 100, 0X4F, 0, 50, DVTC_Pixelformat_RGB565);
}

void LCD_Mix_Copy_Demo(void)
{
    /* 将显存作为背景，图片作为前景，混合转换后显示到显存中 */
    LCD_Mix_Copy((uint32_t)gImage_wechat, LCD_VIDEO_BUFF0_ADDR, LCD_VIDEO_BUFF0_ADDR, 0, 1, 0, 0, 48, 48, 100, 0, 100, 0, DVTC_Pixelformat_RGB565, DVTC_Pixelformat_RGB888);
    LCD_Mix_Copy((uint32_t)gImage_zfb, LCD_VIDEO_BUFF0_ADDR, LCD_VIDEO_BUFF0_ADDR, 0, 1, 0, 0, 48, 48, 50, 50, 50, 50, DVTC_Pixelformat_ARGB8888, DVTC_Pixelformat_RGB888);
}
