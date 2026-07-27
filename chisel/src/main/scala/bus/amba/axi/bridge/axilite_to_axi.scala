package bus.amba.axi.bridge

import bus.amba.axi.axilite._
import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Maps an AXI4-Lite slave port to a full AXI4 master port (single-beat bursts). */
class AxiLiteToAxi4(pLite: AxiLiteParams, pFull: AxiParams) extends Module {
  require(pLite.addrBits == pFull.addrBits && pLite.dataBits == pFull.dataBits)
  val io = IO(new Bundle {
    val lite = new AXI4LiteSlaveBundle(pLite)
    val full = new AXI4MasterBundle(pFull)
  })

  val id = 0.U(pFull.idBits.W)

  io.full.aw.valid       := io.lite.aw.valid
  io.lite.aw.ready       := io.full.aw.ready
  io.full.aw.bits.id     := id
  io.full.aw.bits.addr   := io.lite.aw.bits.addr
  io.full.aw.bits.len    := 0.U
  io.full.aw.bits.size   := log2Ceil(pFull.dataBits / 8).U
  io.full.aw.bits.burst  := AxiBurst.INCR
  io.full.aw.bits.lock   := AxiLock.NORMAL
  io.full.aw.bits.cache  := 0.U
  io.full.aw.bits.prot   := io.lite.aw.bits.prot
  io.full.aw.bits.qos    := 0.U
  io.full.aw.bits.region := 0.U
  io.full.aw.bits.user   := 0.U

  io.full.w.valid     := io.lite.w.valid
  io.lite.w.ready     := io.full.w.ready
  io.full.w.bits.data := io.lite.w.bits.data
  io.full.w.bits.strb := io.lite.w.bits.strb
  io.full.w.bits.last := true.B
  io.full.w.bits.user := 0.U

  io.lite.b.valid     := io.full.b.valid
  io.full.b.ready     := io.lite.b.ready
  io.lite.b.bits.resp := io.full.b.bits.resp

  io.full.ar.valid       := io.lite.ar.valid
  io.lite.ar.ready       := io.full.ar.ready
  io.full.ar.bits.id     := id
  io.full.ar.bits.addr   := io.lite.ar.bits.addr
  io.full.ar.bits.len    := 0.U
  io.full.ar.bits.size   := log2Ceil(pFull.dataBits / 8).U
  io.full.ar.bits.burst  := AxiBurst.INCR
  io.full.ar.bits.lock   := AxiLock.NORMAL
  io.full.ar.bits.cache  := 0.U
  io.full.ar.bits.prot   := io.lite.ar.bits.prot
  io.full.ar.bits.qos    := 0.U
  io.full.ar.bits.region := 0.U
  io.full.ar.bits.user   := 0.U

  io.lite.r.valid     := io.full.r.valid
  io.full.r.ready     := io.lite.r.ready
  io.lite.r.bits.data := io.full.r.bits.data
  io.lite.r.bits.resp := io.full.r.bits.resp
}
