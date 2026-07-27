package bus.amba.axi.axifull

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Inert AXI4 master port (drive externally or extend). */
class AxiMasterShell(p: AxiParams) extends Module {
  val io = IO(new Bundle {
    val axi = new AXI4MasterBundle(p)
  })
  io.axi.aw.valid := false.B
  io.axi.aw.bits  := DontCare
  io.axi.w.valid  := false.B
  io.axi.w.bits   := DontCare
  io.axi.b.ready  := true.B
  io.axi.ar.valid := false.B
  io.axi.ar.bits  := DontCare
  io.axi.r.ready  := true.B
}
