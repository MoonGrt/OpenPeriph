package bus.amba.axi.bridge

import bus.amba.apb._
import bus.amba.axi.axilite._
import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/**
  * AXI4-Lite slave to APB master bridge (word-aligned, one outstanding transaction).
  */
class AxiLiteToApbBridge(p: ApbParams) extends Module {
  private val lp = AxiLiteParams(p.addrBits, p.dataBits)
  val io = IO(new Bundle {
    val axi = new AXI4LiteSlaveBundle(lp)
    val apb = new ApbMasterIO(p)
  })

  val idle :: wSetup :: wAcc :: rSetup :: rAcc :: Nil = Enum(5)
  val state = RegInit(idle)

  val latAddr = Reg(UInt(p.addrBits.W))
  val latWdat = Reg(UInt(p.dataBits.W))
  val latStrb = Reg(UInt(p.strobeBits.W))

  val latRdata = Reg(UInt(p.dataBits.W))
  val latResp  = Reg(UInt(2.W))

  val wDone = RegInit(false.B)
  val rDone = RegInit(false.B)

  io.apb.psel    := false.B
  io.apb.penable := false.B
  io.apb.pwrite  := false.B
  io.apb.paddr   := latAddr
  io.apb.pwdata  := latWdat
  io.apb.pstrb   := latStrb

  io.axi.aw.ready := false.B
  io.axi.w.ready  := false.B
  io.axi.ar.ready := false.B

  io.axi.b.valid := wDone
  io.axi.b.bits.resp := latResp
  io.axi.r.valid := rDone
  io.axi.r.bits.data := latRdata
  io.axi.r.bits.resp := latResp

  when(wDone && io.axi.b.ready) {
    wDone := false.B
  }
  when(rDone && io.axi.r.ready) {
    rDone := false.B
  }

  switch(state) {
    is(idle) {
      when(!wDone && !rDone) {
        when(io.axi.aw.valid && io.axi.w.valid) {
          io.axi.aw.ready := true.B
          io.axi.w.ready  := true.B
          latAddr := io.axi.aw.bits.addr
          latWdat := io.axi.w.bits.data
          latStrb := io.axi.w.bits.strb
          state   := wSetup
        }.elsewhen(io.axi.ar.valid) {
          io.axi.ar.ready := true.B
          latAddr := io.axi.ar.bits.addr
          state   := rSetup
        }
      }
    }
    is(wSetup) {
      io.apb.psel    := true.B
      io.apb.penable := false.B
      io.apb.pwrite  := true.B
      state          := wAcc
    }
    is(wAcc) {
      io.apb.psel    := true.B
      io.apb.penable := true.B
      io.apb.pwrite  := true.B
      when(io.apb.pready && !wDone) {
        latResp := Mux(io.apb.pslverr, AxiResp.SLVERR, AxiResp.OKAY)
        wDone   := true.B
        state   := idle
      }
    }
    is(rSetup) {
      io.apb.psel    := true.B
      io.apb.penable := false.B
      io.apb.pwrite  := false.B
      state          := rAcc
    }
    is(rAcc) {
      io.apb.psel    := true.B
      io.apb.penable := true.B
      io.apb.pwrite  := false.B
      when(io.apb.pready && !rDone) {
        latRdata := io.apb.prdata
        latResp  := Mux(io.apb.pslverr, AxiResp.SLVERR, AxiResp.OKAY)
        rDone    := true.B
        state    := idle
      }
    }
  }
}
