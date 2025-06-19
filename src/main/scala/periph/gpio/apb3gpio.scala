package periph.gpio

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.io.{InOutWrapper, TriStateArray}
import spinal.lib.bus.misc.SizeMapping

object Apb3Gpio {
  def apb3Config(addressWidth: Int, dataWidth: Int) = Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

// 单个GPIO模块
case class Apb3Gpio(gpioWidth: Int = 16, withReadSync: Boolean = true, addressWidth: Int = 5, dataWidth: Int = 32)
    extends Component {
  require(gpioWidth == 16, "This module assumes 16 GPIO pins")

  val io = new Bundle {
    val apb = slave(Apb3(Apb3Gpio.apb3Config(addressWidth, dataWidth)))
    val gpio = master(TriStateArray(gpioWidth bits))
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
  val BSRR = Reg(Bits(gpioWidth bits)) init (0)
  val BSR = Reg(Bits(gpioWidth bits)) init (0)
  val LCKR = Reg(UInt(gpioWidth bits)) init (0)

  // --- APB 寄存器映射，使用 Apb3SlaveFactory ---
  ctrl.read(IDR, 0x00) // 0x00  IDR 输入数据寄存器，只读
  ctrl.readAndWrite(CRL, 0x04) // 0x04  CRL 配置寄存器
  ctrl.readAndWrite(CRH, 0x08) // 0x08  CRH 配置寄存器
  ctrl.readAndWrite(ODR, 0x0c) // 0x0C  ODR 输出数据寄存器
  ctrl.clearOnSet(BSRR, 0x10) // 0x10  BSRR 置位寄存器
  ctrl.clearOnSet(BSR, 0x14) // 0x14  BRR 复位寄存器
  ctrl.readAndWrite(LCKR, 0x18) // 0x18  LCKR 锁定寄存器

  // BSRR和BRR 写操作对ODR的实时影响
  when(ctrl.isWriting(0x10)) {
    ODR := ODR | BSRR.asUInt
  }
  when(ctrl.isWriting(0x14)) {
    ODR := ODR & ~BSR.asUInt
  }

  // 根据CRL/CRH寄存器简单生成输出使能信号
  val gpioDir = Vec(Bool(), gpioWidth)
  for (i <- 0 until gpioWidth) {
    val cfg =
      if (i < 8) CRL(4 * i + 3 downto 4 * i)
      else CRH(4 * (i - 8) + 3 downto 4 * (i - 8))
    gpioDir(i) := cfg(1)
  }

  // 三态GPIO口驱动
  for (i <- 0 until gpioWidth) {
    io.gpio.write(i) := ODR(i)
    io.gpio.writeEnable(i) := gpioDir(i)
  }
}

// 顶层：多个 GPIO 组统一在一个 APB3 接口中
object Apb3GpioArray {
  def apb3Config(gpioGroupCnt: Int, addressWidth: Int, dataWidth: Int) = Apb3Config(
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
    val apb = slave(Apb3(Apb3GpioArray.apb3Config(gpioGroupCnt, addressWidth, dataWidth)))
    val gpio = master(TriStateArray(gpioWidth * gpioGroupCnt bits))
  }

  // 生成多个子模块
  val groups =
    for (i <- 0 until gpioGroupCnt) yield new Apb3Gpio(gpioWidth, withReadSync, addressWidth, dataWidth)
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

  // GPIO 三态信号拼接
  val gpioVec = TriStateArray(gpioWidth * gpioGroupCnt bits)
  for ((grp, i) <- groups.zipWithIndex) {
    gpioVec.write(i * gpioWidth, gpioWidth bits) := grp.io.gpio.write
    gpioVec.writeEnable(
      i * gpioWidth,
      gpioWidth bits
    ) := grp.io.gpio.writeEnable
    grp.io.gpio.read := gpioVec.read(i * gpioWidth, gpioWidth bits)
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
