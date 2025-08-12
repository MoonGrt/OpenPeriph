package graphic.algorithm

import graphic.base._
import spinal.core._

// ---------- ColorConvert Function ----------
case class ConvertConfig(
  inCfg: ColorConfig,
  outCfg: ColorConfig,
  BThreshold: Int = 128
)

object Converter {
  def apply(cfg: ConvertConfig)(inColor: UInt): UInt = {
    cfg.inCfg match {
      case ARGBConfig(_, _, _, _) => ARGBConverter(cfg)(inColor)
      case RGBConfig(_, _, _)     => RGBConverter(cfg)(inColor)
      case YUVConfig(_, _, _)     => YUVConverter(cfg)(inColor)
      case ALConfig(_, _)         => ALConverter(cfg)(inColor)
      case LConfig(_)             => LConverter(cfg)(inColor)
      case _                      => inColor.resized
    }
  }
  // def apply(cfg: ConvertConfig)(inColor: UInt, outColor: UInt): Unit = {
  //   val result = cfg.inCfg match {
  //     case ARGBConfig(_, _, _, _) => ARGBConverter(cfg)(inColor)
  //     case RGBConfig(_, _, _)     => RGBConverter(cfg)(inColor)
  //     case YUVConfig(_, _, _)     => YUVConverter(cfg)(inColor)
  //     case ALConfig(_, _)         => ALConverter(cfg)(inColor)
  //     case LConfig(_)             => LConverter(cfg)(inColor)
  //     case _                      => inColor.resized
  //   }
  //   outColor := result
  // }
}

object ARGBConverter {
  def apply(cfg: ConvertConfig)(inColor: UInt): UInt = {
    cfg.inCfg match {
      case ARGBConfig(aW, rW, gW, bW) =>
        // Extract ARGB fields
        val a = inColor(aW - 1 downto 0)
        val r = inColor(aW + rW - 1 downto aW)
        val g = inColor(aW + rW + gW - 1 downto aW + rW)
        val b = inColor(aW + rW + gW + bW - 1 downto aW + rW + gW)
        // Color conversion logic
        cfg.outCfg match {
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
          // ARGB → B
          case BConfig(bW) =>
            val l = (r * 77) + (g * 151) + (b * 28) >> 8
            Mux(l >= cfg.BThreshold, U((1 << bW) - 1, bW bits), U(0, bW bits))
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not ARGB input, fallback
      case _ => inColor.resized
    }
  }
}

object RGBConverter {
  def apply(cfg: ConvertConfig)(inColor: UInt): UInt = {
    cfg.inCfg match {
      case RGBConfig(rW, gW, bW) =>
        // Extract RGB fields
        val r = inColor(rW - 1 downto 0)
        val g = inColor(rW + gW - 1 downto rW)
        val b = inColor(rW + gW + bW - 1 downto rW + gW)
        // Color conversion logic
        cfg.outCfg match {
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
          // RGB → B
          case BConfig(bW) =>
            val l = (r * 77) + (g * 151) + (b * 28) >> 8
            Mux(l >= cfg.BThreshold, U((1 << bW) - 1, bW bits), U(0, bW bits))
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not RGB input, fallback
      case _ => inColor.resized
    }
  }
}

object YUVConverter {
  def apply(cfg: ConvertConfig)(inColor: UInt): UInt = {
    cfg.inCfg match {
      case YUVConfig(yW, uW, vW) =>
        // Extract YUV fields
        val y = inColor(yW - 1 downto 0)
        val u = inColor(yW + uW - 1 downto yW)
        val v = inColor(yW + uW + vW - 1 downto yW + uW)
        // Color conversion logic
        cfg.outCfg match {
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
          // YUV → B
          case BConfig(bW) =>
            Mux(y >= cfg.BThreshold, U((1 << bW) - 1, bW bits), U(0, bW bits))
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not YUV input, fallback
      case _ => inColor.resized
    }
  }
}

object ALConverter {
  def apply(cfg: ConvertConfig)(inColor: UInt): UInt = {
    cfg.inCfg match {
      case ALConfig(aW, lW) =>
        // Extract AL fields
        val a = inColor(aW - 1 downto 0)
        val l = inColor(aW + aW - 1 downto aW)
        // Color conversion logic
        cfg.outCfg match {
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
          // AL → B
          case BConfig(bW) =>
            Mux(l >= cfg.BThreshold, U((1 << bW) - 1, bW bits), U(0, bW bits))
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not AL input, fallback
      case _ => inColor.resized
    }
  }
}

object LConverter {
  def apply(cfg: ConvertConfig)(inColor: UInt): UInt = {
    cfg.inCfg match {
      case LConfig(lW) =>
        // Extract L fields
        val l = inColor
        // Color conversion logic
        cfg.outCfg match {
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
          // L → B
          case BConfig(bW) =>
            Mux(l >= cfg.BThreshold, U((1 << bW) - 1, bW bits), U(0, bW bits))
          // fallback: passthrough
          case _ => inColor.resized
        }
      // Not L input, fallback
      case _ => inColor.resized
    }
  }
}

// ---------- ColorConvert module ----------
// Demo usage:
case class ColorConvert(cfg: ConvertConfig) extends Component {
  import cfg._
  val io = new Bundle {
    val inColor  = in(Color(inCfg))
    val outColor = out(Color(outCfg))
  }
  io.outColor := Converter(cfg)(io.inColor)
  // Converter(cfg)(io.inColor, io.outColor)
}

// Inpin color conversion module with muxing support
object ColorConvertType extends SpinalEnum {
  val ARGB8888, RGB888, RGB565, ARGB1555, ARGB4444, L8, AL44, AL88 = newElement()
}
object ColorConvert {
  def colorConfigOf(t: ColorConvertType.E): ColorConfig = t match {
    case ColorConvertType.ARGB8888 => ARGBConfig(8,8,8,8)
    case ColorConvertType.RGB888   => RGBConfig(8,8,8)
    case ColorConvertType.RGB565   => RGBConfig(5,6,5)
    case ColorConvertType.ARGB1555 => ARGBConfig(1,5,5,5)
    case ColorConvertType.ARGB4444 => ARGBConfig(4,4,4,4)
    case ColorConvertType.L8       => LConfig(8)
    case ColorConvertType.AL44     => ALConfig(4,4)
    case ColorConvertType.AL88     => ALConfig(8,8)
  }
}
case class ColorConvertMux(inCfg: ColorConfig) extends Component {
  import ColorConvert._
  // Calculate the configuration corresponding to the maximum bit width
  val maxCfg = ColorConvertType.elements
    .map(colorConfigOf)
    .maxBy(_.getWidth)
  val io = new Bundle {
    val inColor  = in(Color(inCfg))
    val muxSel   = in(ColorConvertType())
    val outColor = out(Color(maxCfg))
  }

  io.outColor := io.inColor.resized
  for (t <- ColorConvertType.elements) {
    when(io.muxSel === t) {
      io.outColor := Converter(ConvertConfig(inCfg, colorConfigOf(t)))(io.inColor).resized
    }
  }
}
case class ColorConvertDeMux(outCfg: ColorConfig) extends Component {
  import ColorConvert._
  // Calculate the configuration corresponding to the maximum bit width
  val maxInCfg = ColorConvertType.elements
    .map(colorConfigOf)
    .maxBy(_.getWidth)
  val io = new Bundle {
    val inColor  = in(Color(maxInCfg))
    val muxSel   = in(ColorConvertType())
    val outColor = out(Color(outCfg))
  }

  io.outColor := io.inColor.resized
  for (t <- ColorConvertType.elements) {
    when(io.muxSel === t) {
      io.outColor := Converter(ConvertConfig(colorConfigOf(t), outCfg))(io.inColor.resized)
    }
  }
}


// ---------- Generate ----------
// object ColorConvertGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       ColorConvert(ConvertConfig(
//         inCfg = ARGBConfig(8,8,8,8),
//         outCfg = RGBConfig(5,6,5))
//       )
//     )
//   }
// }

// object ColorConvertMuxGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       ColorConvertMux(inCfg = ARGBConfig(8,8,8,8))
//     )
//   }
// }

// object ColorConvertDeMuxGen {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       ColorConvertDeMux(outCfg = ARGBConfig(8,8,8,8))
//     )
//   }
// }
