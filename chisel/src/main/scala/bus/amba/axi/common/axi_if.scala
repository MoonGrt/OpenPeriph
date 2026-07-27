package bus.amba.axi.common

import chisel3._
import chisel3.util._

/** RocketChip-style AXI4 address channel bundle (AW/AR payload). */
class AXI4BundleA(val p: AxiParams) extends Bundle {
  val id     = UInt(p.idBits.W)
  val addr   = UInt(p.addrBits.W)
  val len    = UInt(8.W)
  val size   = UInt(3.W)
  val burst  = UInt(2.W)
  val lock   = UInt(1.W)
  val cache  = UInt(4.W)
  val prot   = UInt(3.W)
  val qos    = UInt(4.W)
  val region = UInt(4.W)
  val user   = UInt(p.awUserBits.W)
}

/** RocketChip-style AXI4 write data channel bundle (W payload). */
class AXI4BundleW(val p: AxiParams) extends Bundle {
  val data = UInt(p.dataBits.W)
  val strb = UInt(p.strobeBits.W)
  val last = Bool()
  val user = UInt(p.wUserBits.W)
}

/** RocketChip-style AXI4 write response channel bundle (B payload). */
class AXI4BundleB(val p: AxiParams) extends Bundle {
  val id   = UInt(p.idBits.W)
  val resp = UInt(2.W)
  val user = UInt(p.bUserBits.W)
}

/** RocketChip-style AXI4 read data channel bundle (R payload). */
class AXI4BundleR(val p: AxiParams) extends Bundle {
  val id   = UInt(p.idBits.W)
  val data = UInt(p.dataBits.W)
  val resp = UInt(2.W)
  val last = Bool()
  val user = UInt(p.rUserBits.W)
}

/** RocketChip-style AXI4 master bundle (manager-facing signals). */
class AXI4MasterBundle(val p: AxiParams) extends Bundle {
  val aw = Decoupled(new AXI4BundleA(p))
  val w  = Decoupled(new AXI4BundleW(p))
  val b  = Flipped(Decoupled(new AXI4BundleB(p)))
  val ar = Decoupled(new AXI4BundleA(p))
  val r  = Flipped(Decoupled(new AXI4BundleR(p)))
}

/** RocketChip-style AXI4 slave bundle (client-facing signals). */
class AXI4SlaveBundle(val p: AxiParams) extends Bundle {
  val aw = Flipped(Decoupled(new AXI4BundleA(p)))
  val w  = Flipped(Decoupled(new AXI4BundleW(p)))
  val b  = Decoupled(new AXI4BundleB(p))
  val ar = Flipped(Decoupled(new AXI4BundleA(p)))
  val r  = Decoupled(new AXI4BundleR(p))
}

// Backward-compatible aliases for existing project code.
class AxiAddrChannel(p: AxiParams) extends AXI4BundleA(p)
class AxiDataWriteChannel(p: AxiParams) extends AXI4BundleW(p)
class AxiWriteRespChannel(p: AxiParams) extends AXI4BundleB(p)
class AxiDataReadChannel(p: AxiParams) extends AXI4BundleR(p)
class AxiMasterPort(p: AxiParams) extends AXI4MasterBundle(p)
class AxiSlavePort(p: AxiParams) extends AXI4SlaveBundle(p)
