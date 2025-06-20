#ifndef __TIMER_H_
#define __TIMER_H_

/* prescaler */
typedef struct
{
    volatile uint32_t LIMIT;
} Prescaler_Reg;

static void prescaler_init(Prescaler_Reg *reg)
{
}

/* timer */
typedef struct
{
    volatile uint32_t CLEARS_TICKS;
    volatile uint32_t LIMIT;
    volatile uint32_t VALUE;
} Timer_Reg;

static void timer_init(Timer_Reg *reg)
{
    reg->CLEARS_TICKS = 0;
    reg->VALUE = 0;
}

#endif /* __TIMER_H_ */
