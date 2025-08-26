
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __RCC_H
#define __RCC_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_RCC

typedef struct
{
    volatile uint32_t CR;
    volatile uint32_t CFGR;
    volatile uint32_t CIR;
    volatile uint32_t APBRSTR;
    volatile uint32_t AHBENR;
    volatile uint32_t APBENR;
    volatile uint32_t BDCR;
    volatile uint32_t CSR;
    volatile uint32_t AHBRSTR;
    volatile uint32_t CFGR2;
} RCC_TypeDef;

typedef struct
{
    uint32_t SYSCLK_Frequency; /*!< returns SYSCLK clock frequency expressed in Hz */
    uint32_t HCLK_Frequency;   /*!< returns HCLK clock frequency expressed in Hz */
    uint32_t PCLK_Frequency;  /*!< returns PCLK1 clock frequency expressed in Hz */
} RCC_ClocksTypeDef;

/** @defgroup AHB_clock_source
 * @{
 */
#define RCC_SYSCLK_Div1 ((uint32_t)0x00000000)
#define RCC_SYSCLK_Div2 ((uint32_t)0x00000080)
#define RCC_SYSCLK_Div4 ((uint32_t)0x00000090)
#define RCC_SYSCLK_Div8 ((uint32_t)0x000000A0)
#define RCC_SYSCLK_Div16 ((uint32_t)0x000000B0)
#define RCC_SYSCLK_Div64 ((uint32_t)0x000000C0)
#define RCC_SYSCLK_Div128 ((uint32_t)0x000000D0)
#define RCC_SYSCLK_Div256 ((uint32_t)0x000000E0)
#define RCC_SYSCLK_Div512 ((uint32_t)0x000000F0)
#define IS_RCC_HCLK(HCLK) (((HCLK) == RCC_SYSCLK_Div1) || ((HCLK) == RCC_SYSCLK_Div2) ||     \
                           ((HCLK) == RCC_SYSCLK_Div4) || ((HCLK) == RCC_SYSCLK_Div8) ||     \
                           ((HCLK) == RCC_SYSCLK_Div16) || ((HCLK) == RCC_SYSCLK_Div64) ||   \
                           ((HCLK) == RCC_SYSCLK_Div128) || ((HCLK) == RCC_SYSCLK_Div256) || \
                           ((HCLK) == RCC_SYSCLK_Div512))

/** @defgroup APB_clock_source
 * @{
 */
#define RCC_HCLK_Div1 ((uint32_t)0x00000000)
#define RCC_HCLK_Div2 ((uint32_t)0x00000400)
#define RCC_HCLK_Div4 ((uint32_t)0x00000500)
#define RCC_HCLK_Div8 ((uint32_t)0x00000600)
#define RCC_HCLK_Div16 ((uint32_t)0x00000700)
#define IS_RCC_PCLK(PCLK) (((PCLK) == RCC_HCLK_Div1) || ((PCLK) == RCC_HCLK_Div2) || \
                           ((PCLK) == RCC_HCLK_Div4) || ((PCLK) == RCC_HCLK_Div8) || \
                           ((PCLK) == RCC_HCLK_Div16))

/** @defgroup AHB_peripheral
 * @{
 */
#define RCC_AHBPeriph_DMA1 ((uint32_t)0x00000001)
#define RCC_AHBPeriph_DMA2 ((uint32_t)0x00000002)
#define RCC_AHBPeriph_SRAM ((uint32_t)0x00000004)
#define RCC_AHBPeriph_FLITF ((uint32_t)0x00000010)
#define RCC_AHBPeriph_CRC ((uint32_t)0x00000040)

#ifndef STM32F10X_CL
#define RCC_AHBPeriph_FSMC ((uint32_t)0x00000100)
#define RCC_AHBPeriph_SDIO ((uint32_t)0x00000400)
#define IS_RCC_AHB_PERIPH(PERIPH) ((((PERIPH) & 0xFFFFFAA8) == 0x00) && ((PERIPH) != 0x00))
#else
#define RCC_AHBPeriph_OTG_FS ((uint32_t)0x00001000)
#define RCC_AHBPeriph_ETH_MAC ((uint32_t)0x00004000)
#define RCC_AHBPeriph_ETH_MAC_Tx ((uint32_t)0x00008000)
#define RCC_AHBPeriph_ETH_MAC_Rx ((uint32_t)0x00010000)

#define IS_RCC_AHB_PERIPH(PERIPH) ((((PERIPH) & 0xFFFE2FA8) == 0x00) && ((PERIPH) != 0x00))
#define IS_RCC_AHB_PERIPH_RESET(PERIPH) ((((PERIPH) & 0xFFFFAFFF) == 0x00) && ((PERIPH) != 0x00))
#endif /* STM32F10X_CL */

/** @defgroup APB_peripheral
 * @{
 */
#define RCC_APBPeriph_AFIO ((uint32_t)0x00000001)
#define RCC_APBPeriph_GPIOA ((uint32_t)0x00000004)
#define RCC_APBPeriph_GPIOB ((uint32_t)0x00000008)
#define RCC_APBPeriph_USART1 ((uint32_t)0x00000010)
#define RCC_APBPeriph_USART2 ((uint32_t)0x00000020)
#define RCC_APBPeriph_I2C1 ((uint32_t)0x00000040)
#define RCC_APBPeriph_I2C2 ((uint32_t)0x00000080)
#define RCC_APBPeriph_SPI1 ((uint32_t)0x00000100)
#define RCC_APBPeriph_SPI2 ((uint32_t)0x00000200)
#define RCC_APBPeriph_TIM1 ((uint32_t)0x00000400)
#define RCC_APBPeriph_TIM2 ((uint32_t)0x00000800)
#define RCC_APBPeriph_TIM3 ((uint32_t)0x00001000)
#define RCC_APBPeriph_IWDG ((uint32_t)0x00002000)
#define RCC_APBPeriph_WWDG ((uint32_t)0x00004000)

#define IS_RCC_APB_PERIPH(PERIPH) ((((PERIPH) & 0x81013600) == 0x00) && ((PERIPH) != 0x00))

/** @defgroup Clock_source_to_output_on_MCO_pin
 * @{
 */
#define RCC_MCO_NoClock ((uint8_t)0x00)
#define RCC_MCO_SYSCLK ((uint8_t)0x04)
#define RCC_MCO_HSI ((uint8_t)0x05)
#define RCC_MCO_HSE ((uint8_t)0x06)
#define RCC_MCO_PLLCLK_Div2 ((uint8_t)0x07)

#ifndef STM32F10X_CL
#define IS_RCC_MCO(MCO) (((MCO) == RCC_MCO_NoClock) || ((MCO) == RCC_MCO_HSI) || \
                         ((MCO) == RCC_MCO_SYSCLK) || ((MCO) == RCC_MCO_HSE) ||  \
                         ((MCO) == RCC_MCO_PLLCLK_Div2))
#else
#define RCC_MCO_PLL2CLK ((uint8_t)0x08)
#define RCC_MCO_PLL3CLK_Div2 ((uint8_t)0x09)
#define RCC_MCO_XT1 ((uint8_t)0x0A)
#define RCC_MCO_PLL3CLK ((uint8_t)0x0B)

#define IS_RCC_MCO(MCO) (((MCO) == RCC_MCO_NoClock) || ((MCO) == RCC_MCO_HSI) ||         \
                         ((MCO) == RCC_MCO_SYSCLK) || ((MCO) == RCC_MCO_HSE) ||          \
                         ((MCO) == RCC_MCO_PLLCLK_Div2) || ((MCO) == RCC_MCO_PLL2CLK) || \
                         ((MCO) == RCC_MCO_PLL3CLK_Div2) || ((MCO) == RCC_MCO_XT1) ||    \
                         ((MCO) == RCC_MCO_PLL3CLK))
#endif /* STM32F10X_CL */

/** @defgroup RCC_Flag
 * @{
 */
#define RCC_FLAG_HSIRDY ((uint8_t)0x21)
#define RCC_FLAG_HSERDY ((uint8_t)0x31)
#define RCC_FLAG_PLLRDY ((uint8_t)0x39)
#define RCC_FLAG_LSERDY ((uint8_t)0x41)
#define RCC_FLAG_LSIRDY ((uint8_t)0x61)
#define RCC_FLAG_PINRST ((uint8_t)0x7A)
#define RCC_FLAG_PORRST ((uint8_t)0x7B)
#define RCC_FLAG_SFTRST ((uint8_t)0x7C)
#define RCC_FLAG_IWDGRST ((uint8_t)0x7D)
#define RCC_FLAG_WWDGRST ((uint8_t)0x7E)
#define RCC_FLAG_LPWRRST ((uint8_t)0x7F)

#ifndef STM32F10X_CL
#define IS_RCC_FLAG(FLAG) (((FLAG) == RCC_FLAG_HSIRDY) || ((FLAG) == RCC_FLAG_HSERDY) ||   \
                           ((FLAG) == RCC_FLAG_PLLRDY) || ((FLAG) == RCC_FLAG_LSERDY) ||   \
                           ((FLAG) == RCC_FLAG_LSIRDY) || ((FLAG) == RCC_FLAG_PINRST) ||   \
                           ((FLAG) == RCC_FLAG_PORRST) || ((FLAG) == RCC_FLAG_SFTRST) ||   \
                           ((FLAG) == RCC_FLAG_IWDGRST) || ((FLAG) == RCC_FLAG_WWDGRST) || \
                           ((FLAG) == RCC_FLAG_LPWRRST))
#else
#define RCC_FLAG_PLL2RDY ((uint8_t)0x3B)
#define RCC_FLAG_PLL3RDY ((uint8_t)0x3D)
#define IS_RCC_FLAG(FLAG) (((FLAG) == RCC_FLAG_HSIRDY) || ((FLAG) == RCC_FLAG_HSERDY) ||   \
                           ((FLAG) == RCC_FLAG_PLLRDY) || ((FLAG) == RCC_FLAG_LSERDY) ||   \
                           ((FLAG) == RCC_FLAG_PLL2RDY) || ((FLAG) == RCC_FLAG_PLL3RDY) || \
                           ((FLAG) == RCC_FLAG_LSIRDY) || ((FLAG) == RCC_FLAG_PINRST) ||   \
                           ((FLAG) == RCC_FLAG_PORRST) || ((FLAG) == RCC_FLAG_SFTRST) ||   \
                           ((FLAG) == RCC_FLAG_IWDGRST) || ((FLAG) == RCC_FLAG_WWDGRST) || \
                           ((FLAG) == RCC_FLAG_LPWRRST))
#endif /* STM32F10X_CL */

#define IS_RCC_CALIBRATION_VALUE(VALUE) ((VALUE) <= 0x1F)

/** @defgroup RCC_Exported_Functions
 * @{
 */
void RCC_DeInit(void);
uint8_t RCC_GetSYSCLKSource(void);
void RCC_HCLKConfig(uint32_t RCC_SYSCLK);
void RCC_PCLKConfig(uint32_t RCC_HCLK);
void RCC_GetClocksFreq(RCC_ClocksTypeDef *RCC_Clocks);
void RCC_AHBPeriphClockCmd(uint32_t RCC_AHBPeriph, FunctionalState NewState);
void RCC_AHBPeriphResetCmd(uint32_t RCC_AHBPeriph, FunctionalState NewState);
void RCC_APBPeriphClockCmd(uint32_t RCC_APBPeriph, FunctionalState NewState);
void RCC_APBPeriphResetCmd(uint32_t RCC_APBPeriph, FunctionalState NewState);
FlagStatus RCC_GetFlagStatus(uint8_t RCC_FLAG);
void RCC_ClearFlag(void);

#endif /* CYBER_RCC */
#endif /* __RCC_H */
