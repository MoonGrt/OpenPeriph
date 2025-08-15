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
    <li><a href="#文件树">文件树</a></li>
    <li>
      <a href="#关于本项目">关于本项目</a>
    </li>
    <li><a href="#贡献">贡献</a></li>
    <li><a href="#许可证">许可证</a></li>
    <li><a href="#联系我们">联系我们</a></li>
    <li><a href="#致谢">致谢</a></li>
  </ol>
</details>





<!-- 文件树 -->
## 文件树

```
└─ Project
  ├─ /src/main/scala/
  │ ├─ /graphic/      # Graphics and video processing module
  │ │ ├─ /algorithm/  # Video processing algorithms
  │ │ ├─ /base/
  │ │ ├─ /hdmi/
  │ │ ├─ /lcd/
  │ │ └─ /vga/
  │ ├─ /periph/       # Peripheral module
  │ │ ├─ /afio/
  │ │ ├─ /exit/
  │ │ ├─ /gpio/
  │ │ └─ /.../
  │ └─ /soc/          # SoC top-level and platform adaptation
  │   ├─ cyber.scala
  │   └─ /gowin/
  └─ /test/
    ├─ /cyber/        # Software support package for a class STM32 SoC
    │ ├─ linker.ld
    │ ├─ Makefile
    │ ├─ /libs/       # Ported STM32 standard library
    │ │ ├─ exti.h
    │ │ ├─ gpio.h
    │ │ ├─ i2c.h
    │ │ ├─ iwdg.h
    │ │ └─ ...
    │ └─ /src/
    │   ├─ config.h
    │   ├─ init.S
    │   └─ main.c
    ├─ /cyberwithddr/ # Versions that support DDR
    └─ /tang_primer/  # Gowin FPGA Project
```



<!-- 关于本项目 -->
## 关于本项目

本项目基于 **STM32 兼容的外设与寄存器集**，采用 **SpinalHDL** 进行硬件设计与实现，旨在构建一个支持 **开源、兼容 STM32 固件** 的 RISC-V SoC 平台。
其设计目标是让开发者能够在 RISC-V 架构上直接复用 STM32 标准外设库及固件代码，同时为 FPGA 与 SoC 原型验证提供完善的硬件与软件环境。

项目整体分为两大部分：

1. **硬件设计** — 基于 SpinalHDL 的模块化 SoC 架构
2. **软件支持包** — 移植自 STM32 标准库的外设驱动与示例程序

项目内附带最小化 RISC-V SoC 示例代码、Gowin FPGA 完整工程、环境配置脚本与辅助工具，帮助用户快速上手与二次开发。

### 背景与目标

在嵌入式开发领域，STM32 系列 MCU 因其丰富的外设与广泛的软件生态被大量应用。本项目的目标是：

* **硬件层面**：复刻 STM32 的寄存器与外设设计理念，将其移植到 RISC-V SoC 架构中，实现寄存器级别的兼容性。
* **软件层面**：通过完全兼容 STM32 标准外设库，让已有 STM32 固件能够最小化改动直接运行在 RISC-V SoC 上。
* **验证与实验**：提供适配 Gowin FPGA 的工程文件与测试固件，方便在实际硬件上进行 SoC 功能验证。

### 硬件设计

硬件部分由 **SpinalHDL** 编写，结构分为 **外设 (Periph)**、**图形处理 (Graphic)** 与 **SoC 集成** 三大模块。

#### 1. Periph（外设模块）

* 包含常用 MCU 外设：
  `GPIO`、`EXTI`、`AFIO`、`UART`、`TIM`、`SPI`、`IIC`、`WDG`、`SysTick` 等
* 设计完全参考 STM32 数据手册：
  * 寄存器命名、地址映射保持一致
  * 寄存器功能几乎完全复现
  * 支持复杂中断、定时、外设交互等功能

#### 2. Graphic（图形与视频处理模块）

* 驱动层：`HDMI`、`VGA`、`LCD`
* 算法层：`卷积`、`滤波`、`边缘检测`、`颜色转换`、`颜色混合` 等
* DVTC 等模块设计参考 STM32 的 `LTDC + DMA2D` 架构，并扩展视频流处理功能
* 可用于图像显示、视频渲染、嵌入式视觉处理等场景

#### 3. SoC（集成与平台适配）

* 将外设与图形模块集成到 RISC-V SoC 架构中
* 针对 **Gowin FPGA** 的定制设计：
  * DDR 控制器
  * HDMI 视频接口
* 每个 Scala 文件内均包含可直接运行的 Demo，方便功能验证与调试

---

### 软件支持包

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

### 脚本工具

* **环境初始化** — `scripts/setup.sh`
  * 自动安装 `sbt`、`verilator`、`riscv-gnu-toolchain` 等工具
  * 下载必要的依赖与库文件
* **指令提取工具** — `scripts/InstExtractor.py`
  * 从编译生成的二进制文件中提取指令与数据
  * 生成 Verilog 格式的 `mem` 初始化文件
  * 可通过 `make mem` 或手动运行

---

### Gowin FPGA 工程

目录 `test/tang_primer/` 内包含完整的 Gowin FPGA 工程文件：

* 全部硬件设计与 SoC 集成代码
* Gowin 官方 IP 核文件
* 引脚与时序约束文件

该工程可直接在 Gowin IDE 中编译、综合、烧录至目标开发板。


<p align="right">(<a href="#top">top</a>)</p>


<!-- 贡献 -->
## 贡献

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
## 许可证

根据 MIT 许可证分发。打开 [LICENSE](LICENSE) 查看更多内容。
<p align="right">(<a href="#top">top</a>)</p>



<!-- 联系我们 -->
## 联系我们

MoonGrt - 1561145394@qq.com
Project Link: [MoonGrt/OpenPeriph](https://github.com/MoonGrt/OpenPeriph)

<p align="right">(<a href="#top">top</a>)</p>



<!-- 致谢 -->
## 致谢

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [GitHub Pages](https://pages.github.com)
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

