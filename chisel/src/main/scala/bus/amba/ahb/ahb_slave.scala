package bus.amba.ahb

import chisel3._
import chisel3.util._

/** Minimal word-aligned AHB slave (OKAY, zero wait states). */
class AhbRegSlave(p: AhbParams, nWords: Int) extends Module {
  val io = IO(new AhbSlaveIO(p))

  val H_IDLE   = 0.U(2.W)
  val H_NONSEQ = 2.U(2.W)

  private val byteShift = log2Ceil(p.dataBits / 8)
  val mem = RegInit(VecInit(Seq.fill(nWords)(0.U(p.dataBits.W))))

  private val iW = log2Ceil(nWords)
  val idx        = (io.haddr >> byteShift)(iW - 1, 0)
  val ok         = (io.haddr >> byteShift) < nWords.U

  io.hreadyout := true.B
  io.hresp     := false.B
  io.hrdata    := 0.U

  when(io.htrans === H_NONSEQ && io.hready) {
    when(ok) {
      when(io.hwrite) {
        mem(idx) := io.hwdata
      }.otherwise {
        io.hrdata := mem(idx)
      }
    }.otherwise {
      io.hresp := true.B
    }
  }
}
