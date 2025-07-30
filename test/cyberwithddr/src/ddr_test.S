.weak crtStart

crtStart:
  li t0, 0x40000068         # t0 = DDR base address

  # 准备6个数据
  li t1, 0x11111111         # 数据1
  li t2, 0x22222222         # 数据2
  li t3, 0x33333333         # 数据3
  li t4, 0x44444444         # 数据4
  li t5, 0x55555555         # 数据5
  li t6, 0x66666666         # 数据6

  # 写入6个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  sw t3, 8(t0)              # DDR[8] = t3
  sw t4, 12(t0)             # DDR[12] = t4
  sw t5, 16(t0)             # DDR[16] = t5
  sw t6, 20(t0)             # DDR[20] = t6

  # 清零用于验证的寄存器
  li t1, 0
  li t2, 0
  li t3, 0
  li t4, 0
  li t5, 0
  li t6, 0

  # 读出6个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]
  lw t3, 8(t0)              # 读DDR[8]
  lw t4, 12(t0)             # 读DDR[12]
  lw t5, 16(t0)             # 读DDR[16]
  lw t6, 20(t0)             # 读DDR[20]

end:
  j end                    # 死循环
