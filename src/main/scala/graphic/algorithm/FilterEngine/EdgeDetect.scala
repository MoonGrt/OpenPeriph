package graphic.algorithm

import graphic.base._
import spinal.core._
import spinal.lib._

case class EdgeDetectConfig(
  colorCfg: ColorCfg,
  lineLength: Int,
  threshold: Int = 128
)

class EdgeDetect(config: EdgeDetectConfig) extends Component {
  import config._
  val io = new Bundle {
    val EN   = in Bool()
    val pre  = slave(DVTI(colorCfg.getWidth))
    val post = master(DVTI(colorCfg.getWidth))
  }

  // Convert all input colors to 8-bit grayscale L
  val L = Converter(io.pre.data)(ConvertConfig(colorCfg, LCfg(8)))

  // Sobel Horizontal convolution kernel
  val kernelGx = Seq(
    -1, 0, 1,
    -2, 0, 2,
    -1, 0, 1
  )
  // Sobel Vertical convolution kernel
  val kernelGy = Seq(
    -1, -2, -1,
     0,  0,  0,
     1,  2,  1
  )

  // Create two convolvers (Gx and Gy)
  val convGx = new Conv2D3x3(Conv2DConfig(8, lineLength, kernelGx, 0))
  val convGy = new Conv2D3x3(Conv2DConfig(8, lineLength, kernelGy, 0))

  convGx.io.EN     := io.EN
  convGx.io.pre.vs := io.pre.vs
  convGx.io.pre.hs := io.pre.hs
  convGx.io.pre.de := io.pre.de
  convGx.io.pre.data := L

  convGy.io.EN     := io.EN
  convGy.io.pre.vs := io.pre.vs
  convGy.io.pre.hs := io.pre.hs
  convGy.io.pre.de := io.pre.de
  convGy.io.pre.data := L

  // Calculate gradient = |Gx| + |Gy|
  val Gx = convGx.io.post.data.asSInt.abs
  val Gy = convGy.io.post.data.asSInt.abs
  val grad = (Gx + Gy).resize(8)
  val bin = Converter(grad)(ConvertConfig(LCfg(8), BCfg(colorCfg.getWidth)))

  io.post.vs   := Mux(io.EN, convGx.io.post.vs, io.pre.vs)
  io.post.hs   := Mux(io.EN, convGx.io.post.hs, io.pre.hs)
  io.post.de   := Mux(io.EN, convGx.io.post.de, io.pre.de)
  io.post.data := Mux(io.EN, bin, L)
}

// object EdgeDetectGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       new EdgeDetect(EdgeDetectConfig(
//         colorCfg = RGBCfg(8,8,8),
//         lineLength = 480,
//         threshold = 128
//       ))
//     ).printPruned()
//   }
// }
