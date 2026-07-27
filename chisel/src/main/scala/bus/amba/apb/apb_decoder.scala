package bus.amba.apb

import chisel3._
import chisel3.util._

/** One APB master fan-out to `n` slaves using non-overlapping address windows. */
class ApbDecoder(p: ApbParams, bases: Seq[BigInt], sizes: Seq[BigInt]) extends Module {
  require(bases.length == sizes.length && bases.nonEmpty)

  val io = IO(new Bundle {
    val upstream = new ApbSlaveIO(p)
    val slaves   = Vec(bases.length, new ApbMasterIO(p))
  })

  val idxOH = VecInit(bases.zip(sizes).map { case (base, size) =>
    val hi = base + size
    (io.upstream.paddr >= base.U) && (io.upstream.paddr < hi.U)
  })

  val hit = idxOH.asUInt.orR

  for (i <- bases.indices) {
    val s = io.slaves(i)
    s.psel    := io.upstream.psel && idxOH(i)
    s.penable := io.upstream.penable
    s.pwrite  := io.upstream.pwrite
    s.paddr   := io.upstream.paddr
    s.pwdata  := io.upstream.pwdata
    s.pstrb   := io.upstream.pstrb
  }

  val prdataMux = Mux1H(idxOH, io.slaves.map(_.prdata))
  val preadyMux = Mux1H(idxOH, io.slaves.map(_.pready))
  val pslvMux   = Mux1H(idxOH, io.slaves.map(_.pslverr))

  io.upstream.prdata  := Mux(hit, prdataMux, 0.U)
  io.upstream.pready  := Mux(hit, preadyMux, true.B)
  io.upstream.pslverr := Mux(hit, pslvMux, true.B)
}
