package graphic.algorithm

import graphic.base._
import spinal.core._
import spinal.lib._

case class FilterConfig(
  colorConfig: ColorConfig,
  lineLength: Int,
  kernel: Seq[Int],
  kernelShift: Int = 4
)

class Filter(config: FilterConfig) extends Component {
  import config._
  val io = new Bundle {
    val EN        = in Bool()
    val pre_vs    = in Bool()
    val pre_hs    = in Bool()
    val pre_de    = in Bool()
    val pre_data  = in Bits(colorConfig.getWidth bits)
    val post_vs   = out Bool()
    val post_hs   = out Bool()
    val post_de   = out Bool()
    val post_data = out Bits(colorConfig.getWidth bits)
  }

  // 通用卷积构造器
  def buildConv(w: Int) = {
    val conv = new Conv2D3x3(Conv2DConfig(w, lineLength, kernel, kernelShift))
    conv.io.EN     := io.EN
    conv.io.pre_vs := io.pre_vs
    conv.io.pre_hs := io.pre_hs
    conv.io.pre_de := io.pre_de
    conv
  }

  // 通用处理流程
  def processChannels(channelBits: Seq[Bits]) = {
    val convs = channelBits.map(ch => {
      val c = buildConv(ch.getWidth)
      c.io.pre_data := ch
      c
    })
    val combinedData = convs.map(_.io.post_data).reduce(_ ## _)
    io.post_vs   := Mux(io.EN, convs.head.io.post_vs, io.pre_vs)
    io.post_hs   := Mux(io.EN, convs.head.io.post_hs, io.pre_hs)
    io.post_de   := Mux(io.EN, convs.head.io.post_de, io.pre_de)
    io.post_data := Mux(io.EN, combinedData, io.pre_data)
  }

  colorConfig match {
    case ARGBConfig(aW, rW, gW, bW) =>
      processChannels(Seq(
        io.pre_data(aW - 1 downto 0),
        io.pre_data(aW + rW - 1 downto aW),
        io.pre_data(aW + rW + gW - 1 downto aW + rW),
        io.pre_data(aW + rW + gW + bW - 1 downto aW + rW + gW)
      ))
    case RGBConfig(rW, gW, bW) =>
      processChannels(Seq(
        io.pre_data(rW - 1 downto 0),
        io.pre_data(rW + gW - 1 downto rW),
        io.pre_data(rW + gW + bW - 1 downto rW + gW)
      ))
    case YUVConfig(yW, uW, vW) =>
      processChannels(Seq(
        io.pre_data(yW - 1 downto 0),
        io.pre_data(yW + uW - 1 downto yW),
        io.pre_data(yW + uW + vW - 1 downto yW + uW)
      ))
    case ALConfig(aW, lW) =>
      processChannels(Seq(
        io.pre_data(aW - 1 downto 0),
        io.pre_data(aW + lW - 1 downto aW)
      ))
    case LConfig(lW) =>
      processChannels(Seq(io.pre_data))
    case _ =>
      io.post_vs   := io.pre_vs
      io.post_hs   := io.pre_hs
      io.post_de   := io.pre_de
      io.post_data := io.pre_data
  }
}

object FilterGen {
  def main(args: Array[String]): Unit = {
    val gaussianKernel = Seq(1, 2, 1, 2, 4, 2, 1, 2, 1)
    SpinalConfig(targetDirectory = "rtl").generateVerilog(
      new Filter(FilterConfig(
        colorConfig = ARGBConfig(8,8,8,8),
        lineLength = 480,
        kernel = gaussianKernel,
        kernelShift = 4
      ))
    )
  }
}
