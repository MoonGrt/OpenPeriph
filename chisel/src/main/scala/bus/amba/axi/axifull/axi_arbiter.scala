package bus.amba.axi.axifull

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

sealed trait AxiArbiterPolicy
object AxiArbiterPolicy {
  case object FixedPriority extends AxiArbiterPolicy
  case object RoundRobin extends AxiArbiterPolicy
}

/** 2-to-1 AXI4 arbiter wrapper (kept for backward compatibility). */
class AxiArbiter2(p: AxiParams, policy: AxiArbiterPolicy = AxiArbiterPolicy.RoundRobin) extends Module {
  private val impl = Module(new AxiArbiterN(p, 2, policy))
  val io = IO(new Bundle {
    val in  = Vec(2, Flipped(new AXI4MasterBundle(p)))
    val out = new AXI4MasterBundle(p)
  })
  impl.io.in <> io.in
  io.out <> impl.io.out
}

/**
  * N-to-1 AXI4 arbiter.
  *
  * Note: this is a channel-safe practical arbiter for this project that keeps at most one
  * write and one read transaction in flight, and routes B/R back to the granted source.
  */
class AxiArbiterN(p: AxiParams, nInputs: Int, policy: AxiArbiterPolicy = AxiArbiterPolicy.RoundRobin) extends Module {
  require(nInputs > 0)
  private val idxW = log2Ceil(nInputs max 2)

  val io = IO(new Bundle {
    val in  = Vec(nInputs, Flipped(new AXI4MasterBundle(p)))
    val out = new AXI4MasterBundle(p)
  })

  val wBusy = RegInit(false.B)
  val rBusy = RegInit(false.B)
  val wSel  = Reg(UInt(idxW.W))
  val rSel  = Reg(UInt(idxW.W))

  val awLastGrant = RegInit(0.U(idxW.W))
  val arLastGrant = RegInit(0.U(idxW.W))

  def choose(req: Vec[Bool], last: UInt): (Bool, UInt) = {
    val valid = req.asUInt.orR
    val idx = Wire(UInt(idxW.W))
    idx := 0.U
    policy match {
      case AxiArbiterPolicy.FixedPriority =>
        idx := PriorityEncoder(req)
      case AxiArbiterPolicy.RoundRobin =>
        val found = Wire(Bool())
        found := false.B
        for (off <- 1 to nInputs) {
          val raw = last + off.U
          val cand = Mux(raw >= nInputs.U, raw - nInputs.U, raw)(idxW - 1, 0)
          when(!found && req(cand)) {
            idx := cand
            found := true.B
          }
        }
    }
    (valid, idx)
  }

  val awReq = Wire(Vec(nInputs, Bool()))
  val arReq = Wire(Vec(nInputs, Bool()))
  for (i <- 0 until nInputs) {
    awReq(i) := !wBusy && io.in(i).aw.valid
    arReq(i) := !rBusy && io.in(i).ar.valid
  }

  val (awValid, awSelNow) = choose(awReq, awLastGrant)
  val (arValid, arSelNow) = choose(arReq, arLastGrant)

  io.out.aw.valid := !wBusy && awValid
  io.out.aw.bits  := Mux1H((0 until nInputs).map(i => (awSelNow === i.U) -> io.in(i).aw.bits))

  io.out.w.valid := wBusy && io.in(wSel).w.valid
  io.out.w.bits  := io.in(wSel).w.bits

  io.out.ar.valid := !rBusy && arValid
  io.out.ar.bits  := Mux1H((0 until nInputs).map(i => (arSelNow === i.U) -> io.in(i).ar.bits))

  io.out.b.ready := false.B
  io.out.r.ready := false.B

  for (i <- 0 until nInputs) {
    io.in(i).aw.ready := !wBusy && awValid && (awSelNow === i.U) && io.out.aw.ready
    io.in(i).w.ready  := wBusy && (wSel === i.U) && io.out.w.ready
    io.in(i).ar.ready := !rBusy && arValid && (arSelNow === i.U) && io.out.ar.ready

    io.in(i).b.valid := wBusy && (wSel === i.U) && io.out.b.valid
    io.in(i).b.bits  := io.out.b.bits
    io.in(i).r.valid := rBusy && (rSel === i.U) && io.out.r.valid
    io.in(i).r.bits  := io.out.r.bits
  }

  when(!wBusy && io.out.aw.fire) {
    wBusy := true.B
    wSel  := awSelNow
    awLastGrant := awSelNow
  }
  when(wBusy) {
    io.out.b.ready := io.in(wSel).b.ready
    when(io.out.b.fire) { wBusy := false.B }
  }

  when(!rBusy && io.out.ar.fire) {
    rBusy := true.B
    rSel  := arSelNow
    arLastGrant := arSelNow
  }
  when(rBusy) {
    io.out.r.ready := io.in(rSel).r.ready
    when(io.out.r.fire && io.out.r.bits.last) { rBusy := false.B }
  }
}
