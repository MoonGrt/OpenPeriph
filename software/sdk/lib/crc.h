#ifndef OPENPERIPH_CRC_H
#define OPENPERIPH_CRC_H

#include <stdint.h>

typedef struct {
    volatile uint32_t DR;
    volatile uint8_t IDR;
    uint8_t RESERVED0;
    uint16_t RESERVED1;
    volatile uint32_t CR;
} CRC_TypeDef;

void CRC_ResetDR(void);
uint32_t CRC_CalcCRC(uint32_t data);
uint32_t CRC_CalcBlockCRC(const uint32_t *buffer, uint32_t words);
void CRC_SetIDRegister(uint8_t value);
uint8_t CRC_GetIDRegister(void);

#endif
