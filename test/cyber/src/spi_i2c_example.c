#include "spi.h"
#include "i2c.h"
#include "gpio.h"
#include "rcc.h"
#include "delay.h"

// SPI示例：与SPI Flash通信
void spi_flash_example(void) {
    SPI_InitTypeDef SPI_InitStructure;
    
    // 使能SPI1时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SPI1, ENABLE);
    
    // 配置SPI1
    SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;
    SPI_InitStructure.SPI_Mode = SPI_Mode_Master;
    SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;
    SPI_InitStructure.SPI_CPOL = SPI_CPOL_Low;
    SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;
    SPI_InitStructure.SPI_NSS = SPI_NSS_Soft;
    SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_64;
    SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;
    SPI_InitStructure.SPI_CRCPolynomial = 7;
    
    SPI_Init(SPI1, &SPI_InitStructure);
    SPI_Cmd(SPI1, ENABLE);
    
    // 发送测试数据
    uint8_t txData[] = {0x90, 0x00, 0x00, 0x00}; // Flash读取ID命令
    uint8_t rxData[4];
    
    for(int i = 0; i < 4; i++) {
        while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE) == RESET);
        SPI_SendData8(SPI1, txData[i]);
        
        while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE) == RESET);
        rxData[i] = SPI_ReceiveData8(SPI1);
    }
    
    // 通过UART输出结果
    printf("SPI Flash ID: 0x%02X%02X%02X%02X\n", 
           rxData[0], rxData[1], rxData[2], rxData[3]);
}

// I2C示例：与EEPROM通信
void i2c_eeprom_example(void) {
    I2C_InitTypeDef I2C_InitStructure;
    
    // 使能I2C1时钟
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);
    
    // 配置I2C1
    I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
    I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
    I2C_InitStructure.I2C_OwnAddress1 = 0x00;
    I2C_InitStructure.I2C_Ack = I2C_Ack_Enable;
    I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
    I2C_InitStructure.I2C_ClockSpeed = 100000; // 100kHz
    
    I2C_Init(I2C1, &I2C_InitStructure);
    I2C_Cmd(I2C1, ENABLE);
    
    // EEPROM地址 (24C02)
    uint8_t eepromAddr = 0xA0;
    uint8_t memAddr = 0x00;
    uint8_t writeData[] = "Hello OpenPeriph!";
    uint8_t readData[17];
    
    // 写入数据到EEPROM
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    I2C_Send7bitAddress(I2C1, eepromAddr, I2C_Direction_Transmitter);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
    
    I2C_SendData(I2C1, memAddr);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    
    for(int i = 0; i < 16; i++) {
        I2C_SendData(I2C1, writeData[i]);
        while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    }
    
    I2C_GenerateSTOP(I2C1, ENABLE);
    delay_ms(10); // 等待写入完成
    
    // 从EEPROM读取数据
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    I2C_Send7bitAddress(I2C1, eepromAddr, I2C_Direction_Transmitter);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
    
    I2C_SendData(I2C1, memAddr);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    I2C_Send7bitAddress(I2C1, eepromAddr, I2C_Direction_Receiver);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
    
    for(int i = 0; i < 16; i++) {
        if(i == 15) {
            I2C_AcknowledgeConfig(I2C1, DISABLE);
        }
        while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_RECEIVED));
        readData[i] = I2C_ReceiveData(I2C1);
    }
    readData[16] = '\0';
    
    I2C_GenerateSTOP(I2C1, ENABLE);
    
    // 通过UART输出结果
    printf("EEPROM Read: %s\n", readData);
}

// 主函数
int main(void) {
    // 初始化系统时钟
    SystemInit();
    
    // 初始化GPIO
    GPIO_InitTypeDef GPIO_InitStructure;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB, ENABLE);
    
    // 配置SPI引脚
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_6 | GPIO_Pin_7; // SCK, MISO, MOSI
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    
    // 配置I2C引脚
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7; // SCL, SDA
    GPIO_Init(GPIOB, &GPIO_InitStructure);
    
    // 配置UART
    USART_InitTypeDef USART_InitStructure;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
    
    USART_InitStructure.USART_BaudRate = 115200;
    USART_InitStructure.USART_WordLength = USART_WordLength_8b;
    USART_InitStructure.USART_StopBits = USART_StopBits_1;
    USART_InitStructure.USART_Parity = USART_Parity_No;
    USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
    
    USART_Init(USART1, &USART_InitStructure);
    USART_Cmd(USART1, ENABLE);
    
    printf("OpenPeriph SPI/I2C Example\n");
    printf("==========================\n");
    
    while(1) {
        printf("\n--- SPI Flash Test ---\n");
        spi_flash_example();
        
        printf("\n--- I2C EEPROM Test ---\n");
        i2c_eeprom_example();
        
        delay_ms(5000); // 等待5秒后重复
    }
}

// 简单的printf实现
void printf(const char* format, ...) {
    // 这里应该实现一个简单的printf函数
    // 为了简化，我们只输出固定字符串
    const char* str = format;
    while(*str) {
        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
        USART_SendData(USART1, *str++);
    }
}
