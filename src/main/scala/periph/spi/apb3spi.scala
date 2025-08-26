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

object Apb3Spi {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

case class Apb3Spi(
    addressWidth: Int = 7,
    dataWidth: Int = 32,
    dataWidthMax: Int = 16,
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
  val SPE = CR1(6)    // SPI使能
  val MSTR = CR1(2)   // 主模式选择
  val BR = CR1(5 downto 3) // 波特率控制
  val CPOL = CR1(1)   // 时钟极性
  val CPHA = CR1(0)   // 时钟相位
  val DFF = CR1(11)   // 数据帧格式
  val CRCNEXT = CR1(12) // 下一个发送CRC
  val CRCEN = CR1(13) // 硬件CRC计算使能
  val BIDIOE = CR1(14) // 双向数据模式输出使能
  val BIDIMODE = CR1(15) // 双向数据模式使能
  val RXONLY = CR1(10) // 仅接收模式
  val SSM = CR1(8)     // 软件从机管理
  val SSI = CR1(7)     // 内部从机选择
  val LSBFIRST = CR1(7) // LSB优先
  val ERRIE = CR1(5)   // 错误中断使能
  val RXEIE = CR1(6)   // RX缓冲区非空中断使能
  val TXEIE = CR1(7)   // TX缓冲区空中断使能

  // CR2位域解析
  val TXDMAEN = CR2(1) // TX DMA使能
  val RXDMAEN = CR2(0) // RX DMA使能
  val SSOE = CR2(2)    // 从机选择输出使能
  val FRF = CR2(4)     // 帧格式
  val ERRIE_CR2 = CR2(5) // 错误中断使能
  val RXNEIE = CR2(6)  // RX缓冲区非空中断使能
  val TXEIE_CR2 = CR2(7) // TX缓冲区空中断使能

  // SR位域解析
  val BSY = SR(7)      // 忙标志
  val OVR = SR(6)      // 溢出标志
  val MODF = SR(5)     // 模式错误
  val CRCERR = SR(4)   // CRC错误标志
  val UDR = SR(3)      // 下溢标志
  val CHSIDE = SR(2)   // 通道边
  val TXE = SR(1)      // 发送缓冲区空
  val RXNE = SR(0)     // 接收缓冲区非空

  // FIFO实现
  val txFifo = StreamFifo(Bits(dataWidthMax bits), txFifoDepth)
  val rxFifo = StreamFifo(Bits(dataWidthMax bits), rxFifoDepth)

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
    val txValid = txFifo.io.pop.valid
    val txReady = txFifo.io.pop.ready
    val rxValid = rxFifo.io.push.valid
    val rxReady = rxFifo.io.push.ready
    val rxData = rxFifo.io.push.payload

    // 时钟分频器
    val clockDivider = Reg(UInt(8 bits)) init(0)
    val clockCounter = Reg(UInt(8 bits)) init(0)
    val clockTick = clockCounter === 0
    // 根据BR位计算分频值
    val dividerValues = Vec(U(2-1), U(4-1), U(8-1), U(16-1), U(32-1), U(64-1), U(128-1), U(256-1))
    clockDivider := dividerValues(BR)
    when(SPE) {
      clockCounter := clockCounter - 1
      when(clockTick) { clockCounter := clockDivider }
    }

    // SPI状态机
    val state = Reg(UInt(2 bits)) init(0)
    val bitCounter = Reg(UInt(4 bits)) init(0)
    val txShiftReg = Reg(Bits(dataWidthMax bits)) init(0)
    val rxShiftReg = Reg(Bits(dataWidthMax bits)) init(0)

    // 状态机逻辑
    io.spi.mosi := False
    txFifo.io.pop.ready := False
    rxFifo.io.push.valid := False
    rxFifo.io.push.payload := 0
    switch(state) {
      is(0) { // 空闲状态
        when(txValid && clockTick) {
          state := 1
          txShiftReg := txFifo.io.pop.payload
          bitCounter := 0
          txReady := True
        }
      }
      is(1) { // 发送状态
        when(clockTick) {
          // 发送数据
          io.spi.mosi := txShiftReg(dataWidthMax - 1)
          txShiftReg := txShiftReg(dataWidthMax - 2 downto 0) ## B"0"
          // 接收数据
          rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.spi.miso
          // CRC 更新
          when(CRCEN) {
            TXCRCR := crcUpdate(TXCRCR, io.spi.mosi.asBits)
            RXCRCR := crcUpdate(RXCRCR, io.spi.miso.asBits)
          }
          // 计数器更新
          bitCounter := bitCounter + 1
          when(bitCounter === Mux(DFF, U(15), U(7))) {
            state := 2
            // 将接收到的数据放入RX FIFO
            rxFifo.io.push.valid := True
            rxFifo.io.push.payload := rxShiftReg
          }
        }
      }
      is(2) { // 完成状态
        state := 0
        rxValid := True
      }
    }
    // 时钟输出
    io.spi.sclk := Mux(CPOL, !clockTick, clockTick)
  }

  // 状态寄存器更新
  SR(1) := txFifo.io.pop.ready // TXE
  SR(0) := rxFifo.io.pop.valid // RXNE
  SR(7) := spiMaster.state =/= 0 // BSY

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
      txFifo.io.push.payload := io.apb.PWDATA(dataWidthMax-1 downto 0).asBits
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
  io.spi.ss := !SSOE
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
