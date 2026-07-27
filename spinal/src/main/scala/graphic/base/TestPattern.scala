package graphic.base

import graphic.base._
import graphic.dvt._
import graphic.algorithm._
import spinal.core._
import spinal.lib._

object TestPatternEnum extends SpinalEnum {
  val COLOR_BAR, GRAY_SCALE, GRID, SOLID_COLOR = newElement()
}

case class TestPattern(dvtcfg: DVTCfg, colorCfg: ColorCfg) extends Component {
  import dvtcfg._
  val io = new Bundle {
    val muxsel = in(TestPatternEnum())
    val solidColor = in(Color(colorCfg))
    val dvt = master(DVTI(colorCfg.getWidth))
  }

  // Counter
  val hcnt = Reg(UInt(log2Up(htotal) bits)) init(0)
  val vcnt = Reg(UInt(log2Up(vtotal) bits)) init(0)

  when(hcnt === htotal - 1) {
    hcnt := 0
    when(vcnt === vtotal - 1) {
      vcnt := 0
    } otherwise {
      vcnt := vcnt + 1
    }
  } otherwise {
    hcnt := hcnt + 1
  }

  // HSYNC、VSYNC
  val HSpol = Bool(hspol)
  val VSpol = Bool(vspol)
  val hs_active = (hcnt < hsync)
  val vs_active = (vcnt < vsync)
  io.dvt.hs := hs_active ^ HSpol
  io.dvt.vs := vs_active ^ VSpol

  // DE Signal
  val DEpol = Bool(depol)
  val hValid = (hcnt >= hsync + hback) && (hcnt < hsync + hback + hdisp)
  val vValid = (vcnt >= vsync + vback) && (vcnt < vsync + vback + vdisp)
  io.dvt.de := (hValid && vValid) ^ DEpol

  // Color Bar
  val barWidth = hdisp >> 3
  val colorSel = (hcnt - (hsync + hback)) / barWidth
  val colors = Vec(
    U"h000000", U"hFF0000", U"h00FF00", U"h0000FF",
    U"hFFFF00", U"hFF00FF", U"h00FFFF", U"hFFFFFF"
  )
  val colorBarPixel = Converter(colors(7-colorSel.resized))(ConvertConfig(RGBCfg(8,8,8), colorCfg))

  // Gray Scale
  val grayLevel = ((hcnt - (hsync + hback)) * 255 / hdisp).resized
  val grayPixel = (grayLevel @@ grayLevel @@ grayLevel).resized

  // Grid
  val gridSpacing = 32
  val gridLine = (hcnt % gridSpacing === 0) || (vcnt % gridSpacing === 0)
  val gridPixel = Mux(gridLine, U((BigInt(1) << colorCfg.getWidth) - 1, colorCfg.getWidth bits), U(0, colorCfg.getWidth bits))

  // Output Selection
  val pixelData = UInt(colorCfg.getWidth bits)
  switch(io.muxsel) {
    is(TestPatternEnum.COLOR_BAR)  { pixelData := colorBarPixel }
    is(TestPatternEnum.GRAY_SCALE) { pixelData := grayPixel }
    is(TestPatternEnum.GRID)       { pixelData := gridPixel }
    is(TestPatternEnum.SOLID_COLOR){ pixelData := io.solidColor }
  }

  when(!io.dvt.de) {
    pixelData := 0
  }

  io.dvt.data := pixelData
}

case class TestSobel() extends Component {
  val dvtcfg = DVTCfg(1, 2, 160, 164, 1, 2, 30, 34)
  val colorConfig = RGBCfg(8,8,8)
  val testPattern = new TestPattern(dvtcfg, colorConfig)
  val sobel = new EdgeDetect(EdgeDetectConfig(
        colorCfg = colorConfig,
        lineLength = 160,
        threshold = 64))

  testPattern.io.muxsel := TestPatternEnum.COLOR_BAR
  testPattern.io.solidColor := U"h000000"
  sobel.io.pre << testPattern.io.dvt
  sobel.io.EN := True
}


/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */
// object TestPatternGen {
//   def main(args: Array[String]): Unit = {
//     val dvtcfg = DVTCfg(1, 2, 40, 44, 1, 2, 30, 34)
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       TestPattern(dvtcfg, RGBCfg(8,8,8))
//     )
//   }
// }

// object TestSobelGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       TestSobel()
//     )
//   }
// }
