
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __EXTI_H
#define __EXTI_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_EXTI

/** @addtogroup EXTI
 * @{
 */

/** @defgroup EXTI_Exported_Types
 * @{
 */

typedef struct
{
  __IO uint32_t IMR;
  __IO uint32_t EMR;
  __IO uint32_t RTSR;
  __IO uint32_t FTSR;
  __IO uint32_t SWIER;
  __IO uint32_t PR;
} EXTI_TypeDef;

/** @defgroup GPIO_Pin_sources
 * @{
 */

#define GPIO_PinSource0 ((uint8_t)0x00)
#define GPIO_PinSource1 ((uint8_t)0x01)
#define GPIO_PinSource2 ((uint8_t)0x02)
#define GPIO_PinSource3 ((uint8_t)0x03)
#define GPIO_PinSource4 ((uint8_t)0x04)
#define GPIO_PinSource5 ((uint8_t)0x05)
#define GPIO_PinSource6 ((uint8_t)0x06)
#define GPIO_PinSource7 ((uint8_t)0x07)
#define GPIO_PinSource8 ((uint8_t)0x08)
#define GPIO_PinSource9 ((uint8_t)0x09)
#define GPIO_PinSource10 ((uint8_t)0x0A)
#define GPIO_PinSource11 ((uint8_t)0x0B)
#define GPIO_PinSource12 ((uint8_t)0x0C)
#define GPIO_PinSource13 ((uint8_t)0x0D)
#define GPIO_PinSource14 ((uint8_t)0x0E)
#define GPIO_PinSource15 ((uint8_t)0x0F)

#define IS_GPIO_PIN_SOURCE(PINSOURCE) (((PINSOURCE) == GPIO_PinSource0) ||  \
                                       ((PINSOURCE) == GPIO_PinSource1) ||  \
                                       ((PINSOURCE) == GPIO_PinSource2) ||  \
                                       ((PINSOURCE) == GPIO_PinSource3) ||  \
                                       ((PINSOURCE) == GPIO_PinSource4) ||  \
                                       ((PINSOURCE) == GPIO_PinSource5) ||  \
                                       ((PINSOURCE) == GPIO_PinSource6) ||  \
                                       ((PINSOURCE) == GPIO_PinSource7) ||  \
                                       ((PINSOURCE) == GPIO_PinSource8) ||  \
                                       ((PINSOURCE) == GPIO_PinSource9) ||  \
                                       ((PINSOURCE) == GPIO_PinSource10) || \
                                       ((PINSOURCE) == GPIO_PinSource11) || \
                                       ((PINSOURCE) == GPIO_PinSource12) || \
                                       ((PINSOURCE) == GPIO_PinSource13) || \
                                       ((PINSOURCE) == GPIO_PinSource14) || \
                                       ((PINSOURCE) == GPIO_PinSource15))

/**
 * @}
 */

/**
 * @brief  EXTI mode enumeration
 */

typedef enum
{
  EXTI_Mode_Interrupt = 0x00,
  EXTI_Mode_Event = 0x04
} EXTIMode_TypeDef;

#define IS_EXTI_MODE(MODE) (((MODE) == EXTI_Mode_Interrupt) || ((MODE) == EXTI_Mode_Event))

/**
 * @brief  EXTI Trigger enumeration
 */

typedef enum
{
  EXTI_Trigger_Rising = 0x08,
  EXTI_Trigger_Falling = 0x0C,
  EXTI_Trigger_Rising_Falling = 0x10
} EXTITrigger_TypeDef;

#define IS_EXTI_TRIGGER(TRIGGER) (((TRIGGER) == EXTI_Trigger_Rising) ||  \
                                  ((TRIGGER) == EXTI_Trigger_Falling) || \
                                  ((TRIGGER) == EXTI_Trigger_Rising_Falling))
/**
 * @brief  EXTI Init Structure definition
 */

typedef struct
{
  uint32_t EXTI_Line;               /*!< Specifies the EXTI lines to be enabled or disabled.
                                         This parameter can be any combination of @ref EXTI_Lines */
  EXTIMode_TypeDef EXTI_Mode;       /*!< Specifies the mode for the EXTI lines.
                                         This parameter can be a value of @ref EXTIMode_TypeDef */
  EXTITrigger_TypeDef EXTI_Trigger; /*!< Specifies the trigger signal active edge for the EXTI lines.
                                         This parameter can be a value of @ref EXTIMode_TypeDef */
  FunctionalState EXTI_LineCmd;     /*!< Specifies the new state of the selected EXTI lines.
                                         This parameter can be set either to ENABLE or DISABLE */
} EXTI_InitTypeDef;

/**
 * @}
 */

/** @defgroup EXTI_Exported_Constants
 * @{
 */

/** @defgroup EXTI_Lines
 * @{
 */

#define EXTI_Line0 ((uint32_t)0x00001)  /*!< External interrupt line 0 */
#define EXTI_Line1 ((uint32_t)0x00002)  /*!< External interrupt line 1 */
#define EXTI_Line2 ((uint32_t)0x00004)  /*!< External interrupt line 2 */
#define EXTI_Line3 ((uint32_t)0x00008)  /*!< External interrupt line 3 */
#define EXTI_Line4 ((uint32_t)0x00010)  /*!< External interrupt line 4 */
#define EXTI_Line5 ((uint32_t)0x00020)  /*!< External interrupt line 5 */
#define EXTI_Line6 ((uint32_t)0x00040)  /*!< External interrupt line 6 */
#define EXTI_Line7 ((uint32_t)0x00080)  /*!< External interrupt line 7 */
#define EXTI_Line8 ((uint32_t)0x00100)  /*!< External interrupt line 8 */
#define EXTI_Line9 ((uint32_t)0x00200)  /*!< External interrupt line 9 */
#define EXTI_Line10 ((uint32_t)0x00400) /*!< External interrupt line 10 */
#define EXTI_Line11 ((uint32_t)0x00800) /*!< External interrupt line 11 */
#define EXTI_Line12 ((uint32_t)0x01000) /*!< External interrupt line 12 */
#define EXTI_Line13 ((uint32_t)0x02000) /*!< External interrupt line 13 */
#define EXTI_Line14 ((uint32_t)0x04000) /*!< External interrupt line 14 */
#define EXTI_Line15 ((uint32_t)0x08000) /*!< External interrupt line 15 */
#define EXTI_Line16 ((uint32_t)0x10000) /*!< External interrupt line 16 Connected to the PVD Output */
#define EXTI_Line17 ((uint32_t)0x20000) /*!< External interrupt line 17 Connected to the RTC Alarm event */
#define EXTI_Line18 ((uint32_t)0x40000) /*!< External interrupt line 18 Connected to the USB Device/USB OTG FS \
                                             Wakeup from suspend event */
#define EXTI_Line19 ((uint32_t)0x80000) /*!< External interrupt line 19 Connected to the Ethernet Wakeup event */

#define IS_EXTI_LINE(LINE) ((((LINE) & (uint32_t)0xFFF00000) == 0x00) && ((LINE) != (uint16_t)0x00))
#define IS_GET_EXTI_LINE(LINE) (((LINE) == EXTI_Line0) || ((LINE) == EXTI_Line1) ||   \
                                ((LINE) == EXTI_Line2) || ((LINE) == EXTI_Line3) ||   \
                                ((LINE) == EXTI_Line4) || ((LINE) == EXTI_Line5) ||   \
                                ((LINE) == EXTI_Line6) || ((LINE) == EXTI_Line7) ||   \
                                ((LINE) == EXTI_Line8) || ((LINE) == EXTI_Line9) ||   \
                                ((LINE) == EXTI_Line10) || ((LINE) == EXTI_Line11) || \
                                ((LINE) == EXTI_Line12) || ((LINE) == EXTI_Line13) || \
                                ((LINE) == EXTI_Line14) || ((LINE) == EXTI_Line15) || \
                                ((LINE) == EXTI_Line16) || ((LINE) == EXTI_Line17) || \
                                ((LINE) == EXTI_Line18) || ((LINE) == EXTI_Line19))

/**
 * @}
 */

/**
 * @}
 */

/** @defgroup EXTI_Exported_Macros
 * @{
 */

/**
 * @}
 */

/** @defgroup EXTI_Exported_Functions
 * @{
 */

void EXTI_DeInit(void);
void EXTI_Init(EXTI_InitTypeDef *EXTI_InitStruct);
void EXTI_StructInit(EXTI_InitTypeDef *EXTI_InitStruct);
void EXTI_GenerateSWInterrupt(uint32_t EXTI_Line);
FlagStatus EXTI_GetFlagStatus(uint32_t EXTI_Line);
void EXTI_ClearFlag(uint32_t EXTI_Line);
ITStatus EXTI_GetITStatus(uint32_t EXTI_Line);
void EXTI_ClearITPendingBit(uint32_t EXTI_Line);

#endif /* CYBER_EXTI */
#endif /* __EXTI_H */
