package bus.amba.apb

import chisel3._
import chisel3.util._

/** Single APB transaction command (SETUP+ACCESS handled internally). */
class ApbCommand(p: ApbParams) extends Bundle {
  val write = Bool()
  val addr  = UInt(p.addrBits.W)
  val wdata = UInt(p.dataBits.W)
  val strb  = UInt(p.strobeBits.W)
}

class ApbResult(p: ApbParams) extends Bundle {
  val rdata = UInt(p.dataBits.W)
  val err   = Bool()
}

/**
  * Command-style APB master (one outstanding). Exposes `apb` as [[ApbMasterIO]].
  */
class ApbMasterHost(p: ApbParams) extends Module {
  val io = IO(new Bundle {
    val cmd = Flipped(Decoupled(new ApbCommand(p)))
    val rsp = Decoupled(new ApbResult(p))
    val apb = new ApbMasterIO(p)
  })

  val idle :: setup :: access :: outRsp :: Nil = Enum(4)
  val state = RegInit(idle)

  val latWrite = Reg(Bool())
  val latAddr  = Reg(UInt(p.addrBits.W))
  val latWdata = Reg(UInt(p.dataBits.W))
  val latStrb  = Reg(UInt(p.strobeBits.W))
  val latRdata = Reg(UInt(p.dataBits.W))
  val latErr   = Reg(Bool())

  io.apb.psel    := false.B
  io.apb.penable := false.B
  io.apb.pwrite  := false.B
  io.apb.paddr   := latAddr
  io.apb.pwdata  := latWdata
  io.apb.pstrb   := latStrb

  io.cmd.ready := false.B
  io.rsp.valid := false.B
  io.rsp.bits  := DontCare

  switch(state) {
    is(idle) {
      io.cmd.ready := true.B
      when(io.cmd.fire) {
        latWrite := io.cmd.bits.write
        latAddr  := io.cmd.bits.addr
        latWdata := io.cmd.bits.wdata
        latStrb  := io.cmd.bits.strb
        state    := setup
      }
    }
    is(setup) {
      io.apb.psel    := true.B
      io.apb.penable := false.B
      io.apb.pwrite  := latWrite
      state          := access
    }
    is(access) {
      io.apb.psel    := true.B
      io.apb.penable := true.B
      io.apb.pwrite  := latWrite
      when(io.apb.pready) {
        latRdata := io.apb.prdata
        latErr   := io.apb.pslverr
        state    := outRsp
      }
    }
    is(outRsp) {
      io.rsp.valid      := true.B
      io.rsp.bits.rdata := latRdata
      io.rsp.bits.err   := latErr
      when(io.rsp.fire) {
        state := idle
      }
    }
  }
}
