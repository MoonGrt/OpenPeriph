#ifndef __UART_H_
#define __UART_H_

#include "cyber.h"

typedef struct
{
    volatile uint32_t DATA;
    volatile uint32_t STATUS;
    volatile uint32_t CLOCK_DIVIDER;
    volatile uint32_t FRAME_CONFIG;
} Uart_Reg;

typedef struct
{
    volatile uint32_t INPUT;         // +0 0x0000
    volatile uint32_t OUTPUT;        // +4 0x0100
    volatile uint32_t OUTPUT_ENABLE; // +8 0x1000
} Gpio_Reg;                          // old

enum UartParity
{
    NONE = 0,
    EVEN = 1,
    ODD = 2
};
enum UartStop
{
    ONE = 0,
    TWO = 1
};

typedef struct
{
    uint32_t dataLength;
    enum UartParity parity;
    enum UartStop stop;
    uint32_t clockDivider;
} Uart_Config;

static uint32_t uart_writeAvailability(Uart_Reg *reg)
{
    return (reg->STATUS >> 16) & 0xFF;
}
static uint32_t uart_readOccupancy(Uart_Reg *reg)
{
    return reg->STATUS >> 24;
}

static void uart_write(Uart_Reg *reg, uint32_t data)
{
    while (uart_writeAvailability(reg) == 0)
        ;
    reg->DATA = data;
}

static void uart_applyConfig(Uart_Reg *reg, Uart_Config *config)
{
    reg->CLOCK_DIVIDER = config->clockDivider;
    reg->FRAME_CONFIG = ((config->dataLength - 1) << 0) | (config->parity << 8) | (config->stop << 16);
}

#endif /* __UART_H_ */
