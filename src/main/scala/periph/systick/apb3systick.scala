package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._

case class Apb3SysTick(
    addressWidth: Int = 4,
    dataWidth: Int = 32,
    calibValue: Int = 1000
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth, dataWidth)))
    val interrupt = out Bool ()
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 寄存器定义
  val CTRL = Reg(UInt(32 bits)) init (0) // CTRL[0]: ENABLE, [1]: TICKINT, [2]: CLKSOURCE, [16]: COUNTFLAG
  val LOAD = Reg(UInt(32 bits)) init (0)
  val VAL = Reg(UInt(32 bits)) init (0)
  val CALIB = U(calibValue, 32 bits)

  // APB 寄存器映射
  ctrl.readAndWrite(CTRL, 0x00)
  ctrl.readAndWrite(LOAD, 0x04)
  ctrl.readAndWrite(VAL, 0x08)
  ctrl.read(CALIB, 0x0c)

  // 控制信号
  val ENABLE = CTRL(0)
  val TICKINT = CTRL(1)
  val CLKSOURCE = CTRL(2) // 暂未用，可扩展为外部时钟源选择
  val COUNTFLAG = CTRL(16)

  // 计数器逻辑
  when(ENABLE) {
    when(VAL === 0) {
      VAL := LOAD
    } otherwise {
      when(VAL === 1){
        CTRL(16) := True // 设置 COUNTFLAG
      }
      VAL := VAL - 1
    }
  } otherwise {
    CTRL(16) := False
  }

  // 输出中断信号
  io.interrupt := TICKINT && COUNTFLAG
}

// object Apb3SysTickGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3SysTick())
//   }
// }
