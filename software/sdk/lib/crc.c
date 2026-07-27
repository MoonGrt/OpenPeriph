#include "cyber.h"
#ifdef CYBER_CRC

void CRC_ResetDR(void) { CRC->CR = 1; }
uint32_t CRC_CalcCRC(uint32_t data) { CRC->DR = data; return CRC->DR; }
uint32_t CRC_CalcBlockCRC(const uint32_t *buffer, uint32_t words)
{
    while (words-- != 0) CRC->DR = *buffer++;
    return CRC->DR;
}
void CRC_SetIDRegister(uint8_t value) { CRC->IDR = value; }
uint8_t CRC_GetIDRegister(void) { return CRC->IDR; }

#endif
