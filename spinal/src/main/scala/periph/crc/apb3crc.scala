package periph

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._

object Apb3Crc {
  def apb3Config(addressWidth: Int, dataWidth: Int) =
    Apb3Config(addressWidth = addressWidth, dataWidth = dataWidth)
}

/** STM32F1-compatible CRC calculation unit. */
case class Apb3Crc(addressWidth: Int = 5, dataWidth: Int = 32) extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Crc.apb3Config(addressWidth, dataWidth)))
    val interrupt = out(Bool())
  }

  val ctrl = Apb3SlaveFactory(io.apb)
  val dr = Reg(UInt(32 bits)) init U(0xffffffffL, 32 bits)
  val idr = Reg(UInt(8 bits)) init 0

  private def update(initial: UInt, data: Bits): UInt = {
    var value = initial
    for (bit <- 31 to 0 by -1) {
      val feedback = value.msb ^ data(bit)
      value = ((value |<< 1).resized) ^ Mux(feedback, U(0x04c11db7L, 32 bits), U(0, 32 bits))
    }
    value
  }

  ctrl.read(dr, 0x00)
  ctrl.onWrite(0x00) { dr := update(dr, io.apb.PWDATA.asBits) }
  ctrl.readAndWrite(idr, 0x04)
  ctrl.onWrite(0x08) {
    when(io.apb.PWDATA(0)) { dr := U(0xffffffffL, 32 bits) }
  }
  ctrl.read(U(0, 32 bits), 0x08)
  io.interrupt := False
}
