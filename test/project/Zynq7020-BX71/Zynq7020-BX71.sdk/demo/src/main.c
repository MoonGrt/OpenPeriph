#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpiops.h"

#include "../libs/cyber.h"

#define INPUT  1
#define OUTPUT 0
// MIOn对应的GPIO编号为n
#define PS_LED 0  // MIO_LED为MIO0，对应的GPIO编号为0
#define PS_KEY 47 // MIO_KEY为MIO47，对应的GPIO编号为47

/**
  *****************************************************
  * @brief	初始化PS端MIO
  * @usage	PS_GPIO_Init();	// 初始化PS端GPIO
  *****************************************************
**/
XGpioPs GpioPs;	// GPIO实例对象
void PS_GPIO_Init()
{
    XGpioPs_Config *ConfigPtr;
    ConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    XGpioPs_CfgInitialize(&GpioPs, ConfigPtr, ConfigPtr->BaseAddr);
}

/**
  *****************************************************
  * @brief	初始化特定GPIO口的模式与状态
  * @param	GPIO_Num	GPIO编号（MIO为0~53，EMIO从54开始）
  * @param	Dir			输入/输出：OUTPUT为输出，INPUT为输入
  * @param	Data		输出电平高低：0为低，1为高（若设置为输入则此处数据无影响）
  * @usage	//设置GPIO46为输出模式，输出为高电平
  * 		GPIO_SetMode(46, OUTPUT, 1);
  *****************************************************
**/
void PS_GPIO_SetMode(uint8_t GPIO_Num, uint8_t Dir, uint8_t Data)
{
    if(Dir == INPUT) {
        XGpioPs_SetDirectionPin(&GpioPs, GPIO_Num, 0);
    } else if(Dir == OUTPUT){
        XGpioPs_SetDirectionPin(&GpioPs, GPIO_Num, 1);
        XGpioPs_SetOutputEnablePin(&GpioPs, GPIO_Num, 1);
        XGpioPs_WritePin(&GpioPs, GPIO_Num, Data);
    }
}

/**
  *****************************************************
  * @brief	读取特定GPIO口的输入电平,使用前必须先用GPIO_SetMode设置该GPIO口为"输入"模式
  * @param	GPIO_Num	GPIO编号（MIO为0~53，EMIO从54开始）
  * @return	返回采集的GPIO电平值，0为低，1为高
  * @usage	//采集GPIO46的电平，存放在state
  *         state = GPIO_GetPort(46, state);
  *****************************************************
**/
uint8_t PS_GPIO_GetPort(uint8_t GPIO_Num)
{
    return XGpioPs_ReadPin(&GpioPs, GPIO_Num); // 输出高/低电平，0为低，1为高
}

/**
  *****************************************************
  * @brief	控制特定GPIO口的输出高/低电平,使用前必须先用GPIO_SetMode设置该GPIO口为"输出"模式
  * @param	GPIO_Num	GPIO编号（MIO为0~53，EMIO从54开始）
  * @param	Data		输出电平高低：0为低，1为高
  * @usage	//控制GPIO46输出高电平
  * 		GPIO_SetPort(46, 1);
  *****************************************************
**/
void PS_GPIO_SetPort(uint8_t GPIO_Num, uint8_t Data)
{
    XGpioPs_WritePin(&GpioPs, GPIO_Num, Data);	//输出高/低电平，0为低，1为高
}

int main()
{
    init_platform();
    print("Hello World\r\n");
    
    // 初始化PS端GPIO
    PS_GPIO_Init(); // 初始化PS端MIO
    PS_GPIO_SetMode(PS_LED, OUTPUT, 0); // 设置PS_LED(MIO7)为输出并且初始为低电平
    PS_GPIO_SetMode(PS_KEY, INPUT, 0); // 设置PS_KEY(MIO47)方向为输入

    // 初始化PL端GPIO
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    xil_printf("GPIOA->CRL: 0x%08X\r\n", GPIOA->CRL);
    xil_printf("GPIOA->CRH: 0x%08X\r\n", GPIOA->CRH);

    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    xil_printf("GPIOA->CRL: 0x%08X\r\n", GPIOA->CRL);
    xil_printf("GPIOA->CRH: 0x%08X\r\n", GPIOA->CRH);

    while(1)
    {
        GPIO_WriteBit(GPIOA, GPIO_Pin_0, !PS_GPIO_GetPort(PS_KEY));
        PS_GPIO_SetPort(PS_LED, !PS_GPIO_GetPort(PS_KEY));
    }

    cleanup_platform();
    return 0;
}
