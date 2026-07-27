package graphic.base

import chisel3._
import chisel3.util._

sealed trait ColorConfig { def width: Int }
case class ArgbConfig(alpha: Int, red: Int, green: Int, blue: Int) extends ColorConfig {
  val width = alpha + red + green + blue
}
case class RgbConfig(red: Int, green: Int, blue: Int) extends ColorConfig {
  val width = red + green + blue
}
case class YuvConfig(y: Int, u: Int, v: Int) extends ColorConfig { val width = y + u + v }
case class AlphaLumaConfig(alpha: Int, luma: Int) extends ColorConfig { val width = alpha + luma }
case class LumaConfig(luma: Int) extends ColorConfig { val width = luma }
case class BinaryConfig(bits: Int) extends ColorConfig { val width = bits }

class Color(val config: ColorConfig) extends Bundle {
  val value = UInt(config.width.W)
}

object ColorConvert {
  private def resize(channel: UInt, sourceWidth: Int, targetWidth: Int): UInt = {
    if (targetWidth == sourceWidth) channel
    else if (targetWidth < sourceWidth) channel(sourceWidth - 1, sourceWidth - targetWidth)
    else Cat(channel, Fill(targetWidth - sourceWidth, channel(0)))
  }

  def rgb(pixel: UInt, source: RgbConfig, target: RgbConfig): UInt = {
    val blue = pixel(source.blue - 1, 0)
    val green = pixel(source.blue + source.green - 1, source.blue)
    val red = pixel(source.width - 1, source.blue + source.green)
    Cat(
      resize(red, source.red, target.red),
      resize(green, source.green, target.green),
      resize(blue, source.blue, target.blue)
    )
  }
}
