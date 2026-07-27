package bus.tilelink

import chisel3._

class TlSlaveStub(w: Int) extends Module {
  val io = IO(new Bundle {
    val a = Input(new TlChannelA(w))
  })
}
