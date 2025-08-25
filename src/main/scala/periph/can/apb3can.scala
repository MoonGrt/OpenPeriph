package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping

// CAN主接口定义
case class Can() extends Bundle with IMasterSlave {
  val tx = Bool()
  val rx = Bool()

  override def asMaster(): Unit = {
    out(tx)
    in(rx)
  }
  override def asSlave(): Unit = {
    in(tx)
    out(rx)
  }
  override def clone = Can()
}

object Apb3Can {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

case class Apb3Can(
    addressWidth: Int = 10,
    dataWidth: Int = 32,
    dataWidthMax: Int = 128,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Can.apb3Config(addressWidth, dataWidth)))
    val can = master(Can())
    val interrupt = out(Bool())
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 寄存器定义 - 按照STM32 CAN寄存器布局
  val MCR = Reg(UInt(32 bits)) init(0)   // 主控制寄存器
  val MSR = Reg(UInt(32 bits)) init(0)   // 主状态寄存器
  val TSR = Reg(UInt(32 bits)) init(0)   // 发送状态寄存器
  val RF0R = Reg(UInt(32 bits)) init(0)  // 接收FIFO0寄存器
  val RF1R = Reg(UInt(32 bits)) init(0)  // 接收FIFO1寄存器
  val IER = Reg(UInt(32 bits)) init(0)   // 中断使能寄存器
  val ESR = Reg(UInt(32 bits)) init(0)   // 错误状态寄存器
  val BTR = Reg(UInt(32 bits)) init(0)   // 位时序寄存器
  val TI0R = Reg(UInt(32 bits)) init(0)  // 发送邮箱标识符寄存器0
  val TDT0R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据长度控制寄存器0
  val TDL0R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据寄存器0低
  val TDH0R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据寄存器0高
  val TI1R = Reg(UInt(32 bits)) init(0)  // 发送邮箱标识符寄存器1
  val TDT1R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据长度控制寄存器1
  val TDL1R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据寄存器1低
  val TDH1R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据寄存器1高
  val TI2R = Reg(UInt(32 bits)) init(0)  // 发送邮箱标识符寄存器2
  val TDT2R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据长度控制寄存器2
  val TDL2R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据寄存器2低
  val TDH2R = Reg(UInt(32 bits)) init(0) // 发送邮箱数据寄存器2高
  val RI0R = Reg(UInt(32 bits)) init(0)  // 接收邮箱标识符寄存器0
  val RDT0R = Reg(UInt(32 bits)) init(0) // 接收邮箱数据长度控制寄存器0
  val RDL0R = Reg(UInt(32 bits)) init(0) // 接收邮箱数据寄存器0低
  val RDH0R = Reg(UInt(32 bits)) init(0) // 接收邮箱数据寄存器0高
  val RI1R = Reg(UInt(32 bits)) init(0)  // 接收邮箱标识符寄存器1
  val RDT1R = Reg(UInt(32 bits)) init(0) // 接收邮箱数据长度控制寄存器1
  val RDL1R = Reg(UInt(32 bits)) init(0) // 接收邮箱数据寄存器1低
  val RDH1R = Reg(UInt(32 bits)) init(0) // 接收邮箱数据寄存器1高
  val FMR = Reg(UInt(32 bits)) init(0)   // 过滤器主寄存器
  val FM1R = Reg(UInt(32 bits)) init(0)  // 过滤器模式寄存器
  val FS1R = Reg(UInt(32 bits)) init(0)  // 过滤器尺度寄存器
  val FFA1R = Reg(UInt(32 bits)) init(0) // 过滤器分配寄存器
  val FA1R = Reg(UInt(32 bits)) init(0)  // 过滤器激活寄存器
  val F0R1 = Reg(UInt(32 bits)) init(0)  // 过滤器组0寄存器1
  val F0R2 = Reg(UInt(32 bits)) init(0)  // 过滤器组0寄存器2
  val F1R1 = Reg(UInt(32 bits)) init(0)  // 过滤器组1寄存器1
  val F1R2 = Reg(UInt(32 bits)) init(0)  // 过滤器组1寄存器2

  // MCR位域解析
  val INRQ = MCR(0)   // 初始化请求
  val SLEEP = MCR(1)  // 睡眠模式
  val TXFP = MCR(2)   // 发送FIFO优先级
  val RFLM = MCR(3)   // 接收FIFO锁定模式
  val NART = MCR(4)   // 非自动重传
  val AWUM = MCR(5)   // 自动唤醒模式
  val ABOM = MCR(6)   // 自动总线关闭管理
  val TTCM = MCR(7)   // 时间触发通信模式
  val RESET = MCR(15) // 软件复位

  // MSR位域解析
  val INAK = MSR(0)  // 初始化确认
  val SLAK = MSR(1)  // 睡眠确认
  val ERRI = MSR(2)  // 错误中断
  val WKUI = MSR(3)  // 唤醒中断
  val SLAKI = MSR(4) // 睡眠确认中断
  val TXM = MSR(8)   // 发送模式
  val RXM = MSR(9)   // 接收模式
  val SAMP = MSR(10) // 最后采样点
  val RX = MSR(11)   // 接收电平

  // TSR位域解析
  val RQCP0 = TSR(0)  // 请求完成邮箱0
  val TXOK0 = TSR(1)  // 发送完成邮箱0
  val ALST0 = TSR(2)  // 仲裁丢失邮箱0
  val TERR0 = TSR(3)  // 发送错误邮箱0
  val ABRQ0 = TSR(7)  // 中止请求邮箱0
  val RQCP1 = TSR(8)  // 请求完成邮箱1
  val TXOK1 = TSR(9)  // 发送完成邮箱1
  val ALST1 = TSR(10) // 仲裁丢失邮箱1
  val TERR1 = TSR(11) // 发送错误邮箱1
  val ABRQ1 = TSR(15) // 中止请求邮箱1
  val RQCP2 = TSR(16) // 请求完成邮箱2
  val TXOK2 = TSR(17) // 发送完成邮箱2
  val ALST2 = TSR(18) // 仲裁丢失邮箱2
  val TERR2 = TSR(19) // 发送错误邮箱2
  val ABRQ2 = TSR(23) // 中止请求邮箱2
  val CODE = TSR(25 downto 24) // 邮箱代码

  // BTR位域解析
  val BRP = BTR(9 downto 0)   // 波特率预分频器
  val TS1 = BTR(12 downto 10) // 时间段1
  val TS2 = BTR(15 downto 13) // 时间段2
  val SJW = BTR(17 downto 16) // 重同步跳跃宽度
  val LBKM = BTR(30)          // 环回模式
  val SILM = BTR(31)          // 静默模式

  // FIFO实现
  val txFifo = StreamFifo(Bits(dataWidth bits), txFifoDepth)
  val rxFifo = StreamFifo(Bits(dataWidth bits), rxFifoDepth)

  // CAN状态机
  val canState = Reg(UInt(2 bits)) init(0)
  val txState = Reg(UInt(3 bits)) init(0)
  val rxState = Reg(UInt(3 bits)) init(0)
  val bitCounter = Reg(UInt(8 bits)) init(0)
  val txShiftReg = Reg(Bits(dataWidthMax bits)) init(0) // CAN帧最大长度
  val rxShiftReg = Reg(Bits(dataWidthMax bits)) init(0)

  // 时钟分频器
  val clockDivider = Reg(UInt(10 bits)) init(0)
  val clockCounter = Reg(UInt(10 bits)) init(0)
  val clockTick = clockCounter === 0

  // 根据BRP计算时钟分频
  when(!INRQ) {
    clockCounter := clockCounter - 1
    when(clockTick) { clockCounter := clockDivider }
  }

  // CAN发送状态机
  io.can.tx := True // 默认高电平
  txFifo.io.pop.ready := False
  rxFifo.io.push.valid := False
  rxFifo.io.push.payload := 0
  val txMachine = new Area {
    switch(txState) {
      is(0) { // 空闲状态
        when(txFifo.io.pop.valid && TXM && clockTick) {
          txState := 1
          txShiftReg := (txFifo.io.pop.payload).resized // TODO: error
          txFifo.io.pop.ready := True
          bitCounter := 0
          // 开始发送SOF
          io.can.tx := False
        }
      }
      is(1) { // 发送SOF
        when(clockTick) {
          io.can.tx := False // SOF位
          bitCounter := bitCounter + 1
          txState := 2
        }
      }
      is(2) { // 发送标识符
        when(clockTick) {
          io.can.tx := txShiftReg((dataWidthMax - 1 - bitCounter).resized)
          bitCounter := bitCounter + 1
          when(bitCounter === 11) { // 11位标识符
            txState := 3
          }
        }
      }
      is(3) { // 发送控制字段
        when(clockTick) {
          io.can.tx := txShiftReg((dataWidthMax - 1 - bitCounter).resized)
          bitCounter := bitCounter + 1
          when(bitCounter === 19) { // 控制字段6位
            txState := 4
          }
        }
      }
      is(4) { // 发送数据
        when(clockTick) {
          io.can.tx := txShiftReg((dataWidthMax - 1 - bitCounter).resized)
          bitCounter := bitCounter + 1
          when(bitCounter === 83) { // 数据字段64位
            txState := 5
          }
        }
      }
      is(5) { // 发送CRC
        when(clockTick) {
          io.can.tx := txShiftReg((dataWidthMax - 1 - bitCounter).resized)
          bitCounter := bitCounter + 1
          when(bitCounter === 99) { // CRC字段15位
            txState := 6
          }
        }
      }
      is(6) { // 发送ACK
        when(clockTick) {
          io.can.tx := True // ACK位
          bitCounter := bitCounter + 1
          txState := 7
        }
      }
      is(7) { // 发送EOF
        when(clockTick) {
          io.can.tx := True // EOF位
          bitCounter := bitCounter + 1
          when(bitCounter === 111) { // EOF字段7位
            txState := 0
            TXOK0 := True // 发送成功
            RQCP0 := True // 请求完成
          }
        }
      }
    }
  }

  // CAN接收状态机
  val rxMachine = new Area {
    switch(rxState) {
      is(0) { // 空闲状态
        when(RXM && !io.can.rx && clockTick) { // 检测SOF
          rxState := 1
          bitCounter := 0
          rxShiftReg := 0
        }
      }
      is(1) { // 接收标识符
        when(clockTick) {
          rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.can.rx
          bitCounter := bitCounter + 1
          when(bitCounter === 11) { // 11位标识符
            rxState := 2
          }
        }
      }
      is(2) { // 接收控制字段
        when(clockTick) {
          rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.can.rx
          bitCounter := bitCounter + 1
          when(bitCounter === 19) { // 控制字段6位
            rxState := 3
          }
        }
      }
      is(3) { // 接收数据
        when(clockTick) {
          rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.can.rx
          bitCounter := bitCounter + 1
          when(bitCounter === 83) { // 数据字段64位
            rxState := 4
          }
        }
      }
      is(4) { // 接收CRC
        when(clockTick) {
          rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.can.rx
          bitCounter := bitCounter + 1
          when(bitCounter === 99) { // CRC字段15位
            rxState := 5
          }
        }
      }
      is(5) { // 接收ACK
        when(clockTick) {
          bitCounter := bitCounter + 1
          rxState := 6
        }
      }
      is(6) { // 接收EOF
        when(clockTick) {
          bitCounter := bitCounter + 1
          when(bitCounter === 111) { // EOF字段7位
            rxState := 0
            // 将接收到的数据放入RX FIFO
            rxFifo.io.push.valid := True
            rxFifo.io.push.payload := rxShiftReg(127 downto 96)
            // 更新接收寄存器
            RI0R := rxShiftReg(127 downto 96).asUInt
            RDT0R := rxShiftReg(95 downto 64).asUInt
            RDL0R := rxShiftReg(63 downto 32).asUInt
            RDH0R := rxShiftReg(31 downto 0).asUInt
          }
        }
      }
    }
  }

  // 状态寄存器更新
  MSR(0) := canState === 0 // INAK
  MSR(1) := canState === 1 // SLAK
  MSR(8) := txState =/= 0  // TXM
  MSR(9) := rxState =/= 0  // RXM
  MSR(11) := io.can.rx     // RX

  // 中断生成
  val txInterrupt = IER(0) && (TXOK0 || TXOK1 || TXOK2)
  val rxInterrupt = IER(1) && rxFifo.io.pop.valid
  val errorInterrupt = IER(2) && (TERR0 || TERR1 || TERR2)
  val wakeupInterrupt = IER(3) && WKUI

  io.interrupt := txInterrupt || rxInterrupt || errorInterrupt || wakeupInterrupt

  // APB寄存器映射
  ctrl.readAndWrite(MCR, 0x00)
  ctrl.read(MSR, 0x04)
  ctrl.read(TSR, 0x08)
  ctrl.read(RF0R, 0x0C)
  ctrl.read(RF1R, 0x10)
  ctrl.readAndWrite(IER, 0x14)
  ctrl.read(ESR, 0x18)
  ctrl.readAndWrite(BTR, 0x1C)

  // 发送邮箱寄存器
  ctrl.readAndWrite(TI0R, 0x180)
  ctrl.readAndWrite(TDT0R, 0x184)
  ctrl.readAndWrite(TDL0R, 0x188)
  ctrl.readAndWrite(TDH0R, 0x18C)
  ctrl.readAndWrite(TI1R, 0x190)
  ctrl.readAndWrite(TDT1R, 0x194)
  ctrl.readAndWrite(TDL1R, 0x198)
  ctrl.readAndWrite(TDH1R, 0x19C)
  ctrl.readAndWrite(TI2R, 0x1A0)
  ctrl.readAndWrite(TDT2R, 0x1A4)
  ctrl.readAndWrite(TDL2R, 0x1A8)
  ctrl.readAndWrite(TDH2R, 0x1AC)

  // 接收邮箱寄存器
  ctrl.read(RI0R, 0x1B0)
  ctrl.read(RDT0R, 0x1B4)
  ctrl.read(RDL0R, 0x1B8)
  ctrl.read(RDH0R, 0x1BC)
  ctrl.read(RI1R, 0x1C0)
  ctrl.read(RDT1R, 0x1C4)
  ctrl.read(RDL1R, 0x1C8)
  ctrl.read(RDH1R, 0x1CC)

  // 过滤器寄存器
  ctrl.readAndWrite(FMR, 0x200)
  ctrl.readAndWrite(FM1R, 0x204)
  ctrl.readAndWrite(FS1R, 0x20C)
  ctrl.readAndWrite(FFA1R, 0x214)
  ctrl.readAndWrite(FA1R, 0x21C)
  ctrl.readAndWrite(F0R1, 0x240)
  ctrl.readAndWrite(F0R2, 0x244)
  ctrl.readAndWrite(F1R1, 0x248)
  ctrl.readAndWrite(F1R2, 0x24C)

  // 默认连接
  txFifo.io.push.valid := False
  txFifo.io.push.payload := 0
  rxFifo.io.pop.ready := False
}

object Apb3CanArray {
  def apb3Config(canCnt: Int, groupSpace: Int, dataWidth: Int) =
    Apb3Config(
      addressWidth = log2Up(canCnt) + log2Up(groupSpace),
      dataWidth = dataWidth
    )
}
case class Apb3CanArray(
    canCnt: Int = 4,
    groupSpace: Int = 0x800,
    addressWidth: Int = log2Up(0x800),
    dataWidth: Int = 32,
    dataWidthMax: Int = 128,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3CanArray.apb3Config(canCnt, groupSpace, dataWidth)))
    val cans = Vec(master(Can()), canCnt)
    val interrupt = out(Bits(canCnt bits))
  }

  // 创建多个 CAN 控制器
  val CAN = for (_ <- 0 until canCnt) yield Apb3Can(addressWidth, dataWidth, dataWidthMax, txFifoDepth, rxFifoDepth)

  // 地址映射表：每个 CAN 模块分配 groupSpace 地址空间
  val apbMap = CAN.zipWithIndex.map { case (can, idx) =>
    can.io.apb -> SizeMapping(idx * groupSpace, groupSpace)
  }

  // 地址解码器
  val apbDecoder = Apb3Decoder(
    master = io.apb,
    slaves = apbMap
  )

  // CAN TX/RX 连接
  for ((can, i) <- CAN.zipWithIndex) {
    io.cans(i) <> can.io.can
    io.interrupt(i) := can.io.interrupt
  }
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3CanGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3Can()
//     )
//   }
// }

// object Apb3CanArrayGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3CanArray()
//     )
//   }
// }
