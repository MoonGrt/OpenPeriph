
/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_RCC

/** @defgroup RCC_Private_Defines
 * @{
 */
/**
 * @brief In the following line adjust the value of External High Speed oscillator (HSE)
   used in your application 
   
   Tip: To avoid modifying this file each time you need to use different HSE, you
        can define the HSE value in your toolchain compiler preprocessor.
  */           
#if !defined  HSE_VALUE
 #ifdef STM32F10X_CL   
  #define HSE_VALUE    ((uint32_t)25000000) /*!< Value of the External oscillator in Hz */
 #else 
  #define HSE_VALUE    ((uint32_t)8000000) /*!< Value of the External oscillator in Hz */
 #endif /* STM32F10X_CL */
#endif /* HSE_VALUE */

/**
 * @brief In the following line adjust the External High Speed oscillator (HSE) Startup 
   Timeout value 
   */
#define HSE_STARTUP_TIMEOUT   ((uint16_t)0x0500) /*!< Time out for HSE start up */

#define HSI_VALUE    ((uint32_t)8000000) /*!< Value of the Internal oscillator in Hz*/

/* ------------ RCC registers bit address in the alias region ----------- */
#define RCC_OFFSET (RCC_BASE - PERIPH_BASE)

/* --- CR Register ---*/

/* Alias word address of HSION bit */
#define CR_OFFSET (RCC_OFFSET + 0x00)
#define HSION_BitNumber 0x00
#define CR_HSION_BB (PERIPH_BB_BASE + (CR_OFFSET * 32) + (HSION_BitNumber * 4))

/* Alias word address of PLLON bit */
#define PLLON_BitNumber 0x18
#define CR_PLLON_BB (PERIPH_BB_BASE + (CR_OFFSET * 32) + (PLLON_BitNumber * 4))

#ifdef STM32F10X_CL
/* Alias word address of PLL2ON bit */
#define PLL2ON_BitNumber 0x1A
#define CR_PLL2ON_BB (PERIPH_BB_BASE + (CR_OFFSET * 32) + (PLL2ON_BitNumber * 4))

/* Alias word address of PLL3ON bit */
#define PLL3ON_BitNumber 0x1C
#define CR_PLL3ON_BB (PERIPH_BB_BASE + (CR_OFFSET * 32) + (PLL3ON_BitNumber * 4))
#endif /* STM32F10X_CL */

/* Alias word address of CSSON bit */
#define CSSON_BitNumber 0x13
#define CR_CSSON_BB (PERIPH_BB_BASE + (CR_OFFSET * 32) + (CSSON_BitNumber * 4))

/* --- CFGR Register ---*/

/* Alias word address of USBPRE bit */
#define CFGR_OFFSET (RCC_OFFSET + 0x04)

#ifndef STM32F10X_CL
#define USBPRE_BitNumber 0x16
#define CFGR_USBPRE_BB (PERIPH_BB_BASE + (CFGR_OFFSET * 32) + (USBPRE_BitNumber * 4))
#else
#define OTGFSPRE_BitNumber 0x16
#define CFGR_OTGFSPRE_BB (PERIPH_BB_BASE + (CFGR_OFFSET * 32) + (OTGFSPRE_BitNumber * 4))
#endif /* STM32F10X_CL */

/* --- BDCR Register ---*/

/* Alias word address of RTCEN bit */
#define BDCR_OFFSET (RCC_OFFSET + 0x20)
#define RTCEN_BitNumber 0x0F
#define BDCR_RTCEN_BB (PERIPH_BB_BASE + (BDCR_OFFSET * 32) + (RTCEN_BitNumber * 4))

/* Alias word address of BDRST bit */
#define BDRST_BitNumber 0x10
#define BDCR_BDRST_BB (PERIPH_BB_BASE + (BDCR_OFFSET * 32) + (BDRST_BitNumber * 4))

/* --- CSR Register ---*/

/* Alias word address of LSION bit */
#define CSR_OFFSET (RCC_OFFSET + 0x24)
#define LSION_BitNumber 0x00
#define CSR_LSION_BB (PERIPH_BB_BASE + (CSR_OFFSET * 32) + (LSION_BitNumber * 4))

#ifdef STM32F10X_CL
/* --- CFGR2 Register ---*/

/* Alias word address of I2S2SRC bit */
#define CFGR2_OFFSET (RCC_OFFSET + 0x2C)
#define I2S2SRC_BitNumber 0x11
#define CFGR2_I2S2SRC_BB (PERIPH_BB_BASE + (CFGR2_OFFSET * 32) + (I2S2SRC_BitNumber * 4))

/* Alias word address of I2S3SRC bit */
#define I2S3SRC_BitNumber 0x12
#define CFGR2_I2S3SRC_BB (PERIPH_BB_BASE + (CFGR2_OFFSET * 32) + (I2S3SRC_BitNumber * 4))
#endif /* STM32F10X_CL */

/* ---------------------- RCC registers bit mask ------------------------ */

/* CR register bit mask */
#define CR_HSEBYP_Reset ((uint32_t)0xFFFBFFFF)
#define CR_HSEBYP_Set ((uint32_t)0x00040000)
#define CR_HSEON_Reset ((uint32_t)0xFFFEFFFF)
#define CR_HSEON_Set ((uint32_t)0x00010000)
#define CR_HSITRIM_Mask ((uint32_t)0xFFFFFF07)

/* CFGR register bit mask */
#if defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) || defined(STM32F10X_HD_VL) || defined(STM32F10X_CL)
#define CFGR_PLL_Mask ((uint32_t)0xFFC2FFFF)
#else
#define CFGR_PLL_Mask ((uint32_t)0xFFC0FFFF)
#endif /* STM32F10X_CL */

#define CFGR_PLLMull_Mask ((uint32_t)0x003C0000)
#define CFGR_PLLSRC_Mask ((uint32_t)0x00010000)
#define CFGR_PLLXTPRE_Mask ((uint32_t)0x00020000)
#define CFGR_SWS_Mask ((uint32_t)0x0000000C)
#define CFGR_SW_Mask ((uint32_t)0xFFFFFFFC)
#define CFGR_HPRE_Reset_Mask ((uint32_t)0xFFFFFF0F)
#define CFGR_HPRE_Set_Mask ((uint32_t)0x000000F0)
#define CFGR_PPRE1_Reset_Mask ((uint32_t)0xFFFFF8FF)
#define CFGR_PPRE1_Set_Mask ((uint32_t)0x00000700)
#define CFGR_PPRE2_Reset_Mask ((uint32_t)0xFFFFC7FF)
#define CFGR_PPRE2_Set_Mask ((uint32_t)0x00003800)
#define CFGR_ADCPRE_Reset_Mask ((uint32_t)0xFFFF3FFF)
#define CFGR_ADCPRE_Set_Mask ((uint32_t)0x0000C000)

/* CSR register bit mask */
#define CSR_RMVF_Set ((uint32_t)0x01000000)

#if defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) || defined(STM32F10X_HD_VL) || defined(STM32F10X_CL)
/* CFGR2 register bit mask */
#define CFGR2_PREDIV1SRC ((uint32_t)0x00010000)
#define CFGR2_PREDIV1 ((uint32_t)0x0000000F)
#endif
#ifdef STM32F10X_CL
#define CFGR2_PREDIV2 ((uint32_t)0x000000F0)
#define CFGR2_PLL2MUL ((uint32_t)0x00000F00)
#define CFGR2_PLL3MUL ((uint32_t)0x0000F000)
#endif /* STM32F10X_CL */

/* RCC Flag Mask */
#define FLAG_Mask ((uint8_t)0x1F)

/* CIR register byte 2 (Bits[15:8]) base address */
#define CIR_BYTE2_ADDRESS ((uint32_t)0x40021009)

/* CIR register byte 3 (Bits[23:16]) base address */
#define CIR_BYTE3_ADDRESS ((uint32_t)0x4002100A)

/* CFGR register byte 4 (Bits[31:24]) base address */
#define CFGR_BYTE4_ADDRESS ((uint32_t)0x40021007)

/* BDCR register base address */
#define BDCR_ADDRESS (PERIPH_BASE + BDCR_OFFSET)

/**
 * @}
 */

/** @defgroup RCC_Private_Macros
 * @{
 */

/**
 * @}
 */

/** @defgroup RCC_Private_Variables
 * @{
 */

static volatile const uint8_t APBAHBPrescTable[16] = {0, 0, 0, 0, 1, 2, 3, 4, 1, 2, 3, 4, 6, 7, 8, 9};
static volatile const uint8_t ADCPrescTable[4] = {2, 4, 6, 8};

/**
 * @}
 */

/** @defgroup RCC_Private_FunctionPrototypes
 * @{
 */

/**
 * @}
 */

/** @defgroup RCC_Private_Functions
 * @{
 */

/**
 * @brief  Resets the RCC clock configuration to the default reset state.
 * @param  None
 * @retval None
 */
void RCC_DeInit(void)
{
    /* Set HSION bit */
    RCC->CR |= (uint32_t)0x00000001;

    /* Reset SW, HPRE, PPRE1, PPRE2, ADCPRE and MCO bits */
#ifndef STM32F10X_CL
    RCC->CFGR &= (uint32_t)0xF8FF0000;
#else
    RCC->CFGR &= (uint32_t)0xF0FF0000;
#endif /* STM32F10X_CL */

    /* Reset HSEON, CSSON and PLLON bits */
    RCC->CR &= (uint32_t)0xFEF6FFFF;

    /* Reset HSEBYP bit */
    RCC->CR &= (uint32_t)0xFFFBFFFF;

    /* Reset PLLSRC, PLLXTPRE, PLLMUL and USBPRE/OTGFSPRE bits */
    RCC->CFGR &= (uint32_t)0xFF80FFFF;

#ifdef STM32F10X_CL
    /* Reset PLL2ON and PLL3ON bits */
    RCC->CR &= (uint32_t)0xEBFFFFFF;

    /* Disable all interrupts and clear pending bits  */
    RCC->CIR = 0x00FF0000;

    /* Reset CFGR2 register */
    RCC->CFGR2 = 0x00000000;
#elif defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) || defined(STM32F10X_HD_VL)
    /* Disable all interrupts and clear pending bits  */
    RCC->CIR = 0x009F0000;

    /* Reset CFGR2 register */
    RCC->CFGR2 = 0x00000000;
#else
    /* Disable all interrupts and clear pending bits  */
    RCC->CIR = 0x009F0000;
#endif /* STM32F10X_CL */
}

/**
 * @brief  Configures the system clock (SYSCLK).
 * @param  RCC_SYSCLKSource: specifies the clock source used as system clock.
 *   This parameter can be one of the following values:
 *     @arg RCC_SYSCLKSource_HSI: HSI selected as system clock
 *     @arg RCC_SYSCLKSource_HSE: HSE selected as system clock
 *     @arg RCC_SYSCLKSource_PLLCLK: PLL selected as system clock
 * @retval None
 */
void RCC_SYSCLKConfig(uint32_t RCC_SYSCLKSource)
{
    uint32_t tmpreg = 0;
    /* Check the parameters */
    assert_param(IS_RCC_SYSCLK_SOURCE(RCC_SYSCLKSource));
    tmpreg = RCC->CFGR;
    /* Clear SW[1:0] bits */
    tmpreg &= CFGR_SW_Mask;
    /* Set SW[1:0] bits according to RCC_SYSCLKSource value */
    tmpreg |= RCC_SYSCLKSource;
    /* Store the new value */
    RCC->CFGR = tmpreg;
}

/**
 * @brief  Returns the clock source used as system clock.
 * @param  None
 * @retval The clock source used as system clock. The returned value can
 *   be one of the following:
 *     - 0x00: HSI used as system clock
 *     - 0x04: HSE used as system clock
 *     - 0x08: PLL used as system clock
 */
uint8_t RCC_GetSYSCLKSource(void)
{
    return ((uint8_t)(RCC->CFGR & CFGR_SWS_Mask));
}

/**
 * @brief  Configures the AHB clock (HCLK).
 * @param  RCC_SYSCLK: defines the AHB clock divider. This clock is derived from
 *   the system clock (SYSCLK).
 *   This parameter can be one of the following values:
 *     @arg RCC_SYSCLK_Div1: AHB clock = SYSCLK
 *     @arg RCC_SYSCLK_Div2: AHB clock = SYSCLK/2
 *     @arg RCC_SYSCLK_Div4: AHB clock = SYSCLK/4
 *     @arg RCC_SYSCLK_Div8: AHB clock = SYSCLK/8
 *     @arg RCC_SYSCLK_Div16: AHB clock = SYSCLK/16
 *     @arg RCC_SYSCLK_Div64: AHB clock = SYSCLK/64
 *     @arg RCC_SYSCLK_Div128: AHB clock = SYSCLK/128
 *     @arg RCC_SYSCLK_Div256: AHB clock = SYSCLK/256
 *     @arg RCC_SYSCLK_Div512: AHB clock = SYSCLK/512
 * @retval None
 */
void RCC_HCLKConfig(uint32_t RCC_SYSCLK)
{
    uint32_t tmpreg = 0;
    /* Check the parameters */
    assert_param(IS_RCC_HCLK(RCC_SYSCLK));
    tmpreg = RCC->CFGR;
    /* Clear HPRE[3:0] bits */
    tmpreg &= CFGR_HPRE_Reset_Mask;
    /* Set HPRE[3:0] bits according to RCC_SYSCLK value */
    tmpreg |= RCC_SYSCLK;
    /* Store the new value */
    RCC->CFGR = tmpreg;
}

/**
 * @brief  Configures the Low Speed APB clock (PCLK).
 * @param  RCC_HCLK: defines the APB clock divider. This clock is derived from
 *   the AHB clock (HCLK).
 *   This parameter can be one of the following values:
 *     @arg RCC_HCLK_Div1: APB clock = HCLK
 *     @arg RCC_HCLK_Div2: APB clock = HCLK/2
 *     @arg RCC_HCLK_Div4: APB clock = HCLK/4
 *     @arg RCC_HCLK_Div8: APB clock = HCLK/8
 *     @arg RCC_HCLK_Div16: APB clock = HCLK/16
 * @retval None
 */
void RCC_PCLKConfig(uint32_t RCC_HCLK)
{
    uint32_t tmpreg = 0;
    /* Check the parameters */
    assert_param(IS_RCC_PCLK(RCC_HCLK));
    tmpreg = RCC->CFGR;
    /* Clear PPRE1[2:0] bits */
    tmpreg &= CFGR_PPRE1_Reset_Mask;
    /* Set PPRE1[2:0] bits according to RCC_HCLK value */
    tmpreg |= RCC_HCLK;
    /* Store the new value */
    RCC->CFGR = tmpreg;
}

/**
 * @brief  Returns the frequencies of different on chip clocks.
 * @param  RCC_Clocks: pointer to a RCC_ClocksTypeDef structure which will hold
 *         the clocks frequencies.
 * @note   The result of this function could be not correct when using
 *         fractional value for HSE crystal.
 * @retval None
 */
void RCC_GetClocksFreq(RCC_ClocksTypeDef *RCC_Clocks)
{
    uint32_t tmp = 0, pllmull = 0, pllsource = 0, presc = 0;

#ifdef STM32F10X_CL
    uint32_t prediv1source = 0, prediv1factor = 0, prediv2factor = 0, pll2mull = 0;
#endif /* STM32F10X_CL */

#if defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) || defined(STM32F10X_HD_VL)
    uint32_t prediv1factor = 0;
#endif

    /* Get SYSCLK source -------------------------------------------------------*/
    tmp = RCC->CFGR & CFGR_SWS_Mask;

    switch (tmp)
    {
    case 0x00: /* HSI used as system clock */
        RCC_Clocks->SYSCLK_Frequency = HSI_VALUE;
        break;
    case 0x04: /* HSE used as system clock */
        RCC_Clocks->SYSCLK_Frequency = HSE_VALUE;
        break;
    case 0x08: /* PLL used as system clock */

        /* Get PLL clock source and multiplication factor ----------------------*/
        pllmull = RCC->CFGR & CFGR_PLLMull_Mask;
        pllsource = RCC->CFGR & CFGR_PLLSRC_Mask;

#ifndef STM32F10X_CL
        pllmull = (pllmull >> 18) + 2;

        if (pllsource == 0x00)
        { /* HSI oscillator clock divided by 2 selected as PLL clock entry */
            RCC_Clocks->SYSCLK_Frequency = (HSI_VALUE >> 1) * pllmull;
        }
        else
        {
#if defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) || defined(STM32F10X_HD_VL)
            prediv1factor = (RCC->CFGR2 & CFGR2_PREDIV1) + 1;
            /* HSE oscillator clock selected as PREDIV1 clock entry */
            RCC_Clocks->SYSCLK_Frequency = (HSE_VALUE / prediv1factor) * pllmull;
#else
            /* HSE selected as PLL clock entry */
            if ((RCC->CFGR & CFGR_PLLXTPRE_Mask) != (uint32_t)RESET)
            { /* HSE oscillator clock divided by 2 */
                RCC_Clocks->SYSCLK_Frequency = (HSE_VALUE >> 1) * pllmull;
            }
            else
            {
                RCC_Clocks->SYSCLK_Frequency = HSE_VALUE * pllmull;
            }
#endif
        }
#else
        pllmull = pllmull >> 18;

        if (pllmull != 0x0D)
        {
            pllmull += 2;
        }
        else
        { /* PLL multiplication factor = PLL input clock * 6.5 */
            pllmull = 13 / 2;
        }

        if (pllsource == 0x00)
        { /* HSI oscillator clock divided by 2 selected as PLL clock entry */
            RCC_Clocks->SYSCLK_Frequency = (HSI_VALUE >> 1) * pllmull;
        }
        else
        { /* PREDIV1 selected as PLL clock entry */

            /* Get PREDIV1 clock source and division factor */
            prediv1source = RCC->CFGR2 & CFGR2_PREDIV1SRC;
            prediv1factor = (RCC->CFGR2 & CFGR2_PREDIV1) + 1;

            if (prediv1source == 0)
            { /* HSE oscillator clock selected as PREDIV1 clock entry */
                RCC_Clocks->SYSCLK_Frequency = (HSE_VALUE / prediv1factor) * pllmull;
            }
            else
            { /* PLL2 clock selected as PREDIV1 clock entry */

                /* Get PREDIV2 division factor and PLL2 multiplication factor */
                prediv2factor = ((RCC->CFGR2 & CFGR2_PREDIV2) >> 4) + 1;
                pll2mull = ((RCC->CFGR2 & CFGR2_PLL2MUL) >> 8) + 2;
                RCC_Clocks->SYSCLK_Frequency = (((HSE_VALUE / prediv2factor) * pll2mull) / prediv1factor) * pllmull;
            }
        }
#endif /* STM32F10X_CL */
        break;

    default:
        RCC_Clocks->SYSCLK_Frequency = HSI_VALUE;
        break;
    }

    /* Compute HCLK, PCLK clocks frequencies ----------------*/
    /* Get HCLK prescaler */
    tmp = RCC->CFGR & CFGR_HPRE_Set_Mask;
    tmp = tmp >> 4;
    presc = APBAHBPrescTable[tmp];
    /* HCLK clock frequency */
    RCC_Clocks->HCLK_Frequency = RCC_Clocks->SYSCLK_Frequency >> presc;
    /* Get PCLK prescaler */
    tmp = RCC->CFGR & CFGR_PPRE1_Set_Mask;
    tmp = tmp >> 8;
    presc = APBAHBPrescTable[tmp];
    /* PCLK clock frequency */
    RCC_Clocks->PCLK_Frequency = RCC_Clocks->HCLK_Frequency >> presc;
}

/**
 * @brief  Enables or disables the AHB peripheral clock.
 * @param  RCC_AHBPeriph: specifies the AHB peripheral to gates its clock.
 *
 *   For @b STM32_Connectivity_line_devices, this parameter can be any combination
 *   of the following values:
 *     @arg RCC_AHBPeriph_DMA1
 *     @arg RCC_AHBPeriph_DMA2
 *     @arg RCC_AHBPeriph_SRAM
 *     @arg RCC_AHBPeriph_FLITF
 *     @arg RCC_AHBPeriph_CRC
 *     @arg RCC_AHBPeriph_OTG_FS
 *     @arg RCC_AHBPeriph_ETH_MAC
 *     @arg RCC_AHBPeriph_ETH_MAC_Tx
 *     @arg RCC_AHBPeriph_ETH_MAC_Rx
 *
 *   For @b other_STM32_devices, this parameter can be any combination of the
 *   following values:
 *     @arg RCC_AHBPeriph_DMA1
 *     @arg RCC_AHBPeriph_DMA2
 *     @arg RCC_AHBPeriph_SRAM
 *     @arg RCC_AHBPeriph_FLITF
 *     @arg RCC_AHBPeriph_CRC
 *     @arg RCC_AHBPeriph_FSMC
 *     @arg RCC_AHBPeriph_SDIO
 *
 * @note SRAM and FLITF clock can be disabled only during sleep mode.
 * @param  NewState: new state of the specified peripheral clock.
 *   This parameter can be: ENABLE or DISABLE.
 * @retval None
 */
void RCC_AHBPeriphClockCmd(uint32_t RCC_AHBPeriph, FunctionalState NewState)
{
    /* Check the parameters */
    assert_param(IS_RCC_AHB_PERIPH(RCC_AHBPeriph));
    assert_param(IS_FUNCTIONAL_STATE(NewState));

    if (NewState != DISABLE)
    {
        RCC->AHBENR |= RCC_AHBPeriph;
    }
    else
    {
        RCC->AHBENR &= ~RCC_AHBPeriph;
    }
}

/**
 * @brief  Enables or disables the Low Speed APB (APB) peripheral clock.
 * @param  RCC_APBPeriph: specifies the APB peripheral to gates its clock.
 *   This parameter can be any combination of the following values:
 *     @arg RCC_APBPeriph_TIM2, RCC_APBPeriph_TIM3, RCC_APBPeriph_TIM4,
 *          RCC_APBPeriph_TIM5, RCC_APBPeriph_TIM6, RCC_APBPeriph_TIM7,
 *          RCC_APBPeriph_WWDG, RCC_APBPeriph_SPI2, RCC_APBPeriph_SPI3,
 *          RCC_APBPeriph_USART2, RCC_APBPeriph_USART3, RCC_APBPeriph_USART4,
 *          RCC_APBPeriph_USART5, RCC_APBPeriph_I2C1, RCC_APBPeriph_I2C2,
 *          RCC_APBPeriph_USB, RCC_APBPeriph_CAN1, RCC_APBPeriph_BKP,
 *          RCC_APBPeriph_PWR, RCC_APBPeriph_DAC, RCC_APBPeriph_CEC,
 *          RCC_APBPeriph_TIM12, RCC_APBPeriph_TIM13, RCC_APBPeriph_TIM14
 * @param  NewState: new state of the specified peripheral clock.
 *   This parameter can be: ENABLE or DISABLE.
 * @retval None
 */
void RCC_APBPeriphClockCmd(uint32_t RCC_APBPeriph, FunctionalState NewState)
{
    /* Check the parameters */
    assert_param(IS_RCC_APB_PERIPH(RCC_APBPeriph));
    assert_param(IS_FUNCTIONAL_STATE(NewState));
    if (NewState != DISABLE)
    {
        RCC->APBENR |= RCC_APBPeriph;
    }
    else
    {
        RCC->APBENR &= ~RCC_APBPeriph;
    }
}

#ifdef STM32F10X_CL
/**
 * @brief  Forces or releases AHB peripheral reset.
 * @note   This function applies only to STM32 Connectivity line devices.
 * @param  RCC_AHBPeriph: specifies the AHB peripheral to reset.
 *   This parameter can be any combination of the following values:
 *     @arg RCC_AHBPeriph_OTG_FS
 *     @arg RCC_AHBPeriph_ETH_MAC
 * @param  NewState: new state of the specified peripheral reset.
 *   This parameter can be: ENABLE or DISABLE.
 * @retval None
 */
void RCC_AHBPeriphResetCmd(uint32_t RCC_AHBPeriph, FunctionalState NewState)
{
    /* Check the parameters */
    assert_param(IS_RCC_AHB_PERIPH_RESET(RCC_AHBPeriph));
    assert_param(IS_FUNCTIONAL_STATE(NewState));

    if (NewState != DISABLE)
    {
        RCC->AHBRSTR |= RCC_AHBPeriph;
    }
    else
    {
        RCC->AHBRSTR &= ~RCC_AHBPeriph;
    }
}
#endif /* STM32F10X_CL */

/**
 * @brief  Forces or releases Low Speed APB (APB) peripheral reset.
 * @param  RCC_APBPeriph: specifies the APB peripheral to reset.
 *   This parameter can be any combination of the following values:
 *     @arg RCC_APBPeriph_TIM2, RCC_APBPeriph_TIM3, RCC_APBPeriph_TIM4,
 *          RCC_APBPeriph_TIM5, RCC_APBPeriph_TIM6, RCC_APBPeriph_TIM7,
 *          RCC_APBPeriph_WWDG, RCC_APBPeriph_SPI2, RCC_APBPeriph_SPI3,
 *          RCC_APBPeriph_USART2, RCC_APBPeriph_USART3, RCC_APBPeriph_USART4,
 *          RCC_APBPeriph_USART5, RCC_APBPeriph_I2C1, RCC_APBPeriph_I2C2,
 *          RCC_APBPeriph_USB, RCC_APBPeriph_CAN1, RCC_APBPeriph_BKP,
 *          RCC_APBPeriph_PWR, RCC_APBPeriph_DAC, RCC_APBPeriph_CEC,
 *          RCC_APBPeriph_TIM12, RCC_APBPeriph_TIM13, RCC_APBPeriph_TIM14
 * @param  NewState: new state of the specified peripheral clock.
 *   This parameter can be: ENABLE or DISABLE.
 * @retval None
 */
void RCC_APBPeriphResetCmd(uint32_t RCC_APBPeriph, FunctionalState NewState)
{
    /* Check the parameters */
    assert_param(IS_RCC_APB_PERIPH(RCC_APBPeriph));
    assert_param(IS_FUNCTIONAL_STATE(NewState));
    if (NewState != DISABLE)
    {
        RCC->APBRSTR |= RCC_APBPeriph;
    }
    else
    {
        RCC->APBRSTR &= ~RCC_APBPeriph;
    }
}

/**
 * @brief  Checks whether the specified RCC flag is set or not.
 * @param  RCC_FLAG: specifies the flag to check.
 *
 *   For @b STM32_Connectivity_line_devices, this parameter can be one of the
 *   following values:
 *     @arg RCC_FLAG_HSIRDY: HSI oscillator clock ready
 *     @arg RCC_FLAG_HSERDY: HSE oscillator clock ready
 *     @arg RCC_FLAG_PLLRDY: PLL clock ready
 *     @arg RCC_FLAG_PLL2RDY: PLL2 clock ready
 *     @arg RCC_FLAG_PLL3RDY: PLL3 clock ready
 *     @arg RCC_FLAG_LSERDY: LSE oscillator clock ready
 *     @arg RCC_FLAG_LSIRDY: LSI oscillator clock ready
 *     @arg RCC_FLAG_PINRST: Pin reset
 *     @arg RCC_FLAG_PORRST: POR/PDR reset
 *     @arg RCC_FLAG_SFTRST: Software reset
 *     @arg RCC_FLAG_IWDGRST: Independent Watchdog reset
 *     @arg RCC_FLAG_WWDGRST: Window Watchdog reset
 *     @arg RCC_FLAG_LPWRRST: Low Power reset
 *
 *   For @b other_STM32_devices, this parameter can be one of the following values:
 *     @arg RCC_FLAG_HSIRDY: HSI oscillator clock ready
 *     @arg RCC_FLAG_HSERDY: HSE oscillator clock ready
 *     @arg RCC_FLAG_PLLRDY: PLL clock ready
 *     @arg RCC_FLAG_LSERDY: LSE oscillator clock ready
 *     @arg RCC_FLAG_LSIRDY: LSI oscillator clock ready
 *     @arg RCC_FLAG_PINRST: Pin reset
 *     @arg RCC_FLAG_PORRST: POR/PDR reset
 *     @arg RCC_FLAG_SFTRST: Software reset
 *     @arg RCC_FLAG_IWDGRST: Independent Watchdog reset
 *     @arg RCC_FLAG_WWDGRST: Window Watchdog reset
 *     @arg RCC_FLAG_LPWRRST: Low Power reset
 *
 * @retval The new state of RCC_FLAG (SET or RESET).
 */
FlagStatus RCC_GetFlagStatus(uint8_t RCC_FLAG)
{
    uint32_t tmp = 0;
    uint32_t statusreg = 0;
    FlagStatus bitstatus = RESET;
    /* Check the parameters */
    assert_param(IS_RCC_FLAG(RCC_FLAG));

    /* Get the RCC register index */
    tmp = RCC_FLAG >> 5;
    if (tmp == 1) /* The flag to check is in CR register */
    {
        statusreg = RCC->CR;
    }
    else if (tmp == 2) /* The flag to check is in BDCR register */
    {
        statusreg = RCC->BDCR;
    }
    else /* The flag to check is in CSR register */
    {
        statusreg = RCC->CSR;
    }

    /* Get the flag position */
    tmp = RCC_FLAG & FLAG_Mask;
    if ((statusreg & ((uint32_t)1 << tmp)) != (uint32_t)RESET)
    {
        bitstatus = SET;
    }
    else
    {
        bitstatus = RESET;
    }

    /* Return the flag status */
    return bitstatus;
}

/**
 * @brief  Clears the RCC reset flags.
 * @note   The reset flags are: RCC_FLAG_PINRST, RCC_FLAG_PORRST, RCC_FLAG_SFTRST,
 *   RCC_FLAG_IWDGRST, RCC_FLAG_WWDGRST, RCC_FLAG_LPWRRST
 * @param  None
 * @retval None
 */
void RCC_ClearFlag(void)
{
    /* Set RMVF bit to clear the reset flags */
    RCC->CSR |= CSR_RMVF_Set;
}

#endif /* CYBER_RCC */
