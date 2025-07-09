
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __WWDG_H
#define __WWDG_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"
#ifdef CYBER_WWDG

/** @defgroup WWDG_Exported_Types
 * @{
 */
typedef struct
{
    volatile uint32_t CR;
    volatile uint32_t CFR;
    volatile uint32_t SR;
} WWDG_TypeDef;

/** @defgroup WWDG_Prescaler
 * @{
 */
#define WWDG_Prescaler_1 ((uint32_t)0x00000000)
#define WWDG_Prescaler_2 ((uint32_t)0x00000080)
#define WWDG_Prescaler_4 ((uint32_t)0x00000100)
#define WWDG_Prescaler_8 ((uint32_t)0x00000180)
#define IS_WWDG_PRESCALER(PRESCALER) (((PRESCALER) == WWDG_Prescaler_1) || \
                                      ((PRESCALER) == WWDG_Prescaler_2) || \
                                      ((PRESCALER) == WWDG_Prescaler_4) || \
                                      ((PRESCALER) == WWDG_Prescaler_8))
#define IS_WWDG_WINDOW_VALUE(VALUE) ((VALUE) <= 0x7F)
#define IS_WWDG_COUNTER(COUNTER) (((COUNTER) >= 0x40) && ((COUNTER) <= 0x7F))

/** @defgroup WWDG_Exported_Functions
 * @{
 */
void WWDG_DeInit(void);
void WWDG_SetPrescaler(uint32_t WWDG_Prescaler);
void WWDG_SetWindowValue(uint8_t WindowValue);
void WWDG_SetCounter(uint8_t Counter);
void WWDG_Enable(uint8_t Counter);
FlagStatus WWDG_GetFlagStatus(void);
void WWDG_ClearFlag(void);

#endif /* CYBER_WWDG */
#endif /* __WWDG_H */
