#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpiops.h"

#include "../libs/cyber.h"

#define INPUT  1
#define OUTPUT 0
// MIOn��Ӧ��GPIO���Ϊn
#define PS_LED 0  // MIO_LEDΪMIO0����Ӧ��GPIO���Ϊ0
#define PS_KEY 47 // MIO_KEYΪMIO47����Ӧ��GPIO���Ϊ47

/**
  *****************************************************
  * @brief	��ʼ��PS��MIO
  * @usage	PS_GPIO_Init();	// ��ʼ��PS��GPIO
  *****************************************************
**/
XGpioPs GpioPs;	// GPIOʵ������
void PS_GPIO_Init()
{
    XGpioPs_Config *ConfigPtr;
    ConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    XGpioPs_CfgInitialize(&GpioPs, ConfigPtr, ConfigPtr->BaseAddr);
}

/**
  *****************************************************
  * @brief	��ʼ���ض�GPIO�ڵ�ģʽ��״̬
  * @param	GPIO_Num	GPIO��ţ�MIOΪ0~53��EMIO��54��ʼ��
  * @param	Dir			����/�����OUTPUTΪ�����INPUTΪ����
  * @param	Data		�����ƽ�ߵͣ�0Ϊ�ͣ�1Ϊ�ߣ�������Ϊ������˴�������Ӱ�죩
  * @usage	//����GPIO46Ϊ���ģʽ�����Ϊ�ߵ�ƽ
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
  * @brief	��ȡ�ض�GPIO�ڵ������ƽ,ʹ��ǰ��������GPIO_SetMode���ø�GPIO��Ϊ"����"ģʽ
  * @param	GPIO_Num	GPIO��ţ�MIOΪ0~53��EMIO��54��ʼ��
  * @return	���زɼ���GPIO��ƽֵ��0Ϊ�ͣ�1Ϊ��
  * @usage	//�ɼ�GPIO46�ĵ�ƽ�������state
  *         state = GPIO_GetPort(46, state);
  *****************************************************
**/
uint8_t PS_GPIO_GetPort(uint8_t GPIO_Num)
{
    return XGpioPs_ReadPin(&GpioPs, GPIO_Num); // �����/�͵�ƽ��0Ϊ�ͣ�1Ϊ��
}

/**
  *****************************************************
  * @brief	�����ض�GPIO�ڵ������/�͵�ƽ,ʹ��ǰ��������GPIO_SetMode���ø�GPIO��Ϊ"���"ģʽ
  * @param	GPIO_Num	GPIO��ţ�MIOΪ0~53��EMIO��54��ʼ��
  * @param	Data		�����ƽ�ߵͣ�0Ϊ�ͣ�1Ϊ��
  * @usage	//����GPIO46����ߵ�ƽ
  * 		GPIO_SetPort(46, 1);
  *****************************************************
**/
void PS_GPIO_SetPort(uint8_t GPIO_Num, uint8_t Data)
{
    XGpioPs_WritePin(&GpioPs, GPIO_Num, Data);	//�����/�͵�ƽ��0Ϊ�ͣ�1Ϊ��
}

int main()
{
    init_platform();
    print("Hello World\r\n");
    
    // ��ʼ��PS��GPIO
    PS_GPIO_Init(); // ��ʼ��PS��MIO
    PS_GPIO_SetMode(PS_LED, OUTPUT, 0); // ����PS_LED(MIO7)Ϊ������ҳ�ʼΪ�͵�ƽ
    PS_GPIO_SetMode(PS_KEY, INPUT, 0); // ����PS_KEY(MIO47)����Ϊ����

    // ��ʼ��PL��GPIO
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
