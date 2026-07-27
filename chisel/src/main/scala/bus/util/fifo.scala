package bus.util

import chisel3._
import chisel3.util._

class SyncFifo[T <: Data](gen: T, depth: Int) extends Module {
  require(depth > 0)
  val io = IO(new Bundle {
    val enq = Flipped(Decoupled(gen))
    val deq = Decoupled(gen)
  })
  val q = Module(new Queue(gen, depth))
  q.io.enq <> io.enq
  q.io.deq <> io.deq
}
