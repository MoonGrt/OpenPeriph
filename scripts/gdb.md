# 启动GDB并自动执行烧录命令
/opt/riscv/bin/riscv64-unknown-elf-gdb
file /mnt/hgfs/share/OpenPeriph/test/software/pinsec/build/demo.elf
target extended-remote :3333
monitor reset halt
load
continue


y
y
monitor reset halt
load
continue
