package bus.amba.axi.axifull

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/**
  * AXI4 crossbar with multiple masters/slaves.
  *
  * - Per-slave write/read paths are independently arbitrated.
  * - Supports selectable arbitration policy per direction.
  * - One write and one read transaction in flight per slave.
  */
class AxiCrossbar(
  p: AxiParams,
  nMasters: Int,
  slaveAddress: Seq[AddressSet],
  writePolicy: AxiArbiterPolicy = AxiArbiterPolicy.RoundRobin,
  readPolicy: AxiArbiterPolicy = AxiArbiterPolicy.RoundRobin,
) extends Module {
  require(nMasters > 0)
  require(slaveAddress.nonEmpty)
  private val nSlaves = slaveAddress.length
  private val mW = log2Ceil(nMasters max 2)

  val io = IO(new Bundle {
    val fromMasters = Vec(nMasters, new AXI4SlaveBundle(p))
    val toSlaves    = Vec(nSlaves, new AXI4MasterBundle(p))
  })

  private def hit(addr: UInt, as: AddressSet): Bool =
    addr >= as.base.U(p.addrBits.W) && addr <= as.max.U(p.addrBits.W)

  def choose(
    req: Vec[Bool],
    last: UInt,
    policy: AxiArbiterPolicy
  ): (Bool, UInt) = {
    val valid = req.asUInt.orR
    val idx   = Wire(UInt(mW.W))
    idx := 0.U
    policy match {
      case AxiArbiterPolicy.FixedPriority =>
        idx := PriorityEncoder(req)
      case AxiArbiterPolicy.RoundRobin =>
        var found = false.B
        for (off <- 1 to nMasters) {
          val raw = last + off.U
          val cand = Mux(
            raw >= nMasters.U,
            raw - nMasters.U,
            raw
          )(mW - 1, 0)
          when(!found && req(cand)) {
            idx := cand
          }
          found = found || req(cand)
        }
    }
    (valid, idx)
  }

  val wStateIdle :: wStateData :: wStateResp :: Nil = Enum(3)
  val wState = Seq.fill(nSlaves)(RegInit(wStateIdle))
  val wSel   = Seq.fill(nSlaves)(Reg(UInt(mW.W)))
  val wLastGrant = Seq.fill(nSlaves)(RegInit(0.U(mW.W)))

  val rStateIdle :: rStateData :: Nil = Enum(2)
  val rState = Seq.fill(nSlaves)(RegInit(rStateIdle))
  val rSel   = Seq.fill(nSlaves)(Reg(UInt(mW.W)))
  val rLastGrant = Seq.fill(nSlaves)(RegInit(0.U(mW.W)))

  for (m <- 0 until nMasters) {
    io.fromMasters(m).aw.ready := false.B
    io.fromMasters(m).w.ready  := false.B
    io.fromMasters(m).ar.ready := false.B
    io.fromMasters(m).b.valid  := false.B
    io.fromMasters(m).b.bits   := 0.U.asTypeOf(io.fromMasters(m).b.bits)
    io.fromMasters(m).r.valid  := false.B
    io.fromMasters(m).r.bits   := 0.U.asTypeOf(io.fromMasters(m).r.bits)
  }

  for (s <- 0 until nSlaves) {
    io.toSlaves(s).aw.valid := false.B
    io.toSlaves(s).aw.bits  := 0.U.asTypeOf(io.toSlaves(s).aw.bits)
    io.toSlaves(s).w.valid  := false.B
    io.toSlaves(s).w.bits   := 0.U.asTypeOf(io.toSlaves(s).w.bits)
    io.toSlaves(s).b.ready  := false.B
    io.toSlaves(s).ar.valid := false.B
    io.toSlaves(s).ar.bits  := 0.U.asTypeOf(io.toSlaves(s).ar.bits)
    io.toSlaves(s).r.ready  := false.B

    val wReq = Wire(Vec(nMasters, Bool()))
    val rReq = Wire(Vec(nMasters, Bool()))
    for (m <- 0 until nMasters) {
      wReq(m) := (wState(s) === wStateIdle) && io.fromMasters(m).aw.valid && hit(io.fromMasters(m).aw.bits.addr, slaveAddress(s))
      rReq(m) := (rState(s) === rStateIdle) && io.fromMasters(m).ar.valid && hit(io.fromMasters(m).ar.bits.addr, slaveAddress(s))
    }
    val (wReqValid, wReqSel) = choose(wReq, wLastGrant(s), writePolicy)
    val (rReqValid, rReqSel) = choose(rReq, rLastGrant(s), readPolicy)

    switch(wState(s)) {
      is(wStateIdle) {
        when(wReqValid) {
          val mSel = wReqSel
          io.toSlaves(s).aw.valid := true.B
          io.toSlaves(s).aw.bits  := io.fromMasters(mSel).aw.bits
          io.fromMasters(mSel).aw.ready := io.toSlaves(s).aw.ready
          when(io.toSlaves(s).aw.fire) {
            wSel(s)   := mSel
            wLastGrant(s) := mSel
            wState(s) := wStateData
          }
        }
      }
      is(wStateData) {
        io.toSlaves(s).w.valid := io.fromMasters(wSel(s)).w.valid
        io.toSlaves(s).w.bits  := io.fromMasters(wSel(s)).w.bits
        io.fromMasters(wSel(s)).w.ready := io.toSlaves(s).w.ready
        when(io.toSlaves(s).w.fire && io.toSlaves(s).w.bits.last) {
          wState(s) := wStateResp
        }
      }
      is(wStateResp) {
        io.fromMasters(wSel(s)).b.valid := io.toSlaves(s).b.valid
        io.fromMasters(wSel(s)).b.bits  := io.toSlaves(s).b.bits
        io.toSlaves(s).b.ready := io.fromMasters(wSel(s)).b.ready
        when(io.toSlaves(s).b.fire) {
          wState(s) := wStateIdle
        }
      }
    }

    switch(rState(s)) {
      is(rStateIdle) {
        when(rReqValid) {
          val mSel = rReqSel
          io.toSlaves(s).ar.valid := true.B
          io.toSlaves(s).ar.bits  := io.fromMasters(mSel).ar.bits
          io.fromMasters(mSel).ar.ready := io.toSlaves(s).ar.ready
          when(io.toSlaves(s).ar.fire) {
            rSel(s)   := mSel
            rLastGrant(s) := mSel
            rState(s) := rStateData
          }
        }
      }
      is(rStateData) {
        io.fromMasters(rSel(s)).r.valid := io.toSlaves(s).r.valid
        io.fromMasters(rSel(s)).r.bits  := io.toSlaves(s).r.bits
        io.toSlaves(s).r.ready := io.fromMasters(rSel(s)).r.ready
        when(io.toSlaves(s).r.fire && io.toSlaves(s).r.bits.last) {
          rState(s) := rStateIdle
        }
      }
    }
  }
}
