
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __AFIO_H
#define __AFIO_H

/* Includes ------------------------------------------------------------------*/
#include "cyber.h"

#ifdef CYBER_AFIO

/**
 * @brief Alternate Function I/O
 */

typedef struct
{
  __IO uint32_t EVCR;
  __IO uint32_t MAPR;
  __IO uint32_t EXTICR[4];
  uint32_t RESERVED0;
  __IO uint32_t MAPR2;
} AFIO_TypeDef;

#endif /* CYBER_AFIO */
#endif /* __AFIO_H */
