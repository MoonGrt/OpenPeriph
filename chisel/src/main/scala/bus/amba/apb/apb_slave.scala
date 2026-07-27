package bus.amba.apb

import chisel3._
import chisel3.util._

/** Simple word-aligned APB slave backed by registers. */
class ApbRegSlave(p: ApbParams, nWords: Int) extends Module {
  val io = IO(new ApbSlaveIO(p))

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

  private val iW  = log2Ceil(nWords)
  val idx       = (io.paddr >> byteShift)(iW - 1, 0)
  val inRange   = (io.paddr >> byteShift) < nWords.U

  io.prdata  := 0.U
  io.pready  := true.B
  io.pslverr := false.B

  when(io.psel && io.penable) {
    when(!inRange) {
      io.pslverr := true.B
    }.elsewhen(io.pwrite) {
      val cur = mem(idx)
      mem(idx) := mergeBytes(cur, io.pwdata, io.pstrb)
    }.otherwise {
      io.prdata := mem(idx)
    }
  }
}
