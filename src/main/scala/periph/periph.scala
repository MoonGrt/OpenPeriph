// package periph

// import spinal.core._
// import spinal.lib._
// import spinal.lib.bus.amba3.apb._
// import spinal.lib.com.uart.{UartCtrlGenerics}
// import spinal.lib.com.jtag.Jtag
// import spinal.lib.io.{TriStateArray}
// import spinal.lib.system.debugger.SystemDebuggerConfig

// class Apb3Periph(
//   addressWidth: Int = 32,
//   dataWidth: Int = 32,
//   gpioCount: Int = 32,
//   interruptCount: Int = 16
// ) extends Component {

//   val io = new Bundle {
//     // APB3 总线主控接口
//     val apb = slave(Apb3(Apb3Config(addressWidth, dataWidth)))
//     // GPIO 直接外露
//     val gpio = master(TriStateArray(gpioCount bits))
//     // 中断输出
//     val interrupt = out Bits(interruptCount bits)
//   }

//   /* ------------------------ 外设实例化 ------------------------ */
//   val afioCtrl = Apb3Afio(
//     gpioWidth = 16,
//     gpioGroupCnt = 2,
//     addressWidth = 5,
//     dataWidth = 32
//   )
//   val extiCtrl = Apb3Exti(extiWidth = 16)
//   val extiInterrupt = extiCtrl.io.interrupt.asBits.orR
//   extiCtrl.io.exti := afioCtrl.io.afioExti

//   val gpioCtrl = Apb3GpioArray(
//     gpioWidth = 16,
//     gpioGroupCnt = 2,
//     groupSpace = 0x1000,
//     withReadSync = true
//   )
//   gpioCtrl.io.afio := afioCtrl.io.afio.write
//   afioCtrl.io.afio.read := gpioCtrl.io.gpio.read
//   val timCtrl = Apb3TimArray(timCnt = 2, timSpace = 0x1000)
//   val timInterrupt = timCtrl.io.interrupt.asBits.orR
//   val wdgCtrl = Apb3Wdg(memSize = 0x1000)
//   val systickCtrl = Apb3SysTick()
//   val systickInterrupt = systickCtrl.io.interrupt.asBits.orR

//   val uartCtrl = Apb3UartArray(
//     uartCnt = 2,
//     uartSpace = 0x1000,
//     uartConfig = Apb3UartCtrlConfig(
//       uartCtrlGenerics = UartCtrlGenerics(
//         dataWidthMax = 9,
//         clockDividerWidth = 20,
//         preSamplingSize = 1,
//         samplingSize = 3,
//         postSamplingSize = 1
//       ),
//       txFifoDepth = 16,
//       rxFifoDepth = 16
//     )
//   )
//   val uartInterrupt = uartCtrl.io.interrupt.asBits.orR
//   val i2cCtrl = Apb3I2cArray(i2cCnt = 2, i2cSpace = 0x1000)
//   val i2cInterrupt = i2cCtrl.io.interrupt.asBits.orR
//   val spiCtrl = Apb3SpiArray(spiCnt = 2, spiSpace = 0x1000)
//   val spiInterrupt = spiCtrl.io.interrupt.asBits.orR

//   /* ------------------------ 设备引脚 AFIO ------------------------ */
//   afioCtrl.io.device.read :=
//     False ## // 31
//     spiCtrl.io.spis(1).mosi ## // 30
//     spiCtrl.io.spis(1).ss ## // 29
//     spiCtrl.io.spis(0).sclk ## // 28
//     False ## // 27
//     spiCtrl.io.spis(0).mosi ## // 26
//     spiCtrl.io.spis(0).ss ## // 25
//     spiCtrl.io.spis(0).sclk ## // 24
//     i2cCtrl.io.i2cs(1).scl ## // 23
//     i2cCtrl.io.i2cs(1).sda.write ## // 22
//     i2cCtrl.io.i2cs(0).scl ## // 21
//     i2cCtrl.io.i2cs(0).sda.write ## // 20
//     False ## // 19
//     uartCtrl.io.uarts(1).txd ## // 18
//     False ## // 17
//     uartCtrl.io.uarts(0).txd ## // 16
//     timCtrl.io.ch ## // 8 - 15
//     B(0, 8 bits) // 0 - 7

//   uartCtrl.io.uarts(0).rxd := afioCtrl.io.device.write(17)
//   uartCtrl.io.uarts(1).rxd := afioCtrl.io.device.write(19)
//   spiCtrl.io.spis(0).miso := afioCtrl.io.device.write(27)
//   spiCtrl.io.spis(1).miso := afioCtrl.io.device.write(31)
//   i2cCtrl.io.i2cs(0).sda.read := afioCtrl.io.device.write(20).asBits
//   i2cCtrl.io.i2cs(1).sda.read := afioCtrl.io.device.write(22).asBits

//   /* ------------------------ APB Decoder ------------------------ */
//   val apbDecoder = Apb3Decoder(
//     master = io.apb,
//     slaves = List(
//       gpioCtrl.io.apb -> (0x00000, 64 KiB),
//       uartCtrl.io.apb -> (0x10000, 64 KiB),
//       i2cCtrl.io.apb -> (0x20000, 64 KiB),
//       spiCtrl.io.apb -> (0x30000, 64 KiB),
//       timCtrl.io.apb -> (0x40000, 64 KiB),
//       wdgCtrl.io.apb -> (0x50000, 64 KiB),
//       systickCtrl.io.apb -> (0x60000, 64 KiB),
//       afioCtrl.io.apb -> (0xd0000, 64 KiB),
//       extiCtrl.io.apb -> (0xe0000, 64 KiB)
//     )
//   )

//   /* ------------------------ GPIO IO ------------------------ */
//   io.gpio <> gpioCtrl.io.gpio

//   /* ------------------------ Interrupt ------------------------ */
//   io.interrupt := B(interruptCount bits, default -> False)
//   if (interruptCount > 0) {
//     io.interrupt(0) := uartInterrupt
//     io.interrupt(1) := timInterrupt
//     io.interrupt(2) := systickInterrupt
//     io.interrupt(3) := extiInterrupt
//     io.interrupt(4) := i2cInterrupt
//     io.interrupt(15) := spiInterrupt
//   }
// }


// /* ----------------------------------------------------------------------------- */
// /* ---------------------------------- Demo Gen --------------------------------- */
// /* ----------------------------------------------------------------------------- */
// object Apb3PeriphGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       new Apb3Periph(
//         addressWidth = 20,
//         dataWidth = 32,
//         gpioCount = 32,
//         interruptCount = 16
//       )
//     )
//   }
// }


