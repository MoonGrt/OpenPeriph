package bus.amba.apb

import chisel3._

/** Example top: decoder plus two register slaves. */
class ApbExampleSubsystem(p: ApbParams) extends Module {
  val io = IO(new ApbSlaveIO(p))

  val dec = Module(new ApbDecoder(p, Seq(BigInt(0), BigInt(0x1000)), Seq(BigInt(0x1000), BigInt(0x1000))))
  val s0  = Module(new ApbRegSlave(p, 256))
  val s1  = Module(new ApbRegSlave(p, 256))

  dec.io.upstream.psel    := io.psel
  dec.io.upstream.penable := io.penable
  dec.io.upstream.pwrite  := io.pwrite
  dec.io.upstream.paddr   := io.paddr
  dec.io.upstream.pwdata  := io.pwdata
  dec.io.upstream.pstrb   := io.pstrb
  io.prdata               := dec.io.upstream.prdata
  io.pready               := dec.io.upstream.pready
  io.pslverr              := dec.io.upstream.pslverr

  def connectMasterToSlave(m: ApbMasterIO, s: ApbSlaveIO): Unit = {
    s.psel    := m.psel
    s.penable := m.penable
    s.pwrite  := m.pwrite
    s.paddr   := m.paddr
    s.pwdata  := m.pwdata
    s.pstrb   := m.pstrb
    m.prdata  := s.prdata
    m.pready  := s.pready
    m.pslverr := s.pslverr
  }

  connectMasterToSlave(dec.io.slaves(0), s0.io)
  connectMasterToSlave(dec.io.slaves(1), s1.io)
}
