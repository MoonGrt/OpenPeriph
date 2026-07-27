package bus.amba.axi.host

import bus.amba.axi.axilite._
import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/**
  * One AXI4-Lite command: write or read a single beat (word-aligned recommended).
  * `write` high: write; low: read. For reads, `wdata`/`strb` are don't-cares.
  */
class AxiLiteCommand(p: AxiLiteParams) extends Bundle {
  val write = Bool()
  val addr  = UInt(p.addrBits.W)
  val wdata = UInt(p.dataBits.W)
  val strb  = UInt(p.strobeBits.W)
  val prot  = UInt(3.W)
}

/**
  * Completion of a command: AXI `BRESP`/`RRESP` in `resp`; `rdata` meaningful for reads.
  */
class AxiLiteResult(p: AxiLiteParams) extends Bundle {
  val rdata = UInt(p.dataBits.W)
  val resp  = UInt(2.W)
}

/**
  * High-level AXI4-Lite master: Decoupled command in, Decoupled result out, raw `axi` master port.
  * Queue a command on `cmd`; collect `rsp` when `rsp.valid`. One outstanding transaction.
  */
class AxiLiteMasterHost(p: AxiLiteParams) extends Module {
  val io = IO(new Bundle {
    val cmd = Flipped(Decoupled(new AxiLiteCommand(p)))
    val rsp = Decoupled(new AxiLiteResult(p))
    val axi = new AXI4LiteBundle(p)
  })

  val idle :: wAddr :: wWaitB :: wRsp :: rAddr :: rWaitR :: rRsp :: Nil = Enum(7)
  val state = RegInit(idle)

  val latAddr  = Reg(UInt(p.addrBits.W))
  val latWdata = Reg(UInt(p.dataBits.W))
  val latStrb  = Reg(UInt(p.strobeBits.W))
  val latProt  = Reg(UInt(3.W))
  val latResp  = Reg(UInt(2.W))
  val latRdata = Reg(UInt(p.dataBits.W))
  val awSent   = RegInit(false.B)
  val wSent    = RegInit(false.B)

  io.axi.aw.valid := false.B
  io.axi.aw.bits  := DontCare
  io.axi.w.valid  := false.B
  io.axi.w.bits   := DontCare
  io.axi.b.ready  := false.B
  io.axi.ar.valid := false.B
  io.axi.ar.bits  := DontCare
  io.axi.r.ready  := false.B

  io.cmd.ready := false.B
  io.rsp.valid := false.B
  io.rsp.bits  := DontCare

  switch(state) {
    is(idle) {
      io.cmd.ready := true.B
      when(io.cmd.fire) {
        latAddr  := io.cmd.bits.addr
        latWdata := io.cmd.bits.wdata
        latStrb  := io.cmd.bits.strb
        latProt  := io.cmd.bits.prot
        when(io.cmd.bits.write) {
          awSent := false.B
          wSent  := false.B
          state := wAddr
        }.otherwise {
          state := rAddr
        }
      }
    }
    is(wAddr) {
      io.axi.aw.valid       := !awSent
      io.axi.aw.bits.addr   := latAddr
      io.axi.aw.bits.prot   := latProt
      io.axi.w.valid        := !wSent
      io.axi.w.bits.data    := latWdata
      io.axi.w.bits.strb    := latStrb
      when(io.axi.aw.fire) { awSent := true.B }
      when(io.axi.w.fire)  { wSent  := true.B }

      // AXI channels are independent (RocketChip style): allow AW/W to complete in different cycles.
      when((awSent || io.axi.aw.fire) && (wSent || io.axi.w.fire)) {
        awSent := false.B
        wSent  := false.B
        state := wWaitB
      }
    }
    is(wWaitB) {
      io.axi.b.ready := true.B
      when(io.axi.b.fire) {
        latResp := io.axi.b.bits.resp
        state   := wRsp
      }
    }
    is(wRsp) {
      io.rsp.valid      := true.B
      io.rsp.bits.rdata := 0.U
      io.rsp.bits.resp  := latResp
      when(io.rsp.fire) {
        state := idle
      }
    }
    is(rAddr) {
      io.axi.ar.valid     := true.B
      io.axi.ar.bits.addr := latAddr
      io.axi.ar.bits.prot := latProt
      when(io.axi.ar.fire) {
        state := rWaitR
      }
    }
    is(rWaitR) {
      io.axi.r.ready := true.B
      when(io.axi.r.fire) {
        latRdata := io.axi.r.bits.data
        latResp  := io.axi.r.bits.resp
        state    := rRsp
      }
    }
    is(rRsp) {
      io.rsp.valid      := true.B
      io.rsp.bits.rdata := latRdata
      io.rsp.bits.resp  := latResp
      when(io.rsp.fire) {
        state := idle
      }
    }
  }
}

object AxiLiteHost {
  def tieOffMasterIdle(m: AXI4LiteBundle): Unit = {
    m.aw.valid := false.B
    m.aw.bits  := DontCare
    m.w.valid  := false.B
    m.w.bits   := DontCare
    m.b.ready  := true.B
    m.ar.valid := false.B
    m.ar.bits  := DontCare
    m.r.ready  := true.B
  }

  def tieOffSlaveIdle(s: AXI4LiteSlaveBundle): Unit = {
    s.aw.ready := false.B
    s.w.ready  := false.B
    s.b.valid  := false.B
    s.b.bits.resp := AxiResp.OKAY
    s.ar.ready := false.B
    s.r.valid  := false.B
    s.r.bits.data := 0.U
    s.r.bits.resp := AxiResp.OKAY
  }
}
