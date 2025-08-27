package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping

// SPI主接口定义
case class Spi() extends Bundle with IMasterSlave {
  val sclk = Bool()
  val mosi = Bool()
  val miso = Bool()
  val ss = Bool()

  override def asMaster(): Unit = {
    out(sclk, mosi, ss)
    in(miso)
  }
  override def asSlave(): Unit = {
    in(sclk, mosi, ss)
    out(miso)
  }
  override def clone = Spi()
}

// 定义两个状态机的状态
object SpiState extends SpinalEnum {
  val IDLE, LOAD, SHIFT, DONE = newElement()
}
object RxState extends SpinalEnum {
  val IDLE, SHIFT, DONE = newElement()
}

object Apb3Spi {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

case class Apb3Spi(
    addressWidth: Int = 7,
    dataWidth: Int = 32,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Spi.apb3Config(addressWidth, dataWidth)))
    val spi = master(Spi())
    val interrupt = out(Bool())
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 寄存器定义 - 按照STM32 SPI寄存器布局
  val CR1 = Reg(UInt(16 bits)) init(0) // 控制寄存器1
  val CR2 = Reg(UInt(16 bits)) init(0) // 控制寄存器2
  val SR = Reg(UInt(16 bits)) init(0)  // 状态寄存器
  val DR = Reg(UInt(16 bits)) init(0)  // 数据寄存器
  val CRCPR = Reg(UInt(16 bits)) init(0) // CRC多项式寄存器
  val RXCRCR = Reg(UInt(16 bits)) init(0) // 接收CRC寄存器
  val TXCRCR = Reg(UInt(16 bits)) init(0) // 发送CRC寄存器
  val I2SCFGR = Reg(UInt(16 bits)) init(0) // I2S配置寄存器
  val I2SPR = Reg(UInt(16 bits)) init(0) // I2S预分频寄存器

  // CR1位域解析
  val CPHA = CR1(0)        // 时钟相位
  val CPOL = CR1(1)        // 时钟极性
  val MSTR = CR1(2)        // 主模式选择
  val BR = CR1(5 downto 3) // 波特率控制
  val SPE = CR1(6)         // SPI使能
  val LSBFIRST = CR1(7)    // LSB优先
  val SSI = Bool()         // 内部从机选择 - CR1(8)
  val SSM = CR1(9)         // 软件从机管理
  val RXONLY = CR1(10)     // 仅接收模式
  val DFF = CR1(11)        // 数据帧格式
  val CRCNEXT = CR1(12)    // 下一个发送CRC
  val CRCEN = CR1(13)      // 硬件CRC计算使能
  val BIDIOE = CR1(14)     // 双向数据模式输出使能
  val BIDIMODE = CR1(15)   // 双向数据模式使能

  // CR2位域解析
  val RXDMAEN = CR2(0) // RX DMA使能
  val TXDMAEN = CR2(1) // TX DMA使能
  val SSOE = CR2(2)    // 从机选择输出使能
  val ERRIE = CR2(5)   // 错误中断使能
  val RXEIE = CR2(6)   // RX缓冲区非空中断使能
  val TXEIE = CR2(7)   // TX缓冲区空中断使能

  // SR位域解析
  val RXNE = SR(0)   // 接收缓冲区非空
  val TXE = SR(1)    // 发送缓冲区空
  val CHSIDE = SR(2) // 通道边
  val UDR = SR(3)    // 下溢标志
  val CRCERR = SR(4) // CRC错误标志
  val MODF = SR(5)   // 模式错误
  val OVR = SR(6)    // 溢出标志
  val BSY = SR(7)    // 忙标志

  // FIFO实现
  val txFifo = StreamFifo(Bits(16 bits), txFifoDepth)
  val rxFifo = StreamFifo(Bits(16 bits), rxFifoDepth)

  // CRC 更新函数（按字节更新）
  def crcUpdate(crc: UInt, data: Bits): UInt = {
    var next = crc
    for (i <- 0 until data.getWidth) {
      val xorBit = next.msb ^ data(i)
      next = (next << 1).resized ^ (CRCPR & U(xorBit ? B"16'hFFFF" | B"16'h0000"))
    }
    next
  }

  // SPI主控制器
  val spiMaster = new Area {
    // === FIFO 接口 ===
    val txValid = txFifo.io.pop.valid
    val txReady = txFifo.io.pop.ready
    val txData  = txFifo.io.pop.payload
    val rxValid = rxFifo.io.push.valid
    val rxReady = rxFifo.io.push.ready
    val rxData  = rxFifo.io.push.payload

    // === 分频器和SCLK ===
    val clockDivider = Reg(UInt(8 bits)) init(0)
    val clockCounter = Reg(UInt(8 bits)) init(0)
    val sclkToggle   = clockCounter === 0
    val sclkReg      = Reg(Bool) init(False)

    clockDivider := (U(1) << (BR + 1)) - 1

    when(SPE) {
      clockCounter := clockCounter - 1
      when(sclkToggle) {
        clockCounter := clockDivider
        sclkReg := ~sclkReg
      }
    }
    io.spi.sclk := sclkReg ^ CPOL

    // === 通用寄存器 ===
    val frameLength = Mux(DFF, U(16), U(8))

    // ================ SPI 状态机 ================
    val state      = RegInit(SpiState.IDLE)
    val rxShiftReg = Reg(Bits(16 bits)) init(0)
    val txShiftReg = Reg(Bits(16 bits)) init(0)
    val txBitCnt   = Reg(UInt(5 bits)) init(0)
    val rxBitCnt   = Reg(UInt(5 bits)) init(0)
    val mosiReg    = Reg(Bool) init(False)

    SSI := True
    txFifo.io.pop.ready := False
    rxFifo.io.push.valid := False
    rxFifo.io.push.payload := 0
    switch(state) {
      is(SpiState.IDLE) { // Idle
        mosiReg := True
        when(txValid && sclkToggle && (sclkReg === CPOL)) {
          txShiftReg := txData
          txBitCnt := 0
          rxBitCnt := 0
          state := SpiState.SHIFT
          txFifo.io.pop.ready := True
        }
      }
      is(SpiState.SHIFT) { // Shift out
        SSI := False
        when(sclkToggle && (sclkReg =/= (CPHA ^ CPOL))) {
          // 输出 MOSI
          when(frameLength === U(8)) {
            mosiReg := (LSBFIRST ? txShiftReg(0) | txShiftReg(7))
            txShiftReg := LSBFIRST ? (B"0" ## txShiftReg(7 downto 1)).resize(16) | (txShiftReg(6 downto 0) ## B"0").resize(16)
          } .otherwise {
            mosiReg := (LSBFIRST ? txShiftReg(0) | txShiftReg(15))
            txShiftReg := LSBFIRST ? (B"0" ## txShiftReg(15 downto 1)) | (txShiftReg(14 downto 0) ## B"0")
          }
          txBitCnt := txBitCnt + 1
          when(txBitCnt === frameLength) { state := SpiState.DONE }
        }
        when(sclkToggle && (sclkReg === (CPHA ^ CPOL))) {
          // 输出 MOSI
          when(frameLength === U(8)) {
            rxShiftReg := LSBFIRST ? (io.spi.miso ## rxShiftReg(7 downto 1)).resize(16) | (rxShiftReg(6 downto 0) ## io.spi.miso.asBits).resize(16)
          } .otherwise {
            rxShiftReg := LSBFIRST ? (io.spi.miso ## rxShiftReg(15 downto 1)) | (rxShiftReg(14 downto 0) ## io.spi.miso.asBits)
          }
          rxBitCnt := rxBitCnt + 1
        }
      }
      is(SpiState.DONE) {
        rxFifo.io.push.valid   := True
        rxFifo.io.push.payload := rxShiftReg
        state := SpiState.IDLE
      }
    }

    // ================ CRC 更新 (可选) ================
    when(sclkToggle) {
      when(CRCEN) {
        TXCRCR := crcUpdate(TXCRCR, io.spi.mosi.asBits)
        RXCRCR := crcUpdate(RXCRCR, io.spi.miso.asBits)
      }
    }
  }

  // 状态寄存器更新
  SR(0) := rxFifo.io.occupancy =/= 0 // RXNE
  SR(1) := txFifo.io.push.ready // TXE
  SR(2) := False // CHSIDE
  SR(3) := False // UDR
  SR(4) := CRCEN ? (RXCRCR =/= TXCRCR) | False // CRCERR
  SR(5) := False // MODF
  SR(6) := False // OVR
  SR(7) := spiMaster.state =/= SpiState.IDLE // BSY

  // 中断生成
  val txEmptyInterrupt = TXEIE && TXE
  val rxNotEmptyInterrupt = RXEIE && RXNE
  val errorInterrupt = ERRIE && (OVR || MODF || CRCERR || UDR)
  io.interrupt := txEmptyInterrupt || rxNotEmptyInterrupt || errorInterrupt

  // APB寄存器映射
  ctrl.readAndWrite(CR1, 0x00)
  ctrl.readAndWrite(CR2, 0x04)
  ctrl.read(SR, 0x08)

  // DR寄存器特殊处理
  ctrl.onWrite(0x0C) {
    when(TXE) {
      txFifo.io.push.valid := True
      txFifo.io.push.payload := io.apb.PWDATA(15 downto 0).asBits
    }
  }
  ctrl.onRead(0x0C) {
    when(RXNE) {
      rxFifo.io.pop.ready := True
      io.apb.PRDATA := rxFifo.io.pop.payload.resized
    }
  }

  ctrl.readAndWrite(CRCPR, 0x10)
  ctrl.read(RXCRCR, 0x14)
  ctrl.read(TXCRCR, 0x18)
  ctrl.readAndWrite(I2SCFGR, 0x1C)
  ctrl.readAndWrite(I2SPR, 0x20)

  // 默认连接
  txFifo.io.push.valid := False
  txFifo.io.push.payload := 0
  rxFifo.io.pop.ready := False
  io.spi.ss := (~SSM & SSOE) ? SSI | True
  io.spi.mosi := spiMaster.mosiReg
}

object Apb3SpiArray {
  def apb3Config(spiCnt: Int, spiSpace: Int, dataWidth: Int) =
    Apb3Config(
      addressWidth = log2Up(spiCnt) + log2Up(spiSpace),
      dataWidth = dataWidth
    )
}
case class Apb3SpiArray(
    spiCnt: Int = 4,
    spiSpace: Int = 0x40,
    addressWidth: Int = log2Up(0x40),
    dataWidth: Int = 32,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3SpiArray.apb3Config(spiCnt, spiSpace, dataWidth)))
    val spis = Vec(master(Spi()), spiCnt)
    val interrupt = out(Bits(spiCnt bits))
  }

  // 创建多个 SPI 控制器
  val SPI = for (_ <- 0 until spiCnt) yield Apb3Spi(addressWidth, dataWidth, txFifoDepth, rxFifoDepth)

  // 地址映射表：每个 SPI 模块分配 spiSpace 地址空间
  val apbMap = SPI.zipWithIndex.map { case (spi, idx) =>
    spi.io.apb -> SizeMapping(idx * spiSpace, spiSpace)
  }

  // 地址解码器
  val apbDecoder = Apb3Decoder(
    master = io.apb,
    slaves = apbMap
  )

  // SPI TX/RX 连接
  for ((spi, i) <- SPI.zipWithIndex) {
    io.spis(i) <> spi.io.spi
    io.interrupt(i) := spi.io.interrupt
  }
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3SpiGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3Spi()
//     )
//   }
// }

// object Apb3SpiArrayGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3SpiArray()
//     )
//   }
// }
