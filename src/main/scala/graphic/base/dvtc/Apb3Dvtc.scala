// Digital Video Timing Controller (DVTC) Apb3 Interface
package graphic.base

import graphic.algorithm._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4ReadOnly, Axi4ReadOnlyArbiter}
import spinal.lib.graphic.{VideoDma, VideoDmaGeneric}

case class DvtConfig(
  timingWidth: Int = 12,
  positionWidth: Int = 16,
  colorCfg: ColorCfg = RGBCfg(5, 6, 5),
  dvtClock: ClockDomain
)

case class DvtcGenerics(
  axiAddressWidth: Int,
  axiDataWidth: Int,
  burstLength: Int,
  frameSizeMax: Int,
  fifoSize: Int,
  dvtClock: ClockDomain,
  colorCfg: ColorCfg = RGBCfg(5, 6, 5),
  timingWidth: Int = 12,
  pendingRequestMax: Int = 7,
  layerNum: Int = 2
) {
  def axi4Config = dmaGenerics.getAxi4ReadOnlyConfig

  def apb3Config = Apb3Config(
    addressWidth = 10,
    dataWidth = 32,
    useSlaveError = false
  )

  def dvtConfig = DvtConfig(
    timingWidth = 12,
    positionWidth = 16,
    colorCfg = colorCfg,
    dvtClock = dvtClock
  )

  def dmaGenerics = VideoDmaGeneric(
    addressWidth      = axiAddressWidth - log2Up(bytePerAddress),
    dataWidth         = axiDataWidth,
    beatPerAccess     = burstLength,
    sizeWidth         = log2Up(frameSizeMax) - log2Up(bytePerAddress),
    pendingRequetMax  = pendingRequestMax,
    fifoSize          = fifoSize,
    frameClock        = dvtClock,
    frameFragmentType = Color(colorCfg)
  )

  def bytePerAddress = axiDataWidth/8 * burstLength
}

case class position(positionWidth: Int = 16) extends Bundle{
  val x = UInt(positionWidth bits)
  val y = UInt(positionWidth bits)
}

case class DVTI(dataWidth: Int) extends Bundle with IMasterSlave {
  val vs = Bool()
  val hs = Bool()
  val de = Bool()
  val data = UInt(dataWidth bits)

  override def asMaster() = this.asOutput()
  override def asSlave() = this.asInput()
  override def clone = new DVTI(dataWidth)

  def << (that: DVTI): Unit = {
    this.vs := that.vs
    this.hs := that.hs
    this.de := that.de
    this.data := that.data
  }
}

case class DVTCfg(
  hsync: Int,
  hback: Int,
  hdisp: Int,
  htotal: Int,
  vsync: Int,
  vback: Int,
  vdisp: Int,
  vtotal: Int,
  vspol: Boolean = false,
  hspol: Boolean = false,
  depol: Boolean = false,
  pcpol: Boolean = false
)

case class DVTCfgInterface(timingWidth: Int = 12) extends Bundle {
  val hsync  = UInt(timingWidth bits)
  val hback  = UInt(timingWidth bits)
  val hdisp  = UInt(timingWidth bits)
  // val hfront = UInt(timingWidth bits)
  val htotal = UInt(timingWidth bits)
  val vsync  = UInt(timingWidth bits)
  val vback  = UInt(timingWidth bits)
  val vdisp  = UInt(timingWidth bits)
  // val vfront = UInt(timingWidth bits)
  val vtotal = UInt(timingWidth bits)
  val vspol = Bool()
  val hspol = Bool()
  val depol = Bool()
  val pcpol = Bool()
}

case class DVTimingDyn(dvtConfig: DvtConfig) extends Component {
  import dvtConfig._
  val io = new Bundle {
    val en = in Bool()
    val cfg = in(DVTCfgInterface(timingWidth))
    val pixel = slave(Stream(Color(colorCfg)))
    val pos = out(position(positionWidth))
    val dvti = master(DVTI(colorCfg.getWidth))
    val hen = out Bool()
    val ven = out Bool()
  }

  val dvtArea = new ClockingArea(dvtClock) {
    val en = io.hen && io.ven
    val hCnt = Reg(UInt(timingWidth bits)) init(0)
    val vCnt = Reg(UInt(timingWidth bits)) init(0)
    io.hen := (hCnt >= io.cfg.hback) && (hCnt < io.cfg.hdisp)
    io.ven := (vCnt >= io.cfg.vback) && (vCnt < io.cfg.vdisp)
    when(io.en) {
      when(hCnt === io.cfg.htotal) {
        hCnt := 0
        when(vCnt === io.cfg.vtotal) {
          vCnt := 0
        } otherwise {
          vCnt := vCnt + 1
        }
      } otherwise {
        hCnt := hCnt + 1
      }
    }.otherwise {
      hCnt := 0
      vCnt := 0
    }

    // 负极性: 高电平时间长，低电平时间短; 正极性: 高电平时间短，低电平时间长
    io.dvti.data := io.pixel.payload
    io.dvti.vs := ((vCnt <= io.cfg.vsync) ^ io.cfg.vspol) && io.en
    io.dvti.hs := ((hCnt <= io.cfg.hsync) ^ io.cfg.hspol) && io.en
    io.dvti.de := (en ^ io.cfg.depol) && io.en
    io.pos.x := hCnt.resized
    io.pos.y := vCnt.resized
    io.pixel.ready := en || ~io.en
  }
}

case class DVTiming(dvtcfg: DVTCfg, dvtConfig: DvtConfig) extends Component {
  import dvtcfg._
  import dvtConfig._
  val io = new Bundle {
    val en = in Bool()
    val pixel = slave(Stream(Color(colorCfg)))
    val pos = out(position(positionWidth))
    val dvti = master(DVTI(colorCfg.getWidth))
    val hen = out Bool()
    val ven = out Bool()
  }

  val dvtArea = new ClockingArea(dvtClock) {
    val en = io.hen && io.ven
    val hCnt = Reg(UInt(timingWidth bits)) init(0)
    val vCnt = Reg(UInt(timingWidth bits)) init(0)
    io.hen := (hCnt >= hback) && (hCnt < hdisp)
    io.ven := (vCnt >= vback) && (vCnt < vdisp)
    when(io.en) {
      when(hCnt === htotal) {
        hCnt := 0
        when(vCnt === vtotal) {
          vCnt := 0
        } otherwise {
          vCnt := vCnt + 1
        }
      } otherwise {
        hCnt := hCnt + 1
      }
    }.otherwise {
      hCnt := 0
      vCnt := 0
    }

    // 负极性: 高电平时间长，低电平时间短; 正极性: 高电平时间短，低电平时间长
    val HSpol = Bool(hspol)
    val VSpol = Bool(vspol)
    val DEpol = Bool(depol)
    io.dvti.data := io.pixel.payload
    io.dvti.vs := ((vCnt <= vsync) ^ VSpol) && io.en
    io.dvti.hs := ((hCnt <= hsync) ^ HSpol) && io.en
    io.dvti.de := (en ^ DEpol) && io.en
    io.pos.x := hCnt.resized
    io.pos.y := vCnt.resized
    io.pixel.ready := en || ~io.en
  }
}

// Apb3 DVT Controller
case class Apb3Dvtc(config: DvtcGenerics) extends Component {
  import config._
  val io = new Bundle {
    val apb = slave(Apb3(apb3Config))
    val axi = master(Axi4ReadOnly(axi4Config))
    val dvti = master(DVTI(colorCfg.getWidth))
    val interrupt = out Bool()
  }

  // APB3 控制器
  val ctrl = Apb3SlaveFactory(io.apb)

  /* ---------------------------------------------------------------------------- */
  /* ----------------------------------- DVTC ----------------------------------- */
  /* ---------------------------------------------------------------------------- */
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
  ctrl.write(ICR,          0x3C)
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

  /* ---------------------------------------------------------------------------- */
  /* -------------------------------- DVTC Layer -------------------------------- */
  /* ---------------------------------------------------------------------------- */
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

  /* ---------------------------------------------------------------------------- */
  /* -------------------------------- Connection -------------------------------- */
  /* ---------------------------------------------------------------------------- */
  val layerDma = new VideoDma(dmaGenerics)
  val dvt = new DVTimingDyn(dvtConfig)
  // 连接 DVTimingDyn 控制器
  val dvtArea = new ClockingArea(dvtClock) {
    // 连接 DVTimingDyn 控制器的配置寄存器
    dvt.io.en        := BufferCC(GCR(GCR_DVTCEN))
    dvt.io.cfg.pcpol := BufferCC(GCR(GCR_PCPOL))
    dvt.io.cfg.depol := BufferCC(GCR(GCR_DEPOL))

    dvt.io.cfg.vsync  := BufferCC(SSCR(timingWidth - 1 downto 0))
    dvt.io.cfg.vback  := BufferCC(BPCR(timingWidth - 1 downto 0))
    dvt.io.cfg.vdisp  := BufferCC(AWCR(timingWidth - 1 downto 0))
    dvt.io.cfg.vtotal := BufferCC(TWCR(timingWidth - 1 downto 0))
    dvt.io.cfg.vspol  := BufferCC(GCR(GCR_VSPOL))

    dvt.io.cfg.hsync  := BufferCC(SSCR(timingWidth + 15 downto 16))
    dvt.io.cfg.hback  := BufferCC(BPCR(timingWidth + 15 downto 16))
    dvt.io.cfg.hdisp  := BufferCC(AWCR(timingWidth + 15 downto 16))
    dvt.io.cfg.htotal := BufferCC(TWCR(timingWidth + 15 downto 16))
    dvt.io.cfg.hspol  := BufferCC(GCR(GCR_HSPOL))

    // 连接 DVTimingDyn 控制器的数据流
    val frameStart = Mux(dvt.io.cfg.vspol, dvt.io.dvti.vs.rise, dvt.io.dvti.vs.rise.fall)
    val error = RegInit(False)
    val waitStartOfFrame = RegInit(False)
    val firstPixel = Reg(Bool()) setWhen(frameStart) clearWhen(layerDma.io.frame.firstFire)

    when(frameStart){
      waitStartOfFrame := False
    }
    when(layerDma.io.frame.fire && layerDma.io.frame.last){
      error := False
      waitStartOfFrame := error
    }
    when(!waitStartOfFrame && !error) {
      when(firstPixel && layerDma.io.frame.valid && !layerDma.io.frame.first) {
        error := True
      }
    }

    // // Layer window 区域判断
    // val winX0 = BufferCC(WHPCR(15 downto 0))
    // val winX1 = BufferCC(WHPCR(31 downto 16))
    // val winY0 = BufferCC(WVPCR(15 downto 0))
    // val winY1 = BufferCC(WVPCR(31 downto 16))
    // val inWindow = (dvt.io.pos.x >= winX0.resized) && (dvt.io.pos.x < winX1.resized) &&
    //                (dvt.io.pos.y >= winY0.resized) && (dvt.io.pos.y < winY1.resized)

    // // ready 仅在有效区域内反馈
    // layerDma.io.frame.ready.setWhen(!waitStartOfFrame && !error && inWindow)

    // // 像素选择逻辑
    // dvt.io.pixel.valid := layerDma.io.frame.valid && inWindow
    // dvt.io.pixel.payload := Converter(ARGBCfg(8,8,8,8), colorCfg)(DCCR)
    // when(inWindow) {
    //   dvt.io.pixel.payload := layerDma.io.frame.toStreamOfFragment.payload
    // }

    dvt.io.pixel << layerDma.io.frame.toStreamOfFragment.haltWhen(waitStartOfFrame && !error)
    layerDma.io.frame.ready.setWhen(BufferCC(~CR(0)))
  }

  // 在 APB 时钟域中同步来自 dvtClock 的信号
  val pos_x_sync = BufferCC(dvt.io.pos.x)
  val pos_y_sync = BufferCC(dvt.io.pos.y)
  val vs_sync    = BufferCC(dvt.io.dvti.vs)
  val hs_sync    = BufferCC(dvt.io.dvti.hs)
  val hen_sync   = BufferCC(dvt.io.hen)
  val ven_sync   = BufferCC(dvt.io.ven)

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

  // 连接 DMA 控制器
  io.axi <> layerDma.io.mem.toAxi4ReadOnly
  layerDma.io.base := CFBAR >> log2Up(bytePerAddress)
  layerDma.io.size := ((CFBLNR(15 downto 0) * CFBLR(31 downto 16) - 1) >> log2Up(bytePerAddress)).resized
  layerDma.io.start := PulseCCByToggle(dvtArea.frameStart, clockIn = dvtClock, clockOut = ClockDomain.current) && CR(0)

  // 输入输出连接
  io.dvti << dvt.io.dvti
  io.interrupt := (ISR & IER).orR
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
//         colorCfg = RGBCfg(5, 6, 5),
//         dvtClock = ClockDomain.external("dvt"))
//       )
//     )
//   }
// }
