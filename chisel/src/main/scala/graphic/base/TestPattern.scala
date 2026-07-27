package graphic.base

import chisel3._
import chisel3.util._
import graphic.dvt._

object TestPatternMode {
  val colorBar = 0.U(2.W)
  val grayScale = 1.U(2.W)
  val grid = 2.U(2.W)
  val solidColor = 3.U(2.W)
}

class TestPattern(timing: DvtTimingConfig, color: RgbConfig) extends Module {
  val io = IO(new Bundle {
    val mode = Input(UInt(2.W))
    val solidColor = Input(UInt(color.width.W))
    val dvt = Output(new DvtIO(color.width))
  })
  val horizontal = RegInit(0.U(log2Ceil(timing.htotal).W))
  val vertical = RegInit(0.U(log2Ceil(timing.vtotal).W))
  when(horizontal === (timing.htotal - 1).U) {
    horizontal := 0.U
    vertical := Mux(vertical === (timing.vtotal - 1).U, 0.U, vertical + 1.U)
  }.otherwise { horizontal := horizontal + 1.U }

  val horizontalValid = horizontal >= (timing.hsync + timing.hback).U &&
    horizontal < (timing.hsync + timing.hback + timing.hdisplay).U
  val verticalValid = vertical >= (timing.vsync + timing.vback).U &&
    vertical < (timing.vsync + timing.vback + timing.vdisplay).U
  val active = horizontalValid && verticalValid
  io.dvt.hs := (horizontal < timing.hsync.U) ^ timing.hsyncPolarity.B
  io.dvt.vs := (vertical < timing.vsync.U) ^ timing.vsyncPolarity.B
  io.dvt.de := active ^ timing.dataEnablePolarity.B

  val x = horizontal - (timing.hsync + timing.hback).U
  val bar = Mux(x / math.max(1, timing.hdisplay / 8).U > 7.U, 7.U, x / math.max(1, timing.hdisplay / 8).U)
  val colors = VecInit(Seq("h000000".U, "hff0000".U, "h00ff00".U, "h0000ff".U,
    "hffff00".U, "hff00ff".U, "h00ffff".U, "hffffff".U))
  val colorBar = ColorConvert.rgb(colors(7.U - bar), RgbConfig(8, 8, 8), color)
  val gray = (x * 255.U / timing.hdisplay.U)(7, 0)
  val grayPixel = ColorConvert.rgb(Cat(gray, gray, gray), RgbConfig(8, 8, 8), color)
  val gridPixel = Mux(horizontal(4, 0) === 0.U || vertical(4, 0) === 0.U,
    ((BigInt(1) << color.width) - 1).U, 0.U)
  val selected = MuxLookup(io.mode, io.solidColor)(Seq(
    TestPatternMode.colorBar -> colorBar,
    TestPatternMode.grayScale -> grayPixel,
    TestPatternMode.grid -> gridPixel,
    TestPatternMode.solidColor -> io.solidColor
  ))
  io.dvt.data := Mux(active, selected, 0.U)
}
