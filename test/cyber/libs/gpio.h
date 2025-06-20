
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __GPIO_H
#define __GPIO_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_GPIO

/** @defgroup GPIO_Exported_Types
 * @{
 */
typedef struct
{
    volatile uint32_t CRL;  // +0 0x00000
    volatile uint32_t CRH;  // +4 0x00100
    volatile uint32_t IDR;  // +8 0x01000
    volatile uint32_t ODR;  // +12 0x01100
    volatile uint32_t BSR;  // +16 0x10000
    volatile uint32_t BRR;  // +20 0x10100
    volatile uint32_t LCKR; // +24 0x11000
} GPIO_TypeDef;
// typedef struct
// {
//     volatile uint32_t EVCR;
//     volatile uint32_t MAPR;
//     volatile uint32_t EXTICR[4];
//     uint32_t RESERVED0;
//     volatile uint32_t MAPR2;
// } AFIO_TypeDef;

#define IS_GPIO_ALL_PERIPH(PERIPH) (((PERIPH) == GPIOA) || \
                                    ((PERIPH) == GPIOB) || \
                                    ((PERIPH) == GPIOC) || \
                                    ((PERIPH) == GPIOD))

/**
 * @brief  Output Maximum frequency selection
 */
typedef enum
{
    GPIO_Speed_10MHz = 1,
    GPIO_Speed_2MHz,
    GPIO_Speed_50MHz
} GPIOSpeed_TypeDef;
#define IS_GPIO_SPEED(SPEED) (((SPEED) == GPIO_Speed_10MHz) || ((SPEED) == GPIO_Speed_2MHz) || \
                              ((SPEED) == GPIO_Speed_50MHz))

/**
 * @brief  Configuration Mode enumeration
 */
typedef enum
{
    GPIO_Mode_AIN = 0x0,
    GPIO_Mode_IN_FLOATING = 0x04,
    GPIO_Mode_IPD = 0x28,
    GPIO_Mode_IPU = 0x48,
    GPIO_Mode_Out_OD = 0x14,
    GPIO_Mode_Out_PP = 0x10,
    GPIO_Mode_AF_OD = 0x1C,
    GPIO_Mode_AF_PP = 0x18
} GPIOMode_TypeDef;

#define IS_GPIO_MODE(MODE) (((MODE) == GPIO_Mode_AIN) || ((MODE) == GPIO_Mode_IN_FLOATING) || \
                            ((MODE) == GPIO_Mode_IPD) || ((MODE) == GPIO_Mode_IPU) ||         \
                            ((MODE) == GPIO_Mode_Out_OD) || ((MODE) == GPIO_Mode_Out_PP) ||   \
                            ((MODE) == GPIO_Mode_AF_OD) || ((MODE) == GPIO_Mode_AF_PP))

/**
 * @brief  GPIO Init structure definition
 */
typedef struct
{
    uint16_t GPIO_Pin;            /*!< Specifies the GPIO pins to be configured.
                                       This parameter can be any value of @ref GPIO_pins_define */
    GPIOSpeed_TypeDef GPIO_Speed; /*!< Specifies the speed for the selected pins.
                                       This parameter can be a value of @ref GPIOSpeed_TypeDef */
    GPIOMode_TypeDef GPIO_Mode;   /*!< Specifies the operating mode for the selected pins.
                                       This parameter can be a value of @ref GPIOMode_TypeDef */
} GPIO_InitTypeDef;

/**
 * @brief  Bit_SET and Bit_RESET enumeration
 */
typedef enum
{
    Bit_RESET = 0,
    Bit_SET
} BitAction;

#define IS_GPIO_BIT_ACTION(ACTION) (((ACTION) == Bit_RESET) || ((ACTION) == Bit_SET))

/** @defgroup GPIO_pins_define
 * @{
 */
#define GPIO_Pin_0 ((uint16_t)0x0001)   /*!< Pin 0 selected */
#define GPIO_Pin_1 ((uint16_t)0x0002)   /*!< Pin 1 selected */
#define GPIO_Pin_2 ((uint16_t)0x0004)   /*!< Pin 2 selected */
#define GPIO_Pin_3 ((uint16_t)0x0008)   /*!< Pin 3 selected */
#define GPIO_Pin_4 ((uint16_t)0x0010)   /*!< Pin 4 selected */
#define GPIO_Pin_5 ((uint16_t)0x0020)   /*!< Pin 5 selected */
#define GPIO_Pin_6 ((uint16_t)0x0040)   /*!< Pin 6 selected */
#define GPIO_Pin_7 ((uint16_t)0x0080)   /*!< Pin 7 selected */
#define GPIO_Pin_8 ((uint16_t)0x0100)   /*!< Pin 8 selected */
#define GPIO_Pin_9 ((uint16_t)0x0200)   /*!< Pin 9 selected */
#define GPIO_Pin_10 ((uint16_t)0x0400)  /*!< Pin 10 selected */
#define GPIO_Pin_11 ((uint16_t)0x0800)  /*!< Pin 11 selected */
#define GPIO_Pin_12 ((uint16_t)0x1000)  /*!< Pin 12 selected */
#define GPIO_Pin_13 ((uint16_t)0x2000)  /*!< Pin 13 selected */
#define GPIO_Pin_14 ((uint16_t)0x4000)  /*!< Pin 14 selected */
#define GPIO_Pin_15 ((uint16_t)0x8000)  /*!< Pin 15 selected */
#define GPIO_Pin_All ((uint16_t)0xFFFF) /*!< All pins selected */

#define IS_GPIO_PIN(PIN) ((((PIN) & (uint16_t)0x00) == 0x00) && ((PIN) != (uint16_t)0x00))
#define IS_GET_GPIO_PIN(PIN) (((PIN) == GPIO_Pin_0) ||  \
                              ((PIN) == GPIO_Pin_1) ||  \
                              ((PIN) == GPIO_Pin_2) ||  \
                              ((PIN) == GPIO_Pin_3) ||  \
                              ((PIN) == GPIO_Pin_4) ||  \
                              ((PIN) == GPIO_Pin_5) ||  \
                              ((PIN) == GPIO_Pin_6) ||  \
                              ((PIN) == GPIO_Pin_7) ||  \
                              ((PIN) == GPIO_Pin_8) ||  \
                              ((PIN) == GPIO_Pin_9) ||  \
                              ((PIN) == GPIO_Pin_10) || \
                              ((PIN) == GPIO_Pin_11) || \
                              ((PIN) == GPIO_Pin_12) || \
                              ((PIN) == GPIO_Pin_13) || \
                              ((PIN) == GPIO_Pin_14) || \
                              ((PIN) == GPIO_Pin_15))

/** @defgroup GPIO_Port_Sources
 * @{
 */
#define GPIO_PortSourceGPIOA ((uint8_t)0x00)
#define GPIO_PortSourceGPIOB ((uint8_t)0x01)
#define GPIO_PortSourceGPIOC ((uint8_t)0x02)
#define GPIO_PortSourceGPIOD ((uint8_t)0x03)
#define IS_GPIO_EVENTOUT_PORT_SOURCE(PORTSOURCE) (((PORTSOURCE) == GPIO_PortSourceGPIOA) || \
                                                  ((PORTSOURCE) == GPIO_PortSourceGPIOB) || \
                                                  ((PORTSOURCE) == GPIO_PortSourceGPIOC) || \
                                                  ((PORTSOURCE) == GPIO_PortSourceGPIOD))
#define IS_GPIO_EXTI_PORT_SOURCE(PORTSOURCE) (((PORTSOURCE) == GPIO_PortSourceGPIOA) || \
                                              ((PORTSOURCE) == GPIO_PortSourceGPIOB) || \
                                              ((PORTSOURCE) == GPIO_PortSourceGPIOC) || \
                                              ((PORTSOURCE) == GPIO_PortSourceGPIOD))

/** @defgroup GPIO_Exported_Functions
 * @{
 */
void GPIO_DeInit(GPIO_TypeDef *GPIOx);
void GPIO_AFIODeInit(void);
void GPIO_Init(GPIO_TypeDef *GPIOx, GPIO_InitTypeDef *GPIO_InitStruct);
void GPIO_StructInit(GPIO_InitTypeDef *GPIO_InitStruct);
uint8_t GPIO_ReadInputDataBit(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
uint16_t GPIO_ReadInputData(GPIO_TypeDef *GPIOx);
uint8_t GPIO_ReadOutputDataBit(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
uint16_t GPIO_ReadOutputData(GPIO_TypeDef *GPIOx);
void GPIO_SetBits(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
void GPIO_ResetBits(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin);
void GPIO_WriteBit(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, BitAction BitVal);
void GPIO_Write(GPIO_TypeDef *GPIOx, uint16_t PortVal);

#endif /* CYBER_GPIO */
#endif /* __GPIO_H */
