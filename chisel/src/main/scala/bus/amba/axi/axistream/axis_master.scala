package bus.amba.axi.axistream

import chisel3._

class AxisMasterShell(p: AxisParams) extends Module {
  val io = IO(new Bundle {
    val axis = new AxisMasterPort(p)
  })
  io.axis.t.valid := false.B
  io.axis.t.bits  := DontCare
}
