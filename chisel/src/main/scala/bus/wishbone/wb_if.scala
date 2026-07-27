package bus.wishbone

import chisel3._

class WbSignals(aw: Int, dw: Int) extends Bundle {
  val cyc = Bool()
  val stb = Bool()
  val we  = Bool()
  val adr = UInt(aw.W)
  val datW = UInt(dw.W)
  val datR = UInt(dw.W)
  val ack  = Bool()
  val sel  = UInt((dw / 8).W)
}
