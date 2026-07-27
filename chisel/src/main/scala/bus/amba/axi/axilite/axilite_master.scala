package bus.amba.axi.axilite

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Minimal AXI4-Lite master port holder; tie-offs for integration tests. */
class AxiLiteMasterShell(p: AxiLiteParams) extends Module {
  val io = IO(new Bundle {
    val axi = new AXI4LiteBundle(p)
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
