#ifndef __STD_H
#define __STD_H

#include <stdarg.h>
#include "uart.h"

#define UARTPORT USART1
int printf(const char *format, ...);

#endif
