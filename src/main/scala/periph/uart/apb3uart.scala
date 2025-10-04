package periph

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping

case class Apb3UartCtrlConfig(
    uartCtrlGenerics: UartCtrlGenerics,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16,
    ctsGen: Boolean = false,
    rtsGen: Boolean = false,
    apbAddressWidth: Int = 5,
    apbDataWidth: Int = 32
)
case class Apb3Uart(config: Apb3UartCtrlConfig) extends Component {
  import config._
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth = apbAddressWidth, dataWidth = apbDataWidth)))
    val uart = master(Uart(ctsGen = ctsGen, rtsGen = rtsGen))
    val interrupt = out(Bool)
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  val tx = new uartCtrlTx(uartCtrlGenerics)
  val rx = new uartCtrlRx(uartCtrlGenerics)

  tx.io.break := False
  tx.io.cts := False
  rx.io.rxd := io.uart.rxd
  io.uart.txd := tx.io.txd

  // ========= FIFO ============
  val txFifo = StreamFifo(Bits(uartCtrlGenerics.dataWidthMax bits), txFifoDepth)
  val rxFifo = StreamFifo(Bits(uartCtrlGenerics.dataWidthMax bits), rxFifoDepth)
  // RX 连线
  rxFifo.io.push << rx.io.read
  // TX 连线
  tx.io.write << txFifo.io.pop

  // ========= 配置接口 =========
  val CR1, CR2, CR3, GTPR = Reg(UInt(16 bits)) init (0)
  val BRR = Reg(UInt(16 bits)) init (0)
  val DR = Reg(UInt(16 bits)) init (0)
  val SR = Reg(UInt(16 bits)) init (0)

  // 配置结构体
  val frame = UartCtrlFrameConfig(uartCtrlGenerics)
  frame.dataLength := Mux(CR1(12), U(9-1), U(8-1)) // 只支持8/9位数据位
  frame.parity := CR1(10 downto 9).as(UartParityType())
  frame.stop := CR2(13).as(UartStopType()) // 只支持 1、2位停止位
  tx.io.configFrame := frame
  rx.io.configFrame := frame

  // 状态寄存器
  SR := 0
  SR(7) := txFifo.io.push.ready // TXE
  SR(6) := txFifo.io.availability =/= 0 // TC
  SR(5) := rxFifo.io.occupancy =/= 0 // RXNE: 有数据可读
  SR(3) := rx.io.error // FE

  // 定时器
  val clockDivider = new Area {
    val counter = Reg(UInt(config.uartCtrlGenerics.clockDividerWidth bits)) init (0)
    val tick = counter === 0
    val tickReg = RegNext(tick) init (False)
    counter := counter - 1
    when(tick) { counter := BRR(15 downto 4).resized }
  }
  tx.io.samplingTick := clockDivider.tickReg
  rx.io.samplingTick := clockDivider.tickReg

  // 中断
  val feInterrupt   = CR1(4) && SR(3) // 帧错误中断
  val rxneInterrupt = CR1(5) && SR(5) // RXNE中断
  val tcInterrupt   = CR1(6) && SR(6) // TC中断
  val txeInterrupt  = CR1(7) && SR(7) // TXE中断
  val peInterrupt   = CR1(8) && SR(1) // 奇偶校验错误中断

  // 总中断输出：五种中断 OR 组合
  io.interrupt := rxneInterrupt || txeInterrupt || tcInterrupt || peInterrupt || feInterrupt

  // ========== APB 寄存器访问 ==========

  // DR 写入 -> 进入 TX FIFO
  txFifo.io.push.valid := False
  txFifo.io.push.payload := io.apb.PWDATA(uartCtrlGenerics.dataWidthMax-1 downto 0).asBits
  ctrl.onWrite(0x04) { when(txFifo.io.push.ready) { txFifo.io.push.valid := True } } // 只有当FIFO有空间时才能写

  // DR 读取 -> 从 RX FIFO
  rxFifo.io.pop.ready := False
  ctrl.onRead(0x04) {
    io.apb.PRDATA := 0 // 默认读0
    when(rxFifo.io.pop.valid) { // 如果FIFO非空
      io.apb.PRDATA(uartCtrlGenerics.dataWidthMax-1 downto 0) := rxFifo.io.pop.payload.asBits
      rxFifo.io.pop.ready := True
    }
  }

  // 映射寄存器
  ctrl.read(SR, 0x00)
  // ctrl.readAndWrite(DR, 0x04)
  ctrl.readAndWrite(BRR, 0x08)
  ctrl.readAndWrite(CR1, 0x0c)
  ctrl.readAndWrite(CR2, 0x10)
  ctrl.readAndWrite(CR3, 0x14)
  ctrl.readAndWrite(GTPR, 0x18)
}

object Apb3UartArray {
  def apb3Config(uartCnt: Int, uartSpace: Int, dataWidth: Int) =
    Apb3Config(
      addressWidth = log2Up(uartCnt) + log2Up(uartSpace),
      dataWidth = dataWidth
    )
}
case class Apb3UartArray(
    uartCnt: Int = 4,
    uartSpace: Int = 0x20,
    addressWidth: Int = log2Up(0x20),
    dataWidth: Int = 32,
    uartConfig: Apb3UartCtrlConfig
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3UartArray.apb3Config(uartCnt, uartSpace, dataWidth)))
    val uarts = Vec(master(Uart(ctsGen = uartConfig.ctsGen, rtsGen = uartConfig.rtsGen)), uartCnt)
    val interrupt = out(Bits(uartCnt bits))
  }

  // 创建多个 UART 控制器
  val UART = for (_ <- 0 until uartCnt) yield Apb3Uart(uartConfig)

  // 地址映射表：每个 UART 模块分配 uartSpace 地址空间
  val apbMap = UART.zipWithIndex.map { case (uart, idx) =>
    uart.io.apb -> SizeMapping(idx * uartSpace, uartSpace)
  }

  // 地址解码器
  val apbDecoder = Apb3Decoder(
    master = io.apb,
    slaves = apbMap
  )

  // UART TX/RX 连接
  for ((uart, i) <- UART.zipWithIndex) {
    io.uarts(i).txd <> uart.io.uart.txd
    uart.io.uart.rxd := io.uarts(i).rxd
    io.interrupt(i) := uart.io.interrupt
  }
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3UartGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3Uart(
//         Apb3UartCtrlConfig(
//           uartCtrlGenerics = UartCtrlGenerics(
//             dataWidthMax = 9,
//             clockDividerWidth = 20,
//             preSamplingSize = 1,
//             samplingSize = 3,
//             postSamplingSize = 2
//           ),
//           txFifoDepth = 16,
//           rxFifoDepth = 16
//         )
//       )
//     )
//   }
// }

// object Apb3UartArrayGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3UartArray(
//         uartCnt = 4,
//         uartSpace = 0x20,
//         uartConfig = Apb3UartCtrlConfig(
//           uartCtrlGenerics = UartCtrlGenerics(
//             dataWidthMax = 9,
//             clockDividerWidth = 20,
//             preSamplingSize = 1,
//             samplingSize = 3,
//             postSamplingSize = 1
//           ),
//           txFifoDepth = 16,
//           rxFifoDepth = 16,
//           ctsGen = false,
//           rtsGen = false
//         )
//       )
//     )
//   }
// }
