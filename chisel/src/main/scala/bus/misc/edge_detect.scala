package bus.misc

import chisel3._
import chisel3.util._

class EdgeDetect extends Module {
  val io = IO(new Bundle {
    val in  = Input(Bool())
    val rise = Output(Bool())
  })
  val prev = RegNext(io.in)
  io.rise := io.in && !prev
}
