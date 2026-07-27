package bus.amba.axi.axistream

import chisel3._

class AxisSlaveShell(p: AxisParams) extends Module {
  val io = IO(new Bundle {
    val axis = new AxisSlavePort(p)
  })
  io.axis.t.ready := true.B
}
