#ifndef OPENPERIPH_SDIO_H
#define OPENPERIPH_SDIO_H

#include <stdint.h>

typedef struct {
    volatile uint32_t POWER, CLKCR, ARG, CMD;
    volatile const uint32_t RESPCMD, RESP1, RESP2, RESP3, RESP4;
    volatile uint32_t DTIMER, DLEN, DCTRL;
    volatile const uint32_t DCOUNT, STA;
    volatile uint32_t ICR, MASK;
    uint32_t RESERVED0[2];
    volatile const uint32_t FIFOCNT;
    uint32_t RESERVED1[13];
    volatile uint32_t FIFO;
} SDIO_TypeDef;

void SDIO_PowerOn(void);
void SDIO_SendCommand(uint8_t command, uint32_t argument, uint8_t response);
uint32_t SDIO_GetResponse(unsigned index);

#endif
