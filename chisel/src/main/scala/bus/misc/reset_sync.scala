package bus.misc

import chisel3._
import chisel3.util._

class ResetSync extends Module {
  val io = IO(new Bundle {
    val rstIn  = Input(AsyncReset())
    val rstOut = Output(AsyncReset())
  })
  io.rstOut := io.rstIn
}
