.weak crtStart

crtStart:
  j ddr_test
  nop
  nop
  nop
  nop
  nop
  nop
  nop

ddr_test:
  # call ddr_test1
  call ddr_test2

end:
  j end                     # 死循环

ddr_test1:
  # 第一批测试
  li t0, 0x40000000         # t0 = DDR base address

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

  # 读出6个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]
  lw t3, 8(t0)              # 读DDR[8]
  lw t4, 12(t0)             # 读DDR[12]
  lw t5, 16(t0)             # 读DDR[16]
  lw t6, 20(t0)             # 读DDR[20]

  # 第二批测试
  li t0, 0x40000400         # t0 = DDR base address

  # 准备6个数据
  li t1, 0x99999999         # 数据1
  li t2, 0xaaaaaaaa         # 数据2
  li t3, 0xbbbbbbbb         # 数据3
  li t4, 0xcccccccc         # 数据4
  li t5, 0xdddddddd         # 数据5
  li t6, 0xeeeeeeee         # 数据6

  # 写入6个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  sw t3, 8(t0)              # DDR[8] = t3
  sw t4, 12(t0)             # DDR[12] = t4
  sw t5, 16(t0)             # DDR[16] = t5
  sw t6, 20(t0)             # DDR[20] = t6

  # 读出6个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]
  lw t3, 8(t0)              # 读DDR[8]
  lw t4, 12(t0)             # 读DDR[12]
  lw t5, 16(t0)             # 读DDR[16]
  lw t6, 20(t0)             # 读DDR[20]

  # 第三批测试
  li t0, 0x40000800         # t0 = DDR base address

  # 准备6个数据
  li t1, 0x00001111         # 数据1
  li t2, 0x00002222         # 数据2
  li t3, 0x00003333         # 数据3
  li t4, 0x00004444         # 数据4
  li t5, 0x00005555         # 数据5
  li t6, 0x00006666         # 数据6

  # 写入6个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  sw t3, 8(t0)              # DDR[8] = t3
  sw t4, 12(t0)             # DDR[12] = t4
  sw t5, 16(t0)             # DDR[16] = t5
  sw t6, 20(t0)             # DDR[20] = t6

  # 读出6个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]
  lw t3, 8(t0)              # 读DDR[8]
  lw t4, 12(t0)             # 读DDR[12]
  lw t5, 16(t0)             # 读DDR[16]
  lw t6, 20(t0)             # 读DDR[20]

ddr_test2:
  # 第一批测试
  li t0, 0x40000000         # t0 = DDR base address
  # 准备2个数据
  li t1, 0x00000000         # 数据1
  li t2, 0x11111111         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第二批测试
  li t0, 0x40000200         # t0 = DDR base address
  # 准备2个数据
  li t1, 0x22222222         # 数据1
  li t2, 0x33333333         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第三批测试
  li t0, 0x40000400         # t0 = DDR base address
  # 准备2个数据
  li t1, 0x44444444         # 数据1
  li t2, 0x55555555         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第四批测试
  li t0, 0x40000600         # t0 = DDR base address
  # 准备2个数据
  li t1, 0x66666666         # 数据1
  li t2, 0x77777777         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第五批测试
  li t0, 0x40000800         # t0 = DDR base address
  # 准备2个数据
  li t1, 0x88888888         # 数据1
  li t2, 0x99999999         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第六批测试
  li t0, 0x40000a00         # t0 = DDR base address
  # 准备2个数据
  li t1, 0xaaaaaaaa         # 数据1
  li t2, 0xbbbbbbbb         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第七批测试
  li t0, 0x40000c00         # t0 = DDR base address
  # 准备2个数据
  li t1, 0xcccccccc         # 数据1
  li t2, 0xdddddddd         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]

  # 第八批测试
  li t0, 0x40000e00         # t0 = DDR base address
  # 准备2个数据
  li t1, 0xeeeeeeee         # 数据1
  li t2, 0xffffffff         # 数据2
  # 写入2个数据
  sw t1, 0(t0)              # DDR[0] = t1
  sw t2, 4(t0)              # DDR[4] = t2
  # 读出2个数据
  lw t1, 0(t0)              # 读DDR[0]
  lw t2, 4(t0)              # 读DDR[4]
