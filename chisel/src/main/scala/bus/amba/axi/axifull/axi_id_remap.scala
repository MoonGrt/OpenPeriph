package bus.amba.axi.axifull

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Truncate AXI IDs on the AW/AR channels (responses pass through unchanged). */
class AxiIdRemap(pIn: AxiParams, pOut: AxiParams) extends Module {
  require(pIn.addrBits == pOut.addrBits && pIn.dataBits == pOut.dataBits)
  require(pOut.idBits <= pIn.idBits)
  val io = IO(new Bundle {
    val in  = Flipped(new AXI4MasterBundle(pIn))
    val out = new AXI4MasterBundle(pOut)
  })

  io.out.aw.valid := io.in.aw.valid
  io.in.aw.ready  := io.out.aw.ready
  io.out.aw.bits  := io.in.aw.bits
  io.out.aw.bits.id := io.in.aw.bits.id(pOut.idBits - 1, 0)

  io.out.w <> io.in.w

  io.out.ar.valid := io.in.ar.valid
  io.in.ar.ready  := io.out.ar.ready
  io.out.ar.bits  := io.in.ar.bits
  io.out.ar.bits.id := io.in.ar.bits.id(pOut.idBits - 1, 0)

  io.in.b <> io.out.b
  io.in.r <> io.out.r
}
