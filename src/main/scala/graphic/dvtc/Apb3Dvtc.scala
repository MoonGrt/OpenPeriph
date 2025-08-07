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
case class position(positionWidth: Int = 16) extends Bundle{
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

case class DVT(timingWidth: Int = 12, positionWidth: Int = 16, colorConfig: ColorConfig) extends Component {
  val io = new Bundle {
    val en = in Bool()
    val cfg = in(DVTConfig(timingWidth))
    val pixel = slave(Stream(UInt(colorConfig.getWidth bits)))
    val pos = out(position(positionWidth))
    val dvt = master(DVTI(colorConfig))
    val hen = out Bool()
    val ven = out Bool()
  }

  val en = io.hen && io.ven
  val hCnt = Reg(UInt(12 bits)) init(0)
  val vCnt = Reg(UInt(12 bits)) init(0)
  io.hen := (hCnt >= io.cfg.hsync + io.cfg.hback) &&
         (hCnt < io.cfg.hsync + io.cfg.hback + io.cfg.hdisp)
  io.ven := (vCnt >= io.cfg.vsync + io.cfg.vback) &&
         (vCnt < io.cfg.vsync + io.cfg.vback + io.cfg.vdisp)
  when(io.en) {
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
  }

  io.dvt.color := io.pixel.payload
  io.dvt.hs := (hCnt < io.cfg.hsync) ^ io.cfg.hspol
  io.dvt.vs := (vCnt < io.cfg.vsync) ^ io.cfg.vspol
  io.dvt.de := (en) ^ io.cfg.depol
  io.pos.x := (hCnt).resized
  io.pos.y := (vCnt).resized
  io.pixel.ready := en && io.en
}

// Apb3 DVT Controller
case class Apb3Dvtc(config: DvtcGenerics) extends Component {
  import config._
  val io = new Bundle {
    val apb = slave(Apb3(apb3Config))
    val pixel = slave(Stream(UInt(colorConfig.getWidth bits)))
    val dvt = master(DVTI(colorConfig))
    val interrupt = out Bool()
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  // 定义寄存器
  val SSCR  = Reg(UInt(32 bits)) init(0) // 0x08 // Synchronization Size Configuration Register
  val BPCR  = Reg(UInt(32 bits)) init(0) // 0x0C // Back Porch Configuration Register
  val AWCR  = Reg(UInt(32 bits)) init(0) // 0x10 // Active Width Configuration Register
  val TWCR  = Reg(UInt(32 bits)) init(0) // 0x14 // Total Width Configuration Register
  val GCR   = Reg(UInt(32 bits)) init(0) // 0x18 // Global Control Register
  val SRCR  = Reg(UInt(32 bits)) init(0) // 0x24 // Shadow Reload Configuration Register
  val BCCR  = Reg(UInt(32 bits)) init(0) // 0x2C // Background Color Configuration Register
  val IER   = Reg(UInt(32 bits)) init(0) // 0x34 // Interrupt Enable Register
  val ISR   = Reg(UInt(32 bits)) init(0) // 0x38 // Interrupt Status Register
  val ICR   = Reg(UInt(32 bits)) init(0) // 0x3C // Interrupt Clear Register
  val LIPCR = Reg(UInt(32 bits)) init(0) // 0x40 // Line Interrupt Position Configuration Register
  val CPSR  = Reg(UInt(32 bits)) init(0) // 0x44 // Current Position Status Register
  val CDSR  = Reg(UInt(32 bits)) init(0) // 0x48 // Current Display Status Register

  // APB3 地址映射
  ctrl.readAndWrite(SSCR,  0x08)
  ctrl.readAndWrite(BPCR,  0x0C)
  ctrl.readAndWrite(AWCR,  0x10)
  ctrl.readAndWrite(TWCR,  0x14)
  ctrl.readAndWrite(GCR,   0x18)
  ctrl.readAndWrite(SRCR,  0x24)
  ctrl.readAndWrite(BCCR,  0x2C)
  ctrl.readAndWrite(IER,   0x34)
  ctrl.read(ISR,           0x38)
  // ctrl.write(ICR,          0x3C)
  ctrl.readAndWrite(LIPCR, 0x40)
  ctrl.read(CPSR,          0x44)
  ctrl.read(CDSR,          0x48)

  // 控制位定义
  val GCR_DVTCEN = 0
  val GCR_PCPOL  = 28
  val GCR_DEPOL  = 29
  val GCR_VSPOL  = 30
  val GCR_HSPOL  = 31

  // 中断位定义
  val INT_LIF = 0
  val INT_FUIF = 1
  val INT_TERRIF = 2
  val INT_RRIF = 3

  // 连接 DVT 控制器
  val dvtArea = new ClockingArea(dvtClock) {
    val DVT = new DVT(timingWidth = timingWidth, colorConfig = colorConfig)

    DVT.io.en        := BufferCC(GCR(GCR_DVTCEN))
    DVT.io.cfg.pcpol := BufferCC(GCR(GCR_PCPOL))
    DVT.io.cfg.depol := BufferCC(GCR(GCR_DEPOL))    

    DVT.io.cfg.vsync  := BufferCC(SSCR(timingWidth - 1 downto 0))
    DVT.io.cfg.vback  := BufferCC(BPCR(timingWidth - 1 downto 0))
    DVT.io.cfg.vdisp  := BufferCC(AWCR(timingWidth - 1 downto 0))
    DVT.io.cfg.vtotal := BufferCC(TWCR(timingWidth - 1 downto 0))
    DVT.io.cfg.vspol  := BufferCC(GCR(GCR_VSPOL))

    DVT.io.cfg.hsync  := BufferCC(SSCR(timingWidth + 15 downto 16))
    DVT.io.cfg.hback  := BufferCC(BPCR(timingWidth + 15 downto 16))
    DVT.io.cfg.hdisp  := BufferCC(AWCR(timingWidth + 15 downto 16))
    DVT.io.cfg.htotal := BufferCC(TWCR(timingWidth + 15 downto 16))
    DVT.io.cfg.hspol  := BufferCC(GCR(GCR_HSPOL))
  }

  // 在 APB 时钟域中同步来自 dvtClock 的信号
  val pos_x_sync = BufferCC(dvtArea.DVT.io.pos.x)
  val pos_y_sync = BufferCC(dvtArea.DVT.io.pos.y)
  val vs_sync    = BufferCC(dvtArea.DVT.io.dvt.vs)
  val hs_sync    = BufferCC(dvtArea.DVT.io.dvt.hs)
  val hen_sync   = BufferCC(dvtArea.DVT.io.hen)
  val ven_sync   = BufferCC(dvtArea.DVT.io.ven)

  CPSR := (pos_x_sync ## pos_y_sync).asUInt
  CDSR := (B(0, 28 bits) ## vs_sync ## hs_sync ## hen_sync ## ven_sync).asUInt

  // 中断边沿检测
  val vs_rise = Mux(GCR(GCR_VSPOL), vs_sync.rise, vs_sync.fall)
  val hs_rise = Mux(GCR(GCR_HSPOL), hs_sync.rise, hs_sync.fall)
  val line_match = (pos_y_sync === LIPCR(timingWidth - 1 downto 0)) && hs_rise

  // 中断状态设置
  ISR(INT_LIF).setWhen(line_match && IER(INT_LIF))
  // ISR(INT_FUIF).setWhen(&& IER(INT_FUIF))
  // ISR(INT_TERRIF).setWhen(&& IER(INT_TERRIF))
  // ISR(INT_RRIF).setWhen(&& IER(INT_RRIF))

  // 中断清除
  ctrl.onWrite(0x3C) { // ICR
    ISR := ISR & ~io.apb.PWDATA.asUInt
  }

  // 输入输出连接
  io.dvt << dvtArea.DVT.io.dvt
  io.pixel <> dvtArea.DVT.io.pixel
  io.interrupt := (ISR & IER).orR
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
  val CR     = Reg(UInt(32 bits)) init(0) // 0x84 // Control Register
  val WHPCR  = Reg(UInt(32 bits)) init(0) // 0x88 // Window Horizontal Position Configuration Register
  val WVPCR  = Reg(UInt(32 bits)) init(0) // 0x8C // Window Vertical Position Configuration Register
  val CKCR   = Reg(UInt(32 bits)) init(0) // 0x90 // Color Keying Configuration Register
  val PFCR   = Reg(UInt(32 bits)) init(0) // 0x94 // Pixel Format Configuration Register
  val CACR   = Reg(UInt(32 bits)) init(0) // 0x98 // Constant Alpha Configuration Register
  val DCCR   = Reg(UInt(32 bits)) init(0) // 0x9C // Default Color Configuration Register
  val BFCR   = Reg(UInt(32 bits)) init(0) // 0xA0 // Blending Factors Configuration Register
  val CFBAR  = Reg(UInt(32 bits)) init(0) // 0xAC // Color Frame Buffer Address Register
  val CFBLR  = Reg(UInt(32 bits)) init(0) // 0xB0 // Color Frame Buffer Length Register
  val CFBLNR = Reg(UInt(32 bits)) init(0) // 0xB4 // Color Frame Buffer Line Number Register
  val CLUTWR = Reg(UInt(32 bits)) init(0) // 0xC4 // CLUT Write Register

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
  ctrl.readAndWrite(CLUTWR, 0xC4)

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
