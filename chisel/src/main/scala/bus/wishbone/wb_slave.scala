package bus.wishbone

import chisel3._

class WbSlaveStub(aw: Int, dw: Int) extends Module {
  val io = IO(new Bundle {
    val wb = Flipped(new WbSignals(aw, dw))
  })
  io.wb.datR := 0.U
  io.wb.ack  := false.B
}
