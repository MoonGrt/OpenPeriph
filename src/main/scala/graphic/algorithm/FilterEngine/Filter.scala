package graphic.algorithm

import graphic.base._
import spinal.core._
import spinal.lib._

case class FilterConfig(
  colorCfg: ColorCfg,
  lineLength: Int,
  kernel: Seq[Int],
  kernelShift: Int = 4
)

class Filter(config: FilterConfig) extends Component {
  import config._
  val io = new Bundle {
    val EN   = in Bool()
    val pre  = slave(DVTI(colorCfg.getWidth))
    val post = master(DVTI(colorCfg.getWidth))
  }

  // General processing flow
  def processChannels(channelBits: Seq[Bits]) = {
    // General Convolution Constructor
    def buildConv(w: Int) = {
      val conv = new Conv2D3x3(UInt(w bits), Conv2DConfig(w, w, lineLength, kernel, kernelShift))
      conv.io.EN     := io.EN
      conv.io.pre.vs := io.pre.vs
      conv.io.pre.hs := io.pre.hs
      conv.io.pre.de := io.pre.de
      conv
    }
    // Build Convolutions for each channel
    val convs = channelBits.map(ch => {
      val c = buildConv(ch.getWidth)
      c.io.pre.data := ch.asUInt
      c
    })
    val combinedData = convs.map(_.io.post.data.asBits).reduce(_ ## _)
    io.post.vs   := Mux(io.EN, convs.head.io.post.vs, io.pre.vs)
    io.post.hs   := Mux(io.EN, convs.head.io.post.hs, io.pre.hs)
    io.post.de   := Mux(io.EN, convs.head.io.post.de, io.pre.de)
    io.post.data := Mux(io.EN, combinedData.asUInt, io.pre.data)
  }

  colorCfg match {
    case ARGBCfg(aW, rW, gW, bW) =>
      processChannels(Seq(
        io.pre.data.asBits(aW - 1 downto 0),
        io.pre.data.asBits(aW + rW - 1 downto aW),
        io.pre.data.asBits(aW + rW + gW - 1 downto aW + rW),
        io.pre.data.asBits(aW + rW + gW + bW - 1 downto aW + rW + gW)
      ))
    case RGBCfg(rW, gW, bW) =>
      processChannels(Seq(
        io.pre.data.asBits(rW - 1 downto 0),
        io.pre.data.asBits(rW + gW - 1 downto rW),
        io.pre.data.asBits(rW + gW + bW - 1 downto rW + gW)
      ))
    case YUVCfg(yW, uW, vW) =>
      processChannels(Seq(
        io.pre.data.asBits(yW - 1 downto 0),
        io.pre.data.asBits(yW + uW - 1 downto yW),
        io.pre.data.asBits(yW + uW + vW - 1 downto yW + uW)
      ))
    case ALCfg(aW, lW) =>
      processChannels(Seq(
        io.pre.data.asBits(aW - 1 downto 0),
        io.pre.data.asBits(aW + lW - 1 downto aW)
      ))
    case LCfg(lW) =>
      processChannels(Seq(io.pre.data.asBits))
    case _ =>
      io.post << io.pre
  }
}

// object FilterGen {
//   def main(args: Array[String]): Unit = {
//     val meanKernel = Seq(1,1,1, 1,1,1, 1,1,1) // Identity kernel: 1 1 1 / 1 1 1 / 1 1 1
//     val gaussianKernel = Seq(1,2,1, 2,4,2, 1,2,1) // Gaussian kernel: 1 2 1 / 2 4 2 / 1 2 1
//     val sharpenKernel = Seq(0,-1,0, -1,5,-1, 0,-1,0) // Sharpen kernel: 0 -1 0 / -1 5 -1 / 0 -1 0
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       new Filter(FilterConfig(
//         colorCfg = RGBCfg(8,8,8),
//         lineLength = 480,
//         kernel = gaussianKernel,
//         kernelShift = 4
//       ))
//     ).printPruned()
//   }
// }
