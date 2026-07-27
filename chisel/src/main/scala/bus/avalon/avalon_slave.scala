package bus.avalon

import chisel3._

class AvalonSlaveStub(aw: Int, dw: Int) extends Module {
  val io = IO(new Bundle {
    val av = Flipped(new AvalonSignals(aw, dw))
  })
  io.av.rdata         := 0.U
  io.av.waitrequest   := false.B
  io.av.readdatavalid := false.B
}
