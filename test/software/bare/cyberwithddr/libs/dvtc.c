
/* Includes ------------------------------------------------------------------*/
#include "dvtc.h"
#ifdef CYBER_DVTC

/** @defgroup DVTC 
  * @brief DVTC driver modules
  * @{
  */

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

#define GCR_MASK                     ((uint32_t)0x0FFE888F)  /* DVTC GCR Mask */


/** @defgroup DVTC_Private_Functions
  * @{
  */

/** @defgroup DVTC_Group1 Initialization and Configuration functions
 *  @brief   Initialization and Configuration functions 
 *
@verbatim
 ===============================================================================
            ##### Initialization and Configuration functions #####
 ===============================================================================
    [..]  This section provides functions allowing to:
      (+) Initialize and configure the DVTC
      (+) Enable or Disable Dither
      (+) Define the position of the line interrupt
      (+) reload layers registers with new parameters
      (+) Initialize and configure layer1 and layer2
      (+) Set and configure the color keying functionality
      (+) Configure and Enables or disables CLUT 
      
@endverbatim
  * @{
  */

/**
  * @brief  Deinitializes the DVTC peripheral registers to their default reset
  *         values.
  * @param  None
  * @retval None
  */

void DVTC_DeInit(void)
{

}

/**
  * @brief  Initializes the DVTC peripheral according to the specified parameters
  *         in the DVTC_InitStruct.
  * @note   This function can be used only when the DVTC is disabled.
  * @param  DVTC_InitStruct: pointer to a DVTC_InitTypeDef structure that contains
  *         the configuration information for the specified DVTC peripheral.
  * @retval None
  */

void DVTC_Init(DVTC_InitTypeDef* DVTC_InitStruct)
{
  uint32_t horizontalsync = 0;
  uint32_t accumulatedHBP = 0;
  uint32_t accumulatedactiveW = 0;
  uint32_t totalwidth = 0;
  uint32_t backgreen = 0;
  uint32_t backred = 0;

  /* Check function parameters */
  assert_param(IS_DVTC_HSYNC(DVTC_InitStruct->DVTC_HorizontalSync));
  assert_param(IS_DVTC_VSYNC(DVTC_InitStruct->DVTC_VerticalSync));
  assert_param(IS_DVTC_AHBP(DVTC_InitStruct->DVTC_AccumulatedHBP));
  assert_param(IS_DVTC_AVBP(DVTC_InitStruct->DVTC_AccumulatedVBP));
  assert_param(IS_DVTC_AAH(DVTC_InitStruct->DVTC_AccumulatedActiveH));
  assert_param(IS_DVTC_AAW(DVTC_InitStruct->DVTC_AccumulatedActiveW));
  assert_param(IS_DVTC_TOTALH(DVTC_InitStruct->DVTC_TotalHeigh));
  assert_param(IS_DVTC_TOTALW(DVTC_InitStruct->DVTC_TotalWidth));
  assert_param(IS_DVTC_HSPOL(DVTC_InitStruct->DVTC_HSPolarity));
  assert_param(IS_DVTC_VSPOL(DVTC_InitStruct->DVTC_VSPolarity));
  assert_param(IS_DVTC_DEPOL(DVTC_InitStruct->DVTC_DEPolarity));
  assert_param(IS_DVTC_PCPOL(DVTC_InitStruct->DVTC_PCPolarity));
  assert_param(IS_DVTC_BackBlueValue(DVTC_InitStruct->DVTC_BackgroundBlueValue));
  assert_param(IS_DVTC_BackGreenValue(DVTC_InitStruct->DVTC_BackgroundGreenValue));
  assert_param(IS_DVTC_BackRedValue(DVTC_InitStruct->DVTC_BackgroundRedValue));

  /* Sets Synchronization size */
  DVTC->SSCR &= ~(DVTC_SSCR_VSH | DVTC_SSCR_HSW);
  horizontalsync = (DVTC_InitStruct->DVTC_HorizontalSync << 16);
  DVTC->SSCR |= (horizontalsync | DVTC_InitStruct->DVTC_VerticalSync);

  /* Sets Accumulated Back porch */
  DVTC->BPCR &= ~(DVTC_BPCR_AVBP | DVTC_BPCR_AHBP);
  accumulatedHBP = (DVTC_InitStruct->DVTC_AccumulatedHBP << 16);
  DVTC->BPCR |= (accumulatedHBP | DVTC_InitStruct->DVTC_AccumulatedVBP);

  /* Sets Accumulated Active Width */
  DVTC->AWCR &= ~(DVTC_AWCR_AAH | DVTC_AWCR_AAW);
  accumulatedactiveW = (DVTC_InitStruct->DVTC_AccumulatedActiveW << 16);
  DVTC->AWCR |= (accumulatedactiveW | DVTC_InitStruct->DVTC_AccumulatedActiveH);

  /* Sets Total Width */
  DVTC->TWCR &= ~(DVTC_TWCR_TOTALH | DVTC_TWCR_TOTALW);
  totalwidth = (DVTC_InitStruct->DVTC_TotalWidth << 16);
  DVTC->TWCR |= (totalwidth | DVTC_InitStruct->DVTC_TotalHeigh);

  DVTC->GCR &= (uint32_t)GCR_MASK;
  DVTC->GCR |=  (uint32_t)(DVTC_InitStruct->DVTC_HSPolarity | DVTC_InitStruct->DVTC_VSPolarity | \
                           DVTC_InitStruct->DVTC_DEPolarity | DVTC_InitStruct->DVTC_PCPolarity);

  /* sets the background color value */
  backgreen = (DVTC_InitStruct->DVTC_BackgroundGreenValue << 8);
  backred = (DVTC_InitStruct->DVTC_BackgroundRedValue << 16);

  DVTC->BCCR &= ~(DVTC_BCCR_BCBLUE | DVTC_BCCR_BCGREEN | DVTC_BCCR_BCRED);
  DVTC->BCCR |= (backred | backgreen | DVTC_InitStruct->DVTC_BackgroundBlueValue);
}

/**
  * @brief  Fills each DVTC_InitStruct member with its default value.
  * @param  DVTC_InitStruct: pointer to a DVTC_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTC_StructInit(DVTC_InitTypeDef* DVTC_InitStruct)
{
  /*--------------- Reset DVTC init structure parameters values ----------------*/
  DVTC_InitStruct->DVTC_HSPolarity = DVTC_HSPolarity_AL;      /*!< Initialize the DVTC_HSPolarity member */ 
  DVTC_InitStruct->DVTC_VSPolarity = DVTC_VSPolarity_AL;      /*!< Initialize the DVTC_VSPolarity member */
  DVTC_InitStruct->DVTC_DEPolarity = DVTC_DEPolarity_AL;      /*!< Initialize the DVTC_DEPolarity member */
  DVTC_InitStruct->DVTC_PCPolarity = DVTC_PCPolarity_IPC;     /*!< Initialize the DVTC_PCPolarity member */
  DVTC_InitStruct->DVTC_HorizontalSync = 0x00;                /*!< Initialize the DVTC_HorizontalSync member */
  DVTC_InitStruct->DVTC_VerticalSync = 0x00;                  /*!< Initialize the DVTC_VerticalSync member */
  DVTC_InitStruct->DVTC_AccumulatedHBP = 0x00;                /*!< Initialize the DVTC_AccumulatedHBP member */
  DVTC_InitStruct->DVTC_AccumulatedVBP = 0x00;                /*!< Initialize the DVTC_AccumulatedVBP member */
  DVTC_InitStruct->DVTC_AccumulatedActiveW = 0x00;            /*!< Initialize the DVTC_AccumulatedActiveW member */
  DVTC_InitStruct->DVTC_AccumulatedActiveH = 0x00;            /*!< Initialize the DVTC_AccumulatedActiveH member */
  DVTC_InitStruct->DVTC_TotalWidth = 0x00;                    /*!< Initialize the DVTC_TotalWidth member */
  DVTC_InitStruct->DVTC_TotalHeigh = 0x00;                    /*!< Initialize the DVTC_TotalHeigh member */
  DVTC_InitStruct->DVTC_BackgroundRedValue = 0x00;            /*!< Initialize the DVTC_BackgroundRedValue member */
  DVTC_InitStruct->DVTC_BackgroundGreenValue = 0x00;          /*!< Initialize the DVTC_BackgroundGreenValue member */
  DVTC_InitStruct->DVTC_BackgroundBlueValue = 0x00;           /*!< Initialize the DVTC_BackgroundBlueValue member */
}

/**
  * @brief  Enables or disables the DVTC Controller.
  * @param  NewState: new state of the DVTC peripheral.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTC_Cmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable DVTC by setting DVTCEN bit */
    DVTC->GCR |= (uint32_t)DVTC_GCR_DVTCEN;
  }
  else
  {
    /* Disable DVTC by clearing DVTCEN bit */
    DVTC->GCR &= ~(uint32_t)DVTC_GCR_DVTCEN;
  }
}

/**
  * @brief  Enables or disables Dither.
  * @param  NewState: new state of the Dither.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTC_DitherCmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable Dither by setting DTEN bit */
    DVTC->GCR |= (uint32_t)DVTC_GCR_DTEN;
  }
  else
  {
    /* Disable Dither by clearing DTEN bit */
    DVTC->GCR &= ~(uint32_t)DVTC_GCR_DTEN;
  }
}

/**
  * @brief  Get the dither RGB width.
  * @param  DVTC_RGB_InitStruct: pointer to a DVTC_RGBTypeDef structure that contains
  *         the Dither RGB width.
  * @retval None
  */

DVTC_RGBTypeDef DVTC_GetRGBWidth(void)
{
  DVTC_RGBTypeDef DVTC_RGB_InitStruct;

  DVTC->GCR &= (uint32_t)GCR_MASK;

  DVTC_RGB_InitStruct.DVTC_BlueWidth = (uint32_t)((DVTC->GCR >> 4) & 0x7);
  DVTC_RGB_InitStruct.DVTC_GreenWidth = (uint32_t)((DVTC->GCR >> 8) & 0x7);
  DVTC_RGB_InitStruct.DVTC_RedWidth = (uint32_t)((DVTC->GCR >> 12) & 0x7);

  return DVTC_RGB_InitStruct;
}

/**
  * @brief  Fills each DVTC_RGBStruct member with its default value.
  * @param  DVTC_RGB_InitStruct: pointer to a DVTC_RGBTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTC_RGBStructInit(DVTC_RGBTypeDef* DVTC_RGB_InitStruct)
{
  DVTC_RGB_InitStruct->DVTC_BlueWidth = 0x02;
  DVTC_RGB_InitStruct->DVTC_GreenWidth = 0x02;
  DVTC_RGB_InitStruct->DVTC_RedWidth = 0x02;
}


/**
  * @brief  Define the position of the line interrupt .
  * @param  DVTC_LIPositionConfig: Line Interrupt Position.
  * @retval None
  */

void DVTC_LIPConfig(uint32_t DVTC_LIPositionConfig)
{
  /* Check the parameters */
  assert_param(IS_DVTC_LIPOS(DVTC_LIPositionConfig));

  /* Sets the Line Interrupt position */
  DVTC->LIPCR = (uint32_t)DVTC_LIPositionConfig;
}

/**
  * @brief  reload layers registers with new parameters 
  * @param  DVTC_Reload: specifies the type of reload.
  *   This parameter can be one of the following values:
  *     @arg DVTC_IMReload: Vertical blanking reload.
  *     @arg DVTC_VBReload: Immediate reload.  
  * @retval None
  */

void DVTC_ReloadConfig(uint32_t DVTC_Reload)
{
  /* Check the parameters */
  assert_param(IS_DVTC_RELOAD(DVTC_Reload));

  /* Sets the Reload type */
  DVTC->SRCR = (uint32_t)DVTC_Reload;
}


/**
  * @brief  Initializes the DVTC Layer according to the specified parameters
  *         in the DVTC_LayerStruct.
  * @note   This function can be used only when the DVTC is disabled.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2    
  * @param  DVTC_LayerStruct: pointer to a DVTC_LayerTypeDef structure that contains
  *         the configuration information for the specified DVTC peripheral.
  * @retval None
  */

void DVTC_LayerInit(DVTC_Layer_TypeDef* DVTC_Layerx, DVTC_Layer_InitTypeDef* DVTC_Layer_InitStruct)
{

  uint32_t whsppos = 0;
  uint32_t wvsppos = 0;
  uint32_t dcgreen = 0;
  uint32_t dcred = 0;
  uint32_t dcalpha = 0;
  uint32_t cfbp = 0;

/* Check the parameters */
  assert_param(IS_DVTC_Pixelformat(DVTC_Layer_InitStruct->DVTC_PixelFormat));
  assert_param(IS_DVTC_BlendingFactor1(DVTC_Layer_InitStruct->DVTC_BlendingFactor_1));
  assert_param(IS_DVTC_BlendingFactor2(DVTC_Layer_InitStruct->DVTC_BlendingFactor_2));
  assert_param(IS_DVTC_HCONFIGST(DVTC_Layer_InitStruct->DVTC_HorizontalStart));
  assert_param(IS_DVTC_HCONFIGSP(DVTC_Layer_InitStruct->DVTC_HorizontalStop));
  assert_param(IS_DVTC_VCONFIGST(DVTC_Layer_InitStruct->DVTC_VerticalStart));
  assert_param(IS_DVTC_VCONFIGSP(DVTC_Layer_InitStruct->DVTC_VerticalStop));  
  assert_param(IS_DVTC_DEFAULTCOLOR(DVTC_Layer_InitStruct->DVTC_DefaultColorBlue));
  assert_param(IS_DVTC_DEFAULTCOLOR(DVTC_Layer_InitStruct->DVTC_DefaultColorGreen));
  assert_param(IS_DVTC_DEFAULTCOLOR(DVTC_Layer_InitStruct->DVTC_DefaultColorRed));
  assert_param(IS_DVTC_DEFAULTCOLOR(DVTC_Layer_InitStruct->DVTC_DefaultColorAlpha));
  assert_param(IS_DVTC_CFBP(DVTC_Layer_InitStruct->DVTC_CFBPitch));
  assert_param(IS_DVTC_CFBLL(DVTC_Layer_InitStruct->DVTC_CFBLineLength));
  assert_param(IS_DVTC_CFBLNBR(DVTC_Layer_InitStruct->DVTC_CFBLineNumber));

  /* Configures the horizontal start and stop position */
  whsppos = DVTC_Layer_InitStruct->DVTC_HorizontalStop << 16;
  DVTC_Layerx->WHPCR &= ~(DVTC_LxWHPCR_WHSTPOS | DVTC_LxWHPCR_WHSPPOS);
  DVTC_Layerx->WHPCR = (DVTC_Layer_InitStruct->DVTC_HorizontalStart | whsppos);

  /* Configures the vertical start and stop position */
  wvsppos = DVTC_Layer_InitStruct->DVTC_VerticalStop << 16;
  DVTC_Layerx->WVPCR &= ~(DVTC_LxWVPCR_WVSTPOS | DVTC_LxWVPCR_WVSPPOS);
  DVTC_Layerx->WVPCR  = (DVTC_Layer_InitStruct->DVTC_VerticalStart | wvsppos);

  /* Specifies the pixel format */
  DVTC_Layerx->PFCR &= ~(DVTC_LxPFCR_PF);
  DVTC_Layerx->PFCR = (DVTC_Layer_InitStruct->DVTC_PixelFormat);

  /* Configures the default color values */
  dcgreen = (DVTC_Layer_InitStruct->DVTC_DefaultColorGreen << 8);
  dcred = (DVTC_Layer_InitStruct->DVTC_DefaultColorRed << 16);
  dcalpha = (DVTC_Layer_InitStruct->DVTC_DefaultColorAlpha << 24);
  DVTC_Layerx->DCCR &=  ~(DVTC_LxDCCR_DCBLUE | DVTC_LxDCCR_DCGREEN | DVTC_LxDCCR_DCRED | DVTC_LxDCCR_DCALPHA);
  DVTC_Layerx->DCCR = (DVTC_Layer_InitStruct->DVTC_DefaultColorBlue | dcgreen | \
                        dcred | dcalpha);

  /* Specifies the constant alpha value */      
  DVTC_Layerx->CACR &= ~(DVTC_LxCACR_CONSTA);
  DVTC_Layerx->CACR = (DVTC_Layer_InitStruct->DVTC_ConstantAlpha);

  /* Specifies the blending factors */
  DVTC_Layerx->BFCR &= ~(DVTC_LxBFCR_BF2 | DVTC_LxBFCR_BF1);
  DVTC_Layerx->BFCR = (DVTC_Layer_InitStruct->DVTC_BlendingFactor_1 | DVTC_Layer_InitStruct->DVTC_BlendingFactor_2);

  /* Configures the color frame buffer start address */
  DVTC_Layerx->CFBAR &= ~(DVTC_LxCFBAR_CFBADD);
  DVTC_Layerx->CFBAR = (DVTC_Layer_InitStruct->DVTC_CFBStartAdress);

  /* Configures the color frame buffer pitch in byte */
  cfbp = (DVTC_Layer_InitStruct->DVTC_CFBPitch << 16);
  DVTC_Layerx->CFBLR  &= ~(DVTC_LxCFBLR_CFBLL | DVTC_LxCFBLR_CFBP);
  DVTC_Layerx->CFBLR  = (DVTC_Layer_InitStruct->DVTC_CFBLineLength | cfbp);

  /* Configures the frame buffer line number */
  DVTC_Layerx->CFBLNR  &= ~(DVTC_LxCFBLNR_CFBLNBR);
  DVTC_Layerx->CFBLNR  = (DVTC_Layer_InitStruct->DVTC_CFBLineNumber);
}

/**
  * @brief  Fills each DVTC_Layer_InitStruct member with its default value.
  * @param  DVTC_Layer_InitStruct: pointer to a DVTC_LayerTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTC_LayerStructInit(DVTC_Layer_InitTypeDef * DVTC_Layer_InitStruct)
{
  /*--------------- Reset Layer structure parameters values -------------------*/

  /*!< Initialize the horizontal limit member */
  DVTC_Layer_InitStruct->DVTC_HorizontalStart = 0x00;
  DVTC_Layer_InitStruct->DVTC_HorizontalStop = 0x00;

  /*!< Initialize the vertical limit member */
  DVTC_Layer_InitStruct->DVTC_VerticalStart = 0x00;
  DVTC_Layer_InitStruct->DVTC_VerticalStop = 0x00;

  /*!< Initialize the pixel format member */
  DVTC_Layer_InitStruct->DVTC_PixelFormat = DVTC_Pixelformat_ARGB8888;

  /*!< Initialize the constant alpha value */
  DVTC_Layer_InitStruct->DVTC_ConstantAlpha = 0xFF;

  /*!< Initialize the default color values */
  DVTC_Layer_InitStruct->DVTC_DefaultColorBlue = 0x00;
  DVTC_Layer_InitStruct->DVTC_DefaultColorGreen = 0x00;
  DVTC_Layer_InitStruct->DVTC_DefaultColorRed = 0x00;
  DVTC_Layer_InitStruct->DVTC_DefaultColorAlpha = 0x00;

  /*!< Initialize the blending factors */
  DVTC_Layer_InitStruct->DVTC_BlendingFactor_1 = DVTC_BlendingFactor1_PAxCA;
  DVTC_Layer_InitStruct->DVTC_BlendingFactor_2 = DVTC_BlendingFactor2_PAxCA;

  /*!< Initialize the frame buffer start address */
  DVTC_Layer_InitStruct->DVTC_CFBStartAdress = 0x00;

  /*!< Initialize the frame buffer pitch and line length */
  DVTC_Layer_InitStruct->DVTC_CFBLineLength = 0x00;
  DVTC_Layer_InitStruct->DVTC_CFBPitch = 0x00;

  /*!< Initialize the frame buffer line number */
  DVTC_Layer_InitStruct->DVTC_CFBLineNumber = 0x00;
}


/**
  * @brief  Enables or disables the DVTC_Layer Controller.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2
  * @param  NewState: new state of the DVTC_Layer peripheral.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTC_LayerCmd(DVTC_Layer_TypeDef* DVTC_Layerx, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable DVTC_Layer by setting LEN bit */
    DVTC_Layerx->CR |= (uint32_t)DVTC_LxCR_LEN;
  }
  else
  {
    /* Disable DVTC_Layer by clearing LEN bit */
    DVTC_Layerx->CR &= ~(uint32_t)DVTC_LxCR_LEN;
  }
}


/**
  * @brief  Get the current position.
  * @param  DVTC_Pos_InitStruct: pointer to a DVTC_PosTypeDef structure that contains
  *         the current position.
  * @retval None
  */

DVTC_PosTypeDef DVTC_GetPosStatus(void)
{
  DVTC_PosTypeDef DVTC_Pos_InitStruct;

  DVTC->CPSR &= ~(DVTC_CPSR_CYPOS | DVTC_CPSR_CXPOS);

  DVTC_Pos_InitStruct.DVTC_POSX = (uint32_t)(DVTC->CPSR >> 16);
  DVTC_Pos_InitStruct.DVTC_POSY = (uint32_t)(DVTC->CPSR & 0xFFFF);

  return DVTC_Pos_InitStruct;
}

/**
  * @brief  Fills each DVTC_Pos_InitStruct member with its default value.
  * @param  DVTC_Pos_InitStruct: pointer to a DVTC_PosTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTC_PosStructInit(DVTC_PosTypeDef* DVTC_Pos_InitStruct)
{
  DVTC_Pos_InitStruct->DVTC_POSX = 0x00;
  DVTC_Pos_InitStruct->DVTC_POSY = 0x00;
}

/**
  * @brief  Checks whether the specified DVTC's flag is set or not.
  * @param  DVTC_CD: specifies the flag to check.
  *   This parameter can be one of the following values:
  *     @arg DVTC_CD_VDES: vertical data enable current status.
  *     @arg DVTC_CD_HDES: horizontal data enable current status.
  *     @arg DVTC_CD_VSYNC:  Vertical Synchronization current status.
  *     @arg DVTC_CD_HSYNC:  Horizontal Synchronization current status.
  * @retval The new state of DVTC_CD (SET or RESET).
  */

FlagStatus DVTC_GetCDStatus(uint32_t DVTC_CD)
{
  FlagStatus bitstatus;

  /* Check the parameters */
  assert_param(IS_DVTC_GET_CD(DVTC_CD));

  if ((DVTC->CDSR & DVTC_CD) != (uint32_t)RESET)
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
  * @brief  Set and configure the color keying.
  * @param  DVTC_colorkeying_InitStruct: pointer to a DVTC_ColorKeying_InitTypeDef 
  *         structure that contains the color keying configuration.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2   
  * @retval None
  */

void DVTC_ColorKeyingConfig(DVTC_Layer_TypeDef* DVTC_Layerx, DVTC_ColorKeying_InitTypeDef* DVTC_colorkeying_InitStruct, FunctionalState NewState)
{ 
  uint32_t ckgreen = 0;
  uint32_t ckred = 0;

  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));
  assert_param(IS_DVTC_CKEYING(DVTC_colorkeying_InitStruct->DVTC_ColorKeyBlue));
  assert_param(IS_DVTC_CKEYING(DVTC_colorkeying_InitStruct->DVTC_ColorKeyGreen));
  assert_param(IS_DVTC_CKEYING(DVTC_colorkeying_InitStruct->DVTC_ColorKeyRed));
  
  if (NewState != DISABLE)
  {
    /* Enable DVTC color keying by setting COLKEN bit */
    DVTC_Layerx->CR |= (uint32_t)DVTC_LxCR_COLKEN;
    
    /* Sets the color keying values */
    ckgreen = (DVTC_colorkeying_InitStruct->DVTC_ColorKeyGreen << 8);
    ckred = (DVTC_colorkeying_InitStruct->DVTC_ColorKeyRed << 16);
    DVTC_Layerx->CKCR  &= ~(DVTC_LxCKCR_CKBLUE | DVTC_LxCKCR_CKGREEN | DVTC_LxCKCR_CKRED);
    DVTC_Layerx->CKCR |= (DVTC_colorkeying_InitStruct->DVTC_ColorKeyBlue | ckgreen | ckred);
  }
  else
  {
    /* Disable DVTC color keying by clearing COLKEN bit */
    DVTC_Layerx->CR &= ~(uint32_t)DVTC_LxCR_COLKEN;
  }
  
  /* Reload shadow register */
  DVTC->SRCR = DVTC_IMReload;
}

/**
  * @brief  Fills each DVTC_colorkeying_InitStruct member with its default value.
  * @param  DVTC_colorkeying_InitStruct: pointer to a DVTC_ColorKeying_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTC_ColorKeyingStructInit(DVTC_ColorKeying_InitTypeDef* DVTC_colorkeying_InitStruct)
{
  /*!< Initialize the color keying values */
  DVTC_colorkeying_InitStruct->DVTC_ColorKeyBlue = 0x00;
  DVTC_colorkeying_InitStruct->DVTC_ColorKeyGreen = 0x00;
  DVTC_colorkeying_InitStruct->DVTC_ColorKeyRed = 0x00;
}


/**
  * @brief  Enables or disables CLUT.
  * @param  NewState: new state of CLUT.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2  
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTC_CLUTCmd(DVTC_Layer_TypeDef* DVTC_Layerx, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable CLUT by setting CLUTEN bit */
    DVTC_Layerx->CR |= (uint32_t)DVTC_LxCR_CLUTEN;
  }
  else
  {
    /* Disable CLUT by clearing CLUTEN bit */
    DVTC_Layerx->CR &= ~(uint32_t)DVTC_LxCR_CLUTEN;
  }
  
  /* Reload shadow register */
  DVTC->SRCR = DVTC_IMReload;
}

/**
  * @brief  configure the CLUT.
  * @param  DVTC_CLUT_InitStruct: pointer to a DVTC_CLUT_InitTypeDef structure that contains
  *         the CLUT configuration.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2   
  * @retval None
  */

void DVTC_CLUTInit(DVTC_Layer_TypeDef* DVTC_Layerx, DVTC_CLUT_InitTypeDef* DVTC_CLUT_InitStruct)
{  
  uint32_t green = 0;
  uint32_t red = 0;
  uint32_t clutadd = 0;

  /* Check the parameters */
  assert_param(IS_DVTC_CLUTWR(DVTC_CLUT_InitStruct->DVTC_CLUTAdress));
  assert_param(IS_DVTC_CLUTWR(DVTC_CLUT_InitStruct->DVTC_RedValue));
  assert_param(IS_DVTC_CLUTWR(DVTC_CLUT_InitStruct->DVTC_GreenValue));
  assert_param(IS_DVTC_CLUTWR(DVTC_CLUT_InitStruct->DVTC_BlueValue));
    
  /* Specifies the CLUT address and RGB value */
  green = (DVTC_CLUT_InitStruct->DVTC_GreenValue << 8);
  red = (DVTC_CLUT_InitStruct->DVTC_RedValue << 16);
  clutadd = (DVTC_CLUT_InitStruct->DVTC_CLUTAdress << 24);
  DVTC_Layerx->CLUTWR  = (clutadd | DVTC_CLUT_InitStruct->DVTC_BlueValue | \
                              green | red);
}

/**
  * @brief  Fills each DVTC_CLUT_InitStruct member with its default value.
  * @param  DVTC_CLUT_InitStruct: pointer to a DVTC_CLUT_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTC_CLUTStructInit(DVTC_CLUT_InitTypeDef* DVTC_CLUT_InitStruct)
{
  /*!< Initialize the CLUT address and RGB values */
  DVTC_CLUT_InitStruct->DVTC_CLUTAdress = 0x00;
  DVTC_CLUT_InitStruct->DVTC_BlueValue = 0x00;
  DVTC_CLUT_InitStruct->DVTC_GreenValue = 0x00;
  DVTC_CLUT_InitStruct->DVTC_RedValue = 0x00;
}


/**
  * @brief  reconfigure the layer position.
  * @param  OffsetX: horizontal offset from start active width .
  * @param  OffsetY: vertical offset from start active height.   
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2   
  * @retval Reload of the shadow registers values must be applied after layer 
  *         position reconfiguration.
  */

void DVTC_LayerPosition(DVTC_Layer_TypeDef* DVTC_Layerx, uint16_t OffsetX, uint16_t OffsetY)
{
  
  uint32_t tempreg, temp;
  uint32_t horizontal_start;
  uint32_t horizontal_stop;
  uint32_t vertical_start;
  uint32_t vertical_stop;
  
  DVTC_Layerx->WHPCR &= ~(DVTC_LxWHPCR_WHSTPOS | DVTC_LxWHPCR_WHSPPOS);
  DVTC_Layerx->WVPCR &= ~(DVTC_LxWVPCR_WVSTPOS | DVTC_LxWVPCR_WVSPPOS);
  
  /* Reconfigures the horizontal and vertical start position */
  tempreg = DVTC->BPCR;
  horizontal_start = (tempreg >> 16) + 1 + OffsetX;
  vertical_start = (tempreg & 0xFFFF) + 1 + OffsetY;
  
  /* Reconfigures the horizontal and vertical stop position */
  /* Get the number of byte per pixel */
  
  tempreg = DVTC_Layerx->PFCR;
  
  if (tempreg == DVTC_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (tempreg == DVTC_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((tempreg == DVTC_Pixelformat_ARGB4444) || 
          (tempreg == DVTC_Pixelformat_RGB565)    ||  
          (tempreg == DVTC_Pixelformat_ARGB1555)  ||
          (tempreg == DVTC_Pixelformat_AL88))
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }  
    
  tempreg = DVTC_Layerx->CFBLR;
  horizontal_stop = (((tempreg & 0x1FFF) - 3)/temp) + horizontal_start - 1;
  
  tempreg = DVTC_Layerx->CFBLNR;
  vertical_stop = (tempreg & 0x7FF) + vertical_start - 1;  
  
  DVTC_Layerx->WHPCR = horizontal_start | (horizontal_stop << 16);
  DVTC_Layerx->WVPCR = vertical_start | (vertical_stop << 16);  
}
  
/**
  * @brief  reconfigure constant alpha.
  * @param  ConstantAlpha: constant alpha value.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2    
  * @retval Reload of the shadow registers values must be applied after constant 
  *         alpha reconfiguration.         
  */

void DVTC_LayerAlpha(DVTC_Layer_TypeDef* DVTC_Layerx, uint8_t ConstantAlpha)
{  
  /* reconfigure the constant alpha value */      
  DVTC_Layerx->CACR = ConstantAlpha;
}

/**
  * @brief  reconfigure layer address.
  * @param  Address: The color frame buffer start address.
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2     
  * @retval Reload of the shadow registers values must be applied after layer 
  *         address reconfiguration.
  */

void DVTC_LayerAddress(DVTC_Layer_TypeDef* DVTC_Layerx, uint32_t Address)
{
  /* Reconfigures the color frame buffer start address */
  DVTC_Layerx->CFBAR = Address;
}
  
/**
  * @brief  reconfigure layer size.
  * @param  Width: layer window width.
  * @param  Height: layer window height.   
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2   
  * @retval Reload of the shadow registers values must be applied after layer 
  *         size reconfiguration.
  */

void DVTC_LayerSize(DVTC_Layer_TypeDef* DVTC_Layerx, uint32_t Width, uint32_t Height)
{

  uint8_t temp;
  uint32_t tempreg;
  uint32_t horizontal_start;
  uint32_t horizontal_stop;
  uint32_t vertical_start;
  uint32_t vertical_stop;  
  
  tempreg = DVTC_Layerx->PFCR;
  
  if (tempreg == DVTC_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (tempreg == DVTC_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((tempreg == DVTC_Pixelformat_ARGB4444) || \
          (tempreg == DVTC_Pixelformat_RGB565)    || \
          (tempreg == DVTC_Pixelformat_ARGB1555)  || \
          (tempreg == DVTC_Pixelformat_AL88))
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }

  /* update horizontal and vertical stop */
  tempreg = DVTC_Layerx->WHPCR;
  horizontal_start = (tempreg & 0x1FFF);
  horizontal_stop = Width + horizontal_start - 1;  

  tempreg = DVTC_Layerx->WVPCR;
  vertical_start = (tempreg & 0x1FFF);
  vertical_stop = Height + vertical_start - 1;  
  
  DVTC_Layerx->WHPCR = horizontal_start | (horizontal_stop << 16);
  DVTC_Layerx->WVPCR = vertical_start | (vertical_stop << 16);  

  /* Reconfigures the color frame buffer pitch in byte */
  DVTC_Layerx->CFBLR  = ((Width * temp) << 16) | ((Width * temp) + 3);  

  /* Reconfigures the frame buffer line number */
  DVTC_Layerx->CFBLNR  = Height;  
  
}

/**
  * @brief  reconfigure layer pixel format.
  * @param  PixelFormat: reconfigure the pixel format, this parameter can be 
  *         one of the following values:@ref DVTC_Pixelformat.   
  * @param  DVTC_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTC_Layer1, DVTC_Layer2   
  * @retval Reload of the shadow registers values must be applied after layer 
  *         pixel format reconfiguration.
  */

void DVTC_LayerPixelFormat(DVTC_Layer_TypeDef* DVTC_Layerx, uint32_t PixelFormat)
{

  uint8_t temp;
  uint32_t tempreg;
  
  tempreg = DVTC_Layerx->PFCR;
  
  if (tempreg == DVTC_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (tempreg == DVTC_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((tempreg == DVTC_Pixelformat_ARGB4444) || \
          (tempreg == DVTC_Pixelformat_RGB565)    || \
          (tempreg == DVTC_Pixelformat_ARGB1555)  || \
          (tempreg == DVTC_Pixelformat_AL88))  
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }
  
  tempreg = (DVTC_Layerx->CFBLR >> 16);
  tempreg = (tempreg / temp); 
  
  if (PixelFormat == DVTC_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (PixelFormat == DVTC_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((PixelFormat == DVTC_Pixelformat_ARGB4444) || \
          (PixelFormat == DVTC_Pixelformat_RGB565)    || \
          (PixelFormat == DVTC_Pixelformat_ARGB1555)  || \
          (PixelFormat == DVTC_Pixelformat_AL88))
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }
  
  /* Reconfigures the color frame buffer pitch in byte */
  DVTC_Layerx->CFBLR  = ((tempreg * temp) << 16) | ((tempreg * temp) + 3);  

  /* Reconfigures the color frame buffer start address */
  DVTC_Layerx->PFCR = PixelFormat;
    
}
    
/**
  * @}
  */

/** @defgroup DVTC_Group2 Interrupts and flags management functions
 *  @brief   Interrupts and flags management functions
 *
@verbatim
 ===============================================================================
            ##### Interrupts and flags management functions #####
 ===============================================================================

    [..] This section provides functions allowing to configure the DVTC Interrupts 
         and to get the status and clear flags and Interrupts pending bits.
  
    [..] The DVTC provides 4 Interrupts sources and 4 Flags
    
    *** Flags ***
    =============
    [..]
      (+) DVTC_FLAG_LI:   Line Interrupt flag.
      (+) DVTC_FLAG_FU:   FIFO Underrun Interrupt flag.
      (+) DVTC_FLAG_TERR: Transfer Error Interrupt flag.
      (+) DVTC_FLAG_RR:   Register Reload interrupt flag.
      
    *** Interrupts ***
    ==================
    [..]
      (+) DVTC_IT_LI: Line Interrupt is generated when a programmed line 
                      is reached. The line interrupt position is programmed in 
                      the DVTC_LIPR register.
      (+) DVTC_IT_FU: FIFO Underrun interrupt is generated when a pixel is requested 
                      from an empty layer FIFO
      (+) DVTC_IT_TERR: Transfer Error interrupt is generated when an AHB bus 
                        error occurs during data transfer.
      (+) DVTC_IT_RR: Register Reload interrupt is generated when the shadow 
                      registers reload was performed during the vertical blanking 
                      period.
               
@endverbatim
  * @{
  */

/**
  * @brief  Enables or disables the specified DVTC's interrupts.
  * @param  DVTC_IT: specifies the DVTC interrupts sources to be enabled or disabled.
  *   This parameter can be any combination of the following values:
  *     @arg DVTC_IT_LI: Line Interrupt Enable.
  *     @arg DVTC_IT_FU: FIFO Underrun Interrupt Enable.
  *     @arg DVTC_IT_TERR: Transfer Error Interrupt Enable.
  *     @arg DVTC_IT_RR: Register Reload interrupt enable.  
  * @param NewState: new state of the specified DVTC interrupts.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTC_ITConfig(uint32_t DVTC_IT, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_DVTC_IT(DVTC_IT));
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    DVTC->IER |= DVTC_IT;
  }
  else
  {
    DVTC->IER &= (uint32_t)~DVTC_IT;
  }
}

/**
  * @brief  Checks whether the specified DVTC's flag is set or not.
  * @param  DVTC_FLAG: specifies the flag to check.
  *   This parameter can be one of the following values:
  *     @arg DVTC_FLAG_LI:    Line Interrupt flag.
  *     @arg DVTC_FLAG_FU:   FIFO Underrun Interrupt flag.
  *     @arg DVTC_FLAG_TERR: Transfer Error Interrupt flag.
  *     @arg DVTC_FLAG_RR:   Register Reload interrupt flag.
  * @retval The new state of DVTC_FLAG (SET or RESET).
  */
FlagStatus DVTC_GetFlagStatus(uint32_t DVTC_FLAG)
{
  FlagStatus bitstatus = RESET;

  /* Check the parameters */
  assert_param(IS_DVTC_FLAG(DVTC_FLAG));

  if ((DVTC->ISR & DVTC_FLAG) != (uint32_t)RESET)
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
  * @brief  Clears the DVTC's pending flags.
  * @param  DVTC_FLAG: specifies the flag to clear.
  *   This parameter can be any combination of the following values:
  *     @arg DVTC_FLAG_LI:    Line Interrupt flag.
  *     @arg DVTC_FLAG_FU:   FIFO Underrun Interrupt flag.
  *     @arg DVTC_FLAG_TERR: Transfer Error Interrupt flag.
  *     @arg DVTC_FLAG_RR:   Register Reload interrupt flag.  
  * @retval None
  */
void DVTC_ClearFlag(uint32_t DVTC_FLAG)
{
  /* Check the parameters */
  assert_param(IS_DVTC_FLAG(DVTC_FLAG));

  /* Clear the corresponding DVTC flag */
  DVTC->ICR = (uint32_t)DVTC_FLAG;
}

/**
  * @brief  Checks whether the specified DVTC's interrupt has occurred or not.
  * @param  DVTC_IT: specifies the DVTC interrupts sources to check.
  *   This parameter can be one of the following values:
  *     @arg DVTC_IT_LI:    Line Interrupt Enable.
  *     @arg DVTC_IT_FU:   FIFO Underrun Interrupt Enable.
  *     @arg DVTC_IT_TERR: Transfer Error Interrupt Enable.
  *     @arg DVTC_IT_RR:   Register Reload interrupt Enable.
  * @retval The new state of the DVTC_IT (SET or RESET).
  */
ITStatus DVTC_GetITStatus(uint32_t DVTC_IT)
{
  ITStatus bitstatus = RESET;

  /* Check the parameters */
  assert_param(IS_DVTC_IT(DVTC_IT));

  if ((DVTC->ISR & DVTC_IT) != (uint32_t)RESET)
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }

  if (((DVTC->IER & DVTC_IT) != (uint32_t)RESET) && (bitstatus != (uint32_t)RESET))
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
  * @brief  Clears the DVTC's interrupt pending bits.
  * @param  DVTC_IT: specifies the interrupt pending bit to clear.
  *   This parameter can be any combination of the following values:
  *     @arg DVTC_IT_LIE:    Line Interrupt.
  *     @arg DVTC_IT_FUIE:   FIFO Underrun Interrupt.
  *     @arg DVTC_IT_TERRIE: Transfer Error Interrupt.
  *     @arg DVTC_IT_RRIE:   Register Reload interrupt.
  * @retval None
  */
void DVTC_ClearITPendingBit(uint32_t DVTC_IT)
{
  /* Check the parameters */
  assert_param(IS_DVTC_IT(DVTC_IT));

  /* Clear the corresponding DVTC Interrupt */
  DVTC->ICR = (uint32_t)DVTC_IT;
}

#endif /* CYBER_DVTC */

/******************* END OF FILE *******************/

