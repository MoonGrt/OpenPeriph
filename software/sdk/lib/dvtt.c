
/* Includes ------------------------------------------------------------------*/
#include "dvtt.h"
#ifdef CYBER_DVTT

/** @defgroup DVTT 
  * @brief DVTT driver modules
  * @{
  */

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

#define GCR_MASK ((uint32_t)0x0FFE888F)  /* DVTT GCR Mask */


/** @defgroup DVTT_Private_Functions
  * @{
  */

/** @defgroup DVTT_Group1 Initialization and Configuration functions
 *  @brief   Initialization and Configuration functions 
 *
@verbatim
 ===============================================================================
            ##### Initialization and Configuration functions #####
 ===============================================================================
    [..]  This section provides functions allowing to:
      (+) Initialize and configure the DVTT
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
  * @brief  Deinitializes the DVTT peripheral registers to their default reset
  *         values.
  * @param  None
  * @retval None
  */

void DVTT_DeInit(void)
{

}

/**
  * @brief  Initializes the DVTT peripheral according to the specified parameters
  *         in the DVTT_InitStruct.
  * @note   This function can be used only when the DVTT is disabled.
  * @param  DVTT_InitStruct: pointer to a DVTT_InitTypeDef structure that contains
  *         the configuration information for the specified DVTT peripheral.
  * @retval None
  */

void DVTT_Init(DVTT_InitTypeDef* DVTT_InitStruct)
{
  uint32_t horizontalsync = 0;
  uint32_t accumulatedHBP = 0;
  uint32_t accumulatedactiveW = 0;
  uint32_t totalwidth = 0;
  uint32_t backgreen = 0;
  uint32_t backred = 0;

  /* Check function parameters */
  assert_param(IS_DVTT_HSYNC(DVTT_InitStruct->DVTT_HorizontalSync));
  assert_param(IS_DVTT_VSYNC(DVTT_InitStruct->DVTT_VerticalSync));
  assert_param(IS_DVTT_AHBP(DVTT_InitStruct->DVTT_AccumulatedHBP));
  assert_param(IS_DVTT_AVBP(DVTT_InitStruct->DVTT_AccumulatedVBP));
  assert_param(IS_DVTT_AAH(DVTT_InitStruct->DVTT_AccumulatedActiveH));
  assert_param(IS_DVTT_AAW(DVTT_InitStruct->DVTT_AccumulatedActiveW));
  assert_param(IS_DVTT_TOTALH(DVTT_InitStruct->DVTT_TotalHeigh));
  assert_param(IS_DVTT_TOTALW(DVTT_InitStruct->DVTT_TotalWidth));
  assert_param(IS_DVTT_HSPOL(DVTT_InitStruct->DVTT_HSPolarity));
  assert_param(IS_DVTT_VSPOL(DVTT_InitStruct->DVTT_VSPolarity));
  assert_param(IS_DVTT_DEPOL(DVTT_InitStruct->DVTT_DEPolarity));
  assert_param(IS_DVTT_PCPOL(DVTT_InitStruct->DVTT_PCPolarity));
  assert_param(IS_DVTT_BackBlueValue(DVTT_InitStruct->DVTT_BackgroundBlueValue));
  assert_param(IS_DVTT_BackGreenValue(DVTT_InitStruct->DVTT_BackgroundGreenValue));
  assert_param(IS_DVTT_BackRedValue(DVTT_InitStruct->DVTT_BackgroundRedValue));

  /* Sets Synchronization size */
  DVTT->SSCR &= ~(DVTT_SSCR_VSH | DVTT_SSCR_HSW);
  horizontalsync = (DVTT_InitStruct->DVTT_HorizontalSync << 16);
  DVTT->SSCR |= (horizontalsync | DVTT_InitStruct->DVTT_VerticalSync);

  /* Sets Accumulated Back porch */
  DVTT->BPCR &= ~(DVTT_BPCR_AVBP | DVTT_BPCR_AHBP);
  accumulatedHBP = (DVTT_InitStruct->DVTT_AccumulatedHBP << 16);
  DVTT->BPCR |= (accumulatedHBP | DVTT_InitStruct->DVTT_AccumulatedVBP);

  /* Sets Accumulated Active Width */
  DVTT->AWCR &= ~(DVTT_AWCR_AAH | DVTT_AWCR_AAW);
  accumulatedactiveW = (DVTT_InitStruct->DVTT_AccumulatedActiveW << 16);
  DVTT->AWCR |= (accumulatedactiveW | DVTT_InitStruct->DVTT_AccumulatedActiveH);

  /* Sets Total Width */
  DVTT->TWCR &= ~(DVTT_TWCR_TOTALH | DVTT_TWCR_TOTALW);
  totalwidth = (DVTT_InitStruct->DVTT_TotalWidth << 16);
  DVTT->TWCR |= (totalwidth | DVTT_InitStruct->DVTT_TotalHeigh);

  DVTT->GCR &= (uint32_t)GCR_MASK;
  DVTT->GCR |=  (uint32_t)(DVTT_InitStruct->DVTT_HSPolarity | DVTT_InitStruct->DVTT_VSPolarity | \
                           DVTT_InitStruct->DVTT_DEPolarity | DVTT_InitStruct->DVTT_PCPolarity);

  /* sets the background color value */
  backgreen = (DVTT_InitStruct->DVTT_BackgroundGreenValue << 8);
  backred = (DVTT_InitStruct->DVTT_BackgroundRedValue << 16);

  DVTT->BCCR &= ~(DVTT_BCCR_BCBLUE | DVTT_BCCR_BCGREEN | DVTT_BCCR_BCRED);
  DVTT->BCCR |= (backred | backgreen | DVTT_InitStruct->DVTT_BackgroundBlueValue);
}

/**
  * @brief  Fills each DVTT_InitStruct member with its default value.
  * @param  DVTT_InitStruct: pointer to a DVTT_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTT_StructInit(DVTT_InitTypeDef* DVTT_InitStruct)
{
  /*--------------- Reset DVTT init structure parameters values ----------------*/
  DVTT_InitStruct->DVTT_HSPolarity = DVTT_HSPolarity_AL;      /*!< Initialize the DVTT_HSPolarity member */ 
  DVTT_InitStruct->DVTT_VSPolarity = DVTT_VSPolarity_AL;      /*!< Initialize the DVTT_VSPolarity member */
  DVTT_InitStruct->DVTT_DEPolarity = DVTT_DEPolarity_AL;      /*!< Initialize the DVTT_DEPolarity member */
  DVTT_InitStruct->DVTT_PCPolarity = DVTT_PCPolarity_IPC;     /*!< Initialize the DVTT_PCPolarity member */
  DVTT_InitStruct->DVTT_HorizontalSync = 0x00;                /*!< Initialize the DVTT_HorizontalSync member */
  DVTT_InitStruct->DVTT_VerticalSync = 0x00;                  /*!< Initialize the DVTT_VerticalSync member */
  DVTT_InitStruct->DVTT_AccumulatedHBP = 0x00;                /*!< Initialize the DVTT_AccumulatedHBP member */
  DVTT_InitStruct->DVTT_AccumulatedVBP = 0x00;                /*!< Initialize the DVTT_AccumulatedVBP member */
  DVTT_InitStruct->DVTT_AccumulatedActiveW = 0x00;            /*!< Initialize the DVTT_AccumulatedActiveW member */
  DVTT_InitStruct->DVTT_AccumulatedActiveH = 0x00;            /*!< Initialize the DVTT_AccumulatedActiveH member */
  DVTT_InitStruct->DVTT_TotalWidth = 0x00;                    /*!< Initialize the DVTT_TotalWidth member */
  DVTT_InitStruct->DVTT_TotalHeigh = 0x00;                    /*!< Initialize the DVTT_TotalHeigh member */
  DVTT_InitStruct->DVTT_BackgroundRedValue = 0x00;            /*!< Initialize the DVTT_BackgroundRedValue member */
  DVTT_InitStruct->DVTT_BackgroundGreenValue = 0x00;          /*!< Initialize the DVTT_BackgroundGreenValue member */
  DVTT_InitStruct->DVTT_BackgroundBlueValue = 0x00;           /*!< Initialize the DVTT_BackgroundBlueValue member */
}

/**
  * @brief  Enables or disables the DVTT Controller.
  * @param  NewState: new state of the DVTT peripheral.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTT_Cmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable DVTT by setting DVTTEN bit */
    DVTT->GCR |= (uint32_t)DVTT_GCR_DVTTEN;
  }
  else
  {
    /* Disable DVTT by clearing DVTTEN bit */
    DVTT->GCR &= ~(uint32_t)DVTT_GCR_DVTTEN;
  }
}

/**
  * @brief  Enables or disables Dither.
  * @param  NewState: new state of the Dither.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTT_DitherCmd(FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable Dither by setting DTEN bit */
    DVTT->GCR |= (uint32_t)DVTT_GCR_DTEN;
  }
  else
  {
    /* Disable Dither by clearing DTEN bit */
    DVTT->GCR &= ~(uint32_t)DVTT_GCR_DTEN;
  }
}

/**
  * @brief  Get the dither RGB width.
  * @param  DVTT_RGB_InitStruct: pointer to a DVTT_RGBTypeDef structure that contains
  *         the Dither RGB width.
  * @retval None
  */

DVTT_RGBTypeDef DVTT_GetRGBWidth(void)
{
  DVTT_RGBTypeDef DVTT_RGB_InitStruct;

  DVTT->GCR &= (uint32_t)GCR_MASK;

  DVTT_RGB_InitStruct.DVTT_BlueWidth = (uint32_t)((DVTT->GCR >> 4) & 0x7);
  DVTT_RGB_InitStruct.DVTT_GreenWidth = (uint32_t)((DVTT->GCR >> 8) & 0x7);
  DVTT_RGB_InitStruct.DVTT_RedWidth = (uint32_t)((DVTT->GCR >> 12) & 0x7);

  return DVTT_RGB_InitStruct;
}

/**
  * @brief  Fills each DVTT_RGBStruct member with its default value.
  * @param  DVTT_RGB_InitStruct: pointer to a DVTT_RGBTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTT_RGBStructInit(DVTT_RGBTypeDef* DVTT_RGB_InitStruct)
{
  DVTT_RGB_InitStruct->DVTT_BlueWidth = 0x02;
  DVTT_RGB_InitStruct->DVTT_GreenWidth = 0x02;
  DVTT_RGB_InitStruct->DVTT_RedWidth = 0x02;
}


/**
  * @brief  Define the position of the line interrupt .
  * @param  DVTT_LIPositionConfig: Line Interrupt Position.
  * @retval None
  */

void DVTT_LIPConfig(uint32_t DVTT_LIPositionConfig)
{
  /* Check the parameters */
  assert_param(IS_DVTT_LIPOS(DVTT_LIPositionConfig));

  /* Sets the Line Interrupt position */
  DVTT->LIPCR = (uint32_t)DVTT_LIPositionConfig;
}

/**
  * @brief  reload layers registers with new parameters 
  * @param  DVTT_Reload: specifies the type of reload.
  *   This parameter can be one of the following values:
  *     @arg DVTT_IMReload: Vertical blanking reload.
  *     @arg DVTT_VBReload: Immediate reload.  
  * @retval None
  */

void DVTT_ReloadConfig(uint32_t DVTT_Reload)
{
  /* Check the parameters */
  assert_param(IS_DVTT_RELOAD(DVTT_Reload));

  /* Sets the Reload type */
  DVTT->SRCR = (uint32_t)DVTT_Reload;
}


/**
  * @brief  Initializes the DVTT Layer according to the specified parameters
  *         in the DVTT_LayerStruct.
  * @note   This function can be used only when the DVTT is disabled.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2    
  * @param  DVTT_LayerStruct: pointer to a DVTT_LayerTypeDef structure that contains
  *         the configuration information for the specified DVTT peripheral.
  * @retval None
  */

void DVTT_LayerInit(DVTT_Layer_TypeDef* DVTT_Layerx, DVTT_Layer_InitTypeDef* DVTT_Layer_InitStruct)
{

  uint32_t whsppos = 0;
  uint32_t wvsppos = 0;
  uint32_t dcgreen = 0;
  uint32_t dcred = 0;
  uint32_t dcalpha = 0;
  uint32_t cfbp = 0;

/* Check the parameters */
  assert_param(IS_DVTT_Pixelformat(DVTT_Layer_InitStruct->DVTT_PixelFormat));
  assert_param(IS_DVTT_BlendingFactor1(DVTT_Layer_InitStruct->DVTT_BlendingFactor_1));
  assert_param(IS_DVTT_BlendingFactor2(DVTT_Layer_InitStruct->DVTT_BlendingFactor_2));
  assert_param(IS_DVTT_HCONFIGST(DVTT_Layer_InitStruct->DVTT_HorizontalStart));
  assert_param(IS_DVTT_HCONFIGSP(DVTT_Layer_InitStruct->DVTT_HorizontalStop));
  assert_param(IS_DVTT_VCONFIGST(DVTT_Layer_InitStruct->DVTT_VerticalStart));
  assert_param(IS_DVTT_VCONFIGSP(DVTT_Layer_InitStruct->DVTT_VerticalStop));  
  assert_param(IS_DVTT_DEFAULTCOLOR(DVTT_Layer_InitStruct->DVTT_DefaultColorBlue));
  assert_param(IS_DVTT_DEFAULTCOLOR(DVTT_Layer_InitStruct->DVTT_DefaultColorGreen));
  assert_param(IS_DVTT_DEFAULTCOLOR(DVTT_Layer_InitStruct->DVTT_DefaultColorRed));
  assert_param(IS_DVTT_DEFAULTCOLOR(DVTT_Layer_InitStruct->DVTT_DefaultColorAlpha));
  assert_param(IS_DVTT_CFBP(DVTT_Layer_InitStruct->DVTT_CFBPitch));
  assert_param(IS_DVTT_CFBLL(DVTT_Layer_InitStruct->DVTT_CFBLineLength));
  assert_param(IS_DVTT_CFBLNBR(DVTT_Layer_InitStruct->DVTT_CFBLineNumber));

  /* Configures the horizontal start and stop position */
  whsppos = DVTT_Layer_InitStruct->DVTT_HorizontalStop << 16;
  DVTT_Layerx->WHPCR &= ~(DVTT_LxWHPCR_WHSTPOS | DVTT_LxWHPCR_WHSPPOS);
  DVTT_Layerx->WHPCR = (DVTT_Layer_InitStruct->DVTT_HorizontalStart | whsppos);

  /* Configures the vertical start and stop position */
  wvsppos = DVTT_Layer_InitStruct->DVTT_VerticalStop << 16;
  DVTT_Layerx->WVPCR &= ~(DVTT_LxWVPCR_WVSTPOS | DVTT_LxWVPCR_WVSPPOS);
  DVTT_Layerx->WVPCR  = (DVTT_Layer_InitStruct->DVTT_VerticalStart | wvsppos);

  /* Specifies the pixel format */
  DVTT_Layerx->PFCR &= ~(DVTT_LxPFCR_PF);
  DVTT_Layerx->PFCR = (DVTT_Layer_InitStruct->DVTT_PixelFormat);

  /* Configures the default color values */
  dcgreen = (DVTT_Layer_InitStruct->DVTT_DefaultColorGreen << 8);
  dcred = (DVTT_Layer_InitStruct->DVTT_DefaultColorRed << 16);
  dcalpha = (DVTT_Layer_InitStruct->DVTT_DefaultColorAlpha << 24);
  DVTT_Layerx->DCCR &=  ~(DVTT_LxDCCR_DCBLUE | DVTT_LxDCCR_DCGREEN | DVTT_LxDCCR_DCRED | DVTT_LxDCCR_DCALPHA);
  DVTT_Layerx->DCCR = (DVTT_Layer_InitStruct->DVTT_DefaultColorBlue | dcgreen | \
                        dcred | dcalpha);

  /* Specifies the constant alpha value */      
  DVTT_Layerx->CACR &= ~(DVTT_LxCACR_CONSTA);
  DVTT_Layerx->CACR = (DVTT_Layer_InitStruct->DVTT_ConstantAlpha);

  /* Specifies the blending factors */
  DVTT_Layerx->BFCR &= ~(DVTT_LxBFCR_BF2 | DVTT_LxBFCR_BF1);
  DVTT_Layerx->BFCR = (DVTT_Layer_InitStruct->DVTT_BlendingFactor_1 | DVTT_Layer_InitStruct->DVTT_BlendingFactor_2);

  /* Configures the color frame buffer start address */
  DVTT_Layerx->CFBAR &= ~(DVTT_LxCFBAR_CFBADD);
  DVTT_Layerx->CFBAR = (DVTT_Layer_InitStruct->DVTT_CFBStartAdress);

  /* Configures the color frame buffer pitch in byte */
  cfbp = (DVTT_Layer_InitStruct->DVTT_CFBPitch << 16);
  DVTT_Layerx->CFBLR  &= ~(DVTT_LxCFBLR_CFBLL | DVTT_LxCFBLR_CFBP);
  DVTT_Layerx->CFBLR  = (DVTT_Layer_InitStruct->DVTT_CFBLineLength | cfbp);

  /* Configures the frame buffer line number */
  DVTT_Layerx->CFBLNR  &= ~(DVTT_LxCFBLNR_CFBLNBR);
  DVTT_Layerx->CFBLNR  = (DVTT_Layer_InitStruct->DVTT_CFBLineNumber);
}

/**
  * @brief  Fills each DVTT_Layer_InitStruct member with its default value.
  * @param  DVTT_Layer_InitStruct: pointer to a DVTT_LayerTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTT_LayerStructInit(DVTT_Layer_InitTypeDef * DVTT_Layer_InitStruct)
{
  /*--------------- Reset Layer structure parameters values -------------------*/

  /*!< Initialize the horizontal limit member */
  DVTT_Layer_InitStruct->DVTT_HorizontalStart = 0x00;
  DVTT_Layer_InitStruct->DVTT_HorizontalStop = 0x00;

  /*!< Initialize the vertical limit member */
  DVTT_Layer_InitStruct->DVTT_VerticalStart = 0x00;
  DVTT_Layer_InitStruct->DVTT_VerticalStop = 0x00;

  /*!< Initialize the pixel format member */
  DVTT_Layer_InitStruct->DVTT_PixelFormat = DVTT_Pixelformat_ARGB8888;

  /*!< Initialize the constant alpha value */
  DVTT_Layer_InitStruct->DVTT_ConstantAlpha = 0xFF;

  /*!< Initialize the default color values */
  DVTT_Layer_InitStruct->DVTT_DefaultColorBlue = 0x00;
  DVTT_Layer_InitStruct->DVTT_DefaultColorGreen = 0x00;
  DVTT_Layer_InitStruct->DVTT_DefaultColorRed = 0x00;
  DVTT_Layer_InitStruct->DVTT_DefaultColorAlpha = 0x00;

  /*!< Initialize the blending factors */
  DVTT_Layer_InitStruct->DVTT_BlendingFactor_1 = DVTT_BlendingFactor1_PAxCA;
  DVTT_Layer_InitStruct->DVTT_BlendingFactor_2 = DVTT_BlendingFactor2_PAxCA;

  /*!< Initialize the frame buffer start address */
  DVTT_Layer_InitStruct->DVTT_CFBStartAdress = 0x00;

  /*!< Initialize the frame buffer pitch and line length */
  DVTT_Layer_InitStruct->DVTT_CFBLineLength = 0x00;
  DVTT_Layer_InitStruct->DVTT_CFBPitch = 0x00;

  /*!< Initialize the frame buffer line number */
  DVTT_Layer_InitStruct->DVTT_CFBLineNumber = 0x00;
}


/**
  * @brief  Enables or disables the DVTT_Layer Controller.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2
  * @param  NewState: new state of the DVTT_Layer peripheral.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTT_LayerCmd(DVTT_Layer_TypeDef* DVTT_Layerx, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable DVTT_Layer by setting LEN bit */
    DVTT_Layerx->CR |= (uint32_t)DVTT_LxCR_LEN;
  }
  else
  {
    /* Disable DVTT_Layer by clearing LEN bit */
    DVTT_Layerx->CR &= ~(uint32_t)DVTT_LxCR_LEN;
  }
}


/**
  * @brief  Get the current position.
  * @param  DVTT_Pos_InitStruct: pointer to a DVTT_PosTypeDef structure that contains
  *         the current position.
  * @retval None
  */

DVTT_PosTypeDef DVTT_GetPosStatus(void)
{
  DVTT_PosTypeDef DVTT_Pos_InitStruct;

  DVTT->CPSR &= ~(DVTT_CPSR_CYPOS | DVTT_CPSR_CXPOS);

  DVTT_Pos_InitStruct.DVTT_POSX = (uint32_t)(DVTT->CPSR >> 16);
  DVTT_Pos_InitStruct.DVTT_POSY = (uint32_t)(DVTT->CPSR & 0xFFFF);

  return DVTT_Pos_InitStruct;
}

/**
  * @brief  Fills each DVTT_Pos_InitStruct member with its default value.
  * @param  DVTT_Pos_InitStruct: pointer to a DVTT_PosTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTT_PosStructInit(DVTT_PosTypeDef* DVTT_Pos_InitStruct)
{
  DVTT_Pos_InitStruct->DVTT_POSX = 0x00;
  DVTT_Pos_InitStruct->DVTT_POSY = 0x00;
}

/**
  * @brief  Checks whether the specified DVTT's flag is set or not.
  * @param  DVTT_CD: specifies the flag to check.
  *   This parameter can be one of the following values:
  *     @arg DVTT_CD_VDES: vertical data enable current status.
  *     @arg DVTT_CD_HDES: horizontal data enable current status.
  *     @arg DVTT_CD_VSYNC:  Vertical Synchronization current status.
  *     @arg DVTT_CD_HSYNC:  Horizontal Synchronization current status.
  * @retval The new state of DVTT_CD (SET or RESET).
  */

FlagStatus DVTT_GetCDStatus(uint32_t DVTT_CD)
{
  FlagStatus bitstatus;

  /* Check the parameters */
  assert_param(IS_DVTT_GET_CD(DVTT_CD));

  if ((DVTT->CDSR & DVTT_CD) != (uint32_t)RESET)
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
  * @param  DVTT_colorkeying_InitStruct: pointer to a DVTT_ColorKeying_InitTypeDef 
  *         structure that contains the color keying configuration.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2   
  * @retval None
  */

void DVTT_ColorKeyingConfig(DVTT_Layer_TypeDef* DVTT_Layerx, DVTT_ColorKeying_InitTypeDef* DVTT_colorkeying_InitStruct, FunctionalState NewState)
{ 
  uint32_t ckgreen = 0;
  uint32_t ckred = 0;

  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));
  assert_param(IS_DVTT_CKEYING(DVTT_colorkeying_InitStruct->DVTT_ColorKeyBlue));
  assert_param(IS_DVTT_CKEYING(DVTT_colorkeying_InitStruct->DVTT_ColorKeyGreen));
  assert_param(IS_DVTT_CKEYING(DVTT_colorkeying_InitStruct->DVTT_ColorKeyRed));
  
  if (NewState != DISABLE)
  {
    /* Enable DVTT color keying by setting COLKEN bit */
    DVTT_Layerx->CR |= (uint32_t)DVTT_LxCR_COLKEN;
    
    /* Sets the color keying values */
    ckgreen = (DVTT_colorkeying_InitStruct->DVTT_ColorKeyGreen << 8);
    ckred = (DVTT_colorkeying_InitStruct->DVTT_ColorKeyRed << 16);
    DVTT_Layerx->CKCR  &= ~(DVTT_LxCKCR_CKBLUE | DVTT_LxCKCR_CKGREEN | DVTT_LxCKCR_CKRED);
    DVTT_Layerx->CKCR |= (DVTT_colorkeying_InitStruct->DVTT_ColorKeyBlue | ckgreen | ckred);
  }
  else
  {
    /* Disable DVTT color keying by clearing COLKEN bit */
    DVTT_Layerx->CR &= ~(uint32_t)DVTT_LxCR_COLKEN;
  }
  
  /* Reload shadow register */
  DVTT->SRCR = DVTT_IMReload;
}

/**
  * @brief  Fills each DVTT_colorkeying_InitStruct member with its default value.
  * @param  DVTT_colorkeying_InitStruct: pointer to a DVTT_ColorKeying_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTT_ColorKeyingStructInit(DVTT_ColorKeying_InitTypeDef* DVTT_colorkeying_InitStruct)
{
  /*!< Initialize the color keying values */
  DVTT_colorkeying_InitStruct->DVTT_ColorKeyBlue = 0x00;
  DVTT_colorkeying_InitStruct->DVTT_ColorKeyGreen = 0x00;
  DVTT_colorkeying_InitStruct->DVTT_ColorKeyRed = 0x00;
}


/**
  * @brief  Enables or disables CLUT.
  * @param  NewState: new state of CLUT.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2  
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */

void DVTT_CLUTCmd(DVTT_Layer_TypeDef* DVTT_Layerx, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable CLUT by setting CLUTEN bit */
    DVTT_Layerx->CR |= (uint32_t)DVTT_LxCR_CLUTEN;
  }
  else
  {
    /* Disable CLUT by clearing CLUTEN bit */
    DVTT_Layerx->CR &= ~(uint32_t)DVTT_LxCR_CLUTEN;
  }
  
  /* Reload shadow register */
  DVTT->SRCR = DVTT_IMReload;
}

/**
  * @brief  configure the CLUT.
  * @param  DVTT_CLUT_InitStruct: pointer to a DVTT_CLUT_InitTypeDef structure that contains
  *         the CLUT configuration.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2   
  * @retval None
  */

void DVTT_CLUTInit(DVTT_Layer_TypeDef* DVTT_Layerx, DVTT_CLUT_InitTypeDef* DVTT_CLUT_InitStruct)
{  
  uint32_t green = 0;
  uint32_t red = 0;
  uint32_t clutadd = 0;

  /* Check the parameters */
  assert_param(IS_DVTT_CLUTWR(DVTT_CLUT_InitStruct->DVTT_CLUTAdress));
  assert_param(IS_DVTT_CLUTWR(DVTT_CLUT_InitStruct->DVTT_RedValue));
  assert_param(IS_DVTT_CLUTWR(DVTT_CLUT_InitStruct->DVTT_GreenValue));
  assert_param(IS_DVTT_CLUTWR(DVTT_CLUT_InitStruct->DVTT_BlueValue));
    
  /* Specifies the CLUT address and RGB value */
  green = (DVTT_CLUT_InitStruct->DVTT_GreenValue << 8);
  red = (DVTT_CLUT_InitStruct->DVTT_RedValue << 16);
  clutadd = (DVTT_CLUT_InitStruct->DVTT_CLUTAdress << 24);
  DVTT_Layerx->CLUTWR  = (clutadd | DVTT_CLUT_InitStruct->DVTT_BlueValue | \
                              green | red);
}

/**
  * @brief  Fills each DVTT_CLUT_InitStruct member with its default value.
  * @param  DVTT_CLUT_InitStruct: pointer to a DVTT_CLUT_InitTypeDef structure which will
  *         be initialized.
  * @retval None
  */

void DVTT_CLUTStructInit(DVTT_CLUT_InitTypeDef* DVTT_CLUT_InitStruct)
{
  /*!< Initialize the CLUT address and RGB values */
  DVTT_CLUT_InitStruct->DVTT_CLUTAdress = 0x00;
  DVTT_CLUT_InitStruct->DVTT_BlueValue = 0x00;
  DVTT_CLUT_InitStruct->DVTT_GreenValue = 0x00;
  DVTT_CLUT_InitStruct->DVTT_RedValue = 0x00;
}


/**
  * @brief  reconfigure the layer position.
  * @param  OffsetX: horizontal offset from start active width .
  * @param  OffsetY: vertical offset from start active height.   
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2   
  * @retval Reload of the shadow registers values must be applied after layer 
  *         position reconfiguration.
  */

void DVTT_LayerPosition(DVTT_Layer_TypeDef* DVTT_Layerx, uint16_t OffsetX, uint16_t OffsetY)
{
  
  uint32_t tempreg, temp;
  uint32_t horizontal_start;
  uint32_t horizontal_stop;
  uint32_t vertical_start;
  uint32_t vertical_stop;
  
  DVTT_Layerx->WHPCR &= ~(DVTT_LxWHPCR_WHSTPOS | DVTT_LxWHPCR_WHSPPOS);
  DVTT_Layerx->WVPCR &= ~(DVTT_LxWVPCR_WVSTPOS | DVTT_LxWVPCR_WVSPPOS);
  
  /* Reconfigures the horizontal and vertical start position */
  tempreg = DVTT->BPCR;
  horizontal_start = (tempreg >> 16) + 1 + OffsetX;
  vertical_start = (tempreg & 0xFFFF) + 1 + OffsetY;
  
  /* Reconfigures the horizontal and vertical stop position */
  /* Get the number of byte per pixel */
  
  tempreg = DVTT_Layerx->PFCR;
  
  if (tempreg == DVTT_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (tempreg == DVTT_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((tempreg == DVTT_Pixelformat_ARGB4444) || 
          (tempreg == DVTT_Pixelformat_RGB565)    ||  
          (tempreg == DVTT_Pixelformat_ARGB1555)  ||
          (tempreg == DVTT_Pixelformat_AL88))
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }  
    
  tempreg = DVTT_Layerx->CFBLR;
  horizontal_stop = (((tempreg & 0x1FFF) - 3)/temp) + horizontal_start - 1;
  
  tempreg = DVTT_Layerx->CFBLNR;
  vertical_stop = (tempreg & 0x7FF) + vertical_start - 1;  
  
  DVTT_Layerx->WHPCR = horizontal_start | (horizontal_stop << 16);
  DVTT_Layerx->WVPCR = vertical_start | (vertical_stop << 16);  
}
  
/**
  * @brief  reconfigure constant alpha.
  * @param  ConstantAlpha: constant alpha value.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2    
  * @retval Reload of the shadow registers values must be applied after constant 
  *         alpha reconfiguration.         
  */

void DVTT_LayerAlpha(DVTT_Layer_TypeDef* DVTT_Layerx, uint8_t ConstantAlpha)
{  
  /* reconfigure the constant alpha value */      
  DVTT_Layerx->CACR = ConstantAlpha;
}

/**
  * @brief  reconfigure layer address.
  * @param  Address: The color frame buffer start address.
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2     
  * @retval Reload of the shadow registers values must be applied after layer 
  *         address reconfiguration.
  */

void DVTT_LayerAddress(DVTT_Layer_TypeDef* DVTT_Layerx, uint32_t Address)
{
  /* Reconfigures the color frame buffer start address */
  DVTT_Layerx->CFBAR = Address;
}
  
/**
  * @brief  reconfigure layer size.
  * @param  Width: layer window width.
  * @param  Height: layer window height.   
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2   
  * @retval Reload of the shadow registers values must be applied after layer 
  *         size reconfiguration.
  */

void DVTT_LayerSize(DVTT_Layer_TypeDef* DVTT_Layerx, uint32_t Width, uint32_t Height)
{

  uint8_t temp;
  uint32_t tempreg;
  uint32_t horizontal_start;
  uint32_t horizontal_stop;
  uint32_t vertical_start;
  uint32_t vertical_stop;  
  
  tempreg = DVTT_Layerx->PFCR;
  
  if (tempreg == DVTT_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (tempreg == DVTT_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((tempreg == DVTT_Pixelformat_ARGB4444) || \
          (tempreg == DVTT_Pixelformat_RGB565)    || \
          (tempreg == DVTT_Pixelformat_ARGB1555)  || \
          (tempreg == DVTT_Pixelformat_AL88))
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }

  /* update horizontal and vertical stop */
  tempreg = DVTT_Layerx->WHPCR;
  horizontal_start = (tempreg & 0x1FFF);
  horizontal_stop = Width + horizontal_start - 1;  

  tempreg = DVTT_Layerx->WVPCR;
  vertical_start = (tempreg & 0x1FFF);
  vertical_stop = Height + vertical_start - 1;  
  
  DVTT_Layerx->WHPCR = horizontal_start | (horizontal_stop << 16);
  DVTT_Layerx->WVPCR = vertical_start | (vertical_stop << 16);  

  /* Reconfigures the color frame buffer pitch in byte */
  DVTT_Layerx->CFBLR  = ((Width * temp) << 16) | ((Width * temp) + 3);  

  /* Reconfigures the frame buffer line number */
  DVTT_Layerx->CFBLNR  = Height;  
  
}

/**
  * @brief  reconfigure layer pixel format.
  * @param  PixelFormat: reconfigure the pixel format, this parameter can be 
  *         one of the following values:@ref DVTT_Pixelformat.   
  * @param  DVTT_layerx: Select the layer to be configured, this parameter can be 
  *         one of the following values: DVTT_Layer1, DVTT_Layer2   
  * @retval Reload of the shadow registers values must be applied after layer 
  *         pixel format reconfiguration.
  */

void DVTT_LayerPixelFormat(DVTT_Layer_TypeDef* DVTT_Layerx, uint32_t PixelFormat)
{

  uint8_t temp;
  uint32_t tempreg;
  
  tempreg = DVTT_Layerx->PFCR;
  
  if (tempreg == DVTT_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (tempreg == DVTT_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((tempreg == DVTT_Pixelformat_ARGB4444) || \
          (tempreg == DVTT_Pixelformat_RGB565)    || \
          (tempreg == DVTT_Pixelformat_ARGB1555)  || \
          (tempreg == DVTT_Pixelformat_AL88))  
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }
  
  tempreg = (DVTT_Layerx->CFBLR >> 16);
  tempreg = (tempreg / temp); 
  
  if (PixelFormat == DVTT_Pixelformat_ARGB8888)
  {
    temp = 4;
  }
  else if (PixelFormat == DVTT_Pixelformat_RGB888)
  {
    temp = 3;
  }
  else if ((PixelFormat == DVTT_Pixelformat_ARGB4444) || \
          (PixelFormat == DVTT_Pixelformat_RGB565)    || \
          (PixelFormat == DVTT_Pixelformat_ARGB1555)  || \
          (PixelFormat == DVTT_Pixelformat_AL88))
  {
    temp = 2;  
  }
  else
  {
    temp = 1;
  }
  
  /* Reconfigures the color frame buffer pitch in byte */
  DVTT_Layerx->CFBLR  = ((tempreg * temp) << 16) | ((tempreg * temp) + 3);  

  /* Reconfigures the color frame buffer start address */
  DVTT_Layerx->PFCR = PixelFormat;
    
}
    
/**
  * @}
  */

/** @defgroup DVTT_Group2 Interrupts and flags management functions
 *  @brief   Interrupts and flags management functions
 *
@verbatim
 ===============================================================================
            ##### Interrupts and flags management functions #####
 ===============================================================================

    [..] This section provides functions allowing to configure the DVTT Interrupts 
         and to get the status and clear flags and Interrupts pending bits.
  
    [..] The DVTT provides 4 Interrupts sources and 4 Flags
    
    *** Flags ***
    =============
    [..]
      (+) DVTT_FLAG_LI:   Line Interrupt flag.
      (+) DVTT_FLAG_FU:   FIFO Underrun Interrupt flag.
      (+) DVTT_FLAG_TERR: Transfer Error Interrupt flag.
      (+) DVTT_FLAG_RR:   Register Reload interrupt flag.
      
    *** Interrupts ***
    ==================
    [..]
      (+) DVTT_IT_LI: Line Interrupt is generated when a programmed line 
                      is reached. The line interrupt position is programmed in 
                      the DVTT_LIPR register.
      (+) DVTT_IT_FU: FIFO Underrun interrupt is generated when a pixel is requested 
                      from an empty layer FIFO
      (+) DVTT_IT_TERR: Transfer Error interrupt is generated when an AHB bus 
                        error occurs during data transfer.
      (+) DVTT_IT_RR: Register Reload interrupt is generated when the shadow 
                      registers reload was performed during the vertical blanking 
                      period.
               
@endverbatim
  * @{
  */

/**
  * @brief  Enables or disables the specified DVTT's interrupts.
  * @param  DVTT_IT: specifies the DVTT interrupts sources to be enabled or disabled.
  *   This parameter can be any combination of the following values:
  *     @arg DVTT_IT_LI: Line Interrupt Enable.
  *     @arg DVTT_IT_FU: FIFO Underrun Interrupt Enable.
  *     @arg DVTT_IT_TERR: Transfer Error Interrupt Enable.
  *     @arg DVTT_IT_RR: Register Reload interrupt enable.  
  * @param NewState: new state of the specified DVTT interrupts.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void DVTT_ITConfig(uint32_t DVTT_IT, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_DVTT_IT(DVTT_IT));
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    DVTT->IER |= DVTT_IT;
  }
  else
  {
    DVTT->IER &= (uint32_t)~DVTT_IT;
  }
}

/**
  * @brief  Checks whether the specified DVTT's flag is set or not.
  * @param  DVTT_FLAG: specifies the flag to check.
  *   This parameter can be one of the following values:
  *     @arg DVTT_FLAG_LI:    Line Interrupt flag.
  *     @arg DVTT_FLAG_FU:   FIFO Underrun Interrupt flag.
  *     @arg DVTT_FLAG_TERR: Transfer Error Interrupt flag.
  *     @arg DVTT_FLAG_RR:   Register Reload interrupt flag.
  * @retval The new state of DVTT_FLAG (SET or RESET).
  */
FlagStatus DVTT_GetFlagStatus(uint32_t DVTT_FLAG)
{
  FlagStatus bitstatus = RESET;

  /* Check the parameters */
  assert_param(IS_DVTT_FLAG(DVTT_FLAG));

  if ((DVTT->ISR & DVTT_FLAG) != (uint32_t)RESET)
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
  * @brief  Clears the DVTT's pending flags.
  * @param  DVTT_FLAG: specifies the flag to clear.
  *   This parameter can be any combination of the following values:
  *     @arg DVTT_FLAG_LI:    Line Interrupt flag.
  *     @arg DVTT_FLAG_FU:   FIFO Underrun Interrupt flag.
  *     @arg DVTT_FLAG_TERR: Transfer Error Interrupt flag.
  *     @arg DVTT_FLAG_RR:   Register Reload interrupt flag.  
  * @retval None
  */
void DVTT_ClearFlag(uint32_t DVTT_FLAG)
{
  /* Check the parameters */
  assert_param(IS_DVTT_FLAG(DVTT_FLAG));

  /* Clear the corresponding DVTT flag */
  DVTT->ICR = (uint32_t)DVTT_FLAG;
}

/**
  * @brief  Checks whether the specified DVTT's interrupt has occurred or not.
  * @param  DVTT_IT: specifies the DVTT interrupts sources to check.
  *   This parameter can be one of the following values:
  *     @arg DVTT_IT_LI:    Line Interrupt Enable.
  *     @arg DVTT_IT_FU:   FIFO Underrun Interrupt Enable.
  *     @arg DVTT_IT_TERR: Transfer Error Interrupt Enable.
  *     @arg DVTT_IT_RR:   Register Reload interrupt Enable.
  * @retval The new state of the DVTT_IT (SET or RESET).
  */
ITStatus DVTT_GetITStatus(uint32_t DVTT_IT)
{
  ITStatus bitstatus = RESET;

  /* Check the parameters */
  assert_param(IS_DVTT_IT(DVTT_IT));

  if ((DVTT->ISR & DVTT_IT) != (uint32_t)RESET)
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }

  if (((DVTT->IER & DVTT_IT) != (uint32_t)RESET) && (bitstatus != (uint32_t)RESET))
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
  * @brief  Clears the DVTT's interrupt pending bits.
  * @param  DVTT_IT: specifies the interrupt pending bit to clear.
  *   This parameter can be any combination of the following values:
  *     @arg DVTT_IT_LIE:    Line Interrupt.
  *     @arg DVTT_IT_FUIE:   FIFO Underrun Interrupt.
  *     @arg DVTT_IT_TERRIE: Transfer Error Interrupt.
  *     @arg DVTT_IT_RRIE:   Register Reload interrupt.
  * @retval None
  */
void DVTT_ClearITPendingBit(uint32_t DVTT_IT)
{
  /* Check the parameters */
  assert_param(IS_DVTT_IT(DVTT_IT));

  /* Clear the corresponding DVTT Interrupt */
  DVTT->ICR = (uint32_t)DVTT_IT;
}

#endif /* CYBER_DVTT */

/******************* END OF FILE *******************/

