#include "std.h"

void putchar(int c)
{
    USART_SendData(UARTPORT, c);
}

int puts(char *s)
{
    while (*s)
    {
        putchar(*s);
        s++;
    }
    putchar('\n');
    return 0;
}

static void printf_c(int c)
{
    putchar(c);
}

static void printf_s(char *p)
{
    while (*p)
        putchar(*(p++));
}

static void printf_d(int val)
{
    char buffer[32];
    char *p = buffer;
    if (val < 0)
    {
        printf_c('-');
        val = -val;
    }
    while (val || p == buffer)
    {
        *(p++) = '0' + val % 10;
        val = val / 10;
    }
    while (p != buffer)
        printf_c(*(--p));
}

static void printf_u(unsigned int val)
{
    char buffer[32];
    char *p = buffer;
    while (val || p == buffer)
    {
        *(p++) = '0' + val % 10;
        val = val / 10;
    }
    while (p != buffer)
        printf_c(*(--p));
}

static void printf_x(unsigned int val, int uppercase)
{
    char buffer[32];
    char *p = buffer;
    const char *digits = uppercase ? "0123456789ABCDEF" : "0123456789abcdef";
    while (val || p == buffer)
    {
        *(p++) = digits[val % 16];
        val = val / 16;
    }
    while (p != buffer)
        printf_c(*(--p));
}

static void printf_ld(long int val)
{
    char buffer[32];
    char *p = buffer;
    if (val < 0)
    {
        printf_c('-');
        val = -val;
    }
    while (val || p == buffer)
    {
        *(p++) = '0' + (val % 10);
        val = val / 10;
    }
    while (p != buffer)
        printf_c(*(--p));
}

static void printf_lu(unsigned long int val)
{
    char buffer[32];
    char *p = buffer;
    while (val || p == buffer)
    {
        *(p++) = '0' + (val % 10);
        val = val / 10;
    }
    while (p != buffer)
        printf_c(*(--p));
}

static void printf_lx(unsigned long int val, int uppercase)
{
    char buffer[32];
    char *p = buffer;
    const char *digits = uppercase ?
        "0123456789ABCDEF" : "0123456789abcdef";
    while (val || p == buffer)
    {
        *(p++) = digits[val % 16];
        val = val / 16;
    }
    while (p != buffer)
        printf_c(*(--p));
}

static void printf_f(float val)
{
    if (val < 0) {
        printf_c('-');
        val = -val;
    }
    int int_part = (int)val;
    float frac_part = val - int_part;
    printf_d(int_part);
    printf_c('.');
    for (int i = 0; i < 4; i++) {
        frac_part *= 10;
        int digit = (int)frac_part;
        printf_c('0' + digit);
        frac_part -= digit;
    }
}

int printf(const char *format, ...)
{
    int i;
    va_list ap;
    va_start(ap, format);
    for (i = 0; format[i]; i++)
        if (format[i] == '%')
        {
            i++;
            switch(format[i]) {
                case 'c': printf_c(va_arg(ap, int)); break;
                case 's': printf_s(va_arg(ap, char *)); break;
                case 'd': printf_d(va_arg(ap, int)); break;
                case 'u': printf_u(va_arg(ap, unsigned int)); break;
                case 'x': printf_x(va_arg(ap, unsigned int), 0); break;
                case 'X': printf_x(va_arg(ap, unsigned int), 1); break;
                case 'f': printf_f(va_arg(ap, double)); break;
                case 'l':
                {
                    i++;
                    switch(format[i]) {
                        case 'd': printf_ld(va_arg(ap, long int)); break;
                        case 'u': printf_lu(va_arg(ap, unsigned long int)); break;
                        case 'x': printf_lx(va_arg(ap, unsigned long int), 0); break;
                        case 'X': printf_lx(va_arg(ap, unsigned long int), 1); break;
                        default: /* ignore unknown */ break;
                    }
                }
                default: /* ignore unknown */ break;
            }
        }
        else
            printf_c(format[i]);
    va_end(ap);
}
