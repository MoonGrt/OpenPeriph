#include "cyber.h"
#ifdef CYBER_SDIO

void SDIO_PowerOn(void) { SDIO->POWER = 3; }
void SDIO_SendCommand(uint8_t command, uint32_t argument, uint8_t response)
{
    SDIO->ARG = argument;
    SDIO->CMD = (command & 0x3f) | ((uint32_t)(response & 3) << 6) | (1u << 10);
}
uint32_t SDIO_GetResponse(unsigned index)
{
    volatile const uint32_t *response = &SDIO->RESP1;
    return index < 4 ? response[index] : 0;
}

#endif
