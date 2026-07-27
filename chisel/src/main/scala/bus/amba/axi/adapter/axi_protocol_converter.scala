package bus.amba.axi.adapter

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** No-op AXI4 protocol shim (placeholder for downsizing / Lite bridges). */
class AxiProtocolConverter(p: AxiParams) extends Module {
  val io = IO(new Bundle {
    val in  = Flipped(new AXI4SlaveBundle(p))
    val out = new AXI4SlaveBundle(p)
  })
  io.out <> io.in
}
