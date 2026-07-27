package bus.util

import chisel3._
import chisel3.util._

class PipeReg[T <: Data](gen: T) extends Module {
  val io = IO(new Bundle {
    val in  = Flipped(Decoupled(gen))
    val out = Decoupled(gen)
  })
  val rValid = RegInit(false.B)
  val rBits  = Reg(gen)
  io.in.ready := io.out.ready || !rValid
  when(io.in.fire) {
    rValid := true.B
    rBits  := io.in.bits
  }.elsewhen(io.out.fire) {
    rValid := false.B
  }
  io.out.valid := rValid
  io.out.bits  := rBits
}
