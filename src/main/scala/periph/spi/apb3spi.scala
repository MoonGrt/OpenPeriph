// package periph

// import spinal.core._
// import spinal.lib._
// import spinal.lib.bus.amba3.apb._
// import spinal.lib.bus.misc.SizeMapping

// object Apb3Spi {
//   def apb3Config(addressWidth: Int, dataWidth: Int) =
//     Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
// }

// case class Apb3Spi(
//     addressWidth: Int = 7,
//     dataWidth: Int = 32,
//     dataWidthMax: Int = 16,
//     txFifoDepth: Int = 16,
//     rxFifoDepth: Int = 16
// ) extends Component {
//   val io = new Bundle {
//     val apb = slave(Apb3(Apb3Spi.apb3Config(addressWidth, dataWidth)))
//     val spi = master(SpiMaster())
//     val interrupt = out(Bool())
//   }

//   val ctrl = Apb3SlaveFactory(io.apb)

//   def Reg16Init(value: Int = 0) = Reg(UInt(16 bits)) init (value)

//   // 寄存器定义 - 按照STM32 SPI寄存器布局
//   val CR1 = Reg16Init() // 控制寄存器1
//   val CR2 = Reg16Init() // 控制寄存器2
//   val SR = Reg16Init()  // 状态寄存器
//   val DR = Reg16Init()  // 数据寄存器
//   val CRCPR = Reg16Init() // CRC多项式寄存器
//   val RXCRCR = Reg16Init() // 接收CRC寄存器
//   val TXCRCR = Reg16Init() // 发送CRC寄存器
//   val I2SCFGR = Reg16Init() // I2S配置寄存器
//   val I2SPR = Reg16Init() // I2S预分频寄存器

//   // CR1位域解析
//   val SPE = CR1(6)    // SPI使能
//   val MSTR = CR1(2)   // 主模式选择
//   val BR = CR1(5 downto 3) // 波特率控制
//   val CPOL = CR1(1)   // 时钟极性
//   val CPHA = CR1(0)   // 时钟相位
//   val DFF = CR1(11)   // 数据帧格式
//   val CRCNEXT = CR1(12) // 下一个发送CRC
//   val CRCEN = CR1(13) // 硬件CRC计算使能
//   val BIDIOE = CR1(14) // 双向数据模式输出使能
//   val BIDIMODE = CR1(15) // 双向数据模式使能
//   val RXONLY = CR1(10) // 仅接收模式
//   val SSM = CR1(8)     // 软件从机管理
//   val SSI = CR1(7)     // 内部从机选择
//   val LSBFIRST = CR1(7) // LSB优先
//   val ERRIE = CR1(5)   // 错误中断使能
//   val RXEIE = CR1(6)   // RX缓冲区非空中断使能
//   val TXEIE = CR1(7)   // TX缓冲区空中断使能

//   // CR2位域解析
//   val TXDMAEN = CR2(1) // TX DMA使能
//   val RXDMAEN = CR2(0) // RX DMA使能
//   val SSOE = CR2(2)    // 从机选择输出使能
//   val FRF = CR2(4)     // 帧格式
//   val ERRIE_CR2 = CR2(5) // 错误中断使能
//   val RXNEIE = CR2(6)  // RX缓冲区非空中断使能
//   val TXEIE_CR2 = CR2(7) // TX缓冲区空中断使能

//   // SR位域解析
//   val BSY = SR(7)      // 忙标志
//   val OVR = SR(6)      // 溢出标志
//   val MODF = SR(5)     // 模式错误
//   val CRCERR = SR(4)   // CRC错误标志
//   val UDR = SR(3)      // 下溢标志
//   val CHSIDE = SR(2)   // 通道边
//   val TXE = SR(1)      // 发送缓冲区空
//   val RXNE = SR(0)     // 接收缓冲区非空

//   // FIFO实现
//   val txFifo = StreamFifo(Bits(dataWidthMax bits), txFifoDepth)
//   val rxFifo = StreamFifo(Bits(dataWidthMax bits), rxFifoDepth)

//   // SPI主控制器
//   val spiMaster = new Area {
//     val txValid = txFifo.io.pop.valid
//     val txReady = txFifo.io.pop.ready
//     val rxValid = rxFifo.io.push.valid
//     val rxReady = rxFifo.io.push.ready
//     val rxData = rxFifo.io.push.payload

//     // 时钟分频器
//     val clockDivider = Reg(UInt(8 bits)) init(0)
//     val clockCounter = Reg(UInt(8 bits)) init(0)
//     val clockTick = clockCounter === 0

//     // 根据BR位计算分频值
//     val dividerValues = Vec(
//       U(2), U(4), U(8), U(16), U(32), U(64), U(128), U(256)
//     )
//     clockDivider := dividerValues(BR)

//     when(SPE) {
//       clockCounter := clockCounter - 1
//       when(clockTick) {
//         clockCounter := clockDivider
//       }
//     }

//     // SPI状态机
//     val state = Reg(UInt(2 bits)) init(0)
//     val bitCounter = Reg(UInt(4 bits)) init(0)
//     val txShiftReg = Reg(Bits(dataWidthMax bits)) init(0)
//     val rxShiftReg = Reg(Bits(dataWidthMax bits)) init(0)

//     // 状态机逻辑
//     switch(state) {
//       is(0) { // 空闲状态
//         when(txValid && clockTick) {
//           state := 1
//           txShiftReg := txFifo.io.pop.payload
//           bitCounter := 0
//           txReady := True
//         }
//       }
//       is(1) { // 发送状态
//         when(clockTick) {
//           // 发送数据
//           io.spi.mosi := txShiftReg(dataWidthMax - 1)
//           txShiftReg := txShiftReg(dataWidthMax - 2 downto 0) ## B"0"
          
//           // 接收数据
//           rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.spi.miso
          
//           bitCounter := bitCounter + 1
//           when(bitCounter === (if(DFF) U(15) else U(7))) {
//             state := 2
//             // 将接收到的数据放入RX FIFO
//             rxFifo.io.push.valid := True
//             rxFifo.io.push.payload := rxShiftReg
//           }
//         }
//       }
//       is(2) { // 完成状态
//         state := 0
//         rxValid := True
//       }
//     }

//     // 时钟输出
//     io.spi.sclk := Mux(CPOL, !clockTick, clockTick)
//   }

//   // 状态寄存器更新
//   SR(1) := txFifo.io.pop.ready // TXE
//   SR(0) := rxFifo.io.pop.valid // RXNE
//   SR(7) := spiMaster.state =/= 0 // BSY

//   // 中断生成
//   val txEmptyInterrupt = TXEIE && TXE
//   val rxNotEmptyInterrupt = RXEIE && RXNE
//   val errorInterrupt = ERRIE && (OVR || MODF || CRCERR || UDR)

//   io.interrupt := txEmptyInterrupt || rxNotEmptyInterrupt || errorInterrupt

//   // APB寄存器映射
//   ctrl.readAndWrite(CR1, 0x00)
//   ctrl.readAndWrite(CR2, 0x04)
//   ctrl.read(SR, 0x08)
  
//   // DR寄存器特殊处理
//   ctrl.onWrite(0x0C) {
//     when(TXE) {
//       txFifo.io.push.valid := True
//       txFifo.io.push.payload := io.apb.PWDATA(dataWidthMax-1 downto 0).asBits
//     }
//   }
//   ctrl.onRead(0x0C) {
//     when(RXNE) {
//       rxFifo.io.pop.ready := True
//       io.apb.PRDATA := rxFifo.io.pop.payload.asUInt.resized
//     }
//   }

//   ctrl.readAndWrite(CRCPR, 0x10)
//   ctrl.read(RXCRCR, 0x14)
//   ctrl.read(TXCRCR, 0x18)
//   ctrl.readAndWrite(I2SCFGR, 0x1C)
//   ctrl.readAndWrite(I2SPR, 0x20)

//   // 默认连接
//   txFifo.io.push.valid := False
//   txFifo.io.push.payload := 0
//   rxFifo.io.pop.ready := False
//   io.spi.ss := !SSOE
// }

// // SPI主接口定义
// case class SpiMaster() extends Bundle with IMasterSlave {
//   val sclk = Bool()
//   val mosi = Bool()
//   val miso = Bool()
//   val ss = Bool()

//   override def asMaster(): Unit = {
//     out(sclk, mosi, ss)
//     in(miso)
//   }
// }
