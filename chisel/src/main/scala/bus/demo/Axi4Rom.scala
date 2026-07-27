package bus.demo

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/**
  * AXI4 ROM slave with optional file initialization.
  *
  * - Read path: supports FIXED/INCR bursts.
  * - Write path: accepts transactions and always returns SLVERR.
  */
class Axi4Rom(p: AxiParams, depthWords: Int = 1024, initFile: String = "") extends Module {
  require(depthWords > 1, "depthWords must be greater than 1")
  require((p.dataBits % 8) == 0, "AXI dataBits must be byte aligned")

  val io = IO(new Bundle {
    val axi = new AXI4SlaveBundle(p)
  })

  def this(depthWords: Int, initFile: String)(implicit params: AxiParameters) =
    this(AxiParams.fromPortParameters, depthWords, initFile)

  private val dataBytes = p.dataBits / 8
  private val wordShift = log2Ceil(dataBytes)
  private val depthBits = log2Ceil(depthWords)
  private val sizeMatch = log2Ceil(dataBytes).U(3.W)

  import chisel3.util.experimental.loadMemoryFromFileInline
  private val mem = Mem(depthWords, UInt(p.dataBits.W))
  if (initFile.nonEmpty) {
    loadMemoryFromFileInline(mem, initFile)
  }

  private def inRange(addr: UInt): Bool = {
    val idx = (addr >> wordShift)(depthBits - 1, 0)
    idx < depthWords.U
  }

  // -------------------------
  // Write path: always SLVERR
  // -------------------------
  val wIdle :: wData :: wResp :: Nil = Enum(3)
  val wState = RegInit(wIdle)
  val wId    = Reg(UInt(p.idBits.W))
  val awSeen = RegInit(false.B)
  val wSeen  = RegInit(false.B)

  io.axi.aw.ready := (wState === wIdle) && !awSeen
  io.axi.w.ready  := (wState === wIdle || wState === wData) && !wSeen

  io.axi.b.valid     := (wState === wResp)
  io.axi.b.bits.id   := wId
  io.axi.b.bits.resp := AxiResp.SLVERR
  io.axi.b.bits.user := 0.U

  when((wState === wIdle || wState === wData) && io.axi.aw.fire) {
    wId    := io.axi.aw.bits.id
    awSeen := true.B
    when(wSeen) { wState := wResp }
      .otherwise { wState := wData }
  }

  when((wState === wIdle || wState === wData) && io.axi.w.fire) {
    wSeen := true.B
    when(awSeen && io.axi.w.bits.last) {
      wState := wResp
    }.otherwise {
      wState := wData
    }
  }

  when(wState === wResp && io.axi.b.fire) {
    awSeen := false.B
    wSeen  := false.B
    wState := wIdle
  }

  // -------------------------
  // Read path (AR/R)
  // -------------------------
  val rIdle :: rData :: Nil = Enum(2)
  val rState = RegInit(rIdle)

  val rId    = Reg(UInt(p.idBits.W))
  val rAddr  = Reg(UInt(p.addrBits.W))
  val rBurst = Reg(UInt(2.W))
  val rSize  = Reg(UInt(3.W))
  val rBeats = Reg(UInt(9.W))

  io.axi.ar.ready := (rState === rIdle)

  io.axi.r.valid     := (rState === rData)
  io.axi.r.bits.id   := rId
  io.axi.r.bits.data := 0.U
  io.axi.r.bits.resp := AxiResp.OKAY
  io.axi.r.bits.last := (rBeats === 1.U)
  io.axi.r.bits.user := 0.U

  when(rState === rIdle && io.axi.ar.fire) {
    rId    := io.axi.ar.bits.id
    rAddr  := io.axi.ar.bits.addr
    rBurst := io.axi.ar.bits.burst
    rSize  := io.axi.ar.bits.size
    rBeats := io.axi.ar.bits.len + 1.U
    rState := rData
  }

  when(rState === rData) {
    val addrOk  = inRange(rAddr)
    val sizeOk  = (rSize === sizeMatch)
    val burstOk = (rBurst === AxiBurst.INCR) || (rBurst === AxiBurst.FIXED)

    when(addrOk && sizeOk && burstOk) {
      val idx = (rAddr >> wordShift)(depthBits - 1, 0)
      io.axi.r.bits.data := mem.read(idx)
      io.axi.r.bits.resp := AxiResp.OKAY
    }.otherwise {
      io.axi.r.bits.data := 0.U
      io.axi.r.bits.resp := AxiResp.SLVERR
    }

    when(io.axi.r.fire) {
      when(rBeats === 1.U) {
        rState := rIdle
      }.otherwise {
        rBeats := rBeats - 1.U
        when(rBurst === AxiBurst.INCR) {
          rAddr := rAddr + dataBytes.U
        }
      }
    }
  }
}

/**
 * Generate SystemVerilog sources
 */
object Axi4Rom extends App {
  val p = AxiParams(addrBits = 32, dataBits = 32, idBits = 4)
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      "disallowLocalVariables",
      "disallowPackedArrays",
      "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _)
  )
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(
    new Axi4Rom(p = p, depthWords = 1024, initFile = "rom_init.hex"),
    args,
    firtoolOptions
  )
}

/** Minimal usage example: issue one read to ROM base address. */
class Axi4RomExample extends Module {
  private implicit val params: AxiParameters = new BaseAxiConfig
  private val p = AxiParams.fromPortParameters

  val io = IO(new Bundle {
    val done = Output(Bool())
    val data = Output(UInt(p.dataBits.W))
    val resp = Output(UInt(2.W))
  })

  val host = Module(new bus.amba.axi.host.Axi4SingleBeatMasterHost(p))
  val rom  = Module(new Axi4Rom(p, depthWords = 256, initFile = "rom_init.hex"))
  rom.io.axi <> host.io.axi

  val sReq :: sWait :: sDone :: Nil = Enum(3)
  val st = RegInit(sReq)
  val dataReg = RegInit(0.U(p.dataBits.W))
  val respReg = RegInit(AxiResp.OKAY)

  host.io.cmd.valid := false.B
  host.io.cmd.bits  := 0.U.asTypeOf(host.io.cmd.bits)
  host.io.rsp.ready := false.B

  switch(st) {
    is(sReq) {
      host.io.cmd.valid      := true.B
      host.io.cmd.bits.write := false.B
      host.io.cmd.bits.addr  := 0.U
      host.io.cmd.bits.wdata := 0.U
      host.io.cmd.bits.strb  := 0.U
      host.io.cmd.bits.prot  := 0.U
      when(host.io.cmd.fire) { st := sWait }
    }
    is(sWait) {
      host.io.rsp.ready := true.B
      when(host.io.rsp.fire) {
        dataReg := host.io.rsp.bits.rdata
        respReg := host.io.rsp.bits.resp
        st := sDone
      }
    }
  }

  io.done := (st === sDone)
  io.data := dataReg
  io.resp := respReg
}

object Axi4RomExample extends App {
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      "disallowLocalVariables",
      "disallowPackedArrays",
      "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _)
  )
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(new Axi4RomExample, args, firtoolOptions)
}
