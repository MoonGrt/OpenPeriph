package bus.amba.axi.host

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/** Single-beat full AXI4 command (INCR, len=0, fixed id 0). */
class Axi4Command(p: AxiParams) extends Bundle {
  val write = Bool()
  val addr  = UInt(p.addrBits.W)
  val wdata = UInt(p.dataBits.W)
  val strb  = UInt(p.strobeBits.W)
  val prot  = UInt(3.W)
}

class Axi4Result(p: AxiParams) extends Bundle {
  val rdata = UInt(p.dataBits.W)
  val resp  = UInt(2.W)
}

/**
  * High-level AXI4 master for single-beat transfers (one outstanding).
  * Suitable as a bus toolkit front-end when bursts are not required.
  */
class Axi4SingleBeatMasterHost(p: AxiParams) extends Module {
  val io = IO(new Bundle {
    val cmd = Flipped(Decoupled(new Axi4Command(p)))
    val rsp = Decoupled(new Axi4Result(p))
    val axi = new AXI4MasterBundle(p)
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

  val beatSize = log2Ceil(p.dataBits / 8).U

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

  def addrChan(addr: UInt, prot: UInt): AXI4BundleA = {
    val ch = Wire(new AXI4BundleA(p))
    ch.id     := 0.U
    ch.addr   := addr
    ch.len    := 0.U
    ch.size   := beatSize
    ch.burst  := AxiBurst.INCR
    ch.lock   := AxiLock.NORMAL
    ch.cache  := 0.U
    ch.prot   := prot
    ch.qos    := 0.U
    ch.region := 0.U
    ch.user   := 0.U
    ch
  }

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
      io.axi.aw.valid     := !awSent
      io.axi.aw.bits      := addrChan(latAddr, latProt)
      io.axi.w.valid      := !wSent
      io.axi.w.bits.data  := latWdata
      io.axi.w.bits.strb  := latStrb
      io.axi.w.bits.last  := true.B
      io.axi.w.bits.user  := 0.U
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
      io.axi.ar.valid := true.B
      io.axi.ar.bits  := addrChan(latAddr, latProt)
      when(io.axi.ar.fire) {
        state := rWaitR
      }
    }
    is(rWaitR) {
      io.axi.r.ready := true.B
      when(io.axi.r.fire) {
        assert(io.axi.r.bits.last, "Axi4SingleBeatMasterHost expects single-beat responses with RLAST")
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

object Axi4Host {
  def tieOffMasterIdle(m: AXI4MasterBundle): Unit = {
    m.aw.valid := false.B
    m.aw.bits  := DontCare
    m.w.valid  := false.B
    m.w.bits   := DontCare
    m.b.ready  := true.B
    m.ar.valid := false.B
    m.ar.bits  := DontCare
    m.r.ready  := true.B
  }
}
