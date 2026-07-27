package bus.amba.axi.axifull

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Inert AXI4 slave port. */
class AxiSlaveShell(p: AxiParams) extends Module {
  val io = IO(new Bundle {
    val axi = new AXI4SlaveBundle(p)
  })
  io.axi.aw.ready := false.B
  io.axi.w.ready  := false.B
  io.axi.b.valid  := false.B
  io.axi.b.bits   := DontCare
  io.axi.ar.ready := false.B
  io.axi.r.valid  := false.B
  io.axi.r.bits   := DontCare
}
