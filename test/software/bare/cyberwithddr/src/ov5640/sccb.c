#include "sccb.h"

#ifdef OV5640

/*引脚配置层*/

/**
 * 函    数：SCCB写SCL引脚电平
 * 参    数：BitValue 协议层传入的当前需要写入SCL的电平，范围0~1
 * 返 回 值：无
 * 注意事项：此函数需要用户实现内容，当BitValue为0时，需要置SCL为低电平，当BitValue为1时，需要置SCL为高电平
 */
void SCCB_W_SCL(uint8_t BitValue)
{
    GPIO_WriteBit(GPIOB, GPIO_Pin_10, (BitAction)BitValue); // 根据BitValue，设置SCL引脚的电平
    delay_us(10);                                           // 延时10us，防止时序频率超过要求
}

/**
 * 函    数：SCCB写SDA引脚电平
 * 参    数：BitValue 协议层传入的当前需要写入SDA的电平，范围0~1
 * 返 回 值：无
 * 注意事项：此函数需要用户实现内容，当BitValue为0时，需要置SDA为低电平，当BitValue为1时，需要置SDA为高电平
 */
void SCCB_W_SDA(uint8_t BitValue)
{
    GPIO_WriteBit(GPIOB, GPIO_Pin_11, (BitAction)BitValue); // 根据BitValue，设置SDA引脚的电平，BitValue要实现非0即1的特性
    delay_us(10);                                           // 延时10us，防止时序频率超过要求
}

/**
 * 函    数：SCCB读SDA引脚电平
 * 参    数：无
 * 返 回 值：协议层需要得到的当前SDA的电平，范围0~1
 * 注意事项：此函数需要用户实现内容，当前SDA为低电平时，返回0，当前SDA为高电平时，返回1
 */
uint8_t SCCB_R_SDA(void)
{
    uint8_t BitValue;
    BitValue = GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_11); // 读取SDA电平
    delay_us(10);                                         // 延时10us，防止时序频率超过要求
    return BitValue;                                      // 返回SDA电平
}

/**
 * 函    数：SCCB初始化
 * 参    数：无
 * 返 回 值：无
 * 注意事项：此函数需要用户实现内容，实现SCL和SDA引脚的初始化
 */
void SCCB_Init(void)
{
    /*GPIO初始化*/
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_OD;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10 | GPIO_Pin_11;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOB, &GPIO_InitStructure); // 将PB10和PB11引脚初始化为开漏输出

    /*设置默认电平*/
    GPIO_SetBits(GPIOB, GPIO_Pin_10 | GPIO_Pin_11); // 设置PB10和PB11引脚初始化后默认为高电平（释放总线状态）
}

/**
 * 函    数：SCCB反初始化
 * 参    数：无
 * 返 回 值：无
 * 注意事项：此函数需要用户实现内容，用于释放SCL和SDA引脚资源
 */
void SCCB_DeInit(void)
{
}

/*协议层*/

/**
 * 函    数：SCCB起始
 * 参    数：无
 * 返 回 值：无
 */
void SCCB_Start(void)
{
    SCCB_W_SDA(1); // 释放SDA，确保SDA为高电平
    SCCB_W_SCL(1); // 释放SCL，确保SCL为高电平
    SCCB_W_SDA(0); // 在SCL高电平期间，拉低SDA，产生起始信号
    SCCB_W_SCL(0); // 起始后把SCL也拉低，即为了占用总线，也为了方便总线时序的拼接
}

/**
 * 函    数：SCCB终止
 * 参    数：无
 * 返 回 值：无
 */
void SCCB_Stop(void)
{
    SCCB_W_SDA(0); // 拉低SDA，确保SDA为低电平
    SCCB_W_SCL(1); // 释放SCL，使SCL呈现高电平
    SCCB_W_SDA(1); // 在SCL高电平期间，释放SDA，产生终止信号
}

/**
 * 函    数：SCCB发送一个字节
 * 参    数：Byte 要发送的一个字节数据，范围：0x00~0xFF
 * 返 回 值：无
 */
void SCCB_SendByte(uint8_t Byte)
{
    uint8_t i;
    for (i = 0; i < 8; i++) // 循环8次，主机依次发送数据的每一位
    {
        /*两个!可以对数据进行两次逻辑取反，作用是把非0值统一转换为1，即：!!(0) = 0，!!(非0) = 1*/
        SCCB_W_SDA(!!(Byte & (0x80 >> i))); // 使用掩码的方式取出Byte的指定一位数据并写入到SDA线
        SCCB_W_SCL(1);                      // 释放SCL，从机在SCL高电平期间读取SDA
        SCCB_W_SCL(0);                      // 拉低SCL，主机开始发送下一位数据
    }
}

/**
 * 函    数：SCCB接收一个字节
 * 参    数：无
 * 返 回 值：接收到的一个字节数据，范围：0x00~0xFF
 */
uint8_t SCCB_ReceiveByte(void)
{
    uint8_t i, Byte = 0x00; // 定义接收的数据，并赋初值0x00，此处必须赋初值0x00，后面会用到
    SCCB_W_SDA(1);          // 接收前，主机先确保释放SDA，避免干扰从机的数据发送
    for (i = 0; i < 8; i++) // 循环8次，主机依次接收数据的每一位
    {
        SCCB_W_SCL(1); // 释放SCL，主机机在SCL高电平期间读取SDA
        if (SCCB_R_SDA())
        {
            Byte |= (0x80 >> i);
        } // 读取SDA数据，并存储到Byte变量
          // 当SDA为1时，置变量指定位为1，当SDA为0时，不做处理，指定位为默认的初值0
        SCCB_W_SCL(0); // 拉低SCL，从机在SCL低电平期间写入SDA
    }
    return Byte; // 返回接收到的一个字节数据
}

/**
 * 函    数：SCCB发送应答位
 * 参    数：Byte 要发送的应答位，范围：0~1，0表示应答，1表示非应答
 * 返 回 值：无
 */
void SCCB_SendAck(uint8_t AckBit)
{
    SCCB_W_SDA(AckBit); // 主机把应答位数据放到SDA线
    SCCB_W_SCL(1);      // 释放SCL，从机在SCL高电平期间，读取应答位
    SCCB_W_SCL(0);      // 拉低SCL，开始下一个时序模块
}

/**
 * 函    数：SCCB接收应答位
 * 参    数：无
 * 返 回 值：接收到的应答位，范围：0~1，0表示应答，1表示非应答
 */
uint8_t SCCB_ReceiveAck(void)
{
    uint8_t AckBit;        // 定义应答位变量
    SCCB_W_SDA(1);         // 接收前，主机先确保释放SDA，避免干扰从机的数据发送
    SCCB_W_SCL(1);         // 释放SCL，主机机在SCL高电平期间读取SDA
    AckBit = SCCB_R_SDA(); // 将应答位存储到变量里
    SCCB_W_SCL(0);         // 拉低SCL，开始下一个时序模块
    return AckBit;         // 返回定义应答位变量
}

/**
 * 函    数：OV5640 SCCB读寄存器
 * 参    数：dev_addr：SCCB设备地址（7bit地址，不包含读写位）
 *           reg_addr：寄存器地址（16位，高字节在前）
 *           data    ：读出数据存放缓冲区指针
 *           len     ：要读取的数据长度（字节）
 * 返 回 值：执行结果，0表示成功，-1表示失败
 */
int32_t OV5640_SCCB_ReadReg(uint16_t dev_addr, uint16_t reg_addr, uint8_t *data, uint16_t len)
{
    uint16_t i;

    SCCB_Start();

    /* Device address + Write */
    SCCB_SendByte((dev_addr << 1) | 0);
    if (SCCB_ReceiveAck())
        goto err;

    /* Register address high byte */
    SCCB_SendByte((uint8_t)(reg_addr >> 8));
    if (SCCB_ReceiveAck())
        goto err;

    /* Register address low byte */
    SCCB_SendByte((uint8_t)(reg_addr & 0xFF));
    if (SCCB_ReceiveAck())
        goto err;

    /* Re-Start */
    SCCB_Start();

    /* Device address + Read */
    SCCB_SendByte((dev_addr << 1) | 1);
    if (SCCB_ReceiveAck())
        goto err;

    /* Read data */
    for (i = 0; i < len; i++)
    {
        data[i] = SCCB_ReceiveByte();
        if (i == len - 1)
            SCCB_SendAck(IIC_NACK);
        else
            SCCB_SendAck(IIC_ACK);
    }

    SCCB_Stop();
    return 0;

err:
    SCCB_Stop();
    return -1;
}

/**
 * 函    数：OV5640 SCCB写寄存器
 * 参    数：dev_addr：SCCB设备地址（7bit地址，不包含读写位）
 *           reg_addr：寄存器地址（16位，高字节在前）
 *           data    ：要写入的数据缓冲区指针
 *           len     ：要写入的数据长度（字节）
 * 返 回 值：执行结果，0表示成功，-1表示失败
 */
int32_t OV5640_SCCB_WriteReg(uint16_t dev_addr, uint16_t reg_addr, uint8_t *data, uint16_t len)
{
    uint16_t i;

    SCCB_Start();

    /* Device address + Write */
    SCCB_SendByte((dev_addr << 1) | 0);
    if (SCCB_ReceiveAck())
        goto err;

    /* Register address high byte */
    SCCB_SendByte((uint8_t)(reg_addr >> 8));
    if (SCCB_ReceiveAck())
        goto err;

    /* Register address low byte */
    SCCB_SendByte((uint8_t)(reg_addr & 0xFF));
    if (SCCB_ReceiveAck())
        goto err;

    /* Data bytes */
    for (i = 0; i < len; i++)
    {
        SCCB_SendByte(data[i]);
        if (SCCB_ReceiveAck())
            goto err;
    }

    SCCB_Stop();
    return 0;

err:
    SCCB_Stop();
    return -1;
}

#endif /* OV5640 */
