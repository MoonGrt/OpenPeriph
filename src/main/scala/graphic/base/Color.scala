package graphic.base

import spinal.core._

// Color format enumeration
object ColorFormat extends SpinalEnum {
  val ARGB, RGB, YUV, AL, L = newElement()
}

// Color Interface
trait ColorConfig {
  def getWidth: Int
}
case class Color(config: ColorConfig) extends Bundle{
  val color = UInt(config.getWidth bits)
}

// ARGB color model configuration
case class ARGBConfig(aWidth: Int, rWidth: Int, gWidth: Int, bWidth: Int) extends ColorConfig {
  def getWidth = aWidth + rWidth + gWidth + bWidth
}
object ARGB{
  def apply(aWidth: Int, rWidth: Int, gWidth: Int, bWidth: Int): ARGB = ARGB(ARGBConfig(aWidth, rWidth, gWidth, bWidth))
}
case class ARGB(config: ARGBConfig) extends Bundle{
  val color = UInt(config.getWidth bits)
  def clear(): Unit ={
    color := 0
  }
}

// RGB color model configuration
case class RGBConfig(rWidth: Int, gWidth: Int, bWidth: Int) extends ColorConfig {
  def getWidth = rWidth + gWidth + bWidth
}
object RGB{
  def apply(rWidth: Int, gWidth: Int, bWidth: Int): RGB = RGB(RGBConfig(rWidth, gWidth, bWidth))
}
case class RGB(config: RGBConfig) extends Bundle{
  val color = UInt(config.getWidth bits)
  def clear(): Unit ={
    color := 0
  }
}

// YUV color model configuration
case class YUVConfig(yWidth: Int, uWidth: Int, vWidth: Int) extends ColorConfig {
  def getWidth = yWidth + uWidth + vWidth
}
object YUV{
  def apply(yWidth: Int, uWidth: Int, vWidth: Int): YUV = YUV(YUVConfig(yWidth, uWidth, vWidth))
}
case class YUV(config: YUVConfig) extends Bundle{
  val color = UInt(config.getWidth bits)
  def clear(): Unit ={
    color := 0
  }
}

// AL color model configuration
case class ALConfig(aWidth: Int, lWidth: Int) extends ColorConfig {
  def getWidth = aWidth + lWidth
}
object AL{
  def apply(aWidth: Int, lWidth: Int): AL = AL(ALConfig(aWidth, lWidth))
}
case class AL(config: ALConfig) extends Bundle{
  val color = UInt(config.getWidth bits)
  def clear(): Unit ={
    color := 0
  }
}

// L color model configuration
case class LConfig(lWidth: Int) extends ColorConfig {
  def getWidth = lWidth
}
object L{
  def apply(lWidth: Int): L = L(LConfig(lWidth))
}
case class L(config: LConfig) extends Bundle{
  val color = UInt(config.getWidth bits)
  def clear(): Unit ={
    color := 0
  }
}
