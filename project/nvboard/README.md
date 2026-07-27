# NVBoard 测试工程

工程会依次构建对应软件、生成 SoC RTL，再链接
`thirdpartys/nvboard`。第三方子仓库不会被修改。

```sh
make SOC=cyber run
make SOC=cyberplus run
make SOC=chisel run
```

Rocket 的逐指令提交日志默认关闭。调试 CPU 执行过程时可显式启用：

```sh
make SOC=chisel BUILD_TOOL=mill ROCKET_TRACE=1 run
```

软件映射如下：

- `cyber`：`software/bare`，裸机外设与 UART 示例
- `cyberplus`：`software/rthtread`，RT-Thread 示例
- `chisel`：Rocket RV32 核和 `software/rthtread`，包含 VGA 彩条测试

将 `BUILD_TOOL` 改为 `sbt` 可切换到 SBT。旧的图形 SoC 仍可通过
`SOC=spinal` 运行。Chisel SoC 使用 `thirdpartys/rocket-chip` 提供的 Rocket
核，`BUILD_TOOL=mill` 负责生成 RTL；软件通过 CLINT `mtime/mtimecmp`
提供 RT-Thread 时钟节拍。

无图形环境下可运行 VGA 自动检查：

```sh
OPENPERIPH_VGA_SELF_TEST=1 SDL_VIDEODRIVER=dummy \
  make SOC=chisel BUILD_TOOL=mill run
```
