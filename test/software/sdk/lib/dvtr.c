
/* Includes ------------------------------------------------------------------*/
#include "dvtr.h"
#ifdef CYBER_DVTR

/** @addtogroup STM32F4xx_StdPeriph_Driver
  * @{
  */

/** @defgroup DVTR
  * @brief DVTR driver modules
  * @{
  */

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/** @defgroup DVTR_Private_Functions
  * @{
  */

/** @defgroup DVTR_Group1 Initialization and Configuration functions
 *  @brief   Initialization and Configuration functions
 *
@verbatim
 ===============================================================================
              ##### Initialization and Configuration functions #####
 ===============================================================================

@endverbatim
  * @{
  */

/**
  * @brief  Deinitializes the DVTR registers to their default reset values.
  * @param  None
  * @retval None
  */
void DVTR_DeInit(void)
{
  DVTR->CR = 0x0;
  DVTR->IER = 0x0;
  DVTR->ICR = 0x1F;
  DVTR->ESCR = 0x0;
  DVTR->ESUR = 0x0;
  DVTR->CWSTRTR = 0x0;
  DVTR->CWSIZER = 0x0;
}

/**
  * @brief  Initializes the DVTR according to the specified parameters in the DVTR_InitStruct.
  * @param  DVTR_InitStruct: pointer to a DVTR_InitTypeDef structure that contains
  *         the configuration information for the DVTR.
  * @retval None
  */
void DVTR_Init(DVTR_InitTypeDef* DVTR_InitStruct)
{
  uint32_t temp = 0x0;

  /* Check the parameters */
  assert_param(IS_DVTR_CAPTURE_MODE(DVTR_InitStruct->DVTR_CaptureMode));
  assert_param(IS_DVTR_SYNCHRO(DVTR_InitStruct->DVTR_SynchroMode));
  assert_param(IS_DVTR_PCKPOLARITY(DVTR_InitStruct->DVTR_PCKPolarity));
  assert_param(IS_DVTR_VSPOLARITY(DVTR_InitStruct->DVTR_VSPolarity));
  assert_param(IS_DVTR_HSPOLARITY(DVTR_InitStruct->DVTR_HSPolarity));
  assert_param(IS_DVTR_CAPTURE_RATE(DVTR_InitStruct->DVTR_CaptureRate));
  assert_param(IS_DVTR_EXTENDED_DATA(DVTR_InitStruct->DVTR_ExtendedDataMode));

  /* The DVTR configuration registers should be programmed correctly before
  enabling the CR_ENABLE Bit and the CR_CAPTURE Bit */
  DVTR->CR &= ~(DVTR_CR_ENABLE | DVTR_CR_CAPTURE);

  /* Reset the old DVTR configuration */
  temp = DVTR->CR;

  temp &= ~((uint32_t)DVTR_CR_CM     | DVTR_CR_ESS   | DVTR_CR_PCKPOL |
                      DVTR_CR_HSPOL  | DVTR_CR_VSPOL | DVTR_CR_FCRC_0 |
                      DVTR_CR_FCRC_1 | DVTR_CR_EDM_0 | DVTR_CR_EDM_1);

  /* Sets the new configuration of the DVTR peripheral */
  temp |= ((uint32_t)DVTR_InitStruct->DVTR_CaptureMode |
                     DVTR_InitStruct->DVTR_SynchroMode |
                     DVTR_InitStruct->DVTR_PCKPolarity |
                     DVTR_InitStruct->DVTR_VSPolarity |
                     DVTR_InitStruct->DVTR_HSPolarity |
                     DVTR_InitStruct->DVTR_CaptureRate |
                     DVTR_InitStruct->DVTR_ExtendedDataMode);

  DVTR->CR = temp;
}

/**
  * @brief  Fills each DVTR_InitStruct member with its default value.
  * @param  DVTR_InitStruct : pointer to a DVTR_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */
void DVTR_StructInit(DVTR_InitTypeDef* DVTR_InitStruct)
{
  /* Set the default configuration */
  DVTR_InitStruct->DVTR_CaptureMode = DVTR_CaptureMode_Continuous;
  DVTR_InitStruct->DVTR_SynchroMode = DVTR_SynchroMode_Hardware;
  DVTR_InitStruct->DVTR_PCKPolarity = DVTR_PCKPolarity_Falling;
  DVTR_InitStruct->DVTR_VSPolarity = DVTR_VSPolarity_Low;
  DVTR_InitStruct->DVTR_HSPolarity = DVTR_HSPolarity_Low;
  DVTR_InitStruct->DVTR_CaptureRate = DVTR_CaptureRate_All_Frame;
  DVTR_InitStruct->DVTR_ExtendedDataMode = DVTR_ExtendedDataMode_8b;
}

/**
  * @brief  Initializes the DVTR peripheral CROP mode according to the specified
  *         parameters in the DVTR_CROPInitStruct.
  * @note   This function should be called before to enable and start the DVTR interface.
  * @param  DVTR_CROPInitStruct:  pointer to a DVTR_CROPInitTypeDef structure that
  *         contains the configuration information for the DVTR peripheral CROP mode.
  * @retval None
  */
void DVTR_CROPConfig(DVTR_CROPInitTypeDef* DVTR_CROPInitStruct)
{
  /* Sets the CROP window coordinates */
  DVTR->CWSTRTR = (uint32_t)((uint32_t)DVTR_CROPInitStruct->DVTR_HorizontalOffsetCount |
                  ((uint32_t)DVTR_CROPInitStruct->DVTR_VerticalStartLine << 16));

  /* Sets the CROP window size */
  DVTR->CWSIZER = (uint32_t)(DVTR_CROPInitStruct->DVTR_CaptureCount |
                  ((uint32_t)DVTR_CROPInitStruct->DVTR_VerticalLineCount << 16));
}

/**
  * @brief  Enables or disables the DVTR Crop feature.
  * @note   This function should be called before to enable and start the DVTR interface.
  * @param  NewState: new state of the DVTR Crop feature.
  *          This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTR_CROPCmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable the DVTR Crop feature */
    DVTR->CR |= (uint32_t)DVTR_CR_CROP;
  }
  else
  {
    /* Disable the DVTR Crop feature */
    DVTR->CR &= ~(uint32_t)DVTR_CR_CROP;
  }
}

/**
  * @brief  Sets the embedded synchronization codes
  * @param  DVTR_CodesInitTypeDef: pointer to a DVTR_CodesInitTypeDef structure that
  *         contains the embedded synchronization codes for the DVTR peripheral.
  * @retval None
  */
void DVTR_SetEmbeddedSynchroCodes(DVTR_CodesInitTypeDef* DVTR_CodesInitStruct)
{
  DVTR->ESCR = (uint32_t)(DVTR_CodesInitStruct->DVTR_FrameStartCode |
                          ((uint32_t)DVTR_CodesInitStruct->DVTR_LineStartCode << 8)|
                          ((uint32_t)DVTR_CodesInitStruct->DVTR_LineEndCode << 16)|
                          ((uint32_t)DVTR_CodesInitStruct->DVTR_FrameEndCode << 24));
}

/**
  * @brief  Enables or disables the DVTR JPEG format.
  * @note   The Crop and Embedded Synchronization features cannot be used in this mode.
  * @param  NewState: new state of the DVTR JPEG format.
  *          This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTR_JPEGCmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable the DVTR JPEG format */
    DVTR->CR |= (uint32_t)DVTR_CR_JPEG;
  }
  else
  {
    /* Disable the DVTR JPEG format */
    DVTR->CR &= ~(uint32_t)DVTR_CR_JPEG;
  }
}
/**
  * @}
  */

/** @defgroup DVTR_Group2 Image capture functions
 *  @brief   Image capture functions
 *
@verbatim
 ===============================================================================
                    ##### Image capture functions #####
 ===============================================================================

@endverbatim
  * @{
  */

/**
  * @brief  Enables or disables the DVTR interface.
  * @param  NewState: new state of the DVTR interface.
  *          This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTR_Cmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable the DVTR by setting ENABLE bit */
    DVTR->CR |= (uint32_t)DVTR_CR_ENABLE;
  }
  else
  {
    /* Disable the DVTR by clearing ENABLE bit */
    DVTR->CR &= ~(uint32_t)DVTR_CR_ENABLE;
  }
}

/**
  * @brief  Enables or disables the DVTR Capture.
  * @param  NewState: new state of the DVTR capture.
  *          This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTR_CaptureCmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable the DVTR Capture */
    DVTR->CR |= (uint32_t)DVTR_CR_CAPTURE;
  }
  else
  {
    /* Disable the DVTR Capture */
    DVTR->CR &= ~(uint32_t)DVTR_CR_CAPTURE;
  }
}

/**
  * @brief  Reads the data stored in the DR register.
  * @param  None
  * @retval Data register value
  */
uint32_t DVTR_ReadData(void)
{
  return DVTR->DR;
}
/**
  * @}
  */

/** @defgroup DVTR_Group3 Interrupts and flags management functions
 *  @brief   Interrupts and flags management functions
 *
@verbatim
 ===============================================================================
             ##### Interrupts and flags management functions #####
 ===============================================================================

@endverbatim
  * @{
  */

/**
  * @brief  Enables or disables the DVTR interface interrupts.
  * @param  DVTR_IT: specifies the DVTR interrupt sources to be enabled or disabled.
  *          This parameter can be any combination of the following values:
  *            @arg DVTR_IT_FRAME: Frame capture complete interrupt mask
  *            @arg DVTR_IT_OVF: Overflow interrupt mask
  *            @arg DVTR_IT_ERR: Synchronization error interrupt mask
  *            @arg DVTR_IT_VSYNC: VSYNC interrupt mask
  *            @arg DVTR_IT_LINE: Line interrupt mask
  * @param  NewState: new state of the specified DVTR interrupts.
  *          This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTR_ITConfig(uint16_t DVTR_IT, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_DVTR_CONFIG_IT(DVTR_IT));
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable the Interrupt sources */
    DVTR->IER |= DVTR_IT;
  }
  else
  {
    /* Disable the Interrupt sources */
    DVTR->IER &= (uint16_t)(~DVTR_IT);
  }
}

/**
  * @brief  Checks whether the  DVTR interface flag is set or not.
  * @param  DVTR_FLAG: specifies the flag to check.
  *          This parameter can be one of the following values:
  *            @arg DVTR_FLAG_FRAMERI: Frame capture complete Raw flag mask
  *            @arg DVTR_FLAG_OVFRI: Overflow Raw flag mask
  *            @arg DVTR_FLAG_ERRRI: Synchronization error Raw flag mask
  *            @arg DVTR_FLAG_VSYNCRI: VSYNC Raw flag mask
  *            @arg DVTR_FLAG_LINERI: Line Raw flag mask
  *            @arg DVTR_FLAG_FRAMEMI: Frame capture complete Masked flag mask
  *            @arg DVTR_FLAG_OVFMI: Overflow Masked flag mask
  *            @arg DVTR_FLAG_ERRMI: Synchronization error Masked flag mask
  *            @arg DVTR_FLAG_VSYNCMI: VSYNC Masked flag mask
  *            @arg DVTR_FLAG_LINEMI: Line Masked flag mask
  *            @arg DVTR_FLAG_HSYNC: HSYNC flag mask
  *            @arg DVTR_FLAG_VSYNC: VSYNC flag mask
  *            @arg DVTR_FLAG_FNE: Fifo not empty flag mask
  * @retval The new state of DVTR_FLAG (SET or RESET).
  */
FlagStatus DVTR_GetFlagStatus(uint16_t DVTR_FLAG)
{
  FlagStatus bitstatus = RESET;
  uint32_t dvtrreg, tempreg = 0;

  /* Check the parameters */
  assert_param(IS_DVTR_GET_FLAG(DVTR_FLAG));

  /* Get the DVTR register index */
  dvtrreg = (((uint16_t)DVTR_FLAG) >> 12);

  if (dvtrreg == 0x00) /* The FLAG is in RISR register */
  {
    tempreg= DVTR->RISR;
  }
  else if (dvtrreg == 0x02) /* The FLAG is in SR register */
  {
    tempreg = DVTR->SR;
  }
  else /* The FLAG is in MISR register */
  {
    tempreg = DVTR->MISR;
  }

  if ((tempreg & DVTR_FLAG) != (uint16_t)RESET )
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }
  /* Return the DVTR_FLAG status */
  return  bitstatus;
}

/**
  * @brief  Clears the DVTR's pending flags.
  * @param  DVTR_FLAG: specifies the flag to clear.
  *          This parameter can be any combination of the following values:
  *            @arg DVTR_FLAG_FRAMERI: Frame capture complete Raw flag mask
  *            @arg DVTR_FLAG_OVFRI: Overflow Raw flag mask
  *            @arg DVTR_FLAG_ERRRI: Synchronization error Raw flag mask
  *            @arg DVTR_FLAG_VSYNCRI: VSYNC Raw flag mask
  *            @arg DVTR_FLAG_LINERI: Line Raw flag mask
  * @retval None
  */
void DVTR_ClearFlag(uint16_t DVTR_FLAG)
{
  /* Check the parameters */
  assert_param(IS_DVTR_CLEAR_FLAG(DVTR_FLAG));

  /* Clear the flag by writing in the ICR register 1 in the corresponding
  Flag position*/

  DVTR->ICR = DVTR_FLAG;
}

/**
  * @brief  Checks whether the DVTR interrupt has occurred or not.
  * @param  DVTR_IT: specifies the DVTR interrupt source to check.
  *          This parameter can be one of the following values:
  *            @arg DVTR_IT_FRAME: Frame capture complete interrupt mask
  *            @arg DVTR_IT_OVF: Overflow interrupt mask
  *            @arg DVTR_IT_ERR: Synchronization error interrupt mask
  *            @arg DVTR_IT_VSYNC: VSYNC interrupt mask
  *            @arg DVTR_IT_LINE: Line interrupt mask
  * @retval The new state of DVTR_IT (SET or RESET).
  */
ITStatus DVTR_GetITStatus(uint16_t DVTR_IT)
{
  ITStatus bitstatus = RESET;
  uint32_t itstatus = 0;

  /* Check the parameters */
  assert_param(IS_DVTR_GET_IT(DVTR_IT));

  itstatus = DVTR->MISR & DVTR_IT; /* Only masked interrupts are checked */

  if ((itstatus != (uint16_t)RESET))
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }
  return bitstatus;
}

/**
  * @brief  Clears the DVTR's interrupt pending bits.
  * @param  DVTR_IT: specifies the DVTR interrupt pending bit to clear.
  *          This parameter can be any combination of the following values:
  *            @arg DVTR_IT_FRAME: Frame capture complete interrupt mask
  *            @arg DVTR_IT_OVF: Overflow interrupt mask
  *            @arg DVTR_IT_ERR: Synchronization error interrupt mask
  *            @arg DVTR_IT_VSYNC: VSYNC interrupt mask
  *            @arg DVTR_IT_LINE: Line interrupt mask
  * @retval None
  */
void DVTR_ClearITPendingBit(uint16_t DVTR_IT)
{
  /* Clear the interrupt pending Bit by writing in the ICR register 1 in the
  corresponding pending Bit position*/

  DVTR->ICR = DVTR_IT;
}

#endif /* CYBER_DVTR */

/******************* END OF FILE *******************/
