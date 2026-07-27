package bus.amba.axi.adapter

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Placeholder width adapter (requires data-width equality for now). */
class AxiWidthAdapter(p: AxiParams) extends Module {
  val io = IO(new Bundle {
    val in  = Flipped(new AXI4SlaveBundle(p))
    val out = new AXI4SlaveBundle(p)
  })
  io.out <> io.in
}
