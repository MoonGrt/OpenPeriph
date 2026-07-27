package bus.amba.axi.axistream

import chisel3._
import chisel3.util._

class AxisFifo(p: AxisParams, depth: Int) extends Module {
  require(depth > 0)
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(new AxisChannel(p)))
    val out = Decoupled(new AxisChannel(p))
  })
  val q = Module(new Queue(chiselTypeOf(io.in.bits), depth))
  q.io.enq <> io.in
  q.io.deq <> io.out
}
