package graphic.algorithm

import spinal.core._
import spinal.lib.misc.pipeline._


// case class ConverterIO(
//   rgb888: RGB = RGB(RGBConfig(8, 8, 8)),
//   rgbCfg: RGBConfig,
//   argbCfg: ARGBConfig,
//   alCfg: ALConfig,
//   lCfg: LConfig
// ) extends Bundle {
//   val format = in(ColorFormat())

//   val outRGB  = out(RGB(rgbCfg))
//   val outARGB = out(ARGB(argbCfg))
//   val outAL   = out(AL(alCfg))
//   val outL    = out(L(lCfg))
// }

// RGB888 Convert to other color formats
// case class RGB888ConverterIO(
//   rgb888: RGB = RGB(RGBConfig(8, 8, 8)),
//   rgbCfg: RGBConfig,
//   argbCfg: ARGBConfig,
//   alCfg: ALConfig,
//   lCfg: LConfig
// ) extends Bundle {
//   val format = in(ColorFormat())

//   val outRGB  = out(RGB(rgbCfg))
//   val outARGB = out(ARGB(argbCfg))
//   val outAL   = out(AL(alCfg))
//   val outL    = out(L(lCfg))
// }
// class RGB888Converter(rgbCfg: RGBConfig, argbCfg: ARGBConfig, alCfg: ALConfig, lCfg: LConfig) extends Component {
//   val io = new RGB888ConverterIO(
//     rgbCfg = rgbCfg, argbCfg = argbCfg, alCfg = alCfg, lCfg = lCfg
//   )

//   val r8 = io.rgb888.color(rgbCfg.getWidth - 1 downto rgbCfg.getWidth - 8)
//   val g8 = io.rgb888.color(rgbCfg.getWidth - 8 - 1 downto rgbCfg.getWidth - 16)
//   val b8 = io.rgb888.color(rgbCfg.getWidth - 16 - 1 downto rgbCfg.getWidth - 24)

//   switch(io.format) {
//     is(ColorFormat.RGB) {
//       val r = shrinkFrom8Bit(r8, rgbCfg.rWidth)
//       val g = shrinkFrom8Bit(g8, rgbCfg.gWidth)
//       val b = shrinkFrom8Bit(b8, rgbCfg.bWidth)
//       io.outRGB.color := r ## g ## b
//     }
//     is(ColorFormat.ARGB) {
//       val a = U(255)  // Full opaque
//       val r = shrinkFrom8Bit(r8, argbCfg.rWidth)
//       val g = shrinkFrom8Bit(g8, argbCfg.gWidth)
//       val b = shrinkFrom8Bit(b8, argbCfg.bWidth)
//       val alpha = shrinkFrom8Bit(a, argbCfg.aWidth)
//       io.outARGB.color := alpha ## r ## g ## b
//     }
//     is(ColorFormat.AL) {
//       val a = U(255)
//       val l = ((r8.asUInt + g8.asUInt + b8.asUInt) / 3).asUInt
//       val alpha = shrinkFrom8Bit(a, alCfg.aWidth)
//       val luminance = shrinkFrom8Bit(l, alCfg.lWidth)
//       io.outAL.color := alpha ## luminance
//     }
//     is(ColorFormat.L) {
//       val l = ((r8.asUInt + g8.asUInt + b8.asUInt) / 3).asUInt
//       val luminance = shrinkFrom8Bit(l, lCfg.lWidth)
//       io.outL.color := luminance
//     }
//   }
// }
