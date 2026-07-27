package bus.demo

import bus.amba.axi.common._
import chisel3._
import chisel3.util._

/**
  * Simple AXI4 RAM slave.
  *
  * - One outstanding write transaction and one outstanding read transaction.
  * - Supports FIXED/INCR bursts.
  * - Uses byte strobes on writes.
  * - Returns SLVERR on unsupported transfer size or out-of-range access.
  */
class Axi4Ram(p: AxiParams, depthWords: Int = 1024) extends Module {
  require(depthWords > 1, "depthWords must be greater than 1")
  require((p.dataBits % 8) == 0, "AXI dataBits must be byte aligned")

  val io = IO(new Bundle {
    val axi = new AXI4SlaveBundle(p)
  })

  def this(depthWords: Int)(implicit params: AxiParameters) =
    this(AxiParams.fromPortParameters, depthWords)

  private val dataBytes = p.dataBits / 8
  private val wordShift = log2Ceil(dataBytes)
  private val depthBits = log2Ceil(depthWords)
  private val sizeMatch = log2Ceil(dataBytes).U(3.W)

  private val mem = Mem(depthWords, UInt(p.dataBits.W))

  private def inRange(addr: UInt): Bool = {
    val idx = (addr >> wordShift)(depthBits - 1, 0)
    idx < depthWords.U
  }

  private def mergeBytes(oldData: UInt, newData: UInt, strb: UInt): UInt = {
    val lanes = (0 until p.strobeBits).map { i =>
      val lo = i * 8
      Mux(strb(i), newData(lo + 7, lo), oldData(lo + 7, lo))
    }
    Cat(lanes.reverse)
  }

  // -------------------------
  // Write path (AW/W/B)
  // -------------------------
  val wIdle :: wData :: wResp :: Nil = Enum(3)
  val wState = RegInit(wIdle)

  val wId      = Reg(UInt(p.idBits.W))
  val wAddr    = Reg(UInt(p.addrBits.W))
  val wBurst   = Reg(UInt(2.W))
  val wSize    = Reg(UInt(3.W))
  val wBeats   = Reg(UInt(9.W)) // len + 1, up to 256
  val wRespReg = RegInit(AxiResp.OKAY)

  io.axi.aw.ready := (wState === wIdle)
  io.axi.w.ready  := (wState === wData)

  io.axi.b.valid     := (wState === wResp)
  io.axi.b.bits.id   := wId
  io.axi.b.bits.resp := wRespReg
  io.axi.b.bits.user := 0.U

  when(wState === wIdle && io.axi.aw.fire) {
    wId      := io.axi.aw.bits.id
    wAddr    := io.axi.aw.bits.addr
    wBurst   := io.axi.aw.bits.burst
    wSize    := io.axi.aw.bits.size
    wBeats   := io.axi.aw.bits.len + 1.U
    wRespReg := AxiResp.OKAY
    wState   := wData
  }

  when(wState === wData && io.axi.w.fire) {
    val addrOk  = inRange(wAddr)
    val sizeOk  = (wSize === sizeMatch)
    val burstOk = (wBurst === AxiBurst.INCR) || (wBurst === AxiBurst.FIXED)

    when(addrOk && sizeOk && burstOk) {
      val idx     = (wAddr >> wordShift)(depthBits - 1, 0)
      val oldData = mem.read(idx)
      mem.write(idx, mergeBytes(oldData, io.axi.w.bits.data, io.axi.w.bits.strb))
    }.otherwise {
      wRespReg := AxiResp.SLVERR
    }

    val lastBeatByCount = (wBeats === 1.U)
    val txnDone         = io.axi.w.bits.last || lastBeatByCount

    when(txnDone) {
      wState := wResp
    }.otherwise {
      wBeats := wBeats - 1.U
      when(wBurst === AxiBurst.INCR) {
        wAddr := wAddr + dataBytes.U
      }
    }
  }

  when(wState === wResp && io.axi.b.fire) {
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
object Axi4Ram extends App {
  val p = AxiParams(addrBits = 32, dataBits = 32, idBits = 4)
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      // make yosys happy
      // see https://github.com/llvm/circt/blob/main/docs/VerilogGeneration.md
      "disallowLocalVariables",
      "disallowPackedArrays",
      "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _)
  )
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(new Axi4Ram(p, depthWords = 1024), args, firtoolOptions)
}

/** Minimal usage example: write one word then read back. */
class Axi4RamExample extends Module {
  private val masterPort = AXI4MasterPortParameters(
    masters = Seq(AXI4MasterParameters(name = "axi4ram-example-master", id = IdRange(0, 4)))
  )
  private val slavePort = AXI4SlavePortParameters(
    slaves = Seq(
      AXI4SlaveParameters(
        address = Seq(AddressSet(base = 0, mask = 0xffff)),
        supportsWrite = TransferSizes(1, 4),
        supportsRead = TransferSizes(1, 4)
      )
    ),
    beatBytes = 4
  )

  private implicit val params: AxiParameters =
    new WithAxiPorts(masterPort, slavePort) ++ new BaseAxiConfig

  private val p: AxiParams = AxiParams.fromPortParameters
  private val ramDepthWords: Int =
    ((slavePort.maxAddress + 1) / slavePort.beatBytes).toInt

  val io = IO(new Bundle {
    val done     = Output(Bool())
    val readData = Output(UInt(p.dataBits.W))
    val readResp = Output(UInt(2.W))
  })

  val host = Module(new bus.amba.axi.host.Axi4SingleBeatMasterHost(p))
  val ram  = Module(new Axi4Ram(p, depthWords = ramDepthWords))

  ram.io.axi <> host.io.axi

  val sWriteCmd :: sWaitWriteRsp :: sReadCmd :: sWaitReadRsp :: sDone :: Nil = Enum(5)
  val state = RegInit(sWriteCmd)

  host.io.cmd.valid := false.B
  host.io.cmd.bits  := 0.U.asTypeOf(host.io.cmd.bits)
  host.io.rsp.ready := false.B

  val readDataReg = RegInit(0.U(p.dataBits.W))
  val readRespReg = RegInit(AxiResp.OKAY)

  switch(state) {
    is(sWriteCmd) {
      host.io.cmd.valid      := true.B
      host.io.cmd.bits.write := true.B
      host.io.cmd.bits.addr  := 0.U
      host.io.cmd.bits.wdata := "h1234ABCD".U
      host.io.cmd.bits.strb  := Fill(p.strobeBits, 1.U(1.W))
      host.io.cmd.bits.prot  := 0.U
      when(host.io.cmd.fire) { state := sWaitWriteRsp }
    }
    is(sWaitWriteRsp) {
      host.io.rsp.ready := true.B
      when(host.io.rsp.fire) { state := sReadCmd }
    }
    is(sReadCmd) {
      host.io.cmd.valid      := true.B
      host.io.cmd.bits.write := false.B
      host.io.cmd.bits.addr  := 0.U
      host.io.cmd.bits.wdata := 0.U
      host.io.cmd.bits.strb  := 0.U
      host.io.cmd.bits.prot  := 0.U
      when(host.io.cmd.fire) { state := sWaitReadRsp }
    }
    is(sWaitReadRsp) {
      host.io.rsp.ready := true.B
      when(host.io.rsp.fire) {
        readDataReg := host.io.rsp.bits.rdata
        readRespReg := host.io.rsp.bits.resp
        state := sDone
      }
    }
    is(sDone) { host.io.rsp.ready := true.B }
  }

  io.done     := (state === sDone)
  io.readData := readDataReg
  io.readResp := readRespReg
}

object Axi4RamExample extends App {
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      "disallowLocalVariables",
      "disallowPackedArrays",
      "locationInfoStyle=wrapInAtSquareBracket"
    ).reduce(_ + "," + _)
  )
  _root_.circt.stage.ChiselStage.emitSystemVerilogFile(new Axi4RamExample, args, firtoolOptions)
}
