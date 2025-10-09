**English | [简体中文](README_cn.md)**
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
    STM32-compatible peripheral & register set modeled in SpinalHDL. Includes a minimal RISC-V SoC demo for integration testing. Designed for reuse in open-source SoC projects with STM32 firmware compatibility.
    <br />
    <a href="https://github.com/MoonGrt/OpenPeriph"><strong>Explore the docs »</strong></a>
    <br />
    <a href="https://github.com/MoonGrt/OpenPeriph">View Demo</a>
    ·
    <a href="https://github.com/MoonGrt/OpenPeriph/issues">Report Bug</a>
    ·
    <a href="https://github.com/MoonGrt/OpenPeriph/issues">Request Feature</a>
    </p>
</div>




<!-- CONTENTS -->
<details open>
  <summary>Contents</summary>
  <ol>
    <li><a href="#features">Features</a></li>
    <li><a href="#quick-start">Quick Start</a></li>
    <li><a href="#system-requirements">System Requirements</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#file-tree">File Tree</a></li>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#usage-examples">Usage Examples</a></li>
    <li><a href="#supported-peripherals">Supported Peripherals</a></li>
    <li><a href="#graphics-capabilities">Graphics Capabilities</a></li>
    <li><a href="#fpga-support">FPGA Support</a></li>
    <li><a href="#development-workflow">Development Workflow</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- FILE TREE -->
## File Tree

```
└─ Project
  ├─ /docs/
  │ ├─ Openocd.md
  │ └─ SpinalHDL.md
  ├─ /scripts/
  ├─ /src/
  │ ├─ /main/
  │ │ └─ /scala/
  │ │   ├─ /core/
  │ │   ├─ /graphic/
  │ │   ├─ /periph/
  │ │   └─ /soc/
  └─ /test/
    ├─ /project/
    │ ├─ .gitignore
    │ ├─ /tang_mega/
    │ └─ /tang_primer/
    └─ /software/
      ├─ /bare/
      │ ├─ /cyber/
      │ ├─ /cyberpluswithddr/
      │ ├─ /cyberwithddr/
      │ └─ /pinsec/
      └─ /rt-thread/
        └─ /cyberplus/
```

<!-- FEATURES -->
## Features

### 🚀 **STM32 Compatibility**
- **Register-level compatibility** with STM32 peripherals
- **Direct firmware portability** - minimal code changes required
- **Complete peripheral library** ported from STM32 Standard Peripheral Library
- **Interrupt handling** compatible with STM32 architecture

### 🎯 **RISC-V SoC Platform**
- **RISC-V RV32IM** processor core integration
- **Modular SoC architecture** built with SpinalHDL
- **Multiple SoC variants** for different use cases
- **DDR memory support** for high-performance applications

### 🎨 **Advanced Graphics Processing**
- **HDMI/VGA/LCD** display interfaces
- **Real-time video processing** algorithms
- **Image filtering and convolution** operations
- **Color space conversion** and blending
- **Edge detection** and computer vision capabilities

### 🔧 **Development Tools**
- **Automated environment setup** scripts
- **Verilog generation** from SpinalHDL
- **Simulation support** with Verilator/GHDL
- **FPGA synthesis** ready for Gowin devices
- **Instruction extraction** tools for memory initialization

### 📱 **Hardware Support**
- **Gowin FPGA** development boards
- **Tang Primer** and **Tang Mega** support
- **DDR3 memory controller** integration
- **Multiple clock domains** management

<!-- QUICK START -->
## Quick Start

### Prerequisites
- Ubuntu 16.04+ or similar Linux distribution
- Git
- Python 3.6+

```bash
# 1. Clone the Repository
git clone https://github.com/MoonGrt/OpenPeriph.git
cd OpenPeriph

# 2. Setup Development Environment
# Run the automated setup script
chmod +x scripts/setup.sh
bash scripts/setup.sh all

# 3. Build and Test
# Build the SpinalHDL project
sbt run
# Run a simple peripheral test
cd test/cyber
make clean && make

# 4. FPGA Project (Optional)
# Open in Gowin IDE and synthesize

```

<!-- SYSTEM REQUIREMENTS -->
## System Requirements

### Development Environment
- **OS**: Linux (Ubuntu 18.04+ recommended)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 10GB free space
- **CPU**: Multi-core processor recommended

### Required Tools
- **Java 8+** (for SBT)
- **Scala 2.12.18** (managed by SBT)
- **SpinalHDL 1.12.0** (managed by SBT)
- **RISC-V GCC Toolchain**
- **Verilator 4.216+** (for simulation)
- **GHDL** (optional, for VHDL simulation)

### FPGA Development
- **Gowin IDE** (for FPGA synthesis)
- **Tang Primer** or **Tang Mega** development board
- **USB connection** for programming

<!-- INSTALLATION -->
## Installation

### Automated Installation (Recommended)
The project includes an automated setup script that installs all required tools:

```bash
bash scripts/setup.sh all
```

This script will install:
- SBT (Scala Build Tool)
- RISC-V GNU toolchain
- Verilator simulator
- GHDL simulator
- Cocotb testing framework
- Required system packages

### Manual Installation
If you prefer manual installation, follow these steps:

1. **Install SBT**
```bash
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt update
sudo apt install sbt
```

2. **Install RISC-V Toolchain**
```bash
sudo apt install gcc-riscv64-unknown-elf
```

3. **Install Verilator**
```bash
sudo apt install verilator
```

4. **Clone and Build**
```bash
git clone https://github.com/MoonGrt/OpenPeriph.git
cd OpenPeriph
sbt compile
```
5. ***VexRiscv** (optional)
```bash
$ git clone https://github.com/SpinalHDL/VexRiscv.git
$ cd VexRiscv
$ sbt publishLocal
```

<!-- FILE TREE -->
## File Tree

```
OpenPeriph/
├── src/main/scala/
│   ├── graphic/              # Graphics and video processing
│   │   ├── algorithm/        # Video processing algorithms
│   │   │   ├── FilterEngine/ # Convolution, filtering, edge detection
│   │   │   └── PixelUnit/    # Color conversion and blending
│   │   ├── base/             # Base graphics components
│   │   │   ├── dvtc/         # Digital Video Timing Controller
│   │   │   └── Color.scala   # Color space definitions
│   │   ├── hdmi/             # HDMI interface modules
│   │   ├── lcd/              # LCD interface modules
│   │   └── vga/              # VGA interface modules
│   ├── periph/               # STM32-compatible peripherals
│   │   ├── afio/             # Alternate Function I/O
│   │   ├── exit/             # External interrupts
│   │   ├── gpio/             # General Purpose I/O
│   │   ├── uart/             # Universal Asynchronous Receiver/Transmitter
│   │   ├── tim/              # Timer modules
│   │   ├── spi/              # Serial Peripheral Interface
│   │   ├── i2c/              # Inter-Integrated Circuit
│   │   ├── wdg/              # Watchdog timers
│   │   ├── systick/          # System tick timer
│   │   ├── ram/              # RAM controllers
│   │   └── ddr/              # DDR memory controllers
│   └── soc/                  # System-on-Chip integration
│       ├── cyber.scala       # Basic RISC-V SoC
│       ├── pinsec.scala      # SpinalHDL native SoC
│       └── gowin/            # Gowin FPGA specific designs
│           ├── cyberwithddr.scala
│           ├── cyberwithddrhdmi.scala
│           └── cyberwithddrlcd.scala
├── test/                     # Test and example projects
│   ├── cyber/                # Basic SoC software package
│   │   ├── libs/             # STM32-compatible libraries
│   │   ├── src/              # Example applications
│   │   ├── Makefile          # Build configuration
│   │   └── linker.ld         # Linker script
│   ├── cyberwithddr/         # DDR-enabled SoC
│   ├── pinsec/               # SpinalHDL native SoC
│   └── tang_primer/          # Gowin FPGA project files
├── scripts/                  # Development and build scripts
│   ├── setup.sh              # Environment setup script
│   ├── InstExtractor.py      # Instruction extraction tool
│   └── InstExtractor.sh      # Shell wrapper for extraction
├── docs/                     # Documentation
├── build.sbt                 # SBT build configuration
└── README.md                 # This file
```



<!-- ABOUT THE PROJECT -->
## About The Project

This project is based on the **STM32-compatible peripheral and register set** and uses **SpinalHDL** for hardware design and implementation, aiming to build a RISC-V SoC platform that supports **open-source, STM32-compatible firmware**.
Its design objective is to enable developers to directly reuse STM32 standard peripheral libraries and firmware code on the RISC-V architecture, while providing a comprehensive hardware and software environment for FPGA and SoC prototype verification.

The project is divided into two main parts:

1. **Hardware Design** — A modular SoC architecture based on SpinalHDL
2. **Software Support Package** — Peripheral drivers and example programs ported from the STM32 standard library  

The project includes minimal RISC-V SoC example code, a complete Gowin FPGA project, environment configuration scripts, and auxiliary tools to help users get started quickly and perform secondary development.

### Background and Objectives

In the field of embedded development, the STM32 series of MCUs are widely used due to their rich peripherals and extensive software ecosystem. The objectives of this project are:

* **Hardware Level**: Replicate the register and peripheral design philosophy of STM32 and port it to the RISC-V SoC architecture to achieve register-level compatibility.
* **Software Level**: Ensure full compatibility with the STM32 standard peripheral library, enabling existing STM32 firmware to run directly on the RISC-V SoC with minimal modifications.
* **Verification and Testing**: Provide engineering files and test firmware compatible with Gowin FPGA, facilitating SoC functionality verification on actual hardware.

---

### Hardware Design

The hardware part was written using **SpinalHDL** and is divided into three major modules: **Peripherals (Periph)**, **Graphics Processing (Graphic)**, and **SoC Integration**.

#### 1. Periph (Peripheral Module)

* Includes common MCU peripherals:
  `GPIO`, `EXTI`, `AFIO`, `UART`, `TIM`, `SPI`, `IIC`, `WDG`, `SysTick`, etc.
* Design fully references the STM32 data manual:
  * Register naming and address mapping remain consistent
  * Register functions are almost completely replicated
  * Supports complex interrupts, timing, peripheral interaction, and other functions

#### 2. Graphic (Graphics and Video Processing Module)

* Driver layer: `HDMI`, `VGA`, `LCD`
* Algorithm layer: `convolution`, `filtering`, `edge detection`, `color conversion`, `color blending`, etc.
* DVTC and other modules are designed based on the STM32 `LTDC + DMA2D` architecture and extended with video stream processing functionality
* Suitable for image display, video rendering, embedded vision processing, and other scenarios

#### 3. SoC (Integration and Platform Adaptation)

* Integrates peripherals and graphics modules into the RISC-V SoC architecture
* Customized design for **Gowin FPGA**:
  * DDR controller
  * HDMI video interface
* Each Scala file includes a directly executable demo for convenient functionality verification and debugging

---

### Software Support Package

The software component supports the STM32 compatibility features of the hardware and has ported the **STM32 Standard Peripheral Library**, providing multiple runtime environments:

* **pinsec**  
  * Software support package for SpinalHDL native SoCs
* **cyber**  
  * SoC project using STM32 peripherals from this project  
  * Includes a complete development environment:
* `Makefile`
* Linker script (`linker.ld`)
    * Boot file (`init.S`)
    * User example (`main.c`)
    * Ported STM32 standard library drivers (`libs/`)
* **cyberwithddr**
  * An upgraded version of `cyber`
  * Supports hardware DDR, enabling data storage in the DDR address space
  * Includes a simple DDR test program

---

### Script Tools

* **Environment Initialization** — `scripts/setup.sh`
  * Automatically installs tools such as `sbt`, `verilator`, and `riscv-gnu-toolchain`
  * Downloads necessary dependencies and library files
* **Instruction Extraction Tool** — `scripts/InstExtractor.py`
  * Extract instructions and data from the compiled binary files
  * Generate a Verilog-formatted `mem` initialization file
  * Can be run via `make mem` or manually

---

### Gowin FPGA Project

The directory `test/tang_primer/` contains the complete Gowin FPGA project files:

* All hardware design and SoC integration code
* Gowin official IP core files
* Pin and timing constraint files

This project can be directly compiled, synthesized, and burned to the target development board in the Gowin IDE.

<!-- USAGE EXAMPLES -->
## Usage Examples

### Basic GPIO Control
```c
#include "gpio.h"
#include "rcc.h"

int main() {
    // Initialize GPIO clock
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    
    // Configure GPIO pin
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    
    // Toggle LED
    while(1) {
        GPIO_SetBits(GPIOA, GPIO_Pin_0);
        delay_ms(500);
        GPIO_ResetBits(GPIOA, GPIO_Pin_0);
        delay_ms(500);
    }
}
```

### UART Communication
```c
#include "usart.h"
#include "gpio.h"

int main() {
    // Initialize UART
    USART_InitTypeDef USART_InitStructure;
    USART_InitStructure.USART_BaudRate = 115200;
    USART_InitStructure.USART_WordLength = USART_WordLength_8b;
    USART_InitStructure.USART_StopBits = USART_StopBits_1;
    USART_InitStructure.USART_Parity = USART_Parity_No;
    USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
    
    USART_Init(USART1, &USART_InitStructure);
    USART_Cmd(USART1, ENABLE);
    
    // Send message
    USART_SendString(USART1, "Hello OpenPeriph!\r\n");
}
```

### Timer Configuration
```c
#include "tim.h"

int main() {
    // Configure timer
    TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
    TIM_TimeBaseStructure.TIM_Period = 9999;
    TIM_TimeBaseStructure.TIM_Prescaler = 7199;
    TIM_TimeBaseStructure.TIM_ClockDivision = TIM_CKD_DIV1;
    TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;
    TIM_TimeBaseInit(TIM2, &TIM_TimeBaseStructure);
    
    // Enable timer interrupt
    TIM_ITConfig(TIM2, TIM_IT_Update, ENABLE);
    TIM_Cmd(TIM2, ENABLE);
}
```

<!-- SUPPORTED PERIPHERALS -->
## Supported Peripherals

### Core Peripherals
| Peripheral | Status | Features |
|------------|--------|----------|
| **GPIO** | ✅ Complete | Input/Output modes, interrupt support, alternate functions |
| **EXTI** | ✅ Complete | External interrupt controller with edge detection |
| **AFIO** | ✅ Complete | Alternate function I/O remapping |
| **UART** | ✅ Complete | Asynchronous serial communication |
| **TIM** | ✅ Complete | General-purpose timers with PWM, capture, compare |
| **SPI** | ✅ Complete | Serial peripheral interface (master/slave), FIFO support, CRC |
| **I2C** | ✅ Complete | Inter-integrated circuit (master/slave), SMBus support, clock stretching |
| **SDIO** | ✅ Complete | Secure digital I/O interface, SD card support, FIFO buffering |
| **CAN** | ✅ Complete | Controller area network, message filtering, error handling |
| **CRC** | ✅ Complete | Cyclic redundancy check, configurable polynomials, hardware acceleration |
| **WDG** | ✅ Complete | Independent and window watchdog timers |
| **SysTick** | ✅ Complete | System tick timer for RTOS support |

### Memory Controllers
| Controller | Status | Features |
|------------|--------|----------|
| **RAM** | ✅ Complete | Internal RAM controller |
| **DDR3** | ✅ Complete | DDR3 memory controller with AXI4 interface |

### Graphics and Video
| Interface | Status | Features |
|-----------|--------|----------|
| **HDMI** | ✅ Complete | TMDS encoder, clock domain crossing |
| **VGA** | ✅ Complete | RGB output with timing generation |
| **LCD** | ✅ Complete | Parallel LCD interface |
| **DVTC** | ✅ Complete | Digital video timing controller |

<!-- GRAPHICS CAPABILITIES -->
## Graphics Capabilities

### Video Processing Algorithms
- **Convolution Filters**: 3x3 matrix operations for image filtering
- **Edge Detection**: Sobel, Canny, and other edge detection algorithms
- **Color Space Conversion**: RGB ↔ YUV, RGB ↔ HSV conversions
- **Color Blending**: Alpha blending and color mixing operations
- **Image Scaling**: Real-time image resizing capabilities

### Display Interfaces
- **HDMI 1.4**: Up to 1080p resolution support
- **VGA**: Standard VGA output (640x480 to 1920x1080)
- **LCD**: Parallel LCD interface with configurable timing
- **DVI**: Digital video interface support

### Performance Features
- **Real-time Processing**: Hardware-accelerated video operations
- **DMA Support**: Direct memory access for efficient data transfer
- **Multi-layer Support**: Overlay and blending capabilities
- **Custom Timing**: Configurable video timing parameters

<!-- FPGA SUPPORT -->
## FPGA Support

### Supported Boards
- **Tang Primer**: Entry-level development board
- **Tang Mega**: High-performance development board
- **Custom Designs**: Modular architecture supports custom implementations

### FPGA Resources
| Resource | Tang Primer | Tang Mega |
|----------|-------------|-----------|
| **Logic Cells** | 4.6K | 49.5K |
| **BRAM** | 20 | 270 |
| **DSP** | 4 | 144 |
| **PLL** | 2 | 4 |

### Development Workflow
1. **Design Entry**: SpinalHDL code generation
2. **Synthesis**: Gowin IDE synthesis and optimization
3. **Place & Route**: Automatic placement and routing
4. **Timing Analysis**: Static timing analysis
5. **Bitstream Generation**: FPGA configuration file
6. **Programming**: USB-based device programming

<!-- DEVELOPMENT WORKFLOW -->
## Development Workflow

### 1. Hardware Development
```bash
# Edit SpinalHDL source files
vim src/main/scala/periph/gpio/apb3gpio.scala

# Compile and generate Verilog
sbt compile

# Run simulation (if available)
sbt test
```

### 2. Software Development
```bash
# Navigate to test project
cd test/cyber

# Edit source files
vim src/main.c

# Build firmware
make clean && make

# Generate memory initialization file
make mem
```

### 3. FPGA Development
```bash
# Open Gowin IDE
# Load project from test/tang_primer/
# Run synthesis and implementation
# Generate bitstream
# Program FPGA
```

### 4. Testing and Verification
```bash
# Run unit tests
sbt test

# Run integration tests
cd test/cyber
make test

# Simulate with Verilator
verilator --lint-only --top-module cyber
```

<p align="right">(<a href="#top">top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
<p align="right">(<a href="#top">top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.
<p align="right">(<a href="#top">top</a>)</p>



<!-- CONTACT -->
## Contact

MoonGrt - 1561145394@qq.com
Project Link: [MoonGrt/OpenPeriph](https://github.com/MoonGrt/OpenPeriph)
<p align="right">(<a href="#top">top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [GitHub Pages](https://pages.github.com)
* [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) - The hardware description language used in this project
* [RISC-V Foundation](https://riscv.org/) - Open standard instruction set architecture
* [STM32](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html) - Reference architecture for peripheral compatibility
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

