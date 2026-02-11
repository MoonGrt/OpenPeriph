// Digital Video Timing (Interface)
package graphic.dvt

import graphic.base._
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
