package graphic.dvt

import chisel3._
import chisel3.util._
import graphic.base._

case class DvtTimingConfig(
    hsync: Int,
    hback: Int,
    hdisplay: Int,
    htotal: Int,
    vsync: Int,
    vback: Int,
    vdisplay: Int,
    vtotal: Int,
    vsyncPolarity: Boolean = false,
    hsyncPolarity: Boolean = false,
    dataEnablePolarity: Boolean = false,
    pixelClockPolarity: Boolean = false
)

class DvtIO(dataWidth: Int) extends Bundle {
  val vs = Bool()
  val hs = Bool()
  val de = Bool()
  val data = UInt(dataWidth.W)
}

class DvtPosition(width: Int = 16) extends Bundle {
  val x = UInt(width.W)
  val y = UInt(width.W)
}

class DvtDynamicConfig(width: Int = 12) extends Bundle {
  val hsync = UInt(width.W); val hback = UInt(width.W)
  val hdisplay = UInt(width.W); val htotal = UInt(width.W)
  val vsync = UInt(width.W); val vback = UInt(width.W)
  val vdisplay = UInt(width.W); val vtotal = UInt(width.W)
  val vsyncPolarity = Bool(); val hsyncPolarity = Bool()
  val dataEnablePolarity = Bool(); val pixelClockPolarity = Bool()
}

class DvtTimingDynamic(colorWidth: Int, timingWidth: Int = 12, positionWidth: Int = 16)
    extends Module {
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val config = Input(new DvtDynamicConfig(timingWidth))
    val pixel = Flipped(Decoupled(UInt(colorWidth.W)))
    val position = Output(new DvtPosition(positionWidth))
    val dvt = Output(new DvtIO(colorWidth))
    val horizontalEnable = Output(Bool())
    val verticalEnable = Output(Bool())
  })
  val horizontal = RegInit(0.U(timingWidth.W))
  val vertical = RegInit(0.U(timingWidth.W))
  when(io.enable) {
    when(horizontal === io.config.htotal) {
      horizontal := 0.U
      vertical := Mux(vertical === io.config.vtotal, 0.U, vertical + 1.U)
    }.otherwise { horizontal := horizontal + 1.U }
  }.otherwise { horizontal := 0.U; vertical := 0.U }

  io.horizontalEnable := horizontal >= io.config.hback && horizontal < io.config.hdisplay
  io.verticalEnable := vertical >= io.config.vback && vertical < io.config.vdisplay
  val active = io.horizontalEnable && io.verticalEnable
  io.dvt.data := io.pixel.bits
  io.dvt.vs := ((vertical <= io.config.vsync) ^ io.config.vsyncPolarity) && io.enable
  io.dvt.hs := ((horizontal <= io.config.hsync) ^ io.config.hsyncPolarity) && io.enable
  io.dvt.de := (active ^ io.config.dataEnablePolarity) && io.enable
  io.position.x := horizontal
  io.position.y := vertical
  io.pixel.ready := active || !io.enable
}

class DvtTiming(config: DvtTimingConfig, colorWidth: Int, timingWidth: Int = 12)
    extends Module {
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val pixel = Flipped(Decoupled(UInt(colorWidth.W)))
    val position = Output(new DvtPosition())
    val dvt = Output(new DvtIO(colorWidth))
  })
  val dynamic = Module(new DvtTimingDynamic(colorWidth, timingWidth))
  dynamic.io.enable := io.enable
  dynamic.io.pixel <> io.pixel
  dynamic.io.config.hsync := config.hsync.U
  dynamic.io.config.hback := config.hback.U
  dynamic.io.config.hdisplay := config.hdisplay.U
  dynamic.io.config.htotal := config.htotal.U
  dynamic.io.config.vsync := config.vsync.U
  dynamic.io.config.vback := config.vback.U
  dynamic.io.config.vdisplay := config.vdisplay.U
  dynamic.io.config.vtotal := config.vtotal.U
  dynamic.io.config.vsyncPolarity := config.vsyncPolarity.B
  dynamic.io.config.hsyncPolarity := config.hsyncPolarity.B
  dynamic.io.config.dataEnablePolarity := config.dataEnablePolarity.B
  dynamic.io.config.pixelClockPolarity := config.pixelClockPolarity.B
  io.position := dynamic.io.position
  io.dvt := dynamic.io.dvt
}
