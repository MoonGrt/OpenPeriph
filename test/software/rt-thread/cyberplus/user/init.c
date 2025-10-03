extern void trap_entry(void) __attribute__((weak));

void _init()
{
    /* 设置中断入口函数 */
    asm volatile("csrw mtvec, %0" :: "r" (&trap_entry));
    /* 使能 CPU全局中断，设置权限为 Machine，MPP = 11, MPIE = 1, MIE = 1 */
    asm volatile("csrw mstatus, %0" :: "r" (0x1888));
}