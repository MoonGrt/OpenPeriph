.section        .text.entry
.align 2
.globl trap_entry
trap_entry:
    /* 保存线程上下文 */
    addi sp, sp, -32 * 4

    sw x1,   1 * 4(sp)

    li t0, 0x80
    sw t0,   2 * 4(sp)

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

    /* 保存当前栈指针，利用当前线程栈来处理中断 */
    move s0, sp
	
    la   sp, _sp

    /* 将 mcause 与 mepc 寄存器的内容作为参数传给 trap_handler 函数 */
    call rt_interrupt_enter
    csrr a0, mcause
    csrr a1, mepc
    call trap_handler
    call rt_interrupt_leave

    /* 恢复栈指针 */
    move sp, s0

    /* 根据 rt_thread_switch_interrupt_flag 来确定是否需要切换线程 */
    la   s0, rt_thread_switch_interrupt_flag
    lw   s2, (s0)
    beqz s2, spurious_interrupt

    /* 将 rt_thread_switch_interrupt_flag 置 0 */
    sw   zero, (s0)

	/* 将 mepc 存入当前线程的 stack_frame 中 */
    csrr a0, mepc
    sw   a0, 0 * 4(sp)

    /* 将当前 sp 存入 rt_interrupt_from_thread */
    la   s0, rt_interrupt_from_thread
    lw   s1, (s0)
    sw   sp, (s1)

    /* 取出 rt_interrupt_to_thread 的 sp */
    la   s0, rt_interrupt_to_thread
    lw   s1, 0(s0)
    lw   sp, 0(s1)

    /* 取出新线程的 epc 写入 mepc 中 */
    lw   a0, 0 * 4(sp)
    csrw mepc, a0

spurious_interrupt:
    /* 恢复线程上下文 */
    lw x1,   1 * 4(sp)

    li t0, 0x00001800
    csrs mstatus, t0
    lw t0,   2 * 4(sp)
    csrs mstatus, t0 

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

    addi sp, sp, 32 * 4
    mret

/* 如果 trap_handler 有外部定义则不会使用如下定义 */
.weak trap_handler
trap_handler:
1:
    j 1b
