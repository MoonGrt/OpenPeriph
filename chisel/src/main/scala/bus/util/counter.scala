package bus.util

import chisel3._
import chisel3.util._

class UpCounter(w: Int) extends Module {
  val io = IO(new Bundle {
    val en   = Input(Bool())
    val clr  = Input(Bool())
    val out  = Output(UInt(w.W))
    val wrap = Output(Bool())
  })
  val r = RegInit(0.U(w.W))
  io.wrap := false.B
  when(io.clr) {
    r := 0.U
  }.elsewhen(io.en) {
    val n = r + 1.U
    when(n === 0.U) { io.wrap := true.B }
    r := n
  }
  io.out := r
}
