package graphic.base

import spinal.core._

// Color format enumeration
object ColorFormat extends SpinalEnum {
  val ARGB, RGB, YUV, AL, L, B = newElement()
}

// Color Interface
trait ColorCfg {
  def getWidth: Int
}
object Color {
  def apply(colorCfg: ColorCfg): UInt = UInt(colorCfg.getWidth bits)
}

// ARGB color model configuration
case class ARGBCfg(aWidth: Int, rWidth: Int, gWidth: Int, bWidth: Int) extends ColorCfg {
  def getWidth = aWidth + rWidth + gWidth + bWidth
}
object ARGB{
  def apply(aWidth: Int, rWidth: Int, gWidth: Int, bWidth: Int): ARGB = ARGB(ARGBCfg(aWidth, rWidth, gWidth, bWidth))
}
case class ARGB(colorCfg: ARGBCfg) extends Bundle{
  val color = UInt(colorCfg.getWidth bits)
  def clear(): Unit ={ color := 0 }
}

// RGB color model configuration
case class RGBCfg(rWidth: Int, gWidth: Int, bWidth: Int) extends ColorCfg {
  def getWidth = rWidth + gWidth + bWidth
}
object RGB{
  def apply(rWidth: Int, gWidth: Int, bWidth: Int): RGB = RGB(RGBCfg(rWidth, gWidth, bWidth))
}
case class RGB(colorCfg: RGBCfg) extends Bundle{
  val color = UInt(colorCfg.getWidth bits)
  def clear(): Unit ={ color := 0 }
}

// YUV color model configuration
case class YUVCfg(yWidth: Int, uWidth: Int, vWidth: Int) extends ColorCfg {
  def getWidth = yWidth + uWidth + vWidth
}
object YUV{
  def apply(yWidth: Int, uWidth: Int, vWidth: Int): YUV = YUV(YUVCfg(yWidth, uWidth, vWidth))
}
case class YUV(colorCfg: YUVCfg) extends Bundle{
  val color = UInt(colorCfg.getWidth bits)
  def clear(): Unit ={ color := 0 }
}

// AL color model configuration
case class ALCfg(aWidth: Int, lWidth: Int) extends ColorCfg {
  def getWidth = aWidth + lWidth
}
object AL{
  def apply(aWidth: Int, lWidth: Int): AL = AL(ALCfg(aWidth, lWidth))
}
case class AL(colorCfg: ALCfg) extends Bundle{
  val color = UInt(colorCfg.getWidth bits)
  def clear(): Unit ={ color := 0 }
}

// L color model configuration
case class LCfg(lWidth: Int) extends ColorCfg {
  def getWidth = lWidth
}
object L{
  def apply(lWidth: Int): L = L(LCfg(lWidth))
}
case class L(colorCfg: LCfg) extends Bundle{
  val color = UInt(colorCfg.getWidth bits)
  def clear(): Unit ={ color := 0 }
}

// B color model configuration
case class BCfg(bWidth: Int) extends ColorCfg {
  def getWidth = bWidth
}
// object B{
//   def apply(bWidth: Int): B = B(BCfg(bWidth))
// }
// case class B(colorCfg: BCfg) extends Bundle{
//   val color = UInt(colorCfg.getWidth bits)
//   def clear(): Unit ={
//     color := 0
//   }
// }
