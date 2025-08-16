// package periph

// import spinal.core._
// import spinal.lib._
// import spinal.lib.bus.amba3.apb._
// import spinal.lib.bus.misc.SizeMapping

// object Apb3Sdio {
//   def apb3Config(addressWidth: Int, dataWidth: Int) =
//     Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
// }

// case class Apb3Sdio(
//     addressWidth: Int = 7,
//     dataWidth: Int = 32,
//     txFifoDepth: Int = 32,
//     rxFifoDepth: Int = 32
// ) extends Component {
//   val io = new Bundle {
//     val apb = slave(Apb3(Apb3Sdio.apb3Config(addressWidth, dataWidth)))
//     val sdio = master(SdioMaster())
//     val interrupt = out(Bool())
//   }

//   val ctrl = Apb3SlaveFactory(io.apb)

//   def Reg32Init(value: Int = 0) = Reg(UInt(32 bits)) init (value)
//   def Reg16Init(value: Int = 0) = Reg(UInt(16 bits)) init (value)

//   // 寄存器定义 - 按照STM32 SDIO寄存器布局
//   val POWER = Reg16Init() // 电源控制寄存器
//   val CLKCR = Reg16Init() // 时钟控制寄存器
//   val ARG = Reg32Init()   // 参数寄存器
//   val CMD = Reg16Init()   // 命令寄存器
//   val RESPCMD = Reg16Init() // 响应命令寄存器
//   val RESP1 = Reg32Init() // 响应寄存器1
//   val RESP2 = Reg32Init() // 响应寄存器2
//   val RESP3 = Reg32Init() // 响应寄存器3
//   val RESP4 = Reg32Init() // 响应寄存器4
//   val DTIMER = Reg32Init() // 数据定时器寄存器
//   val DLEN = Reg32Init()  // 数据长度寄存器
//   val DCTRL = Reg16Init() // 数据控制寄存器
//   val DCOUNT = Reg32Init() // 数据计数器寄存器
//   val STA = Reg32Init()   // 状态寄存器
//   val ICR = Reg32Init()   // 中断清除寄存器
//   val MASK = Reg32Init()  // 中断屏蔽寄存器
//   val FIFOCNT = Reg32Init() // FIFO计数器寄存器
//   val FIFO = Reg32Init()  // FIFO数据寄存器

//   // POWER位域解析
//   val PWRCTRL = POWER(1 downto 0) // 电源控制

//   // CLKCR位域解析
//   val CLKDIV = CLKCR(7 downto 0)  // 时钟分频
//   val CLKEN = CLKCR(8)            // 时钟使能
//   val PWRSAV = CLKCR(9)           // 电源节省
//   val BYPASS = CLKCR(10)          // 时钟旁路
//   val WIDBUS = CLKCR(11 downto 10) // 总线宽度
//   val NEGEDGE = CLKCR(12)         // 时钟边沿
//   val HWFC_EN = CLKCR(13)         // 硬件流控制使能

//   // CMD位域解析
//   val CMDINDEX = CMD(5 downto 0)  // 命令索引
//   val WAITRESP = CMD(7 downto 6)  // 等待响应
//   val WAITINT = CMD(8)            // 等待中断
//   val WAITPEND = CMD(9)           // 等待挂起
//   val CPSMEN = CMD(10)            // CPSM使能
//   val SDIOSUSPEND = CMD(11)       // SDIO挂起
//   val ENCMDCOMPL = CMD(12)        // 命令完成使能
//   val NIEN = CMD(13)              // 中断使能
//   val CE_ATACMD = CMD(14)         // CE-ATA命令

//   // DCTRL位域解析
//   val DTEN = DCTRL(0)             // 数据传输使能
//   val DTDIR = DCTRL(1)            // 数据传输方向
//   val DTMODE = DCTRL(2)           // 数据传输模式
//   val DMAEN = DCTRL(3)            // DMA使能
//   val DBLOCKSIZE = DCTRL(7 downto 4) // 数据块大小
//   val PWSTART = DCTRL(8)          // 电源启动
//   val PWSTOP = DCTRL(9)           // 电源停止
//   val RWMOD = DCTRL(10)           // 读/写模式
//   val RWSTOP = DCTRL(11)          // 读/写停止

//   // STA位域解析
//   val CCRCFAIL = STA(0)           // 命令CRC失败
//   val DCRCFAIL = STA(1)           // 数据CRC失败
//   val CTIMEOUT = STA(2)           // 命令超时
//   val DTIMEOUT = STA(3)           // 数据超时
//   val TXUNDERR = STA(4)           // 发送下溢
//   val RXOVERR = STA(5)            // 接收溢出
//   val CMDREND = STA(6)            // 命令响应结束
//   val CMDSENT = STA(7)            // 命令发送
//   val DATAEND = STA(8)            // 数据结束
//   val STBITERR = STA(9)           // 起始位错误
//   val DBCKEND = STA(10)           // 数据块结束
//   val CMDACT = STA(11)            // 命令激活
//   val TXACT = STA(12)             // 发送激活
//   val RXACT = STA(13)             // 接收激活
//   val TXFIFOHE = STA(14)          // TX FIFO半空
//   val RXFIFOHF = STA(15)          // RX FIFO半满
//   val TXFIFOF = STA(16)           // TX FIFO满
//   val RXFIFOF = STA(17)           // RX FIFO满
//   val TXFIFOE = STA(18)           // TX FIFO空
//   val RXFIFOE = STA(19)           // RX FIFO空
//   val TXDAVL = STA(20)            // TX数据可用
//   val RXDAVL = STA(21)            // RX数据可用
//   val SDIOIT = STA(22)            // SDIO中断
//   val CEATAEND = STA(23)          // CE-ATA命令结束

//   // FIFO实现
//   val txFifo = StreamFifo(Bits(32 bits), txFifoDepth)
//   val rxFifo = StreamFifo(Bits(32 bits), rxFifoDepth)

//   // SDIO状态机
//   val sdioState = Reg(UInt(4 bits)) init(0)
//   val cmdState = Reg(UInt(3 bits)) init(0)
//   val dataState = Reg(UInt(3 bits)) init(0)
//   val cmdCounter = Reg(UInt(6 bits)) init(0)
//   val dataCounter = Reg(UInt(32 bits)) init(0)
//   val cmdShiftReg = Reg(Bits(48 bits)) init(0)
//   val dataShiftReg = Reg(Bits(32 bits)) init(0)

//   // 时钟分频器
//   val clockDivider = Reg(UInt(8 bits)) init(0)
//   val clockCounter = Reg(UInt(8 bits)) init(0)
//   val clockTick = clockCounter === 0

//   // 根据CLKDIV计算时钟分频
//   when(CLKEN) {
//     clockCounter := clockCounter - 1
//     when(clockTick) {
//       clockCounter := clockDivider
//     }
//   }

//   // SDIO命令状态机
//   val cmdMachine = new Area {
//     switch(cmdState) {
//       is(0) { // 空闲状态
//         when(CPSMEN && clockTick) {
//           cmdState := 1
//           cmdShiftReg := (CMDINDEX ## WAITRESP ## WAITINT ## WAITPEND ## 
//                          CPSMEN ## SDIOSUSPEND ## ENCMDCOMPL ## NIEN ## 
//                          CE_ATACMD ## ARG(31 downto 0)).asBits
//           cmdCounter := 0
//           STA(11) := True // CMDACT = 1
//         }
//       }
//       is(1) { // 发送命令
//         when(clockTick) {
//           io.sdio.cmd := cmdShiftReg(47)
//           cmdShiftReg := cmdShiftReg(46 downto 0) ## B"0"
//           cmdCounter := cmdCounter + 1
//           when(cmdCounter === 47) {
//             cmdState := 2
//             STA(7) := True // CMDSENT = 1
//           }
//         }
//       }
//       is(2) { // 等待响应
//         when(clockTick) {
//           when(WAITRESP =/= 0) {
//             // 接收响应
//             cmdShiftReg := cmdShiftReg(46 downto 0) ## io.sdio.cmd
//             cmdCounter := cmdCounter + 1
//             when(cmdCounter === 127) { // 长响应
//               cmdState := 3
//               STA(6) := True // CMDREND = 1
//               RESP1 := cmdShiftReg(127 downto 96).asUInt
//               RESP2 := cmdShiftReg(95 downto 64).asUInt
//               RESP3 := cmdShiftReg(63 downto 32).asUInt
//               RESP4 := cmdShiftReg(31 downto 0).asUInt
//             }.elsewhen(cmdCounter === 39) { // 短响应
//               cmdState := 3
//               STA(6) := True // CMDREND = 1
//               RESP1 := cmdShiftReg(39 downto 8).asUInt
//             }
//           }.otherwise {
//             cmdState := 3
//             STA(6) := True // CMDREND = 1
//           }
//         }
//       }
//       is(3) { // 命令完成
//         cmdState := 0
//         STA(11) := False // CMDACT = 0
//       }
//     }
//   }

//   // SDIO数据状态机
//   val dataMachine = new Area {
//     switch(dataState) {
//       is(0) { // 空闲状态
//         when(DTEN && clockTick) {
//           dataState := 1
//           dataCounter := 0
//           STA(12) := True // TXACT = 1 (如果写)
//           STA(13) := True // RXACT = 1 (如果读)
//         }
//       }
//       is(1) { // 数据传输
//         when(clockTick) {
//           when(DTDIR === False) { // 写数据
//             when(txFifo.io.pop.valid) {
//               dataShiftReg := txFifo.io.pop.payload
//               txFifo.io.pop.ready := True
//               dataState := 2
//             }
//           }.otherwise { // 读数据
//             dataState := 3
//           }
//         }
//       }
//       is(2) { // 发送数据
//         when(clockTick) {
//           io.sdio.data := dataShiftReg(31)
//           dataShiftReg := dataShiftReg(30 downto 0) ## B"0"
//           dataCounter := dataCounter + 1
//           when(dataCounter === 31) {
//             dataState := 4
//           }
//         }
//       }
//       is(3) { // 接收数据
//         when(clockTick) {
//           dataShiftReg := dataShiftReg(30 downto 0) ## io.sdio.data
//           dataCounter := dataCounter + 1
//           when(dataCounter === 31) {
//             rxFifo.io.push.valid := True
//             rxFifo.io.push.payload := dataShiftReg
//             dataState := 4
//           }
//         }
//       }
//       is(4) { // 数据块结束
//         when(dataCounter >= DLEN) {
//           dataState := 0
//           STA(8) := True // DATAEND = 1
//           STA(10) := True // DBCKEND = 1
//           STA(12) := False // TXACT = 0
//           STA(13) := False // RXACT = 0
//         }.otherwise {
//           dataState := 1 // 继续下一个数据块
//         }
//       }
//     }
//   }

//   // 状态寄存器更新
//   STA(14) := txFifo.io.availability <= txFifoDepth/2 // TXFIFOHE
//   STA(15) := rxFifo.io.occupancy >= rxFifoDepth/2    // RXFIFOHF
//   STA(16) := txFifo.io.availability === 0            // TXFIFOF
//   STA(17) := rxFifo.io.occupancy === rxFifoDepth     // RXFIFOF
//   STA(18) := txFifo.io.pop.ready                     // TXFIFOE
//   STA(19) := rxFifo.io.pop.valid                     // RXFIFOE
//   STA(20) := txFifo.io.pop.valid                     // TXDAVL
//   STA(21) := rxFifo.io.pop.valid                     // RXDAVL

//   // 中断生成
//   val cmdInterrupt = !NIEN && (CMDREND || CMDSENT)
//   val dataInterrupt = !NIEN && (DATAEND || DBCKEND)
//   val errorInterrupt = !NIEN && (CCRCFAIL || DCRCFAIL || CTIMEOUT || DTIMEOUT || TXUNDERR || RXOVERR || STBITERR)
//   val fifoInterrupt = !NIEN && (TXFIFOHE || RXFIFOHF || TXFIFOF || RXFIFOF || TXFIFOE || RXFIFOE)

//   io.interrupt := cmdInterrupt || dataInterrupt || errorInterrupt || fifoInterrupt

//   // APB寄存器映射
//   ctrl.readAndWrite(POWER, 0x00)
//   ctrl.readAndWrite(CLKCR, 0x04)
//   ctrl.readAndWrite(ARG, 0x08)
//   ctrl.readAndWrite(CMD, 0x0C)
//   ctrl.read(RESPCMD, 0x10)
//   ctrl.read(RESP1, 0x14)
//   ctrl.read(RESP2, 0x18)
//   ctrl.read(RESP3, 0x1C)
//   ctrl.read(RESP4, 0x20)
//   ctrl.readAndWrite(DTIMER, 0x24)
//   ctrl.readAndWrite(DLEN, 0x28)
//   ctrl.readAndWrite(DCTRL, 0x2C)
//   ctrl.read(DCOUNT, 0x30)
//   ctrl.read(STA, 0x34)
//   ctrl.readAndWrite(ICR, 0x38)
//   ctrl.readAndWrite(MASK, 0x3C)
//   ctrl.read(FIFOCNT, 0x40)
  
//   // FIFO寄存器特殊处理
//   ctrl.onWrite(0x44) {
//     when(TXDAVL) {
//       txFifo.io.push.valid := True
//       txFifo.io.push.payload := io.apb.PWDATA.asBits
//     }
//   }
//   ctrl.onRead(0x44) {
//     when(RXDAVL) {
//       rxFifo.io.pop.ready := True
//       io.apb.PRDATA := rxFifo.io.pop.payload.asUInt
//     }
//   }

//   // 默认连接
//   txFifo.io.push.valid := False
//   txFifo.io.push.payload := 0
//   rxFifo.io.pop.ready := False
//   io.sdio.clk := clockTick
//   io.sdio.cmd := True
//   io.sdio.data := True
// }

// // SDIO主接口定义
// case class SdioMaster() extends Bundle with IMasterSlave {
//   val clk = Bool()
//   val cmd = Bool()
//   val data = Bool()

//   override def asMaster(): Unit = {
//     out(clk)
//     inout(cmd) // 双向
//     inout(data) // 双向
//   }
// }
