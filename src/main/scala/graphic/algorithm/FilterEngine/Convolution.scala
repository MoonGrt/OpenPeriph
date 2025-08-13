package graphic.algorithm

import graphic.base._
import spinal.core._
import spinal.lib._

/* --------------------------------------------------------------------------- */
/* -------------------------------- Shift Ram -------------------------------- */
/* --------------------------------------------------------------------------- */
// ShiftRamDyn is a dynamic shift register with wrap-around behavior
class ShiftRamDyn(dataWidth: Int, lineLengthBits: Int) extends Component {
  val io = new Bundle {
    val CE = in Bool()
    val D  = in Bits(dataWidth bits)
    val Q  = out Bits(dataWidth bits)
    val LINE_LENGTH = in UInt(lineLengthBits bits)
  }

  // Parameterize a max length by using a Mem; LINE_LENGTH controls wrap mask
  val maxLen = 1 << lineLengthBits
  val mem = Mem(Bits(dataWidth bits), maxLen)
  val wrPtr = RegInit(U(0, lineLengthBits bits))
  val rdPtr = RegInit(U(0, lineLengthBits bits))

  when(!io.CE) {
    io.Q := 0
  } otherwise {
    // write then read (same cycle behavior as original Verilog)
    mem(wrPtr) := io.D
    io.Q := mem(rdPtr)
    // increment with wrap
    val nextWr = wrPtr + 1
    val nextRd = rdPtr + 1
    when(nextWr === io.LINE_LENGTH) { wrPtr := U(0) } .otherwise { wrPtr := nextWr }
    when(nextRd === io.LINE_LENGTH) { rdPtr := U(0) } .otherwise { rdPtr := nextRd }
  }
}

// ShiftRam is a simple shift register with wrap-around behavior
class ShiftRam(dataWidth: Int, lineLength: Int) extends Component {
  val io = new Bundle {
    val CE = in Bool()
    val D  = in Bits(dataWidth bits)
    val Q  = out Bits(dataWidth bits)
  }

  // Parameterize a max length by using a Mem; LINE_LENGTH controls wrap mask
  val mem = Mem(Bits(dataWidth bits), lineLength)
  val wrPtr = RegInit(U(0, log2Up(lineLength) bits))
  val rdPtr = RegInit(U(0, log2Up(lineLength) bits))

  when(!io.CE) {
    io.Q := 0
  } otherwise {
    // write then read (same cycle behavior as original Verilog)
    mem(wrPtr) := io.D
    io.Q := mem.readSync(rdPtr)
    // increment with wrap
    val nextWr = wrPtr + 1
    val nextRd = rdPtr + 1
    when(nextWr === lineLength) { wrPtr := U(0) } .otherwise { wrPtr := nextWr }
    when(nextRd === lineLength) { rdPtr := U(0) } .otherwise { rdPtr := nextRd }
  }
}

/* ---------------------------------------------------------------------------- */
/* ---------------------------------- Matrix ---------------------------------- */
/* ---------------------------------------------------------------------------- */
/**
 * Matrix3x3 builds a 3x3 neighborhood for a single channel.
 * The output matrix signals are valid two cycles after input pre_de (matches Verilog behavior).
 */
case class Matrix3x3Interface(dataWidth: Int) extends Bundle with IMasterSlave {
  val m11 = SInt(dataWidth bits)
  val m12 = SInt(dataWidth bits)
  val m13 = SInt(dataWidth bits)
  val m21 = SInt(dataWidth bits)
  val m22 = SInt(dataWidth bits)
  val m23 = SInt(dataWidth bits)
  val m31 = SInt(dataWidth bits)
  val m32 = SInt(dataWidth bits)
  val m33 = SInt(dataWidth bits)

  override def asMaster() = this.asOutput()
  override def asSlave() = this.asInput()
  override def clone = new Matrix3x3Interface(dataWidth)

  def << (that: Matrix3x3Interface): Unit = {
    this.m11 := that.m11
    this.m12 := that.m12
    this.m13 := that.m13
    this.m21 := that.m21
    this.m22 := that.m22
    this.m23 := that.m23
    this.m31 := that.m31
    this.m32 := that.m32
    this.m33 := that.m33
  }
}
class Matrix3x3Dyn(dataWidth: Int, lineLengthBits: Int) extends Component {
  val io = new Bundle {
    val IMG_HDISP = in UInt(lineLengthBits bits)
    val pre = slave(DVTI(dataWidth))

    val matrix_vs = out Bool()
    val matrix_hs = out Bool()
    val matrix_de = out Bool()
    val matrix = master(Matrix3x3Interface(dataWidth))
  }

  // row shift: row1 is the straight input, row1 and row2 come from two line buffers
  val row1 = Bits(dataWidth bits)
  val row2 = Bits(dataWidth bits)
  val row3 = Reg(Bits(dataWidth bits))

  when(io.pre.de) { row3 := io.pre.data.asBits }

  val ram2 = new ShiftRamDyn(dataWidth, lineLengthBits)
  ram2.io.CE := io.pre.de
  ram2.io.D  := row3
  ram2.io.LINE_LENGTH := io.IMG_HDISP
  row2 := ram2.io.Q

  val ram1 = new ShiftRamDyn(dataWidth, lineLengthBits)
  ram1.io.CE := io.pre.de
  ram1.io.D  := row2
  ram1.io.LINE_LENGTH := io.IMG_HDISP
  row1 := ram1.io.Q

  // two-cycle sync for vs/de
  val pre_vs_r = Reg(Bits(2 bits)) init(0)
  val pre_hs_r = Reg(Bits(2 bits)) init(0)
  val pre_de_r = Reg(Bits(2 bits)) init(0)
  pre_vs_r := (pre_vs_r(0) ## io.pre.vs)
  pre_hs_r := (pre_hs_r(0) ## io.pre.hs)
  pre_de_r := (pre_de_r(0) ## io.pre.de)

  io.matrix_vs := pre_vs_r(1)
  io.matrix_hs := pre_hs_r(1)
  io.matrix_de := pre_de_r(1)

  // 3x3 shift registers per row
  val m11 = Reg(Bits(dataWidth bits)) init(0)
  val m12 = Reg(Bits(dataWidth bits)) init(0)
  val m13 = Reg(Bits(dataWidth bits)) init(0)
  val m21 = Reg(Bits(dataWidth bits)) init(0)
  val m22 = Reg(Bits(dataWidth bits)) init(0)
  val m23 = Reg(Bits(dataWidth bits)) init(0)
  val m31 = Reg(Bits(dataWidth bits)) init(0)
  val m32 = Reg(Bits(dataWidth bits)) init(0)
  val m33 = Reg(Bits(dataWidth bits)) init(0)

  when(pre_de_r(0)) {
    m11 := m12; m12 := m13; m13 := row1
    m21 := m22; m22 := m23; m23 := row2
    m31 := m32; m32 := m33; m33 := row3
  }

  io.matrix.m11 := m11.asSInt
  io.matrix.m12 := m12.asSInt
  io.matrix.m13 := m13.asSInt
  io.matrix.m21 := m21.asSInt
  io.matrix.m22 := m22.asSInt
  io.matrix.m23 := m23.asSInt
  io.matrix.m31 := m31.asSInt
  io.matrix.m32 := m32.asSInt
  io.matrix.m33 := m33.asSInt
}

class Matrix3x3(dataWidth: Int, lineLength: Int) extends Component {
  val io = new Bundle {
    val pre = slave(DVTI(dataWidth))

    val matrix_vs = out Bool()
    val matrix_hs = out Bool()
    val matrix_de = out Bool()
    val matrix = master(Matrix3x3Interface(dataWidth))
  }

  // row shift: row1 is the straight input, row1 and row2 come from two line buffers
  val row1 = Bits(dataWidth bits)
  val row2 = Bits(dataWidth bits)
  val row3 = Reg(Bits(dataWidth bits))

  row3 := io.pre.data.asBits

  val ram2 = new ShiftRam(dataWidth, lineLength)
  ram2.io.CE := io.pre.de
  ram2.io.D  := row3
  row2 := ram2.io.Q

  val ram1 = new ShiftRam(dataWidth, lineLength)
  ram1.io.CE := io.pre.de
  ram1.io.D  := row2
  row1 := ram1.io.Q

  // two-cycle sync for vs/de
  val pre_vs_r = Reg(Bits(2 bits)) init(0)
  val pre_hs_r = Reg(Bits(2 bits)) init(0)
  val pre_de_r = Reg(Bits(2 bits)) init(0)
  pre_vs_r := (pre_vs_r(0) ## io.pre.vs)
  pre_hs_r := (pre_hs_r(0) ## io.pre.hs)
  pre_de_r := (pre_de_r(0) ## io.pre.de)

  io.matrix_vs := pre_vs_r(1)
  io.matrix_hs := pre_hs_r(1)
  io.matrix_de := pre_de_r(1)

  // 3x3 shift registers per row
  val m11 = Reg(Bits(dataWidth bits)) init(0)
  val m12 = Reg(Bits(dataWidth bits)) init(0)
  val m13 = Reg(Bits(dataWidth bits)) init(0)
  val m21 = Reg(Bits(dataWidth bits)) init(0)
  val m22 = Reg(Bits(dataWidth bits)) init(0)
  val m23 = Reg(Bits(dataWidth bits)) init(0)
  val m31 = Reg(Bits(dataWidth bits)) init(0)
  val m32 = Reg(Bits(dataWidth bits)) init(0)
  val m33 = Reg(Bits(dataWidth bits)) init(0)
  when(pre_de_r(0)) {
    m11 := m12; m12 := m13; m13 := row1
    m21 := m22; m22 := m23; m23 := row2
    m31 := m32; m32 := m33; m33 := row3
  }

  io.matrix.m11 := m11.asSInt
  io.matrix.m12 := m12.asSInt
  io.matrix.m13 := m13.asSInt
  io.matrix.m21 := m21.asSInt
  io.matrix.m22 := m22.asSInt
  io.matrix.m23 := m23.asSInt
  io.matrix.m31 := m31.asSInt
  io.matrix.m32 := m32.asSInt
  io.matrix.m33 := m33.asSInt
}

/* --------------------------------------------------------------------------- */
/* ------------------------------- Convolution ------------------------------- */
/* --------------------------------------------------------------------------- */
case class Conv2D3x3ParamsInterface(dataWidth: Int) extends Bundle with IMasterSlave {
  val k11 = SInt(dataWidth bits)
  val k12 = SInt(dataWidth bits)
  val k13 = SInt(dataWidth bits)
  val k21 = SInt(dataWidth bits)
  val k22 = SInt(dataWidth bits)
  val k23 = SInt(dataWidth bits)
  val k31 = SInt(dataWidth bits)
  val k32 = SInt(dataWidth bits)
  val k33 = SInt(dataWidth bits)

  override def asMaster() = this.asOutput()
  override def asSlave() = this.asInput()
  override def clone = new Conv2D3x3ParamsInterface(dataWidth)

  def << (that: Conv2D3x3ParamsInterface): Unit = {
    this.k11 := that.k11
    this.k12 := that.k12
    this.k13 := that.k13
    this.k21 := that.k21
    this.k22 := that.k22
    this.k23 := that.k23
    this.k31 := that.k31
    this.k32 := that.k32
    this.k33 := that.k33
  }
}

case class Conv2DConfig(
  dataWidth    : Int,      // bits per pixel
  lineLength   : Int,      // number of pixels per line
  kernel       : Seq[Int], // 9 elements, row-major: k11,k12,k13,k21,...,k33
  kernelShift  : Int = 4   // right shift to divide by kernel sum (e.g. 16 -> shift 4)
)

case class Conv2D3x3(config: Conv2DConfig) extends Component {
  import config._
  val io = new Bundle {
    val EN   = in Bool()
    val pre  = slave(DVTI(dataWidth))
    val post = master(DVTI(dataWidth))
  }

  // instantiate matrix3x3 module
  val m = new Matrix3x3(dataWidth, lineLength)
  m.io.pre << io.pre

  // convolution compute for each channel
  def conv(m: Matrix3x3, kernel: Seq[Int]) = {
    // create signed wider accumulator to avoid overflow
    val acc = SInt(32 bits)
    // compute sum = sum(kernel[i]*pixel[i])
    val convm = Matrix3x3Interface(8)
    convm << m.io.matrix
    acc := ((convm.m11 * kernel(0)) + (convm.m12 * kernel(1)) + (convm.m13 * kernel(2)) +
            (convm.m21 * kernel(3)) + (convm.m22 * kernel(4)) + (convm.m23 * kernel(5)) +
            (convm.m31 * kernel(6)) + (convm.m32 * kernel(7)) + (convm.m33 * kernel(8))).resized
    // arithmetic right shift by kernelShift and saturate to 0..255
    val shifted = (acc >> kernelShift)
    val clipped = Bits(dataWidth bits)
    when(shifted < 0) { clipped := 0 } .elsewhen(shifted > 255) { clipped := 255 } .otherwise { clipped := shifted.resize(dataWidth).asBits }
    clipped
  }

  val convolution = conv(m, kernel)
  val conv_out = Reg(Bits(dataWidth bits)) init(0)
  // conv_out := Mux(mR.io.matrix_de, convolution, U((1 << dataWidth) - 1, dataWidth bits))
  when(m.io.matrix_de) {
    conv_out := convolution
  }

  // delay vs/de by one cycle to match data latency and support EN bypass
  val matrix_vs = Reg(Bool()) init(False)
  val matrix_hs = Reg(Bool()) init(False)
  val matrix_de = Reg(Bool()) init(False)
  matrix_vs := m.io.matrix_vs
  matrix_hs := m.io.matrix_hs
  matrix_de := m.io.matrix_de

  io.post.vs := Mux(io.EN, matrix_vs, io.pre.vs)
  io.post.hs := Mux(io.EN, matrix_hs, io.pre.hs)
  io.post.de := Mux(io.EN, matrix_de, io.pre.de)
  io.post.data := Mux(io.EN, conv_out.asUInt, io.pre.data)
}

// object Conv2DGen {
//   def main(args: Array[String]): Unit = {
//     val meanKernel = Seq(1,1,1, 1,1,1, 1,1,1) // Identity kernel: 1 1 1 / 1 1 1 / 1 1 1
//     val gaussianKernel = Seq(1,2,1, 2,4,2, 1,2,1) // Gaussian kernel: 1 2 1 / 2 4 2 / 1 2 1
//     val sharpenKernel = Seq(0,-1,0, -1,5,-1, 0,-1,0) // Sharpen kernel: 0 -1 0 / -1 5 -1 / 0 -1 0
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(
//       new Conv2D3x3(Conv2DConfig(
//         dataWidth = 8,
//         lineLength = 480,
//         kernel = gaussianKernel,
//         kernelShift = 4))
//     ).printPruned()
//   }
// }
