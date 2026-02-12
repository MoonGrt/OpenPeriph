
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DVTR_H
#define __DVTR_H

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_DVTR

/** 
  * @brief DVTR
  */

typedef struct
{
  __IO uint32_t CR;       /*!< DVTR control register 1,                       Address offset: 0x00 */
  __IO uint32_t SR;       /*!< DVTR status register,                          Address offset: 0x04 */
  __IO uint32_t RISR;     /*!< DVTR raw interrupt status register,            Address offset: 0x08 */
  __IO uint32_t IER;      /*!< DVTR interrupt enable register,                Address offset: 0x0C */
  __IO uint32_t MISR;     /*!< DVTR masked interrupt status register,         Address offset: 0x10 */
  __IO uint32_t ICR;      /*!< DVTR interrupt clear register,                 Address offset: 0x14 */
  __IO uint32_t ESCR;     /*!< DVTR embedded synchronization code register,   Address offset: 0x18 */
  __IO uint32_t ESUR;     /*!< DVTR embedded synchronization unmask register, Address offset: 0x1C */
  __IO uint32_t CWSTRTR;  /*!< DVTR crop window start,                        Address offset: 0x20 */
  __IO uint32_t CWSIZER;  /*!< DVTR crop window size,                         Address offset: 0x24 */
  __IO uint32_t DR;       /*!< DVTR data register,                            Address offset: 0x28 */
} DVTR_TypeDef;

/******************************************************************************/
/*                                                                            */
/*                                    DVTR                                    */
/*                                                                            */
/******************************************************************************/
/********************  Bits definition for DVTR_CR register  ******************/
#define DVTR_CR_CAPTURE                      ((uint32_t)0x00000001)
#define DVTR_CR_CM                           ((uint32_t)0x00000002)
#define DVTR_CR_CROP                         ((uint32_t)0x00000004)
#define DVTR_CR_JPEG                         ((uint32_t)0x00000008)
#define DVTR_CR_ESS                          ((uint32_t)0x00000010)
#define DVTR_CR_PCKPOL                       ((uint32_t)0x00000020)
#define DVTR_CR_HSPOL                        ((uint32_t)0x00000040)
#define DVTR_CR_VSPOL                        ((uint32_t)0x00000080)
#define DVTR_CR_FCRC_0                       ((uint32_t)0x00000100)
#define DVTR_CR_FCRC_1                       ((uint32_t)0x00000200)
#define DVTR_CR_EDM_0                        ((uint32_t)0x00000400)
#define DVTR_CR_EDM_1                        ((uint32_t)0x00000800)
#define DVTR_CR_CRE                          ((uint32_t)0x00001000)
#define DVTR_CR_ENABLE                       ((uint32_t)0x00004000)

/********************  Bits definition for DVTR_SR register  ******************/
#define DVTR_SR_HSYNC                        ((uint32_t)0x00000001)
#define DVTR_SR_VSYNC                        ((uint32_t)0x00000002)
#define DVTR_SR_FNE                          ((uint32_t)0x00000004)

/********************  Bits definition for DVTR_RIS register  *****************/
#define DVTR_RIS_FRAME_RIS                   ((uint32_t)0x00000001)
#define DVTR_RIS_OVR_RIS                     ((uint32_t)0x00000002)
#define DVTR_RIS_ERR_RIS                     ((uint32_t)0x00000004)
#define DVTR_RIS_VSYNC_RIS                   ((uint32_t)0x00000008)
#define DVTR_RIS_LINE_RIS                     ((uint32_t)0x00000010)
/* Legacy defines */
#define DVTR_RISR_FRAME_RIS                  DVTR_RIS_FRAME_RIS
#define DVTR_RISR_OVR_RIS                    DVTR_RIS_OVR_RIS
#define DVTR_RISR_ERR_RIS                    DVTR_RIS_ERR_RIS
#define DVTR_RISR_VSYNC_RIS                  DVTR_RIS_VSYNC_RIS
#define DVTR_RISR_LINE_RIS                   DVTR_RIS_LINE_RIS
#define DVTR_RISR_OVF_RIS                    DVTR_RIS_OVR_RIS

/********************  Bits definition for DVTR_IER register  *****************/
#define DVTR_IER_FRAME_IE                    ((uint32_t)0x00000001)
#define DVTR_IER_OVR_IE                      ((uint32_t)0x00000002)
#define DVTR_IER_ERR_IE                      ((uint32_t)0x00000004)
#define DVTR_IER_VSYNC_IE                    ((uint32_t)0x00000008)
#define DVTR_IER_LINE_IE                     ((uint32_t)0x00000010)

/* Legacy defines */
#define DVTR_IER_OVF_IE                      DVTR_IER_OVR_IE

/********************  Bits definition for DVTR_MIS register  ****************/
#define DVTR_MIS_FRAME_MIS                   ((uint32_t)0x00000001)
#define DVTR_MIS_OVR_MIS                     ((uint32_t)0x00000002)
#define DVTR_MIS_ERR_MIS                     ((uint32_t)0x00000004)
#define DVTR_MIS_VSYNC_MIS                   ((uint32_t)0x00000008)
#define DVTR_MIS_LINE_MIS                    ((uint32_t)0x00000010)

/* Legacy defines */
#define DVTR_MISR_FRAME_MIS                  DVTR_MIS_FRAME_MIS
#define DVTR_MISR_OVF_MIS                    DVTR_MIS_OVR_MIS
#define DVTR_MISR_ERR_MIS                    DVTR_MIS_ERR_MIS
#define DVTR_MISR_VSYNC_MIS                  DVTR_MIS_VSYNC_MIS
#define DVTR_MISR_LINE_MIS                   DVTR_MIS_LINE_MIS

/********************  Bits definition for DVTR_ICR register  *****************/
#define DVTR_ICR_FRAME_ISC                   ((uint32_t)0x00000001)
#define DVTR_ICR_OVR_ISC                     ((uint32_t)0x00000002)
#define DVTR_ICR_ERR_ISC                     ((uint32_t)0x00000004)
#define DVTR_ICR_VSYNC_ISC                   ((uint32_t)0x00000008)
#define DVTR_ICR_LINE_ISC                    ((uint32_t)0x00000010)

/* Legacy defines */
#define DVTR_ICR_OVF_ISC                     DVTR_ICR_OVR_ISC

/********************  Bits definition for DVTR_ESCR register  ******************/
#define DVTR_ESCR_FSC                        ((uint32_t)0x000000FF)
#define DVTR_ESCR_LSC                        ((uint32_t)0x0000FF00)
#define DVTR_ESCR_LEC                        ((uint32_t)0x00FF0000)
#define DVTR_ESCR_FEC                        ((uint32_t)0xFF000000)

/********************  Bits definition for DVTR_ESUR register  ******************/
#define DVTR_ESUR_FSU                        ((uint32_t)0x000000FF)
#define DVTR_ESUR_LSU                        ((uint32_t)0x0000FF00)
#define DVTR_ESUR_LEU                        ((uint32_t)0x00FF0000)
#define DVTR_ESUR_FEU                        ((uint32_t)0xFF000000)

/********************  Bits definition for DVTR_CWSTRT register  ******************/
#define DVTR_CWSTRT_HOFFCNT                  ((uint32_t)0x00003FFF)
#define DVTR_CWSTRT_VST                      ((uint32_t)0x1FFF0000)

/********************  Bits definition for DVTR_CWSIZE register  ******************/
#define DVTR_CWSIZE_CAPCNT                   ((uint32_t)0x00003FFF)
#define DVTR_CWSIZE_VLINE                    ((uint32_t)0x3FFF0000)

/********************  Bits definition for DVTR_DR register  ******************/
#define DVTR_DR_BYTE0                        ((uint32_t)0x000000FF)
#define DVTR_DR_BYTE1                        ((uint32_t)0x0000FF00)
#define DVTR_DR_BYTE2                        ((uint32_t)0x00FF0000)
#define DVTR_DR_BYTE3                        ((uint32_t)0xFF000000)

/* Exported types ------------------------------------------------------------*/
/**
  * @brief   DVTR Init structure definition
  */
typedef struct
{
  uint16_t DVTR_CaptureMode;      /*!< Specifies the Capture Mode: Continuous or Snapshot.
                                       This parameter can be a value of @ref DVTR_Capture_Mode */
  uint16_t DVTR_SynchroMode;      /*!< Specifies the Synchronization Mode: Hardware or Embedded.
                                       This parameter can be a value of @ref DVTR_Synchronization_Mode */
  uint16_t DVTR_PCKPolarity;      /*!< Specifies the Pixel clock polarity: Falling or Rising.
                                       This parameter can be a value of @ref DVTR_PIXCK_Polarity */
  uint16_t DVTR_VSPolarity;       /*!< Specifies the Vertical synchronization polarity: High or Low.
                                       This parameter can be a value of @ref DVTR_VSYNC_Polarity */
  uint16_t DVTR_HSPolarity;       /*!< Specifies the Horizontal synchronization polarity: High or Low.
                                       This parameter can be a value of @ref DVTR_HSYNC_Polarity */
  uint16_t DVTR_CaptureRate;      /*!< Specifies the frequency of frame capture: All, 1/2 or 1/4.
                                       This parameter can be a value of @ref DVTR_Capture_Rate */
  uint16_t DVTR_ExtendedDataMode; /*!< Specifies the data width: 8-bit, 10-bit, 12-bit or 14-bit.
                                       This parameter can be a value of @ref DVTR_Extended_Data_Mode */
} DVTR_InitTypeDef;

/**
  * @brief   DVTR CROP Init structure definition
  */
typedef struct
{
  uint16_t DVTR_VerticalStartLine;      /*!< Specifies the Vertical start line count from which the image capture
                                             will start. This parameter can be a value between 0x00 and 0x1FFF */
  uint16_t DVTR_HorizontalOffsetCount;  /*!< Specifies the number of pixel clocks to count before starting a capture.
                                             This parameter can be a value between 0x00 and 0x3FFF */
  uint16_t DVTR_VerticalLineCount;      /*!< Specifies the number of lines to be captured from the starting point.
                                             This parameter can be a value between 0x00 and 0x3FFF */
  uint16_t DVTR_CaptureCount;           /*!< Specifies the number of pixel clocks to be captured from the starting
                                             point on the same line.
                                             This parameter can be a value between 0x00 and 0x3FFF */
} DVTR_CROPInitTypeDef;

/**
  * @brief   DVTR Embedded Synchronisation CODE Init structure definition
  */
typedef struct
{
  uint8_t DVTR_FrameStartCode; /*!< Specifies the code of the frame start delimiter. */
  uint8_t DVTR_LineStartCode;  /*!< Specifies the code of the line start delimiter. */
  uint8_t DVTR_LineEndCode;    /*!< Specifies the code of the line end delimiter. */
  uint8_t DVTR_FrameEndCode;   /*!< Specifies the code of the frame end delimiter. */
} DVTR_CodesInitTypeDef;

/* Exported constants --------------------------------------------------------*/

/** @defgroup DVTR_Exported_Constants
  * @{
  */

/** @defgroup DVTR_Capture_Mode
  * @{
  */
#define DVTR_CaptureMode_Continuous    ((uint16_t)0x0000) /*!< The received data are transferred continuously
                                                               into the destination memory through the DMA */
#define DVTR_CaptureMode_SnapShot      ((uint16_t)0x0002) /*!< Once activated, the interface waits for the start of
                                                               frame and then transfers a single frame through the DMA */
#define IS_DVTR_CAPTURE_MODE(MODE)(((MODE) == DVTR_CaptureMode_Continuous) || \
                                   ((MODE) == DVTR_CaptureMode_SnapShot))
/**
  * @}
  */


/** @defgroup DVTR_Synchronization_Mode
  * @{
  */
#define DVTR_SynchroMode_Hardware    ((uint16_t)0x0000) /*!< Hardware synchronization data capture (frame/line start/stop)
                                                             is synchronized with the HSYNC/VSYNC signals */
#define DVTR_SynchroMode_Embedded    ((uint16_t)0x0010) /*!< Embedded synchronization data capture is synchronized with
                                                             synchronization codes embedded in the data flow */
#define IS_DVTR_SYNCHRO(MODE)(((MODE) == DVTR_SynchroMode_Hardware) || \
                              ((MODE) == DVTR_SynchroMode_Embedded))
/**
  * @}
  */


/** @defgroup DVTR_PIXCK_Polarity
  * @{
  */
#define DVTR_PCKPolarity_Falling    ((uint16_t)0x0000) /*!< Pixel clock active on Falling edge */
#define DVTR_PCKPolarity_Rising     ((uint16_t)0x0020) /*!< Pixel clock active on Rising edge */
#define IS_DVTR_PCKPOLARITY(POLARITY)(((POLARITY) == DVTR_PCKPolarity_Falling) || \
                                      ((POLARITY) == DVTR_PCKPolarity_Rising))
/**
  * @}
  */


/** @defgroup DVTR_VSYNC_Polarity
  * @{
  */
#define DVTR_VSPolarity_Low     ((uint16_t)0x0000) /*!< Vertical synchronization active Low */
#define DVTR_VSPolarity_High    ((uint16_t)0x0080) /*!< Vertical synchronization active High */
#define IS_DVTR_VSPOLARITY(POLARITY)(((POLARITY) == DVTR_VSPolarity_Low) || \
                                     ((POLARITY) == DVTR_VSPolarity_High))
/**
  * @}
  */


/** @defgroup DVTR_HSYNC_Polarity
  * @{
  */
#define DVTR_HSPolarity_Low     ((uint16_t)0x0000) /*!< Horizontal synchronization active Low */
#define DVTR_HSPolarity_High    ((uint16_t)0x0040) /*!< Horizontal synchronization active High */
#define IS_DVTR_HSPOLARITY(POLARITY)(((POLARITY) == DVTR_HSPolarity_Low) || \
                                     ((POLARITY) == DVTR_HSPolarity_High))
/**
  * @}
  */


/** @defgroup DVTR_Capture_Rate
  * @{
  */
#define DVTR_CaptureRate_All_Frame     ((uint16_t)0x0000) /*!< All frames are captured */
#define DVTR_CaptureRate_1of2_Frame    ((uint16_t)0x0100) /*!< Every alternate frame captured */
#define DVTR_CaptureRate_1of4_Frame    ((uint16_t)0x0200) /*!< One frame in 4 frames captured */
#define IS_DVTR_CAPTURE_RATE(RATE) (((RATE) == DVTR_CaptureRate_All_Frame) || \
                                    ((RATE) == DVTR_CaptureRate_1of2_Frame) ||\
                                    ((RATE) == DVTR_CaptureRate_1of4_Frame))
/**
  * @}
  */


/** @defgroup DVTR_Extended_Data_Mode
  * @{
  */
#define DVTR_ExtendedDataMode_8b     ((uint16_t)0x0000) /*!< Interface captures 8-bit data on every pixel clock */
#define DVTR_ExtendedDataMode_10b    ((uint16_t)0x0400) /*!< Interface captures 10-bit data on every pixel clock */
#define DVTR_ExtendedDataMode_12b    ((uint16_t)0x0800) /*!< Interface captures 12-bit data on every pixel clock */
#define DVTR_ExtendedDataMode_14b    ((uint16_t)0x0C00) /*!< Interface captures 14-bit data on every pixel clock */
#define IS_DVTR_EXTENDED_DATA(DATA)(((DATA) == DVTR_ExtendedDataMode_8b) || \
                                    ((DATA) == DVTR_ExtendedDataMode_10b) ||\
                                    ((DATA) == DVTR_ExtendedDataMode_12b) ||\
                                    ((DATA) == DVTR_ExtendedDataMode_14b))
/**
  * @}
  */


/** @defgroup DVTR_interrupt_sources
  * @{
  */
#define DVTR_IT_FRAME    ((uint16_t)0x0001)
#define DVTR_IT_OVF      ((uint16_t)0x0002)
#define DVTR_IT_ERR      ((uint16_t)0x0004)
#define DVTR_IT_VSYNC    ((uint16_t)0x0008)
#define DVTR_IT_LINE     ((uint16_t)0x0010)
#define IS_DVTR_CONFIG_IT(IT) ((((IT) & (uint16_t)0xFFE0) == 0x0000) && ((IT) != 0x0000))
#define IS_DVTR_GET_IT(IT) (((IT) == DVTR_IT_FRAME) || \
                            ((IT) == DVTR_IT_OVF) || \
                            ((IT) == DVTR_IT_ERR) || \
                            ((IT) == DVTR_IT_VSYNC) || \
                            ((IT) == DVTR_IT_LINE))
/**
  * @}
  */


/** @defgroup DVTR_Flags
  * @{
  */
/**
  * @brief   DVTR SR register
  */
#define DVTR_FLAG_HSYNC     ((uint16_t)0x2001)
#define DVTR_FLAG_VSYNC     ((uint16_t)0x2002)
#define DVTR_FLAG_FNE       ((uint16_t)0x2004)
/**
  * @brief   DVTR RISR register
  */
#define DVTR_FLAG_FRAMERI    ((uint16_t)0x0001)
#define DVTR_FLAG_OVFRI      ((uint16_t)0x0002)
#define DVTR_FLAG_ERRRI      ((uint16_t)0x0004)
#define DVTR_FLAG_VSYNCRI    ((uint16_t)0x0008)
#define DVTR_FLAG_LINERI     ((uint16_t)0x0010)
/**
  * @brief   DVTR MISR register
  */
#define DVTR_FLAG_FRAMEMI    ((uint16_t)0x1001)
#define DVTR_FLAG_OVFMI      ((uint16_t)0x1002)
#define DVTR_FLAG_ERRMI      ((uint16_t)0x1004)
#define DVTR_FLAG_VSYNCMI    ((uint16_t)0x1008)
#define DVTR_FLAG_LINEMI     ((uint16_t)0x1010)
#define IS_DVTR_GET_FLAG(FLAG) (((FLAG) == DVTR_FLAG_HSYNC) || \
                                ((FLAG) == DVTR_FLAG_VSYNC) || \
                                ((FLAG) == DVTR_FLAG_FNE) || \
                                ((FLAG) == DVTR_FLAG_FRAMERI) || \
                                ((FLAG) == DVTR_FLAG_OVFRI) || \
                                ((FLAG) == DVTR_FLAG_ERRRI) || \
                                ((FLAG) == DVTR_FLAG_VSYNCRI) || \
                                ((FLAG) == DVTR_FLAG_LINERI) || \
                                ((FLAG) == DVTR_FLAG_FRAMEMI) || \
                                ((FLAG) == DVTR_FLAG_OVFMI) || \
                                ((FLAG) == DVTR_FLAG_ERRMI) || \
                                ((FLAG) == DVTR_FLAG_VSYNCMI) || \
                                ((FLAG) == DVTR_FLAG_LINEMI))

#define IS_DVTR_CLEAR_FLAG(FLAG) ((((FLAG) & (uint16_t)0xFFE0) == 0x0000) && ((FLAG) != 0x0000))
/**
  * @}
  */

/**
  * @}
  */

/* Exported macro ------------------------------------------------------------*/
/* Exported functions --------------------------------------------------------*/

/*  Function used to set the DVTR configuration to the default reset state ****/
void DVTR_DeInit(void);

/* Initialization and Configuration functions *********************************/
void DVTR_Init(DVTR_InitTypeDef* DVTR_InitStruct);
void DVTR_StructInit(DVTR_InitTypeDef* DVTR_InitStruct);
void DVTR_CROPConfig(DVTR_CROPInitTypeDef* DVTR_CROPInitStruct);
void DVTR_CROPCmd(FunctionalState NewState);
void DVTR_SetEmbeddedSynchroCodes(DVTR_CodesInitTypeDef* DVTR_CodesInitStruct);
void DVTR_JPEGCmd(FunctionalState NewState);

/* Image capture functions ****************************************************/
void DVTR_Cmd(FunctionalState NewState);
void DVTR_CaptureCmd(FunctionalState NewState);
uint32_t DVTR_ReadData(void);

/* Interrupts and flags management functions **********************************/
void DVTR_ITConfig(uint16_t DVTR_IT, FunctionalState NewState);
FlagStatus DVTR_GetFlagStatus(uint16_t DVTR_FLAG);
void DVTR_ClearFlag(uint16_t DVTR_FLAG);
ITStatus DVTR_GetITStatus(uint16_t DVTR_IT);
void DVTR_ClearITPendingBit(uint16_t DVTR_IT);

#ifdef __cplusplus
}
#endif

#endif /* CYBER_DVTR */
#endif /*__DVTR_H */

/**
  * @}
  */

/**
  * @}
  */

