package graphic.algorithm

import graphic.base._
import spinal.core._


// // ---------- ColorBlend Function ----------
// object Blender {
//   def apply(inColor1: UInt, inColor2: UInt, inCfg1: ColorCfg, inCfg2: ColorCfg): UInt = {
//     inCfg1 match {
//       case ARGBCfg(_, _, _, _) => ARGBBlender(inColor1, inColor2, inCfg1, inCfg2)
//     //   case RGBCfg(_, _, _)     => RGBBlender(inColor, inCfg, outCfg)
//     //   case YUVCfg(_, _, _)     => YUVBlender(inColor, inCfg, outCfg)
//     //   case ALCfg(_, _)         => ALBlender(inColor, inCfg, outCfg)
//     //   case LCfg(_)             => LBlender(inColor, inCfg, outCfg)
//       case _                      => inColor.resized
//     }
//   }
// }

// object ARGBBlender {
//   def apply(inColor1: UInt, inColor2: UInt, inCfg1: ColorCfg, inCfg2: ColorCfg): UInt = {
//     inCfg match {
//       case ARGBCfg(aW, rW, gW, bW) =>

//     }
//   }
// }

// // ---------- ColorBlend module ----------
// case class ColorBlend(inCfg: ColorCfg, outCfg: ColorCfg) extends Component {
//   val io = new Bundle {
//     val inColor  = in(Color(infig))
//     val outColor = out(Color(outCfg))
//   }
//   io.outColor := Blender(io.inColor, inCfg, outCfg)
// }

// object ColorBlendGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       ColorBlend(
//         inCfg = ALCfg(8,8),
//         outCfg = RGBCfg(5,6,5)
//       )
//     )
//   }
// }
