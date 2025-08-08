package graphic.algorithm

import graphic.base._
import spinal.core._


// // ---------- ColorBlend Function ----------
// object Blender {
//   def apply(inColor1: UInt, inColor2: UInt, inCfg1: ColorConfig, inCfg2: ColorConfig): UInt = {
//     inCfg1 match {
//       case ARGBConfig(_, _, _, _) => ARGBBlender(inColor1, inColor2, inCfg1, inCfg2)
//     //   case RGBConfig(_, _, _)     => RGBBlender(inColor, inCfg, outCfg)
//     //   case YUVConfig(_, _, _)     => YUVBlender(inColor, inCfg, outCfg)
//     //   case ALConfig(_, _)         => ALBlender(inColor, inCfg, outCfg)
//     //   case LConfig(_)             => LBlender(inColor, inCfg, outCfg)
//       case _                      => inColor.resized
//     }
//   }
// }

// object ARGBBlender {
//   def apply(inColor1: UInt, inColor2: UInt, inCfg1: ColorConfig, inCfg2: ColorConfig): UInt = {
//     inCfg match {
//       case ARGBConfig(aW, rW, gW, bW) =>

//     }
//   }
// }

// // ---------- ColorBlend module ----------
// case class ColorBlend(inCfg: ColorConfig, outCfg: ColorConfig) extends Component {
//   val io = new Bundle {
//     val inColor  = in(UInt(inCfg.getWidth bits))
//     val outColor = out(UInt(outCfg.getWidth bits))
//   }
//   io.outColor := Blender(io.inColor, inCfg, outCfg)
// }

// object ColorBlendGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       ColorBlend(
//         inCfg = ALConfig(8,8),
//         outCfg = RGBConfig(5,6,5)
//       )
//     )
//   }
// }
