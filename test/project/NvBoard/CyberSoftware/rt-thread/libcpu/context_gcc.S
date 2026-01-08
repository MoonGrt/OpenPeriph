/*
 * 关闭全局中断
 * rt_base_t rt_hw_interrupt_disable(void);
 */
.globl rt_hw_interrupt_disable
rt_hw_interrupt_disable:
    /* 将 mstatus 的第 3 位（mie）置 0，关闭全局中断，并将 mstatus 的内容放入 a0 返回 */
    csrrci a0, mstatus, 8
    ret

/*
 * 将全局中断状态恢复到原来的状态，注意这里不是打开
 * void rt_hw_interrupt_enable(rt_base_t level);
 */
.globl rt_hw_interrupt_enable
rt_hw_interrupt_enable:
    /* 将传入的参数 level 写入 mstatus 中 */
    csrw mstatus, a0
    ret

/*
 * 线程上下文切换，从 from 切换到 to
 * void rt_hw_context_switch(rt_uint32 from, rt_uint32 to);
 * a0 --> from
 * a1 --> to
 */
.globl rt_hw_context_switch
rt_hw_context_switch:

    /* saved <from> thread context
     *     x1/ra       -> sp(0)
     *     x1/ra       -> sp(1)
     *     mstatus.mie -> sp(2)
     *     x(i)        -> sp(i-4)
     */
    /* 将 sp 减去 32 * 4，腾出空间给 stack_frame */ 
    addi  sp,  sp, -32 * 4
    sw sp,  (a0)

    sw x1,  0 * 4(sp) // ra -> epc
    sw x1,  1 * 4(sp) // ra -> ra

    /* 检查 mstatus.mie（全局中断使能） 是否打开（mstatus.mie = 1），
      如果打开则需要设置 mstatus.pie = 1，反之则直接跳转 save_mpie */
    csrr a0, mstatus
    andi a0, a0, 8
    beqz a0, save_mpie
    li   a0, 0x80
    /* 保存当前线程的相关寄存器 */
save_mpie:
    sw a0,   2 * 4(sp)

    sw x4,   4 * 4(sp)
    sw x5,   5 * 4(sp)
    sw x6,   6 * 4(sp)
    sw x7,   7 * 4(sp)
    sw x8,   8 * 4(sp)
    sw x9,   9 * 4(sp)
    sw x10, 10 * 4(sp)
    sw x11, 11 * 4(sp)
    sw x12, 12 * 4(sp)
    sw x13, 13 * 4(sp)
    sw x14, 14 * 4(sp)
    sw x15, 15 * 4(sp)
    sw x16, 16 * 4(sp)
    sw x17, 17 * 4(sp)
    sw x18, 18 * 4(sp)
    sw x19, 19 * 4(sp)
    sw x20, 20 * 4(sp)
    sw x21, 21 * 4(sp)
    sw x22, 22 * 4(sp)
    sw x23, 23 * 4(sp)
    sw x24, 24 * 4(sp)
    sw x25, 25 * 4(sp)
    sw x26, 26 * 4(sp)
    sw x27, 27 * 4(sp)
    sw x28, 28 * 4(sp)
    sw x29, 29 * 4(sp)
    sw x30, 30 * 4(sp)
    sw x31, 31 * 4(sp)

    /* restore <to> thread context
     * sp(0) -> epc;
     * sp(1) -> ra;
     * sp(i) -> x(i+2)
     */
    lw sp,  (a1)

    /* load epc(ra) -> mepc，使用 mret 后会跳转到 mepc 指向的地址处继续执行 */
    lw a1,   0 * 4(sp)
    csrw mepc, a1
    lw x1,   1 * 4(sp)

    /* force to machin mode(MPP=11) */
    li a1, 0x00001800
    csrs mstatus, a1
    lw a1,   2 * 4(sp)
    csrs mstatus, a1

    /* 恢复要切换到的线程的相关寄存器 */
    lw x4,   4 * 4(sp)
    lw x5,   5 * 4(sp)
    lw x6,   6 * 4(sp)
    lw x7,   7 * 4(sp)
    lw x8,   8 * 4(sp)
    lw x9,   9 * 4(sp)
    lw x10, 10 * 4(sp)
    lw x11, 11 * 4(sp)
    lw x12, 12 * 4(sp)
    lw x13, 13 * 4(sp)
    lw x14, 14 * 4(sp)
    lw x15, 15 * 4(sp)
    lw x16, 16 * 4(sp)
    lw x17, 17 * 4(sp)
    lw x18, 18 * 4(sp)
    lw x19, 19 * 4(sp)
    lw x20, 20 * 4(sp)
    lw x21, 21 * 4(sp)
    lw x22, 22 * 4(sp)
    lw x23, 23 * 4(sp)
    lw x24, 24 * 4(sp)
    lw x25, 25 * 4(sp)
    lw x26, 26 * 4(sp)
    lw x27, 27 * 4(sp)
    lw x28, 28 * 4(sp)
    lw x29, 29 * 4(sp)
    lw x30, 30 * 4(sp)
    lw x31, 31 * 4(sp)

    addi sp,  sp, 32 * 4
    mret

/*
 * 线程上下文切换，不保存当前线程上下文
 * void rt_hw_context_switch_to(rt_uint32 to);
 * a0 --> to
 */
.globl rt_hw_context_switch_to
rt_hw_context_switch_to:
    lw sp, (a0)

    /* load epc from stack */
    lw a0,   0 * 4(sp)
    csrw mepc, a0
    lw x1,   1 * 4(sp)
    /* load mstatus from stack */
    lw a0,   2 * 4(sp)
    csrw mstatus, a0
    lw x4,   4 * 4(sp)
    lw x5,   5 * 4(sp)
    lw x6,   6 * 4(sp)
    lw x7,   7 * 4(sp)
    lw x8,   8 * 4(sp)
    lw x9,   9 * 4(sp)
    lw x10, 10 * 4(sp)
    lw x11, 11 * 4(sp)
    lw x12, 12 * 4(sp)
    lw x13, 13 * 4(sp)
    lw x14, 14 * 4(sp)
    lw x15, 15 * 4(sp)
    lw x16, 16 * 4(sp)
    lw x17, 17 * 4(sp)
    lw x18, 18 * 4(sp)
    lw x19, 19 * 4(sp)
    lw x20, 20 * 4(sp)
    lw x21, 21 * 4(sp)
    lw x22, 22 * 4(sp)
    lw x23, 23 * 4(sp)
    lw x24, 24 * 4(sp)
    lw x25, 25 * 4(sp)
    lw x26, 26 * 4(sp)
    lw x27, 27 * 4(sp)
    lw x28, 28 * 4(sp)
    lw x29, 29 * 4(sp)
    lw x30, 30 * 4(sp)
    lw x31, 31 * 4(sp)
    
    /* 将 sp 增加 32 * 4，覆盖掉 stack_frame，因为内容都读取完了，就不需要再次用到 stack_frame 了 */
    addi sp,  sp, 32 * 4
    mret

/*
 * void rt_hw_context_switch_interrupt(rt_uint32 from, rt_uint32 to);
 */
.globl rt_thread_switch_interrupt_flag
.globl rt_interrupt_from_thread
.globl rt_interrupt_to_thread
.globl rt_hw_context_switch_interrupt
rt_hw_context_switch_interrupt:
    addi sp, sp, -16
    sw   s0, 12(sp)
    sw   a0, 8(sp)
    sw   a5, 4(sp)

    /* 判断 rt_thread_switch_interrupt_flag 是否为 1，若为 1 则跳转 _reswitch */
    la   a0, rt_thread_switch_interrupt_flag
    lw   a5, (a0)
    bnez a5, _reswitch

    /* 将 rt_thread_switch_interrupt_flag 置 1 */
    li   a5, 1
    sw   a5, (a0)

    /* 将 from 赋值给 rt_interrupt_from_thread */
    la   a5, rt_interrupt_from_thread
    lw   a0, 8(sp)
    sw   a0, (a5)

_reswitch:
    /* 将 to 赋值给 rt_interrupt_to_thread */
    la   a5, rt_interrupt_to_thread
    sw   a1, (a5)

    lw   a5, 4(sp)
    lw   a0, 8(sp)
    lw   s0, 12(sp)
    addi sp, sp, 16
    ret
