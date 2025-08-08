package graphic.algorithm

import graphic.base._
import spinal.core._

// ---------- ColorConvert Function ----------
object Converter {
  def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt): UInt = {
    inCfg match {
      case ARGBConfig(_, _, _, _) => ARGBConverter(inCfg, outCfg)(inColor)
      case RGBConfig(_, _, _)     => RGBConverter(inCfg, outCfg)(inColor)
      case YUVConfig(_, _, _)     => YUVConverter(inCfg, outCfg)(inColor)
      case ALConfig(_, _)         => ALConverter(inCfg, outCfg)(inColor)
      case LConfig(_)             => LConverter(inCfg, outCfg)(inColor)
      case _                      => inColor.resized
    }
  }
  // def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt, outColor: UInt): Unit = {
  //   val result = inCfg match {
  //     case ARGBConfig(_, _, _, _) => ARGBConverter(inCfg, outCfg)(inColor)
  //     case RGBConfig(_, _, _)     => RGBConverter(inCfg, outCfg)(inColor)
  //     case YUVConfig(_, _, _)     => YUVConverter(inCfg, outCfg)(inColor)
  //     case ALConfig(_, _)         => ALConverter(inCfg, outCfg)(inColor)
  //     case LConfig(_)             => LConverter(inCfg, outCfg)(inColor)
  //     case _                      => inColor.resized
  //   }
  //   outColor := result
  // }
}

object ARGBConverter {
  def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt): UInt = {
    inCfg match {
      case ARGBConfig(aW, rW, gW, bW) =>
        // Extract ARGB fields
        val a = inColor(aW - 1 downto 0)
        val r = inColor(aW + rW - 1 downto aW)
        val g = inColor(aW + rW + gW - 1 downto aW + rW)
        val b = inColor(aW + rW + gW + bW - 1 downto aW + rW + gW)
        // Color conversion logic
        outCfg match {
          // ARGB → ARGB
          case ARGBConfig(aW, rW, gW, bW) =>
            (b.asBits.resizeLeft(bW) ## g.asBits.resizeLeft(gW) ## r.asBits.resizeLeft(rW) ## a.asBits.resizeLeft(aW)).asUInt
          // ARGB → RGB
          case RGBConfig(rW, gW, bW) =>
            (b.asBits.resizeLeft(bW) ## g.asBits.resizeLeft(gW) ## r.asBits.resizeLeft(rW)).asUInt
          // ARGB → YUV
          case YUVConfig(yW, uW, vW) =>
            val y = ((r * 77) + (g * 150) + (b * 29)) >> 8
            val u = (((b * 128) - (r * 43) - (g * 85)) >> 8) + 128
            val v = (((r * 128) - (g * 107) - (b * 21)) >> 8) + 128
            (v.asBits.resizeLeft(vW) ## u.asBits.resizeLeft(uW) ## y.asBits.resizeLeft(yW)).asUInt
          // ARGB → AL
          case ALConfig(aW, lW) =>
            val l = (r * 77) + (g * 151) + (b * 28) >> 8
            (l.asBits.resizeLeft(lW) ## a.asBits.resizeLeft(aW)).asUInt
          // ARGB → L
          case LConfig(lW) =>
            val l = (r * 77) + (g * 151) + (b * 28) >> 8
            l.asBits.resizeLeft(lW).asUInt
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not ARGB input, fallback
      case _ => inColor.resized
    }
  }
}

object RGBConverter {
  def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt): UInt = {
    inCfg match {
      case RGBConfig(rW, gW, bW) =>
        // Extract RGB fields
        val r = inColor(rW - 1 downto 0)
        val g = inColor(rW + gW - 1 downto rW)
        val b = inColor(rW + gW + bW - 1 downto rW + gW)
        // Color conversion logic
        outCfg match {
          // RGB → ARGB
          case ARGBConfig(aW, rW, gW, bW) => // A field is set to 0
            (b.asBits.resizeLeft(bW) ## g.asBits.resizeLeft(gW) ## r.asBits.resizeLeft(rW) ## B(0, aW bits)).asUInt
          // RGB → RGB
          case RGBConfig(rW, gW, bW) =>
            (b.asBits.resizeLeft(bW) ## g.asBits.resizeLeft(gW) ## r.asBits.resizeLeft(rW)).asUInt
          // RGB → YUV
          case YUVConfig(yW, uW, vW) =>
            val y = ((r * 77) + (g * 150) + (b * 29)) >> 8
            val u = (((b * 128) - (r * 43) - (g * 85)) >> 8) + 128
            val v = (((r * 128) - (g * 107) - (b * 21)) >> 8) + 128
            (v.asBits.resizeLeft(vW) ## u.asBits.resizeLeft(uW) ## y.asBits.resizeLeft(yW)).asUInt
          // RGB → AL
          case ALConfig(aW, lW) => // A field is set to 0
            val l = (r * 77) + (g * 151) + (b * 28) >> 8
            (l.asBits.resizeLeft(lW) ## B(0, aW bits)).asUInt
          // RGB → L
          case LConfig(lW) =>
            val l = (r * 77) + (g * 151) + (b * 28) >> 8
            l.asBits.resizeLeft(lW).asUInt
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not RGB input, fallback
      case _ => inColor.resized
    }
  }
}

object YUVConverter {
  def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt): UInt = {
    inCfg match {
      case YUVConfig(yW, uW, vW) =>
        // Extract YUV fields
        val y = inColor(yW - 1 downto 0)
        val u = inColor(yW + uW - 1 downto yW)
        val v = inColor(yW + uW + vW - 1 downto yW + uW)
        // Color conversion logic
        outCfg match {
          // YUV → ARGB
          case ARGBConfig(aW, rW, gW, bW) => // A field is set to 0
            val r = y + ((359 * (v - 128)) >> 8)
            val g = y - (( 88 * (u - 128) + 183 * (v - 128)) >> 8)
            val b = y + ((454 * (u - 128)) >> 8)
            (b.asBits.resizeLeft(bW) ## g.asBits.resizeLeft(gW) ## r.asBits.resizeLeft(rW) ## B(0, aW bits)).asUInt
          // YUV → RGB
          case RGBConfig(rW, gW, bW) =>
            val r = y + ((359 * (v - 128)) >> 8)
            val g = y - (( 88 * (u - 128) + 183 * (v - 128)) >> 8)
            val b = y + ((454 * (u - 128)) >> 8)
            (b.asBits.resizeLeft(bW) ## g.asBits.resizeLeft(gW) ## r.asBits.resizeLeft(rW)).asUInt
          // YUV → YUV
          case YUVConfig(yW, uW, vW) =>
            (v.asBits.resizeLeft(vW) ## u.asBits.resizeLeft(uW) ## y.asBits.resizeLeft(yW)).asUInt
          // YUV → AL
          case ALConfig(aW, lW) => // A field is set to 0
            (y.asBits.resizeLeft(lW) ## B(0, aW bits)).asUInt
          // YUV → L (grayscale)
          case LConfig(lW) =>
            y.asBits.resizeLeft(lW).asUInt
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not YUV input, fallback
      case _ => inColor.resized
    }
  }
}

object ALConverter {
  def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt): UInt = {
    inCfg match {
      case ALConfig(aW, lW) =>
        // Extract AL fields
        val l = inColor(lW - 1 downto 0)
        val a = inColor(lW + aW - 1 downto lW)
        // Color conversion logic
        outCfg match {
          // AL → ARGB
          case ARGBConfig(aW, rW, gW, bW) => // RGB fields are set to L
            (l.asBits.resizeLeft(bW) ## l.asBits.resizeLeft(gW) ## l.asBits.resizeLeft(rW) ## a.asBits.resizeLeft(aW)).asUInt
          // AL → RGB
          case RGBConfig(rW, gW, bW) => // RGB fields are set to L
            (l.asBits.resizeLeft(bW) ## l.asBits.resizeLeft(gW) ## l.asBits.resizeLeft(rW)).asUInt
          // AL → YUV
          case YUVConfig(yW, uW, vW) => // UV field is set to 0
            (B(0, aW bits) ## B(0, aW bits) ## l.asBits.resizeLeft(yW)).asUInt
          // AL → AL
          case ALConfig(aW, lW) =>
            (l.asBits.resizeLeft(lW) ## a.asBits.resizeLeft(lW)).asUInt
          // AL → L
          case LConfig(lW) =>
            l.asBits.resizeLeft(lW).asUInt
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not AL input, fallback
      case _ => inColor.resized
    }
  }
}

object LConverter {
  def apply(inCfg: ColorConfig, outCfg: ColorConfig)(inColor: UInt): UInt = {
    inCfg match {
      case LConfig(lW) =>
        // Extract L fields
        val l = inColor
        // Color conversion logic
        outCfg match {
          // L → ARGB
          case ARGBConfig(aW, rW, gW, bW) => // RGB fields are set to L
            (l.asBits.resizeLeft(bW) ## l.asBits.resizeLeft(gW) ## l.asBits.resizeLeft(rW) ## B(0, aW bits)).asUInt
          // L → RGB
          case RGBConfig(rW, gW, bW) => // RGB fields are set to L
            (l.asBits.resizeLeft(bW) ## l.asBits.resizeLeft(gW) ## l.asBits.resizeLeft(rW)).asUInt
          // L → YUV
          case YUVConfig(yW, uW, vW) => // UV field is set to 0
            (B(0, vW bits) ## B(0, uW bits) ## l.asBits.resizeLeft(yW)).asUInt
          // L → AL
          case ALConfig(aW, lW) =>
            (l.asBits.resizeLeft(lW) ## B(0, aW bits)).asUInt
          // L → L
          case LConfig(lW) =>
            l.asBits.resizeLeft(lW).asUInt
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not L input, fallback
      case _ => inColor.resized
    }
  }
}

// ---------- ColorConvert module ----------
case class ColorConvert(inCfg: ColorConfig, outCfg: ColorConfig) extends Component {
  val io = new Bundle {
    val inColor  = in(UInt(inCfg.getWidth bits))
    val outColor = out(UInt(outCfg.getWidth bits))
  }
  io.outColor := Converter(inCfg, outCfg)(io.inColor)
  // Converter(inCfg, outCfg)(io.inColor, io.outColor)
}

// object ColorConvertGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       ColorConvert(
//         inCfg = ARGBConfig(8,8,8,8),
//         outCfg = RGBConfig(5,6,5)
//       )
//     )
//   }
// }
