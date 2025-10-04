#include "types.h"
#include "hw_timer.h"

#define IRQ_M_TIMER 7
#define IRQ_M_UART 11
#define CAUSE_MACHINE_IRQ_REASON_MASK 0xFFFF

reg_t trap_handler(reg_t mcause, reg_t mepc)
{
    reg_t epc = mepc;
    reg_t cause = mcause & CAUSE_MACHINE_IRQ_REASON_MASK;

    if (mcause & 0x80000000) 
    {
        /* 异步中断 */
        switch (cause)
        {
            case IRQ_M_TIMER: /* 定时器中断 */
                hw_timer_irq_handler();
                break;
            case IRQ_M_UART:
                printf("uart interrupt!\r\n");
                break;
            default: 
                printf("default interrupt\r\n");
                break;
        }
    }
    else 
    {
        /* 同步中断 */
        /* 目前不需要用到同步中断 */
        // printf("Something wrong has happend\n");
    }

    return epc;
}
