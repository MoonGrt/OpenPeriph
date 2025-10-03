#include "st7789_soft.h"

#define ST7789_SOFT_CLK_PORT GPIOB
#define ST7789_SOFT_CLK_PIN GPIO_Pin_8
#define ST7789_SOFT_CS_PORT GPIOB
#define ST7789_SOFT_CS_PIN GPIO_Pin_9
#define ST7789_SOFT_DATA_PORT GPIOB
#define ST7789_SOFT_DATA_PIN GPIO_Pin_10
#define ST7789_SOFT_RS_PORT GPIOB
#define ST7789_SOFT_RS_PIN GPIO_Pin_12
#define ST7789_SOFT_BL_PORT GPIOB
#define ST7789_SOFT_BL_PIN GPIO_Pin_13
#define ST7789_SOFT_RST_PORT GPIOB
#define ST7789_SOFT_RST_PIN GPIO_Pin_14

#define ST7789_SOFT_CLK_H() ST7789_SOFT_CLK_PORT->BSR = ST7789_SOFT_CLK_PIN
#define ST7789_SOFT_CLK_L() ST7789_SOFT_CLK_PORT->BRR = ST7789_SOFT_CLK_PIN
#define ST7789_SOFT_MOSI_H() ST7789_SOFT_DATA_PORT->BSR = ST7789_SOFT_DATA_PIN
#define ST7789_SOFT_MOSI_L() ST7789_SOFT_DATA_PORT->BRR = ST7789_SOFT_DATA_PIN
#define ST7789_SOFT_CS_H() ST7789_SOFT_CS_PORT->BSR = ST7789_SOFT_CS_PIN
#define ST7789_SOFT_CS_L() ST7789_SOFT_CS_PORT->BRR = ST7789_SOFT_CS_PIN
#define ST7789_SOFT_RS_H() ST7789_SOFT_RS_PORT->BSR = ST7789_SOFT_RS_PIN
#define ST7789_SOFT_RS_L() ST7789_SOFT_RS_PORT->BRR = ST7789_SOFT_RS_PIN
#define ST7789_SOFT_BL_H() ST7789_SOFT_BL_PORT->BSR = ST7789_SOFT_BL_PIN
#define ST7789_SOFT_BL_L() ST7789_SOFT_BL_PORT->BRR = ST7789_SOFT_BL_PIN
#define ST7789_SOFT_RST_H() ST7789_SOFT_RST_PORT->BSR = ST7789_SOFT_RST_PIN
#define ST7789_SOFT_RST_L() ST7789_SOFT_RST_PORT->BRR = ST7789_SOFT_RST_PIN

void SoftSPI_WriteByte(uint8_t data)
{
    for (int i = 0; i < 8; i++)
    {
        // !!(expr)：将表达式归一化为 0 或 1
        if (!!(data & (0x80 >> i)))
            ST7789_SOFT_MOSI_H();
        else
            ST7789_SOFT_MOSI_L();
        ST7789_SOFT_CLK_H();
        ST7789_SOFT_CLK_L();
    }
}

void ST7789_SOFT_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = ST7789_SOFT_CLK_PIN | ST7789_SOFT_DATA_PIN | ST7789_SOFT_CS_PIN |
                                  ST7789_SOFT_RS_PIN | ST7789_SOFT_BL_PIN | ST7789_SOFT_RST_PIN;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOB, &GPIO_InitStructure);

    // 初始状态
    ST7789_SOFT_CLK_L();
    ST7789_SOFT_BL_L(); // <<<< 打开背光
    ST7789_SOFT_CS_H();
}

void ST7789_SOFT_WriteCmd(uint8_t cmd)
{
    ST7789_SOFT_CS_L();
    ST7789_SOFT_RS_L();
    SoftSPI_WriteByte(cmd);
    ST7789_SOFT_CS_H();
}

void ST7789_SOFT_WriteData(uint8_t data)
{
    ST7789_SOFT_CS_L();
    ST7789_SOFT_RS_H();
    SoftSPI_WriteByte(data);
    ST7789_SOFT_CS_H();
}

void ST7789_SOFT_Reset(void)
{
    ST7789_SOFT_RST_L();
    delay_ms(100);
    ST7789_SOFT_RST_H();
    delay_ms(200);
}

void ST7789_SOFT_Init(void)
{
    ST7789_SOFT_Reset();
    ST7789_SOFT_WriteCmd(0x11);
    delay_ms(120);

    for (int i = 0; i < sizeof(init_cmds) / sizeof(init_cmds[0]); i++)
    {
        uint8_t is_data = (init_cmds[i] >> 8) & 0x1;
        uint8_t val = init_cmds[i] & 0xFF;
        if (is_data)
            ST7789_SOFT_WriteData(val);
        else
            ST7789_SOFT_WriteCmd(val);
    }
}
