package bus.amba.axi.axistream

import chisel3._
import chisel3.util._

case class AxisParams(dataBits: Int = 32, idBits: Int = 0, destBits: Int = 0, userBits: Int = 0) {
  require(dataBits % 8 == 0)
}

class AxisChannel(val p: AxisParams) extends Bundle {
  val data = UInt(p.dataBits.W)
  val last = Bool()
  val id   = UInt(p.idBits.W)
  val dest = UInt(p.destBits.W)
  val user = UInt(p.userBits.W)
}

class AxisMasterPort(val p: AxisParams) extends Bundle {
  val t = Decoupled(new AxisChannel(p))
}

class AxisSlavePort(val p: AxisParams) extends Bundle {
  val t = Flipped(Decoupled(new AxisChannel(p)))
}
