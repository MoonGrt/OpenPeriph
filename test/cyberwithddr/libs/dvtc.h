
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DVTC_H
#define __DVTC_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_DVTC

/**
  * @brief LCD-TFT Display Controller
  */

typedef struct
{
  uint32_t      RESERVED0[2];  /*!< Reserved, 0x00-0x04 */
  __IO uint32_t SSCR;          /*!< DVTC Synchronization Size Configuration Register,    Address offset: 0x08 */
  __IO uint32_t BPCR;          /*!< DVTC Back Porch Configuration Register,              Address offset: 0x0C */
  __IO uint32_t AWCR;          /*!< DVTC Active Width Configuration Register,            Address offset: 0x10 */
  __IO uint32_t TWCR;          /*!< DVTC Total Width Configuration Register,             Address offset: 0x14 */
  __IO uint32_t GCR;           /*!< DVTC Global Control Register,                        Address offset: 0x18 */
  uint32_t      RESERVED1[2];  /*!< Reserved, 0x1C-0x20 */
  __IO uint32_t SRCR;          /*!< DVTC Shadow Reload Configuration Register,           Address offset: 0x24 */
  uint32_t      RESERVED2[1];  /*!< Reserved, 0x28 */
  __IO uint32_t BCCR;          /*!< DVTC Background Color Configuration Register,        Address offset: 0x2C */
  uint32_t      RESERVED3[1];  /*!< Reserved, 0x30 */
  __IO uint32_t IER;           /*!< DVTC Interrupt Enable Register,                      Address offset: 0x34 */
  __IO uint32_t ISR;           /*!< DVTC Interrupt Status Register,                      Address offset: 0x38 */
  __IO uint32_t ICR;           /*!< DVTC Interrupt Clear Register,                       Address offset: 0x3C */
  __IO uint32_t LIPCR;         /*!< DVTC Line Interrupt Position Configuration Register, Address offset: 0x40 */
  __IO uint32_t CPSR;          /*!< DVTC Current Position Status Register,               Address offset: 0x44 */
  __IO uint32_t CDSR;         /*!< DVTC Current Display Status Register,                       Address offset: 0x48 */
} DVTC_TypeDef;

/**
  * @brief LCD-TFT Display layer x Controller
  */

typedef struct
{
  __IO uint32_t CR;            /*!< DVTC Layerx Control Register                                  Address offset: 0x84 */
  __IO uint32_t WHPCR;         /*!< DVTC Layerx Window Horizontal Position Configuration Register Address offset: 0x88 */
  __IO uint32_t WVPCR;         /*!< DVTC Layerx Window Vertical Position Configuration Register   Address offset: 0x8C */
  __IO uint32_t CKCR;          /*!< DVTC Layerx Color Keying Configuration Register               Address offset: 0x90 */
  __IO uint32_t PFCR;          /*!< DVTC Layerx Pixel Format Configuration Register               Address offset: 0x94 */
  __IO uint32_t CACR;          /*!< DVTC Layerx Constant Alpha Configuration Register             Address offset: 0x98 */
  __IO uint32_t DCCR;          /*!< DVTC Layerx Default Color Configuration Register              Address offset: 0x9C */
  __IO uint32_t BFCR;          /*!< DVTC Layerx Blending Factors Configuration Register           Address offset: 0xA0 */
  uint32_t      RESERVED0[2];  /*!< Reserved */
  __IO uint32_t CFBAR;         /*!< DVTC Layerx Color Frame Buffer Address Register               Address offset: 0xAC */
  __IO uint32_t CFBLR;         /*!< DVTC Layerx Color Frame Buffer Length Register                Address offset: 0xB0 */
  __IO uint32_t CFBLNR;        /*!< DVTC Layerx ColorFrame Buffer Line Number Register            Address offset: 0xB4 */
  uint32_t      RESERVED1[3];  /*!< Reserved */
  __IO uint32_t CLUTWR;         /*!< DVTC Layerx CLUT Write Register                               Address offset: 0x144 */

} DVTC_Layer_TypeDef;

/**
  * @brief  DVTC Init structure definition
  */

typedef struct
{
  uint32_t DVTC_HSPolarity;            /*!< configures the horizontal synchronization polarity.
                                            This parameter can be one value of @ref DVTC_HSPolarity */
  uint32_t DVTC_VSPolarity;            /*!< configures the vertical synchronization polarity.
                                            This parameter can be one value of @ref DVTC_VSPolarity */
  uint32_t DVTC_DEPolarity;            /*!< configures the data enable polarity. This parameter can
                                            be one of value of @ref DVTC_DEPolarity */
  uint32_t DVTC_PCPolarity;            /*!< configures the pixel clock polarity. This parameter can
                                            be one of value of @ref DVTC_PCPolarity */
  uint32_t DVTC_HorizontalSync;        /*!< configures the number of Horizontal synchronization
                                            width. This parameter must range from 0x000 to 0xFFF. */
  uint32_t DVTC_VerticalSync;          /*!< configures the number of Vertical synchronization
                                            height. This parameter must range from 0x000 to 0x7FF. */
  uint32_t DVTC_AccumulatedHBP;        /*!< configures the accumulated horizontal back porch width.
                                            This parameter must range from DVTC_HorizontalSync to 0xFFF. */
  uint32_t DVTC_AccumulatedVBP;        /*!< configures the accumulated vertical back porch height.
                                            This parameter must range from DVTC_VerticalSync to 0x7FF. */
  uint32_t DVTC_AccumulatedActiveW;    /*!< configures the accumulated active width. This parameter
                                            must range from DVTC_AccumulatedHBP to 0xFFF. */
  uint32_t DVTC_AccumulatedActiveH;    /*!< configures the accumulated active height. This parameter
                                            must range from DVTC_AccumulatedVBP to 0x7FF. */
  uint32_t DVTC_TotalWidth;            /*!< configures the total width. This parameter
                                            must range from DVTC_AccumulatedActiveW to 0xFFF. */
  uint32_t DVTC_TotalHeigh;            /*!< configures the total height. This parameter
                                            must range from DVTC_AccumulatedActiveH to 0x7FF. */
  uint32_t DVTC_BackgroundRedValue;    /*!< configures the background red value.
                                            This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_BackgroundGreenValue;  /*!< configures the background green value.
                                            This parameter must range from 0x00 to 0xFF. */
   uint32_t DVTC_BackgroundBlueValue;  /*!< configures the background blue value.
                                            This parameter must range from 0x00 to 0xFF. */
} DVTC_InitTypeDef;

/**
  * @brief  DVTC Layer structure definition
  */

typedef struct {
  uint16_t hsync, hback, hdisp, hfront, htotal;
  uint16_t vsync, vback, vdisp, vfront, vtotal;
  bool vspol, hspol, depol, pcpol;
} DVTiming;

/**
  * @brief  DVTC Layer structure definition
  */

typedef struct
{
  uint32_t DVTC_HorizontalStart;    /*!< Configures the Window Horizontal Start Position.
                                      This parameter must range from 0x000 to 0xFFF. */
  uint32_t DVTC_HorizontalStop;     /*!< Configures the Window Horizontal Stop Position.
                                      This parameter must range from 0x0000 to 0xFFFF. */
  uint32_t DVTC_VerticalStart;      /*!< Configures the Window vertical Start Position.
                                      This parameter must range from 0x000 to 0xFFF. */
  uint32_t DVTC_VerticalStop;       /*!< Configures the Window vaertical Stop Position.
                                      This parameter must range from 0x0000 to 0xFFFF. */
  uint32_t DVTC_PixelFormat;        /*!< Specifies the pixel format. This parameter can be
                                      one of value of @ref DVTC_Pixelformat */
  uint32_t DVTC_ConstantAlpha;      /*!< Specifies the constant alpha used for blending.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_DefaultColorBlue;   /*!< Configures the default blue value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_DefaultColorGreen;  /*!< Configures the default green value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_DefaultColorRed;    /*!< Configures the default red value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_DefaultColorAlpha;  /*!< Configures the default alpha value.
                                      This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_BlendingFactor_1;   /*!< Select the blending factor 1. This parameter
                                      can be one of value of @ref DVTC_BlendingFactor1 */
  uint32_t DVTC_BlendingFactor_2;   /*!< Select the blending factor 2. This parameter
                                      can be one of value of @ref DVTC_BlendingFactor2 */
  uint32_t DVTC_CFBStartAdress;     /*!< Configures the color frame buffer address */
  uint32_t DVTC_CFBLineLength;      /*!< Configures the color frame buffer line length.
                                      This parameter must range from 0x0000 to 0x1FFF. */
  uint32_t DVTC_CFBPitch;           /*!< Configures the color frame buffer pitch in bytes.
                                      This parameter must range from 0x0000 to 0x1FFF. */
  uint32_t DVTC_CFBLineNumber;      /*!< Specifies the number of line in frame buffer.
                                      This parameter must range from 0x000 to 0x7FF. */
} DVTC_Layer_InitTypeDef;

/**
  * @brief  DVTC Position structure definition
  */
typedef struct
{
  uint32_t DVTC_POSX;                         /*!<  Current X Position */
  uint32_t DVTC_POSY;                         /*!<  Current Y Position */
} DVTC_PosTypeDef;

/**
  * @brief  DVTC RGB structure definition
  */
typedef struct
{
  uint32_t DVTC_BlueWidth;                        /*!< Blue width */
  uint32_t DVTC_GreenWidth;                       /*!< Green width */
  uint32_t DVTC_RedWidth;                         /*!< Red width */
} DVTC_RGBTypeDef;

/**
  * @brief  DVTC Color Keying structure definition
  */
typedef struct
{
  uint32_t DVTC_ColorKeyBlue;               /*!< Configures the color key blue value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_ColorKeyGreen;              /*!< Configures the color key green value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_ColorKeyRed;                /*!< Configures the color key red value.
                                                 This parameter must range from 0x00 to 0xFF. */
} DVTC_ColorKeying_InitTypeDef;

/**
  * @brief  DVTC CLUT structure definition
  */
typedef struct
{
  uint32_t DVTC_CLUTAdress;                 /*!< Configures the CLUT address.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_BlueValue;                  /*!< Configures the blue value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_GreenValue;                 /*!< Configures the green value.
                                                 This parameter must range from 0x00 to 0xFF. */
  uint32_t DVTC_RedValue;                   /*!< Configures the red value.
                                                 This parameter must range from 0x00 to 0xFF. */
} DVTC_CLUT_InitTypeDef;

/******************************************************************************/
/*                                                                            */
/*                      LCD-TFT Display Controller (DVTC)                     */
/*                                                                            */
/******************************************************************************/

/********************  Bit definition for DVTC_SSCR register  *****************/

#define DVTC_SSCR_VSH                       ((uint32_t)0x000007FF)              /*!< Vertical Synchronization Height */
#define DVTC_SSCR_HSW                       ((uint32_t)0x0FFF0000)              /*!< Horizontal Synchronization Width */

/********************  Bit definition for DVTC_BPCR register  *****************/

#define DVTC_BPCR_AVBP                      ((uint32_t)0x000007FF)              /*!< Accumulated Vertical Back Porch */
#define DVTC_BPCR_AHBP                      ((uint32_t)0x0FFF0000)              /*!< Accumulated Horizontal Back Porch */

/********************  Bit definition for DVTC_AWCR register  *****************/

#define DVTC_AWCR_AAH                       ((uint32_t)0x000007FF)              /*!< Accumulated Active heigh */
#define DVTC_AWCR_AAW                       ((uint32_t)0x0FFF0000)              /*!< Accumulated Active Width */

/********************  Bit definition for DVTC_TWCR register  *****************/

#define DVTC_TWCR_TOTALH                    ((uint32_t)0x000007FF)              /*!< Total Heigh */
#define DVTC_TWCR_TOTALW                    ((uint32_t)0x0FFF0000)              /*!< Total Width */

/********************  Bit definition for DVTC_GCR register  ******************/

#define DVTC_GCR_DVTCEN                     ((uint32_t)0x00000001)              /*!< LCD-TFT controller enable bit */
#define DVTC_GCR_DBW                        ((uint32_t)0x00000070)              /*!< Dither Blue Width */
#define DVTC_GCR_DGW                        ((uint32_t)0x00000700)              /*!< Dither Green Width */
#define DVTC_GCR_DRW                        ((uint32_t)0x00007000)              /*!< Dither Red Width */
#define DVTC_GCR_DEN                        ((uint32_t)0x00010000)              /*!< Dither Enable */
#define DVTC_GCR_PCPOL                      ((uint32_t)0x10000000)              /*!< Pixel Clock Polarity */
#define DVTC_GCR_DEPOL                      ((uint32_t)0x20000000)              /*!< Data Enable Polarity */
#define DVTC_GCR_VSPOL                      ((uint32_t)0x40000000)              /*!< Vertical Synchronization Polarity */
#define DVTC_GCR_HSPOL                      ((uint32_t)0x80000000)              /*!< Horizontal Synchronization Polarity */

/* Legacy defines */
#define DVTC_GCR_DTEN                       DVTC_GCR_DEN

/********************  Bit definition for DVTC_SRCR register  *****************/

#define DVTC_SRCR_IMR                      ((uint32_t)0x00000001)               /*!< Immediate Reload */
#define DVTC_SRCR_VBR                      ((uint32_t)0x00000002)               /*!< Vertical Blanking Reload */

/********************  Bit definition for DVTC_BCCR register  *****************/

#define DVTC_BCCR_BCBLUE                    ((uint32_t)0x000000FF)              /*!< Background Blue value */
#define DVTC_BCCR_BCGREEN                   ((uint32_t)0x0000FF00)              /*!< Background Green value */
#define DVTC_BCCR_BCRED                     ((uint32_t)0x00FF0000)              /*!< Background Red value */

/********************  Bit definition for DVTC_IER register  ******************/

#define DVTC_IER_LIE                        ((uint32_t)0x00000001)              /*!< Line Interrupt Enable */
#define DVTC_IER_FUIE                       ((uint32_t)0x00000002)              /*!< FIFO Underrun Interrupt Enable */
#define DVTC_IER_TERRIE                     ((uint32_t)0x00000004)              /*!< Transfer Error Interrupt Enable */
#define DVTC_IER_RRIE                       ((uint32_t)0x00000008)              /*!< Register Reload interrupt enable */

/********************  Bit definition for DVTC_ISR register  ******************/

#define DVTC_ISR_LIF                        ((uint32_t)0x00000001)              /*!< Line Interrupt Flag */
#define DVTC_ISR_FUIF                       ((uint32_t)0x00000002)              /*!< FIFO Underrun Interrupt Flag */
#define DVTC_ISR_TERRIF                     ((uint32_t)0x00000004)              /*!< Transfer Error Interrupt Flag */
#define DVTC_ISR_RRIF                       ((uint32_t)0x00000008)              /*!< Register Reload interrupt Flag */

/********************  Bit definition for DVTC_ICR register  ******************/

#define DVTC_ICR_CLIF                       ((uint32_t)0x00000001)              /*!< Clears the Line Interrupt Flag */
#define DVTC_ICR_CFUIF                      ((uint32_t)0x00000002)              /*!< Clears the FIFO Underrun Interrupt Flag */
#define DVTC_ICR_CTERRIF                    ((uint32_t)0x00000004)              /*!< Clears the Transfer Error Interrupt Flag */
#define DVTC_ICR_CRRIF                      ((uint32_t)0x00000008)              /*!< Clears Register Reload interrupt Flag */

/********************  Bit definition for DVTC_LIPCR register  ****************/

#define DVTC_LIPCR_LIPOS                    ((uint32_t)0x000007FF)              /*!< Line Interrupt Position */

/********************  Bit definition for DVTC_CPSR register  *****************/

#define DVTC_CPSR_CYPOS                     ((uint32_t)0x0000FFFF)              /*!< Current Y Position */
#define DVTC_CPSR_CXPOS                     ((uint32_t)0xFFFF0000)              /*!< Current X Position */

/********************  Bit definition for DVTC_CDSR register  *****************/

#define DVTC_CDSR_VDES                      ((uint32_t)0x00000001)              /*!< Vertical Data Enable Status */
#define DVTC_CDSR_HDES                      ((uint32_t)0x00000002)              /*!< Horizontal Data Enable Status */
#define DVTC_CDSR_VSYNCS                    ((uint32_t)0x00000004)              /*!< Vertical Synchronization Status */
#define DVTC_CDSR_HSYNCS                    ((uint32_t)0x00000008)              /*!< Horizontal Synchronization Status */

/********************  Bit definition for DVTC_LxCR register  *****************/

#define DVTC_LxCR_LEN                       ((uint32_t)0x00000001)              /*!< Layer Enable */
#define DVTC_LxCR_COLKEN                    ((uint32_t)0x00000002)              /*!< Color Keying Enable */
#define DVTC_LxCR_CLUTEN                    ((uint32_t)0x00000010)              /*!< Color Lockup Table Enable */

/********************  Bit definition for DVTC_LxWHPCR register  **************/

#define DVTC_LxWHPCR_WHSTPOS                ((uint32_t)0x00000FFF)              /*!< Window Horizontal Start Position */
#define DVTC_LxWHPCR_WHSPPOS                ((uint32_t)0xFFFF0000)              /*!< Window Horizontal Stop Position */

/********************  Bit definition for DVTC_LxWVPCR register  **************/

#define DVTC_LxWVPCR_WVSTPOS                ((uint32_t)0x00000FFF)              /*!< Window Vertical Start Position */
#define DVTC_LxWVPCR_WVSPPOS                ((uint32_t)0xFFFF0000)              /*!< Window Vertical Stop Position */

/********************  Bit definition for DVTC_LxCKCR register  ***************/

#define DVTC_LxCKCR_CKBLUE                  ((uint32_t)0x000000FF)              /*!< Color Key Blue value */
#define DVTC_LxCKCR_CKGREEN                 ((uint32_t)0x0000FF00)              /*!< Color Key Green value */
#define DVTC_LxCKCR_CKRED                   ((uint32_t)0x00FF0000)              /*!< Color Key Red value */

/********************  Bit definition for DVTC_LxPFCR register  ***************/

#define DVTC_LxPFCR_PF                      ((uint32_t)0x00000007)              /*!< Pixel Format */

/********************  Bit definition for DVTC_LxCACR register  ***************/

#define DVTC_LxCACR_CONSTA                  ((uint32_t)0x000000FF)              /*!< Constant Alpha */

/********************  Bit definition for DVTC_LxDCCR register  ***************/

#define DVTC_LxDCCR_DCBLUE                  ((uint32_t)0x000000FF)              /*!< Default Color Blue */
#define DVTC_LxDCCR_DCGREEN                 ((uint32_t)0x0000FF00)              /*!< Default Color Green */
#define DVTC_LxDCCR_DCRED                   ((uint32_t)0x00FF0000)              /*!< Default Color Red */
#define DVTC_LxDCCR_DCALPHA                 ((uint32_t)0xFF000000)              /*!< Default Color Alpha */

/********************  Bit definition for DVTC_LxBFCR register  ***************/

#define DVTC_LxBFCR_BF2                     ((uint32_t)0x00000007)              /*!< Blending Factor 2 */
#define DVTC_LxBFCR_BF1                     ((uint32_t)0x00000700)              /*!< Blending Factor 1 */

/********************  Bit definition for DVTC_LxCFBAR register  **************/

#define DVTC_LxCFBAR_CFBADD                 ((uint32_t)0xFFFFFFFF)              /*!< Color Frame Buffer Start Address */

/********************  Bit definition for DVTC_LxCFBLR register  **************/

#define DVTC_LxCFBLR_CFBLL                  ((uint32_t)0x00001FFF)              /*!< Color Frame Buffer Line Length */
#define DVTC_LxCFBLR_CFBP                   ((uint32_t)0x1FFF0000)              /*!< Color Frame Buffer Pitch in bytes */

/********************  Bit definition for DVTC_LxCFBLNR register  *************/

#define DVTC_LxCFBLNR_CFBLNBR               ((uint32_t)0x000007FF)              /*!< Frame Buffer Line Number */

/********************  Bit definition for DVTC_LxCLUTWR register  *************/

#define DVTC_LxCLUTWR_BLUE                  ((uint32_t)0x000000FF)              /*!< Blue value */
#define DVTC_LxCLUTWR_GREEN                 ((uint32_t)0x0000FF00)              /*!< Green value */
#define DVTC_LxCLUTWR_RED                   ((uint32_t)0x00FF0000)              /*!< Red value */
#define DVTC_LxCLUTWR_CLUTADD               ((uint32_t)0xFF000000)              /*!< CLUT address */

/* Exported constants --------------------------------------------------------*/
/** @defgroup DVTC_Exported_Constants
  * @{
  */

/** @defgroup DVTC_SYNC
  * @{
  */

#define DVTC_HorizontalSYNC               ((uint32_t)0x00000FFF)
#define DVTC_VerticalSYNC                 ((uint32_t)0x000007FF)

#define IS_DVTC_HSYNC(HSYNC) ((HSYNC) <= DVTC_HorizontalSYNC)
#define IS_DVTC_VSYNC(VSYNC) ((VSYNC) <= DVTC_VerticalSYNC)
#define IS_DVTC_AHBP(AHBP)  ((AHBP) <= DVTC_HorizontalSYNC)
#define IS_DVTC_AVBP(AVBP) ((AVBP) <= DVTC_VerticalSYNC)
#define IS_DVTC_AAW(AAW)   ((AAW) <= DVTC_HorizontalSYNC)
#define IS_DVTC_AAH(AAH) ((AAH) <= DVTC_VerticalSYNC)
#define IS_DVTC_TOTALW(TOTALW) ((TOTALW) <= DVTC_HorizontalSYNC)
#define IS_DVTC_TOTALH(TOTALH) ((TOTALH) <= DVTC_VerticalSYNC)
/**
  * @}
  */

/** @defgroup DVTC_HSPolarity
  * @{
  */
#define DVTC_HSPolarity_AL                ((uint32_t)0x00000000)                /*!< Horizontal Synchronization is active low. */
#define DVTC_HSPolarity_AH                DVTC_GCR_HSPOL                        /*!< Horizontal Synchronization is active high. */

#define IS_DVTC_HSPOL(HSPOL) (((HSPOL) == DVTC_HSPolarity_AL) || \
                              ((HSPOL) == DVTC_HSPolarity_AH))
/**
  * @}
  */

/** @defgroup DVTC_VSPolarity
  * @{
  */
#define DVTC_VSPolarity_AL                ((uint32_t)0x00000000)                /*!< Vertical Synchronization is active low. */
#define DVTC_VSPolarity_AH                DVTC_GCR_VSPOL                        /*!< Vertical Synchronization is active high. */

#define IS_DVTC_VSPOL(VSPOL) (((VSPOL) == DVTC_VSPolarity_AL) || \
                              ((VSPOL) == DVTC_VSPolarity_AH))
/**
  * @}
  */

/** @defgroup DVTC_DEPolarity
  * @{
  */
#define DVTC_DEPolarity_AL                ((uint32_t)0x00000000)                /*!< Data Enable, is active low. */
#define DVTC_DEPolarity_AH                DVTC_GCR_DEPOL                        /*!< Data Enable, is active high. */

#define IS_DVTC_DEPOL(DEPOL) (((DEPOL) ==  DVTC_VSPolarity_AL) || \
                              ((DEPOL) ==  DVTC_DEPolarity_AH))
/**
  * @}
  */

/** @defgroup DVTC_PCPolarity
  * @{
  */
#define DVTC_PCPolarity_IPC               ((uint32_t)0x00000000)                /*!< input pixel clock. */
#define DVTC_PCPolarity_IIPC              DVTC_GCR_PCPOL                        /*!< inverted input pixel clock. */

#define IS_DVTC_PCPOL(PCPOL) (((PCPOL) ==  DVTC_PCPolarity_IPC) || \
                              ((PCPOL) ==  DVTC_PCPolarity_IIPC))
/**
  * @}
  */

/** @defgroup DVTC_Reload
  * @{
  */
#define DVTC_IMReload                     DVTC_SRCR_IMR                         /*!< Immediately Reload. */
#define DVTC_VBReload                     DVTC_SRCR_VBR                         /*!< Vertical Blanking Reload. */

#define IS_DVTC_RELOAD(RELOAD) (((RELOAD) == DVTC_IMReload) || \
                                ((RELOAD) == DVTC_VBReload))
/**
  * @}
  */

/** @defgroup DVTC_Back_Color
  * @{
  */
#define DVTC_Back_Color                   ((uint32_t)0x000000FF)

#define IS_DVTC_BackBlueValue(BBLUE)    ((BBLUE) <= DVTC_Back_Color)
#define IS_DVTC_BackGreenValue(BGREEN)  ((BGREEN) <= DVTC_Back_Color)
#define IS_DVTC_BackRedValue(BRED)      ((BRED) <= DVTC_Back_Color)
/**
  * @}
  */

/** @defgroup DVTC_Position
  * @{
  */
#define DVTC_POS_CY                       DVTC_CPSR_CYPOS
#define DVTC_POS_CX                       DVTC_CPSR_CXPOS

#define IS_DVTC_GET_POS(POS) (((POS) <= DVTC_POS_CY))
/**
  * @}
  */

/** @defgroup DVTC_LIPosition
  * @{
  */
#define IS_DVTC_LIPOS(LIPOS) ((LIPOS) <= 0x7FF)
/**
  * @}
  */

/** @defgroup DVTC_CurrentStatus
  * @{
  */
#define DVTC_CD_VDES                     DVTC_CDSR_VDES
#define DVTC_CD_HDES                     DVTC_CDSR_HDES
#define DVTC_CD_VSYNC                    DVTC_CDSR_VSYNCS
#define DVTC_CD_HSYNC                    DVTC_CDSR_HSYNCS

#define IS_DVTC_GET_CD(CD) (((CD) == DVTC_CD_VDES) || ((CD) == DVTC_CD_HDES) || \
                              ((CD) == DVTC_CD_VSYNC) || ((CD) == DVTC_CD_HSYNC))
/**
  * @}
  */

/** @defgroup DVTC_Interrupts
  * @{
  */
#define DVTC_IT_LI                      DVTC_IER_LIE
#define DVTC_IT_FU                      DVTC_IER_FUIE
#define DVTC_IT_TERR                    DVTC_IER_TERRIE
#define DVTC_IT_RR                      DVTC_IER_RRIE

#define IS_DVTC_IT(IT) ((((IT) & (uint32_t)0xFFFFFFF0) == 0x00) && ((IT) != 0x00))

/**
  * @}
  */

/** @defgroup DVTC_Flag
  * @{
  */
#define DVTC_FLAG_LI                     DVTC_ISR_LIF
#define DVTC_FLAG_FU                     DVTC_ISR_FUIF
#define DVTC_FLAG_TERR                   DVTC_ISR_TERRIF
#define DVTC_FLAG_RR                     DVTC_ISR_RRIF

#define IS_DVTC_FLAG(FLAG) (((FLAG) == DVTC_FLAG_LI) || ((FLAG) == DVTC_FLAG_FU) || \
                               ((FLAG) == DVTC_FLAG_TERR) || ((FLAG) == DVTC_FLAG_RR))
/**
  * @}
  */

/** @defgroup DVTC_Pixelformat
  * @{
  */
#define DVTC_Pixelformat_ARGB8888                  ((uint32_t)0x00000000)
#define DVTC_Pixelformat_RGB888                    ((uint32_t)0x00000001)
#define DVTC_Pixelformat_RGB565                    ((uint32_t)0x00000002)
#define DVTC_Pixelformat_ARGB1555                  ((uint32_t)0x00000003)
#define DVTC_Pixelformat_ARGB4444                  ((uint32_t)0x00000004)
#define DVTC_Pixelformat_L8                        ((uint32_t)0x00000005)
#define DVTC_Pixelformat_AL44                      ((uint32_t)0x00000006)
#define DVTC_Pixelformat_AL88                      ((uint32_t)0x00000007)

#define IS_DVTC_Pixelformat(Pixelformat) (((Pixelformat) == DVTC_Pixelformat_ARGB8888) || ((Pixelformat) == DVTC_Pixelformat_RGB888)   || \
                        ((Pixelformat) == DVTC_Pixelformat_RGB565)   || ((Pixelformat) == DVTC_Pixelformat_ARGB1555) || \
                        ((Pixelformat) == DVTC_Pixelformat_ARGB4444) || ((Pixelformat) == DVTC_Pixelformat_L8)       || \
                        ((Pixelformat) == DVTC_Pixelformat_AL44)     || ((Pixelformat) == DVTC_Pixelformat_AL88))

/**
  * @}
  */

/** @defgroup DVTC_BlendingFactor1
  * @{
  */
#define DVTC_BlendingFactor1_CA                       ((uint32_t)0x00000400)
#define DVTC_BlendingFactor1_PAxCA                    ((uint32_t)0x00000600)

#define IS_DVTC_BlendingFactor1(BlendingFactor1) (((BlendingFactor1) == DVTC_BlendingFactor1_CA) || ((BlendingFactor1) == DVTC_BlendingFactor1_PAxCA))
/**
  * @}
  */

/** @defgroup DVTC_BlendingFactor2
  * @{
  */
#define DVTC_BlendingFactor2_CA                       ((uint32_t)0x00000005)
#define DVTC_BlendingFactor2_PAxCA                    ((uint32_t)0x00000007)

#define IS_DVTC_BlendingFactor2(BlendingFactor2) (((BlendingFactor2) == DVTC_BlendingFactor2_CA) || ((BlendingFactor2) == DVTC_BlendingFactor2_PAxCA))
/**
  * @}
  */

/** @defgroup DVTC_LAYER_Config
  * @{
  */
#define DVTC_STOPPosition                 ((uint32_t)0x0000FFFF)
#define DVTC_STARTPosition                ((uint32_t)0x00000FFF)

#define DVTC_DefaultColorConfig           ((uint32_t)0x000000FF)
#define DVTC_ColorFrameBuffer             ((uint32_t)0x00001FFF)
#define DVTC_LineNumber                   ((uint32_t)0x000007FF)

#define IS_DVTC_HCONFIGST(HCONFIGST) ((HCONFIGST) <= DVTC_STARTPosition)
#define IS_DVTC_HCONFIGSP(HCONFIGSP) ((HCONFIGSP) <= DVTC_STOPPosition)
#define IS_DVTC_VCONFIGST(VCONFIGST)  ((VCONFIGST) <= DVTC_STARTPosition)
#define IS_DVTC_VCONFIGSP(VCONFIGSP) ((VCONFIGSP) <= DVTC_STOPPosition)

#define IS_DVTC_DEFAULTCOLOR(DEFAULTCOLOR) ((DEFAULTCOLOR) <= DVTC_DefaultColorConfig)

#define IS_DVTC_CFBP(CFBP) ((CFBP) <= DVTC_ColorFrameBuffer)
#define IS_DVTC_CFBLL(CFBLL) ((CFBLL) <= DVTC_ColorFrameBuffer)

#define IS_DVTC_CFBLNBR(CFBLNBR) ((CFBLNBR) <= DVTC_LineNumber)
/**
  * @}
  */

/** @defgroup DVTC_colorkeying_Config
  * @{
  */
#define DVTC_colorkeyingConfig            ((uint32_t)0x000000FF)

#define IS_DVTC_CKEYING(CKEYING) ((CKEYING) <= DVTC_colorkeyingConfig)
/**
  * @}
  */

/** @defgroup DVTC_CLUT_Config
  * @{
  */

#define DVTC_CLUTWR                       ((uint32_t)0x000000FF)

#define IS_DVTC_CLUTWR(CLUTWR)  ((CLUTWR) <= DVTC_CLUTWR)

/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
/*  Function used to set the DVTC configuration to the default reset state *****/
void DVTC_DeInit(void);

/* Initialization and Configuration functions *********************************/
void DVTC_Init(DVTC_InitTypeDef* DVTC_InitStruct);
void DVTC_StructInit(DVTC_InitTypeDef* DVTC_InitStruct);
void DVTC_Cmd(FunctionalState NewState);
void DVTC_DitherCmd(FunctionalState NewState);
DVTC_RGBTypeDef DVTC_GetRGBWidth(void);
void DVTC_RGBStructInit(DVTC_RGBTypeDef* DVTC_RGB_InitStruct);
void DVTC_LIPConfig(uint32_t DVTC_LIPositionConfig);
void DVTC_ReloadConfig(uint32_t DVTC_Reload);
void DVTC_LayerInit(DVTC_Layer_TypeDef* DVTC_Layerx, DVTC_Layer_InitTypeDef* DVTC_Layer_InitStruct);
void DVTC_LayerStructInit(DVTC_Layer_InitTypeDef * DVTC_Layer_InitStruct);
void DVTC_LayerCmd(DVTC_Layer_TypeDef* DVTC_Layerx, FunctionalState NewState);
DVTC_PosTypeDef DVTC_GetPosStatus(void);
void DVTC_PosStructInit(DVTC_PosTypeDef* DVTC_Pos_InitStruct);
FlagStatus DVTC_GetCDStatus(uint32_t DVTC_CD);
void DVTC_ColorKeyingConfig(DVTC_Layer_TypeDef* DVTC_Layerx, DVTC_ColorKeying_InitTypeDef* DVTC_colorkeying_InitStruct, FunctionalState NewState);
void DVTC_ColorKeyingStructInit(DVTC_ColorKeying_InitTypeDef* DVTC_colorkeying_InitStruct);
void DVTC_CLUTCmd(DVTC_Layer_TypeDef* DVTC_Layerx, FunctionalState NewState);
void DVTC_CLUTInit(DVTC_Layer_TypeDef* DVTC_Layerx, DVTC_CLUT_InitTypeDef* DVTC_CLUT_InitStruct);
void DVTC_CLUTStructInit(DVTC_CLUT_InitTypeDef* DVTC_CLUT_InitStruct);
void DVTC_LayerPosition(DVTC_Layer_TypeDef* DVTC_Layerx, uint16_t OffsetX, uint16_t OffsetY);
void DVTC_LayerAlpha(DVTC_Layer_TypeDef* DVTC_Layerx, uint8_t ConstantAlpha);
void DVTC_LayerAddress(DVTC_Layer_TypeDef* DVTC_Layerx, uint32_t Address);
void DVTC_LayerSize(DVTC_Layer_TypeDef* DVTC_Layerx, uint32_t Width, uint32_t Height);
void DVTC_LayerPixelFormat(DVTC_Layer_TypeDef* DVTC_Layerx, uint32_t PixelFormat);

/* Interrupts and flags management functions **********************************/
void DVTC_ITConfig(uint32_t DVTC_IT, FunctionalState NewState);
FlagStatus DVTC_GetFlagStatus(uint32_t DVTC_FLAG);
void DVTC_ClearFlag(uint32_t DVTC_FLAG);
ITStatus DVTC_GetITStatus(uint32_t DVTC_IT);
void DVTC_ClearITPendingBit(uint32_t DVTC_IT);


#endif /* CYBER_DVTC */
#endif /* __DVTC_H */
