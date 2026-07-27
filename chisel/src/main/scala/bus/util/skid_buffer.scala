package bus.util

import chisel3._
import chisel3.util._

/** Simple two-deep queue behaving as a skid buffer. */
class SkidBuffer[T <: Data](gen: T) extends Module {
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(gen))
    val out = Decoupled(gen)
  })
  val q = Module(new Queue(gen, entries = 2))
  q.io.enq <> io.in
  q.io.deq <> io.out
}
