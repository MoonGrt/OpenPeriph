**简体中文 | [English](README.md)**
<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
    <a href="https://github.com/MoonGrt/OpenPeriph">
    <img src="docs/images/logo.png" alt="Logo" width="80" height="80">
    </a>
<h3 align="center">OpenPeriph</h3>
    <p align="center">
    基于STM32兼容的外设及寄存器集，采用SpinalHDL进行设计。包含一个用于集成测试的最小化RISC-V SoC代码。该设计旨在支持开源兼容STM32固件的SoC项目。
    <br />
    <a href="https://github.com/MoonGrt/OpenPeriph"><strong>浏览文档 »</strong></a>
    <br />
    <a href="https://github.com/MoonGrt/OpenPeriph">查看 Demo</a>
    ·
    <a href="https://github.com/MoonGrt/OpenPeriph/issues">反馈 Bug</a>
    ·
    <a href="https://github.com/MoonGrt/OpenPeriph/issues">请求新功能</a>
    </p>
</div>



<!-- CONTENTS -->
<details open>
  <summary>目录</summary>
  <ol>
    <li><a href="#功能特性">功能特性</a></li>
    <li><a href="#快速开始">快速开始</a></li>
    <li><a href="#安装指南">安装指南</a></li>
    <li><a href="#文件树">文件树</a></li>
    <li><a href="#关于本项目">关于本项目</a></li>
    <li><a href="#使用示例">使用示例</a></li>
    <li><a href="#支持的外设">支持的外设</a></li>
    <li><a href="#图形处理能力">图形处理能力</a></li>
    <li><a href="#fpga支持">FPGA支持</a></li>
    <li><a href="#开发工作流">开发工作流</a></li>
    <li><a href="#贡献">贡献</a></li>
    <li><a href="#许可证">许可证</a></li>
    <li><a href="#联系我们">联系我们</a></li>
    <li><a href="#致谢">致谢</a></li>
  </ol>
</details>



<!-- 功能特性 -->
### 功能特性

#### 🚀 **STM32兼容性**
- **寄存器级兼容** 与STM32外设完全兼容
- **直接固件移植** 最小化代码修改即可运行
- **完整外设库** 移植自STM32标准外设库
- **中断处理** 兼容STM32架构

#### 🎯 **RISC-V SoC平台**
- **RISC-V RV32IM** 处理器核心集成
- **模块化SoC架构** 基于SpinalHDL构建
- **多种SoC变体** 适用于不同应用场景
- **DDR内存支持** 高性能应用支持

#### 🎨 **高级图形处理**
- **HDMI/VGA/LCD** 显示接口
- **实时视频处理** 算法
- **图像滤波和卷积** 操作
- **颜色空间转换** 和混合
- **边缘检测** 和计算机视觉能力

#### 🔧 **开发工具**
- **自动化环境配置** 脚本
- **Verilog生成** 从SpinalHDL
- **仿真支持** 支持Verilator/GHDL
- **FPGA综合** 支持Gowin器件
- **指令提取** 内存初始化工具

#### 📱 **硬件支持**
- **Gowin FPGA** 开发板
- **Tang Primer** 和 **Tang Mega** 支持
- **DDR3内存控制器** 集成
- **多时钟域** 管理



<!-- 快速开始 -->
### 快速开始

#### 前置要求
- **Ubuntu 16.04及以上版本**
- **Java 8及以上版本**（用于SBT）
- **Scala 2.12.18**（由SBT管理）
- **SpinalHDL 1.12.0**（由SBT管理）
- **RISC-V GCC 工具链**
- **Verilator 4.216+**（用于仿真）

#### 克隆项目并运行
```bash
# 1. Clone the Repository
git clone https://github.com/MoonGrt/OpenPeriph.git
cd OpenPeriph

# 2. Setup Development Environment
# Run the automated setup script
bash setup.sh

# 3.1. Build with sbt
sbt run

# 3.2. Build with mill (optional) (Currently, there are issues with building the vexriscv kernel.)
mill

# 4. Software Development
# Open the relevant project file in test/software

# 5. FPGA Synthesis (optional)
# Open the relevant project file in test/project

```



<!-- 安装指南 -->
### 安装指南

#### 自动化安装（推荐）
项目包含自动化设置脚本，可安装所有必需工具：（建议还是一步步构建所需工具）

```bash
bash setup.sh
```

此脚本将安装：
- Java
- SBT (Scala Build Tool)
- RISC-V GNU toolchain
- Verilator simulator
- Openocd
- VexRiscv (optional)

#### 手动安装
如果您偏好手动安装，请按照以下步骤：

1. **安装SBT**
```bash
  # Install SBT - https://www.scala-sbt.org/
  echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
  echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
  curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
  sudo apt-get update
  sudo apt-get install sbt
```

2. **安装RISC-V工具链**
```bash
  # Download and install the Sifive GCC toolchain
  sudo apt install -y libncurses5
  version=riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14
  wget -O riscv64-unknown-elf-gcc.tar.gz riscv https://static.dev.sifive.com/dev-tools/$version.tar.gz
  tar -xzvf riscv64-unknown-elf-gcc.tar.gz
  sudo mv $version /opt/riscv
  echo 'export PATH=/opt/riscv/bin:$PATH' >> ~/.bashrc
  rm riscv64-unknown-elf-gcc.tar.gz
```

3. **安装Verilator**
```bash
  sudo apt install -y make autoconf g++ flex libfl-dev bison  # First time prerequisites
  git clone https://github.com/verilator/verilator.git  # Only first time
  unset VERILATOR_ROOT  # For bash
  cd verilator
  git pull  # Make sure we're up-to-date
  git checkout v4.216
  autoconf  # Create ./configure script
  ./configure
  make -j $(nproc)
  sudo make install
  cd .. && rm -rf verilator
```

4. **Openocd**
```bash
  sudo apt-get install -y libyaml-dev
  git clone https://github.com/SpinalHDL/openocd_riscv.git
  cd openocd_riscv
  ./bootstrap
  ./configure --enable-cmsis-dap
  make -j $(nproc)
  sudo make install
  cd .. && rm -rf openocd_riscv
```

6. **mill** (optional)
```bash
  curl --fail -L -o mill https://github.com/com-lihaoyi/mill/releases/download/0.11.6/0.11.6-assembly
  chmod +x mill
  sudo mv mill /usr/local/bin
  mill OpenPeriph.runMain soc.Cyber
```

7. ***VexRiscv** (optional)
```bash
  git clone https://github.com/SpinalHDL/VexRiscv.git
  cd VexRiscv
  sbt publishLocal
```



<!-- 文件树 -->
### 文件树

```
OpenPeriph/
  ├─ /docs/
  │ ├─ Openocd.md        # OpenOCD configuration
  │ └─ SpinalHDL.md      # SpinalHDL usage guide
  ├─ src/main/scala/     # Source code
  │ ├─ graphic/          # Graphics and video processing
  │ │ ├─ algorithm/      # Video processing algorithms
  │ │ ├─ base/           # Base graphics components
  │ │ ├─ hdmi/           # HDMI interface modules
  │ │ ├─ lcd/            # LCD interface modules
  │ │ └─ vga/            # VGA interface modules
  │ ├─ periph/           # STM32-compatible peripherals
  │ │ ├─ afio/           # Alternate Function I/O
  │ │ ├─ exit/           # External interrupts
  │ │ ├─ gpio/           # General Purpose I/O
  │ │ ├─ uart/           # Universal Asynchronous Receiver/Transmitter
  │ │ ├─ tim/            # Timer modules
  │ │ ├─ spi/            # Serial Peripheral Interface
  │ │ ├─ i2c/            # Inter-Integrated Circuit
  │ │ ├─ wdg/            # Watchdog timers
  │ │ ├─ systick/        # System tick timer
  │ │ ├─ ram/            # RAM controllers
  │ │ └─ ddr/            # DDR memory controllers
  │ └─ soc/              # System-on-Chip with sample implementations
  ├─ /test/              # Test and example projects
  │ ├─ /project/         # FPGA project directories
  │ │ ├─ /tang_mega/
  │ │ └─ /tang_primer/
  │ └─ /software/        # Software project
  │   ├─ /bare/          # Bare-metal software package
  │   │ ├─ /cyber/
  │   │ ├─ /cyberwithddr/
  │   │ └─ /pinsec/
  │   └─ /rt-thread/     # RT-Thread RTOS support
  │     └─ /cyberplus/
  ├─ scripts/            # Development and build scripts
  │ ├─ jtag/             # JTAG tools
  │ ├─ InstExtractor.py  # Instruction extraction tool
  │ └─ InstExtractor.sh  # Shell wrapper for extraction
  ├─ build.sbt           # SBT build configuration
  └─ setup.sh            # Environment setup script
```



<!-- 关于本项目 -->
### 关于本项目

本项目基于 **STM32 兼容的外设与寄存器集**，采用 **SpinalHDL** 进行硬件设计与实现，旨在构建一个支持 **开源、兼容 STM32 固件** 的 RISC-V SoC 平台。
其设计目标是让开发者能够在 RISC-V 架构上直接复用 STM32 标准外设库及固件代码，同时为 FPGA 与 SoC 原型验证提供完善的硬件与软件环境。

项目整体分为两大部分：

1. **硬件设计** — 基于 SpinalHDL 的模块化 SoC 架构
2. **软件支持包** — 移植自 STM32 标准库的外设驱动与示例程序

项目内附带最小化 RISC-V SoC 示例代码、Gowin FPGA 完整工程、环境配置脚本与辅助工具，帮助用户快速上手与二次开发。

#### 背景与目标

在嵌入式开发领域，STM32 系列 MCU 因其丰富的外设与广泛的软件生态被大量应用。本项目的目标是：

* **硬件层面**：复刻 STM32 的寄存器与外设设计理念，将其移植到 RISC-V SoC 架构中，实现寄存器级别的兼容性。
* **软件层面**：通过完全兼容 STM32 标准外设库，让已有 STM32 固件能够最小化改动直接运行在 RISC-V SoC 上。
* **验证与实验**：提供适配 Gowin FPGA 的工程文件与测试固件，方便在实际硬件上进行 SoC 功能验证。

#### 硬件设计

硬件部分由 **SpinalHDL** 编写，结构分为 **外设 (Periph)**、**图形处理 (Graphic)** 与 **SoC 集成** 三大模块。

##### 1. Periph（外设模块）

* 包含常用 MCU 外设：
  `GPIO`、`EXTI`、`AFIO`、`UART`、`TIM`、`SPI`、`IIC`、`WDG`、`SysTick` 等
* 设计完全参考 STM32 数据手册：
  * 寄存器命名、地址映射保持一致
  * 寄存器功能几乎完全复现
  * 支持复杂中断、定时、外设交互等功能

##### 2. Graphic（图形与视频处理模块）

* 驱动层：`HDMI`、`VGA`、`LCD`
* 算法层：`卷积`、`滤波`、`边缘检测`、`颜色转换`、`颜色混合` 等
* DVTT 等模块设计参考 STM32 的 `LTDC + DMA2D` 架构，并扩展视频流处理功能
* 可用于图像显示、视频渲染、嵌入式视觉处理等场景

##### 3. SoC（集成与平台适配）

* 将外设与图形模块集成到 RISC-V SoC 架构中
* 针对 **Gowin FPGA** 的定制设计：
  * DDR 控制器
  * HDMI 视频接口
* 每个 Scala 文件内均包含可直接运行的 Demo，方便功能验证与调试

---

#### 软件支持包

软件部分针对硬件的 STM32 兼容特性，移植了 **STM32 标准外设库**，并提供多种运行环境：

* **pinsec**
  * SpinalHDL 原生 SoC 的软件支持包
* **cyber**
  * 使用本项目类 STM32 外设的 SoC 工程
  * 包含完整开发环境：
    * `Makefile`
    * 链接脚本 (`linker.ld`)
    * 启动文件 (`init.S`)
    * 用户示例 (`main.c`)
    * 移植后的 STM32 标准库驱动 (`libs/`)
* **cyberwithddr**
  * `cyber` 的升级版
  * 支持硬件 DDR，能将数据存储到 DDR 地址空间
  * 附带简单的 DDR 测试程序

---

#### 脚本工具

* **环境初始化** — `scripts/setup.sh`
  * 自动安装 `sbt`、`verilator`、`riscv-gnu-toolchain` 等工具
  * 下载必要的依赖与库文件
* **指令提取工具** — `scripts/InstExtractor.py`
  * 从编译生成的二进制文件中提取指令与数据
  * 生成 Verilog 格式的 `mem` 初始化文件
  * 可通过 `make mem` 或手动运行

---

#### Gowin FPGA 工程

目录 `test/tang_primer/` 内包含完整的 Gowin FPGA 工程文件：

* 全部硬件设计与 SoC 集成代码
* Gowin 官方 IP 核文件
* 引脚与时序约束文件

该工程可直接在 Gowin IDE 中编译、综合、烧录至目标开发板。



<!-- 使用示例 -->
### 使用示例

#### 基础GPIO控制
```c
#include "gpio.h"
#include "rcc.h"

int main() {
    // 初始化GPIO时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    
    // 配置GPIO引脚
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    
    // 切换LED
    while(1) {
        GPIO_SetBits(GPIOA, GPIO_Pin_0);
        delay_ms(500);
        GPIO_ResetBits(GPIOA, GPIO_Pin_0);
        delay_ms(500);
    }
}
```

#### UART通信
```c
#include "usart.h"
#include "gpio.h"

int main() {
    // 初始化UART
    USART_InitTypeDef USART_InitStructure;
    USART_InitStructure.USART_BaudRate = 115200;
    USART_InitStructure.USART_WordLength = USART_WordLength_8b;
    USART_InitStructure.USART_StopBits = USART_StopBits_1;
    USART_InitStructure.USART_Parity = USART_Parity_No;
    USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
    
    USART_Init(USART1, &USART_InitStructure);
    USART_Cmd(USART1, ENABLE);
    
    // 发送消息
    USART_SendString(USART1, "Hello OpenPeriph!\r\n");
}
```

#### 定时器配置
```c
#include "tim.h"

int main() {
    // 配置定时器
    TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
    TIM_TimeBaseStructure.TIM_Period = 9999;
    TIM_TimeBaseStructure.TIM_Prescaler = 7199;
    TIM_TimeBaseStructure.TIM_ClockDivision = TIM_CKD_DIV1;
    TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;
    TIM_TimeBaseInit(TIM2, &TIM_TimeBaseStructure);
    
    // 使能定时器中断
    TIM_ITConfig(TIM2, TIM_IT_Update, ENABLE);
    TIM_Cmd(TIM2, ENABLE);
}
```



<!-- 支持的外设 -->
### 支持的外设

#### 核心外设
| 外设 | 状态 | 功能特性 |
|------|------|----------|
| **GPIO** | ✅ 完整 | 输入/输出模式、中断支持、复用功能 |
| **EXTI** | ✅ 完整 | 外部中断控制器，支持边沿检测 |
| **AFIO** | ✅ 完整 | 复用功能I/O重映射 |
| **UART** | ✅ 完整 | 异步串行通信 |
| **TIM** | ✅ 完整 | 通用定时器，支持PWM、捕获、比较 |
| **SPI** | ✅ 完整 | 串行外设接口（主/从模式） |
| **I2C** | ✅ 完整 | 内部集成电路（主/从模式） |
| **WDG** | ✅ 完整 | 独立和窗口看门狗定时器 |
| **SysTick** | ✅ 完整 | 系统滴答定时器，支持RTOS |

#### 内存控制器
| 控制器 | 状态 | 功能特性 |
|--------|------|----------|
| **RAM** | ✅ 完整 | 内部RAM控制器 |
| **DDR3** | ✅ 完整 | DDR3内存控制器，支持AXI4接口 |

#### 图形和视频
| 接口 | 状态 | 功能特性 |
|------|------|----------|
| **HDMI** | ✅ 完整 | TMDS编码器、时钟域转换 |
| **VGA** | ✅ 完整 | RGB输出、时序生成 |
| **LCD** | ✅ 完整 | 并行LCD接口 |
| **DVTT** | ✅ 完整 | 数字视频时序控制器 |



<!-- 图形处理能力 -->
### 图形处理能力

#### 视频处理算法
- **卷积滤波器**: 3x3矩阵操作，用于图像滤波
- **边缘检测**: Sobel、Canny等边缘检测算法
- **颜色空间转换**: RGB ↔ YUV、RGB ↔ HSV转换
- **颜色混合**: Alpha混合和颜色混合操作
- **图像缩放**: 实时图像尺寸调整能力

#### 显示接口
- **HDMI 1.4**: 支持高达1080p分辨率
- **VGA**: 标准VGA输出（640x480到1920x1080）
- **LCD**: 并行LCD接口，可配置时序
- **DVI**: 数字视频接口支持

#### 性能特性
- **实时处理**: 硬件加速视频操作
- **DMA支持**: 直接内存访问，高效数据传输
- **多层支持**: 覆盖和混合能力
- **自定义时序**: 可配置视频时序参数



<!-- FPGA支持 -->
### FPGA支持

#### 支持的开发板
- **Tang Primer**: 入门级开发板
- **Tang Mega**: 高性能开发板
- **自定义设计**: 模块化架构支持自定义实现

#### FPGA资源
| 资源 | Tang Primer | Tang Mega |
|------|-------------|-----------|
| **逻辑单元** | 4.6K | 49.5K |
| **BRAM** | 20 | 270 |
| **DSP** | 4 | 144 |
| **PLL** | 2 | 4 |

#### 开发工作流
1. **设计输入**: SpinalHDL代码生成
2. **综合**: Gowin IDE综合和优化
3. **布局布线**: 自动布局和布线
4. **时序分析**: 静态时序分析
5. **比特流生成**: FPGA配置文件
6. **编程**: 基于USB的设备编程



<!-- 开发工作流 -->
### 开发工作流

#### 1. 硬件开发
```bash
# 编辑SpinalHDL源文件
vim src/main/scala/periph/gpio/apb3gpio.scala

# 编译并生成Verilog
sbt compile

# 运行仿真（如果可用）
sbt test
```

#### 2. 软件开发
```bash
# 导航到测试项目
cd test/cyber

# 编辑源文件
vim src/main.c

# 构建固件
make clean && make

# 生成内存初始化文件
make mem
```

#### 3. FPGA开发
```bash
# 打开Gowin IDE
# 从test/tang_primer/加载项目
# 运行综合和实现
# 生成比特流
# 编程FPGA
```

#### 4. 测试和验证
```bash
# 运行单元测试
sbt test

# 运行集成测试
cd test/cyber
make test

# 使用Verilator仿真
verilator --lint-only --top-module cyber
```

<p align="right">(<a href="#top">top</a>)</p>



<!-- 路线图 -->
## 路线图

- [ ] 1. 基础外设
  - GPIO; AFIO; EXIT; UART; SPI; I2C; TIM; WDG; SysTick;
- [ ] 2. 进阶外设
  - DDR; CRC
  - TODO: DMA; DMA2D; SDIO; CAN;
  - TODO: DDR; ctrl brust support;
- [ ] 3. 图形处理
  - DVTT; HDMI; VGA; LCD;
  - Algorithm: Convolution; Filtering; Edge Detection; Color Conversion;
  - TODO: DVTP Algorithm(Color Blending; Image Scaling;)

到 [open issues](https://github.com/MoonGrt/OpenPeriph/issues) 页查看所有请求的功能 （以及已知的问题）。

<p align="right">(<a href="#top">顶部</a>)</p>



<!-- 贡献 -->
### 贡献

欢迎通过以下方式参与本项目：

* 提交 Bug 报告
* 添加新的外设驱动或算法模块
* 优化现有 SpinalHDL 代码结构
* 编写更多测试用例或演示程序

如果你有好的建议，请复刻（fork）本仓库并且创建一个拉取请求（pull request）。你也可以简单地创建一个议题（issue），并且添加标签「enhancement」。不要忘记给项目点一个 star！再次感谢！

1. 复刻（Fork）本项目
2. 创建你的 Feature 分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的变更 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到该分支 (`git push origin feature/AmazingFeature`)
5. 创建一个拉取请求（Pull Request）
<p align="right">(<a href="#top">top</a>)</p>



<!-- 许可证 -->
### 许可证

根据 MIT 许可证分发。打开 [LICENSE](LICENSE) 查看更多内容。
<p align="right">(<a href="#top">top</a>)</p>



<!-- 联系我们 -->
### 联系我们

MoonGrt - 1561145394@qq.com
Project Link: [MoonGrt/OpenPeriph](https://github.com/MoonGrt/OpenPeriph)

<p align="right">(<a href="#top">top</a>)</p>



<!-- 致谢 -->
### 致谢

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [GitHub Pages](https://pages.github.com)
* [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) - 本项目使用的硬件描述语言
* [RISC-V Foundation](https://riscv.org/) - 开放标准指令集架构
* [STM32](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html) - 外设兼容性的参考架构
<p align="right">(<a href="#top">top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/MoonGrt/OpenPeriph.svg?style=for-the-badge
[contributors-url]: https://github.com/MoonGrt/OpenPeriph/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/MoonGrt/OpenPeriph.svg?style=for-the-badge
[forks-url]: https://github.com/MoonGrt/OpenPeriph/network/members
[stars-shield]: https://img.shields.io/github/stars/MoonGrt/OpenPeriph.svg?style=for-the-badge
[stars-url]: https://github.com/MoonGrt/OpenPeriph/stargazers
[issues-shield]: https://img.shields.io/github/issues/MoonGrt/OpenPeriph.svg?style=for-the-badge
[issues-url]: https://github.com/MoonGrt/OpenPeriph/issues
[license-shield]: https://img.shields.io/github/license/MoonGrt/OpenPeriph.svg?style=for-the-badge
[license-url]: https://github.com/MoonGrt/OpenPeriph/blob/master/LICENSE

