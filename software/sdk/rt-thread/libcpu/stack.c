#include <rthw.h>
#include <rtthread.h>

/* 中断处理中所用到一些参数 */
rt_uint32_t rt_interrupt_from_thread;
rt_uint32_t rt_interrupt_to_thread;
rt_uint32_t rt_thread_switch_interrupt_flag;

/* risc-v 体系结构中的寄存器定义 */
struct stack_frame
{
    /* cpu 执行 mret 指令后会跳转到 mepc 内的地址处继续执行 */
    rt_ubase_t epc;         /* exception program counter */
    rt_ubase_t ra;          /* x1  - ra     - return address                      */
    rt_ubase_t mstatus;     /*              - machine status register             */ 
    rt_ubase_t gp;          /* x3  - gp     - global pointer                      */
    rt_ubase_t tp;          /* x4  - tp     - thread pointer                      */
    rt_ubase_t t0;          /* x5  - t0     - temporary register 0                */
    rt_ubase_t t1;          /* x6  - t1     - temporary register 1                */
    rt_ubase_t t2;          /* x7  - t0     - temporary register 2                */
    rt_ubase_t s0_fp;       /* x8  - s0/fp  - saved register 0 or frame pointer   */
    rt_ubase_t s1;          /* x9  - s1     - saved register 1                    */
    rt_ubase_t a0;          /* x10 - a0     - return value or function argument 0 */
    rt_ubase_t a1;          /* x11 - a1     - return value or function argument 1 */
    rt_ubase_t a2;          /* x12 - a2     - function argument 2                 */
    rt_ubase_t a3;          /* x13 - a3     - function argument 3                 */
    rt_ubase_t a4;          /* x14 - a4     - function argument 4                 */
    rt_ubase_t a5;          /* x15 - a5     - function argument 5                 */
    rt_ubase_t a6;          /* x16 - a6     - function argument 6                 */
    rt_ubase_t a7;          /* x17 - a7     - function argument 7                 */
    rt_ubase_t s2;          /* x18 - s2     - saved register 2                    */
    rt_ubase_t s3;          /* x19 - s3     - saved register 3                    */
    rt_ubase_t s4;          /* x20 - s4     - saved register 4                    */
    rt_ubase_t s5;          /* x21 - s5     - saved register 5                    */
    rt_ubase_t s6;          /* x22 - s6     - saved register 6                    */
    rt_ubase_t s7;          /* x23 - s7     - saved register 7                    */
    rt_ubase_t s8;          /* x24 - s8     - saved register 8                    */
    rt_ubase_t s9;          /* x25 - s9     - saved register 9                    */
    rt_ubase_t s10;         /* x26 - s10    - saved register 10                   */
    rt_ubase_t s11;         /* x27 - s11    - saved register 11                   */
    rt_ubase_t t3;          /* x28 - t3     - temporary register 3                */
    rt_ubase_t t4;          /* x29 - t4     - temporary register 4                */
    rt_ubase_t t5;          /* x30 - t5     - temporary register 5                */
    rt_ubase_t t6;          /* x31 - t6     - temporary register 6                */
};

/**
 * This function will initialize thread stack
 *
 * @param tentry the entry of thread
 * @param parameter the parameter of entry
 * @param stack_addr the beginning stack address
 *
 * @return stack address
 */
rt_uint8_t *rt_hw_stack_init(void       *tentry,
                             void       *parameter,
                             rt_uint8_t *stack_addr)
{
    struct stack_frame *frame;
    rt_uint8_t         *stk;
    int                 i;

    /* 获取栈顶指针
     rt_hw_stack_init 在调用的时候，传给 stack_addr 的是(栈顶指针-4) */
    stk  = stack_addr + sizeof(rt_uint32_t);

    /* 让 stk 指针向下 8 字节对齐 */
    stk  = (rt_uint8_t *)RT_ALIGN_DOWN((rt_uint32_t)stk, 8);

    /* stk 指针继续向下移动 sizeof(struct stack_frame)个偏移，这些空间用于上下文切换的时候保存线程上下文 */
    stk -= sizeof(struct stack_frame); 

    frame = (struct stack_frame *)stk;

    /* 将 rt_hw_stack_frame 结构体内各个参数初始化为 0xdeadbeef */
    for (i = 0; i < sizeof(struct stack_frame) / sizeof(rt_ubase_t); i++)
    {
        ((rt_ubase_t *)frame)[i] = 0xdeadbeef;
    }

    // frame->ra  = (rt_ubase_t)texit;
    frame->a0  = (rt_ubase_t)parameter;
    frame->epc = (rt_ubase_t)tentry;

    /* force to machine mode(MPP=11) and set MPIE to 1 */
    frame->mstatus = 0x00001880;

    /* 返回线程栈指针 */
    return stk;
}
