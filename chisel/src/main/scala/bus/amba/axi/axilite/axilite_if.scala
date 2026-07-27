package bus.amba.axi.axilite

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** RocketChip-style AXI4-Lite write address payload. */
class AXI4LiteBundleAW(val p: AxiLiteParams) extends Bundle {
  val addr = UInt(p.addrBits.W)
  val prot = UInt(3.W)
}

/** RocketChip-style AXI4-Lite write data payload. */
class AXI4LiteBundleW(val p: AxiLiteParams) extends Bundle {
  val data = UInt(p.dataBits.W)
  val strb = UInt(p.strobeBits.W)
}

/** RocketChip-style AXI4-Lite write response payload. */
class AXI4LiteBundleB extends Bundle {
  val resp = UInt(2.W)
}

/** RocketChip-style AXI4-Lite read address payload. */
class AXI4LiteBundleAR(val p: AxiLiteParams) extends Bundle {
  val addr = UInt(p.addrBits.W)
  val prot = UInt(3.W)
}

/** RocketChip-style AXI4-Lite read data payload. */
class AXI4LiteBundleR(val p: AxiLiteParams) extends Bundle {
  val data = UInt(p.dataBits.W)
  val resp = UInt(2.W)
}

/** RocketChip-style AXI4-Lite master bundle (manager-facing signals). */
class AXI4LiteBundle(val p: AxiLiteParams) extends Bundle {
  val aw = Decoupled(new AXI4LiteBundleAW(p))
  val w  = Decoupled(new AXI4LiteBundleW(p))
  val b  = Flipped(Decoupled(new AXI4LiteBundleB))
  val ar = Decoupled(new AXI4LiteBundleAR(p))
  val r  = Flipped(Decoupled(new AXI4LiteBundleR(p)))
}

/** RocketChip-style AXI4-Lite slave bundle (client-facing signals). */
class AXI4LiteSlaveBundle(val p: AxiLiteParams) extends Bundle {
  val aw = Flipped(Decoupled(new AXI4LiteBundleAW(p)))
  val w  = Flipped(Decoupled(new AXI4LiteBundleW(p)))
  val b  = Decoupled(new AXI4LiteBundleB)
  val ar = Flipped(Decoupled(new AXI4LiteBundleAR(p)))
  val r  = Decoupled(new AXI4LiteBundleR(p))
}

// Backward-compatible aliases for existing project code.
class AxiLiteWriteAddr(p: AxiLiteParams) extends AXI4LiteBundleAW(p)
class AxiLiteWriteData(p: AxiLiteParams) extends AXI4LiteBundleW(p)
class AxiLiteWriteResp extends AXI4LiteBundleB
class AxiLiteReadAddr(p: AxiLiteParams) extends AXI4LiteBundleAR(p)
class AxiLiteReadData(p: AxiLiteParams) extends AXI4LiteBundleR(p)
class AxiLiteMasterPort(p: AxiLiteParams) extends AXI4LiteBundle(p)
class AxiLiteSlavePort(p: AxiLiteParams) extends AXI4LiteSlaveBundle(p)
