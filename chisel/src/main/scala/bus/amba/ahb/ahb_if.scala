package bus.amba.ahb

import chisel3._

case class AhbParams(addrBits: Int = 32, dataBits: Int = 32)

/** Initiator driving the AHB fabric. */
class AhbMasterIO(val p: AhbParams) extends Bundle {
  val htrans     = Output(UInt(2.W))
  val hwrite     = Output(Bool())
  val haddr      = Output(UInt(p.addrBits.W))
  val hsize      = Output(UInt(3.W))
  val hburst     = Output(UInt(3.W))
  val hprot      = Output(UInt(4.W))
  val hmastlock  = Output(Bool())
  val hwdata     = Output(UInt(p.dataBits.W))
  val hrdata     = Input(UInt(p.dataBits.W))
  val hready     = Input(Bool())
  val hreadyout  = Input(Bool())
  val hresp      = Input(Bool())
}

/** AHB slave-facing signals (initiator on the bus drives the Input side). */
class AhbSlaveIO(val p: AhbParams) extends Bundle {
  val htrans     = Input(UInt(2.W))
  val hwrite     = Input(Bool())
  val haddr      = Input(UInt(p.addrBits.W))
  val hsize      = Input(UInt(3.W))
  val hburst     = Input(UInt(3.W))
  val hprot      = Input(UInt(4.W))
  val hmastlock  = Input(Bool())
  val hwdata     = Input(UInt(p.dataBits.W))
  val hrdata     = Output(UInt(p.dataBits.W))
  val hready     = Input(Bool())
  val hreadyout  = Output(Bool())
  val hresp      = Output(Bool())
}
