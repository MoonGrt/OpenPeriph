package bus.tilelink

import chisel3._

class TlChannelA(w: Int) extends Bundle {
  val opcode = UInt(3.W)
  val address = UInt(w.W)
  val data = UInt(32.W)
}
