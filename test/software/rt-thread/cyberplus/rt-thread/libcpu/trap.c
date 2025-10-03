#include "types.h"
#include "hw_timer.h"

#define IRQ_M_TIMER                   7
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
            /* 定时器中断 */
            case IRQ_M_TIMER:
                {
                    /* 调用定时器中断处理函数 */
                    hw_timer_irq_handler();
                }
                break;
            case 11:
                {
                    printf("uart interrupt!\r\n");
                }
                break;
            default: 
                {
                    printf("default interrupt\r\n");
                }
                break;
        }
    }
    else 
    {
        /* 同步中断 */
        /* 目前不需要用到同步中断 */
        printf("Something wrong has happend\n");
    }

    return epc;
}
