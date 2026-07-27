package bus.wishbone

import chisel3._

class WbMasterStub(aw: Int, dw: Int) extends Module {
  val io = IO(new Bundle {
    val wb = new WbSignals(aw, dw)
  })
  io.wb.cyc  := false.B
  io.wb.stb  := false.B
  io.wb.we   := false.B
  io.wb.adr  := 0.U
  io.wb.datW := 0.U
  io.wb.sel  := 0.U
}
