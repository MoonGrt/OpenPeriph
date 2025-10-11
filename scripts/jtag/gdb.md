# 启动GDB并自动执行烧录命令
/opt/riscv/bin/riscv64-unknown-elf-gdb
file /home/moon/OpenPeriph/test/software/rt-thread/cyberplus/build/demo.elf
target extended-remote :3333
monitor reset halt
load
continue


y
y
monitor reset halt
load
continue
