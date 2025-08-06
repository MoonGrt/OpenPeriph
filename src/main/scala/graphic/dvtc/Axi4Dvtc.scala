// Digital Video Timing Controller (DVTC) AXI4-Stream Interface
package graphic.dvtc

import graphic.base._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._

// DVT Generator

case class position(positionWidth: Int = 12) extends Bundle{
  val x = UInt(positionWidth bits)
  val y = UInt(positionWidth bits)
}

case class DVTConfig(timingWidth: Int = 12) extends Bundle {
  val vsync  = UInt(timingWidth bits)
  val vback  = UInt(timingWidth bits)
  val vdisp  = UInt(timingWidth bits)
  val vfront = UInt(timingWidth bits)
  val vtotal = UInt(timingWidth bits)
  val hsync  = UInt(timingWidth bits)
  val hback  = UInt(timingWidth bits)
  val hdisp  = UInt(timingWidth bits)
  val hfront = UInt(timingWidth bits)
  val htotal = UInt(timingWidth bits)
  val vspol = Bool()
  val hspol = Bool()
  val depol = Bool()
  val pcpol = Bool()
}

case class DVTBus(config: ColorConfig) extends Bundle with IMasterSlave {
  val vs = Bool()
  val hs = Bool()
  val de = Bool()
  val color = Color(config)

  override def asMaster() = this.asOutput()
  override def asSlave() = this.asInput()
  override def clone = new DVTBus(config)

  def << (m: DVTBus): Unit = {
    this.vs := m.vs
    this.hs := m.hs
    this.de := m.de
    this.color := m.color
  }
}

case class DVT(timingWidth: Int = 12, config: ColorConfig) extends Component {
  val io = new Bundle {
    val cfg = in(DVTConfig(timingWidth))
    val pixel = slave(Stream(Color(config)))
    val pos = out(position(timingWidth))
    val dvt = master(DVTBus(config))
    val hen = out Bool()
    val ven = out Bool()
  }

  val hCnt = Reg(UInt(12 bits)) init(0)
  val vCnt = Reg(UInt(12 bits)) init(0)
  when(hCnt === io.cfg.htotal - 1) {
    hCnt := 0
    when(vCnt === io.cfg.vtotal - 1) {
      vCnt := 0
    } otherwise {
      vCnt := vCnt + 1
    }
  } otherwise {
    hCnt := hCnt + 1
  }
  io.hen := (hCnt >= io.cfg.hsync + io.cfg.hback) &&
         (hCnt < io.cfg.hsync + io.cfg.hback + io.cfg.hdisp)
  io.ven := (vCnt >= io.cfg.vsync + io.cfg.vback) &&
         (vCnt < io.cfg.vsync + io.cfg.vback + io.cfg.vdisp)
  val en = io.hen && io.ven

  io.dvt.hs := (hCnt < io.cfg.hsync) ^ io.cfg.hspol
  io.dvt.vs := (vCnt < io.cfg.vsync) ^ io.cfg.vspol
  io.dvt.de := (en) ^ io.cfg.depol
  io.pos.x := hCnt
  io.pos.y := vCnt
  io.dvt.color := io.pixel.payload
  io.pixel.ready := en
}

// AXI4-Stream DVT Controller
case class Apb3Dvtc(
  addressWidth: Int = 8, 
  dataWidth: Int = 32, 
  layerNum: Int = 1, 
  timingWidth: Int = 12,
  config: ColorConfig = RGBConfig(5, 6, 5)
) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(addressWidth, dataWidth)))
    val pixel = slave(Stream(Color(config)))
    val dvt = master(DVTBus(config))
  }

  val ctrl = Apb3SlaveFactory(io.apb)
  val DCT = new DVT(timingWidth = timingWidth, config = config)

  // 定义寄存器
  val SSCR   = Reg(UInt(32 bits)) init(0) // 0x08
  val BPCR   = Reg(UInt(32 bits)) init(0) // 0x0C
  val AWCR   = Reg(UInt(32 bits)) init(0) // 0x10
  val TWCR   = Reg(UInt(32 bits)) init(0) // 0x14
  val GCR    = Reg(UInt(32 bits)) init(0) // 0x18
  val SRCR   = Reg(UInt(32 bits)) init(0) // 0x24
  val BCCR   = Reg(UInt(32 bits)) init(0) // 0x2C
  val IER    = Reg(UInt(32 bits)) init(0) // 0x34
  val ISR    = Reg(UInt(32 bits)) init(0) // 0x38
  val ICR    = Reg(UInt(32 bits)) init(0) // 0x3C
  val LIPCR  = Reg(UInt(32 bits)) init(0) // 0x40
  val CPSR   = Reg(UInt(32 bits)) init(0) // 0x44
  val CDSR   = Reg(UInt(32 bits)) init(0) // 0x48

  // APB3 映射：注意地址需要与 STM32 对齐
  ctrl.readAndWrite(SSCR,  0x08)
  ctrl.readAndWrite(BPCR,  0x0C)
  ctrl.readAndWrite(AWCR,  0x10)
  ctrl.readAndWrite(TWCR,  0x14)
  ctrl.readAndWrite(GCR,   0x18)
  ctrl.readAndWrite(SRCR,  0x24)
  ctrl.readAndWrite(BCCR,  0x2C)
  ctrl.readAndWrite(IER,   0x34)
  ctrl.readAndWrite(ISR,   0x38)
  ctrl.readAndWrite(ICR,   0x3C)
  ctrl.readAndWrite(LIPCR, 0x40)
  ctrl.read(CPSR,          0x44)
  ctrl.read(CDSR,          0x48)

  // 连接 DVT 控制器
  DCT.io.cfg.vsync := SSCR(timingWidth - 1 downto 0)
  DCT.io.cfg.vback := BPCR(timingWidth - 1 downto 0)
  DCT.io.cfg.vdisp := AWCR(timingWidth - 1 downto 0)
  DCT.io.cfg.vfront := (TWCR(timingWidth - 1 downto 0) - 
                       (BPCR(timingWidth - 1 downto 0) + AWCR(timingWidth - 1 downto 0)))
  DCT.io.cfg.vtotal := TWCR(timingWidth - 1 downto 0)
  DCT.io.cfg.vspol := GCR(30)
  DCT.io.cfg.hsync := SSCR(timingWidth + 15 downto 16)
  DCT.io.cfg.hback := BPCR(timingWidth + 15 downto 16)
  DCT.io.cfg.hdisp := AWCR(timingWidth + 15 downto 16)
  DCT.io.cfg.hfront := (TWCR(timingWidth + 15 downto 16) - 
                       (BPCR(timingWidth + 15 downto 16) + AWCR(timingWidth + 15 downto 16)))
  DCT.io.cfg.htotal := TWCR(timingWidth + 15 downto 16)
  DCT.io.cfg.hspol := GCR(31)
  DCT.io.cfg.depol := GCR(29)
  DCT.io.cfg.pcpol := GCR(28)

  CPSR(timingWidth - 1 downto 0) := DCT.io.pos.x
  CPSR(timingWidth + 15 downto 16) := DCT.io.pos.y
  CDSR := (B(0, 28 bits) ## DCT.io.dvt.vs ## DCT.io.dvt.hs ## DCT.io.hen ## DCT.io.ven).asUInt

  // 输入输出连接
  io.dvt << DCT.io.dvt
  io.pixel <> DCT.io.pixel
}

// object Apb3DvtcGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(Apb3Dvtc())
//   }
// }
