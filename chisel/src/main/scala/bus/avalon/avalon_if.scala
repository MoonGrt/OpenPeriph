package bus.avalon

import chisel3._

class AvalonSignals(aw: Int, dw: Int) extends Bundle {
  val read  = Bool()
  val write = Bool()
  val addr  = UInt(aw.W)
  val wdata = UInt(dw.W)
  val rdata = UInt(dw.W)
  val waitrequest = Bool()
  val readdatavalid = Bool()
}
