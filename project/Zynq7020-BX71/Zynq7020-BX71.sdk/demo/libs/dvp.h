
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DVP_H
#define __DVP_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_DVP

/** @defgroup DVP_Exported_Types
 * @{
 */
typedef struct
{
    volatile uint32_t VI_CR;        // VI Control Register
    volatile uint32_t VI_SR;        // VI Status Register
    volatile uint32_t VP_CR;        // VP Control Register
    volatile uint32_t VP_SR;        // VP Status Register
    volatile uint32_t VP_START;     // VP Start Position Register
    volatile uint32_t VP_END;       // VP End Position Register
    volatile uint32_t VP_SCALER;    // VP Scaler W/H Register
    volatile uint32_t VP_THRESHOLD; // VP Threshold Register
    volatile uint32_t VO_CR;        // VO Control Register
    volatile uint32_t VO_SR;        // VO Status Register
} DVP_TypeDef;

typedef struct
{
    uint8_t Mode;
    uint8_t CutterMode;    // Cutter 模式 (2位模式: | 1位使能: 0: 禁用, 1: 使能)
    uint8_t FilterMode;    // Filter 模式 (2位模式: 01: gaussian, 10: mean, 11: median | 1位使能: 0: 禁用, 1: 使能)
    uint8_t ScalerMode;    // Scaler 模式 (2位模式: 01: neighbor, 10: bilinear, 11: bicubic | 1位使能: 0: 禁用, 1: 使能)
    uint8_t ColorMode;     // Color 模式 (2位模式: 01: YUV422, 10: YUV222, 11: | 1位使能: 0: 禁用, 1: 使能)
    uint8_t EdgerMode;     // Edger 模式 (2位模式: 01: sobel, 10: prewitt, 11: | 1位使能: 0: 禁用, 1: 使能)
    uint8_t BinarizerMode; // Binarizer 模式 (2位模式: 01: 正向模式, 10: 反相模式, 11: | 1位使能: 0: 禁用, 1: 使能)
    uint8_t FillMode;      // Fill 模式 (2位模式: 01: 黑色, 10: 白色, 11: 自定义 | 1位使能: 0: 禁用, 1: 使能)
} VP_InitTypeDef;

typedef struct
{
    uint8_t VIMode;        // VI 模式 (2位模式: 01: test, 10: camera, 11: hdmi | 1位使能: 0: 禁用, 1: 使能)
    VP_InitTypeDef VPMode; // VP 模式 (2位模式: 01: scale, 10: edge, 11: binarize | 1位使能: 0: 禁用, 1: 使能)
    uint8_t VOMode;        // VO 模式 (2位模式: 01: HDMI, 10: VGA, 11: LCD | 1位使能: 0: 禁用, 1: 使能)
} DVP_InitTypeDef;

/** @defgroup DVP_Private_Defines
 * @{
 */
#define ENABLE 0x01      // 使能标志
#define DISABLE 0x00 // 禁用标志

// VI 模式宏
#define VI_TEST 0x02   // Test 模式
#define VI_CAMERA 0x04 // Camera 模式
#define VI_HDMI 0x06   // HDMI 模式
// VP 模式宏
#define VP_Scaler 0x02    // Scaler 模式
#define VP_Edge 0x04      // Edge 模式
#define VP_Binarizer 0x06 // Binarizer 模式
// VO 模式宏
#define VO_HDMI 0x02 // HDMI 输出模式
#define VO_VGA 0x04  // VGA 输出模式
#define VO_LCD 0x06  // LCD 输出模式

// Cutter 模式宏
#define VP_Cutter 0x02 // Cutter 模式
// Filter 模式宏
#define VP_Gaussian 0x02 // Gaussian 模式
#define VP_Mean 0x04     // Mean 模式
#define VP_Median 0x06   // Median 模式
// Scaler 模式宏
#define VP_Neighbor 0x02 // Neighbor 模式
#define VP_Bilinear 0x04 // Bilinear 模式
#define VP_Bicubic 0x06  // Bicubic 模式
// Color 模式宏
#define VP_YUV422 0x02 // YUV422 模式
#define VP_YUV222 0x04 // YUV222 模式
// Edger 模式宏
#define VP_Sobel 0x02   // Sobel 模式
#define VP_Prewitt 0x04 // Prewitt 模式
// Binarizer 模式宏
#define VP_Normal 0x02  // Normal 模式
#define VP_Inverse 0x02 // Inverse 模式
// Fill 模式宏
#define VP_Black 0x02  // 黑色
#define VP_White 0x04  // 白色

/** @defgroup DVP_Exported_Functions
 * @{
 */
void VP_Init(DVP_TypeDef *DVPx, VP_InitTypeDef *VP_InitStruct);
void DVP_Init(DVP_TypeDef *DVPx, DVP_InitTypeDef *DVP_InitStruct);
void DVP_VP_SetStart(DVP_TypeDef *DVPx, uint16_t startX, uint16_t startY);
void DVP_VP_SetEnd(DVP_TypeDef *DVPx, uint16_t endX, uint16_t endY);
void DVP_VP_SetOutRes(DVP_TypeDef *DVPx, uint16_t outputXRes, uint16_t outputYRes);
void DVP_VP_SetThreshold(DVP_TypeDef *DVPx, uint8_t edger_threshold, uint8_t binarizer_threshold);

#endif /* CYBER_DVP */
#endif /* __DVP_H */
