package bus.tilelink

import chisel3._

class TlMasterStub(w: Int) extends Module {
  val io = IO(new Bundle {
    val a = Output(new TlChannelA(w))
  })
  io.a := DontCare
}
