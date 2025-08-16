# SPI和I2C外设使用指南

本文档介绍OpenPeriph项目中新增的SPI和I2C外设模块的使用方法。

## 概述

OpenPeriph项目新增了两个重要的通信外设：

1. **SPI (Serial Peripheral Interface)** - 串行外设接口
2. **I2C (Inter-Integrated Circuit)** - 内部集成电路

这两个外设都完全兼容STM32的寄存器布局和功能，可以直接使用STM32标准外设库进行编程。

## SPI外设

### 特性

- 支持主模式和从模式
- 可配置的时钟极性(CPOL)和时钟相位(CPHA)
- 支持8位和16位数据宽度
- 可编程的波特率分频器
- 支持硬件CRC校验
- 支持DMA传输
- 完整的中断支持

### 寄存器映射

| 地址偏移 | 寄存器名称 | 描述 |
|----------|------------|------|
| 0x00 | CR1 | 控制寄存器1 |
| 0x04 | CR2 | 控制寄存器2 |
| 0x08 | SR | 状态寄存器 |
| 0x0C | DR | 数据寄存器 |
| 0x10 | CRCPR | CRC多项式寄存器 |
| 0x14 | RXCRCR | 接收CRC寄存器 |
| 0x18 | TXCRCR | 发送CRC寄存器 |
| 0x1C | I2SCFGR | I2S配置寄存器 |
| 0x20 | I2SPR | I2S预分频寄存器 |

### 使用示例

#### 基本配置

```c
#include "spi.h"
#include "rcc.h"

void spi_init(void) {
    SPI_InitTypeDef SPI_InitStructure;
    
    // 使能SPI时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SPI1, ENABLE);
    
    // 配置SPI
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
}
```

#### 数据收发

```c
uint8_t spi_transfer(uint8_t data) {
    // 等待发送缓冲区空
    while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE) == RESET);
    
    // 发送数据
    SPI_SendData8(SPI1, data);
    
    // 等待接收缓冲区非空
    while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE) == RESET);
    
    // 返回接收到的数据
    return SPI_ReceiveData8(SPI1);
}
```

#### 与SPI Flash通信

```c
void spi_flash_read_id(void) {
    uint8_t cmd[] = {0x90, 0x00, 0x00, 0x00}; // 读取ID命令
    uint8_t id[4];
    
    for(int i = 0; i < 4; i++) {
        id[i] = spi_transfer(cmd[i]);
    }
    
    printf("Flash ID: 0x%02X%02X%02X%02X\n", id[0], id[1], id[2], id[3]);
}
```

## I2C外设

### 特性

- 支持标准模式(100kHz)和快速模式(400kHz)
- 支持7位和10位地址
- 支持多主机模式
- 支持时钟延展
- 支持SMBus协议
- 完整的中断支持
- 支持DMA传输

### 寄存器映射

| 地址偏移 | 寄存器名称 | 描述 |
|----------|------------|------|
| 0x00 | CR1 | 控制寄存器1 |
| 0x04 | CR2 | 控制寄存器2 |
| 0x08 | OAR1 | 自身地址寄存器1 |
| 0x0C | OAR2 | 自身地址寄存器2 |
| 0x10 | DR | 数据寄存器 |
| 0x14 | SR1 | 状态寄存器1 |
| 0x18 | SR2 | 状态寄存器2 |
| 0x1C | CCR | 时钟控制寄存器 |
| 0x20 | TRISE | TRISE寄存器 |

### 使用示例

#### 基本配置

```c
#include "i2c.h"
#include "rcc.h"

void i2c_init(void) {
    I2C_InitTypeDef I2C_InitStructure;
    
    // 使能I2C时钟
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);
    
    // 配置I2C
    I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
    I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
    I2C_InitStructure.I2C_OwnAddress1 = 0x00;
    I2C_InitStructure.I2C_Ack = I2C_Ack_Enable;
    I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
    I2C_InitStructure.I2C_ClockSpeed = 100000; // 100kHz
    
    I2C_Init(I2C1, &I2C_InitStructure);
    I2C_Cmd(I2C1, ENABLE);
}
```

#### 写数据到设备

```c
void i2c_write_byte(uint8_t device_addr, uint8_t reg_addr, uint8_t data) {
    // 发送起始条件
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    // 发送设备地址
    I2C_Send7bitAddress(I2C1, device_addr, I2C_Direction_Transmitter);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
    
    // 发送寄存器地址
    I2C_SendData(I2C1, reg_addr);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    
    // 发送数据
    I2C_SendData(I2C1, data);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    
    // 发送停止条件
    I2C_GenerateSTOP(I2C1, ENABLE);
}
```

#### 从设备读数据

```c
uint8_t i2c_read_byte(uint8_t device_addr, uint8_t reg_addr) {
    uint8_t data;
    
    // 发送起始条件
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    // 发送设备地址(写模式)
    I2C_Send7bitAddress(I2C1, device_addr, I2C_Direction_Transmitter);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
    
    // 发送寄存器地址
    I2C_SendData(I2C1, reg_addr);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    
    // 重新发送起始条件
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    // 发送设备地址(读模式)
    I2C_Send7bitAddress(I2C1, device_addr, I2C_Direction_Receiver);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
    
    // 禁用应答
    I2C_AcknowledgeConfig(I2C1, DISABLE);
    
    // 读取数据
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_RECEIVED));
    data = I2C_ReceiveData(I2C1);
    
    // 发送停止条件
    I2C_GenerateSTOP(I2C1, ENABLE);
    
    // 重新启用应答
    I2C_AcknowledgeConfig(I2C1, ENABLE);
    
    return data;
}
```

#### 与EEPROM通信

```c
void eeprom_write_page(uint8_t page_addr, uint8_t* data, uint8_t len) {
    uint8_t eeprom_addr = 0xA0 | ((page_addr & 0x07) << 1);
    uint8_t mem_addr = (page_addr >> 3) << 8;
    
    // 发送起始条件
    I2C_GenerateSTART(I2C1, ENABLE);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT));
    
    // 发送EEPROM地址
    I2C_Send7bitAddress(I2C1, eeprom_addr, I2C_Direction_Transmitter);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
    
    // 发送内存地址
    I2C_SendData(I2C1, mem_addr);
    while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    
    // 发送数据
    for(int i = 0; i < len; i++) {
        I2C_SendData(I2C1, data[i]);
        while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED));
    }
    
    // 发送停止条件
    I2C_GenerateSTOP(I2C1, ENABLE);
    
    // 等待写入完成
    delay_ms(10);
}
```

## 硬件连接

### SPI连接

```
SPI1_SCK  -> PA5
SPI1_MISO -> PA6
SPI1_MOSI -> PA7
SPI1_NSS  -> PA4 (可选，软件控制)
```

### I2C连接

```
I2C1_SCL -> PB6
I2C1_SDA -> PB7
```

注意：I2C需要外接上拉电阻(通常4.7kΩ)。

## 常见应用

### SPI应用

1. **SPI Flash存储器** - 存储程序和数据
2. **SPI LCD显示屏** - 图形显示
3. **SPI传感器** - 温度、压力、加速度等
4. **SPI ADC/DAC** - 模数/数模转换
5. **SPI以太网控制器** - 网络通信

### I2C应用

1. **EEPROM存储器** - 配置数据存储
2. **RTC实时时钟** - 时间日期
3. **I2C传感器** - 温度、湿度、压力等
4. **I2C LCD显示屏** - 字符显示
5. **I2C ADC/DAC** - 模数/数模转换

## 注意事项

1. **时钟配置** - 确保外设时钟正确配置
2. **引脚复用** - 正确配置GPIO的复用功能
3. **时序要求** - 注意SPI和I2C的时序要求
4. **中断处理** - 合理使用中断提高效率
5. **错误处理** - 处理通信错误和超时

## 调试技巧

1. **使用示波器** - 观察SPI和I2C信号波形
2. **逻辑分析仪** - 分析通信协议
3. **LED指示** - 用LED指示通信状态
4. **串口输出** - 通过UART输出调试信息
5. **状态寄存器** - 检查外设状态寄存器

## 性能优化

1. **使用DMA** - 大量数据传输时使用DMA
2. **中断驱动** - 使用中断而不是轮询
3. **FIFO缓冲** - 利用内置FIFO提高效率
4. **时钟优化** - 选择合适的时钟频率
5. **批量传输** - 减少单次传输开销
