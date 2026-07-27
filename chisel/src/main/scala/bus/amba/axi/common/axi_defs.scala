package bus.amba.axi.common

import chisel3._

object AxiResp {
  val OKAY:   UInt = 0.U(2.W)
  val EXOKAY: UInt = 1.U(2.W)
  val SLVERR: UInt = 2.U(2.W)
  val DECERR: UInt = 3.U(2.W)
}

object AxiBurst {
  val FIXED: UInt = 0.U(2.W)
  val INCR:  UInt = 1.U(2.W)
  val WRAP:  UInt = 2.U(2.W)
}

object AxiLock {
  val NORMAL: UInt = 0.U(1.W)
}
