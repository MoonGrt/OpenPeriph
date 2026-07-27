package bus.amba.ahb

import chisel3._

/** Placeholder bridge between AHB domains. */
class AhbBridgeStub(p: AhbParams) extends Module {
  val io = IO(new Bundle {
    val pass = Output(Bool())
  })
  io.pass := true.B
}
