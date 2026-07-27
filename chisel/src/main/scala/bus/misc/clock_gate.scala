package bus.misc

import chisel3._

class ClockGateStub extends Module {
  val io = IO(new Bundle {
    val clkIn  = Input(Clock())
    val en     = Input(Bool())
    val clkOut = Output(Clock())
  })
  io.clkOut := io.clkIn
}
