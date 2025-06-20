package periph.gpio

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.io.{InOutWrapper, TriStateArray}
import spinal.lib.bus.misc.SizeMapping

object Apb3Gpio {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

// 单个GPIO模块
case class Apb3Gpio(
    gpioWidth: Int = 16,
    withReadSync: Boolean = true,
    addressWidth: Int = 5,
    dataWidth: Int = 32
) extends Component {
  require(gpioWidth == 16, "This module assumes 16 GPIO pins")

  val io = new Bundle {
    val apb = slave(Apb3(Apb3Gpio.apb3Config(addressWidth, dataWidth)))
    val gpio = master(TriStateArray(gpioWidth bits))
    val afio = in(Bits(gpioWidth bits)) // 复用功能输入
  }

  // GPIO输入值，同步或异步传递
  val gpioInput = if (withReadSync) BufferCC(io.gpio.read) else io.gpio.read

  // APB寄存器工厂
  val ctrl = Apb3SlaveFactory(io.apb)

  // 寄存器定义
  val CRL = Reg(UInt(gpioWidth * 2 bits)) init (0)
  val CRH = Reg(UInt(gpioWidth * 2 bits)) init (0)
  val IDR = gpioInput.asUInt
  val ODR = Reg(UInt(gpioWidth bits)) init (0)
  // val BSRR = Reg(Bits(gpioWidth bits)) init (0)
  // val BSR = Reg(Bits(gpioWidth bits)) init (0)
  val LCKR = Reg(UInt(gpioWidth bits)) init (0)

  // --- APB 寄存器映射，使用 Apb3SlaveFactory ---
  ctrl.readAndWrite(CRL, 0x00) // 0x00  CRL 配置寄存器
  ctrl.readAndWrite(CRH, 0x04) // 0x04  CRH 配置寄存器
  ctrl.read(IDR, 0x08) // 0x08  IDR 输入数据寄存器，只读
  ctrl.readAndWrite(ODR, 0x0c) // 0x0C  ODR 输出数据寄存器
  // BSRR和BRR 写操作对ODR的实时影响
  ctrl.onWrite(0x10) { // BSRR
    val bsrrData = io.apb.PWDATA
    val bs = bsrrData(gpioWidth - 1 downto 0).asUInt
    val br = bsrrData(gpioWidth * 2 - 1 downto gpioWidth).asUInt
    ODR := (ODR | bs) & ~br
  }
  ctrl.onWrite(0x14) { // BRR
    val brrData = io.apb.PWDATA
    ODR := ODR & ~brrData(gpioWidth - 1 downto 0).asUInt
  }
  // LCKR 锁定寄存器, 永久保留锁定位
  ctrl.read(LCKR, 0x18) // LCKR
  ctrl.onWrite(0x18) {
    val writeVal = io.apb.PWDATA(gpioWidth - 1 downto 0).asUInt
    // 只对尚未锁定的位设置锁定
    LCKR := LCKR | (writeVal & ~LCKR)
  }

  // // 根据CRL/CRH寄存器简单生成输出使能信号
  // val gpioDir = Vec(Bool(), gpioWidth)
  // for (i <- 0 until gpioWidth) {
  //   val cfg =
  //     if (i < gpioWidth / 2) CRL(4 * i + 3 downto 4 * i)
  //     else CRH(4 * (i - gpioWidth / 2) + 3 downto 4 * (i - gpioWidth / 2))
  //   gpioDir(i) := cfg(1)
  // }

  // // 三态GPIO口驱动
  // for (i <- 0 until gpioWidth) {
  //   io.gpio.write(i) := ODR(i)
  //   io.gpio.writeEnable(i) := gpioDir(i)
  // }

  // GPIO 模式配置解码
  case class GpioCtrl() extends Bundle {
    val mode = UInt(2 bits)
    val cnf = UInt(2 bits)
  }
  val gpioCfg = Vec(GpioCtrl(), gpioWidth)
  for (i <- 0 until gpioWidth) {
    val bits =
      if (i < 8) CRL(4 * i + 3 downto 4 * i)
      else CRH(4 * (i - 8) + 3 downto 4 * (i - 8))
    gpioCfg(i).assignFromBits(bits.asBits)
  }

  // GPIO 输出控制
  for (i <- 0 until gpioWidth) {
    val cfg = gpioCfg(i)
    val isOutput = cfg.mode =/= 0
    val useAfio = cfg.cnf === 2 || cfg.cnf === 3
    val isOpenDrain = cfg.cnf === 1 || cfg.cnf === 3
    val outputData = Mux(useAfio, io.afio(i), ODR(i))
    val enableOutput = isOutput && (!isOpenDrain || outputData === False)

    io.gpio.write(i) := outputData
    io.gpio.writeEnable(i) := enableOutput
  }
}

// 顶层：多个 GPIO 组统一在一个 APB3 接口中
object Apb3GpioArray {
  def apb3Config(gpioGroupCnt: Int, addressWidth: Int, dataWidth: Int) =
    Apb3Config(
      addressWidth = log2Up(gpioGroupCnt) + addressWidth,
      dataWidth = dataWidth
    )
}
case class Apb3GpioArray(
    gpioWidth: Int,
    gpioGroupCnt: Int,
    withReadSync: Boolean,
    addressWidth: Int = 5,
    dataWidth: Int = 32
) extends Component {
  val io = new Bundle {
    val apb = slave(
      Apb3(Apb3GpioArray.apb3Config(gpioGroupCnt, addressWidth, dataWidth))
    )
    val gpio = master(TriStateArray(gpioWidth * gpioGroupCnt bits))
    val afio = in(Bits(gpioWidth * gpioGroupCnt bits))
  }

  // 生成多个子模块
  val groups =
    for (i <- 0 until gpioGroupCnt)
      yield new Apb3Gpio(gpioWidth, withReadSync, addressWidth, dataWidth)
  val apbMap = groups.zipWithIndex.map { case (grp, idx) =>
    val base = idx * 0x20 // 每组预留 32 字节空间
    (grp, base)
  }

  // APB 地址解码器
  val apbDecoder = Apb3Decoder(
    master = io.apb,
    slaves = apbMap.map { case (grp, base) =>
      grp.io.apb -> SizeMapping(base, 0x20)
    }
  )

  // GPIO 与 AFIO 信号连接
  val gpioVec = TriStateArray(gpioWidth * gpioGroupCnt bits)
  val afioVec = io.afio
  for ((grp, i) <- groups.zipWithIndex) {
    val offset = i * gpioWidth
    // GPIO 连接
    gpioVec.write(offset, gpioWidth bits) := grp.io.gpio.write
    gpioVec.writeEnable(offset, gpioWidth bits) := grp.io.gpio.writeEnable
    grp.io.gpio.read := gpioVec.read(offset, gpioWidth bits)
    // AFIO 连接
    grp.io.afio := afioVec(offset + gpioWidth - 1 downto offset)
  }

  gpioVec <> io.gpio
}

object Apb3GpioGen {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl").generateVerilog(
      InOutWrapper(Apb3Gpio(gpioWidth = 16, withReadSync = true))
    )
  }
}

object Apb3GpioArrayGen {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl").generateVerilog(
      InOutWrapper(
        Apb3GpioArray(gpioWidth = 16, gpioGroupCnt = 4, withReadSync = true)
      )
    )
  }
}
