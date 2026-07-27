package bus.amba.apb

import chisel3._

case class ApbParams(addrBits: Int = 32, dataBits: Int = 32) {
  require(dataBits % 8 == 0)
  def strobeBits: Int = dataBits / 8
}

/** APB signals as seen by a slave (CPU / bridge is master). */
class ApbSlaveIO(val p: ApbParams) extends Bundle {
  val psel    = Input(Bool())
  val penable = Input(Bool())
  val pwrite  = Input(Bool())
  val paddr   = Input(UInt(p.addrBits.W))
  val pwdata  = Input(UInt(p.dataBits.W))
  val pstrb   = Input(UInt(p.strobeBits.W))
  val prdata  = Output(UInt(p.dataBits.W))
  val pready  = Output(Bool())
  val pslverr = Output(Bool())
}

/** APB signals driven by an initiator toward slaves. */
class ApbMasterIO(val p: ApbParams) extends Bundle {
  val psel    = Output(Bool())
  val penable = Output(Bool())
  val pwrite  = Output(Bool())
  val paddr   = Output(UInt(p.addrBits.W))
  val pwdata  = Output(UInt(p.dataBits.W))
  val pstrb   = Output(UInt(p.strobeBits.W))
  val prdata  = Input(UInt(p.dataBits.W))
  val pready  = Input(Bool())
  val pslverr = Input(Bool())
}

/** Legacy undirected bundle for internal wiring (decoder fan-out). */
class ApbSignals(val p: ApbParams) extends Bundle {
  val psel    = Bool()
  val penable = Bool()
  val pwrite  = Bool()
  val paddr   = UInt(p.addrBits.W)
  val pwdata  = UInt(p.dataBits.W)
  val pstrb   = UInt(p.strobeBits.W)
  val prdata  = UInt(p.dataBits.W)
  val pready  = Bool()
  val pslverr = Bool()
}
