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
    <li><a href="#file-tree">File Tree</a></li>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
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
  ├─ /src/
  │ └─ /main/
  │   └─ /scala/
  │     ├─ /graphic/
  │     │ ├─ /algorithm/
  │     │ ├─ /base/
  │     │ ├─ /hdmi/
  │     │ ├─ /lcd/
  │     │ └─ /vga/
  │     ├─ /periph/
  │     │ ├─ /afio/
  │     │ ├─ /exit/
  │     │ ├─ /gpio/
  │     │ └─ /.../
  │     └─ /soc/
  │       ├─ cyber.scala
  │       └─ /gowin/
  └─ /test/
    ├─ /cyber/
    │ ├─ linker.ld
    │ ├─ Makefile
    │ ├─ /libs/
    │ │ ├─ exti.h
    │ │ ├─ gpio.h
    │ │ ├─ i2c.h
    │ │ ├─ iwdg.h
    │ │ └─ ...
    │ └─ /src/
    │   ├─ config.h
    │   ├─ init.S
    │   └─ main.c
    ├─ /cyberwithddr/
    └─ /tang_primer/
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
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)
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

