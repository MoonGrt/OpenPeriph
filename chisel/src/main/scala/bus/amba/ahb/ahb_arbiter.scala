package bus.amba.ahb

import chisel3._

/** Placeholder AHB master arbiter. */
class AhbArbiterStub(p: AhbParams) extends Module {
  val io = IO(new Bundle {
    val grant = Output(Bool())
  })
  io.grant := true.B
}
