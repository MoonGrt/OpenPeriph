// package soc

// import spinal.core._
// import spinal.lib._
// import spinal.lib.bus.amba3.apb._
// import spinal.lib.bus.misc.SizeMapping
// import periph._

// case class cyberwithspii2cConfig(
//     cpuFrequency: HertzNumber = 50 MHz,
//     memSize: BigInt = 8 kB,
//     memFile: String = null,
//     apb3Config: Apb3Config = Apb3Config(
//         addressWidth = 20,
//         dataWidth = 32
//     )
// )

// class cyberwithspii2c(config: cyberwithspii2cConfig) extends Component {
//   val io = new Bundle {
//     val gpioA = master(TriStateArray(16 bits))
//     val gpioB = master(TriStateArray(16 bits))
//     val gpioC = master(TriStateArray(16 bits))
//     val gpioD = master(TriStateArray(16 bits))
    
//     // SPI接口
//     val spi1 = master(SpiMaster())
//     val spi2 = master(SpiMaster())
    
//     // I2C接口
//     val i2c1 = master(I2cMaster())
//     val i2c2 = master(I2cMaster())
    
//     // UART接口
//     val uart = master(Uart())
    
//     // 中断
//     val interrupt = out(Bool())
//   }

//   // 时钟域
//   val clkCtrl = new ClockingArea(ClockDomain.current) {
//     // APB总线
//     val apb = Apb3(config.apb3Config)

//     // 外设实例化
//     val gpioA = Apb3Gpio(gpioWidth = 16)
//     val gpioB = Apb3Gpio(gpioWidth = 16)
//     val gpioC = Apb3Gpio(gpioWidth = 16)
//     val gpioD = Apb3Gpio(gpioWidth = 16)
    
//     val spi1 = Apb3Spi(
//       addressWidth = 7,
//       dataWidth = 32,
//       dataWidthMax = 16,
//       txFifoDepth = 16,
//       rxFifoDepth = 16
//     )
    
//     val spi2 = Apb3Spi(
//       addressWidth = 7,
//       dataWidth = 32,
//       dataWidthMax = 16,
//       txFifoDepth = 16,
//       rxFifoDepth = 16
//     )
    
//     val i2c1 = Apb3I2c(
//       addressWidth = 7,
//       dataWidth = 32,
//       dataWidthMax = 8,
//       txFifoDepth = 16,
//       rxFifoDepth = 16
//     )
    
//     val i2c2 = Apb3I2c(
//       addressWidth = 7,
//       dataWidth = 32,
//       dataWidthMax = 8,
//       txFifoDepth = 16,
//       rxFifoDepth = 16
//     )
    
//     val uart = Apb3Uart(Apb3UartCtrlConfig(
//       uartCtrlGenerics = UartCtrlGenerics(
//         dataWidthMax = 8,
//         clockDividerWidth = 20,
//         preSamplingSize = 1,
//         samplingSize = 5,
//         postSamplingSize = 2
//       ),
//       txFifoDepth = 16,
//       rxFifoDepth = 16,
//       apbAddressWidth = 5,
//       apbDataWidth = 32
//     ))

//     // APB总线仲裁器
//     val apbDecoder = Apb3Decoder(
//       master = apb,
//       slaves = List(
//         gpioA.io.apb -> SizeMapping(0x40010800, 1 kB),
//         gpioB.io.apb -> SizeMapping(0x40010C00, 1 kB),
//         gpioC.io.apb -> SizeMapping(0x40011000, 1 kB),
//         gpioD.io.apb -> SizeMapping(0x40011400, 1 kB),
//         spi1.io.apb -> SizeMapping(0x40013000, 1 kB),
//         spi2.io.apb -> SizeMapping(0x40013400, 1 kB),
//         i2c1.io.apb -> SizeMapping(0x40013800, 1 kB),
//         i2c2.io.apb -> SizeMapping(0x40013C00, 1 kB),
//         uart.io.apb -> SizeMapping(0x40014000, 1 kB)
//       )
//     )

//     // GPIO连接
//     io.gpioA <> gpioA.io.gpio
//     io.gpioB <> gpioB.io.gpio
//     io.gpioC <> gpioC.io.gpio
//     io.gpioD <> gpioD.io.gpio

//     // SPI连接
//     io.spi1 <> spi1.io.spi
//     io.spi2 <> spi2.io.spi

//     // I2C连接
//     io.i2c1 <> i2c1.io.i2c
//     io.i2c2 <> i2c2.io.i2c

//     // UART连接
//     io.uart <> uart.io.uart

//     // 中断连接
//     io.interrupt := gpioA.io.interrupt || gpioB.io.interrupt || 
//                    gpioC.io.interrupt || gpioD.io.interrupt ||
//                    spi1.io.interrupt || spi2.io.interrupt ||
//                    i2c1.io.interrupt || i2c2.io.interrupt ||
//                    uart.io.interrupt
//   }
// }

// // 生成Verilog的示例
// object cyberwithspii2c {
//   def main(args: Array[String]) {
//     val config = cyberwithspii2cConfig()
//     SpinalConfig(
//       targetDirectory = "rtl",
//       defaultConfigForClockDomains = ClockDomainConfig(
//         resetKind = BOOT
//       )
//     ).generateVerilog(new cyberwithspii2c(config))
//   }
// }
