package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping

object Apb3Crc {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

case class Apb3Crc(
    addressWidth: Int = 7,
    dataWidth: Int = 32,
    polynomialWidth: Int = 32
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Crc.apb3Config(addressWidth, dataWidth)))
    val interrupt = out(Bool())
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 寄存器定义 - 按照STM32 CRC寄存器布局
  val DR = Reg(UInt(32 bits)) init(0)    // 数据寄存器
  val IDR = Reg(UInt(32 bits)) init(0)   // 独立数据寄存器
  val CR = Reg(UInt(32 bits)) init(0)    // 控制寄存器
  val INIT = Reg(UInt(32 bits)) init(0)  // 初始值寄存器
  val POL = Reg(UInt(32 bits)) init(0)   // 多项式寄存器

  // CR位域解析
  val RESET = CR(0) // 复位位
  val POLYSIZE = CR(4 downto 3) // 多项式大小
  val REV_IN = CR(6 downto 5) // 输入数据反转
  val REV_OUT = CR(7) // 输出数据反转

  // CRC计算引擎
  val crcEngine = new Area {
    val crcReg = Reg(UInt(polynomialWidth bits)) init(0)
    val dataIn = Reg(Bits(dataWidth bits)) init(0)
    val polyU = POL.resized

    // 根据配置选择多项式大小
    val polySize = UInt(6 bits)
    switch(POLYSIZE){
      is(U"2'b00"){ polySize := U(7)  }
      is(U"2'b01"){ polySize := U(8)  }
      is(U"2'b10"){ polySize := U(16) }
      is(U"2'b11"){ polySize := U(32) }
    }

    // 输入数据反转
    val reversedInput = Mux(REV_IN === 0, dataIn,
                           Mux(REV_IN === 1, dataIn(7 downto 0) ## dataIn(15 downto 8) ## dataIn(23 downto 16) ## dataIn(31 downto 24),
                               dataIn(3 downto 0) ## dataIn(7 downto 4) ## dataIn(11 downto 8) ## dataIn(15 downto 12) ##
                               dataIn(19 downto 16) ## dataIn(23 downto 20) ## dataIn(27 downto 24) ## dataIn(31 downto 28))).asUInt

    // 一步迭代函数：acc 左移并按MSB决定是否异或多项式（组合逻辑）
    def iter(start: UInt, poly: UInt, steps: Int): UInt = {
      var acc = start
      for(i <- 0 until steps){
        acc = Mux(acc.msb, (acc |<< 1) ^ poly, acc |<< 1)
      }
      acc
    }

    // 针对不同宽度分别计算（参与量都统一resized到 polynomialWidth）
    val next32 = iter((crcReg ^ reversedInput.resized),               polyU,                        32)
    val next16 = iter((crcReg(15 downto 0) ^ reversedInput(15 downto 0)).resized, polyU(15 downto 0).resized, 16)
    val next8  = iter((crcReg(7  downto 0) ^ reversedInput(7  downto 0)).resized, polyU(7  downto 0).resized,  8)
    val next7  = iter((crcReg(6  downto 0) ^ reversedInput(6  downto 0)).resized, polyU(6  downto 0).resized,  7)

    val nextCrc = UInt(polynomialWidth bits)
    nextCrc := next32
    when(polySize === U(16)) { nextCrc := next16.resized }
    .elsewhen(polySize === U(8)) { nextCrc := next8.resized }
    .elsewhen(polySize === U(7)) { nextCrc := next7.resized }

    // 输出反转：统一用 Bits.reversed 再转回 UInt，保证类型一致
    val finalCrc = Mux(REV_OUT, nextCrc.asBits.reversed.asUInt, nextCrc)

    // 更新CRC寄存器 / DR
    when(RESET) { 
      crcReg := INIT.resized
    } .otherwise {
      crcReg := finalCrc
    }
    DR := finalCrc.resized   // DR 固定 32 位
  }

  // 中断生成（CRC计算完成）
  val crcCompleteInterrupt = Reg(Bool()) init(False)
  io.interrupt := crcCompleteInterrupt

  // APB寄存器映射
  ctrl.readAndWrite(DR, 0x00)
  ctrl.readAndWrite(IDR, 0x04)
  ctrl.readAndWrite(CR, 0x08)
  ctrl.readAndWrite(INIT, 0x10)
  ctrl.readAndWrite(POL, 0x14)

  // 当写入DR时触发CRC计算
  ctrl.onWrite(0x00) {
    crcEngine.dataIn := io.apb.PWDATA.asBits
    crcCompleteInterrupt := True
  }
  // 当读取DR时清除中断
  ctrl.onRead(0x00) {
    crcCompleteInterrupt := False
  }
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3CrcGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3Crc()
//     )
//   }
// }
