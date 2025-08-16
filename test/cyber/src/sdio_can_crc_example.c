#include "sdio.h"
#include "can.h"
#include "crc.h"
#include "gpio.h"
#include "rcc.h"
#include "delay.h"

// SDIO示例：SD卡初始化
void sdio_sd_card_init(void) {
    SDIO_InitTypeDef SDIO_InitStructure;
    
    // 使能SDIO时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SDIO, ENABLE);
    
    // 配置SDIO
    SDIO_InitStructure.SDIO_ClockDiv = SDIO_ClockDiv_0; // 400kHz
    SDIO_InitStructure.SDIO_ClockEdge = SDIO_ClockEdge_Rising;
    SDIO_InitStructure.SDIO_ClockBypass = SDIO_ClockBypass_Disable;
    SDIO_InitStructure.SDIO_ClockPowerSave = SDIO_ClockPowerSave_Disable;
    SDIO_InitStructure.SDIO_BusWide = SDIO_BusWide_1b;
    SDIO_InitStructure.SDIO_HardwareFlowControl = SDIO_HardwareFlowControl_Disable;
    
    SDIO_Init(&SDIO_InitStructure);
    SDIO_PowerState_ON(SDIO);
    
    // 发送CMD0 - 复位SD卡
    SDIO_CmdInitTypeDef SDIO_CmdInitStructure;
    SDIO_CmdInitStructure.SDIO_Argument = 0x00;
    SDIO_CmdInitStructure.SDIO_CmdIndex = 0;
    SDIO_CmdInitStructure.SDIO_Response = SDIO_Response_No;
    SDIO_CmdInitStructure.SDIO_Wait = SDIO_Wait_No;
    SDIO_CmdInitStructure.SDIO_CPSM = SDIO_CPSM_Enable;
    
    SDIO_SendCommand(&SDIO_CmdInitStructure);
    
    // 等待命令完成
    while(!SDIO_GetFlagStatus(SDIO_FLAG_CMDSENT));
    
    printf("SDIO: SD card reset completed\n");
}

// CAN示例：发送CAN消息
void can_send_message(uint32_t id, uint8_t* data, uint8_t length) {
    CAN_InitTypeDef CAN_InitStructure;
    CanTxMsg TxMessage;
    
    // 使能CAN时钟
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_CAN1, ENABLE);
    
    // 配置CAN
    CAN_InitStructure.CAN_TTCM = DISABLE;
    CAN_InitStructure.CAN_ABOM = DISABLE;
    CAN_InitStructure.CAN_AWUM = DISABLE;
    CAN_InitStructure.CAN_NART = DISABLE;
    CAN_InitStructure.CAN_RFLM = DISABLE;
    CAN_InitStructure.CAN_TXFP = DISABLE;
    CAN_InitStructure.CAN_Mode = CAN_Mode_Normal;
    CAN_InitStructure.CAN_SJW = CAN_SJW_1tq;
    CAN_InitStructure.CAN_BS1 = CAN_BS1_3tq;
    CAN_InitStructure.CAN_BS2 = CAN_BS2_2tq;
    CAN_InitStructure.CAN_Prescaler = 4; // 1Mbps
    
    CAN_Init(CAN1, &CAN_InitStructure);
    
    // 配置发送消息
    TxMessage.StdId = id;
    TxMessage.ExtId = 0x00;
    TxMessage.RTR = CAN_RTR_DATA;
    TxMessage.IDE = CAN_ID_STD;
    TxMessage.DLC = length;
    
    for(int i = 0; i < length; i++) {
        TxMessage.Data[i] = data[i];
    }
    
    // 发送消息
    uint8_t mbox = CAN_Transmit(CAN1, &TxMessage);
    
    // 等待发送完成
    while(CAN_TransmitStatus(CAN1, mbox) != CAN_TxStatus_Ok);
    
    printf("CAN: Message sent, ID=0x%03X, Length=%d\n", id, length);
}

// CAN示例：接收CAN消息
void can_receive_message(void) {
    CanRxMsg RxMessage;
    
    // 配置接收过滤器
    CAN_FilterInitTypeDef CAN_FilterInitStructure;
    CAN_FilterInitStructure.CAN_FilterNumber = 0;
    CAN_FilterInitStructure.CAN_FilterMode = CAN_FilterMode_IdMask;
    CAN_FilterInitStructure.CAN_FilterScale = CAN_FilterScale_32bit;
    CAN_FilterInitStructure.CAN_FilterIdHigh = 0x0000;
    CAN_FilterInitStructure.CAN_FilterIdLow = 0x0000;
    CAN_FilterInitStructure.CAN_FilterMaskIdHigh = 0x0000;
    CAN_FilterInitStructure.CAN_FilterMaskIdLow = 0x0000;
    CAN_FilterInitStructure.CAN_FilterFIFOAssignment = CAN_Filter_FIFO0;
    CAN_FilterInitStructure.CAN_FilterActivation = ENABLE;
    
    CAN_FilterInit(&CAN_FilterInitStructure);
    
    // 检查是否有接收到的消息
    if(CAN_MessagePending(CAN1, CAN_FIFO0) != 0) {
        CAN_Receive(CAN1, CAN_FIFO0, &RxMessage);
        
        printf("CAN: Message received, ID=0x%03X, Length=%d, Data=", 
               RxMessage.StdId, RxMessage.DLC);
        
        for(int i = 0; i < RxMessage.DLC; i++) {
            printf("0x%02X ", RxMessage.Data[i]);
        }
        printf("\n");
    }
}

// CRC示例：计算CRC32
uint32_t crc32_calculate(uint8_t* data, uint32_t length) {
    CRC_InitTypeDef CRC_InitStructure;
    
    // 使能CRC时钟
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_CRC, ENABLE);
    
    // 配置CRC
    CRC_InitStructure.CRC_Polynomial = 0x04C11DB7; // CRC32多项式
    CRC_InitStructure.CRC_PolySize = CRC_PolySize_32b;
    CRC_InitStructure.CRC_ReverseInputData = CRC_ReverseInputData_32b;
    CRC_InitStructure.CRC_ReverseOutputData = CRC_ReverseOutputData_Enable;
    CRC_InitStructure.CRC_DefaultInitValueUse = CRC_DefaultInitValue_Disable;
    CRC_InitStructure.CRC_DefaultInitValue = 0xFFFFFFFF;
    
    CRC_Init(&CRC_InitStructure);
    
    // 计算CRC
    uint32_t crc = 0;
    for(uint32_t i = 0; i < length; i += 4) {
        uint32_t word = 0;
        for(int j = 0; j < 4 && (i + j) < length; j++) {
            word |= (data[i + j] << (j * 8));
        }
        crc = CRC_CalcCRC(word);
    }
    
    printf("CRC32: 0x%08X\n", crc);
    return crc;
}

// 主函数
int main(void) {
    // 初始化系统时钟
    SystemInit();
    
    // 初始化GPIO
    GPIO_InitTypeDef GPIO_InitStructure;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB, ENABLE);
    
    // 配置SDIO引脚
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9 | GPIO_Pin_10 | GPIO_Pin_11; // CLK, CMD, D0, D1
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    
    // 配置CAN引脚
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9; // CAN1 TX, RX
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
    
    printf("OpenPeriph SDIO/CAN/CRC Example\n");
    printf("================================\n");
    
    while(1) {
        printf("\n--- SDIO SD Card Test ---\n");
        sdio_sd_card_init();
        
        printf("\n--- CAN Communication Test ---\n");
        uint8_t can_data[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
        can_send_message(0x123, can_data, 8);
        can_receive_message();
        
        printf("\n--- CRC32 Calculation Test ---\n");
        uint8_t test_data[] = "Hello OpenPeriph!";
        crc32_calculate(test_data, sizeof(test_data) - 1);
        
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
