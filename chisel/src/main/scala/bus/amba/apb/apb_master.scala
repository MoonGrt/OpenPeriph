package bus.amba.apb

import chisel3._

/** Placeholder APB initiator; drive outputs from a core or testbench. */
class ApbMasterShell(p: ApbParams) extends Module {
  val io = IO(new ApbMasterIO(p))
  io.psel    := false.B
  io.penable := false.B
  io.pwrite  := false.B
  io.paddr   := 0.U
  io.pwdata  := 0.U
  io.pstrb   := 0.U
}
