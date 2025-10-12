package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.io.{TriStateArray, InOutWrapper}

// I2C主接口定义
case class I2c() extends Bundle with IMasterSlave {
  val scl = Bool()
  val sda = TriStateArray(1 bits)

  override def asMaster(): Unit = {
    out(scl, sda.write, sda.writeEnable)
    in(sda.read)
  }
  override def asSlave(): Unit = {
    in(scl, sda.write, sda.writeEnable)
    out(sda.read)
  }
  override def clone = I2c()
}

object Apb3I2c {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

case class Apb3I2c(
    addressWidth: Int = 7,
    dataWidth: Int = 32,
    dataWidthMax: Int = 8,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3I2c.apb3Config(addressWidth, dataWidth)))
    val i2c = master(I2c())
    val interrupt = out(Bool())
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 寄存器定义 - 按照STM32 I2C寄存器布局
  val CR1 = Reg(UInt(16 bits)) init(0)   // 控制寄存器1
  val CR2 = Reg(UInt(16 bits)) init(0)   // 控制寄存器2
  val OAR1 = Reg(UInt(16 bits)) init(0)  // 自身地址寄存器1
  val OAR2 = Reg(UInt(16 bits)) init(0)  // 自身地址寄存器2
  val DR = Reg(UInt(16 bits)) init(0)    // 数据寄存器
  val SR1 = Reg(UInt(16 bits)) init(0)   // 状态寄存器1
  val SR2 = Reg(UInt(16 bits)) init(0)   // 状态寄存器2
  val CCR = Reg(UInt(16 bits)) init(0)   // 时钟控制寄存器
  val TRISE = Reg(UInt(16 bits)) init(0) // TRISE寄存器

  // CR1位域解析
  val PE = CR1(0)        // 外设使能
  val SMBUS = CR1(1)     // SMBus模式
  val SMBTYPE = CR1(3)   // SMBus类型
  val ENARP = CR1(4)     // ARP使能
  val ENPEC = CR1(5)     // PEC使能
  val ENGC = CR1(6)      // 广播呼叫使能
  val NOSTRETCH = CR1(7) // 时钟延展禁止
  val START = CR1(8)     // 起始条件
  val STOP = CR1(9)      // 停止条件
  val ACK = CR1(10)      // 应答使能
  val POS = CR1(11)      // 应答位置
  val CR1PEC = CR1(12)   // 数据包错误检查
  val ALERT = CR1(13)    // SMBus警告
  val SWRST = CR1(15)    // 软件复位

  // CR2位域解析
  val FREQ = CR2(5 downto 0) // 外设时钟频率
  val ITERREN = CR2(8)   // 错误中断使能
  val ITEVTEN = CR2(9)   // 事件中断使能
  val ITBUFEN = CR2(10)  // 缓冲区中断使能
  val DMAEN = CR2(11)    // DMA请求使能
  val LAST = CR2(12)     // DMA最后一个传输

  // OAR1位域解析
  val ADDMODE = OAR1(15) // 地址模式
  val ADD = OAR1(9 downto 0) // 10位地址

  // OAR2位域解析
  val ADD2 = OAR2(7 downto 1) // 7位地址
  val ENDUAL = OAR2(0) // 双地址模式

  // SR1位域解析
  val SB = SR1(0)        // 起始位
  val ADDR = SR1(1)      // 地址发送
  val BTF = SR1(2)       // 字节传输完成
  val ADD10 = SR1(3)     // 10位头地址
  val STOPF = SR1(4)     // 停止检测
  val RXNE = SR1(6)      // 数据寄存器非空
  val TXE = SR1(7)       // 数据寄存器空
  val BERR = SR1(8)      // 总线错误
  val ARLO = SR1(9)      // 仲裁丢失
  val AF = SR1(10)       // 应答失败
  val OVR = SR1(11)      // 溢出/下溢
  val PECERR = SR1(12)   // PEC错误
  val TIMEOUT = SR1(14)  // 超时或Tlow错误
  val SMBALERT = SR1(15) // SMBus警告

  // SR2位域解析
  val MSL = SR2(0)        // 主/从
  val BUSY = SR2(1)       // 总线忙
  val TRA = SR2(2)        // 发送器/接收器
  val GENCALL = SR2(4)    // 广播呼叫地址
  val SMBDEFAULT = SR2(5) // SMBus设备默认地址
  val SMBHOST = SR2(6)    // SMBus主机头
  val DUALF = SR2(7)      // 双标志
  val SR2PEC = SR2(15 downto 8) // 数据包错误检查

  // CCR位域解析
  val CCR_FS = CCR(15) // 外设时钟频率
  val CCR_DUTY = CCR(14) // 空闲时钟占空比
  val CCR_CCR = CCR(11 downto 0) // 时钟控制寄存器

  // FIFO实现
  val txFifo = StreamFifo(Bits(dataWidthMax bits), txFifoDepth)
  val rxFifo = StreamFifo(Bits(dataWidthMax bits), rxFifoDepth)

  // I2C状态机
  val i2cState = Reg(UInt(4 bits)) init(0)
  val bitCounter = Reg(UInt(4 bits)) init(0)
  val txShiftReg = Reg(Bits(dataWidthMax bits)) init(0)
  val rxShiftReg = Reg(Bits(dataWidthMax bits)) init(0)
  val isRead = Reg(Bool()) init(False)
  isRead := False // TODO

  // 时钟分频器
  val clockCounter = Reg(UInt(12 bits)) init(0)
  val clockTick = clockCounter === 0

  // 根据CCR计算时钟分频
  when(PE) {
    clockCounter := clockCounter - 1
    when(clockTick) { clockCounter := CCR_CCR }
  }

  // I2C状态机逻辑
  txFifo.io.pop.ready := False
  rxFifo.io.push.valid := False
  rxFifo.io.push.payload := 0
  io.i2c.sda.write := True.asBits // 默认高电平
  io.i2c.sda.writeEnable := False.asBits
  switch(i2cState) {
    is(0) { // 空闲状态
      when(START && PE) {
        i2cState := 1
        SR1(0) := True // SB = 1
        bitCounter := 0
      }
    }
    is(1) { // 发送地址
      when(clockTick) {
        when(ADDMODE) {
          when(bitCounter < 10) {
            io.i2c.sda.write := ADD(9 - bitCounter).asBits
            io.i2c.sda.writeEnable := True.asBits
            bitCounter := bitCounter + 1
          }.elsewhen(bitCounter === 10) {
            io.i2c.sda.write := isRead.asBits
            bitCounter := bitCounter + 1
            SR1(1) := True // ADDR = 1
          }.otherwise {
            i2cState := 2
            SR1(1) := False // ADDR = 0
          }
        }.otherwise {
          when(bitCounter < 7) {
            io.i2c.sda.write := ADD(7 - bitCounter).asBits
            io.i2c.sda.writeEnable := True.asBits
            bitCounter := bitCounter + 1
          }.elsewhen(bitCounter === 7) {
            io.i2c.sda.write := isRead.asBits
            io.i2c.sda.writeEnable := True.asBits
            bitCounter := bitCounter + 1
            SR1(1) := True // ADDR = 1
          }.otherwise {
            i2cState := 2
            SR1(1) := False // ADDR = 0
          }
        }
      }
    }
    is(2) { // 等待应答
      when(clockTick) {
        when(io.i2c.sda.read === False.asBits) { // ACK received
          when(isRead) { i2cState := 3 } // 进入接收模式
          .otherwise { i2cState := 4 } // 进入发送模式
        }.otherwise { // NACK received
          SR1(10) := True // AF = 1
          i2cState := 0
        }
      }
    }
    is(3) { // 接收数据
      when(clockTick) {
        rxShiftReg := rxShiftReg(dataWidthMax - 2 downto 0) ## io.i2c.sda.read
        bitCounter := bitCounter + 1
        when(bitCounter === 7) {
          // 将接收到的数据放入RX FIFO
          rxFifo.io.push.valid := True
          rxFifo.io.push.payload := rxShiftReg
          SR1(6) := True // RXNE = 1
          i2cState := 5
        }
      }
    }
    is(4) { // 发送数据
      when(txFifo.io.pop.valid && clockTick) {
        txShiftReg := txFifo.io.pop.payload
        io.i2c.sda.write := txShiftReg(7).asBits
        io.i2c.sda.writeEnable := True.asBits
        bitCounter := 1
        txFifo.io.pop.ready := True
        i2cState := 6
      }
    }
    is(5) { // 接收完成
      when(clockTick) {
        when(STOP) {
          i2cState := 0
          SR1(4) := True // STOPF = 1
        }.otherwise {
          i2cState := 3 // 继续接收
        }
      }
    }
    is(6) { // 发送进行中
      when(clockTick) {
        io.i2c.sda.write := txShiftReg((7 - bitCounter).resized).asBits
        io.i2c.sda.writeEnable := True.asBits
        bitCounter := bitCounter + 1
        when(bitCounter === 7) {
          SR1(2) := True // BTF = 1
          i2cState := 7
        }
      }
    }
    is(7) { // 发送完成
      when(clockTick) {
        when(STOP) {
          i2cState := 0
          SR1(4) := True // STOPF = 1
        }.otherwise {
          i2cState := 4 // 继续发送
        }
      }
    }
  }

  // 状态寄存器更新
  SR1(7) := txFifo.io.pop.ready // TXE
  SR1(6) := rxFifo.io.pop.valid // RXNE
  SR2(1) := i2cState =/= 0 // BUSY
  SR2(2) := isRead // TRA

  // 中断生成
  val errorInterrupt = ITERREN && (BERR || ARLO || AF || OVR || PECERR || TIMEOUT)
  val eventInterrupt = ITEVTEN && (SB || ADDR || BTF || STOPF)
  val bufferInterrupt = ITBUFEN && (TXE || RXNE)

  io.interrupt := errorInterrupt || eventInterrupt || bufferInterrupt

  // APB寄存器映射
  ctrl.readAndWrite(CR1, 0x00)
  ctrl.readAndWrite(CR2, 0x04)
  ctrl.readAndWrite(OAR1, 0x08)
  ctrl.readAndWrite(OAR2, 0x0C)

  // DR寄存器特殊处理
  ctrl.onWrite(0x10) {
    when(TXE) {
      txFifo.io.push.valid := True
      txFifo.io.push.payload := io.apb.PWDATA(dataWidthMax - 1 downto 0).asBits
    }
  }
  ctrl.onRead(0x10) {
    when(RXNE) {
      rxFifo.io.pop.ready := True
      io.apb.PRDATA := rxFifo.io.pop.payload.resized
    }
  }

  ctrl.read(SR1, 0x14)
  ctrl.read(SR2, 0x18)
  ctrl.readAndWrite(CCR, 0x1C)
  ctrl.readAndWrite(TRISE, 0x20)

  // 默认连接
  txFifo.io.push.valid := False
  txFifo.io.push.payload := 0
  rxFifo.io.pop.ready := False
  io.i2c.scl := clockTick
}

object Apb3I2cArray {
  def apb3Config(i2cCnt: Int, i2cSpace: BigInt, dataWidth: Int) =
    Apb3Config(
      addressWidth = log2Up(i2cCnt) + log2Up(i2cSpace),
      dataWidth = dataWidth
    )
}
case class Apb3I2cArray(
    i2cCnt: Int = 4,
    i2cSpace: BigInt = 0x40,
    addressWidth: Int = log2Up(0x40),
    dataWidth: Int = 32,
    txFifoDepth: Int = 16,
    rxFifoDepth: Int = 16
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3I2cArray.apb3Config(i2cCnt, i2cSpace, dataWidth)))
    val i2cs = Vec(master(I2c()), i2cCnt)
    val interrupt = out(Bits(i2cCnt bits))
  }

  // 创建多个 I2C 控制器
  val I2C = for (_ <- 0 until i2cCnt) yield Apb3I2c(addressWidth, dataWidth, txFifoDepth, rxFifoDepth)

  // 地址映射表：每个 I2C 模块分配 i2cSpace 地址空间
  val apbMap = I2C.zipWithIndex.map { case (i2c, idx) =>
    i2c.io.apb -> SizeMapping(idx * i2cSpace, i2cSpace)
  }

  // 地址解码器
  val apbDecoder = Apb3Decoder(
    master = io.apb,
    slaves = apbMap
  )

  // I2C TX/RX 连接
  for ((i2c, i) <- I2C.zipWithIndex) {
    io.i2cs(i) <> i2c.io.i2c
    io.interrupt(i) := i2c.io.interrupt
  }
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3I2cGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(new Apb3I2c())
//   }
// }

// object Apb3I2cArrayGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(new Apb3I2cArray())
//   }
// }
