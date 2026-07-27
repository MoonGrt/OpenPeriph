package bus.amba.ahb

import chisel3._

/** Placeholder address decode block for multi-slave AHB systems. */
class AhbDecoderStub(p: AhbParams) extends Module {
  val io = IO(new Bundle {
    val sel = Output(Bool())
  })
  io.sel := true.B
}
