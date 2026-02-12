
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DVTT_H
#define __DVTT_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_DVTT

typedef enum{FALSE = 0, TRUE = !FALSE} bool;

/**
  * @brief LCD-TFT Display Controller
  */

typedef struct
{
  uint32_t      RESERVED0[2];  /*!< Reserved, 0x00-0x04 */
  __IO uint32_t SSCR;          /*!< DVTT Synchronization Size Configuration Register,    Address offset: 0x08 */
  __IO uint32_t BPCR;          /*!< DVTT Back Porch Configuration Register,              Address offset: 0x0C */
  __IO uint32_t AWCR;          /*!< DVTT Active Width Configuration Register,            Address offset: 0x10 */
  __IO uint32_t TWCR;          /*!< DVTT Total Width Configuration Register,             Address offset: 0x14 */
  __IO uint32_t GCR;           /*!< DVTT Global Control Register,                        Address offset: 0x18 */
  uint32_t      RESERVED1[2];  /*!< Reserved, 0x1C-0x20 */
  __IO uint32_t SRCR;          /*!< DVTT Shadow Reload Configuration Register,           Address offset: 0x24 */
  uint32_t      RESERVED2[1];  /*!< Reserved, 0x28 */
  __IO uint32_t BCCR;          /*!< DVTT Background Color Configuration Register,        Address offset: 0x2C */
  uint32_t      RESERVED3[1];  /*!< Reserved, 0x30 */
  __IO uint32_t IER;           /*!< DVTT Interrupt Enable Register,                      Address offset: 0x34 */
  __IO uint32_t ISR;           /*!< DVTT Interrupt Status Register,                      Address offset: 0x38 */
  __IO uint32_t ICR;           /*!< DVTT Interrupt Clear Register,                       Address offset: 0x3C */
  __IO uint32_t LIPCR;         /*!< DVTT Line Interrupt Position Configuration Register, Address offset: 0x40 */
  __IO uint32_t CPSR;          /*!< DVTT Current Position Status Register,               Address offset: 0x44 */
  __IO uint32_t CDSR;         /*!< DVTT Current Display Status Register,                       Address offset: 0x48 */
} DVTT_TypeDef;

/**
  * @brief LCD-TFT Display layer x Controller
  */

typedef struct
{
  __IO uint32_t CR;            /*!< DVTT Layerx Control Register                                  Address offset: 0x84 */
  __IO uint32_t WHPCR;         /*!< DVTT Layerx Window Horizontal Position Configuration Register Address offset: 0x88 */
  __IO uint32_t WVPCR;         /*!< DVTT Layerx Window Vertical Position Configuration Register   Address offset: 0x8C */
  __IO uint32_t CKCR;          /*!< DVTT Layerx Color Keying Configuration Register               Address offset: 0x90 */
  __IO uint32_t PFCR;          /*!< DVTT Layerx Pixel Format Configuration Register               Address offset: 0x94 */
  __IO uint32_t CACR;          /*!< DVTT Layerx Constant Alpha Configuration Register             Address offset: 0x98 */
  __IO uint32_t DCCR;          /*!< DVTT Layerx Default Color Configuration Register              Address offset: 0x9C */
  __IO uint32_t BFCR;          /*!< DVTT Layerx Blending Factors Configuration Register           Address offset: 0xA0 */
  uint32_t      RESERVED0[2];  /*!< Reserved */
  __IO uint32_t CFBAR;         /*!< DVTT Layerx Color Frame Buffer Address Register               Address offset: 0xAC */
  __IO uint32_t CFBLR;         /*!< DVTT Layerx Color Frame Buffer Length Register                Address offset: 0xB0 */
  __IO uint32_t CFBLNR;        /*!< DVTT Layerx ColorFrame Buffer Line Number Register            Address offset: 0xB4 */
  uint32_t      RESERVED1[3];  /*!< Reserved */
  __IO uint32_t CLUTWR;         /*!< DVTT Layerx CLUT Write Register                               Address offset: 0x144 */

} DVTT_Layer_TypeDef;

/**
  * @brief  DVTT Init structure definition
  */

typedef struct
{
  uint32_t DVTT_HSPolarity;            /*!< configures the horizontal synchronization polarity.
                                            This parameter can be one value of @ref DVTT_HSPolarity */
  uint32_t DVTT_VSPolarity;            /*!< configures the vertical synchronization polarity.
                                            This parameter can be one value of @ref DVTT_VSPolarity */
  uint32_t DVTT_DEPolarity;            /*!< configures the data enable polarity. This parameter can
                                            be one of value of @ref DVTT_DEPolarity */
  uint32_t DVTT_PCPolarity;            /*!< configures the pixel clock polarity. This parameter can
                                            be one of value of @ref DVTT_PCPolarity */
  uint32_t DVTT_HorizontalSync;        /*!< configures the number of Horizontal synchronization
                                            width. This parameter must range from 0x000 to 0xFFF. */
  uint32_t DVTT_VerticalSync;          /*!< configures the number of Vertical synchronization
                                            height. This parameter must range from 0x000 to 0x7FF. */
  uint32_t DVTT_AccumulatedHBP;        /*!< configures the accumulated horizontal back porch width.
                                            This parameter must range from DVTT_HorizontalSync to 0xFFF. */
  uint32_t DVTT_AccumulatedVBP;        /*!< configures the accumulated vertical back porch height.
                                            This parameter must range from DVTT_VerticalSync to 0x7FF. */
  uint32_t DVTT_AccumulatedActiveW;    /*!< configures the accumulated active width. This parameter
                                            must range from DVTT_AccumulatedHBP to 0xFFF. */
  uint32_t DVTT_AccumulatedActiveH;    /*!< configures the accumulated active height. This parameter
                                            must range from DVTT_AccumulatedVBP to 0x7FF. */
  uint32_t DVTT_TotalWidth;            /*!< configures the total width. This parameter
                                            must range from DVTT_AccumulatedActiveW to 0xFFF. */
  uint32_t DVTT_TotalHeigh;            /*!< configures the total height. This parameter
                                            must range from DVTT_AccumulatedActiveH to 0x7FF. */
  uint32_t DVTT_BackgroundRedValue;    /*!< configures the background red value.
                                            This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_BackgroundGreenValue;  /*!< configures the background green value.
                                            This parameter must range from 0x00 to 0xFF. */
   uint32_t DVTT_BackgroundBlueValue;  /*!< configures the background blue value.
                                            This parameter must range from 0x00 to 0xFF. */
} DVTT_InitTypeDef;

/**
  * @brief  DVTT Layer structure definition
  */

typedef struct {
  uint16_t hsync, hback, hdisp, hfront, htotal;
  uint16_t vsync, vback, vdisp, vfront, vtotal;
  bool vspol, hspol, depol, pcpol;
} DVTiming;

/**
  * @brief  DVTT Layer structure definition
  */

typedef struct
{
  uint32_t DVTT_HorizontalStart;    /*!< Configures the Window Horizontal Start Position.
                                      This parameter must range from 0x000 to 0xFFF. */
  uint32_t DVTT_HorizontalStop;     /*!< Configures the Window Horizontal Stop Position.
                                      This parameter must range from 0x0000 to 0xFFFF. */
  uint32_t DVTT_VerticalStart;      /*!< Configures the Window vertical Start Position.
                                      This parameter must range from 0x000 to 0xFFF. */
  uint32_t DVTT_VerticalStop;       /*!< Configures the Window vaertical Stop Position.
                                      This parameter must range from 0x0000 to 0xFFFF. */
  uint32_t DVTT_PixelFormat;        /*!< Specifies the pixel format. This parameter can be
                                      one of value of @ref DVTT_Pixelformat */
  uint32_t DVTT_ConstantAlpha;      /*!< Specifies the constant alpha used for blending.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_DefaultColorBlue;   /*!< Configures the default blue value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_DefaultColorGreen;  /*!< Configures the default green value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_DefaultColorRed;    /*!< Configures the default red value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_DefaultColorAlpha;  /*!< Configures the default alpha value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_BlendingFactor_1;   /*!< Select the blending factor 1. This parameter
                                      can be one of value of @ref DVTT_BlendingFactor1 */
  uint32_t DVTT_BlendingFactor_2;   /*!< Select the blending factor 2. This parameter
                                      can be one of value of @ref DVTT_BlendingFactor2 */
  uint32_t DVTT_CFBStartAdress;     /*!< Configures the color frame buffer address */
  uint32_t DVTT_CFBLineLength;      /*!< Configures the color frame buffer line length.
                                      This parameter must range from 0x0000 to 0x1FFF. */
  uint32_t DVTT_CFBPitch;           /*!< Configures the color frame buffer pitch in bytes.
                                      This parameter must range from 0x0000 to 0x1FFF. */
  uint32_t DVTT_CFBLineNumber;      /*!< Specifies the number of line in frame buffer.
                                      This parameter must range from 0x000 to 0x7FF. */
} DVTT_Layer_InitTypeDef;

/**
  * @brief  DVTT Position structure definition
  */
typedef struct
{
  uint32_t DVTT_POSX;                         /*!<  Current X Position */
  uint32_t DVTT_POSY;                         /*!<  Current Y Position */
} DVTT_PosTypeDef;

/**
  * @brief  DVTT RGB structure definition
  */
typedef struct
{
  uint32_t DVTT_BlueWidth;                        /*!< Blue width */
  uint32_t DVTT_GreenWidth;                       /*!< Green width */
  uint32_t DVTT_RedWidth;                         /*!< Red width */
} DVTT_RGBTypeDef;

/**
  * @brief  DVTT Color Keying structure definition
  */
typedef struct
{
  uint32_t DVTT_ColorKeyBlue;               /*!< Configures the color key blue value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_ColorKeyGreen;              /*!< Configures the color key green value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_ColorKeyRed;                /*!< Configures the color key red value.
                                                 This parameter must range from 0x00 to 0xFF. */
} DVTT_ColorKeying_InitTypeDef;

/**
  * @brief  DVTT CLUT structure definition
  */
typedef struct
{
  uint32_t DVTT_CLUTAdress;                 /*!< Configures the CLUT address.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_BlueValue;                  /*!< Configures the blue value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_GreenValue;                 /*!< Configures the green value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTT_RedValue;                   /*!< Configures the red value.
                                                 This parameter must range from 0x00 to 0xFF. */
} DVTT_CLUT_InitTypeDef;

/******************************************************************************/
/*                                                                            */
/*                      LCD-TFT Display Controller (DVTT)                     */
/*                                                                            */
/******************************************************************************/

/********************  Bit definition for DVTT_SSCR register  *****************/

#define DVTT_SSCR_VSH                       ((uint32_t)0x000007FF)              /*!< Vertical Synchronization Height */
#define DVTT_SSCR_HSW                       ((uint32_t)0x0FFF0000)              /*!< Horizontal Synchronization Width */

/********************  Bit definition for DVTT_BPCR register  *****************/

#define DVTT_BPCR_AVBP                      ((uint32_t)0x000007FF)              /*!< Accumulated Vertical Back Porch */
#define DVTT_BPCR_AHBP                      ((uint32_t)0x0FFF0000)              /*!< Accumulated Horizontal Back Porch */

/********************  Bit definition for DVTT_AWCR register  *****************/

#define DVTT_AWCR_AAH                       ((uint32_t)0x000007FF)              /*!< Accumulated Active heigh */
#define DVTT_AWCR_AAW                       ((uint32_t)0x0FFF0000)              /*!< Accumulated Active Width */

/********************  Bit definition for DVTT_TWCR register  *****************/

#define DVTT_TWCR_TOTALH                    ((uint32_t)0x000007FF)              /*!< Total Heigh */
#define DVTT_TWCR_TOTALW                    ((uint32_t)0x0FFF0000)              /*!< Total Width */

/********************  Bit definition for DVTT_GCR register  ******************/

#define DVTT_GCR_DVTTEN                     ((uint32_t)0x00000001)              /*!< LCD-TFT controller enable bit */
#define DVTT_GCR_DBW                        ((uint32_t)0x00000070)              /*!< Dither Blue Width */
#define DVTT_GCR_DGW                        ((uint32_t)0x00000700)              /*!< Dither Green Width */
#define DVTT_GCR_DRW                        ((uint32_t)0x00007000)              /*!< Dither Red Width */
#define DVTT_GCR_DEN                        ((uint32_t)0x00010000)              /*!< Dither Enable */
#define DVTT_GCR_PCPOL                      ((uint32_t)0x10000000)              /*!< Pixel Clock Polarity */
#define DVTT_GCR_DEPOL                      ((uint32_t)0x20000000)              /*!< Data Enable Polarity */
#define DVTT_GCR_VSPOL                      ((uint32_t)0x40000000)              /*!< Vertical Synchronization Polarity */
#define DVTT_GCR_HSPOL                      ((uint32_t)0x80000000)              /*!< Horizontal Synchronization Polarity */

/* Legacy defines */
#define DVTT_GCR_DTEN                       DVTT_GCR_DEN

/********************  Bit definition for DVTT_SRCR register  *****************/

#define DVTT_SRCR_IMR                      ((uint32_t)0x00000001)               /*!< Immediate Reload */
#define DVTT_SRCR_VBR                      ((uint32_t)0x00000002)               /*!< Vertical Blanking Reload */

/********************  Bit definition for DVTT_BCCR register  *****************/

#define DVTT_BCCR_BCBLUE                    ((uint32_t)0x000000FF)              /*!< Background Blue value */
#define DVTT_BCCR_BCGREEN                   ((uint32_t)0x0000FF00)              /*!< Background Green value */
#define DVTT_BCCR_BCRED                     ((uint32_t)0x00FF0000)              /*!< Background Red value */

/********************  Bit definition for DVTT_IER register  ******************/

#define DVTT_IER_LIE                        ((uint32_t)0x00000001)              /*!< Line Interrupt Enable */
#define DVTT_IER_FUIE                       ((uint32_t)0x00000002)              /*!< FIFO Underrun Interrupt Enable */
#define DVTT_IER_TERRIE                     ((uint32_t)0x00000004)              /*!< Transfer Error Interrupt Enable */
#define DVTT_IER_RRIE                       ((uint32_t)0x00000008)              /*!< Register Reload interrupt enable */

/********************  Bit definition for DVTT_ISR register  ******************/

#define DVTT_ISR_LIF                        ((uint32_t)0x00000001)              /*!< Line Interrupt Flag */
#define DVTT_ISR_FUIF                       ((uint32_t)0x00000002)              /*!< FIFO Underrun Interrupt Flag */
#define DVTT_ISR_TERRIF                     ((uint32_t)0x00000004)              /*!< Transfer Error Interrupt Flag */
#define DVTT_ISR_RRIF                       ((uint32_t)0x00000008)              /*!< Register Reload interrupt Flag */

/********************  Bit definition for DVTT_ICR register  ******************/

#define DVTT_ICR_CLIF                       ((uint32_t)0x00000001)              /*!< Clears the Line Interrupt Flag */
#define DVTT_ICR_CFUIF                      ((uint32_t)0x00000002)              /*!< Clears the FIFO Underrun Interrupt Flag */
#define DVTT_ICR_CTERRIF                    ((uint32_t)0x00000004)              /*!< Clears the Transfer Error Interrupt Flag */
#define DVTT_ICR_CRRIF                      ((uint32_t)0x00000008)              /*!< Clears Register Reload interrupt Flag */

/********************  Bit definition for DVTT_LIPCR register  ****************/

#define DVTT_LIPCR_LIPOS                    ((uint32_t)0x000007FF)              /*!< Line Interrupt Position */

/********************  Bit definition for DVTT_CPSR register  *****************/

#define DVTT_CPSR_CYPOS                     ((uint32_t)0x0000FFFF)              /*!< Current Y Position */
#define DVTT_CPSR_CXPOS                     ((uint32_t)0xFFFF0000)              /*!< Current X Position */

/********************  Bit definition for DVTT_CDSR register  *****************/

#define DVTT_CDSR_VDES                      ((uint32_t)0x00000001)              /*!< Vertical Data Enable Status */
#define DVTT_CDSR_HDES                      ((uint32_t)0x00000002)              /*!< Horizontal Data Enable Status */
#define DVTT_CDSR_VSYNCS                    ((uint32_t)0x00000004)              /*!< Vertical Synchronization Status */
#define DVTT_CDSR_HSYNCS                    ((uint32_t)0x00000008)              /*!< Horizontal Synchronization Status */

/********************  Bit definition for DVTT_LxCR register  *****************/

#define DVTT_LxCR_LEN                       ((uint32_t)0x00000001)              /*!< Layer Enable */
#define DVTT_LxCR_COLKEN                    ((uint32_t)0x00000002)              /*!< Color Keying Enable */
#define DVTT_LxCR_CLUTEN                    ((uint32_t)0x00000010)              /*!< Color Lockup Table Enable */

/********************  Bit definition for DVTT_LxWHPCR register  **************/

#define DVTT_LxWHPCR_WHSTPOS                ((uint32_t)0x00000FFF)              /*!< Window Horizontal Start Position */
#define DVTT_LxWHPCR_WHSPPOS                ((uint32_t)0xFFFF0000)              /*!< Window Horizontal Stop Position */

/********************  Bit definition for DVTT_LxWVPCR register  **************/

#define DVTT_LxWVPCR_WVSTPOS                ((uint32_t)0x00000FFF)              /*!< Window Vertical Start Position */
#define DVTT_LxWVPCR_WVSPPOS                ((uint32_t)0xFFFF0000)              /*!< Window Vertical Stop Position */

/********************  Bit definition for DVTT_LxCKCR register  ***************/

#define DVTT_LxCKCR_CKBLUE                  ((uint32_t)0x000000FF)              /*!< Color Key Blue value */
#define DVTT_LxCKCR_CKGREEN                 ((uint32_t)0x0000FF00)              /*!< Color Key Green value */
#define DVTT_LxCKCR_CKRED                   ((uint32_t)0x00FF0000)              /*!< Color Key Red value */

/********************  Bit definition for DVTT_LxPFCR register  ***************/

#define DVTT_LxPFCR_PF                      ((uint32_t)0x00000007)              /*!< Pixel Format */

/********************  Bit definition for DVTT_LxCACR register  ***************/

#define DVTT_LxCACR_CONSTA                  ((uint32_t)0x000000FF)              /*!< Constant Alpha */

/********************  Bit definition for DVTT_LxDCCR register  ***************/

#define DVTT_LxDCCR_DCBLUE                  ((uint32_t)0x000000FF)              /*!< Default Color Blue */
#define DVTT_LxDCCR_DCGREEN                 ((uint32_t)0x0000FF00)              /*!< Default Color Green */
#define DVTT_LxDCCR_DCRED                   ((uint32_t)0x00FF0000)              /*!< Default Color Red */
#define DVTT_LxDCCR_DCALPHA                 ((uint32_t)0xFF000000)              /*!< Default Color Alpha */

/********************  Bit definition for DVTT_LxBFCR register  ***************/

#define DVTT_LxBFCR_BF2                     ((uint32_t)0x00000007)              /*!< Blending Factor 2 */
#define DVTT_LxBFCR_BF1                     ((uint32_t)0x00000700)              /*!< Blending Factor 1 */

/********************  Bit definition for DVTT_LxCFBAR register  **************/

#define DVTT_LxCFBAR_CFBADD                 ((uint32_t)0xFFFFFFFF)              /*!< Color Frame Buffer Start Address */

/********************  Bit definition for DVTT_LxCFBLR register  **************/

#define DVTT_LxCFBLR_CFBLL                  ((uint32_t)0x00001FFF)              /*!< Color Frame Buffer Line Length */
#define DVTT_LxCFBLR_CFBP                   ((uint32_t)0x1FFF0000)              /*!< Color Frame Buffer Pitch in bytes */

/********************  Bit definition for DVTT_LxCFBLNR register  *************/

#define DVTT_LxCFBLNR_CFBLNBR               ((uint32_t)0x000007FF)              /*!< Frame Buffer Line Number */

/********************  Bit definition for DVTT_LxCLUTWR register  *************/

#define DVTT_LxCLUTWR_BLUE                  ((uint32_t)0x000000FF)              /*!< Blue value */
#define DVTT_LxCLUTWR_GREEN                 ((uint32_t)0x0000FF00)              /*!< Green value */
#define DVTT_LxCLUTWR_RED                   ((uint32_t)0x00FF0000)              /*!< Red value */
#define DVTT_LxCLUTWR_CLUTADD               ((uint32_t)0xFF000000)              /*!< CLUT address */

/* Exported constants --------------------------------------------------------*/
/** @defgroup DVTT_Exported_Constants
  * @{
  */

/** @defgroup DVTT_SYNC
  * @{
  */

#define DVTT_HorizontalSYNC               ((uint32_t)0x00000FFF)
#define DVTT_VerticalSYNC                 ((uint32_t)0x000007FF)

#define IS_DVTT_HSYNC(HSYNC) ((HSYNC) <= DVTT_HorizontalSYNC)
#define IS_DVTT_VSYNC(VSYNC) ((VSYNC) <= DVTT_VerticalSYNC)
#define IS_DVTT_AHBP(AHBP)  ((AHBP) <= DVTT_HorizontalSYNC)
#define IS_DVTT_AVBP(AVBP) ((AVBP) <= DVTT_VerticalSYNC)
#define IS_DVTT_AAW(AAW)   ((AAW) <= DVTT_HorizontalSYNC)
#define IS_DVTT_AAH(AAH) ((AAH) <= DVTT_VerticalSYNC)
#define IS_DVTT_TOTALW(TOTALW) ((TOTALW) <= DVTT_HorizontalSYNC)
#define IS_DVTT_TOTALH(TOTALH) ((TOTALH) <= DVTT_VerticalSYNC)
/**
  * @}
  */

/** @defgroup DVTT_HSPolarity
  * @{
  */
#define DVTT_HSPolarity_AL                ((uint32_t)0x00000000)                /*!< Horizontal Synchronization is active low. */
#define DVTT_HSPolarity_AH                DVTT_GCR_HSPOL                        /*!< Horizontal Synchronization is active high. */

#define IS_DVTT_HSPOL(HSPOL) (((HSPOL) == DVTT_HSPolarity_AL) || \
                              ((HSPOL) == DVTT_HSPolarity_AH))
/**
  * @}
  */

/** @defgroup DVTT_VSPolarity
  * @{
  */
#define DVTT_VSPolarity_AL                ((uint32_t)0x00000000)                /*!< Vertical Synchronization is active low. */
#define DVTT_VSPolarity_AH                DVTT_GCR_VSPOL                        /*!< Vertical Synchronization is active high. */

#define IS_DVTT_VSPOL(VSPOL) (((VSPOL) == DVTT_VSPolarity_AL) || \
                              ((VSPOL) == DVTT_VSPolarity_AH))
/**
  * @}
  */

/** @defgroup DVTT_DEPolarity
  * @{
  */
#define DVTT_DEPolarity_AL                ((uint32_t)0x00000000)                /*!< Data Enable, is active low. */
#define DVTT_DEPolarity_AH                DVTT_GCR_DEPOL                        /*!< Data Enable, is active high. */

#define IS_DVTT_DEPOL(DEPOL) (((DEPOL) ==  DVTT_VSPolarity_AL) || \
                              ((DEPOL) ==  DVTT_DEPolarity_AH))
/**
  * @}
  */

/** @defgroup DVTT_PCPolarity
  * @{
  */
#define DVTT_PCPolarity_IPC               ((uint32_t)0x00000000)                /*!< input pixel clock. */
#define DVTT_PCPolarity_IIPC              DVTT_GCR_PCPOL                        /*!< inverted input pixel clock. */

#define IS_DVTT_PCPOL(PCPOL) (((PCPOL) ==  DVTT_PCPolarity_IPC) || \
                              ((PCPOL) ==  DVTT_PCPolarity_IIPC))
/**
  * @}
  */

/** @defgroup DVTT_Reload
  * @{
  */
#define DVTT_IMReload                     DVTT_SRCR_IMR                         /*!< Immediately Reload. */
#define DVTT_VBReload                     DVTT_SRCR_VBR                         /*!< Vertical Blanking Reload. */

#define IS_DVTT_RELOAD(RELOAD) (((RELOAD) == DVTT_IMReload) || \
                                ((RELOAD) == DVTT_VBReload))
/**
  * @}
  */

/** @defgroup DVTT_Back_Color
  * @{
  */
#define DVTT_Back_Color                   ((uint32_t)0x000000FF)

#define IS_DVTT_BackBlueValue(BBLUE)    ((BBLUE) <= DVTT_Back_Color)
#define IS_DVTT_BackGreenValue(BGREEN)  ((BGREEN) <= DVTT_Back_Color)
#define IS_DVTT_BackRedValue(BRED)      ((BRED) <= DVTT_Back_Color)
/**
  * @}
  */

/** @defgroup DVTT_Position
  * @{
  */
#define DVTT_POS_CY                       DVTT_CPSR_CYPOS
#define DVTT_POS_CX                       DVTT_CPSR_CXPOS

#define IS_DVTT_GET_POS(POS) (((POS) <= DVTT_POS_CY))
/**
  * @}
  */

/** @defgroup DVTT_LIPosition
  * @{
  */
#define IS_DVTT_LIPOS(LIPOS) ((LIPOS) <= 0x7FF)
/**
  * @}
  */

/** @defgroup DVTT_CurrentStatus
  * @{
  */
#define DVTT_CD_VDES                     DVTT_CDSR_VDES
#define DVTT_CD_HDES                     DVTT_CDSR_HDES
#define DVTT_CD_VSYNC                    DVTT_CDSR_VSYNCS
#define DVTT_CD_HSYNC                    DVTT_CDSR_HSYNCS

#define IS_DVTT_GET_CD(CD) (((CD) == DVTT_CD_VDES) || ((CD) == DVTT_CD_HDES) || \
                              ((CD) == DVTT_CD_VSYNC) || ((CD) == DVTT_CD_HSYNC))
/**
  * @}
  */

/** @defgroup DVTT_Interrupts
  * @{
  */
#define DVTT_IT_LI                      DVTT_IER_LIE
#define DVTT_IT_FU                      DVTT_IER_FUIE
#define DVTT_IT_TERR                    DVTT_IER_TERRIE
#define DVTT_IT_RR                      DVTT_IER_RRIE

#define IS_DVTT_IT(IT) ((((IT) & (uint32_t)0xFFFFFFF0) == 0x00) && ((IT) != 0x00))

/**
  * @}
  */

/** @defgroup DVTT_Flag
  * @{
  */
#define DVTT_FLAG_LI                     DVTT_ISR_LIF
#define DVTT_FLAG_FU                     DVTT_ISR_FUIF
#define DVTT_FLAG_TERR                   DVTT_ISR_TERRIF
#define DVTT_FLAG_RR                     DVTT_ISR_RRIF

#define IS_DVTT_FLAG(FLAG) (((FLAG) == DVTT_FLAG_LI) || ((FLAG) == DVTT_FLAG_FU) || \
                               ((FLAG) == DVTT_FLAG_TERR) || ((FLAG) == DVTT_FLAG_RR))
/**
  * @}
  */

/** @defgroup DVTT_Pixelformat
  * @{
  */
#define DVTT_Pixelformat_ARGB8888                  ((uint32_t)0x00000000)
#define DVTT_Pixelformat_RGB888                    ((uint32_t)0x00000001)
#define DVTT_Pixelformat_RGB565                    ((uint32_t)0x00000002)
#define DVTT_Pixelformat_ARGB1555                  ((uint32_t)0x00000003)
#define DVTT_Pixelformat_ARGB4444                  ((uint32_t)0x00000004)
#define DVTT_Pixelformat_L8                        ((uint32_t)0x00000005)
#define DVTT_Pixelformat_AL44                      ((uint32_t)0x00000006)
#define DVTT_Pixelformat_AL88                      ((uint32_t)0x00000007)

#define IS_DVTT_Pixelformat(Pixelformat) (((Pixelformat) == DVTT_Pixelformat_ARGB8888) || ((Pixelformat) == DVTT_Pixelformat_RGB888)   || \
                        ((Pixelformat) == DVTT_Pixelformat_RGB565)   || ((Pixelformat) == DVTT_Pixelformat_ARGB1555) || \
                        ((Pixelformat) == DVTT_Pixelformat_ARGB4444) || ((Pixelformat) == DVTT_Pixelformat_L8)       || \
                        ((Pixelformat) == DVTT_Pixelformat_AL44)     || ((Pixelformat) == DVTT_Pixelformat_AL88))

/**
  * @}
  */

/** @defgroup DVTT_BlendingFactor1
  * @{
  */
#define DVTT_BlendingFactor1_CA                       ((uint32_t)0x00000400)
#define DVTT_BlendingFactor1_PAxCA                    ((uint32_t)0x00000600)

#define IS_DVTT_BlendingFactor1(BlendingFactor1) (((BlendingFactor1) == DVTT_BlendingFactor1_CA) || ((BlendingFactor1) == DVTT_BlendingFactor1_PAxCA))
/**
  * @}
  */

/** @defgroup DVTT_BlendingFactor2
  * @{
  */
#define DVTT_BlendingFactor2_CA                       ((uint32_t)0x00000005)
#define DVTT_BlendingFactor2_PAxCA                    ((uint32_t)0x00000007)

#define IS_DVTT_BlendingFactor2(BlendingFactor2) (((BlendingFactor2) == DVTT_BlendingFactor2_CA) || ((BlendingFactor2) == DVTT_BlendingFactor2_PAxCA))
/**
  * @}
  */

/** @defgroup DVTT_LAYER_Config
  * @{
  */
#define DVTT_STOPPosition                 ((uint32_t)0x0000FFFF)
#define DVTT_STARTPosition                ((uint32_t)0x00000FFF)

#define DVTT_DefaultColorConfig           ((uint32_t)0x000000FF)
#define DVTT_ColorFrameBuffer             ((uint32_t)0x00001FFF)
#define DVTT_LineNumber                   ((uint32_t)0x000007FF)

#define IS_DVTT_HCONFIGST(HCONFIGST) ((HCONFIGST) <= DVTT_STARTPosition)
#define IS_DVTT_HCONFIGSP(HCONFIGSP) ((HCONFIGSP) <= DVTT_STOPPosition)
#define IS_DVTT_VCONFIGST(VCONFIGST)  ((VCONFIGST) <= DVTT_STARTPosition)
#define IS_DVTT_VCONFIGSP(VCONFIGSP) ((VCONFIGSP) <= DVTT_STOPPosition)

#define IS_DVTT_DEFAULTCOLOR(DEFAULTCOLOR) ((DEFAULTCOLOR) <= DVTT_DefaultColorConfig)

#define IS_DVTT_CFBP(CFBP) ((CFBP) <= DVTT_ColorFrameBuffer)
#define IS_DVTT_CFBLL(CFBLL) ((CFBLL) <= DVTT_ColorFrameBuffer)

#define IS_DVTT_CFBLNBR(CFBLNBR) ((CFBLNBR) <= DVTT_LineNumber)
/**
  * @}
  */

/** @defgroup DVTT_colorkeying_Config
  * @{
  */
#define DVTT_colorkeyingConfig            ((uint32_t)0x000000FF)

#define IS_DVTT_CKEYING(CKEYING) ((CKEYING) <= DVTT_colorkeyingConfig)
/**
  * @}
  */

/** @defgroup DVTT_CLUT_Config
  * @{
  */

#define DVTT_CLUTWR                       ((uint32_t)0x000000FF)

#define IS_DVTT_CLUTWR(CLUTWR)  ((CLUTWR) <= DVTT_CLUTWR)

/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
/*  Function used to set the DVTT configuration to the default reset state *****/
void DVTT_DeInit(void);

/* Initialization and Configuration functions *********************************/
void DVTT_Init(DVTT_InitTypeDef* DVTT_InitStruct);
void DVTT_StructInit(DVTT_InitTypeDef* DVTT_InitStruct);
void DVTT_Cmd(FunctionalState NewState);
void DVTT_DitherCmd(FunctionalState NewState);
DVTT_RGBTypeDef DVTT_GetRGBWidth(void);
void DVTT_RGBStructInit(DVTT_RGBTypeDef* DVTT_RGB_InitStruct);
void DVTT_LIPConfig(uint32_t DVTT_LIPositionConfig);
void DVTT_ReloadConfig(uint32_t DVTT_Reload);
void DVTT_LayerInit(DVTT_Layer_TypeDef* DVTT_Layerx, DVTT_Layer_InitTypeDef* DVTT_Layer_InitStruct);
void DVTT_LayerStructInit(DVTT_Layer_InitTypeDef * DVTT_Layer_InitStruct);
void DVTT_LayerCmd(DVTT_Layer_TypeDef* DVTT_Layerx, FunctionalState NewState);
DVTT_PosTypeDef DVTT_GetPosStatus(void);
void DVTT_PosStructInit(DVTT_PosTypeDef* DVTT_Pos_InitStruct);
FlagStatus DVTT_GetCDStatus(uint32_t DVTT_CD);
void DVTT_ColorKeyingConfig(DVTT_Layer_TypeDef* DVTT_Layerx, DVTT_ColorKeying_InitTypeDef* DVTT_colorkeying_InitStruct, FunctionalState NewState);
void DVTT_ColorKeyingStructInit(DVTT_ColorKeying_InitTypeDef* DVTT_colorkeying_InitStruct);
void DVTT_CLUTCmd(DVTT_Layer_TypeDef* DVTT_Layerx, FunctionalState NewState);
void DVTT_CLUTInit(DVTT_Layer_TypeDef* DVTT_Layerx, DVTT_CLUT_InitTypeDef* DVTT_CLUT_InitStruct);
void DVTT_CLUTStructInit(DVTT_CLUT_InitTypeDef* DVTT_CLUT_InitStruct);
void DVTT_LayerPosition(DVTT_Layer_TypeDef* DVTT_Layerx, uint16_t OffsetX, uint16_t OffsetY);
void DVTT_LayerAlpha(DVTT_Layer_TypeDef* DVTT_Layerx, uint8_t ConstantAlpha);
void DVTT_LayerAddress(DVTT_Layer_TypeDef* DVTT_Layerx, uint32_t Address);
void DVTT_LayerSize(DVTT_Layer_TypeDef* DVTT_Layerx, uint32_t Width, uint32_t Height);
void DVTT_LayerPixelFormat(DVTT_Layer_TypeDef* DVTT_Layerx, uint32_t PixelFormat);

/* Interrupts and flags management functions **********************************/
void DVTT_ITConfig(uint32_t DVTT_IT, FunctionalState NewState);
FlagStatus DVTT_GetFlagStatus(uint32_t DVTT_FLAG);
void DVTT_ClearFlag(uint32_t DVTT_FLAG);
ITStatus DVTT_GetITStatus(uint32_t DVTT_IT);
void DVTT_ClearITPendingBit(uint32_t DVTT_IT);


#endif /* CYBER_DVTT */
#endif /* __DVTT_H */
