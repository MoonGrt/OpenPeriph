package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc._

case class Apb3Exti(
    extiWidth: Int = 16,
    addressWidth: Int = 5,
    dataWidth: Int = 32
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth, dataWidth)))
    val exti = in(Bits(extiWidth bits)) // 外部中断线
    val interrupt = out(Bits(extiWidth bits)) // 输出中断请求
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 各寄存器定义
  val IMR = Reg(Bits(extiWidth bits)) init (0) // 中断屏蔽
  val EMR = Reg(Bits(extiWidth bits)) init (0) // 事件屏蔽（暂未使用）
  val RTSR = Reg(Bits(extiWidth bits)) init (0) // 上升沿触发
  val FTSR = Reg(Bits(extiWidth bits)) init (0) // 下降沿触发
  val SWIER = Reg(Bits(extiWidth bits)) init (0) // 软件中断触发
  val PR = Reg(Bits(extiWidth bits)) init (0) // 挂起标志

  // 寄存器映射
  ctrl.readAndWrite(IMR, 0x00)
  ctrl.readAndWrite(EMR, 0x04)
  ctrl.readAndWrite(RTSR, 0x08)
  ctrl.readAndWrite(FTSR, 0x0c)
  ctrl.onWrite(0x10) { // SWIER
    val sw = io.apb.PWDATA(extiWidth - 1 downto 0)
    SWIER := SWIER | sw.asBits
  }
  ctrl.read(SWIER, 0x10)
  ctrl.onWrite(0x14) {
    val wr = io.apb.PWDATA(extiWidth - 1 downto 0).asBits
    // 写1清除，对应位清零
    PR := PR & ~wr
  }
  ctrl.read(PR, 0x14)

  // 触发逻辑：同步输入边沿检测
  val extiReg = RegNext(io.exti) init (0)
  val risingEdge = io.exti & ~extiReg
  val fallingEdge = ~io.exti & extiReg

  val edgeTriggered = (risingEdge & RTSR) | (fallingEdge & FTSR)
  val swTriggered = SWIER & IMR
  val newPending = (edgeTriggered | swTriggered) & IMR

  // 挂起位更新
  PR := PR | edgeTriggered

  // interrupt 输出
  io.interrupt := PR & IMR
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3ExtiGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3Exti(extiWidth = 16))
//   }
// }
