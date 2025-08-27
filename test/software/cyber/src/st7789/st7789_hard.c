#include "st7789_hard.h"

#define ST7789_HARD_CLK_PORT GPIOB
#define ST7789_HARD_CLK_PIN GPIO_Pin_8
#define ST7789_HARD_CS_PORT GPIOB
#define ST7789_HARD_CS_PIN GPIO_Pin_9
#define ST7789_HARD_DATA_PORT GPIOB
#define ST7789_HARD_DATA_PIN GPIO_Pin_10
#define ST7789_HARD_RS_PORT GPIOB
#define ST7789_HARD_RS_PIN GPIO_Pin_12
#define ST7789_HARD_BL_PORT GPIOB
#define ST7789_HARD_BL_PIN GPIO_Pin_13
#define ST7789_HARD_RST_PORT GPIOB
#define ST7789_HARD_RST_PIN GPIO_Pin_14

#define ST7789_HARD_RS_H() ST7789_HARD_RS_PORT->BSR = ST7789_HARD_RS_PIN
#define ST7789_HARD_RS_L() ST7789_HARD_RS_PORT->BRR = ST7789_HARD_RS_PIN
#define ST7789_HARD_BL_H() ST7789_HARD_BL_PORT->BSR = ST7789_HARD_BL_PIN
#define ST7789_HARD_BL_L() ST7789_HARD_BL_PORT->BRR = ST7789_HARD_BL_PIN
#define ST7789_HARD_RST_H() ST7789_HARD_RST_PORT->BSR = ST7789_HARD_RST_PIN
#define ST7789_HARD_RST_L() ST7789_HARD_RST_PORT->BRR = ST7789_HARD_RST_PIN

void HardSPI_WriteByte(uint8_t data)
{
    while (SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE) != SET); // 等待发送数据寄存器空
    SPI_I2S_SendData(SPI1, data); // 写入数据到发送数据寄存器，开始产生时序
}

void ST7789_HARD_GPIO_Init(void)
{
    /*GPIO初始化*/
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = ST7789_HARD_CLK_PIN | ST7789_HARD_DATA_PIN | ST7789_HARD_CS_PIN;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOB, &GPIO_InitStructure); // 将PB8、PB9和PB10引脚初始化为复用推挽输出 SCK MOSI CS
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Pin = ST7789_HARD_RS_PIN | ST7789_HARD_BL_PIN | ST7789_HARD_RST_PIN;
    GPIO_Init(GPIOB, &GPIO_InitStructure);

    /*SPI初始化*/
    SPI_InitTypeDef SPI_InitStructure;                                 // 定义结构体变量
    SPI_InitStructure.SPI_Mode = SPI_Mode_Master;                      // 模式，选择为SPI主模式
    SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex; // 方向，选择2线全双工
    SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;                  // 数据宽度，选择为8位
    SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;                 // 先行位，选择高位先行
    SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_2; // 波特率分频，选择128分频
    SPI_InitStructure.SPI_CPOL = SPI_CPOL_Low;                         // SPI极性，选择低极性
    SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;                       // SPI相位，选择第一个时钟边沿采样，极性和相位决定选择SPI模式0
    SPI_InitStructure.SPI_NSS = SPI_NSS_Hard;                          // NSS，选择由软件控制
    SPI_InitStructure.SPI_CRCPolynomial = 7;                           // CRC多项式，暂时用不到，给默认值7
    SPI_Init(SPI1, &SPI_InitStructure);                                // 将结构体变量交给SPI_Init，配置SPI1
    SPI_SSOutputCmd(SPI1, ENABLE);                                     // 使能片选输出

    // 初始状态
    ST7789_HARD_BL_L(); // <<<< 打开背光
    /*SPI使能*/
    SPI_Cmd(SPI1, ENABLE); // 使能SPI1，开始运行
}

void ST7789_HARD_WriteCmd(uint8_t cmd)
{
    ST7789_HARD_RS_L();
    HardSPI_WriteByte(cmd);
}

void ST7789_HARD_WriteData(uint8_t data)
{
    ST7789_HARD_RS_H();
    HardSPI_WriteByte(data);
}

void ST7789_HARD_Reset(void)
{
    ST7789_HARD_RST_L();
    delay_ms(100);
    ST7789_HARD_RST_H();
    delay_ms(200);
}

void ST7789_HARD_Init(void)
{
    ST7789_HARD_Reset();
    ST7789_HARD_WriteCmd(0x11);
    delay_ms(120);

    for (int i = 0; i < sizeof(init_cmds) / sizeof(init_cmds[0]); i++)
    {
        uint8_t is_data = (init_cmds[i] >> 8) & 0x1;
        uint8_t val = init_cmds[i] & 0xFF;
        if (is_data)
            ST7789_HARD_WriteData(val);
        else
            ST7789_HARD_WriteCmd(val);
    }
}
