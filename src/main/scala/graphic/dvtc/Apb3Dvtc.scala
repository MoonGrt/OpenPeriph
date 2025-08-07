// Digital Video Timing Controller (DVTC) Apb3 Interface
package graphic.dvtc

import graphic.base._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4ReadOnly}
import spinal.lib.graphic.{VideoDma, VideoDmaGeneric}

case class DvtcGenerics(
  axiAddressWidth: Int,
  axiDataWidth: Int,
  burstLength: Int,
  frameSizeMax: Int,
  fifoSize: Int,
  dvtClock: ClockDomain,
  colorConfig: ColorConfig = RGBConfig(5, 6, 5),
  timingWidth: Int = 12,
  pendingRequestMax: Int = 7
) {
  def axi4Config = dmaGenerics.getAxi4ReadOnlyConfig

  def apb3Config = Apb3Config(
    addressWidth = 10,
    dataWidth = 32,
    useSlaveError = false
  )

  def dmaGenerics = VideoDmaGeneric(
    addressWidth      = axiAddressWidth - log2Up(bytePerAddress),
    dataWidth         = axiDataWidth,
    beatPerAccess     = burstLength,
    sizeWidth         = log2Up(frameSizeMax) -log2Up(bytePerAddress),
    pendingRequetMax  = pendingRequestMax,
    fifoSize          = fifoSize,
    frameClock        = dvtClock,
    frameFragmentType = UInt(colorConfig.getWidth bits)
  )

  def bytePerAddress = axiDataWidth/8 * burstLength
}

// DVT Generator
case class position(positionWidth: Int = 12) extends Bundle{
  val x = UInt(positionWidth bits)
  val y = UInt(positionWidth bits)
}

case class DVTConfig(timingWidth: Int = 12) extends Bundle {
  val vsync  = UInt(timingWidth bits)
  val vback  = UInt(timingWidth bits)
  val vdisp  = UInt(timingWidth bits)
  // val vfront = UInt(timingWidth bits)
  val vtotal = UInt(timingWidth bits)
  val hsync  = UInt(timingWidth bits)
  val hback  = UInt(timingWidth bits)
  val hdisp  = UInt(timingWidth bits)
  // val hfront = UInt(timingWidth bits)
  val htotal = UInt(timingWidth bits)
  val vspol = Bool()
  val hspol = Bool()
  val depol = Bool()
  val pcpol = Bool()
}

case class DVTI(colorConfig: ColorConfig) extends Bundle with IMasterSlave {
  val vs = Bool()
  val hs = Bool()
  val de = Bool()
  val color = UInt(colorConfig.getWidth bits)

  override def asMaster() = this.asOutput()
  override def asSlave() = this.asInput()
  override def clone = new DVTI(colorConfig)

  def << (m: DVTI): Unit = {
    this.vs := m.vs
    this.hs := m.hs
    this.de := m.de
    this.color := m.color
  }
}

case class DVT(timingWidth: Int = 12, colorConfig: ColorConfig) extends Component {
  val io = new Bundle {
    // val en = in Bool()
    val cfg = in(DVTConfig(timingWidth))
    val pixel = slave(Stream(UInt(colorConfig.getWidth bits)))
    val pos = out(position(timingWidth))
    val dvt = master(DVTI(colorConfig))
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
  io.pos.x := (hCnt - io.cfg.hsync - io.cfg.hback).resized
  io.pos.y := (vCnt - io.cfg.vsync - io.cfg.vback).resized
  io.dvt.color := io.pixel.payload
  io.pixel.ready := en
}

// Apb3 DVT Controller
case class Apb3Dvtc(config: DvtcGenerics) extends Component {
  import config._
  val io = new Bundle {
    val apb = slave(Apb3(apb3Config))
    val pixel = slave(Stream(UInt(colorConfig.getWidth bits)))
    val dvt = master(DVTI(colorConfig))
  }

  val ctrl = Apb3SlaveFactory(io.apb)

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

  // APB3 地址映射
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
  val dvtArea = new ClockingArea(dvtClock) {
    val DCT = new DVT(timingWidth = timingWidth, colorConfig = colorConfig)

    DCT.io.cfg.vsync  := BufferCC(SSCR(timingWidth - 1 downto 0))
    DCT.io.cfg.vback  := BufferCC(BPCR(timingWidth - 1 downto 0))
    DCT.io.cfg.vdisp  := BufferCC(AWCR(timingWidth - 1 downto 0))
    DCT.io.cfg.vtotal := BufferCC(TWCR(timingWidth - 1 downto 0))
    DCT.io.cfg.vspol  := BufferCC(GCR(30))

    DCT.io.cfg.hsync  := BufferCC(SSCR(timingWidth + 15 downto 16))
    DCT.io.cfg.hback  := BufferCC(BPCR(timingWidth + 15 downto 16))
    DCT.io.cfg.hdisp  := BufferCC(AWCR(timingWidth + 15 downto 16))
    DCT.io.cfg.htotal := BufferCC(TWCR(timingWidth + 15 downto 16))
    DCT.io.cfg.hspol  := BufferCC(GCR(31))

    DCT.io.cfg.depol  := BufferCC(GCR(29))
    DCT.io.cfg.pcpol  := BufferCC(GCR(28))
  }

  // 在 APB 时钟域中同步来自 dvtClock 的信号
  val pos_x_sync = BufferCC(dvtArea.DCT.io.pos.x)
  val pos_y_sync = BufferCC(dvtArea.DCT.io.pos.y)
  val vs_sync    = BufferCC(dvtArea.DCT.io.dvt.vs)
  val hs_sync    = BufferCC(dvtArea.DCT.io.dvt.hs)
  val hen_sync   = BufferCC(dvtArea.DCT.io.hen)
  val ven_sync   = BufferCC(dvtArea.DCT.io.ven)

  CPSR(timingWidth - 1 downto 0) := pos_x_sync
  CPSR(timingWidth + 15 downto 16) := pos_y_sync
  CDSR := (B(0, 28 bits) ## vs_sync ## hs_sync ## hen_sync ## ven_sync).asUInt

  // 输入输出连接
  io.dvt << dvtArea.DCT.io.dvt
  io.pixel <> dvtArea.DCT.io.pixel
}

case class Apb3DvtcLayer(config: DvtcGenerics) extends Component {
  import config._
  val io = new Bundle {
    val apb = slave(Apb3(apb3Config))
    val axi = master(Axi4ReadOnly(axi4Config))
    val pixel = master(Stream(Fragment(dmaGenerics.frameFragmentType)))
  }

  val ctrl = Apb3SlaveFactory(io.apb)
  val layerDma = VideoDma(dmaGenerics)

  // 定义寄存器
  val CR      = Reg(UInt(32 bits)) init(0) // 0x84
  val WHPCR   = Reg(UInt(32 bits)) init(0) // 0x88
  val WVPCR   = Reg(UInt(32 bits)) init(0) // 0x8C
  val CKCR    = Reg(UInt(32 bits)) init(0) // 0x90
  val PFCR    = Reg(UInt(32 bits)) init(0) // 0x94
  val CACR    = Reg(UInt(32 bits)) init(0) // 0x98
  val DCCR    = Reg(UInt(32 bits)) init(0) // 0x9C
  val BFCR    = Reg(UInt(32 bits)) init(0) // 0xA0
  val CFBAR   = Reg(UInt(32 bits)) init(0) // 0xAC
  val CFBLR   = Reg(UInt(32 bits)) init(0) // 0xB0
  val CFBLNR  = Reg(UInt(32 bits)) init(0) // 0xB4
  val CLUTWR  = Reg(UInt(32 bits)) init(0) // 0x144

  // APB3 地址映射
  ctrl.readAndWrite(CR,     0x84)
  ctrl.readAndWrite(WHPCR,  0x88)
  ctrl.readAndWrite(WVPCR,  0x8C)
  ctrl.readAndWrite(CKCR,   0x90)
  ctrl.readAndWrite(PFCR,   0x94)
  ctrl.readAndWrite(CACR,   0x98)
  ctrl.readAndWrite(DCCR,   0x9C)
  ctrl.readAndWrite(BFCR,   0xA0)
  ctrl.readAndWrite(CFBAR,  0xAC)
  ctrl.readAndWrite(CFBLR,  0xB0)
  ctrl.readAndWrite(CFBLNR, 0xB4)
  ctrl.readAndWrite(CLUTWR, 0x144)

  // 连接 DMA 控制器
  io.axi <> layerDma.io.mem.toAxi4ReadOnly
  io.pixel <> layerDma.io.frame
  layerDma.io.size := (CFBLNR(15 downto 0) * CFBLR(31 downto 16) * (2)).resized
  layerDma.io.base := CFBAR.resized
  layerDma.io.start := CR(0)
}

// object Apb3DvtcGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       Apb3Dvtc(DvtcGenerics(
//         axiAddressWidth = 32,
//         axiDataWidth = 32,
//         burstLength = 8,
//         frameSizeMax = 2048*1512,
//         fifoSize = 512,
//         colorConfig = RGBConfig(5, 6, 5),
//         dvtClock = ClockDomain.external("dvt"))
//       )
//     )
//   }
// }

// object Apb3DvtcLayerGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog {
//       Apb3DvtcLayer(DvtcGenerics(
//         axiAddressWidth = 32,
//         axiDataWidth = 32,
//         burstLength = 8,
//         frameSizeMax = 2048*1512,
//         fifoSize = 512,
//         colorConfig = RGBConfig(5, 6, 5),
//         dvtClock = ClockDomain.external("dvt"))
//       )
//     }
//   }
// }
