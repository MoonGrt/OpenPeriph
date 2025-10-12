package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping

object Apb3Tim {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}
case class Apb3Tim(addressWidth: Int = 7, dataWidth: Int = 32)
    extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Tim.apb3Config(addressWidth, dataWidth)))
    val ch = out Bits (4 bits)
    val interrupt = out Bool ()
  }

  // 寄存器区
  val ctrl = Apb3SlaveFactory(io.apb)

  def Reg16Init(value: Int = 0) = Reg(UInt(16 bits)) init (value)

  // 寄存器定义
  val CR1 = Reg16Init()
  val CR2 = Reg16Init()
  val SMCR = Reg16Init()
  val DIER = Reg16Init()
  val SR = Reg16Init()
  val EGR = Reg16Init()
  val CCMR1 = Reg16Init()
  val CCMR2 = Reg16Init()
  val CCER = Reg16Init()
  val CNT = Reg16Init()
  val PSC = Reg16Init()
  val ARR = Reg16Init(0xffff)
  val RCR = Reg16Init()
  val CCR = Vec(Reg16Init(), 4)
  val BDTR = Reg16Init()
  val DCR = Reg16Init()
  val DMAR = Reg16Init()
  // -------- 解析寄存器位域 -------------
  val CEN  = CR1(0)
  val DIR  = CR1(4)
  val CMS  = CR1(6 downto 5)
  val ARPE = CR1(7)
  val CKD  = CR1(9 downto 8)
  val MMS  = CR2(6 downto 4)
  val UIE   = DIER(0)
  val CC1IE = DIER(1)
  val CC2IE = DIER(2)
  val CC3IE = DIER(3)
  val CC4IE = DIER(4)
  val TIE   = DIER(6)
  val UIF   = SR(0)
  val CC1IF = SR(1)
  val CC2IF = SR(2)
  val CC3IF = SR(3)
  val CC4IF = SR(4)
  val TIF   = SR(6)

  // 寄存器映射 (注意地址对齐 32bit，低16有效)
  ctrl.readAndWrite(CR1, 0x00)
  ctrl.readAndWrite(CR2, 0x04)
  ctrl.readAndWrite(SMCR, 0x08)
  ctrl.readAndWrite(DIER, 0x0c)
  ctrl.readAndWrite(SR, 0x10)
  ctrl.readAndWrite(EGR, 0x14)
  ctrl.readAndWrite(CCMR1, 0x18)
  ctrl.readAndWrite(CCMR2, 0x1c)
  ctrl.readAndWrite(CCER, 0x20)
  ctrl.read(CNT, 0x24)
  ctrl.readAndWrite(PSC, 0x28)
  ctrl.readAndWrite(ARR, 0x2c)
  ctrl.readAndWrite(RCR, 0x30)
  ctrl.readAndWrite(CCR(0), 0x34)
  ctrl.readAndWrite(CCR(1), 0x38)
  ctrl.readAndWrite(CCR(2), 0x3c)
  ctrl.readAndWrite(CCR(3), 0x40)
  ctrl.readAndWrite(BDTR, 0x44)
  ctrl.readAndWrite(DCR, 0x48)
  ctrl.readAndWrite(DMAR, 0x4c)

  // -------- 计数器逻辑 -------------
  val prescaler = Reg(UInt(16 bits)) init(0)
  when(CEN === True) {
    prescaler := prescaler + 1
    when(prescaler === PSC) {
      prescaler := 0
      when(DIR === False) {
        CNT := CNT + 1
        when(CNT === ARR) {
          CNT := 0
          SR(0) := True // UIF = 1
        }
      } otherwise {
        CNT := CNT - 1
        when(CNT === 0) {
          CNT := ARR
          SR(0) := True // UIF = 1
        }
      }
    }
  }

  // EGR（事件发生器，硬件自动清零）
  when(EGR(0)) { // UG
    CNT := 0
    EGR := 0
  }
  when(EGR(1)) { // CC1
    EGR := 0
  }
  when(EGR(2)) { // CC2
    EGR := 0
  }
  when(EGR(3)) { // CC3
    EGR := 0
  }
  when(EGR(4)) { // CC4
    EGR := 0
  }
  when(EGR(6)) { // TG
    EGR := 0
  }

  // -------- 中断输出 -------------
  io.interrupt := SR(0) && DIER(0)

  // PWM 输出逻辑
  for (i <- 0 until 4) {
    val enable = CCER(i)
    val pwm = Reg(Bool()) init (False)
    pwm := (CNT < CCR(i)) && enable
    io.ch(i) := pwm
  }
}

object Apb3TimArray {
  def apb3Config(timCnt: Int, timSpace: BigInt, dataWidth: Int) =
    Apb3Config(
      addressWidth = log2Up(timCnt) + log2Up(timSpace),
      dataWidth = dataWidth
    )
}
case class Apb3TimArray(
    timCnt: Int,
    timSpace: BigInt = 0x80,
    addressWidth: Int = log2Up(0x80),
    dataWidth: Int = 32
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3TimArray.apb3Config(timCnt, timSpace, dataWidth)))
    val ch = out Bits(timCnt * 4 bits)
    val interrupt = out Bits(timCnt bits)
  }

  // 生成多个定时器子模块
  val TIM = 
    for (i <- 0 until timCnt)
      yield new Apb3Tim(addressWidth, dataWidth)

  val apbMap = TIM.zipWithIndex.map { case (tim, idx) =>
    val base = idx * timSpace
    (tim.io.apb, SizeMapping(base, timSpace))
  }

  // APB 解码器
  Apb3Decoder(
    master = io.apb,
    slaves = apbMap
  )

  // 连接 PWM 输出和中断
  for ((tim, i) <- TIM.zipWithIndex) {
    io.ch(i * 4 + 3 downto i * 4) := tim.io.ch
    io.interrupt(i) := tim.io.interrupt
  }
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object Apb3TimGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3Tim()
//     )
//   }
// }

// object Apb3TimArrayGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3TimArray(timCnt = 4)
//     )
//   }
// }
