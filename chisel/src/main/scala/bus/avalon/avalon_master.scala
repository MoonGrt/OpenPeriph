package bus.avalon

import chisel3._

class AvalonMasterStub(aw: Int, dw: Int) extends Module {
  val io = IO(new Bundle {
    val av = new AvalonSignals(aw, dw)
  })
  io.av.read  := false.B
  io.av.write := false.B
  io.av.addr  := 0.U
  io.av.wdata := 0.U
}
