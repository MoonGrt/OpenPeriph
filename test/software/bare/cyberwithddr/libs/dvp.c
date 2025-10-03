
/* Includes ------------------------------------------------------------------*/
#include "dvp.h"
#ifdef CYBER_DVP

/** @defgroup DVP_Private_Variables
 * @{
 */


/** @defgroup DVP_Private_Functions
  * @{
  */
// 初始化 VP 模块
void VP_Init(DVP_TypeDef *DVPx, VP_InitTypeDef *VP_InitStruct)
{
    DVPx->VP_CR = ((VP_InitStruct->Mode & 0x7) << 0) |           // 1位使能 + 2位模式 [2:1]
                  ((VP_InitStruct->CutterMode & 0x7) << 3) |     // 1位使能 + 2位模式 [5:3]
                  ((VP_InitStruct->FilterMode & 0x7) << 6) |     // 1位使能 + 2位模式 [8:6]
                  ((VP_InitStruct->ScalerMode & 0x7) << 9) |     // 1位使能 + 2位模式 [11:9]
                  ((VP_InitStruct->ColorMode & 0x7) << 12) |     // 1位使能 + 2位模式 [14:12]
                  ((VP_InitStruct->EdgerMode & 0x7) << 15) |     // 1位使能 + 2位模式 [17:15]
                  ((VP_InitStruct->BinarizerMode & 0x7) << 18) | // 1位使能 + 2位模式 [20:18]
                  ((VP_InitStruct->FillMode & 0x7) << 21);       // 1位使能 + 2位模式 [23:21]
}

// 初始化 DVP 模块
void DVP_Init(DVP_TypeDef *DVPx, DVP_InitTypeDef *DVP_InitStruct)
{
    // 配置 VI_CR
    DVPx->VI_CR = (DVP_InitStruct->VIMode & 0x7); // 1位使能 + 2位模式 [2:1]
    // 配置 VP_CR
    VP_Init(DVPx, &DVP_InitStruct->VPMode);
    // 配置 VO_CR
    DVPx->VO_CR = (DVP_InitStruct->VOMode & 0x7); // 1位使能 + 2位模式 [2:1]
}

// VP_THRESHOLD 设置函数
void DVP_VP_SetThreshold(DVP_TypeDef *DVPx, uint8_t edger_threshold, uint8_t binarizer_threshold)
{
    DVPx->VP_THRESHOLD = ((edger_threshold & 0xFF) << 0) | 
                         ((binarizer_threshold & 0xFF) << 8);
}

// 设置VP_START
void DVP_VP_SetStart(DVP_TypeDef *DVPx, uint16_t startX, uint16_t startY)
{
    DVPx->VP_START = (startY & 0xFFFF) << 16 | (startX & 0xFFFF); // 将START_Y和START_X写入VP_START
}

// 设置VP_END
void DVP_VP_SetEnd(DVP_TypeDef *DVPx, uint16_t endX, uint16_t endY)
{
    DVPx->VP_END = (endY & 0xFFFF) << 16 | (endX & 0xFFFF); // 将END_Y和END_X写入VP_END
}

// 设置VP_SCALER
void DVP_VP_SetOutRes(DVP_TypeDef *DVPx, uint16_t outputXRes, uint16_t outputYRes)
{
    DVPx->VP_SCALER = (outputYRes & 0xFFFF) << 16 | (outputXRes & 0xFFFF); // 将OUTPUT_Y_RES和OUTPUT_X_RES写入VP_SCALER
}

#endif /* CYBER_DVP */

/******************* END OF FILE *******************/
