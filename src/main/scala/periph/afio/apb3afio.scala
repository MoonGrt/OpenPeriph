package periph.afio

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.io.{InOutWrapper, TriStateArray}

object Apb3Afio {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}
case class Apb3Afio(
    gpioWidth: Int = 16,
    gpioGroupCnt: Int = 4,
    addressWidth: Int = 5,
    dataWidth: Int = 32
) extends Component {
  val selWidth = log2Up(gpioGroupCnt)
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth, dataWidth)))
    val device = in(Bits(gpioWidth * gpioGroupCnt bits))
    val afio = master(TriStateArray(gpioWidth * gpioGroupCnt bits))
    val afioExti = out(Bits(gpioWidth bits))
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // --- AFIO寄存器 ---
  val EVCR     = Reg(UInt(32 bits)) init(0)
  val MAPR     = Reg(UInt(32 bits)) init(0)
  val EXTICR   = Vec(Reg(UInt(32 bits)) init(0), 4)
  val MAPR2    = Reg(UInt(32 bits)) init(0)

  ctrl.readAndWrite(EVCR, 0x00) // EVCR 未使用
  ctrl.readAndWrite(MAPR, 0x04) // MAPR1 未使用
  for (i <- 0 until 4)
    ctrl.readAndWrite(EXTICR(i), 0x08 + i * 4)
  // RESERVED 0x18
  ctrl.readAndWrite(MAPR2, 0x1C) // MAPR2 未使用

  // --- EXTICR 控制外设到 GPIO 输入映射 (影响中断线、事件控制等) ---
  val afioExti = Bits(gpioWidth bits)
  for (i <- 0 until gpioWidth) {
    val extiRegIndex = i / 4         // EXTICR 每个寄存器控制 4 个 GPIO
    val extiBitIndex = (i % 4) * 4   // 每个 GPIO 使用 4 位表示来源组
    // 提取 4 位 Bits -> 转换为 UInt
    val selBits  = EXTICR(extiRegIndex).asBits(extiBitIndex + 3 downto extiBitIndex)
    val selGroup = selBits.asUInt.resize(log2Up(gpioGroupCnt))  // 安全转换到目标范围
    // 多路选择当前 GPIO 来自哪个 group
    val extiSignal = selGroup.mux(
      (0 until gpioGroupCnt).map(g =>
        U(g, selGroup.getWidth bits) -> io.afio.read(g * gpioWidth + i)
      ): _* // ← 关键点：展开 IndexedSeq 为 varargs
    )
    afioExti(i) := extiSignal
  }
  io.afioExti := afioExti

  // --- MAPR 控制 GPIO 输出映射 (影响 GPIO 输出电平等) ---
  for (i <- 0 until gpioWidth * gpioGroupCnt) {
    io.afio.write(i) := io.device(i)
    io.afio.writeEnable(i) := True
  }
}

object Apb3AfioGen {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3Afio(gpioWidth = 16, gpioGroupCnt = 4))
  }
}
