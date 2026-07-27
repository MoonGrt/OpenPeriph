package bus.amba.ahb

import chisel3._

class AhbMasterShell(p: AhbParams) extends Module {
  val io = IO(new AhbMasterIO(p))
  io.htrans    := 0.U
  io.hwrite    := false.B
  io.haddr     := 0.U
  io.hsize     := 2.U
  io.hburst    := 0.U
  io.hprot     := 0.U
  io.hmastlock := false.B
  io.hwdata    := 0.U
}
