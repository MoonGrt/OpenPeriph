// Digital Video Timing Receiver (DVTR) Apb3 Interface
package graphic.dvt

import graphic.base._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._

/* -------------------------------------------------------------------------- */
/*                               Generics                                      */
/* -------------------------------------------------------------------------- */

case class DvtRGenerics(
  apb3Config : Apb3Config,
  colorWidth : Int = 8
)

/* -------------------------------------------------------------------------- */
/*                               DVTR Core                                     */
/* -------------------------------------------------------------------------- */

case class Apb3DvtR(config: DvtRGenerics) extends Component {
  import config._

  val io = new Bundle {
    val apb       = slave(Apb3(apb3Config))
    val dvti      = slave(DVTI(colorWidth))
    val interrupt = out Bool()
  }

  val ctrl = Apb3SlaveFactory(io.apb)

  /* -------------------------------------------------------------------------- */
  /*                               Registers                                     */
  /* -------------------------------------------------------------------------- */

  val CR      = Reg(UInt(32 bits)) init(0) // 0x00
  val SR      = Reg(UInt(32 bits)) init(0) // 0x04
  val RISR    = Reg(UInt(32 bits)) init(0) // 0x08
  val IER     = Reg(UInt(32 bits)) init(0) // 0x0C
  val MISR    = Reg(UInt(32 bits)) init(0) // 0x10
  val ICR     = Reg(UInt(32 bits)) init(0) // 0x14
  val ESCR    = Reg(UInt(32 bits)) init(0) // 0x18
  val ESUR    = Reg(UInt(32 bits)) init(0) // 0x1C
  val CWSTRTR = Reg(UInt(32 bits)) init(0) // 0x20
  val CWSIZER = Reg(UInt(32 bits)) init(0) // 0x24
  val DR      = Reg(UInt(32 bits)) init(0) // 0x28

  /* -------------------------------------------------------------------------- */
  /*                              APB Mapping                                    */
  /* -------------------------------------------------------------------------- */

  ctrl.readAndWrite(CR,      0x00)
  ctrl.read(SR,              0x04)
  ctrl.read(RISR,            0x08)
  ctrl.readAndWrite(IER,     0x0C)
  ctrl.read(MISR,            0x10)
  ctrl.write(ICR,            0x14)
  ctrl.readAndWrite(ESCR,    0x18)
  ctrl.readAndWrite(ESUR,    0x1C)
  ctrl.readAndWrite(CWSTRTR, 0x20)
  ctrl.readAndWrite(CWSIZER, 0x24)
  ctrl.read(DR,              0x28)

  /* -------------------------------------------------------------------------- */
  /*                             CR bit fields                                   */
  /* -------------------------------------------------------------------------- */

  val CR_ENABLE  = 0  // DCMI enable
  val CR_CAPTURE = 1  // 0: continuous, 1: snapshot
  val CR_CROP    = 2
  val CR_PCKPOL  = 3
  val CR_HSPOL   = 4
  val CR_VSPOL   = 5

  /* -------------------------------------------------------------------------- */
  /*                         Input synchronization                                */
  /* -------------------------------------------------------------------------- */

  val pclk  = io.dvti.hs  // TODO
  val hs    = io.dvti.hs
  val vs    = io.dvti.vs
  val data  = io.dvti.data

  val hs_evt = Mux(CR(CR_HSPOL), hs.rise, hs.fall)
  val vs_evt = Mux(CR(CR_VSPOL), vs.rise, vs.fall)
  val px_evt = Mux(CR(CR_PCKPOL), pclk.rise, pclk.fall)

  /* -------------------------------------------------------------------------- */
  /*                       Position counters (X/Y)                               */
  /* -------------------------------------------------------------------------- */

  val xCnt = Reg(UInt(16 bits)) init(0)
  val yCnt = Reg(UInt(16 bits)) init(0)

  when(vs_evt) {
    xCnt := 0
    yCnt := 0
    RISR(1) := True // Frame interrupt
  }

  when(hs_evt) {
    xCnt := 0
    yCnt := yCnt + 1
    RISR(2) := True // Line interrupt
  }

  when(px_evt && CR(CR_ENABLE)) {
    xCnt := xCnt + 1
  }

  /* -------------------------------------------------------------------------- */
  /*                             Crop window                                     */
  /* -------------------------------------------------------------------------- */

  val cropX0 = CWSTRTR(15 downto 0)
  val cropY0 = CWSTRTR(31 downto 16)
  val cropW  = CWSIZER(15 downto 0)
  val cropH  = CWSIZER(31 downto 16)

  val inCrop =
    (!CR(CR_CROP)) ||
    (xCnt >= cropX0 && xCnt < (cropX0 + cropW) &&
     yCnt >= cropY0 && yCnt < (cropY0 + cropH))

  /* -------------------------------------------------------------------------- */
  /*                             Data capture                                    */
  /* -------------------------------------------------------------------------- */

  val captureEn = CR(CR_ENABLE)

  when(px_evt && captureEn && inCrop) {
    DR := data.resized
    RISR(0) := True // Data ready
  }

  /* Snapshot mode auto-stop */
  when(CR(CR_CAPTURE) && vs_evt) {
    CR(CR_ENABLE) := False
  }

  /* -------------------------------------------------------------------------- */
  /*                             Status register                                  */
  /* -------------------------------------------------------------------------- */

  SR(0) := CR(CR_ENABLE)
  SR(1) := vs
  SR(2) := hs
  SR(3) := inCrop

  /* -------------------------------------------------------------------------- */
  /*                             Interrupt logic                                  */
  /* -------------------------------------------------------------------------- */

  MISR := RISR & IER

  ctrl.onWrite(0x14) { // ICR
    RISR := RISR & ~io.apb.PWDATA.asUInt
  }

  io.interrupt := MISR.orR
}

/* ----------------------------------------------------------------------------- */
/* ---------------------------------- Demo Gen --------------------------------- */
/* ----------------------------------------------------------------------------- */

object Apb3DvtRGen {
  def main(args: Array[String]): Unit = {
    SpinalConfig(
      targetDirectory = "rtl"
    ).generateVerilog(
      Apb3DvtR(
        DvtRGenerics(
          apb3Config = Apb3Config(
            addressWidth = 12,
            dataWidth    = 32
          ),
          colorWidth = 8
        )
      )
    )
  }
}
