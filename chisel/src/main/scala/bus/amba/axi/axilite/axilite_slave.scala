package bus.amba.axi.axilite

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Word-aligned AXI4-Lite slave with a register file. */
class AxiLiteRegSlave(p: AxiLiteParams, nWords: Int) extends Module {
  val io = IO(new Bundle {
    val axi = new AXI4LiteSlaveBundle(p)
  })

  private val byteShift = log2Ceil(p.dataBits / 8)
  require(nWords > 0 && nWords <= (1 << math.max(0, p.addrBits - byteShift)))

  val mem = RegInit(VecInit(Seq.fill(nWords)(0.U(p.dataBits.W))))

  def mergeBytes(old: UInt, wdata: UInt, strb: UInt): UInt = {
    val lanes = (0 until p.strobeBits).map { i =>
      val lo = 8 * i
      Mux(strb(i), wdata(8 * (i + 1) - 1, lo), old(8 * (i + 1) - 1, lo))
    }
    Cat(lanes.reverse)
  }

  private val iW = log2Ceil(nWords)
  val wIdx = (io.axi.aw.bits.addr >> byteShift)(iW - 1, 0)
  val rIdx = (io.axi.ar.bits.addr >> byteShift)(iW - 1, 0)
  val wOk  = wIdx < nWords.U
  val rOk  = rIdx < nWords.U

  val bValid = RegInit(false.B)
  val bResp  = Reg(UInt(2.W))

  io.axi.aw.ready := !bValid && io.axi.aw.valid && io.axi.w.valid
  io.axi.w.ready  := !bValid && io.axi.aw.valid && io.axi.w.valid

  when(io.axi.aw.fire && io.axi.w.fire) {
    when(wOk) {
      val cur = mem(wIdx)
      mem(wIdx) := mergeBytes(cur, io.axi.w.bits.data, io.axi.w.bits.strb)
      bResp := AxiResp.OKAY
    }.otherwise {
      bResp := AxiResp.DECERR
    }
    bValid := true.B
  }

  io.axi.b.valid := bValid
  io.axi.b.bits.resp := bResp
  when(bValid && io.axi.b.ready) {
    bValid := false.B
  }

  val rPipeValid = RegInit(false.B)
  val rPipeIdx   = Reg(UInt(log2Ceil(nWords).W))
  val rPipeOk    = Reg(Bool())

  io.axi.ar.ready := io.axi.r.ready || !rPipeValid
  when(io.axi.ar.fire) {
    rPipeIdx := rIdx
    rPipeOk  := rOk
    rPipeValid := true.B
  }.elsewhen(io.axi.r.fire) {
    rPipeValid := false.B
  }

  io.axi.r.valid     := rPipeValid
  io.axi.r.bits.data := mem(rPipeIdx)
  io.axi.r.bits.resp := Mux(rPipeOk, AxiResp.OKAY, AxiResp.DECERR)
}
